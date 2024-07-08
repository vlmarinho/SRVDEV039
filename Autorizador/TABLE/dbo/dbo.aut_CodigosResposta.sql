CREATE TABLE [dbo].[aut_CodigosResposta] ( 
	[codigo] INT IDENTITY(0,1) NOT NULL
	,[descricao] VARCHAR(150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[codigo_cielo] CHAR(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[descricao_cielo] VARCHAR(150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[codigo_policard] CHAR(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[descricao_policard] VARCHAR(35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[objeto] VARCHAR(150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[Descricao_Tecban] VARCHAR(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[codigo_redecard] CHAR(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[codigo_stone] CHAR(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[MostrarMsgApp] BIT NOT NULL CONSTRAINT [DF_aut_CodigosResposta_MostrarMsgApp] DEFAULT ((0))
	,[MsgApp] VARCHAR(150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,CONSTRAINT [pk_aut_CodigosResposta_codigo] PRIMARY KEY CLUSTERED (codigo ASC) WITH FILLFACTOR = 80
	);
