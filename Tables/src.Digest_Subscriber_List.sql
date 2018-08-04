CREATE TABLE [src].[Digest_Subscriber_List]
(
[Subs_#] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address Name Customer Name] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer Company] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer Street] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer Address2] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer City] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer Country] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoadDate] [datetime] NOT NULL CONSTRAINT [DF__Digest_Su__LoadD__3787ACF0] DEFAULT (getdate())
)
GO
