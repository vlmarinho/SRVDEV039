
/*
--------------------------------------------------------------------------
Data........: 03/06/2015
Nome Sistema: Autorizador
Objeto......: f_ContarBitmap
Propósito...: Função responsável por retornar se uma ISO8583 possui ou não
			  o Mapa de Bits Secundário.
--------------------------------------------------------------------------
Data alteração: -
Mudança.......: -
--------------------------------------------------------------------------
*/

CREATE FUNCTION [dbo].[f_ContarBitmap](
	@pInput			VARCHAR(1000)
	,@pSearchChar	CHAR(1)
)
RETURNS INT
BEGIN
	RETURN (LEN(@pInput) - LEN(REPLACE(@pInput, @pSearchChar, '')))
END
