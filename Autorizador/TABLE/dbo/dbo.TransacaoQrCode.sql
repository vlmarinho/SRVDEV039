CREATE TABLE [dbo].[TransacaoQrCode] ( 
	[TrnCodigo] INT IDENTITY(1,1) NOT NULL
	,[TrnReferencia] INT NULL
	,[DataHora] DATETIME NOT NULL
	,[DataLocal] CHAR(4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	,[HoraLocal] CHAR(6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	,[TipoMensagem] CHAR(4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[TpoTrnCodigo] VARCHAR(6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	,[CodEstab] INT NULL
	,[BaseOrigem] CHAR(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[MeiCptCodigo] INT NOT NULL
	,[RdeCodigo] INT NOT NULL
	,[Valor] DECIMAL(15,2) NOT NULL
	,[Autorizacao] VARCHAR(6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	,[ModoEntrada] CHAR(3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[Provedor] VARCHAR(40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[Status] CHAR(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[Terminal] CHAR(8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[NSUOrigem] CHAR(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[EstabMigrado] BIT NULL
	,CONSTRAINT [PK_TransacaoQrCode_TrnCodigo] PRIMARY KEY NONCLUSTERED (TrnCodigo DESC) WITH FILLFACTOR = 90
	);

CREATE NONCLUSTERED INDEX [IX_TransacaoQrCode_1] ON [dbo].[TransacaoQrCode] (DataHora ASC, TipoMensagem ASC, CodEstab ASC)
	WITH (PAD_INDEX = OFF, FILLFACTOR = 100, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF , ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
	ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_TransacaoQrCode_2] ON [dbo].[TransacaoQrCode] (DataHora ASC, NSUOrigem ASC, Terminal ASC)
	WITH (PAD_INDEX = OFF, FILLFACTOR = 100, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF , ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
	ON [PRIMARY];
