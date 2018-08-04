CREATE TABLE [adhoc].[Non_Null_News_Pref_20180310]
(
[CustomerKey] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE NONCLUSTERED INDEX [IX_CustomerKey] ON [adhoc].[Non_Null_News_Pref_20180310] ([CustomerKey])
GO
