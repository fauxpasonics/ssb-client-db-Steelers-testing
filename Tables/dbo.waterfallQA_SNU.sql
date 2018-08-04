CREATE TABLE [dbo].[waterfallQA_SNU]
(
[batchID] [int] NULL,
[LoyaltyPlus_ID] [int] NULL,
[External_Customer_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Date] [datetime] NULL,
[Email] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Event_Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Event_Details] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Event_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Value] [int] NULL,
[Points] [int] NULL,
[Channel] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sub_Channel] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sub_Channel_Detail] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[External_User_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[External_User_Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
