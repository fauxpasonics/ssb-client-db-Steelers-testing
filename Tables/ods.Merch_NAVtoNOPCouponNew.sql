CREATE TABLE [ods].[Merch_NAVtoNOPCouponNew]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_UpdatedDate] [datetime] NOT NULL,
[ETL_IsDeleted] [bit] NOT NULL,
[ETL_DeletedDate] [datetime] NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[Id] [int] NOT NULL,
[NopCouponId] [int] NOT NULL,
[Description] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StoreId] [int] NOT NULL,
[NavCouponCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsActive] [bit] NOT NULL,
[IsOneTimeUse] [bit] NOT NULL,
[IsConsumed] [bit] NOT NULL,
[DateAdded] [datetime] NOT NULL,
[LastTimeStamp] [binary] (8) NULL,
[LastUpdate] [datetime] NULL
)
GO
