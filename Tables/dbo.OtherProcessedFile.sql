CREATE TABLE [dbo].[OtherProcessedFile]
(
[FileId] [int] NOT NULL IDENTITY(1, 1),
[Filename] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[TotalRecordCount] [int] NULL,
[NumRecordsLoaded] [int] NULL
)
GO
