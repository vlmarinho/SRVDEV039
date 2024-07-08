CREATE TABLE [dbo].[TiposProdutosTiposTransacoes] ( 
	[CodTipoProduto] INT NOT NULL
	,[CodTipoTransacao] INT NOT NULL
	,[CodProduto] INT NOT NULL
	,[TaxaJuros] DECIMAL(6,2) NULL
	,[ValorMinimoParcela] DECIMAL(15,2) NOT NULL
	,[ValorMaximoParcela] DECIMAL(15,2) NOT NULL
	,[NivelBloqueio] TINYINT NULL
	,[ValorRefTaxacao] DECIMAL(15,2) NULL
	,[ValorTaxacao] DECIMAL(15,2) NULL
	,[TipoTransacao] CHAR(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[TransacaoVinculada] INT NULL
	,CONSTRAINT [XPKTiposProdutosTiposTransacoes] PRIMARY KEY CLUSTERED (CodTipoProduto ASC, CodTipoTransacao ASC) WITH FILLFACTOR = 90
	,CONSTRAINT [FK_TiposProdutosTiposTransacoes_TiposTransacoes] FOREIGN KEY (CodTipoTransacao) REFERENCES TiposTransacoes(CodTipoTransacao)
	);
