CREATE TABLE [apietl].[yinzcam_twitter_Entry_Values_2]
(
[ETL__yinzcam_twitter_Entry_Values_id] [uniqueidentifier] NOT NULL,
[ETL__yinzcam_twitter_Entry_id] [uniqueidentifier] NULL,
[Value] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[yinzcam_twitter_Entry_Values_2] ADD CONSTRAINT [PK__yinzcam___71CCDAD38284E9B6] PRIMARY KEY CLUSTERED  ([ETL__yinzcam_twitter_Entry_Values_id])
GO
