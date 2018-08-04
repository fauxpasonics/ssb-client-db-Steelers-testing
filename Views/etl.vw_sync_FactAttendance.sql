SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [etl].[vw_sync_FactAttendance] AS (

	SELECT FactAttendanceId, DimEventId, DimCustomerId, DimSeatId, ScanDateTime, ScanGate, Barcode, Channel, SSID_event_id, SSID_acct_id, SSID_section_id, SSID_row_id,
		   SSID_seat, ETL_SourceSystem, ETL_CreatedDate, ETL_UpdatedDate
	FROM dbo.FactAttendance (NOLOCK)

)
GO
