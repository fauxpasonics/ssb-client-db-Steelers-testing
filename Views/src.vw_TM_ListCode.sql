SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [src].[vw_TM_ListCode]
AS

SELECT 
	acct_id
	, code
	, value   	
	, sort_seq
	,SourceFileName
	, HASHBYTES('sha2_256', ISNULL(RTRIM(acct_id),'DBNULL_TEXT') + ISNULL(RTRIM(code),'DBNULL_TEXT') + ISNULL(RTRIM(sort_seq),'DBNULL_TEXT') + ISNULL(RTRIM(value),'DBNULL_TEXT')) SrcHashKey
	, ROW_NUMBER() OVER(PARTITION BY acct_id, code, value ORDER BY sort_seq desc) AS MergeRank
  FROM [src].TM_ListCode





GO
