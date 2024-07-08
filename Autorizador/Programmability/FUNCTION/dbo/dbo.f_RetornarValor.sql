
/*
----------------------------------------------------------------------------
Data........: 08/06/2015
Nome Sistema: Autorizador
Objeto......: f_RetornarValor
Propósito...: Função responsável por retornar o valor da transação.
----------------------------------------------------------------------------
Data alteração: -
Mudança.......: -
----------------------------------------------------------------------------
*/

CREATE FUNCTION [f_RetornarValor]
(
	@sValor VARCHAR(20)
)
RETURNS DECIMAL(15,2)
AS
BEGIN
	DECLARE @dRetorno DECIMAL(15,2)
			,@dValor  DECIMAL(15,2)

	SELECT @sValor = SUBSTRING(@sValor,PATINDEX('%[a-z,1-9]%',@sValor),LEN(@sValor))

	IF (ISNUMERIC(@sValor) = 1)
		SET @dRetorno = CONVERT(DECIMAL(15,2),@sValor)/100
	ELSE
		SET @dRetorno = 0

	RETURN @dRetorno
END
