SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [etl].[TM_LoadDims]
AS
BEGIN

	--SELECT GETDATE()

	DECLARE @BatchId INT = 0;
	DECLARE @ExecutionId uniqueidentifier = newid();
	DECLARE @ProcedureName nvarchar(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
	DECLARE @LogEventDefault NVARCHAR(255) = 'Processing Status'

	EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Dim Load', @LogEventDefault, 'Start', @ExecutionId

	EXEC [etl].[TM_LoadDimArena]
	EXEC [etl].[TM_LoadDimSeason]
	EXEC [etl].[TM_LoadDimItem]
	EXEC [etl].[TM_LoadDimEvent]	
	EXEC [etl].[TM_LoadDimPlan]
	
	EXEC [etl].[TM_LoadDimLedger] 
	EXEC [etl].[TM_LoadDimClassTM]	

	EXEC [etl].[TM_LoadDimPromo]
	EXEC [etl].[TM_LoadDimSalesCode]

	EXEC [etl].[TM_LoadDimPriceCode]
	EXEC [etl].[TM_LoadDimPriceCodeMaster] 

	EXEC [etl].[TM_LoadDimSeat]
	
--	EXEC etl.TM_LoadDimCustomer			replaced with standard load by DCH on 2018-03-20
	EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Steelers', @LoadView = 'etl.vw_Load_DimCustomer_TM', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'

	EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Dim Load', @LogEventDefault, 'Complete', @ExecutionId

END



GO
