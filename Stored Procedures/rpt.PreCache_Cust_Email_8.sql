SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROC [rpt].[PreCache_Cust_Email_8]
AS


--Non-Emailable optout cust info
--DROP TABLE #NONEMAILABLE
--DROP TABLE #NonemailableOptOutCustomerInfo

SELECT  p.PK ,
        p.NUM_SENT ,
        p.NUM_FTD ,
        p.NUM_CLICK ,
        p.OPTOUT_FLG ,
        CONVERT(DATE,LEFT(p.OPTOUT_DTTM,8))  OPTOUT_DTTM,
        CONVERT(DATE,LEFT(p.CREATED_DTTM,8)) CREATED_DTTM,
        --CONVERT(DATE,LEFT(p.MODIFIED_DTTM,8))  MODIFIED_DTTM,
        --CASE WHEN p.LAST_SENT_DTTM = '' THEN '' ELSE CONVERT(VARCHAR,CONVERT(DATE,LEFT(p.LAST_SENT_DTTM,8)),101) END AS LAST_SENT_DTTM,
        --CASE WHEN p.FTD_DTTM = '' THEN null ELSE CONVERT(DATE,LEFT(p.FTD_DTTM,8)) END AS FTD_DTTM,
        CASE WHEN p.HTML_OPEN_DTTM = ''THEN NULL ELSE CONVERT(DATE,LEFT(p.HTML_OPEN_DTTM,8)) END AS HTML_OPEN_DTTM
INTO    #NONEMAILABLE
FROM    ods.Epsilon_PDU p ( NOLOCK )
        LEFT JOIN ods.Epsilon_ADU a ( NOLOCK ) ON p.PK = a.PROFILE_KEY
WHERE   a.PROFILE_KEY IS NULL
        AND p.OPTOUT_FLG = 1; 

SELECT  n.* ,
        dcb.SSB_CRMSYSTEM_CONTACT_ID ,
        c.FirstName ,
        c.LastName ,
        c.Gender ,
        ( YEAR(GETDATE()) - YEAR(dc.Birthday) ) Age ,
        c.AddressPrimaryStreet ,
        c.AddressPrimaryCity ,
        c.AddressPrimaryState ,
        c.AddressPrimaryZip ,
        c.AddressPrimaryCounty ,
        c.AddressPrimaryCountry
INTO    #NonemailableOptOutCustomerInfo
FROM    #NONEMAILABLE n
        JOIN dbo.DimCustomer dc ON dc.SSID = n.PK
        LEFT JOIN dbo.DimCustomerSSBID dcb ON dcb.DimCustomerId = dc.DimCustomerId
        LEFT JOIN mdm.compositerecord c ON c.SSB_CRMSYSTEM_CONTACT_ID = dcb.SSB_CRMSYSTEM_CONTACT_ID;

INSERT [rpt].[PreCache_Cust_Email_8_tbl]
SELECT *,0 AS IsReady 
--INTO [rpt].[PreCache_Cust_Email_8_tbl]
FROM #NonemailableOptOutCustomerInfo

DELETE rpt.PreCache_Cust_Email_8_tbl WHERE IsReady = 1
UPDATE rpt.PreCache_Cust_Email_8_tbl SET IsReady = 1
							   
--SELECT * FROM rpt.TempEmailCust






GO
