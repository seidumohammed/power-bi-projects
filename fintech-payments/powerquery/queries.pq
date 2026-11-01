// =====================================================================================
// FINTECH PAYMENTS: Power Query (M) scripts
// Paste each query into Power BI: Home > Get data > Blank query > Advanced Editor.
// Name each query exactly as shown after "Query:".
// =====================================================================================

// ==== Query: DataFolder ====
// Create it through Home > Manage parameters > New parameter (Type: Text), not as a query.
// Set it to the folder that holds the raw CSV files. End it with a backslash.
"C:\path\to\power-bi-projects\fintech-payments\data\raw\" meta [IsParameterQuery = true, Type = "Text", IsParameterQueryRequired = true]

// ==== Query: dim_Region ====
let
    Source = Csv.Document(File.Contents(DataFolder & "regions.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"region", "Region"}}),
    Selected = Table.SelectColumns(Renamed, {"Region"}),
    Typed = Table.TransformColumnTypes(Selected, {{"Region", type text}}, "en-US")
in
    Typed

// ==== Query: dim_Customer ====
// Cleaning: segment has stray spaces and mixed case.
let
    Source = Csv.Document(File.Contents(DataFolder & "customers.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Cleansegment = Table.TransformColumns(Promoted, {{"segment", each Text.Proper(Text.Trim(_)), type text}}),
    Renamed = Table.RenameColumns(Cleansegment, {{"customer_id", "CustomerID"}, {"segment", "Segment"}, {"region", "Region"}, {"acquisition_channel", "AcquisitionChannel"}, {"joined_date", "JoinedDate"}}),
    Selected = Table.SelectColumns(Renamed, {"CustomerID", "Segment", "Region", "AcquisitionChannel", "JoinedDate"}),
    Typed = Table.TransformColumnTypes(Selected, {{"CustomerID", type text}, {"Segment", type text}, {"Region", type text}, {"AcquisitionChannel", type text}, {"JoinedDate", type date}}, "en-US")
in
    Typed

// ==== Query: dim_TxnType ====
let
    Source = Csv.Document(File.Contents(DataFolder & "txn_types.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"type_id", "TypeID"}, {"txn_type", "TxnType"}, {"txn_group", "TxnGroup"}}),
    Selected = Table.SelectColumns(Renamed, {"TypeID", "TxnType", "TxnGroup"}),
    Typed = Table.TransformColumnTypes(Selected, {{"TypeID", type text}, {"TxnType", type text}, {"TxnGroup", type text}}, "en-US")
in
    Typed

// ==== Query: dim_Channel ====
let
    Source = Csv.Document(File.Contents(DataFolder & "channels.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"channel_id", "ChannelID"}, {"channel", "Channel"}}),
    Selected = Table.SelectColumns(Renamed, {"ChannelID", "Channel"}),
    Typed = Table.TransformColumnTypes(Selected, {{"ChannelID", type text}, {"Channel", type text}}, "en-US")
in
    Typed

// ==== Query: fact_Transaction ====
// Cleaning: dates in two formats, amount stored as text ('GHS 1,250.00') in some rows, status in mixed case, duplicate txn_id rows. Status flags are calculated here.
let
    Source = Csv.Document(File.Contents(DataFolder & "transactions.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Deduped = Table.Distinct(Promoted, {"txn_id"}),
    WithTxnDate = Table.AddColumn(Deduped, "TxnDate", each if [txn_date] = null or Text.Trim([txn_date]) = "" then null else try Date.FromText([txn_date], [Format = "yyyy-MM-dd", Culture = "en-GB"]) otherwise Date.FromText([txn_date], [Format = "dd/MM/yyyy", Culture = "en-GB"]), type date),
    WithAmountGHS = Table.AddColumn(WithTxnDate, "AmountGHS", each if [amount_ghs] = null or Text.Trim([amount_ghs]) = "" then null else Number.FromText(Text.Trim(Text.Replace(Text.Replace(Text.Replace([amount_ghs], "GHS", ""), ",", ""), " ", "")), "en-US"), type number),
    Cleanstatus = Table.TransformColumns(WithAmountGHS, {{"status", each Text.Proper(Text.Trim(_)), type text}}),
    Renamed = Table.RenameColumns(Cleanstatus, {{"txn_id", "TxnID"}, {"customer_id", "CustomerID"}, {"type_id", "TypeID"}, {"channel_id", "ChannelID"}, {"fee_ghs", "FeeGHS"}, {"status", "Status"}, {"failure_reason", "FailureReason"}, {"is_fraud", "IsFraud"}}),
    Selected = Table.SelectColumns(Renamed, {"TxnID", "TxnDate", "CustomerID", "TypeID", "ChannelID", "AmountGHS", "FeeGHS", "Status", "FailureReason", "IsFraud"}),
    Typed = Table.TransformColumnTypes(Selected, {{"TxnID", type text}, {"CustomerID", type text}, {"TypeID", type text}, {"ChannelID", type text}, {"FeeGHS", type number}, {"Status", type text}, {"FailureReason", type text}, {"IsFraud", Int64.Type}}, "en-US"),
    AddIsSuccess = Table.AddColumn(Typed, "IsSuccess", each if [Status] = "Success" then 1 else 0, Int64.Type),
    AddIsFailed = Table.AddColumn(AddIsSuccess, "IsFailed", each if [Status] = "Failed" then 1 else 0, Int64.Type),
    AddIsReversed = Table.AddColumn(AddIsFailed, "IsReversed", each if [Status] = "Reversed" then 1 else 0, Int64.Type),
    AddSuccessValueGHS = Table.AddColumn(AddIsReversed, "SuccessValueGHS", each [AmountGHS] * [IsSuccess], type number),
    AddFraudValueGHS = Table.AddColumn(AddSuccessValueGHS, "FraudValueGHS", each [AmountGHS] * [IsFraud], type number)
in
    AddFraudValueGHS

// ==== Query: fact_Loan ====
// Cleaning: date in two formats, amount stored as text, status in mixed case, duplicate loan_id rows. Outstanding balance and risk flags are calculated here.
let
    Source = Csv.Document(File.Contents(DataFolder & "loans.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Deduped = Table.Distinct(Promoted, {"loan_id"}),
    WithDisbursedDate = Table.AddColumn(Deduped, "DisbursedDate", each if [disbursed_date] = null or Text.Trim([disbursed_date]) = "" then null else try Date.FromText([disbursed_date], [Format = "yyyy-MM-dd", Culture = "en-GB"]) otherwise Date.FromText([disbursed_date], [Format = "dd/MM/yyyy", Culture = "en-GB"]), type date),
    WithAmountGHS = Table.AddColumn(WithDisbursedDate, "AmountGHS", each if [amount_ghs] = null or Text.Trim([amount_ghs]) = "" then null else Number.FromText(Text.Trim(Text.Replace(Text.Replace(Text.Replace([amount_ghs], "GHS", ""), ",", ""), " ", "")), "en-US"), type number),
    Cleanstatus = Table.TransformColumns(WithAmountGHS, {{"status", each Text.Proper(Text.Trim(_)), type text}}),
    Renamed = Table.RenameColumns(Cleanstatus, {{"loan_id", "LoanID"}, {"customer_id", "CustomerID"}, {"term_days", "TermDays"}, {"status", "Status"}, {"days_past_due", "DaysPastDue"}, {"repaid_ghs", "RepaidGHS"}}),
    Selected = Table.SelectColumns(Renamed, {"LoanID", "CustomerID", "DisbursedDate", "AmountGHS", "TermDays", "Status", "DaysPastDue", "RepaidGHS"}),
    Typed = Table.TransformColumnTypes(Selected, {{"LoanID", type text}, {"CustomerID", type text}, {"TermDays", Int64.Type}, {"Status", type text}, {"DaysPastDue", Int64.Type}, {"RepaidGHS", type number}}, "en-US"),
    AddOutstandingGHS = Table.AddColumn(Typed, "OutstandingGHS", each if [Status] = "Repaid" then 0 else [AmountGHS] - [RepaidGHS], type number),
    AddIsDefault = Table.AddColumn(AddOutstandingGHS, "IsDefault", each if [Status] = "Default" then 1 else 0, Int64.Type),
    AddPAR30BalanceGHS = Table.AddColumn(AddIsDefault, "PAR30BalanceGHS", each if [DaysPastDue] > 30 then [OutstandingGHS] else 0, type number)
in
    AddPAR30BalanceGHS

// ==== Query: fact_Target ====
let
    Source = Csv.Document(File.Contents(DataFolder & "targets.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"month", "MonthStart"}, {"region", "Region"}, {"txn_value_target_ghs", "TxnValueTargetGHS"}}),
    Selected = Table.SelectColumns(Renamed, {"MonthStart", "Region", "TxnValueTargetGHS"}),
    Typed = Table.TransformColumnTypes(Selected, {{"MonthStart", type date}, {"Region", type text}, {"TxnValueTargetGHS", type number}}, "en-US")
in
    Typed

// ==== Query: dim_Date ====
// Generated calendar covering the data. Mark it as the date table in Power BI (Table tools > Mark as date table > Date).
let
    StartDate = #date(2024, 1, 1),
    EndDate = #date(2025, 12, 31),
    Days = List.Dates(StartDate, Duration.Days(EndDate - StartDate) + 1, #duration(1, 0, 0, 0)),
    AsTable = Table.FromList(Days, Splitter.SplitByNothing(), {"Date"}, null, ExtraValues.Error),
    Typed = Table.TransformColumnTypes(AsTable, {{"Date", type date}}),
    Year = Table.AddColumn(Typed, "Year", each Date.Year([Date]), Int64.Type),
    Quarter = Table.AddColumn(Year, "Quarter", each "Q" & Text.From(Date.QuarterOfYear([Date])), type text),
    MonthNumber = Table.AddColumn(Quarter, "MonthNumber", each Date.Month([Date]), Int64.Type),
    MonthName = Table.AddColumn(MonthNumber, "MonthName", each Date.ToText([Date], "MMM", "en-GB"), type text),
    MonthStart = Table.AddColumn(MonthName, "MonthStart", each Date.StartOfMonth([Date]), type date),
    YearMonth = Table.AddColumn(MonthStart, "YearMonth", each Date.ToText([Date], "yyyy-MM", "en-GB"), type text),
    DayNumber = Table.AddColumn(YearMonth, "DayNumber", each Date.DayOfWeek([Date], Day.Monday) + 1, Int64.Type),
    DayName = Table.AddColumn(DayNumber, "DayName", each Date.ToText([Date], "ddd", "en-GB"), type text),
    IsWeekend = Table.AddColumn(DayName, "IsWeekend", each Date.DayOfWeek([Date], Day.Monday) >= 5, type logical)
in
    IsWeekend
