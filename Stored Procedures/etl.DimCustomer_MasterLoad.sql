SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






/*****	Revision History

DCH on 2018-02-14	-	Added data uploader load.

DCH on 2018-03-27	-	Added execution of etl.sp_Load_Data_Uploader_Customer.

*****/


CREATE PROCEDURE [etl].[DimCustomer_MasterLoad]
AS
BEGIN


-- Data Uploader
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Steelers', @LoadView = 'api.UploadDimCustomerStaging', @LogLevel = '2', @DropTemp = '1', @IsDataUploaderSource = '1'


-- 500F
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Steelers', @LoadView = '[etl].[vw_Load_DimCustomer_500f]', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'


-- Epsilon
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Steelers', @LoadView = '[etl].[vw_Load_DimCustomer_Epsilon]', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'


-- Merch
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Steelers', @LoadView = '[etl].[vw_Load_DimCustomer_Merch]', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'


-- TM
--EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Steelers', @LoadView = '[etl].[vw_Load_DimCustomer_TM]', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'


-- FanCentric
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Steelers', @LoadView = '[etl].[vw_Load_DimCustomer_FanCentric]', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'


--	DCH 2018-03-27:	this sproc needs to be executed before the following DimCustomer loads occur
EXEC etl.sp_Load_Data_Uploader_Customer;

-- Email Contests
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Steelers', @LoadView = '[ods].[vw_LoadDimCustomer_Contests]', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'


-- Email Events
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Steelers', @LoadView = '[ods].[vw_LoadDimCustomer_Events]', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'


END










GO
