SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [etl].[TM_LoadDimLedger]

as
BEGIN

DECLARE @RunTime datetime = getdate()

MERGE dbo.DimLedger AS myTarget

USING (Select * from ods.vw_TM_LoadDimLedger) as mysource
     
	 ON mysource.ETL_SSID_ledger_id = myTarget.ETL_SSID_ledger_id
    
WHEN MATCHED AND isnull(mySource.ETL_DeltaHashKey,-1) <> isnull(myTarget.ETL_DeltaHashKey, -1)

THEN UPDATE SET 

	myTarget.ETL_UpdatedBy = 'CI'
	, myTarget.ETL_UpdatedDate = @RunTime
	, myTarget.ETL_DeltaHashKey = mySource.ETL_DeltaHashKey

	, myTarget.LedgerCode = mysource.LedgerCode
	, myTarget.LedgerName = mysource.LedgerName
	, myTarget.IsActive = mysource.IsActive
	, myTarget.gl_code_payment = mysource.gl_code_payment
	, myTarget.gl_code_refund = mysource.gl_code_refund
	, myTarget.add_user = mysource.add_user
	, myTarget.add_datetime = mysource.add_datetime
	, myTarget.upd_user = mysource.upd_user
	, myTarget.upd_datetime = mysource.upd_datetime

	WHEN NOT MATCHED BY TARGET THEN 
	INSERT (ETL_CreatedBy, ETL_UpdatedBy, ETL_CreatedDate, ETL_UpdatedDate, ETL_SSID, ETL_SSID_ledger_id, ETL_DeltaHashKey, LedgerCode, LedgerName, IsActive, gl_code_payment, gl_code_refund, add_user, add_datetime, upd_user, upd_datetime)
	VALUES (
		'CI' --ETL_CreatedBy
		, 'CI' --ETL_UpdatedBy
		, GETDATE() --ETL_CreatedDate
		, GETDATE() --ETL_UpdatedDate
		, mySource.ETL_SSID --ETL_SSID
		, mySource.ETL_SSID_ledger_id --ETL_SSID_class_id
		, mySource.ETL_DeltaHashKey --ETL_DeltaHashKey

		, mysource.LedgerCode
		, mysource.LedgerName
		, mysource.IsActive
		, mysource.gl_code_payment
		, mysource.gl_code_refund
		, mysource.add_user
		, mysource.add_datetime
		, mysource.upd_user
		, mysource.upd_datetime

    );


END

GO
