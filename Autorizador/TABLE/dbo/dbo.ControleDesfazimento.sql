CREATE TABLE [dbo].[ControleDesfazimento] ( 
	[DataHora] DATETIME NULL
	,[TipoMensagem] CHAR(4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[Terminal] CHAR(8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[Estabelecimento] VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[Rede] INT NULL
	,[NsuMeioCaptura] CHAR(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[NsuTrnOriginal] CHAR(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[Valor] VARCHAR(12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[HoraTerminal] CHAR(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[DataTerminal] CHAR(4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[CodigoResposta] INT NULL
	);
