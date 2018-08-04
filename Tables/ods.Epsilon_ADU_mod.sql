CREATE TABLE [ods].[Epsilon_ADU_mod]
(
[PROFILE_KEY] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MAILING_NAME] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACTION_CODE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SOURCE_CODE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACTION_DATE] [date] NULL
)
GO
CREATE NONCLUSTERED INDEX [IDX_ACTION_CODE] ON [ods].[Epsilon_ADU_mod] ([ACTION_CODE])
GO
CREATE NONCLUSTERED INDEX [IDX_ACTION_DATE] ON [ods].[Epsilon_ADU_mod] ([ACTION_DATE])
GO
CREATE NONCLUSTERED INDEX [IDX_MAILING_NAME] ON [ods].[Epsilon_ADU_mod] ([MAILING_NAME])
GO
CREATE NONCLUSTERED INDEX [IDX_PROFILE_KEY] ON [ods].[Epsilon_ADU_mod] ([PROFILE_KEY])
GO
CREATE NONCLUSTERED INDEX [IDX_SOURCE_CODE] ON [ods].[Epsilon_ADU_mod] ([SOURCE_CODE])
GO