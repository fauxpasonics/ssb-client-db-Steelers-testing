SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE PROCEDURE [dbo].[GetColumnNamesAndTypes](@table BIT, @schema VARCHAR(20), @Name VARCHAR(100))
AS

BEGIN

DECLARE @TableType varchar(10) = (SELECT CASE WHEN @table = 1 THEN 'tables' ELSE 'views' END )
DECLARE @sql NVARCHAR(MAX)


SET @sql = CONCAT('SELECT c.name AS ColumnName, types.name AS DataType
				   FROM sys.', @TableType, ' t
						JOIN sys.columns c ON c.object_id = t.object_id
						JOIN sys.schemas s ON s.schema_id = t.schema_id
						JOIN sys.types types ON types.user_type_id = c.user_type_id
				   WHERE s.name = ''',@schema,'''',
						 'AND t.name = ''',@Name,'''')


EXECUTE sys.sp_executesql @sql
    


END


GO
