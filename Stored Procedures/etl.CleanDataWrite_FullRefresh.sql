SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[CleanDataWrite_FullRefresh] 
(
	@ClientDB varchar(50)
)
AS 

begin


/*[etl].[CleanDataWrite_FullRefresh] 
* created: 
* modified:  12/11/2014 - Kwyss -- will send all contacts (primary address, email, and phone through clean data for a refresh)
* modified:  04/20/2015 - GHolder -- Added @ClientDB parameter and updated sproc to use dynamic SQL
* modified: 09/17/2015 - GHolder -- Added Azure check for @ClientDB parameter per Kwyss
*
*/

--DECLARE @ClientDB VARCHAR(50) = 'PSP'

IF (SELECT @@VERSION) LIKE '%Azure%'
BEGIN
SET @ClientDB = ''
END

IF (SELECT @@VERSION) NOT LIKE '%Azure%'
BEGIN
SET @ClientDB = @ClientDB + '.'
END

DECLARE 
	@sql NVARCHAR(MAX) = ' ' + CHAR(13)

SET @sql = @sql 
	+ '/*Main Select to Cast Final Datatypes*/' + CHAR(13)
	+ 'SELECT' + CHAR(13)
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
	
	
+ ', CASE WHEN firstname IS NULL AND lastname IS NULL ' + CHAR(13)
+ 'AND charINDEX('','', fullname) > 0 AND CHARINDEX('','',fullname, charINDEX('','', fullname)+ 1 ) = 0' + CHAR(13)
+ 'THEN LTRIM(SUBSTRING(fullname, charINDEX('','', fullname) + 1, LEN(fullname) - charINDEX('','', fullname))) ' + CHAR(13)
+ 'ELSE' + CHAR(13)
+ ' CAST(REPLACE(REPLACE(REPLACE(FirstName, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(100))' + CHAR(13)
+ 'END AS firstname' + CHAR(13)

	+ ', CAST(REPLACE(REPLACE(REPLACE(MiddleName, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(100)) MiddleName' + CHAR(13)



	+ ',CASE WHEN firstname IS NULL AND lastname IS NULL  ' + CHAR(13)
	+ 'AND charINDEX('','', fullname) > 0 AND CHARINDEX('','',fullname, charINDEX('','', fullname)+ 1 ) = 0  ' + CHAR(13)
	+ 'THEN LEFT(fullname, charINDEX('','', fullname)- 1)  ' + CHAR(13)
	+ 'ELSE  ' + CHAR(13)
    + ' CAST(REPLACE(REPLACE(REPLACE(LastName, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(100)) ' + CHAR(13)
	+ 'END AS lastname  ' + CHAR(13)


	+ ', CAST(REPLACE(REPLACE(REPLACE(Suffix, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(25)) Suffix' + CHAR(13)

	+ ',CASE WHEN charINDEX('','', fullname) > 0 AND CHARINDEX('','',fullname, charINDEX('','', fullname)+ 1 ) = 0 THEN NULL ELSE ' + CHAR(13)
	 + 'REPLACE(REPLACE(REPLACE(FullName, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') end as FullName' + CHAR(13)
	+ ', ''addressprimary'' AddressType' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressPrimaryStreet, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(500)) Address' + CHAR(13)
	+ ', Cast(REPLACE(REPLACE(REPLACE(AddressPrimarySuite, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as varchar(500)) Address2' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressPrimaryCity, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(200)) City' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressPrimaryState, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(200)) State' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressPrimaryZip, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(25)) ZipCode' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressPrimaryCounty, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(200)) County' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(AddressPrimaryCountry, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(200)) Country' + CHAR(13)
	+ ', ''phoneprimary'' PhoneType' + CHAR(13)
	+ ', CAST(REPLACE(REPLACE(REPLACE(PhonePrimary, CHAR(13), '' ''), CHAR(10), '' ''), CHAR(9), '' '') as VARCHAR(25)) Phone' + CHAR(13)
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
	+ 'FROM ' + @ClientDB + 'dbo.DimCustomer' + CHAR(13)
	+ 'WHERE 1=1 ' + CHAR(13)
	+ ' AND IsDeleted = 0 ' + CHAR(13)
	+ ')X' + CHAR(13)

--SELECT @sql

EXEC sp_executesql @sql

end

GO
