SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [rpt].[Cust_Email_3]
as
select * from [rpt].[PreCache_Cust_Email_3_tbl]
where IsReady = 1

GO
