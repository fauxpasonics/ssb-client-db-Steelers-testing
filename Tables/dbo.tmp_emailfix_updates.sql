CREATE TABLE [dbo].[tmp_emailfix_updates]
(
[dimcustomerid] [int] NOT NULL,
[input_email] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailPrimary] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[domain] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
