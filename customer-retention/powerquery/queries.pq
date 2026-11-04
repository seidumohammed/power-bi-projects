// =====================================================================================
// CUSTOMER ACQUISITION AND RETENTION: Power Query (M) scripts
// Paste each query into Power BI: Home > Get data > Blank query > Advanced Editor.
// Name each query exactly as shown after "Query:".
// =====================================================================================

// ==== Query: DataFolder ====
// Create it through Home > Manage parameters > New parameter (Type: Text), not as a query.
// Set it to the folder that holds the raw CSV files. End it with a backslash.
"C:\path\to\power-bi-projects\customer-retention\data\raw\" meta [IsParameterQuery = true, Type = "Text", IsParameterQueryRequired = true]

// ==== Query: dim_Channel ====
let
    Source = Csv.Document(File.Contents(DataFolder & "channels.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"channel_id", "ChannelID"}, {"acquisition_channel", "AcquisitionChannel"}}),
    Selected = Table.SelectColumns(Renamed, {"ChannelID", "AcquisitionChannel"}),
    Typed = Table.TransformColumnTypes(Selected, {{"ChannelID", type text}, {"AcquisitionChannel", type text}}, "en-US")
in
    Typed

// ==== Query: dim_Customer ====
// Cleaning: dates in two formats, blank churn date means still active, segment in mixed case, region with stray spaces, duplicate customer_id rows.
let
    Source = Csv.Document(File.Contents(DataFolder & "customers.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Deduped = Table.Distinct(Promoted, {"customer_id"}),
    WithSignupDate = Table.AddColumn(Deduped, "SignupDate", each if [signup_date] = null or Text.Trim([signup_date]) = "" then null else try Date.FromText([signup_date], [Format = "yyyy-MM-dd", Culture = "en-GB"]) otherwise Date.FromText([signup_date], [Format = "dd/MM/yyyy", Culture = "en-GB"]), type date),
    WithChurnDate = Table.AddColumn(WithSignupDate, "ChurnDate", each if [churn_date] = null or Text.Trim([churn_date]) = "" then null else try Date.FromText([churn_date], [Format = "yyyy-MM-dd", Culture = "en-GB"]) otherwise Date.FromText([churn_date], [Format = "dd/MM/yyyy", Culture = "en-GB"]), type date),
    Cleansegment = Table.TransformColumns(WithChurnDate, {{"segment", each Text.Proper(Text.Trim(_)), type text}}),
    Cleanregion = Table.TransformColumns(Cleansegment, {{"region", each Text.Trim(_), type text}}),
    Renamed = Table.RenameColumns(Cleanregion, {{"customer_id", "CustomerID"}, {"segment", "Segment"}, {"region", "Region"}, {"channel_id", "ChannelID"}}),
    Selected = Table.SelectColumns(Renamed, {"CustomerID", "Segment", "Region", "ChannelID", "SignupDate", "ChurnDate"}),
    Typed = Table.TransformColumnTypes(Selected, {{"CustomerID", type text}, {"Segment", type text}, {"Region", type text}, {"ChannelID", type text}}, "en-US")
in
    Typed

// ==== Query: fact_Order ====
// Cleaning: dates in two formats, order value stored as text ('GHS 85.50') in some rows, duplicate order_id rows.
let
    Source = Csv.Document(File.Contents(DataFolder & "orders.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Deduped = Table.Distinct(Promoted, {"order_id"}),
    WithOrderDate = Table.AddColumn(Deduped, "OrderDate", each if [order_date] = null or Text.Trim([order_date]) = "" then null else try Date.FromText([order_date], [Format = "yyyy-MM-dd", Culture = "en-GB"]) otherwise Date.FromText([order_date], [Format = "dd/MM/yyyy", Culture = "en-GB"]), type date),
    WithOrderValueGHS = Table.AddColumn(WithOrderDate, "OrderValueGHS", each if [order_value_ghs] = null or Text.Trim([order_value_ghs]) = "" then null else Number.FromText(Text.Trim(Text.Replace(Text.Replace(Text.Replace([order_value_ghs], "GHS", ""), ",", ""), " ", "")), "en-US"), type number),
    Renamed = Table.RenameColumns(WithOrderValueGHS, {{"order_id", "OrderID"}, {"customer_id", "CustomerID"}, {"items", "Items"}}),
    Selected = Table.SelectColumns(Renamed, {"OrderID", "OrderDate", "CustomerID", "OrderValueGHS", "Items"}),
    Typed = Table.TransformColumnTypes(Selected, {{"OrderID", type text}, {"CustomerID", type text}, {"Items", Int64.Type}}, "en-US")
in
    Typed

// ==== Query: fact_Funnel ====
let
    Source = Csv.Document(File.Contents(DataFolder & "funnel.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"month", "Month"}, {"channel_id", "ChannelID"}, {"visits", "Visits"}, {"signups", "Signups"}, {"first_orders", "FirstOrders"}}),
    Selected = Table.SelectColumns(Renamed, {"Month", "ChannelID", "Visits", "Signups", "FirstOrders"}),
    Typed = Table.TransformColumnTypes(Selected, {{"Month", type date}, {"ChannelID", type text}, {"Visits", Int64.Type}, {"Signups", Int64.Type}, {"FirstOrders", Int64.Type}}, "en-US")
in
    Typed

// ==== Query: fact_Spend ====
let
    Source = Csv.Document(File.Contents(DataFolder & "spend.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"month", "Month"}, {"channel_id", "ChannelID"}, {"spend_ghs", "SpendGHS"}}),
    Selected = Table.SelectColumns(Renamed, {"Month", "ChannelID", "SpendGHS"}),
    Typed = Table.TransformColumnTypes(Selected, {{"Month", type date}, {"ChannelID", type text}, {"SpendGHS", type number}}, "en-US")
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
