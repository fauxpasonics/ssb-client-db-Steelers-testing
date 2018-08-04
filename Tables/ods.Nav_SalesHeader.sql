CREATE TABLE [ods].[Nav_SalesHeader]
(
[No] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[YourReference] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToName2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToAddress] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToAddress2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToContact] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrderDate] [datetime] NULL,
[ShipmentDate] [datetime] NULL,
[ShipmentMethodCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NAVAmount] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NAVAmountIncludingVAT] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SellToCustomerName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SellToCustomerName2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SellToAddress] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SellToAddress2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SellToCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SellToContact] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SellToPostCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SellToState] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SellToCountryRegionCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToPostCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToState] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToCountryRegionCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PaymentMethodCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShippingAgentCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IncrementID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrderID] [int] NULL,
[AppliedRuleIDs] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StagingTransEntryNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerGroupID] [int] NULL,
[Email] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EntityNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Amount] [numeric] (18, 2) NULL,
[TaxAmount] [numeric] (18, 2) NULL,
[TotalAmount] [numeric] (18, 2) NULL,
[DiscountAmount] [numeric] (18, 2) NULL,
[ShippingAmount] [numeric] (18, 2) NULL,
[ETL_CreatedOn] [datetime] NOT NULL CONSTRAINT [DF__Nav_Sales__ETL_C__2D84AF2A] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[ETL_CreatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__Nav_Sales__ETL_C__2E78D363] DEFAULT (suser_sname()),
[ETL_UpdatedOn] [datetime] NOT NULL CONSTRAINT [DF__Nav_Sales__ETL_U__2F6CF79C] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[ETL_UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__Nav_Sales__ETL_U__30611BD5] DEFAULT (suser_sname())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----------- CREATE TRIGGER -----------
CREATE TRIGGER [ods].[Snapshot_Nav_SalesHeaderUpdate] ON [ods].[Nav_SalesHeader]
AFTER UPDATE, DELETE

AS
BEGIN

DECLARE @ETL_UpdatedOn DATETIME = (SELECT [etl].[ConvertToLocalTime](CAST(GETDATE() AS DATETIME2(0))))
DECLARE @ETL_UpdatedBy NVARCHAR(400) = (SELECT SYSTEM_USER)

UPDATE t SET
[ETL_UpdatedOn] = @ETL_UpdatedOn
,[ETL_UpdatedBy] = @ETL_UpdatedBy
FROM [ods].[Nav_SalesHeader] t
	JOIN inserted i ON  t.[No] = i.[No]

INSERT INTO [ods].[Snapshot_Nav_SalesHeader] ([No],[YourReference],[ShipToName],[ShipToName2],[ShipToAddress],[ShipToAddress2],[ShipToCity],[ShipToContact],[OrderDate],[ShipmentDate],[ShipmentMethodCode],[NAVAmount],[NAVAmountIncludingVAT],[SellToCustomerName],[SellToCustomerName2],[SellToAddress],[SellToAddress2],[SellToCity],[SellToContact],[SellToPostCode],[SellToState],[SellToCountryRegionCode],[ShipToPostCode],[ShipToState],[ShipToCountryRegionCode],[PaymentMethodCode],[ShippingAgentCode],[IncrementID],[OrderID],[AppliedRuleIDs],[StagingTransEntryNo],[CustomerGroupID],[Email],[EntityNo],[Amount],[TaxAmount],[TotalAmount],[DiscountAmount],[ShippingAmount],[ETL_CreatedOn],[ETL_CreatedBy],[ETL_UpdatedOn],[ETL_UpdatedBy],[RecordEndDate])
SELECT a.*,dateadd(s,-1,@ETL_UpdatedOn)
FROM deleted a

END
GO
ALTER TABLE [ods].[Nav_SalesHeader] ADD CONSTRAINT [PK__Nav_Sale__3214D4A872A46A97] PRIMARY KEY CLUSTERED  ([No])
GO
