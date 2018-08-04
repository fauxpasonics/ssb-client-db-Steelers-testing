SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [rpt].[SourceTableLastUpdated] AS

DECLARE @SQL NVARCHAR(MAX) = (SELECT STUFF(  (SELECT 'UNION ALL Select ''' + c.table_schema + '.' + c.table_name + ''' TableName, MAX(' + column_name + ') MaxUpdatedDate FROM ' + c.table_schema + '.' + c.table_name + '(NOLOCK)' + Char(10)
											  FROM information_schema.columns c
											  	JOIN information_schema.tables t on c.table_schema = t.table_schema
											  									    AND  c.table_name = t.table_name
											  where column_name = 'ETL_UpdatedDate' 
											  	   and table_type = 'base table'
											  	   and t.table_schema = 'ods'
											  FOR XML PATH('')),1,10,'')
											   
											   + char(10) + 
											   'ORDER BY MaxUpdatedDate'
										 )


exec sp_executesql @SQL
GO
