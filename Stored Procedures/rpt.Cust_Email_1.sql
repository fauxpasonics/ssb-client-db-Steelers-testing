SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [rpt].[Cust_Email_1]
as

select * from rpt.PreCache_Cust_Email_1_tbl
where IsReady = 1

GO
