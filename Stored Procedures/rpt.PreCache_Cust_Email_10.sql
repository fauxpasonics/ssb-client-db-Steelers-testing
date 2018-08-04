SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [rpt].[PreCache_Cust_Email_10]
AS 

IF OBJECT_ID('tempdb..#base')IS NOT NULL DROP TABLE #base

/*
SELECT emailable.PROFILE_KEY
	   ,lastActivity
INTO #base
FROM rpt.vw__Epsilon_Emailable emailable
	LEFT JOIN ( SELECT PROFILE_KEY, MAX(ActionDate)AS LastActivity
				FROM [rpt].[vw__Epsilon_ADU_Combined]
				WHERE Action IN ('CLICK','OPEN')
				GROUP BY PROFILE_KEY
			   )activity ON emailable.PROFILE_KEY = activity.PROFILE_KEY 
*/

select emailable.PROFILE_KEY
	  ,COALESCE(Activity.LastActivity,pdu.LastActivity) LastActivity
INTO #base
FROM rpt.vw__Epsilon_Emailable_Harmony emailable (nolock)
	LEFT JOIN (Select CustomerKey PROFILE_KEY
					 ,MAX(ActionTimestamp) LastActivity
			   FROM ods.Epsilon_activities (nolock)
			   WHERE Action IN ('CLICK','OPEN')
			   GROUP BY CustomerKey
			   )Activity ON emailable.PROFILE_KEY = activity.PROFILE_KEY 
	LEFT JOIN (SELECT PK PROFILE_KEY
					 ,CASE WHEN pu.HTML_OPEN_DTTM > pu.click_dttm THEN HTML_OPEN_DTTM ELSE click_dttm END LastActivity
			   FROM ods.Epsilon_PDU pu (nolock)
			   )pdu on pdu.PROFILE_KEY = emailable.PROFILE_KEY

CREATE NONCLUSTERED INDEX IX_LastActivity ON #base (LastActivity)

INSERT INTO [rpt].[PreCache_Cust_Email_10_tbl]

SELECT CASE WHEN lastActivity IS NULL THEN 8
			WHEN lastActivity >= DATEADD(DAY,-30  ,CAST(GETDATE() AS DATE)) THEN 1
			WHEN lastActivity >= DATEADD(DAY,-60  ,CAST(GETDATE() AS DATE)) THEN 2
			WHEN lastActivity >= DATEADD(DAY,-90  ,CAST(GETDATE() AS DATE)) THEN 3
			WHEN lastActivity >= DATEADD(DAY,-180 ,CAST(GETDATE() AS DATE)) THEN 4
			WHEN lastActivity >= DATEADD(DAY,-365 ,CAST(GETDATE() AS DATE)) THEN 5
			WHEN lastActivity >= DATEADD(DAY,-729 ,CAST(GETDATE() AS DATE)) THEN 6
			ELSE 7
	   END AS SortOrder
	   ,CASE WHEN lastActivity IS NULL THEN 'No Activity' 
			WHEN lastActivity >= DATEADD(DAY,-30  ,CAST(GETDATE() AS DATE)) THEN 'Last 30 Days'
			WHEN lastActivity >= DATEADD(DAY,-60  ,CAST(GETDATE() AS DATE)) THEN '31 - 60 Days'
			WHEN lastActivity >= DATEADD(DAY,-90  ,CAST(GETDATE() AS DATE)) THEN '61 - 90 Days'
			WHEN lastActivity >= DATEADD(DAY,-180 ,CAST(GETDATE() AS DATE)) THEN '91 - 180 Days'
			WHEN lastActivity >= DATEADD(DAY,-365 ,CAST(GETDATE() AS DATE)) THEN '181 - 365 Days'
			WHEN lastActivity >= DATEADD(DAY,-729 ,CAST(GETDATE() AS DATE)) THEN '366 - 729 Days'
			ELSE 'Over 730 Days'
	   END AS ActivityGroup																														
	   ,COUNT(PROFILE_KEY) AS numCustomers
	   ,0 AS IsReady
FROM #base
GROUP BY CASE WHEN lastActivity IS NULL THEN 8
			WHEN lastActivity >= DATEADD(DAY,-30  ,CAST(GETDATE() AS DATE)) THEN 1
			WHEN lastActivity >= DATEADD(DAY,-60  ,CAST(GETDATE() AS DATE)) THEN 2
			WHEN lastActivity >= DATEADD(DAY,-90  ,CAST(GETDATE() AS DATE)) THEN 3
			WHEN lastActivity >= DATEADD(DAY,-180 ,CAST(GETDATE() AS DATE)) THEN 4
			WHEN lastActivity >= DATEADD(DAY,-365 ,CAST(GETDATE() AS DATE)) THEN 5
			WHEN lastActivity >= DATEADD(DAY,-729 ,CAST(GETDATE() AS DATE)) THEN 6
			ELSE 7
	   END
	   ,CASE WHEN lastActivity IS NULL THEN 'No Activity' 
			WHEN lastActivity >= DATEADD(DAY,-30  ,CAST(GETDATE() AS DATE)) THEN 'Last 30 Days'
			WHEN lastActivity >= DATEADD(DAY,-60  ,CAST(GETDATE() AS DATE)) THEN '31 - 60 Days'
			WHEN lastActivity >= DATEADD(DAY,-90  ,CAST(GETDATE() AS DATE)) THEN '61 - 90 Days'
			WHEN lastActivity >= DATEADD(DAY,-180 ,CAST(GETDATE() AS DATE)) THEN '91 - 180 Days'
			WHEN lastActivity >= DATEADD(DAY,-365 ,CAST(GETDATE() AS DATE)) THEN '181 - 365 Days'
			WHEN lastActivity >= DATEADD(DAY,-729 ,CAST(GETDATE() AS DATE)) THEN '366 - 729 Days'
			ELSE 'Over 730 Days'
	   END
ORDER BY SortOrder


DELETE FROM [rpt].[PreCache_Cust_Email_10_tbl]
WHERE isReady = 1

UPDATE [rpt].[PreCache_Cust_Email_10_tbl]
SET isReady = 1

DROP TABLE #base	

















GO
