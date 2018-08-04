CREATE TABLE [src].[Steelers_500f_Events]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[loyalty_customer_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[loyalty_event_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[event_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[external_customer_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[transaction_date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[created_at] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[expires_at] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[detail] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[original_event_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[value] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[points] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[redeemed_points] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[expired_points] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[status] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[channel] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sub_channel] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sub_channel_detail] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
