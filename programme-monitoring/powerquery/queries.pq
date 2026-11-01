// =====================================================================================
// PROGRAMME MONITORING: Power Query (M) scripts
// Paste each query into Power BI: Home > Get data > Blank query > Advanced Editor.
// Name each query exactly as shown after "Query:". Disable "Enable load" for DataFolder only
// if you want, it is a parameter (see the first block).
// =====================================================================================

// ==== Query: DataFolder ====
// Create it through Home > Manage parameters > New parameter (Type: Text), not as a query.
// Current value: the folder that holds the raw CSV files. End it with a backslash.
"C:\path\to\power-bi-projects\programme-monitoring\data\raw\" meta [IsParameterQuery = true, Type = "Text", IsParameterQueryRequired = true]

// ==== Query: dim_Zone ====
// Distinct zones (an invented grouping of Central Region districts), built from the district file.
// Used to filter both districts and targets.
let
    Source = Csv.Document(File.Contents(DataFolder & "districts.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Zones = Table.Distinct(Table.SelectColumns(Promoted, {"zone"})),
    Renamed = Table.RenameColumns(Zones, {{"zone", "Zone"}}),
    Trimmed = Table.TransformColumns(Renamed, {{"Zone", each Text.Trim(_), type text}})
in
    Trimmed

// ==== Query: dim_District ====
let
    Source = Csv.Document(File.Contents(DataFolder & "districts.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"district_id", "DistrictID"}, {"zone", "Zone"}, {"district", "District"}}),
    Typed = Table.TransformColumnTypes(Renamed, {{"DistrictID", type text}, {"Zone", type text}, {"District", type text}})
in
    Typed

// ==== Query: dim_Community ====
let
    Source = Csv.Document(File.Contents(DataFolder & "communities.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"community_id", "CommunityID"}, {"district_id", "DistrictID"}, {"community_name", "Community"}}),
    Typed = Table.TransformColumnTypes(Renamed, {{"CommunityID", type text}, {"DistrictID", type text}, {"Community", type text}})
in
    Typed

// ==== Query: dim_Officer ====
// Cleaning: the home_zone column arrives in mixed case with stray spaces ("  western coast ").
let
    Source = Csv.Document(File.Contents(DataFolder & "officers.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"officer_id", "OfficerID"}, {"officer_name", "OfficerName"}, {"team", "Team"}, {"home_zone", "HomeZone"}, {"start_date", "StartDate"}}),
    CleanZone = Table.TransformColumns(Renamed, {{"HomeZone", each Text.Proper(Text.Trim(_)), type text}}),
    Typed = Table.TransformColumnTypes(CleanZone, {{"OfficerID", type text}, {"OfficerName", type text}, {"Team", type text}, {"StartDate", type date}}, "en-GB")
in
    Typed

// ==== Query: fact_Visit ====
// Cleaning steps (each one fixes a problem injected into visits.csv):
//   1. visit_date is mostly yyyy-MM-dd but about 3% is dd/MM/yyyy: try one format, fall back to the other.
//   2. visit_type has stray spaces and mixed case: trim, proper-case, then restore "Follow-up".
//   3. about 1% of rows are exact duplicates of a visit_id: keep one.
let
    Source = Csv.Document(File.Contents(DataFolder & "visits.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Deduped = Table.Distinct(Promoted, {"visit_id"}),
    WithDate = Table.AddColumn(Deduped, "VisitDate",
        each try Date.FromText([visit_date], [Format = "yyyy-MM-dd", Culture = "en-GB"])
             otherwise Date.FromText([visit_date], [Format = "dd/MM/yyyy", Culture = "en-GB"]), type date),
    CleanType = Table.TransformColumns(WithDate, {{"visit_type", each Text.Replace(Text.Proper(Text.Trim(_)), "Follow-Up", "Follow-up"), type text}}),
    Renamed = Table.RenameColumns(CleanType, {{"visit_id", "VisitID"}, {"officer_id", "OfficerID"}, {"community_id", "CommunityID"}, {"visit_type", "VisitType"},
        {"visit_status", "VisitStatus"}, {"farmers_visited", "FarmersVisited"}, {"duration_min", "DurationMin"},
        {"records_collected", "RecordsCollected"}, {"records_with_errors", "RecordsWithErrors"}}),
    Selected = Table.SelectColumns(Renamed, {"VisitID", "VisitDate", "OfficerID", "CommunityID", "VisitType", "VisitStatus", "FarmersVisited", "DurationMin", "RecordsCollected", "RecordsWithErrors"}),
    Typed = Table.TransformColumnTypes(Selected, {{"VisitID", type text}, {"OfficerID", type text}, {"CommunityID", type text}, {"VisitStatus", type text},
        {"FarmersVisited", Int64.Type}, {"DurationMin", Int64.Type}, {"RecordsCollected", Int64.Type}, {"RecordsWithErrors", Int64.Type}}, "en-US")
in
    Typed

// ==== Query: dim_VslaGroup ====
let
    Source = Csv.Document(File.Contents(DataFolder & "vsla_groups.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"group_id", "GroupID"}, {"group_name", "GroupName"}, {"community_id", "CommunityID"}, {"formed_date", "FormedDate"}, {"members", "Members"}}),
    Typed = Table.TransformColumnTypes(Renamed, {{"GroupID", type text}, {"GroupName", type text}, {"CommunityID", type text}, {"FormedDate", type date}, {"Members", Int64.Type}}, "en-GB")
in
    Typed

// ==== Query: fact_VslaMeeting ====
// Cleaning steps:
//   1. meeting_date: same mixed formats as visits.
//   2. savings_ghs: about 4% arrive as text such as "GHS 1,250.00": strip the prefix and thousands separators.
//   3. duplicate meeting_id rows: keep one.
let
    Source = Csv.Document(File.Contents(DataFolder & "vsla_meetings.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Deduped = Table.Distinct(Promoted, {"meeting_id"}),
    WithDate = Table.AddColumn(Deduped, "MeetingDate",
        each try Date.FromText([meeting_date], [Format = "yyyy-MM-dd", Culture = "en-GB"])
             otherwise Date.FromText([meeting_date], [Format = "dd/MM/yyyy", Culture = "en-GB"]), type date),
    WithSavings = Table.AddColumn(WithDate, "SavingsGHS",
        each Number.FromText(Text.Trim(Text.Replace(Text.Replace([savings_ghs], "GHS", ""), ",", "")), "en-US"), type number),
    Renamed = Table.RenameColumns(WithSavings, {{"meeting_id", "MeetingID"}, {"group_id", "GroupID"}, {"members_present", "MembersPresent"},
        {"loans_disbursed_ghs", "LoansDisbursedGHS"}, {"loans_repaid_ghs", "LoansRepaidGHS"}}),
    Selected = Table.SelectColumns(Renamed, {"MeetingID", "GroupID", "MeetingDate", "MembersPresent", "SavingsGHS", "LoansDisbursedGHS", "LoansRepaidGHS"}),
    Typed = Table.TransformColumnTypes(Selected, {{"MeetingID", type text}, {"GroupID", type text}, {"MembersPresent", Int64.Type},
        {"LoansDisbursedGHS", type number}, {"LoansRepaidGHS", type number}}, "en-US")
in
    Typed

// ==== Query: fact_Target ====
// Monthly targets by zone. MonthStart is the first day of the month, used to match dim_Date[MonthStart].
let
    Source = Csv.Document(File.Contents(DataFolder & "targets.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"month", "MonthStart"}, {"zone", "Zone"}, {"visits_target", "VisitsTarget"}, {"savings_target_ghs", "SavingsTargetGHS"}}),
    Typed = Table.TransformColumnTypes(Renamed, {{"MonthStart", type date}, {"Zone", type text}, {"VisitsTarget", Int64.Type}, {"SavingsTargetGHS", type number}}, "en-US")
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
