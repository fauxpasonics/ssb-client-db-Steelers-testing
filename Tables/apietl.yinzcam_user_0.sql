CREATE TABLE [apietl].[yinzcam_user_0]
(
[ETL__yinzcam_user_id] [uniqueidentifier] NOT NULL,
[ETL__session_id] [uniqueidentifier] NOT NULL,
[ETL__insert_datetime] [datetime] NOT NULL CONSTRAINT [DF__yinzcam_u__ETL____2C185C49] DEFAULT (getutcdate()),
[ETL__multi_query_value_for_audit] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[YinzID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[yinzcam_user_0] ADD CONSTRAINT [PK__yinzcam___56B454D7E6828FA5] PRIMARY KEY CLUSTERED  ([ETL__yinzcam_user_id])
GO
