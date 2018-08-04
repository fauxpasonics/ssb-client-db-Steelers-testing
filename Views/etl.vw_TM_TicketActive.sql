SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [etl].[vw_TM_TicketActive] as (

	select a.*
	from ods.TM_vw_TicketActive a
	left outer join ods.TM_vw_TicketReturn r 
	on a.acct_id = r.acct_id 
		and a.event_id = r.event_id
		and a.section_id = r.section_id
		and a.row_id = r.row_id
		and a.seat_num = r.seat_num
		and a.order_num <= r.order_num
		and a.order_line_item <= r.order_line_item
		and a.add_datetime <= isnull(r.add_datetime, '1900-01-01')
	where r.acct_id is null 

)

GO
