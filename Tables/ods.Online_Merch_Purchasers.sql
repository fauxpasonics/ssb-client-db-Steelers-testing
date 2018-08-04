CREATE TABLE [ods].[Online_Merch_Purchasers]
(
[OnlineMerchId] [int] NOT NULL IDENTITY(1, 1),
[FileId] [int] NULL,
[date_start] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[invoicenumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[userid] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cc_total] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[gift_certificate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [varbinary] (32) NULL,
[InsertDate] [datetime] NULL,
[ModifiedDate] [datetime] NULL
)
GO
ALTER TABLE [ods].[Online_Merch_Purchasers] ADD CONSTRAINT [PK__Online_M__28D16DAF00093A6A] PRIMARY KEY CLUSTERED  ([OnlineMerchId])
GO
