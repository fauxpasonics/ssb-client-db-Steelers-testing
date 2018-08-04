SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW  [src].[vw_TM_EventsInPlan]
AS

SELECT [plan_group_id]
      ,[plan_group_name]
      ,[plan_event_id]
      ,[plan_event_name]
      ,[plan_total_events]
      ,[plan_type]
      ,[event_id]
      ,[event_name]
      ,[event_Date]
      ,[event_time]
      ,[team]
      ,[game_number]
      ,[total_events]
      ,[tm_event_name]
      ,[child_is_plan]
      ,[season_id]
	  ,[SourceFileName]
	  ,HASHBYTES('sha2_256', ISNULL(RTRIM([plan_group_id]),'DBNULL_TEXT') + ISNULL(RTRIM([plan_group_name]),'DBNULL_TEXT') + ISNULL(RTRIM([plan_event_id]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([plan_event_name]),'DBNULL_TEXT') + ISNULL(RTRIM([plan_total_events]),'DBNULL_TEXT') + ISNULL(RTRIM([plan_type]),'DBNULL_TEXT') + ISNULL(RTRIM([event_id]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([event_name]),'DBNULL_TEXT') + ISNULL(RTRIM([event_Date]),'DBNULL_TEXT') + ISNULL(RTRIM([event_time]),'DBNULL_TEXT') + ISNULL(RTRIM([team]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([game_number]),'DBNULL_TEXT') + ISNULL(RTRIM([total_events]),'DBNULL_TEXT') + ISNULL(RTRIM([tm_event_name]),'DBNULL_TEXT') + ISNULL(RTRIM([child_is_plan]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([season_id]),'DBNULL_TEXT')) SrcHashKey
	  , ROW_NUMBER() OVER(PARTITION BY plan_group_id, plan_event_id, event_id, season_id ORDER BY event_date desc) AS MergeRank
  FROM [src].[TM_EventsInPlan]



GO
