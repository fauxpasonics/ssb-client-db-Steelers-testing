SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_sync_DimSeat] AS (
	SELECT DimSeatId, DimArenaId, ManifestId, SectionName, SectionDesc, SectionSort, RowName, RowSort, Seat, DefaultClass, DefaultPriceCode, SSCreatedBy, SSUpdatedBy,
           SSCreatedDate, SSUpdatedDate, SSID, SSID_manifest_id, SSID_section_id, SSID_row_id, SSID_seat, SourceSystem, DeltaHashKey, CreatedBy, UpdatedBy, CreatedDate,
           UpdatedDate, IsDeleted, DeleteDate, Config_Location, Config_IsFactInventoryEligible
     FROM dbo.DimSeat (NOLOCK)
)
GO
