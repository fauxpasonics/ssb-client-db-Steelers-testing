SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[UpdateDimCustomerFromCDIOOutput] 
(
	@ClientDB varchar(50)
)
AS 
BEGIN


/*[etl].[UpdateDimCustomerFromCDIOOutput] 
* created: 
* modified:  12/11/2014 - Kwyss -- Moved the update of primary email and phone to the main contact record - related to changes to CleanDataWrite.
* modified:  04/20/2015 - GHolder -- Added @ClientDB parameter and updated sproc to use dynamic SQL
*
*
*/

IF (SELECT @@VERSION) LIKE '%Azure%'
BEGIN
SET @ClientDB = ''
END
ELSE
BEGIN
SET @ClientDB = @ClientDB + '.'
END

DECLARE 
	@sql NVARCHAR(MAX) = ' ' 

SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerFromCDIOoutput'', ''Start'', 0);'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql 
	+ 'BEGIN TRY' + CHAR(13)

		+ '	INSERT INTO ' + @ClientDB + 'archive.[CleanDataOutput] (BatchId, ContactId, ContactStatusCode, ContactStatus, SourceContactId, Prefix, FirstName, MiddleName, LastName, Suffix, Gender, Salutation, Address, Address2, Suite, City, State, ZipCode, Plus4, AddressCounty, AddressCountry, AddressCountyFips, AddressType, AddressDeliveryPoint, ZipLatitude, ZipLongitude, AreaCode, Phone, PhoneExtension, EmailAddress, NameStatus, AddressStatus, PhoneStatus, EmailStatus, Input_Prefix, Input_FirstName, Input_MiddleName, Input_LastName, Input_Suffix, Input_FullName, Input_AddressType, Input_Address, Input_Address2, Input_City, Input_State, Input_ZipCode, Input_AddressCounty, Input_AddressCountry, Input_PhoneType, Input_Phone, Input_EmailType, Input_Email, Input_SourcePriorityRank, Input_SourceCreateDate, Input_Custom1, Input_Custom2, Input_Custom3, Input_Custom4, Input_Custom5, RunContactMatch, Input_SourceSystem, ncoaAddress, ncoaAddress2, ncoaSuite, ncoaCity, ncoaState, ncoaZipCode, ncoaPlus4, ncoaAddressCounty, ncoaAddressCountry, ncoaAddressCountyFips, ncoaAddressType, ncoaAddressDeliveryPoint, ncoaZipLatitude, ncoaZipLongitude, ncoaMoveEffectiveDate, ETL_CreatedDate)' + CHAR(13)
		+ '	SELECT BatchId, ContactId, ContactStatusCode, ContactStatus, SourceContactId, Prefix, FirstName, MiddleName, LastName, Suffix, Gender, Salutation, Address, Address2, Suite, City, State, ZipCode, Plus4, AddressCounty, AddressCountry, AddressCountyFips, AddressType, AddressDeliveryPoint, ZipLatitude, ZipLongitude, AreaCode, Phone, PhoneExtension, EmailAddress, NameStatus, AddressStatus, PhoneStatus, EmailStatus, Input_Prefix, Input_FirstName, Input_MiddleName, Input_LastName, Input_Suffix, Input_FullName, Input_AddressType, Input_Address, Input_Address2, Input_City, Input_State, Input_ZipCode, Input_AddressCounty, Input_AddressCountry, Input_PhoneType, Input_Phone, Input_EmailType, Input_Email, Input_SourcePriorityRank, Input_SourceCreateDate, Input_Custom1, Input_Custom2, Input_Custom3, Input_Custom4, Input_Custom5, RunContactMatch, Input_SourceSystem, ncoaAddress, ncoaAddress2, ncoaSuite, ncoaCity, ncoaState, ncoaZipCode, ncoaPlus4, ncoaAddressCounty, ncoaAddressCountry, ncoaAddressCountyFips, ncoaAddressType, ncoaAddressDeliveryPoint, ncoaZipLatitude, ncoaZipLongitude, ncoaMoveEffectiveDate, GETDATE() ETL_CreatedDate' + CHAR(13)
		+ '	FROM ' + @ClientDB + 'dbo.CleanDataOutput' + CHAR(13)

SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerFromCDIOoutput'', ''Records Archived'', @@Rowcount);'
SET @sql = @sql + CHAR(13) + CHAR(13)

+ 'END TRY' + CHAR(13)
+ 'BEGIN CATCH' + CHAR(13)
+ ' PRINT @@ERROR' + CHAR(13)
+ 'END CATCH'
SET @sql = @sql + CHAR(13) + CHAR(13)													

SET @sql = @sql 
	+ '--update the primary address including the CDIO customer key' + CHAR(13)
	+ 'update ' + @ClientDB + 'dbo.DimCustomer' + CHAR(13)
	+ 'set[AddressPrimaryStreet] = cdio.address ' + CHAR(13)
	+ '	,[AddressPrimarySuite]  = isnull(cdio.Suite, cdio.address2)' + CHAR(13)
	+ '	,[AddressPrimaryCity]  = cdio.city' + CHAR(13)
	+ '	,[AddressPrimaryState] = cdio.state' + CHAR(13)
	+ '	,[AddressPrimaryZip] = cdio.zipcode' + CHAR(13)
	+ '	,[AddressPrimaryCounty] = cdio.addresscounty' + CHAR(13)
	+ '	,[AddressPrimaryCountry] = cdio.addresscountry' + CHAR(13)
	+ '	,[AddressPrimaryIsCleanStatus] = isnull(cast(AddressStatus as nvarchar(100)), ''notfound'')' + CHAR(13)
	+ '	--,[AddressPrimaryMasterId] [bigint] NULL,' + CHAR(13)
	+ '	,[ContactGUID] = ContactId' + CHAR(13)
	+ '	,[Prefix]  = cdio.prefix ' + CHAR(13)
	+ '	,[FirstName] = cdio.firstname' + CHAR(13)
	+ '	,[MiddleName] = cdio.middlename' + CHAR(13)
	+ '	,[LastName] = cdio.lastname' + CHAR(13)
	+ '	,[Suffix] = cdio.suffix' + CHAR(13)
	+ '	, Gender = cdio.Gender' + CHAR(13)
	+ '	,[NameIsCleanStatus] = isnull(cast(NameStatus as nvarchar(100)), ''notfound'')' + CHAR(13)
	+ '	,[AddressPrimaryNCOAStatus] = CASE WHEN ISNULL(cdio.ncoaMoveEffectiveDate,'''') = '''' THEN 0 ELSE 1 END' + CHAR(13)
	+ '	,[PhonePrimary] = cdio.phone' + CHAR(13)
	+ '	,[PhonePrimaryIsCleanStatus] = isnull(cdio.PhoneStatus, ''notfound'')' + CHAR(13)
	+ '	, [EmailPrimary] = cdio.emailaddress' + CHAR(13)
	+ '	,[EmailPrimaryIsCleanStatus] = isnull(cdio.EmailStatus,''notfound'')' + CHAR(13)
	+ '	---, [ExternalContactId] = case when isnull(ContactID, ''{00000000-0000-0000-0000-000000000000}'')  != ''{00000000-0000-0000-0000-000000000000}''  then ContactId else newID() end' + CHAR(13)
	+ '	, [UpdatedBy] = ''CI''' + CHAR(13)
	+ '	, [UpdatedDate] = current_timestamp' + CHAR(13)
	+ 'from ' + @ClientDB + 'dbo.CleanDataOutput cdio, ' + @ClientDB + 'dbo.DimCustomer dimcust' + CHAR(13)
	+ 'where cdio.sourcecontactid = dimcust.ssid AND cdio.Input_SourceSystem = dimcust.SourceSystem' + CHAR(13)
	+ '-- and cdio.Id BETWEEN @RowId AND @RowIdLoop' + CHAR(13)
	+ 'and Input_Custom2 = ''contact'''
SET @sql = @sql + CHAR(13) + CHAR(13)


SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerFromCDIOoutput'', ''Contact Records Updated'', @@Rowcount);'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql 
	+ '--update address one' + CHAR(13)
	+ 'update ' + @ClientDB + 'dbo.DimCustomer' + CHAR(13)
	+ 'set [AddressOneStreet] = cdio.address ' + CHAR(13)
	+ '	,[AddressOneSuite]  =  isnull(cdio.Suite, cdio.address2)' + CHAR(13)
	+ '	,[AddressOneCity] = cdio.city' + CHAR(13)
	+ '	,[AddressOneState] = cdio.state' + CHAR(13)
	+ '	,[AddressOneZip]  = cdio.zipcode' + CHAR(13)
	+ '	,[AddressOneCounty] =  cdio.addresscounty' + CHAR(13)
	+ '	,[AddressOneCountry]  = cdio.addresscountry' + CHAR(13)
	+ '	,[AddressOneIsCleanStatus]  = isnull(AddressStatus, ''notfound'')' + CHAR(13)
	+ '	--,[AddressOneMasterId] [bigint] NULL,' + CHAR(13)
	+ '	,[AddressOneStreetNCOAStatus] = CASE WHEN ISNULL(cdio.ncoaMoveEffectiveDate,'''') = '''' THEN 0 ELSE 1 END' + CHAR(13)
	+ '	, [UpdatedBy] = ''CI''' + CHAR(13)
	+ '	, [UpdatedDate] = current_timestamp' + CHAR(13)
	+ 'from ' + @ClientDB + 'dbo.CleanDataOutput cdio, ' + @ClientDB + 'dbo.DimCustomer dimcust' + CHAR(13)
	+ 'where cdio.sourcecontactid = dimcust.ssid AND cdio.Input_SourceSystem = dimcust.SourceSystem' + CHAR(13)
	+ '-- and cdio.Id BETWEEN @RowId AND @RowIdLoop' + CHAR(13)
	+ 'and Input_Custom2 = ''addressone''' 
SET @sql = @sql + CHAR(13) + CHAR(13)


SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerFromCDIOoutput'', ''Address One Updated'', @@Rowcount);'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql 
	+ '--update address two' + CHAR(13)
	+ 'update ' + @ClientDB + 'dbo.DimCustomer' + CHAR(13)
	+ 'set[AddressTwoStreet] =  cdio.address ' + CHAR(13)
	+ '	,[AddressTwoSuite]  =  isnull(cdio.Suite, cdio.address2)' + CHAR(13)
	+ '	,[AddressTwoCity] = cdio.city' + CHAR(13)
	+ '	,[AddressTwoState] = cdio.state' + CHAR(13)
	+ '	,[AddressTwoZip] = cdio.zipcode' + CHAR(13)
	+ '	,[AddressTwocounty] = cdio.addresscounty' + CHAR(13)
	+ '	,[AddressTwoCountry] = cdio.AddressCountry' + CHAR(13)
	+ '	,[AddressTwoIsCleanStatus] =isnull(AddressStatus, ''notfound'')' + CHAR(13)
	+ '	--,[AddressTwoMasterId] [bigint] NULL,' + CHAR(13)
	+ '	,[AddressTwoStreetNCOAStatus] = CASE WHEN ISNULL(cdio.ncoaMoveEffectiveDate,'''') = '''' THEN 0 ELSE 1 END' + CHAR(13)
	+ '	, [UpdatedBy] = ''CI''' + CHAR(13)
	+ '	, [UpdatedDate] = current_timestamp' + CHAR(13)
	+ 'from ' + @ClientDB + 'dbo.CleanDataOutput cdio, ' + @ClientDB + 'dbo.DimCustomer dimcust' + CHAR(13)
	+ 'where cdio.sourcecontactid = dimcust.ssid AND cdio.Input_SourceSystem = dimcust.SourceSystem ' + CHAR(13)
	+ '-- and cdio.Id BETWEEN @RowId AND @RowIdLoop' + CHAR(13)
	+ 'and Input_Custom2 = ''addresstwo'''
SET @sql = @sql + CHAR(13) + CHAR(13)


SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerFromCDIOoutput'', ''Address Two Updated'', @@Rowcount);'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql 
	+ '--update address three' + CHAR(13)
	+ 'update ' + @ClientDB + 'dbo.DimCustomer' + CHAR(13)
	+ 'set' + CHAR(13)
	+ '    [AddressThreeStreet] = cdio.address' + CHAR(13)
	+ '	,[AddressThreeSuite]  = isnull(cdio.Suite, cdio.address2)' + CHAR(13)
	+ '	,[AddressThreeCity] = cdio.city' + CHAR(13)
	+ '	,[AddressThreeState] =cdio.state' + CHAR(13)
	+ '	,[AddressThreeZip] = cdio.zipcode' + CHAR(13)
	+ '	,[AddressThreeCounty] = cdio.addresscounty' + CHAR(13)
	+ '	,[AddressThreeCountry]  = cdio.addresscountry' + CHAR(13)
	+ '	,[AddressThreeIsCleanStatus] = isnull(AddressStatus, ''notfound'')' + CHAR(13)
	+ '	--,[AddressThreeMasterId] [bigint] NULL,' + CHAR(13)
	+ '	,[AddressThreeStreetNCOAStatus] = CASE WHEN ISNULL(cdio.ncoaMoveEffectiveDate,'''') = '''' THEN 0 ELSE 1 END' + CHAR(13)
	+ '	, [UpdatedBy] = ''CI''' + CHAR(13)
	+ '	, [UpdatedDate] = current_timestamp' + CHAR(13)
	+ 'from ' + @ClientDB + 'dbo.CleanDataOutput cdio, ' + @ClientDB + 'dbo.DimCustomer dimcust' + CHAR(13)
	+ 'where cdio.sourcecontactid = dimcust.ssid AND cdio.Input_SourceSystem = dimcust.SourceSystem ' + CHAR(13)
	+ '-- and cdio.Id BETWEEN @RowId AND @RowIdLoop' + CHAR(13)
	+ 'and Input_Custom2 = ''addressthree''' 
SET @sql = @sql + CHAR(13) + CHAR(13)


SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerFromCDIOoutput'', ''Address Three Updated'', @@Rowcount);'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql 
	+ '--update address four' + CHAR(13)
	+ 'update ' + @ClientDB + 'dbo.DimCustomer' + CHAR(13)
	+ 'set' + CHAR(13)
	+ '[AddressFourStreet] = cdio.address ' + CHAR(13)
	+ '	,[AddressFourSuite]  =  isnull(cdio.Suite, cdio.address2)' + CHAR(13)
	+ '	,[AddressFourCity] = cdio.city' + CHAR(13)
	+ '	,[AddressFourState] =cdio.state' + CHAR(13)
	+ '	,[AddressFourZip] = cdio.zipcode' + CHAR(13)
	+ '	,[AddressFourCounty] = cdio.addresscounty' + CHAR(13)
	+ '	,[AddressFourCountry] = cdio.AddressCountry' + CHAR(13)
	+ '	,[AddressFourIsCleanStatus] = isnull(AddressStatus, ''notfound'')' + CHAR(13)
	+ '	--,[AddressFourMasterId] [bigint] NULL,' + CHAR(13)
	+ '	,[AddressFourStreetNCOAStatus] = CASE WHEN ISNULL(cdio.ncoaMoveEffectiveDate,'''') = '''' THEN 0 ELSE 1 END' + CHAR(13)
	+ '	, [UpdatedBy] = ''CI''' + CHAR(13)
	+ '	, [UpdatedDate] = current_timestamp' + CHAR(13)
	+ 'from ' + @ClientDB + 'dbo.CleanDataOutput cdio, ' + @ClientDB + 'dbo.DimCustomer dimcust' + CHAR(13)
	+ 'where cdio.sourcecontactid = dimcust.ssid AND cdio.Input_SourceSystem = dimcust.SourceSystem' + CHAR(13)
	+ '-- and cdio.Id BETWEEN @RowId AND @RowIdLoop' + CHAR(13)
	+ 'and Input_Custom2 = ''addressfour''' 
SET @sql = @sql + CHAR(13) + CHAR(13)


SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerFromCDIOoutput'', ''Address Four Updated'', @@Rowcount);'
SET @sql = @sql + CHAR(13) + CHAR(13)

/* --- Part of contact
SET @sql = @sql 
	+ '/*Standard Phone Entities*/' + CHAR(13)
	+ 'update dbo.DimCustomer' + CHAR(13)
	+ 'set' + CHAR(13)
	+ '[PhonePrimary] = cdio.phone' + CHAR(13)
	+ '	,[PhonePrimaryIsCleanStatus] = isnull(cdio.PhoneStatus, ''notfound'')' + CHAR(13)
	+ '	--[PhonePrimaryMasterId] [bigint] NULL,' + CHAR(13)
	+ '	, [UpdatedBy] = ''CI''' + CHAR(13)
	+ '	, [UpdatedDate] = current_timestamp' + CHAR(13)
	+ 'from dbo.CleanDataOutput cdio, dbo.DimCustomer dimcust' + CHAR(13)
	+ 'where cdio.sourcecontactid = dimcust.ssid AND cdio.Input_SourceSystem = dimcust.SourceSystem' + CHAR(13)
	+ '-- and cdio.Id BETWEEN @RowId AND @RowIdLoop' + CHAR(13)
	+ 'and Input_Custom2 = ''phoneprimary'''
SET @sql = @sql + CHAR(13) + CHAR(13)


SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerFromCDIOoutput'', ''Phone Primary Updated'', @@Rowcount);'
SET @sql = @sql + CHAR(13) + CHAR(13)
*/


SET @sql = @sql 
	+ 'update ' + @ClientDB + 'dbo.DimCustomer' + CHAR(13)
	+ 'set' + CHAR(13)
	+ '[PhoneHome] = cdio.phone' + CHAR(13)
	+ '	,[PhoneHomeIsCleanStatus] =isnull(cdio.PhoneStatus, ''notfound'')' + CHAR(13)
	+ '	--[PhoneHomeMasterId] [bigint] NULL,' + CHAR(13)
	+ '	, [UpdatedBy] = ''CI''' + CHAR(13)
	+ '	, [UpdatedDate] = current_timestamp' + CHAR(13)
	+ 'from ' + @ClientDB + 'dbo.CleanDataOutput cdio, ' + @ClientDB + 'dbo.DimCustomer dimcust' + CHAR(13)
	+ 'where cdio.sourcecontactid = dimcust.ssid AND cdio.Input_SourceSystem = dimcust.SourceSystem' + CHAR(13)
	+ '-- and cdio.Id BETWEEN @RowId AND @RowIdLoop' + CHAR(13)
	+ 'and Input_Custom2 = ''phonehome'''
SET @sql = @sql + CHAR(13) + CHAR(13)


SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerFromCDIOoutput'', ''Phone Home Updated'', @@Rowcount);'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql 
	+ 'update ' + @ClientDB + 'dbo.DimCustomer' + CHAR(13)
	+ 'set' + CHAR(13)
	+ '[PhoneCell]= cdio.phone' + CHAR(13)
	+ '	,[PhoneCellIsCleanStatus] = isnull(cdio.PhoneStatus, ''notfound'')' + CHAR(13)
	+ '	--[PhoneCellMasterId] [bigint] NULL,' + CHAR(13)
	+ '	, [UpdatedBy] = ''CI''' + CHAR(13)
	+ '	, [UpdatedDate] = current_timestamp' + CHAR(13)
	+ 'from ' + @ClientDB + 'dbo.CleanDataOutput cdio, ' + @ClientDB + 'dbo.DimCustomer dimcust' + CHAR(13)
	+ 'where cdio.sourcecontactid = dimcust.ssid AND cdio.Input_SourceSystem = dimcust.SourceSystem' + CHAR(13)
	+ '-- and cdio.Id BETWEEN @RowId AND @RowIdLoop' + CHAR(13)
	+ 'and Input_Custom2 = ''phonecell''' 
SET @sql = @sql + CHAR(13) + CHAR(13)


SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerFromCDIOoutput'', ''Phone Cell Updated'', @@Rowcount);'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql 
	+ 'update ' + @ClientDB + 'dbo.DimCustomer' + CHAR(13)
	+ 'set' + CHAR(13)
	+ '[PhoneBusiness] = cdio.phone' + CHAR(13)
	+ '	,[PhoneBusinessIsCleanStatus] = isnull(cdio.PhoneStatus, ''notfound'')' + CHAR(13)
	+ '	--[PhoneBusinessMasterId] [bigint] NULL,' + CHAR(13)
	+ '	, [UpdatedBy] = ''CI''' + CHAR(13)
	+ '	, [UpdatedDate] = current_timestamp' + CHAR(13)
	+ 'from ' + @ClientDB + 'dbo.CleanDataOutput cdio, ' + @ClientDB + 'dbo.DimCustomer dimcust' + CHAR(13)
	+ 'where cdio.sourcecontactid = dimcust.ssid AND cdio.Input_SourceSystem = dimcust.SourceSystem' + CHAR(13)
	+ '-- and cdio.Id BETWEEN @RowId AND @RowIdLoop' + CHAR(13)
	+ 'and Input_Custom2 = ''phonebusiness''' 
SET @sql = @sql + CHAR(13) + CHAR(13)


SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerFromCDIOoutput'', ''Phone Business Updated'', @@Rowcount);'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql 
	+ 'update ' + @ClientDB + 'dbo.DimCustomer' + CHAR(13)
	+ 'set' + CHAR(13)
	+ '[PhoneFax] = cdio.phone' + CHAR(13)
	+ '	,[PhoneFaxIsCleanStatus] = isnull(cdio.PhoneStatus, ''notfound'')' + CHAR(13)
	+ '	--[PhoneFaxMasterId] [bigint] NULL,' + CHAR(13)
	+ '	, [UpdatedBy] = ''CI''' + CHAR(13)
	+ '	, [UpdatedDate] = current_timestamp' + CHAR(13)
	+ 'from ' + @ClientDB + 'dbo.CleanDataOutput cdio, ' + @ClientDB + 'dbo.DimCustomer dimcust' + CHAR(13)
	+ 'where cdio.sourcecontactid = dimcust.ssid AND cdio.Input_SourceSystem = dimcust.SourceSystem' + CHAR(13)
	+ '-- and cdio.Id BETWEEN @RowId AND @RowIdLoop' + CHAR(13)
	+ 'and Input_Custom2 = ''phonefax'''
SET @sql = @sql + CHAR(13) + CHAR(13)


SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerFromCDIOoutput'', ''Phone Fax Updated'', @@Rowcount);'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql 
	+ 'update ' + @ClientDB + 'dbo.DimCustomer' + CHAR(13)
	+ 'set' + CHAR(13)
	+ '[PhoneOther] = cdio.phone' + CHAR(13)
	+ '	,[PhoneOtherIsCleanStatus] = isnull(cdio.PhoneStatus, ''notfound'')  ' + CHAR(13)
	+ '	--[PhoneOtherMasterId] [bigint] NULL,' + CHAR(13)
	+ '	, [UpdatedBy] = ''CI''' + CHAR(13)
	+ '	, [UpdatedDate] = current_timestamp' + CHAR(13)
	+ 'from ' + @ClientDB + 'dbo.CleanDataOutput cdio, ' + @ClientDB + 'dbo.DimCustomer dimcust' + CHAR(13)
	+ 'where cdio.sourcecontactid = dimcust.ssid AND cdio.Input_SourceSystem = dimcust.SourceSystem' + CHAR(13)
	+ '-- and cdio.Id BETWEEN @RowId AND @RowIdLoop' + CHAR(13)
	+ 'and Input_Custom2 = ''phoneother''' 
SET @sql = @sql + CHAR(13) + CHAR(13)


SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerFromCDIOoutput'', ''Phone Other Updated'', @@Rowcount);'
SET @sql = @sql + CHAR(13) + CHAR(13)


/*  MOVED TO CONTACT 

	/*Standard Email Entities*/
update dbo.DimCustomer
set
	[EmailPrimary] = cdio.emailaddress
	,[EmailPrimaryIsCleanStatus] = isnull(cdio.EmailStatus,'notfound')
--	[EmailPrimaryMasterId] [bigint] NULL,
, [UpdatedBy] = 'CI'
	, [UpdatedDate] = current_timestamp
from dbo.CleanDataOutput cdio, dbo.DimCustomer dimcust
where cdio.sourcecontactid = dimcust.ssid AND cdio.Input_SourceSystem = dimcust.SourceSystem
-- and cdio.Id BETWEEN @RowId AND @RowIdLoop
and Input_Custom2 = 'emailprimary'

*/


SET @sql = @sql 
	+ 'update ' + @ClientDB + 'dbo.DimCustomer' + CHAR(13)
	+ 'set' + CHAR(13)
	+ '[EmailOne] = cdio.emailaddress' + CHAR(13)
	+ '	,[EmailOneIsCleanStatus] =  isnull(cdio.EmailStatus,''notfound'')' + CHAR(13)
	+ '	--[EmailOneMasterId] [bigint] NULL,' + CHAR(13)
	+ '	, [UpdatedBy] = ''CI''' + CHAR(13)
	+ '	, [UpdatedDate] = current_timestamp' + CHAR(13)
	+ 'from ' + @ClientDB + 'dbo.CleanDataOutput cdio, ' + @ClientDB + 'dbo.DimCustomer dimcust' + CHAR(13)
	+ 'where cdio.sourcecontactid = dimcust.ssid AND cdio.Input_SourceSystem = dimcust.SourceSystem' + CHAR(13)
	+ '-- and cdio.Id BETWEEN @RowId AND @RowIdLoop' + CHAR(13)
	+ 'and Input_Custom2 = ''emailone''' 
SET @sql = @sql + CHAR(13) + CHAR(13)


SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerFromCDIOoutput'', ''Email One Updated'', @@Rowcount);'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql 
	+ 'update ' + @ClientDB + 'dbo.DimCustomer' + CHAR(13)
	+ 'set' + CHAR(13)
	+ '[EmailTwo] = cdio.emailaddress ' + CHAR(13)
	+ '	,[EmailTwoIsCleanStatus] =  isnull(cdio.EmailStatus,''notfound'') ' + CHAR(13)
	+ '	--[EmailTwoMasterId] [bigint] NULL,' + CHAR(13)
	+ '	, [UpdatedBy] = ''CI''' + CHAR(13)
	+ '	, [UpdatedDate] = current_timestamp' + CHAR(13)
	+ 'from ' + @ClientDB + 'dbo.CleanDataOutput cdio, ' + @ClientDB + 'dbo.DimCustomer dimcust' + CHAR(13)
	+ 'where cdio.sourcecontactid = dimcust.ssid AND cdio.Input_SourceSystem = dimcust.SourceSystem' + CHAR(13)
	+ '-- and cdio.Id BETWEEN @RowId AND @RowIdLoop' + CHAR(13)
	+ 'and Input_Custom2 = ''emailtwo'''


SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerFromCDIOoutput'', ''Email Two Updated'', @@Rowcount);'
SET @sql = @sql + CHAR(13) + CHAR(13)	

SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerFromCDIOoutput'', ''End'', 0);'
SET @sql = @sql + CHAR(13) + CHAR(13)
						
EXEC sp_executesql @sql

end



GO
