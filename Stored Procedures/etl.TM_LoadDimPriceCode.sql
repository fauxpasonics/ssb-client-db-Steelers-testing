SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[TM_LoadDimPriceCode] 

as
BEGIN

DECLARE @RunTime datetime = getdate()

MERGE dbo.DimPriceCode AS mytarget

USING (select * from ods.vw_TM_LoadDimPriceCode) as mySource
     ON
		myTarget.SourceSystem = mySource.SourceSystem		
		and myTarget.SSID_event_id = mySource.SSID_event_id
		and myTarget.SSID_price_code = mySource.SSID_price_code

WHEN MATCHED AND isnull(mySource.DeltaHashKey,-1) <> isnull(myTarget.DeltaHashKey, -1)
THEN UPDATE SET 

	myTarget.DimSeasonId = mySource.DimSeasonId
	, myTarget.DimItemId = mySource.DimItemId
	, myTarget.PriceCode = mySource.PriceCode
	, myTarget.PriceCodeDesc = mySource.PriceCodeDesc
	, myTarget.PriceCodeClass = mySource.PriceCodeClass
	, myTarget.PC1 = mySource.PC1
	, myTarget.PC2 = mySource.PC2
	, myTarget.PC3 = mySource.PC3
	, myTarget.PC4 = mySource.PC4
	, myTarget.IsEnabled = mySource.IsEnabled
	, myTarget.EventSallable = mySource.EventSallable
	, myTarget.PcSellable = mySource.PcSellable
	, myTarget.InetPcSellable = mySource.InetPcSellable
	, myTarget.TotalEvents = mySource.TotalEvents
	, myTarget.Price = mySource.Price
	, myTarget.ParentPriceCode = mySource.ParentPriceCode
	, myTarget.TicketTypeCode = mySource.TicketTypeCode
	, myTarget.FullPriceTicketTypeCode = mySource.FullPriceTicketTypeCode
	, myTarget.TtCode = mySource.TtCode
	, myTarget.TicketType = mySource.TicketType
	, myTarget.TicketTypeDesc = mySource.TicketTypeDesc
	, myTarget.TicketTypeCategory = mySource.TicketTypeCategory
	, myTarget.CompIndicator = mySource.CompIndicator
	, myTarget.DefaultHostOfferId = mySource.DefaultHostOfferId
	, myTarget.TicketTypeRelationship = mySource.TicketTypeRelationship
	, myTarget.PricingMethod = mySource.PricingMethod
	, myTarget.TmPriceLevel = mySource.TmPriceLevel
	, myTarget.TmTicketType = mySource.TmTicketType
	, myTarget.TicketTemplateOverride = mySource.TicketTemplateOverride
	, myTarget.TicketTemplate = mySource.TicketTemplate
	, myTarget.Code = mySource.Code
	, myTarget.PriceCodeGroup = mySource.PriceCodeGroup
	, myTarget.PriceCodeInfo1 = mySource.PriceCodeInfo1
	, myTarget.PriceCodeInfo2 = mySource.PriceCodeInfo2
	, myTarget.PriceCodeInfo3 = mySource.PriceCodeInfo3
	, myTarget.PriceCodeInfo4 = mySource.PriceCodeInfo4
	, myTarget.PriceCodeInfo5 = mySource.PriceCodeInfo5
	, myTarget.Color = mySource.Color
	, myTarget.PrintedPrice = mySource.PrintedPrice
	, myTarget.PcTicket = mySource.PcTicket
	, myTarget.PcTax = mySource.PcTax
	, myTarget.PcLicenseFee = mySource.PcLicenseFee
	, myTarget.PcOther1 = mySource.PcOther1
	, myTarget.PcOther2 = mySource.PcOther2
	, myTarget.TaxRateA = mySource.TaxRateA
	, myTarget.TaxRateB = mySource.TaxRateB
	, myTarget.TaxRateC = mySource.TaxRateC
	, myTarget.OnsaleDatetime = mySource.OnsaleDatetime
	, myTarget.OffsaleDatetime = mySource.OffsaleDatetime
	, myTarget.InetOnSaleDatetime = mySource.InetOnSaleDatetime
	, myTarget.InetOffSaleDatetime = mySource.InetOffSaleDatetime
	, myTarget.InetPriceCodeName = mySource.InetPriceCodeName
	, myTarget.InetOfferText = mySource.InetOfferText
	, myTarget.InetFullPrice = mySource.InetFullPrice
	, myTarget.InetMinTicketsPerTran = mySource.InetMinTicketsPerTran
	, myTarget.InetMaxTicketsPerTran = mySource.InetMaxTicketsPerTran
	, myTarget.TidFamilyId = mySource.TidFamilyId
	, myTarget.OnPurchAddToAcctGroupId = mySource.OnPurchAddToAcctGroupId
	, myTarget.AutoAddMembershipName = mySource.AutoAddMembershipName
	, myTarget.RequiredMembershipList = mySource.RequiredMembershipList
	, myTarget.CardTemplateOverride = mySource.CardTemplateOverride
	, myTarget.CardTemplate = mySource.CardTemplate
	, myTarget.LedgerId = mySource.LedgerId
	, myTarget.LedgerCode = mySource.LedgerCode
	, myTarget.MerchantId = mySource.MerchantId
	, myTarget.MerchantCode = mySource.MerchantCode
	, myTarget.MerchantColor = mySource.MerchantColor
	, myTarget.MembershipRequiredForPurpose = mySource.MembershipRequiredForPurpose
	, myTarget.MembershipIdForMembership = mySource.MembershipIdForMembership
	, myTarget.MembershipName = mySource.MembershipName
	, myTarget.MembershipExpirationDate = mySource.MembershipExpirationDate
	, myTarget.ClubGroupEnabled = mySource.ClubGroupEnabled
	, myTarget.IsRenewal = mySource.IsRenewal
	, myTarget.SSCreatedBy = mySource.SSCreatedBy
	, myTarget.SSUpdatedBy = mySource.SSUpdatedBy
	, myTarget.SSCreatedDate = mySource.SSCreatedDate
	, myTarget.SSUpdatedDate = mySource.SSUpdatedDate
	, myTarget.SSID = mySource.SSID
	, myTarget.SSID_event_id = mySource.SSID_event_id
	, myTarget.SSID_price_code = mySource.SSID_price_code
	, myTarget.SourceSystem = mySource.SourceSystem
	, myTarget.DeltaHashKey = mySource.DeltaHashKey

	, UpdatedBy = 'CI'
	, UpdatedDate = @RunTime


WHEN NOT MATCHED THEN INSERT
    (
		DimSeasonId, DimItemId, PriceCode
		, PriceCodeDesc, PriceCodeClass, PC1, PC2, PC3, PC4, IsEnabled, EventSallable, PcSellable, InetPcSellable, TotalEvents, Price, ParentPriceCode, TicketTypeCode, FullPriceTicketTypeCode, TtCode, TicketType, TicketTypeDesc, TicketTypeCategory, CompIndicator, DefaultHostOfferId, TicketTypeRelationship, PricingMethod, TmPriceLevel, TmTicketType, TicketTemplateOverride, TicketTemplate, Code, PriceCodeGroup
		, PriceCodeInfo1, PriceCodeInfo2, PriceCodeInfo3, PriceCodeInfo4, PriceCodeInfo5, Color
		, PrintedPrice, PcTicket, PcTax, PcLicenseFee, PcOther1, PcOther2, TaxRateA, TaxRateB, TaxRateC
		, OnsaleDatetime, OffsaleDatetime, InetOnSaleDatetime, InetOffSaleDatetime, InetPriceCodeName, InetOfferText
		, InetFullPrice
		, InetMinTicketsPerTran, InetMaxTicketsPerTran, TidFamilyId, OnPurchAddToAcctGroupId, AutoAddMembershipName, RequiredMembershipList, CardTemplateOverride, CardTemplate
		, LedgerId, LedgerCode, MerchantId, MerchantCode, MerchantColor, MembershipRequiredForPurpose, MembershipIdForMembership, MembershipName, MembershipExpirationDate, ClubGroupEnabled, IsRenewal
		, SSCreatedBy, SSUpdatedBy, SSCreatedDate, SSUpdatedDate, SSID, SSID_event_id, SSID_price_code, SourceSystem, DeltaHashKey, CreatedBy, UpdatedBy, CreatedDate, UpdatedDate, IsDeleted, DeleteDate
    )
    VALUES (
	
		mySource.DimSeasonId
		, mySource.DimItemId
		, mySource.PriceCode
		, mySource.PriceCodeDesc
		, mySource.PriceCodeClass
		, mySource.PC1
		, mySource.PC2
		, mySource.PC3
		, mySource.PC4
		, mySource.IsEnabled
		, mySource.EventSallable
		, mySource.PcSellable
		, mySource.InetPcSellable
		, mySource.TotalEvents
		, mySource.Price
		, mySource.ParentPriceCode
		, mySource.TicketTypeCode
		, mySource.FullPriceTicketTypeCode
		, mySource.TtCode
		, mySource.TicketType
		, mySource.TicketTypeDesc
		, mySource.TicketTypeCategory
		, mySource.CompIndicator
		, mySource.DefaultHostOfferId
		, mySource.TicketTypeRelationship
		, mySource.PricingMethod
		, mySource.TmPriceLevel
		, mySource.TmTicketType
		, mySource.TicketTemplateOverride
		, mySource.TicketTemplate
		, mySource.Code
		, mySource.PriceCodeGroup
		, mySource.PriceCodeInfo1
		, mySource.PriceCodeInfo2
		, mySource.PriceCodeInfo3
		, mySource.PriceCodeInfo4
		, mySource.PriceCodeInfo5
		, mySource.Color
		, mySource.PrintedPrice
		, mySource.PcTicket
		, mySource.PcTax
		, mySource.PcLicenseFee
		, mySource.PcOther1
		, mySource.PcOther2
		, mySource.TaxRateA
		, mySource.TaxRateB
		, mySource.TaxRateC
		, mySource.OnsaleDatetime
		, mySource.OffsaleDatetime
		, mySource.InetOnSaleDatetime
		, mySource.InetOffSaleDatetime
		, mySource.InetPriceCodeName
		, mySource.InetOfferText
		, mySource.InetFullPrice
		, mySource.InetMinTicketsPerTran
		, mySource.InetMaxTicketsPerTran
		, mySource.TidFamilyId
		, mySource.OnPurchAddToAcctGroupId
		, mySource.AutoAddMembershipName
		, mySource.RequiredMembershipList
		, mySource.CardTemplateOverride
		, mySource.CardTemplate
		, mySource.LedgerId
		, mySource.LedgerCode
		, mySource.MerchantId
		, mySource.MerchantCode
		, mySource.MerchantColor
		, mySource.MembershipRequiredForPurpose
		, mySource.MembershipIdForMembership
		, mySource.MembershipName
		, mySource.MembershipExpirationDate
		, mySource.ClubGroupEnabled
		, mySource.IsRenewal
		, mySource.SSCreatedBy
		, mySource.SSUpdatedBy
		, mySource.SSCreatedDate
		, mySource.SSUpdatedDate
		, mySource.SSID
		, mySource.SSID_event_id
		, mySource.SSID_price_code
		, mySource.SourceSystem
		, mySource.DeltaHashKey
	
		, 'CI' --CreatedBy
		, 'CI' --UpdatedBy
		, @RunTime --CreatedDate
		, @RunTime --UpdatedDate
		, 0 --IsDeleted
		, null --DeleteDate

    );

END

GO
