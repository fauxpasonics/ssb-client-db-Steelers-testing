CREATE TABLE [EmailOutbound].[WorkingSet]
(
[EmailPrimary] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsNewRecord] [bit] NULL,
[RecordSource] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [date] NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE NONCLUSTERED INDEX [IX_EmailPrimary] ON [EmailOutbound].[WorkingSet] ([EmailPrimary])
GO
CREATE NONCLUSTERED INDEX [IX_GUID] ON [EmailOutbound].[WorkingSet] ([SSB_CRMSYSTEM_CONTACT_ID])
GO
