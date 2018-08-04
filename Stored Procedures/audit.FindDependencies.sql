SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [audit].[FindDependencies] (@ObjectName VARCHAR(200))
AS




SELECT ObjectTypes.*
FROM (
	  select CONCAT(s.name,'.',o.name) ObjectName, o.type_desc ObjectType
	  from sys.objects o
	  	  JOIN sys.schemas s on s.schema_id = o.schema_id
	 )ObjectTypes
	JOIN (SELECT DISTINCT CONCAT(referenced_schema_name,'.', referenced_entity_name) ObjectName
		  FROM sys.dm_sql_referenced_entities (@ObjectName, 'OBJECT')
		  )TranslatorDependencies on TranslatorDependencies.ObjectName = ObjectTypes.ObjectName
ORDER BY ObjectType

GO
