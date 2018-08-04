CREATE TABLE [ods].[Snapshot_Nav_SubCategory]
(
[Nav_SubCategorySK] [int] NOT NULL IDENTITY(1, 1),
[ItemCategoryCode] [int] NULL,
[Code] [int] NULL,
[Description] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DivisionCode] [int] NULL,
[ETL_CreatedOn] [datetime] NULL,
[ETL_CreatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_UpdatedOn] [datetime] NULL,
[ETL_UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordEndDate] [datetime] NULL
)
GO
ALTER TABLE [ods].[Snapshot_Nav_SubCategory] ADD CONSTRAINT [PK__Snapshot__9B4D183C8458C5E6] PRIMARY KEY CLUSTERED  ([Nav_SubCategorySK])
GO
