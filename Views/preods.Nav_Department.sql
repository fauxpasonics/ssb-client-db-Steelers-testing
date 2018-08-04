SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [preods].[Nav_Department]
AS
 
SELECT DISTINCT
    CONVERT(VARCHAR(10),[Code]) [Code_K]
   ,CONVERT(VARCHAR(50),[Description]) [Description]
FROM [src].[Nav_Department] WITH (NOLOCK)
GO
