CREATE TABLE [segmentation].[SegmentationFlatData513e474f-38e7-4582-a3cf-7e3f79ee1292]
(
[id] [uniqueidentifier] NOT NULL,
[DocumentType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[_rn] [bigint] NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Archtics_Acct_Id] [int] NULL,
[Attended_By_Originator] [bit] NULL,
[Season_Is_Active] [bit] NULL,
[Season_Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Event_Header_Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Event_Code] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Event_Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Event_Desc] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Event_Class] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Event_Date] [date] NULL,
[Event_Time] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Event_Hierarchy_L1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Event_Hierarchy_L2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Event_Hierarchy_L3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Section_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Row_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[First_Seat] [int] NULL,
[Scan_Time] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Scan_Gate] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Channel] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [segmentation].[SegmentationFlatData513e474f-38e7-4582-a3cf-7e3f79ee1292] ADD CONSTRAINT [pk_SegmentationFlatData513e474f-38e7-4582-a3cf-7e3f79ee1292] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData513e474f-38e7-4582-a3cf-7e3f79ee1292] ON [segmentation].[SegmentationFlatData513e474f-38e7-4582-a3cf-7e3f79ee1292] ([_rn])
GO
