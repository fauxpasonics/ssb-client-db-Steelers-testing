SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_sync_DimTicketClass] AS (
	SELECT [DimTicketClassId]
     ,[TicketClassCode]
     ,[TicketClassName]
     ,[TicketClassDesc]
     ,[TicketClassGroup]
	 ,[TicketClassType]
     ,[CreatedBy]
     ,[UpdatedBy]
     ,[CreatedDate]
     ,[UpdatedDate]
     ,[IsDeleted]
     ,[DeletedDate]
     ,[DeltaHashKey]
     FROM dbo.DimTicketClass (NOLOCK)
)
GO
