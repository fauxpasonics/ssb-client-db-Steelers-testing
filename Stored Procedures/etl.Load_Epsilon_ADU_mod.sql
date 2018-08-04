SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [etl].[Load_Epsilon_ADU_mod]

AS


TRUNCATE TABLE ods.Epsilon_ADU_mod

INSERT INTO ods.Epsilon_ADU_mod

SELECT  PROFILE_KEY
	   ,MAILING_NAME
	   ,ACTION_CODE
	   ,SOURCE_CODE
	   ,CAST(LEFT(ACTION_DTTM,8) AS DATE) ACTION_DATE
FROM ods.Epsilon_ADU


DROP INDEX [IDX_PROFILE_KEY]  ON [ods].[Epsilon_ADU_mod]
DROP INDEX [IDX_MAILING_NAME] ON [ods].[Epsilon_ADU_mod]
DROP INDEX [IDX_ACTION_CODE]  ON [ods].[Epsilon_ADU_mod]
DROP INDEX [IDX_SOURCE_CODE]  ON [ods].[Epsilon_ADU_mod]
DROP INDEX [IDX_ACTION_DATE]  ON [ods].[Epsilon_ADU_mod]


CREATE NONCLUSTERED INDEX [IDX_PROFILE_KEY] ON ods.Epsilon_ADU_mod ([PROFILE_KEY] ASC)
CREATE NONCLUSTERED INDEX [IDX_MAILING_NAME] ON ods.Epsilon_ADU_mod ([MAILING_NAME] ASC)
CREATE NONCLUSTERED INDEX [IDX_ACTION_CODE] ON ods.Epsilon_ADU_mod ([ACTION_CODE] ASC)
CREATE NONCLUSTERED INDEX [IDX_SOURCE_CODE] ON ods.Epsilon_ADU_mod ([SOURCE_CODE] ASC)
CREATE NONCLUSTERED INDEX [IDX_ACTION_DATE] ON ods.Epsilon_ADU_mod ([ACTION_DATE] ASC)


DROP INDEX [IDX_CustomerKey]	 ON ods.Epsilon_Activities 
DROP INDEX [IDX_MessageName]	 ON ods.Epsilon_Activities 
DROP INDEX [IDX_Action]			 ON ods.Epsilon_Activities 
DROP INDEX [IDX_ActionTimestamp] ON ods.Epsilon_Activities 


CREATE NONCLUSTERED INDEX [IDX_CustomerKey]		 ON ods.Epsilon_Activities ([CustomerKey] ASC)
CREATE NONCLUSTERED INDEX [IDX_MessageName]		 ON ods.Epsilon_Activities  ([MessageName] ASC)
CREATE NONCLUSTERED INDEX [IDX_Action]			 ON ods.Epsilon_Activities ([Action] ASC)
CREATE NONCLUSTERED INDEX [IDX_ActionTimestamp]  ON ods.Epsilon_Activities ([ActionTimestamp] ASC)




GO
