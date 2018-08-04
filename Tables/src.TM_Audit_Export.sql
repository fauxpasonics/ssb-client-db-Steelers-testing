CREATE TABLE [src].[TM_Audit_Export]
(
[event_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[price_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[price_code_Desc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Plan] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Single] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Group] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Comp] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Held] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Avail] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Kill] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Revenue] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pc_price_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuditHostSold] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuditArchticsSold] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TicketArchticsSold] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TicketHostSold] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TicketAvailSold] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DiffHostSold] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DiffArchticsSold] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[event_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[export_datetime] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[source_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
