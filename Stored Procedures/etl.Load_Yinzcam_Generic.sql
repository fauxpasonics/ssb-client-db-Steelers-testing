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

CREATE PROC [etl].[Load_Yinzcam_Generic]

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

	IF NOT EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_user_id' AND object_id = OBJECT_ID('apietl.yinzcam_user_0') )
	BEGIN CREATE NONCLUSTERED INDEX IX_user_id on apietl.yinzcam_user_0				(ETL__yinzcam_user_id)		   END

	IF NOT EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_user_id' AND object_id = OBJECT_ID('apietl.yinzcam_user_Entry_1') )
	BEGIN CREATE NONCLUSTERED INDEX IX_user_id on apietl.yinzcam_user_Entry_1			(ETL__yinzcam_user_id)	   END
	
	IF NOT EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_Entry_id' AND object_id = OBJECT_ID('apietl.yinzcam_user_Entry_1') )
	BEGIN CREATE NONCLUSTERED INDEX IX_Entry_id on apietl.yinzcam_user_Entry_1		(ETL__yinzcam_user_Entry_id)   END
	
	IF NOT EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_Entry_id' AND object_id = OBJECT_ID('apietl.yinzcam_user_Entry_Values_2') )
	BEGIN CREATE NONCLUSTERED INDEX IX_Entry_id on apietl.yinzcam_user_Entry_Values_2 (ETL__yinzcam_user_Entry_id) END

	SELECT  YinzID
		   ,abi_optout
		   ,address_country
		   ,address_postal
		   ,CAST(birth_date AS date) AS birth_date
		   ,CAST(birthdate AS date) AS birthdate
		   ,email
		   ,email_optout
		   ,filter_presets
		   ,first_name
		   ,gender
		   ,image_url
		   ,last_name
		   ,phone
		   ,CAST(wgu_card_android_timestamp AS datetime) AS wgu_card_android_timestamp
		   ,wgu_card_android_url
		   ,ETL__insert_datetime
	INTO #stg
	FROM
		(  SELECT a.ETL__insert_datetime
				  ,CONVERT(VARCHAR(50),a.YinzID) YinzID
				  ,b.[Key] AS field
				  ,c.Value
			FROM apietl.yinzcam_user_0 a
				JOIN apietl.yinzcam_user_Entry_1 b ON b.ETL__yinzcam_user_id = a.ETL__yinzcam_user_id
				JOIN apietl.yinzcam_user_Entry_Values_2 c ON c.ETL__yinzcam_user_Entry_id = b.ETL__yinzcam_user_Entry_id
			--WHERE a.YinzID = 'b0429fcd-be87-4dce-af9b-3b574e8eb496'
		) base
		PIVOT
		(   MAX(Value) FOR field IN ( abi_optout
									 ,address_country
									 ,address_postal
									 ,birth_date
									 ,birthdate
									 ,email
									 ,email_optout
									 ,filter_presets
									 ,first_name
									 ,gender
									 ,image_url
									 ,last_name
									 ,phone
									 ,wgu_card_android_timestamp
									 ,wgu_card_android_url
									 )
		) pvt

	CREATE NONCLUSTERED INDEX IX_yinzID ON #stg (YinzID)
	
	/*====================================================================================================
												LOAD ODS
	====================================================================================================*/

	MERGE INTO ods.Yinzcam_Generic AS MyTarget

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

	 MyTarget.[ETL_UpdatedDate]						= GETDATE()
	,MyTarget.[YinzID]								= MySource.[YinzID]                    
	,MyTarget.[abi_optout]							= MySource.[abi_optout]                
	,MyTarget.[address_country]						= MySource.[address_country]           
	,MyTarget.[address_postal]						= MySource.[address_postal]            
	,MyTarget.[birth_date]							= MySource.[birth_date]				
	,MyTarget.[birthdate]							= MySource.[birthdate]				
	,MyTarget.[email]								= MySource.[email]                     
	,MyTarget.[email_optout]						= MySource.[email_optout]              
	,MyTarget.[filter_presets]						= MySource.[filter_presets]            
	,MyTarget.[first_name]							= MySource.[first_name]                
	,MyTarget.[gender]								= MySource.[gender]                    
	,MyTarget.[image_url]							= MySource.[image_url]                 
	,MyTarget.[last_name]							= MySource.[last_name]                 
	,MyTarget.[phone]								= MySource.[phone]                     
	,MyTarget.[wgu_card_android_timestamp]			= MySource.[wgu_card_android_timestamp]
	,MyTarget.[wgu_card_android_url]				= MySource.[wgu_card_android_url]      
	,MyTarget.[ETL_IsDeleted]						= 0  
	,MyTarget.[ETL_DeletedDate]						= NULL
   
     
	 WHEN NOT MATCHED BY TARGET	THEN INSERT (ETL_CreatedDate	,ETL_UpdatedDate	,YinzID	,abi_optout	,address_country	,address_postal	,birth_date	
											,birthdate	,email	,email_optout	,filter_presets	,first_name	,gender	,image_url	,last_name	,phone	
											,wgu_card_android_timestamp	,wgu_card_android_url	,ETL_IsDeleted	,ETL_DeletedDate)

    
     
	 VALUES (   GETDATE()										--ETL_CreatedDate                  
			  , GETDATE()                  						--ETL_UpdatedDate                  
			  , MySource.[YinzID]								--YinzID                       
			  , MySource.[abi_optout]                   		--abi_optout                   
			  , MySource.[address_country]              		--address_country              
			  , MySource.[address_postal]               		--address_postal               
			  , MySource.[birth_date]							--birth_date					
			  , MySource.[birthdate]							--birthdate					
			  , MySource.[email]                        		--email                        
			  , MySource.[email_optout]                 		--email_optout                 
			  , MySource.[filter_presets]               		--filter_presets               
			  , MySource.[first_name]                   		--first_name                   
			  , MySource.[gender]                       		--gender                       
			  , MySource.[image_url]                    		--image_url                    
			  , MySource.[last_name]                    		--last_name                    
			  , MySource.[phone]                        		--phone                        
			  , MySource.[wgu_card_android_timestamp]			--wgu_card_android_timestamp	
			  , MySource.[wgu_card_android_url]                 --wgu_card_android_url                      
			  , 0                  								--ETL_IsDeleted                    
			  , NULL                  							--ETL_DeletedDate                  
    
	)

	WHEN NOT MATCHED BY SOURCE THEN UPDATE 

	SET  MyTarget.[ETL_IsDeleted]         	= 1   
		,MyTarget.[ETL_DeletedDate]       	= GETDATE()
	;

	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_yinzID' AND object_id = OBJECT_ID('ods.Yinzcam_Generic') )
	BEGIN DROP INDEX IX_yinzID ON ods.Yinzcam_Generic END
	
	CREATE NONCLUSTERED INDEX IX_yinzID ON ods.Yinzcam_Generic (YinzID)

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

	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_user_id' AND object_id = OBJECT_ID('apietl.yinzcam_user_0') )
	BEGIN DROP INDEX IX_user_id ON apietl.yinzcam_user_0 END

	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_user_id' AND object_id = OBJECT_ID('apietl.yinzcam_user_Entry_1') )
	BEGIN DROP INDEX IX_user_id ON apietl.yinzcam_user_Entry_1 END
	
	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_Entry_id' AND object_id = OBJECT_ID('apietl.yinzcam_user_Entry_1') )
	BEGIN DROP INDEX IX_Entry_id ON apietl.yinzcam_user_Entry_1 END
	
	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_Entry_id' AND object_id = OBJECT_ID('apietl.yinzcam_user_Entry_Values_2') )
	BEGIN DROP INDEX IX_Entry_id ON apietl.yinzcam_user_Entry_Values_2 END

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

	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_user_id' AND object_id = OBJECT_ID('apietl.yinzcam_user_0') )
	BEGIN DROP INDEX IX_user_id ON apietl.yinzcam_user_0 END

	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_user_id' AND object_id = OBJECT_ID('apietl.yinzcam_user_Entry_1') )
	BEGIN DROP INDEX IX_user_id ON apietl.yinzcam_user_Entry_1 END
	
	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_Entry_id' AND object_id = OBJECT_ID('apietl.yinzcam_user_Entry_1') )
	BEGIN DROP INDEX IX_Entry_id ON apietl.yinzcam_user_Entry_1 END
	
	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_Entry_id' AND object_id = OBJECT_ID('apietl.yinzcam_user_Entry_Values_2') )
	BEGIN DROP INDEX IX_Entry_id ON apietl.yinzcam_user_Entry_Values_2 END


END CATCH






GO
