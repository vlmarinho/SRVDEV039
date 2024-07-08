
/*
--------------------------------------------------------------------------
Nome Sistema: Autorização
Objeto: [dbo].[pr_aut_Confirmar_Transacao_Estorno]
Propósito: Procedure responsável por confirmar estorno
Autor: Cristiano Silva Barbosa - Tecnologia Policard
--------------------------------------------------------------------------
Data: 19/02/2017
Mud/CH.:  2601
--------------------------------------------------------------------------
Data: 14/03/2023
Autor: Adilson Pereira - Up Brasil
Chamado: 1986162
Descrição: Projeto cashback - Integração plataforma Parantez.
-------------------------------------------------------------------------- 
*/

CREATE PROCEDURE [dbo].[pr_aut_Confirmar_Transacao_Estorno](
	 @iCodigoEstabelecimento	CHAR(11)
	,@cNSUPolicard				CHAR(9)
	,@cNumeroCartao				VARCHAR(16)
	,@cBaseOrigem				CHAR(1)
	,@bPermiteSMS				BIT
	)

AS
BEGIN
	
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	DECLARE @iFlagIdentificacao					INT
			,@iTrnCodigo						INT
			,@iUsuario							INT
			,@iCodCartaoUsuario					INT
			,@iFranquiaUsuario					INT
			,@iQtdParcelas						INT
			,@iCodTrnReferencia					INT
			,@cTipoMensagem						VARCHAR(4)
			,@dValor							DECIMAL(18,2)
			,@dSaldoDisponivel					DECIMAL(18,2)
			,@iAno								INT
			,@iMes								INT
			,@dDataTransacao					DATETIME
			,@bControlaLimite					BIT
			,@bControlaFinanciamento			BIT
			,@cTipoCartao						CHAR(1)
			,@nValor_Mensal						DECIMAL(15,2)
			,@nValor_Financiamento				DECIMAL(15,2)
			,@nLimiteDependente					DECIMAL(15,2)
			,@nLimiteFinanciamentoDependente	MONEY
			,@cNomeEstabelecimento				VARCHAR(50)
			,@codigoEstabelecimento				INT
			,@iCodigoTransacao					INT
			,@returnCode 						INT
			,@returnMessage 					VARCHAR(4000)			

	SET @iFlagIdentificacao = 0
	SET @iQtdParcelas		= 1
	
	
	IF @cBaseOrigem = 'C'
	BEGIN

		DECLARE @cTabela CHAR(1)
		
		SELECT	
			 @cTabela						 = T.Tabela
			,@iCodTrnReferencia				 = T.Codigo_Referencia
			,@cTipoMensagem					 = T.Tipo_Mensagem
			,@dDataTransacao				 = CONVERT(VARCHAR(23),T.DataAutorizacao,121)
			,@iUsuario						 = TE.Usuario
			,@iCodCartaoUsuario				 = TE.Cartao_Usuario
			,@iFranquiaUsuario				 = TE.Franquia_Usuario
			,@dValor						 = TE.Valor_Operacao
			,@iAno							 = TE.Ano
			,@iMes							 = TE.Mes
			,@bControlaLimite				 = C.ControlaLimiteDependente
			,@bControlaFinanciamento		 = C.ControlaLimiteFinanciamento
			,@nLimiteDependente				 = COALESCE(C.ValorLimiteDependente, 0)
			,@nLimiteFinanciamentoDependente = COALESCE(C.ValorLimiteFinanciamento, 0)
			,@cTipoCartao					 = C.Tipo_Cartao
			,@iFlagIdentificacao			 = 1
		FROM	  [Policard_603078].[dbo].Transacao_RegistroTEF T WITH(NOLOCK)
		INNER JOIN   [Policard_603078].[dbo].Transacao_Eletronica TE WITH(NOLOCK) ON (T.Codigo_Referencia = TE.Codigo)
		INNER JOIN   [Policard_603078].[dbo].Cartao_Usuario C WITH(NOLOCK) ON (C.Codigo = TE.Cartao_usuario AND C.Franquia = TE.Franquia_usuario)
		WHERE T.NsuHost = @cNSUPolicard 
		AND T.StatusTef = 'P'
	
		IF (@iFlagIdentificacao = 1)
		BEGIN
			IF (@cTipoCartao = 'D' AND @bControlaLimite = 1)
			BEGIN
				EXEC   [Policard_603078].[dbo].sp_Gastos_Cartao
					@iCodCartaoUsuario
					,@iFranquiaUsuario
					,@iAno
					,@iMes
					,@nValor_Mensal			OUTPUT
					,@nValor_Financiamento	OUTPUT

				SET @dSaldoDisponivel = @nLimiteDependente - ((@nValor_Mensal + @dValor + 0 /* TAXACAO CLIENTE */) + 0 /* VALOR TROCO */)
				SET @dSaldoDisponivel = @dSaldoDisponivel + ((@dValor + 0 /* TAXACAO CLIENTE */) + 0 /* VALOR TROCO */)
			END
			ELSE
			BEGIN
				SELECT	@dSaldoDisponivel = ISNULL(Limite_Mensal,0) + (ISNULL(Saldo_Lancamentos,0) + ISNULL(Saldo_Anterior,0) + ISNULL(Saldo_Vendas,0) + ISNULL(Saldo_Manutencao,0))
				FROM	  [Policard_603078].[dbo].Conta_Usuario WITH(NOLOCK)
				WHERE	Usuario = @iUsuario
						AND Franquia = @iFranquiaUsuario
						AND Ano = @iAno
						AND Mes = @iMes
			END
		END

		IF (@iFlagIdentificacao = 0)
		BEGIN
			SELECT	@iUsuario						 = F.Usuario
					,@iCodCartaoUsuario				 = F.Cartao_Usuario
					,@iFranquiaUsuario				 = F.Franquia_Usuario
					,@cTipoMensagem					 = T.Tipo_Mensagem
					,@dDataTransacao				 = CONVERT(VARCHAR(23),T.DataAutorizacao,121)
					,@dValor						 = F.Valor_Base
					,@iQtdParcelas					 = F.Qtde_parcelas
					,@iAno							 = F.Ano
					,@iMes							 = F.Mes
					,@bControlaLimite				 = C.ControlaLimiteDependente
					,@bControlaFinanciamento		 = C.ControlaLimiteFinanciamento
					,@nLimiteDependente				 = COALESCE(C.ValorLimiteDependente, 0)
					,@nLimiteFinanciamentoDependente = COALESCE(C.ValorLimiteFinanciamento, 0)
					,@cTipoCartao					 = C.Tipo_Cartao
			FROM	  [Policard_603078].[dbo].Transacao_RegistroTEF T WITH(NOLOCK)
					JOIN   [Policard_603078].[dbo].Financiamento F WITH(NOLOCK) ON (T.Codigo_Referencia = F.Codigo)
					JOIN   [Policard_603078].[dbo].Cartao_Usuario C WITH(NOLOCK) ON (C.Codigo = F.Cartao_Usuario AND C.Franquia = F.Franquia_usuario)
			WHERE	T.NsuHost = @cNSUPolicard
					AND T.StatusTef = 'P'

			IF (@cTipoCartao = 'D' AND @bControlaFinanciamento = 1)
			BEGIN
				EXEC   [Policard_603078].[dbo].sp_Gastos_Cartao
					@iCodCartaoUsuario
					,@iFranquiaUsuario
					,@iAno
					,@iMes
					,@nValor_Mensal			OUTPUT
					,@nValor_Financiamento	OUTPUT

				SET @dSaldoDisponivel = @nLimiteFinanciamentoDependente - @nValor_Financiamento
			END
			ELSE
			BEGIN
				
				SELECT	@dSaldoDisponivel = ISNULL(Limite_Mensal,0) + (ISNULL(Saldo_Lancamentos,0) + ISNULL(Saldo_Anterior,0) + ISNULL(Saldo_Vendas,0) + ISNULL(Saldo_Manutencao,0))
				FROM	  [Policard_603078].[dbo].Conta_Usuario WITH(NOLOCK)
				WHERE	Usuario = @iUsuario
						AND Franquia = @iFranquiaUsuario
						AND Ano = @iAno
						AND Mes = @iMes
			END
		END

		IF (@iFlagIdentificacao = 1)
		BEGIN
			UPDATE	  [Policard_603078].[dbo].Transacao_RegistroTEF
			SET		StatusTef = 'A'
			WHERE	NsuHost = @cNSUPolicard
					AND StatusTef = 'P'
		END

		IF (@iFlagIdentificacao = 0)
		BEGIN /* Venda parcelada */
			UPDATE	T
			SET		T.StatusTef = 'A'
			FROM	  [Policard_603078].[dbo].Transacao_RegistroTEF T WITH(NOLOCK)
					INNER JOIN   [Policard_603078].[dbo].Financiamento F WITH(NOLOCK) ON (F.Codigo = T.Codigo_Referencia)
			WHERE	T.NsuHost = @cNSUPolicard
					AND T.StatusTef = 'P'

			UPDATE	F
			SET		F.Status = 'A'
			FROM	  [Policard_603078].[dbo].Financiamento F WITH(NOLOCK)
					INNER JOIN   [Policard_603078].[dbo].Transacao_RegistroTEF T WITH(NOLOCK) ON (T.Codigo_Referencia = F.Codigo)
			WHERE	T.NsuHost = @cNSUPolicard
					AND F.Status = 'P'
		END
	END


	IF (@iFlagIdentificacao = 0 AND @cBaseOrigem = 'P')
	BEGIN

		SELECT	@iCodCartaoUsuario	= C.CrtUsrCodigo
			,@iFranquiaUsuario	= PAE.AgcCodigo
			,@cNumeroCartao		= C.Numero
			,@dValor			= T.Valor
			,@dSaldoDisponivel	= C.CreditoDisponivel
			,@dDataTransacao	= CONVERT(VARCHAR(23),T.DataAutorizacao,121)
			,@cTipoMensagem		= T.TipoMensagem
		FROM Processadora.dbo.Transacoes T WITH(NOLOCK)
		INNER JOIN Processadora.dbo.CartoesUsuarios C WITH(NOLOCK) ON (C.CrtUsrCodigo = T.CrtUsrCodigo)
		INNER JOIN Processadora.dbo.ContasUsuarios CO WITH(NOLOCK) ON (CO.CntUsrCodigo = C.CntUsrCodigo)
		INNER JOIN Processadora.dbo.Propostas P WITH(NOLOCK) ON (P.PrpCodigo = CO.PrpCodigo)
		INNER JOIN Processadora.dbo.ProdutosAgentesEmissores PAE WITH(NOLOCK) ON (PAE.EntCodigo = P.EntCodigo)
		WHERE	T.TrnCodigo	 = @cNSUPolicard
		AND T.Status = 'P'

		UPDATE	Processadora.dbo.Transacoes
		SET		Status = 'A'
		WHERE	TrnCodigo  = @cNSUPolicard
				AND status = 'P'

		UPDATE	TransacoesRegistro
		SET		StatusTef = 'A'
		WHERE	TrnCodigo = @cNSUPolicard
				AND StatusTef = 'P'
				
		
		SELECT @codigoEstabelecimento = CONVERT(INT, @iCodigoEstabelecimento)
			,@iCodigoTransacao = CONVERT(INT, @cNSUPolicard);

		EXEC Autorizador.dbo.PR_Aut_ParantezTransaction @codigoEstabelecimento, @iCodigoTransacao, @cBaseOrigem, @cNumeroCartao, 1, @returnCode output, @returnMessage output;
				
	END

	IF (@dValor < 0)
		SET @dValor = @dValor * -1

	/* INÍCIO: Carga dados SMS */
	IF EXISTS (SELECT 1 FROM Autorizacao.dbo.UsuarioPermiteSMS WITH(NOLOCK) WHERE CodCartao = @iCodCartaoUsuario AND Franquia = @iFranquiaUsuario AND Base = @cBaseOrigem)
	BEGIN

		SELECT @cNomeEstabelecimento = Nome FROM Processadora.dbo.Estabelecimentos WITH(NOLOCK) WHERE Numero = @iCodigoEstabelecimento

		EXEC pr_AUT_CargaInformacoesEnvioSMS
			@iCodCartaoUsuario
			,@iFranquiaUsuario
			,@cBaseOrigem
			,@cNumeroCartao
			,@dValor
			,@dSaldoDisponivel
			,@dDataTransacao
			,@cTipoMensagem
			,@iQtdParcelas
			,@cNomeEstabelecimento
	END
	/* FIM: Carga dados SMS */

END




