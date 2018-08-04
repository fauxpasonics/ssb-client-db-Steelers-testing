SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [src].[vw_TM_ManifestSeat]
as

SELECT [arena_id]
      ,[manifest_id]
      ,[section_id]
      ,[section_name]
      ,[section_desc]
      ,[section_type]
      ,[section_type_name]
      ,[gate]
      ,[ga]
      ,[row_id]
      ,[row_name]
      ,[row_desc]
      ,[seat_num]
      ,[num_seats]
      ,[last_seat]
      ,[seat_increment]
      ,[default_class]
      ,[class_name]
      ,[def_price_code]
      ,[tm_section_name]
      ,[tm_row_name]
      ,[section_info1]
      ,[section_info2]
      ,[section_info3]
      ,[section_info4]
      ,[section_info5]
      ,[row_info1]
      ,[row_info2]
      ,[row_info3]
      ,[row_info4]
      ,[row_info5]
      ,[manifest_name]
      ,[arena_name]
      ,[org_id]
      ,[org_name]
	  ,[SourceFileName]
	  ,HASHBYTES('sha2_256', ISNULL(RTRIM([arena_id]),'DBNULL_TEXT') + ISNULL(RTRIM([manifest_id]),'DBNULL_TEXT') + ISNULL(RTRIM([section_id]),'DBNULL_TEXT') + ISNULL(RTRIM([section_name]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([section_desc]),'DBNULL_TEXT') + ISNULL(RTRIM([section_type]),'DBNULL_TEXT') + ISNULL(RTRIM([section_type_name]),'DBNULL_TEXT') + ISNULL(RTRIM([gate]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([ga]),'DBNULL_TEXT') + ISNULL(RTRIM([row_id]),'DBNULL_TEXT') + ISNULL(RTRIM([row_name]),'DBNULL_TEXT') + ISNULL(RTRIM([row_desc]),'DBNULL_TEXT') + ISNULL(RTRIM([seat_num]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([num_seats]),'DBNULL_TEXT') + ISNULL(RTRIM([last_seat]),'DBNULL_TEXT') + ISNULL(RTRIM([seat_increment]),'DBNULL_TEXT') + ISNULL(RTRIM([default_class]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([class_name]),'DBNULL_TEXT') + ISNULL(RTRIM([def_price_code]),'DBNULL_TEXT') + ISNULL(RTRIM([tm_section_name]),'DBNULL_TEXT') + ISNULL(RTRIM([tm_row_name]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([section_info1]),'DBNULL_TEXT') + ISNULL(RTRIM([section_info2]),'DBNULL_TEXT') + ISNULL(RTRIM([section_info3]),'DBNULL_TEXT') + ISNULL(RTRIM([section_info4]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([section_info5]),'DBNULL_TEXT') + ISNULL(RTRIM([row_info1]),'DBNULL_TEXT') + ISNULL(RTRIM([row_info2]),'DBNULL_TEXT') + ISNULL(RTRIM([row_info3]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([row_info4]),'DBNULL_TEXT') + ISNULL(RTRIM([row_info5]),'DBNULL_TEXT') + ISNULL(RTRIM([manifest_name]),'DBNULL_TEXT') + ISNULL(RTRIM([arena_name]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([org_id]),'DBNULL_TEXT') + ISNULL(RTRIM([org_name]),'DBNULL_TEXT')) SrcHashKey
	  , ROW_NUMBER() OVER(PARTITION BY arena_id, manifest_id, section_id, row_id, seat_num ORDER BY arena_id) AS MergeRank
  FROM [src].[TM_ManifestSeat]





GO
