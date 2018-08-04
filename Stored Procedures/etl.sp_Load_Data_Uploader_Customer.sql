SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [etl].[sp_Load_Data_Uploader_Customer] AS

UPDATE EmailOutbound.Data_Uploader_Landing
SET ContactHash = CONVERT(BINARY(32),HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Email)),'DBNULL_TEXT')
														 + ISNULL(LTRIM(RTRIM(First_Name)),'DBNULL_TEXT')
														 + ISNULL(LTRIM(RTRIM(Last_Name)),'DBNULL_TEXT')
														 + ISNULL(LTRIM(RTRIM(Suffix)),'DBNULL_TEXT')
														 ))
WHERE ContactHash IS NULL 

EXEC [etl].[sp_Load_Data_Uploader_Contests]

EXEC [etl].[sp_Load_Data_Uploader_Events]


UPDATE up
SET up.ssid = contest.ssid
	,up.Processed = 1
FROM EmailOutbound.Data_Uploader_Landing up
	JOIN etl.Data_Uploader_Customer_Contests contest ON contest.ContactHash = up.ContactHash
WHERE up.Source = 'contests'
	  AND up.ssid IS NULL

UPDATE up
SET up.ssid = Evnt.ssid
	,up.Processed = 1
FROM EmailOutbound.Data_Uploader_Landing up
	JOIN etl.Data_Uploader_Customer_Events Evnt ON Evnt.ContactHash = up.ContactHash
WHERE up.Source = 'Events'
	  AND up.ssid IS NULL

GO
