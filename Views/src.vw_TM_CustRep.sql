SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [src].[vw_TM_CustRep]
AS


SELECT *
, HASHBYTES('sha2_256', ISNULL(RTRIM(acct_id),'DBNULL_TEXT') + ISNULL(RTRIM(acct_rep_id),'DBNULL_TEXT') + ISNULL(RTRIM(acct_rep_type),'DBNULL_TEXT') + ISNULL(RTRIM(acct_rep_type_name),'DBNULL_TEXT') + ISNULL(RTRIM(rep_company_name),'DBNULL_TEXT') + ISNULL(RTRIM(rep_cust_name_id),'DBNULL_TEXT') + ISNULL(RTRIM(rep_email_addr),'DBNULL_TEXT') + ISNULL(RTRIM(rep_full_name),'DBNULL_TEXT') + ISNULL(RTRIM(rep_name_first),'DBNULL_TEXT') + ISNULL(RTRIM(rep_name_last),'DBNULL_TEXT') + ISNULL(RTRIM(rep_name_last_first_mi),'DBNULL_TEXT') + ISNULL(RTRIM(rep_name_middle),'DBNULL_TEXT') + ISNULL(RTRIM(rep_name_title),'DBNULL_TEXT') + ISNULL(RTRIM(rep_nick_name),'DBNULL_TEXT') + ISNULL(RTRIM(rep_phone),'DBNULL_TEXT') + ISNULL(RTRIM(rep_phone_formatted),'DBNULL_TEXT') + ISNULL(RTRIM(rep_user_id),'DBNULL_TEXT') + ISNULL(RTRIM(SourceFileName),'DBNULL_TEXT')) SrcHashKey
FROM (

	SELECT 
		acct_id, acct_rep_id, acct_rep_type, acct_rep_type_name, rep_cust_name_id, rep_name_first, rep_name_middle, rep_name_last, rep_name_title, rep_company_name, rep_nick_name, rep_name_last_first_mi, rep_full_name, rep_user_id, rep_email_addr, rep_phone, rep_phone_formatted, SourceFileName
		, ROW_NUMBER() OVER(PARTITION BY acct_id, acct_rep_id, acct_rep_type ORDER BY acct_id) MergeRank
	FROM [src].[TM_CustRep]
) a













GO
