CREATE TABLE [mdm].[SourceSystemPriority]
(
[ElementID] [int] NOT NULL,
[SourceSystemID] [int] NOT NULL,
[SourceSystemPriority] [int] NULL,
[DateCreated] [date] NULL CONSTRAINT [DF__SourceSys__DateC__3E923B2D] DEFAULT (getdate()),
[DateUpdated] [date] NULL CONSTRAINT [DF__SourceSys__DateU__3F865F66] DEFAULT (getdate())
)
GO
