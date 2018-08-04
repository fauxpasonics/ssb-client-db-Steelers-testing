CREATE TABLE [src].[Merch_tbl_Reg_User_Address]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ID] [int] NULL,
[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[date_Start] [datetime] NULL,
[UserID] [int] NULL,
[Address1] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplayName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
