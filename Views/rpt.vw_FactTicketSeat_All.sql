SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [rpt].[vw_FactTicketSeat_All] AS (

	SELECT CAST('Active' AS NVARCHAR(25)) SourceView, * FROM rpt.vw_FactTicketSeat

	UNION ALL

	SELECT CAST('History' AS NVARCHAR(25)) SourceView, * FROM rpt.vw_FactTicketSeat_History

)

GO
