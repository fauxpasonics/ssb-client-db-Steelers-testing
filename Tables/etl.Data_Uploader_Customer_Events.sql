CREATE TABLE [etl].[Data_Uploader_Customer_Events]
(
[SSID] [bigint] NOT NULL IDENTITY(1, 1),
[Email] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[First_Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Last_Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Suffix] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Gender] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Birth_Date] [date] NULL,
[Address_Street] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_Suite] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_City] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_State] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_Zip] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_Country] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone_Primary] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone_Cell] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactHash] [binary] (32) NULL,
[ETL_CreatedDate] [datetime] NULL,
[ETL_UpdatedDate] [datetime] NULL
)
GO
