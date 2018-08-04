CREATE TABLE [apietl].[yinzcam_ticketmaster_audit_trail_source_object_log]
(
[ETL__audit_id] [uniqueidentifier] NOT NULL,
[ETL__yinzcam_ticketmaster_id] [uniqueidentifier] NULL,
[ETL__session_id] [uniqueidentifier] NOT NULL,
[ETL__insert_datetime] [datetime] NOT NULL CONSTRAINT [DF__yinzcam_t__ETL____726A124A] DEFAULT (getutcdate()),
[json_payload] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[raw_response] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[yinzcam_ticketmaster_audit_trail_source_object_log] ADD CONSTRAINT [PK__yinzcam___DB9573BC80F338A9] PRIMARY KEY CLUSTERED  ([ETL__audit_id])
GO
