CREATE TABLE [dbo].[DimPlanType]
(
[DimPlanTypeId] [int] NOT NULL IDENTITY(1, 1),
[PlanTypeCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlanTypeName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlanTypeDesc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NOT NULL,
[UpdatedDate] [datetime] NOT NULL,
[IsDeleted] [bit] NOT NULL,
[DeletedDate] [datetime] NULL
)
GO
ALTER TABLE [dbo].[DimPlanType] ADD CONSTRAINT [PK_DimPlanType] PRIMARY KEY CLUSTERED  ([DimPlanTypeId])
GO
