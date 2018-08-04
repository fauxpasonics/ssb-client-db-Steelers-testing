SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [archive].[vw_steelers_500f_customer]
AS

SELECT  QUOTENAME(loyalty_id           ,'"')	loyalty_id          
	   ,QUOTENAME(email                ,'"')	email               
	   ,QUOTENAME(external_customer_id,'"')		external_customer_id
	   ,QUOTENAME(enrolled_at          ,'"')	enrolled_at         
	   ,QUOTENAME(first_name           ,'"')	first_name          
	   ,QUOTENAME(last_name            ,'"')	last_name           
	   ,QUOTENAME(balance              ,'"')	balance             
	   ,QUOTENAME(lifetime_balance     ,'"')	lifetime_balance    
	   ,QUOTENAME(last_activity        ,'"')	last_activity       
	   ,QUOTENAME(STATUS               ,'"')	STATUS              
	   ,QUOTENAME(unsubscribed         ,'"')	unsubscribed        
	   ,QUOTENAME(top_tier_name        ,'"')	top_tier_name       
	   ,QUOTENAME(tier_join_date       ,'"')	tier_join_date      
	   ,QUOTENAME(tier_expiration_date,'"')		tier_expiration_date
	   ,QUOTENAME(birthdate            ,'"')	birthdate           
	   ,QUOTENAME(ADDRESS              ,'"')	ADDRESS             
	   ,QUOTENAME(address_2            ,'"')	address_2           
	   ,QUOTENAME(city                 ,'"')	city                
	   ,QUOTENAME(STATE                ,'"')	STATE               
	   ,QUOTENAME(country              ,'"')	country             
	   ,QUOTENAME(postal_code          ,'"')	postal_code         
	   ,QUOTENAME(mobile_phone         ,'"')	mobile_phone        
	   ,QUOTENAME(home_phone           ,'"')	home_phone          
	   ,QUOTENAME(work_phone           ,'"')	work_phone          
	   ,QUOTENAME(home_store           ,'"')	home_store          
	   ,QUOTENAME(channel              ,'"')	channel             
	   ,QUOTENAME(sub_channel          ,'"')	sub_channel         
	   ,QUOTENAME(sub_channel_detail,'"')		sub_channel_detail
	   ,QUOTENAME(brand                ,'"')	brand               
	   ,QUOTENAME(loyalty_id_string    ,'"')	loyalty_id_string   
FROM archive.Steelers_500f_Customer
GO
