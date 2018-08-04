SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [rpt].[Cust_Waterfall_QA_TM](
@batchID INT
)
 AS

BEGIN

--DECLARE @batchID INT = 1
DECLARE @batchStart DATE = (SELECT MIN(add_date) FROM dbo.waterfallQA_Archtics WHERE batchID = @batchID)
DECLARE @batchEnd DATE = DATEADD(DAY,1,(SELECT MAX(add_date) FROM dbo.waterfallQA_Archtics WHERE batchID = @batchID))

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
			   ,AccountId
			   ,BatchDate
		FROM dbo.DimCustomer_History 
		WHERE SourceSystem = 'TM'
			  AND batchDate <= @batchEnd 
	    )dc
		LEFT JOIN ( SELECT DimCustomerId
					FROM dbo.DimCustomer_History
					WHERE batchDate  < @batchStart
					)dc_old ON dc_old.DimCustomerId = dc.DimCustomerId
WHERE dc_old.DimCustomerId IS NULL
	  
SELECT CASE WHEN qa.acct_id IS NULL THEN 'Dimcustomer Only'
			WHEN new.AccountId IS NULL THEN 'QA Source Only'
			ELSE 'Match'
	   END as SourceMatch
	   ,COALESCE(new.AccountId,qa.acct_id) AS AccountID
INTO #NewAccountsCombined
FROM #newAccounts new
	FULL OUTER JOIN (SELECT acct_id
							,add_date
						FROM dbo.waterfallQA_Archtics
						)qa ON qa.acct_id = new.AccountId

/******************************************
				SSBID
*******************************************/

SELECT dc.* 
INTO #newAccountsSSBID
FROM   (SELECT SSBID.DimCustomerId
			   ,dc.AccountId
			   ,SSBID.BatchDate
		FROM dbo.DimCustomerSSBID_History SSBID
			JOIN dimcustomer dc ON dc.DimCustomerId = SSBID.DimCustomerId
		WHERE ssbid.SourceSystem = 'TM'
			  AND batchDate <= @batchEnd 
	    )dc
		LEFT JOIN ( SELECT SSBID.DimCustomerId
					FROM dbo.DimCustomerSSBID_History SSBID
					WHERE batchDate  < @batchStart
					)dc_old ON dc_old.DimCustomerId = dc.DimCustomerId
WHERE dc_old.DimCustomerId IS NULL

SELECT CASE WHEN qa.acct_id IS NULL THEN 'dimCustomerSSBID Only'
			WHEN new.AccountId IS NULL THEN 'QA Source Only'
			ELSE 'Match'
	   END as SourceMatch
	   ,COALESCE(new.AccountId,qa.acct_id) AS AccountID
INTO #NewAccountsSSBIDCombined
FROM #newAccountsSSBID new
	FULL OUTER JOIN (SELECT acct_id
							,add_date
						FROM dbo.waterfallQA_Archtics
						)qa ON qa.acct_id = new.AccountId

/******************************************
			COMPOSITE RECORD
*******************************************/

SELECT cr.* 
INTO #NewAccountsCR
FROM (SELECT DimCustomerId
			,AccountId
			,BatchDate
	  FROM mdm.compositerecord_History
	  WHERE SourceSystem = 'TM'
			AND batchDate <= @batchEnd
	  ) cr
	LEFT JOIN ( SELECT DimCustomerId
				FROM mdm.compositerecord_History 
				WHERE batchDate  < @batchStart) cr_old
				ON cr_old.DimCustomerId = cr.DimCustomerId
WHERE cr_old.DimCustomerId IS NULL
	  AND cr.batchDate <= @batchEnd

SELECT CASE WHEN qa.acct_id IS NULL THEN 'Composite Record Only'
			WHEN new.AccountId IS NULL THEN 'QA Source Only'
			ELSE 'Match'
	   END as SourceMatch
	   ,COALESCE(new.AccountId,qa.acct_id) AS AccountID
INTO #NewAccountsCRCombined
FROM #NewAccountsCR new
	FULL OUTER JOIN (SELECT acct_id
							,add_date
						FROM dbo.waterfallQA_Archtics
						)qa ON qa.acct_id = new.AccountId

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
         ,'dbo.waterfallQA_Archtics' 										-- QA_Table - varchar(50)
         ,@batchID															-- BatchID - int
         ,results.SourceTable 												-- SSB_Table - varchar(50)
         ,results.MatchGroup 												-- varianceGroup - varchar(50)
         ,results.AccountID													-- accountID - varchar(200)
FROM #results results
WHERE results.MatchGroup <> 'Match'

END


GO
