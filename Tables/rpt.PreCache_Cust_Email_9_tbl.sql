CREATE TABLE [rpt].[PreCache_Cust_Email_9_tbl]
(
[SortOrder] [int] NOT NULL,
[Preference] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[numSent] [int] NULL,
[numDelivered] [int] NULL,
[numOpened] [int] NULL,
[openRate] [decimal] (5, 4) NULL,
[numClicked] [int] NULL,
[ClickRate] [decimal] (5, 4) NULL,
[ClickOpenRate] [decimal] (5, 4) NULL,
[numOptOut] [int] NULL,
[OptOutRate] [decimal] (5, 4) NULL,
[IsReady] [int] NOT NULL
)
GO
