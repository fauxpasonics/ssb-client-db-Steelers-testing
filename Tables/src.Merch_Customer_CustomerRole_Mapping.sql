CREATE TABLE [src].[Merch_Customer_CustomerRole_Mapping]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[LastTimeStamp] [binary] (8) NULL,
[Customer_Id] [int] NULL,
[CustomerRole_Id] [int] NULL
)
GO
