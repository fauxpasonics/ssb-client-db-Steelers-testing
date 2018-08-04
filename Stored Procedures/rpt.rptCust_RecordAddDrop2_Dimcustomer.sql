SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






--[rpt].[rptCust_RecordAddDrop2_Dimcustomer] 

CREATE PROCEDURE [rpt].[rptCust_RecordAddDrop2_Dimcustomer] 

AS

SELECT DISTINCT ssbid.SSB_CRMSYSTEM_CONTACT_ID
INTO #contactGUID
FROM dbo.DimCustomer_History_Changes dc
	JOIN dimcustomerssbid ssbid ON ssbid.DimCustomerId = dc.DimCustomerId
WHERE dc.RecordChange = 'MERGE'

DELETE FROM dbo.DimCustomer_Merged_Expanded

INSERT INTO dbo.DimCustomer_Merged_Expanded

SELECT ssbid.SSB_CRMSYSTEM_PRIMARY_FLAG isPrimary
	   ,ssbid.SSB_CRMSYSTEM_CONTACT_ID
	   ,dc.DimCustomerId
	   ,dc.BatchId
	   ,dc.ODSRowLastUpdated
	   ,dc.SourceSystem
	   ,dc.SourceSystemPriority
	   ,dc.SSID
	   ,dc.CustomerType
	   ,dc.CustomerStatus
	   ,dc.AccountType
	   ,dc.AccountRep
	   ,dc.CompanyName
	   ,dc.SalutationName
	   ,dc.DonorMailName
	   ,dc.DonorFormalName
	   ,dc.Birthday
	   ,dc.Gender
	   ,dc.MergedRecordFlag
	   ,dc.MergedIntoSSID
	   ,dc.Prefix
	   ,dc.FirstName
	   ,dc.MiddleName
	   ,dc.LastName
	   ,dc.Suffix
	   ,dc.NameMasterId
	   ,dc.AddressPrimaryStreet
	   ,dc.AddressPrimaryCity
	   ,dc.AddressPrimaryState
	   ,dc.AddressPrimaryZip
	   ,dc.AddressPrimaryCounty
	   ,dc.AddressPrimaryCountry
	   ,dc.AddressPrimaryMasterId
	   ,dc.AddressOneStreet
	   ,dc.AddressOneCity
	   ,dc.AddressOneState
	   ,dc.AddressOneZip
	   ,dc.AddressOneCounty
	   ,dc.AddressOneCountry
	   ,dc.AddressOneMasterId
	   ,dc.AddressTwoStreet
	   ,dc.AddressTwoCity
	   ,dc.AddressTwoState
	   ,dc.AddressTwoZip
	   ,dc.AddressTwoCounty
	   ,dc.AddressTwoCountry
	   ,dc.AddressTwoMasterId
	   ,dc.AddressThreeStreet
	   ,dc.AddressThreeCity
	   ,dc.AddressThreeState
	   ,dc.AddressThreeZip
	   ,dc.AddressThreeCounty
	   ,dc.AddressThreeCountry
	   ,dc.AddressThreeMasterId
	   ,dc.AddressFourStreet
	   ,dc.AddressFourCity
	   ,dc.AddressFourState
	   ,dc.AddressFourZip
	   ,dc.AddressFourCounty
	   ,dc.AddressFourCountry
	   ,dc.AddressFourMasterId
	   ,dc.PhonePrimary
	   ,dc.PhonePrimaryMasterId
	   ,dc.PhoneHome
	   ,dc.PhoneHomeMasterId
	   ,dc.PhoneCell
	   ,dc.PhoneCellMasterId
	   ,dc.PhoneBusiness
	   ,dc.PhoneBusinessMasterId
	   ,dc.PhoneFax
	   ,dc.PhoneFaxMasterId
	   ,dc.PhoneOther
	   ,dc.PhoneOtherMasterId
	   ,dc.EmailPrimary
	   ,dc.EmailPrimaryMasterId
	   ,dc.EmailOne
	   ,dc.EmailOneMasterId
	   ,dc.EmailTwo
	   ,dc.EmailTwoMasterId
	   ,dc.SSCreatedBy
	   ,dc.SSCreatedDate
	   ,dc.CreatedBy
	   ,dc.CreatedDate
	   ,dc.AccountId
	   ,dc.AddressPrimaryNCOAStatus
	   ,dc.AddressOneStreetNCOAStatus
	   ,dc.AddressTwoStreetNCOAStatus
	   ,dc.AddressThreeStreetNCOAStatus
	   ,dc.AddressFourStreetNCOAStatus
	   ,dc.IsDeleted
	   ,dc.DeleteDate
	   ,dc.IsBusiness
	   ,dc.FullName
	   ,dc.AddressPrimarySuite
	   ,dc.AddressOneSuite
	   ,dc.AddressTwoSuite
	   ,dc.AddressThreeSuite
	   ,dc.AddressFourSuite
	   ,dc.customer_matchkey
	   ,dc.PhonePrimaryDNC
	   ,dc.PhoneHomeDNC
	   ,dc.PhoneCellDNC
	   ,dc.PhoneBusinessDNC
	   ,dc.PhoneFaxDNC
	   ,dc.PhoneOtherDNC
	   ,dc.AddressPrimaryPlus4
	   ,dc.AddressOnePlus4
	   ,dc.AddressTwoPlus4
	   ,dc.AddressThreePlus4
	   ,dc.AddressFourPlus4
	   ,dc.CD_Gender

FROM dbo.DimCustomerSSBID ssbid 
	JOIN dimcustomer dc ON dc.DimCustomerId = ssbid.DimCustomerId
	JOIN #contactGUID GUID ON GUID.SSB_CRMSYSTEM_CONTACT_ID = ssbid.SSB_CRMSYSTEM_CONTACT_ID 
ORDER BY ssbid.SSB_CRMSYSTEM_CONTACT_ID, isPrimary


GO
