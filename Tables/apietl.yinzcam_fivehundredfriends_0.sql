CREATE TABLE [apietl].[yinzcam_fivehundredfriends_0]
(
[ETL__yinzcam_fivehundredfriends_id] [uniqueidentifier] NOT NULL,
[ETL__session_id] [uniqueidentifier] NOT NULL,
[ETL__insert_datetime] [datetime] NOT NULL CONSTRAINT [DF__yinzcam_f__inser__33B7E763] DEFAULT (getutcdate()),
[ETL__multi_query_value_for_audit] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[YinzID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[yinzcam_fivehundredfriends_0] ADD CONSTRAINT [PK__yinzcam___B99C891E3442258F] PRIMARY KEY CLUSTERED  ([ETL__yinzcam_fivehundredfriends_id])
GO
