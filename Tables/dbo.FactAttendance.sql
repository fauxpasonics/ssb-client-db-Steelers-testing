CREATE TABLE [dbo].[FactAttendance]
(
[FactAttendanceId] [bigint] NOT NULL IDENTITY(1, 1),
[DimEventId] [int] NOT NULL,
[DimCustomerId] [bigint] NOT NULL,
[DimSeatId] [int] NOT NULL,
[ScanDateTime] [datetime] NOT NULL,
[ScanGate] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Barcode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Channel] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSID_event_id] [int] NOT NULL,
[SSID_acct_id] [int] NULL,
[SSID_section_id] [int] NOT NULL,
[SSID_row_id] [int] NOT NULL,
[SSID_seat] [int] NOT NULL,
[ETL_SourceSystem] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_UpdatedDate] [datetime] NOT NULL
)
GO
ALTER TABLE [dbo].[FactAttendance] ADD CONSTRAINT [PK__FactAtte__5A5CE7B24BB9D16C] PRIMARY KEY CLUSTERED  ([FactAttendanceId])
GO
CREATE NONCLUSTERED INDEX [IDX_DimCustomerId] ON [dbo].[FactAttendance] ([DimCustomerId])
GO
CREATE NONCLUSTERED INDEX [IDX_LoadKey] ON [dbo].[FactAttendance] ([DimEventId], [DimSeatId])
GO
CREATE NONCLUSTERED INDEX [IX_ETL_UpdatedDate] ON [dbo].[FactAttendance] ([ETL_UpdatedDate] DESC)
GO
CREATE NONCLUSTERED INDEX [IDX_ScanDateTime] ON [dbo].[FactAttendance] ([ScanDateTime])
GO
CREATE NONCLUSTERED INDEX [IDX_ScanGate] ON [dbo].[FactAttendance] ([ScanGate])
GO
