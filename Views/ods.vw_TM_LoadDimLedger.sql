SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [ods].[vw_TM_LoadDimLedger] AS (

/*
EXEC [dbo].[SSBHashFieldSyntaxZF] 'dbo.DimLedger', 'DimLedgerId, ETL_CreatedBy, ETL_UpdatedBy, ETL_CreatedDate,	ETL_UpdatedDate, ETL_SSID, ETL_SSID_ledger_id, ETL_DeltaHashKey, LedgerClass, IsPlan, Cust_LedgerClassLineLabel, Cust_LedgerClassGroup, Cust_PaymentBucket'
*/

	SELECT *
	, HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(25),add_datetime)),'DBNULL_DATETIME') + ISNULL(RTRIM(add_user),'DBNULL_TEXT') + ISNULL(RTRIM(gl_code_payment),'DBNULL_TEXT') + ISNULL(RTRIM(gl_code_refund),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),IsActive)),'DBNULL_BIT') + ISNULL(RTRIM(LedgerCode),'DBNULL_TEXT') + ISNULL(RTRIM(LedgerName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),upd_datetime)),'DBNULL_DATETIME') + ISNULL(RTRIM(upd_user),'DBNULL_TEXT')) ETL_DeltaHashKey
	FROM (
		SELECT 			
			ledger_id ETL_SSID
			, TRY_CAST(ledger_id AS int) ETL_SSID_ledger_id			
			, CAST(Ledger_Code AS NVARCHAR(255)) LedgerCode
			, CAST(ledger_name AS NVARCHAR(255)) LedgerName
			, CAST(CASE WHEN active = 'N' THEN 0 ELSE 1 END AS NVARCHAR(255)) IsActive
			, CAST(gl_code_payment AS NVARCHAR(255)) gl_code_payment
			, CAST(gl_code_refund AS NVARCHAR(255)) gl_code_refund
			, CAST(add_user AS NVARCHAR(255)) add_user
			, CAST(add_datetime AS DATETIME) add_datetime
			, CAST(upd_user AS NVARCHAR(255)) upd_user
			, CAST(upd_datetime AS INT) upd_datetime				
			
		FROM ods.TM_Ledger
	
	) a

)



GO
