CREATE TABLE [rpt].[DataCompareDifferenceAnalysisResults]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[TestResultId] [int] NOT NULL,
[DifferenceType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IdentifyingId] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ColumnName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceValue] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TargetValue] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [rpt].[DataCompareDifferenceAnalysisResults] ADD CONSTRAINT [PK__DataComp__3214EC0750FAB140] PRIMARY KEY CLUSTERED  ([Id])
GO
