CREATE TABLE [ods].[NFL_TM_Customers]
(
[nfl_team_code] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ticket_customers_id] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acct_id] [bigint] NULL,
[cust_name_id] [bigint] NULL,
[primary_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rec_status] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acct_type_desc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name_prefix] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name_first] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name_mi] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name_last] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name_suffix] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[street_addr_1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[street_addr_2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[city] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[state] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[zip] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[country] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_day] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_eve] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_fax] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_cell] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[gender] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[src_registration_date] [datetime] NULL,
[derived_customer_type] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[derived_customer_status] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[create_date] [datetime] NULL,
[last_modified] [datetime] NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [CCI_ods__NFL_TM_Customers] ON [ods].[NFL_TM_Customers]
GO
