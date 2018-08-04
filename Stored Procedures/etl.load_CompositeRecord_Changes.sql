SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [etl].[load_CompositeRecord_Changes]
AS

IF ((SELECT MAX(batchDate) FROM mdm.compositerecord_History_Changes) = (SELECT MAX(batchDate) FROM mdm.compositerecord_History))

	BEGIN
		PRINT 'CompositeRecord_History_Changes has already been populated with the most recent changes'
		RETURN	
	END

IF object_id('tempdb..#batchDates')IS NOT NULL DROP TABLE #batchDates

CREATE TABLE #batchDates(
dateId INT IDENTITY(1,1)
,batchDate DATE 
)

INSERT INTO #batchDates

SELECT DISTINCT batchDate 
FROM mdm.compositerecord_History
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
		FROM mdm.compositeRecord_History 
		WHERE BatchDate = @startDate
		) day1
		FULL JOIN (SELECT dimcustomerId
					FROM mdm.compositeRecord_History 
					WHERE BatchDate = @endDate
					) day2 ON day1.DimCustomerId = day2.DimCustomerId
		LEFT JOIN (SELECT ssbid.DimCustomerId
						,COUNT(ssbid.DimCustomerId) OVER(PARTITION BY ssbid.SSB_CRMSYSTEM_CONTACT_ID) AS numIds
					FROM dbo.DimCustomerSSBID_History ssbid
					WHERE ssbid.BatchDate = @endDate)ssbid ON ssbid.DimCustomerId = day2.DimCustomerId
WHERE day1.DimCustomerId IS NULL 
		OR day2.DimCustomerId IS NULL

IF object_id('tempdb..#updates') IS NOT NULL DROP TABLE #updates
SELECT cr.DimCustomerId
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
	   ,SSB_CRMSYSTEM_ACCT_ID
	   ,SSB_CRMSYSTEM_CONTACT_ID
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
INTO #updates
FROM mdm.compositerecord_History cr
	LEFT JOIN #addDrop addDrop ON addDrop.dimcustomerID = cr.DimCustomerId		
WHERE BatchDate = @endDate
	  AND addDrop.dimcustomerID IS NULL

EXCEPT	

SELECT cr.DimCustomerId
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
	   ,SSB_CRMSYSTEM_ACCT_ID
	   ,SSB_CRMSYSTEM_CONTACT_ID
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
FROM mdm.compositerecord_History cr
	LEFT JOIN #addDrop addDrop ON addDrop.dimcustomerID = cr.DimCustomerId		
WHERE BatchDate = @startDate
	  AND addDrop.dimcustomerID IS NULL

DROP INDEX IX_CompositeRecord_History_Changes_AccountID ON mdm.CompositeRecord_History_Changes 
DROP INDEX IX_CompositeRecord_History_Changes_SSID ON mdm.CompositeRecord_History_Changes 
DROP INDEX IX_CompositeRecord_History_Changes_BatchDate ON mdm.CompositeRecord_History_Changes
DROP INDEX IX_CompositeRecord_History_Changes_DimCustomerID ON mdm.CompositeRecord_History_Changes

INSERT INTO mdm.compositerecord_History_Changes

SELECT @endDate AS BatchDate
	   ,'UPDATE' AS RecordChange
	   ,cr.BatchDate AS SnapshotDate
	   ,cr.DimCustomerId
	   ,cr.BatchId
	   ,cr.ODSRowLastUpdated
	   ,cr.SourceDB
	   ,cr.SourceSystem
	   ,cr.SourceSystemPriority
	   ,cr.SSID
	   ,cr.CustomerType
	   ,cr.CustomerStatus
	   ,cr.AccountType
	   ,cr.AccountRep
	   ,cr.CompanyName
	   ,cr.SalutationName
	   ,cr.DonorMailName
	   ,cr.DonorFormalName
	   ,cr.Birthday
	   ,cr.Gender
	   ,cr.MergedRecordFlag
	   ,cr.MergedIntoSSID
	   ,cr.Prefix
	   ,cr.FirstName
	   ,cr.MiddleName
	   ,cr.LastName
	   ,cr.Suffix
	   ,cr.NameDirtyHash
	   ,cr.NameIsCleanStatus
	   ,cr.NameMasterId
	   ,cr.AddressPrimaryStreet
	   ,cr.AddressPrimaryCity
	   ,cr.AddressPrimaryState
	   ,cr.AddressPrimaryZip
	   ,cr.AddressPrimaryCounty
	   ,cr.AddressPrimaryCountry
	   ,cr.AddressPrimaryDirtyHash
	   ,cr.AddressPrimaryIsCleanStatus
	   ,cr.AddressPrimaryMasterId
	   ,cr.ContactDirtyHash
	   ,cr.ContactGUID
	   ,cr.AddressOneStreet
	   ,cr.AddressOneCity
	   ,cr.AddressOneState
	   ,cr.AddressOneZip
	   ,cr.AddressOneCounty
	   ,cr.AddressOneCountry
	   ,cr.AddressOneDirtyHash
	   ,cr.AddressOneIsCleanStatus
	   ,cr.AddressOneMasterId
	   ,cr.AddressTwoStreet
	   ,cr.AddressTwoCity
	   ,cr.AddressTwoState
	   ,cr.AddressTwoZip
	   ,cr.AddressTwoCounty
	   ,cr.AddressTwoCountry
	   ,cr.AddressTwoDirtyHash
	   ,cr.AddressTwoIsCleanStatus
	   ,cr.AddressTwoMasterId
	   ,cr.AddressThreeStreet
	   ,cr.AddressThreeCity
	   ,cr.AddressThreeState
	   ,cr.AddressThreeZip
	   ,cr.AddressThreeCounty
	   ,cr.AddressThreeCountry
	   ,cr.AddressThreeDirtyHash
	   ,cr.AddressThreeIsCleanStatus
	   ,cr.AddressThreeMasterId
	   ,cr.AddressFourStreet
	   ,cr.AddressFourCity
	   ,cr.AddressFourState
	   ,cr.AddressFourZip
	   ,cr.AddressFourCounty
	   ,cr.AddressFourCountry
	   ,cr.AddressFourDirtyHash
	   ,cr.AddressFourIsCleanStatus
	   ,cr.AddressFourMasterId
	   ,cr.PhonePrimary
	   ,cr.PhonePrimaryDirtyHash
	   ,cr.PhonePrimaryIsCleanStatus
	   ,cr.PhonePrimaryMasterId
	   ,cr.PhoneHome
	   ,cr.PhoneHomeDirtyHash
	   ,cr.PhoneHomeIsCleanStatus
	   ,cr.PhoneHomeMasterId
	   ,cr.PhoneCell
	   ,cr.PhoneCellDirtyHash
	   ,cr.PhoneCellIsCleanStatus
	   ,cr.PhoneCellMasterId
	   ,cr.PhoneBusiness
	   ,cr.PhoneBusinessDirtyHash
	   ,cr.PhoneBusinessIsCleanStatus
	   ,cr.PhoneBusinessMasterId
	   ,cr.PhoneFax
	   ,cr.PhoneFaxDirtyHash
	   ,cr.PhoneFaxIsCleanStatus
	   ,cr.PhoneFaxMasterId
	   ,cr.PhoneOther
	   ,cr.PhoneOtherDirtyHash
	   ,cr.PhoneOtherIsCleanStatus
	   ,cr.PhoneOtherMasterId
	   ,cr.EmailPrimary
	   ,cr.EmailPrimaryDirtyHash
	   ,cr.EmailPrimaryIsCleanStatus
	   ,cr.EmailPrimaryMasterId
	   ,cr.EmailOne
	   ,cr.EmailOneDirtyHash
	   ,cr.EmailOneIsCleanStatus
	   ,cr.EmailOneMasterId
	   ,cr.EmailTwo
	   ,cr.EmailTwoDirtyHash
	   ,cr.EmailTwoIsCleanStatus
	   ,cr.EmailTwoMasterId
	   ,cr.ExtAttribute1
	   ,cr.ExtAttribute2
	   ,cr.ExtAttribute3
	   ,cr.ExtAttribute4
	   ,cr.ExtAttribute5
	   ,cr.ExtAttribute6
	   ,cr.ExtAttribute7
	   ,cr.ExtAttribute8
	   ,cr.ExtAttribute9
	   ,cr.ExtAttribute10
	   ,cr.ExtAttribute11
	   ,cr.ExtAttribute12
	   ,cr.ExtAttribute13
	   ,cr.ExtAttribute14
	   ,cr.ExtAttribute15
	   ,cr.ExtAttribute16
	   ,cr.ExtAttribute17
	   ,cr.ExtAttribute18
	   ,cr.ExtAttribute19
	   ,cr.ExtAttribute20
	   ,cr.ExtAttribute21
	   ,cr.ExtAttribute22
	   ,cr.ExtAttribute23
	   ,cr.ExtAttribute24
	   ,cr.ExtAttribute25
	   ,cr.ExtAttribute26
	   ,cr.ExtAttribute27
	   ,cr.ExtAttribute28
	   ,cr.ExtAttribute29
	   ,cr.ExtAttribute30
	   ,cr.SSCreatedBy
	   ,cr.SSCreatedDate
	   ,cr.CreatedBy
	   ,cr.CreatedDate
	   ,cr.AccountId
	   ,cr.AddressPrimaryNCOAStatus
	   ,cr.AddressOneStreetNCOAStatus
	   ,cr.AddressTwoStreetNCOAStatus
	   ,cr.AddressThreeStreetNCOAStatus
	   ,cr.AddressFourStreetNCOAStatus
	   ,cr.IsDeleted
	   ,cr.DeleteDate
	   ,cr.IsBusiness
	   ,cr.FullName
	   ,cr.ExtAttribute31
	   ,cr.ExtAttribute32
	   ,cr.ExtAttribute33
	   ,cr.ExtAttribute34
	   ,cr.ExtAttribute35
	   ,cr.AddressPrimarySuite
	   ,cr.AddressOneSuite
	   ,cr.AddressTwoSuite
	   ,cr.AddressThreeSuite
	   ,cr.AddressFourSuite
	   ,cr.SSB_CRMSYSTEM_ACCT_ID
	   ,cr.SSB_CRMSYSTEM_CONTACT_ID
	   ,cr.PhonePrimaryDNC
	   ,cr.PhoneHomeDNC
	   ,cr.PhoneCellDNC
	   ,cr.PhoneBusinessDNC
	   ,cr.PhoneFaxDNC
	   ,cr.PhoneOtherDNC
	   ,cr.AddressPrimaryPlus4
	   ,cr.AddressOnePlus4
	   ,cr.AddressTwoPlus4
	   ,cr.AddressThreePlus4
	   ,cr.AddressFourPlus4
	   ,cr.AddressPrimaryLatitude
	   ,cr.AddressPrimaryLongitude
	   ,cr.AddressOneLatitude
	   ,cr.AddressOneLongitude
	   ,cr.AddressTwoLatitude
	   ,cr.AddressTwoLongitude
	   ,cr.AddressThreeLatitude
	   ,cr.AddressThreeLongitude
	   ,cr.AddressFourLatitude
	   ,cr.AddressFourLongitude
	   ,cr.CD_Gender
FROM mdm.compositerecord_History cr
	JOIN #updates updates ON updates.dimcustomerID = cr.DimCustomerId
WHERE cr.BatchDate IN (@startDate,@endDate)

UNION ALL 

SELECT @endDate AS BatchDate
	   ,addDrop.recordChange
	   ,cr.BatchDate AS SnapshotDate
	   ,cr.DimCustomerId
	   ,cr.BatchId
	   ,cr.ODSRowLastUpdated
	   ,cr.SourceDB
	   ,cr.SourceSystem
	   ,cr.SourceSystemPriority
	   ,cr.SSID
	   ,cr.CustomerType
	   ,cr.CustomerStatus
	   ,cr.AccountType
	   ,cr.AccountRep
	   ,cr.CompanyName
	   ,cr.SalutationName
	   ,cr.DonorMailName
	   ,cr.DonorFormalName
	   ,cr.Birthday
	   ,cr.Gender
	   ,cr.MergedRecordFlag
	   ,cr.MergedIntoSSID
	   ,cr.Prefix
	   ,cr.FirstName
	   ,cr.MiddleName
	   ,cr.LastName
	   ,cr.Suffix
	   ,cr.NameDirtyHash
	   ,cr.NameIsCleanStatus
	   ,cr.NameMasterId
	   ,cr.AddressPrimaryStreet
	   ,cr.AddressPrimaryCity
	   ,cr.AddressPrimaryState
	   ,cr.AddressPrimaryZip
	   ,cr.AddressPrimaryCounty
	   ,cr.AddressPrimaryCountry
	   ,cr.AddressPrimaryDirtyHash
	   ,cr.AddressPrimaryIsCleanStatus
	   ,cr.AddressPrimaryMasterId
	   ,cr.ContactDirtyHash
	   ,cr.ContactGUID
	   ,cr.AddressOneStreet
	   ,cr.AddressOneCity
	   ,cr.AddressOneState
	   ,cr.AddressOneZip
	   ,cr.AddressOneCounty
	   ,cr.AddressOneCountry
	   ,cr.AddressOneDirtyHash
	   ,cr.AddressOneIsCleanStatus
	   ,cr.AddressOneMasterId
	   ,cr.AddressTwoStreet
	   ,cr.AddressTwoCity
	   ,cr.AddressTwoState
	   ,cr.AddressTwoZip
	   ,cr.AddressTwoCounty
	   ,cr.AddressTwoCountry
	   ,cr.AddressTwoDirtyHash
	   ,cr.AddressTwoIsCleanStatus
	   ,cr.AddressTwoMasterId
	   ,cr.AddressThreeStreet
	   ,cr.AddressThreeCity
	   ,cr.AddressThreeState
	   ,cr.AddressThreeZip
	   ,cr.AddressThreeCounty
	   ,cr.AddressThreeCountry
	   ,cr.AddressThreeDirtyHash
	   ,cr.AddressThreeIsCleanStatus
	   ,cr.AddressThreeMasterId
	   ,cr.AddressFourStreet
	   ,cr.AddressFourCity
	   ,cr.AddressFourState
	   ,cr.AddressFourZip
	   ,cr.AddressFourCounty
	   ,cr.AddressFourCountry
	   ,cr.AddressFourDirtyHash
	   ,cr.AddressFourIsCleanStatus
	   ,cr.AddressFourMasterId
	   ,cr.PhonePrimary
	   ,cr.PhonePrimaryDirtyHash
	   ,cr.PhonePrimaryIsCleanStatus
	   ,cr.PhonePrimaryMasterId
	   ,cr.PhoneHome
	   ,cr.PhoneHomeDirtyHash
	   ,cr.PhoneHomeIsCleanStatus
	   ,cr.PhoneHomeMasterId
	   ,cr.PhoneCell
	   ,cr.PhoneCellDirtyHash
	   ,cr.PhoneCellIsCleanStatus
	   ,cr.PhoneCellMasterId
	   ,cr.PhoneBusiness
	   ,cr.PhoneBusinessDirtyHash
	   ,cr.PhoneBusinessIsCleanStatus
	   ,cr.PhoneBusinessMasterId
	   ,cr.PhoneFax
	   ,cr.PhoneFaxDirtyHash
	   ,cr.PhoneFaxIsCleanStatus
	   ,cr.PhoneFaxMasterId
	   ,cr.PhoneOther
	   ,cr.PhoneOtherDirtyHash
	   ,cr.PhoneOtherIsCleanStatus
	   ,cr.PhoneOtherMasterId
	   ,cr.EmailPrimary
	   ,cr.EmailPrimaryDirtyHash
	   ,cr.EmailPrimaryIsCleanStatus
	   ,cr.EmailPrimaryMasterId
	   ,cr.EmailOne
	   ,cr.EmailOneDirtyHash
	   ,cr.EmailOneIsCleanStatus
	   ,cr.EmailOneMasterId
	   ,cr.EmailTwo
	   ,cr.EmailTwoDirtyHash
	   ,cr.EmailTwoIsCleanStatus
	   ,cr.EmailTwoMasterId
	   ,cr.ExtAttribute1
	   ,cr.ExtAttribute2
	   ,cr.ExtAttribute3
	   ,cr.ExtAttribute4
	   ,cr.ExtAttribute5
	   ,cr.ExtAttribute6
	   ,cr.ExtAttribute7
	   ,cr.ExtAttribute8
	   ,cr.ExtAttribute9
	   ,cr.ExtAttribute10
	   ,cr.ExtAttribute11
	   ,cr.ExtAttribute12
	   ,cr.ExtAttribute13
	   ,cr.ExtAttribute14
	   ,cr.ExtAttribute15
	   ,cr.ExtAttribute16
	   ,cr.ExtAttribute17
	   ,cr.ExtAttribute18
	   ,cr.ExtAttribute19
	   ,cr.ExtAttribute20
	   ,cr.ExtAttribute21
	   ,cr.ExtAttribute22
	   ,cr.ExtAttribute23
	   ,cr.ExtAttribute24
	   ,cr.ExtAttribute25
	   ,cr.ExtAttribute26
	   ,cr.ExtAttribute27
	   ,cr.ExtAttribute28
	   ,cr.ExtAttribute29
	   ,cr.ExtAttribute30
	   ,cr.SSCreatedBy
	   ,cr.SSCreatedDate
	   ,cr.CreatedBy
	   ,cr.CreatedDate
	   ,cr.AccountId
	   ,cr.AddressPrimaryNCOAStatus
	   ,cr.AddressOneStreetNCOAStatus
	   ,cr.AddressTwoStreetNCOAStatus
	   ,cr.AddressThreeStreetNCOAStatus
	   ,cr.AddressFourStreetNCOAStatus
	   ,cr.IsDeleted
	   ,cr.DeleteDate
	   ,cr.IsBusiness
	   ,cr.FullName
	   ,cr.ExtAttribute31
	   ,cr.ExtAttribute32
	   ,cr.ExtAttribute33
	   ,cr.ExtAttribute34
	   ,cr.ExtAttribute35
	   ,cr.AddressPrimarySuite
	   ,cr.AddressOneSuite
	   ,cr.AddressTwoSuite
	   ,cr.AddressThreeSuite
	   ,cr.AddressFourSuite
	   ,cr.SSB_CRMSYSTEM_ACCT_ID
	   ,cr.SSB_CRMSYSTEM_CONTACT_ID
	   ,cr.PhonePrimaryDNC
	   ,cr.PhoneHomeDNC
	   ,cr.PhoneCellDNC
	   ,cr.PhoneBusinessDNC
	   ,cr.PhoneFaxDNC
	   ,cr.PhoneOtherDNC
	   ,cr.AddressPrimaryPlus4
	   ,cr.AddressOnePlus4
	   ,cr.AddressTwoPlus4
	   ,cr.AddressThreePlus4
	   ,cr.AddressFourPlus4
	   ,cr.AddressPrimaryLatitude
	   ,cr.AddressPrimaryLongitude
	   ,cr.AddressOneLatitude
	   ,cr.AddressOneLongitude
	   ,cr.AddressTwoLatitude
	   ,cr.AddressTwoLongitude
	   ,cr.AddressThreeLatitude
	   ,cr.AddressThreeLongitude
	   ,cr.AddressFourLatitude
	   ,cr.AddressFourLongitude
	   ,cr.CD_Gender
FROM mdm.compositerecord_History cr
	JOIN #addDrop addDrop ON addDrop.dimcustomerID = cr.DimCustomerId
WHERE cr.BatchDate IN (@startDate,@endDate)

CREATE INDEX IX_CompositeRecord_History_Changes_AccountID ON mdm.CompositeRecord_History_Changes (AccountId ASC)	
CREATE INDEX IX_CompositeRecord_History_Changes_SSID ON mdm.CompositeRecord_History_Changes (SSID ASC)
CREATE INDEX IX_CompositeRecord_History_Changes_BatchDate ON mdm.CompositeRecord_History_Changes(BatchDate ASC)	
CREATE INDEX IX_CompositeRecord_History_Changes_DimCustomerID ON mdm.CompositeRecord_History_Changes (DimCustomerID ASC)

GO
