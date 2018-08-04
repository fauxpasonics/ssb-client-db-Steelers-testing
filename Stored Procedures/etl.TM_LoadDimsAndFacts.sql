SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[TM_LoadDimsAndFacts]
AS
BEGIN

	--The sproc is created solely to have a common etl that runs TM file loads regardless of whether they have Dim/Fact Model or not

	SET NOCOUNT ON;

	SELECT GETDATE()

END
GO
