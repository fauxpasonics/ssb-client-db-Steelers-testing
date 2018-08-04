SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [src].[vw_TM_Attend]
AS

		SELECT [acct_id]
		  ,[event_id]
		  ,[section_id]
		  ,[row_id]
		  ,[seat_num]
		  ,[scan_date]
		  ,[scan_time]
		  ,[gate]
		  ,[barcode]
		  ,[SourceFileName]
		, HASHBYTES('sha2_256', ISNULL(RTRIM([acct_id]),'DBNULL_TEXT') +
		  ISNULL(RTRIM([scan_date]),'DBNULL_TEXT') + ISNULL(RTRIM([scan_time]),'DBNULL_TEXT') + ISNULL(RTRIM([gate]),'DBNULL_TEXT') + ISNULL(RTRIM([barcode]),'DBNULL_TEXT')) SrcHashKey
		  , ROW_NUMBER() OVER(PARTITION BY event_id, section_id, row_id, seat_num ORDER BY scan_date DESC, scan_time DESC) MergeRank	  
	  FROM [src].[TM_Attend]




GO
