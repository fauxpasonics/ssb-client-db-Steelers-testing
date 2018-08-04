SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[TM_LoadDimEvent] 

as
BEGIN

DECLARE @RunTime datetime = getdate()

MERGE dbo.DimEvent AS mytarget

USING (select * from ods.vw_TM_LoadDimEvent) as mySource
     ON
		myTarget.SourceSystem = mySource.SourceSystem
		and myTarget.SSID_event_id = mySource.SSID_event_id

WHEN MATCHED AND isnull(mySource.DeltaHashKey,-1) <> isnull(myTarget.DeltaHashKey, -1)
THEN UPDATE SET 

	myTarget.DimArenaId = mySource.DimArenaId
	, myTarget.DimSeasonId = mySource.DimSeasonId
	--, myTarget.DimEventHeaderId = mySource.DimEventHeaderId
	, myTarget.EventCode = mySource.EventCode
	, myTarget.EventName = mySource.EventName
	, myTarget.EventDesc = mySource.EventDesc
	--, myTarget.EventClass = mySource.EventClass
	, myTarget.EventDateTime = mySource.EventDateTime
	, myTarget.EventDate = mySource.EventDate
	, myTarget.EventTime = mySource.EventTime
	, myTarget.EventStatus = mySource.EventStatus
	, myTarget.Capacity = mySource.Capacity
	, myTarget.Attendance = mySource.Attendance
	, myTarget.ScanEventId = mySource.ScanEventId
	, myTarget.ManifestId = mySource.ManifestId
	, myTarget.MajorCategoryTM = mySource.MajorCategoryTM
	, myTarget.MinorCategoryTM = mySource.MinorCategoryTM
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
		DimArenaId, DimSeasonId, DimEventHeaderId, EventCode, EventName, EventDesc, EventClass, EventDateTime, EventDate, EventTime, EventStatus, Capacity, Attendance, ScanEventId, ManifestId, MajorCategoryTM, MinorCategoryTM, SSCreatedBy, SSUpdatedBy, SSCreatedDate, SSUpdatedDate, SSID, SSID_event_id, SourceSystem, DeltaHashKey, CreatedBy, UpdatedBy, CreatedDate, UpdatedDate, IsDeleted, DeleteDate
    )
    VALUES (
		mySource.DimArenaId
		, mySource.DimSeasonId
		, mySource.DimEventHeaderId
		, mySource.EventCode
		, mySource.EventName
		, mySource.EventDesc
		, mySource.EventClass
		, mySource.EventDateTime
		, mySource.EventDate
		, mySource.EventTime
		, mySource.EventStatus
		, mySource.Capacity
		, mySource.Attendance
		, mySource.ScanEventId
		, mySource.ManifestId
		, mySource.MajorCategoryTM
		, mySource.MinorCategoryTM
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

	
	UPDATE dbo.DimEvent
	SET IsClosed = 0
	WHERE IsClosed IS NULL
    

	UPDATE dbo.DimEvent
	SET IsInventoryEligible = 0
	WHERE IsInventoryEligible IS null


	update dbo.DimEvent
	set EventOpenTime = DATEADD(hour, -3, EventDateTime)
	where EventOpenTime is null and DimEventId > 0


	update dbo.DimEvent
	set EventFinishTime = DATEADD(hour, 6, EventDateTime)
	where EventFinishTime is null and DimEventId > 0

END
GO
