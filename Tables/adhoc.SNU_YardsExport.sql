CREATE TABLE [adhoc].[SNU_YardsExport]
(
[SortOrder] [int] NULL,
[Label] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DaysSinceTrans] [int] NOT NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
