CREATE TABLE [ods].[TM_Audit_Export]
(
[id] [bigint] NOT NULL IDENTITY(1, 1),
[event_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[price_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[price_code_Desc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Plan] [int] NULL,
[Single] [int] NULL,
[Group] [int] NULL,
[Comp] [int] NULL,
[Held] [int] NULL,
[Avail] [int] NULL,
[Kill] [int] NULL,
[Revenue] [decimal] (18, 6) NULL,
[pc_price_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuditHostSold] [int] NULL,
[AuditArchticsSold] [int] NULL,
[TicketArchticsSold] [int] NULL,
[TicketHostSold] [int] NULL,
[TicketAvailSold] [int] NULL,
[DiffHostSold] [int] NULL,
[DiffArchticsSold] [int] NULL,
[event_id] [int] NULL,
[export_datetime] [datetime] NULL,
[source_id] [int] NULL,
[InsertDate] [datetime] NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [ods].[TM_Audit_Export] ADD CONSTRAINT [PK__TM_Audit__3213E83F2BF6A9E2] PRIMARY KEY CLUSTERED  ([id])
GO
