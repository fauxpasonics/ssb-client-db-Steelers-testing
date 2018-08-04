CREATE TABLE [audit].[TaskLog]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[BatchID] [int] NOT NULL,
[Created] [datetime] NULL CONSTRAINT [DF__TaskLog__Created__533556C6] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[User] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TaskName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Target] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SQL] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExecuteStart] [datetime] NULL,
[ExecuteEnd] [datetime] NULL,
[ExecutionRuntimeSeconds] AS (CONVERT([float],datediff(second,[ExecuteStart],[ExecuteEnd]),(0))),
[RowCountBefore] [int] NULL CONSTRAINT [DF__TaskLog__RowCoun__54297AFF] DEFAULT ((0)),
[RowCountAfter] [int] NULL CONSTRAINT [DF__TaskLog__RowCoun__551D9F38] DEFAULT ((0)),
[Inserted] [int] NULL CONSTRAINT [DF__TaskLog__Inserte__5611C371] DEFAULT ((0)),
[Updated] [int] NULL CONSTRAINT [DF__TaskLog__Updated__5705E7AA] DEFAULT ((0)),
[Deleted] [int] NULL CONSTRAINT [DF__TaskLog__Deleted__57FA0BE3] DEFAULT ((0)),
[Truncated] [int] NULL CONSTRAINT [DF__TaskLog__Truncat__58EE301C] DEFAULT ((0)),
[IsCommitted] [bit] NULL CONSTRAINT [DF__TaskLog__IsCommi__59E25455] DEFAULT ((0)),
[IsError] [bit] NULL CONSTRAINT [DF__TaskLog__IsError__5AD6788E] DEFAULT ((0)),
[ErrorMessage] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorSeverity] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorState] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [audit].[TaskLog] ADD CONSTRAINT [PK__TaskLog__3214EC27CC26D96B] PRIMARY KEY CLUSTERED  ([ID])
GO
