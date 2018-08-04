CREATE TABLE [stg].[Steelers_500f_MergedCustomer]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__Steelers___ETL_C__38EB74DE] DEFAULT (getdate()),
[ETL_SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[victim_external_customer_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[victim_email] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[victim_loyalty_customer_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[survivor_external_customer_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[survivor_email] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[survivor_loyalty_customer_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[merge_date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
