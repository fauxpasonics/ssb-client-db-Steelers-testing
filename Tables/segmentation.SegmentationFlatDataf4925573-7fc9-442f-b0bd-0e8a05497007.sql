CREATE TABLE [segmentation].[SegmentationFlatDataf4925573-7fc9-442f-b0bd-0e8a05497007]
(
[id] [uniqueidentifier] NOT NULL,
[DocumentType] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[_rn] [bigint] NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JoinDate] [date] NULL,
[EmailChannelOptStatusDate] [date] NULL,
[EmailChannelOptOutFlag] [int] NOT NULL,
[EmailAddressDeliveryStatus] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_TEAM_NEWS] [int] NOT NULL,
[PREF_SNU] [int] NOT NULL,
[PREF_MERCH] [int] NOT NULL,
[PREF_PARTNER_OFFERS] [int] NOT NULL,
[PREF_HEINZ_FIELD] [int] NOT NULL,
[PREF_TEAM_EVENTS] [int] NOT NULL,
[PREF_CONCERTS] [int] NOT NULL,
[IsEmailable] [int] NOT NULL,
[IsEngaged] [int] NOT NULL
)
GO
