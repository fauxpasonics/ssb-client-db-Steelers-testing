SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [etl].[vw_sync_DimSalesCode] as (
	SELECT [DimSalesCodeId]
     ,[SalesCode]
     ,[SalesCodeName]
     ,[SalesCodeDesc]
     ,[SalesCodeClass]
     ,[IsHost]
     ,[SalesCodeStartDate]
     ,[SalesCodeEndDate]
     ,[SalesCodeStatus]
     ,[SSCreatedBy]
     ,[SSUpdatedBy]
     ,[SSCreatedDate]
     ,[SSUpdatedDate]
     ,[SSID]
     ,[SSID_sell_location_id]
     ,[SourceSystem]
     ,[DeltaHashKey]
     ,[CreatedBy]
     ,[UpdatedBy]
     ,[CreatedDate]
     ,[UpdatedDate]
     ,[IsDeleted]
     ,[DeleteDate]
     FROM dbo.DimSalesCode (NOLOCK)
)
GO
