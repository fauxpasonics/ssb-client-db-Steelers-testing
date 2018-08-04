CREATE TABLE [rpt].[SNU_ExcludeDetails]
(
[Detail] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE NONCLUSTERED INDEX [IX_Detail] ON [rpt].[SNU_ExcludeDetails] ([Detail])
GO
