CREATE TABLE [dbo].[MonitorSenhaTransacoes] ( 
	[Codigo] INT IDENTITY(1,1) NOT NULL
	,[Data] DATETIME NULL
	,[TrnCodigo] INT NULL
	,[Estabelecimento] INT NULL
	,[Terminal] VARCHAR(8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[Provedor] VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[Rede] CHAR(3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[NSU] VARCHAR(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[Valor] DECIMAL(15,2) NULL
	,[Senha] VARCHAR(16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[SenhaValida] BIT NULL
	,[BaseOrigem] CHAR(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[BIN] CHAR(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[PrdCodigo] INT NULL
	,[TpoPrdCodigo] INT NULL
	,[CrtUsrCodigo] INT NULL
	,[CntUsrCodigo] INT NULL
	,[TempoSegundos] INT NULL
	,[Resposta] INT NULL
	,[SenhaCapturada] BIT NULL
	,[Franquia_Usuario] INT NULL
	,[Usuario] INT NULL
	);

CREATE CLUSTERED INDEX [IX_MonitorSenhaTransacoes_Estabelecimento] ON [dbo].[MonitorSenhaTransacoes] (Estabelecimento ASC)
	WITH (PAD_INDEX = OFF, FILLFACTOR = 90, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF , ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
	ON [PRIMARY];

