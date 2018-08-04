SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [etl].[MDM_PostProcessing]

AS
BEGIN

DECLARE	@Time DATETIME = GETDATE()
DECLARE	@runDate DATE = GETDATE()

IF EXISTS (SELECT EndTime FROM [etl].[MDM_PostProcessing_Log] WHERE ProcID = 36 AND runDate = @runDate)
BEGIN
PRINT 'MDM_PostProcessing has already been run for @runDate = ' + CAST(@runDate AS VARCHAR(20))
RETURN
END

--EMAIL

INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,1,  @Time, NULL EXEC [etl].[Load_EpsilonActivities_LastNinety]		UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 1    SET @TIME = GETDATE()
																     																															 
INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,2,  @Time, NULL; EXEC [rpt].[PreCache_Cust_Email_1];				UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 2;   SET @TIME = GETDATE();
INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,3,  @Time, NULL; EXEC [rpt].[PreCache_Cust_Email_2];				UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 3;   SET @TIME = GETDATE();
INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,4,  @Time, NULL; EXEC [rpt].[PreCache_Cust_Email_3];				UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 4;   SET @TIME = GETDATE();
INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,5,  @Time, NULL; EXEC [rpt].[PreCache_Cust_Email_4];				UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 5;   SET @TIME = GETDATE();
INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,6,  @Time, NULL; EXEC [rpt].[PreCache_Cust_Email_5];				UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 6;   SET @TIME = GETDATE();
INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,7,  @Time, NULL; EXEC [rpt].[PreCache_Cust_Email_6];				UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 7;   SET @TIME = GETDATE();
INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,8,  @Time, NULL; EXEC [rpt].[PreCache_Cust_Email_7];				UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 8;   SET @TIME = GETDATE();
--INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,9,  @Time, NULL EXEC [rpt].[PreCache_Cust_Email_8];			UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 9;   SET @TIME = GETDATE();
INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,10, @Time, NULL; EXEC [rpt].[PreCache_Cust_Email_9];				UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 10;  SET @TIME = GETDATE();
INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,11, @Time, NULL; EXEC [rpt].[PreCache_Cust_Email_10];			UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 11;  SET @TIME = GETDATE();
INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,12, @Time, NULL; EXEC [rpt].[PreCache_Cust_Email_11];			UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 12;  SET @TIME = GETDATE();
INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,13, @Time, NULL; EXEC [rpt].[PreCache_Cust_Email_12];			UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 13;  SET @TIME = GETDATE();
INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,14, @Time, NULL; EXEC [rpt].[PreCache_Cust_Email_13];			UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 14;  SET @TIME = GETDATE();
INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,15, @Time, NULL; EXEC [rpt].[PreCache_Cust_Email_14];			UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 15;  SET @TIME = GETDATE();

--MERCH

INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,16, @Time, NULL; EXEC [rpt].[PreCache_Cust_Merch_1];				UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 16;  SET @TIME = GETDATE();
INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,17, @Time, NULL; EXEC [rpt].[PreCache_Cust_Merch_2];				UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 17;  SET @TIME = GETDATE();
INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,18, @Time, NULL; EXEC [rpt].[PreCache_Cust_Merch_3];				UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 18;  SET @TIME = GETDATE();
INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,19, @Time, NULL; EXEC [rpt].[PreCache_Cust_Merch_4];				UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 19;  SET @TIME = GETDATE();
INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,20, @Time, NULL; EXEC [rpt].[PreCache_Cust_Merch_MarketFreq];	UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 20;  SET @TIME = GETDATE();

--SNU

INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,21, @Time, NULL; EXEC [rpt].[PreCache_Cust_SNU_1];				UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 21;  SET @TIME = GETDATE();
INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,22, @Time, NULL; EXEC [rpt].[PreCache_Cust_SNU_2];				UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 22;  SET @TIME = GETDATE();
INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,23, @Time, NULL; EXEC [rpt].[PreCache_Cust_SNU_3];				UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 23;  SET @TIME = GETDATE();
INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,24, @Time, NULL; EXEC [rpt].[PreCache_Cust_SNU_4];				UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 24;  SET @TIME = GETDATE();
INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,25, @Time, NULL; EXEC [rpt].[PreCache_Cust_SNU_5];				UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 25;  SET @TIME = GETDATE();
INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,26, @Time, NULL; EXEC [rpt].[PreCache_Cust_SNU_6];				UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 26;  SET @TIME = GETDATE();
INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,27, @Time, NULL; EXEC [rpt].[PreCache_Cust_SNU_180];				UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 27;  SET @TIME = GETDATE();
INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,28, @Time, NULL; EXEC [rpt].[PreCache_Cust_SNU_Total];			UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 28;  SET @TIME = GETDATE();

--DB

INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,29,  @Time, NULL; EXEC [rpt].[PreCache_Cust_DB_1];				UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 29;   SET @TIME = GETDATE();
INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,30,  @Time, NULL; EXEC [rpt].[PreCache_Cust_DB_2];				UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 30;   SET @TIME = GETDATE();
INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,31,  @Time, NULL; EXEC [rpt].[PreCache_Cust_DB_3];				UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 31;   SET @TIME = GETDATE();
INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,32,  @Time, NULL; EXEC [rpt].[PreCache_Cust_DB_4];				UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 32;   SET @TIME = GETDATE();
INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,33,  @Time, NULL; EXEC [rpt].[PreCache_Cust_DB_5];				UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 33;   SET @TIME = GETDATE();
INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,34,  @Time, NULL; EXEC [rpt].[PreCache_Cust_DB_6];				UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 34;   SET @TIME = GETDATE();
INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,35,  @Time, NULL; EXEC [rpt].[PreCache_Cust_DB_7];				UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 35;   SET @TIME = GETDATE();
INSERT INTO [etl].[MDM_PostProcessing_Log] SELECT @runDate,36,  @Time, NULL; EXEC [rpt].[PreCache_Cust_DB_8];				UPDATE [etl].[MDM_PostProcessing_Log] SET EndTime = GETDATE() WHERE RunDate = @RunDate AND ProcID = 36;   SET @TIME = GETDATE();

END														























GO
