SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [etl].[Cust_FactTicketSalesProcessing]
(
	@BatchId INT = 0,
	@LoadDate DATETIME = NULL,
	@Options NVARCHAR(MAX) = NULL
)

AS
BEGIN

--//Notes: 
--// DimPlanTypeId's
--//-1 Unknown
--//1 New
--//2 Renew
--//3 ADDON - add on 
--//4 UPG - Upgrade
--//5 BROKER - Broker
--//6 Flex - Flex Plan
--//7 NoPlan

--//DimTicketTypeID
--//-1 Unknown
--/1 FS Full Season
--//2 PS Partial Season
--//3 Group 
--//4 SG Single Game
--//5 MISC -MISC

/****************************************** Ticket Type and Plan Type Tags ****************************************************************/


/*Group Sales*/
/* //All Account Id's greater than 3 Million */
UPDATE f
SET f.DimPlanTypeId = 7 --NoPlan
, f.DimTicketTypeId = 3 --Group
--FROM dbo.Factticketsales f
FROM #stgFactTicketSales f
INNER JOIN dbo.dimplan dp on f.DimPlanId = dp.DimPlanId
WHERE f.SSID_Acct_ID > 3000000
AND ISNULL(f.RetailTicketType,'') <> ''
AND dp.dimplanid = 0

--------------------------------------------------------------------------------------------------------------------------------------------------


/*Single Games*/
UPDATE f
SET f.DimPlanTypeId = 7 --NoPlan
, f.DimTicketTypeId = 4 --Single Game
--FROM dbo.FactTicketSales f
FROM #stgFactTicketSales f
INNER JOIN dbo.dimplan dp on f.DimPlanId = dp.DimPlanId
WHERE ISNULL(f.RetailTicketType,'') <> ''
OR (f.SSID_Acct_ID < 3000000 AND dp.dimplanid = 0 )


UPDATE fts
SET DimTicketTypeId = 1
FROM #stgFactTicketSales fts
	JOIN dimplan dp on dp.dimplanid = fts.dimplanid
	JOIN dimseason ds on ds.dimseasonid = fts.dimseasonid
WHERE PlanCode = CONCAT(RIGHT(SeasonYear,2),'FS')


/*Plan Check*/
UPDATE f
SET f.DimPlanTypeId = 7 --NoPlan
--FROM dbo.FactTicketSales f
FROM #stgFactTicketSales f 
WHERE f.DimPlanTypeId = -1






/****************************************** Fact Tags ****************************************************************/




/*Set Full Seasons*/
UPDATE f
SET f.IsPlan = 1
, f.IsPartial = 0
, f.IsSingleEvent = 0
, f.IsGroup = 0
FROM #stgFactTicketSales f
INNER JOIN dbo.DimTicketType dtt ON f.DimTicketTypeId = dtt.DimTicketTypeId
WHERE dtt.TicketTypeCode = 'FS'


/*Set Single Game Sales*/
UPDATE f
SET f.IsPlan = 0
, f.IsPartial = 0
, f.IsSingleEvent = 1
, f.IsGroup = 0
--FROM dbo.FactTicketSales f
FROM #stgFactTicketSales f
INNER JOIN dbo.DimTicketType dtt ON f.DimTicketTypeId = dtt.DimTicketTypeId
WHERE dtt.TicketTypeCode = 'SG'

/*Set Host Sales*/
UPDATE f
SET f.ishost = 1 
--FROM dbo.FactTicketSales f
FROM #stgFactTicketSales f
Where f.RetailTicketType <>''

/*Set Group Sales*/
UPDATE f
SET f.IsPlan = 0
, f.IsPartial = 0
, f.IsSingleEvent = 1
, f.IsGroup = 1
--FROM dbo.FactTicketSales f
FROM #stgFactTicketSales f
INNER JOIN dbo.DimTicketType dtt ON f.DimTicketTypeId = dtt.DimTicketTypeId
WHERE dtt.TicketTypeCode = 'Group'



/*Renewal Update - Is Renewal*/
UPDATE f
SET f.IsRenewal = 1
FROM #stgFactTicketSales f
INNER JOIN dbo.DimPlanType dpt ON f.DimPlanTypeId = dpt.DimPlanTypeId
WHERE dpt.PlanTypeCode = 'RENEW'

/*Renewal Update - Is Not Renewal*/
UPDATE f
SET f.IsRenewal = 0
FROM #stgFactTicketSales f
INNER JOIN dbo.DimPlanType dpt ON f.DimPlanTypeId = dpt.DimPlanTypeId
WHERE dpt.PlanTypeCode <> 'RENEW'


/****************************************** QtySeatFSE ****************************************************************/

/*QtySeat Calculation*/
UPDATE f
SET f.QtySeatFSE = f.QtySeat / 10.0
FROM #stgFactTicketSales f
INNER JOIN dbo.DimTicketType dtt ON f.DimTicketTypeId = dtt.DimTicketTypeId
WHERE dtt.TicketTypeClass = '%Plan%'
AND f.DimSeasonId = '76' OR f.DimSeasonId = '74'


/****************************************** DimSeatType ****************************************************************/

UPDATE f
SET f.DimSeatTypeid = 1
FROM #stgFactTicketSales f
--FROM dbo.FactTicketSales f
INNER JOIN dbo.dimseat ds ON f.DimSeatIdStart = ds.DimSeatId
WHERE ds.SectionName LIKE '1%'


UPDATE f
SET f.DimSeatTypeid = 2
FROM #stgFactTicketSales f
--FROM dbo.FactTicketSales f
INNER JOIN dbo.dimseat ds ON f.DimSeatIdStart = ds.DimSeatId
WHERE ds.SectionName LIKE '2%'

UPDATE f
SET f.DimSeatTypeid = 3
FROM #stgFactTicketSales f
--FROM dbo.FactTicketSales f
INNER JOIN dbo.dimseat ds ON f.DimSeatIdStart = ds.DimSeatId
WHERE ds.SectionName LIKE '5%'

UPDATE f
SET f.DimSeatTypeid = 4
FROM #stgFactTicketSales f
--FROM dbo.FactTicketSales f
INNER JOIN dbo.dimseat ds ON f.DimSeatIdStart = ds.DimSeatId
INNER JOIN dbo.DimPriceCode dp ON f.dimpricecodeid = dp.dimpricecodeid
WHERE ds.SectionName LIKE '2%' AND dp.pricecode LIKE 'P%'

UPDATE f
SET f.DimSeatTypeid = 5
FROM #stgFactTicketSales f
--FROM dbo.FactTicketSales f
INNER JOIN dbo.dimseat ds ON f.DimSeatIdStart = ds.DimSeatId
WHERE ds.SectionName LIKE '3%'


UPDATE f
SET f.DimSeatTypeid = 6
FROM #stgFactTicketSales f
--FROM dbo.FactTicketSales f
INNER JOIN dbo.dimseat ds ON f.DimSeatIdStart = ds.DimSeatId
WHERE ds.SectionName LIKE '4%'

UPDATE f
SET f.DimSeatTypeid = 7
FROM #stgFactTicketSales f
--FROM dbo.FactTicketSales f
INNER JOIN dbo.dimseat ds ON f.DimSeatIdStart = ds.DimSeatId
WHERE ds.SectionName LIKE 'C%'

UPDATE f
SET f.DimSeatTypeid = 8
FROM #stgFactTicketSales f
--FROM dbo.FactTicketSales f
INNER JOIN dbo.dimseat ds ON f.DimSeatIdStart = ds.DimSeatId
WHERE ds.SectionName LIKE 'FC%'


UPDATE f
SET f.DimSeatTypeid = 9
FROM #stgFactTicketSales f
--FROM dbo.FactTicketSales f
INNER JOIN dbo.dimseat ds ON f.DimSeatIdStart = ds.DimSeatId
WHERE ds.SectionName LIKE 'FFZ'


UPDATE f
SET f.DimSeatTypeid = 10
FROM #stgFactTicketSales f
--FROM dbo.FactTicketSales f
INNER JOIN dbo.dimseat ds ON f.DimSeatIdStart = ds.DimSeatId
WHERE ds.SectionName LIKE 'NC%'

UPDATE f
SET f.DimSeatTypeid = 11
FROM #stgFactTicketSales f
--FROM dbo.FactTicketSales f
INNER JOIN dbo.dimseat ds ON f.DimSeatIdStart = ds.DimSeatId
WHERE ds.SectionName LIKE 'USLN%'


END

































GO
