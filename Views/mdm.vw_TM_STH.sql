SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [mdm].[vw_TM_STH] AS
(

SELECT dc.dimcustomerid, STH, dc.accountid FROM dbo.dimcustomer dc
--change to STH Flag rather than hard coded to dynamically change season as renewals come in. '>= season year -1'

LEFT JOIN (	SELECT DISTINCT dimcustomerid, 1 AS 'STH' FROM dbo.factticketsales a
JOIN dbo.DimPlan dp ON dp.DimPlanId = a.DimPlanId
	WHERE plancode IN('15FS', '16FS') ) sth ON dc.dimcustomerid = sth.dimcustomerid
	








)



GO
