SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE VIEW [segmentation].[vw__Attendance]
AS
    ( SELECT    ssbid.SSB_CRMSYSTEM_CONTACT_ID
              , DimCustomer.AccountId AS Archtics_Acct_Id
              , CAST(1 AS BIT) AS Attended_By_Originator
              , DimSeasonHeader.Active AS Season_Is_Active
              , DimSeason.SeasonName AS Season_Name
              , DimEventHeader.EventName AS Event_Header_Name
              , DimEvent.EventCode AS Event_Code
              , DimEvent.EventName AS Event_Name
              , DimEvent.EventDesc AS Event_Desc
              , DimEvent.EventClass AS Event_Class
              , DimEvent.EventDate AS Event_Date
              , CAST(DimEvent.EventTime AS NVARCHAR(30)) Event_Time
			  --, DimEvent.MajorCategoryTM
		      --, DimEvent.MinorCategoryTM
              , DimEventHeader.EventHierarchyL1 AS Event_Hierarchy_L1
              , DimEventHeader.EventHierarchyL2 AS Event_Hierarchy_L2
              , DimEventHeader.EventHierarchyL3 AS Event_Hierarchy_L3
              , DimSeat.SectionName AS Section_Name
              , DimSeat.RowName AS Row_Name
              , DimSeat.Seat AS First_Seat
              , CAST(CAST(fa.ScanDateTime AS TIME) AS NVARCHAR(30)) Scan_Time
              , fa.ScanGate AS Scan_Gate
              , fa.Channel
      FROM      dbo.FactAttendance fa
                INNER JOIN rpt.vw_DimEvent DimEvent WITH ( NOLOCK ) ON DimEvent.DimEventId = fa.DimEventId
                INNER JOIN rpt.vw_DimSeason DimSeason WITH ( NOLOCK ) ON DimSeason.DimSeasonId = DimEvent.DimSeasonId
                INNER JOIN rpt.vw_DimSeat DimSeat WITH ( NOLOCK ) ON DimSeat.DimSeatId = fa.DimSeatId
                INNER JOIN rpt.vw_dimcustomer DimCustomer WITH ( NOLOCK ) ON DimCustomer.DimCustomerId = fa.DimCustomerId
                                                              AND DimCustomer.CustomerType = 'Primary'
                                                              AND DimCustomer.SourceSystem = 'TM'
                INNER JOIN dbo.dimcustomerssbid ssbid WITH ( NOLOCK ) ON ssbid.DimCustomerId = fa.DimCustomerId
                INNER JOIN rpt.vw_DimEventHeader DimEventHeader WITH ( NOLOCK ) ON DimEventHeader.DimEventHeaderId = DimEvent.DimEventHeaderId
                INNER JOIN rpt.vw_DimSeasonHeader DimSeasonHeader WITH ( NOLOCK ) ON DimSeasonHeader.DimSeasonHeaderId = DimEventHeader.DimSeasonHeaderId
	 
	 WHERE DimEvent.EventDate >= DATEADD(YEAR, -3, GETDATE())
    )









GO
