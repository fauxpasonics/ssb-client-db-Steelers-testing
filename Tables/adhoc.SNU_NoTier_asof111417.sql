CREATE TABLE [adhoc].[SNU_NoTier_asof111417]
(
[CustomerKey] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAddress] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SNU_CURRENT_YARDS] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SNU_ENROLLED_AT] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SNU_LAST_ACTIVITY_DATE] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SNU_STATUS] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SNU_TIER] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE NONCLUSTERED INDEX [ix_CustomerKey] ON [adhoc].[SNU_NoTier_asof111417] ([CustomerKey])
GO
CREATE NONCLUSTERED INDEX [ix_EmailAddress] ON [adhoc].[SNU_NoTier_asof111417] ([EmailAddress])
GO
