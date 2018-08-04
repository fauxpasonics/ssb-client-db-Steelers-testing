CREATE TABLE [dbo].[dimcustomer_addDrop_Unpivoted]
(
[BatchDate] [date] NULL,
[RecordChange] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[dimcustomerID] [int] NOT NULL,
[SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FieldName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Value] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
