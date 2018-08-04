CREATE TABLE [segmentation].[SegmentationFlatDataae18a552-2e0f-4383-ba58-9819825c75de]
(
[id] [uniqueidentifier] NULL,
[DocumentType] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[_rn] [bigint] NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Source_System] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Loyalty_Id] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Loyalty_Event_Id] [int] NOT NULL,
[Loyalty_Activity_Tag_Name] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Loyalty_Activity_Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Loyalty_Event_Description] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Loyalty_Transaction_Date] [date] NULL,
[Loyalty_Transaction_Year] [int] NULL,
[Loyalty_Transaction_Month] [int] NULL
)
GO
