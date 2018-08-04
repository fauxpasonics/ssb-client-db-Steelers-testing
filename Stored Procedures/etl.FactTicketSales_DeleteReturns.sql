SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[FactTicketSales_DeleteReturns] 
AS 

BEGIN


	DECLARE @TMSourceSystem NVARCHAR(255) = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))

	/* Get Ods Values */
	SELECT tkt.event_id, tkt.section_id, tkt.row_id, tkt.seat_num, tkt.num_seats, tkt.acct_id 
	INTO #tkt
	FROM ods.tm_vw_ticket tkt
	LEFT OUTER JOIN dbo.DimItem dItem ON CASE WHEN tkt.plan_event_id = 0 THEN tkt.event_id ELSE tkt.plan_event_id END = dItem.SSID_event_id AND dItem.SourceSystem = @TMSourceSystem AND dItem.DimItemId > 0
	WHERE ISNULL(dItem.Config_IsFactSalesEligible,1) = 1 AND ISNULL(dItem.Config_IsClosed,0) = 0


	/* Get Facts */
	SELECT f.FactTicketSalesId, f.SSID_event_id event_id, f.SSID_section_id section_id, f.SSID_row_id row_id, f.SSID_seat_num seat_num, f.QtySeat num_seats, f.SSID_acct_id acct_id 
	INTO #fact
	FROM dbo.FactTicketSales f
	INNER JOIN dbo.DimItem di ON f.DimItemId = di.DimItemId
	WHERE f.SourceSystem = @TMSourceSystem
	AND ISNULL(di.Config_IsClosed,0) = 0


	/* Compare 2 sets for records only in fact */
	SELECT f.* 
	INTO #ToDelete
	FROM #fact f
	LEFT OUTER JOIN #tkt tkt
		ON f.event_id = tkt.event_id
		AND f.section_id = tkt.section_id
		AND f.row_id = tkt.row_id
		AND f.seat_num = tkt.seat_num
	WHERE tkt.event_id IS NULL


	DELETE f
	FROM dbo.FactTicketSales f
	INNER JOIN #ToDelete td ON f.FactTicketSalesId = td.FactTicketSalesId


	/*Load Reprocess Queue With Transactions not in Fact Table Presently*/
	TRUNCATE TABLE etl.STG_FactTicketSales_ReporcessTransactionQueue

	INSERT INTO etl.STG_FactTicketSales_ReporcessTransactionQueue
			( event_id, section_id, row_id, seat_num, ETL__CreatedDate )

	SELECT tkt.event_id, tkt.section_id, tkt.row_id, tkt.seat_num, GETDATE() ETL__CreatedDate
	FROM #tkt tkt
	LEFT OUTER JOIN #fact f 
		ON f.event_id = tkt.event_id
		AND f.section_id = tkt.section_id
		AND f.row_id = tkt.row_id
		AND f.seat_num = tkt.seat_num
	WHERE f.event_id IS NULL


END





GO
