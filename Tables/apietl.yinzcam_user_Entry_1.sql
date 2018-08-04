CREATE TABLE [apietl].[yinzcam_user_Entry_1]
(
[ETL__yinzcam_user_Entry_id] [uniqueidentifier] NOT NULL,
[ETL__yinzcam_user_id] [uniqueidentifier] NULL,
[Key] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[yinzcam_user_Entry_1] ADD CONSTRAINT [PK__yinzcam___7E411AE9BA150511] PRIMARY KEY CLUSTERED  ([ETL__yinzcam_user_Entry_id])
GO
