SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [etl].[TaskGenerator]
AS

SELECT * FROM etl.TaskModule_StandardSet
GO