CREATE TABLE [EmailOutbound].[Data_Uploader_Landing]
(
[SessionId] [uniqueidentifier] NULL,
[RecordCreateDate] [datetime] NOT NULL CONSTRAINT [DF__Data_Uplo__Recor__2284D06E] DEFAULT (getutcdate()),
[Processed] [bit] NOT NULL CONSTRAINT [DF__Data_Uplo__Proce__2378F4A7] DEFAULT ((0)),
[DynamicData] [xml] NULL,
[ETL_CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__Data_Uplo__ETL_C__246D18E0] DEFAULT (getdate()),
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
[Pref_Team_News] [bit] NULL,
[Pref_Team_Events] [bit] NULL,
[Pref_Concerts] [bit] NULL,
[Pref_Heinz_Field] [bit] NULL,
[Pref_Pro_Shop] [bit] NULL,
[Pref_Contests_Promotions] [bit] NULL,
[Source] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Event_Date] [datetime] NULL,
[Email_Opt_In] [bit] NULL,
[Ext_Attribute1] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Ext_Attribute2] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Ext_Attribute3] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Event_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Cost] [numeric] (18, 2) NULL,
[Quantity] [int] NULL,
[ContactHash] [binary] (32) NULL,
[SSID] [bigint] NULL
)
GO