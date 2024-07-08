
/*
--------------------------------------------------------------------------
Data........: 15/06/2015
Nome Sistema: Autorizador
Objeto......: f_RemoverAcentos
Propósito...: Função responsável por remover a acentuação das palavras.
--------------------------------------------------------------------------
Data alteração: -
Mudança.......: -
--------------------------------------------------------------------------
*/

CREATE FUNCTION  [dbo].[f_RemoverAcentos](@Texto VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS BEGIN
	DECLARE @sRetorno VARCHAR(MAX) -- O trecho abaixo possibilita que caracteres como "º" ou "ª" -- sejam convertidos para "o" ou "a", respectivamente 
	SET @sRetorno = UPPER(@Texto) COLLATE sql_latin1_general_cp1250_ci_as

	-- O trecho abaixo remove acentos e outros caracteres especiais, -- substituindo os mesmos por letras normais 
	SET @sRetorno = @sRetorno COLLATE sql_latin1_general_cp1251_ci_as
	RETURN @sRetorno
END
