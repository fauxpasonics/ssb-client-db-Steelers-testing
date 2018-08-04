CREATE TABLE [EmailOutbound].[Upsert_Standard]
(
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[First_Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Last_Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Suffix] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Gender] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Birth_Date] [date] NULL,
[Address_Street] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_Suite] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_City] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_State] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_Zip] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_County] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_Country] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Record_Source] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Is_New_Record] [bit] NULL
)
GO
CREATE NONCLUSTERED INDEX [IX_Email] ON [EmailOutbound].[Upsert_Standard] ([Email])
GO
