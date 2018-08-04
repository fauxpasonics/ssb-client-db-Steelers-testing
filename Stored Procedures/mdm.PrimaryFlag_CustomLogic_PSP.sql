SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [mdm].[PrimaryFlag_CustomLogic_PSP] as
Begin

/* mdm.UpdateSSBPrimaryFlag - Creates/Updates SSB Primary Flag
* created: 11/18/2014 kwyss
* modified:
*
*
*/
 
/* Most Recent Transaction - this is custom */
with stubhub_orders as
	( 
	Select OrderNumber, Account, OrderDate 
	FROM [172.31.17.15].Sixers.dbo.vw_SixersTrans
	where item like 'SH%'
	 )
Select trans.account, trans.class, max(trans.orderdate) as most_recent_trans_dt
into #tmp_sixers_trans
FROM [172.31.17.15].Sixers.dbo.vw_SixersTrans trans
left join stubhub_orders sh
on trans.ordernumber = sh.ordernumber and trans.account = sh.account and trans.orderdate = sh.orderdate
where class is not null 
---and trans.account = '10462'
group by trans.account, trans.class
UNION ALL 
Select trans.account, 'STUBHUB' as class, max(trans.orderdate) as most_recent_trans_dt
FROM [172.31.17.15].Sixers.dbo.vw_SixersTrans trans
inner join stubhub_orders sh
on trans.ordernumber = sh.ordernumber and trans.account = sh.account and trans.orderdate = sh.orderdate
---where class is not null 
---and trans.account = '10462'
group by trans.account;


SELECT
 dc.ssid
 ,dc.sourcesystem
 , di.ItemClass ItemClass
	, max(sd.CalDate) as most_recent_trans_dt
into #tmp_devils_trans
	FROM devils.rpt.vw_FactTicketSales f
	INNER JOIN devils.rpt.vw_DimDate sd ON sd.DimDateId = f.DimDateId
	INNER JOIN devils.rpt.vw_DimCustomer dc ON dc.DimCustomerId = f.DimCustomerId
	INNER JOIN devils.rpt.vw_DimItem di ON di.DimItemId = f.DimItemId
	group by dc.ssid, dc.sourcesystem, di.ItemClass;



	
with most_recent_trans as (
	Select 'Sixers' as brand, 'TI' as sourcesystem, account, max(most_recent_trans_dt) as most_recent_trans_dt
	from #tmp_sixers_trans
	where class != 'Stubhub'
	group by account
	union all
	select 'Devils' as brand, SourceSystem, SSID, max(most_recent_trans_dt) as most_recent_trans_dt
	from #tmp_devils_trans
	group by sourcesystem, ssid
)
,most_recent_sh_trans as (
	Select 'Sixers' as brand, 'TI' as sourcesystem, account, max(most_recent_trans_dt) as most_recent_trans_dt
	from #tmp_sixers_trans
	where class = 'Stubhub'
	group by account
)
Select ssbid.dimcustomerid, ssbid.sourcesystem, ssbid.ssid, 
ssbid.ssb_crmsystem_acct_id, ssbid.SSB_CRMSYSTEM_CONTACT_ID, isnull(a.most_recent_trans_dt, b.most_recent_trans_dt) as trans_dt, 
isnull(MaxSeasonTicketHolder, 0) as STH, dimcust.SSUpdatedDate, DIMCUST.SSCreatedDate, ssbid.SSB_CRMSYSTEM_PRIMARY_FLAG,   
ssbid.SSB_CRMSYSTEM_ACCT_PRIMARY_FLAG, dimcust.SourceSystemPriority
from dimcustomerssbid ssbid
inner join dimcustomer dimcust
on ssbid.DimCustomerId = dimcust.dimcustomerid
left join most_recent_trans a
on ssbid.SourceSystem = a.sourcesystem and ssbid.SSID = a.account
left join most_recent_sh_trans b
on ssbid.SourceSystem = b.sourcesystem and ssbid.SSID = b.account
left join psp_sfdc.stg.vw_SeasonTicketHolders_DimcustomerID c
on ssbid.SourceSystem = c.sourcesystem and ssbid.ssid = c.ssid
where dimcust.isdeleted = 0;


end




GO
