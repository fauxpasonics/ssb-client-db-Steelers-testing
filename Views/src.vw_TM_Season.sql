SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [src].[vw_TM_Season]
as

SELECT [season_id]
      ,[name]
      ,[line1]
      ,[line2]
      ,[line3]
      ,[arena_id]
      ,[manifest_id]
      ,[add_datetime]
      ,[upd_user]
      ,[upd_datetime]
      ,[season_year]
      ,[org_id]
	  ,[SourceFileName]
	  ,HASHBYTES('sha2_256', ISNULL(RTRIM([season_id]),'DBNULL_TEXT') + ISNULL(RTRIM([name]),'DBNULL_TEXT') + ISNULL(RTRIM([line1]),'DBNULL_TEXT') + ISNULL(RTRIM([line2]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([line3]),'DBNULL_TEXT') + ISNULL(RTRIM([arena_id]),'DBNULL_TEXT') + ISNULL(RTRIM([manifest_id]),'DBNULL_TEXT') + ISNULL(RTRIM([add_datetime]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([upd_user]),'DBNULL_TEXT') + ISNULL(RTRIM([upd_datetime]),'DBNULL_TEXT') + ISNULL(RTRIM([season_year]),'DBNULL_TEXT') + ISNULL(RTRIM([org_id]),'DBNULL_TEXT')) SrcHashKey
	, ROW_NUMBER() OVER(PARTITION BY season_id ORDER BY upd_datetime desc) AS MergeRank
  FROM [src].[TM_Season]








GO
