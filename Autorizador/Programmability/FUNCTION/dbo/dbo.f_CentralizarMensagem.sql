
/*
----------------------------------------------------------------------------
Data........: 12/06/2015
Nome Sistema: Autorizador
Objeto......: f_CentralizarMensagem
Propósito...: Função responsável por centralizar mensagens para Tickets.
----------------------------------------------------------------------------
Data alteração: -
Mudança.......: -
----------------------------------------------------------------------------
*/

CREATE FUNCTION [f_CentralizarMensagem]
(
	@Mensagem	VARCHAR(100)
	,@Separador	CHAR(1) = NULL
	,@Tamanho	INT
)
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @sRetorno	VARCHAR(100)
			,@iLenBordas	INT

	SET @iLenBordas = (@Tamanho - LEN(@Mensagem)) / 2

	IF (@Separador IS NOT NULL)
		SET @sRetorno = @Separador + REPLICATE(' ',@iLenBordas) + @Mensagem
	ELSE
		SET @sRetorno = REPLICATE(' ',@iLenBordas) + @Mensagem

	RETURN @sRetorno
END
