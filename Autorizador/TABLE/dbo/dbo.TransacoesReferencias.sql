CREATE TABLE [dbo].[TransacoesReferencias] ( 
	[TrnCodigo] INT NOT NULL
	,[TipoReferencia] CHAR(1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	,[CodigoTrnOriginal] INT NOT NULL
	,CONSTRAINT [PK_TransacoesReferencias] PRIMARY KEY CLUSTERED (TrnCodigo ASC, TipoReferencia ASC) WITH FILLFACTOR = 80
	);
