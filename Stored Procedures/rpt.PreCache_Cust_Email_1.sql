SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO










CREATE PROC [rpt].[PreCache_Cust_Email_1]
AS 

INSERT INTO rpt.PreCache_Cust_Email_1_tbl

SELECT COUNT(dc.SSID) AS AllAccounts
	   ,COUNT(case when Emailable.PROFILE_KEY IS NOT NULL THEN dc.SSID END) AS EmailAccounts
	   ,COUNT(case when Engaged.PROFILE_KEY   IS NOT NULL THEN dc.SSID END) AS EngagedEmail
	   ,0 AS IsReady
FROM dbo.DimCustomer(nolock) dc
	LEFT JOIN rpt.vw__Epsilon_Emailable_Harmony (nolock) Emailable ON Emailable.PROFILE_KEY = dc.SSID
	LEFT JOIN rpt.vw__Epsilon_Engaged_Harmony (nolock) Engaged ON Engaged.PROFILE_KEY = Emailable.PROFILE_KEY
WHERE dc.SourceSystem = 'Epsilon'

DELETE FROM rpt.PreCache_Cust_Email_1_tbl WHERE IsReady = 1
UPDATE rpt.PreCache_Cust_Email_1_tbl SET IsReady = 1




GO
