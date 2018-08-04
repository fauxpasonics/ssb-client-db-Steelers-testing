CREATE TABLE [rpt].[Epsilon_Preference_lookup]
(
[MessageName] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Preference] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [rpt].[Epsilon_Preference_lookup] ADD CONSTRAINT [PK__Epsilon___6DB2EE9D03F1BA5C] PRIMARY KEY CLUSTERED  ([MessageName])
GO
