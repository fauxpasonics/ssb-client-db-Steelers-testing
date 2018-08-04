SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [src].[vw_TM_PaySchdPayment]
AS

/*
EXEC [dbo].[SSBHashFieldSyntaxZF] 'ods.TM_PaySchdPayment', 'id, InsertDate, UpdateDate, HashKey', ''
*/

SELECT payment_Schedule_id, payment_number, due_date, percent_due, payment_description, SourceFileName
, HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(VARCHAR(25),due_date)),'DBNULL_DATETIME') + ISNULL(RTRIM(payment_description),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),payment_number)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),payment_Schedule_id)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(VARCHAR(25),percent_due)),'DBNULL_NUMBER') + ISNULL(RTRIM(SourceFileName),'DBNULL_TEXT')) HashKey
FROM (
	SELECT ISNULL(TRY_CAST(payment_Schedule_id AS INT),0) payment_Schedule_id, ISNULL(TRY_CAST(payment_number AS INT),0) payment_number, TRY_CAST(due_date AS DATETIME) due_date, ISNULL(TRY_CAST(percent_due AS DECIMAL(18,6)),0) percent_due, payment_description, SourceFileName
	, ROW_NUMBER() OVER(PARTITION BY payment_Schedule_id, payment_number ORDER BY due_date) AS MergeRank
  FROM [src].TM_PaySchdPayment
) a 
WHERE MergeRank = 1



GO
