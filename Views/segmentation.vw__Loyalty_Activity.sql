SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE  VIEW [segmentation].[vw__Loyalty_Activity]
AS
    (--Loyalty to Dimcustomer
SELECT  ssbid.SSB_CRMSYSTEM_CONTACT_ID --C
        , DimCustomer.SourceSystem Source_System --C
        , DimCustomer.SSID Loyalty_Id --C
		, L_Event.loyalty_event_id Loyalty_Event_Id --A
		, CASE WHEN L_Event.type = 'badge' THEN 'Badge'  
		  WHEN L_Event.type = 'checkin' THEN 'Check In' 
		  WHEN L_Event.type LIKE 'rsvp%' THEN 'RSVP'
		  WHEN (L_Event.type LIKE 'purchase%' OR L_Event.type = 'deal' OR L_Event.type = 'reward' OR L_Event.type = 'gift') THEN 'Offers'
		  WHEN (L_Event.type LIKE 'viewed%' OR L_Event.type = 'social_share' OR L_Event.type LIKE 'WeeklyHuddle%' ) THEN 'Social' ELSE 'Other' 
		  END AS Loyalty_Activity_Tag_Name
		, L_Event.type Loyalty_Activity_Type --A
		, L_Event.detail Loyalty_Event_Description--A
		, CAST(L_Event.transaction_date AS DATE) Loyalty_Transaction_Date--A
		, YEAR(L_Event.transaction_date) Loyalty_Transaction_Year--A
		, MONTH(L_Event.transaction_date) Loyalty_Transaction_Month--A
	
FROM    dbo.DimCustomer DimCustomer
        INNER JOIN dbo.DimCustomerSSBID ssbid WITH ( NOLOCK ) ON DimCustomer.dimcustomerid = ssbid.dimcustomerid
        INNER JOIN ods.Steelers_500f_Customer L_Cust WITH ( NOLOCK ) ON DimCustomer.SSID = L_Cust.loyalty_id AND DimCustomer.SourceSystem = '500f'
		INNER JOIN ods.Steelers_500f_Events L_Event WITH ( NOLOCK ) ON L_Cust.loyalty_id = L_Event.loyalty_customer_id
		
		)
GO
