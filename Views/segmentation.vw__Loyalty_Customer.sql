SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE  VIEW [segmentation].[vw__Loyalty_Customer]
AS
    (--Loyalty to Dimcustomer
SELECT   ssbid.SSB_CRMSYSTEM_CONTACT_ID --C
        , DimCustomer.SourceSystem Source_System --C
        , DimCustomer.SSID Loyalty_Id --C
		, L_Cust.status Loyalty_Status --C
		, NULL AS Season_Ticket_Holder
		, Top_Tier_Name
		, CAST(L_Cust.unsubscribed AS BIT) Loyalty_Unsubscribed --C
		, CAST(L_Cust.enrolled_at AS DATE) Loyalty_Enrollment_Date --C
		, YEAR(L_Cust.enrolled_at) Loyalty_Enrollment_Year --C
		, MONTH(L_Cust.enrolled_at) Loyalty_Enrollment_Month --C
		, CAST(L_Cust.last_activity AS DATE) Loyalty_Last_Activity -- C/RFM
		, YEAR(L_Cust.last_activity) Loyalty_Last_Active_Year --C/RFM
		, MONTH(L_Cust.last_activity) Loyalty_Last_Active_Month --C/RFM
		, ISNULL(CASE WHEN L_Cust.last_activity = MAX(L_Event.transaction_date) THEN L_Event.type END,'N/A') AS Last_Activity_Type
		, COUNT(L_Event.type) Total_Engagement_Count
		, ISNULL(CASE WHEN L_Event.type = 'badge' THEN COUNT(L_Event.type) END,0) AS Badge_Engagement_Count
		, ISNULL(CASE WHEN L_Event.type = 'tier' THEN COUNT(L_Event.type) END,0) AS Tier_Engagement_Count
		, ISNULL(CASE WHEN L_Event.type = 'checkin' THEN COUNT(L_Event.type) END,0) AS Checkin_Engagement_Count
		, ISNULL(CASE WHEN L_Event.type = 'rsvp' THEN COUNT(L_Event.type) END,0) AS RSVP_Engagementy_Count
		, ISNULL(CASE WHEN L_Event.type = 'complete_profile' THEN 1 ELSE 0 END,0) AS Completed_Profile
		, ISNULL(CASE WHEN L_Event.type LIKE 'purchase%' THEN COUNT(L_Event.type) END,0) AS Purchase_Count
		, ISNULL(CASE WHEN (L_Event.type = 'deal' OR L_Event.type = 'reward' OR L_Event.type = 'gift') THEN COUNT(L_Event.type) END,0) AS Offer_Engagement_Count
		, ISNULL(CASE WHEN L_Event.type = 'social_share' THEN COUNT(L_Event.type) END,0) AS Social_Share_Count
		, ISNULL(CASE WHEN L_Event.type LIKE 'viewed%' THEN COUNT(L_Event.type) END,0) AS Viewed_Social_Engagement_Count
		, ISNULL(CASE WHEN L_Event.type LIKE 'WeeklyHuddle%' THEN COUNT(L_Event.type) END,0) AS Weekly_Huddle_Engagement_Count
		
FROM    dbo.DimCustomer DimCustomer WITH (NOLOCK)
        INNER JOIN dbo.DimCustomerSSBID ssbid WITH ( NOLOCK ) ON DimCustomer.dimcustomerid = ssbid.dimcustomerid
        INNER JOIN ods.Steelers_500f_Customer L_Cust WITH ( NOLOCK ) ON DimCustomer.SSID = L_Cust.loyalty_id AND DimCustomer.SourceSystem = '500f'
		INNER JOIN ods.Steelers_500f_Events L_Event WITH ( NOLOCK ) ON L_Cust.loyalty_id = L_Event.loyalty_customer_id
		GROUP BY  ssbid.SSB_CRMSYSTEM_CONTACT_ID 
                  , DimCustomer.SourceSystem 
                  , DimCustomer.SSID 
                  , L_Cust.status
				  , L_Cust.last_activity
                  , L_Event.type
				  , L_Cust.unsubscribed
				  , L_Cust.enrolled_at
				  , Top_Tier_Name

                  
		
		)


GO
