// =====================================================================================
// CONTENT AND EMAIL ENGAGEMENT: Power Query (M) scripts
// Paste each query into Power BI: Home > Get data > Blank query > Advanced Editor.
// Name each query exactly as shown after "Query:".
// =====================================================================================

// ==== Query: DataFolder ====
// Create it through Home > Manage parameters > New parameter (Type: Text), not as a query.
// Set it to the folder that holds the raw CSV files. End it with a backslash.
"C:\path\to\power-bi-projects\content-engagement\data\raw\" meta [IsParameterQuery = true, Type = "Text", IsParameterQueryRequired = true]

// ==== Query: dim_Content ====
// Cleaning: dates in two formats, topic and format in mixed case, author with stray spaces, duplicate content_id rows.
let
    Source = Csv.Document(File.Contents(DataFolder & "content.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Deduped = Table.Distinct(Promoted, {"content_id"}),
    WithPublishDate = Table.AddColumn(Deduped, "PublishDate", each if [publish_date] = null or Text.Trim([publish_date]) = "" then null else try Date.FromText([publish_date], [Format = "yyyy-MM-dd", Culture = "en-GB"]) otherwise Date.FromText([publish_date], [Format = "dd/MM/yyyy", Culture = "en-GB"]), type date),
    Cleantopic = Table.TransformColumns(WithPublishDate, {{"topic", each Text.Proper(Text.Trim(_)), type text}}),
    Cleanformat = Table.TransformColumns(Cleantopic, {{"format", each Text.Proper(Text.Trim(_)), type text}}),
    Cleanauthor = Table.TransformColumns(Cleanformat, {{"author", each Text.Trim(_), type text}}),
    Renamed = Table.RenameColumns(Cleanauthor, {{"content_id", "ContentID"}, {"title", "Title"}, {"topic", "Topic"}, {"format", "Format"}, {"author", "Author"}}),
    Selected = Table.SelectColumns(Renamed, {"ContentID", "Title", "Topic", "Format", "Author", "PublishDate"}),
    Typed = Table.TransformColumnTypes(Selected, {{"ContentID", type text}, {"Title", type text}, {"Topic", type text}, {"Format", type text}, {"Author", type text}}, "en-US")
in
    Typed

// ==== Query: dim_Platform ====
let
    Source = Csv.Document(File.Contents(DataFolder & "platforms.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"platform_id", "PlatformID"}, {"platform", "Platform"}}),
    Selected = Table.SelectColumns(Renamed, {"PlatformID", "Platform"}),
    Typed = Table.TransformColumnTypes(Selected, {{"PlatformID", type text}, {"Platform", type text}}, "en-US")
in
    Typed

// ==== Query: dim_Audience ====
let
    Source = Csv.Document(File.Contents(DataFolder & "audiences.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Renamed = Table.RenameColumns(Promoted, {{"audience_id", "AudienceID"}, {"audience_segment", "AudienceSegment"}}),
    Selected = Table.SelectColumns(Renamed, {"AudienceID", "AudienceSegment"}),
    Typed = Table.TransformColumnTypes(Selected, {{"AudienceID", type text}, {"AudienceSegment", type text}}, "en-US")
in
    Typed

// ==== Query: fact_Email ====
// Cleaning: dates in two formats, duplicate email_id rows.
let
    Source = Csv.Document(File.Contents(DataFolder & "email.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Deduped = Table.Distinct(Promoted, {"email_id"}),
    WithSendDate = Table.AddColumn(Deduped, "SendDate", each if [send_date] = null or Text.Trim([send_date]) = "" then null else try Date.FromText([send_date], [Format = "yyyy-MM-dd", Culture = "en-GB"]) otherwise Date.FromText([send_date], [Format = "dd/MM/yyyy", Culture = "en-GB"]), type date),
    Renamed = Table.RenameColumns(WithSendDate, {{"email_id", "EmailID"}, {"content_id", "ContentID"}, {"audience_id", "AudienceID"}, {"sent", "Sent"}, {"delivered", "Delivered"}, {"opens", "Opens"}, {"clicks", "Clicks"}, {"unsubscribes", "Unsubscribes"}, {"signups", "Signups"}}),
    Selected = Table.SelectColumns(Renamed, {"EmailID", "SendDate", "ContentID", "AudienceID", "Sent", "Delivered", "Opens", "Clicks", "Unsubscribes", "Signups"}),
    Typed = Table.TransformColumnTypes(Selected, {{"EmailID", type text}, {"ContentID", type text}, {"AudienceID", type text}, {"Sent", Int64.Type}, {"Delivered", Int64.Type}, {"Opens", Int64.Type}, {"Clicks", Int64.Type}, {"Unsubscribes", Int64.Type}, {"Signups", Int64.Type}}, "en-US")
in
    Typed

// ==== Query: fact_Social ====
// Cleaning: dates in two formats, duplicate post_id rows.
let
    Source = Csv.Document(File.Contents(DataFolder & "social.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Deduped = Table.Distinct(Promoted, {"post_id"}),
    WithPostDate = Table.AddColumn(Deduped, "PostDate", each if [post_date] = null or Text.Trim([post_date]) = "" then null else try Date.FromText([post_date], [Format = "yyyy-MM-dd", Culture = "en-GB"]) otherwise Date.FromText([post_date], [Format = "dd/MM/yyyy", Culture = "en-GB"]), type date),
    Renamed = Table.RenameColumns(WithPostDate, {{"post_id", "PostID"}, {"content_id", "ContentID"}, {"platform_id", "PlatformID"}, {"impressions", "Impressions"}, {"engagements", "Engagements"}, {"shares", "Shares"}, {"followers_gained", "FollowersGained"}}),
    Selected = Table.SelectColumns(Renamed, {"PostID", "PostDate", "ContentID", "PlatformID", "Impressions", "Engagements", "Shares", "FollowersGained"}),
    Typed = Table.TransformColumnTypes(Selected, {{"PostID", type text}, {"ContentID", type text}, {"PlatformID", type text}, {"Impressions", Int64.Type}, {"Engagements", Int64.Type}, {"Shares", Int64.Type}, {"FollowersGained", Int64.Type}}, "en-US")
in
    Typed

// ==== Query: fact_Web ====
// Cleaning: dates in two formats, bounce rate stored as text ('42%') in some rows, duplicate web_id rows.
let
    Source = Csv.Document(File.Contents(DataFolder & "web.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Deduped = Table.Distinct(Promoted, {"web_id"}),
    WithWeekStart = Table.AddColumn(Deduped, "WeekStart", each if [week_start] = null or Text.Trim([week_start]) = "" then null else try Date.FromText([week_start], [Format = "yyyy-MM-dd", Culture = "en-GB"]) otherwise Date.FromText([week_start], [Format = "dd/MM/yyyy", Culture = "en-GB"]), type date),
    WithBounceRate = Table.AddColumn(WithWeekStart, "BounceRate", each if Text.EndsWith(Text.Trim([bounce_rate]), "%") then Number.FromText(Text.Replace(Text.Trim([bounce_rate]), "%", ""), "en-US") / 100 else Number.FromText(Text.Trim([bounce_rate]), "en-US"), type number),
    Renamed = Table.RenameColumns(WithBounceRate, {{"web_id", "WebID"}, {"content_id", "ContentID"}, {"sessions", "Sessions"}, {"users", "Users"}, {"avg_seconds", "AvgSeconds"}, {"signups", "Signups"}}),
    Selected = Table.SelectColumns(Renamed, {"WebID", "WeekStart", "ContentID", "Sessions", "Users", "BounceRate", "AvgSeconds", "Signups"}),
    Typed = Table.TransformColumnTypes(Selected, {{"WebID", type text}, {"ContentID", type text}, {"Sessions", Int64.Type}, {"Users", Int64.Type}, {"AvgSeconds", type number}, {"Signups", Int64.Type}}, "en-US")
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
