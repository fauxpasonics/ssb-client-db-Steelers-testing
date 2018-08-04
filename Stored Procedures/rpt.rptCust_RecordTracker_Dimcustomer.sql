SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




--[rpt].[rptCust_RecordTracker_Dimcustomer] '20160718'

CREATE PROCEDURE [rpt].[rptCust_RecordTracker_Dimcustomer](@batchDate DATE)

AS 

SET NOCOUNT ON

--DECLARE @BatchDate Date = (SELECT MAX(batchDate) FROM dbo.DimCustomer_History_Changes)
DECLARE @PriorDate DATE = (SELECT MIN(snapshotDate) FROM dbo.DimCustomer_History_Changes WHERE BatchDate = @BatchDate)
DECLARE @CurrentDate DATE = (SELECT MAX(snapshotDate) FROM dbo.DimCustomer_History_Changes WHERE BatchDate = @BatchDate)

IF object_id('tempdb..#dimcustomerUnpivoted')IS NOT NULL DROP TABLE #dimcustomerUnpivoted

SELECT dimcustomerID
	   ,SourceSystem
	   ,SnapshotDate
	   ,FieldName
	   ,Value 
INTO #dimcustomerUnpivoted
FROM (SELECT DimCustomerId, SourceSystem, SnapshotDate	,ISNULL(CAST(BatchId AS VARCHAR(100)),'NULL') BatchId	,ISNULL(CAST(ODSRowLastUpdated AS VARCHAR(100)),'NULL') ODSRowLastUpdated ,ISNULL(CAST(SourceDB AS VARCHAR(100)),'NULL') SourceDB	
			,ISNULL(CAST(SourceSystemPriority AS VARCHAR(100)),'NULL') SourceSystemPriority	,ISNULL(CAST(SSID AS VARCHAR(100)),'NULL') SSID	,ISNULL(CAST(CustomerType AS VARCHAR(100)),'NULL') CustomerType	
			,ISNULL(CAST(CustomerStatus AS VARCHAR(100)),'NULL') CustomerStatus	,ISNULL(CAST(AccountType AS VARCHAR(100)),'NULL') AccountType	,ISNULL(CAST(AccountRep AS VARCHAR(100)),'NULL') AccountRep	,ISNULL(CAST(CompanyName AS VARCHAR(100)),'NULL') CompanyName	
			,ISNULL(CAST(SalutationName AS VARCHAR(100)),'NULL') SalutationName	,ISNULL(CAST(DonorMailName AS VARCHAR(100)),'NULL') DonorMailName	,ISNULL(CAST(DonorFormalName AS VARCHAR(100)),'NULL') DonorFormalName	,ISNULL(CAST(Birthday AS VARCHAR(100)),'NULL') Birthday	
			,ISNULL(CAST(Gender AS VARCHAR(100)),'NULL') Gender	,ISNULL(CAST(MergedRecordFlag AS VARCHAR(100)),'NULL') MergedRecordFlag	,ISNULL(CAST(MergedIntoSSID AS VARCHAR(100)),'NULL') MergedIntoSSID	,ISNULL(CAST(Prefix AS VARCHAR(100)),'NULL') Prefix	
			,ISNULL(CAST(FirstName AS VARCHAR(100)),'NULL') FirstName	,ISNULL(CAST(MiddleName AS VARCHAR(100)),'NULL') MiddleName	,ISNULL(CAST(LastName AS VARCHAR(100)),'NULL') LastName	,ISNULL(CAST(Suffix AS VARCHAR(100)),'NULL') Suffix	
			,ISNULL(CONVERT(VARCHAR(100),master.dbo.fn_varbintohexstr(NameDirtyHash)),'NULL') NameDirtyHash	,ISNULL(CAST(NameIsCleanStatus AS VARCHAR(100)),'NULL') NameIsCleanStatus	,ISNULL(CAST(NameMasterId AS VARCHAR(100)),'NULL') NameMasterId	
			,ISNULL(CAST(AddressPrimaryStreet AS VARCHAR(100)),'NULL') AddressPrimaryStreet	,ISNULL(CAST(AddressPrimaryCity AS VARCHAR(100)),'NULL') AddressPrimaryCity	,ISNULL(CAST(AddressPrimaryState AS VARCHAR(100)),'NULL') AddressPrimaryState	
			,ISNULL(CAST(AddressPrimaryZip AS VARCHAR(100)),'NULL') AddressPrimaryZip	,ISNULL(CAST(AddressPrimaryCounty AS VARCHAR(100)),'NULL') AddressPrimaryCounty	,ISNULL(CAST(AddressPrimaryCountry AS VARCHAR(100)),'NULL') AddressPrimaryCountry	
			,ISNULL(CONVERT(VARCHAR(100),master.dbo.fn_varbintohexstr(AddressPrimaryDirtyHash)),'NULL') AddressPrimaryDirtyHash	,ISNULL(CAST(AddressPrimaryIsCleanStatus AS VARCHAR(100)),'NULL') AddressPrimaryIsCleanStatus	
			,ISNULL(CAST(AddressPrimaryMasterId AS VARCHAR(100)),'NULL') AddressPrimaryMasterId	,ISNULL(CONVERT(VARCHAR(100),master.dbo.fn_varbintohexstr(ContactDirtyHash)),'NULL') ContactDirtyHash	,ISNULL(CAST(ContactGUID AS VARCHAR(100)),'NULL') ContactGUID	
			,ISNULL(CAST(AddressOneStreet AS VARCHAR(100)),'NULL') AddressOneStreet	,ISNULL(CAST(AddressOneCity AS VARCHAR(100)),'NULL') AddressOneCity	,ISNULL(CAST(AddressOneState AS VARCHAR(100)),'NULL') AddressOneState	
			,ISNULL(CAST(AddressOneZip AS VARCHAR(100)),'NULL') AddressOneZip	,ISNULL(CAST(AddressOneCounty AS VARCHAR(100)),'NULL') AddressOneCounty	,ISNULL(CAST(AddressOneCountry AS VARCHAR(100)),'NULL') AddressOneCountry	
			,ISNULL(CONVERT(VARCHAR(100),master.dbo.fn_varbintohexstr(AddressOneDirtyHash)),'NULL') AddressOneDirtyHash	,ISNULL(CAST(AddressOneIsCleanStatus AS VARCHAR(100)),'NULL') AddressOneIsCleanStatus	,ISNULL(CAST(AddressOneMasterId AS VARCHAR(100)),'NULL') AddressOneMasterId	
			,ISNULL(CAST(AddressTwoStreet AS VARCHAR(100)),'NULL') AddressTwoStreet	,ISNULL(CAST(AddressTwoCity AS VARCHAR(100)),'NULL') AddressTwoCity	,ISNULL(CAST(AddressTwoState AS VARCHAR(100)),'NULL') AddressTwoState	
			,ISNULL(CAST(AddressTwoZip AS VARCHAR(100)),'NULL') AddressTwoZip	,ISNULL(CAST(AddressTwoCounty AS VARCHAR(100)),'NULL') AddressTwoCounty	,ISNULL(CAST(AddressTwoCountry AS VARCHAR(100)),'NULL') AddressTwoCountry	
			,ISNULL(CONVERT(VARCHAR(100),master.dbo.fn_varbintohexstr(AddressTwoDirtyHash)),'NULL') AddressTwoDirtyHash	,ISNULL(CAST(AddressTwoIsCleanStatus AS VARCHAR(100)),'NULL') AddressTwoIsCleanStatus	,ISNULL(CAST(AddressTwoMasterId AS VARCHAR(100)),'NULL') AddressTwoMasterId	
			,ISNULL(CAST(AddressThreeStreet AS VARCHAR(100)),'NULL') AddressThreeStreet	,ISNULL(CAST(AddressThreeCity AS VARCHAR(100)),'NULL') AddressThreeCity	,ISNULL(CAST(AddressThreeState AS VARCHAR(100)),'NULL') AddressThreeState	
			,ISNULL(CAST(AddressThreeZip AS VARCHAR(100)),'NULL') AddressThreeZip	,ISNULL(CAST(AddressThreeCounty AS VARCHAR(100)),'NULL') AddressThreeCounty	,ISNULL(CAST(AddressThreeCountry AS VARCHAR(100)),'NULL') AddressThreeCountry	
			,ISNULL(CONVERT(VARCHAR(100),master.dbo.fn_varbintohexstr(AddressThreeDirtyHash)),'NULL') AddressThreeDirtyHash	,ISNULL(CAST(AddressThreeIsCleanStatus AS VARCHAR(100)),'NULL') AddressThreeIsCleanStatus	
			,ISNULL(CAST(AddressThreeMasterId AS VARCHAR(100)),'NULL') AddressThreeMasterId	,ISNULL(CAST(AddressFourStreet AS VARCHAR(100)),'NULL') AddressFourStreet	,ISNULL(CAST(AddressFourCity AS VARCHAR(100)),'NULL') AddressFourCity	
			,ISNULL(CAST(AddressFourState AS VARCHAR(100)),'NULL') AddressFourState	,ISNULL(CAST(AddressFourZip AS VARCHAR(100)),'NULL') AddressFourZip	,ISNULL(CAST(AddressFourCounty AS VARCHAR(100)),'NULL') AddressFourCounty	
			,ISNULL(CAST(AddressFourCountry AS VARCHAR(100)),'NULL') AddressFourCountry	,ISNULL(CONVERT(VARCHAR(100),master.dbo.fn_varbintohexstr(AddressFourDirtyHash)),'NULL') AddressFourDirtyHash	
			,ISNULL(CAST(AddressFourIsCleanStatus AS VARCHAR(100)),'NULL') AddressFourIsCleanStatus	,ISNULL(CAST(AddressFourMasterId AS VARCHAR(100)),'NULL') AddressFourMasterId	,ISNULL(CAST(PhonePrimary AS VARCHAR(100)),'NULL') PhonePrimary	
			,ISNULL(CONVERT(VARCHAR(100),master.dbo.fn_varbintohexstr(PhonePrimaryDirtyHash)),'NULL') PhonePrimaryDirtyHash	,ISNULL(CAST(PhonePrimaryIsCleanStatus AS VARCHAR(100)),'NULL') PhonePrimaryIsCleanStatus	
			,ISNULL(CAST(PhonePrimaryMasterId AS VARCHAR(100)),'NULL') PhonePrimaryMasterId	,ISNULL(CAST(PhoneHome AS VARCHAR(100)),'NULL') PhoneHome	,ISNULL(CONVERT(VARCHAR(100),master.dbo.fn_varbintohexstr(PhoneHomeDirtyHash)),'NULL') PhoneHomeDirtyHash	
			,ISNULL(CAST(PhoneHomeIsCleanStatus AS VARCHAR(100)),'NULL') PhoneHomeIsCleanStatus	,ISNULL(CAST(PhoneHomeMasterId AS VARCHAR(100)),'NULL') PhoneHomeMasterId	,ISNULL(CAST(PhoneCell AS VARCHAR(100)),'NULL') PhoneCell	
			,ISNULL(CONVERT(VARCHAR(100),master.dbo.fn_varbintohexstr(PhoneCellDirtyHash)),'NULL') PhoneCellDirtyHash	,ISNULL(CAST(PhoneCellIsCleanStatus AS VARCHAR(100)),'NULL') PhoneCellIsCleanStatus	,ISNULL(CAST(PhoneCellMasterId AS VARCHAR(100)),'NULL') PhoneCellMasterId	
			,ISNULL(CAST(PhoneBusiness AS VARCHAR(100)),'NULL') PhoneBusiness	,ISNULL(CONVERT(VARCHAR(100),master.dbo.fn_varbintohexstr(PhoneBusinessDirtyHash)),'NULL') PhoneBusinessDirtyHash	
			,ISNULL(CAST(PhoneBusinessIsCleanStatus AS VARCHAR(100)),'NULL') PhoneBusinessIsCleanStatus	,ISNULL(CAST(PhoneBusinessMasterId AS VARCHAR(100)),'NULL') PhoneBusinessMasterId	,ISNULL(CAST(PhoneFax AS VARCHAR(100)),'NULL') PhoneFax	
			,ISNULL(CONVERT(VARCHAR(100),master.dbo.fn_varbintohexstr(PhoneFaxDirtyHash)),'NULL') PhoneFaxDirtyHash	,ISNULL(CAST(PhoneFaxIsCleanStatus AS VARCHAR(100)),'NULL') PhoneFaxIsCleanStatus	,ISNULL(CAST(PhoneFaxMasterId AS VARCHAR(100)),'NULL') PhoneFaxMasterId	
			,ISNULL(CAST(PhoneOther AS VARCHAR(100)),'NULL') PhoneOther	,ISNULL(CONVERT(VARCHAR(100),master.dbo.fn_varbintohexstr(PhoneOtherDirtyHash)),'NULL') PhoneOtherDirtyHash	,ISNULL(CAST(PhoneOtherIsCleanStatus AS VARCHAR(100)),'NULL') PhoneOtherIsCleanStatus	
			,ISNULL(CAST(PhoneOtherMasterId AS VARCHAR(100)),'NULL') PhoneOtherMasterId	,ISNULL(CAST(EmailPrimary AS VARCHAR(100)),'NULL') EmailPrimary	,ISNULL(CONVERT(VARCHAR(100),master.dbo.fn_varbintohexstr(EmailPrimaryDirtyHash)),'NULL') EmailPrimaryDirtyHash	
			,ISNULL(CAST(EmailPrimaryIsCleanStatus AS VARCHAR(100)),'NULL') EmailPrimaryIsCleanStatus	,ISNULL(CAST(EmailPrimaryMasterId AS VARCHAR(100)),'NULL') EmailPrimaryMasterId	,ISNULL(CAST(EmailOne AS VARCHAR(100)),'NULL') EmailOne	
			,ISNULL(CONVERT(VARCHAR(100),master.dbo.fn_varbintohexstr(EmailOneDirtyHash)),'NULL') EmailOneDirtyHash	,ISNULL(CAST(EmailOneIsCleanStatus AS VARCHAR(100)),'NULL') EmailOneIsCleanStatus	,ISNULL(CAST(EmailOneMasterId AS VARCHAR(100)),'NULL') EmailOneMasterId	
			,ISNULL(CAST(EmailTwo AS VARCHAR(100)),'NULL') EmailTwo	,ISNULL(CONVERT(VARCHAR(100),master.dbo.fn_varbintohexstr(EmailTwoDirtyHash)),'NULL') EmailTwoDirtyHash	,ISNULL(CAST(EmailTwoIsCleanStatus AS VARCHAR(100)),'NULL') EmailTwoIsCleanStatus	
			,ISNULL(CAST(EmailTwoMasterId AS VARCHAR(100)),'NULL') EmailTwoMasterId	,ISNULL(CAST(ExtAttribute1 AS VARCHAR(100)),'NULL') ExtAttribute1	,ISNULL(CAST(ExtAttribute2 AS VARCHAR(100)),'NULL') ExtAttribute2	
			,ISNULL(CAST(ExtAttribute3 AS VARCHAR(100)),'NULL') ExtAttribute3	,ISNULL(CAST(ExtAttribute4 AS VARCHAR(100)),'NULL') ExtAttribute4	,ISNULL(CAST(ExtAttribute5 AS VARCHAR(100)),'NULL') ExtAttribute5	
			,ISNULL(CAST(ExtAttribute6 AS VARCHAR(100)),'NULL') ExtAttribute6	,ISNULL(CAST(ExtAttribute7 AS VARCHAR(100)),'NULL') ExtAttribute7	,ISNULL(CAST(ExtAttribute8 AS VARCHAR(100)),'NULL') ExtAttribute8	
			,ISNULL(CAST(ExtAttribute9 AS VARCHAR(100)),'NULL') ExtAttribute9	,ISNULL(CAST(ExtAttribute10 AS VARCHAR(100)),'NULL') ExtAttribute10	,ISNULL(CAST(ExtAttribute11 AS VARCHAR(100)),'NULL') ExtAttribute11	,ISNULL(CAST(ExtAttribute12 AS VARCHAR(100)),'NULL') ExtAttribute12	
			,ISNULL(CAST(ExtAttribute13 AS VARCHAR(100)),'NULL') ExtAttribute13	,ISNULL(CAST(ExtAttribute14 AS VARCHAR(100)),'NULL') ExtAttribute14	,ISNULL(CAST(ExtAttribute15 AS VARCHAR(100)),'NULL') ExtAttribute15	,ISNULL(CAST(ExtAttribute16 AS VARCHAR(100)),'NULL') ExtAttribute16	
			,ISNULL(CAST(ExtAttribute17 AS VARCHAR(100)),'NULL') ExtAttribute17	,ISNULL(CAST(ExtAttribute18 AS VARCHAR(100)),'NULL') ExtAttribute18	,ISNULL(CAST(ExtAttribute19 AS VARCHAR(100)),'NULL') ExtAttribute19	,ISNULL(CAST(ExtAttribute20 AS VARCHAR(100)),'NULL') ExtAttribute20	
			,ISNULL(CAST(ExtAttribute21 AS VARCHAR(100)),'NULL') ExtAttribute21	,ISNULL(CAST(ExtAttribute22 AS VARCHAR(100)),'NULL') ExtAttribute22	,ISNULL(CAST(ExtAttribute23 AS VARCHAR(100)),'NULL') ExtAttribute23	,ISNULL(CAST(ExtAttribute24 AS VARCHAR(100)),'NULL') ExtAttribute24	
			,ISNULL(CAST(ExtAttribute25 AS VARCHAR(100)),'NULL') ExtAttribute25	,ISNULL(CAST(ExtAttribute26 AS VARCHAR(100)),'NULL') ExtAttribute26	,ISNULL(CAST(ExtAttribute27 AS VARCHAR(100)),'NULL') ExtAttribute27	,ISNULL(CAST(ExtAttribute28 AS VARCHAR(100)),'NULL') ExtAttribute28
			,ISNULL(CAST(ExtAttribute29 AS VARCHAR(100)),'NULL') ExtAttribute29	,ISNULL(CAST(ExtAttribute30 AS VARCHAR(100)),'NULL') ExtAttribute30	,ISNULL(CAST(SSCreatedBy AS VARCHAR(100)),'NULL') SSCreatedBy	,ISNULL(CAST(SSCreatedDate AS VARCHAR(100)),'NULL') SSCreatedDate	
			,ISNULL(CAST(CreatedBy AS VARCHAR(100)),'NULL') CreatedBy	,ISNULL(CAST(CreatedDate AS VARCHAR(100)),'NULL') CreatedDate	,ISNULL(CAST(AccountId AS VARCHAR(100)),'NULL') AccountId	,ISNULL(CAST(AddressPrimaryNCOAStatus AS VARCHAR(100)),'NULL') AddressPrimaryNCOAStatus	
			,ISNULL(CAST(AddressOneStreetNCOAStatus AS VARCHAR(100)),'NULL') AddressOneStreetNCOAStatus	,ISNULL(CAST(AddressTwoStreetNCOAStatus AS VARCHAR(100)),'NULL') AddressTwoStreetNCOAStatus	
			,ISNULL(CAST(AddressThreeStreetNCOAStatus AS VARCHAR(100)),'NULL') AddressThreeStreetNCOAStatus	,ISNULL(CAST(AddressFourStreetNCOAStatus AS VARCHAR(100)),'NULL') AddressFourStreetNCOAStatus	,ISNULL(CAST(IsDeleted AS VARCHAR(100)),'NULL') IsDeleted	
			,ISNULL(CAST(DeleteDate AS VARCHAR(100)),'NULL') DeleteDate	,ISNULL(CAST(IsBusiness AS VARCHAR(100)),'NULL') IsBusiness	,ISNULL(CAST(FullName AS VARCHAR(100)),'NULL') FullName	,ISNULL(CAST(ExtAttribute31 AS VARCHAR(100)),'NULL') ExtAttribute31	
			,ISNULL(CAST(ExtAttribute32 AS VARCHAR(100)),'NULL') ExtAttribute32	,ISNULL(CAST(ExtAttribute33 AS VARCHAR(100)),'NULL') ExtAttribute33	,ISNULL(CAST(ExtAttribute34 AS VARCHAR(100)),'NULL') ExtAttribute34	,ISNULL(CAST(ExtAttribute35 AS VARCHAR(100)),'NULL') ExtAttribute35	
			,ISNULL(CAST(AddressPrimarySuite AS VARCHAR(100)),'NULL') AddressPrimarySuite	,ISNULL(CAST(AddressOneSuite AS VARCHAR(100)),'NULL') AddressOneSuite	,ISNULL(CAST(AddressTwoSuite AS VARCHAR(100)),'NULL') AddressTwoSuite	
			,ISNULL(CAST(AddressThreeSuite AS VARCHAR(100)),'NULL') AddressThreeSuite	,ISNULL(CAST(AddressFourSuite AS VARCHAR(100)),'NULL') AddressFourSuite	,ISNULL(CAST(customer_matchkey AS VARCHAR(100)),'NULL') customer_matchkey	
			,ISNULL(CAST(PhonePrimaryDNC AS VARCHAR(100)),'NULL') PhonePrimaryDNC	,ISNULL(CAST(PhoneHomeDNC AS VARCHAR(100)),'NULL') PhoneHomeDNC	,ISNULL(CAST(PhoneCellDNC AS VARCHAR(100)),'NULL') PhoneCellDNC	,ISNULL(CAST(PhoneBusinessDNC AS VARCHAR(100)),'NULL') PhoneBusinessDNC	
			,ISNULL(CAST(PhoneFaxDNC AS VARCHAR(100)),'NULL') PhoneFaxDNC	,ISNULL(CAST(PhoneOtherDNC AS VARCHAR(100)),'NULL') PhoneOtherDNC	,ISNULL(CAST(AddressPrimaryPlus4 AS VARCHAR(100)),'NULL') AddressPrimaryPlus4	
			,ISNULL(CAST(AddressOnePlus4 AS VARCHAR(100)),'NULL') AddressOnePlus4	,ISNULL(CAST(AddressTwoPlus4 AS VARCHAR(100)),'NULL') AddressTwoPlus4	,ISNULL(CAST(AddressThreePlus4 AS VARCHAR(100)),'NULL') AddressThreePlus4	
			,ISNULL(CAST(AddressFourPlus4 AS VARCHAR(100)),'NULL') AddressFourPlus4	,ISNULL(CAST(AddressPrimaryLatitude AS VARCHAR(100)),'NULL') AddressPrimaryLatitude	,ISNULL(CAST(AddressPrimaryLongitude AS VARCHAR(100)),'NULL') AddressPrimaryLongitude	
			,ISNULL(CAST(AddressOneLatitude AS VARCHAR(100)),'NULL') AddressOneLatitude	,ISNULL(CAST(AddressOneLongitude AS VARCHAR(100)),'NULL') AddressOneLongitude	,ISNULL(CAST(AddressTwoLatitude AS VARCHAR(100)),'NULL') AddressTwoLatitude	
			,ISNULL(CAST(AddressTwoLongitude AS VARCHAR(100)),'NULL') AddressTwoLongitude	,ISNULL(CAST(AddressThreeLatitude AS VARCHAR(100)),'NULL') AddressThreeLatitude	,ISNULL(CAST(AddressThreeLongitude AS VARCHAR(100)),'NULL') AddressThreeLongitude	
			,ISNULL(CAST(AddressFourLatitude AS VARCHAR(100)),'NULL') AddressFourLatitude	,ISNULL(CAST(AddressFourLongitude AS VARCHAR(100)),'NULL') AddressFourLongitude	,ISNULL(CAST(CD_Gender AS VARCHAR(100)),'NULL') CD_Gender	
			,ISNULL(CONVERT(VARCHAR(100),master.dbo.fn_varbintohexstr(contactattrDirtyHash)),'NULL') contactattrDirtyHash	,ISNULL(CONVERT(VARCHAR(100),master.dbo.fn_varbintohexstr(extattr1_10DirtyHash)),'NULL') extattr1_10DirtyHash	
			,ISNULL(CONVERT(VARCHAR(100),master.dbo.fn_varbintohexstr(extattr11_20DirtyHash)),'NULL') extattr11_20DirtyHash	,ISNULL(CONVERT(VARCHAR(100),master.dbo.fn_varbintohexstr(extattr21_30DirtyHash)),'NULL') extattr21_30DirtyHash	
			,ISNULL(CONVERT(VARCHAR(100),master.dbo.fn_varbintohexstr(extattr31_35DirtyHash)),'NULL') extattr31_35DirtyHash

	FROM dbo.DimCustomer_History_Changes
	WHERE BatchDate = @BatchDate
		  AND recordChange = 'UPDATE'

	) Unpivoted
	UNPIVOT	
	(Value FOR FieldName IN 
		(BatchId	,ODSRowLastUpdated	,SourceDB		
		 ,SourceSystemPriority	,SSID	,CustomerType	,CustomerStatus	,AccountType	
		 ,AccountRep	,CompanyName	,SalutationName	,DonorMailName	,DonorFormalName	
		 ,Birthday	,Gender	,MergedRecordFlag	,MergedIntoSSID	,Prefix	,FirstName	
		 ,MiddleName	,LastName	,Suffix	,NameDirtyHash	,NameIsCleanStatus	,NameMasterId	
		 ,AddressPrimaryStreet	,AddressPrimaryCity	,AddressPrimaryState	,AddressPrimaryZip	
		 ,AddressPrimaryCounty	,AddressPrimaryCountry	,AddressPrimaryDirtyHash	
		 ,AddressPrimaryIsCleanStatus	,AddressPrimaryMasterId	,ContactDirtyHash	
		 ,ContactGUID	,AddressOneStreet	,AddressOneCity	,AddressOneState	
		 ,AddressOneZip	,AddressOneCounty	,AddressOneCountry	,AddressOneDirtyHash	
		 ,AddressOneIsCleanStatus	,AddressOneMasterId	,AddressTwoStreet	,AddressTwoCity	
		 ,AddressTwoState	,AddressTwoZip	,AddressTwoCounty	,AddressTwoCountry	
		 ,AddressTwoDirtyHash	,AddressTwoIsCleanStatus	,AddressTwoMasterId	
		 ,AddressThreeStreet	,AddressThreeCity	,AddressThreeState	,AddressThreeZip	
		 ,AddressThreeCounty	,AddressThreeCountry	,AddressThreeDirtyHash	
		 ,AddressThreeIsCleanStatus	,AddressThreeMasterId	,AddressFourStreet	
		 ,AddressFourCity	,AddressFourState	,AddressFourZip	,AddressFourCounty	
		 ,AddressFourCountry	,AddressFourDirtyHash	,AddressFourIsCleanStatus	
		 ,AddressFourMasterId	,PhonePrimary	,PhonePrimaryDirtyHash	
		 ,PhonePrimaryIsCleanStatus	,PhonePrimaryMasterId	,PhoneHome	,PhoneHomeDirtyHash	
		 ,PhoneHomeIsCleanStatus	,PhoneHomeMasterId	,PhoneCell	,PhoneCellDirtyHash	
		 ,PhoneCellIsCleanStatus	,PhoneCellMasterId	,PhoneBusiness	,PhoneBusinessDirtyHash	
		 ,PhoneBusinessIsCleanStatus	,PhoneBusinessMasterId	,PhoneFax	,PhoneFaxDirtyHash	
		 ,PhoneFaxIsCleanStatus	,PhoneFaxMasterId	,PhoneOther	,PhoneOtherDirtyHash	
		 ,PhoneOtherIsCleanStatus	,PhoneOtherMasterId	,EmailPrimary	,EmailPrimaryDirtyHash	
		 ,EmailPrimaryIsCleanStatus	,EmailPrimaryMasterId	,EmailOne	,EmailOneDirtyHash	
		 ,EmailOneIsCleanStatus	,EmailOneMasterId	,EmailTwo	,EmailTwoDirtyHash	
		 ,EmailTwoIsCleanStatus	,EmailTwoMasterId	,ExtAttribute1	,ExtAttribute2	
		 ,ExtAttribute3	,ExtAttribute4	,ExtAttribute5	,ExtAttribute6	,ExtAttribute7	
		 ,ExtAttribute8	,ExtAttribute9	,ExtAttribute10	,ExtAttribute11	,ExtAttribute12	
		 ,ExtAttribute13	,ExtAttribute14	,ExtAttribute15	,ExtAttribute16	,ExtAttribute17	
		 ,ExtAttribute18	,ExtAttribute19	,ExtAttribute20	,ExtAttribute21	,ExtAttribute22	
		 ,ExtAttribute23	,ExtAttribute24	,ExtAttribute25	,ExtAttribute26	,ExtAttribute27	
		 ,ExtAttribute28	,ExtAttribute29	,ExtAttribute30	,SSCreatedBy	,SSCreatedDate	
		 ,CreatedBy	,CreatedDate	,AccountId	,AddressPrimaryNCOAStatus	,AddressOneStreetNCOAStatus	
		 ,AddressTwoStreetNCOAStatus	,AddressThreeStreetNCOAStatus	,AddressFourStreetNCOAStatus	
		 ,IsDeleted	,DeleteDate	,IsBusiness	,FullName	,ExtAttribute31	,ExtAttribute32	,ExtAttribute33	
		 ,ExtAttribute34	,ExtAttribute35	,AddressPrimarySuite	,AddressOneSuite	,AddressTwoSuite	
		 ,AddressThreeSuite	,AddressFourSuite	,customer_matchkey	,PhonePrimaryDNC	,PhoneHomeDNC	
		 ,PhoneCellDNC	,PhoneBusinessDNC	,PhoneFaxDNC	,PhoneOtherDNC	,AddressPrimaryPlus4	
		 ,AddressOnePlus4	,AddressTwoPlus4	,AddressThreePlus4	,AddressFourPlus4	
		 ,AddressPrimaryLatitude	,AddressPrimaryLongitude	,AddressOneLatitude	,AddressOneLongitude	
		 ,AddressTwoLatitude	,AddressTwoLongitude	,AddressThreeLatitude	,AddressThreeLongitude	
		 ,AddressFourLatitude	,AddressFourLongitude	,CD_Gender	,contactattrDirtyHash	,extattr1_10DirtyHash	
		 ,extattr11_20DirtyHash	,extattr21_30DirtyHash	,extattr31_35DirtyHash)
		 )AS unpvt

		 SELECT dimcustomerID
				,SourceSystem
				,PriorDate
				,fieldName
				,PriorDayValue 
				,CurrentDayValue
		 FROM ( SELECT PriorDay.dimcustomerID
					   , PriorDay.fieldName
					   , PriorDay.SourceSystem
					   , priorday.snapShotDate AS PriorDate
					   , PriorDay.value AS PriorDayValue
					   , CurrentDay.value AS CurrentDayValue 
					   , CASE WHEN CurrentDay.value = PriorDay.value THEN 0 ELSE 1 END AS hasVariance
				FROM #dimcustomerUnpivoted PriorDay
					JOIN #dimcustomerUnpivoted CurrentDay ON PriorDay.dimcustomerid = CurrentDay.dimcustomerid
															 AND CurrentDay.fieldname = PriorDay.fieldname
					JOIN dbo.Recordcomparefields rcf ON rcf.fieldName = PriorDay.FieldName
				WHERE PriorDay.snapShotDate = @priorDate
					  AND CurrentDay.snapShotDate = @currentDate
					  AND rcf.isToBeCompared = 1)x
		WHERE x.hasVariance = 1
		ORDER BY DimCustomerId


GO
