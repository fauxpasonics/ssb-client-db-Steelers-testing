CREATE TABLE [ods].[Steelers_500f_Customer]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_UpdatedDate] [datetime] NOT NULL,
[ETL_IsDeleted] [bit] NOT NULL,
[ETL_DeletedDate] [datetime] NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[loyalty_id] [int] NOT NULL,
[email] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[external_customer_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[enrolled_at] [datetime] NULL,
[first_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[last_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[balance] [int] NULL,
[lifetime_balance] [int] NULL,
[last_activity] [datetime] NULL,
[status] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[unsubscribed] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[top_tier_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tier_join_date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tier_expiration_date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[birthdate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address_2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[city] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[state] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[country] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[postal_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mobile_phone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[home_phone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[work_phone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[home_store] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[channel] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sub_channel] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sub_channel_detail] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[brand] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE NONCLUSTERED INDEX [IX_Steelers_500f_Customer_email] ON [ods].[Steelers_500f_Customer] ([email])
GO
CREATE NONCLUSTERED INDEX [idx_steelers_500f_customer_loyalty_id] ON [ods].[Steelers_500f_Customer] ([loyalty_id])
GO
CREATE NONCLUSTERED INDEX [IX_Steelers_500f_Customer_status] ON [ods].[Steelers_500f_Customer] ([status])
GO
CREATE NONCLUSTERED INDEX [idx_steelers_500f_customer_status_include] ON [ods].[Steelers_500f_Customer] ([status]) INCLUDE ([loyalty_id], [top_tier_name])
GO
