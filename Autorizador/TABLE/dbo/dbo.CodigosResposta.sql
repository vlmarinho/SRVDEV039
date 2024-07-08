CREATE TABLE [dbo].[CodigosResposta] ( 
	[Codigo] INT IDENTITY(0,1) NOT NULL
	,[Descricao] VARCHAR(200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[CodCielo] CHAR(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[DescricaoCielo] VARCHAR(150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[CodPolicard] CHAR(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[DescricaoPolicard] VARCHAR(35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[CodTecban] CHAR(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[DescricaoTecban] VARCHAR(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[CodVT] CHAR(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[DescricaoVT] VARCHAR(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,CONSTRAINT [pk_CodigosResposta_codigo] PRIMARY KEY CLUSTERED (Codigo ASC) WITH FILLFACTOR = 80
	,CONSTRAINT [UQ__CodigosResposta__09DE7BCC] UNIQUE NONCLUSTERED (Descricao ASC, DescricaoPolicard ASC) WITH FILLFACTOR = 80
	);
