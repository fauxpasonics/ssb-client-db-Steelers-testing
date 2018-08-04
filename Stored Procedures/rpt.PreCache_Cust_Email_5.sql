SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE PROC [rpt].[PreCache_Cust_Email_5]
AS

INSERT  INTO rpt.PreCache_Cust_Email_5_tbl

SELECT  SUM(CASE WHEN Gender = 'F' THEN EmailableMembers END) AS Female ,
        SUM(CASE WHEN Gender = 'M' THEN EmailableMembers END) AS Male ,
        SUM(CASE WHEN Gender = 'F' OR Gender = 'M' THEN EmailableMembers END) TotalGender ,
        0 AS IsReady
FROM    ( SELECT    a.SSB_CRMSYSTEM_CONTACT_ID 
                    , c.Gender
                    , COUNT(DISTINCT a.SSB_CRMSYSTEM_CONTACT_ID) EmailableMembers 
            FROM      dbo.DimCustomerSSBID a
                    JOIN dbo.DimCustomer dc ON dc.DimCustomerId = a.DimCustomerId
					JOIN rpt.vw__Epsilon_emailable_Harmony emailable ON emailable.PROFILE_KEY = dc.SSID																
                    JOIN mdm.compositerecord c ON a.SSB_CRMSYSTEM_CONTACT_ID = c.SSB_CRMSYSTEM_CONTACT_ID
			WHERE     dc.SourceSystem = 'epsilon'
            GROUP BY  c.Gender ,
                    a.SSB_CRMSYSTEM_CONTACT_ID
        ) a

DELETE  rpt.PreCache_Cust_Email_5_tbl WHERE   IsReady = 1

UPDATE  rpt.PreCache_Cust_Email_5_tbl
SET     IsReady = 1





GO
