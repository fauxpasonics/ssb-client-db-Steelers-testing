SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO














/*============================================================================================================
CREATED BY:		Jeff Barberio
CREATED DATE:	7/30/2017
PY VERSION:		N/A
USED BY:		Epsilon Outbound Integration
UPDATES:		8/10 jbarberio - added in logging , modified logic to look use SSB_CRMSYSTEM_CONTACT_ID
				11/3 jbarberio - updated ticketing logic to utilize account groups 
DESCRIPTION:	This PROC updates the custom fields for EmailOutbound.UpsertSet, combining data from matching
				email addresses
NOTES:					
=============================================================================================================*/

CREATE PROC [EmailOutbound].[sp_Load_Custom]

AS

DECLARE @SeasonYear INT = CASE WHEN 100*month(getdate())+day(getdate()) > 308 THEN YEAR(GETDATE())
							   ELSE YEAR(GETDATE()) - 1
						  END
DECLARE @CurrentSeasonID INT = (SELECT dimseasonid
								FROM dbo.DimSeason 
								WHERE 1=1	
									  AND SeasonYear = @SeasonYear
									  AND SeasonName LIKE '%heinz%'
									  AND seasonName LIKE '%season%'
									  AND SeasonName NOT LIKE '%post%'
									  AND SeasonName NOT LIKE '%suite%'
								)


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
												   INSERT FROM WORKING SET
		====================================================================================================*/
		
		IF EXISTS (SELECT * 
				   FROM sys.indexes 
				   WHERE name='IX_Email' AND object_id = OBJECT_ID('EmailOutbound.Upsert_Custom')
				   )
		BEGIN
			DROP INDEX IX_Email ON EmailOutbound.Upsert_Custom
		END

		TRUNCATE TABLE EmailOutbound.Upsert_Custom

		INSERT INTO EmailOutbound.Upsert_custom (SSB_CRMSYSTEM_CONTACT_ID, email, Insert_DateTime)

		SELECT SSB_CRMSYSTEM_CONTACT_ID
			  ,EmailPrimary Email
			  ,GETDATE()
		FROM EmailOutbound.WorkingSet

		SET @LoadCount = @@ROWCOUNT

		CREATE NONCLUSTERED INDEX IX_Email ON EmailOutbound.Upsert_Custom (email)
		/*==================================================================================================
													UPDATE CUSTOM FIELDS
		==================================================================================================*/

		--===========================
		--DOB
		--===========================

		UPDATE cust
		SET DOB_DAY		= dob.DOB_DAY		
		   ,DOB_MONTH	= dob.DOB_MONTH	
		   ,DOB_YEAR	= dob.DOB_YEAR	
		FROM EmailOutbound.Upsert_Custom cust
			JOIN (  SELECT SSB_CRMSYSTEM_CONTACT_ID	
						  ,CONCAT(CASE WHEN  LEN(DOB_DAY  ) = 1 THEN '0' ELSE '' END, DOB_DAY  ) AS DOB_DAY	
						  ,CONCAT(CASE WHEN  LEN(DOB_MONTH) = 1 THEN '0' ELSE '' END, DOB_MONTH) AS DOB_MONTH	
						  ,CAST(DOB_YEAR AS CHAR(4)) AS DOB_YEAR
					FROM (  SELECT DISTINCT
									standard.SSB_CRMSYSTEM_CONTACT_ID
								   ,DATEPART(DAY,	standard.Birth_Date) DOB_DAY
								   ,DATEPART(MONTH,	standard.Birth_Date) DOB_MONTH
								   ,DATEPART(YEAR,	standard.Birth_Date) DOB_YEAR
							FROM EmailOutbound.Upsert_Standard standard
						  )x
				  )dob ON dob.SSB_CRMSYSTEM_CONTACT_ID = cust.SSB_CRMSYSTEM_CONTACT_ID
			
		--===========================
		--SNU
		--===========================

		UPDATE cust
		SET cust.PREF_SNU						= ISNULL(Snu.Member,'')
		   ,cust.SNU_ENROLLED_AT				= NULLIF(Snu.Enrolled_at,'19000101')
		   ,cust.SNU_STATUS						= Snu.Status
		   ,cust.SNU_TIER						= Snu.Tier
		   ,cust.SNU_TIER_PREVIOUS_SEASON		= Snu.Tier_PY
		   ,cust.SNU_CURRENT_YARDS				= Snu.Current_Yards
		   ,cust.SNU_LAST_ACTIVITY_DATE			= Snu.Last_Activity_Date
		FROM EmailOutbound.Upsert_Custom cust
			LEFT JOIN (   SELECT dc.EmailPrimary Email
								,CASE WHEN cust.status = 'active' THEN 'Y' ELSE '' END AS Member
								,cust.enrolled_at
								,cust.status
								,cust.top_tier_name Tier
								,archive.top_tier_name Tier_PY
								,cust.balance Current_Yards
								,activity.Last_Activity_Date
								,NULL AS Reward_Available			--LOGIC TBD OR POSSIBLY EXCLUDE THIS ITEM
								,RANK() OVER(PARTITION BY dc.EmailPrimary ORDER BY cust.enrolled_at DESC, cust.loyalty_id) rnk
						  FROM ods.Steelers_500f_Customer cust (NOLOCK)
							JOIN dbo.DimCustomer dc ON dc.SSID = cust.loyalty_id
							LEFT JOIN (SELECT e.loyalty_customer_id loyalty_id
											 ,MAX(e.transaction_date) Last_Activity_Date
									   FROM ods.Steelers_500f_Events e (NOLOCK) 
										LEFT JOIN rpt.SNU_ExcludeTypes et ON et.type = e.type
										LEFT JOIN rpt.SNU_ExcludeDetails ed ON ed.Detail = e.Detail
									   WHERE et.type IS NULL 
											 AND ed.detail IS NULL
									   GROUP BY loyalty_customer_id
									   )activity ON activity.loyalty_id = cust.loyalty_id
							LEFT JOIN archive.Steelers_500f_Customer archive (NOLOCK) ON archive.loyalty_id = cust.loyalty_id
						WHERE dc.SourceSystem = '500f'
					   )snu ON snu.email = cust.email
							   AND rnk = 1

		--===========================
		--TM
		--===========================

		UPDATE cust
		SET CURRENT_STH			= ISNULL(tkt.Sth,'')
		   ,CURRENT_WL			= ISNULL(tkt.Waitlist,'')
		   ,TM_SINGLE_BUYER		= ISNULL(tkt.Single,'')
		   ,CURRENT_SUITE		= ISNULL(tkt.Suite,'')
		   ,TM_CONCERT			= ''
		FROM Emailoutbound.Upsert_Custom cust
			LEFT JOIN (SELECT SSB_CRMSYSTEM_CONTACT_ID
							 ,CASE WHEN Suite = 1									THEN 'Y' ELSE '' END Suite
							 ,CASE WHEN Suite = 0 AND STH = 1						THEN 'Y' ELSE '' END STH
							 ,CASE WHEN Suite = 0 AND STH = 0 AND x.Waitlist = 1	THEN 'Y' ELSE '' END Waitlist
							 ,CASE WHEN Suite = 0 AND STH = 0						THEN 'Y' ELSE '' END Single
					   FROM (  SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID
									 ,MAX(CASE WHEN AccountGroup.membership_name = 'SUITE' THEN 1 ELSE 0 END) Suite
									 ,MAX(CASE WHEN AccountGroup.membership_name = 'STH' THEN 1 ELSE 0 END) STH
									 ,MAX(CASE WHEN AccountGroup.membership_name = 'WAITING LIST' THEN 1 ELSE 0 END) Waitlist								 
							   FROM dbo.DimCustomerSSBID ssbid (NOLOCK)
								JOIN dimcustomer dc (NOLOCK) ON dc.DimCustomerId = ssbid.DimCustomerId
								LEFT JOIN (SELECT DISTINCT dimcustomerid
										   FROM dbo.FactTicketSales fts (NOLOCK)
										   WHERE fts.DimSeasonId = @CurrentSeasonID
										   )fts ON fts.DimCustomerId = ssbid.DimCustomerId
								LEFT JOIN ods.vw_TM_CustMember_Active AccountGroup ON AccountGroup.acct_id = dc.AccountId
																					  AND dc.SourceSystem = 'TM'
																					  AND AccountGroup.membership_name IN ('STH','WAITING LIST','SUITE')
							   WHERE (AccountGroup.acct_id IS NOT NULL OR fts.DimCustomerId IS NOT NULL)
							   GROUP BY ssbid.SSB_CRMSYSTEM_CONTACT_ID
							 )x
						)tkt ON tkt.SSB_CRMSYSTEM_CONTACT_ID = cust.SSB_CRMSYSTEM_CONTACT_ID

		--===========================
		--MISC
		--===========================

		--Events
		SELECT DISTINCT SSB_CRMSYSTEM_CONTACT_ID
					   ,Event_Name AS Event
        INTO #Events
		FROM dimcustomerssbid ssbid (NOLOCK)
			JOIN dimcustomer dc (NOLOCK) ON dc.dimcustomerid = ssbid.dimcustomerid
			JOIN Emailoutbound.Data_Uploader_Landing dul ON dul.ssid = dc.ssid
		WHERE dc.sourcesystem = 'Events'
			  AND dul.source = 'Events'

		
		CREATE NONCLUSTERED INDEX IX_SSB_CRMSYSTEM_CONTACT_ID ON #Events (SSB_CRMSYSTEM_CONTACT_ID)
		CREATE NONCLUSTERED INDEX IX_Event ON #Events (Event)

		
		UPDATE cust
		SET cust.EVENTS_ATTENDED = event.EVENTS_ATTENDED
		FROM Emailoutbound.Upsert_Custom cust
			LEFT JOIN (SELECT SSB_CRMSYSTEM_CONTACT_ID
					   	  ,STUFF( (SELECT ', ' + Event
					   			   FROM #Events e2
					   			   WHERE e2.SSB_CRMSYSTEM_CONTACT_ID = e1.SSB_CRMSYSTEM_CONTACT_ID
					   			   FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
					   			   ,1,2,''
					   			   ) EVENTS_ATTENDED
					   FROM #Events e1
					   GROUP BY SSB_CRMSYSTEM_CONTACT_ID
					   )Event ON Event.SSB_CRMSYSTEM_CONTACT_ID = cust.SSB_CRMSYSTEM_CONTACT_ID
		
		--Contests
		SELECT DISTINCT SSB_CRMSYSTEM_CONTACT_ID
					   ,Event_Name AS contest
        INTO #contests
		FROM dimcustomerssbid ssbid (NOLOCK)
			JOIN dimcustomer dc (NOLOCK) ON dc.dimcustomerid = ssbid.dimcustomerid
			JOIN Emailoutbound.Data_Uploader_Landing dul ON dul.ssid = dc.ssid
		WHERE dc.sourcesystem = 'contests'
			  AND dul.source = 'contests'

		
		CREATE NONCLUSTERED INDEX IX_SSB_CRMSYSTEM_CONTACT_ID ON #contests (SSB_CRMSYSTEM_CONTACT_ID)
		CREATE NONCLUSTERED INDEX IX_Contest ON #contests (Contest)

		
		UPDATE cust
		SET cust.contests_Entered = contest.CONTESTS_ENTERED
		FROM Emailoutbound.Upsert_Custom cust
			LEFT JOIN (SELECT SSB_CRMSYSTEM_CONTACT_ID
					   	  ,STUFF( (SELECT ', ' + contest
					   			   FROM #contests e2
					   			   WHERE e2.SSB_CRMSYSTEM_CONTACT_ID = e1.SSB_CRMSYSTEM_CONTACT_ID
					   			   FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
					   			   ,1,2,''
					   			   ) contests_Entered
					   FROM #contests e1
					   )contest ON contest.SSB_CRMSYSTEM_CONTACT_ID = cust.SSB_CRMSYSTEM_CONTACT_ID

		--Is_Wifi_Customer
		UPDATE cust
		SET IS_WIFI_CUSTOMER = CASE WHEN wifi.SSB_CRMSYSTEM_CONTACT_ID IS NULL THEN '' ELSE 'Y' END
		FROM EmailOutbound.Upsert_Custom cust
			LEFT JOIN (SELECT DISTINCT SSB_CRMSYSTEM_CONTACT_ID 
					   FROM dbo.dimcustomerssbid (NOLOCK) 
					   WHERE sourcesystem = 'wifi'
					   )wifi ON wifi.SSB_CRMSYSTEM_CONTACT_ID = cust.SSB_CRMSYSTEM_CONTACT_ID

		--Is_Mobile_App_Customer
		UPDATE cust
		SET IS_MOBILE_APP_CUSTOMER = CASE WHEN YinzCam.SSB_CRMSYSTEM_CONTACT_ID IS NULL THEN '' ELSE 'Y' END
		FROM EmailOutbound.Upsert_Custom cust
			LEFT JOIN (SELECT DISTINCT SSB_CRMSYSTEM_CONTACT_ID 
					   FROM dbo.dimcustomerssbid (NOLOCK)
					   WHERE sourcesystem = 'YinzCam'
					   )YinzCam ON Yinzcam.SSB_CRMSYSTEM_CONTACT_ID = cust.SSB_CRMSYSTEM_CONTACT_ID


		--===========================
		--UPLOADER FIELDS
		--===========================

		UPDATE EmailOutbound.Upsert_Custom
		SET	 PREF_TEAM_NEWS				= ''
			,PREF_TEAM_EVENTS			= ''
			,PREF_CONCERTS				= ''
			,PREF_HEINZ_FIELD			= ''
			,PREF_MERCH					= ''
			,PREF_PARTNER_OFFERS		= ''

		
		--===========================
		--MERCH
		--===========================
					   
		UPDATE cust
		SET PRO_SHOP_PURCHASER = ISNULL(Merch.PRO_SHOP_PURCHASER,'')
		   ,PRO_SHOP_LAST_ORDER_DATE = Merch.PRO_SHOP_LAST_ORDER_DATE
		FROM EmailOutbound.Upsert_Custom cust
			LEFT JOIN (SELECT SSB_CRMSYSTEM_CONTACT_ID 
							 ,'Y' PRO_SHOP_PURCHASER
							 ,MAX(CreatedOnUtc) PRO_SHOP_LAST_ORDER_DATE
					   FROM dbo.dimcustomerssbid ssbid (NOLOCK)
						JOIN ods.merch_order mo (NOLOCK) ON mo.customerid = ssbid.ssid
					   WHERE sourcesystem = 'Merch'
					   GROUP BY SSB_CRMSYSTEM_CONTACT_ID
					   )Merch ON Merch.SSB_CRMSYSTEM_CONTACT_ID = cust.SSB_CRMSYSTEM_CONTACT_ID
	
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

		DROP TABLE #events
		DROP TABLE #contests

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

		DROP TABLE #events
		DROP TABLE #contests

END CATCH




GO
