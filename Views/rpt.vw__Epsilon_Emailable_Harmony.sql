SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [rpt].[vw__Epsilon_Emailable_Harmony]

AS 

SELECT pu.CustomerKey PROFILE_KEY
FROM [ods].[Epsilon_Profile_Updates] pu
	LEFT JOIN ods.Epsilon_SuppressionList suppression ON suppression.CustomerKey = pu.CustomerKey
WHERE EmailChannelOptOutFlag <> 'Y'
	  AND EmailAddressDeliveryStatus = 'G'
	  AND suppression.CustomerKey IS NULL





GO
