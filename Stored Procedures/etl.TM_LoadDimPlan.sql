SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[TM_LoadDimPlan] 

as
BEGIN

DECLARE @RunTime datetime = getdate()

MERGE dbo.DimPlan AS mytarget

USING (select * from ods.vw_TM_LoadDimPlan) as mySource
     ON
		myTarget.SourceSystem = mySource.SourceSystem
		and myTarget.SSID_event_id = mySource.SSID_event_id

WHEN MATCHED AND isnull(mySource.DeltaHashKey,-1) <> isnull(myTarget.DeltaHashKey, -1)
THEN UPDATE SET 

	myTarget.DimSeasonId = mySource.DimSeasonId
	, myTarget.PlanCode = mySource.PlanCode
	, myTarget.PlanName = mySource.PlanName
	, myTarget.PlanDesc = mySource.PlanDesc
	, myTarget.PlanClass = mySource.PlanClass
	, myTarget.PlanFse = mySource.PlanFse
	, myTarget.PlanType = mySource.PlanType
	, myTarget.PlanEventCnt = mySource.PlanEventCnt
	, myTarget.PlanStartDate = mySource.PlanStartDate
	, myTarget.PlanEndDate = mySource.PlanEndDate
	, myTarget.PlanStatus = mySource.PlanStatus
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
		DimSeasonId, PlanCode, PlanName, PlanDesc, PlanClass, PlanFse, PlanType, PlanEventCnt, PlanStartDate, PlanEndDate, PlanStatus, SSCreatedBy, SSUpdatedBy, SSCreatedDate, SSUpdatedDate, SSID, SSID_event_id, SourceSystem, DeltaHashKey, CreatedBy, UpdatedBy, CreatedDate, UpdatedDate, IsDeleted, DeleteDate
    )
    VALUES (
	
		mySource.DimSeasonId
		, mySource.PlanCode
		, mySource.PlanName
		, mySource.PlanDesc
		, mySource.PlanClass
		, mySource.PlanFse
		, mySource.PlanType
		, mySource.PlanEventCnt
		, mySource.PlanStartDate
		, mySource.PlanEndDate
		, mySource.PlanStatus
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

END

GO
