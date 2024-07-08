
/*
=====================================================================
Projeto: Translate de Senha
Descrição: Procedure utilizada para converter de Hexa para Base64
Autor:	Cristiano Silva Barbosa
Data Criacao: 28/09/2017
Chamado/Mudança: 417680 / 3262
=====================================================================
*/

CREATE PROCEDURE [dbo].[pr_Aut_HexaDecimal_Base64](@sRetorno VARCHAR(MAX) OUTPUT)
AS 
BEGIN

	DECLARE  @sBinHex		VARCHAR(MAX)
			,@vBinary		VARBINARY(MAX)
			,@Statement		NVARCHAR(MAX)

	SELECT @sBinHex = '0x' + @sRetorno
	SELECT @Statement = N'SELECT @binaryResult = ' + @sBinHex;
	EXECUTE sp_executesql @Statement, N'@binaryResult varbinary(max) OUTPUT', @binaryResult=@vBinary OUTPUT;

			
	SELECT @sRetorno = CAST(N'' AS XML).value('xs:base64Binary(xs:hexBinary(sql:column("bin")))', 'VARCHAR(MAX)') FROM (SELECT @vBinary AS bin) AS bin_sql_server_temp

END