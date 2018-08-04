CREATE TABLE [ods].[NFL_TM_Ticket]
(
[nfl_team_code] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ticket_orders_id] [nvarchar] (155) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ticket_customers_id] [nvarchar] (51) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acct_id] [bigint] NULL,
[event_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Team] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[section_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[row_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[num_seats] [int] NULL,
[seat_num] [int] NULL,
[last_Seat] [int] NULL,
[ticket_status] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[season_year] [int] NULL,
[order_line_item] [bigint] NULL,
[order_line_item_seq] [int] NULL,
[sell_location] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[purchase_price] [decimal] (18, 6) NULL,
[ticket_class] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[plan_event_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[promo_code_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[create_date] [datetime] NULL,
[last_modified] [datetime] NULL,
[order_date] [datetime] NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [CCI_ods__NFL_TM_Ticket] ON [ods].[NFL_TM_Ticket]
GO
