CREATE TABLE [mdm].[SourceSystems]
(
[SourceSystemID] [int] NOT NULL IDENTITY(1, 1),
[SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsDeleted] [bit] NULL,
[DateCreated] [date] NULL CONSTRAINT [DF__SourceSys__DateC__407A839F] DEFAULT (getdate()),
[DateUpdated] [date] NULL CONSTRAINT [DF__SourceSys__DateU__416EA7D8] DEFAULT (getdate()),
[NameForReporting] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [mdm].[SourceSystems] ADD CONSTRAINT [PK__SourceSy__8F4FFBF46F7FB4C4] PRIMARY KEY CLUSTERED  ([SourceSystemID])
GO
