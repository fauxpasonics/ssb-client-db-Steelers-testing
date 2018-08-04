CREATE TABLE [etl].[STG_FactTicketSales_ReporcessTransactionQueue]
(
[event_id] [int] NOT NULL,
[section_id] [decimal] (18, 6) NOT NULL,
[row_id] [decimal] (18, 6) NOT NULL,
[seat_num] [int] NOT NULL,
[ETL__CreatedDate] [datetime] NOT NULL
)
GO
