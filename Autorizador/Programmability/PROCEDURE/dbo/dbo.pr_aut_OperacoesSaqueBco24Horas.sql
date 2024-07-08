/*********************************************************************
** EMPRESA: POLICARD
** SISTEMA / MÓDULO:  PROCESSADORA / AUTORIZACAO
** NOME OBJETO: [pr_AUT_OperacoesSaqueBco24Horas]
** DESCRIÇÃO: Consultar o valor p/ saque a vista para cartões processadora;
			  Efetivar o saque para cartões processadora
			  Alterar Status dos Saques efetivados
**********************************************************************
PARÂMETRO(S) ENTRADA:
@cTipoOperacao --> TIPO DE OPERAÇÃO SOLICITADA
				  (C) - CONSULTA SALDO
				  (S) - SAQUE
				  (A) - CONFIRMAÇÃO
**********************************************************************
PARÂMETRO(S) SAÍDA:
@sInfoPlanos --> Valor da Tarifa cobrada para o saque
@iResposta --> Codigo da resposta em caso de erro de negocio ou sistema
**********************************************************************
** DATA CRIACAO = 19/03/2015
** AUTOR = 
** EMPRESA = CEDRO TECHNOLOGIES
**********************************************************************
Data: 23/07/2015
Mudança: 988
-------------------------------------------------------------------
*/
/*
-------------------------------------------------------------------
Nome Sistema: [Convenio]  
Objeto: [pr_AUT_OperacoesSaqueBco24Horas]  
Propósito: [Autorização de transações do banco 24 horas]  
Instancia/Banco: Processadora - Autorizacao
Autor: Victor Pires  
-------------------------------------------------------------------
Data: 19/08/2015  
Chamado/Mudança: 207983/1075  
-------------------------------------------------------------------
Data criação: 19/02/2017
Mudança: 2601
-------------------------------------------------------------------
Author:	Cristiano Barbosa
Data: 05/06/2018
CH.: 501627 / 503824 Mud.: 4062
-------------------------------------------------------------------------------------------
Data: 11/04/2024
Autor: Adilson Pereira - Up Brasil
Chamado: 2121626
Descrição: Alteração na regra de saque dos produtos benefícios para que
	  apenas clientes com Taxa Banco 24hrs configurada possam fazer
	  o saque.
-------------------------------------------------------------------------------------------

*/

CREATE PROCEDURE [dbo].[pr_aut_OperacoesSaqueBco24Horas](
	 @cTipoOperacao			CHAR(1)
	,@iCodCartao			INT
	,@dValorSaque			DECIMAL(15,2)
	,@iQtdParcelas			INT
	,@sNSUPolicard			VARCHAR(9)
	,@sNSUTecBan			VARCHAR(6)
	,@cModoEntrada			CHAR(3)
	,@sEstabelecimento		VARCHAR(15)		= NULL
	,@sTerminal				VARCHAR(8)
	,@iRedeCaptura			INT
	,@dDataHoraTransacao	DATETIME		= NULL
	,@sDataHoraGMT			VARCHAR(10)
	,@sDataTransacao		VARCHAR(4)
	,@sHoraTransacao		VARCHAR(6)
	,@cBit039Confirmacao	CHAR(2)			= NULL
	,@sReferenciaTecban		VARCHAR(6)
	,@sInfoPlanos			VARCHAR(2000)	OUTPUT
	,@iResposta				INT				OUTPUT
	)
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE  @iEstCodigo					INT
			,@iCodigoEstabelecimento		INT
			,@iTpoTrnCodigo					INT
			,@iMeiCptCodigo					INT
			,@iCntUsrCodigo					INT
			,@iLote							INT
			,@iTrnCodigoSaque				INT
			---,@iTrnCodigoTarifa				INT
			,@iTrnVinculada					INT
			,@iTpoPrdCodigo					TINYINT
			,@iPrdCodigo					TINYINT
			,@dValorTarifa					DECIMAL(15,2)
			,@bCartaoEmv					BIT
			,@bPermiteSaque					BIT
			,@cStatusTransacao				CHAR(1)
			,@cAutorizacao					CHAR(18) -- Utilizar Função gerada anteriormente
			,@sTipoMensagem					CHAR(4)
			,@cCodAutorizacao				VARCHAR(6)
			,@cTipoCartao					CHAR(1)
			,@cCodProcessamento 			CHAR(6)
			,@cNSURedeCaptura				CHAR(6)
			,@cCompResposta					CHAR(6)
			,@sNumeroCartao					VARCHAR(16)
			,@sInfoAdicionais				VARCHAR(1000)
			,@sDadosTrnOriginal				VARCHAR(99)
			,@sInfPolicard					VARCHAR(1000)
			,@sTicketRetorno				VARCHAR(1000)
			-- TAXAS
			,@iQtdSaquePromocional			INT				-- quantidade de saque promocional liberado no mês
			,@iQtdSaqueEfetuadoMes			INT				-- quantidade de saques efetuados no mês
			,@iQtdSaqueDiaPermitido			INT				-- quantidade de saques diários liberado
			,@iQtdSaqueDiaEfetuado			INT				-- quantidade de saques efetuados no dia
			,@dValorMaxSaqueDia				DECIMAL (15,2)	-- valor maximo de saque por dia
			,@dValorMaxDiaSacado			DECIMAL (15,2)	-- valor sacado no dia
			,@dValorTarifaSaquePromocional	DECIMAL (15,2)  -- valor da tarifa promocional ou normal
			,@dValorTarifaSaqueNormal		DECIMAL (15,2)	-- valor da tarifa promocional ou normal
			,@iCodTaxaPersonalizada			INT				-- código das taxas do cliente
			,@iEntidade						INT				-- código do cliente na processadora
			,@dCreditoDisponivelCartao		DECIMAL(15,2)	-- crédito disponivel para saque no cartao do usuario
			,@dCreditoDisponivelConta		DECIMAL(15,2)	-- crédito disponivel para saque na conta do usuario
			,@nPagamentoMinimo				DECIMAL(15,2)	-- Pagamento minimo

	SET @iResposta			= 0
	SET @iEstCodigo			= 131686 	-- FIXO: Alterar pelo novo Código que será cadastrado no Acquirer
	SET @iTpoTrnCodigo		= 350000
	SET @iMeiCptCodigo		= 26479		-- FIXO: Alterar pelo código que será gerado em Produção
	SET @iQtdParcelas		= 1			-- FIXO
	SET @cStatusTransacao	= 'P'
	SET @cAutorizacao		= dbo.f_GerarAutorizacao()
	SET @sTipoMensagem		= '0200'	-- FIXO: Usado somente no insert na Tabela Transações
	
	IF (@dDataHoraTransacao IS NULL)
		SET @dDataHoraTransacao = GETDATE()

	SELECT @iCodigoEstabelecimento = Numero FROM Processadora.dbo.Estabelecimentos WITH(NOLOCK) WHERE EstCodigo = @iEstCodigo

	SELECT	@iTpoPrdCodigo				= C.TpoPrdCodigo
			,@iPrdCodigo				= C.PrdCodigo
			,@iCntUsrCodigo				= C.CntUsrCodigo
			,@cTipoCartao				= C.Tipo
			,@iEntidade					= PR.EntCodigo
			,@bCartaoEmv				= ISNULL(C.Chip,0)
			,@dCreditoDisponivelCartao	= ISNULL(C.CreditoDisponivel,0)
			,@dCreditoDisponivelConta	= ISNULL(CO.CreditoDisponivel,0)
	FROM	Processadora.dbo.CartoesUsuarios C WITH(NOLOCK)
	INNER JOIN Processadora.dbo.ContasUsuarios CO WITH(NOLOCK) ON (CO.CntUsrCodigo = C.CntUsrCodigo)
	INNER JOIN Processadora.dbo.Propostas PR WITH(NOLOCK) ON (PR.PrpCodigo = CO.PrpCodigo)
	WHERE	C.CrtUsrCodigo = @iCodCartao

	-- SELECIONA TRANSAÇÃO VINCULADA E PAGAMENTO MINIMO
	SELECT 
		 @iTrnVinculada = T.TransacaoVinculada 
		,@nPagamentoMinimo = T.PagamentoMinimo
	FROM Processadora.dbo.TiposProdutosTiposTransacoes T WITH(NOLOCK) 
	WHERE T.TpoPrdCodigo  = @iTpoPrdCodigo 
	AND T.TpoTrnCodigo = @iTpoTrnCodigo

	-- SELECIONA QUANTIDADE DE SAQUES NO MES
	EXEC Processadora.dbo.pr_PROC_ConsultaMovimentacaoMensalHistorico 'S', @iCodCartao, @iTpoPrdCodigo, @iCntUsrCodigo, @iQtdSaqueEfetuadoMes OUTPUT
	
	-- SELECIONA CONFIGURAÇÃO DE COBRANÇA DE TARIFAS
	SELECT @iCodTaxaPersonalizada = ISNULL(Codigo,0) FROM Processadora.dbo.TaxaBanco24Hrs WITH(NOLOCK) WHERE CodigoCliente = @iEntidade AND CodigoProduto = @iTpoPrdCodigo

	-- SELECIONA PERFIL PERSONALIZADO
	IF (@iCodTaxaPersonalizada > 0)
	BEGIN
		-- BUSCAR PERFIL PERSONALIZADO
		SELECT	@iQtdSaqueDiaPermitido			= QtdMaxSaqueDia
				,@iQtdSaquePromocional			= QtdSaquePromocional
				,@dValorMaxSaqueDia				= ValorMaxSaqueDia
				,@dValorTarifaSaquePromocional	= ValorTarifaSaquePromocional
				,@dValorTarifaSaqueNormal		= ValorTarifaSaqueNormal
				,@bPermiteSaque					= ISNULL(PermiteSaque24H, 0)
		FROM	Processadora.dbo.TaxaBanco24Hrs WITH(NOLOCK)
		WHERE	CodigoCliente	= @iEntidade
			AND CodigoProduto	= @iTpoPrdCodigo

	END
	ELSE
	BEGIN
		
		SET @iResposta = 386
		
		-- BUSCAR PERFIL PADRÃO
--		SELECT	TOP 1
--				@iQtdSaqueDiaPermitido			= QtdMaxSaqueDia
--				,@iQtdSaquePromocional			= QtdSaquePromocional
--				,@dValorMaxSaqueDia				= ValorMaxSaqueDia
--				,@dValorTarifaSaquePromocional	= ValorTarifaSaquePromocional
--				,@dValorTarifaSaqueNormal		= ValorTarifaSaqueNormal
--				,@bPermiteSaque					= ISNULL(PermiteSaque24H,1)
--		FROM	Processadora.dbo.ConfigTaxaBco24Horas WITH(NOLOCK)
	END

	IF (@bPermiteSaque = 1)
	BEGIN

		-- VALOR SACADO DIA E QUANTIDADE DE SAQUES
		SELECT	@dValorMaxDiaSacado		= ISNULL(SUM(Valor), 0)
				,@iQtdSaqueDiaEfetuado	= ISNULL(COUNT(*),0)
		FROM	Processadora.dbo.Transacoes WITH(NOLOCK)
		WHERE	CrtUsrCodigo	 = @iCodCartao
		AND Data > CAST(FLOOR(CAST(GETDATE() AS FLOAT)) AS DATETIME)
		AND TpoTrnCodigo = '350000'
		AND Status IN ('P','A')

		-- VALOR TARIFA
		IF (@iQtdSaqueEfetuadoMes >= @iQtdSaquePromocional)
			SET @dValorTarifa = @dValorTarifaSaqueNormal
		ELSE
			SET @dValorTarifa = @dValorTarifaSaquePromocional
	
		-------------------------------------------------------------------------------------------------------
		-- VALIDAÇÕES
		-------------------------------------------------------------------------------------------------------
		IF (@cTipoOperacao IN ('S','C'))
		BEGIN
			-- VALOR DIARIO
			IF (@dValorMaxDiaSacado > @dValorMaxSaqueDia)
			BEGIN
				SET @iResposta = 394
				GOTO FIM
			END

			-- VALOR DIARIO + VALOR SOLICITADO
			IF (@dValorMaxDiaSacado + @dValorSaque > @dValorMaxSaqueDia)
			BEGIN
				SET @iResposta = 394
				GOTO FIM
			END

			-- QUANTDADE DIARIA
			IF (@iQtdSaqueDiaEfetuado > @iQtdSaqueDiaPermitido)
			BEGIN
				SET @iResposta = 393
				GOTO FIM
			END

			-- SALDO INDISPONIVEL NO CARTAO PARA TARIFA
			IF (@dValorTarifa > @dCreditoDisponivelCartao OR @dValorTarifa > @dCreditoDisponivelConta)
			BEGIN
				SET @iResposta = 392
				GOTO FIM
			END

			-- SALDO INDISPONIVEL NO CARTAO PARA VALOR SOLICITADO
			IF (@dValorSaque > @dCreditoDisponivelCartao OR @dValorSaque > @dCreditoDisponivelConta)
			BEGIN
				SET @iResposta = 392
				GOTO FIM
			END

			-- SALDO INDISPONIVEL NO CARTAO PARA VALOR SOLICITADO + VALOR TARIFA
			IF (@dValorSaque + @dValorTarifa > @dCreditoDisponivelCartao OR @dValorSaque + @dValorTarifa > @dCreditoDisponivelConta)
			BEGIN
				SET @iResposta = 392
				GOTO FIM
			END
			
		END
	END
	ELSE
	BEGIN
		SET @iResposta = 386
		GOTO FIM
	END

	-------------------------------------------------------------------------------------------------------
	-- OPERAÇÕES
	-------------------------------------------------------------------------------------------------------
	IF (@iResposta = 0)
	BEGIN
	
		-- SAQUE
		IF (@cTipoOperacao = 'S')
		BEGIN
	
			SET @cCodAutorizacao = RIGHT(@cAutorizacao,6)
		

			INSERT INTO Processadora.dbo.Transacoes
					(EstCodigo
					,TpoTrnCodigo
					,CrtUsrCodigo
					,TpoPrdCodigo
					,PagamentoMinimo
					,MeiCptCodigo
					,RdeCodigo
					,Valor
					,Data
					,Parcelas
					,DataGMT
					,TaxaJuros
					,Status
					,DataAutorizacao
					,DataSolicitacao
					,Lote
					,Comprovante
					,Comprovante_FormGen
					,Autorizacao
					,NSUOrigem
					,Comissao
					,PrdCodigo
					,TipoMensagem
					,Terminal
					,DataLocal
					,HoraLocal
					,FlagTarifacao
					,VinculoTransacao
					,CodEstab
					,CodCliente
					,CartaoEmv
					,ModoEntrada
					,Provedor
					,ReferenciaTecban)
			VALUES (@iEstCodigo
					,@iTpoTrnCodigo
					,@iCodCartao
					,@iTpoPrdCodigo
					,@nPagamentoMinimo
					,@iMeiCptCodigo
					,@iRedeCaptura
					,@dValorSaque
					,@dDataHoraTransacao
					,@iQtdParcelas
					,@sDataHoraGMT
					,0.0
					,@cStatusTransacao
					,@dDataHoraTransacao
					,@dDataHoraTransacao
					,CONVERT(INT,CONVERT(VARCHAR,GETDATE(),12))
					,@sNSUPolicard
					,@cCodAutorizacao
					,@cAutorizacao
					,@sNSUTecBan
					,0 -- CASE WHEN @iTpoTrnCodigo = 350000 THEN 0 ELSE @nTaxaAdministracao END -- Campo "TaxaAdministracao" obtido na consulta a entidade EstabelecimentosTiposProdutos
					,@iPrdCodigo
					,@sTipoMensagem
					,@sTerminal
					,@sDataTransacao
					,@sHoraTransacao
					,0
					,0
					,@iCodigoEstabelecimento
					,@iEntidade
					,@bCartaoEmv
					,@cModoEntrada
					,'TECBAN'
					,@sReferenciaTecban)

			SELECT @iTrnCodigoSaque = SCOPE_IDENTITY()

			EXEC pr_AtualizarCreditoDisponivel
				 @iCodCartao
				,@iCntUsrCodigo
				,@cTipoCartao
				,@dValorSaque
				,@iQtdParcelas
				,@iTpoPrdCodigo
				,@iTrnVinculada
				,'D'
				,0
				,@iTrnCodigoSaque
				,769
				
			/* Tarifação dinâmica de transações */
			IF (@dValorTarifa <> 0 AND @iTrnVinculada IS NOT NULL)
			BEGIN

				EXEC pr_AtualizarCreditoDisponivel
					@iCodCartao
					,@iCntUsrCodigo
					,@cTipoCartao
					,@dValorTarifa
					,@iQtdParcelas
					,@iTpoPrdCodigo
					,@iTrnVinculada
					,'D'
					,0
					,@iTrnCodigoSaque
					,771 /*Tipo de lancamento de tarifa de saque */ 

			END

			INSERT INTO	TransacoesRegistro
					(TrnCodigo
					,StatusTef
					,NumeroEstabelecimento)
			VALUES (@iTrnCodigoSaque
					,@cStatusTransacao
					,@iCodigoEstabelecimento)

			--INSERINDO O HISTORICO DE SAQUE EFETUADO
			EXEC Processadora.dbo.pr_PROC_InsereHistoricoSaldoExtratoSaqueBco24H 'S', @iCodCartao, @iTpoPrdCodigo, @iCntUsrCodigo

		END
		ELSE IF(@cTipoOperacao = 'C')
		BEGIN
		  
			SET @sInfoPlanos = 
			RIGHT(REPLICATE('0',12) + CONVERT(VARCHAR,REPLACE(@dValorTarifa,'.','')),12)  -- 1º - VALOR TARIFA (12 CARACT)
			+ REPLICATE('0',12)			-- 2º - VALOR IOF (12 CARACT) 
			+ '00'						-- 3º - PORCENTAGEM IOF (2 CARACT)
			+ REPLICATE('0',41)			-- 4º - PLANOS (41 CARACT)
			+ REPLICATE('0',4)			-- 5º - VAZIO (4 CARACT)
			+ REPLICATE('0',20)			-- 6º - NOME TARIFA DE SAQUE (20 CARACT)
			+ RIGHT(REPLICATE('0',3) + CONVERT(VARCHAR,@iResposta),3) -- 7º - RESPOSTA (3 CARACT)


		END
		ELSE IF (@cTipoOperacao = 'A')
		BEGIN
			
			DECLARE	 @iHistoricoSaque	INT
			
			SET @iHistoricoSaque = 0
			
			SELECT	 @iTrnCodigoSaque	= T.TrnCodigo
					,@sNSUPolicard		= T.Comprovante
					,@sNumeroCartao		= CU.Numero
			FROM	Processadora.dbo.Transacoes T WITH(NOLOCK)
			INNER JOIN Processadora.dbo.CartoesUsuarios CU WITH (NOLOCK) ON T.CrtUsrCodigo = CU.CrtUsrCodigo
			WHERE	TrnCodigo = @sNSUPolicard
				AND T.Valor			= @dValorSaque
				AND T.TpoTrnCodigo	= 350000
			
			IF (@cBit039Confirmacao = '00')
			BEGIN

				UPDATE Processadora.dbo.Transacoes SET Status = 'A' WHERE TrnCodigo = @iTrnCodigoSaque AND Status = 'P'
				UPDATE TransacoesRegistro SET StatusTef = 'A' WHERE TrnCodigo = @iTrnCodigoSaque AND StatusTef = 'P'
				
			END
			ELSE
			BEGIN
				
				EXEC pr_AUT_CancelaSaqueBco24Horas
					 @iTrnCodigoSaque
					,@sNumeroCartao
					,@dValorSaque
					,@dDataHoraTransacao
					,@iCodigoEstabelecimento
					,@sTerminal
					,@iResposta		OUTPUT

				IF (@iResposta = 0)
				BEGIN

					UPDATE TransacoesRegistro SET StatusTef = 'E' WHERE TrnCodigo = @iTrnCodigoSaque
					
					SELECT @iHistoricoSaque = MAX(Codigo)
					FROM 
						Processadora.dbo.HistoricoSaldoExtratoBanco24Hrs WITH (NOLOCK)
					WHERE TipoOperacao = 'S' 
						AND CntUsrCodigo = @iCntUsrCodigo 
						AND CrtUsrCodigo = @iCodCartao
						AND DataConsulta > CAST(FLOOR(CAST(GETDATE() AS FLOAT)) AS DATETIME)
					
					IF @iHistoricoSaque > 0
						DELETE FROM Processadora.dbo.HistoricoSaldoExtratoBanco24Hrs WHERE codigo = @iHistoricoSaque

				END
			END
		END
	END

FIM:END



