CREATE TABLE [ods].[FanCentric_ColumnDescription]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ColumnName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ColumnDescription] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [ods].[FanCentric_ColumnDescription] ADD CONSTRAINT [PK__FanCentr__3214EC270EF01128] PRIMARY KEY CLUSTERED  ([ID])
GO
