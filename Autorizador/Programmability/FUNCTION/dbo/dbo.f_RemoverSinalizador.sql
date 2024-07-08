
/*
--------------------------------------------------------------------------
Data........: 18/05/2015
Nome Sistema: Autorizador
Objeto......: f_RemoverSinalizador
Propósito...: Função  responsável  por remover os sinalizadores das  tran-
			  sações recebidas do FormGen.
--------------------------------------------------------------------------
Data alteração: -
Mudança.......: -
--------------------------------------------------------------------------
*/

CREATE FUNCTION [dbo].[f_RemoverSinalizador]
(
	@Texto VARCHAR(1000)
)
RETURNS VARCHAR(1000)
AS
BEGIN
	DECLARE @sRetorno VARCHAR(1000)

	IF (@Texto IS NULL)
		SET @sRetorno = NULL
	ELSE
	BEGIN
		IF (LEN(@Texto) > 0)
			SET @sRetorno = SUBSTRING(@Texto, 2, LEN(@Texto) - 1)
		ELSE
			SET @sRetorno = ''
	END

	RETURN @sRetorno
END
