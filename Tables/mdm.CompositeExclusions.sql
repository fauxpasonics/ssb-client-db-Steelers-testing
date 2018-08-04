CREATE TABLE [mdm].[CompositeExclusions]
(
[ElementID] [int] NOT NULL,
[ExclusionID] [int] NOT NULL,
[IsDeleted] [bit] NULL,
[DateCreated] [date] NULL CONSTRAINT [DF__Composite__DateC__36F11965] DEFAULT (getdate()),
[DateUpdated] [date] NULL CONSTRAINT [DF__Composite__DateU__37E53D9E] DEFAULT (getdate())
)
GO
