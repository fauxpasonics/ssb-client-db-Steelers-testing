CREATE TABLE [audit].[digest_20171025]
(
[id] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[first] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[last] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[company] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address2] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[city] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[st] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[zip] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[status] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE NONCLUSTERED INDEX [IX_id] ON [audit].[digest_20171025] ([id])
GO
