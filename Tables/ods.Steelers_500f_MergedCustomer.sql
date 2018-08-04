CREATE TABLE [ods].[Steelers_500f_MergedCustomer]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__Steelers___ETL_C__351AE3FA] DEFAULT (getdate()),
[ETL_UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF__Steelers___ETL_U__360F0833] DEFAULT (getdate()),
[ETL_IsDeleted] [bit] NOT NULL CONSTRAINT [DF__Steelers___ETL_I__37032C6C] DEFAULT ((0)),
[ETL_DeletedDate] [datetime] NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[ETL_SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[victim_external_customer_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[victim_email] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[victim_loyalty_customer_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[survivor_external_customer_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[survivor_email] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[survivor_loyalty_customer_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[merge_date] [datetime] NULL
)
GO
