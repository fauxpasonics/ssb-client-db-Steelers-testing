SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [ods].[LoadClass]
(
	@BatchId bigint = 0,
	@Options nvarchar(MAX) = null
)
as
BEGIN

--SET NOCOUNT ON;
	/*
	Log Level value optionally specified in the @Options parameter, if not provided set to 3
	Log Level 1 = Error Logging, 2 = Error + Warnings, 3 = Error + Warnings + Info, 0 = None(use for dev only)

	Optionally can disable merge crud options with true value for (DisableInsert, DisableUpdate, DisableDelete)
	*/
	
	DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.TM_arena),'0');	

	/*Set ExecutionId to new guid to group log records together*/
	DECLARE @ExecutionId uniqueidentifier = newid();
	DECLARE @ProcedureName nvarchar(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);

	/*Load Options into a temp table*/
	SELECT Col1 AS OptionKey, Col2 as OptionValue INTO #Options FROM [dbo].[SplitMultiColumn](@Options, '=', ';')

	/*Extract Options, default values set if the option is not specified*/
	DECLARE @LogLevel int = ISNULL((SELECT TRY_PARSE(OptionValue as int) FROM #Options WHERE OptionKey = 'LogLevel'),3)
	DECLARE @DisableInsert nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableInsert'),'false')
	DECLARE @DisableUpdate nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableUpdate'),'false')
	DECLARE @DisableDelete nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableDelete'),'false')


	if (@LogLevel >= 3)
	begin 
		EXEC etl.LogEventRecord @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Start', 'Starting Merge Load', @ExecutionId
		EXEC etl.LogEventRecord @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId
	END	

	/*Put all merge logic inside of try block*/
	BEGIN TRY

	DECLARE @RunTime datetime = GETDATE();

MERGE ods.TM_Class AS myTarget

USING (SELECT * FROM [src].[vw_TM_Class]) mySource

     ON mySource.[class_id] = myTarget.[class_id]

WHEN MATCHED AND @DisableUpdate = 'false' AND mySource.HashKey <> myTarget.HashKey

THEN UPDATE SET 

	myTarget.UpdateDate = @RunTime
	, myTarget.SourceFileName = mySource.SourceFileName
	, myTarget.HashKey = mySource.HashKey

	, myTarget.class_id = mySource.class_id
	, myTarget.name = mySource.name
	, myTarget.upd_user = mySource.upd_user
	, myTarget.upd_datetime = mySource.upd_datetime
	, myTarget.matrix_char = mySource.matrix_char
	, myTarget.color = mySource.color
	, myTarget.return_class_id = mySource.return_class_id
	, myTarget.killed = mySource.killed
	, myTarget.valid_for_reclass = mySource.valid_for_reclass
	, myTarget.dist_status = mySource.dist_status
	, myTarget.dist_name = mySource.dist_name
	, myTarget.dist_ett = mySource.dist_ett
	, myTarget.ism_class_id = mySource.ism_class_id
	, myTarget.qualifier_state_names = mySource.qualifier_state_names
	, myTarget.system_class = mySource.system_class
	, myTarget.qualifier_template = mySource.qualifier_template
	, myTarget.unsold_type = mySource.unsold_type
	, myTarget.unsold_qual_id = mySource.unsold_qual_id
	, myTarget.attrib_type = mySource.attrib_type
	, myTarget.attrib_code = mySource.attrib_code

WHEN NOT MATCHED BY Target AND @DisableInsert<> 'true' THEN
INSERT (InsertDate, UpdateDate, SourceFileName, HashKey, class_id, name, upd_user, upd_datetime, matrix_char, color, return_class_id, killed, valid_for_reclass, dist_status, dist_name, dist_ett, ism_class_id, qualifier_state_names, system_class, qualifier_template, unsold_type, unsold_qual_id, attrib_type, attrib_code)
    VALUES (
		@RunTime
		, @RunTime
		, mySource.SourceFileName
		, mySource.[HashKey]

		, mySource.class_id
		, mySource.name
		, mySource.upd_user
		, mySource.upd_datetime
		, mySource.matrix_char
		, mySource.color
		, mySource.return_class_id
		, mySource.killed
		, mySource.valid_for_reclass
		, mySource.dist_status
		, mySource.dist_name
		, mySource.dist_ett
		, mySource.ism_class_id
		, mySource.qualifier_state_names
		, mySource.system_class
		, mySource.qualifier_template
		, mySource.unsold_type
		, mySource.unsold_qual_id
		, mySource.attrib_type
		, mySource.attrib_code	

    );

		END TRY

	BEGIN CATCH 
		/*Log Error*/
		if (@LogLevel >= 1)
		begin 
			DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
			DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
			DECLARE @ErrorState INT = ERROR_STATE();
			
			if (@LogLevel >= 1)
			begin
				EXEC etl.LogEventRecord @Batchid, 'Error', @ProcedureName, 'Merge Load', 'Merge Error', @ErrorMessage, @ExecutionId
			end 
			if (@LogLevel >= 3)
			begin 
				EXEC etl.LogEventRecord @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Complete', 'Completed Merge Load', @ExecutionId
			END

			RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

		END
	END CATCH

	if (@LogLevel >= 3)
	begin 
		EXEC etl.LogEventRecord @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Complete', 'Completed Merge Load', @ExecutionId
	END

END





GO
