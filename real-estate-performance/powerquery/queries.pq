// =====================================================================================
// REAL ESTATE PERFORMANCE: Power Query (M) scripts
// Paste each query into Power BI: Home > Get data > Blank query > Advanced Editor.
// Name each query exactly as shown after "Query:".
// =====================================================================================

// ==== Query: DataFolder ====
// Create it through Home > Manage parameters > New parameter (Type: Text), not as a query.
// Set it to the folder that holds the raw CSV files. End it with a backslash.
"C:\path\to\power-bi-projects\real-estate-performance\data\raw\" meta [IsParameterQuery = true, Type = "Text", IsParameterQueryRequired = true]

// ==== Query: dim_Branch ====
let
    Source = Csv.Document(File.Contents(DataFolder & "branches.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"branch_id", "BranchID"}, {"branch", "Branch"}, {"city", "City"}}),
    Selected = Table.SelectColumns(Renamed, {"BranchID", "Branch", "City"}),
    Typed = Table.TransformColumnTypes(Selected, {{"BranchID", type text}, {"Branch", type text}, {"City", type text}}, "en-US")
in
    Typed

// ==== Query: dim_Area ====
let
    Source = Csv.Document(File.Contents(DataFolder & "areas.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"area_id", "AreaID"}, {"area", "Area"}, {"zone", "Zone"}}),
    Selected = Table.SelectColumns(Renamed, {"AreaID", "Area", "Zone"}),
    Typed = Table.TransformColumnTypes(Selected, {{"AreaID", type text}, {"Area", type text}, {"Zone", type text}}, "en-US")
in
    Typed

// ==== Query: dim_Agent ====
let
    Source = Csv.Document(File.Contents(DataFolder & "agents.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"agent_id", "AgentID"}, {"agent_name", "AgentName"}, {"branch_id", "BranchID"}, {"joined_date", "JoinedDate"}}),
    Selected = Table.SelectColumns(Renamed, {"AgentID", "AgentName", "BranchID", "JoinedDate"}),
    Typed = Table.TransformColumnTypes(Selected, {{"AgentID", type text}, {"AgentName", type text}, {"BranchID", type text}, {"JoinedDate", type date}}, "en-US")
in
    Typed

// ==== Query: dim_Property ====
// Cleaning: property_type has stray spaces and mixed case.
let
    Source = Csv.Document(File.Contents(DataFolder & "properties.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Cleanpropertytype = Table.TransformColumns(Promoted, {{"property_type", each Text.Proper(Text.Trim(_)), type text}}),
    Renamed = Table.RenameColumns(Cleanpropertytype, {{"property_id", "PropertyID"}, {"area_id", "AreaID"}, {"property_type", "PropertyType"}, {"bedrooms", "Bedrooms"}, {"floor_area_sqm", "FloorAreaSqm"}}),
    Selected = Table.SelectColumns(Renamed, {"PropertyID", "AreaID", "PropertyType", "Bedrooms", "FloorAreaSqm"}),
    Typed = Table.TransformColumnTypes(Selected, {{"PropertyID", type text}, {"AreaID", type text}, {"PropertyType", type text}, {"Bedrooms", Int64.Type}, {"FloorAreaSqm", type number}}, "en-US")
in
    Typed

// ==== Query: fact_Listing ====
// Cleaning: list_date in two formats, status in mixed case, duplicate listing_id rows.
let
    Source = Csv.Document(File.Contents(DataFolder & "listings.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Deduped = Table.Distinct(Promoted, {"listing_id"}),
    WithListDate = Table.AddColumn(Deduped, "ListDate", each if [list_date] = null or Text.Trim([list_date]) = "" then null else try Date.FromText([list_date], [Format = "yyyy-MM-dd", Culture = "en-GB"]) otherwise Date.FromText([list_date], [Format = "dd/MM/yyyy", Culture = "en-GB"]), type date),
    Cleanstatus = Table.TransformColumns(WithListDate, {{"status", each Text.Proper(Text.Trim(_)), type text}}),
    Renamed = Table.RenameColumns(Cleanstatus, {{"listing_id", "ListingID"}, {"property_id", "PropertyID"}, {"agent_id", "AgentID"}, {"list_price_ghs", "ListPriceGHS"}, {"status", "Status"}}),
    Selected = Table.SelectColumns(Renamed, {"ListingID", "PropertyID", "AgentID", "ListDate", "ListPriceGHS", "Status"}),
    Typed = Table.TransformColumnTypes(Selected, {{"ListingID", type text}, {"PropertyID", type text}, {"AgentID", type text}, {"ListPriceGHS", type number}, {"Status", type text}}, "en-US")
in
    Typed

// ==== Query: fact_Sale ====
// Cleaning: dates in two formats, sale price stored as text ('GHS 1,250,000.00') in some rows, duplicate sale_id rows.
let
    Source = Csv.Document(File.Contents(DataFolder & "sales.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Deduped = Table.Distinct(Promoted, {"sale_id"}),
    WithListDate = Table.AddColumn(Deduped, "ListDate", each if [list_date] = null or Text.Trim([list_date]) = "" then null else try Date.FromText([list_date], [Format = "yyyy-MM-dd", Culture = "en-GB"]) otherwise Date.FromText([list_date], [Format = "dd/MM/yyyy", Culture = "en-GB"]), type date),
    WithSaleDate = Table.AddColumn(WithListDate, "SaleDate", each if [sale_date] = null or Text.Trim([sale_date]) = "" then null else try Date.FromText([sale_date], [Format = "yyyy-MM-dd", Culture = "en-GB"]) otherwise Date.FromText([sale_date], [Format = "dd/MM/yyyy", Culture = "en-GB"]), type date),
    WithSalePriceGHS = Table.AddColumn(WithSaleDate, "SalePriceGHS", each if [sale_price_ghs] = null or Text.Trim([sale_price_ghs]) = "" then null else Number.FromText(Text.Trim(Text.Replace(Text.Replace(Text.Replace([sale_price_ghs], "GHS", ""), ",", ""), " ", "")), "en-US"), type number),
    Renamed = Table.RenameColumns(WithSalePriceGHS, {{"sale_id", "SaleID"}, {"listing_id", "ListingID"}, {"property_id", "PropertyID"}, {"agent_id", "AgentID"}, {"list_price_ghs", "ListPriceGHS"}}),
    Selected = Table.SelectColumns(Renamed, {"SaleID", "ListingID", "PropertyID", "AgentID", "ListDate", "SaleDate", "ListPriceGHS", "SalePriceGHS"}),
    Typed = Table.TransformColumnTypes(Selected, {{"SaleID", type text}, {"ListingID", type text}, {"PropertyID", type text}, {"AgentID", type text}, {"ListPriceGHS", type number}}, "en-US"),
    AddDaysOnMarket = Table.AddColumn(Typed, "DaysOnMarket", each Duration.Days([SaleDate] - [ListDate]), Int64.Type),
    AddCommissionGHS = Table.AddColumn(AddDaysOnMarket, "CommissionGHS", each [SalePriceGHS] * 0.03, type number)
in
    AddCommissionGHS

// ==== Query: fact_Target ====
let
    Source = Csv.Document(File.Contents(DataFolder & "targets.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"month", "MonthStart"}, {"branch", "Branch"}, {"sales_target_ghs", "SalesTargetGHS"}}),
    Selected = Table.SelectColumns(Renamed, {"MonthStart", "Branch", "SalesTargetGHS"}),
    Typed = Table.TransformColumnTypes(Selected, {{"MonthStart", type date}, {"Branch", type text}, {"SalesTargetGHS", type number}}, "en-US")
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
