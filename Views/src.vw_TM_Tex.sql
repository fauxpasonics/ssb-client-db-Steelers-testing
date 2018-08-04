SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [src].[vw_TM_Tex]
AS
SELECT [event_name]
      ,[section_name]
      ,[row_name]
      ,[event_date]
      ,[event_time]
      ,[seat_num]
      ,[num_seats]
      ,[last_seat]
      ,[seat_increment]
      ,[event_id]
      ,[section_id]
      ,[row_id]
      ,[owner_acct_id]
      ,[Company_name]
      ,[Owner_name]
      ,[Orig_purchase_price]
      ,[order_num]
      ,[order_line_item]
      ,[order_line_item_seq]
      ,[plan_event_id]
      ,[plan_event_name]
      ,[add_datetime]
      ,[add_user]
      ,[assoc_acct_id]
      ,[forward_to_name]
      ,[forward_to_email_addr]
	  , ISNULL(TRY_CAST(te_seller_credit_amount AS DECIMAL(18,6)),0) te_seller_credit_amount
	  , ISNULL(TRY_CAST(te_seller_fees AS DECIMAL(18,6)),0) te_seller_fees
	  , ISNULL(TRY_CAST(te_posting_price AS DECIMAL(18,6)),0) te_posting_price
	  , ISNULL(TRY_CAST(te_buyer_fees_hidden AS DECIMAL(18,6)),0) te_buyer_fees_hidden
	  , ISNULL(TRY_CAST(te_purchase_price AS DECIMAL(18,6)),0) te_purchase_price
	  , ISNULL(TRY_CAST(te_buyer_fees_not_hidden AS DECIMAL(18,6)),0) te_buyer_fees_not_hidden
	  , ISNULL(TRY_CAST(inet_delivery_fee AS DECIMAL(18,6)),0) inet_delivery_fee
	  , ISNULL(TRY_CAST(inet_transaction_amount AS DECIMAL(18,6)),0) inet_transaction_amount
      ,[delivery_method]
      ,[activity]
      ,[activity_name]
      ,[season_name]
      ,[season_id]
      ,[season_year]
      ,[org_id]
      ,[org_name]
	  ,[SourceFileName]
	  ,HASHBYTES('sha2_256', ISNULL(RTRIM([event_name]),'DBNULL_TEXT') + ISNULL(RTRIM([section_name]),'DBNULL_TEXT') + ISNULL(RTRIM([row_name]),'DBNULL_TEXT') + ISNULL(RTRIM([event_date]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([event_time]),'DBNULL_TEXT') + ISNULL(RTRIM([seat_num]),'DBNULL_TEXT') + ISNULL(RTRIM([num_seats]),'DBNULL_TEXT') + ISNULL(RTRIM([last_seat]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([seat_increment]),'DBNULL_TEXT') + ISNULL(RTRIM([event_id]),'DBNULL_TEXT') + ISNULL(RTRIM([section_id]),'DBNULL_TEXT') + ISNULL(RTRIM([row_id]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([owner_acct_id]),'DBNULL_TEXT') + ISNULL(RTRIM([Company_name]),'DBNULL_TEXT') + ISNULL(RTRIM([Owner_name]),'DBNULL_TEXT') + ISNULL(RTRIM([Orig_purchase_price]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([order_num]),'DBNULL_TEXT') + ISNULL(RTRIM([order_line_item]),'DBNULL_TEXT') + ISNULL(RTRIM([order_line_item_seq]),'DBNULL_TEXT') + ISNULL(RTRIM([plan_event_id]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([plan_event_name]),'DBNULL_TEXT') + ISNULL(RTRIM([add_datetime]),'DBNULL_TEXT') + ISNULL(RTRIM([add_user]),'DBNULL_TEXT') + ISNULL(RTRIM([assoc_acct_id]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([forward_to_name]),'DBNULL_TEXT') + ISNULL(RTRIM([forward_to_email_addr]),'DBNULL_TEXT') + ISNULL(RTRIM([te_seller_credit_amount]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([te_seller_fees]),'DBNULL_TEXT') + ISNULL(RTRIM([te_posting_price]),'DBNULL_TEXT') + ISNULL(RTRIM([te_buyer_fees_hidden]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([te_purchase_price]),'DBNULL_TEXT') + ISNULL(RTRIM([te_buyer_fees_not_hidden]),'DBNULL_TEXT') + ISNULL(RTRIM([inet_delivery_fee]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([inet_transaction_amount]),'DBNULL_TEXT') + ISNULL(RTRIM([delivery_method]),'DBNULL_TEXT') + ISNULL(RTRIM([activity]),'DBNULL_TEXT') + ISNULL(RTRIM([activity_name]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([season_name]),'DBNULL_TEXT') + ISNULL(RTRIM([season_id]),'DBNULL_TEXT') + ISNULL(RTRIM([season_year]),'DBNULL_TEXT') + ISNULL(RTRIM([org_id]),'DBNULL_TEXT') + 
	  ISNULL(RTRIM([org_name]),'DBNULL_TEXT')) SrcHashKey
	, ROW_NUMBER() OVER(PARTITION BY season_id, event_id, section_id, row_id, seat_num, num_seats, add_datetime ORDER BY add_datetime DESC) AS MergeRank
  FROM [src].[TM_Tex]

  



GO
