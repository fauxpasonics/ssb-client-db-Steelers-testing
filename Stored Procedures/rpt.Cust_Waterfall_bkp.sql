SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROC [rpt].[Cust_Waterfall_bkp] AS

	SELECT B.SourceSystem 
          ,B.SortOrder 
          ,B.TotalRecords 
          ,B.SourceUnique 
          ,B.UniqueCount 
          ,B.EtlDate 
          ,B.UniqueToSource
		  ,1 AS IsCurrentDay
		  ,B.EtlDate AS dimdateid
	FROM (  SELECT z.SourceSystem
				  , SortOrder
				  , COUNT(z.DimCustomerId) TotalRecords
				  , COUNT(DISTINCT a.SSB_CRMSYSTEM_CONTACT_ID) SourceUnique
				  , SUM(CASE WHEN PersonRowNumber = 1 THEN 1 ELSE 0 END)  AS UniqueCount
				  , GETDATE() AS EtlDate
				  , COUNT(DISTINCT CASE WHEN MaxSourceRank = 1 THEN a.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS UniqueToSource
			FROM (SELECT CASE WHEN SourceSystem = 'events' THEN ExtAttribute10 ELSE SourceSystem END AS SourceSystem
						 ,DimCustomerId 
				  FROM dbo.DimCustomer) z
			LEFT JOIN ( SELECT  SortOrder 
								,SourceSystem 
								,SSB_CRMSYSTEM_CONTACT_ID 
								,dimcustomerid
								,personrownumber
								,MAX(sourceRank) AS MaxSourceRank
						 FROM ( SELECT ss.SortOrder 
									   ,CASE WHEN dc.SourceSystem = 'events' THEN ExtAttribute10 ELSE dc.SourceSystem END AS SourceSystem 
									   ,ssbid.SSB_CRMSYSTEM_CONTACT_ID 
									   ,ssbid.dimcustomerid
									   ,ROW_NUMBER() OVER (PARTITION BY ssbid.SSB_CRMSYSTEM_CONTACT_ID ORDER BY ISNULL(SortOrder, 10000000)) AS PersonRowNumber
									   ,DENSE_RANK() OVER (PARTITION BY ssbid.SSB_CRMSYSTEM_CONTACT_ID ORDER BY ss.SortOrder) AS sourceRank		
								FROM [dbo].[dimcustomerssbid] ssbid (NOLOCK)
									JOIN dimcustomer dc ON dc.DimCustomerId = ssbid.DimCustomerId
									LEFT JOIN rpt.SystemSort ss (NOLOCK) ON CASE WHEN dc.SourceSystem = 'events' THEN ExtAttribute10 ELSE dc.SourceSystem END = ss.SourceSystem) a
						 GROUP BY SortOrder 
								  ,SourceSystem 
								  ,SSB_CRMSYSTEM_CONTACT_ID 
								  ,dimcustomerid
								  ,personrownumber
						) a ON a.SourceSystem = z.SourceSystem AND a.DimCustomerId = z.DimCustomerId
			GROUP BY z.SourceSystem, SortOrder
		  ) B WHERE B.SortOrder IS NOT NULL



GO
