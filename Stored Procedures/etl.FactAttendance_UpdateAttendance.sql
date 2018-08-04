SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[FactAttendance_UpdateAttendance]

AS
BEGIN
	
	SELECT acct_id, event_id, section_id, row_id, seat_num, gate, scan_date
	INTO #AttendData
	FROM (
		SELECT acct_id, event_id, section_id, row_id, seat_num, gate, (scan_date + ISNULL(TRY_CAST(scan_time AS DATETIME), '00:00')) scan_date
		, ROW_NUMBER() OVER(PARTITION BY event_id, section_id, row_id, seat_num ORDER BY scan_date desc) AS RowRank		
		FROM ods.TM_Attend (NOLOCK) a
		WHERE a.UpdateDate > (GETDATE() - 3)
	) a 
	WHERE RowRank = 1
	
	CREATE NONCLUSTERED INDEX IX_seat ON #AttendData (event_id, section_id, row_id, seat_num)
	CREATE NONCLUSTERED INDEX IX_acct_id ON #AttendData (acct_id)


	SELECT DISTINCT a.acct_id, dc.DimCustomerId
	INTO #Lkp_DimCustomerId
	FROM #AttendData a
	INNER JOIN dbo.DimCustomer (nolock) dc ON a.acct_id = dc.AccountId AND dc.CustomerType = 'Primary' AND dc.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))

	CREATE NONCLUSTERED INDEX IX_acct_id ON #Lkp_DimCustomerId (acct_id)

	SELECT ISNULL(de.DimEventId, -1) AS DimEventId, ISNULL(ldc.DimCustomerId, -1) DimCustomerId, ISNULL(dst.DimSeatId, -1) DimSeatId
	, a.scan_date ScanDateTime
	, a.gate ScanGate
	, CAST(NULL AS NVARCHAR(255)) Barcode
	, CAST(NULL AS NVARCHAR(255)) Channel
	, a.event_id SSID_event_id
	, a.acct_id SSID_acct_id
	, a.section_id SSID_section_id
	, a.row_id SSID_row_id
	, a.seat_num SSID_seat
	, 'TM' ETL_SourceSystem
	, GETDATE() ETL_CreatedDate
	, GETDATE() ETL_UpdatedDate
	INTO #AttendTM
	FROM #AttendData a
	LEFT OUTER JOIN dbo.DimEvent (NOLOCK) de ON de.SSID_event_id = a.event_id AND de.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
	LEFT OUTER JOIN dbo.DimSeat (NOLOCK) dst ON dst.SSID_manifest_id = de.ManifestId AND dst.SSID_section_id = a.section_id AND dst.SSID_row_id = a.row_id AND dst.SSID_seat = a.seat_num AND dst.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
	LEFT OUTER JOIN #Lkp_DimCustomerId ldc ON ldc.acct_id = a.acct_id 	
	

	CREATE NONCLUSTERED INDEX IDX_LoadKey ON #AttendTM (DimEventId, DimSeatId)


	INSERT INTO dbo.FactAttendance (DimEventId, DimCustomerId, DimSeatId, ScanDateTime, ScanGate, Barcode, Channel, SSID_event_id, SSID_acct_id, SSID_section_id, SSID_row_id, SSID_seat, ETL_SourceSystem, ETL_CreatedDate, ETL_UpdatedDate)
	SELECT a.DimEventId, a.DimCustomerId, a.DimSeatId, a.ScanDateTime, a.ScanGate, a.Barcode, a.Channel, a.SSID_event_id, a.SSID_acct_id, a.SSID_section_id, a.SSID_row_id, a.SSID_seat, a.ETL_SourceSystem, a.ETL_CreatedDate, a.ETL_UpdatedDate
	FROM #AttendTM a
	LEFT OUTER JOIN dbo.FactAttendance f ON f.DimEventId = a.DimEventId AND f.DimSeatId = a.DimSeatId 
	WHERE f.FactAttendanceId IS NULL


	UPDATE fi
	SET fi.IsAttended = 1
	, fi.ScanDateTime = ss.ScanDateTime
	, fi.ScanGate = ss.ScanGate
	, fi.ETL_UpdatedDate = GETDATE()
	FROM dbo.FactInventory fi
	INNER JOIN #AttendTM ss ON fi.DimEventId = ss.DimEventId and fi.DimSeatId = ss.DimSeatId
	WHERE fi.IsAttended = 0


END

GO
