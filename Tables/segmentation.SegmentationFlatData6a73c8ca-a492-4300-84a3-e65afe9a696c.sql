CREATE TABLE [segmentation].[SegmentationFlatData6a73c8ca-a492-4300-84a3-e65afe9a696c]
(
[id] [uniqueidentifier] NOT NULL,
[DocumentType] [varchar] (24) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[_rn] [bigint] NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[O_Archtics_Acct_Id] [int] NULL,
[O_Activity] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[O_Activity_Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[O_Transaction_Date] [date] NULL,
[O_Season_Year] [int] NULL,
[O_Event_Code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[O_Event_Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[O_Event_Time] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[O_Event_Date] [datetime] NULL,
[O_Section_Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[O_Row_Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[O_First_Seat] [int] NULL,
[O_Qty_Seat] [int] NULL,
[O_Orig_purchase_price] [numeric] (29, 2) NULL,
[O_TE_Purchase_Price] [numeric] (18, 0) NULL,
[O_TE_Price_Difference] [numeric] (30, 0) NULL
)
GO
ALTER TABLE [segmentation].[SegmentationFlatData6a73c8ca-a492-4300-84a3-e65afe9a696c] ADD CONSTRAINT [pk_SegmentationFlatData6a73c8ca-a492-4300-84a3-e65afe9a696c] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData6a73c8ca-a492-4300-84a3-e65afe9a696c] ON [segmentation].[SegmentationFlatData6a73c8ca-a492-4300-84a3-e65afe9a696c] ([_rn])
GO
