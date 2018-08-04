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

CREATE PROC [etl].[Load_Yinzcam_Facebook]

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
	
	IF NOT EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_facebook_id' AND object_id = OBJECT_ID('apietl.yinzcam_facebook_0') )
	BEGIN CREATE NONCLUSTERED INDEX IX_facebook_id on apietl.yinzcam_facebook_0				(ETL__yinzcam_facebook_id)		   END

	IF NOT EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_facebook_id' AND object_id = OBJECT_ID('apietl.yinzcam_facebook_Entry_1') )
	BEGIN CREATE NONCLUSTERED INDEX IX_facebook_id on apietl.yinzcam_facebook_Entry_1			(ETL__yinzcam_facebook_id)	   END
	
	IF NOT EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_Entry_id' AND object_id = OBJECT_ID('apietl.yinzcam_facebook_Entry_1') )
	BEGIN CREATE NONCLUSTERED INDEX IX_Entry_id on apietl.yinzcam_facebook_Entry_1		(ETL__yinzcam_facebook_Entry_id)   END
	
	IF NOT EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_Entry_id' AND object_id = OBJECT_ID('apietl.yinzcam_facebook_Entry_Values_2') )
	BEGIN CREATE NONCLUSTERED INDEX IX_Entry_id on apietl.yinzcam_facebook_Entry_Values_2 (ETL__yinzcam_facebook_Entry_id) END


	SELECT ETL__insert_datetime
		  ,yinzid
		  ,NULLIF(first_name,'null')first_name
		  ,NULLIF(last_name,'null')last_name
		  ,NULLIF(gender,'null')gender
		  ,NULLIF(email,'null')email
		  ,NULLIF(locale,'null')locale
		  ,CASE WHEN timezone_offset = 'null' THEN NULL ELSE CAST(LEFT(timezone_offset,CHARINDEX('.',timezone_offset)-1) AS INT) END timezone_offset
		  ,CAST(NULLIF(timestamp_update,'null') AS DATETIME) timestamp_update
		  ,NULLIF(id_thirdparty,'null')id_thirdparty
		  ,NULLIF(link,'null')link
		  ,CAST(NULLIF(verified,'null') AS BIT) verified
		  ,NULLIF(currency,'null' )currency
		  ,NULLIF(id_global,'null')id_global
	INTO #stg
	FROM
		(  SELECT a.ETL__insert_datetime
				  ,CONVERT(VARCHAR(50),a.YinzID) yinzid
				  ,b.[Key] AS field
				  ,c.Value
			FROM apietl.yinzcam_facebook_0 a
				JOIN apietl.yinzcam_facebook_Entry_1 b ON b.ETL__yinzcam_facebook_id = a.ETL__yinzcam_facebook_id
				JOIN apietl.yinzcam_facebook_Entry_Values_2 c ON c.ETL__yinzcam_facebook_Entry_id = b.ETL__yinzcam_facebook_Entry_id
		) base
		PIVOT
		(   MAX(Value) FOR field IN ( first_name
									 ,last_name
									 ,gender
									 ,email
									 ,locale
									 ,timezone_offset
									 ,timestamp_update
									 ,id_thirdparty
									 ,link
									 ,verified
									 ,currency
									 ,id_global)
		) pvt

	CREATE NONCLUSTERED INDEX IX_yinzID ON #stg (YinzID)

	/*====================================================================================================
												LOAD ODS
	====================================================================================================*/

	MERGE INTO ods.Yinzcam_Facebook AS MyTarget

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

	 MyTarget.[ETL_UpdatedDate]  = GETDATE()
	,MyTarget.[yinzid]           = MySource.[yinzid]          
	,MyTarget.[first_name]       = MySource.[first_name]      
	,MyTarget.[last_name]        = MySource.[last_name]       
	,MyTarget.[gender]           = MySource.[gender]          
	,MyTarget.[email]            = MySource.[email]           
	,MyTarget.[locale]           = MySource.[locale]          
	,MyTarget.[timezone_offset]  = MySource.[timezone_offset] 
	,MyTarget.[timestamp_update] = MySource.[timestamp_update]
	,MyTarget.[id_thirdparty]    = MySource.[id_thirdparty]   
	,MyTarget.[link]             = MySource.[link]            
	,MyTarget.[verified]         = MySource.[verified]        
	,MyTarget.[currency]         = MySource.[currency]        
	,MyTarget.[id_global]        = MySource.[id_global]       
	,MyTarget.[ETL_IsDeleted]    = 0  
	,MyTarget.[ETL_DeletedDate]  = NULL

   
     
	 WHEN NOT MATCHED BY TARGET	THEN INSERT (ETL_CreatedDate, ETL_UpdatedDate, yinzid, first_name, last_name, gender, email, locale	
											, timezone_offset, timestamp_update, id_thirdparty, link, verified, currency, id_global	
											, ETL_IsDeleted, ETL_DeletedDate)
    
     
	 VALUES ( GETDATE()							--ETL_CreatedDate 
			 ,GETDATE() 						--ETL_UpdatedDate 
			 ,MySource.[yinzid]          		--yinzid          
			 ,MySource.[first_name]      		--first_name      
			 ,MySource.[last_name]       		--last_name       
			 ,MySource.[gender]          		--gender          
			 ,MySource.[email]           		--email           
			 ,MySource.[locale]          		--locale          
			 ,MySource.[timezone_offset] 		--timezone_offset 
			 ,MySource.[timestamp_update]		--timestamp_update
			 ,MySource.[id_thirdparty]   		--id_thirdparty   
			 ,MySource.[link]            		--link            
			 ,MySource.[verified]        		--verified        
			 ,MySource.[currency]        		--currency        
			 ,MySource.[id_global]       		--id_global       
			 ,0   								--ETL_IsDeleted   
			 ,NULL								--ETL_DeletedDate 
    
	)

	WHEN NOT MATCHED BY SOURCE THEN UPDATE 

	SET  MyTarget.[ETL_IsDeleted]         	= 1   
		,MyTarget.[ETL_DeletedDate]       	= GETDATE()

	;

	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_yinzID' AND object_id = OBJECT_ID('ods.Yinzcam_facebook') )
	BEGIN DROP INDEX IX_yinzID on ods.Yinzcam_facebook END

	CREATE NONCLUSTERED INDEX IX_yinzID ON ods.Yinzcam_facebook (YinzID)

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

	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_facebook_id' AND object_id = OBJECT_ID('apietl.yinzcam_facebook_0') )
	BEGIN DROP INDEX IX_facebook_id ON apietl.yinzcam_facebook_0 END

	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_facebook_id' AND object_id = OBJECT_ID('apietl.yinzcam_facebook_Entry_1') )
	BEGIN DROP INDEX IX_facebook_id ON apietl.yinzcam_facebook_Entry_1 END
	
	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_Entry_id' AND object_id = OBJECT_ID('apietl.yinzcam_facebook_Entry_1') )
	BEGIN DROP INDEX IX_Entry_id ON apietl.yinzcam_facebook_Entry_1 END
	
	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_Entry_id' AND object_id = OBJECT_ID('apietl.yinzcam_facebook_Entry_Values_2') )
	BEGIN DROP INDEX IX_Entry_id ON apietl.yinzcam_facebook_Entry_Values_2 END

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

	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_facebook_id' AND object_id = OBJECT_ID('apietl.yinzcam_facebook_0') )
	BEGIN DROP INDEX IX_facebook_id ON apietl.yinzcam_facebook_0 END

	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_facebook_id' AND object_id = OBJECT_ID('apietl.yinzcam_facebook_Entry_1') )
	BEGIN DROP INDEX IX_facebook_id ON apietl.yinzcam_facebook_Entry_1 END
	
	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_Entry_id' AND object_id = OBJECT_ID('apietl.yinzcam_facebook_Entry_1') )
	BEGIN DROP INDEX IX_Entry_id ON apietl.yinzcam_facebook_Entry_1 END
	
	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_Entry_id' AND object_id = OBJECT_ID('apietl.yinzcam_facebook_Entry_Values_2') )
	BEGIN DROP INDEX IX_Entry_id ON apietl.yinzcam_facebook_Entry_Values_2 END

END CATCH







GO
