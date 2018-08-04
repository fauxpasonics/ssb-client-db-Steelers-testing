CREATE TABLE [src].[Merch_SNU]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[Id] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SnuId] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UnSubscribed] [bit] NULL,
[UnsubscribedSms] [bit] NULL,
[CreatedAt] [datetime] NULL,
[UpdatedAt] [datetime] NULL,
[Balance] [int] NULL,
[LifetimeBalance] [int] NULL,
[LastActivity] [datetime] NULL,
[ImageUrl] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TopTierName] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExternalCustomerId] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastRewardEventId] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubscriptionType] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Channel] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubChannel] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubChannelDetail] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastRewardDate] [datetime] NULL,
[DateEnrolled] [datetime] NULL,
[LastTimeStamp] [binary] (8) NULL
)
GO
