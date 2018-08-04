SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[TM_LoadDimSeat] 

as
BEGIN

DECLARE @RunTime datetime = getdate()

SELECT DISTINCT manifest_id
INTO #Manifests
FROM ods.TM_ManifestSeat
WHERE UpdateDate > getdate() - 3


select * 
INTO #SrcData
FROM ods.vw_TM_LoadDimSeat
WHERE ManifestId IN (SELECT manifest_id FROM #Manifests)


CREATE NONCLUSTERED INDEX IDX_LoadKey
ON #SrcData ([SSID_manifest_id],[SSID_section_id],[SSID_row_id],[SSID_seat],[SourceSystem])

MERGE dbo.DimSeat AS mytarget

USING (select * from #SrcData) as mySource
     ON
		myTarget.SourceSystem = mySource.SourceSystem		
		and myTarget.SSID_manifest_id = mySource.SSID_manifest_id
		and myTarget.SSID_section_id = mySource.SSID_section_id
		and myTarget.SSID_row_id = mySource.SSID_row_id
		and myTarget.SSID_seat = mySource.SSID_seat

WHEN MATCHED AND isnull(mySource.DeltaHashKey,-1) <> isnull(myTarget.DeltaHashKey, -1)
THEN UPDATE SET 

	myTarget.DimArenaId = mySource.DimArenaId
	, myTarget.ManifestId = mySource.ManifestId
	, myTarget.SectionName = mySource.SectionName
	, myTarget.SectionDesc = mySource.SectionDesc
	, myTarget.SectionSort = mySource.SectionSort
	, myTarget.RowName = mySource.RowName
	, myTarget.RowSort = mySource.RowSort
	, myTarget.Seat = mySource.Seat
	, myTarget.DefaultClass = mySource.DefaultClass
	, myTarget.DefaultPriceCode = mySource.DefaultPriceCode
	, myTarget.SSCreatedBy = mySource.SSCreatedBy
	, myTarget.SSUpdatedBy = mySource.SSUpdatedBy
	, myTarget.SSCreatedDate = mySource.SSCreatedDate
	, myTarget.SSUpdatedDate = mySource.SSUpdatedDate
	, myTarget.SSID = mySource.SSID
	, myTarget.SSID_manifest_id = mySource.SSID_manifest_id
	, myTarget.SSID_section_id = mySource.SSID_section_id
	, myTarget.SSID_row_id = mySource.SSID_row_id
	, myTarget.SSID_seat = mySource.SSID_seat
	, myTarget.SourceSystem = mySource.SourceSystem
	, myTarget.DeltaHashKey = mySource.DeltaHashKey	
	, UpdatedBy = 'CI'
	, UpdatedDate = @RunTime


WHEN NOT MATCHED THEN INSERT
    (
		DimArenaId, ManifestId, SectionName, SectionDesc, SectionSort, RowName, RowSort, Seat, DefaultClass, DefaultPriceCode, SSCreatedBy, SSUpdatedBy, SSCreatedDate, SSUpdatedDate, SSID, SSID_manifest_id, SSID_section_id, SSID_row_id, SSID_seat, SourceSystem, DeltaHashKey, CreatedBy, UpdatedBy, CreatedDate, UpdatedDate, IsDeleted, DeleteDate
    )
    VALUES (
	
		mySource.DimArenaId
		, mySource.ManifestId
		, mySource.SectionName
		, mySource.SectionDesc
		, mySource.SectionSort
		, mySource.RowName
		, mySource.RowSort
		, mySource.Seat
		, mySource.DefaultClass
		, mySource.DefaultPriceCode
		, mySource.SSCreatedBy
		, mySource.SSUpdatedBy
		, mySource.SSCreatedDate
		, mySource.SSUpdatedDate
		, mySource.SSID
		, mySource.SSID_manifest_id
		, mySource.SSID_section_id
		, mySource.SSID_row_id
		, mySource.SSID_seat
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
