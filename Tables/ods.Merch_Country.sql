CREATE TABLE [ods].[Merch_Country]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_UpdatedDate] [datetime] NOT NULL,
[ETL_IsDeleted] [bit] NOT NULL,
[ETL_DeletedDate] [datetime] NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[Id] [int] NULL,
[Name] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplayOrder] [int] NULL,
[LastTimeStamp] [binary] (8) NULL,
[AllowsBilling] [bit] NULL,
[AllowsShipping] [bit] NULL,
[TwoLetterIsoCode] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ThreeLetterIsoCode] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumericIsoCode] [int] NULL,
[SubjectToVat] [bit] NULL,
[Published] [bit] NULL,
[LimitedToStores] [bit] NULL
)
GO
