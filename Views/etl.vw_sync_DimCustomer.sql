SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [etl].[vw_sync_DimCustomer] AS (
	SELECT [DimCustomerId]
     ,[BatchId]
     ,[ODSRowLastUpdated]
     ,[SourceDB]
     ,[SourceSystem]
     ,[SourceSystemPriority]
     ,[SSID]
     ,[CustomerType]
     ,[CustomerStatus]
     ,[AccountType]
     ,[AccountRep]
     ,CAST([CompanyName] AS NVARCHAR(500)) [CompanyName]
     ,[SalutationName]
     ,[DonorMailName]
     ,[DonorFormalName]
     ,[Birthday]
     ,[Gender]
     ,[MergedRecordFlag]
     ,[MergedIntoSSID]
     ,[Prefix]
     ,[FirstName]
     ,[MiddleName]
     ,[LastName]
     ,[Suffix]
     ,[NameDirtyHash]
     ,[NameIsCleanStatus]
     ,[NameMasterId]
     ,[AddressPrimaryStreet]
     ,[AddressPrimaryCity]
     ,[AddressPrimaryState]
     ,[AddressPrimaryZip]
     ,[AddressPrimaryCounty]
     ,[AddressPrimaryCountry]
     ,[AddressPrimaryDirtyHash]
     ,[AddressPrimaryIsCleanStatus]
     ,[AddressPrimaryMasterId]
     ,[ContactDirtyHash]
     ,[ContactGUID]
     ,[AddressOneStreet]
     ,[AddressOneCity]
     ,[AddressOneState]
     ,[AddressOneZip]
     ,[AddressOneCounty]
     ,[AddressOneCountry]
     ,[AddressOneDirtyHash]
     ,[AddressOneIsCleanStatus]
     ,[AddressOneMasterId]
     ,[AddressTwoStreet]
     ,[AddressTwoCity]
     ,[AddressTwoState]
     ,[AddressTwoZip]
     ,[AddressTwoCounty]
     ,[AddressTwoCountry]
     ,[AddressTwoDirtyHash]
     ,[AddressTwoIsCleanStatus]
     ,[AddressTwoMasterId]
     ,[AddressThreeStreet]
     ,[AddressThreeCity]
     ,[AddressThreeState]
     ,[AddressThreeZip]
     ,[AddressThreeCounty]
     ,[AddressThreeCountry]
     ,[AddressThreeDirtyHash]
     ,[AddressThreeIsCleanStatus]
     ,[AddressThreeMasterId]
     ,[AddressFourStreet]
     ,[AddressFourCity]
     ,[AddressFourState]
     ,[AddressFourZip]
     ,[AddressFourCounty]
     ,[AddressFourCountry]
     ,[AddressFourDirtyHash]
     ,[AddressFourIsCleanStatus]
     ,[AddressFourMasterId]
     ,[PhonePrimary]
     ,[PhonePrimaryDirtyHash]
     ,[PhonePrimaryIsCleanStatus]
     ,[PhonePrimaryMasterId]
     ,[PhoneHome]
     ,[PhoneHomeDirtyHash]
     ,[PhoneHomeIsCleanStatus]
     ,[PhoneHomeMasterId]
     ,[PhoneCell]
     ,[PhoneCellDirtyHash]
     ,[PhoneCellIsCleanStatus]
     ,[PhoneCellMasterId]
     ,[PhoneBusiness]
     ,[PhoneBusinessDirtyHash]
     ,[PhoneBusinessIsCleanStatus]
     ,[PhoneBusinessMasterId]
     ,[PhoneFax]
     ,[PhoneFaxDirtyHash]
     ,[PhoneFaxIsCleanStatus]
     ,[PhoneFaxMasterId]
     ,[PhoneOther]
     ,[PhoneOtherDirtyHash]
     ,[PhoneOtherIsCleanStatus]
     ,[PhoneOtherMasterId]
     ,[EmailPrimary]
     ,[EmailPrimaryDirtyHash]
     ,[EmailPrimaryIsCleanStatus]
     ,[EmailPrimaryMasterId]
     ,[EmailOne]
     ,[EmailOneDirtyHash]
     ,[EmailOneIsCleanStatus]
     ,[EmailOneMasterId]
     ,[EmailTwo]
     ,[EmailTwoDirtyHash]
     ,[EmailTwoIsCleanStatus]
     ,[EmailTwoMasterId]
     ,[ExtAttribute1]
     ,[ExtAttribute2]
     ,[ExtAttribute3]
     ,[ExtAttribute4]
     ,[ExtAttribute5]
     ,[ExtAttribute6]
     ,[ExtAttribute7]
     ,[ExtAttribute8]
     ,[ExtAttribute9]
     ,[ExtAttribute10]
     ,[ExtAttribute11]
     ,[ExtAttribute12]
     ,[ExtAttribute13]
     ,[ExtAttribute14]
     ,[ExtAttribute15]
     ,[ExtAttribute16]
     ,[ExtAttribute17]
     ,[ExtAttribute18]
     ,[ExtAttribute19]
     ,[ExtAttribute20]
     ,[ExtAttribute21]
     ,[ExtAttribute22]
     ,[ExtAttribute23]
     ,[ExtAttribute24]
     ,[ExtAttribute25]
     ,[ExtAttribute26]
     ,[ExtAttribute27]
     ,[ExtAttribute28]
     ,[ExtAttribute29]
     ,[ExtAttribute30]
     ,[SSCreatedBy]
     ,[SSUpdatedBy]
     ,[SSCreatedDate]
     ,[SSUpdatedDate]
     ,[CreatedBy]
     ,[UpdatedBy]
     ,[CreatedDate]
     ,[UpdatedDate]
     ,[AccountId]
     ,[AddressPrimaryNCOAStatus]
     ,[AddressOneStreetNCOAStatus]
     ,[AddressTwoStreetNCOAStatus]
     ,[AddressThreeStreetNCOAStatus]
     ,[AddressFourStreetNCOAStatus]
     ,[IsDeleted]
     ,[DeleteDate]
     ,[IsBusiness]
     ,[FullName]
     ,[ExtAttribute31]
     ,[ExtAttribute32]
     ,[ExtAttribute33]
     ,[ExtAttribute34]
     ,[ExtAttribute35]
     ,[AddressPrimarySuite]
     ,[AddressOneSuite]
     ,[AddressTwoSuite]
     ,[AddressThreeSuite]
     ,[AddressFourSuite]
     ,[customer_matchkey]
     ,[PhonePrimaryDNC]
     ,[PhoneHomeDNC]
     ,[PhoneCellDNC]
     ,[PhoneBusinessDNC]
     ,[PhoneFaxDNC]
     ,[PhoneOtherDNC]
     FROM dbo.DimCustomer (NOLOCK)
)


GO
