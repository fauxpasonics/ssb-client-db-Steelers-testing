CREATE TABLE [adhoc].[Epsilon_BreakingNewsDetail]
(
[PROFILE_KEY] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Preference] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActionDate] [date] NULL,
[Action] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MessageName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MessageID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LinkName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE NONCLUSTERED INDEX [IX_Action] ON [adhoc].[Epsilon_BreakingNewsDetail] ([Action])
GO
CREATE NONCLUSTERED INDEX [IX_MessageName] ON [adhoc].[Epsilon_BreakingNewsDetail] ([MessageName])
GO
CREATE NONCLUSTERED INDEX [IX_PROFILE_KEY] ON [adhoc].[Epsilon_BreakingNewsDetail] ([PROFILE_KEY])
GO
