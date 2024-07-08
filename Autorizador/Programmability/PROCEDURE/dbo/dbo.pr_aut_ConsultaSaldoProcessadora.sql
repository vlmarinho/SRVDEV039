/*
--------------------------------------------------------------------------
Nome Sistema: Autorização
Objeto: [dbo].[pr_aut_ConsultaSaldoProcessadora]
Propósito: Procedure responsável por consultar saldo.
Autor: Cristiano Silva Barbosa - Tecnologia Policard
--------------------------------------------------------------------------
Data: 19/02/2017
Mud/CH.:  2601 
--------------------------------------------------------------------------


*/

CREATE PROCEDURE [pr_aut_ConsultaSaldoProcessadora](
	 @cBit003					VARCHAR(6)
	,@cNumeroCartao				CHAR(16)
	,@iRedeNumero				INT				OUTPUT
	,@iCodigoEstabelecimento	INT				OUTPUT
	,@bEstabMigrado				BIT
	,@cBit062					VARCHAR(1000)   OUTPUT
	,@cBit041					CHAR(8)
	,@cBit011					CHAR(6)
	,@dDataHora_Transacao		DATETIME
	,@iResposta					INT				OUTPUT
	
)
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE
		 @iCrtUsrCodigo_CartoesUsuarios		INT
		,@iTpoPrdCodigo_CartoesUsuarios		INT
		,@nCreditoDisponivelCartao			DECIMAL(15,2)
		,@cStatus_CartoesUsuarios			CHAR(1)
		,@sNome_Usuario                     VARCHAR(50)
		,@cStatus_ContasUsuarios			CHAR(1)
		,@cStatus_Estabelecimentos			CHAR(1)
		,@sLabelProduto						VARCHAR(40)
		,@sNome_Estabelecimento				VARCHAR(40)
		,@sEndereco_Estabelecimento			VARCHAR(40)
		,@sCidade_Estabelecimento			VARCHAR(40)
		,@sCNPJ_Estabelecimento				VARCHAR(20)
		,@sEstado_Estabelecimento			CHAR(2)
		

		

	SELECT	
		 @iCrtUsrCodigo_CartoesUsuarios		= C.CrtUsrCodigo         
		,@iTpoPrdCodigo_CartoesUsuarios		= C.TpoPrdCodigo
		,@nCreditoDisponivelCartao			= C.CreditoDisponivel
		,@cStatus_CartoesUsuarios			= C.Status
		,@sNome_Usuario                     = C.Nome
		,@cStatus_ContasUsuarios			= CU.Status
		,@sLabelProduto						= LTRIM(RTRIM(UPPER(COALESCE(TP.Descricao,TP.NOME))))
	FROM Processadora.dbo.CartoesUsuarios C WITH(NOLOCK)
	INNER JOIN Processadora.dbo.TiposProdutos TP WITH(NOLOCK) ON TP.TpoPrdCodigo = C.TpoPrdCodigo 
	INNER JOIN Processadora.dbo.ContasUsuarios CU WITH (NOLOCK) ON C.CntUsrCodigo = CU.CntUsrCodigo
	WHERE c.Numero = @cNumeroCartao
	AND C.FlagTransferido = 0


	IF (@bEstabMigrado = 0)
	BEGIN

		SELECT	
			  @cStatus_Estabelecimentos		= [Status]
			 ,@sNome_Estabelecimento		= UPPER(LTRIM(RTRIM(Nome)))
			 ,@sEndereco_Estabelecimento	= UPPER(LTRIM(RTRIM(Endereco)))
			 ,@sCidade_Estabelecimento		= UPPER(LTRIM(RTRIM(Cidade)))
			 ,@sCNPJ_Estabelecimento		= CNPJ
			 ,@sEstado_Estabelecimento		= UPPER(LTRIM(RTRIM(Estado)))

		FROM	
			Processadora.dbo.Estabelecimentos WITH(NOLOCK)
		WHERE	
			Numero = @iCodigoEstabelecimento

	END
	ELSE
	BEGIN 

								
		SELECT 
			@cStatus_Estabelecimentos = CASE WHEN E.CodigoEntidadeStatus = 1 THEN 'A'
											WHEN E.CodigoEntidadeStatus = 2 THEN 'I'
											WHEN E.CodigoEntidadeStatus = 3 THEN 'C'
											WHEN E.CodigoEntidadeStatus = 4 THEN 'P'
											WHEN E.CodigoEntidadeStatus = 6 THEN 'B'
										END
			,@sCNPJ_Estabelecimento		= dbo.f_FormatarCNPJ_CPF(E.Cnpj)
			,@sNome_Estabelecimento		= UPPER(LTRIM(RTRIM(E.Nome)))
			,@sEndereco_Estabelecimento	= UPPER(LTRIM(RTRIM(EE.Logradouro))) + ',' + CONVERT(VARCHAR, EE.Numero)
			,@sCidade_Estabelecimento   = UPPER(LTRIM(RTRIM(EE.Cidade))) 
			,@sEstado_Estabelecimento   = EE.UF
		FROM Acquirer.dbo.Estabelecimento E WITH (NOLOCK)
		INNER JOIN Acquirer.dbo.EstabelecimentoEndereco EE WITH (NOLOCK) ON E.CodigoEstabelecimento = EE.CodigoEstabelecimento
		WHERE E.CodigoEstabelecimento = @iCodigoEstabelecimento
		AND EE.CodigoTipoEndereco = 1

	END

	
	/*
	Trava: Validar_Existencia_Cartao_Usuario      
	Descrição : Verifica a existência do cartão do usuário.    
	Código: --
	*/

	IF (@iCrtUsrCodigo_CartoesUsuarios IS NOT NULL)
	BEGIN
			
		/*
		Trava: Validar o tipo de produto
		Descrição : Verifica se o cartao é Polifrete.    
		Código: --
		*/
		
		IF (@iTpoPrdCodigo_CartoesUsuarios = 59)
		BEGIN

			/*
			Trava: Validar_Status_Cartao_Usuario      
			Descrição : Verifica o status do cartão do usuário.    
			Código: --
			*/

			IF (@cStatus_CartoesUsuarios = 'A')
			BEGIN

				/*
				Trava: Validar_Status_Conta_Usuario      
				Descrição : Verifica o status da conta do usuário.
				Código: --
				*/

				IF (@cStatus_ContasUsuarios = 'A')
				BEGIN

					/*
					Trava: Validar_Existencia_Estabelecimento      
					Descrição : Verifica a existência do estabelecimento.    
					Código: --
					*/
						
					IF (@iCodigoEstabelecimento IS NOT NULL)
					BEGIN
								
						/*
						Trava: Validar_Status_Estabelecimento      
						Descrição : Verifica o status do estabelecimento.    
						Código: --
						*/
							
						IF (@cStatus_Estabelecimentos = 'A')
						BEGIN

							/************************************************************************************
							* Alterado por: Elmiro Leandro														*
							* Motivo: Buscar o formato do ticket a ser utilizado para o retorno da mensagem	*
							* Data: 15/06/2010																	*
							************************************************************************************/
							DECLARE @cAutorizacao CHAR(18)
									,@cBit038 CHAR(6)
									
							SET @cAutorizacao = [dbo].[f_GerarAutorizacao]()
							SET @cBit038 = RIGHT(@cAutorizacao, 6)

							EXEC [dbo].[pr_AUT_RetornarTicketTransacao]
								 '0100'
								,@cBit003
								,0			
								,0
								,@cBit011
								,@cBit038		
								,@cBit041			
								,@cBit062			OUTPUT
								,0			
								,@cBit038
								,@sCNPJ_Estabelecimento				
								,@cNumeroCartao		
								,NULL
								,@sLabelProduto		
								,@sNome_Usuario		
								,@sNome_Estabelecimento		
								,@sEndereco_Estabelecimento			
								,@sCidade_Estabelecimento			
								,@sEstado_Estabelecimento			
								,0		
								,@nCreditoDisponivelCartao	
								,@iRedeNumero				
								,@iCodigoEstabelecimento	
								,0	

						END
						ELSE
							SET @iResposta = 320
					END
					ELSE
						SET @iResposta = 116
				END
				ELSE
					SET @iResposta = 328
			END
			ELSE
				SET @iResposta = 95
		END
		ELSE
			SET @iResposta = 118
	END
	ELSE
		SET @iResposta = 12
END
