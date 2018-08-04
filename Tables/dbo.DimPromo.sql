CREATE TABLE [dbo].[DimPromo]
(
[DimPromoID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_UpdatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_CreatedDate] [datetime] NULL,
[ETL_UpdatedDate] [datetime] NULL,
[ETL_SSID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_SSID_promo_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[ETL_SourceSystem] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PromoCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PromoName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[promo_inet_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[promo_inet_desc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[promo_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[promo_group_sell_flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[inet_start_datetime] [datetime] NULL,
[inet_end_datetime] [datetime] NULL,
[archtics_start_datetime] [datetime] NULL,
[archtics_end_datetime] [datetime] NULL,
[add_Datetime] [datetime] NULL,
[add_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[upd_datetime] [datetime] NULL
)
GO
ALTER TABLE [dbo].[DimPromo] ADD CONSTRAINT [PK_DimPromo] PRIMARY KEY CLUSTERED  ([DimPromoID])
GO
