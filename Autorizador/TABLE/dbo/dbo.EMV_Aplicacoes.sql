CREATE TABLE [dbo].[EMV_Aplicacoes] ( 
	[CodigoAid] CHAR(3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	,[LenAID] CHAR(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[AID] VARCHAR(16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[TipoAplicacao] CHAR(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[Categoria] CHAR(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[NomeAplicacao] CHAR(16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[AID_Version_1] VARCHAR(16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[AID_Version_2] VARCHAR(16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[AID_Version_3] VARCHAR(16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[TermCapabilities] VARCHAR(24) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[AddTermCapabilities] VARCHAR(40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[TerminalType] CHAR(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[TAC_Default] VARCHAR(40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[TAC_Denial] VARCHAR(40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[TAC_Online] VARCHAR(40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[FloorLimit] VARCHAR(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[TCC] CHAR(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[TDOL] VARCHAR(160) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[DDOL] VARCHAR(160) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[AutRespCodeOfflineAppoved] CHAR(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[AutRespCodeOfflineDenied] CHAR(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[AutRespCodeUnableOfflineApproved] CHAR(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[AutRespCodeUnableOfflineDenied] CHAR(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[TargetPercentage] CHAR(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[ThresholdValue] CHAR(4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[MaxTargetPercentage] CHAR(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[IdBandeira] CHAR(3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,CONSTRAINT [PK_EMV_Aplicacoes] PRIMARY KEY CLUSTERED (CodigoAid ASC) WITH FILLFACTOR = 80
	);
