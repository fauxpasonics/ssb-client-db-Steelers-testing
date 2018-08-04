CREATE TABLE [apietl].[yinzcam_fivehundredfriends_Entry_Values_2]
(
[ETL__yinzcam_fivehundredfriends_Entry_Values_id] [uniqueidentifier] NOT NULL,
[ETL__yinzcam_fivehundredfriends_Entry_id] [uniqueidentifier] NULL,
[Value] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[yinzcam_fivehundredfriends_Entry_Values_2] ADD CONSTRAINT [PK__yinzcam___88A8322DCD5B287B] PRIMARY KEY CLUSTERED  ([ETL__yinzcam_fivehundredfriends_Entry_Values_id])
GO
