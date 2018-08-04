CREATE TABLE [rpt].[SNU_ExcludeTypes]
(
[type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE NONCLUSTERED INDEX [IX_type] ON [rpt].[SNU_ExcludeTypes] ([type])
GO
