SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [etl].[load_DimCustomerSSBID_Changes]
AS


BEGIN

/*
double check that dimcustomerSSBID_history_changes hasn't already been populated 
for the most current date in dimcustomer_history and exit the proc if it has
*/
IF ((SELECT MAX(batchDate) FROM dimcustomerSSBID_History_Changes) = (SELECT MAX(batchDate) FROM dbo.DimCustomerSSBID_History))
	BEGIN
		PRINT 'DimcustomerSSBID_History_Changes has already been populated with the most recent changes'
		RETURN	
	END

IF OBJECT_ID('tempdb..#BatchDates')IS NOT NULL DROP TABLE #BatchDates
CREATE TABLE #BatchDates(
DateID INT IDENTITY(1,1)
,batchDate DATE
)

INSERT INTO #batchDates

SELECT DISTINCT
		BatchDate
FROM dbo.DimCustomerSSBID_History
ORDER BY BatchDate

DECLARE @startID INT = (SELECT MAX(dateID) FROM #BatchDates) - 1
DECLARE @startDate DATE = (SELECT batchDate FROM #BatchDates WHERE DateID = @startID)
DECLARE @EndDate DATE = (SELECT MAX(batchDate) FROM #BatchDates)

IF OBJECT_ID('tempdb..#addDrop')IS NOT NULL DROP TABLE #addDrop
SELECT CASE WHEN day1.DimCustomerId IS NULL THEN CASE WHEN day2.numIds = 1 THEN 'ADD'
														ELSE 'MERGE'
													END
			WHEN day2.DimCustomerId IS NULL THEN 'DROP'
			ELSE 'NO CHANGE'
		END AS recordChange
		,COALESCE(day2.DimCustomerId,day1.DimCustomerId) AS dimcustomerID
INTO #addDrop
FROM (SELECT DimCustomerId 
		FROM dbo.DimCustomerSSBID_History 
		WHERE BatchDate = @startDate
		) day1
		FULL JOIN (SELECT DimCustomerId
						,COUNT(dimcustomerid) OVER(PARTITION BY SSB_CRMSYSTEM_CONTACT_ID)numIds
					FROM dbo.DimCustomerSSBID_History 
					WHERE BatchDate = @endDate
					) day2 ON day1.DimCustomerId = day2.DimCustomerId
WHERE day1.DimCustomerId IS NULL 
		OR day2.DimCustomerId IS NULL

IF OBJECT_ID('tempdb..#updates')IS NOT NULL DROP TABLE #updates
SELECT	DimCustomerSSBID
		,ssb.DimCustomerId
		,NameAddr_ID
		,NameEmail_id
		,Composite_ID
		,SSB_CRMSYSTEM_ACCT_ID
		,SSB_CRMSYSTEM_CONTACT_ID
		,SSB_CRMSYSTEM_PRIMARY_FLAG
		,CreatedBy
		--,UpdatedBy
		,CreatedDate
		--,UpdatedDate
		,IsDeleted
		,DeleteDate
		,SSID
		,SourceSystem
		,SSB_CRMSYSTEM_ACCT_PRIMARY_FLAG
		,NamePhone_ID
		,ssb_crmsystem_contactacct_id
INTO #updates
FROM dbo.DimCustomerSSBID_History ssb
	LEFT JOIN #addDrop addDrop ON addDrop.dimcustomerID = ssb.DimCustomerId
WHERE BatchDate = @endDate
		AND addDrop.dimcustomerID IS NULL

EXCEPT 

SELECT	DimCustomerSSBID
		,ssb.DimCustomerId
		,NameAddr_ID
		,NameEmail_id
		,Composite_ID
		,SSB_CRMSYSTEM_ACCT_ID
		,SSB_CRMSYSTEM_CONTACT_ID
		,SSB_CRMSYSTEM_PRIMARY_FLAG
		,CreatedBy
		--,UpdatedBy
		,CreatedDate
		--,UpdatedDate
		,IsDeleted
		,DeleteDate
		,SSID
		,SourceSystem
		,SSB_CRMSYSTEM_ACCT_PRIMARY_FLAG
		,NamePhone_ID
		,ssb_crmsystem_contactacct_id
FROM dbo.DimCustomerSSBID_History ssb
	LEFT JOIN #addDrop addDrop ON addDrop.dimcustomerID = ssb.DimCustomerId
WHERE BatchDate = @startDate
		AND addDrop.dimcustomerID IS NULL

DROP INDEX IX_DimCustomerSSBID_History_Changes_SSID	ON dbo.DimCustomerSSBID_History_Changes 			
DROP INDEX IX_DimCustomerSSBID_History_Changes_BatchDate ON dbo.DimCustomerSSBID_History_Changes	
DROP INDEX IX_DimCustomerSSBID_History_Changes_DimCustomerID ON dbo.DimCustomerSSBID_History_Changes 

INSERT INTO [dbo].[DimCustomerSSBID_History_Changes]

SELECT @EndDate AS BatchDate
	   ,'UPDATE' AS RecordChange
	   ,ssbid.BatchDate AS SnapshotDate
	   ,ssbid.DimCustomerSSBID
	   ,ssbid.DimCustomerId
	   ,ssbid.NameAddr_ID
	   ,ssbid.NameEmail_id
	   ,ssbid.Composite_ID
	   ,ssbid.SSB_CRMSYSTEM_ACCT_ID
	   ,ssbid.SSB_CRMSYSTEM_CONTACT_ID
	   ,ssbid.SSB_CRMSYSTEM_PRIMARY_FLAG
	   ,ssbid.CreatedBy
	   --,ssbid.UpdatedBy
	   ,ssbid.CreatedDate
	   --,ssbid.UpdatedDate
	   ,ssbid.IsDeleted
	   ,ssbid.DeleteDate
	   ,ssbid.SSID
	   ,ssbid.SourceSystem
	   ,ssbid.SSB_CRMSYSTEM_ACCT_PRIMARY_FLAG
	   ,ssbid.NamePhone_ID
	   ,ssbid.ssb_crmsystem_contactacct_id
FROM dbo.DimCustomerSSBID_History ssbid
	JOIN #updates updates ON updates.dimcustomerid = ssbid.DimCustomerId
WHERE ssbid.BatchDate IN (@startDate,@EndDate)
	
UNION ALL 

SELECT	@EndDate AS BatchDate
		,addDrop.recordChange
		,ssbid.batchDate AS SnapshotDate
		,ssbid.DimCustomerSSBID
		,ssbid.DimCustomerId
		,ssbid.NameAddr_ID
		,ssbid.NameEmail_id
		,ssbid.Composite_ID
		,ssbid.SSB_CRMSYSTEM_ACCT_ID
		,ssbid.SSB_CRMSYSTEM_CONTACT_ID
		,ssbid.SSB_CRMSYSTEM_PRIMARY_FLAG
		,ssbid.CreatedBy
		--,ssbid.UpdatedBy
		,ssbid.CreatedDate
		--,ssbid.UpdatedDate
		,ssbid.IsDeleted
		,ssbid.DeleteDate
		,ssbid.SSID
		,ssbid.SourceSystem
		,ssbid.SSB_CRMSYSTEM_ACCT_PRIMARY_FLAG
		,ssbid.NamePhone_ID
		,ssbid.ssb_crmsystem_contactacct_id
FROM dbo.DimCustomerSSBID_History ssbid
	JOIN #addDrop addDrop ON addDrop.dimcustomerID = ssbid.DimCustomerId
WHERE BatchDate IN (@startDate,@endDate)

ORDER BY recordChange,DimCustomerId

CREATE INDEX IX_DimCustomerSSBID_History_Changes_SSID ON dbo.DimCustomerSSBID_History_Changes (SSID ASC)
CREATE INDEX IX_DimCustomerSSBID_History_Changes_BatchDate ON dbo.DimCustomerSSBID_History_Changes(BatchDate ASC)
CREATE INDEX IX_DimCustomerSSBID_History_Changes_DimCustomerID ON dbo.DimCustomerSSBID_History_Changes (DimCustomerID ASC)

END


GO
