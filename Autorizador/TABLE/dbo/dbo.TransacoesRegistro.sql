CREATE TABLE [dbo].[TransacoesRegistro] ( 
	[TrnCodigo] INT NOT NULL
	,[StatusTef] CHAR(1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_TransacoesRegistro_StatusTef] DEFAULT ('P')
	,[NumeroEstabelecimento] INT NOT NULL
	,[UltimaSonda] DATETIME NULL
	,[NivelSonda] SMALLINT NULL
	,[UltimaRspSonda] INT NULL CONSTRAINT [DF_TransacoesRegistro_UltimaRspSonda] DEFAULT ((0))
	,CONSTRAINT [PK_TransacoesRegistro] PRIMARY KEY NONCLUSTERED (TrnCodigo ASC) WITH FILLFACTOR = 80
	);
