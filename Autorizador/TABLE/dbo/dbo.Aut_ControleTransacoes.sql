CREATE TABLE [dbo].[Aut_ControleTransacoes] ( 
	[Codigo] INT IDENTITY(1,1) NOT NULL
	,[CodigoReferencia] INT NULL
	,[Data] CHAR(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[Hora] CHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[TipoMsg] CHAR(4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[Terminal] CHAR(8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[Estabelecimento] VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[Rede] CHAR(4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[NsuMcaptura] CHAR(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[NsuTrnOriginal] CHAR(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[Valor] VARCHAR(12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[HoraTerminal] CHAR(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[DataTerminal] CHAR(4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[NumeroCartao] CHAR(16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[CodigoResposta] INT NULL
	,[Resposta] CHAR(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,CONSTRAINT [PK_Aut_ControleTransacoes] PRIMARY KEY CLUSTERED (Codigo DESC) WITH FILLFACTOR = 90
	);

CREATE NONCLUSTERED INDEX [IX_Aut_ControleTransacoes] ON [dbo].[Aut_ControleTransacoes] (Data DESC, TipoMsg ASC, Terminal ASC, Estabelecimento ASC, NsuMcaptura DESC)
	WITH (PAD_INDEX = OFF, FILLFACTOR = 90, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF , ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
	ON [PRIMARY];

