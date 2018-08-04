SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [etl].[Merch_PostProcess_PointOfSale]
AS

BEGIN


EXEC etl.LoadDimPOSAccount
;

EXEC etl.LoadDimPOSProduct
;

EXEC etl.LoadFactPointOfSale
;

EXEC etl.LoadFactPointOfSaleDetail
;



END








GO
