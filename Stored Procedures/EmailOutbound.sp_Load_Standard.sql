SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*============================================================================================================
CREATED BY:		Jeff Barberio
CREATED DATE:	7/29/2017
PY VERSION:		N/A
USED BY:		Epsilon Outbound Integration
UPDATES:		8/10 jbarberio - added in logging
				11/3 updated process to account for adding SSB_CRMSYSTEM_CONTACT_ID to the working set PROC
DESCRIPTION:	This PROC creates a golden record for the demographic data, using email as the match key
NOTES:					
=============================================================================================================*/
CREATE PROC [EmailOutbound].[sp_Load_Standard]

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
													TRUNCATE TABLE
		====================================================================================================*/


		IF EXISTS (SELECT * 
				   FROM sys.indexes 
				   WHERE name='IX_Email' AND object_id = OBJECT_ID('EmailOutbound.Upsert_Standard')
				   )
		BEGIN
			DROP INDEX IX_Email ON EmailOutbound.Upsert_Standard
		END

		TRUNCATE TABLE EmailOutbound.Upsert_Standard

		/*====================================================================================================
													INSERT TO STANDARD
		====================================================================================================*/

		INSERT INTO [EmailOutbound].[Upsert_Standard]
				   ([Email]
				   ,[First_Name]
				   ,[Last_Name]
				   ,[Suffix]
				   ,[Gender]
				   ,[Birth_Date]
				   ,[Address_Street]
				   ,[Address_Suite]
				   ,[Address_City]
				   ,[Address_State]
				   ,[Address_Zip]
				   ,[Address_County]
				   ,[Address_Country]
				   ,[Record_Source]
				   ,[Is_New_Record]
				   ,[SSB_CRMSYSTEM_CONTACT_ID])

		SELECT wrk.EmailPrimary					AS Email						
			  ,cr.FirstName						AS First_Name
			  ,cr.LastName						AS Last_Name
			  ,cr.Suffix						AS Suffix
			  ,cr.Gender						AS Gender
			  ,NULLIF(cr.Birthday,'19000101')	AS Birth_Date
			  ,cr.AddressPrimaryStreet			AS Address_Street
			  ,cr.AddressPrimarySuite			AS Address_Suite
			  ,cr.AddressPrimaryCity			AS Address_City
			  ,cr.AddressPrimaryState			AS Address_State
			  ,cr.AddressPrimaryZip				AS Address_Zip
			  ,cr.AddressPrimaryCounty			AS Address_County
			  ,cr.AddressPrimaryCountry			AS Address_Country
			  ,wrk.RecordSource					AS Record_Source
			  ,wrk.IsNewRecord					AS Is_New_Record
			  ,cr.SSB_CRMSYSTEM_CONTACT_ID		AS SSB_CRMSYSTEM_CONTACT_ID
		FROM EmailOutbound.WorkingSet wrk
			JOIN mdm.CompositeRecord cr ON cr.SSB_CRMSYSTEM_CONTACT_ID = wrk.SSB_CRMSYSTEM_CONTACT_ID							

		SET @LoadCount = @@ROWCOUNT

		CREATE NONCLUSTERED INDEX IX_Email ON EmailOutbound.Upsert_Standard (Email)

		/*====================================================================================================
													LOG RESULTS
		====================================================================================================*/

		INSERT INTO EmailOutbound.Load_Monitoring (
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


		INSERT INTO EmailOutbound.Load_Monitoring (
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

END CATCH









GO
