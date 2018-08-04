SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [preods].[Nav_SalesLine]
AS
 
SELECT DISTINCT
    CONVERT(VARCHAR(20),[DocumentNo]) [DocumentNo_K]
   ,CONVERT(INT,[LineNo]) [LineNo_K]
   ,CONVERT(VARCHAR(20),[No]) [ItemNo]
   ,CONVERT(VARCHAR(200),[Description]) [Description]
   ,CONVERT(INT,[Quantity]) [Quantity]
   ,CONVERT(NUMERIC(18,2),[UnitPrice]) [UnitPrice]
   ,CONVERT(NUMERIC(18,2),[LineDiscountPercent]) [LineDiscountPercent]
   ,CONVERT(NUMERIC(18,2),[LineDiscountAmount]) [LineDiscountAmount]
   ,CONVERT(NUMERIC(18,2),[Amount]) [Amount]
   ,CONVERT(NUMERIC(18,2),[AmountIncludingTax]) [AmountIncludingTax]
   ,CONVERT(BIT,[DropShipment]) [DropShipment]
   ,CONVERT(BIT,[TaxLiable]) [TaxLiable]
   ,CONVERT(NUMERIC(18,2),[LineAmount]) [LineAmount]
   ,CONVERT(VARCHAR(20),[VariantCode]) [VariantCode]
   ,CONVERT(VARCHAR(20),[Category]) [Category]
   ,CONVERT(VARCHAR(20),[SubCategory]) [SubCategory]
   ,CONVERT(VARCHAR(50),[AppliedRuleIDs]) [AppliedRuleIDs]
   ,CONVERT(VARCHAR(50),[DepartmentDescription]) [DepartmentDescription]
   ,CONVERT(VARCHAR(50),[CategoryDescription]) [CategoryDescription]
   ,CONVERT(VARCHAR(50),[SubCategoryDescription]) [SubCategoryDescription]
   ,CONVERT(VARCHAR(50),[Department]) [Department]
FROM [src].[Nav_SalesLine] WITH (NOLOCK)
GO
