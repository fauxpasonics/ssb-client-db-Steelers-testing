SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [rpt].[PreCache_Cust_Email_CustomerSummary]
AS

TRUNCATE TABLE ods.Epsilon_Activities_CustomerSummary

INSERT INTO ods.Epsilon_Activities_CustomerSummary

SELECT CustomerKey
,COUNT(DISTINCT CASE WHEN Preference = 'BREAKINGNEWS'		AND Action = 'SEND' THEN MessageID END) NumDelivered_BREAKINGNEWS	
,COUNT(DISTINCT CASE WHEN Preference = 'BREAKINGNEWS'		AND Action = 'CLICK' THEN MessageID END) NumClicked_BREAKINGNEWS	
,COUNT(DISTINCT CASE WHEN Preference = 'BREAKINGNEWS'		AND Action = 'OPEN' THEN MessageID END) NumOpened_BREAKINGNEWS	
,COUNT(DISTINCT CASE WHEN Preference = 'HF'					AND Action = 'SEND' THEN MessageID END) NumDelivered_HF					  																															
,COUNT(DISTINCT CASE WHEN Preference = 'HF'					AND Action = 'CLICK' THEN MessageID END) NumClicked_HF				
,COUNT(DISTINCT CASE WHEN Preference = 'HF'					AND Action = 'OPEN' THEN MessageID END) NumOpened_HF			
,COUNT(DISTINCT CASE WHEN Preference = 'MERCH'				AND Action = 'SEND' THEN MessageID END) NumDelivered_MERCH		
,COUNT(DISTINCT CASE WHEN Preference = 'MERCH'				AND Action = 'CLICK' THEN MessageID END) NumClicked_MERCH		
,COUNT(DISTINCT CASE WHEN Preference = 'MERCH'				AND Action = 'OPEN' THEN MessageID END) NumOpened_MERCH		
,COUNT(DISTINCT CASE WHEN Preference = 'MKTG'				AND Action = 'SEND' THEN MessageID END) NumDelivered_MKTG			
,COUNT(DISTINCT CASE WHEN Preference = 'MKTG'				AND Action = 'CLICK' THEN MessageID END) NumClicked_MKTG			
,COUNT(DISTINCT CASE WHEN Preference = 'MKTG'				AND Action = 'OPEN' THEN MessageID END) NumOpened_MKTG			
,COUNT(DISTINCT CASE WHEN Preference = 'NEWS'				AND Action = 'SEND' THEN MessageID END) NumDelivered_NEWS			
,COUNT(DISTINCT CASE WHEN Preference = 'NEWS'				AND Action = 'CLICK' THEN MessageID END) NumClicked_NEWS			
,COUNT(DISTINCT CASE WHEN Preference = 'NEWS'				AND Action = 'OPEN' THEN MessageID END) NumOpened_NEWS			
,COUNT(DISTINCT CASE WHEN Preference = 'REACTIVATION'		AND Action = 'SEND' THEN MessageID END) NumDelivered_REACTIVATION	
,COUNT(DISTINCT CASE WHEN Preference = 'REACTIVATION'		AND Action = 'CLICK' THEN MessageID END) NumClicked_REACTIVATION	
,COUNT(DISTINCT CASE WHEN Preference = 'REACTIVATION'		AND Action = 'OPEN' THEN MessageID END) NumOpened_REACTIVATION	
,COUNT(DISTINCT CASE WHEN Preference = 'SNU'				AND Action = 'SEND' THEN MessageID END) NumDelivered_SNU			
,COUNT(DISTINCT CASE WHEN Preference = 'SNU'				AND Action = 'CLICK' THEN MessageID END) NumClicked_SNU			
,COUNT(DISTINCT CASE WHEN Preference = 'SNU'				AND Action = 'OPEN' THEN MessageID END) NumOpened_SNU			
,COUNT(DISTINCT CASE WHEN Preference = 'SPONSOR'			AND Action = 'SEND' THEN MessageID END) NumDelivered_SPONSOR		
,COUNT(DISTINCT CASE WHEN Preference = 'SPONSOR'			AND Action = 'CLICK' THEN MessageID END) NumClicked_SPONSOR		
,COUNT(DISTINCT CASE WHEN Preference = 'SPONSOR'			AND Action = 'OPEN' THEN MessageID END) NumOpened_SPONSOR		
FROM ods.Epsilon_Activities_LastNinety (NOLOCK)	
GROUP BY CustomerKey	
GO
