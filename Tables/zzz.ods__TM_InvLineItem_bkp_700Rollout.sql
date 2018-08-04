CREATE TABLE [zzz].[ods__TM_InvLineItem_bkp_700Rollout]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[acct_id] [int] NULL,
[order_num] [int] NULL,
[order_line_item] [int] NULL,
[order_line_item_seq] [int] NULL,
[invoice_id] [int] NULL,
[amount] [decimal] (18, 6) NULL,
[purchase_amount] [decimal] (18, 6) NULL,
[gross_invoice_amount] [decimal] (18, 6) NULL,
[invoice_method] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[item_amount] [decimal] (18, 6) NULL,
[status] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[required_ind] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[opt_out] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[opt_out_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[opt_out_datetime] [datetime] NULL,
[InsertDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [binary] (32) NULL
)
GO
ALTER TABLE [zzz].[ods__TM_InvLineItem_bkp_700Rollout] ADD CONSTRAINT [PK__TM_InvLi__3213E83FB57868CF] PRIMARY KEY CLUSTERED  ([id])
GO
CREATE NONCLUSTERED INDEX [IDX_TMInvLineItem_OrderNum_OrderLineItem_OrderLineSeqIItem_InvoiceID] ON [zzz].[ods__TM_InvLineItem_bkp_700Rollout] ([order_num], [order_line_item], [order_line_item_seq], [invoice_id])
GO
