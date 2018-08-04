SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [src].[vw_TM_Evnt]
AS
SELECT [event_name]
      ,[event_date]
      ,[event_time]
      ,[event_day]
      ,[Team]
	  ,[plan_abv]
      ,[event_report_group]
	  ,[plan_Type]
      ,[Enabled]
      ,[Returnable]
      ,[Min_events]
      ,[total_events]
      ,[FSE]
      ,[Dsps_allowed]
      ,[exchange_price_opt]
      ,[Season_name]
      ,[event_name_long]
      ,[Tm_event_name]
      ,[Event_sort]
      ,[Game_Numbe]
      ,[Barcode_Status]
      ,[Print_Ticket_Ind]
      ,[Add_date]
      ,[Upd_user]
      ,[Upd_date]
      ,[Event_id]
      ,[MaxEventDate]
      ,[Event_Type]
      ,[Arena_name]
      ,[Major_Category]
      ,[Minor_Category]
      ,[Org_Name]
	  ,[Plan]
	  ,[Season_id]
	  ,[SourceFileName]
	  ,HASHBYTES('sha2_256', ISNULL(RTRIM([event_name]),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(25),[event_date])),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(VARCHAR(25),[event_time])),'DBNULL_DATETIME') +
	   ISNULL(RTRIM([event_day]),'DBNULL_TEXT') + ISNULL(RTRIM([Team]),'DBNULL_TEXT') + ISNULL(RTRIM([plan_abv]),'DBNULL_TEXT') + ISNULL(RTRIM([event_report_group]),'DBNULL_TEXT') + 
	   ISNULL(RTRIM([Enabled]),'DBNULL_TEXT') + ISNULL(RTRIM([plan_Type]),'DBNULL_TEXT') + 
	   ISNULL(RTRIM([Returnable]),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),[Min_events])),'DBNULL_BIGINT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),[total_events])),'DBNULL_BIGINT') + 
	   ISNULL(RTRIM([FSE]),'DBNULL_TEXT') + ISNULL(RTRIM([Dsps_allowed]),'DBNULL_TEXT') + ISNULL(RTRIM([exchange_price_opt]),'DBNULL_TEXT') + ISNULL(RTRIM([Season_name]),'DBNULL_TEXT') + 
	   ISNULL(RTRIM([event_name_long]),'DBNULL_TEXT') + ISNULL(RTRIM([Tm_event_name]),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),[Event_sort])),'DBNULL_BIGINT') + 
	   ISNULL(RTRIM([Game_Numbe]),'DBNULL_TEXT') + ISNULL(RTRIM([Barcode_Status]),'DBNULL_TEXT') + ISNULL(RTRIM([Print_Ticket_Ind]),'DBNULL_TEXT') + 
	   ISNULL(RTRIM(CONVERT(VARCHAR(25),[Add_date])),'DBNULL_DATETIME') + ISNULL(RTRIM([Upd_user]),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(25),[Upd_date])),'DBNULL_DATETIME') + 
	   ISNULL(RTRIM(CONVERT(VARCHAR(10),[Event_id])),'DBNULL_BIGINT') + ISNULL(RTRIM(CONVERT(VARCHAR(25),[MaxEventDate])),'DBNULL_DATETIME') + ISNULL(RTRIM([Event_Type]),'DBNULL_TEXT') + 
	   ISNULL(RTRIM([Arena_name]),'DBNULL_TEXT') + ISNULL(RTRIM([Major_Category]),'DBNULL_TEXT') + ISNULL(RTRIM([Minor_Category]),'DBNULL_TEXT') + ISNULL(RTRIM([Org_Name]),'DBNULL_TEXT') + 
	   ISNULL(RTRIM([Plan]),'DBNULL_TEXT') + ISNULL(RTRIM([Season_id]),'DBNULL_INT')) SrcHashKey
	   , ROW_NUMBER() OVER(PARTITION BY Event_id ORDER BY Upd_date desc) AS MergeRank
  FROM [src].[TM_Evnt]











GO
