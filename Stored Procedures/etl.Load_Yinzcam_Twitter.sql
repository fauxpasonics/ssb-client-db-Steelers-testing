SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*============================================================================================================
CREATED BY:		Jeff Barberio
CREATED DATE:	6/15/2017
PY VERSION:		N/A
USED BY:		YinzCam Inbound Integration
UPDATES:		
NOTES:			This PROC loads the data into ods.Yincam_Twitter, one of four yinzcam segment tables
=============================================================================================================*/


CREATE PROC [etl].[Load_Yinzcam_Twitter]

AS

DECLARE @RunDate DATE = GETDATE()
DECLARE @RunTime DATETIME = GETDATE()
DECLARE @ProcName VARCHAR(200) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID)
DECLARE @LoadCount INT
DECLARE @ErrorMessage NVARCHAR(4000) 
DECLARE @ErrorSeverity INT			 
DECLARE @ErrorState INT				 

/*========================================================================================================================
													START TRY
========================================================================================================================*/

BEGIN TRY


	/*====================================================================================================
													LOAD STAGING
	====================================================================================================*/

	SELECT   Insert_datetime									   AS ETL__insert_datetime
			,CAST(NULLIF(timestamp_create,'null') AS DATETIME)     AS timestamp_create         
			,NULLIF(YinzID,'null')								   AS YinzID         
			,NULLIF(id_global,'null')                              AS id_global              
			,NULLIF(name,'null')                                   AS name              
			,NULLIF(nick,'null')                                   AS nick              
			,NULLIF(image_url,'null')                              AS image_url              
			,NULLIF(image_url_small,'null')                        AS image_url_small              
			,NULLIF(image_url_large,'null')                        AS image_url_large              
			,NULLIF(image_url_background,'null')                   AS image_url_background              
			,NULLIF(twitter_favorites_count,'null')                AS twitter_favorites_count              
			,NULLIF(twitter_followers_count,'null')                AS twitter_followers_count              
			,NULLIF(twitter_friends_count,'null')                  AS twitter_friends_count              
			,NULLIF(twitter_listed_count,'null')                   AS twitter_listed_count              
			,NULLIF(twitter_statuses_count,'null')                 AS twitter_statuses_count              
			,NULLIF(timezone_name,'null')                          AS timezone_name              
			,NULLIF(timezone_offset,'null')                        AS timezone_offset              
			,NULLIF(language_affinities,'null')                    AS language_affinities              
	INTO #stg 
	FROM
		(   SELECT a.Insert_datetime
				  ,a.YinzID
				  ,b.[Key] AS field
				  ,c.Value
			FROM apietl.yinzcam_Twitter_0 a
				JOIN apietl.yinzcam_Twitter_Entry_1 b ON b.yinzcam_Twitter_id = a.yinzcam_Twitter_id
				JOIN apietl.yinzcam_Twitter_Entry_Values_2 c ON c.yinzcam_Twitter_Entry_id = b.yinzcam_Twitter_Entry_id
		) base
		PIVOT
		(   MAX(Value) FOR field IN (timestamp_create
									,id_global
									,name
									,nick
									,image_url
									,image_url_small
									,image_url_large
									,image_url_background
									,twitter_favorites_count
									,twitter_followers_count
									,twitter_friends_count
									,twitter_listed_count
									,twitter_statuses_count
									,timezone_name
									,timezone_offset
									,language_affinities)
		) pvt


	/*====================================================================================================
												RECORD DELETES
	====================================================================================================*/

	INSERT INTO ods.Yinzcam_Twitter_Deletes

	SELECT ods.*, GETDATE() DeletedDate
	FROM ods.Yinzcam_Twitter ods
		LEFT JOIN #stg stg ON stg.YinzID = ods.yinzID
	WHERE stg.yinzID IS NULL

	/*====================================================================================================
												LOAD ODS
	====================================================================================================*/

	TRUNCATE TABLE ods.Yinzcam_Twitter

	INSERT INTO ods.Yinzcam_Twitter

	SELECT * FROM #stg

	SET @LoadCount = @@ROWCOUNT

	/*====================================================================================================
												LOG RESULTS
	====================================================================================================*/

	INSERT INTO etl.YinzCam_Load_Monitoring (
	RunDate			--DATE
	,ProcName		--VARCHAR(100)
	,StartTime		--DATETIME
	,EndTime		--DATETIME
	,Completed		--BIT
	,LoadCount		--INT
	,ErrorMessage	--NVARCHAR(4000)
	,ErrorSeverity  --INT
	,ErrorState	    --INT
	)

	VALUES(
	@RunDate
	,@ProcName
	,@RunTime
	,GETDATE()
	,1
	,@LoadCount
	,NULL
	,NULL
	,NULL
	)

	DROP TABLE #stg

END TRY
/*========================================================================================================================
													START CATCH
========================================================================================================================*/

BEGIN CATCH

	/*====================================================================================================
												LOG ERRORS
	====================================================================================================*/

	SET @ErrorMessage  = ERROR_MESSAGE()	
	SET @ErrorSeverity = ERROR_SEVERITY()	
	SET @ErrorState	   = ERROR_STATE()	


	INSERT INTO etl.YinzCam_Load_Monitoring (
	RunDate			--DATE
	,ProcName		--VARCHAR(100)
	,StartTime		--DATETIME
	,EndTime		--DATETIME
	,Completed		--BIT
	,LoadCount		--INT
	,ErrorMessage	--NVARCHAR(4000)
	,ErrorSeverity  --INT
	,ErrorState	    --INT
	)

	VALUES(
	@RunDate
	,@ProcName
	,@RunTime
	,GETDATE()
	,0
	,NULL
	,@ErrorMessage 
	,@ErrorSeverity
	,@ErrorState	  
	)

	DROP TABLE #stg

END CATCH



GO
