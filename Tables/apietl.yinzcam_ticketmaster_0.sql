CREATE TABLE [apietl].[yinzcam_ticketmaster_0]
(
[ETL__yinzcam_ticketmaster_id] [uniqueidentifier] NOT NULL,
[ETL__session_id] [uniqueidentifier] NOT NULL,
[ETL__insert_datetime] [datetime] NOT NULL CONSTRAINT [DF__yinzcam_t__ETL____75467EF5] DEFAULT (getutcdate()),
[ETL__multi_query_value_for_audit] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[YinzID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[yinzcam_ticketmaster_0] ADD CONSTRAINT [PK__yinzcam___2545225B4CE2E48F] PRIMARY KEY CLUSTERED  ([ETL__yinzcam_ticketmaster_id])
GO
