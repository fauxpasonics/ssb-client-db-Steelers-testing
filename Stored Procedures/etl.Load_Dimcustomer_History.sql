SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [etl].[Load_Dimcustomer_History] AS 
BEGIN

DECLARE @batchDate AS DATE = GETDATE()
DECLARE @LowerDateBound AS DATE = DATEADD(DAY,-10,GETDATE())

IF (SELECT COUNT(*) 
    FROM etl.Load_Dimcustomer_Monitoring 
	WHERE batchDate = CAST(GETDATE() AS DATE)) > 0

BEGIN
PRINT '[etl].[Load_Dimcustomer_History] has already run for batchDate = ' + CAST(@batchDate AS VARCHAR(20))
RETURN 
END

INSERT INTO etl.Load_Dimcustomer_Monitoring
SELECT @batchDate,1,0,GETDATE(),NULL

/*****************************************************************
					dbo.Dimcustomer_History
***************************************************************

DELETE FROM dbo.Dimcustomer_History
WHERE batchDate < @LowerDateBound

--DROP INDEXES BEFORE NEW INSERT 
DROP INDEX IX_DimCustomer_History_AccountID ON dbo.DimCustomer_History 	
DROP INDEX IX_DimCustomer_History_SSID ON dbo.DimCustomer_History 			
DROP INDEX IX_DimCustomer_History_BatchDate ON dbo.DimCustomer_History	
DROP INDEX IX_DimCustomer_History_dimCustomerID ON dbo.DimCustomer_History 
DROP INDEX IX_DimCustomer_History_SourceSystem ON dbo.DimCustomer_History 

INSERT INTO dbo.Dimcustomer_History
SELECT @batchDate AS batchDate
	   ,dc.*
FROM dimcustomer dc

--RECREATE INDEXES
CREATE INDEX IX_DimCustomer_History_AccountID ON dbo.DimCustomer_History (AccountId ASC)
CREATE INDEX IX_DimCustomer_History_SSID ON dbo.DimCustomer_History (SSID ASC)
CREATE INDEX IX_DimCustomer_History_BatchDate ON dbo.DimCustomer_History(BatchDate ASC)
CREATE INDEX IX_DimCustomer_History_dimCustomerID ON dbo.DimCustomer_History (dimCustomerID ASC)
CREATE INDEX IX_DimCustomer_History_SourceSystem ON dbo.DimCustomer_History (SourceSystem ASC)

/*****************************************************************
					dbo.Dimcustomerssbid_History
****************************************************************/

DELETE FROM dbo.Dimcustomerssbid_History 
WHERE batchDate < @LowerDateBound

--DROP INDEXES BEFORE INSERT
DROP INDEX IX_DimCustomerSSBID_History_SSID	ON dbo.DimCustomerSSBID_History 			
DROP INDEX IX_DimCustomerSSBID_History_BatchDate ON dbo.DimCustomerSSBID_History	
DROP INDEX IX_DimCustomerSSBID_History_DimCustomerID ON dbo.DimCustomerSSBID_History 
DROP INDEX IX_DimCustomerSSBID_History_GUID ON dbo.DimCustomerSSBID_History

INSERT INTO dbo.DimCustomerSSBID_History
SELECT @batchDate AS batchDate
	   ,dc.*
FROM dbo.DimCustomerSSBID dc

--RECREATE INDEXES
CREATE INDEX IX_DimCustomerSSBID_History_SSID ON dbo.DimCustomerSSBID_History (SSID ASC)
CREATE INDEX IX_DimCustomerSSBID_History_BatchDate ON dbo.DimCustomerSSBID_History(BatchDate ASC)
CREATE INDEX IX_DimCustomerSSBID_History_DimCustomerID ON dbo.DimCustomerSSBID_History (DimCustomerID ASC)
CREATE INDEX IX_DimCustomerSSBID_History_GUID ON dbo.DimCustomerSSBID_History (SSB_CRMSYSTEM_CONTACT_ID ASC)

/*****************************************************************
					mdm.compositerecord_History
****************************************************************/

DELETE FROM mdm.compositerecord_History 
WHERE batchDate < @LowerDateBound

--DROP INDEXES BEFORE INSERT
DROP INDEX IX_CompositeRecord_History_AccountID ON mdm.CompositeRecord_History 
DROP INDEX IX_CompositeRecord_History_SSID ON mdm.CompositeRecord_History 
DROP INDEX IX_CompositeRecord_History_BatchDate ON mdm.CompositeRecord_History
DROP INDEX IX_CompositeRecord_History_DimCustomerID ON mdm.CompositeRecord_History

INSERT INTO mdm.compositerecord_History
SELECT @batchDate AS batchDate
	   ,cr.*
FROM mdm.compositerecord cr

--RECREATE INDEXES
CREATE INDEX IX_CompositeRecord_History_AccountID ON mdm.CompositeRecord_History (AccountId ASC)	
CREATE INDEX IX_CompositeRecord_History_SSID ON mdm.CompositeRecord_History (SSID ASC)
CREATE INDEX IX_CompositeRecord_History_BatchDate ON mdm.CompositeRecord_History(BatchDate ASC)	
CREATE INDEX IX_CompositeRecord_History_DimCustomerID ON mdm.CompositeRecord_History (DimCustomerID ASC)

/*****************************************************************
					dbo.Waterfall_Count_History
****************************************************************/
*/

DELETE FROM dbo.Waterfall_Count_History
WHERE batchDate < @LowerDateBound

INSERT INTO dbo.Waterfall_Count_History
(SourceSystem	,SortOrder	,TotalRecords	,SourceUnique	,UniqueCount	,EtlDate	,UniqueToSource	,IsCurrentDay	,dimdateid)

EXEC [rpt].[Cust_Waterfall_load]

UPDATE dbo.Waterfall_Count_History
SET BatchDate = @BatchDate 
WHERE BatchDate IS NULL

/*****************************************************************
					etl.Load_Dimcustomer_Monitoring
****************************************************************/

UPDATE etl.Load_Dimcustomer_Monitoring
SET JobCompleted = 1, completeTime = GETDATE()
WHERE batchDate = @batchDate


END 













GO
