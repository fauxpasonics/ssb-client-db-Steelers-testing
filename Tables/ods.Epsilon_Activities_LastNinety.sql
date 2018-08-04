CREATE TABLE [ods].[Epsilon_Activities_LastNinety]
(
[CustomerKey] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Preference] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Action] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MessageName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MessageID] [nvarchar] (510) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL_CreatedDate] [datetime] NULL
)
GO
CREATE NONCLUSTERED INDEX [IX_Action] ON [ods].[Epsilon_Activities_LastNinety] ([Action])
GO
CREATE NONCLUSTERED INDEX [IX_CustomerKey] ON [ods].[Epsilon_Activities_LastNinety] ([CustomerKey])
GO
CREATE NONCLUSTERED INDEX [IX_MessageID] ON [ods].[Epsilon_Activities_LastNinety] ([MessageID])
GO
CREATE NONCLUSTERED INDEX [IX_Preference] ON [ods].[Epsilon_Activities_LastNinety] ([Preference])
GO
