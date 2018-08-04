SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

 
CREATE PROC [etl].[JSON_Translator_Monitoring]
AS
 
DECLARE @SQL NVARCHAR(MAX) = ''
 
SELECT @SQL += a
FROM
    (
    SELECT DISTINCT '
    SELECT ''[' + s.name + '].[' + t.name + ']'' TableName,SUM(CASE WHEN IsLoaded = 1 THEN 1 ELSE 0 END) TotalCount,SUM(CASE WHEN IsLoaded = 0 THEN 1 ELSE 0 END) TotalCountToLoad FROM [' + s.name + '].[' + t.name + '] WITH (NOLOCK)
    UNION ALL' a
    FROM sys.columns c
        JOIN sys.tables t ON c.object_Id = t.object_Id
        JOIN sys.schemas s ON t.schema_Id = s.schema_Id
    WHERE c.name = 'IsLoaded' AND t.name NOT LIKE '%_bkp%'
    ) a
 
SET @SQL = LEFT(@SQL,LEN(@SQL)-11)
 
PRINT @SQL
 
IF OBJECT_ID('tempdb..#New','U') IS NOT NULL DROP TABLE #New
CREATE TABLE #New (TableName NVARCHAR(100), TotalCount INT, TotalCountToLoad INT)
INSERT INTO #New
EXEC (@SQL)
 
SELECT
    GETDATE() AsOf
    ,n.TableName
    ,n.TotalCount TotalCountLoaded
    ,TotalCountToLoad
    , ISNULL(CONVERT(NVARCHAR(max),CONVERT(INT,n.TotalCount / ((NULLIF(TotalCountToLoad,0) + n.TotalCount) * 1.0) * 100)) + '%','  100%') PercentComplete
FROM #New n
 
 

GO
