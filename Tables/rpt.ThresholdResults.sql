CREATE TABLE [rpt].[ThresholdResults]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[TestResultId] [int] NOT NULL,
[SourceCount] [int] NOT NULL,
[TargetCount] [int] NOT NULL,
[SourceDate] [datetime] NULL,
[TargetDate] [datetime] NULL,
[TestCountThreshold] [float] NOT NULL,
[ResultThreshold] [float] NOT NULL,
[HourDateDifference] [int] NULL
)
GO
ALTER TABLE [rpt].[ThresholdResults] ADD CONSTRAINT [PK__Threshol__3214EC07688D58CD] PRIMARY KEY CLUSTERED  ([Id])
GO
