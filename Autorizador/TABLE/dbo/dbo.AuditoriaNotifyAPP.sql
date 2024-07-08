CREATE TABLE [dbo].[AuditoriaNotifyAPP] ( 
	[Codigo] INT IDENTITY(1,1) NOT NULL
	,[Data] DATETIME NULL
	,[TipoMensagem] CHAR(4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[NsuHost] INT NULL
	,[CrtUsrcodigo] INT NULL
	,[CntAppCodigo] INT NULL
	,[BaseOrigem] CHAR(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[Tipo] CHAR(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[Status] BIT NULL
	);
