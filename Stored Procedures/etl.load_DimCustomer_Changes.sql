SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [etl].[load_DimCustomer_Changes] AS

IF ((SELECT MAX(batchDate) FROM dimcustomer_History_Changes) = (SELECT MAX(batchDate) FROM dbo.DimCustomer_History))

	BEGIN
		PRINT 'Dimcustomer_History_Changes has already been populated with the most recent changes'
		RETURN	
	END


IF OBJECT_ID('tempdb..#batchDates') IS NOT NULL DROP TABLE #batchDates

CREATE TABLE #BatchDates(
DateID INT IDENTITY(1,1)
,batchDate DATE
)

INSERT INTO #batchDates

SELECT DISTINCT
		BatchDate
FROM dbo.DimCustomer_History
ORDER BY BatchDate
		
DECLARE @startID INT = (SELECT MAX(dateID) FROM #BatchDates) - 1
DECLARE @startDate DATE = (SELECT batchDate FROM #BatchDates WHERE DateID = @startID)
DECLARE @EndDate DATE = (SELECT MAX(batchDate) FROM #BatchDates)

IF object_id('tempdb..#addDrop') IS NOT NULL DROP TABLE #addDrop
SELECT CASE WHEN day1.DimCustomerId IS NULL THEN CASE WHEN ssbid.numIds = 1 THEN 'ADD'
														ELSE 'MERGE'
													END
			WHEN day2.DimCustomerId IS NULL THEN 'DROP'
			ELSE 'NO CHANGE'
		END AS recordChange
		,COALESCE(day2.DimCustomerId,day1.DimCustomerId) AS dimcustomerID
INTO #addDrop
FROM (SELECT DimCustomerId 
		FROM dbo.DimCustomer_History 
		WHERE BatchDate = @startDate
		) day1
		FULL JOIN (SELECT dimcustomerId, CAST(UpdatedDate AS DATE) UpdatedDate, BatchDate 
					FROM dbo.DimCustomer_History 
					WHERE BatchDate = @endDate
					) day2 ON day1.DimCustomerId = day2.DimCustomerId
		LEFT JOIN (SELECT ssbid.DimCustomerId
						,COUNT(ssbid.DimCustomerId) OVER(PARTITION BY ssbid.SSB_CRMSYSTEM_CONTACT_ID) AS numIds
					FROM dbo.DimCustomerSSBID_History ssbid
					WHERE ssbid.BatchDate = @endDate)ssbid ON ssbid.DimCustomerId = day2.DimCustomerId
WHERE day1.DimCustomerId IS NULL 
		OR day2.DimCustomerId IS NULL


IF OBJECT_ID('tempdb..#updates')IS NOT NULL DROP TABLE #updates
SELECT  dc.DimCustomerId
	   ,BatchId
	   ,ODSRowLastUpdated
	   ,SourceDB
	   ,SourceSystem
	   ,SourceSystemPriority
	   ,SSID
	   ,CustomerType
	   ,CustomerStatus
	   ,AccountType
	   ,AccountRep
	   ,CompanyName
	   ,SalutationName
	   ,DonorMailName
	   ,DonorFormalName
	   ,Birthday
	   ,Gender
	   ,MergedRecordFlag
	   ,MergedIntoSSID
	   ,Prefix
	   ,FirstName
	   ,MiddleName
	   ,LastName
	   ,Suffix
	   ,NameDirtyHash
	   ,NameIsCleanStatus
	   ,NameMasterId
	   ,AddressPrimaryStreet
	   ,AddressPrimaryCity
	   ,AddressPrimaryState
	   ,AddressPrimaryZip
	   ,AddressPrimaryCounty
	   ,AddressPrimaryCountry
	   ,AddressPrimaryDirtyHash
	   ,AddressPrimaryIsCleanStatus
	   ,AddressPrimaryMasterId
	   ,ContactDirtyHash
	   ,ContactGUID
	   ,AddressOneStreet
	   ,AddressOneCity
	   ,AddressOneState
	   ,AddressOneZip
	   ,AddressOneCounty
	   ,AddressOneCountry
	   ,AddressOneDirtyHash
	   ,AddressOneIsCleanStatus
	   ,AddressOneMasterId
	   ,AddressTwoStreet
	   ,AddressTwoCity
	   ,AddressTwoState
	   ,AddressTwoZip
	   ,AddressTwoCounty
	   ,AddressTwoCountry
	   ,AddressTwoDirtyHash
	   ,AddressTwoIsCleanStatus
	   ,AddressTwoMasterId
	   ,AddressThreeStreet
	   ,AddressThreeCity
	   ,AddressThreeState
	   ,AddressThreeZip
	   ,AddressThreeCounty
	   ,AddressThreeCountry
	   ,AddressThreeDirtyHash
	   ,AddressThreeIsCleanStatus
	   ,AddressThreeMasterId
	   ,AddressFourStreet
	   ,AddressFourCity
	   ,AddressFourState
	   ,AddressFourZip
	   ,AddressFourCounty
	   ,AddressFourCountry
	   ,AddressFourDirtyHash
	   ,AddressFourIsCleanStatus
	   ,AddressFourMasterId
	   ,PhonePrimary
	   ,PhonePrimaryDirtyHash
	   ,PhonePrimaryIsCleanStatus
	   ,PhonePrimaryMasterId
	   ,PhoneHome
	   ,PhoneHomeDirtyHash
	   ,PhoneHomeIsCleanStatus
	   ,PhoneHomeMasterId
	   ,PhoneCell
	   ,PhoneCellDirtyHash
	   ,PhoneCellIsCleanStatus
	   ,PhoneCellMasterId
	   ,PhoneBusiness
	   ,PhoneBusinessDirtyHash
	   ,PhoneBusinessIsCleanStatus
	   ,PhoneBusinessMasterId
	   ,PhoneFax
	   ,PhoneFaxDirtyHash
	   ,PhoneFaxIsCleanStatus
	   ,PhoneFaxMasterId
	   ,PhoneOther
	   ,PhoneOtherDirtyHash
	   ,PhoneOtherIsCleanStatus
	   ,PhoneOtherMasterId
	   ,EmailPrimary
	   ,EmailPrimaryDirtyHash
	   ,EmailPrimaryIsCleanStatus
	   ,EmailPrimaryMasterId
	   ,EmailOne
	   ,EmailOneDirtyHash
	   ,EmailOneIsCleanStatus
	   ,EmailOneMasterId
	   ,EmailTwo
	   ,EmailTwoDirtyHash
	   ,EmailTwoIsCleanStatus
	   ,EmailTwoMasterId
	   ,ExtAttribute1
	   ,ExtAttribute2
	   ,ExtAttribute3
	   ,ExtAttribute4
	   ,ExtAttribute5
	   ,ExtAttribute6
	   ,ExtAttribute7
	   ,ExtAttribute8
	   ,ExtAttribute9
	   ,ExtAttribute10
	   ,ExtAttribute11
	   ,ExtAttribute12
	   ,ExtAttribute13
	   ,ExtAttribute14
	   ,ExtAttribute15
	   ,ExtAttribute16
	   ,ExtAttribute17
	   ,ExtAttribute18
	   ,ExtAttribute19
	   ,ExtAttribute20
	   ,ExtAttribute21
	   ,ExtAttribute22
	   ,ExtAttribute23
	   ,ExtAttribute24
	   ,ExtAttribute25
	   ,ExtAttribute26
	   ,ExtAttribute27
	   ,ExtAttribute28
	   ,ExtAttribute29
	   ,ExtAttribute30
	   ,SSCreatedBy
	   ,SSCreatedDate
	   ,CreatedBy
	   ,CreatedDate
	   ,AccountId
	   ,AddressPrimaryNCOAStatus
	   ,AddressOneStreetNCOAStatus
	   ,AddressTwoStreetNCOAStatus
	   ,AddressThreeStreetNCOAStatus
	   ,AddressFourStreetNCOAStatus
	   ,IsDeleted
	   ,DeleteDate
	   ,IsBusiness
	   ,FullName
	   ,ExtAttribute31
	   ,ExtAttribute32
	   ,ExtAttribute33
	   ,ExtAttribute34
	   ,ExtAttribute35
	   ,AddressPrimarySuite
	   ,AddressOneSuite
	   ,AddressTwoSuite
	   ,AddressThreeSuite
	   ,AddressFourSuite
	   ,customer_matchkey
	   ,PhonePrimaryDNC
	   ,PhoneHomeDNC
	   ,PhoneCellDNC
	   ,PhoneBusinessDNC
	   ,PhoneFaxDNC
	   ,PhoneOtherDNC
	   ,AddressPrimaryPlus4
	   ,AddressOnePlus4
	   ,AddressTwoPlus4
	   ,AddressThreePlus4
	   ,AddressFourPlus4
	   ,AddressPrimaryLatitude
	   ,AddressPrimaryLongitude
	   ,AddressOneLatitude
	   ,AddressOneLongitude
	   ,AddressTwoLatitude
	   ,AddressTwoLongitude
	   ,AddressThreeLatitude
	   ,AddressThreeLongitude
	   ,AddressFourLatitude
	   ,AddressFourLongitude
	   ,CD_Gender
	   ,contactattrDirtyHash
	   ,extattr1_10DirtyHash
	   ,extattr11_20DirtyHash
	   ,extattr21_30DirtyHash
	   ,extattr31_35DirtyHash
INTO #updates
FROM dbo.DimCustomer_History dc
LEFT JOIN #addDrop addDrop ON addDrop.dimcustomerID = dc.dimcustomerID
WHERE BatchDate = @EndDate
AND addDrop.dimcustomerID IS NULL

EXCEPT

SELECT  dc.DimCustomerId
	   ,BatchId
	   ,ODSRowLastUpdated
	   ,SourceDB
	   ,SourceSystem
	   ,SourceSystemPriority
	   ,SSID
	   ,CustomerType
	   ,CustomerStatus
	   ,AccountType
	   ,AccountRep
	   ,CompanyName
	   ,SalutationName
	   ,DonorMailName
	   ,DonorFormalName
	   ,Birthday
	   ,Gender
	   ,MergedRecordFlag
	   ,MergedIntoSSID
	   ,Prefix
	   ,FirstName
	   ,MiddleName
	   ,LastName
	   ,Suffix
	   ,NameDirtyHash
	   ,NameIsCleanStatus
	   ,NameMasterId
	   ,AddressPrimaryStreet
	   ,AddressPrimaryCity
	   ,AddressPrimaryState
	   ,AddressPrimaryZip
	   ,AddressPrimaryCounty
	   ,AddressPrimaryCountry
	   ,AddressPrimaryDirtyHash
	   ,AddressPrimaryIsCleanStatus
	   ,AddressPrimaryMasterId
	   ,ContactDirtyHash
	   ,ContactGUID
	   ,AddressOneStreet
	   ,AddressOneCity
	   ,AddressOneState
	   ,AddressOneZip
	   ,AddressOneCounty
	   ,AddressOneCountry
	   ,AddressOneDirtyHash
	   ,AddressOneIsCleanStatus
	   ,AddressOneMasterId
	   ,AddressTwoStreet
	   ,AddressTwoCity
	   ,AddressTwoState
	   ,AddressTwoZip
	   ,AddressTwoCounty
	   ,AddressTwoCountry
	   ,AddressTwoDirtyHash
	   ,AddressTwoIsCleanStatus
	   ,AddressTwoMasterId
	   ,AddressThreeStreet
	   ,AddressThreeCity
	   ,AddressThreeState
	   ,AddressThreeZip
	   ,AddressThreeCounty
	   ,AddressThreeCountry
	   ,AddressThreeDirtyHash
	   ,AddressThreeIsCleanStatus
	   ,AddressThreeMasterId
	   ,AddressFourStreet
	   ,AddressFourCity
	   ,AddressFourState
	   ,AddressFourZip
	   ,AddressFourCounty
	   ,AddressFourCountry
	   ,AddressFourDirtyHash
	   ,AddressFourIsCleanStatus
	   ,AddressFourMasterId
	   ,PhonePrimary
	   ,PhonePrimaryDirtyHash
	   ,PhonePrimaryIsCleanStatus
	   ,PhonePrimaryMasterId
	   ,PhoneHome
	   ,PhoneHomeDirtyHash
	   ,PhoneHomeIsCleanStatus
	   ,PhoneHomeMasterId
	   ,PhoneCell
	   ,PhoneCellDirtyHash
	   ,PhoneCellIsCleanStatus
	   ,PhoneCellMasterId
	   ,PhoneBusiness
	   ,PhoneBusinessDirtyHash
	   ,PhoneBusinessIsCleanStatus
	   ,PhoneBusinessMasterId
	   ,PhoneFax
	   ,PhoneFaxDirtyHash
	   ,PhoneFaxIsCleanStatus
	   ,PhoneFaxMasterId
	   ,PhoneOther
	   ,PhoneOtherDirtyHash
	   ,PhoneOtherIsCleanStatus
	   ,PhoneOtherMasterId
	   ,EmailPrimary
	   ,EmailPrimaryDirtyHash
	   ,EmailPrimaryIsCleanStatus
	   ,EmailPrimaryMasterId
	   ,EmailOne
	   ,EmailOneDirtyHash
	   ,EmailOneIsCleanStatus
	   ,EmailOneMasterId
	   ,EmailTwo
	   ,EmailTwoDirtyHash
	   ,EmailTwoIsCleanStatus
	   ,EmailTwoMasterId
	   ,ExtAttribute1
	   ,ExtAttribute2
	   ,ExtAttribute3
	   ,ExtAttribute4
	   ,ExtAttribute5
	   ,ExtAttribute6
	   ,ExtAttribute7
	   ,ExtAttribute8
	   ,ExtAttribute9
	   ,ExtAttribute10
	   ,ExtAttribute11
	   ,ExtAttribute12
	   ,ExtAttribute13
	   ,ExtAttribute14
	   ,ExtAttribute15
	   ,ExtAttribute16
	   ,ExtAttribute17
	   ,ExtAttribute18
	   ,ExtAttribute19
	   ,ExtAttribute20
	   ,ExtAttribute21
	   ,ExtAttribute22
	   ,ExtAttribute23
	   ,ExtAttribute24
	   ,ExtAttribute25
	   ,ExtAttribute26
	   ,ExtAttribute27
	   ,ExtAttribute28
	   ,ExtAttribute29
	   ,ExtAttribute30
	   ,SSCreatedBy
	   ,SSCreatedDate
	   ,CreatedBy
	   ,CreatedDate
	   ,AccountId
	   ,AddressPrimaryNCOAStatus
	   ,AddressOneStreetNCOAStatus
	   ,AddressTwoStreetNCOAStatus
	   ,AddressThreeStreetNCOAStatus
	   ,AddressFourStreetNCOAStatus
	   ,IsDeleted
	   ,DeleteDate
	   ,IsBusiness
	   ,FullName
	   ,ExtAttribute31
	   ,ExtAttribute32
	   ,ExtAttribute33
	   ,ExtAttribute34
	   ,ExtAttribute35
	   ,AddressPrimarySuite
	   ,AddressOneSuite
	   ,AddressTwoSuite
	   ,AddressThreeSuite
	   ,AddressFourSuite
	   ,customer_matchkey
	   ,PhonePrimaryDNC
	   ,PhoneHomeDNC
	   ,PhoneCellDNC
	   ,PhoneBusinessDNC
	   ,PhoneFaxDNC
	   ,PhoneOtherDNC
	   ,AddressPrimaryPlus4
	   ,AddressOnePlus4
	   ,AddressTwoPlus4
	   ,AddressThreePlus4
	   ,AddressFourPlus4
	   ,AddressPrimaryLatitude
	   ,AddressPrimaryLongitude
	   ,AddressOneLatitude
	   ,AddressOneLongitude
	   ,AddressTwoLatitude
	   ,AddressTwoLongitude
	   ,AddressThreeLatitude
	   ,AddressThreeLongitude
	   ,AddressFourLatitude
	   ,AddressFourLongitude
	   ,CD_Gender
	   ,contactattrDirtyHash
	   ,extattr1_10DirtyHash
	   ,extattr11_20DirtyHash
	   ,extattr21_30DirtyHash
	   ,extattr31_35DirtyHash
FROM dbo.DimCustomer_History dc
LEFT JOIN #addDrop addDrop ON addDrop.dimcustomerID = dc.dimcustomerID
WHERE BatchDate = @startDate
AND addDrop.dimcustomerID IS NULL

DROP INDEX IX_DimCustomer_History_Changes_AccountID ON dbo.DimCustomer_History_Changes 	
DROP INDEX IX_DimCustomer_History_Changes_SSID ON dbo.DimCustomer_History_Changes 			
DROP INDEX IX_DimCustomer_History_Changes_BatchDate ON dbo.DimCustomer_History_Changes	
DROP INDEX IX_DimCustomer_History_Changes_dimCustomerID ON dbo.DimCustomer_History_Changes 

INSERT INTO dbo.dimcustomer_history_changes

SELECT  @EndDate AS BatchDate
	   ,'UPDATE' AS RecordChange
	   ,dc.batchDate AS SnapshotDate
	   ,dc.DimCustomerId
	   ,dc.BatchId
	   ,dc.ODSRowLastUpdated
	   ,dc.SourceDB
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
	   ,dc.NameDirtyHash
	   ,dc.NameIsCleanStatus
	   ,dc.NameMasterId
	   ,dc.AddressPrimaryStreet
	   ,dc.AddressPrimaryCity
	   ,dc.AddressPrimaryState
	   ,dc.AddressPrimaryZip
	   ,dc.AddressPrimaryCounty
	   ,dc.AddressPrimaryCountry
	   ,dc.AddressPrimaryDirtyHash
	   ,dc.AddressPrimaryIsCleanStatus
	   ,dc.AddressPrimaryMasterId
	   ,dc.ContactDirtyHash
	   ,dc.ContactGUID
	   ,dc.AddressOneStreet
	   ,dc.AddressOneCity
	   ,dc.AddressOneState
	   ,dc.AddressOneZip
	   ,dc.AddressOneCounty
	   ,dc.AddressOneCountry
	   ,dc.AddressOneDirtyHash
	   ,dc.AddressOneIsCleanStatus
	   ,dc.AddressOneMasterId
	   ,dc.AddressTwoStreet
	   ,dc.AddressTwoCity
	   ,dc.AddressTwoState
	   ,dc.AddressTwoZip
	   ,dc.AddressTwoCounty
	   ,dc.AddressTwoCountry
	   ,dc.AddressTwoDirtyHash
	   ,dc.AddressTwoIsCleanStatus
	   ,dc.AddressTwoMasterId
	   ,dc.AddressThreeStreet
	   ,dc.AddressThreeCity
	   ,dc.AddressThreeState
	   ,dc.AddressThreeZip
	   ,dc.AddressThreeCounty
	   ,dc.AddressThreeCountry
	   ,dc.AddressThreeDirtyHash
	   ,dc.AddressThreeIsCleanStatus
	   ,dc.AddressThreeMasterId
	   ,dc.AddressFourStreet
	   ,dc.AddressFourCity
	   ,dc.AddressFourState
	   ,dc.AddressFourZip
	   ,dc.AddressFourCounty
	   ,dc.AddressFourCountry
	   ,dc.AddressFourDirtyHash
	   ,dc.AddressFourIsCleanStatus
	   ,dc.AddressFourMasterId
	   ,dc.PhonePrimary
	   ,dc.PhonePrimaryDirtyHash
	   ,dc.PhonePrimaryIsCleanStatus
	   ,dc.PhonePrimaryMasterId
	   ,dc.PhoneHome
	   ,dc.PhoneHomeDirtyHash
	   ,dc.PhoneHomeIsCleanStatus
	   ,dc.PhoneHomeMasterId
	   ,dc.PhoneCell
	   ,dc.PhoneCellDirtyHash
	   ,dc.PhoneCellIsCleanStatus
	   ,dc.PhoneCellMasterId
	   ,dc.PhoneBusiness
	   ,dc.PhoneBusinessDirtyHash
	   ,dc.PhoneBusinessIsCleanStatus
	   ,dc.PhoneBusinessMasterId
	   ,dc.PhoneFax
	   ,dc.PhoneFaxDirtyHash
	   ,dc.PhoneFaxIsCleanStatus
	   ,dc.PhoneFaxMasterId
	   ,dc.PhoneOther
	   ,dc.PhoneOtherDirtyHash
	   ,dc.PhoneOtherIsCleanStatus
	   ,dc.PhoneOtherMasterId
	   ,dc.EmailPrimary
	   ,dc.EmailPrimaryDirtyHash
	   ,dc.EmailPrimaryIsCleanStatus
	   ,dc.EmailPrimaryMasterId
	   ,dc.EmailOne
	   ,dc.EmailOneDirtyHash
	   ,dc.EmailOneIsCleanStatus
	   ,dc.EmailOneMasterId
	   ,dc.EmailTwo
	   ,dc.EmailTwoDirtyHash
	   ,dc.EmailTwoIsCleanStatus
	   ,dc.EmailTwoMasterId
	   ,dc.ExtAttribute1
	   ,dc.ExtAttribute2
	   ,dc.ExtAttribute3
	   ,dc.ExtAttribute4
	   ,dc.ExtAttribute5
	   ,dc.ExtAttribute6
	   ,dc.ExtAttribute7
	   ,dc.ExtAttribute8
	   ,dc.ExtAttribute9
	   ,dc.ExtAttribute10
	   ,dc.ExtAttribute11
	   ,dc.ExtAttribute12
	   ,dc.ExtAttribute13
	   ,dc.ExtAttribute14
	   ,dc.ExtAttribute15
	   ,dc.ExtAttribute16
	   ,dc.ExtAttribute17
	   ,dc.ExtAttribute18
	   ,dc.ExtAttribute19
	   ,dc.ExtAttribute20
	   ,dc.ExtAttribute21
	   ,dc.ExtAttribute22
	   ,dc.ExtAttribute23
	   ,dc.ExtAttribute24
	   ,dc.ExtAttribute25
	   ,dc.ExtAttribute26
	   ,dc.ExtAttribute27
	   ,dc.ExtAttribute28
	   ,dc.ExtAttribute29
	   ,dc.ExtAttribute30
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
	   ,dc.ExtAttribute31
	   ,dc.ExtAttribute32
	   ,dc.ExtAttribute33
	   ,dc.ExtAttribute34
	   ,dc.ExtAttribute35
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
	   ,dc.AddressPrimaryLatitude
	   ,dc.AddressPrimaryLongitude
	   ,dc.AddressOneLatitude
	   ,dc.AddressOneLongitude
	   ,dc.AddressTwoLatitude
	   ,dc.AddressTwoLongitude
	   ,dc.AddressThreeLatitude
	   ,dc.AddressThreeLongitude
	   ,dc.AddressFourLatitude
	   ,dc.AddressFourLongitude
	   ,dc.CD_Gender
	   ,dc.contactattrDirtyHash
	   ,dc.extattr1_10DirtyHash
	   ,dc.extattr11_20DirtyHash
	   ,dc.extattr21_30DirtyHash
	   ,dc.extattr31_35DirtyHash
FROM dbo.DimCustomer_History dc
	JOIN #updates updates ON updates.DimCustomerId = dc.DimCustomerId
WHERE dc.BatchDate IN (@startDate,@EndDate)

UNION ALL 

SELECT  @EndDate
		,addDrop.recordChange
		,dc.batchDate AS SnapshotDate
		,dc.DimCustomerId
		,dc.BatchId
		,dc.ODSRowLastUpdated
		,dc.SourceDB
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
		,dc.NameDirtyHash
		,dc.NameIsCleanStatus
		,dc.NameMasterId
		,dc.AddressPrimaryStreet
		,dc.AddressPrimaryCity
		,dc.AddressPrimaryState
		,dc.AddressPrimaryZip
		,dc.AddressPrimaryCounty
		,dc.AddressPrimaryCountry
		,dc.AddressPrimaryDirtyHash
		,dc.AddressPrimaryIsCleanStatus
		,dc.AddressPrimaryMasterId
		,dc.ContactDirtyHash
		,dc.ContactGUID
		,dc.AddressOneStreet
		,dc.AddressOneCity
		,dc.AddressOneState
		,dc.AddressOneZip
		,dc.AddressOneCounty
		,dc.AddressOneCountry
		,dc.AddressOneDirtyHash
		,dc.AddressOneIsCleanStatus
		,dc.AddressOneMasterId
		,dc.AddressTwoStreet
		,dc.AddressTwoCity
		,dc.AddressTwoState
		,dc.AddressTwoZip
		,dc.AddressTwoCounty
		,dc.AddressTwoCountry
		,dc.AddressTwoDirtyHash
		,dc.AddressTwoIsCleanStatus
		,dc.AddressTwoMasterId
		,dc.AddressThreeStreet
		,dc.AddressThreeCity
		,dc.AddressThreeState
		,dc.AddressThreeZip
		,dc.AddressThreeCounty
		,dc.AddressThreeCountry
		,dc.AddressThreeDirtyHash
		,dc.AddressThreeIsCleanStatus
		,dc.AddressThreeMasterId
		,dc.AddressFourStreet
		,dc.AddressFourCity
		,dc.AddressFourState
		,dc.AddressFourZip
		,dc.AddressFourCounty
		,dc.AddressFourCountry
		,dc.AddressFourDirtyHash
		,dc.AddressFourIsCleanStatus
		,dc.AddressFourMasterId
		,dc.PhonePrimary
		,dc.PhonePrimaryDirtyHash
		,dc.PhonePrimaryIsCleanStatus
		,dc.PhonePrimaryMasterId
		,dc.PhoneHome
		,dc.PhoneHomeDirtyHash
		,dc.PhoneHomeIsCleanStatus
		,dc.PhoneHomeMasterId
		,dc.PhoneCell
		,dc.PhoneCellDirtyHash
		,dc.PhoneCellIsCleanStatus
		,dc.PhoneCellMasterId
		,dc.PhoneBusiness
		,dc.PhoneBusinessDirtyHash
		,dc.PhoneBusinessIsCleanStatus
		,dc.PhoneBusinessMasterId
		,dc.PhoneFax
		,dc.PhoneFaxDirtyHash
		,dc.PhoneFaxIsCleanStatus
		,dc.PhoneFaxMasterId
		,dc.PhoneOther
		,dc.PhoneOtherDirtyHash
		,dc.PhoneOtherIsCleanStatus
		,dc.PhoneOtherMasterId
		,dc.EmailPrimary
		,dc.EmailPrimaryDirtyHash
		,dc.EmailPrimaryIsCleanStatus
		,dc.EmailPrimaryMasterId
		,dc.EmailOne
		,dc.EmailOneDirtyHash
		,dc.EmailOneIsCleanStatus
		,dc.EmailOneMasterId
		,dc.EmailTwo
		,dc.EmailTwoDirtyHash
		,dc.EmailTwoIsCleanStatus
		,dc.EmailTwoMasterId
		,dc.ExtAttribute1
		,dc.ExtAttribute2
		,dc.ExtAttribute3
		,dc.ExtAttribute4
		,dc.ExtAttribute5
		,dc.ExtAttribute6
		,dc.ExtAttribute7
		,dc.ExtAttribute8
		,dc.ExtAttribute9
		,dc.ExtAttribute10
		,dc.ExtAttribute11
		,dc.ExtAttribute12
		,dc.ExtAttribute13
		,dc.ExtAttribute14
		,dc.ExtAttribute15
		,dc.ExtAttribute16
		,dc.ExtAttribute17
		,dc.ExtAttribute18
		,dc.ExtAttribute19
		,dc.ExtAttribute20
		,dc.ExtAttribute21
		,dc.ExtAttribute22
		,dc.ExtAttribute23
		,dc.ExtAttribute24
		,dc.ExtAttribute25
		,dc.ExtAttribute26
		,dc.ExtAttribute27
		,dc.ExtAttribute28
		,dc.ExtAttribute29
		,dc.ExtAttribute30
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
		,dc.ExtAttribute31
		,dc.ExtAttribute32
		,dc.ExtAttribute33
		,dc.ExtAttribute34
		,dc.ExtAttribute35
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
		,dc.AddressPrimaryLatitude
		,dc.AddressPrimaryLongitude
		,dc.AddressOneLatitude
		,dc.AddressOneLongitude
		,dc.AddressTwoLatitude
		,dc.AddressTwoLongitude
		,dc.AddressThreeLatitude
		,dc.AddressThreeLongitude
		,dc.AddressFourLatitude
		,dc.AddressFourLongitude
		,dc.CD_Gender
		,dc.contactattrDirtyHash
		,dc.extattr1_10DirtyHash
		,dc.extattr11_20DirtyHash
		,dc.extattr21_30DirtyHash
		,dc.extattr31_35DirtyHash
FROM dbo.DimCustomer_History dc
		JOIN #addDrop addDrop ON addDrop.dimcustomerID = dc.dimcustomerID
WHERE BatchDate IN (@startDate,@endDate)

ORDER BY recordChange,dimcustomerId

CREATE INDEX IX_DimCustomer_History_Changes_AccountID ON dbo.DimCustomer_History_Changes (AccountId ASC)
CREATE INDEX IX_DimCustomer_History_Changes_SSID ON dbo.DimCustomer_History_Changes (SSID ASC)
CREATE INDEX IX_DimCustomer_History_Changes_BatchDate ON dbo.DimCustomer_History_Changes(BatchDate ASC)
CREATE INDEX IX_DimCustomer_History_Changes_dimCustomerID ON dbo.DimCustomer_History_Changes (dimCustomerID ASC)

GO
