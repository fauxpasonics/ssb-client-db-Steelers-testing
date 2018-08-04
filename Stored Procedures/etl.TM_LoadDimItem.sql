SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[TM_LoadDimItem] 

as
BEGIN

DECLARE @RunTime datetime = getdate()

MERGE dbo.DimItem AS mytarget

USING (select * from ods.vw_TM_LoadDimItem) as mySource
     ON
		myTarget.SourceSystem = mySource.SourceSystem
		and myTarget.SSID_event_id = mySource.SSID_event_id

WHEN MATCHED AND isnull(mySource.DeltaHashKey,-1) <> isnull(myTarget.DeltaHashKey, -1)
THEN UPDATE SET 

	myTarget.DimSeasonId = mySource.DimSeasonId
	, myTarget.ItemCode = mySource.ItemCode
	, myTarget.ItemName = mySource.ItemName
	, myTarget.ItemDesc = mySource.ItemDesc
	, myTarget.ItemClass = mySource.ItemClass
	, myTarget.ItemStatus = mySource.ItemStatus
	, myTarget.SSCreatedBy = mySource.SSCreatedBy
	, myTarget.SSUpdatedBy = mySource.SSUpdatedBy
	, myTarget.SSCreatedDate = mySource.SSCreatedDate
	, myTarget.SSUpdatedDate = mySource.SSUpdatedDate
	, myTarget.SSID = mySource.SSID
	, myTarget.SSID_event_id = mySource.SSID_event_id
	, myTarget.SourceSystem = mySource.SourceSystem
	, myTarget.DeltaHashKey = mySource.DeltaHashKey
	, UpdatedBy = 'CI'
	, UpdatedDate = @RunTime


WHEN NOT MATCHED THEN INSERT
    (
		DimSeasonId, ItemCode, ItemName, ItemDesc, ItemClass, ItemStatus, SSCreatedBy, SSUpdatedBy, SSCreatedDate, SSUpdatedDate, SSID, SSID_event_id, SourceSystem, DeltaHashKey, CreatedBy, UpdatedBy, CreatedDate, UpdatedDate, IsDeleted, DeleteDate
    )
    VALUES (
		mySource.DimSeasonId
		, mySource.ItemCode
		, mySource.ItemName
		, mySource.ItemDesc
		, mySource.ItemClass
		, mySource.ItemStatus
		, mySource.SSCreatedBy
		, mySource.SSUpdatedBy
		, mySource.SSCreatedDate
		, mySource.SSUpdatedDate
		, mySource.SSID
		, mySource.SSID_event_id
		, mySource.SourceSystem
		, mySource.DeltaHashKey
		, 'CI' --CreatedBy
		, 'CI' --UpdatedBy
		, @RunTime --CreatedDate
		, @RunTime --UpdatedDate
		, 0 --IsDeleted
		, null --DeleteDate

    );

	UPDATE dbo.DimItem
	SET Config_IsClosed = 0
	WHERE Config_IsClosed IS NULL

	UPDATE dbo.DimItem
	SET Config_IsFactSalesEligible = 1
	WHERE Config_IsFactSalesEligible IS NULL

	IF EXISTS (SELECT * FROM sys.procedures WHERE [object_id] = OBJECT_ID('etl.Cust_DimItemProcessing'))
	BEGIN
		EXEC etl.Cust_DimItemProcessing
	END



END
GO
