CREATE TABLE [etl].[JSON_Meta_Table_Configuration]
(
[JSON_Meta_Table_Configuration_ID] [int] NOT NULL IDENTITY(1, 1),
[JSON_Meta_Table_ID] [int] NOT NULL,
[TargetSchema] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TargetTableName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF__JSON_Meta__Activ__500ED158] DEFAULT ((1)),
[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF__JSON_Meta__Creat__5102F591] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[CreatedBy] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__JSON_Meta__Creat__51F719CA] DEFAULT (suser_sname()),
[LastUpdatedOn] [datetime] NOT NULL CONSTRAINT [DF__JSON_Meta__LastU__52EB3E03] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[LastUpdatedBy] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__JSON_Meta__LastU__53DF623C] DEFAULT (suser_sname())
)
GO
ALTER TABLE [etl].[JSON_Meta_Table_Configuration] ADD CONSTRAINT [PK__JSON_Met__CA90E60479D34C10] PRIMARY KEY CLUSTERED  ([JSON_Meta_Table_Configuration_ID])
GO
ALTER TABLE [etl].[JSON_Meta_Table_Configuration] ADD CONSTRAINT [UQ__JSON_Met__BBAAE0D909C92769] UNIQUE NONCLUSTERED  ([TargetSchema], [TargetTableName])
GO
