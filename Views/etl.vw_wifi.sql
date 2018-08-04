SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [etl].[vw_wifi]
AS


SELECT COALESCE(NULLIF(a.email,''),NULLIF(b.email,''),NULLIF(c.email,''),NULLIF(d.email,'')) email
	  ,COALESCE(NULLIF(a.FirstName,''),NULLIF(b.FirstName,''),NULLIF(c.FirstName,''),NULLIF(d.FirstName,'')) FirstName
	  ,COALESCE(NULLIF(a.LastName,''),NULLIF(b.LastName,''),NULLIF(c.LastName,''),NULLIF(d.LastName,'')) LastName
	  ,COALESCE(NULLIF(d.GameDate,''),NULLIF(c.GameDate,''),NULLIF(b.GameDate,''),NULLIF(a.GameDate,'')) SSCreatedDate
FROM (select DISTINCT email from dbo.wifi_consolidated) x
LEFT JOIN (select * FROM [dbo].[Wifi_Consolidated] where GameDate = '2017-01-08') a  ON a.email = x.email
LEFT JOIN (select * FROM [dbo].[Wifi_Consolidated] where GameDate = '2017-01-01') b  ON b.email = x.email
LEFT JOIN (select * FROM [dbo].[Wifi_Consolidated] where GameDate = '2016-12-04') c  ON c.email = x.email 
LEFT JOIN (select * FROM [dbo].[Wifi_Consolidated] where GameDate = '2016-11-13') d  ON d.email = x.email
GO
