SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [src].[vw_TM_RetailEvent]
AS

/*
EXEC [dbo].[SSBHashFieldSyntaxZF] 'ods.TM_RetailEvent', 'id, InsertDate, UpdateDate, HashKey', ''
*/

SELECT retail_event_id, [host_name], host_event_code, host_event_id, event_date, event_time, attraction_id, attraction_name, major_category_id, major_category_name, minor_category_id, minor_category_name, venue_id, venue_name, primary_act_id, primary_act, secondary_act_id, secondary_act, SourceFileName
, HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(10),attraction_id)),'DBNULL_INT') + ISNULL(RTRIM(attraction_name),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),event_date,112)),'DBNULL_DATE') + ISNULL(RTRIM(event_time),'DBNULL_TEXT') + ISNULL(RTRIM(host_event_code),'DBNULL_TEXT') + ISNULL(RTRIM(host_event_id),'DBNULL_TEXT') + ISNULL(RTRIM(host_name),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),major_category_id)),'DBNULL_INT') + ISNULL(RTRIM(major_category_name),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),minor_category_id)),'DBNULL_INT') + ISNULL(RTRIM(minor_category_name),'DBNULL_TEXT') + ISNULL(RTRIM(primary_act),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),primary_act_id)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),retail_event_id)),'DBNULL_INT') + ISNULL(RTRIM(secondary_act),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),secondary_act_id)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),venue_id)),'DBNULL_INT') + ISNULL(RTRIM(venue_name),'DBNULL_TEXT')) HashKey
FROM (
	SELECT retail_event_id, [host_name], host_event_code, host_event_id, event_date, event_time, attraction_id, attraction_name, major_category_id, major_category_name, minor_category_id, minor_category_name, venue_id, venue_name, primary_act_id, primary_act, secondary_act_id, secondary_act, SourceFileName
	, ROW_NUMBER() OVER(PARTITION BY retail_event_id ORDER BY event_date) AS MergeRank
  FROM [src].[TM_RetailEvent]
) a 
WHERE MergeRank = 1

GO
