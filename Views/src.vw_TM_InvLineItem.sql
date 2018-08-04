SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [src].[vw_TM_InvLineItem]
AS

/*
EXEC [dbo].[SSBHashFieldSyntaxZF] 'ods.TM_InvLineItem', 'id, InsertDate, UpdateDate, HashKey', ''
*/

SELECT acct_id, order_num, order_line_item, order_line_item_seq, invoice_id, amount, purchase_amount, gross_invoice_amount, invoice_method, item_amount, status, required_ind, opt_out, opt_out_user, opt_out_datetime, SourceFileName
, HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(10),acct_id)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(25),amount)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),gross_invoice_amount)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(10),invoice_id)),'DBNULL_INT') + ISNULL(RTRIM(invoice_method),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),item_amount)),'DBNULL_NUMBER') + ISNULL(RTRIM(opt_out),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),opt_out_datetime)),'DBNULL_DATETIME') + ISNULL(RTRIM(opt_out_user),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),order_line_item)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),order_line_item_seq)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),order_num)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(25),purchase_amount)),'DBNULL_NUMBER') + ISNULL(RTRIM(required_ind),'DBNULL_TEXT') + ISNULL(RTRIM(SourceFileName),'DBNULL_TEXT') + ISNULL(RTRIM(status),'DBNULL_TEXT')) HashKey
FROM (
	SELECT ISNULL(TRY_CAST(acct_id AS int),0) acct_id, ISNULL(TRY_CAST(order_num AS int),0) order_num, ISNULL(TRY_CAST(order_line_item AS int),0) order_line_item, ISNULL(TRY_CAST(order_line_item_seq AS int),0) order_line_item_seq, ISNULL(TRY_CAST(invoice_id AS int),0) invoice_id, ISNULL(TRY_CAST(amount AS decimal(18,6)),0) amount, ISNULL(TRY_CAST(purchase_amount AS decimal(18,6)),0) purchase_amount, ISNULL(TRY_CAST(gross_invoice_amount AS decimal(18,6)),0) gross_invoice_amount, invoice_method, ISNULL(TRY_CAST(item_amount AS decimal(18,6)),0) item_amount, status, required_ind, opt_out, opt_out_user, TRY_CAST(opt_out_datetime AS datetime) opt_out_datetime, SourceFileName
	, ROW_NUMBER() OVER(PARTITION BY invoice_id, order_num, order_line_item, order_line_item_seq ORDER BY [status]) AS MergeRank
  FROM [src].TM_InvLineItem
) a 
WHERE MergeRank = 1





GO
