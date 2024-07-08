CREATE TABLE [dbo].[AtualizacaoTerminal] ( 
	[Codigo] INT IDENTITY(1,1) NOT NULL
	,[DataHora] DATETIME NULL
	,[Estabelecimento] INT NULL
	,[Terminal] CHAR(8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[Modelo] VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[VersaoTerminal] VARCHAR(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[VersaoProducao] VARCHAR(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[Rede] INT NULL
	,[Status] CHAR(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[QtdeNotificacao] INT NULL
	,CONSTRAINT [PK_Aut_AtualizacaoTerminal] PRIMARY KEY CLUSTERED (Codigo DESC) WITH FILLFACTOR = 90
	);
