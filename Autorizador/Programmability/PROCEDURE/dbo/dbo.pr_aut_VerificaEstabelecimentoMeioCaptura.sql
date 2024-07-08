



/* 
------------------------------------------------------------------------------
Nome Sistema: Autorização
Objeto: [dbo].[pr_aut_VerificaEstabelecimentoMeioCaptura]
Propósito: Procedure responsável por verificar estabelecimento e meio captura
Autor: Cristiano Silva Barbosa - Tecnologia Policard
-------------------------------------------------------------------------------
Data criação: 19/02/2017
Mudança: 2601
-------------------------------------------------------------------------------
Data: 24/02/2017
Mud/CH.: 359154 / 2627
--------------------------------------------------------------------------
Data Alteracao: 21/03/2017
Autor: Cristiano Barbosa
CH: 365214 - 2676
--------------------------------------------------------------------------
Data Alteracao: 16/08/2017
Autor: Cristiano Barbosa
CH: 410107 - 3153
--------------------------------------------------------------------------
Data Alteracao: 25/03/2019
Autor: Kyros
CH: 618588 - Projeto Melhorias SGF - Auto Gestão
Descrição: Criação de uma nova Opção Frota (4) e de uma nova Rede (SGF)
--------------------------------------------------------------------------
Data Alteracao: 03/07/2019
Autor: João Henrique
CH: 
Descrição: Alterando regra de validação dos meios de capturas no Acquirer New
--------------------------------------------------------------------------
Data Alteracao: 05/08/2021
Autor: João Henrique
CH: 1741118 
Descrição: Inclusão da captura dos cartões PAT na PagSeguro
--------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[pr_aut_VerificaEstabelecimentoMeioCaptura](
	 @cBit001						CHAR(4)
	,@cBit041						CHAR(8)
	,@cBit047						VARCHAR(200)	
	,@iRedeNumero					INT
	,@iCodigoEstabelecimento		BIGINT
	,@bEstabMigrado					BIT
	,@cProvedor						VARCHAR(50)
	,@iEstCodigo					INT				OUTPUT
	,@cCNPJ_Estabelecimento			CHAR(20)		OUTPUT
	,@cNome_Estabelecimento			VARCHAR(30)		OUTPUT
	,@cEndereco_Estabelecimento		VARCHAR(50)		OUTPUT
	,@cCidade_Estabelecimento		VARCHAR(30)		OUTPUT
	,@cEstado_Estabelecimento		CHAR(2)			OUTPUT
	,@bPermiteDigitado				BIT				OUTPUT
	,@bPermiteSemSenha				BIT				OUTPUT
	,@iTipoMeioCaptura				INT				OUTPUT
	,@iMeiCptCodigo					INT				OUTPUT
	,@iResposta						INT				OUTPUT
		
)

AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE
		 @cStatus				CHAR(1)
		,@cIdPOS				CHAR(08)


	
	IF (@bEstabMigrado = 0)
	BEGIN

		
		/* Migração do POS Phoebus para Masters */
	 	IF NOT EXISTS (SELECT 1 FROM Processadora.dbo.MeiosCaptura WITH (NOLOCK) WHERE NUMERO = @cBit041) AND @iRedeNumero IN (23,24)
		BEGIN
			SET @cIdPOS = '3011'+substring (@cBit041,5,4)
			EXEC Processadora.dbo.pr_ACQ_MigrarPOS_Masters @NumeroLogicoMigrar = @cIdPOS , @Responsavel = 'Autorizador', @iRedeNumero = @iRedeNumero		
		END

		/* Consulta base de estabelecimento */
		SELECT 
			 @iEstCodigo					= EST.EstCodigo
			,@cStatus						= EST.Status
			,@cCNPJ_Estabelecimento			= EST.CNPJ
			,@cNome_Estabelecimento			= LTRIM(RTRIM(EST.Nome))
			,@cEndereco_Estabelecimento		= LTRIM(RTRIM(EST.Endereco))
			,@cCidade_Estabelecimento		= LTRIM(RTRIM(EST.Cidade))
			,@cEstado_Estabelecimento		= EST.Estado
			,@bPermiteDigitado				= EST.PermiteTransacaoDigitada
			,@bPermiteSemSenha				= EST.PermiteTransacaoSemSenha
		FROM Processadora.dbo.Estabelecimentos EST WITH(NOLOCK)
		WHERE EST.Numero = @iCodigoEstabelecimento

		SET @cCidade_Estabelecimento = dbo.f_FormatarTexto(@cCidade_Estabelecimento)

		/* Validando se o estabelecimento foi encontrado no cadastro*/
		IF (@iEstCodigo IS NULL)
			SET @iResposta = 116 -- ESTABELECIMENTO INVALIDO


		/* Validar o vinculo de meio de captura*/
		IF (@iResposta = 0 AND @iRedeNumero IN(8,13,22,23,24,57,58)) -- TEF PAYGO/DISCADO, POS POLICARD, POS MASTERS PHOEBUS, POS WALW
			EXEC Processadora.[dbo].[pr_AUT_Verifica_Meioscaptura] @cBit041, @iCodigoEstabelecimento, @cBit047, @iRedeNumero, 0 ,@iResposta OUTPUT
			
		
		--IF (@iResposta = 0)
		--BEGIN
		--	----------------------------------------------------------------------------------------------
		--	--Nome      : Validar_Vinculo_Estabelecimento_Rede
		--	--Descrição : Valida se o estabelecimento em questão pode realizar transações na rede da transação
		--	--   Deve ser realizado uma validação de existência de resultados.
		--	----------------------------------------------------------------------------------------------
		--	IF NOT EXISTS ( SELECT	1
		--					FROM	Processadora.dbo.EstabelecimentosRedes ER WITH(NOLOCK)
		--					WHERE	ER.EstCodigo = @iEstCodigo
		--					AND ER.RdeCodigo = @iRedeCodigo)
		--		SET @iResposta = 277 /* ESTABELECIMENTO NAO ASSOCIADO A REDE - NAO PERMITIDA */
		--END


		/*Capturar o codigo e o tipo de meio de captura*/
		IF (@iRedeNumero IN (8,13,14,16,17,19,22,23,24,37,57,58))
		BEGIN
			SELECT @iMeiCptCodigo = MeiCptCodigo
				,@iTipoMeioCaptura = TpoMeiCptCodigo 
			FROM Processadora.dbo.MeiosCaptura WITH (NOLOCK)
			WHERE Numero = @cBit041

		END
		ELSE IF (@iRedeNumero = 10)
		BEGIN
			SET @iMeiCptCodigo = 15023
			SET @iTipoMeioCaptura = 12
		END
		ELSE IF (@iRedeNumero = 7)
		BEGIN
			SET @iMeiCptCodigo = 10000
			SET @iTipoMeioCaptura = 9
		END
		ELSE IF (@iRedeNumero = 25) /*Criar um tipo de meio de captura e o meio de captura para a rede Sysdata*/
		BEGIN

			SET @iTipoMeioCaptura = 21
			SELECT TOP 1 @iMeiCptCodigo = MeiCptCodigo FROM Processadora.dbo.MEIOSCAPTURA WITH (NOLOCK) where TpoMeiCptCodigo = @iTipoMeioCaptura

		END
		ELSE IF (@iMeiCptCodigo IS NULL)
		BEGIN
		
			SET @iMeiCptCodigo = 0 
			SET @iTipoMeioCaptura = 0
		END

	END
	ELSE 
	BEGIN 
			
		SELECT 
			 @cStatus					= CASE WHEN E.CodigoEntidadeStatus = 1 THEN 'A'
											   WHEN E.CodigoEntidadeStatus = 2 THEN 'I'
											   WHEN E.CodigoEntidadeStatus = 3 THEN 'C'
											   WHEN E.CodigoEntidadeStatus = 4 THEN 'P'
											   WHEN E.CodigoEntidadeStatus = 6 THEN 'B'
										  END
			,@cCNPJ_Estabelecimento		= dbo.f_FormatarCNPJ_CPF(E.Cnpj)
			,@cNome_Estabelecimento		= LTRIM(RTRIM(E.Nome))
			,@cEndereco_Estabelecimento	= LTRIM(RTRIM(EE.Logradouro))
			,@cCidade_Estabelecimento	= LTRIM(RTRIM(EE.Cidade))
			,@cEstado_Estabelecimento	= EE.UF
			,@bPermiteDigitado			= ECA.TransacaoDigitada
			,@bPermiteSemSenha			= ECA.TransacaoSemSenha
		FROM Acquirer.dbo.Estabelecimento E WITH (NOLOCK)
		INNER JOIN Acquirer.dbo.EstabelecimentoEndereco EE WITH (NOLOCK) ON E.CodigoEstabelecimento = EE.CodigoEstabelecimento
		INNER JOIN Acquirer.dbo.EstabelecimentoConfiguracoesAdicionais ECA WITH (NOLOCK) ON E.CodigoEstabelecimento = ECA.CodigoEstabelecimento
		WHERE E.CodigoEstabelecimento = @iCodigoEstabelecimento
		AND EE.CodigoTipoEndereco = 1


		IF (@cBit001 NOT IN ('0202','0402'))
		BEGIN

			IF (@iRedeNumero IN (7,8))
			BEGIN 

				SELECT @iMeiCptCodigo = MC.CodigoMeioCaptura
					  ,@iTipoMeioCaptura = MC.CodigoTipoMeioCaptura 
				FROM Acquirer.dbo.EstabelecimentoMeioCaptura EMC WITH(NOLOCK)
				INNER JOIN Acquirer.dbo.MeioCaptura MC WITH(NOLOCK) ON EMC.CodigoMeioCaptura = MC.CodigoMeioCaptura
				INNER JOIN Acquirer.dbo.TipoSistemaTEF TST WITH(NOLOCK) ON MC.CodigoTipoSistemaTEF = TST.CodigoTipoSistemaTEF
				WHERE TST.DescricaoAutorizador like '%'+ @cProvedor +'%'
				AND EMC.Ativo = 1
			
				IF (@iMeiCptCodigo IS NULL)
					SET @iResposta = 109

			END
			ELSE
			BEGIN
	

				SELECT @iMeiCptCodigo = MC.CodigoMeioCaptura
					  ,@iTipoMeioCaptura = MC.CodigoTipoMeioCaptura 
				FROM Acquirer.dbo.EstabelecimentoMeioCaptura EMC WITH(NOLOCK)
				INNER JOIN Acquirer.dbo.MeioCaptura MC ON EMC.CodigoMeioCaptura = MC.CodigoMeioCaptura
				WHERE MC.NumeroLogico = @cBit041
				AND EMC.Ativo = 1

				IF (@iMeiCptCodigo IS NULL)
				BEGIN
				
					IF (@iRedeNumero = 20)
					BEGIN
						SET @iMeiCptCodigo = 2
						SET @iTipoMeioCaptura = 2
					END
					ELSE IF @iRedeNumero IN (10,16,17,19,37) --INCLUINDO CIELO
					BEGIN
						
						/*Verificar*/
						IF (@iRedeNumero IN (16,37)) --CRM
						BEGIN
							SET @iMeiCptCodigo = 1
							SET @iTipoMeioCaptura = 1
						END
						ELSE IF (@iRedeNumero = 17) --CAE
						BEGIN
							SET @iMeiCptCodigo = 119
							SET @iTipoMeioCaptura = 5
						END
						ELSE 
						BEGIN
							SET @iMeiCptCodigo = 27321
							SET @iTipoMeioCaptura = 17
						END

						IF (@iRedeNumero = 10) --INCLUINDO CIELO
						BEGIN
							SET @iMeiCptCodigo = 15023
							SET @iTipoMeioCaptura = 12
						END
					 END
					ELSE
						SET @iResposta = 109

				END
			END
		END
	END

	/* Consulta base de estabelecimento */
	IF (@iResposta = 0 AND @iRedeNumero IN (16,17,19,20,27,37))
	BEGIN


		IF (@bEstabMigrado = 0)
		BEGIN

			DECLARE @iRedecodigo INT

			SELECT @iRedecodigo = RdeCodigo FROM Processadora.dbo.Redes WITH (NOLOCK) WHERE Numero = @iredenumero
			
			IF NOT EXISTS ( SELECT 1 FROM	Processadora.dbo.EstabelecimentosRedes ER WITH(NOLOCK)
						WHERE ER.RdeCodigo = @iRedecodigo AND ER.EstCodigo = @iEstCodigo
						)
			
			BEGIN

				INSERT INTO Processadora.dbo.EstabelecimentosRedes (RdeCodigo, EstCodigo) VALUES (@iRedecodigo,@iEstCodigo)

			END

		END
		ELSE
		BEGIN
				
			IF NOT EXISTS ( SELECT	1 FROM	Acquirer.dbo.SubRedeEstabelecimento RE WITH(NOLOCK)
						WHERE RE.CodigoEstabelecimento = @iCodigoEstabelecimento
						AND RE.CodigoSubRede = @iRedeNumero
						)
			
			BEGIN
					
				INSERT INTO Acquirer.dbo.SubRedeEstabelecimento (CodigoSubRede, CodigoEstabelecimento, Ativo, DataAlteracao, CodigoUsuario) VALUES (@iRedeNumero,@iCodigoEstabelecimento,1,GETDATE(),0)
					
			END
				
		END
	END

	/* Estabelecimento Bloqueado / Cancelado */
	IF (@cStatus <> 'A' AND @cBit001 <> '0810')
		SET @iResposta = 331 --BLOQ./CANCEL.

	/* Confirmar Transações 2 Vias */
	IF (@iResposta = 0 AND (@iRedeNumero NOT IN (7,8,22,23,24,14,55,56,36,29,25) AND @cBit001 <> '0430')) /*TEF DEDICADO / TEF DISCADO / POS ITAU / POS PHOEBUS*/
	BEGIN

		EXEC pr_AUT_ConfirmarTransacoes2Vias
			 @iRedeNumero
			,@iCodigoEstabelecimento
			,@cBit041
	END

END


