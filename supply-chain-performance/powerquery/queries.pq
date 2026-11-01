// =====================================================================================
// SUPPLY CHAIN PERFORMANCE: Power Query (M) scripts
// Paste each query into Power BI: Home > Get data > Blank query > Advanced Editor.
// Name each query exactly as shown after "Query:".
// =====================================================================================

// ==== Query: DataFolder ====
// Create it through Home > Manage parameters > New parameter (Type: Text), not as a query.
// Set it to the folder that holds the raw CSV files. End it with a backslash.
"C:\path\to\power-bi-projects\supply-chain-performance\data\raw\" meta [IsParameterQuery = true, Type = "Text", IsParameterQueryRequired = true]

// ==== Query: dim_Warehouse ====
let
    Source = Csv.Document(File.Contents(DataFolder & "warehouses.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"warehouse_id", "WarehouseID"}, {"warehouse", "Warehouse"}, {"region", "Region"}}),
    Selected = Table.SelectColumns(Renamed, {"WarehouseID", "Warehouse", "Region"}),
    Typed = Table.TransformColumnTypes(Selected, {{"WarehouseID", type text}, {"Warehouse", type text}, {"Region", type text}}, "en-US")
in
    Typed

// ==== Query: dim_Customer ====
// Cleaning: customer_type has stray spaces and mixed case.
let
    Source = Csv.Document(File.Contents(DataFolder & "customers.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Cleancustomertype = Table.TransformColumns(Promoted, {{"customer_type", each Text.Proper(Text.Trim(_)), type text}}),
    Renamed = Table.RenameColumns(Cleancustomertype, {{"customer_id", "CustomerID"}, {"customer", "Customer"}, {"customer_type", "CustomerType"}, {"region", "Region"}}),
    Selected = Table.SelectColumns(Renamed, {"CustomerID", "Customer", "CustomerType", "Region"}),
    Typed = Table.TransformColumnTypes(Selected, {{"CustomerID", type text}, {"Customer", type text}, {"CustomerType", type text}, {"Region", type text}}, "en-US")
in
    Typed

// ==== Query: dim_Product ====
let
    Source = Csv.Document(File.Contents(DataFolder & "products.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"product_id", "ProductID"}, {"product", "Product"}, {"category", "Category"}, {"supplier_id", "SupplierID"}, {"unit_cost_ghs", "UnitCostGHS"}, {"unit_price_ghs", "UnitPriceGHS"}}),
    Selected = Table.SelectColumns(Renamed, {"ProductID", "Product", "Category", "SupplierID", "UnitCostGHS", "UnitPriceGHS"}),
    Typed = Table.TransformColumnTypes(Selected, {{"ProductID", type text}, {"Product", type text}, {"Category", type text}, {"SupplierID", type text}, {"UnitCostGHS", type number}, {"UnitPriceGHS", type number}}, "en-US")
in
    Typed

// ==== Query: dim_Supplier ====
let
    Source = Csv.Document(File.Contents(DataFolder & "suppliers.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"supplier_id", "SupplierID"}, {"supplier", "Supplier"}, {"origin", "Origin"}}),
    Selected = Table.SelectColumns(Renamed, {"SupplierID", "Supplier", "Origin"}),
    Typed = Table.TransformColumnTypes(Selected, {{"SupplierID", type text}, {"Supplier", type text}, {"Origin", type text}}, "en-US")
in
    Typed

// ==== Query: dim_Carrier ====
let
    Source = Csv.Document(File.Contents(DataFolder & "carriers.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"carrier_id", "CarrierID"}, {"carrier", "Carrier"}, {"mode", "Mode"}}),
    Selected = Table.SelectColumns(Renamed, {"CarrierID", "Carrier", "Mode"}),
    Typed = Table.TransformColumnTypes(Selected, {{"CarrierID", type text}, {"Carrier", type text}, {"Mode", type text}}, "en-US")
in
    Typed

// ==== Query: fact_OrderLine ====
// Cleaning: dates in two formats, freight cost stored as text ('GHS 340.00') in some rows, duplicate line_id rows. Service flags are calculated here.
let
    Source = Csv.Document(File.Contents(DataFolder & "order_lines.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Deduped = Table.Distinct(Promoted, {"line_id"}),
    WithOrderDate = Table.AddColumn(Deduped, "OrderDate", each if [order_date] = null or Text.Trim([order_date]) = "" then null else try Date.FromText([order_date], [Format = "yyyy-MM-dd", Culture = "en-GB"]) otherwise Date.FromText([order_date], [Format = "dd/MM/yyyy", Culture = "en-GB"]), type date),
    WithRequiredDate = Table.AddColumn(WithOrderDate, "RequiredDate", each if [required_date] = null or Text.Trim([required_date]) = "" then null else try Date.FromText([required_date], [Format = "yyyy-MM-dd", Culture = "en-GB"]) otherwise Date.FromText([required_date], [Format = "dd/MM/yyyy", Culture = "en-GB"]), type date),
    WithShipDate = Table.AddColumn(WithRequiredDate, "ShipDate", each if [ship_date] = null or Text.Trim([ship_date]) = "" then null else try Date.FromText([ship_date], [Format = "yyyy-MM-dd", Culture = "en-GB"]) otherwise Date.FromText([ship_date], [Format = "dd/MM/yyyy", Culture = "en-GB"]), type date),
    WithDeliveryDate = Table.AddColumn(WithShipDate, "DeliveryDate", each if [delivery_date] = null or Text.Trim([delivery_date]) = "" then null else try Date.FromText([delivery_date], [Format = "yyyy-MM-dd", Culture = "en-GB"]) otherwise Date.FromText([delivery_date], [Format = "dd/MM/yyyy", Culture = "en-GB"]), type date),
    WithFreightCostGHS = Table.AddColumn(WithDeliveryDate, "FreightCostGHS", each if [freight_cost_ghs] = null or Text.Trim([freight_cost_ghs]) = "" then null else Number.FromText(Text.Trim(Text.Replace(Text.Replace(Text.Replace([freight_cost_ghs], "GHS", ""), ",", ""), " ", "")), "en-US"), type number),
    Renamed = Table.RenameColumns(WithFreightCostGHS, {{"line_id", "LineID"}, {"order_id", "OrderID"}, {"customer_id", "CustomerID"}, {"product_id", "ProductID"}, {"warehouse_id", "WarehouseID"}, {"carrier_id", "CarrierID"}, {"ordered_qty", "OrderedQty"}, {"shipped_qty", "ShippedQty"}, {"unit_price_ghs", "UnitPriceGHS"}}),
    Selected = Table.SelectColumns(Renamed, {"LineID", "OrderID", "OrderDate", "RequiredDate", "ShipDate", "DeliveryDate", "CustomerID", "ProductID", "WarehouseID", "CarrierID", "OrderedQty", "ShippedQty", "UnitPriceGHS", "FreightCostGHS"}),
    Typed = Table.TransformColumnTypes(Selected, {{"LineID", type text}, {"OrderID", type text}, {"CustomerID", type text}, {"ProductID", type text}, {"WarehouseID", type text}, {"CarrierID", type text}, {"OrderedQty", Int64.Type}, {"ShippedQty", Int64.Type}, {"UnitPriceGHS", type number}}, "en-US"),
    AddIsOnTime = Table.AddColumn(Typed, "IsOnTime", each if [DeliveryDate] <= [RequiredDate] then 1 else 0, Int64.Type),
    AddIsInFull = Table.AddColumn(AddIsOnTime, "IsInFull", each if [ShippedQty] >= [OrderedQty] then 1 else 0, Int64.Type),
    AddIsOTIF = Table.AddColumn(AddIsInFull, "IsOTIF", each [IsOnTime] * [IsInFull], Int64.Type),
    AddLeadTimeDays = Table.AddColumn(AddIsOTIF, "LeadTimeDays", each Duration.Days([DeliveryDate] - [OrderDate]), Int64.Type),
    AddShippedValueGHS = Table.AddColumn(AddLeadTimeDays, "ShippedValueGHS", each [ShippedQty] * [UnitPriceGHS], type number)
in
    AddShippedValueGHS

// ==== Query: fact_Stock ====
// Month-end stock count per hub and product.
let
    Source = Csv.Document(File.Contents(DataFolder & "stock.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"snapshot_date", "SnapshotDate"}, {"warehouse_id", "WarehouseID"}, {"product_id", "ProductID"}, {"on_hand_qty", "OnHandQty"}, {"demand_qty", "DemandQty"}}),
    Selected = Table.SelectColumns(Renamed, {"SnapshotDate", "WarehouseID", "ProductID", "OnHandQty", "DemandQty"}),
    Typed = Table.TransformColumnTypes(Selected, {{"SnapshotDate", type date}, {"WarehouseID", type text}, {"ProductID", type text}, {"OnHandQty", Int64.Type}, {"DemandQty", Int64.Type}}, "en-US"),
    AddIsStockout = Table.AddColumn(Typed, "IsStockout", each if [OnHandQty] <= 0 then 1 else 0, Int64.Type)
in
    AddIsStockout

// ==== Query: fact_Receipt ====
// Cleaning: dates in two formats and duplicate receipt_id rows.
let
    Source = Csv.Document(File.Contents(DataFolder & "receipts.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Deduped = Table.Distinct(Promoted, {"receipt_id"}),
    WithPODate = Table.AddColumn(Deduped, "PODate", each if [po_date] = null or Text.Trim([po_date]) = "" then null else try Date.FromText([po_date], [Format = "yyyy-MM-dd", Culture = "en-GB"]) otherwise Date.FromText([po_date], [Format = "dd/MM/yyyy", Culture = "en-GB"]), type date),
    WithExpectedDate = Table.AddColumn(WithPODate, "ExpectedDate", each if [expected_date] = null or Text.Trim([expected_date]) = "" then null else try Date.FromText([expected_date], [Format = "yyyy-MM-dd", Culture = "en-GB"]) otherwise Date.FromText([expected_date], [Format = "dd/MM/yyyy", Culture = "en-GB"]), type date),
    WithReceiptDate = Table.AddColumn(WithExpectedDate, "ReceiptDate", each if [receipt_date] = null or Text.Trim([receipt_date]) = "" then null else try Date.FromText([receipt_date], [Format = "yyyy-MM-dd", Culture = "en-GB"]) otherwise Date.FromText([receipt_date], [Format = "dd/MM/yyyy", Culture = "en-GB"]), type date),
    Renamed = Table.RenameColumns(WithReceiptDate, {{"receipt_id", "ReceiptID"}, {"supplier_id", "SupplierID"}, {"product_id", "ProductID"}, {"warehouse_id", "WarehouseID"}, {"ordered_qty", "OrderedQty"}, {"received_qty", "ReceivedQty"}, {"rejected_qty", "RejectedQty"}}),
    Selected = Table.SelectColumns(Renamed, {"ReceiptID", "PODate", "ExpectedDate", "ReceiptDate", "SupplierID", "ProductID", "WarehouseID", "OrderedQty", "ReceivedQty", "RejectedQty"}),
    Typed = Table.TransformColumnTypes(Selected, {{"ReceiptID", type text}, {"SupplierID", type text}, {"ProductID", type text}, {"WarehouseID", type text}, {"OrderedQty", Int64.Type}, {"ReceivedQty", Int64.Type}, {"RejectedQty", Int64.Type}}, "en-US"),
    AddIsOnTime = Table.AddColumn(Typed, "IsOnTime", each if [ReceiptDate] <= [ExpectedDate] then 1 else 0, Int64.Type),
    AddLeadTimeDays = Table.AddColumn(AddIsOnTime, "LeadTimeDays", each Duration.Days([ReceiptDate] - [PODate]), Int64.Type)
in
    AddLeadTimeDays

// ==== Query: fact_Target ====
let
    Source = Csv.Document(File.Contents(DataFolder & "targets.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"month", "MonthStart"}, {"warehouse", "Warehouse"}, {"otif_target", "OTIFTarget"}}),
    Selected = Table.SelectColumns(Renamed, {"MonthStart", "Warehouse", "OTIFTarget"}),
    Typed = Table.TransformColumnTypes(Selected, {{"MonthStart", type date}, {"Warehouse", type text}, {"OTIFTarget", type number}}, "en-US")
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
