SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [src].[vw_TM_Audit_Export]
as

	SELECT 
		event_name
		,price_code
		,price_code_Desc
		,ISNULL(TRY_CAST([Plan] as int),0) as [Plan]
		,ISNULL(TRY_CAST(Single as int),0) as Single
		,ISNULL(TRY_CAST([Group] as int),0) as [Group]
		,ISNULL(TRY_CAST(Comp as int),0) as Comp
		,ISNULL(TRY_CAST(Held as int),0) as Held
		,ISNULL(TRY_CAST(Avail as int),0) as Avail
		,ISNULL(TRY_CAST([Kill] as int),0) as [Kill]
		,ISNULL(TRY_CAST(Revenue as decimal(18,6)), 0.0) as Revenue
		,pc_price_code
		,ISNULL(TRY_CAST(AuditHostSold as int),0) as AuditHostSold
		,ISNULL(TRY_CAST(AuditArchticsSold as int),0) as AuditArchticsSold
		,ISNULL(TRY_CAST(TicketArchticsSold as int),0) as TicketArchticsSold
		,ISNULL(TRY_CAST(TicketHostSold as int),0) as TicketHostSold
		,ISNULL(TRY_CAST(TicketAvailSold as int),0) as TicketAvailSold
		,ISNULL(TRY_CAST(DiffHostSold as int),0) as DiffHostSold
		,ISNULL(TRY_CAST(DiffArchticsSold as int),0) as DiffArchticsSold
		,ISNULL(TRY_CAST(event_id as int),0) as event_id
		,CASE 
			WHEN export_datetime like '%.' THEN TRY_CAST((export_datetime + '000') as datetime) 
			ELSE ISNULL(TRY_CAST(export_datetime as datetime),'1900-01-01') 
		 END as export_datetime
		,ISNULL(TRY_CAST(source_id as int),0) as source_id
		,SourceFileName
	FROM src.TM_Audit_Export



GO
