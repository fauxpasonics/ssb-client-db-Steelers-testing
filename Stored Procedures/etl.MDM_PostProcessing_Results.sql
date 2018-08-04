SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [etl].[MDM_PostProcessing_Results] @RunDate DATE = '1900-01-01'

AS 

IF @RunDate = '1900-01-01' 
BEGIN
SET @RunDate = (SELECT MAX(RunDate) FROM [etl].[MDM_PostProcessing_Log])
END

CREATE TABLE #output(
RunDate DATE
,ProcID INT
,ProcName VARCHAR(100)
,StartTime DATETIME
,endtime DATETIME
,numTotalSeconds INT
,numHours		 INT
,numMinutes		 INT
,numSeconds		 INT
)

INSERT INTO #output
        ( RunDate
		  ,ProcId
		  ,ProcName 
          ,StartTime 
          ,endtime 
          ,numTotalSeconds 
          ,numHours
		  ,numMinutes
		  ,numSeconds
        )

SELECT runDate
	   ,ProcID
	   ,ProcName
	   ,StartTime
	   ,EndTime
	   ,DATEDIFF(SECOND,StartTime,EndTime) AS numSeconds
	   ,DATEDIFF(SECOND,StartTime,EndTime)/3600 numHours 
	   ,(DATEDIFF(SECOND,StartTime,EndTime)%3600)/60 numMinutes
	   ,(DATEDIFF(SECOND,StartTime,EndTime)%3600)%60 numSeconds
FROM (SELECT lg.runDate
			,lg.ProcId
			,name.ProcName
			,StartTime
			,EndTime	  
	  FROM [etl].[MDM_PostProcessing_Log] lg
	  	JOIN [etl].[MDM_PostProcessing_ProcLookup] name ON lg.ProcID = name.ProcID
	  WHERE runDate = @RunDate
	  
	  UNION ALL

	  SELECT lg.runDate
		    ,99 AS ProcId
		    ,'Total'
		    ,MIN(StartTime)
		    ,MAX(EndTime)	  
	  FROM [etl].[MDM_PostProcessing_Log] lg	  	
	  WHERE runDate = @RunDate
	  GROUP BY lg.runDate
	  )x
ORDER BY ProcID


SELECT runDate
	   ,ProcName
	   ,CONCAT(numHours,':',CASE WHEN LEN(numMinutes) = 1 THEN '0' END, numMinutes, ':', CASE WHEN LEN(numSeconds) = 1 THEN '0' END,numSeconds) AS RunTime
FROM #output

DROP TABLE #output


GO
