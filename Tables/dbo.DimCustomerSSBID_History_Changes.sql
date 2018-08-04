CREATE TABLE [dbo].[DimCustomerSSBID_History_Changes]
(
[BatchDate] [date] NULL,
[RecordChange] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SnapshotDate] [date] NOT NULL,
[DimCustomerSSBID] [int] NOT NULL,
[DimCustomerId] [int] NOT NULL,
[NameAddr_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NameEmail_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Composite_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSB_CRMSYSTEM_ACCT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSB_CRMSYSTEM_PRIMARY_FLAG] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NOT NULL,
[IsDeleted] [bit] NOT NULL,
[DeleteDate] [datetime] NULL,
[SSID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSB_CRMSYSTEM_ACCT_PRIMARY_FLAG] [int] NULL,
[NamePhone_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ssb_crmsystem_contactacct_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE NONCLUSTERED INDEX [IX_DimCustomerSSBID_History_Changes_BatchDate] ON [dbo].[DimCustomerSSBID_History_Changes] ([BatchDate])
GO
CREATE NONCLUSTERED INDEX [IX_DimCustomerSSBID_History_Changes_DimCustomerID] ON [dbo].[DimCustomerSSBID_History_Changes] ([DimCustomerId])
GO
CREATE NONCLUSTERED INDEX [IX_DimCustomerSSBID_History_Changes_SSID] ON [dbo].[DimCustomerSSBID_History_Changes] ([SSID])
GO
