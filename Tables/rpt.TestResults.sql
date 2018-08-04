CREATE TABLE [rpt].[TestResults]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[BatchId] [int] NOT NULL,
[Client] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TestName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TestType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SourceConnectionName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TargetConnectionName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SourceQuery] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TargetQuery] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DateExecuted] [datetime] NOT NULL,
[Pass] [int] NULL,
[ColumnCount] [int] NULL,
[SourceResultCount] [int] NULL,
[TargetResultCount] [int] NULL,
[SourceQueryTime] [float] NULL,
[TargetQueryTime] [float] NULL,
[TestExecutionTime] [float] NULL
)
GO
ALTER TABLE [rpt].[TestResults] ADD CONSTRAINT [PK__TestResu__3214EC0797EF3B86] PRIMARY KEY CLUSTERED  ([Id])
GO
