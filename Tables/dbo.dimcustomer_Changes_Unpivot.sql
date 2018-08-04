CREATE TABLE [dbo].[dimcustomer_Changes_Unpivot]
(
[BatchDate] [date] NULL,
[PriorDate] [date] NOT NULL,
[RecordChange] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dimcustomerID] [int] NOT NULL,
[fieldName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriorDayValue] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CurrentDayValue] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
