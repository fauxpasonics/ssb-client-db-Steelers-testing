CREATE TABLE [src].[SSISAudit]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[ssisRunUser] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ssisRunDate] [datetime] NULL CONSTRAINT [DF__SSISAudit__ssisR__29221CFB] DEFAULT (getdate())
)
GO
ALTER TABLE [src].[SSISAudit] ADD CONSTRAINT [PK__SSISAudi__3213E83FE58E176D] PRIMARY KEY CLUSTERED  ([id])
GO
