CREATE TABLE [etl].[YinzCam_Load_Monitoring]
(
[RunDate] [date] NULL,
[ProcName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartTime] [datetime] NULL,
[EndTime] [datetime] NULL,
[Completed] [bit] NULL,
[LoadCount] [int] NULL,
[ErrorMessage] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorSeverity] [int] NULL,
[ErrorState] [int] NULL
)
GO
