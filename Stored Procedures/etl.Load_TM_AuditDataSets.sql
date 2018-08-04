SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[Load_TM_AuditDataSets]
(
	@BatchId INT = 0,
	@TM_AuditSourceFile NVARCHAR(255)
)
AS

BEGIN



/*
	Get the File Timestamp embeded in the filename
*/

DECLARE @FileTimeStamp DATETIME = master.dbo.fn_ConvertFileTimeStamptoDateTime(SUBSTRING(@TM_AuditSourceFile, (CHARINDEX('_',@TM_AuditSourceFile,0) - 12),12))

/*
CREATE Audit Set Record, assumed to be latest based on timestamp in the audit file name
*/

INSERT INTO audit.TM_AuditSets (ETL_CreatedDate, ETL_BatchId, TM_AuditFileDate, TM_AuditSourceFile, DW_AuditData_IsLoaded, AuditThresholdFail, Notes)
VALUES (GETDATE(), @BatchId, @FileTimeStamp, @TM_AuditSourceFile, 0, 0, NULL)

DECLARE @AuditSetId int = @@IDENTITY


/*
Get event list for the audit file
*/

SELECT DISTINCT event_id INTO #EventList
FROM ods.TM_Audit_Export
WHERE SourceFileName = @TM_AuditSourceFile


/*
Snapshot the data in the fact table to compare to the audit data
*/

INSERT INTO audit.DW_AuditSnapShot (ETL_BatchId, ETL_CreatedDate, ETL_TM_AuditSetId, TM_AuditSourceFile, EventId, PriceCode, IsHost, Qty_TotalSold, Qty_Plan, Qty_Single, Qty_Group, Qty_Comp, Qty_Held, Qty_Avail, Qty_Kill, Revenue)

SELECT @BatchId BatchId
, GETDATE() ETL_CreatedDate
, @AuditSetId ETL_TM_AuditSetId
, @TM_AuditSourceFile TM_AuditSourceFile
, de.SSID_event_id EventId
, dpc.PriceCode
, f.IsHost
, SUM(f.QtySeat) TotalSoldQty
, 0 Qty_Plan
, 0 Qty_Single
, 0 Qty_Group
, 0 Qty_Comp
, 0 Qty_Held
, 0 Qty_Avail
, 0 Qty_Kill
, SUM(TotalRevenue) Revenue
--INTO #fact
FROM rpt.vw_FactTicketSales f
INNER JOIN rpt.vw_DimEvent de ON de.DimEventId = f.DimEventId
INNER JOIN #EventList el ON de.SSID_event_id = el.event_id
INNER JOIN rpt.vw_DimPriceCode dpc ON dpc.DimPriceCodeId = f.DimPriceCodeId

GROUP BY de.SSID_event_id, dpc.PriceCode, f.IsHost

UPDATE audit.TM_AuditSets
SET DW_AuditData_IsLoaded = 1
WHERE ETL_TM_AuditSetId = @AuditSetId

END














GO
