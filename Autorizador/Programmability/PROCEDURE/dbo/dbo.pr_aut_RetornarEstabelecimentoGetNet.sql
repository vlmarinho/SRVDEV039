 

/*
--------------------------------------------------------------------------
Data........: 
Nome Sistema: Autorizador
Objeto......: [pr_aut_RetornarEstabelecimentoGetNet]
Propósito...: Procedure responsável por  retornar os dados  para validação
			  do Estabelecimento.
--------------------------------------------------------------------------
Data Alteração: 12/03/2019
Chamados: 
Responsavel: João Henrique - Up Brasil
--------------------------------------------------------------------------
Data Alteração: 29/10/2021
Chamados: 
Responsavel: João Henrique - Up Brasil
--------------------------------------------------------------------------
Data Alteração: 01/11/2021
Responsavel: João Henrique - Up Brasil
CH:  1778396 
Descrição: Correção do fluxo de habilitação de estabelecimento Softnex
--------------------------------------------------------------------------
Data Alteração: 05/11/2021
Responsavel: João Henrique - Up Brasil
CH:  1778396 
Descrição: Correção do fluxo de habilitação de estabelecimento Softnex
--------------------------------------------------------------------------
Data Alteração: 27/01/2022
Responsavel: João Henrique - Up Brasil
CH:   
Descrição: Inclusão rede 26 Apps
--------------------------------------------------------------------------
Data: 11/05/2023
Autor: Adilson Pereira - Up Brasil
Chamdo: 2009473
Descrição: Remoção das redes 46, 47, 48, 49, 50 e 51 (Adyen) que serão tratadas em procedure específica.
--------------------------------------------------------------------------
*/


CREATE PROCEDURE [dbo].[pr_aut_RetornarEstabelecimentoGetNet] (
	 @sEstabelecimento	VARCHAR(20)	OUTPUT
	,@cStatus			CHAR(1)		OUTPUT
	,@bEstabMigrado		BIT			OUTPUT
	,@bHabilitadoGetNet	BIT			OUTPUT
	,@iRedeCodigo		INT
	)
AS
BEGIN
	
	SET NOCOUNT ON;

	IF @iRedeCodigo = 33
		SET @iRedeCodigo = 32

	DECLARE @iEstabelecimento	BIGINT
		,@iRetorno	INT

	SET @bEstabMigrado = 0
	SET @iRetorno = 0
	SET @sEstabelecimento = REPLACE (@sEstabelecimento,'.','')

	SELECT @sEstabelecimento = SUBSTRING(@sEstabelecimento,PATINDEX('%[a-z,1-9]%',@sEstabelecimento),LEN(@sEstabelecimento))
	
	IF (ISNUMERIC(@sEstabelecimento) = 1)
		SET @iEstabelecimento = CONVERT(BIGINT,@sEstabelecimento)
	ELSE
		SET @iEstabelecimento = 0

		IF (@iRedeCodigo = 32)
		BEGIN
				
				IF (@iEstabelecimento > 0)
				BEGIN
					SELECT @iRetorno = E.CodigoEstabelecimento
						  ,@bEstabMigrado = 1
						  ,@bHabilitadoGetNet = ISNULL(ES.Habilitado,0)
						  ,@cStatus = CASE WHEN E.CodigoEntidadeStatus = 1 THEN 'A'
										WHEN E.CodigoEntidadeStatus = 2 THEN 'I'
										WHEN E.CodigoEntidadeStatus = 3 THEN 'C'
										WHEN E.CodigoEntidadeStatus = 4 THEN 'P'
										WHEN E.CodigoEntidadeStatus = 6 THEN 'B'
							END
					FROM Acquirer.dbo.Estabelecimento E WITH(NOLOCK)
					INNER JOIN Acquirer.dbo.EstabelecimentoGetNet ES WITH(NOLOCK) ON (ES.CodigoEstabelecimento = E.CodigoEstabelecimento)
					WHERE ES.CodigoGetNet = @iEstabelecimento
					and ES.CodRede = @iRedeCodigo
				END

				IF (@bEstabMigrado = 0)
				BEGIN
					SELECT	
						 @iRetorno = ES.CodigoEstabelecimento
						,@bEstabMigrado = 0
						,@cStatus = E.status
						,@bHabilitadoGetNet = ISNULL(ES.Habilitado,0)
					FROM Processadora.dbo.Estabelecimentos E WITH(NOLOCK)
					INNER JOIN Acquirer.dbo.EstabelecimentoGetNet ES WITH(NOLOCK) ON (ES.CodigoEstabelecimento = E.Numero)
					WHERE ES.CodigoGetNet = @iEstabelecimento
					and ES.CodRede = @iRedeCodigo 
				END			
		END

		IF (@iRedeCodigo in (34,35,38,39,40,41,42,43,52,53,54,57,58))
		BEGIN
				
				IF (@iEstabelecimento > 0)
				BEGIN
					SELECT @iRetorno = E.CodigoEstabelecimento
						  ,@bEstabMigrado = 1
						  ,@bHabilitadoGetNet = ISNULL(ES.Habilitado,0)
						  ,@cStatus = CASE WHEN E.CodigoEntidadeStatus = 1 THEN 'A'
										WHEN E.CodigoEntidadeStatus = 2 THEN 'I'
										WHEN E.CodigoEntidadeStatus = 3 THEN 'C'
										WHEN E.CodigoEntidadeStatus = 4 THEN 'P'
										WHEN E.CodigoEntidadeStatus = 6 THEN 'B'
							END
					FROM Acquirer.dbo.Estabelecimento E WITH(NOLOCK)
					INNER JOIN Acquirer.dbo.EstabelecimentoGetNet ES WITH(NOLOCK) ON (ES.CodigoEstabelecimento = E.CodigoEstabelecimento)
					WHERE ES.CodigoGetNet = @iEstabelecimento
					and ES.CodRede in (34,35,38,39,40,41,42,43,52,53,54,57,58)
				END

				IF (@bEstabMigrado = 0)
				BEGIN
					SELECT	
						 @iRetorno = ES.CodigoEstabelecimento
						,@bEstabMigrado = 0
						,@cStatus = E.status
						,@bHabilitadoGetNet = ISNULL(ES.Habilitado,0)
					FROM Processadora.dbo.Estabelecimentos E WITH(NOLOCK)
					INNER JOIN Acquirer.dbo.EstabelecimentoGetNet ES WITH(NOLOCK) ON (ES.CodigoEstabelecimento = E.Numero)
					WHERE ES.CodigoGetNet = @iEstabelecimento
					and ES.CodRede in (34,35,38,39,40,41,42,43,52,53,54,57,58)
				END		
		END	

		IF (@iRedeCodigo = 26)
		BEGIN
				
				IF (@iEstabelecimento > 0)
				BEGIN
					SELECT @iRetorno = E.CodigoEstabelecimento
						  ,@bEstabMigrado = 1
						  ,@bHabilitadoGetNet = ISNULL(ES.Habilitado,0)
						  ,@cStatus = CASE WHEN E.CodigoEntidadeStatus = 1 THEN 'A'
										WHEN E.CodigoEntidadeStatus = 2 THEN 'I'
										WHEN E.CodigoEntidadeStatus = 3 THEN 'C'
										WHEN E.CodigoEntidadeStatus = 4 THEN 'P'
										WHEN E.CodigoEntidadeStatus = 6 THEN 'B'
							END
					FROM Acquirer.dbo.Estabelecimento E WITH(NOLOCK)
					INNER JOIN Acquirer.dbo.EstabelecimentoGetNet ES WITH(NOLOCK) ON (ES.CodigoEstabelecimento = E.CodigoEstabelecimento)
					WHERE ES.CodigoGetNet = @iEstabelecimento
					and ES.CodRede = @iRedeCodigo
				END

				IF (@bEstabMigrado = 0)
				BEGIN
					SELECT	
						 @iRetorno = ES.CodigoEstabelecimento
						,@bEstabMigrado = 0
						,@cStatus = E.status
						,@bHabilitadoGetNet = ISNULL(ES.Habilitado,0)
					FROM Processadora.dbo.Estabelecimentos E WITH(NOLOCK)
					INNER JOIN Acquirer.dbo.EstabelecimentoGetNet ES WITH(NOLOCK) ON (ES.CodigoEstabelecimento = E.Numero)
					WHERE ES.CodigoGetNet = @iEstabelecimento
					and ES.CodRede = @iRedeCodigo 
				END			
		END
		
	IF (ISNULL(@iEstabelecimento,0) = 0)
		SET @sEstabelecimento = @sEstabelecimento
	ELSE
		SET @sEstabelecimento = @iRetorno

END
