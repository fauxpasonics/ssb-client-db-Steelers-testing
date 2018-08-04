SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [preods].[Nav_Category]
AS
 
SELECT DISTINCT
    CONVERT(VARCHAR(10),[Code]) [Code_K]
   ,CONVERT(VARCHAR(50),[Description]) [Description]
   ,CONVERT(VARCHAR(10),[DivisionCode]) [DivisionCode]
FROM [src].[Nav_Category] WITH (NOLOCK)
GO
