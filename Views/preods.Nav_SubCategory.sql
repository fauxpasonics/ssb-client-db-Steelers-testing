SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [preods].[Nav_SubCategory]
AS
 
SELECT DISTINCT
    CONVERT(INT,[ItemCategoryCode]) [ItemCategoryCode]
   ,CONVERT(INT,[Code]) [Code_K]
   ,CONVERT(VARCHAR(200),[Description]) [Description]
   ,CONVERT(INT,[DivisionCode]) [DivisionCode]
FROM [src].[Nav_SubCategory] WITH (NOLOCK)
GO
