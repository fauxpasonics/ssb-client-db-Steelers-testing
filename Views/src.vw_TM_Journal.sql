SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [src].[vw_TM_Journal]
AS

/*
EXEC [dbo].[SSBHashFieldSyntaxZF] 'ods.tm_journal', 'id, InsertDate, UpdateDate, HashKey', ''
*/

	SELECT acct_id, stamp, seq, type, type_desc, debit, credit, invoice_amount, event_id, order_num, order_line_item, order_line_item_seq, cc_type, payment_type_desc, payment_schedule_id, invoice_id, journal_Seq_id, add_user, upd_user, SourceFileName, credit_applied, batch_tag, batch_id, cc_num_masked, surchg_amount, surchg_code, disc_amount, disc_code, ledger_code, merchant_code, plan_event_name, event_name, section_name, row_name, seat_num, last_seat, sell_location, info, posted_date	
	, HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(10),acct_id)),'DBNULL_BIGINT') + ISNULL(RTRIM(add_user),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),batch_id)),'DBNULL_INT') + ISNULL(RTRIM(batch_tag),'DBNULL_TEXT') + ISNULL(RTRIM(cc_num_masked),'DBNULL_TEXT') + ISNULL(RTRIM(cc_type),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),credit)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),credit_applied)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),debit)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),disc_amount)),'DBNULL_NUMBER') + ISNULL(RTRIM(disc_code),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),event_id)),'DBNULL_INT') + ISNULL(RTRIM(event_name),'DBNULL_TEXT') + ISNULL(RTRIM(info),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),invoice_amount)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(10),invoice_id)),'DBNULL_BIGINT') + ISNULL(RTRIM(CONVERT(varchar(10),journal_Seq_id)),'DBNULL_BIGINT') + ISNULL(RTRIM(CONVERT(varchar(10),last_seat)),'DBNULL_INT') + ISNULL(RTRIM(ledger_code),'DBNULL_TEXT') + ISNULL(RTRIM(merchant_code),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),order_line_item)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),order_line_item_seq)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),order_num)),'DBNULL_BIGINT') + ISNULL(RTRIM(CONVERT(varchar(10),payment_schedule_id)),'DBNULL_BIGINT') + ISNULL(RTRIM(payment_type_desc),'DBNULL_TEXT') + ISNULL(RTRIM(plan_event_name),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),posted_date,112)),'DBNULL_DATE') + ISNULL(RTRIM(row_name),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),seat_num)),'DBNULL_INT') + ISNULL(RTRIM(section_name),'DBNULL_TEXT') + ISNULL(RTRIM(sell_location),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),seq)),'DBNULL_BIGINT') + ISNULL(RTRIM(SourceFileName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),stamp)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(25),surchg_amount)),'DBNULL_NUMBER') + ISNULL(RTRIM(surchg_code),'DBNULL_TEXT') + ISNULL(RTRIM(type),'DBNULL_TEXT') + ISNULL(RTRIM(type_desc),'DBNULL_TEXT') + ISNULL(RTRIM(upd_user),'DBNULL_TEXT')) HashKey
	FROM (
		SELECT ISNULL(TRY_CAST(acct_id AS BIGINT),0) acct_id, TRY_CAST(stamp AS DATETIME) stamp, ISNULL(TRY_CAST(seq AS BIGINT),0) seq, type, type_desc, ISNULL(TRY_CAST(debit AS DECIMAL(18,6)),0) debit, ISNULL(TRY_CAST(credit AS DECIMAL(18,6)),0) credit, ISNULL(TRY_CAST(invoice_amount AS DECIMAL(18,6)),0) invoice_amount, ISNULL(TRY_CAST(event_id AS INT),0) event_id, ISNULL(TRY_CAST(order_num AS BIGINT),0) order_num, ISNULL(TRY_CAST(order_line_item AS INT),0) order_line_item, ISNULL(TRY_CAST(order_line_item_seq AS INT),0) order_line_item_seq, cc_type, payment_type_desc, ISNULL(TRY_CAST(payment_schedule_id AS BIGINT),0) payment_schedule_id, ISNULL(TRY_CAST(invoice_id AS BIGINT),0) invoice_id, ISNULL(TRY_CAST(journal_Seq_id AS BIGINT),0) journal_Seq_id, add_user, upd_user, SourceFileName, ISNULL(TRY_CAST(credit_applied AS DECIMAL(18,6)),0) credit_applied, batch_tag, ISNULL(TRY_CAST(batch_id AS INT),0) batch_id, cc_num_masked, ISNULL(TRY_CAST(surchg_amount AS DECIMAL(18,6)),0) surchg_amount, surchg_code, ISNULL(TRY_CAST(disc_amount AS DECIMAL(18,6)),0) disc_amount, disc_code, ledger_code, merchant_code, plan_event_name, event_name, section_name, row_name, ISNULL(TRY_CAST(seat_num AS INT),0) seat_num, ISNULL(TRY_CAST(last_seat AS INT),0) last_seat, sell_location, info
			, TRY_CAST(posted_date AS DATE) posted_date
			, ROW_NUMBER() OVER(PARTITION BY journal_Seq_id ORDER BY journal_Seq_id) AS MergeRank
		FROM src.TM_Journal	
	) a
	WHERE MergeRank = 1



GO
