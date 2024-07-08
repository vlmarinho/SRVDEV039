CREATE TABLE [dbo].[ControleBloqueioCartao] ( 
	[CodCartao] INT NOT NULL
	,[Franquia] INT NULL
	,[BaseOrigem] CHAR(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[CodResposta] INT NOT NULL
	,[Data] DATETIME NOT NULL
	);

CREATE NONCLUSTERED INDEX [ControleBloqueioCartao_IX02] ON [dbo].[ControleBloqueioCartao] (CodCartao ASC, Franquia ASC, BaseOrigem ASC, CodResposta ASC)
	WITH (PAD_INDEX = OFF, FILLFACTOR = 100, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF , ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
	ON [PRIMARY];

