CREATE TABLE [apietl].[yinzcam_facebook_Entry_1]
(
[ETL__yinzcam_facebook_Entry_id] [uniqueidentifier] NOT NULL,
[ETL__yinzcam_facebook_id] [uniqueidentifier] NULL,
[Key] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[yinzcam_facebook_Entry_1] ADD CONSTRAINT [PK__yinzcam___97FA948C17F8472B] PRIMARY KEY CLUSTERED  ([ETL__yinzcam_facebook_Entry_id])
GO
