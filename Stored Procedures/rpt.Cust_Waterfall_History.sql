SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [rpt].[Cust_Waterfall_History] AS 


SELECT [batchDate] Date
      ,[SourceSystem]
      ,[SortOrder]
      ,[TotalRecords]
      --,[SourceUnique]
      --,[UniqueCount]
      --,[UniqueToSource]
      --,[IsCurrentDay]
      --,[dimdateid]
FROM [Steelers].[dbo].[Waterfall_Count_History] (NOLOCK)
ORDER BY SortOrder,batchDate
GO
