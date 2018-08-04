SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [rpt].[Cust_Waterfall_QA_SNU](
@batchID INT
)
 AS

BEGIN

--DECLARE @batchID INT = 1
DECLARE @batchStart DATE = (SELECT MIN(date) FROM dbo.waterfallQA_SNU WHERE batchID = @batchID)
DECLARE @batchEnd DATE = DATEADD(DAY,1,(SELECT MAX(date) FROM dbo.waterfallQA_SNU WHERE batchID = @batchID))

IF OBJECT_ID('tempdb..#newAccounts')IS NOT NULL					DROP TABLE #newAccounts
IF OBJECT_ID('tempdb..#NewAccountsCombined')IS NOT NULL			DROP TABLE #NewAccountsCombined
IF OBJECT_ID('tempdb..#newAccountsSSBID')IS NOT NULL			DROP TABLE #newAccountsSSBID
IF OBJECT_ID('tempdb..#NewAccountsSSBIDCombined')IS NOT NULL	DROP TABLE #NewAccountsSSBIDCombined
IF OBJECT_ID('tempdb..#newAccountsCR')IS NOT NULL				DROP TABLE #newAccountsCR
IF OBJECT_ID('tempdb..#NewAccountsCRCombined')IS NOT NULL		DROP TABLE #NewAccountsCRCombined
IF OBJECT_ID('tempdb..#Results')IS NOT NULL						DROP TABLE #Results

/**********************************************************************************************************************
														TEMP TABLES
***********************************************************************************************************************/

/******************************************
				DIMCUSTOMER
*******************************************/

SELECT dc.* 
INTO #newAccounts
FROM   (SELECT DimCustomerId
			   ,SSID
			   ,BatchDate
		FROM dbo.DimCustomer_History 
		WHERE SourceSystem = '500f'
			  AND batchDate <= @batchEnd 
	    )dc
		LEFT JOIN ( SELECT DimCustomerId
					FROM dbo.DimCustomer_History
					WHERE batchDate < @batchStart
					)dc_old ON dc_old.DimCustomerId = dc.DimCustomerId
WHERE dc_old.DimCustomerId IS NULL
	  
SELECT CASE WHEN qa.LoyaltyPlus_ID IS NULL THEN 'Dimcustomer Only'
			WHEN new.SSID IS NULL THEN 'QA Source Only'
			ELSE 'Match'
	   END as SourceMatch
	   ,COALESCE(new.SSID,qa.LoyaltyPlus_ID) AS AccountID
INTO #NewAccountsCombined
FROM #newAccounts new
	FULL OUTER JOIN (SELECT LoyaltyPlus_ID
							,date
						FROM dbo.waterfallQA_SNU
						)qa ON qa.LoyaltyPlus_ID = new.SSID


/******************************************
				SSBID
*******************************************/

SELECT dc.* 
INTO #newAccountsSSBID
FROM   (SELECT SSBID.DimCustomerId
			   ,SSBID.SSID
			   ,SSBID.BatchDate
		FROM dbo.DimCustomerSSBID_History SSBID
		WHERE ssbid.SourceSystem = '500f'
			  AND batchDate <= @batchEnd 
	    )dc
		LEFT JOIN ( SELECT SSBID.DimCustomerId
					FROM dbo.DimCustomerSSBID_History SSBID
					WHERE batchDate < @batchStart
					)dc_old ON dc_old.DimCustomerId = dc.DimCustomerId
WHERE dc_old.DimCustomerId IS NULL

SELECT CASE WHEN qa.LoyaltyPlus_ID IS NULL THEN 'dimCustomerSSBID Only'
			WHEN new.SSID IS NULL THEN 'QA Source Only'
			ELSE 'Match'
	   END as SourceMatch
	   ,COALESCE(new.SSID,qa.LoyaltyPlus_ID) AS AccountID
INTO #NewAccountsSSBIDCombined
FROM #newAccountsSSBID new
	FULL OUTER JOIN (SELECT LoyaltyPlus_ID
							,date
						FROM dbo.waterfallQA_SNU
						)qa ON qa.LoyaltyPlus_ID = new.SSID

/******************************************
			COMPOSITE RECORD
*******************************************/

SELECT cr.* 
INTO #NewAccountsCR
FROM (SELECT DimCustomerId
			,SSID
			,BatchDate
	  FROM mdm.compositerecord_History
	  WHERE SourceSystem = '500f'
			AND batchDate <= @batchEnd
	  ) cr
	LEFT JOIN ( SELECT DimCustomerId
				FROM mdm.compositerecord_History 
				WHERE batchDate < @batchStart) cr_old
				ON cr_old.DimCustomerId = cr.DimCustomerId
WHERE cr_old.DimCustomerId IS NULL
	  AND cr.batchDate <= @batchEnd

SELECT CASE WHEN qa.LoyaltyPlus_ID IS NULL THEN 'Composite Record Only'
			WHEN new.SSID IS NULL THEN 'QA Source Only'
			ELSE 'Match'
	   END as SourceMatch
	   ,COALESCE(new.SSID,qa.LoyaltyPlus_ID) AS AccountID
INTO #NewAccountsCRCombined
FROM #NewAccountsCR new
	FULL OUTER JOIN (SELECT LoyaltyPlus_ID
							,date
						FROM dbo.waterfallQA_SNU
						)qa ON qa.LoyaltyPlus_ID = new.SSID

/**********************************************************************************************************************
														RESULTS
***********************************************************************************************************************/

create TABLE #results(
SourceTable VARCHAR(50)
,MatchGroup VARCHAR(50)
,AccountID VARCHAR(50)
)

INSERT INTO #results
( 
SourceTable 
,MatchGroup 
,AccountID
)

/******************************************
				  DIMCUSTOMER
*******************************************/

--New account classification
SELECT 'dbo.dimcustomer' AS SourceTable
	   ,SourceMatch AS MatchGroup
	   ,AccountID 
FROM #NewAccountsCombined

UNION ALL
		
/******************************************
			 DIMCUSTOMERSSBID
*******************************************/

--New account classification
SELECT 'dbo.dimcustomerSSBID' AS SourceTable
	   ,SourceMatch AS MatchGroup
	   ,AccountID 
FROM #NewAccountsSSBIDCombined 

UNION ALL

/******************************************
			 COMPOSITE RECORD
*******************************************/

--New account classification
SELECT DISTINCT 
	   'mdm.compositeRecord' AS SourceTable
	   ,SourceMatch AS MatchGroup
	   ,AccountID 
FROM #NewAccountsCRCombined 


/**********************************************************************************************************************
													OUTPUT TO QA TABLE
***********************************************************************************************************************/


INSERT INTO dbo.waterfallQA_Variance
        ( insertID ,
          insertDate ,
          QA_Table ,
          BatchID ,
          SSB_Table ,
          varianceGroup ,
          accountID
        )

SELECT   (SELECT ISNULL(MAX(insertID),0)+1 FROM dbo.waterfallQA_Variance)   -- insertID - int
         ,GETDATE() 														-- insertDate - date
         ,'dbo.waterfallQA_SNU' 											-- QA_Table - varchar(50)
         ,@batchID															-- BatchID - int
         ,results.SourceTable 												-- SSB_Table - varchar(50)
         ,results.MatchGroup 												-- varianceGroup - varchar(50)
         ,results.AccountID													-- accountID - varchar(200)
FROM #results results
WHERE results.MatchGroup <> 'Match'


END


GO
