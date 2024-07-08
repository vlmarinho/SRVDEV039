
/*
----------------------------------------------------------------------------
Data........: 25/05/2015
Nome Sistema: Autorizador
Objeto......: f_RetornarRede
Propósito...: Função responsável por retornar a Rede da transação.
----------------------------------------------------------------------------
Data alteração: -
Mudança.......: -
----------------------------------------------------------------------------
*/

CREATE FUNCTION [f_RetornarRede]
(
	@sBit024	VARCHAR(20)
	,@sBit032	VARCHAR(20)
)
RETURNS INT
AS
BEGIN
	DECLARE @iRetorno INT

	SET @iRetorno = CASE WHEN (CONVERT(BIGINT, @sBit032) IN (58, 13, 14, 15)) THEN CONVERT(INT, @sBit032)
						 WHEN (CONVERT(BIGINT, @sBit032) = 6142) THEN 10
						 WHEN (CONVERT(BIGINT, @sBit032) NOT IN (6142, 58) AND CONVERT(INT, @sBit024) IN (SELECT Numero FROM Acquirer..SubRede WITH(NOLOCK))) THEN CONVERT(INT, @sBit024)
					END

	SELECT @iRetorno = CodigoSubRede FROM Acquirer..SubRede WITH(NOLOCK) WHERE CONVERT(INT,Numero) = @iRetorno

	RETURN @iRetorno
END
