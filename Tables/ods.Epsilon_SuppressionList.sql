CREATE TABLE [ods].[Epsilon_SuppressionList]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__Epsilon_S__ETL_C__40801300] DEFAULT (getdate()),
[ETL_UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF__Epsilon_S__ETL_U__41743739] DEFAULT (getdate()),
[ETL_IsDeleted] [bit] NOT NULL CONSTRAINT [DF__Epsilon_S__ETL_I__42685B72] DEFAULT ((0)),
[ETL_DeletedDate] [datetime] NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[ETL_FileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerKey] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAddress] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NULL,
[CURRENT_STH] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SNU_STATUS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PRO_SHOP_PURCHASER] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [ods].[Epsilon_SuppressionList] ADD CONSTRAINT [PK__Epsilon___7EF6BFCD4F3373DC] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
