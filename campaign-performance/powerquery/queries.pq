// =====================================================================================
// CAMPAIGN PERFORMANCE: Power Query (M) scripts
// Paste each query into Power BI: Home > Get data > Blank query > Advanced Editor.
// Name each query exactly as shown after "Query:".
// =====================================================================================

// ==== Query: DataFolder ====
// Create it through Home > Manage parameters > New parameter (Type: Text), not as a query.
// Set it to the folder that holds the raw CSV files. End it with a backslash.
"C:\path\to\power-bi-projects\campaign-performance\data\raw\" meta [IsParameterQuery = true, Type = "Text", IsParameterQueryRequired = true]

// ==== Query: dim_Channel ====
let
    Source = Csv.Document(File.Contents(DataFolder & "channels.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"channel_id", "ChannelID"}, {"channel", "Channel"}, {"channel_type", "ChannelType"}}),
    Selected = Table.SelectColumns(Renamed, {"ChannelID", "Channel", "ChannelType"}),
    Typed = Table.TransformColumnTypes(Selected, {{"ChannelID", type text}, {"Channel", type text}, {"ChannelType", type text}}, "en-US")
in
    Typed

// ==== Query: dim_Campaign ====
// Cleaning: objective in mixed case, campaign names with stray spaces.
let
    Source = Csv.Document(File.Contents(DataFolder & "campaigns.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Cleanobjective = Table.TransformColumns(Promoted, {{"objective", each Text.Proper(Text.Trim(_)), type text}}),
    Cleancampaign = Table.TransformColumns(Cleanobjective, {{"campaign", each Text.Trim(_), type text}}),
    Renamed = Table.RenameColumns(Cleancampaign, {{"campaign_id", "CampaignID"}, {"campaign", "Campaign"}, {"objective", "Objective"}, {"channel_id", "ChannelID"}, {"category", "Category"}}),
    Selected = Table.SelectColumns(Renamed, {"CampaignID", "Campaign", "Objective", "ChannelID", "Category"}),
    Typed = Table.TransformColumnTypes(Selected, {{"CampaignID", type text}, {"Campaign", type text}, {"Objective", type text}, {"ChannelID", type text}, {"Category", type text}}, "en-US")
in
    Typed

// ==== Query: fact_Ads ====
// Cleaning: dates in two formats, spend and revenue stored as text ('GHS 1,250.00') in some rows, duplicate ad_id rows.
let
    Source = Csv.Document(File.Contents(DataFolder & "ad_results.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Deduped = Table.Distinct(Promoted, {"ad_id"}),
    WithAdDate = Table.AddColumn(Deduped, "AdDate", each if [ad_date] = null or Text.Trim([ad_date]) = "" then null else try Date.FromText([ad_date], [Format = "yyyy-MM-dd", Culture = "en-GB"]) otherwise Date.FromText([ad_date], [Format = "dd/MM/yyyy", Culture = "en-GB"]), type date),
    WithSpendGHS = Table.AddColumn(WithAdDate, "SpendGHS", each if [spend_ghs] = null or Text.Trim([spend_ghs]) = "" then null else Number.FromText(Text.Trim(Text.Replace(Text.Replace(Text.Replace([spend_ghs], "GHS", ""), ",", ""), " ", "")), "en-US"), type number),
    WithRevenueGHS = Table.AddColumn(WithSpendGHS, "RevenueGHS", each if [revenue_ghs] = null or Text.Trim([revenue_ghs]) = "" then null else Number.FromText(Text.Trim(Text.Replace(Text.Replace(Text.Replace([revenue_ghs], "GHS", ""), ",", ""), " ", "")), "en-US"), type number),
    Renamed = Table.RenameColumns(WithRevenueGHS, {{"ad_id", "AdID"}, {"campaign_id", "CampaignID"}, {"impressions", "Impressions"}, {"clicks", "Clicks"}, {"conversions", "Conversions"}}),
    Selected = Table.SelectColumns(Renamed, {"AdID", "AdDate", "CampaignID", "Impressions", "Clicks", "SpendGHS", "Conversions", "RevenueGHS"}),
    Typed = Table.TransformColumnTypes(Selected, {{"AdID", type text}, {"CampaignID", type text}, {"Impressions", Int64.Type}, {"Clicks", Int64.Type}, {"Conversions", Int64.Type}}, "en-US")
in
    Typed

// ==== Query: fact_Budget ====
let
    Source = Csv.Document(File.Contents(DataFolder & "budgets.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"month", "MonthStart"}, {"channel", "Channel"}, {"budget_ghs", "BudgetGHS"}}),
    Selected = Table.SelectColumns(Renamed, {"MonthStart", "Channel", "BudgetGHS"}),
    Typed = Table.TransformColumnTypes(Selected, {{"MonthStart", type date}, {"Channel", type text}, {"BudgetGHS", type number}}, "en-US")
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
