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

CREATE PROC [etl].[Load_Yinzcam_TM]

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

	IF NOT EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_ticketmaster_id' AND object_id = OBJECT_ID('apietl.yinzcam_ticketmaster_0') )
	BEGIN CREATE NONCLUSTERED INDEX IX_ticketmaster_id on apietl.yinzcam_ticketmaster_0				(ETL__yinzcam_ticketmaster_id)		   END

	IF NOT EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_ticketmaster_id' AND object_id = OBJECT_ID('apietl.yinzcam_ticketmaster_Entry_1') )
	BEGIN CREATE NONCLUSTERED INDEX IX_ticketmaster_id on apietl.yinzcam_ticketmaster_Entry_1			(ETL__yinzcam_ticketmaster_id)	   END
	
	IF NOT EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_Entry_id' AND object_id = OBJECT_ID('apietl.yinzcam_ticketmaster_Entry_1') )
	BEGIN CREATE NONCLUSTERED INDEX IX_Entry_id on apietl.yinzcam_ticketmaster_Entry_1		(ETL__yinzcam_ticketmaster_Entry_id)   END
	
	IF NOT EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_Entry_id' AND object_id = OBJECT_ID('apietl.yinzcam_ticketmaster_Entry_Values_2') )
	BEGIN CREATE NONCLUSTERED INDEX IX_Entry_id on apietl.yinzcam_ticketmaster_Entry_Values_2 (ETL__yinzcam_ticketmaster_Entry_id) END

	SELECT ETL__insert_datetime
		  ,CAST(NULLIF(timestamp_create ,'null') AS DATETIME)	  AS timestamp_create  
		  ,yinzid                                           
		  ,NULLIF(entity_class          ,'null')				  AS entity_class                                       
		  ,NULLIF(id_name               ,'null')				  AS id_name                                            
		  ,NULLIF(id_global             ,'null')				  AS id_global                                          
		  ,NULLIF(id_links              ,'null')				  AS id_links                                           
		  ,NULLIF(first_name            ,'null')				  AS first_name                                         
		  ,NULLIF(middle_initial        ,'null')				  AS middle_initial                                     
		  ,NULLIF(last_name             ,'null')				  AS last_name                                          
		  ,NULLIF(name                  ,'null')				  AS name                                               
		  ,NULLIF(email                 ,'null')				  AS email                                              
		  ,NULLIF(email_format          ,'null')				  AS email_format                                       
		  ,NULLIF(email_optout          ,'null')				  AS email_optout                                       
		  ,NULLIF(sms_optout            ,'null')				  AS sms_optout                                         
		  ,NULLIF(address_street_1      ,'null')				  AS address_street_1                                   
		  ,NULLIF(address_city          ,'null')				  AS address_city                                       
		  ,NULLIF(address_division_1    ,'null')				  AS address_division_1                                 
		  ,NULLIF(address_postal        ,'null')				  AS address_postal                                     
		  ,NULLIF(address_country       ,'null')				  AS address_country                                    
		  ,NULLIF(phone                 ,'null')				  AS phone                                              
		  ,NULLIF(phone_daytime         ,'null')				  AS phone_daytime                                      
		  ,NULLIF(phone_alternate_1     ,'null')				  AS phone_alternate_1                                  
		  ,NULLIF(sth_status            ,'null')				  AS sth_status                                         
		  ,NULLIF(sth_primary_id_global ,'null')				  AS sth_primary_id_global                              
		  ,NULLIF(sth_primary_first_name,'null')				  AS sth_primary_first_name                             
		  ,NULLIF(sth_primary_last_name ,'null')				  AS sth_primary_last_name                              
		  ,NULLIF(sth_plan_name         ,'null')				  AS sth_plan_name                                      
		  ,NULLIF(sth_plan_name_long    ,'null')				  AS sth_plan_name_long                                 
		  ,NULLIF(sth_primary_email     ,'null')				  AS sth_primary_email                                  
		  ,NULLIF(other_4               ,'null')				  AS other_4                                            
		  ,NULLIF(other_5               ,'null')				  AS other_5                                            
		  ,NULLIF(other_9               ,'null')				  AS other_9                                            
		  ,NULLIF(other_10              ,'null')				  AS other_10                                           
		  ,NULLIF(amgr_access_level     ,'null')				  AS amgr_access_level                                  
	INTO #stg
	FROM
		(  SELECT a.ETL__insert_datetime
				  ,CONVERT(VARCHAR(50),a.YinzID) YinzID
				  ,b.[Key] AS field
				  ,c.Value
			FROM apietl.yinzcam_TicketMaster_0 a
				JOIN apietl.yinzcam_TicketMaster_Entry_1 b ON b.ETL__yinzcam_TicketMaster_id = a.ETL__yinzcam_TicketMaster_id
				JOIN apietl.yinzcam_TicketMaster_Entry_Values_2 c ON c.ETL__yinzcam_TicketMaster_Entry_id = b.ETL__yinzcam_TicketMaster_Entry_id
		) base
		PIVOT
		(   MAX(Value) FOR field IN ( timestamp_create      
									 ,entity_class          
									 ,id_name               
									 ,id_global             
									 ,id_links              
									 ,first_name            
									 ,middle_initial        
									 ,last_name             
									 ,name                  
									 ,email                 
									 ,email_format          
									 ,email_optout          
									 ,sms_optout            
									 ,address_street_1      
									 ,address_city          
									 ,address_division_1    
									 ,address_postal        
									 ,address_country       
									 ,phone                 
									 ,phone_daytime         
									 ,phone_alternate_1     
									 ,sth_status            
									 ,sth_primary_id_global 
									 ,sth_primary_first_name
									 ,sth_primary_last_name 
									 ,sth_plan_name         
									 ,sth_plan_name_long    
									 ,sth_primary_email     
									 ,other_4               
									 ,other_5               
									 ,other_9               
									 ,other_10              
									 ,amgr_access_level)
		) pvt

	CREATE NONCLUSTERED INDEX IX_yinzID ON #stg (YinzID)

	/*====================================================================================================
												LOAD ODS
	====================================================================================================*/

	MERGE INTO ods.Yinzcam_TM AS MyTarget

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

   
	MyTarget.[ETL_UpdatedDate]       	= GETDATE()     
   ,MyTarget.[timestamp_create]      	= MySource.[timestamp_create]      
   ,MyTarget.[YinzID]                	= MySource.[YinzID]                
   ,MyTarget.[entity_class]          	= MySource.[entity_class]          
   ,MyTarget.[id_name]               	= MySource.[id_name]               
   ,MyTarget.[id_global]             	= MySource.[id_global]             
   ,MyTarget.[id_links]              	= MySource.[id_links]              
   ,MyTarget.[first_name]            	= MySource.[first_name]            
   ,MyTarget.[middle_initial]        	= MySource.[middle_initial]        
   ,MyTarget.[last_name]             	= MySource.[last_name]             
   ,MyTarget.[name]                  	= MySource.[name]                  
   ,MyTarget.[email]                 	= MySource.[email]                 
   ,MyTarget.[email_format]          	= MySource.[email_format]          
   ,MyTarget.[email_optout]          	= MySource.[email_optout]          
   ,MyTarget.[sms_optout]            	= MySource.[sms_optout]            
   ,MyTarget.[address_street_1]      	= MySource.[address_street_1]      
   ,MyTarget.[address_city]          	= MySource.[address_city]          
   ,MyTarget.[address_division_1]    	= MySource.[address_division_1]    
   ,MyTarget.[address_postal]        	= MySource.[address_postal]        
   ,MyTarget.[address_country]       	= MySource.[address_country]       
   ,MyTarget.[phone]                 	= MySource.[phone]                 
   ,MyTarget.[phone_daytime]         	= MySource.[phone_daytime]         
   ,MyTarget.[phone_alternate_1]     	= MySource.[phone_alternate_1]     
   ,MyTarget.[sth_status]            	= MySource.[sth_status]            
   ,MyTarget.[sth_primary_id_global] 	= MySource.[sth_primary_id_global] 
   ,MyTarget.[sth_primary_first_name]	= MySource.[sth_primary_first_name]
   ,MyTarget.[sth_primary_last_name] 	= MySource.[sth_primary_last_name] 
   ,MyTarget.[sth_plan_name]         	= MySource.[sth_plan_name]         
   ,MyTarget.[sth_plan_name_long]    	= MySource.[sth_plan_name_long]    
   ,MyTarget.[sth_primary_email]     	= MySource.[sth_primary_email]     
   ,MyTarget.[other_4]               	= MySource.[other_4]               
   ,MyTarget.[other_5]               	= MySource.[other_5]               
   ,MyTarget.[other_9]               	= MySource.[other_9]               
   ,MyTarget.[other_10]              	= MySource.[other_10]              
   ,MyTarget.[amgr_access_level]     	= MySource.[amgr_access_level]     
   ,MyTarget.[ETL_IsDeleted]         	= 0        
   ,MyTarget.[ETL_DeletedDate]       	= NULL   
   
     
	 WHEN NOT MATCHED BY TARGET	THEN INSERT (ETL_CreatedDate, ETL_UpdatedDate ,timestamp_create ,YinzID ,entity_class ,id_name ,id_global ,id_links ,first_name 
											 ,middle_initial ,last_name ,name ,email ,email_format ,email_optout ,sms_optout ,address_street_1 ,address_city 
											 ,address_division_1 ,address_postal ,address_country ,phone ,phone_daytime ,phone_alternate_1 ,sth_status
											 ,sth_primary_id_global ,sth_primary_first_name,sth_primary_last_name ,sth_plan_name ,sth_plan_name_long ,sth_primary_email
											 ,other_4 ,other_5 ,other_9 ,other_10 ,amgr_access_level ,ETL_IsDeleted ,ETL_DeletedDate)       
     
	 VALUES (

	 GETDATE()									--ETL_CreatedDate       
	,GETDATE()       							--ETL_UpdatedDate       
	,MySource.[timestamp_create]      			--timestamp_create      
	,MySource.[YinzID]                			--YinzID                
	,MySource.[entity_class]          			--entity_class          
	,MySource.[id_name]               			--id_name               
	,MySource.[id_global]             			--id_global             
	,MySource.[id_links]              			--id_links              
	,MySource.[first_name]            			--first_name            
	,MySource.[middle_initial]        			--middle_initial        
	,MySource.[last_name]             			--last_name             
	,MySource.[name]                  			--name                  
	,MySource.[email]                 			--email                 
	,MySource.[email_format]          			--email_format          
	,MySource.[email_optout]          			--email_optout          
	,MySource.[sms_optout]            			--sms_optout            
	,MySource.[address_street_1]      			--address_street_1      
	,MySource.[address_city]          			--address_city          
	,MySource.[address_division_1]    			--address_division_1    
	,MySource.[address_postal]        			--address_postal        
	,MySource.[address_country]       			--address_country       
	,MySource.[phone]                 			--phone                 
	,MySource.[phone_daytime]         			--phone_daytime         
	,MySource.[phone_alternate_1]     			--phone_alternate_1     
	,MySource.[sth_status]            			--sth_status            
	,MySource.[sth_primary_id_global] 			--sth_primary_id_global 
	,MySource.[sth_primary_first_name]			--sth_primary_first_name
	,MySource.[sth_primary_last_name] 			--sth_primary_last_name 
	,MySource.[sth_plan_name]         			--sth_plan_name         
	,MySource.[sth_plan_name_long]    			--sth_plan_name_long    
	,MySource.[sth_primary_email]     			--sth_primary_email     
	,MySource.[other_4]               			--other_4               
	,MySource.[other_5]               			--other_5               
	,MySource.[other_9]               			--other_9               
	,MySource.[other_10]              			--other_10              
	,MySource.[amgr_access_level]     			--amgr_access_level     
	,0       									--ETL_IsDeleted         
	,NULL       								--ETL_DeletedDate       
	)

	WHEN NOT MATCHED BY SOURCE THEN UPDATE 

	SET  MyTarget.[ETL_IsDeleted]         	= 1   
		,MyTarget.[ETL_DeletedDate]       	= GETDATE()

	;


	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_yinzID' AND object_id = OBJECT_ID('ods.Yinzcam_TM') )
	BEGIN DROP INDEX IX_yinzID on ods.Yinzcam_TM END

	CREATE NONCLUSTERED INDEX IX_yinzID ON ods.Yinzcam_TM (YinzID)
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

	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_ticketmaster_id' AND object_id = OBJECT_ID('apietl.yinzcam_ticketmaster_0') )
	BEGIN DROP INDEX IX_ticketmaster_id ON apietl.yinzcam_ticketmaster_0 END

	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_ticketmaster_id' AND object_id = OBJECT_ID('apietl.yinzcam_ticketmaster_Entry_1') )
	BEGIN DROP INDEX IX_ticketmaster_id ON apietl.yinzcam_ticketmaster_Entry_1 END
	
	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_Entry_id' AND object_id = OBJECT_ID('apietl.yinzcam_ticketmaster_Entry_1') )
	BEGIN DROP INDEX IX_Entry_id ON apietl.yinzcam_ticketmaster_Entry_1 END
	
	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_Entry_id' AND object_id = OBJECT_ID('apietl.yinzcam_ticketmaster_Entry_Values_2') )
	BEGIN DROP INDEX IX_Entry_id ON apietl.yinzcam_ticketmaster_Entry_Values_2 END

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

	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_ticketmaster_id' AND object_id = OBJECT_ID('apietl.yinzcam_ticketmaster_0') )
	BEGIN DROP INDEX IX_ticketmaster_id ON apietl.yinzcam_ticketmaster_0 END

	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_ticketmaster_id' AND object_id = OBJECT_ID('apietl.yinzcam_ticketmaster_Entry_1') )
	BEGIN DROP INDEX IX_ticketmaster_id ON apietl.yinzcam_ticketmaster_Entry_1 END
	
	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_Entry_id' AND object_id = OBJECT_ID('apietl.yinzcam_ticketmaster_Entry_1') )
	BEGIN DROP INDEX IX_Entry_id ON apietl.yinzcam_ticketmaster_Entry_1 END
	
	IF EXISTS (SELECT * FROM sys.indexes  WHERE name='IX_Entry_id' AND object_id = OBJECT_ID('apietl.yinzcam_ticketmaster_Entry_Values_2') )
	BEGIN DROP INDEX IX_Entry_id ON apietl.yinzcam_ticketmaster_Entry_Values_2 END

END CATCH







GO
