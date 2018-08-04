SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[fnConvertSecondsToTime](@NumTotalSeconds BIGINT) 
RETURNS TIME
AS

BEGIN

DECLARE @time VARCHAR(20) 
DECLARE @numHours   INT = @NumTotalSeconds/3600 
DECLARE @numMinutes INT = (@NumTotalSeconds%3600)/60
DECLARE @numSeconds INT = @numTotalSeconds%60

			
SET @time = CONCAT(@numHours,':',@numMinutes,':',@numSeconds)

RETURN @time

END


GO
