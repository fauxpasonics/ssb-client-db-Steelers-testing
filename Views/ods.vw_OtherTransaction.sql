SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [ods].[vw_OtherTransaction]
as 
	select 
		'ST' as nfl_team_code
		,'NEWSLETTER' as system_type
		,cast(NULL as nvarchar(255)) as customer_id
		,cast(NULL as nvarchar(255)) as loyalty_id
		, upper(cast(master.dbo.fn_varbintohexstr(HASHBYTES('SHA1', 
				'ST' + '|'
				+ ISNULL(LEFT(a.email, 10), '') + '|'
				+ ISNULL(a.name_first, '') + '|'
				+ ISNULL(a.name_last, '') + '|'
				+ ISNULL(a.street_addr_1, '') + '|'
				+ ISNULL(a.city, '') + '|'
				+ ISNULL(a.state, '') + '|'
				+ ISNULL(a.zip, '') + '|'
				+ ISNULL(NULL /*order_id*/, '') + '|'
				+ ISNULL(a.order_date, ''))) as varchar(32))) as order_id
		,cast(NULL as nvarchar(255)) as name_prefix
		,a.name_first
		,cast(NULL as nvarchar(255)) as name_mi
		,a.name_last
		,cast(NULL as nvarchar(255)) as name_suffix
		,a.street_addr_1
		,a.street_addr_2
		,a.city 
		,a.state
		,a.zip
		,a.country
		,a.email
		,cast(NULL as nvarchar(255)) as phone_day
		,cast(NULL as nvarchar(255)) as phone_eve
		,cast(NULL as nvarchar(255)) as phone_fax
		,cast(NULL as nvarchar(255)) as phone_cell
		,cast(a.order_date as datetime) as order_date
		,cast(NULL as nvarchar(255)) as order_amount
		,cast(a.order_date as date) as src_registration_date
		,0 as is_delete
		,0 as is_update
		,cast(a.order_date as date)  as create_date
		,cast(a.order_date as date) as last_modified
	from ods.Digest a

	UNION ALL

	select 
		'ST' as nfl_team_code
		,'POS' as system_type
		,userid as customer_id
		,cast(NULL as nvarchar(255)) as loyalty_id
		,userid + ':' + invoicenumber as order_id
		,cast(NULL as nvarchar(255)) as name_prefix
		,cast(NULL as nvarchar(255)) as name_first
		,cast(NULL as nvarchar(255)) as name_mi
		,cast(NULL as nvarchar(255)) as name_last
		,cast(NULL as nvarchar(255)) as name_suffix
		,cast(NULL as nvarchar(255)) as street_addr_1
		,cast(NULL as nvarchar(255)) as street_addr_2
		,cast(NULL as nvarchar(255)) as city 
		,cast(NULL as nvarchar(255)) as state
		,cast(NULL as nvarchar(255)) as zip
		,cast(NULL as nvarchar(255)) as country
		,a.email
		,cast(NULL as nvarchar(255)) as phone_day
		,cast(NULL as nvarchar(255)) as phone_eve
		,cast(NULL as nvarchar(255)) as phone_fax
		,cast(NULL as nvarchar(255)) as phone_cell
		,cast(a.date_start as datetime) as order_date
		,cast(cast(a.cc_total as decimal(18,6)) + cast(gift_certificate as decimal(18,6)) as varchar(255)) as order_amount
		,cast(a.date_start as date) as src_registration_date
		,0 as is_delete
		,0 as is_update
		,cast(a.date_start as date)  as create_date
		,cast(a.date_start as date) as last_modified
	from ods.Online_Merch_Purchasers a

GO
