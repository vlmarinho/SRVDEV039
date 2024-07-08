CREATE TABLE [dbo].[TicketsRetorno] ( 
	[Codigo] INT IDENTITY(1,1) NOT NULL
	,[CodTipoTicket] INT NOT NULL
	,[MsgCabecalho] NVARCHAR(600) NULL
	,[MsgTicket] NVARCHAR(8000) NOT NULL
	,[MsgRodape] NVARCHAR(600) NULL
	,[MsgExtra1] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[MsgExtra2] VARCHAR(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,CONSTRAINT [PK_TicketsRetorno] PRIMARY KEY CLUSTERED (Codigo ASC) WITH FILLFACTOR = 80
	,CONSTRAINT [FK_TicketsRetorno_TiposTickets] FOREIGN KEY (CodTipoTicket) REFERENCES TiposTickets(Codigo)
	);
