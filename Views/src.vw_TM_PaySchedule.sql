SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [src].[vw_TM_PaySchedule]
AS

/*
EXEC [dbo].[SSBHashFieldSyntaxZF] 'ods.TM_PaySchedule', 'id, InsertDate, UpdateDate, HashKey', ''
*/

SELECT acct_id, payment_schedule_id, invoice_id, payment_plan_id, comments, add_user, add_datetime, payment_plan_name, periods, last_period_paid, purchase_amount, paid_amount, percent_due, percent_paid, compliant, invoice_desc, effective_Date, expiration_date, inet_effective_Date, inet_expiration_Date, inet_plan_name, payment_plan_type, last_payment_number, period_type, [start_date], SourceFileName
, HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(10),acct_id)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(25),add_datetime)),'DBNULL_DATETIME') + ISNULL(RTRIM(add_user),'DBNULL_TEXT') + ISNULL(RTRIM(comments),'DBNULL_TEXT') + ISNULL(RTRIM(compliant),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),effective_Date)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(25),expiration_date)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(25),inet_effective_Date)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(25),inet_expiration_Date)),'DBNULL_DATETIME') + ISNULL(RTRIM(inet_plan_name),'DBNULL_TEXT') + ISNULL(RTRIM(invoice_desc),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),invoice_id)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),last_payment_number)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),last_period_paid)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(25),paid_amount)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(10),payment_plan_id)),'DBNULL_INT') + ISNULL(RTRIM(payment_plan_name),'DBNULL_TEXT') + ISNULL(RTRIM(payment_plan_type),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),payment_schedule_id)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(25),percent_due)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),percent_paid)),'DBNULL_NUMBER') + ISNULL(RTRIM(period_type),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),periods)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(25),purchase_amount)),'DBNULL_NUMBER') + ISNULL(RTRIM(SourceFileName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),start_date)),'DBNULL_DATETIME')) HashKey
FROM (
	SELECT ISNULL(TRY_CAST(acct_id AS INT),0) acct_id, ISNULL(TRY_CAST(payment_schedule_id AS INT),0) payment_schedule_id, ISNULL(TRY_CAST(invoice_id AS INT),0) invoice_id, ISNULL(TRY_CAST(payment_plan_id AS INT),0) payment_plan_id, comments, add_user, TRY_CAST(add_datetime AS DATETIME) add_datetime, payment_plan_name, ISNULL(TRY_CAST(periods AS INT),0) periods, ISNULL(TRY_CAST(last_period_paid AS INT),0) last_period_paid, ISNULL(TRY_CAST(purchase_amount AS DECIMAL(18,6)),0) purchase_amount, ISNULL(TRY_CAST(paid_amount AS DECIMAL(18,6)),0) paid_amount, ISNULL(TRY_CAST(percent_due AS DECIMAL(18,6)),0) percent_due, ISNULL(TRY_CAST(percent_paid AS DECIMAL(18,6)),0) percent_paid, compliant, invoice_desc, TRY_CAST(effective_Date AS DATETIME) effective_Date, TRY_CAST(expiration_date AS DATETIME) expiration_date, TRY_CAST(inet_effective_Date AS DATETIME) inet_effective_Date, TRY_CAST(inet_expiration_Date AS DATETIME) inet_expiration_Date, inet_plan_name, payment_plan_type, ISNULL(TRY_CAST(last_payment_number AS INT),0) last_payment_number, period_type, TRY_CAST(start_date AS DATETIME) [start_date], SourceFileName
	, ROW_NUMBER() OVER(PARTITION BY payment_Schedule_id ORDER BY add_datetime) AS MergeRank
  FROM [src].TM_PaySchedule
) a 
WHERE MergeRank = 1



GO
