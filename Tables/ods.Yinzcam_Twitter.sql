CREATE TABLE [ods].[Yinzcam_Twitter]
(
[ETL__insert_datetime] [datetime] NULL,
[timestamp_create] [datetime] NULL,
[YinzID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[id_global] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nick] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[image_url] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[image_url_small] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[image_url_large] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[image_url_background] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[twitter_favorites_count] [int] NULL,
[twitter_followers_count] [int] NULL,
[twitter_friends_count] [int] NULL,
[twitter_listed_count] [int] NULL,
[twitter_statuses_count] [int] NULL,
[timezone_name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[timezone_offset] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[language_affinities] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
