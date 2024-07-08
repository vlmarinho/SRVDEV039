

/*
--------------------------------------------------------------------------
Data........: 
Nome Sistema: Autorizador
Objeto......: [pr_aut_RetornarEstabelecimentoRede]
Propósito...: Procedure responsável por  retornar os dados  para validação
			  do Estabelecimento.
--------------------------------------------------------------------------
Data Alteração: 19/07/2019
Chamados: 
Responsavel: João Henrique - Up Brasil
--------------------------------------------------------------------------
Data Alteração: 28/04/2020
Chamados: 
Responsavel: João Henrique - Up Brasil - Remoção da regra de validação de 
codigos de estabelecimentos importados da Comunix, devido a conflito com o campo numero 
--------------------------------------------------------------------------

*/


CREATE PROCEDURE [dbo].[pr_aut_RetornarEstabelecimentoRede] (
	 @sEstabelecimento	VARCHAR(20)	OUTPUT
	,@cStatus			CHAR(1)		OUTPUT
	,@bEstabMigrado		BIT			OUTPUT
	,@bHabilitadoRede	BIT			OUTPUT
	)
AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @iEstabelecimento	BIGINT
		,@iRetorno	INT

	SET @bEstabMigrado = 0
	SET @iRetorno = 0
	SET @sEstabelecimento = REPLACE (@sEstabelecimento,'.','')

	SELECT @sEstabelecimento = SUBSTRING(@sEstabelecimento,PATINDEX('%[a-z,1-9]%',@sEstabelecimento),LEN(@sEstabelecimento))
	if (len (@sEstabelecimento)=15 and substring(@sEstabelecimento,1,3)='539')
	set @sEstabelecimento =  substring(@sEstabelecimento,4,10)
	
	IF (ISNUMERIC(@sEstabelecimento) = 1)
		SET @iEstabelecimento = CONVERT(BIGINT,@sEstabelecimento)
	ELSE
		SET @iEstabelecimento = 0

   /*migração com codigo rede e codigo comunix*/
	SET @iRetorno = @iEstabelecimento

	--IF NOT EXISTS(select 1 from Processadora..Estabelecimentos (nolock) where numero = @iEstabelecimento )   /*migração com codigo rede e codigo comunix*/
	--BEGIN
		IF (@iEstabelecimento > 0)
		BEGIN
		
			SELECT @iRetorno = E.CodigoEstabelecimento
				  ,@bEstabMigrado = 1
				  ,@bHabilitadoRede = ISNULL(ES.Habilitado,0)
				  ,@cStatus = CASE WHEN E.CodigoEntidadeStatus = 1 THEN 'A'
								WHEN E.CodigoEntidadeStatus = 2 THEN 'I'
								WHEN E.CodigoEntidadeStatus = 3 THEN 'C'
								WHEN E.CodigoEntidadeStatus = 4 THEN 'P'
								WHEN E.CodigoEntidadeStatus = 6 THEN 'B'
					END
			FROM Acquirer.dbo.Estabelecimento E WITH(NOLOCK)
			INNER JOIN Acquirer.dbo.EstabelecimentoRede ES WITH(NOLOCK) ON (ES.CodigoEstabelecimento = E.CodigoEstabelecimento)
			WHERE ES.CodigoRede = @iEstabelecimento
			AND es.Habilitado = 1

			IF (@bEstabMigrado = 0)
			BEGIN
		
				SELECT	
					 @iRetorno = ES.CodigoEstabelecimento
					,@bEstabMigrado = 0
					,@cStatus = E.status
					,@bHabilitadoRede = ISNULL(ES.Habilitado,0)
				FROM Processadora.dbo.Estabelecimentos E WITH(NOLOCK)
				INNER JOIN Acquirer.dbo.EstabelecimentoRede ES WITH(NOLOCK) ON (ES.CodigoEstabelecimento = E.Numero)
				WHERE ES.CodigoRede = @iEstabelecimento
				AND es.Habilitado = 1
			
			END
	
		END
	--END
		IF (ISNULL(@iEstabelecimento,0) = 0)
			SET @sEstabelecimento = 0
		ELSE
			SET @sEstabelecimento = @iRetorno

END
