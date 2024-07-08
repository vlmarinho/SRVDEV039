

/*
-------------------------------------------------------------------------
Data........: 18/05/2015
Nome Sistema: Autorizador
Objeto......: f_RetornarEstabelecimento
Propósito...: Função responsável por retornar o número do Estabelecimento
			  para validação.
-------------------------------------------------------------------------
Data alteração: 19/04/2016 - 19:00
Mudança.......: 1809
-------------------------------------------------------------------------
Data: 19/02/2017
Mud/CH.:  2601
*/

CREATE FUNCTION [dbo].[f_RetornarEstabelecimento]
(
	@sEstabelecimento VARCHAR(20)
)
RETURNS BIGINT
AS
BEGIN
	DECLARE @iRetorno			BIGINT
			,@iEstabelecimento	BIGINT

	SET @sEstabelecimento = REPLACE (@sEstabelecimento,'.','')

	SELECT @sEstabelecimento = SUBSTRING(@sEstabelecimento,PATINDEX('%[a-z,1-9]%',@sEstabelecimento),LEN(@sEstabelecimento))
	
	IF (ISNUMERIC(@sEstabelecimento) = 1)
		SET @iRetorno = CONVERT(BIGINT,@sEstabelecimento)
	ELSE
		SET @iRetorno = 0

	IF (@iRetorno > 0)
		SELECT TOP 1 @iEstabelecimento = E.CodigoEstabelecimento
		FROM Acquirer..Estabelecimento E WITH(NOLOCK)
		LEFT JOIN Acquirer..EstabelecimentoCielo EC WITH(NOLOCK) ON (EC.CodigoEstabelecimento = E.CodigoEstabelecimento)
		WHERE (E.CodigoEstabelecimento = @iRetorno OR EC.CodigoCielo = @sEstabelecimento)
		AND E.CodigoEntidadeStatus = 1
		
	IF (ISNULL(@iEstabelecimento,0) = 0)
		SET @iRetorno = 0
	ELSE
		SET @iRetorno = @iEstabelecimento

	RETURN @iRetorno
END


