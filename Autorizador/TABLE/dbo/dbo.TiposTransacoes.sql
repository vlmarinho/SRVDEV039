CREATE TABLE [dbo].[TiposTransacoes] ( 
	[CodTipoTransacao] INT NOT NULL
	,[CodTipoLancamento] INT NOT NULL
	,[Nome] VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	,[Tipo] CHAR(1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	,[RequerSenha] BIT NOT NULL CONSTRAINT [DF__TiposTran__Reque__4D94879B] DEFAULT ((0))
	,[VendaParcelada] BIT NOT NULL CONSTRAINT [DF__TiposTran__Venda__4E88ABD4] DEFAULT ((0))
	,CONSTRAINT [XPKTiposTransacoes] PRIMARY KEY CLUSTERED (CodTipoTransacao ASC) WITH FILLFACTOR = 90
	);
