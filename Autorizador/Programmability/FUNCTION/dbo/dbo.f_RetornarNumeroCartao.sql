
/*
----------------------------------------------------------------------------
Data........: 20/05/2015
Nome Sistema: Autorizador
Objeto......: f_RetornarNumeroCartao
Propósito...: Função responsável por retornar o número do cartão.
----------------------------------------------------------------------------
Data alteração: -
Mudança.......: -
----------------------------------------------------------------------------
*/

CREATE FUNCTION [f_RetornarNumeroCartao]
(
	@Bit002	 VARCHAR(20) = NULL /* Cartão */
	,@Bit035 VARCHAR(20) = NULL /* Cartão */
	,@Bit045 VARCHAR(20) = NULL /* Cartão */
)
RETURNS VARCHAR(16)
AS
BEGIN
	DECLARE @sRetorno VARCHAR(16)

	SET @sRetorno = CASE WHEN (@Bit002 IS NOT NULL AND LEN(@Bit002) = 16) THEN @Bit002	/* Número do cartão - Digitado */
						 WHEN (LEN(@Bit035) >= 16) THEN LEFT(@Bit035,16)				/* Número do cartão - Trilha 2 do cartão */
						 ELSE SUBSTRING(@Bit045,2,16)									/* Número do cartão - Trilha 1 do cartão */
					END

	RETURN @sRetorno
END
