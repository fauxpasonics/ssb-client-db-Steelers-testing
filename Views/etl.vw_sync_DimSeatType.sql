SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_sync_DimSeatType] AS (

	SELECT DimSeatTypeId, SeatTypeCode, SeatTypeName, SeatTypeDesc, CreatedBy, UpdatedBy, CreatedDate, UpdatedDate, IsDeleted, DeletedDate
	FROM dbo.DimSeatType (NOLOCK)
)
GO
