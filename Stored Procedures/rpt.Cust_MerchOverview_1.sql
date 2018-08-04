SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [rpt].[Cust_MerchOverview_1] AS


SELECT [GroupID]
      ,[StateAb]
      ,[Country]
      ,[State]
      ,[Color]
      ,[Customers]
      ,[ItemsPurchased]
      ,[TotalOrders]
      ,[TotalRevenue]
      ,[AvgOrder]
      ,[CustRank]
      ,[RevRank]
      ,[isReady]
	  ,[TotalRevenue] as TotalGrossRevenue
  FROM [rpt].[PreCache_Cust_Merch_1_tbl]
    WHERE IsReady = 1
GO
