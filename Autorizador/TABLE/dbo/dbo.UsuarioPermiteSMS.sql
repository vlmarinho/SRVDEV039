CREATE TABLE [dbo].[UsuarioPermiteSMS] ( 
	[Codigo] INT IDENTITY(1,1) NOT NULL
	,[CodCartao] INT NOT NULL
	,[Franquia] INT NOT NULL
	,[CodTipoProduto] INT NOT NULL
	,[Base] CHAR(1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	,[DataCadastro] DATETIME NOT NULL
	,CONSTRAINT [PK_UsuarioPermiteSMS] PRIMARY KEY CLUSTERED (Codigo ASC) WITH FILLFACTOR = 80
	);
