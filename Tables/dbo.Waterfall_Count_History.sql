CREATE TABLE [dbo].[Waterfall_Count_History]
(
[batchDate] [date] NULL,
[SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SortOrder] [numeric] (18, 0) NULL,
[TotalRecords] [int] NULL,
[SourceUnique] [int] NULL,
[UniqueCount] [int] NULL,
[EtlDate] [datetime] NULL,
[UniqueToSource] [int] NULL,
[IsCurrentDay] [bit] NULL,
[dimdateid] [datetime] NULL
)
GO
