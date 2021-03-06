CREATE TABLE [EmailOutbound].[Upsert_Custom]
(
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB_DAY] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB_MONTH] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB_YEAR] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_SNU] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SNU_ENROLLED_AT] [datetime] NULL,
[SNU_STATUS] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SNU_TIER] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SNU_TIER_PREVIOUS_SEASON] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SNU_CURRENT_YARDS] [int] NULL,
[SNU_LAST_ACTIVITY_DATE] [datetime] NULL,
[CURRENT_STH] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CURRENT_SUITE] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CURRENT_WL] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_SINGLE_BUYER] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_CONCERT] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EVENTS_ATTENDED] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CONTESTS_ENTERED] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IS_WIFI_CUSTOMER] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IS_MOBILE_APP_CUSTOMER] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_TEAM_NEWS] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_TEAM_EVENTS] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_CONCERTS] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_HEINZ_FIELD] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_MERCH] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_PARTNER_OFFERS] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PRO_SHOP_PURCHASER] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PRO_SHOP_LAST_ORDER_DATE] [datetime] NULL,
[NFL_SHOP_PURCHASER] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[INSERT_DATETIME] [datetime] NULL
)
GO
CREATE NONCLUSTERED INDEX [IX_Email] ON [EmailOutbound].[Upsert_Custom] ([Email])
GO
