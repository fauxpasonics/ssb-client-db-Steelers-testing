SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [ods].[LoadAttrib]
as
BEGIN
SET NOCOUNT ON;

select getdate() placeholder

--MERGE dbo.TM_Attrib AS target

--USING 
--( SELECT 
--	   [acct_id]
--      ,[cust_name_id]
--      ,[attrib_id]
--      ,[attrib_seq_num]
--      ,[Category]
--      ,[attrib_name]
--      ,[attrib_value]
--      ,[attrib_comment]
--      ,[upd_datetime]
--      ,[upd_user]
--      ,[SrcHashKey]
--  FROM [src].[vw_TM_Attrib]
--) as source
--     ON source.[attrib_id] = Target.[attrib_id]
--WHEN MATCHED AND source.SrcHashKey <> target.HashKey
-- THEN UPDATE SET 
--    [acct_id]			= Source.[acct_id],
--    [cust_name_id]		= Source.[cust_name_id],
--    [attrib_seq_num]	= Source.[attrib_seq_num],
--    [Category]			= Source.[Category],
--    [attrib_name]		= Source.[attrib_name],
--    [attrib_value]		= Source.[attrib_value],
--    [attrib_comment]	= Source.[attrib_comment],
--    [upd_datetime]		= Source.[upd_datetime],
--    [upd_user]			= Source.[upd_user],
--    [HashKey]			= Source.[SrcHashKey]
--WHEN NOT MATCHED THEN INSERT
--    (
--        [attrib_id], 
--        [acct_id], 
--        [cust_name_id], 
--        [attrib_seq_num], 
--        [Category], 
--        [attrib_name], 
--        [attrib_value], 
--        [attrib_comment], 
--        [upd_datetime], 
--        [upd_user], 
--        [HashKey]
--    )
--    VALUES (
--        source.[attrib_id], 
--        source.[acct_id], 
--        source.[cust_name_id], 
--        source.[attrib_seq_num], 
--        source.[Category], 
--        source.[attrib_name], 
--        source.[attrib_value], 
--        source.[attrib_comment], 
--        source.[upd_datetime], 
--        source.[upd_user], 
--        source.[SrcHashKey]
--    );
	
	
END








GO
