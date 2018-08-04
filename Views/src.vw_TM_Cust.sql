SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [src].[vw_TM_Cust]
as

SELECT [acct_id]
      ,[cust_name_id]
      ,[Relationship_type]
      ,[Primary_code]
      ,[rec_status]
      ,[acct_type_desc]
      ,[salutation]
      ,[company_name]
      ,[name_first]
      ,[name_mi]
      ,[name_last]
      ,[name_title]
      ,[street_addr_1]
      ,[street_addr_2]
      ,[city]
      ,[state]
      ,[zip]
      ,[country]
      ,[phone_day]
      ,[phone_eve]
      ,[phone_fax]
      ,[Tag]
      ,[acct_rep_num]
      ,[acct_rep_name]
      ,[priority]
      ,case when try_cast([points] as bigint) is not null then points else 0 end points
      ,case when try_cast([points_ytd] as bigint) is not null then points else 0 end points_ytd
      ,case when try_cast([points_itd] as bigint) is not null then points else 0 end points_itd
      ,[email_addr]
      ,[add_date]
      ,[add_user]
      ,[upd_date]
      ,[upd_user]
      ,[birth_date]
      ,[Since_date]
      ,[old_acct_id]
      ,[household_id]
      ,[fan_loyalty_id]
      ,[ext_system1_id]
      ,[ext_system2_id]
      ,[other_info_1]
      ,[other_info_2]
      ,[other_info_3]
      ,[other_info_4]
      ,[other_info_5]
      ,[other_info_6]
      ,[other_info_7]
      ,[other_info_8]
      ,[other_info_9]
      ,[other_info_10]
      ,[source]
      ,[source_name]
      ,[source_desc]
      ,[pin]
      ,[gender]
      ,[solicit_phone_day]
      ,[Solicit_phone_eve]
      ,[solicit_phone_fax]
      ,[Solicit_email]
      ,[solicit_addr]
      ,[marital_Status]
      ,[Sic_Code]
      ,[Sic_Name]
      ,[Industry]
      ,[phone_cell]
      ,[solicit_phone_cell]
      ,[email_addr2]
      ,[Source_list_name]
      ,[Maiden_Name]
	  ,[SourceFileName]
	  ,[name_type]
	  ,HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(VARCHAR(255),acct_id )),'DBNULL_BIGINT') + ISNULL(RTRIM(CONVERT(VARCHAR(255),cust_name_id)),'DBNULL_BIGINT') + 
							ISNULL(RTRIM(Relationship_type),'DBNULL_TEXT') + ISNULL(RTRIM(Primary_code),'DBNULL_TEXT') + ISNULL(RTRIM(rec_status),'DBNULL_TEXT') + 
							ISNULL(RTRIM(acct_type_desc),'DBNULL_TEXT') + ISNULL(RTRIM(salutation),'DBNULL_TEXT') + ISNULL(RTRIM(company_name),'DBNULL_TEXT') + 
							ISNULL(RTRIM(name_first),'DBNULL_TEXT') + ISNULL(RTRIM(name_mi),'DBNULL_TEXT') + ISNULL(RTRIM(name_last),'DBNULL_TEXT') + 
							ISNULL(RTRIM(name_title),'DBNULL_TEXT') + ISNULL(RTRIM(street_addr_1),'DBNULL_TEXT') + ISNULL(RTRIM(street_addr_2),'DBNULL_TEXT') + 
							ISNULL(RTRIM(city),'DBNULL_TEXT') + ISNULL(RTRIM(state),'DBNULL_TEXT') + ISNULL(RTRIM(zip),'DBNULL_TEXT') + ISNULL(RTRIM(country),'DBNULL_TEXT') + 
							ISNULL(RTRIM(phone_day),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(255),phone_eve)),'DBNULL_BIGINT') + ISNULL(RTRIM(CONVERT(VARCHAR(255),phone_fax)),'DBNULL_BIGINT') + 
							ISNULL(RTRIM(Tag),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(255),acct_rep_num)),'DBNULL_BIGINT') + ISNULL(RTRIM(acct_rep_name),'DBNULL_TEXT') + 
							ISNULL(RTRIM(CONVERT(VARCHAR(255),priority)),'DBNULL_BIGINT') + ISNULL(RTRIM(CONVERT(VARCHAR(255),points)),'DBNULL_BIGINT') + 
							ISNULL(RTRIM(CONVERT(VARCHAR(255),points_ytd)),'DBNULL_BIGINT') + ISNULL(RTRIM(CONVERT(VARCHAR(255),points_itd)),'DBNULL_BIGINT') + 
							ISNULL(RTRIM(email_addr),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(255),add_date)),'DBNULL_DATETIME') + ISNULL(RTRIM(add_user),'DBNULL_TEXT') + 
							ISNULL(RTRIM(CONVERT(VARCHAR(255),upd_date)),'DBNULL_DATETIME') + ISNULL(RTRIM(upd_user),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(255),birth_date)),'DBNULL_DATETIME') + 
							ISNULL(RTRIM(CONVERT(VARCHAR(255),Since_date)),'DBNULL_DATETIME') + ISNULL(RTRIM(old_acct_id),'DBNULL_TEXT') + ISNULL(RTRIM(household_id),'DBNULL_TEXT') + 
							ISNULL(RTRIM(fan_loyalty_id),'DBNULL_TEXT') + ISNULL(RTRIM(ext_system1_id),'DBNULL_TEXT') + ISNULL(RTRIM(ext_system2_id),'DBNULL_TEXT') + 
							ISNULL(RTRIM(other_info_1),'DBNULL_TEXT') + ISNULL(RTRIM(other_info_2),'DBNULL_TEXT') + ISNULL(RTRIM(other_info_3),'DBNULL_TEXT') + 
							ISNULL(RTRIM(other_info_4),'DBNULL_TEXT') + ISNULL(RTRIM(other_info_5),'DBNULL_TEXT') + ISNULL(RTRIM(other_info_6),'DBNULL_TEXT') + 
							ISNULL(RTRIM(other_info_7),'DBNULL_TEXT') + ISNULL(RTRIM(other_info_8),'DBNULL_TEXT') + ISNULL(RTRIM(other_info_9),'DBNULL_TEXT') + 
							ISNULL(RTRIM(other_info_10),'DBNULL_TEXT') + ISNULL(RTRIM(source),'DBNULL_TEXT') + ISNULL(RTRIM(source_name),'DBNULL_TEXT') + 
							ISNULL(RTRIM(source_desc),'DBNULL_TEXT') + ISNULL(RTRIM(pin),'DBNULL_TEXT') + ISNULL(RTRIM(gender),'DBNULL_TEXT') + 
							ISNULL(RTRIM(solicit_phone_day),'DBNULL_TEXT') + ISNULL(RTRIM(Solicit_phone_eve),'DBNULL_TEXT') + ISNULL(RTRIM(solicit_phone_fax),'DBNULL_TEXT') + 
							ISNULL(RTRIM(Solicit_email),'DBNULL_TEXT') + ISNULL(RTRIM(solicit_addr),'DBNULL_TEXT') + ISNULL(RTRIM(marital_Status),'DBNULL_TEXT') + 
							ISNULL(RTRIM(Sic_Code),'DBNULL_TEXT') + ISNULL(RTRIM(Sic_Name),'DBNULL_TEXT') + ISNULL(RTRIM(Industry),'DBNULL_TEXT') + 
							ISNULL(RTRIM(CONVERT(VARCHAR(255),phone_cell)),'DBNULL_BIGINT') + ISNULL(RTRIM(solicit_phone_cell),'DBNULL_TEXT') + 
							ISNULL(RTRIM(email_addr2),'DBNULL_TEXT') + ISNULL(RTRIM(Source_list_name),'DBNULL_TEXT') + ISNULL(RTRIM(Maiden_Name),'DBNULL_TEXT') +
							ISNULL(RTRIM(name_type),'DBNULL_TEXT')) SrcHashKey
	, ROW_NUMBER() OVER(PARTITION BY acct_id, cust_name_id ORDER BY upd_date desc) AS MergeRank
  FROM [src].[TM_Cust]










GO
