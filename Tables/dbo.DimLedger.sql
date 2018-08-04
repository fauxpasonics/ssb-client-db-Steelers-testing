CREATE TABLE [dbo].[DimLedger]
(
[DimLedgerId] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_UpdatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_UpdatedDate] [datetime] NOT NULL,
[ETL_SSID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_SSID_ledger_id] [int] NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[ETL_SourceSystem] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LedgerCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LedgerName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LedgerClass] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NULL,
[gl_code_payment] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[gl_code_refund] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[add_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[add_datetime] [datetime] NULL,
[upd_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[upd_datetime] [datetime] NULL
)
GO
ALTER TABLE [dbo].[DimLedger] ADD CONSTRAINT [PK__DimLedge__D3261CC3A3CEE86D] PRIMARY KEY CLUSTERED  ([DimLedgerId])
GO
