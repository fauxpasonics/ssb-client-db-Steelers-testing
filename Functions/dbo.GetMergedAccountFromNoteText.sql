SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetMergedAccountFromNoteText]
(
	@Input AS nvarchar(max)
) 
RETURNS TABLE
AS	
	RETURN SELECT TRY_PARSE(LEFT(REPLACE(@Input, 'Merged account ', ''), CHARINDEX(' ', REPLACE(@Input, 'Merged account ', '')) - 1) AS int) MergedAccount
GO
