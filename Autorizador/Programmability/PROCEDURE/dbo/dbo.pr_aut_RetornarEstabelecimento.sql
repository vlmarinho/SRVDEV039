

/*
--------------------------------------------------------------------------
Data........: 
Nome Sistema: Autorizador
Objeto......: [pr_aut_RetornarEstabelecimento]
Propósito...: Procedure responsável por  retornar os dados  para validação
			  do Estabelecimento.
--------------------------------------------------------------------------
Data alteração: 
Mudança.......: 
Autor: Cristiano Silva Barbosa
--------------------------------------------------------------------------

declare @sEstabelecimento VARCHAR(20)
,@cStatus char(1)
,@bEstabMigrado bit

set @sEstabelecimento = '000004561412302'

EXEC [dbo].[pr_aut_RetornarEstabelecimento] @sEstabelecimento out,@cStatus out,@bEstabMigrado out

SELECT @sEstabelecimento

*/



CREATE PROCEDURE [dbo].[pr_aut_RetornarEstabelecimento] (
	 @sEstabelecimento	VARCHAR(20)	OUTPUT
	,@cStatus			CHAR(1)		OUTPUT
	,@bEstabMigrado		BIT			OUTPUT
	)
AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @iEstabelecimento	BIGINT

	SET @bEstabMigrado = 0
	SET @sEstabelecimento = REPLACE (@sEstabelecimento,'.','')

	SELECT @sEstabelecimento = SUBSTRING(@sEstabelecimento,PATINDEX('%[a-z,1-9]%',@sEstabelecimento),LEN(@sEstabelecimento))
	
	IF (ISNUMERIC(@sEstabelecimento) = 1)
		SET @iEstabelecimento = CONVERT(BIGINT,@sEstabelecimento)
	ELSE
		SET @iEstabelecimento = 0

	IF (@iEstabelecimento > 0)
	BEGIN

		SELECT @iEstabelecimento = dbo.f_RetornarEstabelecimento(@sEstabelecimento)
		
		IF @iEstabelecimento > 0
		BEGIN

			SELECT 
				 @iEstabelecimento = E.CodigoEstabelecimento
				,@bEstabMigrado = 1
				,@cStatus = CASE WHEN E.CodigoEntidadeStatus = 1 THEN 'A'
							   WHEN E.CodigoEntidadeStatus = 2 THEN 'I'
							   WHEN E.CodigoEntidadeStatus = 3 THEN 'C'
							   WHEN E.CodigoEntidadeStatus = 4 THEN 'P'
							   WHEN E.CodigoEntidadeStatus = 6 THEN 'B'
							END
			FROM Acquirer.dbo.Estabelecimento E WITH(NOLOCK)
			WHERE (E.CodigoEstabelecimento = @iEstabelecimento )
		
		END

		IF (@bEstabMigrado = 0)
		BEGIN

			SELECT @iEstabelecimento = Processadora.dbo.f_RetornarEstabelecimento(@sEstabelecimento)
	
			IF @iEstabelecimento > 0
			BEGIN
				SELECT	
					 @iEstabelecimento = E.Numero
					,@bEstabMigrado = 0
					,@cStatus = E.status
				FROM Processadora.dbo.Estabelecimentos E WITH(NOLOCK)
				WHERE (E.Numero = @iEstabelecimento)
			END
		END
	
	END
		
	IF (ISNULL(@iEstabelecimento,0) = 0)
		SET @sEstabelecimento = 0
	ELSE
		SET @sEstabelecimento = @iEstabelecimento

END



