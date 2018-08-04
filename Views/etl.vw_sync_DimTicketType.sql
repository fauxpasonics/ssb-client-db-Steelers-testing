SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_sync_DimTicketType] AS (

	SELECT DimTicketTypeId, TicketTypeCode, TicketTypeName, TicketTypeDesc, TicketTypeClass, CreatedBy, UpdatedBy, CreatedDate, UpdatedDate, IsDeleted, DeletedDate
	FROM dbo.DimTicketType (NOLOCK)
)
GO
