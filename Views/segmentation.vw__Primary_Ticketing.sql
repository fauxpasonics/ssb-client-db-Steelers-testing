SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE   VIEW [segmentation].[vw__Primary_Ticketing]
AS 
SELECT * FROM 
	( SELECT    ssbid.SSB_CRMSYSTEM_CONTACT_ID
              , fts.SSID_acct_id AS Archtics_Acct_ID
              , CAST(DimDate.CalDate AS DATE) AS Order_Date
              , ISNULL(DimSeasonHeader.SeasonYear, DimSeason.SeasonYear) AS Season_Year
              , DimSeasonHeader.Active AS Season_Is_Active
              , DimSeason.SeasonName AS Season_Name
			  , DimTeam.TeamFullName AS Opponent_Team_Name
			 -- , DimTeam.TeamShort AS Opponent_Team_Short_Name
              , DimEventHeader.EventName AS Event_Header_Name
              , DimEvent.EventCode AS Event_Code
              , DimEvent.EventName AS Event_Name
              , DimEvent.EventDesc AS Event_Desc
              , DimEvent.EventClass AS Event_Class
              , DimEvent.EventDate AS Event_Date
              , CAST(DimEvent.EventTime AS NVARCHAR(30)) Event_Time
		--, DimEvent.MajorCategoryTM
		--, DimEvent.MinorCategoryTM
              , DimEventHeader.EventHierarchyL1 AS Event_Hierarchy_L1
              , DimEventHeader.EventHierarchyL2 AS Event_Hierarchy_L2
              , DimEventHeader.EventHierarchyL3 AS Event_Hierarchy_L3
              , DimPriceCode.PriceCode AS Price_Code
              , DimPriceCode.PriceCodeDesc AS Price_Code_Description
              , DimPriceCode.PriceCodeGroup AS Price_Code_Group
              , DimPriceCode.PC1 AS PC1
              , DimPriceCode.PC2 AS PC2
              , DimPriceCode.PC3 AS PC3
              , DimPriceCode.PC4 AS PC4
			  , SUBSTRING(DimPriceCode.PriceCode,2,4) PRICE_TYPE
		--, DimClassTM.ClassName
		--, DimClassTM.ClassCategory
		--, DimClassTM.ClassType
              , DimSaleCode.SalesCode AS Sales_Code
              , DimSaleCode.SalesCodeName AS Sales_Code_Name
		--, DimSaleCode.SalesCodeDesc
		--, DimSaleCode.SalesCodeClass
              , DimPromo.PromoCode AS Promo_Code
              , DimPromo.PromoName AS Promo_Name
              , DimItem.ItemCode AS Item_Code
              , DimItem.ItemName AS Item_Name
              , DimItem.ItemDesc AS Item_Description
              , DimItem.ItemClass AS Item_Class
			  , DimPlan.PlanName AS Plan_Name
			  , DimPlan.PlanCode AS Plan_Code
              , DimTicketType.TicketTypeCode AS Ticket_Type_Code
              , DimTicketType.TicketTypeName AS Ticket_Type_Name
              , DimTicketType.TicketTypeDesc AS Ticket_Type_Description 
              , DimPlanType.PlanTypeCode AS Plan_Type_Code
              , DimPlanType.PlanTypeName AS Plan_Type_Name
              , DimPlanType.PlanTypeDesc AS Plan_Type_Description
              , DimSeatType.SeatTypeCode AS Seat_Type_Code
              , DimSeatType.SeatTypeName AS Seat_Type_Name
              , DimSeatType.SeatTypeDesc AS Seat_Type_Description
              , fts.IsHost AS Is_Host
              , fts.IsComp AS Is_Comp
              , fts.IsPremium AS Is_Premium
              , fts.IsDiscount AS Is_Discounted
              , fts.IsPlan AS Is_Plan
              , fts.IsPartial AS Is_Partial_Plan
              , fts.IsSingleEvent AS Is_Single_Event
              , fts.IsGroup AS Is_Group
              , fts.IsBroker AS Is_Broker
              , fts.IsRenewal AS Is_Renewal
              , fts.CompCode AS Comp_Code
              , DimSeat.SectionName AS Section_Name
              , DimSeat.RowName AS Row_Name
              , DimSeat.Seat AS First_Seat
              , fts.QtySeat AS Qty_Seat
              , fts.PcTicket AS Pc_Ticket
              , fts.PcPrice AS Pc_Price
              , fts.PcOther1 AS Pc_Other_1
              , fts.PcOther2 AS Pc_Other_2
              , fts.PcTax AS Pc_Tax
              , fts.PcLicenseFee AS Pc_License_Fee
              , fts.Surcharge AS Pc_Surcharge
              , fts.BlockPurchasePrice AS Block_Purchase_Price
              , fts.PaidStatus AS Paid_Status
              , fts.PaidAmount AS Paid_Amount
              , fts.OwedAmount AS Owed_Amount
              , AccountRep.AccountId AS  AccountRep_ID
              , AccountRep.FirstName  AS AccountRep_FirstName
              , AccountRep.MiddleName  AS AccountRep_MiddleName
              , AccountRep.LastName  AS AccountRep_LastName
			  , fts.SSCreatedBy Archtics_AddUser
			  , CASE WHEN concerts.eventCode IS NULL THEN 0 ELSE 1 END AS Is_Concert_Event
      FROM      dbo.FactTicketSales fts WITH ( NOLOCK )
                INNER JOIN rpt.vw_DimPriceCode DimPriceCode WITH ( NOLOCK ) ON DimPriceCode.DimPriceCodeId = fts.DimPriceCodeId
                INNER JOIN rpt.vw_DimTicketType DimTicketType WITH ( NOLOCK ) ON DimTicketType.DimTicketTypeId = fts.DimTicketTypeId
                INNER JOIN rpt.vw_DimPlanType DimPlanType WITH ( NOLOCK ) ON DimPlanType.DimPlanTypeId = fts.DimPlanTypeId
                INNER JOIN rpt.vw_DimSeatType DimSeatType WITH ( NOLOCK ) ON DimSeatType.DimSeatTypeId = fts.DimSeatTypeId
                INNER JOIN dbo.DimCustomer DimCustomer WITH ( NOLOCK ) ON DimCustomer.DimCustomerId = fts.DimCustomerId AND Dimcustomer.CustomerType = 'Primary' AND DimCustomer.SourceSystem = 'TM'
                INNER JOIN dbo.DimCustomer AccountRep WITH ( NOLOCK ) ON AccountRep.DimCustomerId = fts.DimCustomerIdSalesRep
                INNER JOIN rpt.vw_DimDate DimDate WITH ( NOLOCK ) ON DimDate.DimDateId = fts.DimDateId
                INNER JOIN rpt.vw_DimSeason DimSeason WITH ( NOLOCK ) ON DimSeason.DimSeasonId = fts.DimSeasonId
                INNER JOIN rpt.vw_DimEvent DimEvent WITH ( NOLOCK ) ON DimEvent.DimEventId = fts.DimEventId
                INNER JOIN dbo.dimcustomerssbid ssbid WITH ( NOLOCK ) ON ssbid.DimCustomerId = fts.DimCustomerId
                INNER JOIN rpt.vw_DimClassTM DimClassTM WITH ( NOLOCK ) ON DimClassTM.DimClassTMId = fts.DimClassTMId
                INNER JOIN rpt.vw_DimSalesCode DimSaleCode WITH ( NOLOCK ) ON DimSaleCode.DimSalesCodeId = fts.DimSalesCodeId
                INNER JOIN rpt.vw_DimPromo DimPromo WITH ( NOLOCK ) ON DimPromo.DimPromoID = fts.DimPromoId
                INNER JOIN rpt.vw_DimSeat DimSeat WITH ( NOLOCK ) ON DimSeat.DimSeatId = fts.DimSeatIdStart
                INNER JOIN rpt.vw_DimItem DimItem WITH ( NOLOCK ) ON DimItem.DimItemId = fts.DimItemId
                INNER JOIN rpt.vw_DimEventHeader DimEventHeader WITH ( NOLOCK ) ON DimEventHeader.DimEventHeaderId = DimEvent.DimEventHeaderId
                INNER JOIN rpt.vw_DimSeasonHeader DimSeasonHeader WITH ( NOLOCK ) ON DimSeasonHeader.DimSeasonHeaderId = DimEventHeader.DimSeasonHeaderId
				INNER JOIN rpt.vw_DimTeam DimTeam  WITH ( NOLOCK ) ON DimEventHeader.OpponentDimTeamId = DimTeam.DimTeamId
				INNER JOIN rpt.vw_DimPlan DimPlan WITH ( NOLOCK ) ON DimPlan.DimPlanId = fts.DimPlanId
				LEFT JOIN segmentation.ConcertEvents concerts (NOLOCK) ON concerts.EventCode = dimEvent.EventCode
    ) cy
	UNION ALL 
	SELECT * FROM
	( SELECT    ssbid.SSB_CRMSYSTEM_CONTACT_ID
              , fts.SSID_acct_id AS Archtics_Acct_ID
              , CAST(DimDate.CalDate AS DATE) AS Order_Date
              , ISNULL(DimSeasonHeader.SeasonYear, DimSeason.SeasonYear) AS Season_Year
              , DimSeasonHeader.Active AS Season_Is_Active
              , DimSeason.SeasonName AS Season_Name
			  , DimTeam.TeamFullName AS Opponent_Team_Name
			 -- , DimTeam.TeamShort AS Opponent_Team_Short_Name
              , DimEventHeader.EventName AS Event_Header_Name
              , DimEvent.EventCode AS Event_Code
              , DimEvent.EventName AS Event_Name
              , DimEvent.EventDesc AS Event_Desc
              , DimEvent.EventClass AS Event_Class
              , DimEvent.EventDate AS Event_Date
              , CAST(DimEvent.EventTime AS NVARCHAR(30)) Event_Time
		--, DimEvent.MajorCategoryTM
		--, DimEvent.MinorCategoryTM
              , DimEventHeader.EventHierarchyL1 AS Event_Hierarchy_L1
              , DimEventHeader.EventHierarchyL2 AS Event_Hierarchy_L2
              , DimEventHeader.EventHierarchyL3 AS Event_Hierarchy_L3
              , DimPriceCode.PriceCode AS Price_Code
              , DimPriceCode.PriceCodeDesc AS Price_Code_Description
              , DimPriceCode.PriceCodeGroup AS Price_Code_Group
              , DimPriceCode.PC1 AS PC1
              , DimPriceCode.PC2 AS PC2
              , DimPriceCode.PC3 AS PC3
              , DimPriceCode.PC4 AS PC4
			  , SUBSTRING(DimPriceCode.PriceCode,2,4) PRICE_TYPE
		--, DimClassTM.ClassName
		--, DimClassTM.ClassCategory
		--, DimClassTM.ClassType
              , DimSaleCode.SalesCode AS Sales_Code
              , DimSaleCode.SalesCodeName AS Sales_Code_Name
		--, DimSaleCode.SalesCodeDesc
		--, DimSaleCode.SalesCodeClass
              , DimPromo.PromoCode AS Promo_Code
              , DimPromo.PromoName AS Promo_Name
              , DimItem.ItemCode AS Item_Code
              , DimItem.ItemName AS Item_Name
              , DimItem.ItemDesc AS Item_Description
              , DimItem.ItemClass AS Item_Class
			  , DimPlan.PlanName AS Plan_Name
			  , DimPlan.PlanCode AS Plan_Code
              , DimTicketType.TicketTypeCode AS Ticket_Type_Code
              , DimTicketType.TicketTypeName AS Ticket_Type_Name
              , DimTicketType.TicketTypeDesc AS Ticket_Type_Description 
              , DimPlanType.PlanTypeCode AS Plan_Type_Code
              , DimPlanType.PlanTypeName AS Plan_Type_Name
              , DimPlanType.PlanTypeDesc AS Plan_Type_Description
              , DimSeatType.SeatTypeCode AS Seat_Type_Code
              , DimSeatType.SeatTypeName AS Seat_Type_Name
              , DimSeatType.SeatTypeDesc AS Seat_Type_Description
              , fts.IsHost AS Is_Host
              , fts.IsComp AS Is_Comp
              , fts.IsPremium AS Is_Premium
              , fts.IsDiscount AS Is_Discounted
              , fts.IsPlan AS Is_Plan
              , fts.IsPartial AS Is_Partial_Plan
              , fts.IsSingleEvent AS Is_Single_Event
              , fts.IsGroup AS Is_Group
              , fts.IsBroker AS Is_Broker
              , fts.IsRenewal AS Is_Renewal
              , fts.CompCode AS Comp_Code
              , DimSeat.SectionName AS Section_Name
              , DimSeat.RowName AS Row_Name
              , DimSeat.Seat AS First_Seat
              , fts.QtySeat AS Qty_Seat
              , fts.PcTicket AS Pc_Ticket
              , fts.PcPrice AS Pc_Price
              , fts.PcOther1 AS Pc_Other_1
              , fts.PcOther2 AS Pc_Other_2
              , fts.PcTax AS Pc_Tax
              , fts.PcLicenseFee AS Pc_License_Fee
              , fts.Surcharge AS Pc_Surcharge
              , fts.BlockPurchasePrice AS Block_Purchase_Price
              , fts.PaidStatus AS Paid_Status
              , fts.PaidAmount AS Paid_Amount
              , fts.OwedAmount AS Owed_Amount
              , AccountRep.AccountId AS  AccountRep_ID
              , AccountRep.FirstName  AS AccountRep_FirstName
              , AccountRep.MiddleName  AS AccountRep_MiddleName
              , AccountRep.LastName  AS AccountRep_LastName
			  , fts.SSCreatedBy Archtics_AddUser
			  , CASE WHEN concerts.eventCode IS NULL THEN 0 ELSE 1 END AS Is_Concert_Event
      FROM      dbo.FactTicketSalesHistory fts WITH ( NOLOCK )
                INNER JOIN rpt.vw_DimPriceCode DimPriceCode WITH ( NOLOCK ) ON DimPriceCode.DimPriceCodeId = fts.DimPriceCodeId
                INNER JOIN rpt.vw_DimTicketType DimTicketType WITH ( NOLOCK ) ON DimTicketType.DimTicketTypeId = fts.DimTicketTypeId
                INNER JOIN rpt.vw_DimPlanType DimPlanType WITH ( NOLOCK ) ON DimPlanType.DimPlanTypeId = fts.DimPlanTypeId
                INNER JOIN rpt.vw_DimSeatType DimSeatType WITH ( NOLOCK ) ON DimSeatType.DimSeatTypeId = fts.DimSeatTypeId
                INNER JOIN dbo.DimCustomer DimCustomer WITH ( NOLOCK ) ON DimCustomer.DimCustomerId = fts.DimCustomerId AND Dimcustomer.CustomerType = 'Primary' AND DimCustomer.SourceSystem = 'TM'
                INNER JOIN dbo.DimCustomer AccountRep WITH ( NOLOCK ) ON AccountRep.DimCustomerId = fts.DimCustomerIdSalesRep
                INNER JOIN rpt.vw_DimDate DimDate WITH ( NOLOCK ) ON DimDate.DimDateId = fts.DimDateId
                INNER JOIN rpt.vw_DimSeason DimSeason WITH ( NOLOCK ) ON DimSeason.DimSeasonId = fts.DimSeasonId
                INNER JOIN rpt.vw_DimEvent DimEvent WITH ( NOLOCK ) ON DimEvent.DimEventId = fts.DimEventId
                INNER JOIN dbo.dimcustomerssbid ssbid WITH ( NOLOCK ) ON ssbid.DimCustomerId = fts.DimCustomerId
                INNER JOIN rpt.vw_DimClassTM DimClassTM WITH ( NOLOCK ) ON DimClassTM.DimClassTMId = fts.DimClassTMId
                INNER JOIN rpt.vw_DimSalesCode DimSaleCode WITH ( NOLOCK ) ON DimSaleCode.DimSalesCodeId = fts.DimSalesCodeId
                INNER JOIN rpt.vw_DimPromo DimPromo WITH ( NOLOCK ) ON DimPromo.DimPromoID = fts.DimPromoId
                INNER JOIN rpt.vw_DimSeat DimSeat WITH ( NOLOCK ) ON DimSeat.DimSeatId = fts.DimSeatIdStart
                INNER JOIN rpt.vw_DimItem DimItem WITH ( NOLOCK ) ON DimItem.DimItemId = fts.DimItemId
                INNER JOIN rpt.vw_DimEventHeader DimEventHeader WITH ( NOLOCK ) ON DimEventHeader.DimEventHeaderId = DimEvent.DimEventHeaderId
                INNER JOIN rpt.vw_DimSeasonHeader DimSeasonHeader WITH ( NOLOCK ) ON DimSeasonHeader.DimSeasonHeaderId = DimEventHeader.DimSeasonHeaderId
				INNER JOIN rpt.vw_DimTeam DimTeam  WITH ( NOLOCK ) ON DimEventHeader.OpponentDimTeamId = DimTeam.DimTeamId
				INNER JOIN rpt.vw_DimPlan DimPlan WITH ( NOLOCK ) ON DimPlan.DimPlanId = fts.DimPlanId
				LEFT JOIN segmentation.ConcertEvents concerts (NOLOCK) ON concerts.EventCode = dimEvent.EventCode
	
	 WHERE DimEvent.EventDate >= DATEADD(YEAR, -3, GETDATE())
    )pys
	






GO
