SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [rpt].[rptCust_RecordAddDrop_Dimcustomer] (@batchDate DATE)

AS

SELECT RecordChange
	   ,DimCustomerId
	   ,FirstName
	   ,LastName
	   ,EmailPrimary
	   ,SourceSystem
	   ,SSID AS AccountID
FROM dbo.DimCustomer_History_Changes
WHERE BatchDate = @batchDate
	  AND RecordChange IN ('ADD','MERGE','DROP')

	  SELECT DISTINCT batchDate FROM dbo.DimCustomer_History_Changes WHERE RecordChange = 'DROP'
GO
