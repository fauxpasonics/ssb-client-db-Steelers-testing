SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [preods].[Nav_SalesHeader]
AS
 
SELECT DISTINCT
    CONVERT(VARCHAR(20),[No]) [No_K]
   ,CONVERT(VARCHAR(35),[YourReference]) [YourReference]
   ,CONVERT(VARCHAR(100),[ShipToName]) [ShipToName]
   ,CONVERT(VARCHAR(100),[ShipToName2]) [ShipToName2]
   ,CONVERT(VARCHAR(100),[ShipToAddress]) [ShipToAddress]
   ,CONVERT(VARCHAR(100),[ShipToAddress2]) [ShipToAddress2]
   ,CONVERT(VARCHAR(50),[ShipToCity]) [ShipToCity]
   ,CONVERT(VARCHAR(50),[ShipToContact]) [ShipToContact]
   ,CONVERT(DATETIME,[OrderDate]) [OrderDate]
   ,CONVERT(DATETIME,[ShipmentDate]) [ShipmentDate]
   ,CONVERT(VARCHAR(50),[ShipmentMethodCode]) [ShipmentMethodCode]
   ,CONVERT(VARCHAR(50),[NAVAmount]) [NAVAmount]
   ,CONVERT(VARCHAR(50),[NAVAmountIncludingVAT]) [NAVAmountIncludingVAT]
   ,CONVERT(VARCHAR(100),[SellToCustomerName]) [SellToCustomerName]
   ,CONVERT(VARCHAR(100),[SellToCustomerName2]) [SellToCustomerName2]
   ,CONVERT(VARCHAR(100),[SellToAddress]) [SellToAddress]
   ,CONVERT(VARCHAR(100),[SellToAddress2]) [SellToAddress2]
   ,CONVERT(VARCHAR(50),[SellToCity]) [SellToCity]
   ,CONVERT(VARCHAR(50),[SellToContact]) [SellToContact]
   ,CONVERT(VARCHAR(20),[SellToPostCode]) [SellToPostCode]
   ,CONVERT(VARCHAR(50),[SellToState]) [SellToState]
   ,CONVERT(VARCHAR(50),[SellToCountryRegionCode]) [SellToCountryRegionCode]
   ,CONVERT(VARCHAR(20),[ShipToPostCode]) [ShipToPostCode]
   ,CONVERT(VARCHAR(50),[ShipToState]) [ShipToState]
   ,CONVERT(VARCHAR(50),[ShipToCountryRegionCode]) [ShipToCountryRegionCode]
   ,CONVERT(VARCHAR(50),[PaymentMethodCode]) [PaymentMethodCode]
   ,CONVERT(VARCHAR(50),[ShippingAgentCode]) [ShippingAgentCode]
   ,CONVERT(VARCHAR(50),[IncrementID]) [IncrementID]
   ,CONVERT(INT,[OrderID]) [OrderID]
   ,CONVERT(VARCHAR(50),[AppliedRuleIDs]) [AppliedRuleIDs]
   ,CONVERT(VARCHAR(50),[StagingTransEntryNo]) [StagingTransEntryNo]
   ,CONVERT(INT,[CustomerGroupID]) [CustomerGroupID]
   ,CONVERT(VARCHAR(50),[EMail]) [Email]
   ,CONVERT(VARCHAR(50),[EntityNo]) [EntityNo]
   ,CONVERT(NUMERIC(18,2),[Amount]) [Amount]
   ,CONVERT(NUMERIC(18,2),[TaxAmount]) [TaxAmount]
   ,CONVERT(NUMERIC(18,2),[TotalAmount]) [TotalAmount]
   ,CONVERT(NUMERIC(18,2),[DiscountAmount]) [DiscountAmount]
   ,CONVERT(NUMERIC(18,2),[ShippingAmount]) [ShippingAmount]
FROM [src].[Nav_SalesHeader] WITH (NOLOCK)
GO
