SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [src].[vw_TM_Arena]
AS

SELECT [arena_id]
      ,[arena_name]
      ,[arena_abv]
      ,[venue_city]
      ,[venue_state]
      ,[venue_zip]
      ,[inet_arena_name]
      ,[street_addr_1]
      ,[street_addr_2]
      ,[city]
      ,[state]
      ,[country]
      ,[phone]
	  ,[SourceFileName]
	  ,HASHBYTES('sha2_256', ISNULL(RTRIM([arena_id]),'DBNULL_TEXT') + ISNULL(RTRIM([arena_name]),'DBNULL_TEXT') + ISNULL(RTRIM([arena_abv]),'DBNULL_TEXT') + ISNULL(RTRIM([venue_city]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([venue_state]),'DBNULL_TEXT') + ISNULL(RTRIM([venue_zip]),'DBNULL_TEXT') + ISNULL(RTRIM([inet_arena_name]),'DBNULL_TEXT') + ISNULL(RTRIM([street_addr_1]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([street_addr_2]),'DBNULL_TEXT') + ISNULL(RTRIM([city]),'DBNULL_TEXT') + ISNULL(RTRIM([state]),'DBNULL_TEXT') + ISNULL(RTRIM([country]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([phone]),'DBNULL_TEXT')) SrcHashKey
	  , ROW_NUMBER() OVER(PARTITION BY arena_id ORDER BY arena_name) AS MergeRank
  FROM [src].[TM_Arena]



GO
