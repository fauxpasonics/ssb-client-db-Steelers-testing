SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
-- Get the status of your table 20 minutes ago...
DECLARE @AsOfDate DATETIME = (SELECT [etl].[ConvertToLocalTime](DATEADD(MINUTE,-20,GETDATE())))
SELECT * FROM [ods].[AsOf_Nav_SalesHeader] (@AsOfDate)
*/

CREATE FUNCTION [ods].[AsOf_Nav_SalesHeader] (@AsOfDate DATETIME)

RETURNS @Results TABLE
(
[No] [varchar](20) NULL,
[YourReference] [varchar](35) NULL,
[ShipToName] [varchar](100) NULL,
[ShipToName2] [varchar](100) NULL,
[ShipToAddress] [varchar](100) NULL,
[ShipToAddress2] [varchar](100) NULL,
[ShipToCity] [varchar](50) NULL,
[ShipToContact] [varchar](50) NULL,
[OrderDate] [datetime] NULL,
[ShipmentDate] [datetime] NULL,
[ShipmentMethodCode] [varchar](50) NULL,
[NAVAmount] [varchar](50) NULL,
[NAVAmountIncludingVAT] [varchar](50) NULL,
[SellToCustomerName] [varchar](100) NULL,
[SellToCustomerName2] [varchar](100) NULL,
[SellToAddress] [varchar](100) NULL,
[SellToAddress2] [varchar](100) NULL,
[SellToCity] [varchar](50) NULL,
[SellToContact] [varchar](50) NULL,
[SellToPostCode] [varchar](20) NULL,
[SellToState] [varchar](50) NULL,
[SellToCountryRegionCode] [varchar](50) NULL,
[ShipToPostCode] [varchar](20) NULL,
[ShipToState] [varchar](50) NULL,
[ShipToCountryRegionCode] [varchar](50) NULL,
[PaymentMethodCode] [varchar](50) NULL,
[ShippingAgentCode] [varchar](50) NULL,
[IncrementID] [varchar](50) NULL,
[OrderID] [int] NULL,
[AppliedRuleIDs] [varchar](50) NULL,
[StagingTransEntryNo] [varchar](50) NULL,
[CustomerGroupID] [int] NULL,
[Email] [varchar](50) NULL,
[EntityNo] [varchar](50) NULL,
[Amount] [numeric](18, 2) NULL,
[TaxAmount] [numeric](18, 2) NULL,
[TotalAmount] [numeric](18, 2) NULL,
[DiscountAmount] [numeric](18, 2) NULL,
[ShippingAmount] [numeric](18, 2) NULL,
[ETL_CreatedOn] [datetime] NOT NULL,
[ETL_CreatedBy] NVARCHAR(400) NOT NULL,
[ETL_UpdatedOn] [datetime] NOT NULL,
[ETL_UpdatedBy] NVARCHAR(400) NOT NULL
)

AS
BEGIN

DECLARE @EndDate DATETIME = (SELECT [etl].[ConvertToLocalTime](CAST(GETDATE() AS datetime2(0))))
SET @AsOfDate = (SELECT CAST(@AsOfDate AS datetime2(0)))

INSERT INTO @Results
SELECT [No],[YourReference],[ShipToName],[ShipToName2],[ShipToAddress],[ShipToAddress2],[ShipToCity],[ShipToContact],[OrderDate],[ShipmentDate],[ShipmentMethodCode],[NAVAmount],[NAVAmountIncludingVAT],[SellToCustomerName],[SellToCustomerName2],[SellToAddress],[SellToAddress2],[SellToCity],[SellToContact],[SellToPostCode],[SellToState],[SellToCountryRegionCode],[ShipToPostCode],[ShipToState],[ShipToCountryRegionCode],[PaymentMethodCode],[ShippingAgentCode],[IncrementID],[OrderID],[AppliedRuleIDs],[StagingTransEntryNo],[CustomerGroupID],[Email],[EntityNo],[Amount],[TaxAmount],[TotalAmount],[DiscountAmount],[ShippingAmount],[ETL_CreatedOn],[ETL_CreatedBy],[ETL_UpdatedOn],[ETL_UpdatedBy]
FROM
	(
	SELECT [No],[YourReference],[ShipToName],[ShipToName2],[ShipToAddress],[ShipToAddress2],[ShipToCity],[ShipToContact],[OrderDate],[ShipmentDate],[ShipmentMethodCode],[NAVAmount],[NAVAmountIncludingVAT],[SellToCustomerName],[SellToCustomerName2],[SellToAddress],[SellToAddress2],[SellToCity],[SellToContact],[SellToPostCode],[SellToState],[SellToCountryRegionCode],[ShipToPostCode],[ShipToState],[ShipToCountryRegionCode],[PaymentMethodCode],[ShippingAgentCode],[IncrementID],[OrderID],[AppliedRuleIDs],[StagingTransEntryNo],[CustomerGroupID],[Email],[EntityNo],[Amount],[TaxAmount],[TotalAmount],[DiscountAmount],[ShippingAmount],[ETL_CreatedOn],[ETL_CreatedBy],[ETL_UpdatedOn],[ETL_UpdatedBy],@EndDate [RecordEndDate]
	FROM [ods].[Nav_SalesHeader] t
	UNION ALL
	SELECT [No],[YourReference],[ShipToName],[ShipToName2],[ShipToAddress],[ShipToAddress2],[ShipToCity],[ShipToContact],[OrderDate],[ShipmentDate],[ShipmentMethodCode],[NAVAmount],[NAVAmountIncludingVAT],[SellToCustomerName],[SellToCustomerName2],[SellToAddress],[SellToAddress2],[SellToCity],[SellToContact],[SellToPostCode],[SellToState],[SellToCountryRegionCode],[ShipToPostCode],[ShipToState],[ShipToCountryRegionCode],[PaymentMethodCode],[ShippingAgentCode],[IncrementID],[OrderID],[AppliedRuleIDs],[StagingTransEntryNo],[CustomerGroupID],[Email],[EntityNo],[Amount],[TaxAmount],[TotalAmount],[DiscountAmount],[ShippingAmount],[ETL_CreatedOn],[ETL_CreatedBy],[ETL_UpdatedOn],[ETL_UpdatedBy],[RecordEndDate]
	FROM [ods].[Snapshot_Nav_SalesHeader]
	) a
WHERE
	@AsOfDate BETWEEN [ETL_UpdatedOn] AND [RecordEndDate]
	AND [ETL_CreatedOn] <= @AsOfDate

RETURN

END
GO
