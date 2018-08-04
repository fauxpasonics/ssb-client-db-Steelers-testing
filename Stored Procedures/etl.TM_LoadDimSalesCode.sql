SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[TM_LoadDimSalesCode] 

as
BEGIN

DECLARE @RunTime datetime = getdate()

MERGE dbo.DimSalesCode AS mytarget

USING (select * from ods.vw_TM_LoadDimSalesCode) as mySource
     ON
		myTarget.SourceSystem = mySource.SourceSystem		
		and myTarget.SSID_sell_location_id = mySource.SSID_sell_location_id

WHEN MATCHED AND isnull(mySource.DeltaHashKey,-1) <> isnull(myTarget.DeltaHashKey, -1)
THEN UPDATE SET 

	myTarget.SalesCode = mySource.SalesCode
	, myTarget.SalesCodeName = mySource.SalesCodeName
	, myTarget.SalesCodeDesc = mySource.SalesCodeDesc
	, myTarget.SalesCodeClass = mySource.SalesCodeClass
	, myTarget.IsHost = mySource.IsHost
	, myTarget.SalesCodeStartDate = mySource.SalesCodeStartDate
	, myTarget.SalesCodeEndDate = mySource.SalesCodeEndDate
	, myTarget.SalesCodeStatus = mySource.SalesCodeStatus
	, myTarget.SSCreatedBy = mySource.SSCreatedBy
	, myTarget.SSUpdatedBy = mySource.SSUpdatedBy
	, myTarget.SSCreatedDate = mySource.SSCreatedDate
	, myTarget.SSUpdatedDate = mySource.SSUpdatedDate
	, myTarget.SSID = mySource.SSID
	, myTarget.SSID_sell_location_id = mySource.SSID_sell_location_id
	, myTarget.SourceSystem = mySource.SourceSystem
	, myTarget.DeltaHashKey = mySource.DeltaHashKey
	, UpdatedBy = 'CI'
	, UpdatedDate = @RunTime


WHEN NOT MATCHED THEN INSERT
    (
		SalesCode, SalesCodeName, SalesCodeDesc, SalesCodeClass, IsHost, SalesCodeStartDate, SalesCodeEndDate, SalesCodeStatus, SSCreatedBy, SSUpdatedBy, SSCreatedDate, SSUpdatedDate, SSID, SSID_sell_location_id, SourceSystem, DeltaHashKey, CreatedBy, UpdatedBy, CreatedDate, UpdatedDate, IsDeleted, DeleteDate
    )
    VALUES (
	
		mySource.SalesCode
		, mySource.SalesCodeName
		, mySource.SalesCodeDesc
		, mySource.SalesCodeClass
		, mySource.IsHost
		, mySource.SalesCodeStartDate
		, mySource.SalesCodeEndDate
		, mySource.SalesCodeStatus
		, mySource.SSCreatedBy
		, mySource.SSUpdatedBy
		, mySource.SSCreatedDate
		, mySource.SSUpdatedDate
		, mySource.SSID
		, mySource.SSID_sell_location_id
		, mySource.SourceSystem
		, mySource.DeltaHashKey
		, 'CI' --CreatedBy
		, 'CI' --UpdatedBy
		, @RunTime --CreatedDate
		, @RunTime --UpdatedDate
		, 0 --IsDeleted
		, null --DeleteDate

    );

END

GO
