SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [ods].[vw_TM_LoadDimClassTM] AS (

/*
EXEC [dbo].[SSBHashFieldSyntaxZF] 'dbo.DimClassTM', 'DimClassTMId, ETL_CreatedBy, ETL_UpdatedBy, ETL_CreatedDate, ETL_UpdatedDate, ETL_SourceSystem, ETL_SSID, ETL_SSID_class_id, ETL_DeltaHashKey, ClassCategory, ClassType', ''
*/

	SELECT *
	, HASHBYTES('sha2_256', ISNULL(RTRIM(attrib_code),'DBNULL_TEXT') + ISNULL(RTRIM(attrib_type),'DBNULL_TEXT') + ISNULL(RTRIM(ClassName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),color)),'DBNULL_INT') + ISNULL(RTRIM(dist_ett),'DBNULL_TEXT') + ISNULL(RTRIM(DistName),'DBNULL_TEXT') + ISNULL(RTRIM(DistStatus),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),IsKill)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),ism_class_id)),'DBNULL_INT') + ISNULL(RTRIM(matrix_char),'DBNULL_TEXT') + ISNULL(RTRIM(qualifier_state_names),'DBNULL_TEXT') + ISNULL(RTRIM(qualifier_template),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),return_class_id)),'DBNULL_INT') + ISNULL(RTRIM(system_class),'DBNULL_TEXT') + ISNULL(RTRIM(unsold_qual_id),'DBNULL_TEXT') + ISNULL(RTRIM(unsold_type),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(25),upd_datetime)),'DBNULL_DATETIME') + ISNULL(RTRIM(upd_user),'DBNULL_TEXT') + ISNULL(RTRIM(valid_for_reclass),'DBNULL_TEXT')) ETL_DeltaHashKey
	FROM (
			
		SELECT 
			CAST(class_id AS NVARCHAR(255)) ETL_SSID
			, CAST(class_id AS INT) ETL_SSID_class_id
			, CAST(name AS NVARCHAR(255)) ClassName
			, CAST(CASE WHEN killed = 'Y' THEN 1 ELSE 0 END AS BIT) IsKill
			, CAST(dist_status AS NVARCHAR(255)) DistStatus
			, CAST(dist_name AS NVARCHAR(255)) DistName		
		
			, CAST(upd_user AS NVARCHAR(255)) upd_user
			, CAST(upd_datetime AS DATETIME) upd_datetime
			, CAST(matrix_char AS NVARCHAR(255)) matrix_char
			, CAST(color AS INT) color
			, CAST(return_class_id AS INT) return_class_id		
			, CAST(valid_for_reclass AS NVARCHAR(255)) valid_for_reclass
			, CAST(dist_ett AS NVARCHAR(255)) dist_ett
			, CAST(ism_class_id AS INT) ism_class_id
			, CAST(qualifier_state_names AS NVARCHAR(255)) qualifier_state_names
			, CAST(system_class AS NVARCHAR(255)) system_class
			, CAST(qualifier_template AS NVARCHAR(255)) qualifier_template
			, CAST(unsold_type AS NVARCHAR(255)) unsold_type
			, CAST(unsold_qual_id AS INT) unsold_qual_id
			, CAST(attrib_type AS NVARCHAR(255)) attrib_type
			, CAST(attrib_code AS NVARCHAR(255)) attrib_code			
			, CAST((SELECT etl.fnGetClientSetting('TM-SourceStyem')) AS NVARCHAR(255)) ETL_SourceSystem

		FROM ods.TM_Class
	
	) a

)






GO
