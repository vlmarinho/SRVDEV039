
/*
--------------------------------------------------------------------------
Nome Sistema: Autorização
Objeto: [dbo].pr_aut_Confirmar_Transacao_Venda
Propósito: Procedure responsável por confirmar transacoes de TEF e POS
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


CREATE PROCEDURE [dbo].[pr_aut_Confirmar_Transacao_Venda](
	 @iCodigoEstabelecimento	CHAR(11)
	,@cNSUPolicard				CHAR(9)
	,@cNumeroCartao				VARCHAR(16)
	,@cBaseOrigem				CHAR(1)
	,@bPermiteSMS				BIT
	,@bEstabMigrado				BIT
	)
AS
BEGIN

	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	DECLARE @iFlagIdentificacao					INT
			,@iUsuario							INT
			,@iCodCartaoUsuario					INT
			,@iFranquiaUsuario					INT
			,@iCliente							INT
			,@iCodTrnReferencia					INT
			,@cTipoMensagem						VARCHAR(4)
			,@dValor							DECIMAL(18,2)
			,@dSaldoDisponivel					DECIMAL(18,2)
			,@dSaldoFinanciamento				DECIMAL(18,2)
			,@iAno								INT
			,@iMes								INT
			,@dDataTransacao					DATETIME
			,@bControlaLimite					BIT
			,@bControlaFinanciamento			BIT
			,@cTipoCartao						CHAR(1)
			,@nValor_Mensal						DECIMAL(15,2)
			,@nValor_Financiamento				DECIMAL(15,2)
			,@nLimite_Financiamento				DECIMAL(15,2)
			,@nLimiteDependente					DECIMAL(15,2)
			,@nLimiteFinanciamentoDependente	MONEY
			,@mValor_Taxa_Cliente				MONEY
			,@iQtdParcelas						INT
			,@cNomeEstabelecimento				VARCHAR(50)
			,@codigoEstabelecimento				INT
			,@iCodigoTransacao					INT
			,@returnCode 						INT
			,@returnMessage 					VARCHAR(4000)

	SET @iFlagIdentificacao = 0

	IF (@cBaseOrigem = 'P')
	BEGIN

		UPDATE	Processadora.dbo.Transacoes
		SET		Status = 'A'
		WHERE	TrnCodigo  = @cNSUPolicard
				AND Status = 'P'

		UPDATE dbo.TransacoesRegistro
		SET	 StatusTef = 'A'
		WHERE TrnCodigo = @cNSUPolicard
		AND StatusTef = 'P';
	
		SELECT @codigoEstabelecimento = CONVERT(INT, @iCodigoEstabelecimento)
			,@iCodigoTransacao = CONVERT(INT, @cNSUPolicard);
		EXEC Autorizador.dbo.PR_Aut_ParantezTransaction @codigoEstabelecimento, @iCodigoTransacao, @cBaseOrigem, @cNumeroCartao, 0, @returnCode output, @returnMessage output;

	END
	ELSE IF (@cBaseOrigem = 'C')
	BEGIN
		/* Venda a vista */
		DECLARE @cTabela CHAR(1)

		SELECT	@cTabela			 = Tabela
				,@cNumeroCartao		 = NumeroCartao
				,@iCodTrnReferencia	 = Codigo_Referencia
				,@cTipoMensagem		 = Tipo_Mensagem
				,@dDataTransacao	 = DataAutorizacao
				,@iFlagIdentificacao = 1
		FROM	  Policard_603078.dbo.Transacao_RegistroTEF WITH(NOLOCK)
		WHERE	NsuHost = @cNSUPolicard
				AND StatusTef = 'P'

		IF @iCodTrnReferencia > 0
		BEGIN

			IF (@cTabela = 'F')
			BEGIN
				UPDATE	F
				SET		F.Status = 'A'
				FROM	  [Policard_603078].[dbo].Financiamento F
				WHERE	Codigo = @iCodTrnReferencia
			END
			
			UPDATE	  [Policard_603078].[dbo].Transacao_RegistroTEF
			SET		StatusTef = 'A'
			WHERE	NsuHost = @cNSUPolicard
			AND StatusTef = 'P'
		
		END
	END

	IF (@bPermiteSMS = 1)
	BEGIN

		IF @bEstabMigrado = 1
			SELECT @cNomeEstabelecimento = Nome FROM Acquirer.dbo.Estabelecimento WITH(NOLOCK) WHERE CodigoEstabelecimento = @iCodigoEstabelecimento
		ELSE 
			SELECT @cNomeEstabelecimento = Nome FROM Processadora.dbo.Estabelecimentos WITH(NOLOCK) WHERE Numero = @iCodigoEstabelecimento
					
		IF (@cBaseOrigem = 'P')
		BEGIN 

			SELECT	@iCodCartaoUsuario	= C.CrtUsrCodigo
					,@iFranquiaUsuario	= PAE.AgcCodigo
					,@cNumeroCartao		= C.Numero
					,@dValor			= T.Valor
					,@dSaldoDisponivel	= C.CreditoDisponivel
					,@dDataTransacao	= T.DataAutorizacao
					,@cTipoMensagem		= TipoMensagem
			FROM Processadora.dbo.Transacoes T WITH(NOLOCK)
			INNER JOIN Processadora.dbo.CartoesUsuarios C WITH(NOLOCK) ON (C.CrtUsrCodigo = T.CrtUsrCodigo)
			INNER JOIN Processadora.dbo.ContasUsuarios CO WITH(NOLOCK) ON (CO.CntUsrCodigo = C.CntUsrCodigo)
			INNER JOIN Processadora.dbo.Propostas P WITH(NOLOCK) ON (P.PrpCodigo = CO.PrpCodigo)
			INNER JOIN Processadora.dbo.ProdutosAgentesEmissores PAE WITH(NOLOCK) ON (PAE.EntCodigo = P.EntCodigo)
			WHERE	T.TrnCodigo	= @cNSUPolicard
			AND T.Status = 'P'

		END
		ELSE
		BEGIN

			SELECT	@iCodCartaoUsuario					= C.Codigo
					,@iFranquiaUsuario					= C.Franquia
					,@iCliente							= C.Cliente
					,@bControlaLimite					= C.ControlaLimiteDependente
					,@bControlaFinanciamento			= C.ControlaLimiteFinanciamento
					,@nLimiteDependente					= COALESCE(C.ValorLimiteDependente, 0)
					,@nLimiteFinanciamentoDependente	= COALESCE(C.ValorLimiteFinanciamento, 0)
					,@cTipoCartao						= C.Tipo_Cartao
			FROM	  Policard_603078.dbo.Cartao_usuario C WITH(NOLOCK)
					INNER JOIN   Policard_603078.dbo.Franquia F WITH(NOLOCK) ON (F.Codigo = C.Franquia)
			WHERE	C.CodigoCartao = @cNumeroCartao
					AND C.StsTransferenciaUsuario IS NULL

			IF (@cTabela = 'T')
			BEGIN
				SELECT	@iUsuario			= Usuario
						,@iCodCartaoUsuario	= Cartao_Usuario
						,@iFranquiaUsuario	= Franquia_Usuario
						,@dValor			= Valor_Operacao
						,@iAno				= Ano
						,@iMes				= Mes
						,@iQtdParcelas		= 1
				FROM	  Policard_603078.dbo.Transacao_Eletronica WITH(NOLOCK)
				WHERE	Codigo = @iCodTrnReferencia

			END
			ELSE
			BEGIN
				SELECT	@iUsuario			= Usuario
						,@iCodCartaoUsuario	= Cartao_Usuario
						,@iFranquiaUsuario	= Franquia_Usuario
						,@dValor			= Valor_Base
						,@iAno				= Ano
						,@iMes				= Mes
						,@iQtdParcelas		= Qtde_parcelas
				FROM	  Policard_603078.dbo.Financiamento WITH(NOLOCK)
				WHERE	Codigo = @iCodTrnReferencia
			END

			SELECT	@dSaldoDisponivel		= ISNULL(Limite_Mensal,0) + (ISNULL(Saldo_Lancamentos,0) + ISNULL(Saldo_Vendas,0) + ISNULL(Saldo_Manutencao,0) + ISNULL(Saldo_Anterior,0))
					,@nLimite_Financiamento = ISNULL(Limite_financiamento,0)
			FROM	  [Policard_603078].[dbo].Conta_Usuario WITH(NOLOCK) WHERE Usuario = @iUsuario AND Franquia = @iFranquiaUsuario AND Ano = @iAno AND Mes = @iMes

			SELECT	@mValor_Taxa_Cliente = TC.Valor_Lancar
			FROM	  Policard_603078.dbo.Taxacao_Cliente TC WITH(NOLOCK)
			WHERE	TC.Franquia		= @iFranquiaUsuario
					AND TC.Cliente	= @iCliente
					AND TC.Status	= 'A'
					AND @dValor BETWEEN TC.Valor_Inicio AND TC.Valor_Fim -- Verifica se o parâmetro de entrada Valor_Transacao está entre o valor de taxação permitido.

			SET	@mValor_Taxa_Cliente = COALESCE(@mValor_Taxa_Cliente, 0)

			IF (@cTabela = 'T')
			BEGIN
				IF (@cTipoCartao = 'D' AND @bControlaLimite = 1)
				BEGIN
					EXEC   Policard_603078.dbo.sp_Gastos_Cartao
						@iCodCartaoUsuario
						,@iFranquiaUsuario
						,@iAno
						,@iMes
						,@nValor_Mensal			OUTPUT
						,@nValor_Financiamento	OUTPUT

					SET @dSaldoDisponivel = @nLimiteDependente - (@nValor_Mensal + ISNULL(@mValor_Taxa_Cliente, 0))
				END
				ELSE
					SET @dSaldoDisponivel = @dSaldoDisponivel - (ISNULL(@mValor_Taxa_Cliente, 0))
			END
			ELSE
			BEGIN
				IF (@cTipoCartao = 'D' AND @bControlaFinanciamento = 1)
				BEGIN
					EXEC   Policard_603078.dbo.sp_Gastos_Cartao
						@iCodCartaoUsuario
						,@iFranquiaUsuario
						,@iAno
						,@iMes
						,@nValor_Mensal			OUTPUT
						,@nValor_Financiamento	OUTPUT

					SET @dSaldoDisponivel = @nLimiteFinanciamentoDependente - @nValor_Financiamento
				END
			END

		END

		EXEC Autorizacao.dbo.pr_AUT_CargaInformacoesEnvioSMS
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
	

	--/* INÍCIO: Carga dados SMS */
	--IF EXISTS (SELECT 1 FROM UsuarioPermiteSMS WITH(NOLOCK) WHERE CodCartao = @iCodCartaoUsuario AND Franquia = @iFranquiaUsuario AND Base = @cBaseOrigem)
	--BEGIN
	--	SELECT @cNomeEstabelecimento = Nome FROM Processadora..Estabelecimentos WITH(NOLOCK) WHERE Numero = @iCodigoEstabelecimento

	--	EXEC pr_AUT_CargaInformacoesEnvioSMS
	--		@iCodCartaoUsuario
	--		,@iFranquiaUsuario
	--		,@cBaseOrigem
	--		,@cNumeroCartao
	--		,@dValor
	--		,@dSaldoDisponivel
	--		,@dDataTransacao
	--		,@cTipoMensagem
	--		,@iQtdParcelas
	--		,@cNomeEstabelecimento
	--END
	--/* FIM: Carga dados SMS */
END



