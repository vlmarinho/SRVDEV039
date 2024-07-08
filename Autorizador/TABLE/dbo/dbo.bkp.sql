CREATE TABLE [dbo].[bkp] ( 
	[Codigo] INT IDENTITY(1,1) NOT NULL
	,[CodigoEstabelecimento] INT NOT NULL
	,[CodigoRede] BIGINT NOT NULL
	,[DataInclusao] DATETIME NOT NULL
	,[DataHabilitacao] DATETIME NULL
	,[DataDesabilitacao] DATETIME NULL
	,[CodigoStatusRede] INT NOT NULL
	,[Habilitado] BIT NOT NULL
	,[EstabMigrado] BIT NULL
	,[Responsavel] VARCHAR(150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	);
