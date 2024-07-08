CREATE TABLE [dbo].[TiposTransacoesTiposMensagens] ( 
	[CodTipoTransacao] INT NOT NULL
	,[Mensagem] CHAR(4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	,[DescricaoOrigem] VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[Origem] CHAR(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,CONSTRAINT [UK_TpoTrnCodigoMensagem] UNIQUE NONCLUSTERED (CodTipoTransacao ASC, Mensagem ASC) WITH FILLFACTOR = 80
	,CONSTRAINT [FK_TiposTransacoesTiposMensagens_TiposTransacoes] FOREIGN KEY (CodTipoTransacao) REFERENCES TiposTransacoes(CodTipoTransacao)
	,CONSTRAINT [FK_TiposTransacoesTiposMensagens_TiposMensagens] FOREIGN KEY (Mensagem) REFERENCES TiposMensagens(Mensagem)
	);

CREATE CLUSTERED INDEX [IX_TiposTransacoesTiposMensagens] ON [dbo].[TiposTransacoesTiposMensagens] (CodTipoTransacao ASC, Mensagem ASC)
	WITH (PAD_INDEX = OFF, FILLFACTOR = 100, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF , ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
	ON [PRIMARY];

