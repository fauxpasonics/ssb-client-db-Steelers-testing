CREATE TABLE [audit].[EmailOutbound_QA_20171127]
(
[MatchType] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TierMatch] [int] NOT NULL,
[EmailAddress] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[top_tier_name_QA] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[top_tier_name_SSB] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
