SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [rpt].[FactTickettoMerch_dev] 
--(@clientdb VARCHAR(50), @dimcustomerid VARCHAR(20), @attributegroup VARCHAR(10))

AS
BEGIN

--DROP TABLE #CContact

CREATE TABLE #CContact
(SystemID VARCHAR(45), 
Club# int, 
Suite# int, 
GA# int, 
Club$ int, 
Suite$ int, 
GA$ int, 
Merch# int, 
Merch$ int)


INSERT INTO #CContact (SystemID)
(
SELECT x.* from
(
SELECT DISTINCT SSB_CRMSYSTEM_CONTACT_ID FROM dimcustomerssbid WITH (NOLOCK)
WHERE sourcesystem = 'Merch'
) x
JOIN
(

SELECT DISTINCT SSB_CRMSYSTEM_CONTACT_ID FROM dimcustomerssbid WITH (NOLOCK)
WHERE sourcesystem = 'TM'
) y ON x.SSB_CRMSYSTEM_CONTACT_ID = y.SSB_CRMSYSTEM_CONTACT_ID 
)


--///////////////////////////////////Club Sales///////////////////////////////////////////
CREATE TABLE #CContact_Club
(Dimcustomerid VARCHAR(40),
SystemID VARCHAR(45), 
Club# int, 
Club$ int, 
)

INSERT INTO #CContact_Club (Dimcustomerid,SystemID,Club#,[Club$])
(
SELECT 
f.DimCustomerId,dsb.SSB_CRMSYSTEM_CONTACT_ID,
SUM(qtyseat)/10 'Total Tickets', SUM(totalrevenue) 'Total Revenue' FROM dbo.FactTicketSales f 
INNER JOIN dbo.DimSeatType ds ON f.DimSeatTypeId = ds.DimSeatTypeId
LEFT JOIN dbo.DimCustomerSSBID dsb ON f.dimcustomerid = dsb.DimCustomerId
WHERE f.dimseasonid IN  ('74','76') AND ds.SeatTypeCode ='CLUB'
GROUP BY f.DimCustomerId,dsb.SSB_CRMSYSTEM_CONTACT_ID)


UPDATE #CContact 
SET #CContact.Club# = #CContact_Club.Club# ,
    #CContact.Club$ = #CContact_Club.Club$
FROM #CContact_Club
WHERE #CContact.SystemID = #CContact_Club.SystemID

--///////////////////////////////////Club Sales///////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////Suite Sales//////////////////////////////////////////

CREATE TABLE #CContact_Suite
(Dimcustomerid VARCHAR(40),
SystemID VARCHAR(45), 
Suite# int, 
Suite$ int, 
)

INSERT INTO #CContact_suite (Dimcustomerid,SystemID,Suite#,[Suite$])
(
SELECT 
f.DimCustomerId,dsb.SSB_CRMSYSTEM_CONTACT_ID,
SUM(qtyseat)/10 'Total Tickets', SUM(totalrevenue) 'Total Revenue' FROM dbo.FactTicketSales f 
INNER JOIN dbo.DimSeatType ds ON f.DimSeatTypeId = ds.DimSeatTypeId
LEFT JOIN dbo.DimCustomerSSBID dsb ON f.dimcustomerid = dsb.DimCustomerId
WHERE f.dimseasonid IN  ('74','76') AND ds.SeatTypeCode ='Suite'
GROUP BY f.DimCustomerId,dsb.SSB_CRMSYSTEM_CONTACT_ID)

UPDATE #CContact 
SET #CContact.Suite# = #CContact_Suite.Suite# ,
    #CContact.Suite$ = #CContact_Suite.Suite$
FROM #CContact_Suite
WHERE #CContact.SystemID = #CContact_Suite.SystemID

--///////////////////////////////////Suite Sales///////////////////////////////////////////
--/////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////GA Sales//////////////////////////////////////////////

CREATE TABLE #CContact_GA
(Dimcustomerid VARCHAR(40),
SystemID VARCHAR(45), 
GA# int, 
GA$ int, 
)

INSERT INTO #CContact_GA (Dimcustomerid,SystemID,GA#,[GA$])
(
SELECT 
f.DimCustomerId,dsb.SSB_CRMSYSTEM_CONTACT_ID,
SUM(qtyseat)/10 'Total Tickets', SUM(totalrevenue) 'Total Revenue' FROM dbo.FactTicketSales f 
INNER JOIN dbo.DimSeatType ds ON f.DimSeatTypeId = ds.DimSeatTypeId
LEFT JOIN dbo.DimCustomerSSBID dsb ON f.dimcustomerid = dsb.DimCustomerId
WHERE f.dimseasonid IN  ('74','76') AND ds.SeatTypeCode ='GA'
GROUP BY f.DimCustomerId,dsb.SSB_CRMSYSTEM_CONTACT_ID)

UPDATE #CContact 
SET #CContact.GA# = #CContact_GA.GA# ,
    #CContact.GA$ = #CContact_GA.GA$
FROM #CContact_GA
WHERE #CContact.SystemID = #CContact_GA.SystemID

--///////////////////////////////////GA Sales///////////////////////////////////////////
--/////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////Merch Sales//////////////////////////////////////////////

CREATE TABLE #CContact_Merch
(Dimcustomerid VARCHAR(40),
SystemID VARCHAR(45), 
Merch# int, 
Merch$ int, 
)

INSERT INTO #CContact_Merch (Dimcustomerid,SystemID,Merch#,[Merch$])
(

SELECT ssb.DimCustomerid, ssb.SSB_CRMSYSTEM_CONTACT_ID, 
count (mo.ordertotal) 'Total Merch #',
SUM(mo.ordertotal) 'Total Revenue'
FROM ods.Merch_Order mo 
INNER JOIN dbo.DimCustomerSSBID ssb ON mo.CustomerId = ssb.SSID
WHERE ssb.SourceSystem = 'merch'
GROUP BY SSB.DimCustomerId,ssb.SSB_CRMSYSTEM_CONTACT_ID)


UPDATE #CContact 
SET #CContact.Merch# = #CContact_Merch.Merch# ,
    #CContact.[Merch$] = #CContact_Merch.Merch$
FROM #CContact_Merch
WHERE #CContact.SystemID = #CContact_Merch.SystemID

--////////////////////////////////////End Merch Sales///////////////////////////////////
--///////////////////////////////////Match Tix to Merch/////////////////////////////////

SELECT 
Sum(isnull(Club#,0)) as TotalClubTickets,
Sum(isnull(Club$,0)) as TotalClubSpend,
Sum(isnull(GA#,0)) as TotalGATickets,
Sum(isnull(GA$,0)) as TotalGASpend,
Sum(isnull(Suite#,0)) as TotalSuiteTickets,
Sum(isnull(Suite$,0)) as TotalSuiteSpend,
Sum(isnull(Merch#,0)) as TotalMerchCount,
Sum(isnull(Merch$,0)) as TotalMerchSpend,
Sum(case when isnull(Club#,0) > 0 then 1 else 0 end) as ClubMerchCount,
Sum(case when isnull(Club#,0) > 0 then isnull(Merch$,0) else 0 end) as ClubMerchSpend,
Sum(case when isnull(GA#,0) > 0 then 1 else 0 end) as GAMerchCount,
Sum(case when isnull(GA#,0) > 0 then isnull(Merch$,0) else 0 end) as GAMerchSpend,
Sum(case when isnull(Suite#,0) > 0 then 1 else 0 end) as SuiteMerchCount,
Sum(case when isnull(Suite#,0) > 0 then isnull(Merch$,0) else 0 end) as SuiteMerchSpend
FROM #CContact

END





GO
