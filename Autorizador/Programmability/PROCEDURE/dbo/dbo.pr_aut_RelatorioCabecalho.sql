
/*
--------------------------------------------------------------------------
Nome Sistema: Autorização
Objeto: [dbo].[pr_aut_RelatorioCabecalho]
Autor: Cristiano Silva Barbosa
--------------------------------------------------------------------------
Data criação: 19/02/2017
Mudança: 2601
--------------------------------------------------------------------------
*/

CREATE PROCEDURE [pr_aut_RelatorioCabecalho] (
	 @cTerminal					CHAR(8)
	,@iCodigoEstabelecimento	INT
	,@bEstabMigrado				BIT
	,@cData  					VARCHAR(20)
	,@cResposta					CHAR(2)			OUTPUT
	,@cTicket					VARCHAR(1000)	OUTPUT
	)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE  
		 @iResposta					INT
		,@cCnpj_Estabelecimento		VARCHAR(18)
		,@cNome_Estabelecimento		VARCHAR(41)
		,@cEndereco_Estabelecimento VARCHAR(41)
		,@cCidade_Estabelecimento	VARCHAR(30)
		,@cEstado_Estabelecimento	CHAR(2)
	
	SET @iResposta = 0
	
	
	IF (@bEstabMigrado = 0)
	BEGIN
		SELECT 
			  @cCnpj_Estabelecimento      = LTRIM(RTRIM(CNPJ))
			 ,@cNome_Estabelecimento      = LTRIM(RTRIM(Nome))
			 ,@cEndereco_Estabelecimento  = LTRIM(RTRIM(Endereco))
			 ,@cCidade_Estabelecimento    = LTRIM(RTRIM(Cidade))
			 ,@cEstado_Estabelecimento    = LTRIM(RTRIM(Estado))
		 FROM Processadora.dbo.Estabelecimentos WITH(NOLOCK)
		 WHERE Numero  = @iCodigoEstabelecimento /* PARÂMETRO DE ENTRADA REFERENTE AO CÓDIGO POLICARD DO ESTABELECIMENTO */     
	END
	ELSE IF (@bEstabMigrado = 1)
	BEGIN
		
		 SELECT 
		     @cCNPJ_Estabelecimento		= dbo.f_FormatarCNPJ_CPF(E.Cnpj)
			,@cNome_Estabelecimento		= LTRIM(RTRIM(E.Nome))
			,@cEndereco_Estabelecimento	= LTRIM(RTRIM(EE.Logradouro))
			,@cCidade_Estabelecimento	= LTRIM(RTRIM(EE.Cidade))
			,@cEstado_Estabelecimento	= EE.UF
		FROM Acquirer.dbo.Estabelecimento E WITH (NOLOCK)
		INNER JOIN Acquirer.dbo.EstabelecimentoEndereco EE WITH (NOLOCK) ON E.CodigoEstabelecimento = EE.CodigoEstabelecimento
		WHERE E.CodigoEstabelecimento = @iCodigoEstabelecimento
		AND EE.CodigoTipoEndereco = 1

	END
			
	IF (@iResposta = 0)
	BEGIN       
		SET @cTicket = @cNome_Estabelecimento 
		             + '@' + @cEndereco_Estabelecimento 
		             + '@' + @cCidade_Estabelecimento + '-' + @cEstado_Estabelecimento + '@'
					 + 'CNPJ: ' + @cCnpj_Estabelecimento + '@'
		SET @cResposta = '00'
	END
END
