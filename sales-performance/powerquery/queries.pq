// =====================================================================================
// SALES PERFORMANCE: Power Query (M) scripts
// Paste each query into Power BI: Home > Get data > Blank query > Advanced Editor.
// Name each query exactly as shown after "Query:".
// =====================================================================================

// ==== Query: DataFolder ====
// Create it through Home > Manage parameters > New parameter (Type: Text), not as a query.
// Current value: the folder that holds the raw CSV files. End it with a backslash.
"C:\path\to\power-bi-projects\sales-performance\data\raw\" meta [IsParameterQuery = true, Type = "Text", IsParameterQueryRequired = true]

// ==== Query: dim_Store ====
let
    Source = Csv.Document(File.Contents(DataFolder & "stores.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"store_id", "StoreID"}, {"store_name", "Store"}, {"region", "Region"}, {"opened", "OpenedDate"}}),
    Typed = Table.TransformColumnTypes(Renamed, {{"StoreID", type text}, {"Store", type text}, {"Region", type text}, {"OpenedDate", type date}}, "en-GB")
in
    Typed

// ==== Query: dim_Product ====
// Adds a unit margin column so learners can see a calculated column next to the DAX measures.
let
    Source = Csv.Document(File.Contents(DataFolder & "products.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"product_id", "ProductID"}, {"product_name", "ProductName"}, {"category", "Category"}, {"subcategory", "Subcategory"},
        {"list_price_ghs", "ListPriceGHS"}, {"unit_cost_ghs", "UnitCostGHS"}}),
    Typed = Table.TransformColumnTypes(Renamed, {{"ProductID", type text}, {"ProductName", type text}, {"Category", type text}, {"Subcategory", type text},
        {"ListPriceGHS", type number}, {"UnitCostGHS", type number}}, "en-US"),
    WithMargin = Table.AddColumn(Typed, "UnitMarginGHS", each [ListPriceGHS] - [UnitCostGHS], type number)
in
    WithMargin

// ==== Query: dim_Customer ====
// Cleaning: segment arrives in mixed case with stray spaces ("  retail ", "WHOLESALE").
let
    Source = Csv.Document(File.Contents(DataFolder & "customers.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"customer_id", "CustomerID"}, {"segment", "Segment"}, {"home_store", "HomeStoreID"}, {"joined", "JoinedDate"}}),
    CleanSegment = Table.TransformColumns(Renamed, {{"Segment", each Text.Proper(Text.Trim(_)), type text}}),
    Typed = Table.TransformColumnTypes(CleanSegment, {{"CustomerID", type text}, {"HomeStoreID", type text}, {"JoinedDate", type date}}, "en-GB")
in
    Typed

// ==== Query: fact_Sales ====
// Cleaning steps (each one fixes a problem injected into sales.csv):
//   1. order_date is mostly yyyy-MM-dd but about 3% is dd/MM/yyyy: try one format, fall back to the other.
//   2. product_id has stray spaces and lower case in about 4% of rows: trim and upper-case so it matches dim_Product.
//   3. discount is a decimal (0.05) but about 5% arrive as text ("5%"): convert both to a decimal.
//   4. about 1% of rows are exact duplicates of a line_id: keep one.
// Line amounts are calculated here so the DAX measures can simply sum them.
let
    Source = Csv.Document(File.Contents(DataFolder & "sales.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Deduped = Table.Distinct(Promoted, {"line_id"}),
    WithDate = Table.AddColumn(Deduped, "OrderDate",
        each try Date.FromText([order_date], [Format = "yyyy-MM-dd", Culture = "en-GB"])
             otherwise Date.FromText([order_date], [Format = "dd/MM/yyyy", Culture = "en-GB"]), type date),
    CleanProduct = Table.TransformColumns(WithDate, {{"product_id", each Text.Upper(Text.Trim(_)), type text}}),
    WithDiscount = Table.AddColumn(CleanProduct, "DiscountPct",
        each if Text.EndsWith(Text.Trim([discount]), "%")
             then Number.FromText(Text.Replace(Text.Trim([discount]), "%", ""), "en-US") / 100
             else Number.FromText(Text.Trim([discount]), "en-US"), type number),
    Renamed = Table.RenameColumns(WithDiscount, {{"line_id", "LineID"}, {"order_id", "OrderID"}, {"store_id", "StoreID"}, {"customer_id", "CustomerID"},
        {"product_id", "ProductID"}, {"channel", "Channel"}, {"quantity", "Quantity"}, {"unit_price_ghs", "UnitPriceGHS"}, {"unit_cost_ghs", "UnitCostGHS"}}),
    Selected = Table.SelectColumns(Renamed, {"LineID", "OrderID", "OrderDate", "StoreID", "CustomerID", "ProductID", "Channel", "Quantity", "UnitPriceGHS", "DiscountPct", "UnitCostGHS"}),
    Typed = Table.TransformColumnTypes(Selected, {{"LineID", type text}, {"OrderID", type text}, {"StoreID", type text}, {"CustomerID", type text}, {"ProductID", type text},
        {"Channel", type text}, {"Quantity", Int64.Type}, {"UnitPriceGHS", type number}, {"UnitCostGHS", type number}}, "en-US"),
    Gross = Table.AddColumn(Typed, "GrossSales", each [Quantity] * [UnitPriceGHS], type number),
    DiscountAmt = Table.AddColumn(Gross, "DiscountAmount", each [GrossSales] * [DiscountPct], type number),
    Net = Table.AddColumn(DiscountAmt, "NetSales", each [GrossSales] - [DiscountAmount], type number),
    Cost = Table.AddColumn(Net, "TotalCost", each [Quantity] * [UnitCostGHS], type number)
in
    Cost

// ==== Query: fact_Target ====
// Monthly sales targets by store. MonthStart is the first day of the month, used to match dim_Date[MonthStart].
let
    Source = Csv.Document(File.Contents(DataFolder & "targets.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"month", "MonthStart"}, {"store_id", "StoreID"}, {"sales_target_ghs", "SalesTargetGHS"}}),
    Typed = Table.TransformColumnTypes(Renamed, {{"MonthStart", type date}, {"StoreID", type text}, {"SalesTargetGHS", type number}}, "en-US")
in
    Typed

// ==== Query: dim_Date ====
// Generated calendar covering the data (2024-2025). Mark it as a date table in Power BI:
// Table tools > Mark as date table > Date. Sort MonthName by MonthNumber and DayName by DayNumber.
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
