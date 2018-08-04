SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [ods].[vw_yinzcam_DimCustomer_stage]
AS
 
WITH CTE_AllIDs (yinzid, SSCreatedDate, SSUpdatedDate)
AS ( SELECT YinzId
	 	  ,MIN(ETL_CreatedDate) AS SSCreatedDate
		  ,MAX(ETL_UpdatedDate) LastUpdatedDate	  
	 FROM ( SELECT yinzid ,ETL_UpdatedDate ,ETL_CreatedDate FROM ods.Yinzcam_500f		UNION ALL
	 	   SELECT yinzid  ,ETL_UpdatedDate ,ETL_CreatedDate FROM ods.Yinzcam_Facebook	UNION ALL
	 	   SELECT yinzid  ,ETL_UpdatedDate ,ETL_CreatedDate FROM ods.Yinzcam_Generic	UNION ALL
	 	   SELECT yinzid  ,ETL_UpdatedDate ,ETL_CreatedDate FROM ods.Yinzcam_TM
	 	 )x
	 GROUP BY YinzID
	)

SELECT AllIDs.yinzid
	 , AllIDs.SSCreatedDate
	 , AllIDs.SSUpdatedDate
	 , COALESCE(tm.first_name,fb.first_name,yinz.first_name)									AS FirstName
	 , tm.middle_initial																		AS MiddleName
	 , COALESCE(tm.last_name,fb.last_name,yinz.last_name)										AS LastName
	 , COALESCE(tm.email,snu.email,fb.email,yinz.email)											AS EmailPrimary
	 , COALESCE(fb.gender,yinz.gender)															AS Gender
	 , yinz.birthdate																			AS Birthday
	 , tm.address_street_1																		AS AddressPrimaryStreet
	 , tm.address_city																			AS AddressPrimaryCity
	 , tm.address_division_1																	AS AddressPrimaryState
	 , COALESCE(tm.address_postal, yinz.address_postal)											AS AddressPrimaryZip
	 , COALESCE(tm.address_country, yinz.address_country)										AS AddressPrimaryCountry
	 , COALESCE(tm.phone, yinz.phone)															AS PhonePrimary
	 , CASE WHEN NULLIF(tm.id_global,'') IS NULL OR NULLIF(tm.id_name,'') IS NULL THEN NULL		 
	  	    ELSE CONCAT('TM-',tm.id_global,':',id_name)												 
	   END																						AS Customer_Matchkey
FROM CTE_AllIDs AllIDs
	LEFT JOIN ods.Yinzcam_500f			snu			ON snu.YinzID	= AllIDs.Yinzid
	LEFT JOIN ods.Yinzcam_Facebook		fb			ON fb.YinzID	= AllIDs.Yinzid
	LEFT JOIN ods.Yinzcam_Generic		yinz		ON yinz.YinzID	= AllIDs.Yinzid
	LEFT JOIN ods.Yinzcam_TM			tm			ON tm.YinzID	= AllIDs.Yinzid





	


















GO
