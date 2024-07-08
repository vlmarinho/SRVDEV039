CREATE TABLE [dbo].[LogTransacoesUra] ( 
	[Codigo] INT IDENTITY(1,1) NOT NULL
	,[Data_hora] DATETIME NOT NULL
	,[Tipo] CHAR(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BaseOrigem] CHAR(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[TpoPrdCodigo] INT NULL
	,[CodMensagem] VARCHAR(4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[NumCartao] VARCHAR(16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[CodProcessamento] VARCHAR(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[ValorTransacao] DECIMAL(15,2) NULL
	,[DataHora] VARCHAR(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[NsuOrigem] VARCHAR(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[Hora] VARCHAR(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[Data] VARCHAR(4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[ModoEntrada] VARCHAR(3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[Rede] VARCHAR(3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[Autorizacao] VARCHAR(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[CodResposta] VARCHAR(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[Terminal] VARCHAR(8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[Estabelecimento] INT NULL
	,[InfoBit46] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[InfoBit47] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[Provedor] VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[SenhaCripto] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[MsgResposta] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[InfoBit63] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[QtdParcelas] VARCHAR(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[InfoBit68] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[CodigoCVV] VARCHAR(4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[NsuHost] VARCHAR(9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[CodIntResposta] INT NULL
	,[TelefoneOrigem] VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,CONSTRAINT [PK_LogTransacoesUra] PRIMARY KEY CLUSTERED (Codigo DESC) WITH FILLFACTOR = 90
	);

CREATE NONCLUSTERED INDEX [IX_LOGTRANSACAOUSA05] ON [dbo].[LogTransacoesUra] (Data_hora ASC)
	INCLUDE (BaseOrigem, NumCartao, TelefoneOrigem)
	WITH (PAD_INDEX = OFF, FILLFACTOR = 100, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF , ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
	ON [PRIMARY];

