SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[UpdateDimCustomerPrepForCD] 
(
	@ClientDB varchar(50)
)
WITH RECOMPILE
as
BEGIN

/*[etl].[UpdateDimCustomerPrepForCD] 
* created: 
* modified:  12/11/2014 - Kwyss -- Procedure was excluding records without a full name from running through clean data.  
*		Removed this exclusion as records without a name are still marketable
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
	+ 'values (current_timestamp, ''UpdateDimCustomerPrepForCD'', ''Start'', 0);'
SET @sql = @sql + CHAR(13) + CHAR(13)

set @sql = @sql 
+ 'delete from ' + @ClientDB + '.dbo.dimcustomerssbid where dimcustomerssbid in ( ' + CHAR(13)
+ 'select dimcustomerssbid from ' + @ClientDB + '.dbo.dimcustomerssbid a ' + CHAR(13)
+ 'left join ' + @ClientDB + '.dbo.dimcustomer b ' + CHAR(13)
+ 'on a.dimcustomerid = b.dimcustomerid ' + CHAR(13)
+ 'where b.dimcustomerid is null or b.isdeleted = 1) ' + CHAR(13)
SET @sql = @sql + CHAR(13) + CHAR(13)
SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + '.mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerPrepForCD'', ''Cleanup deleted records from dimcustomerssbid'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)

set @sql = @sql 
+ 'delete from ' + @ClientDB + '.dbo.dimcustomerssbid where dimcustomerssbid in ( ' + CHAR(13)
+ 'select dimcustomerssbid from ' + @ClientDB + '.dbo.dimcustomerssbid a ' + CHAR(13)
+ 'inner join ' + @ClientDB + '.dbo.dimcustomer b ' + CHAR(13)
+ 'on a.dimcustomerid = b.dimcustomerid  ' + CHAR(13)
+ 'where a.ssid != b.ssid or a.sourcesystem != b.sourcesystem); ' + CHAR(13)
SET @sql = @sql + CHAR(13) + CHAR(13)
SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + '.mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerPrepForCD'', ''Cleanup mismatch records from dimcustomerssbid'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)

/*Set Any Records NOT in DIMCUSTOMERSSBID to DIRTY*/
SET @sql = @sql 
	+ 'UPDATE ' + @ClientDB + '.dbo.DimCustomer' + CHAR(13)
	+ 'SET AddressPrimaryIsCleanStatus = ''Dirty''' + CHAR(13)
	+ ', NameIsCleanStatus = ''dirty''' + CHAR(13)
	+ ', EmailPrimaryIsCleanStatus = ''Dirty''' + CHAR(13)
	+ ', PhonePrimaryISCleanStatus = ''Dirty''' + CHAR(13)
	+ 'WHERE dimcustomerid IN (' + CHAR(13)
	+ '	SELECT a.DimCustomerId' + CHAR(13)
	+ '	FROM ' + @ClientDB + '.dbo.dimcustomer a' + CHAR(13)
	+ '	LEFT JOIN ' + @ClientDB + '.dbo.dimcustomerssbid b' + CHAR(13)
	+ '	ON a.dimcustomerid = b.DimCustomerId' + CHAR(13)
	+ '	WHERE b.dimcustomerid IS NULL and a.isdeleted = 0' + CHAR(13)
	+ ');'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + '.mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerPrepForCD'', ''Records not in dimcustomerssbid'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)

/******************
** Address
*******************/
SET @sql = @sql
	+ 'UPDATE ' + @ClientDB + '.dbo.DimCustomer ' + CHAR(13)
	+ 'SET AddressPrimaryIsCleanStatus = ''Bad''' + CHAR(13)
	+ 'WHERE AddressPrimaryIsCleanStatus = ''Dirty''' + CHAR(13)
	+ 'AND (AddressPrimaryStreet IS NULL OR RTRIM(AddressPrimaryStreet) = '''');'
SET @sql = @sql + CHAR(13) + CHAR(13)


SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + '.mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerPrepForCD'', ''Bad Primary Address'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)


SET @sql = @sql
	+ 'UPDATE ' + @ClientDB + '.dbo.DimCustomer SET AddressOneIsCleanStatus = ''N/A''' + CHAR(13)
	+ 'WHERE AddressOneIsCleanStatus = ''Dirty''' + CHAR(13)
	+ 'AND (AddressOneStreet IS NULL OR RTRIM(AddressOneStreet) = '''');'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + '.mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerPrepForCD'', ''No Address One'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql
	+ 'UPDATE ' + @ClientDB + '.dbo.DimCustomer SET AddressTwoIsCleanStatus = ''N/A''' + CHAR(13)
	+ 'WHERE AddressTwoIsCleanStatus = ''Dirty''' + CHAR(13)
	+ 'AND (AddressTwoStreet IS NULL OR RTRIM(AddressTwoStreet) = '''');'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + '.mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerPrepForCD'', ''No Address Two'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql
	+ 'UPDATE ' + @ClientDB + '.dbo.DimCustomer SET AddressThreeIsCleanStatus = ''N/A''' + CHAR(13)
	+ 'WHERE AddressThreeIsCleanStatus = ''Dirty''' + CHAR(13)
	+ 'AND (AddressThreeStreet IS NULL OR RTRIM(AddressThreeStreet) = '''');'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + '.mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerPrepForCD'', ''No Address Three'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql
	+ 'UPDATE ' + @ClientDB + '.dbo.DimCustomer SET AddressFourIsCleanStatus = ''N/A''' + CHAR(13)
	+ 'WHERE AddressFourIsCleanStatus = ''Dirty''' + CHAR(13)
	+ 'AND (AddressFourStreet IS NULL OR RTRIM(AddressFourStreet) = '''');'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + '.mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerPrepForCD'', ''No Address Four'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)

/******************
** Phone
*******************/
SET @sql = @sql
	+ 'UPDATE ' + @ClientDB + '.dbo.DimCustomer SET PhonePrimaryIsCleanStatus = ''Bad''' + CHAR(13)
	+ 'WHERE PhonePrimaryIsCleanStatus = ''Dirty''' + CHAR(13)
	+ 'AND (PhonePrimary IS NULL OR RTRIM(PhonePrimary) = '''');'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + '.mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerPrepForCD'', ''Bad Primary Phone'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql
	+ 'UPDATE ' + @ClientDB + '.dbo.DimCustomer SET PhoneHomeIsCleanStatus = ''N/A''' + CHAR(13)
	+ 'WHERE PhoneHomeIsCleanStatus = ''Dirty''' + CHAR(13)
	+ 'AND (PhoneHome IS NULL OR RTRIM(PhoneHome) = '''');'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + '.mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerPrepForCD'', ''No Phone Home'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql
	+ 'UPDATE ' + @ClientDB + '.dbo.DimCustomer SET PhoneCellIsCleanStatus = ''N/A''' + CHAR(13)
	+ 'WHERE PhoneCellIsCleanStatus = ''Dirty''' + CHAR(13)
	+ 'AND (PhoneCell IS NULL OR RTRIM(PhoneCell) = '''');'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + '.mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerPrepForCD'', ''No Phone Cell'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql
+ 'UPDATE ' + @ClientDB + '.dbo.DimCustomer SET PhoneBusinessIsCleanStatus = ''N/A''' + CHAR(13)
+ 'WHERE PhoneBusinessIsCleanStatus = ''Dirty''' + CHAR(13)
+ 'AND (PhoneBusiness IS NULL OR RTRIM(PhoneBusiness) = '''');'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + '.mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerPrepForCD'', ''No Phone Business'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql
+ 'UPDATE ' + @ClientDB + '.dbo.DimCustomer SET PhoneFaxIsCleanStatus = ''N/A''' + CHAR(13)
+ 'WHERE PhoneFaxIsCleanStatus = ''Dirty''' + CHAR(13)
+ 'AND (PhoneFax IS NULL OR RTRIM(PhoneFax) = '''');'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + '.mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerPrepForCD'', ''No Phone Fax'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql
+ 'UPDATE ' + @ClientDB + '.dbo.DimCustomer SET PhoneOtherIsCleanStatus = ''N/A''' + CHAR(13)
+ 'WHERE PhoneOtherIsCleanStatus = ''Dirty''' + CHAR(13)
+ 'AND (PhoneOther IS NULL OR RTRIM(PhoneOther) = '''');'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + '.mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerPrepForCD'', ''No Phone Other'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)

/******************
** Email
*******************/
SET @sql = @sql
+ 'UPDATE ' + @ClientDB + '.dbo.DimCustomer ' + CHAR(13)
+ 'SET EmailPrimaryIsCleanStatus = ''Bad''' + CHAR(13)
+ 'WHERE EmailPrimaryIsCleanStatus = ''Dirty''' + CHAR(13)
+ 'AND (EmailPrimary IS NULL OR RTRIM(EmailPrimary) = '''');' 
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + '.mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerPrepForCD'', ''Bad Email Primary'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql
+ 'UPDATE ' + @ClientDB + '.dbo.DimCustomer SET EmailOneIsCleanStatus = ''N/A''' + CHAR(13)
+ 'WHERE EmailOneIsCleanStatus = ''Dirty''' + CHAR(13)
+ 'AND (EmailOne IS NULL OR RTRIM(EmailOne) = '''');'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + '.mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerPrepForCD'', ''No Email One'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql
+ 'UPDATE ' + @ClientDB + '.dbo.DimCustomer SET EmailTwoIsCleanStatus = ''N/A''' + CHAR(13)
+ 'WHERE EmailTwoIsCleanStatus = ''Dirty''' + CHAR(13)
+ 'AND (EmailTwo IS NULL OR RTRIM(EmailTwo) = '''');'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + '.mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerPrepForCD'', ''No Email Two'', @@ROWCOUNT);'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql 
	+ 'Insert into ' + @ClientDB + '.mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''UpdateDimCustomerPrepForCD'', ''End'', 0);'
SET @sql = @sql + CHAR(13) + CHAR(13)

--SELECT @sql

EXEC sp_executesql @sql



END





GO
