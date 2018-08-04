CREATE TABLE [src].[Merch_StateProvince]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[Id] [int] NULL,
[Name] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplayOrder] [int] NULL,
[LastTimeStamp] [binary] (8) NULL,
[CountryId] [int] NULL,
[Abbreviation] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Published] [bit] NULL
)
GO
