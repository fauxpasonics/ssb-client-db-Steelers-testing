CREATE TABLE [rpt].[PreCache_Cust_Email_8_tbl]
(
[PK] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NUM_SENT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NUM_FTD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NUM_CLICK] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OPTOUT_FLG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OPTOUT_DTTM] [date] NULL,
[CREATED_DTTM] [date] NULL,
[HTML_OPEN_DTTM] [date] NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Gender] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Age] [int] NULL,
[AddressPrimaryStreet] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressPrimaryCity] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressPrimaryState] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressPrimaryZip] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressPrimaryCounty] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressPrimaryCountry] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsReady] [int] NOT NULL
)
GO
