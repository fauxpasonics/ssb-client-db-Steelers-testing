SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE PROC [rpt].[Cust_Waterfall_load] AS

create table #SourceRank (
SourceSystem varchar(50)
,SortOrder INT
)

INSERT INTO #SourceRank

select dc.Sourcesystem
	  ,rank() OVER(ORDER BY ISNULL(ss.SortOrder,99), dc.SourceSystem) SortOrder
FROM (  select distinct sourcesystem
		from dimcustomerssbid
		WHERE SourceSystem IS NOT NULL
	 )dc
	 LEFT JOIN rpt.SystemSort ss on ss.SourceSystem = dc.Sourcesystem

SELECT z.SourceSystem
		, SortOrder
		, COUNT(z.DimCustomerId) TotalRecords
		, COUNT(DISTINCT z.SSB_CRMSYSTEM_CONTACT_ID) SourceUnique
		, SUM(CASE WHEN PersonRowNumber = 1 THEN 1 ELSE 0 END)  AS UniqueCount
		, GETDATE() AS EtlDate
		, COUNT(DISTINCT CASE WHEN MaxSourceRank = 1 THEN z.SSB_CRMSYSTEM_CONTACT_ID ELSE NULL END) AS UniqueToSource
		, 1 AS IsCurrentDay
		, GETDATE() AS dimdateid
FROM ( SELECT  SortOrder 
			  ,SourceSystem 
			  ,SSB_CRMSYSTEM_CONTACT_ID 
			  ,dimcustomerid
			  ,personrownumber
			  ,MAX(sourceRank) AS MaxSourceRank
	   FROM (  SELECT ss.SortOrder 
					 ,ssbid.SourceSystem 
					 ,ssbid.SSB_CRMSYSTEM_CONTACT_ID 
					 ,ssbid.dimcustomerid
					 ,ROW_NUMBER() OVER (PARTITION BY ssbid.SSB_CRMSYSTEM_CONTACT_ID ORDER BY ISNULL(SortOrder, 10000000)) AS PersonRowNumber
					 ,DENSE_RANK() OVER (PARTITION BY ssbid.SSB_CRMSYSTEM_CONTACT_ID ORDER BY ss.SortOrder) AS sourceRank		
			   FROM [dbo].[dimcustomerssbid] ssbid (NOLOCK)
				LEFT JOIN #SourceRank ss (NOLOCK) ON ssbid.SourceSystem = ss.SourceSystem
			)a
	  GROUP BY SortOrder 
	  		  ,SourceSystem 
	  		  ,SSB_CRMSYSTEM_CONTACT_ID 
	  		  ,dimcustomerid
	  		  ,personrownumber
	 )z
GROUP BY z.SourceSystem, SortOrder

DROP TABLE #SourceRank

GO
