CREATE TABLE [audit].[DW_AuditSnapShot]
(
[ETL_ID] [bigint] NOT NULL IDENTITY(1, 1),
[ETL_BatchId] [int] NOT NULL,
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_TM_AuditSetId] [int] NOT NULL,
[TM_AuditSourceFile] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EventId] [int] NOT NULL,
[PriceCode] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsHost] [bit] NOT NULL,
[Qty_TotalSold] [int] NOT NULL,
[Qty_Plan] [int] NOT NULL,
[Qty_Single] [int] NOT NULL,
[Qty_Group] [int] NOT NULL,
[Qty_Comp] [int] NOT NULL,
[Qty_Held] [int] NOT NULL,
[Qty_Avail] [int] NOT NULL,
[Qty_Kill] [int] NOT NULL,
[Revenue] [decimal] (18, 6) NOT NULL
)
GO
