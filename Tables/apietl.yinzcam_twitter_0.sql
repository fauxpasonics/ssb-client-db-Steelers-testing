CREATE TABLE [apietl].[yinzcam_twitter_0]
(
[ETL__yinzcam_twitter_id] [uniqueidentifier] NOT NULL,
[ETL__session_id] [uniqueidentifier] NOT NULL,
[ETL__insert_datetime] [datetime] NOT NULL CONSTRAINT [DF__yinzcam_t__ETL____76314CE4] DEFAULT (getutcdate()),
[ETL__multi_query_value_for_audit] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[YinzID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[yinzcam_twitter_0] ADD CONSTRAINT [PK__yinzcam___C99D87A24C87A37B] PRIMARY KEY CLUSTERED  ([ETL__yinzcam_twitter_id])
GO
