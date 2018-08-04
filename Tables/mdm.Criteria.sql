CREATE TABLE [mdm].[Criteria]
(
[CriteriaID] [int] NOT NULL IDENTITY(1, 1),
[Criteria] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CriteriaField] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CriteriaTable] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CriteriaJoin] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Custom] [bit] NULL,
[IsDeleted] [bit] NULL,
[DateCreated] [date] NULL CONSTRAINT [DF__Criteria__DateCr__38D961D7] DEFAULT (getdate()),
[DateUpdated] [date] NULL CONSTRAINT [DF__Criteria__DateUp__39CD8610] DEFAULT (getdate()),
[CriteriaOrder] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DefaultDisplayOrder] [int] NULL,
[PreSQL] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[criteriacondition] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
