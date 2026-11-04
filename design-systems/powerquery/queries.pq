// =====================================================================================
// DESIGN SYSTEMS GALLERY: Power Query (M) scripts
// Paste each query into Power BI: Home > Get data > Blank query > Advanced Editor.
// Name each query exactly as shown after "Query:".
// =====================================================================================

// ==== Query: DataFolder ====
// Create it through Home > Manage parameters > New parameter (Type: Text), not as a query.
// Set it to the folder that holds the raw CSV files. End it with a backslash.
"C:\path\to\power-bi-projects\design-systems\data\raw\" meta [IsParameterQuery = true, Type = "Text", IsParameterQueryRequired = true]

// ==== Query: dim_Ward ====
let
    Source = Csv.Document(File.Contents(DataFolder & "wards.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"ward_id", "WardID"}, {"ward", "Ward"}, {"department", "Department"}, {"beds", "Beds"}}),
    Selected = Table.SelectColumns(Renamed, {"WardID", "Ward", "Department", "Beds"}),
    Typed = Table.TransformColumnTypes(Selected, {{"WardID", type text}, {"Ward", type text}, {"Department", type text}, {"Beds", Int64.Type}}, "en-US")
in
    Typed

// ==== Query: dim_Diagnosis ====
let
    Source = Csv.Document(File.Contents(DataFolder & "diagnoses.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"diagnosis_id", "DiagnosisID"}, {"diagnosis_group", "DiagnosisGroup"}, {"category", "Category"}}),
    Selected = Table.SelectColumns(Renamed, {"DiagnosisID", "DiagnosisGroup", "Category"}),
    Typed = Table.TransformColumnTypes(Selected, {{"DiagnosisID", type text}, {"DiagnosisGroup", type text}, {"Category", type text}}, "en-US")
in
    Typed

// ==== Query: dim_PatientProfile ====
// Cleaning: sex has stray spaces and mixed case; insurance has stray spaces.
let
    Source = Csv.Document(File.Contents(DataFolder & "profiles.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Cleansex = Table.TransformColumns(Promoted, {{"sex", each Text.Proper(Text.Trim(_)), type text}}),
    Cleaninsurance = Table.TransformColumns(Cleansex, {{"insurance", each Text.Trim(_), type text}}),
    Renamed = Table.RenameColumns(Cleaninsurance, {{"profile_id", "ProfileID"}, {"sex", "Sex"}, {"age_group", "AgeGroup"}, {"insurance", "Insurance"}, {"district", "District"}}),
    Selected = Table.SelectColumns(Renamed, {"ProfileID", "Sex", "AgeGroup", "Insurance", "District"}),
    Typed = Table.TransformColumnTypes(Selected, {{"ProfileID", type text}, {"Sex", type text}, {"AgeGroup", type text}, {"Insurance", type text}, {"District", type text}}, "en-US")
in
    Typed

// ==== Query: fact_Admission ====
// Cleaning: dates in two formats, outcome in mixed case, duplicate admission_id rows. Length of stay and outcome flags are calculated here.
let
    Source = Csv.Document(File.Contents(DataFolder & "admissions.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Deduped = Table.Distinct(Promoted, {"admission_id"}),
    WithAdmitDate = Table.AddColumn(Deduped, "AdmitDate", each if [admit_date] = null or Text.Trim([admit_date]) = "" then null else try Date.FromText([admit_date], [Format = "yyyy-MM-dd", Culture = "en-GB"]) otherwise Date.FromText([admit_date], [Format = "dd/MM/yyyy", Culture = "en-GB"]), type date),
    WithDischargeDate = Table.AddColumn(WithAdmitDate, "DischargeDate", each if [discharge_date] = null or Text.Trim([discharge_date]) = "" then null else try Date.FromText([discharge_date], [Format = "yyyy-MM-dd", Culture = "en-GB"]) otherwise Date.FromText([discharge_date], [Format = "dd/MM/yyyy", Culture = "en-GB"]), type date),
    Cleanoutcome = Table.TransformColumns(WithDischargeDate, {{"outcome", each Text.Proper(Text.Trim(_)), type text}}),
    Renamed = Table.RenameColumns(Cleanoutcome, {{"admission_id", "AdmissionID"}, {"profile_id", "ProfileID"}, {"ward_id", "WardID"}, {"diagnosis_id", "DiagnosisID"}, {"outcome", "Outcome"}, {"readmitted_30", "Readmitted30"}}),
    Selected = Table.SelectColumns(Renamed, {"AdmissionID", "AdmitDate", "DischargeDate", "ProfileID", "WardID", "DiagnosisID", "Outcome", "Readmitted30"}),
    Typed = Table.TransformColumnTypes(Selected, {{"AdmissionID", type text}, {"ProfileID", type text}, {"WardID", type text}, {"DiagnosisID", type text}, {"Outcome", type text}, {"Readmitted30", Int64.Type}}, "en-US"),
    AddLengthOfStay = Table.AddColumn(Typed, "LengthOfStay", each List.Max({1, Duration.Days([DischargeDate] - [AdmitDate])}), Int64.Type),
    AddIsDeceased = Table.AddColumn(AddLengthOfStay, "IsDeceased", each if [Outcome] = "Deceased" then 1 else 0, Int64.Type),
    AddIsReferred = Table.AddColumn(AddIsDeceased, "IsReferred", each if [Outcome] = "Referred" then 1 else 0, Int64.Type)
in
    AddIsReferred

// ==== Query: fact_Census ====
// Beds occupied per ward and day.
let
    Source = Csv.Document(File.Contents(DataFolder & "census.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"census_date", "CensusDate"}, {"ward_id", "WardID"}, {"occupied_beds", "OccupiedBeds"}}),
    Selected = Table.SelectColumns(Renamed, {"CensusDate", "WardID", "OccupiedBeds"}),
    Typed = Table.TransformColumnTypes(Selected, {{"CensusDate", type date}, {"WardID", type text}, {"OccupiedBeds", Int64.Type}}, "en-US")
in
    Typed

// ==== Query: fact_ED ====
// Cleaning: date in two formats, waiting time stored as text ('45 min') in some rows, triage and disposition in mixed case, duplicate visit_id rows.
let
    Source = Csv.Document(File.Contents(DataFolder & "ed_visits.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Deduped = Table.Distinct(Promoted, {"visit_id"}),
    WithArrivalDate = Table.AddColumn(Deduped, "ArrivalDate", each if [arrival_date] = null or Text.Trim([arrival_date]) = "" then null else try Date.FromText([arrival_date], [Format = "yyyy-MM-dd", Culture = "en-GB"]) otherwise Date.FromText([arrival_date], [Format = "dd/MM/yyyy", Culture = "en-GB"]), type date),
    WithWaitMinutes = Table.AddColumn(WithArrivalDate, "WaitMinutes", each if [wait_minutes] = null or Text.Trim([wait_minutes]) = "" then null else Number.FromText(Text.Trim(Text.Replace(Text.Lower([wait_minutes]), "min", "")), "en-US"), type number),
    Cleantriagelevel = Table.TransformColumns(WithWaitMinutes, {{"triage_level", each Text.Proper(Text.Trim(_)), type text}}),
    Cleandisposition = Table.TransformColumns(Cleantriagelevel, {{"disposition", each Text.Proper(Text.Trim(_)), type text}}),
    Renamed = Table.RenameColumns(Cleandisposition, {{"visit_id", "VisitID"}, {"profile_id", "ProfileID"}, {"triage_level", "TriageLevel"}, {"disposition", "Disposition"}}),
    Selected = Table.SelectColumns(Renamed, {"VisitID", "ArrivalDate", "ProfileID", "TriageLevel", "WaitMinutes", "Disposition"}),
    Typed = Table.TransformColumnTypes(Selected, {{"VisitID", type text}, {"ProfileID", type text}, {"TriageLevel", type text}, {"Disposition", type text}}, "en-US"),
    AddIsWithinTarget = Table.AddColumn(Typed, "IsWithinTarget", each if if [TriageLevel] = "Red" then [WaitMinutes] <= 10 else if [TriageLevel] = "Orange" then [WaitMinutes] <= 30 else if [TriageLevel] = "Yellow" then [WaitMinutes] <= 60 else [WaitMinutes] <= 120 then 1 else 0, Int64.Type),
    AddIsLWBS = Table.AddColumn(AddIsWithinTarget, "IsLWBS", each if [Disposition] = "Left Without Being Seen" then 1 else 0, Int64.Type),
    AddIsAdmitted = Table.AddColumn(AddIsLWBS, "IsAdmitted", each if [Disposition] = "Admitted" then 1 else 0, Int64.Type)
in
    AddIsAdmitted

// ==== Query: fact_Target ====
let
    Source = Csv.Document(File.Contents(DataFolder & "targets.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"month", "MonthStart"}, {"ward", "Ward"}, {"occupancy_target", "OccupancyTarget"}}),
    Selected = Table.SelectColumns(Renamed, {"MonthStart", "Ward", "OccupancyTarget"}),
    Typed = Table.TransformColumnTypes(Selected, {{"MonthStart", type date}, {"Ward", type text}, {"OccupancyTarget", type number}}, "en-US")
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
