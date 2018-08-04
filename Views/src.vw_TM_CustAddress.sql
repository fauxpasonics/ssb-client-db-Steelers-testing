SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [src].[vw_TM_CustAddress]
AS

/*
EXEC [dbo].[SSBHashFieldSyntaxZF] 'ods.tm_CustAddress', 'id, InsertDate, UpdateDate, HashKey', ''
*/

SELECT cust_name_id, cust_address_id, address_type, address_type_name, acct_id, primary_ind, street_addr_1, street_addr_2, city, state, zip, country, county, solicit_mail, solicit_mail_registry, carrier_route, seasonal, start_date, end_date, city_state_zip, name_prefix, name_prefix2, name_first, name_middle, name_last, name_suffix, name_title, company_name, nick_name, maiden_name, salutation, name_last_first_mi, full_name, primary_code, address_type_primary_ind, name_type, owner_name, owner_name_full, SourceFileName
, HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(VARCHAR(10),acct_id)),'DBNULL_INT') + ISNULL(RTRIM(address_type),'DBNULL_TEXT') + ISNULL(RTRIM(address_type_name),'DBNULL_TEXT') + ISNULL(RTRIM(address_type_primary_ind),'DBNULL_TEXT') + ISNULL(RTRIM(carrier_route),'DBNULL_TEXT') + ISNULL(RTRIM(city),'DBNULL_TEXT') + ISNULL(RTRIM(city_state_zip),'DBNULL_TEXT') + ISNULL(RTRIM(company_name),'DBNULL_TEXT') + ISNULL(RTRIM(country),'DBNULL_TEXT') + ISNULL(RTRIM(county),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),cust_address_id)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(VARCHAR(10),cust_name_id)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(VARCHAR(25),end_date)),'DBNULL_DATETIME') + ISNULL(RTRIM(full_name),'DBNULL_TEXT') + ISNULL(RTRIM(maiden_name),'DBNULL_TEXT') + ISNULL(RTRIM(name_first),'DBNULL_TEXT') + ISNULL(RTRIM(name_last),'DBNULL_TEXT') + ISNULL(RTRIM(name_last_first_mi),'DBNULL_TEXT') + ISNULL(RTRIM(name_middle),'DBNULL_TEXT') + ISNULL(RTRIM(name_prefix),'DBNULL_TEXT') + ISNULL(RTRIM(name_prefix2),'DBNULL_TEXT') + ISNULL(RTRIM(name_suffix),'DBNULL_TEXT') + ISNULL(RTRIM(name_title),'DBNULL_TEXT') + ISNULL(RTRIM(name_type),'DBNULL_TEXT') + ISNULL(RTRIM(nick_name),'DBNULL_TEXT') + ISNULL(RTRIM(owner_name),'DBNULL_TEXT') + ISNULL(RTRIM(owner_name_full),'DBNULL_TEXT') + ISNULL(RTRIM(primary_code),'DBNULL_TEXT') + ISNULL(RTRIM(primary_ind),'DBNULL_TEXT') + ISNULL(RTRIM(salutation),'DBNULL_TEXT') + ISNULL(RTRIM(seasonal),'DBNULL_TEXT') + ISNULL(RTRIM(solicit_mail),'DBNULL_TEXT') + ISNULL(RTRIM(solicit_mail_registry),'DBNULL_TEXT') + ISNULL(RTRIM(SourceFileName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(VARCHAR(25),start_date)),'DBNULL_DATETIME') + ISNULL(RTRIM(state),'DBNULL_TEXT') + ISNULL(RTRIM(street_addr_1),'DBNULL_TEXT') + ISNULL(RTRIM(street_addr_2),'DBNULL_TEXT') + ISNULL(RTRIM(zip),'DBNULL_TEXT')) HashKey
FROM (
	SELECT cust_name_id, cust_address_id, address_type, address_type_name, acct_id, primary_ind, street_addr_1, street_addr_2, city, state, zip, country, county, solicit_mail, solicit_mail_registry, carrier_route, seasonal, start_date, end_date, city_state_zip, name_prefix, name_prefix2, name_first, name_middle, name_last, name_suffix, name_title, company_name, nick_name, maiden_name, salutation, name_last_first_mi, full_name, primary_code, address_type_primary_ind, name_type, owner_name, owner_name_full, SourceFileName
	, ROW_NUMBER() OVER(PARTITION BY acct_id, cust_name_id, cust_address_id ORDER BY primary_ind) AS MergeRank
  FROM [src].[TM_CustAddress]
) a 
WHERE MergeRank = 1






GO
