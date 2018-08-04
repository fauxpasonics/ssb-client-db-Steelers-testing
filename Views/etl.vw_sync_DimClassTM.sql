SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_sync_DimClassTM] AS (
	SELECT [DimClassTMId]
     ,[ETL_CreatedBy]
     ,[ETL_UpdatedBy]
     ,[ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_SSID]
     ,[ETL_SSID_class_id]
     ,[ETL_DeltaHashKey]
	 ,[ETL_SourceSystem]
     ,[ClassName]
     ,[ClassCategory]
     ,[ClassType]
     ,[IsKill]
     ,[DistStatus]
     ,[DistName]
     ,[upd_user]
     ,[upd_datetime]
     ,[matrix_char]
     ,[color]
     ,[return_class_id]
     ,[valid_for_reclass]
     ,[dist_ett]
     ,[ism_class_id]
     ,[qualifier_state_names]
     ,[system_class]
     ,[qualifier_template]
     ,[unsold_type]
     ,[unsold_qual_id]
     ,[attrib_type]
     ,[attrib_code]
     FROM dbo.DimClassTM (NOLOCK)
)
GO
