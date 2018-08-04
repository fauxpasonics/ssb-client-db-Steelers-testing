SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

 
CREATE PROC [etl].[JSONTranslator_Queue]
AS
 
 
DECLARE @SQL NVARCHAR(MAX) = '
--SELECT TOP 1 *
SELECT *
FROM
    ('
 
SELECT @SQL += a
FROM
    (
    SELECT DISTINCT NEWID() SortRandomly,'
SELECT ''INSERT INTO audit.JSONTranslatorLog (SourceTable) VALUES (''''' + t.[Name] + ''''')
EXEC [etl].[JSONTranslator] @Step = ''''Run ETL'''', @StageSchema = ''''' + t.[Schema] + ''''', @TableName = ''''' + t.[Name] + ''''', @SuppressPrint = 0,@RunFullSession = 1
'' a FROM [' + t.[Schema] + '].[' + t.[Name] + '] WITH (NOLOCK) WHERE IsLoaded = 0 GROUP BY IsLoaded
UNION ALL' a
    FROM [etl].[JSON_Meta_Table_Configuration] tcon
        JOIN [etl].[JSON_Meta_Table] t ON tcon.JSON_Meta_Table_ID = t.JSON_Meta_Table_ID
    WHERE tcon.Active = 1
    ) a
 
SET @SQL = LEFT(@SQL,LEN(@SQL)-11) + '
    ) a'
 
--PRINT @SQL
DECLARE @ProcScript AS TABLE (Script NVARCHAR(MAX))
INSERT INTO @ProcScript
EXEC (@SQL)
 
SET @SQL = ''
 
SELECT @SQL += Script
FROM @ProcScript
--PRINT @SQL
 
EXEC(@SQL)

GO
