CREATE TABLE [dbo].[DimCustomer_Merged_Expanded]
(
[isPrimary] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DimCustomerId] [int] NOT NULL,
[BatchId] [bigint] NULL,
[ODSRowLastUpdated] [datetime] NULL,
[SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceSystemPriority] [int] NULL,
[SSID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerStatus] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountRep] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CompanyName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SalutationName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DonorMailName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DonorFormalName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Birthday] [date] NULL,
[Gender] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MergedRecordFlag] [int] NULL,
[MergedIntoSSID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Prefix] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MiddleName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Suffix] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NameMasterId] [bigint] NULL,
[AddressPrimaryStreet] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressPrimaryCity] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressPrimaryState] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressPrimaryZip] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressPrimaryCounty] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressPrimaryCountry] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressPrimaryMasterId] [bigint] NULL,
[AddressOneStreet] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressOneCity] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressOneState] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressOneZip] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressOneCounty] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressOneCountry] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressOneMasterId] [bigint] NULL,
[AddressTwoStreet] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressTwoCity] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressTwoState] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressTwoZip] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressTwoCounty] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressTwoCountry] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressTwoMasterId] [bigint] NULL,
[AddressThreeStreet] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressThreeCity] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressThreeState] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressThreeZip] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressThreeCounty] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressThreeCountry] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressThreeMasterId] [bigint] NULL,
[AddressFourStreet] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressFourCity] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressFourState] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressFourZip] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressFourCounty] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressFourCountry] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressFourMasterId] [bigint] NULL,
[PhonePrimary] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhonePrimaryMasterId] [bigint] NULL,
[PhoneHome] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneHomeMasterId] [bigint] NULL,
[PhoneCell] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneCellMasterId] [bigint] NULL,
[PhoneBusiness] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneBusinessMasterId] [bigint] NULL,
[PhoneFax] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneFaxMasterId] [bigint] NULL,
[PhoneOther] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneOtherMasterId] [bigint] NULL,
[EmailPrimary] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailPrimaryMasterId] [bigint] NULL,
[EmailOne] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailOneMasterId] [bigint] NULL,
[EmailTwo] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailTwoMasterId] [bigint] NULL,
[SSCreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSCreatedDate] [datetime] NULL,
[CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NOT NULL,
[AccountId] [int] NULL,
[AddressPrimaryNCOAStatus] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressOneStreetNCOAStatus] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressTwoStreetNCOAStatus] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressThreeStreetNCOAStatus] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressFourStreetNCOAStatus] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsDeleted] [bit] NOT NULL,
[DeleteDate] [datetime] NULL,
[IsBusiness] [bit] NULL,
[FullName] [nvarchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressPrimarySuite] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressOneSuite] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressTwoSuite] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressThreeSuite] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressFourSuite] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer_matchkey] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhonePrimaryDNC] [bit] NULL,
[PhoneHomeDNC] [bit] NULL,
[PhoneCellDNC] [bit] NULL,
[PhoneBusinessDNC] [bit] NULL,
[PhoneFaxDNC] [bit] NULL,
[PhoneOtherDNC] [bit] NULL,
[AddressPrimaryPlus4] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressOnePlus4] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressTwoPlus4] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressThreePlus4] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressFourPlus4] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Gender] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO