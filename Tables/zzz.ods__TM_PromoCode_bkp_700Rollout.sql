CREATE TABLE [zzz].[ods__TM_PromoCode_bkp_700Rollout]
(
[id] [bigint] NOT NULL IDENTITY(1, 1),
[promo_code_id] [int] NULL,
[promo_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[promo_code_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acct_id] [bigint] NULL,
[promo_inet_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[promo_inet_desc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[promo_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[promo_group_sell_flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[promo_active_flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[add_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[inet_start_datetime] [datetime] NULL,
[inet_end_datetime] [datetime] NULL,
[archtics_start_datetime] [datetime] NULL,
[archtics_end_datetime] [datetime] NULL,
[event_id] [int] NULL,
[event_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tm_event_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[add_Datetime] [datetime] NULL,
[upd_datetime] [datetime] NULL,
[InsertDate] [datetime] NULL CONSTRAINT [DF__TM_PromoC__Inser__3FD07829] DEFAULT (getdate()),
[UpdateDate] [datetime] NULL CONSTRAINT [DF__TM_PromoC__Updat__40C49C62] DEFAULT (getdate()),
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [binary] (32) NULL
)
GO
ALTER TABLE [zzz].[ods__TM_PromoCode_bkp_700Rollout] ADD CONSTRAINT [PK__TM_Promo__3213E83FAB153005] PRIMARY KEY CLUSTERED  ([id])
GO
