SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [ods].[vw_TM_LoadDimPriceCode] as (

	SELECT *
	, HASHBYTES('sha2_256', ISNULL(RTRIM(AutoAddMembershipName),'DBNULL_TEXT') + ISNULL(RTRIM(CardTemplate),'DBNULL_TEXT') + ISNULL(RTRIM(CardTemplateOverride),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),ClubGroupEnabled)),'DBNULL_BIT') + ISNULL(RTRIM(Code),'DBNULL_TEXT') + ISNULL(RTRIM(Color),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),CompIndicator)),'DBNULL_BIT') + ISNULL(RTRIM(DefaultHostOfferId),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),DimItemId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),DimSeasonId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),EventSallable)),'DBNULL_BIT') + ISNULL(RTRIM(FullPriceTicketTypeCode),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),InetFullPrice)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(10),InetMaxTicketsPerTran)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),InetMinTicketsPerTran)),'DBNULL_INT') + ISNULL(RTRIM(InetOfferText),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),InetOffSaleDatetime)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(25),InetOnSaleDatetime)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(10),InetPcSellable)),'DBNULL_BIT') + ISNULL(RTRIM(InetPriceCodeName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),IsEnabled)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsRenewal)),'DBNULL_BIT') + ISNULL(RTRIM(LedgerCode),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),LedgerId)),'DBNULL_INT') + ISNULL(RTRIM(MembershipExpirationDate),'DBNULL_TEXT') + ISNULL(RTRIM(MembershipIdForMembership),'DBNULL_TEXT') + ISNULL(RTRIM(MembershipName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),MembershipRequiredForPurpose)),'DBNULL_BIT') + ISNULL(RTRIM(MerchantCode),'DBNULL_TEXT') + ISNULL(RTRIM(MerchantColor),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),MerchantId)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(25),OffsaleDatetime)),'DBNULL_DATETIME') + ISNULL(RTRIM(OnPurchAddToAcctGroupId),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),OnsaleDatetime)),'DBNULL_DATETIME') + ISNULL(RTRIM(ParentPriceCode),'DBNULL_TEXT') + ISNULL(RTRIM(PC1),'DBNULL_TEXT') + ISNULL(RTRIM(PC2),'DBNULL_TEXT') + ISNULL(RTRIM(PC3),'DBNULL_TEXT') + ISNULL(RTRIM(PC4),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),PcLicenseFee)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),PcOther1)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),PcOther2)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(10),PcSellable)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(25),PcTax)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),PcTicket)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),Price)),'DBNULL_NUMBER') + ISNULL(RTRIM(PriceCode),'DBNULL_TEXT') + ISNULL(RTRIM(PriceCodeClass),'DBNULL_TEXT') + ISNULL(RTRIM(PriceCodeDesc),'DBNULL_TEXT') + ISNULL(RTRIM(PriceCodeGroup),'DBNULL_TEXT') + ISNULL(RTRIM(PriceCodeInfo1),'DBNULL_TEXT') + ISNULL(RTRIM(PriceCodeInfo2),'DBNULL_TEXT') + ISNULL(RTRIM(PriceCodeInfo3),'DBNULL_TEXT') + ISNULL(RTRIM(PriceCodeInfo4),'DBNULL_TEXT') + ISNULL(RTRIM(PriceCodeInfo5),'DBNULL_TEXT') + ISNULL(RTRIM(PricingMethod),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),PrintedPrice)),'DBNULL_NUMBER') + ISNULL(RTRIM(RequiredMembershipList),'DBNULL_TEXT') + ISNULL(RTRIM(SourceSystem),'DBNULL_TEXT') + ISNULL(RTRIM(SSID),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),SSID_event_id)),'DBNULL_INT') + ISNULL(RTRIM(SSID_price_code),'DBNULL_TEXT') + ISNULL(RTRIM(SSUpdatedBy),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),SSUpdatedDate)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(25),TaxRateA)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),TaxRateB)),'DBNULL_NUMBER') + ISNULL(RTRIM(CONVERT(varchar(25),TaxRateC)),'DBNULL_NUMBER') + ISNULL(RTRIM(TicketTemplate),'DBNULL_TEXT') + ISNULL(RTRIM(TicketTemplateOverride),'DBNULL_TEXT') + ISNULL(RTRIM(TicketType),'DBNULL_TEXT') + ISNULL(RTRIM(TicketTypeCategory),'DBNULL_TEXT') + ISNULL(RTRIM(TicketTypeCode),'DBNULL_TEXT') + ISNULL(RTRIM(TicketTypeDesc),'DBNULL_TEXT') + ISNULL(RTRIM(TicketTypeRelationship),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),TidFamilyId)),'DBNULL_INT') + ISNULL(RTRIM(TmPriceLevel),'DBNULL_TEXT') + ISNULL(RTRIM(TmTicketType),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),TotalEvents)),'DBNULL_INT') + ISNULL(RTRIM(TtCode),'DBNULL_TEXT')) DeltaHashKey
	FROM (

	SELECT 
	isnull(dSeason.DimSeasonId,-1) as DimSeasonId
	, isnull(dItem.DimItemId, -1) as DimItemId
	, pc.price_code as PriceCode
	, pc.price_code_desc as PriceCodeDesc
	, null as PriceCodeClass
	, case when len(pc.price_code) >= 1 then  substring(pc.price_code,1,1) end as PC1
	, case when len(pc.price_code) >= 2 then  substring(pc.price_code,2,1) end as PC2
	, case when len(pc.price_code) >= 3 then  substring(pc.price_code,3,1) end as PC3
	, case when len(pc.price_code) >= 4 then  substring(pc.price_code,4,1) end as PC4
	, case when pc.enabled = 'Y' then 1 else 0 end IsEnabled
	, case when pc.event_sellable = 'Y' then 1 else 0 end as EventSallable
	, case when pc.pc_sellable = 'Y' then 1 else 0 end as PcSellable
	, case when pc.inet_pc_sellable = 'Y' then 1 else 0 end as InetPcSellable
	, pc.total_events as TotalEvents
	, pc.price as Price
	, pc.parent_price_code as ParentPriceCode
	, pc.ticket_type_code as TicketTypeCode
	, pc.full_price_ticket_type_code as FullPriceTicketTypeCode
	, pc.tt_code as TtCode
	, pc.ticket_type as TicketType
	, pc.ticket_type_desc as TicketTypeDesc
	, pc.ticket_type_category as TicketTypeCategory
	, case when pc.comp_ind = 'Y' then 1 else 0 end as CompIndicator
	, pc.default_host_offer_id as DefaultHostOfferId
	, pc.ticket_type_relationship as TicketTypeRelationship
	, pc.pricing_method as PricingMethod
	, pc.tm_price_level as TmPriceLevel
	, pc.tm_ticket_type as TmTicketType
	, pc.ticket_template_override as TicketTemplateOverride
	, pc.ticket_template as TicketTemplate
	, pc.code as Code
	, pc.price_code_group as PriceCodeGroup
	, pc.price_code_info1 as PriceCodeInfo1
	, pc.price_code_info2 as PriceCodeInfo2
	, pc.price_code_info3 as PriceCodeInfo3
	, pc.price_code_info4 as PriceCodeInfo4
	, pc.price_code_info5 as PriceCodeInfo5
	, pc.color as Color
	, isnull(pc.printed_price,0) as PrintedPrice
	, isnull(pc.pc_ticket,0) as PcTicket
	, isnull(pc.pc_tax,0) as PcTax
	, isnull(pc.pc_licfee,0) as PcLicenseFee
	, isnull(pc.pc_other1,0) as PcOther1
	, isnull(pc.pc_other2,0) as PcOther2
	, isnull(pc.tax_rate_a,0) as TaxRateA
	, isnull(pc.tax_rate_b,0) as TaxRateB
	, isnull(pc.tax_rate_c,0) as TaxRateC
	, pc.onsale_datetime as OnsaleDatetime
	, pc.offsale_datetime as OffsaleDatetime
	, pc.inet_onsale_datetime as InetOnSaleDatetime
	, pc.inet_offsale_datetime as InetOffSaleDatetime
	, pc.inet_price_code_name as InetPriceCodeName
	, pc.inet_offer_text as InetOfferText
	, pc.inet_full_price InetFullPrice
	, pc.inet_min_tickets_per_tran as InetMinTicketsPerTran
	, pc.inet_max_tickets_per_tran as InetMaxTicketsPerTran
	, pc.tid_family_id as TidFamilyId
	, pc.on_purch_add_to_acct_group_id as OnPurchAddToAcctGroupId
	, pc.auto_add_membership_name as AutoAddMembershipName
	, pc.required_membership_list as RequiredMembershipList
	, pc.card_template_override as CardTemplateOverride
	, pc.card_template as CardTemplate
	, pc.ledger_id as LedgerId
	, pc.ledger_code as LedgerCode
	, pc.merchant_id as MerchantId
	, pc.merchant_code as MerchantCode
	, pc.merchant_color as MerchantColor
	, case when pc.membership_reqd_for_purchase = 'Y' then 1 else 0 end MembershipRequiredForPurpose
	, pc.membership_id_for_membership_event as MembershipIdForMembership
	, pc.membership_name as MembershipName
	, pc.membership_expiration_date as MembershipExpirationDate
	, case when pc.club_group_enabled = 'Y' then 1 else 0 end ClubGroupEnabled
	, 0 as IsRenewal
	, cast(null as nvarchar(255)) SSCreatedBy
	, pc.upd_user as [SSUpdatedBy]
	, cast(null as datetime) SSCreatedDate
	, pc.upd_datetime as [SSUpdatedDate]

	, cast(pc.event_id as varchar(20)) + ':' + cast(pc.price_code as varchar(20)) as [SSID]
	, pc.event_id SSID_event_id
	, pc.price_code SSID_price_code
	, CAST((SELECT etl.fnGetClientSetting('TM-SourceStyem')) AS NVARCHAR(255)) as [SourceSystem]

	FROM ods.TM_PriceCode pc
	LEFT OUTER JOIN dbo.DimSeason dSeason on pc.season_id = dSeason.SSID_season_id AND dSeason.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
	LEFT OUTER JOIN dbo.DimItem dItem on pc.event_id = dItem.SSID_event_id AND dItem.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))

	) a

)




































GO
