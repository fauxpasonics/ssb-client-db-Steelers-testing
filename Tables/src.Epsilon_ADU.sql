CREATE TABLE [src].[Epsilon_ADU]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__Epsilon_A__ETL_C__42B7D1CC] DEFAULT (getdate()),
[MAILING_NAME] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PROFILE_KEY] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMAIL_ADDR] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CONTENT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SOURCE_CODE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACTION_CODE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SUB_ACTION_CODE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACTION_DTTM] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UNIQUE_FLAG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LINK_NAME] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LINK_TAG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ABUSE_DOMAIN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ABUSEOPT_FLG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ABUSE_SUB] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
