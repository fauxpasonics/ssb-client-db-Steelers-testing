SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_sync_DimPlanType] AS (

	SELECT DimPlanTypeId, PlanTypeCode, PlanTypeName, PlanTypeDesc, CreatedBy, UpdatedBy, CreatedDate, UpdatedDate, IsDeleted, DeletedDate
	FROM dbo.DimPlanType (NOLOCK)
)
GO
