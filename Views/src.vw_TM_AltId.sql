SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [src].[vw_TM_AltId]
AS

/*
EXEC [dbo].[SSBHashFieldSyntaxZF] 'ods.tm_AltId', 'id, InsertDate, UpdateDate, HashKey', ''
*/

SELECT acct_id, alt_acct_id, alt_id_type, alt_id_type_name, alt_id_comment, SourceFileName
, HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(VARCHAR(10),acct_id)),'DBNULL_INT') + ISNULL(RTRIM(alt_acct_id),'DBNULL_TEXT') + ISNULL(RTRIM(alt_id_comment),'DBNULL_TEXT') + ISNULL(RTRIM(alt_id_type),'DBNULL_TEXT') + ISNULL(RTRIM(alt_id_type_name),'DBNULL_TEXT') + ISNULL(RTRIM(SourceFileName),'DBNULL_TEXT')) HashKey
FROM (
	SELECT ISNULL(TRY_CAST(acct_id AS INT),0) acct_id, alt_acct_id, alt_id_type, alt_id_type_name, alt_id_comment, SourceFileName
	, ROW_NUMBER() OVER(PARTITION BY acct_id, alt_acct_id, alt_id_type ORDER BY alt_id_type_name) AS MergeRank
  FROM [src].[TM_AltId]
) a 
WHERE MergeRank = 1




GO
