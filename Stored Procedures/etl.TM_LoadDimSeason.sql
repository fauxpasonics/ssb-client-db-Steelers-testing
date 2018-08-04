SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[TM_LoadDimSeason] 

as
BEGIN

DECLARE @RunTime datetime = getdate()

MERGE dbo.DimSeason AS mytarget

USING (select * from ods.vw_TM_LoadDimSeason) as mySource
     ON
		myTarget.SourceSystem = mySource.SourceSystem		
		and myTarget.SSID_season_id = mySource.SSID_season_id

WHEN MATCHED AND isnull(mySource.DeltaHashKey,-1) <> isnull(myTarget.DeltaHashKey, -1)
THEN UPDATE SET 

	myTarget.DimArenaId = mySource.DimArenaId
	, myTarget.SeasonCode = mySource.SeasonCode
	, myTarget.SeasonName = mySource.SeasonName
	, myTarget.SeasonDesc = mySource.SeasonDesc
	--, myTarget.SeasonClass = mySource.SeasonClass
	, myTarget.SeasonYear = mySource.SeasonYear
	, myTarget.PrevSeasonId = mySource.PrevSeasonId
	, myTarget.SeasonStartDate = mySource.SeasonStartDate
	, myTarget.SeasonEndDate = mySource.SeasonEndDate
	, myTarget.ManifestId = mySource.ManifestId
	, myTarget.Active = mySource.Active
	, myTarget.SSCreatedBy = mySource.SSCreatedBy
	, myTarget.SSUpdatedBy = mySource.SSUpdatedBy
	, myTarget.SSCreatedDate = mySource.SSCreatedDate
	, myTarget.SSUpdatedDate = mySource.SSUpdatedDate
	, myTarget.SSID = mySource.SSID
	, myTarget.SSID_season_id = mySource.SSID_season_id
	, myTarget.SourceSystem = mySource.SourceSystem
	, myTarget.DeltaHashKey = mySource.DeltaHashKey
	, UpdatedBy = 'CI'
	, UpdatedDate = @RunTime


WHEN NOT MATCHED THEN INSERT
    (
		DimArenaId, SeasonCode, SeasonName, SeasonDesc, SeasonClass, SeasonYear, PrevSeasonId, SeasonStartDate, SeasonEndDate, ManifestId, Active, SSCreatedBy, SSUpdatedBy, SSCreatedDate, SSUpdatedDate, SSID, SSID_season_id, SourceSystem, DeltaHashKey, CreatedBy, UpdatedBy, CreatedDate, UpdatedDate, IsDeleted, DeleteDate
    )
    VALUES (
	
		mySource.DimArenaId
		, mySource.SeasonCode
		, mySource.SeasonName
		, mySource.SeasonDesc
		, mySource.SeasonClass
		, mySource.SeasonYear
		, mySource.PrevSeasonId
		, mySource.SeasonStartDate
		, mySource.SeasonEndDate
		, mySource.ManifestId
		, mySource.Active
		, mySource.SSCreatedBy
		, mySource.SSUpdatedBy
		, mySource.SSCreatedDate
		, mySource.SSUpdatedDate
		, mySource.SSID
		, mySource.SSID_season_id
		, mySource.SourceSystem
		, mySource.DeltaHashKey		
		, 'CI' --CreatedBy
		, 'CI' --UpdatedBy
		, @RunTime --CreatedDate
		, @RunTime --UpdatedDate
		, 0 --IsDeleted
		, null --DeleteDate

    );

	UPDATE dbo.DimSeason
	SET Config_IsFactSalesEligible = 1
	WHERE Config_IsFactSalesEligible IS NULL

	UPDATE dbo.DimSeason
	SET Config_IsFactSalesEligible = 1
	WHERE Config_IsFactSalesEligible IS NULL

	IF EXISTS (SELECT * FROM sys.procedures WHERE [object_id] = OBJECT_ID('etl.Cust_DimSeasonProcessing'))
	BEGIN
		EXEC etl.Cust_DimSeasonProcessing
	END

END
GO
