SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [etl].[LoadDimPOSAccount]
AS 

BEGIN

SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey
,  ETL_SSID, ETL_SSID_Id, Id, Prefix, FirstName, MiddleName, LastName, Suffix, Username, Email, Phone, Gender, IsActive, AccountType, IsLoyaltyMember, LoyaltyId, CreatedDate, UpdatedDate
INTO #SrcData
FROM (
	SELECT  ETL_SSID, ETL_SSID_Id, Id, Prefix, FirstName, MiddleName, LastName, Suffix, Username, Email, Phone, Gender, Active as IsActive, AccountType, IsLoyaltyMember, LoyaltyId, CreatedDate, UpdatedDate
	, ROW_NUMBER() OVER(PARTITION BY ETL_SSID ORDER BY ETL_ID) RowRank
	FROM ods.vw_Merch_LoadDimPOSAccount
	WHERE ETL_UpdatedDate > DATEADD(day,-3,GETDATE())
) a
WHERE RowRank = 1;

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(AccountType),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),IsActive)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(25),CreatedDate)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(10),ETL_SSID)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),ETL_SSID_Id)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),Gender)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),Id)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),IsLoyaltyMember)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),LoyaltyId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),MiddleName)),'DBNULL_INT') + ISNULL(RTRIM(Phone),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),Prefix)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),Suffix)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(25),UpdatedDate)),'DBNULL_DATETIME') + ISNULL(RTRIM(Username),'DBNULL_TEXT'));

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (ETL_SSID);
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey);

MERGE dbo.DimPOSAccount AS myTarget
USING (
	SELECT * FROM #SrcData
) AS mySource
ON myTarget.ETL_SSID = mySource.ETL_SSID

WHEN MATCHED AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
	 OR ISNULL(mySource.FirstName,'') <> ISNULL(myTarget.FirstName,'') OR ISNULL(mySource.LastName,'') <> ISNULL(myTarget.LastName,'') OR ISNULL(mySource.Email,'') <> ISNULL(myTarget.Email,'') 
)
THEN UPDATE SET
       myTarget.[ETL_UpdatedDate] = GETDATE()
     , myTarget.[ETL_IsDeleted] = 0
     , myTarget.[ETL_DeletedDate] = NULL
     , myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
	 , myTarget.ETL_SSID = mySource.ETL_SSID
	 , myTarget.ETL_SSID_Id = mySource.ETL_SSID_Id
     , myTarget.[Id] = mySource.[Id]
     , myTarget.[Prefix] = mySource.[Prefix]
     , myTarget.[FirstName] = mySource.[FirstName]
     , myTarget.[MiddleName] = mySource.[MiddleName]
     , myTarget.[LastName] = mySource.[LastName]
     , myTarget.[Suffix] = mySource.[Suffix]
     , myTarget.[Username] = mySource.[Username]
     , myTarget.[Email] = mySource.[Email]
     , myTarget.[Phone] = mySource.[Phone]
     , myTarget.[Gender] = mySource.[Gender]
     , myTarget.[IsActive] = mySource.[IsActive]
     , myTarget.[AccountType] = mySource.[AccountType]
     , myTarget.[IsLoyaltyMember] = mySource.[IsLoyaltyMember]
     , myTarget.[LoyaltyId] = mySource.[LoyaltyId]
     , myTarget.[CreatedDate] = mySource.[CreatedDate]
     , myTarget.[UpdatedDate] = mySource.[UpdatedDate]
     

WHEN NOT MATCHED BY Target
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_IsDeleted]
     ,[ETL_DeletedDate]
     ,[ETL_SourceSystem]
     ,[ETL_DeltaHashKey]
     ,[ETL_SSID]
     ,[ETL_SSID_Id]
     ,[Id]
     ,[Prefix]
     ,[FirstName]
     ,[MiddleName]
     ,[LastName]
     ,[Suffix]
     ,[Username]
     ,[Email]
     ,[Phone]
     ,[Gender]
     ,[IsActive]
     ,[AccountType]
     ,[IsLoyaltyMember]
     ,[LoyaltyId]
     ,[CreatedDate]
     ,[UpdatedDate]
     )
VALUES
     (GETDATE() --ETL_CreatedDate
     ,GETDATE() --ETL_UpdateddDate
     ,0 --ETL_DeletedDate
     ,NULL --ETL_DeletedDate
     ,'Merch' --SourceSystem
     ,mySource.[ETL_DeltaHashKey]
	 ,mySource.ETL_SSID
	 ,mySource.ETL_SSID_Id
     ,mySource.[Id]
     ,mySource.[Prefix]
     ,mySource.[FirstName]
     ,mySource.[MiddleName]
     ,mySource.[LastName]
     ,mySource.[Suffix]
     ,mySource.[Username]
     ,mySource.[Email]
     ,mySource.[Phone]
     ,mySource.[Gender]
     ,mySource.[IsActive]
     ,mySource.[AccountType]
     ,mySource.[IsLoyaltyMember]
     ,mySource.[LoyaltyId]
     ,mySource.[CreatedDate]
     ,mySource.[UpdatedDate]
     )
;


END



GO
