
/*
----------------------------------------------------------------------------
Data........: 18/05/2015
Nome Sistema: Autorizador
Objeto......: f_RemoverZerosEsquerda
Propósito...: Função responsável por remover zeros à esquerda de varchar.
----------------------------------------------------------------------------
Data alteração: -
Mudança.......: -
----------------------------------------------------------------------------
*/

CREATE FUNCTION [f_RemoverZerosEsquerda]
(
	@sValor VARCHAR(200)
)
RETURNS VARCHAR(200)
AS
BEGIN
	DECLARE @sRetorno VARCHAR(200)
	SELECT @sRetorno = SUBSTRING(@sValor,PATINDEX('%[a-z,1-9]%',@sValor),LEN(@sValor))
	RETURN @sRetorno
END
