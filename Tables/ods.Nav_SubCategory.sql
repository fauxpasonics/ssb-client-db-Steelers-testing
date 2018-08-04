CREATE TABLE [ods].[Nav_SubCategory]
(
[ItemCategoryCode] [int] NULL,
[Code] [int] NOT NULL,
[Description] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DivisionCode] [int] NULL,
[ETL_CreatedOn] [datetime] NOT NULL CONSTRAINT [DF__Nav_SubCa__ETL_C__4FD9C72E] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[ETL_CreatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__Nav_SubCa__ETL_C__50CDEB67] DEFAULT (suser_sname()),
[ETL_UpdatedOn] [datetime] NOT NULL CONSTRAINT [DF__Nav_SubCa__ETL_U__51C20FA0] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[ETL_UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__Nav_SubCa__ETL_U__52B633D9] DEFAULT (suser_sname())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----------- CREATE TRIGGER -----------
CREATE TRIGGER [ods].[Snapshot_Nav_SubCategoryUpdate] ON [ods].[Nav_SubCategory]
AFTER UPDATE, DELETE

AS
BEGIN

DECLARE @ETL_UpdatedOn DATETIME = (SELECT [etl].[ConvertToLocalTime](CAST(GETDATE() AS DATETIME2(0))))
DECLARE @ETL_UpdatedBy NVARCHAR(400) = (SELECT SYSTEM_USER)

UPDATE t SET
[ETL_UpdatedOn] = @ETL_UpdatedOn
,[ETL_UpdatedBy] = @ETL_UpdatedBy
FROM [ods].[Nav_SubCategory] t
	JOIN inserted i ON  t.[Code] = i.[Code]

INSERT INTO [ods].[Snapshot_Nav_SubCategory] ([ItemCategoryCode],[Code],[Description],[DivisionCode],[ETL_CreatedOn],[ETL_CreatedBy],[ETL_UpdatedOn],[ETL_UpdatedBy],[RecordEndDate])
SELECT a.*,dateadd(s,-1,@ETL_UpdatedOn)
FROM deleted a

END
GO
ALTER TABLE [ods].[Nav_SubCategory] ADD CONSTRAINT [PK__Nav_SubC__A25C5AA6FAA922D0] PRIMARY KEY CLUSTERED  ([Code])
GO
