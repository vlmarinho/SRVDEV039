CREATE TABLE [dbo].[EMV_KeyPublic] ( 
	[Codigo] INT IDENTITY(1,1) NOT NULL
	,[DataHora] DATETIME NOT NULL
	,[InfoPublicKey] VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[RID] VARCHAR(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[CA_PubKeyIndex] VARCHAR(8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[CA_PubKeyExpLen] CHAR(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[CA_PubKeyExp] VARCHAR(24) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[CA_PublicKeyLen] CHAR(3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[CA_PublicKey] VARCHAR(496) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[ChecksumStatus] CHAR(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[CA_PubKeyChecksum] VARCHAR(48) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[IndiceMasterKey] CHAR(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[WorkingKey] VARCHAR(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,CONSTRAINT [PK_EMV_KeyPublic] PRIMARY KEY CLUSTERED (Codigo ASC) WITH FILLFACTOR = 80
	);
