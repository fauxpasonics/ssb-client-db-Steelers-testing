SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [rpt].[vw_Merch_Discount_Amounts]
AS



select mo.ID OrderID
	  ,mo.CreatedOnUtc
	  ,dc.DiscountID
	  ,dc.Name
	  ,SUM(ISNULL(dc.DiscountPercentage,0)*mo.OrderSubtotalInclTax 
		   + ISNULL(dc.DiscountAmount,0) 
		   + case when IsFreeItem = 1 THEN DiscountAmountInclTax ELSE 0 END) DiscountTotal
from [ods].[Merch_Order] mo
	JOIN ods.Merch_OrderItem moi on moi.Orderid = mo.ID
	JOIN [ods].[Merch_DiscountUsageHistory] du on mo.ID = du.OrderID
	JOIN [rpt].[Merch_Discount_Codes] dc on dc.DiscountID = du.DisCountID
	JOin DimCustomer dimcust on dimcust.ssid = mo.customerid
							AND dimcust.sourcesystem = 'merch'
	JOIN [ods].[Steelers_500f_Customer] snu on snu.email = dimcust.EmailPrimary
Where snu.status = 'active'
	  AND snu.enrolled_at < mo.CreatedOnUtc
	  AND mo.OrderStatusId = 30
	  AND StoreId = 1
GROUP BY mo.ID
	    ,mo.CreatedOnUtc
	    ,dc.DiscountID
	    ,dc.Name



GO
