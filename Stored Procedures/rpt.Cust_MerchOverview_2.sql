SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [rpt].[Cust_MerchOverview_2] AS



SELECT [DataType]
      ,[SaleMonth]
      ,[STH_Rev]
      ,[STH_Cnt]
      ,[STH_Items]
      ,[STH_Avg]
      ,[Waitlist_Rev]
      ,[Waitlist_Cnt]
      ,[Waitlist_Items]
      ,[Waitlist_Avg]
      ,[SG_Rev]
      ,[SG_Cnt]
      ,[SG_Items]
      ,[SG_Avg]
      ,[SNU_Rev]
      ,[SNU_Cnt]
      ,[SNU_Items]
      ,[SNU_Avg]
      ,[IsSnuNon_SNU_Rev]
      ,[Non_SNU_Cnt]
      ,[Non_SNU_Items]
      ,[Non_SNU_Avg]
      ,[Digest_Rev]
      ,[Digest_Cnt]
      ,[Digest_Items]
      ,[Digest_Avg]
      ,[In_Market_Rev]
      ,[In_Market_Cnt]
      ,[In_Market_Items]
      ,[In_Market_Avg]
      ,[Out_of_Market_Rev]
      ,[Out_of_Market_Cnt]
      ,[Out_of_Market_Items]
      ,[Out_of_Market_Avg]
      ,[New_Buyer_Rev]
      ,[New_Cnt]
      ,[New_Buyer_Items]
      ,[New_Buyer_Avg]
      ,[Repeat_Buyer_Rev]
      ,[Repeat_Cnt]
      ,[Repeat_Buyer_Items]
      ,[Repeat_Buyer_Avg]
      ,[Orders]
      ,[TotalRevenue]
      ,[UniqueBuyers]
    
  FROM [rpt].[PreCache_Cust_Merch_2_tbl]
  WHERE isReady = 1
order by case when datatype = 'Detail' then 2 else 1 end, salemonth
GO
