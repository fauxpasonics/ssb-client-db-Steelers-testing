CREATE TABLE [apietl].[yinzcam_fivehundredfriends_audit_trail_source_object_log]
(
[ETL__audit_id] [uniqueidentifier] NOT NULL,
[ETL__yinzcam_fivehundredfriends_id] [uniqueidentifier] NULL,
[ETL__session_id] [uniqueidentifier] NOT NULL,
[ETL__insert_datetime] [datetime] NOT NULL CONSTRAINT [DF__yinzcam_f__inser__30DB7AB8] DEFAULT (getutcdate()),
[json_payload] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[raw_response] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[yinzcam_fivehundredfriends_audit_trail_source_object_log] ADD CONSTRAINT [PK__yinzcam___5AF33E33F6309D1C] PRIMARY KEY CLUSTERED  ([ETL__audit_id])
GO
