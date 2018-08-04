CREATE TABLE [apietl].[yinzcam_ticketmaster_Entry_Values_2]
(
[ETL__yinzcam_ticketmaster_Entry_Values_id] [uniqueidentifier] NOT NULL,
[ETL__yinzcam_ticketmaster_Entry_id] [uniqueidentifier] NULL,
[Value] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[yinzcam_ticketmaster_Entry_Values_2] ADD CONSTRAINT [PK__yinzcam___CCED235E3C7158DF] PRIMARY KEY CLUSTERED  ([ETL__yinzcam_ticketmaster_Entry_Values_id])
GO
