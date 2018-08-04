SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [nfl].[vw_TicketOrder]
AS
(

SELECT 
		nfl_team_code
		,ticket_orders_id
		,ticket_customers_id
		,acct_id
		,event_name
		,Team
		,section_name
		,row_name
		,num_seats
		,seat_num
		,last_Seat
		,ticket_status
		,season_year
		,order_line_item
		,order_line_item_seq
		,sell_location
		,purchase_price
		,ticket_class
		,plan_event_name
		,promo_code_name
		,create_date
		,last_modified
		,order_date
	FROM (SELECT 
	'ST' AS nfl_team_code
	, CAST(tkt.acct_id AS NVARCHAR(25)) + ':' + CAST(tkt.event_id AS NVARCHAR(25)) + ':' + CAST(tkt.section_id AS NVARCHAR(25)) + ':' + CAST(tkt.row_id AS NVARCHAR(25)) + ':' + CAST(tkt.seat_num AS NVARCHAR(25)) + ':' + CAST(tkt.num_seats AS NVARCHAR(25)) AS ticket_orders_id 
	, CAST(tkt.acct_id AS NVARCHAR(25)) + ':' + CAST(cust.cust_name_id AS NVARCHAR(25)) AS ticket_customers_id 
	, tkt.acct_id
	, tkt.event_name
	, evnt.Team
	, tkt.section_name
	, tkt.row_name
	, tkt.num_seats
	, tkt.seat_num
	, tkt.last_Seat
	, tkt.ticket_status
	, season.season_year
	, tkt.order_line_item
	, tkt.order_line_item_seq
	, tkt.sell_location AS sell_location
	, tkt.purchase_price
	, CASE
		WHEN ISNULL(plans.fse,0) >= 1 THEN 'Full Season'
		WHEN ISNULL(plans.fse,0) > 0 THEN 'Partial Season'
		ELSE 'Single Event'
	END AS ticket_class
	, tkt.plan_event_name
	, tkt.promo_code AS promo_code_name 
	, tkt.add_datetime AS create_date
	, tkt.upd_datetime AS last_modified
	, tkt.add_datetime AS order_date
	, ROW_NUMBER() OVER (PARTITION BY CAST(tkt.acct_id AS NVARCHAR(25)) + ':' + CAST(tkt.event_id AS NVARCHAR(25)) + ':' + CAST(tkt.section_id AS NVARCHAR(25)) + ':' + CAST(tkt.row_id AS NVARCHAR(25)) + ':' + CAST(tkt.seat_num AS NVARCHAR(25)) + ':' + CAST(tkt.num_seats AS NVARCHAR(25))
			, CAST(tkt.acct_id AS NVARCHAR(25)) + ':' + CAST(cust.cust_name_id AS NVARCHAR(25))
			, tkt.order_line_item 
		ORDER BY 
			CAST(tkt.acct_id AS NVARCHAR(25)) + ':' + CAST(tkt.event_id AS NVARCHAR(25)) + ':' + CAST(tkt.section_id AS NVARCHAR(25)) + ':' + CAST(tkt.row_id AS NVARCHAR(25)) + ':' + CAST(tkt.seat_num AS NVARCHAR(25)) + ':' + CAST(tkt.num_seats AS NVARCHAR(25))
			, CAST(tkt.acct_id AS NVARCHAR(25)) + ':' + CAST(cust.cust_name_id AS NVARCHAR(25))
			, tkt.order_line_item
			) AS merge_rank
FROM nfl.vw_TM_Ticket tkt
INNER JOIN ods.TM_Evnt evnt ON tkt.event_id = evnt.event_id
INNER JOIN ods.TM_Season season ON evnt.season_id = season.season_id
LEFT OUTER JOIN ods.TM_Evnt plans ON tkt.plan_event_id = plans.Event_id
INNER JOIN ods.TM_cust cust ON tkt.acct_id = cust.acct_id AND cust.primary_code = 'Primary') A 
WHERE merge_rank = 1

)

GO
