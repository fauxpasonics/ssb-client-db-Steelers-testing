CREATE TABLE [rpt].[DataCompareErrorResults]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[TestResultId] [int] NOT NULL,
[Number_Data_Differences] [int] NOT NULL,
[Number_Unique_To_Source] [int] NOT NULL,
[Number_Unique_To_Target] [int] NOT NULL,
[Results] [varbinary] (max) NULL,
[XMLResults] [xml] NULL
)
GO
ALTER TABLE [rpt].[DataCompareErrorResults] ADD CONSTRAINT [PK__DataComp__3214EC074EA91582] PRIMARY KEY CLUSTERED  ([Id])
GO
