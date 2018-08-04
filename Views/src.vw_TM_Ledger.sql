SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [src].[vw_TM_Ledger]
AS

/*
EXEC [dbo].[SSBHashFieldSyntaxZF] 'ods.tm_ledger', 'id, InsertDate, UpdateDate, HashKey', ''
*/

SELECT ledger_id, ledger_code, ledger_name, active, gl_code_payment, gl_code_refund, sort_seq, add_user, add_datetime, upd_user, upd_datetime, SourceFileName
, HASHBYTES('sha2_256', ISNULL(RTRIM(active),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(25),add_datetime)),'DBNULL_DATETIME') + ISNULL(RTRIM(add_user),'DBNULL_TEXT') + ISNULL(RTRIM(gl_code_payment),'DBNULL_TEXT') + ISNULL(RTRIM(gl_code_refund),'DBNULL_TEXT') + ISNULL(RTRIM(ledger_code),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),ledger_id)),'DBNULL_INT') + ISNULL(RTRIM(ledger_name),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),sort_seq)),'DBNULL_INT') + ISNULL(RTRIM(SourceFileName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(25),upd_datetime)),'DBNULL_DATETIME') + ISNULL(RTRIM(upd_user),'DBNULL_TEXT')) HashKey
FROM (
	SELECT ledger_id, ledger_code, ledger_name, active, gl_code_payment, gl_code_refund, sort_seq, add_user, add_datetime, upd_user, upd_datetime, SourceFileName
	, ROW_NUMBER() OVER(PARTITION BY ledger_id ORDER BY sort_seq) AS MergeRank
  FROM [src].[TM_Ledger]
) a 
WHERE MergeRank = 1







GO
