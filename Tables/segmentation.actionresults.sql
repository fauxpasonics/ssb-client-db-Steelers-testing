CREATE TABLE [segmentation].[actionresults]
(
[resultid] [int] NOT NULL IDENTITY(1, 1),
[SSB_CRM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Runid] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActionName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [segmentation].[actionresults] ADD CONSTRAINT [PK__actionre__C6EBD0434EACD833] PRIMARY KEY CLUSTERED  ([resultid])
GO
