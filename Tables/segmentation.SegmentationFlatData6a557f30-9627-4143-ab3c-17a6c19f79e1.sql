CREATE TABLE [segmentation].[SegmentationFlatData6a557f30-9627-4143-ab3c-17a6c19f79e1]
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
ALTER TABLE [segmentation].[SegmentationFlatData6a557f30-9627-4143-ab3c-17a6c19f79e1] ADD CONSTRAINT [pk_SegmentationFlatData6a557f30-9627-4143-ab3c-17a6c19f79e1] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData6a557f30-9627-4143-ab3c-17a6c19f79e1] ON [segmentation].[SegmentationFlatData6a557f30-9627-4143-ab3c-17a6c19f79e1] ([_rn])
GO
