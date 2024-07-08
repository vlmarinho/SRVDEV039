CREATE TABLE [dbo].[LogTransacoesTecBan] ( 
	[Codigo] INT IDENTITY(1,1) NOT NULL
	,[CodigoReferencia] INT NULL
	,[Data_hora] DATETIME NOT NULL
	,[BIT001] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BIT003] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BIT004] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BIT007] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BIT011] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BIT012] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BIT013] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BIT014] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BIT015] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BIT022] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BIT032] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BIT033] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BIT035] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BIT037] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BIT038] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BIT039] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BIT041] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BIT042] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BIT047] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BIT049] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BIT052] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BIT061] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BIT062] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BIT064] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BIT067] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BIT090] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BIT100] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BIT120] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BIT124] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BIT126] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BIT127] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[CodResposta] INT NULL
	,CONSTRAINT [PK_LogTransacoesTecBan] PRIMARY KEY CLUSTERED (Codigo DESC) WITH FILLFACTOR = 90
	);

CREATE NONCLUSTERED INDEX [IX_index005] ON [dbo].[LogTransacoesTecBan] (BIT003 ASC, BIT004 ASC, BIT007 ASC, BIT041 ASC, BIT042 ASC, BIT127 ASC, BIT001 ASC, Codigo ASC)
	WITH (PAD_INDEX = OFF, FILLFACTOR = 90, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF , ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
	ON [PRIMARY];
