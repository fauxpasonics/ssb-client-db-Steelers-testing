CREATE TABLE [apietl].[yinzcam_twitter_Entry_1]
(
[ETL__yinzcam_twitter_Entry_id] [uniqueidentifier] NOT NULL,
[ETL__yinzcam_twitter_id] [uniqueidentifier] NULL,
[Key] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[yinzcam_twitter_Entry_1] ADD CONSTRAINT [PK__yinzcam___D793827B4E702CE4] PRIMARY KEY CLUSTERED  ([ETL__yinzcam_twitter_Entry_id])
GO
