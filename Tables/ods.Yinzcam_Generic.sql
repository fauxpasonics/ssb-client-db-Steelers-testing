CREATE TABLE [ods].[Yinzcam_Generic]
(
[ETL_CreatedDate] [datetime] NULL,
[ETL_UpdatedDate] [datetime] NULL,
[YinzID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[abi_optout] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address_country] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address_postal] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[birth_date] [date] NULL,
[birthdate] [date] NULL,
[email] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email_optout] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[filter_presets] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[first_name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[gender] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[image_url] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[last_name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[wgu_card_android_timestamp] [datetime] NULL,
[wgu_card_android_url] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_IsDeleted] [bit] NULL,
[ETL_DeletedDate] [datetime] NULL
)
GO
CREATE NONCLUSTERED INDEX [IX_yinzID] ON [ods].[Yinzcam_Generic] ([YinzID])
GO
