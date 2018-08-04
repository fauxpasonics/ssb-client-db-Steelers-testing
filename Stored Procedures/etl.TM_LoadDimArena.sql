SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[TM_LoadDimArena] 

as
BEGIN

declare @RunTime datetime = getdate()

MERGE dbo.DimArena AS myTarget

USING (select * from ods.vw_TM_LoadDimArena) as mySource
     ON
		myTarget.SourceSystem = mySource.SourceSystem
		and myTarget.SSID_arena_id = mySource.SSID_arena_id

WHEN MATCHED AND isnull(mySource.DeltaHashKey,-1) <> isnull(myTarget.DeltaHashKey, -1)

THEN UPDATE SET 
    myTarget.ArenaCode = mySource.ArenaCode
	, myTarget.ArenaName = mySource.ArenaName
    , myTarget.ArenaDesc = mySource.ArenaDesc
    , myTarget.ArenaClass = mySource.ArenaClass
    , myTarget.Capacity = mySource.Capacity
    , myTarget.IsOutdoor = mySource.IsOutdoor
    , myTarget.StreetAddress = mySource.StreetAddress
    , myTarget.City = mySource.City
    , myTarget.State = mySource.State
    , myTarget.ZipCode = mySource.ZipCode
    , myTarget.Latitude = mySource.Latitude
    , myTarget.Longitude = mySource.Longitude
    , myTarget.ArenaStartDate = mySource.ArenaStartDate
    , myTarget.ArenaEndDate = mySource.ArenaEndDate
    , myTarget.Active = mySource.Active
    , myTarget.SourceSystem = mySource.SourceSystem
	, myTarget.SSCreatedBy = mySource.SSCreatedBy
	, myTarget.SSUpdatedBy = mySource.SSUpdatedBy
	, myTarget.SSCreatedDate = mySource.SSCreatedDate
	, myTarget.SSUpdatedDate = mySource.SSUpdatedDate
	, myTarget.SSID = mySource.SSID
	, myTarget.DeltaHashKey = mySource.DeltaHashKey
    , myTarget.UpdatedBy = 'CI'
    , myTarget.UpdatedDate = @RunTime

WHEN NOT MATCHED THEN INSERT (
		ArenaCode, ArenaName, ArenaDesc, ArenaClass, Capacity, IsOutdoor, StreetAddress, City, State, ZipCode, Latitude, Longitude, ArenaStartDate, ArenaEndDate, Active, SSCreatedBy, SSUpdatedBy, SSCreatedDate, SSUpdatedDate, SSID, SSID_arena_id, SourceSystem, DeltaHashKey, CreatedBy, UpdatedBy, CreatedDate, UpdatedDate, IsDeleted, DeleteDate
    )
    VALUES (
		mySource.ArenaCode
		, mySource.ArenaName
		, mySource.ArenaDesc
		, mySource.ArenaClass
		, mySource.Capacity
		, mySource.IsOutdoor
		, mySource.StreetAddress
		, mySource.City
		, mySource.State
		, mySource.ZipCode
		, mySource.Latitude
		, mySource.Longitude
		, mySource.ArenaStartDate
		, mySource.ArenaEndDate
		, mySource.Active
		, mySource.SSCreatedBy
		, mySource.SSUpdatedBy
		, mySource.SSCreatedDate
		, mySource.SSUpdatedDate
		, mySource.SSID
		, mySource.SSID_arena_id
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
