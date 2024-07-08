CREATE TABLE [dbo].[Aut_CodigosRespostaRecargaCelular] ( 
	[Codigo] INT IDENTITY(0,1) NOT NULL
	,[Codigo_Resposta] VARCHAR(2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	,[Descricao] VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,CONSTRAINT [pk_Aut_CodigosRespostaRecargaCelular] PRIMARY KEY CLUSTERED (Codigo ASC) WITH FILLFACTOR = 80
	);
