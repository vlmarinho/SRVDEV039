
/*
----------------------------------------------------------------------------
Data........: 11/09/2015
Nome Sistema: Autorizador
Objeto......: f_RetornarTipoMeioCaptura
Propósito...: Função responsável por retornar o tipo de meio de captura.
----------------------------------------------------------------------------
Data alteração: -
Mudança.......: -
----------------------------------------------------------------------------
*/

CREATE FUNCTION [f_RetornarTipoMeioCaptura](@sBit041 VARCHAR(20))
RETURNS TINYINT
AS
BEGIN
	DECLARE @iRetorno TINYINT

	SELECT @iRetorno = CodigoTipoMeioCaptura FROM Acquirer..MeioCaptura WITH(NOLOCK) WHERE NumeroLogico = @sBit041

	RETURN @iRetorno
END
