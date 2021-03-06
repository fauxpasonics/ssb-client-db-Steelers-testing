CREATE TABLE [segmentation].[SegmentationFlatData02d07d2d-b9e9-4c83-870b-9f773fa3e3c0]
(
[id] [uniqueidentifier] NOT NULL,
[DocumentType] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[_rn] [bigint] NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Source_System] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Loyalty_Id] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Loyalty_Status] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Season_Ticket_Holder] [int] NULL,
[Top_Tier_Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Loyalty_Unsubscribed] [bit] NULL,
[Loyalty_Enrollment_Date] [date] NULL,
[Loyalty_Enrollment_Year] [int] NULL,
[Loyalty_Enrollment_Month] [int] NULL,
[Loyalty_Last_Activity] [date] NULL,
[Loyalty_Last_Active_Year] [int] NULL,
[Loyalty_Last_Active_Month] [int] NULL,
[Last_Activity_Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Total_Engagement_Count] [int] NULL,
[Badge_Engagement_Count] [int] NOT NULL,
[Tier_Engagement_Count] [int] NOT NULL,
[Checkin_Engagement_Count] [int] NOT NULL,
[RSVP_Engagementy_Count] [int] NOT NULL,
[Completed_Profile] [int] NOT NULL,
[Purchase_Count] [int] NOT NULL,
[Offer_Engagement_Count] [int] NOT NULL,
[Social_Share_Count] [int] NOT NULL,
[Viewed_Social_Engagement_Count] [int] NOT NULL,
[Weekly_Huddle_Engagement_Count] [int] NOT NULL
)
GO
ALTER TABLE [segmentation].[SegmentationFlatData02d07d2d-b9e9-4c83-870b-9f773fa3e3c0] ADD CONSTRAINT [pk_SegmentationFlatData02d07d2d-b9e9-4c83-870b-9f773fa3e3c0] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData02d07d2d-b9e9-4c83-870b-9f773fa3e3c0] ON [segmentation].[SegmentationFlatData02d07d2d-b9e9-4c83-870b-9f773fa3e3c0] ([_rn])
GO
