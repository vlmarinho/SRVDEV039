CREATE TABLE [dbo].[EnviaSMS] ( 
	[Codigo] INT IDENTITY(1,1) NOT NULL
	,[CodUsuario] INT NOT NULL
	,[CodTelefone] INT NOT NULL
	,[Mensagem] VARCHAR(200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	,[Valor] DECIMAL(15,2) NULL
	,[Saldo] DECIMAL(15,2) NULL
	,[DataTransacao] DATETIME NULL
	,[ClientID] VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[MensagemRetorno] VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[Enviado] BIT NOT NULL
	,[NomeEstabelecimento] VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,CONSTRAINT [PK_EnviaSMS] PRIMARY KEY CLUSTERED (Codigo DESC) WITH FILLFACTOR = 80
	,CONSTRAINT [FK_EnviaSMS_UsuarioPermiteSMS] FOREIGN KEY (CodUsuario) REFERENCES UsuarioPermiteSMS(Codigo)
	,CONSTRAINT [FK_EnviaSMS_TelefonesSMS] FOREIGN KEY (CodTelefone) REFERENCES TelefonesSMS(Codigo)
	);
