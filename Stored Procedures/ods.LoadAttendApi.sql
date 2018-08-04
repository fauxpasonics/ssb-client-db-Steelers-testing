SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [ods].[LoadAttendApi]
(
	@BatchId INT = 0,
	@Options NVARCHAR(MAX) = null
)
AS 

BEGIN
/**************************************Comments***************************************
**************************************************************************************
Mod #:  1
Name:     dbo
Date:     12/19/2016
Comments: Initial creation
*************************************************************************************/

DECLARE @RunTime DATETIME = GETDATE()

DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @ProcedureName nvarchar(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.TM_AttendApi),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0'

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Start', @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src DataSize', @SrcDataSize, @ExecutionId


SELECT CAST(NULL AS BINARY(32)) ETL__DeltaHashKey, a.ETL__ID, a.section_id, a.access_type, a.ticket_type, a.seat_num, a.event_name, a.valid, a.seq_num, a.section_name, a.plan_event_Id, a.action_time,
       a.scan_type, a.event_date, a.print_count, a.gate, a.mobile, a.event_id, a.source_system, a.result_code, a.channel_ind, a.comp, a.result_type,
       a.plan_event_name, a.row_id, a.price_code, a.acct_id, a.ticket_acct_id, a.row_name
INTO #SrcData
FROM (
	SELECT ETL__ID, section_id, access_type, ticket_type, seat_num, event_name, valid, seq_num, section_name, plan_event_Id, action_time, scan_type, event_date,
		   print_count, gate, mobile, event_id, source_system, result_code, channel_ind, comp, result_type, plan_event_name, row_id, price_code, acct_id,
		   ticket_acct_id, row_name
		   , ROW_NUMBER() OVER(PARTITION BY event_id, section_id, row_id, seat_num, result_code ORDER BY CAST(seq_num AS INT) DESC) RowRank 
	FROM src.TM_AttendApi
) a
WHERE a.RowRank = 1


EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL__DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(access_type),'DBNULL_TEXT') + ISNULL(RTRIM(acct_id),'DBNULL_TEXT') + ISNULL(RTRIM(action_time),'DBNULL_TEXT') + ISNULL(RTRIM(channel_ind),'DBNULL_TEXT') + ISNULL(RTRIM(comp),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),ETL__ID)),'DBNULL_INT') + ISNULL(RTRIM(event_date),'DBNULL_TEXT') + ISNULL(RTRIM(event_id),'DBNULL_TEXT') + ISNULL(RTRIM(event_name),'DBNULL_TEXT') + ISNULL(RTRIM(gate),'DBNULL_TEXT') + ISNULL(RTRIM(mobile),'DBNULL_TEXT') + ISNULL(RTRIM(plan_event_Id),'DBNULL_TEXT') + ISNULL(RTRIM(plan_event_name),'DBNULL_TEXT') + ISNULL(RTRIM(price_code),'DBNULL_TEXT') + ISNULL(RTRIM(print_count),'DBNULL_TEXT') + ISNULL(RTRIM(result_code),'DBNULL_TEXT') + ISNULL(RTRIM(result_type),'DBNULL_TEXT') + ISNULL(RTRIM(row_id),'DBNULL_TEXT') + ISNULL(RTRIM(row_name),'DBNULL_TEXT') + ISNULL(RTRIM(scan_type),'DBNULL_TEXT') + ISNULL(RTRIM(seat_num),'DBNULL_TEXT') + ISNULL(RTRIM(section_id),'DBNULL_TEXT') + ISNULL(RTRIM(section_name),'DBNULL_TEXT') + ISNULL(RTRIM(seq_num),'DBNULL_TEXT') + ISNULL(RTRIM(source_system),'DBNULL_TEXT') + ISNULL(RTRIM(ticket_acct_id),'DBNULL_TEXT') + ISNULL(RTRIM(ticket_type),'DBNULL_TEXT') + ISNULL(RTRIM(valid),'DBNULL_TEXT'))

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (event_id, section_id, row_id, seat_num, result_code)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL__DeltaHashKey)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE ods.TM_AttendApi AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.event_id = mySource.event_id and myTarget.section_id = mySource.section_id and myTarget.row_id = mySource.row_id and myTarget.seat_num = mySource.seat_num and myTarget.result_code = mySource.result_code

WHEN MATCHED AND (
     ISNULL(mySource.ETL__DeltaHashKey,-1) <> ISNULL(myTarget.ETL__DeltaHashKey, -1)	 
)
THEN UPDATE SET
	
	myTarget.ETL__UpdatedDate = GETDATE()
	,myTarget.ETL__DeltaHashKey = mySource.ETL__DeltaHashKey
     ,myTarget.[section_id] = mySource.[section_id]
     ,myTarget.[access_type] = mySource.[access_type]
     ,myTarget.[ticket_type] = mySource.[ticket_type]
     ,myTarget.[seat_num] = mySource.[seat_num]
     ,myTarget.[event_name] = mySource.[event_name]
     ,myTarget.[valid] = mySource.[valid]
     ,myTarget.[seq_num] = mySource.[seq_num]
     ,myTarget.[section_name] = mySource.[section_name]
     ,myTarget.[plan_event_Id] = mySource.[plan_event_Id]
     ,myTarget.[action_time] = mySource.[action_time]
     ,myTarget.[scan_type] = mySource.[scan_type]
     ,myTarget.[event_date] = mySource.[event_date]
     ,myTarget.[print_count] = mySource.[print_count]
     ,myTarget.[gate] = mySource.[gate]
     ,myTarget.[mobile] = mySource.[mobile]
     ,myTarget.[event_id] = mySource.[event_id]
     ,myTarget.[source_system] = mySource.[source_system]
     ,myTarget.[result_code] = mySource.[result_code]
     ,myTarget.[channel_ind] = mySource.[channel_ind]
     ,myTarget.[comp] = mySource.[comp]
     ,myTarget.[result_type] = mySource.[result_type]
     ,myTarget.[plan_event_name] = mySource.[plan_event_name]
     ,myTarget.[row_id] = mySource.[row_id]
     ,myTarget.[price_code] = mySource.[price_code]
     ,myTarget.[acct_id] = mySource.[acct_id]
     ,myTarget.[ticket_acct_id] = mySource.[ticket_acct_id]
     ,myTarget.[row_name] = mySource.[row_name]
     
WHEN NOT MATCHED BY Target
THEN INSERT
     (
     [ETL__CreatedDate]
     ,[ETL__UpdatedDate]
     ,[ETL__DeltaHashKey]
     ,[section_id]
     ,[access_type]
     ,[ticket_type]
     ,[seat_num]
     ,[event_name]
     ,[valid]
     ,[seq_num]
     ,[section_name]
     ,[plan_event_Id]
     ,[action_time]
     ,[scan_type]
     ,[event_date]
     ,[print_count]
     ,[gate]
     ,[mobile]
     ,[event_id]
     ,[source_system]
     ,[result_code]
     ,[channel_ind]
     ,[comp]
     ,[result_type]
     ,[plan_event_name]
     ,[row_id]
     ,[price_code]
     ,[acct_id]
     ,[ticket_acct_id]
     ,[row_name]
     )
VALUES
     (@RunTime --ETL__CreatedDate
     ,@RunTime --ETL__UpdateddDate
     ,mySource.ETL__DeltaHashKey
     ,mySource.[section_id]
     ,mySource.[access_type]
     ,mySource.[ticket_type]
     ,mySource.[seat_num]
     ,mySource.[event_name]
     ,mySource.[valid]
     ,mySource.[seq_num]
     ,mySource.[section_name]
     ,mySource.[plan_event_Id]
     ,mySource.[action_time]
     ,mySource.[scan_type]
     ,mySource.[event_date]
     ,mySource.[print_count]
     ,mySource.[gate]
     ,mySource.[mobile]
     ,mySource.[event_id]
     ,mySource.[source_system]
     ,mySource.[result_code]
     ,mySource.[channel_ind]
     ,mySource.[comp]
     ,mySource.[result_type]
     ,mySource.[plan_event_name]
     ,mySource.[row_id]
     ,mySource.[price_code]
     ,mySource.[acct_id]
     ,mySource.[ticket_acct_id]
     ,mySource.[row_name]
     )
;

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Complete', @ExecutionId

DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.TM_AttendApi WHERE ETL__CreatedDate >= @RunTime AND ETL__UpdatedDate = ETL__CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.TM_AttendApi WHERE ETL__UpdatedDate >= @RunTime AND ETL__UpdatedDate > ETL__CreatedDate),'0');	

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Insert Row Count', @MergeInsertRowCount, @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Update Row Count', @MergeUpdateRowCount, @ExecutionId


END TRY 
BEGIN CATCH 

	DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();
			
	PRINT @ErrorMessage
	EXEC etl.LogEventRecordDB @Batchid, 'Error', @ProcedureName, 'Merge Load', 'Merge Error', @ErrorMessage, @ExecutionId
	EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Complete', @ExecutionId

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Complete', @ExecutionId


END




GO
