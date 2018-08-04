CREATE TABLE [apietl].[yinzcam_facebook_0]
(
[ETL__yinzcam_facebook_id] [uniqueidentifier] NOT NULL,
[ETL__session_id] [uniqueidentifier] NOT NULL,
[ETL__insert_datetime] [datetime] NOT NULL CONSTRAINT [DF__yinzcam_f__inser__2A2E7D29] DEFAULT (getutcdate()),
[ETL__multi_query_value_for_audit] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[YinzID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[yinzcam_facebook_0] ADD CONSTRAINT [PK__yinzcam___625E35A8D1FD439A] PRIMARY KEY CLUSTERED  ([ETL__yinzcam_facebook_id])
GO
