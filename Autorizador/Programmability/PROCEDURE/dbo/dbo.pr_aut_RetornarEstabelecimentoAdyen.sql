/*
 Data: 11/05/2023
 Autor: Adilson Pereira - Up Brasil
 Chamado: 2009473
 Descrição: Criação do objeto
 --------------------------------------------------------------------------
 */

CREATE PROCEDURE [dbo].[pr_aut_RetornarEstabelecimentoAdyen] (
	@sEstabelecimento VARCHAR(20) OUTPUT
	,@cStatus CHAR(1) OUTPUT
	,@bEstabMigrado BIT OUTPUT
	,@bHabilitadoAdyen BIT OUTPUT
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @iEstabelecimento BIGINT
		,@iRetorno INT

	SET @bEstabMigrado = 0
	SET @iRetorno = 0
	SET @sEstabelecimento = REPLACE(@sEstabelecimento, '.', '')

	SELECT @sEstabelecimento = SUBSTRING(@sEstabelecimento, PATINDEX('%[a-z,1-9]%', @sEstabelecimento), LEN(@sEstabelecimento))

	IF (ISNUMERIC(@sEstabelecimento) = 1)
		SET @iEstabelecimento = CONVERT(BIGINT, @sEstabelecimento)
	ELSE
		SET @iEstabelecimento = 0

	IF (@iEstabelecimento > 0)
	BEGIN
		SELECT @iRetorno = E.CodigoEstabelecimento
			,@bEstabMigrado = 1
			,@bHabilitadoAdyen = ISNULL(ES.Habilitado, 0)
			,@cStatus = CASE 
				WHEN E.CodigoEntidadeStatus = 1
					THEN 'A'
				WHEN E.CodigoEntidadeStatus = 2
					THEN 'I'
				WHEN E.CodigoEntidadeStatus = 3
					THEN 'C'
				WHEN E.CodigoEntidadeStatus = 4
					THEN 'P'
				WHEN E.CodigoEntidadeStatus = 6
					THEN 'B'
				END
		FROM Acquirer.dbo.Estabelecimento E WITH (NOLOCK)
		INNER JOIN Acquirer.dbo.EstabelecimentoAdien ES WITH (NOLOCK) ON (ES.CodigoEstabelecimento = E.CodigoEstabelecimento)
		WHERE ES.CodigoAdien = @iEstabelecimento

		IF (@bEstabMigrado = 0)
		BEGIN
			SELECT @iRetorno = ES.CodigoEstabelecimento
				,@bEstabMigrado = 0
				,@cStatus = E.STATUS
				,@bHabilitadoAdyen = ISNULL(ES.Habilitado, 0)
			FROM Processadora.dbo.Estabelecimentos E WITH (NOLOCK)
			INNER JOIN Acquirer.dbo.EstabelecimentoAdien ES WITH (NOLOCK) ON (ES.CodigoEstabelecimento = E.Numero)
			WHERE ES.CodigoAdien = @iEstabelecimento
		END
	END

	IF (ISNULL(@iEstabelecimento, 0) = 0)
		SET @sEstabelecimento = @sEstabelecimento
	ELSE
		SET @sEstabelecimento = @iRetorno
END