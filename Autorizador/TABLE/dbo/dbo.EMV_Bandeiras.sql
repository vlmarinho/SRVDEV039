CREATE TABLE [dbo].[EMV_Bandeiras] ( 
	[IdBandeira] CHAR(3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	,[TipoBandeira] CHAR(2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	,[NomeBandeira] CHAR(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	,[Options1] CHAR(8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	,[Options2] CHAR(8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	,[Options3] CHAR(8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	);
