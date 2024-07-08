CREATE TABLE [dbo].[LogServicoVT] ( 
	[Id] INT IDENTITY(1,1) NOT NULL
	,[Date] DATETIME NOT NULL
	,[Thread] VARCHAR(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	,[Level] VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	,[Logger] VARCHAR(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	,[Message] VARCHAR(4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	,[Exception] VARCHAR(2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	);

CREATE CLUSTERED INDEX [IX_LogServicoVT_Id] ON [dbo].[LogServicoVT] (Id ASC)
	WITH (PAD_INDEX = OFF, FILLFACTOR = 80, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF , ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
	ON [PRIMARY];

CREATE NONCLUSTERED INDEX [IX_LogServicoVT_Date] ON [dbo].[LogServicoVT] (Date ASC)
	WITH (PAD_INDEX = OFF, FILLFACTOR = 90, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF , ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
	ON [PRIMARY];
