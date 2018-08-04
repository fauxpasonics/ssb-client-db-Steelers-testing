CREATE TABLE [audit].[StandardLoadAuditLog]
(
[StandardLoadAuditLogID] [int] NOT NULL IDENTITY(1, 1),
[LoadDate] [datetime] NULL,
[LoadView] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoadGuid] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordCount] [int] NULL
)
GO
ALTER TABLE [audit].[StandardLoadAuditLog] ADD CONSTRAINT [PK__Standard__9174223282D0E0D8] PRIMARY KEY CLUSTERED  ([StandardLoadAuditLogID])
GO
