SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_sync_DimLedger] AS (
	SELECT [DimLedgerId]
     ,[ETL_CreatedBy]
     ,[ETL_UpdatedBy]
     ,[ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_SSID]
     ,[ETL_SSID_ledger_id]
     ,[ETL_DeltaHashKey]
     ,[ETL_SourceSystem]
     ,[LedgerCode]
     ,[LedgerName]
     ,[LedgerClass]
     ,[IsActive]
     ,[gl_code_payment]
     ,[gl_code_refund]
     ,[add_user]
     ,[add_datetime]
     ,[upd_user]
     ,[upd_datetime]
     FROM dbo.DimLedger (NOLOCK)
)
GO
