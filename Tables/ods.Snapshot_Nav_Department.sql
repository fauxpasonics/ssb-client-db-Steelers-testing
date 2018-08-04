CREATE TABLE [ods].[Snapshot_Nav_Department]
(
[Nav_DepartmentSK] [int] NOT NULL IDENTITY(1, 1),
[Code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_CreatedOn] [datetime] NULL,
[ETL_CreatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_UpdatedOn] [datetime] NULL,
[ETL_UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordEndDate] [datetime] NULL
)
GO
ALTER TABLE [ods].[Snapshot_Nav_Department] ADD CONSTRAINT [PK__Snapshot__2AF5DAD55808776A] PRIMARY KEY CLUSTERED  ([Nav_DepartmentSK])
GO
