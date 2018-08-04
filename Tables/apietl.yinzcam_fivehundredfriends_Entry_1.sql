CREATE TABLE [apietl].[yinzcam_fivehundredfriends_Entry_1]
(
[ETL__yinzcam_fivehundredfriends_Entry_id] [uniqueidentifier] NOT NULL,
[ETL__yinzcam_fivehundredfriends_id] [uniqueidentifier] NULL,
[Key] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[yinzcam_fivehundredfriends_Entry_1] ADD CONSTRAINT [PK__yinzcam___79828417A71BFFB3] PRIMARY KEY CLUSTERED  ([ETL__yinzcam_fivehundredfriends_Entry_id])
GO
