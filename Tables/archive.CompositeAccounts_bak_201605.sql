CREATE TABLE [archive].[CompositeAccounts_bak_201605]
(
[addresshash] [varchar] (1481) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ssb_crmsystem_acct_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE CLUSTERED INDEX [CIX_CompositeAccounts_bak_201605] ON [archive].[CompositeAccounts_bak_201605] ([addresshash], [ssb_crmsystem_acct_id])
GO
