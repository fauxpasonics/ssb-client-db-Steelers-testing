SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [src].[vw_TM_Class]
AS

/*
EXEC [dbo].[SSBHashFieldSyntaxZF] 'ods.tm_Class', 'id, InsertDate, UpdateDate, HashKey', ''
*/

SELECT SourceFileName, class_id, name, upd_user, upd_datetime, matrix_char, color, return_class_id, killed, valid_for_reclass, dist_status, dist_name, dist_ett, ism_class_id, qualifier_state_names, system_class, qualifier_template, unsold_type, unsold_qual_id, attrib_type, attrib_code
, HASHBYTES('sha2_256', ISNULL(RTRIM(attrib_code),'DBNULL_TEXT') + ISNULL(RTRIM(attrib_type),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),class_id)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),color)),'DBNULL_INT') + ISNULL(RTRIM(dist_ett),'DBNULL_TEXT') + ISNULL(RTRIM(dist_name),'DBNULL_TEXT') + ISNULL(RTRIM(dist_status),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),ism_class_id)),'DBNULL_INT') + ISNULL(RTRIM(killed),'DBNULL_TEXT') + ISNULL(RTRIM(matrix_char),'DBNULL_TEXT') + ISNULL(RTRIM(name),'DBNULL_TEXT') + ISNULL(RTRIM(qualifier_state_names),'DBNULL_TEXT') + ISNULL(RTRIM(qualifier_template),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),return_class_id)),'DBNULL_INT') + ISNULL(RTRIM(SourceFileName),'DBNULL_TEXT') + ISNULL(RTRIM(system_class),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),unsold_qual_id)),'DBNULL_INT') + ISNULL(RTRIM(unsold_type),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),upd_datetime)),'DBNULL_DATETIME') + ISNULL(RTRIM(upd_user),'DBNULL_TEXT') + ISNULL(RTRIM(valid_for_reclass),'DBNULL_TEXT')) HashKey
FROM (
	SELECT SourceFileName, ISNULL(TRY_CAST(class_id AS int),0) class_id, name, upd_user, TRY_CAST(upd_datetime AS datetime) upd_datetime, matrix_char, ISNULL(TRY_CAST(color AS int),0) color, ISNULL(TRY_CAST(return_class_id AS int),0) return_class_id, killed, valid_for_reclass, dist_status, dist_name, dist_ett, ISNULL(TRY_CAST(ism_class_id AS int),0) ism_class_id, qualifier_state_names, system_class, qualifier_template, unsold_type, ISNULL(TRY_CAST(unsold_qual_id AS int),0) unsold_qual_id, attrib_type, attrib_code
	, ROW_NUMBER() OVER(PARTITION BY class_id ORDER BY upd_datetime desc) AS MergeRank
  FROM [src].[TM_Class]
) a 
WHERE MergeRank = 1




GO
