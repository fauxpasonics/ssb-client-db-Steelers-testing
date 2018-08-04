SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [src].[vw_TM_Attrib]
as

select getdate() placeholder

--SELECT [acct_id]
--      ,[cust_name_id]
--      ,[attrib_id]
--      ,[attrib_seq_num]
--      ,[Category]
--      ,[attrib_name]
--      ,[attrib_value]
--      ,[attrib_comment]
--      ,[upd_datetime]
--      ,[upd_user]
--	  ,HASHBYTES('sha2_256', ISNULL(RTRIM(acct_id),'DBNULL_TEXT') + ISNULL(RTRIM(cust_name_id),'DBNULL_TEXT') + ISNULL(RTRIM(attrib_id),'DBNULL_TEXT') +
--	   ISNULL(RTRIM(attrib_seq_num),'DBNULL_TEXT') + ISNULL(RTRIM(Category),'DBNULL_TEXT') + ISNULL(RTRIM(attrib_name),'DBNULL_TEXT') + 
--	   ISNULL(RTRIM(attrib_value),'DBNULL_TEXT') + ISNULL(RTRIM(attrib_comment),'DBNULL_TEXT') + ISNULL(RTRIM(upd_datetime),'DBNULL_TEXT') + ISNULL(RTRIM(upd_user),'DBNULL_TEXT')) SrcHashKey
--  FROM [src].[TM_Attrib]









GO
