CREATE TABLE [audit].[TM_AuditSets]
(
[ETL_TM_AuditSetId] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_BatchId] [int] NOT NULL,
[TM_AuditFileDate] [datetime] NULL,
[TM_AuditSourceFile] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DW_AuditData_IsLoaded] [bit] NOT NULL,
[AuditThresholdFail] [bit] NOT NULL,
[Notes] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [audit].[TM_AuditSets] ADD CONSTRAINT [PK__TM_Audit__B0AF26A62F314E21] PRIMARY KEY CLUSTERED  ([ETL_TM_AuditSetId])
GO
