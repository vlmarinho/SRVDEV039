CREATE TABLE [dbo].[ChaveTrabalho] ( 
	[Codigo] INT IDENTITY(1,1) NOT NULL
	,[Estabelecimento] INT NULL
	,[Terminal] CHAR(8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[ChaveTrabalho] VARCHAR(2048) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	,[Data] DATETIME NOT NULL
	,[Provedor] VARCHAR(30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,CONSTRAINT [PK_ChaveTrabalho] PRIMARY KEY CLUSTERED (Codigo DESC) WITH FILLFACTOR = 80
	);
