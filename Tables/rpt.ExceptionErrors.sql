CREATE TABLE [rpt].[ExceptionErrors]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[TestResultId] [int] NOT NULL,
[ExceptionMsg] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ExceptionType] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExceptionSource] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [rpt].[ExceptionErrors] ADD CONSTRAINT [PK__Exceptio__3214EC07EBADF617] PRIMARY KEY CLUSTERED  ([Id])
GO
