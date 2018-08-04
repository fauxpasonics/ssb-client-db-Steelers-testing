SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [EmailOutbound].[Data_Uploader_Landing_Process]
    @DataTable [dbo].[EmailOutbound_Type] READONLY
AS
BEGIN

	DECLARE @finalXml  XML

	BEGIN TRY

		DECLARE @recordCount INT
		SELECT @recordCount = COUNT(*)
			FROM @DataTable
			
		INSERT INTO [EmailOutbound].[Data_Uploader_Landing]
		([SessionId], [DynamicData], [Email], [First_Name], [Last_Name], [Suffix], [Gender], [Birth_Date], [Address_Street], 
		 [Address_Suite], [Address_City], [Address_State], [Address_Zip], [Address_Country], [Phone_Primary], [Phone_Cell], 
		 [Pref_Team_News], [Pref_Team_Events], [Pref_Concerts], [Pref_Heinz_Field], [Pref_Pro_Shop], [Pref_Contests_Promotions], 
		 [Source], [Event_Date], [Email_Opt_In], [Ext_Attribute1], [Ext_Attribute2], [Ext_Attribute3], [Event_Name], [Cost], [Quantity])
		SELECT [SessionId], [DynamicData], [Email], [First_Name], [Last_Name], [Suffix], [Gender], [Birth_Date], [Address_Street], 
		 [Address_Suite], [Address_City], [Address_State], [Address_Zip], [Address_Country], [Phone_Primary], [Phone_Cell], 
		 [Pref_Team_News], [Pref_Team_Events], [Pref_Concerts], [Pref_Heinz_Field], [Pref_Pro_Shop], [Pref_Contests_Promotions], 
		 [Source], [Event_Date], [Email_Opt_In], [Ext_Attribute1], [Ext_Attribute2], [Ext_Attribute3], [Event_Name], [Cost], [Quantity]
		FROM @DataTable
		
		SET @finalXml = '<Root><ResponseInfo><Success>true</Success><RecordsInserted>' + CAST(@recordCount AS NVARCHAR(10)) + '</RecordsInserted></ResponseInfo></Root>'

	END TRY


	BEGIN CATCH
	
		-- TODO: Better error messaging here
		SET @finalXml = '<Root><ResponseInfo><Success>false</Success><ErrorMessage>There was an error attempting to upload this data.</ErrorMessage></ResponseInfo></Root>'

	END CATCH


	-- Return response
	SELECT CAST(@finalXml AS XML)

END


GO
