CREATE TABLE [rpt].[PreCache_Cust_Merch_1_tbl]
(
[GroupID] [int] NOT NULL,
[StateAb] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STATE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Color] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Customers] [int] NULL,
[ItemsPurchased] [int] NULL,
[TotalOrders] [int] NULL,
[TotalRevenue] [numeric] (38, 4) NULL,
[AvgOrder] [numeric] (38, 6) NULL,
[CustRank] [bigint] NULL,
[RevRank] [bigint] NULL,
[isReady] [int] NOT NULL
)
GO
