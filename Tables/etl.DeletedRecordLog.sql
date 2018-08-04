CREATE TABLE [etl].[DeletedRecordLog]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[SourceTable] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SourceColumn] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DeletedKeyValue] [bigint] NOT NULL,
[ETL_CreatedDate] [datetime] NOT NULL
)
GO
ALTER TABLE [etl].[DeletedRecordLog] ADD CONSTRAINT [PK__DeletedR__3214EC07E387D95A] PRIMARY KEY CLUSTERED  ([Id])
GO
