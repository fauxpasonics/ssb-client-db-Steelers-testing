CREATE TABLE [segmentation].[SegmentationFlatData7781cce1-8968-45ca-8cff-1193c256ae33]
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
ALTER TABLE [segmentation].[SegmentationFlatData7781cce1-8968-45ca-8cff-1193c256ae33] ADD CONSTRAINT [pk_SegmentationFlatData7781cce1-8968-45ca-8cff-1193c256ae33] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData7781cce1-8968-45ca-8cff-1193c256ae33] ON [segmentation].[SegmentationFlatData7781cce1-8968-45ca-8cff-1193c256ae33] ([_rn])
GO
