CREATE TABLE [stg].[Epsilon_SuppressionList]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__Epsilon_S__ETL_C__3DA3A655] DEFAULT (getdate()),
[ETL_FileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerKey] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAddress] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CURRENT_STH] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SNU_STATUS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PRO_SHOP_PURCHASER] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [stg].[Epsilon_SuppressionList] ADD CONSTRAINT [PK__Epsilon___7EF6BFCD0DDA6263] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
