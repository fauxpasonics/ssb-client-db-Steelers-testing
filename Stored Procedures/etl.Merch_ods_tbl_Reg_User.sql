SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Merch_ods_tbl_Reg_User]
(
	@BatchId INT = 0,
	@Options NVARCHAR(MAX) = null
)
AS 

BEGIN
/**************************************Comments***************************************
**************************************************************************************
Mod #:  1
Name:     SSBCLOUD\dhorstman
Date:     01/21/2016
Comments: Initial creation
*************************************************************************************/

DECLARE @RunTime DATETIME = GETDATE()

DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @ProcedureName nvarchar(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.Merch_tbl_Reg_User),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0'

/*Load Options into a temp table*/
SELECT Col1 AS OptionKey, Col2 as OptionValue INTO #Options FROM [dbo].[SplitMultiColumn](@Options, '=', ';')

/*Extract Options, default values set if the option is not specified*/	
DECLARE @DisableInsert nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableInsert'),'false')
DECLARE @DisableUpdate nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableUpdate'),'false')
DECLARE @DisableDelete nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableDelete'),'true')


BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Start', @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src DataSize', @SrcDataSize, @ExecutionId

SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey
,  ID, UserName, servicePlanID, serviceStatusID, Password, AuthCode, FirstName, LastName, Phone, Email, AddressID, shippingAddressID, shippingMethodID, paymentID, Marketing, date_Start, Score, Posts, shareEmail, shareLocation, sendCatalog, suspended, deleted, birthdate, emailBrowserTypeID, emailContentType, shareInfo, address1, address2, city, state, zip, country, emailStatus, hostID, emailSent, emailOpened, emailClicks, integration, mBoardAccount, mBoardStatus, pageSize, avatar, recentFirst, timeZone, mBoardMessage, bio, favoritePlayer, attendedGame, gender, informOffers, seasonTicketHolder, cardType, cardHolder, cardNumber, cardMonth, cardYear, cardZipCode, billingAgree, num1
INTO #SrcData
FROM (
	SELECT  ID, UserName, servicePlanID, serviceStatusID, Password, AuthCode, FirstName, LastName, Phone, Email, AddressID, shippingAddressID, shippingMethodID, paymentID, Marketing, date_Start, Score, Posts, shareEmail, shareLocation, sendCatalog, suspended, deleted, birthdate, emailBrowserTypeID, emailContentType, shareInfo, address1, address2, city, state, zip, country, emailStatus, hostID, emailSent, emailOpened, emailClicks, integration, mBoardAccount, mBoardStatus, pageSize, avatar, recentFirst, timeZone, mBoardMessage, bio, favoritePlayer, attendedGame, gender, informOffers, seasonTicketHolder, cardType, cardHolder, cardNumber, cardMonth, cardYear, cardZipCode, billingAgree, num1
	, ROW_NUMBER() OVER(PARTITION BY Id ORDER BY ETL_ID) RowRank
	FROM src.Merch_tbl_Reg_User
) a
WHERE RowRank = 1

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(address1),'DBNULL_TEXT') + ISNULL(RTRIM(address2),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),AddressID)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),attendedGame)),'DBNULL_BIT') + ISNULL(RTRIM(AuthCode),'DBNULL_TEXT') + ISNULL(RTRIM(avatar),'DBNULL_TEXT') + ISNULL(RTRIM(billingAgree),'DBNULL_TEXT') + ISNULL(RTRIM(birthdate),'DBNULL_TEXT') + ISNULL(RTRIM(cardHolder),'DBNULL_TEXT') + ISNULL(RTRIM(cardMonth),'DBNULL_TEXT') + ISNULL(RTRIM(cardNumber),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),cardType)),'DBNULL_INT') + ISNULL(RTRIM(cardYear),'DBNULL_TEXT') + ISNULL(RTRIM(cardZipCode),'DBNULL_TEXT') + ISNULL(RTRIM(city),'DBNULL_TEXT') + ISNULL(RTRIM(country),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),date_Start)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(10),deleted)),'DBNULL_BIT') + ISNULL(RTRIM(Email),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),emailBrowserTypeID)),'DBNULL_INT') + ISNULL(RTRIM(emailClicks),'DBNULL_TEXT') + ISNULL(RTRIM(emailContentType),'DBNULL_TEXT') + ISNULL(RTRIM(emailOpened),'DBNULL_TEXT') + ISNULL(RTRIM(emailSent),'DBNULL_TEXT') + ISNULL(RTRIM(emailStatus),'DBNULL_TEXT') + ISNULL(RTRIM(favoritePlayer),'DBNULL_TEXT') + ISNULL(RTRIM(FirstName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),gender)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),hostID)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),ID)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),informOffers)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),integration)),'DBNULL_BIT') + ISNULL(RTRIM(LastName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),Marketing)),'DBNULL_BIT') + ISNULL(RTRIM(mBoardAccount),'DBNULL_TEXT') + ISNULL(RTRIM(mBoardStatus),'DBNULL_TEXT') + ISNULL(RTRIM(num1),'DBNULL_TEXT') + ISNULL(RTRIM(pageSize),'DBNULL_TEXT') + ISNULL(RTRIM(Password),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),paymentID)),'DBNULL_INT') + ISNULL(RTRIM(Phone),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),Posts)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),recentFirst)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),Score)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),seasonTicketHolder)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),sendCatalog)),'DBNULL_BIT') + ISNULL(RTRIM(servicePlanID),'DBNULL_TEXT') + ISNULL(RTRIM(serviceStatusID),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),shareEmail)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),shareInfo)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),shareLocation)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),shippingAddressID)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),shippingMethodID)),'DBNULL_INT') + ISNULL(RTRIM(state),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),suspended)),'DBNULL_BIT') + ISNULL(RTRIM(timeZone),'DBNULL_TEXT') + ISNULL(RTRIM(UserName),'DBNULL_TEXT') + ISNULL(RTRIM(zip),'DBNULL_TEXT'))

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (Id)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE ods.Merch_tbl_Reg_User AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.Id = mySource.Id

WHEN MATCHED AND @DisableUpdate = 'false' AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
	 OR ISNULL(mySource.mBoardMessage,'') <> ISNULL(myTarget.mBoardMessage,'') OR ISNULL(mySource.bio,'') <> ISNULL(myTarget.bio,'') 
)
THEN UPDATE SET
       myTarget.[ETL_UpdatedDate] = @RunTime
     , myTarget.[ETL_IsDeleted] = 0
     , myTarget.[ETL_DeletedDate] = NULL
     , myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
     , myTarget.[ID] = mySource.[ID]
     , myTarget.[UserName] = mySource.[UserName]
     , myTarget.[servicePlanID] = mySource.[servicePlanID]
     , myTarget.[serviceStatusID] = mySource.[serviceStatusID]
     , myTarget.[Password] = mySource.[Password]
     , myTarget.[AuthCode] = mySource.[AuthCode]
     , myTarget.[FirstName] = mySource.[FirstName]
     , myTarget.[LastName] = mySource.[LastName]
     , myTarget.[Phone] = mySource.[Phone]
     , myTarget.[Email] = mySource.[Email]
     , myTarget.[AddressID] = mySource.[AddressID]
     , myTarget.[shippingAddressID] = mySource.[shippingAddressID]
     , myTarget.[shippingMethodID] = mySource.[shippingMethodID]
     , myTarget.[paymentID] = mySource.[paymentID]
     , myTarget.[Marketing] = mySource.[Marketing]
     , myTarget.[date_Start] = mySource.[date_Start]
     , myTarget.[Score] = mySource.[Score]
     , myTarget.[Posts] = mySource.[Posts]
     , myTarget.[shareEmail] = mySource.[shareEmail]
     , myTarget.[shareLocation] = mySource.[shareLocation]
     , myTarget.[sendCatalog] = mySource.[sendCatalog]
     , myTarget.[suspended] = mySource.[suspended]
     , myTarget.[deleted] = mySource.[deleted]
     , myTarget.[birthdate] = mySource.[birthdate]
     , myTarget.[emailBrowserTypeID] = mySource.[emailBrowserTypeID]
     , myTarget.[emailContentType] = mySource.[emailContentType]
     , myTarget.[shareInfo] = mySource.[shareInfo]
     , myTarget.[address1] = mySource.[address1]
     , myTarget.[address2] = mySource.[address2]
     , myTarget.[city] = mySource.[city]
     , myTarget.[state] = mySource.[state]
     , myTarget.[zip] = mySource.[zip]
     , myTarget.[country] = mySource.[country]
     , myTarget.[emailStatus] = mySource.[emailStatus]
     , myTarget.[hostID] = mySource.[hostID]
     , myTarget.[emailSent] = mySource.[emailSent]
     , myTarget.[emailOpened] = mySource.[emailOpened]
     , myTarget.[emailClicks] = mySource.[emailClicks]
     , myTarget.[integration] = mySource.[integration]
     , myTarget.[mBoardAccount] = mySource.[mBoardAccount]
     , myTarget.[mBoardStatus] = mySource.[mBoardStatus]
     , myTarget.[pageSize] = mySource.[pageSize]
     , myTarget.[avatar] = mySource.[avatar]
     , myTarget.[recentFirst] = mySource.[recentFirst]
     , myTarget.[timeZone] = mySource.[timeZone]
     , myTarget.[mBoardMessage] = mySource.[mBoardMessage]
     , myTarget.[bio] = mySource.[bio]
     , myTarget.[favoritePlayer] = mySource.[favoritePlayer]
     , myTarget.[attendedGame] = mySource.[attendedGame]
     , myTarget.[gender] = mySource.[gender]
     , myTarget.[informOffers] = mySource.[informOffers]
     , myTarget.[seasonTicketHolder] = mySource.[seasonTicketHolder]
     , myTarget.[cardType] = mySource.[cardType]
     , myTarget.[cardHolder] = mySource.[cardHolder]
     , myTarget.[cardNumber] = mySource.[cardNumber]
     , myTarget.[cardMonth] = mySource.[cardMonth]
     , myTarget.[cardYear] = mySource.[cardYear]
     , myTarget.[cardZipCode] = mySource.[cardZipCode]
     , myTarget.[billingAgree] = mySource.[billingAgree]
     , myTarget.[num1] = mySource.[num1]
     
WHEN NOT MATCHED BY SOURCE AND @DisableDelete = 'false' THEN DELETE

WHEN NOT MATCHED BY Target AND @DisableInsert = 'false'
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_IsDeleted]
     ,[ETL_DeletedDate]
     ,[ETL_DeltaHashKey]
     ,[ID]
     ,[UserName]
     ,[servicePlanID]
     ,[serviceStatusID]
     ,[Password]
     ,[AuthCode]
     ,[FirstName]
     ,[LastName]
     ,[Phone]
     ,[Email]
     ,[AddressID]
     ,[shippingAddressID]
     ,[shippingMethodID]
     ,[paymentID]
     ,[Marketing]
     ,[date_Start]
     ,[Score]
     ,[Posts]
     ,[shareEmail]
     ,[shareLocation]
     ,[sendCatalog]
     ,[suspended]
     ,[deleted]
     ,[birthdate]
     ,[emailBrowserTypeID]
     ,[emailContentType]
     ,[shareInfo]
     ,[address1]
     ,[address2]
     ,[city]
     ,[state]
     ,[zip]
     ,[country]
     ,[emailStatus]
     ,[hostID]
     ,[emailSent]
     ,[emailOpened]
     ,[emailClicks]
     ,[integration]
     ,[mBoardAccount]
     ,[mBoardStatus]
     ,[pageSize]
     ,[avatar]
     ,[recentFirst]
     ,[timeZone]
     ,[mBoardMessage]
     ,[bio]
     ,[favoritePlayer]
     ,[attendedGame]
     ,[gender]
     ,[informOffers]
     ,[seasonTicketHolder]
     ,[cardType]
     ,[cardHolder]
     ,[cardNumber]
     ,[cardMonth]
     ,[cardYear]
     ,[cardZipCode]
     ,[billingAgree]
     ,[num1]
     )
VALUES
     (@RunTime --ETL_CreatedDate
     ,@RunTime --ETL_UpdateddDate
     ,0 --ETL_DeletedDate
     ,NULL --ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
     ,mySource.[ID]
     ,mySource.[UserName]
     ,mySource.[servicePlanID]
     ,mySource.[serviceStatusID]
     ,mySource.[Password]
     ,mySource.[AuthCode]
     ,mySource.[FirstName]
     ,mySource.[LastName]
     ,mySource.[Phone]
     ,mySource.[Email]
     ,mySource.[AddressID]
     ,mySource.[shippingAddressID]
     ,mySource.[shippingMethodID]
     ,mySource.[paymentID]
     ,mySource.[Marketing]
     ,mySource.[date_Start]
     ,mySource.[Score]
     ,mySource.[Posts]
     ,mySource.[shareEmail]
     ,mySource.[shareLocation]
     ,mySource.[sendCatalog]
     ,mySource.[suspended]
     ,mySource.[deleted]
     ,mySource.[birthdate]
     ,mySource.[emailBrowserTypeID]
     ,mySource.[emailContentType]
     ,mySource.[shareInfo]
     ,mySource.[address1]
     ,mySource.[address2]
     ,mySource.[city]
     ,mySource.[state]
     ,mySource.[zip]
     ,mySource.[country]
     ,mySource.[emailStatus]
     ,mySource.[hostID]
     ,mySource.[emailSent]
     ,mySource.[emailOpened]
     ,mySource.[emailClicks]
     ,mySource.[integration]
     ,mySource.[mBoardAccount]
     ,mySource.[mBoardStatus]
     ,mySource.[pageSize]
     ,mySource.[avatar]
     ,mySource.[recentFirst]
     ,mySource.[timeZone]
     ,mySource.[mBoardMessage]
     ,mySource.[bio]
     ,mySource.[favoritePlayer]
     ,mySource.[attendedGame]
     ,mySource.[gender]
     ,mySource.[informOffers]
     ,mySource.[seasonTicketHolder]
     ,mySource.[cardType]
     ,mySource.[cardHolder]
     ,mySource.[cardNumber]
     ,mySource.[cardMonth]
     ,mySource.[cardYear]
     ,mySource.[cardZipCode]
     ,mySource.[billingAgree]
     ,mySource.[num1]
     )
;

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Complete', @ExecutionId

DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Merch_tbl_Reg_User WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Merch_tbl_Reg_User WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Insert Row Count', @MergeInsertRowCount, @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Update Row Count', @MergeUpdateRowCount, @ExecutionId


END TRY 
BEGIN CATCH 

	DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();
			
	PRINT @ErrorMessage
	EXEC etl.LogEventRecordDB @Batchid, 'Error', @ProcedureName, 'Merge Load', 'Merge Error', @ErrorMessage, @ExecutionId
	EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Complete', @ExecutionId

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Complete', @ExecutionId


END

GO
