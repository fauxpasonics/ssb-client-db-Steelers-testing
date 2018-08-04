SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [rpt].[vw_Tableau500fs]
as
SELECT enrolled_at,c.email,balance, c.lifetime_balance, last_activity, c.status, c.unsubscribed, c.top_tier_name,c.tier_join_date, birthdate,c.address,city,state,country,c.postal_code,type AS eventtype, e.transaction_date AS eventtransaction, detail, value AS TransactionValue,points AS TransactionPoints,e.redeemed_points AS TransactionDetail, value,points 
FROM [ods].[Steelers_500f_Customer]  c LEFT JOIN [ods].[Steelers_500f_Events] e  ON e.loyalty_customer_id = c.loyalty_id
GO
