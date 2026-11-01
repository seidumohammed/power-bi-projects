// =====================================================================================
// PUBLIC HEALTH PROGRAMME: Power Query (M) scripts
// Paste each query into Power BI: Home > Get data > Blank query > Advanced Editor.
// Name each query exactly as shown after "Query:".
// =====================================================================================

// ==== Query: DataFolder ====
// Create it through Home > Manage parameters > New parameter (Type: Text), not as a query.
// Set it to the folder that holds the raw CSV files. End it with a backslash.
"C:\path\to\power-bi-projects\public-health-programme\data\raw\" meta [IsParameterQuery = true, Type = "Text", IsParameterQueryRequired = true]

// ==== Query: dim_District ====
let
    Source = Csv.Document(File.Contents(DataFolder & "districts.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"district_id", "DistrictID"}, {"district", "District"}, {"subregion", "Subregion"}, {"population", "Population"}}),
    Selected = Table.SelectColumns(Renamed, {"DistrictID", "District", "Subregion", "Population"}),
    Typed = Table.TransformColumnTypes(Selected, {{"DistrictID", type text}, {"District", type text}, {"Subregion", type text}, {"Population", Int64.Type}}, "en-US")
in
    Typed

// ==== Query: dim_Facility ====
// Cleaning: facility level has stray spaces.
let
    Source = Csv.Document(File.Contents(DataFolder & "facilities.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Cleanfacilitylevel = Table.TransformColumns(Promoted, {{"facility_level", each Text.Trim(_), type text}}),
    Renamed = Table.RenameColumns(Cleanfacilitylevel, {{"facility_id", "FacilityID"}, {"facility", "Facility"}, {"district_id", "DistrictID"}, {"facility_level", "FacilityLevel"}, {"catchment_population", "CatchmentPopulation"}}),
    Selected = Table.SelectColumns(Renamed, {"FacilityID", "Facility", "DistrictID", "FacilityLevel", "CatchmentPopulation"}),
    Typed = Table.TransformColumnTypes(Selected, {{"FacilityID", type text}, {"Facility", type text}, {"DistrictID", type text}, {"FacilityLevel", type text}, {"CatchmentPopulation", Int64.Type}}, "en-US")
in
    Typed

// ==== Query: dim_Antigen ====
let
    Source = Csv.Document(File.Contents(DataFolder & "antigens.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"antigen_id", "AntigenID"}, {"antigen", "Antigen"}, {"schedule", "Schedule"}}),
    Selected = Table.SelectColumns(Renamed, {"AntigenID", "Antigen", "Schedule"}),
    Typed = Table.TransformColumnTypes(Selected, {{"AntigenID", type text}, {"Antigen", type text}, {"Schedule", type text}}, "en-US")
in
    Typed

// ==== Query: dim_Disease ====
let
    Source = Csv.Document(File.Contents(DataFolder & "diseases.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"disease_id", "DiseaseID"}, {"disease", "Disease"}, {"type", "Type"}}),
    Selected = Table.SelectColumns(Renamed, {"DiseaseID", "Disease", "Type"}),
    Typed = Table.TransformColumnTypes(Selected, {{"DiseaseID", type text}, {"Disease", type text}, {"Type", type text}}, "en-US")
in
    Typed

// ==== Query: fact_Immunisation ====
// Cleaning: month in two formats, duplicate record_id rows.
let
    Source = Csv.Document(File.Contents(DataFolder & "immunisation.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Deduped = Table.Distinct(Promoted, {"record_id"}),
    WithMonth = Table.AddColumn(Deduped, "Month", each if [month] = null or Text.Trim([month]) = "" then null else try Date.FromText([month], [Format = "yyyy-MM-dd", Culture = "en-GB"]) otherwise Date.FromText([month], [Format = "dd/MM/yyyy", Culture = "en-GB"]), type date),
    Renamed = Table.RenameColumns(WithMonth, {{"record_id", "RecordID"}, {"facility_id", "FacilityID"}, {"antigen_id", "AntigenID"}, {"doses", "Doses"}, {"target_children", "TargetChildren"}}),
    Selected = Table.SelectColumns(Renamed, {"RecordID", "Month", "FacilityID", "AntigenID", "Doses", "TargetChildren"}),
    Typed = Table.TransformColumnTypes(Selected, {{"RecordID", type text}, {"FacilityID", type text}, {"AntigenID", type text}, {"Doses", Int64.Type}, {"TargetChildren", Int64.Type}}, "en-US")
in
    Typed

// ==== Query: fact_Cases ====
// Cleaning: month in two formats, duplicate case_record_id rows.
let
    Source = Csv.Document(File.Contents(DataFolder & "cases.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Deduped = Table.Distinct(Promoted, {"case_record_id"}),
    WithMonth = Table.AddColumn(Deduped, "Month", each if [month] = null or Text.Trim([month]) = "" then null else try Date.FromText([month], [Format = "yyyy-MM-dd", Culture = "en-GB"]) otherwise Date.FromText([month], [Format = "dd/MM/yyyy", Culture = "en-GB"]), type date),
    Renamed = Table.RenameColumns(WithMonth, {{"case_record_id", "CaseRecordID"}, {"facility_id", "FacilityID"}, {"disease_id", "DiseaseID"}, {"cases", "Cases"}, {"deaths", "Deaths"}, {"tested", "Tested"}, {"positive", "Positive"}}),
    Selected = Table.SelectColumns(Renamed, {"CaseRecordID", "Month", "FacilityID", "DiseaseID", "Cases", "Deaths", "Tested", "Positive"}),
    Typed = Table.TransformColumnTypes(Selected, {{"CaseRecordID", type text}, {"FacilityID", type text}, {"DiseaseID", type text}, {"Cases", Int64.Type}, {"Deaths", Int64.Type}, {"Tested", Int64.Type}, {"Positive", Int64.Type}}, "en-US")
in
    Typed

// ==== Query: fact_Reporting ====
// Cleaning: month in two formats, duplicate report_id rows.
let
    Source = Csv.Document(File.Contents(DataFolder & "reporting.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Deduped = Table.Distinct(Promoted, {"report_id"}),
    WithMonth = Table.AddColumn(Deduped, "Month", each if [month] = null or Text.Trim([month]) = "" then null else try Date.FromText([month], [Format = "yyyy-MM-dd", Culture = "en-GB"]) otherwise Date.FromText([month], [Format = "dd/MM/yyyy", Culture = "en-GB"]), type date),
    Renamed = Table.RenameColumns(WithMonth, {{"report_id", "ReportID"}, {"facility_id", "FacilityID"}, {"submitted", "Submitted"}, {"on_time", "OnTime"}}),
    Selected = Table.SelectColumns(Renamed, {"ReportID", "Month", "FacilityID", "Submitted", "OnTime"}),
    Typed = Table.TransformColumnTypes(Selected, {{"ReportID", type text}, {"FacilityID", type text}, {"Submitted", Int64.Type}, {"OnTime", Int64.Type}}, "en-US")
in
    Typed

// ==== Query: fact_Target ====
let
    Source = Csv.Document(File.Contents(DataFolder & "targets.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"month", "MonthStart"}, {"district", "District"}, {"coverage_target", "CoverageTarget"}}),
    Selected = Table.SelectColumns(Renamed, {"MonthStart", "District", "CoverageTarget"}),
    Typed = Table.TransformColumnTypes(Selected, {{"MonthStart", type date}, {"District", type text}, {"CoverageTarget", type number}}, "en-US")
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
