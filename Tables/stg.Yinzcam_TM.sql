CREATE TABLE [stg].[Yinzcam_TM]
(
[ETL__insert_datetime] [datetime] NULL,
[timestamp_create] [datetime] NULL,
[YinzID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[entity_class] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[id_name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[id_global] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[id_links] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[first_name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[middle_initial] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[last_name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email_format] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email_optout] [bit] NULL,
[sms_optout] [bit] NULL,
[address_street_1] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address_city] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address_division_1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address_postal] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address_country] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_daytime] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_alternate_1] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sth_status] [bit] NULL,
[sth_primary_id_global] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sth_primary_first_name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sth_primary_last_name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sth_plan_name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sth_plan_name_long] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sth_primary_email] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_4] [int] NULL,
[other_5] [int] NULL,
[other_9] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_10] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[amgr_access_level] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
