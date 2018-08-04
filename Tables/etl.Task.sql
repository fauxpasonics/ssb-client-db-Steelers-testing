CREATE TABLE [etl].[Task]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[BatchID] [int] NOT NULL CONSTRAINT [DF__Task__BatchID__5E5CF0AF] DEFAULT ((0)),
[ExecutionOrder] [int] NOT NULL CONSTRAINT [DF__Task__ExecutionO__5F5114E8] DEFAULT ((1)),
[TaskName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__Task__TaskName__60453921] DEFAULT ('Not Specified'),
[TaskType] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__Task__TaskType__61395D5A] DEFAULT ('Not Specified'),
[SQL] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__Task__SQL__622D8193] DEFAULT (NULL),
[Target] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__Task__Target__6321A5CC] DEFAULT (NULL),
[Source] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__Task__Source__6415CA05] DEFAULT (NULL),
[CustomMatchOn] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__Task__CustomMatc__6509EE3E] DEFAULT (NULL),
[ExcludeColumns] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__Task__ExcludeCol__65FE1277] DEFAULT (NULL),
[Execute] [bit] NULL CONSTRAINT [DF__Task__Execute__66F236B0] DEFAULT ((0)),
[FailBatchOnFailure] [bit] NULL CONSTRAINT [DF__Task__FailBatchO__67E65AE9] DEFAULT ((1)),
[SuppressResults] [bit] NULL CONSTRAINT [DF__Task__SuppressRe__68DA7F22] DEFAULT ((0)),
[RunSQL] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NULL CONSTRAINT [DF__Task__Active__69CEA35B] DEFAULT ((1)),
[CREATED_DATE] [datetime] NOT NULL CONSTRAINT [DF__Task__CREATED_DA__6AC2C794] DEFAULT ([etl].[ConvertToLocalTime](getdate())),
[LUPDATED_DATE] [datetime] NOT NULL CONSTRAINT [DF__Task__LUPDATED_D__6BB6EBCD] DEFAULT ([etl].[ConvertToLocalTime](getdate()))
)
GO
ALTER TABLE [etl].[Task] ADD CONSTRAINT [PK__Task__3214EC27832AA504] PRIMARY KEY CLUSTERED  ([ID])
GO
