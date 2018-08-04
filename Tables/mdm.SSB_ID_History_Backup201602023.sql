CREATE TABLE [mdm].[SSB_ID_History_Backup201602023]
(
[SSID] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sourcesystem] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nameaddr_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nameemail_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[composite_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ssb_crmsystem_acct_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ssb_crmsystem_contact_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ssb_crmsystem_primary_flag] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[createddate] [datetime] NOT NULL,
[SSB_HISTORY_ID] [int] NOT NULL IDENTITY(1, 1)
)
GO
