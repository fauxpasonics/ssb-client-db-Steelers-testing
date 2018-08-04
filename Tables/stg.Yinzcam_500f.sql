CREATE TABLE [stg].[Yinzcam_500f]
(
[insert_datetime] [datetime] NULL,
[YinzID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[id_external] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[loyalty_subscription_type] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[status_name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[status_active] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[loyalty_points_current] [int] NULL,
[loyalty_tier_name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[loyalty_points_lifetime] [int] NULL,
[loyalty_channel] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[loyalty_subchannel] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[loyalty_subchannel_detail] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[loyalty_unsubscribed] [bit] NULL,
[sms_optout] [bit] NULL,
[loyalty_last_reward_event_id] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[loyalty_tier_expiration_timestamp] [datetime] NULL,
[timestamp_enroll] [datetime] NULL,
[timestamp_create] [datetime] NULL,
[timestamp_active] [datetime] NULL,
[timestamp_update] [datetime] NULL,
[url_login_dcg] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[token_login_dcg] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[image_url] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
