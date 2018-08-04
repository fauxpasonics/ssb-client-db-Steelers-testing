CREATE TABLE [ods].[Merch_Customer]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_UpdatedDate] [datetime] NOT NULL,
[ETL_IsDeleted] [bit] NOT NULL,
[ETL_DeletedDate] [datetime] NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[Id] [int] NULL,
[CustomerGuid] [uniqueidentifier] NULL,
[Username] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Password] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PasswordFormatId] [int] NULL,
[PasswordSalt] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdminComment] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsTaxExempt] [bit] NULL,
[AffiliateId] [int] NULL,
[VendorId] [int] NULL,
[HasShoppingCartItems] [bit] NULL,
[Active] [bit] NULL,
[Deleted] [bit] NULL,
[IsSystemAccount] [bit] NULL,
[SystemName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastIpAddress] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedOnUtc] [datetime] NULL,
[LastLoginDateUtc] [datetime] NULL,
[LastActivityDateUtc] [datetime] NULL,
[BillingAddress_Id] [int] NULL,
[ShippingAddress_Id] [int] NULL,
[LastTimeStamp] [binary] (8) NULL
)
GO
CREATE NONCLUSTERED INDEX [IDX_MerchCustomer_Id] ON [ods].[Merch_Customer] ([Id])
GO
