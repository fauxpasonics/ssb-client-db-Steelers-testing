SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [nfl].[vw_TM_Ticket] 
AS 
(

	SELECT 
		tkt.event_name, tkt.section_name, tkt.row_name, tkt.num_seats, tkt.ticket_status, tkt.acct_id, tkt.upd_datetime, tkt.block_purchase_price, tkt.order_num, tkt.order_line_item,
		order_line_item_seq, tkt.info, tkt.total_events, tkt.price_code, tkt.pricing_method, tkt.comp_code, tkt.comp_name, tkt.Paid, tkt.disc_code, tkt.disc_amount, tkt.surchg_code, tkt.surchg_amount,
		group_flag, tkt.upd_user, tkt.class_name, tkt.sell_location, tkt.full_price, tkt.purchase_price, tkt.sales_source_name, tkt.sales_source_date, tkt.Ticket_Type, tkt.Price_code_desc, tkt.event_id,
		plan_event_id, tkt.plan_event_name, tkt.seat_num, tkt.last_Seat, tkt.other_info_1, tkt.other_info_2, tkt.other_info_3, tkt.other_info_4, tkt.other_info_5, tkt.other_info_6, tkt.other_info_7,
		other_info_8, tkt.other_info_9, tkt.other_info_10, tkt.acct_Rep_id, tkt.acct_rep_full_name, tkt.tran_type, tkt.section_id, tkt.row_id, tkt.promo_code, tkt.retail_ticket_type,
		retail_qualifiers, tkt.paid_amount, tkt.owed_amount, tkt.add_datetime, tkt.add_user, tkt.renewal_ind, tkt.InsertDate, tkt.UpdateDate, tkt.SourceFileName, tkt.HashKey,
		return_reason, tkt.return_reason_desc, CAST(tkt.SourceTable AS nvarchar(255)) SourceTable
	FROM ods.TM_vw_Ticket tkt
	
		UNION ALL

	SELECT 
		event_name, section_name, row_name, num_seats, ticket_status, acct_id, upd_datetime, block_purchase_price, order_num, order_line_item,
		order_line_item_seq, info, total_events, price_code, pricing_method, comp_code, comp_name, Paid, disc_code, disc_amount, surchg_code, surchg_amount,
		group_flag, upd_user, class_name, sell_location, full_price, purchase_price, sales_source_name, sales_source_date, Ticket_Type, Price_code_desc, event_id,
		plan_event_id, plan_event_name, seat_num, last_Seat, other_info_1, other_info_2, other_info_3, other_info_4, other_info_5, other_info_6, other_info_7,
		other_info_8, other_info_9, other_info_10, acct_Rep_id, acct_rep_full_name, tran_type, section_id, row_id, promo_code, retail_ticket_type,
		retail_qualifiers, paid_amount, owed_amount, add_datetime, add_user, renewal_ind, InsertDate, UpdateDate, SourceFileName, HashKey,
		return_reason, return_reason_desc, CAST('TM_Ticket_History' AS nvarchar(255)) SourceTable
	FROM ods.TM_Ticket_History (NOLOCK)

) 


GO
