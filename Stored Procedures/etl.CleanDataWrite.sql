SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[CleanDataWrite]
(
	@ClientDB varchar(50),
	@RowCount INT = 0
)
AS 

begin


/*[etl].[CleanDataWrite] 
* created: 
* modified:  12/11/2014 - Kwyss -- Procedure was putting email and phone on seperate rows.  
*					Moved the primary email and phone to the main contact record for recognition purposes.
* modified:  04/20/2015 - GHolder -- Added @ClientDB parameter and updated sproc to use dynamic SQL
*
*/

IF (SELECT @@VERSION) LIKE '%Azure%'
BEGIN
SET @ClientDB = ''
END


DECLARE 
	@sql NVARCHAR(MAX) = ' ' 

	SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + '.mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''CleanDataWrite'', ''Start'', 0);'
SET @sql = @sql + CHAR(13) + CHAR(13)

/*Main Select to Cast Final Datatypes*/
SET @sql = @sql 
	+ 'SELECT ' + CASE WHEN @RowCount > 0 THEN 'TOP ' + CAST(@RowCount AS NVARCHAR(25)) ELSE '' END + CHAR(13)
	+ 'CAST(SourceContactId as VARCHAR(200)) as SourceContactId' + CHAR(13)
	+ ', CAST(Prefix as VARCHAR(25)) Prefix' + CHAR(13)
	+ ', CAST(FirstName as VARCHAR(100)) FirstName' + CHAR(13)
	+ ', CAST(MiddleName as VARCHAR(100)) MiddleName' + CHAR(13)
	+ ', CAST(LastName as VARCHAR(100)) LastName' + CHAR(13)
	+ ', CAST(Suffix as VARCHAR(25)) Suffix' + CHAR(13)
	+ '---, CAST(NULL as VARCHAR(25)) Prefix' + CHAR(13)
	+ '---, CAST(NULL as VARCHAR(100)) FirstName' + CHAR(13)
	+ '---, CAST(NULL as VARCHAR(100)) MiddleName' + CHAR(13)
	+ '---, CAST(NULL as VARCHAR(100)) LastName' + CHAR(13)
	+ '---, CAST(NULL as VARCHAR(25)) Suffix' + CHAR(13)
	+ ', CAST(FullName as VARCHAR(200)) FullName' + CHAR(13)
	+ ', CAST(AddressType as VARCHAR(25)) AddressType' + CHAR(13)
	+ ', CAST(Address as VARCHAR(500)) Address' + CHAR(13)
	+ ', CAST(Address2 as VARCHAR(500)) Address2' + CHAR(13)
	+ ', CAST(City as VARCHAR(200)) City' + CHAR(13)
	+ ', CAST(State as VARCHAR(200)) State' + CHAR(13)
	+ ', CAST(ZipCode as VARCHAR(25)) ZipCode' + CHAR(13)
	+ ', CAST(County as VARCHAR(200)) County' + CHAR(13)
	+ ', CAST(Country as VARCHAR(200)) Country' + CHAR(13)
	+ ', CAST(PhoneType as VARCHAR(25))PhoneType' + CHAR(13)
	+ ', CAST(Phone as VARCHAR(25)) Phone' + CHAR(13)
	+ ', CAST(EmailType as VARCHAR(25)) EmailType' + CHAR(13)
	+ ', CAST(Email as VARCHAR(256)) Email' + CHAR(13)
	+ ', CAST(SourcePriorityRank as INT) SourcePriorityRank' + CHAR(13)
	+ ', CONVERT(VARCHAR(25), SourceCreateDate, 101) SourceCreateDate' + CHAR(13)
	+ ', CAST(Custom1 as VARCHAR(200)) Custom1' + CHAR(13)
	+ ', CAST(Custom2 as VARCHAR(200)) Custom2' + CHAR(13)
	+ ', CAST(Custom3 as VARCHAR(200)) Custom3' + CHAR(13)
	+ ', CAST(Custom4 as VARCHAR(200)) Custom4' + CHAR(13)
	+ ', CAST(Custom5 as VARCHAR(200)) Custom5' + CHAR(13)
	+ ', CAST(RunContactMatch as VARCHAR(5)) RunContactMatch' + CHAR(13)
	+ ', CAST(SourceSystem as VARCHAR(200)) SourceSystem' + CHAR(13)

	+ 'FROM' + CHAR(13)
	+ '(' + CHAR(13)
	+ '/*Contact Match*/' + CHAR(13)
	+ 'select ' + CHAR(13)
	+ 'CAST(SSID as VARCHAR(200)) SourceContactId' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(Prefix, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(25)) Prefix' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(FirstName, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(100)) FirstName' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(MiddleName, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(100)) MiddleName' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(LastName, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(100)) LastName' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(Suffix, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(25)) Suffix' + CHAR(13)
	+ ', REPLACE(REPLACE(REPLACE(FullName, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '')  FullName' + CHAR(13)
	+ ', ''addressprimary'' AddressType' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressPrimaryStreet, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(500)) Address' + CHAR(13)
	+ ', Cast(REPLACE(REPLACE(REPLACE(AddressPrimarySuite, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '')  as varchar(500)) Address2' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressPrimaryCity, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '')  as VARCHAR(200)) City' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressPrimaryState, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '')  as VARCHAR(200)) State' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressPrimaryZip, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(25)) ZipCode' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressPrimaryCounty, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '')  as VARCHAR(200)) County' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressPrimaryCountry, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '')  as VARCHAR(200)) Country' + CHAR(13)
	+ ', ''phoneprimary'' PhoneType' + CHAR(13)
	+ ', CAST(PhonePrimary as VARCHAR(25)) Phone' + CHAR(13)
	+ ', ''emailprimary'' EmailType' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(EmailPrimary, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(256)) Email' + CHAR(13)
	+ ', Isnull(SourceSystemPriority, 0) SourcePriorityRank' + CHAR(13)
	+ ', ISNULL(CONVERT(VARCHAR(25), SSCreatedDate, 101), ''01/01/1900'') SourceCreateDate' + CHAR(13)
	+ ', CAST(SSID as VARCHAR(200)) Custom1' + CHAR(13)
	+ ', CAST(''contact'' as VARCHAR(200)) Custom2' + CHAR(13)
	+ ', NULL Custom3, NULL Custom4' + CHAR(13)
	+ ', cast(IsBusiness as varchar(200)) Custom5' + CHAR(13)
	+ ', CAST(''True'' as VARCHAR(5)) RunContactMatch' + CHAR(13)
	+ ', SourceSystem' + CHAR(13)
	+ 'FROM ' + @ClientDB + '.dbo.DimCustomer' + CHAR(13)
	+ 'WHERE 1=1 ' + CHAR(13)
	+ 'AND (AddressPrimaryIsCleanStatus = ''Dirty''  or EmailPrimaryIsCleanStatus = ''Dirty'' or NameIsCleanStatus = ''Dirty'') ' + CHAR(13)
	+ 'AND IsDeleted = 0 ' + CHAR(13)

	+ 'UNION ALL' + CHAR(13)

	+ 'select ' + CHAR(13)
	+ 'CAST(SSID as VARCHAR(200)) SourceContactId' + CHAR(13)
	+ ', NULL Prefix' + CHAR(13)
	+ ', NULL FirstName' + CHAR(13)
	+ ', NULL MiddleName' + CHAR(13)
	+ ', NULL LastName' + CHAR(13)
	+ ', NULL Suffix' + CHAR(13)
	+ ', null FullName' + CHAR(13)
	+ ', ''addressone'' AddressType' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressOneStreet, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(500)) Address' + CHAR(13)
	+ ', Cast(REPLACE(REPLACE(REPLACE(AddressOneSuite, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as varchar(500)) Address2' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressOneCity, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(200)) City' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressOneState, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(200)) State' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressOneZip, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(25)) ZipCode' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressOneCounty, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(200)) County' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressOneCountry, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(200)) Country' + CHAR(13)
	+ ', NULL PhoneType' + CHAR(13)
	+ ', NULL Phone' + CHAR(13)
	+ ', NULL EmailType' + CHAR(13)
	+ ', NULL Email' + CHAR(13)
	+ ', Isnull(SourceSystemPriority, 0) SourcePriorityRank' + CHAR(13)
	+ ', ISNULL(CONVERT(VARCHAR(25), SSCreatedDate, 101), ''01/01/1900'') SourceCreateDate' + CHAR(13)
	+ ', CAST(SSID as VARCHAR(200)) Custom1' + CHAR(13)
	+ ', CAST(''addressone'' as VARCHAR(200)) Custom2' + CHAR(13)
	+ ', NULL Custom3, NULL Custom4, NULL Custom5' + CHAR(13)
	+ ', CAST(''False'' as VARCHAR(5)) RunContactMatch' + CHAR(13)
	+ ', SourceSystem' + CHAR(13)
	+ 'FROM ' + @ClientDB + '.dbo.DimCustomer' + CHAR(13)
	+ 'WHERE 1=1 ' + CHAR(13)
	+ 'AND AddressOneIsCleanStatus = ''Dirty'' AND IsDeleted = 0 ' + CHAR(13)

	+ 'UNION ALL ' + CHAR(13)

	+ 'select ' + CHAR(13)
	+ 'CAST(SSID as VARCHAR(200)) SourceContactId' + CHAR(13)
	+ ', NULL Prefix, NULL FirstName, NULL MiddleName, NULL LastName, NULL Suffix' + CHAR(13)
	+ ', null FullName' + CHAR(13)
	+ ', ''addresstwo'' AddressType' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressTwoStreet, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(500)) Address' + CHAR(13)
	+ ', Cast(REPLACE(REPLACE(REPLACE(AddressTwoSuite, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as varchar(500)) Address2' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressTwoCity, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(200)) City' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressTwoState, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(200)) State' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressTwoZip, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(25)) ZipCode' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressTwoCounty, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(200)) County' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressTwoCountry, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(200)) Country' + CHAR(13)
	+ ', NULL PhoneType, NULL Phone, NULL EmailType, NULL Email' + CHAR(13)
	+ ', Isnull(SourceSystemPriority, 0) SourcePriorityRank' + CHAR(13)
	+ ', ISNULL(CONVERT(VARCHAR(25), SSCreatedDate, 101), ''01/01/1900'') SourceCreateDate' + CHAR(13)
	+ ', CAST(SSID as VARCHAR(200)) Custom1' + CHAR(13)
	+ ', CAST(''addresstwo'' as VARCHAR(200)) Custom2' + CHAR(13)
	+ ', NULL Custom3, NULL Custom4, NULL Custom5' + CHAR(13)
	+ ', CAST(''False'' as VARCHAR(5)) RunContactMatch' + CHAR(13)
	+ ', SourceSystem' + CHAR(13)
	+ 'FROM ' + @ClientDB + '.dbo.DimCustomer' + CHAR(13)
	+ 'WHERE 1=1 ' + CHAR(13)
	+ 'AND AddressTwoIsCleanStatus = ''Dirty'' AND IsDeleted = 0 ' + CHAR(13)

	+ 'UNION ALL ' + CHAR(13)

	+ 'select ' + CHAR(13)
	+ 'CAST(SSID as VARCHAR(200)) SourceContactId' + CHAR(13)
	+ ', NULL Prefix, NULL FirstName, NULL MiddleName, NULL LastName, NULL Suffix' + CHAR(13)
	+ ',Null FullName' + CHAR(13)
	+ ', ''addressthree'' AddressType' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressThreeStreet, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(500)) Address' + CHAR(13)
	+ ', Cast(REPLACE(REPLACE(REPLACE(AddressThreeSuite, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as varchar(500)) Address2' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressThreeCity, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(200)) City' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressThreeState, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(200)) State' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressThreeZip, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(25)) ZipCode' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressThreeCounty, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(200)) County' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressThreeCountry, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(200)) Country' + CHAR(13)
	+ ', NULL PhoneType, NULL Phone, NULL EmailType, NULL Email' + CHAR(13)
	+ ', Isnull(SourceSystemPriority, 0) SourcePriorityRank' + CHAR(13)
	+ ', ISNULL(CONVERT(VARCHAR(25), SSCreatedDate, 101), ''01/01/1900'') SourceCreateDate' + CHAR(13)
	+ ', CAST(SSID as VARCHAR(200)) Custom1' + CHAR(13)
	+ ', CAST(''addressthree'' as VARCHAR(200)) Custom2' + CHAR(13)
	+ ', NULL Custom3, NULL Custom4, NULL Custom5' + CHAR(13)
	+ ', CAST(''False'' as VARCHAR(5)) RunContactMatch' + CHAR(13)
	+ ', SourceSystem' + CHAR(13)
	+ 'FROM ' + @ClientDB + '.dbo.DimCustomer' + CHAR(13)
	+ 'WHERE 1=1 ' + CHAR(13)
	+ 'AND AddressThreeIsCleanStatus = ''Dirty'' AND IsDeleted = 0 ' + CHAR(13)

	+ 'UNION ALL ' + CHAR(13)

	+ 'select ' + CHAR(13)
	+ 'CAST(SSID as VARCHAR(200)) SourceContactId' + CHAR(13)
	+ ', NULL Prefix, NULL FirstName, NULL MiddleName, NULL LastName, NULL Suffix' + CHAR(13)
	+ ', FullName FullName' + CHAR(13)
	+ ', ''addressfour'' AddressType' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressFourStreet, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(500)) Address' + CHAR(13)
	+ ', Cast(REPLACE(REPLACE(REPLACE(AddressFourSuite, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as varchar(500)) Address2' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressFourCity, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(200)) City' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressFourState, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(200)) State' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressFourZip, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(25)) ZipCode' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressFourCounty, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(200)) County' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressFourCountry, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(200)) Country' + CHAR(13)
	+ ', NULL PhoneType, NULL Phone, NULL EmailType, NULL Email' + CHAR(13)
	+ ', Isnull(SourceSystemPriority, 0) SourcePriorityRank' + CHAR(13)
	+ ', ISNULL(CONVERT(VARCHAR(25), SSCreatedDate, 101), ''01/01/1900'') SourceCreateDate' + CHAR(13)
	+ ', CAST(SSID as VARCHAR(200)) Custom1' + CHAR(13)
	+ ', CAST(''addressfour'' as VARCHAR(200)) Custom2' + CHAR(13)
	+ ', NULL Custom3, NULL Custom4, NULL Custom5' + CHAR(13)
	+ ', CAST(''False'' as VARCHAR(5)) RunContactMatch' + CHAR(13)
	+ ', SourceSystem' + CHAR(13)
	+ 'FROM ' + @ClientDB + '.dbo.DimCustomer' + CHAR(13)
	+ 'WHERE 1=1 ' + CHAR(13)
	+ 'AND AddressFourIsCleanStatus = ''Dirty'' AND IsDeleted = 0 ' + CHAR(13)
 
	+ 'UNION ALL' + CHAR(13)

	+ '/*Phone*/' + CHAR(13)
	+ 'select ' + CHAR(13)
	+ 'CAST(SSID as VARCHAR(200)) SourceContactId' + CHAR(13)
	+ ', NULL Prefix, NULL FirstName, NULL MiddleName, NULL LastName, NULL Suffix, NULL FullName, NULL AddressType, NULL Address, NULL Address2, NULL City, NULL State, NULL ZipCode, NULL County, NULL Country' + CHAR(13)
	+ ', ''phoneprimary'' PhoneType' + CHAR(13)
	+ ', CAST(PhonePrimary as VARCHAR(25)) Phone' + CHAR(13)
	+ ', NULL EmailType, NULL Email' + CHAR(13)
	+ ', Isnull(SourceSystemPriority, 0) SourcePriorityRank' + CHAR(13)
	+ ', ISNULL(CONVERT(VARCHAR(25), SSCreatedDate, 101), ''01/01/1900'') SourceCreateDate' + CHAR(13)
	+ ', CAST(SSID as VARCHAR(200)) Custom1' + CHAR(13)
	+ ', CAST(''phoneprimary'' as VARCHAR(200)) Custom2' + CHAR(13)
	+ ', NULL Custom3, NULL Custom4, NULL Custom5' + CHAR(13)
	+ ', CAST(''False'' as VARCHAR(5)) RunContactMatch' + CHAR(13)
	+ ', SourceSystem' + CHAR(13)
	+ 'FROM ' + @ClientDB + '.dbo.DimCustomer' + CHAR(13)
	+ 'WHERE 1=1 ' + CHAR(13)
	+ 'AND PhonePrimaryIsCleanStatus = ''Dirty'' AND IsDeleted = 0' + CHAR(13)

	+ 'UNION ALL' + CHAR(13)

	+ 'select ' + CHAR(13)
	+ 'CAST(SSID as VARCHAR(200)) SourceContactId' + CHAR(13)
	+ ', NULL Prefix, NULL FirstName, NULL MiddleName, NULL LastName, NULL Suffix, NULL FullName, NULL AddressType, NULL Address, NULL Address2, NULL City, NULL State, NULL ZipCode, NULL County, NULL Country' + CHAR(13)
	+ ', ''phonehome'' PhoneType' + CHAR(13)
	+ ', CAST(PhoneHome as VARCHAR(25)) Phone' + CHAR(13)
	+ ', NULL EmailType, NULL Email' + CHAR(13)
	+ ', Isnull(SourceSystemPriority, 0) SourcePriorityRank' + CHAR(13)
	+ ', ISNULL(CONVERT(VARCHAR(25), SSCreatedDate, 101), ''01/01/1900'') SourceCreateDate' + CHAR(13)
	+ ', CAST(SSID as VARCHAR(200)) Custom1' + CHAR(13)
	+ ', CAST(''phonehome'' as VARCHAR(200)) Custom2' + CHAR(13)
	+ ', NULL Custom3, NULL Custom4, NULL Custom5' + CHAR(13)
	+ ', CAST(''False'' as VARCHAR(5)) RunContactMatch' + CHAR(13)
	+ ', SourceSystem' + CHAR(13)
	+ 'FROM ' + @ClientDB + '.dbo.DimCustomer' + CHAR(13)
	+ 'WHERE 1=1 ' + CHAR(13)
	+ 'AND PhoneHomeIsCleanStatus = ''Dirty'' AND IsDeleted = 0  ' + CHAR(13)

	+ 'UNION ALL' + CHAR(13)

	+ 'select ' + CHAR(13)
	+ 'CAST(SSID as VARCHAR(200)) SourceContactId' + CHAR(13)
	+ ', NULL Prefix, NULL FirstName, NULL MiddleName, NULL LastName, NULL Suffix, NULL FullName, NULL AddressType, NULL Address, NULL Address2, NULL City, NULL State, NULL ZipCode, NULL County, NULL Country' + CHAR(13)
	+ ', ''phonecell'' PhoneType' + CHAR(13)
	+ ', CAST(PhoneCell as VARCHAR(25)) Phone' + CHAR(13)
	+ ', NULL EmailType, NULL Email' + CHAR(13)
	+ ', Isnull(SourceSystemPriority, 0) SourcePriorityRank' + CHAR(13)
	+ ', ISNULL(CONVERT(VARCHAR(25), SSCreatedDate, 101), ''01/01/1900'') SourceCreateDate' + CHAR(13)
	+ ', CAST(SSID as VARCHAR(200)) Custom1' + CHAR(13)
	+ ', CAST(''phonecell'' as VARCHAR(200)) Custom2' + CHAR(13)
	+ ', NULL Custom3, NULL Custom4, NULL Custom5' + CHAR(13)
	+ ', CAST(''False'' as VARCHAR(5)) RunContactMatch' + CHAR(13)
	+ ', SourceSystem' + CHAR(13)
	+ 'FROM ' + @ClientDB + '.dbo.DimCustomer' + CHAR(13)
	+ 'WHERE 1=1 ' + CHAR(13)
	+ 'AND PhoneCellIsCleanStatus = ''Dirty'' AND IsDeleted = 0 ' + CHAR(13)

	+ 'UNION ALL' + CHAR(13)

	+ 'select ' + CHAR(13)
	+ 'CAST(SSID as VARCHAR(200)) SourceContactId' + CHAR(13)
	+ ', NULL Prefix, NULL FirstName, NULL MiddleName, NULL LastName, NULL Suffix, NULL FullName, NULL AddressType, NULL Address, NULL Address2, NULL City, NULL State, NULL ZipCode, NULL County, NULL Country' + CHAR(13)
	+ ', ''phonefax'' PhoneType' + CHAR(13)
	+ ', CAST(PhoneFax as VARCHAR(25)) Phone' + CHAR(13)
	+ ', NULL EmailType, NULL Email' + CHAR(13)
	+ ', Isnull(SourceSystemPriority, 0) SourcePriorityRank' + CHAR(13)
	+ ', ISNULL(CONVERT(VARCHAR(25), SSCreatedDate, 101), ''01/01/1900'') SourceCreateDate' + CHAR(13)
	+ ', CAST(SSID as VARCHAR(200)) Custom1' + CHAR(13)
	+ ', CAST(''phonefax'' as VARCHAR(200)) Custom2' + CHAR(13)
	+ ', NULL Custom3, NULL Custom4, NULL Custom5' + CHAR(13)
	+ ', CAST(''False'' as VARCHAR(5)) RunContactMatch' + CHAR(13)
	+ ', SourceSystem' + CHAR(13)
	+ 'FROM ' + @ClientDB + '.dbo.DimCustomer' + CHAR(13)
	+ 'WHERE 1=1 ' + CHAR(13)
	+ 'AND PhoneFaxIsCleanStatus = ''Dirty'' AND IsDeleted = 0 ' + CHAR(13)

	+ 'UNION ALL' + CHAR(13)

	+ 'select ' + CHAR(13)
	+ 'CAST(SSID as VARCHAR(200)) SourceContactId' + CHAR(13)
	+ ', NULL Prefix, NULL FirstName, NULL MiddleName, NULL LastName, NULL Suffix, NULL FullName, NULL AddressType, NULL Address, NULL Address2, NULL City, NULL State, NULL ZipCode, NULL County, NULL Country' + CHAR(13)
	+ ', ''phoneother'' PhoneType' + CHAR(13)
	+ ', CAST(PhoneOther as VARCHAR(25)) Phone' + CHAR(13)
	+ ', NULL EmailType, NULL Email' + CHAR(13)
	+ ', Isnull(SourceSystemPriority, 0) SourcePriorityRank' + CHAR(13)
	+ ', ISNULL(CONVERT(VARCHAR(25), SSCreatedDate, 101), ''01/01/1900'') SourceCreateDate' + CHAR(13)
	+ ', CAST(SSID as VARCHAR(200)) Custom1' + CHAR(13)
	+ ', CAST(''phoneother'' as VARCHAR(200)) Custom2' + CHAR(13)
	+ ', NULL Custom3, NULL Custom4, NULL Custom5' + CHAR(13)
	+ ', CAST(''False'' as VARCHAR(5)) RunContactMatch' + CHAR(13)
	+ ', SourceSystem' + CHAR(13)
	+ 'FROM ' + @ClientDB + '.dbo.DimCustomer' + CHAR(13)
	+ 'WHERE 1=1 ' + CHAR(13)
	+ 'AND PhoneOtherIsCleanStatus = ''Dirty'' AND IsDeleted = 0 ' + CHAR(13)


/* MOVED TO CONTACT 
UNION ALL

/*Email  */
select 
CAST(SSID as VARCHAR(200)) SourceContactId
, NULL Prefix, NULL FirstName, NULL MiddleName, NULL LastName, NULL Suffix, NULL FullName, NULL AddressType, NULL Address, NULL Address2, NULL City, NULL State, NULL ZipCode, NULL County, NULL Country, NULL PhoneType, NULL Phone
, 'emailprimary' EmailType
, CAST(EmailPrimary as VARCHAR(256)) Email
, SourceSystemPriority SourcePriorityRank
, ISNULL(CONVERT(VARCHAR(25), SSCreatedDate, 101), '01/01/1900') SourceCreateDate
, CAST(SSID as VARCHAR(200)) Custom1
, CAST('emailprimary' as VARCHAR(200)) Custom2
, NULL Custom3, NULL Custom4, NULL Custom5
, CAST('False' as VARCHAR(5)) RunContactMatch
, SourceSystem
FROM dbo.DimCustomer
WHERE 1=1 
AND EmailPrimaryIsCleanStatus = 'Dirty' AND IsDeleted = 0
*/

	+ 'UNION ALL' + CHAR(13)

	+ 'select ' + CHAR(13)
	+ 'CAST(SSID as VARCHAR(200)) SourceContactId' + CHAR(13)
	+ ', NULL Prefix, NULL FirstName, NULL MiddleName, NULL LastName, NULL Suffix, NULL FullName, NULL AddressType, NULL Address, NULL Address2, NULL City, NULL State, NULL ZipCode, NULL County, NULL Country, NULL PhoneType, NULL Phone' + CHAR(13)
	+ ', ''emailone'' EmailType' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(EmailOne, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(256)) Email' + CHAR(13)
	+ ', Isnull(SourceSystemPriority, 0) SourcePriorityRank' + CHAR(13)
	+ ', ISNULL(CONVERT(VARCHAR(25), SSCreatedDate, 101), ''01/01/1900'') SourceCreateDate' + CHAR(13)
	+ ', CAST(SSID as VARCHAR(200)) Custom1' + CHAR(13)
	+ ', CAST(''emailone'' as VARCHAR(200)) Custom2' + CHAR(13)
	+ ', NULL Custom3, NULL Custom4, NULL Custom5' + CHAR(13)
	+ ', CAST(''False'' as VARCHAR(5)) RunContactMatch' + CHAR(13)
	+ ', SourceSystem' + CHAR(13)
	+ 'FROM ' + @ClientDB + '.dbo.DimCustomer' + CHAR(13)
	+ 'WHERE 1=1 ' + CHAR(13)
	+ 'AND EmailOneIsCleanStatus = ''Dirty'' AND IsDeleted = 0  ' + CHAR(13)

	+ 'UNION ALL' + CHAR(13)

	+ 'select ' + CHAR(13)
	+ 'CAST(SSID as VARCHAR(200)) SourceContactId' + CHAR(13)
	+ ', NULL Prefix, NULL FirstName, NULL MiddleName, NULL LastName, NULL Suffix, NULL FullName, NULL AddressType, NULL Address, NULL Address2, NULL City, NULL State, NULL ZipCode, NULL County, NULL Country, NULL PhoneType, NULL Phone' + CHAR(13)
	+ ', ''emailtwo'' EmailType' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(EmailTwo, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(256)) Email' + CHAR(13)
	+ ', Isnull(SourceSystemPriority, 0) SourcePriorityRank' + CHAR(13)
	+ ', ISNULL(CONVERT(VARCHAR(25), SSCreatedDate, 101), ''01/01/1900'') SourceCreateDate' + CHAR(13)
	+ ', CAST(SSID as VARCHAR(200)) Custom1' + CHAR(13)
	+ ', CAST(''emailtwo'' as VARCHAR(200)) Custom2' + CHAR(13)
	+ ', NULL Custom3, NULL Custom4, NULL Custom5' + CHAR(13)
	+ ', CAST(''False'' as VARCHAR(5)) RunContactMatch' + CHAR(13)
	+ ', SourceSystem' + CHAR(13)
	+ 'FROM ' + @ClientDB + '.dbo.DimCustomer' + CHAR(13)
	+ 'WHERE 1=1 ' + CHAR(13)
	+ 'AND EmailTwoIsCleanStatus = ''Dirty'' AND IsDeleted = 0   ' + CHAR(13)

	+ ')X' + CHAR(13)

		SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + '.mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''CleanDataWrite'', ''Records Output'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)

	SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + '.mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''CleanDataWrite'', ''End'', 0);'
SET @sql = @sql + CHAR(13) + CHAR(13)


--SELECT @sql
EXEC sp_executesql @sql

end


GO
