SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[TM_LoadDimClassTM]

as
BEGIN

	DECLARE @RunTime datetime = GETDATE();

	MERGE dbo.DimClassTM AS myTarget

	USING (select * from ods.vw_TM_LoadDimClassTM) as mySource
     ON
		myTarget.ETL_SSID_class_id = mySource.ETL_SSID_class_id

	WHEN MATCHED AND isnull(mySource.ETL_DeltaHashKey,-1) <> isnull(myTarget.ETL_DeltaHashKey, -1)

	THEN UPDATE SET 

		myTarget.ETL_UpdatedBy = 'CI'
		, myTarget.ETL_UpdatedDate = @RunTime
		, myTarget.ETL_SourceSystem = 'TM'
		, myTarget.ETL_DeltaHashKey = mySource.ETL_DeltaHashKey

		, myTarget.ClassName = mySource.ClassName
		, myTarget.IsKill = mySource.IsKill
		, myTarget.DistStatus = mySource.DistStatus
		, myTarget.DistName = mySource.DistName
		, myTarget.upd_user = mySource.upd_user
		, myTarget.upd_datetime = mySource.upd_datetime
		, myTarget.matrix_char = mySource.matrix_char
		, myTarget.color = mySource.color
		, myTarget.return_class_id = mySource.return_class_id
		, myTarget.valid_for_reclass = mySource.valid_for_reclass
		, myTarget.dist_ett = mySource.dist_ett
		, myTarget.ism_class_id = mySource.ism_class_id
		, myTarget.qualifier_state_names = mySource.qualifier_state_names
		, myTarget.system_class = mySource.system_class
		, myTarget.qualifier_template = mySource.qualifier_template
		, myTarget.unsold_type = mySource.unsold_type
		, myTarget.unsold_qual_id = mySource.unsold_qual_id
		, myTarget.attrib_type = mySource.attrib_type
		, myTarget.attrib_code = mySource.attrib_code



	WHEN NOT MATCHED BY Target THEN
	INSERT (ETL_CreatedBy, ETL_UpdatedBy, ETL_CreatedDate, ETL_UpdatedDate, ETL_SourceSystem, ETL_SSID, ETL_SSID_class_id, ETL_DeltaHashKey, ClassName, IsKill, DistStatus, DistName, upd_user, upd_datetime, matrix_char, color, return_class_id, valid_for_reclass, dist_ett, ism_class_id, qualifier_state_names, system_class, qualifier_template, unsold_type, unsold_qual_id, attrib_type, attrib_code)
	VALUES (

		'CI'--ETL_CreatedBy
		, 'CI'--ETL_UpdatedBy
		, GETDATE()--ETL_CreatedDate
		, GETDATE()--ETL_UpdatedDate
		, mySource.ETL_SourceSystem--ETL_SourceSystem
		, mySource.ETL_SSID--ETL_SSID
		, mySource.ETL_SSID_class_id--ETL_SSID_class_id
		, mySource.ETL_DeltaHashKey--ETL_DeltaHashKey

		, mySource.ClassName
		, mySource.IsKill
		, mySource.DistStatus
		, mySource.DistName
		, mySource.upd_user
		, mySource.upd_datetime
		, mySource.matrix_char
		, mySource.color
		, mySource.return_class_id
		, mySource.valid_for_reclass
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
		

END






GO
