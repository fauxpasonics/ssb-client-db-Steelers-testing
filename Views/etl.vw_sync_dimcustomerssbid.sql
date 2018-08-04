SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [etl].[vw_sync_dimcustomerssbid] as (
	SELECT [DimCustomerSSBID]
     ,[DimCustomerId]
     ,[NameAddr_ID]
     ,[NameEmail_id]
     ,[Composite_ID]
     ,[SSB_CRMSYSTEM_ACCT_ID]
     ,[SSB_CRMSYSTEM_CONTACT_ID]
     ,[SSB_CRMSYSTEM_PRIMARY_FLAG]
     ,[CreatedBy]
     ,[UpdatedBy]
     ,[CreatedDate]
     ,[UpdatedDate]
     ,[IsDeleted]
     ,[DeleteDate]
     ,[SSID]
     ,[SourceSystem]
     ,[SSB_CRMSYSTEM_ACCT_PRIMARY_FLAG]
     ,[NamePhone_ID]
     ,[ssb_crmsystem_contactacct_id]
     FROM dbo.dimcustomerssbid (NOLOCK)
)
GO
