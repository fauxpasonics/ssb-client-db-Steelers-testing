SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [rpt].[DataCompareErrorResultsDetails]
	AS 
	SELECT 
	dcr.TestResultID,
	result.value('(DifferenceType/text())[1]','varchar(max)') as DifferenceType,
	result.value('(ID/text())[1]','varchar(max)') as ID,
	result.value('(ColumnName/text())[1]','varchar(max)') as ColumnName,
	result.value('(SourceValue/text())[1]','varchar(max)') as SourceValue,
	result.value('(TargetValue/text())[1]','varchar(max)') as TargetValue
FROM rpt.DataCompareErrorResults dcr
CROSS APPLY XMLResults.nodes('/CompareDifferenceResults/Results/Result') as Result(result)
GO
