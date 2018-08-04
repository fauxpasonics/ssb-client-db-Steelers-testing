CREATE TABLE [archive].[Steelers_500f_Events_20170623]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_UpdatedDate] [datetime] NOT NULL,
[ETL_IsDeleted] [bit] NOT NULL,
[ETL_DeletedDate] [datetime] NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[loyalty_customer_id] [int] NOT NULL,
[loyalty_event_id] [int] NOT NULL,
[event_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[external_customer_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[transaction_date] [datetime] NULL,
[created_at] [datetime] NULL,
[expires_at] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[detail] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[original_event_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[value] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[points] [int] NULL,
[redeemed_points] [int] NULL,
[expired_points] [int] NULL,
[status] [int] NULL,
[channel] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sub_channel] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sub_channel_detail] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
