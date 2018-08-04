CREATE TABLE [etl].[JSON_Meta_TableColumn]
(
[JSON_Meta_TableColumn_ID] [int] NOT NULL IDENTITY(1, 1),
[JSON_Meta_Table_ID] [int] NOT NULL,
[Level] [int] NOT NULL,
[Grouping] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HierarchyName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Order] [bigint] NULL,
[DataType] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Unpivot] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF__JSON_Meta__Activ__54D38675] DEFAULT ((0)),
[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF__JSON_Meta__Creat__55C7AAAE] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[CreatedBy] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__JSON_Meta__Creat__56BBCEE7] DEFAULT (suser_sname()),
[LastUpdatedOn] [datetime] NOT NULL CONSTRAINT [DF__JSON_Meta__LastU__57AFF320] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[LastUpdatedBy] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__JSON_Meta__LastU__58A41759] DEFAULT (suser_sname()),
[Name_raw] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [etl].[JSON_Meta_TableColumn] ADD CONSTRAINT [PK__JSON_Met__AC7F85BD297DB57E] PRIMARY KEY CLUSTERED  ([JSON_Meta_Table_ID], [Level], [HierarchyName])
GO
