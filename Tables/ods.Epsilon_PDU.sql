CREATE TABLE [ods].[Epsilon_PDU]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_UpdatedDate] [datetime] NOT NULL,
[ETL_IsDeleted] [bit] NOT NULL,
[ETL_DeletedDate] [datetime] NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[PK] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EM] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NUM_SENT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NUM_FTD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NUM_CLICK] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OPTOUT_FLG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAST_SENT_DTTM] [datetime] NULL,
[FTD_DTTM] [datetime] NULL,
[CLICK_DTTM] [datetime] NULL,
[HTML_OPEN_DTTM] [datetime] NULL,
[OPTOUT_DTTM] [datetime] NULL,
[MODIFIED_DTTM] [datetime] NULL,
[CREATED_DTTM] [datetime] NULL,
[2013_FAN_CLUB] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2013_LEGENDS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2013_STH] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2013_SUITES] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2013_WAITLIST] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2014_FAN_CLUB] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2014_LEGENDS_Q1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2014_LEGENDS_Q2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2014_LEGENDS_Q3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2014_LEGENDS_Q4] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2014_STH_Q1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2014_STH_Q2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2014_STH_Q3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2014_STH_Q4] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2014_SUITES_Q1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2014_SUITES_Q2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2014_SUITES_Q3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2014_SUITES_Q4] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2014_WL_Q1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2014_WL_Q2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2014_WL_Q3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2014_WL_Q4] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2015_FAN_CLUB] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2015_STH_Q1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2015_STH_Q2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2015_STH_Q3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2015_STH_Q4] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2015_SUITES_Q1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2015_SUITES_Q2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2015_SUITES_Q3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2015_SUITES_Q4] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2015_WL_Q1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2015_WL_Q2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2015_WL_Q3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2015_WL_Q4] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2016_STH_Q1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2016_STH_Q2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2016_SUITES_Q1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2016_SUITES_Q2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2016_WL_Q1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2016_WL_Q2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[5K_ATTEND] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDRESS1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDRESS2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CITY] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COUNTRY] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRUISE_ATTEND] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB_DAY] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB_MONTH] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB_YEAR] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DRAFT_PICK_CONTEST] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FAVORITEPLAYER] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FIRSTNAME] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GENDER] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HEINZ_FIELD_EVENTS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LASTNAME] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MENS_FANTASY_CAMP] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MENS_FANTASY_CAMP_ATTEND] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_5K] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_COUNTRY_CONCERTS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_FAN_CLUBS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_HEINZ_FIELD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_LADIES_EVENTS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_MERCH] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_NEWSLETTER] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_PARTNER_OFFERS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_ROCK_CONCERTS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_SNU] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_TEAM_EVENTS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_TR_CAMP] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_UPDATE_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_YOUTH_CAMPS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PURCHASEMERCHANDISE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RECORD_SOURCE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SNU_STATUS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STATE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STH_ACCOUNT_ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TICKET_TYPE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIPCODE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE NONCLUSTERED INDEX [IX_CLICK] ON [ods].[Epsilon_PDU] ([CLICK_DTTM])
GO
CREATE NONCLUSTERED INDEX [IX_CREATED] ON [ods].[Epsilon_PDU] ([CREATED_DTTM])
GO
CREATE NONCLUSTERED INDEX [IX_FTD] ON [ods].[Epsilon_PDU] ([FTD_DTTM])
GO
CREATE NONCLUSTERED INDEX [IX_HTML_OPEN] ON [ods].[Epsilon_PDU] ([HTML_OPEN_DTTM])
GO
CREATE NONCLUSTERED INDEX [IX_LAST_SENT] ON [ods].[Epsilon_PDU] ([LAST_SENT_DTTM])
GO
CREATE NONCLUSTERED INDEX [IX_MODIFIED] ON [ods].[Epsilon_PDU] ([MODIFIED_DTTM])
GO
CREATE NONCLUSTERED INDEX [IX_OPTOUT] ON [ods].[Epsilon_PDU] ([OPTOUT_DTTM])
GO
CREATE NONCLUSTERED INDEX [IX_Epsilon_PDU_PK] ON [ods].[Epsilon_PDU] ([PK])
GO