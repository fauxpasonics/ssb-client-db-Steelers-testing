SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [src].[vw_TM_SellLocation]
as

SELECT [sell_location_id]
      ,[sell_location_code]
      ,[sell_location_name]
      ,[sell_location_desc]
      ,[outlet_code]
      ,[org_id]
      ,[active]
      ,[protected]
      ,[sort_order]
      ,[add_user]
      ,[add_datetime]
      ,[upd_user]
      ,[upd_datetime]
	  ,[SourceFileName]
	  ,HASHBYTES('sha2_256', ISNULL(RTRIM([sell_location_id]),'DBNULL_TEXT') + ISNULL(RTRIM([sell_location_code]),'DBNULL_TEXT') + ISNULL(RTRIM([sell_location_name]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([sell_location_desc]),'DBNULL_TEXT') + ISNULL(RTRIM([outlet_code]),'DBNULL_TEXT') + ISNULL(RTRIM([org_id]),'DBNULL_TEXT') + ISNULL(RTRIM([active]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([protected]),'DBNULL_TEXT') + ISNULL(RTRIM([sort_order]),'DBNULL_TEXT') + ISNULL(RTRIM([add_user]),'DBNULL_TEXT') + ISNULL(RTRIM([add_datetime]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([upd_user]),'DBNULL_TEXT') + ISNULL(RTRIM([upd_datetime]),'DBNULL_TEXT')) SrcHashKey
	, ROW_NUMBER() OVER(PARTITION BY sell_location_id ORDER BY upd_datetime desc) AS MergeRank
  FROM [src].[TM_SellLocation]




GO
