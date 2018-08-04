SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- Author name: Jeff Barberio

-- Created date: 6/15/2017

-- Purpose: Dimcustomer Load

-- Copyright © 2018, SSB, All Rights Reserved

-------------------------------------------------------------------------------

-- Modification History --

-- 6/16/2018: Jeff Barberio

	-- Change notes: commented out "WITH EXEC AS OWNER". this command was restricting the API users permissions and causing failures
	
	-- Peer reviewed by: Keegan Schmitt
	
	-- Peer review notes: 
	
	-- Peer review date: 6/19/2018
	
	-- Deployed by:
	
	-- Deployment date:
	
	-- Deployment notes:

-------------------------------------------------------------------------------

-------------------------------------------------------------------------------


CREATE PROC [etl].[Load_Yinzcam_500f]

--WITH EXEC AS OWNER	--Allow the calling user to perform all operations inside the PROC as long as they have permission to execute the PROC (eg insert/deletes to tables)

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

	IF NOT EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_fivehundredfriends_id' AND object_id = OBJECT_ID('apietl.yinzcam_fivehundredfriends_0') )
	BEGIN CREATE NONCLUSTERED INDEX IX_fivehundredfriends_id on apietl.yinzcam_fivehundredfriends_0				(ETL__yinzcam_fivehundredfriends_id)		   END

	IF NOT EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_fivehundredfriends_id' AND object_id = OBJECT_ID('apietl.yinzcam_fivehundredfriends_Entry_1') )
	BEGIN CREATE NONCLUSTERED INDEX IX_fivehundredfriends_id on apietl.yinzcam_fivehundredfriends_Entry_1			(ETL__yinzcam_fivehundredfriends_id)	   END
	
	IF NOT EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_Entry_id' AND object_id = OBJECT_ID('apietl.yinzcam_fivehundredfriends_Entry_1') )
	BEGIN CREATE NONCLUSTERED INDEX IX_Entry_id on apietl.yinzcam_fivehundredfriends_Entry_1		(ETL__yinzcam_fivehundredfriends_Entry_id)   END
	
	IF NOT EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_Entry_id' AND object_id = OBJECT_ID('apietl.yinzcam_fivehundredfriends_Entry_Values_2') )
	BEGIN CREATE NONCLUSTERED INDEX IX_Entry_id on apietl.yinzcam_fivehundredfriends_Entry_Values_2 (ETL__yinzcam_fivehundredfriends_Entry_id) END

	SELECT  pvt.ETL__insert_datetime
		   ,pvt.YinzID
		   ,NULLIF(email,'null')												AS email
		   ,NULLIF(id_external,'null')											AS id_external
		   ,NULLIF(loyalty_subscription_type,'null')							AS loyalty_subscription_type
		   ,NULLIF(status_name,'null')											AS status_name
		   ,NULLIF(status_active,'null')										AS status_active
		   ,CAST(NULLIF(loyalty_points_current,'null') AS INT)					AS loyalty_points_current
		   ,NULLIF(loyalty_tier_name,'null')									AS loyalty_tier_name
		   ,CAST(NULLIF(loyalty_points_lifetime,'null') AS INT)					AS loyalty_points_lifetime
		   ,NULLIF(loyalty_channel,'null')										AS loyalty_channel
		   ,NULLIF(loyalty_subchannel,'null')									AS loyalty_subchannel
		   ,NULLIF(loyalty_subchannel_detail,'null')							AS loyalty_subchannel_detail
		   ,CAST(NULLIF(loyalty_unsubscribed,'null') AS BIT)					AS loyalty_unsubscribed
		   ,CAST(NULLIF(sms_optout,'null')			 AS BIT)					AS sms_optout
		   ,NULLIF(loyalty_last_reward_event_id,'null')							AS loyalty_last_reward_event_id
		   ,CAST(NULLIF(loyalty_tier_expiration_timestamp,'null') AS DATETIME)	AS loyalty_tier_expiration_timestamp
		   ,CAST(NULLIF(timestamp_enroll,'null') AS DATETIME)					AS timestamp_enroll
		   ,CAST(NULLIF(timestamp_create,'null') AS DATETIME)					AS timestamp_create
		   ,CAST(NULLIF(timestamp_active,'null') AS DATETIME)					AS timestamp_active
		   ,CAST(NULLIF(timestamp_update,'null') AS DATETIME)					AS timestamp_update
		   ,NULLIF(url_login_dcg,'null')										AS url_login_dcg
		   ,NULLIF(token_login_dcg,'null')										AS token_login_dcg
		   ,NULLIF(image_url,'null')											AS image_url
	INTO #stg
	FROM
		(  SELECT a.ETL__insert_datetime
				  ,CONVERT(VARCHAR(50),a.YinzID) YinzID
				  ,b.[Key] AS field
				  ,c.Value
			FROM apietl.yinzcam_fivehundredfriends_0 a
				JOIN apietl.yinzcam_fivehundredfriends_Entry_1 b ON b.ETL__yinzcam_fivehundredfriends_id = a.ETL__yinzcam_fivehundredfriends_id
				JOIN apietl.yinzcam_fivehundredfriends_Entry_Values_2 c ON c.ETL__yinzcam_fivehundredfriends_Entry_id = b.ETL__yinzcam_fivehundredfriends_Entry_id
			--WHERE a.YinzID = 'b0429fcd-be87-4dce-af9b-3b574e8eb496'
		) base
		PIVOT
		(   MAX(Value) FOR field IN ( email
									 ,id_external
									 ,loyalty_subscription_type
									 ,status_name
									 ,status_active
									 ,loyalty_points_current
									 ,loyalty_tier_name
									 ,loyalty_points_lifetime
									 ,loyalty_channel
									 ,loyalty_subchannel
									 ,loyalty_subchannel_detail
									 ,loyalty_unsubscribed
									 ,sms_optout
									 ,loyalty_last_reward_event_id
									 ,loyalty_tier_expiration_timestamp
									 ,timestamp_enroll
									 ,timestamp_create
									 ,timestamp_active
									 ,timestamp_update
									 ,url_login_dcg
									 ,token_login_dcg
									 ,image_url)
		) pvt

	CREATE NONCLUSTERED INDEX IX_yinzID ON #stg (YinzID)

	/*====================================================================================================
												LOAD ODS
	====================================================================================================*/

	MERGE INTO ods.Yinzcam_500f AS MyTarget

	USING (SELECT *
		   FROM (SELECT *
					   ,ROW_NUMBER() OVER(PARTITION BY YinzID ORDER BY ETL__insert_datetime, NEWID()) rnk
				 FROM #stg
				)x
		   WHERE rnk = 1
		   ) AS MySource
		
		ON MyTarget.yinzid = MySource.YinzID


	WHEN MATCHED
	THEN UPDATE SET

	 MyTarget.[ETL_UpdatedDate]					  = GETDATE()
	,MyTarget.[YinzID]                            = MySource.[YinzID]                           
	,MyTarget.[email]                             = MySource.[email]                            
	,MyTarget.[id_external]                       = MySource.[id_external]                      
	,MyTarget.[loyalty_subscription_type]         = MySource.[loyalty_subscription_type]        
	,MyTarget.[status_name]                       = MySource.[status_name]                      
	,MyTarget.[status_active]                     = MySource.[status_active]                    
	,MyTarget.[loyalty_points_current]            = MySource.[loyalty_points_current]           
	,MyTarget.[loyalty_tier_name]                 = MySource.[loyalty_tier_name]                
	,MyTarget.[loyalty_points_lifetime]           = MySource.[loyalty_points_lifetime]          
	,MyTarget.[loyalty_channel]                   = MySource.[loyalty_channel]                  
	,MyTarget.[loyalty_subchannel]                = MySource.[loyalty_subchannel]               
	,MyTarget.[loyalty_subchannel_detail]         = MySource.[loyalty_subchannel_detail]        
	,MyTarget.[loyalty_unsubscribed]              = MySource.[loyalty_unsubscribed]             
	,MyTarget.[sms_optout]                        = MySource.[sms_optout]                       
	,MyTarget.[loyalty_last_reward_event_id]      = MySource.[loyalty_last_reward_event_id]     
	,MyTarget.[loyalty_tier_expiration_timestamp] = MySource.[loyalty_tier_expiration_timestamp]
	,MyTarget.[timestamp_enroll]                  = MySource.[timestamp_enroll]                 
	,MyTarget.[timestamp_create]                  = MySource.[timestamp_create]                 
	,MyTarget.[timestamp_active]                  = MySource.[timestamp_active]                 
	,MyTarget.[timestamp_update]                  = MySource.[timestamp_update]                 
	,MyTarget.[url_login_dcg]                     = MySource.[url_login_dcg]                    
	,MyTarget.[token_login_dcg]                   = MySource.[token_login_dcg]                  
	,MyTarget.[image_url]                         = MySource.[image_url]                        
	,MyTarget.[ETL_IsDeleted]					  = 0  
	,MyTarget.[ETL_DeletedDate]					  = NULL

   
     
	 WHEN NOT MATCHED BY TARGET	THEN INSERT (ETL_CreatedDate	,ETL_UpdatedDate	,YinzID	,email	,id_external	,loyalty_subscription_type	,status_name	
											,status_active	,loyalty_points_current	,loyalty_tier_name	,loyalty_points_lifetime	,loyalty_channel	,loyalty_subchannel	
											,loyalty_subchannel_detail	,loyalty_unsubscribed	,sms_optout	,loyalty_last_reward_event_id	,loyalty_tier_expiration_timestamp	
											,timestamp_enroll	,timestamp_create	,timestamp_active	,timestamp_update	,url_login_dcg	,token_login_dcg	
											,image_url	,ETL_IsDeleted	,ETL_DeletedDate)

    
     
	 VALUES (   GETDATE()										--ETL_CreatedDate                  
			  , GETDATE()                  						--ETL_UpdatedDate                  
			  , MySource.[YinzID]                           	--YinzID                           
			  , MySource.[email]                            	--email                            
			  , MySource.[id_external]                      	--id_external                      
			  , MySource.[loyalty_subscription_type]        	--loyalty_subscription_type        
			  , MySource.[status_name]                      	--status_name                      
			  , MySource.[status_active]                    	--status_active                    
			  , MySource.[loyalty_points_current]           	--loyalty_points_current           
			  , MySource.[loyalty_tier_name]                	--loyalty_tier_name                
			  , MySource.[loyalty_points_lifetime]          	--loyalty_points_lifetime          
			  , MySource.[loyalty_channel]                  	--loyalty_channel                  
			  , MySource.[loyalty_subchannel]               	--loyalty_subchannel               
			  , MySource.[loyalty_subchannel_detail]        	--loyalty_subchannel_detail        
			  , MySource.[loyalty_unsubscribed]             	--loyalty_unsubscribed             
			  , MySource.[sms_optout]                       	--sms_optout                       
			  , MySource.[loyalty_last_reward_event_id]     	--loyalty_last_reward_event_id     
			  , MySource.[loyalty_tier_expiration_timestamp]	--loyalty_tier_expiration_timestamp
			  , MySource.[timestamp_enroll]                 	--timestamp_enroll                 
			  , MySource.[timestamp_create]                 	--timestamp_create                 
			  , MySource.[timestamp_active]                 	--timestamp_active                 
			  , MySource.[timestamp_update]                 	--timestamp_update                 
			  , MySource.[url_login_dcg]                    	--url_login_dcg                    
			  , MySource.[token_login_dcg]                  	--token_login_dcg                  
			  , MySource.[image_url]                        	--image_url                        
			  , 0                  								--ETL_IsDeleted                    
			  , NULL                  							--ETL_DeletedDate                  
    
	)

	WHEN NOT MATCHED BY SOURCE THEN UPDATE 

	SET  MyTarget.[ETL_IsDeleted]         	= 1   
		,MyTarget.[ETL_DeletedDate]       	= GETDATE()

	;

	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_yinzID' AND object_id = OBJECT_ID('ods.Yinzcam_500f') )
	BEGIN DROP INDEX IX_yinzID on ods.Yinzcam_500f END

	CREATE NONCLUSTERED INDEX IX_yinzID ON ods.Yinzcam_500f (YinzID)

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
	,NULL
	,NULL
	,NULL
	,NULL
	)

	DROP TABLE #stg

	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_fivehundredfriends_id' AND object_id = OBJECT_ID('apietl.yinzcam_fivehundredfriends_0') )
	BEGIN DROP INDEX IX_fivehundredfriends_id ON apietl.yinzcam_fivehundredfriends_0 END

	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_fivehundredfriends_id' AND object_id = OBJECT_ID('apietl.yinzcam_fivehundredfriends_Entry_1') )
	BEGIN DROP INDEX IX_fivehundredfriends_id ON apietl.yinzcam_fivehundredfriends_Entry_1 END
	
	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_Entry_id' AND object_id = OBJECT_ID('apietl.yinzcam_fivehundredfriends_Entry_1') )
	BEGIN DROP INDEX IX_Entry_id ON apietl.yinzcam_fivehundredfriends_Entry_1 END
	
	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_Entry_id' AND object_id = OBJECT_ID('apietl.yinzcam_fivehundredfriends_Entry_Values_2') )
	BEGIN DROP INDEX IX_Entry_id ON apietl.yinzcam_fivehundredfriends_Entry_Values_2 END

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

	IF EXISTS (SELECT OBJECT_ID('tempdb..#stg')) DROP TABLE #stg

	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_fivehundredfriends_id' AND object_id = OBJECT_ID('apietl.yinzcam_fivehundredfriends_0') )
	BEGIN DROP INDEX IX_fivehundredfriends_id ON apietl.yinzcam_fivehundredfriends_0 END

	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_fivehundredfriends_id' AND object_id = OBJECT_ID('apietl.yinzcam_fivehundredfriends_Entry_1') )
	BEGIN DROP INDEX IX_fivehundredfriends_id ON apietl.yinzcam_fivehundredfriends_Entry_1 END
	
	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_Entry_id' AND object_id = OBJECT_ID('apietl.yinzcam_fivehundredfriends_Entry_1') )
	BEGIN DROP INDEX IX_Entry_id ON apietl.yinzcam_fivehundredfriends_Entry_1 END
	
	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_Entry_id' AND object_id = OBJECT_ID('apietl.yinzcam_fivehundredfriends_Entry_Values_2') )
	BEGIN DROP INDEX IX_Entry_id ON apietl.yinzcam_fivehundredfriends_Entry_Values_2 END

END CATCH




GO
