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
DESCRIPTION:	This PROC Identifies the Emails that will be pulled into the outbound process. Distinguishing 
				between current records to potentially be updated and new records to create.
NOTES:			
=============================================================================================================*/

CREATE PROC [EmailOutbound].[sp_Load_WorkingSet_bkp]
AS 



DECLARE @RunDate DATE = GETDATE()
DECLARE @RunTime DATETIME = GETDATE()
DECLARE @ProcName VARCHAR(200) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID)
DECLARE @LoadCount INT
DECLARE @ErrorMessage NVARCHAR(4000) 
DECLARE @ErrorSeverity INT			 
DECLARE @ErrorState INT		

DECLARE @CutoffSNU DATE = '20171007'		 

/*========================================================================================================================
													START TRY
========================================================================================================================*/

BEGIN TRY

		/*==========================================================================================
											IDENTIFY NEW INSERTS
		==========================================================================================*/

		--Identify Prod emails to exclude from new loads
		SELECT DISTINCT CustomerKey email
		INTO #prod
		FROM ods.Epsilon_Profile_Updates (NOLOCK)

		CREATE NONCLUSTERED INDEX IX_email ON #prod (email)

		CREATE TABLE #Inserts (
		EmailPrimary NVARCHAR(256)
		,RecordSource VARCHAR(50)
		,CreatedDate DATE
		)

		--============================
		--TM
		--============================

		INSERT INTO #Inserts (EmailPrimary,RecordSource,CreatedDate)

		SELECT EmailPrimary
			,'TM'
			,MIN(createddate) createddate
		FROM [ods].[vw_TM_CustMember_Active] grp (NOLOCK)
			JOIN dbo.DimCustomer dc (NOLOCK) ON dc.AccountId = grp.acct_id
			LEFT JOIN #prod prod ON prod.email = dc.EmailPrimary
		WHERE membership_name IN ('WAITING LIST','SUITE','STH')
			AND dc.SourceSystem = 'tm'
			AND dc.EmailPrimaryIsCleanStatus LIKE 'Valid%'
			AND prod.email IS NULL
		GROUP BY dc.EmailPrimary

		--============================
		--SNU
		--============================

		INSERT INTO #Inserts (EmailPrimary,RecordSource,CreatedDate)

		SELECT dc.EmailPrimary, '500f' , MIN(snu.enrolled_at) CreatedDate
		FROM ods.Steelers_500f_Customer snu (NOLOCK)
			JOIN dbo.DimCustomer dc (NOLOCK) ON dc.SSID = snu.loyalty_id
			LEFT JOIN #prod prod ON prod.email = dc.EmailPrimary
		WHERE prod.email IS NULL
			  AND dc.SourceSystem = '500f'
			  AND dc.EmailPrimaryIsCleanStatus LIKE 'valid%'
			  AND snu.[status] = 'active'
			  AND snu.enrolled_at > @CutoffSNU
		GROUP BY dc.EmailPrimary

		--============================
		--Merch
		--============================
		--Currently no new customers being brought in via merchandise purchases

		--INSERT INTO #Inserts (EmailPrimary,RecordSource,CreatedDate)

		--SELECT dc.EmailPrimary, 'Merch' , MIN(merch.CreatedOnUtc) CreatedDate
		--FROM ods.Merch_Order merch (NOLOCK)
		--	JOIN dbo.DimCustomer dc (NOLOCK) ON dc.SSID = merch.CustomerId
		--	LEFT JOIN #prod prod ON prod.email = dc.EmailPrimary
		--WHERE prod.email IS NULL
		--	  AND merch.CreatedOnUtc >= @CutoffDate_Merch
		--	  AND dc.SourceSystem = 'Merch'
		--	  AND dc.EmailPrimaryIsCleanStatus LIKE 'valid%'
		--GROUP BY dc.EmailPrimary

		--============================
		--Data Uploader
		--============================

		INSERT INTO #Inserts (EmailPrimary,RecordSource,CreatedDate)

		SELECT uploader.EmailPrimary, 'Email Uploader' , MIN(uploader.SSCreatedDate) CreatedDate
		FROM dbo.DimCustomer uploader (NOLOCK)
			LEFT JOIN #prod prod ON prod.email = uploader.EmailPrimary
		WHERE prod.email IS NULL
			  AND uploader.SourceSystem = 'Email Uploader'
		GROUP BY uploader.EmailPrimary

		/*==========================================================================================
											LOAD TO WORKING SET
		==========================================================================================*/

		--============================
		--Clean Up and Prep
		--============================

		CREATE INDEX IX_EmailPrimary ON #inserts (EmailPrimary)

		IF EXISTS (SELECT * 
				   FROM sys.indexes 
				   WHERE name='IX_EmailPrimary' AND object_id = OBJECT_ID('EmailOutbound.WorkingSet')
				   )
		BEGIN
			DROP INDEX IX_EmailPrimary ON EmailOutbound.WorkingSet
		END

		IF EXISTS (SELECT * 
				   FROM sys.indexes 
				   WHERE name='IX_GUID' AND object_id = OBJECT_ID('EmailOutbound.WorkingSet')
				   )
		BEGIN
			DROP INDEX IX_GUID ON EmailOutbound.WorkingSet
		END

		TRUNCATE TABLE EmailOutbound.WorkingSet

		--============================
		--Insert
		--============================

		INSERT INTO EmailOutbound.WorkingSet (EmailPrimary, IsNewRecord, RecordSource, CreatedDate)

		--Inserts
		--Uncertain how the steelers will want to resolve records coming in from multiple sources on the same
		--Date. SourceTieBreak Subquery put in place until confirmation from Steelers on how to handle
		SELECT EmailPrimary
			 , 1
			 , RecordSource
			 , CreatedDate
		FROM (
				SELECT inserts.EmailPrimary
					 , inserts.RecordSource
					 , inserts.CreatedDate 
					 , RANK() OVER(PARTITION BY inserts.EmailPrimary ORDER BY inserts.CreatedDate DESC , SourceRank) SourceRank
				FROM #Inserts inserts
					JOIN ( SELECT '500f'		RecordSource	, 1 SourceRank 	UNION ALL
						   SELECT 'TM'			RecordSource	, 2 SourceRank	UNION ALL
						   SELECT 'Merch'		RecordSource	, 3 SourceRank	UNION ALL
						   SELECT 'Events'		RecordSource	, 4 SourceRank	UNION ALL
						   SELECT 'Contests'	RecordSource	, 5 SourceRank 	UNION ALL
						   SELECT 'Wifi'		RecordSource	, 6 SourceRank 	UNION ALL
						   SELECT 'Mobile App'	RecordSource	, 7 SourceRank 		
						 )SourceTieBreak ON SourceTieBreak.RecordSource = inserts.RecordSource
			 )x
		WHERE x.SourceRank = 1

		UNION ALL

		--Updates 
		SELECT Email
			  , 0
			  , NULL			--**FIELD NOT MODIFIED FOR EXISTING RECORDS
			  , NULL			--**FIELD NOT MODIFIED FOR EXISTING RECORDS
		FROM #prod

		SET @LoadCount = @@ROWCOUNT

		CREATE NONCLUSTERED INDEX IX_EmailPrimary ON EmailOutbound.WorkingSet (EmailPrimary)

		--============================
		--Update GUID
		--============================
		--SSB_CRMSYSTEM_CONTACT_ID will be used later in order to pull in custom field data. the below logic reconciles cases where emails exist on multiple GUIDs

		UPDATE wrk
		SET wrk.SSB_CRMSYSTEM_CONTACT_ID = dc.SSB_CRMSYSTEM_CONTACT_ID
		FROM EmailOutbound.WorkingSet wrk
			JOIN (SELECT dc.EmailPrimary
						,ssbid.SSB_CRMSYSTEM_CONTACT_ID
						,RANK() OVER(PARTITION BY EmailPrimary ORDER BY iSNULL(SourceRank,9) , dc.UpdatedDate DESC, dc.CreatedDate DESC, dc.DimCustomerId) rnk
				  FROM dbo.DimCustomer dc
					JOIN dimcustomerssbid ssbid ON ssbid.DimCustomerId = dc.DimCustomerId
					LEFT JOIN ( SELECT 'TM'				SourceSystem	, 1 SourceRank 	UNION ALL
								SELECT '500f'			SourceSystem	, 2 SourceRank	UNION ALL
								SELECT 'Merch'			SourceSystem	, 3 SourceRank	UNION ALL
								SELECT 'Events'			SourceSystem	, 4 SourceRank	UNION ALL
								SELECT 'Contests'		SourceSystem	, 5 SourceRank 	UNION ALL
								SELECT 'Epsilon'		SourceSystem	, 6 SourceRank 	UNION ALL
								SELECT 'Wifi'			SourceSystem	, 7 SourceRank 	UNION ALL
								SELECT 'Mobile App'		SourceSystem	, 8 SourceRank 		
							  )SourceRank ON SourceRank.SourceSystem = dc.SourceSystem
				 )dc ON dc.EmailPrimary = wrk.EmailPrimary
		WHERE dc.rnk = 1

		CREATE NONCLUSTERED INDEX IX_GUID ON EmailOutbound.WorkingSet (SSB_CRMSYSTEM_CONTACT_ID)
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

		DROP TABLE #prod
		DROP TABLE #Inserts

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

		DROP TABLE #prod
		DROP TABLE #Inserts

END CATCH



GO
