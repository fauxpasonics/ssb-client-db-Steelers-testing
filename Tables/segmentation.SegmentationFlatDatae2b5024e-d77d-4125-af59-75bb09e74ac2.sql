CREATE TABLE [segmentation].[SegmentationFlatDatae2b5024e-d77d-4125-af59-75bb09e74ac2]
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
ALTER TABLE [segmentation].[SegmentationFlatDatae2b5024e-d77d-4125-af59-75bb09e74ac2] ADD CONSTRAINT [pk_SegmentationFlatDatae2b5024e-d77d-4125-af59-75bb09e74ac2] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatDatae2b5024e-d77d-4125-af59-75bb09e74ac2] ON [segmentation].[SegmentationFlatDatae2b5024e-d77d-4125-af59-75bb09e74ac2] ([_rn])
GO
