SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [rpt].[PreCache_Cust_Email_12]
AS 

IF OBJECT_ID('tempdb..#base')IS NOT NULL DROP TABLE #base
IF OBJECT_ID('tempdb..#CountHelper')IS NOT NULL DROP TABLE #CountHelper
IF OBJECT_ID('tempdb..#adds')IS NOT NULL DROP TABLE #adds
IF OBJECT_ID('tempdb..#members')IS NOT NULL DROP TABLE #members

DECLARE @LowerDateBound DATE = '20160831'

/*=========================================================================================
										COUNT HELPER
=========================================================================================*/

DECLARE @Date DATE = GETDATE()

CREATE TABLE #CountHelper(
MONTH_ID INT
,MONTH_NAME VARCHAR(20)
)

WHILE @Date > @LowerDateBound
BEGIN

INSERT INTO #CountHelper
VALUES  (100*YEAR(@date) + MONTH(@Date),DATENAME(MONTH,@Date))

SET @Date = DATEADD(MONTH,-1,@Date)

END


/*=========================================================================================
										BASE SET
=========================================================================================*/

SELECT PROFILE_KEY
	  ,JOIN_MONTH
	  ,CASE WHEN x.SUPPRESSION_MONTH < OPTOUT_MONTH THEN x.SUPPRESSION_MONTH ELSE x.OPTOUT_MONTH END OPTOUT_MONTH
	  ,PREF_NEWSLETTER
	  ,PREF_SNU
	  ,PREF_MERCH
	  ,PREF_PARTNER_OFFERS
	  ,PREF_HEINZ_FIELD
	  ,PREF_TEAM_EVENTS
	  ,PREF_CONCERTS
INTO #base
FROM (
		SELECT epu.CustomerKey PROFILE_KEY
			   ,CASE WHEN JoinDate <= @LowerDateBound THEN 0 
					 ELSE 100*YEAR(JoinDate) + MONTH(JoinDate) 
				END JOIN_MONTH
			   ,CASE WHEN EmailChannelOptOutFlag <> 'Y' THEN 100*YEAR(GETDATE()) + MONTH(GETDATE()) + 1
					 WHEN EmailChannelOptStatusDate <= @LowerDateBound THEN 0 			 
					 ELSE 100*YEAR(EmailChannelOptStatusDate) + MONTH(EmailChannelOptStatusDate) 
				END OPTOUT_MONTH
			   ,CASE WHEN suppression.CustomerKey IS NULL THEN 100*YEAR(GETDATE()) + MONTH(GETDATE()) + 1
					 WHEN suppression.ETL_CreatedDate <= @LowerDateBound THEN 0 			 
					 ELSE 100*YEAR(suppression.ETL_CreatedDate) + MONTH(suppression.ETL_CreatedDate) 
				END SUPPRESSION_MONTH
			   ,CASE WHEN epu.PREF_TEAM_NEWS       = 'Y' THEN 1 ELSE 0 END  PREF_NEWSLETTER    
			   ,CASE WHEN epu.PREF_SNU             = 'Y' THEN 1 ELSE 0 END  PREF_SNU           
			   ,CASE WHEN epu.PREF_MERCH           = 'Y' THEN 1 ELSE 0 END  PREF_MERCH         
			   ,CASE WHEN epu.PREF_PARTNER_OFFERS  = 'Y' THEN 1 ELSE 0 END  PREF_PARTNER_OFFERS
			   ,CASE WHEN epu.PREF_HEINZ_FIELD     = 'Y' THEN 1 ELSE 0 END  PREF_HEINZ_FIELD   
			   ,CASE WHEN epu.PREF_TEAM_EVENTS     = 'Y' THEN 1 ELSE 0 END  PREF_TEAM_EVENTS   
			   ,CASE WHEN epu.PREF_CONCERTS        = 'Y' THEN 1 ELSE 0 END  PREF_CONCERTS          
		FROM ods.epsilon_profile_updates epu
			LEFT JOIN ods.Epsilon_SuppressionList suppression ON suppression.CustomerKey = epu.CustomerKey
																 AND suppression.ETL_IsDeleted = 0
		WHERE EmailAddressDeliveryStatus = 'G'
	 )x

/*=========================================================================================
										  ADDS
=========================================================================================*/

SELECT ch.MONTH_ID AS SortOrder
	   ,ch.MONTH_NAME AS Month
	   ,COUNT(CASE WHEN adds.PREF_NEWSLETTER      = 1 THEN adds.PROFILE_KEY END) Adds_Newsletter    
	   ,COUNT(CASE WHEN adds.PREF_SNU             = 1 THEN adds.PROFILE_KEY END) Adds_Snu           
	   ,COUNT(CASE WHEN adds.PREF_MERCH           = 1 THEN adds.PROFILE_KEY END) Adds_Merch         
	   ,COUNT(CASE WHEN adds.PREF_PARTNER_OFFERS  = 1 THEN adds.PROFILE_KEY END) Adds_Partner_offers
	   ,COUNT(CASE WHEN adds.PREF_HEINZ_FIELD     = 1 THEN adds.PROFILE_KEY END) Adds_Heinz_field   
	   ,COUNT(CASE WHEN adds.PREF_TEAM_EVENTS     = 1 THEN adds.PROFILE_KEY END) Adds_Team_events   
	   ,COUNT(CASE WHEN adds.PREF_CONCERTS        = 1 THEN adds.PROFILE_KEY END) Adds_Concerts 
	   ,COUNT(adds.PROFILE_KEY) Adds_Total
INTO #adds
FROM #CountHelper ch
	LEFT JOIN #base adds ON adds.JOIN_MONTH = ch.MONTH_ID
GROUP BY ch.MONTH_ID 
	   ,ch.MONTH_NAME

/*=========================================================================================
										TOTAL MEMBERS
=========================================================================================*/

SELECT ch.MONTH_ID AS SortOrder
	   ,ch.MONTH_NAME AS Month	   
	   ,COUNT(CASE WHEN Members.PREF_NEWSLETTER      = 1 THEN Members.PROFILE_KEY END) Members_Newsletter    
	   ,COUNT(CASE WHEN Members.PREF_SNU             = 1 THEN Members.PROFILE_KEY END) Members_Snu           
	   ,COUNT(CASE WHEN Members.PREF_MERCH           = 1 THEN Members.PROFILE_KEY END) Members_Merch         
	   ,COUNT(CASE WHEN Members.PREF_PARTNER_OFFERS  = 1 THEN Members.PROFILE_KEY END) Members_Partner_offers
	   ,COUNT(CASE WHEN Members.PREF_HEINZ_FIELD     = 1 THEN Members.PROFILE_KEY END) Members_Heinz_field   
	   ,COUNT(CASE WHEN Members.PREF_TEAM_EVENTS     = 1 THEN Members.PROFILE_KEY END) Members_Team_events   
	   ,COUNT(CASE WHEN Members.PREF_CONCERTS        = 1 THEN Members.PROFILE_KEY END) Members_Concerts 
	   ,COUNT(Members.PROFILE_KEY) Members_Total	   
INTO #members
FROM #CountHelper ch
	LEFT JOIN #base members ON ch.MONTH_ID BETWEEN members.JOIN_MONTH AND (members.OPTOUT_MONTH - 1)
GROUP BY ch.MONTH_ID 
	   ,ch.MONTH_NAME

/*=========================================================================================
										  OUTPUT
=========================================================================================*/

INSERT INTO rpt.PreCache_Cust_Email_12_tbl

SELECT  members.SortOrder
	   ,members.Month
	   ,Members_Newsletter
	   ,Members_Snu
	   ,Members_Merch
	   ,Members_Partner_offers
	   ,Members_Heinz_field
	   ,Members_Team_events
	   ,Members_Concerts
	   ,Members_Total
	   ,Adds_Newsletter
	   ,Adds_Snu
	   ,Adds_Merch
	   ,Adds_Partner_offers
	   ,Adds_Heinz_field
	   ,Adds_Team_events
	   ,Adds_Concerts
	   ,Adds_Total
	   ,Adds_Newsletter			AS Count_Newsletter		  --REMOVE AFTER REPORT COLUMN POINTERS HAVE BEEN SWAPPED!!
	   ,Adds_Snu				AS Count_Snu			
	   ,Adds_Merch				AS Count_Merch			
	   ,Adds_Partner_offers		AS Count_Partner_offers	
	   ,Adds_Heinz_field		AS Count_Heinz_field	
	   ,Adds_Team_events		AS Count_Team_events	
	   ,Adds_Concerts			AS Count_Concerts		
	   ,Adds_Total				AS Count_Total
	   ,0 AS IsReady
FROM #members members
	LEFT JOIN #adds adds ON adds.SortOrder = members.SortOrder
ORDER BY SortOrder

DELETE FROM rpt.PreCache_Cust_Email_12_tbl WHERE IsReady = 1
UPDATE rpt.PreCache_Cust_Email_12_tbl SET IsReady = 1


DROP TABLE #base
DROP TABLE #CountHelper
DROP TABLE #adds
DROP TABLE #members


GO
