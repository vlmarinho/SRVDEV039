/*
Data: 11/04/2023
Autor: Adilson Pereira - Up Brasil
Descrição: Criação do objeto
---------------------------------------------------------------------------------
Data: 18/05/2023
Autor: Adilson Pereira - Up Brasil
Descrição: Inclusão da validação de produto ativo no Cliente
Chamado: 2012838
---------------------------------------------------------------------------------
Data: 08/06/2023
Autor: João Henrique dos Santos
Descrição: Inclusão da regra de validação da habilitação por produto
Chamado: 
---------------------------------------------------------------------------------
Data: 08/06/2023
Autor: João Henrique dos Santos
Descrição: Inclusão da regra de validação de limite diário
Chamado: 
---------------------------------------------------------------------------------
Data: 26/10/2023
Autor: Adilson Pereira - Up Brasil
Chamado: 2070946
Descrição: Ajuste para considerar apenas transações de venda
---------------------------------------------------------------------------------
Data: 14/05/2024
Autor: João Henrique dos Santos
Chamado: 2131156
Descrição: Ajuste para considerar a habilitação do Voucher nos dois APP's
---------------------------------------------------------------------------------
*/


CREATE PROCEDURE [dbo].[PR_Aut_ValidateCardHubSale] (
	 @cardNumber VARCHAR(16)
	,@transactionValue DECIMAL(15, 2)
	,@cardHubProductName VARCHAR(64)
	,@iTpoPrdCodigo INT
	,@iResposta INT OUTPUT
	)
AS
DECLARE @cardHubProductId INT = 0
	,@isRangeValues BIT = 0
	,@qty INT = 0
	,@valorTransacaoDiariaCartao decimal(18,2) = 0
	,@valorLimitediario decimal(18,2) = 200.00

BEGIN
	SET @iResposta = 0;

	SELECT @cardHubProductId = chp.Id
		,@isRangeValues = chp.RangeValues
	FROM Processadora.dbo.CardHubProduct AS chp WITH (NOLOCK)
		,Processadora.dbo.CardHubProductType AS chpt WITH (NOLOCK)
		,Processadora.dbo.CardHubBusinessType AS chbt WITH (NOLOCK)
		,Processadora.dbo.CardHubProvider AS chp2 WITH (NOLOCK)
	WHERE chp.Name = @cardHubProductName
		AND chp.Active = 1
		AND chp.CardHubProductTypeId = chpt.Id
		AND chpt.Active = 1
		AND chp.CardHubBusinessTypeId = chbt.Id
		AND chbt.Active = 1
		AND chp.CardHubProviderId = chp2.Id
		AND chp2.Active = 1;

	IF @cardHubProductId = 0
	BEGIN
		SET @iResposta = 422;
		RETURN;
	END

	SELECT @qty = COUNT(1)
	FROM Processadora.dbo.CardHubProductTiposProdutos AS t WITH (NOLOCK)
	WHERE t.CardHubProductId = @cardHubProductId
		AND t.TpoPrdcodigo = @iTpoPrdCodigo;

	IF @qty = 0
	BEGIN
		SET @iResposta = 423;
		RETURN;
	END

	IF @isRangeValues = 1
	BEGIN
		IF NOT EXISTS (
				SELECT TOP 1 1
				FROM (
					SELECT min(t.Value) AS MinValue
						,max(t.Value) AS MaxValue
					FROM Processadora.dbo.CardHubProductValues t
					WHERE t.CardHubProductId = @cardHubProductId
						AND t.Active = 1
					) mainTable
				WHERE @transactionValue BETWEEN mainTable.MinValue
						AND mainTable.MaxValue
				)
		BEGIN
			SET @iResposta = 424;
			RETURN
		END
	END
	ELSE
	BEGIN
		IF NOT EXISTS (
				SELECT TOP 1 1
				FROM Processadora.dbo.CardHubProductValues AS t WITH (NOLOCK)
				WHERE t.Value = @transactionValue
					AND t.CardHubProductId = @cardHubProductId
					AND t.Active = 1
				)
		BEGIN
			SET @iResposta = 424;
			RETURN;
		END
	END

	/*Validação de Produto no Cliente*/
	IF (@iResposta = 0)
	BEGIN
			DECLARE 
				@iDeliveryApp INT = 0,
				@cBaseOrigem CHAR(1) = 0,
				@cPermiteSaque CHAR(1),
				@iCliente INT,
				@iUsuario INT,
				@iCartao INT,
				@iConta INT,
				@iFranquia INT

				SET @iTpoPrdCodigo = 0

				EXEC Processadora.dbo.pr_PROC_RetornarTipoProdutoCartao @cardNumber,@cBaseOrigem OUTPUT,@iTpoPrdCodigo OUTPUT,@cPermiteSaque OUTPUT,@iCliente OUTPUT,@iUsuario OUTPUT,@iCartao OUTPUT,@iConta OUTPUT,@iFranquia OUTPUT


				IF (@cBaseOrigem = 'P')
				BEGIN 
					IF EXISTS (SELECT 1
								FROM   Processadora..ProdutosAgentesEmissores pe WITH (NOLOCK) 
								WHERE pe.EntCodigo = @iCliente
									  and pe.tpoprdcodigo = @iTpoPrdCodigo
									  and (ISNULL(pe.DeliveryApp,0) = 1
									  or ISNULL(pe.DeliverynewApp,0) = 1)
									  ) /*inclusão de regra de validação de produto*/
					SET @iDeliveryApp  = 1
				END

				IF (@cBaseOrigem = 'C')
				BEGIN 
					IF EXISTS (SELECT 1
										FROM   Policard_603078.dbo.Cliente c WITH (NOLOCK)  
										WHERE c.codigo = @iCliente 
										and c.franquia = @iFranquia
										and (ISNULL(DeliveryApp,0) = 1
										or ISNULL(DeliveryNewApp,0) = 1))
					SET @iDeliveryApp = 1
				END
	
		IF (@iDeliveryApp = 0)
		BEGIN
			SET @iResposta =  275
			RETURN;
		END	 
	/*Fim Validação Produto no Cliente*/

	/*Inicio Validação Limite*/
			IF (@cBaseOrigem = 'P')
				BEGIN
					SELECT 
					@valorTransacaoDiariaCartao = sum(t.Valor)
					FROM Processadora.dbo.transacoes AS t WITH (NOLOCK)
					WHERE t.[Data] > cast(GETDATE() AS DATE)
						AND t.CrtUsrCodigo = @iCartao
						AND t.codestab = 7859009
						AND t.STATUS IN ('A','P')
						AND t.TipoMensagem = '0200'
				 END

			IF (@cBaseOrigem = 'C')
				BEGIN
					SELECT 
					@valorTransacaoDiariaCartao = sum(t.valor_operacao)
					FROM Policard_603078.dbo.transacao_eletronica AS t WITH (NOLOCK)
					WHERE t.[Data] > cast(GETDATE() AS DATE)
						AND t.Cartao_usuario = @iCartao
						AND t.franquia_usuario = @iFranquia
						AND t.cliente = @iCliente
						AND t.codigoestabelecimento = 7859009
						AND t.Estorno IS NULL 
						AND t.Tipo_Mensagem = '0200'
				END

		IF ((@valorTransacaoDiariaCartao + @transactionValue > @valorLimitediario) OR (@transactionValue > @valorLimitediario))
			BEGIN
				SET @iResposta =  426
				RETURN;
			END
		END
	/*Fim Validação Limite*/
END