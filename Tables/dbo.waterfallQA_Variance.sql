CREATE TABLE [dbo].[waterfallQA_Variance]
(
[insertID] [int] NULL,
[insertDate] [date] NULL,
[QA_Table] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BatchID] [int] NULL,
[SSB_Table] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[varianceGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[accountID] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
