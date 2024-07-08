CREATE TABLE [dbo].[TelefonesUsuariosSMS] ( 
	[CodUsuarioSMS] INT NOT NULL
	,[CodTelefoneSMS] INT NOT NULL
	,CONSTRAINT [PK_TelefonesUsuariosSMS] PRIMARY KEY CLUSTERED (CodUsuarioSMS ASC, CodTelefoneSMS ASC) WITH FILLFACTOR = 80
	,CONSTRAINT [FK_TelefonesUsuariosSMS_UsuarioPermiteSMS] FOREIGN KEY (CodUsuarioSMS) REFERENCES UsuarioPermiteSMS(Codigo)
	,CONSTRAINT [FK_TelefonesUsuariosSMS_TelefonesSMS] FOREIGN KEY (CodTelefoneSMS) REFERENCES TelefonesSMS(Codigo)
	);
