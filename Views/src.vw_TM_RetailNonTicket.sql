SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [src].[vw_TM_RetailNonTicket]
AS

/*
EXEC [dbo].[SSBHashFieldSyntaxZF] 'ods.TM_RetailNonTicket', 'id, InsertDate, UpdateDate, HashKey', ''
*/

SELECT event_name, section_name, row_name, first_seat, last_seat, num_seats, seat_increment, retail_system_name, acct_id, retail_event_id, retail_acct_num, retail_acct_add_date, came_from_code, retail_price_level, retail_ticket_type, retail_qualifiers, retail_purchase_price, transaction_datetime, retail_opcode, retail_operator_type, refund_flag, add_user, add_datetime, owner_name, owner_name_full, retail_event_code, event_date, event_time, attraction_name, major_category_name, minor_category_name, venue_name, primary_act, secondary_act, event_id, SourceFileName
, HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(VARCHAR(10),acct_id)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(VARCHAR(25),add_datetime)),'DBNULL_DATETIME') + ISNULL(RTRIM(add_user),'DBNULL_TEXT') + ISNULL(RTRIM(attraction_name),'DBNULL_TEXT') + ISNULL(RTRIM(came_from_code),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),event_date,112)),'DBNULL_DATE') + ISNULL(RTRIM(CONVERT(VARCHAR(10),event_id)),'DBNULL_INT') + ISNULL(RTRIM(event_name),'DBNULL_TEXT') + ISNULL(RTRIM(event_time),'DBNULL_TEXT') + ISNULL(RTRIM(first_seat),'DBNULL_TEXT') + ISNULL(RTRIM(last_seat),'DBNULL_TEXT') + ISNULL(RTRIM(major_category_name),'DBNULL_TEXT') + ISNULL(RTRIM(minor_category_name),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),num_seats)),'DBNULL_INT') + ISNULL(RTRIM(owner_name),'DBNULL_TEXT') + ISNULL(RTRIM(owner_name_full),'DBNULL_TEXT') + ISNULL(RTRIM(primary_act),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),refund_flag)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),retail_acct_add_date,112)),'DBNULL_DATE') + ISNULL(RTRIM(retail_acct_num),'DBNULL_TEXT') + ISNULL(RTRIM(retail_event_code),'DBNULL_TEXT') + ISNULL(RTRIM(retail_event_id),'DBNULL_TEXT') + ISNULL(RTRIM(retail_opcode),'DBNULL_TEXT') + ISNULL(RTRIM(retail_operator_type),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),retail_price_level)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(VARCHAR(25),retail_purchase_price)),'DBNULL_NUMBER') + ISNULL(RTRIM(retail_qualifiers),'DBNULL_TEXT') + ISNULL(RTRIM(retail_system_name),'DBNULL_TEXT') + ISNULL(RTRIM(retail_ticket_type),'DBNULL_TEXT') + ISNULL(RTRIM(row_name),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),seat_increment)),'DBNULL_INT') + ISNULL(RTRIM(secondary_act),'DBNULL_TEXT') + ISNULL(RTRIM(section_name),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(25),transaction_datetime)),'DBNULL_DATETIME') + ISNULL(RTRIM(venue_name),'DBNULL_TEXT')) HashKey
FROM (
	SELECT event_name, section_name, row_name, ISNULL(TRY_CAST(first_seat AS int),0) first_seat, ISNULL(TRY_CAST(last_seat AS int),0) last_seat, ISNULL(TRY_CAST(num_seats AS int),0) num_seats, ISNULL(TRY_CAST(seat_increment AS int),0) seat_increment, retail_system_name, ISNULL(TRY_CAST(acct_id AS int),0) acct_id, retail_event_id, retail_acct_num, TRY_CAST(retail_acct_add_date AS date) retail_acct_add_date, came_from_code, ISNULL(TRY_CAST(retail_price_level AS int),0) retail_price_level, retail_ticket_type, retail_qualifiers, ISNULL(TRY_CAST(retail_purchase_price AS decimal(18,6)),0) retail_purchase_price, TRY_CAST(transaction_datetime AS datetime) transaction_datetime, retail_opcode, retail_operator_type, ISNULL(TRY_CAST(refund_flag AS int),0) refund_flag, add_user, TRY_CAST(add_datetime AS datetime) add_datetime, owner_name, owner_name_full, retail_event_code, TRY_CAST(event_date AS date) event_date, TRY_CAST(event_time AS time) event_time, attraction_name, major_category_name, minor_category_name, venue_name, primary_act, secondary_act, ISNULL(TRY_CAST(event_id AS int),0) event_id, SourceFileName	
	, ROW_NUMBER() OVER(PARTITION BY event_id, event_name, retail_event_id, section_name, row_name, first_seat, last_seat, refund_flag ORDER BY transaction_datetime DESC, add_datetime DESC) AS MergeRank
  FROM [src].[TM_RetailNonTicket]
) a 
WHERE MergeRank = 1



GO
