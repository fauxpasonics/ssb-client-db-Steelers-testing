SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [nfl].[vw_TicketCustomer]
AS
(

SELECT 
		'ST' AS nfl_team_code
		, CAST(CAST(S.acct_id AS NVARCHAR(25)) + ':' + CAST(S.cust_name_id AS NVARCHAR(25)) AS NVARCHAR(100)) AS ticket_customers_id
		, S.acct_id
		, S.cust_name_id
		, S.primary_code 
		, S.rec_status
		, S.acct_type_desc
		, CAST(NULL AS NVARCHAR(255)) AS name_prefix
		, S.name_first
		, S.name_mi
		, S.name_last
		, CAST(NULL AS NVARCHAR(255)) AS name_suffix
		, S.street_addr_1
		, S.street_addr_2
		, S.city
		, S.state
		, S.zip
		, S.country
		, S.email_addr AS email
		, S.phone_day
		, S.phone_eve
		, S.phone_fax
		, S.phone_cell
		, S.gender
		, S.Since_date AS src_registration_date
		, CustType.ticket_class AS derived_customer_type
		, CASE WHEN CustType.acct_id IS NULL THEN 'Lapsed' ELSE 'Active' END AS derived_customer_status
		, S.add_date AS create_date
		, S.upd_date AS last_modified
	
	FROM ods.TM_Cust S
	LEFT OUTER JOIN (
		SELECT acct_id
		, CASE
			WHEN CustSegmentLevel = 1 THEN 'Full Season'
			WHEN CustSegmentLevel > 2 THEN 'Partial Season'
			ELSE 'Single Event'
		END AS ticket_class
		FROM (
			SELECT acct_id, CustSegmentLevel
			, ROW_NUMBER() OVER(PARTITION BY acct_id ORDER BY CustSegmentLevel) AS CustSegmentRank
			FROM (
				SELECT DISTINCT tkt.acct_id
				, CASE
						WHEN ISNULL(plans.fse,0) >= 1 THEN 1
						WHEN ISNULL(plans.fse,0) > 0 THEN 2
						ELSE 3
					END CustSegmentLevel
				FROM ods.TM_vw_Ticket tkt
				LEFT OUTER JOIN ods.TM_Evnt plans ON tkt.plan_event_id = plans.Event_id
			) a
		) a
		WHERE CustSegmentRank = 1
	) CustType ON S.acct_id = CustType.acct_id

)


GO
