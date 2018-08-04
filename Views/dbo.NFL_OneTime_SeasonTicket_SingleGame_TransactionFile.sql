SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[NFL_OneTime_SeasonTicket_SingleGame_TransactionFile]
AS 

SELECT 'ST' AS nfl_team_code,
       CAST(fts.SSID_acct_id AS NVARCHAR(25)) + ':' + CAST(fts.SSID_event_id AS NVARCHAR(25)) + ':'
       + CAST(fts.SSID_section_id AS NVARCHAR(25)) + ':' + CAST(fts.SSID_row_id AS NVARCHAR(25)) + ':'
       + CAST(fts.SSID_seat_num AS NVARCHAR(25)) + ':' + CAST(fts.QtySeat AS NVARCHAR(25)) AS ticket_orders_id,
       dc.SSID AS ticket_customers_id,
	   DB_NAME() AS Club,
	   de.EventName AS Opponent,
	   dd.CalDate AS DateStamp,
	   ds.SeasonYear AS Season,
	   CASE WHEN fts.DimTicketTypeId = 1 THEN 1 ELSE 0 END AS SeasonTicketFlag, -- Update Season Ticket Holder Logic for your team here
	   CASE WHEN fts.DimTicketTypeId <> 1 THEN 1 ELSE 0 END AS SingleGameFlag, -- Update Single Game Buyer Logic for your team here
	   fts.QtySeat,
	   fts.TotalRevenue
FROM dbo.FactTicketSales fts (NOLOCK)
JOIN dbo.DimCustomer dc ON dc.DimCustomerId = fts.DimCustomerId
JOIN dbo.DimDate dd ON dd.DimDateId = fts.DimDateId
JOIN dbo.DimSeason ds ON fts.DimSeasonId = ds.DimSeasonId
JOIN dbo.DimPlan dp ON dp.DimPlanId = fts.DimPlanId
JOIN  dbo.DimEvent de ON de.DimEventId = fts.DimEventId
WHERE (seasonname like '%Heinz%' AND (seasonname like '%season%' OR seasonname like '%post%') AND seasonname not like '%suite%')
	  OR SeasonName = CONCAT(SeasonYear,' Season Suites')


GO
