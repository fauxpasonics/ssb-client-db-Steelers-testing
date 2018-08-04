CREATE TABLE [dbo].[DimSeason]
(
[DimSeasonId] [int] NOT NULL IDENTITY(1, 1),
[DimArenaId] [int] NULL,
[SeasonCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SeasonName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SeasonDesc] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SeasonClass] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SeasonYear] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrevSeasonId] [int] NULL,
[SeasonStartDate] [date] NULL,
[SeasonEndDate] [date] NULL,
[ManifestId] [int] NULL,
[Active] [bit] NULL,
[SSCreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSUpdatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSCreatedDate] [datetime] NULL,
[SSUpdatedDate] [datetime] NULL,
[SSID] [int] NULL,
[SSID_season_id] [int] NULL,
[SourceSystem] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeltaHashKey] [binary] (32) NULL,
[CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_DimSeason_CreateDate] DEFAULT (getdate()),
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_DimSeason_UpdateDate] DEFAULT (getdate()),
[IsDeleted] [bit] NULL CONSTRAINT [DF_DimSeason_DeleteFlag] DEFAULT ((0)),
[DeleteDate] [datetime] NULL,
[Config_IsFactSalesEligible] [bit] NULL,
[Config_IsMultiYearSeason] [bit] NULL,
[Config_SeasonOrg] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Config_DefaultDimSeasonHeaderId] [int] NULL,
[Config_SeasonEventCntFSE] [int] NULL
)
GO
ALTER TABLE [dbo].[DimSeason] ADD CONSTRAINT [PK_DimSeason] PRIMARY KEY CLUSTERED  ([DimSeasonId])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_LoadKey] ON [dbo].[DimSeason] ([SourceSystem], [SSID_season_id])
GO
