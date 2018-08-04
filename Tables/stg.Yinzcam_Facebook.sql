CREATE TABLE [stg].[Yinzcam_Facebook]
(
[insert_datetime] [datetime] NULL,
[yinzid] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[first_name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[last_name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[gender] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[locale] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[timezone_offset] [int] NULL,
[timestamp_update] [datetime] NULL,
[id_thirdparty] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[link] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[verified] [bit] NULL,
[currency] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[id_global] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
