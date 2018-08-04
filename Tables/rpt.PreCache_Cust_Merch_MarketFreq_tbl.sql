CREATE TABLE [rpt].[PreCache_Cust_Merch_MarketFreq_tbl]
(
[MonthYear] [nvarchar] (61) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MonthAbbrv] [nvarchar] (34) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InMarket] [int] NULL,
[OutMarket] [int] NULL,
[RepeatCust] [int] NULL,
[NotRepeat] [int] NULL,
[IsReady] [int] NOT NULL
)
GO
