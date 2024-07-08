/*
Data: 11/04/2023
Autor: Adilson Pereira - Up Brasil
Descrição: Criação do objeto
 */

Create PROCEDURE [dbo].[PR_Aut_ValidateCardHubSale_teste] (
	@cardNumber VARCHAR(16)
	,@transactionValue DECIMAL(15, 2)
	,@cardHubProductName VARCHAR(64)
	,@iTpoPrdCodigo INT
	,@iResposta INT OUTPUT
	)
AS
DECLARE @cardHubProductId INT = 0
	,@isRangeValues BIT = 0
	,@qty INT = 0;

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
	IF @iResposta = 0
	BEGIN
			Declare @iDeliveryApp int,
				@cBaseOrigem char(1) = 0,
				@cPermiteSaque char(1),
				@iCliente int,
				@iUsuario int,
				@iCartao int,
				@iConta int,
				@iFranquia int

				set @iTpoPrdCodigo = 0

				EXEC Processadora.dbo.pr_PROC_RetornarTipoProdutoCartao @cardNumber,@cBaseOrigem OUTPUT,@iTpoPrdCodigo OUTPUT,@cPermiteSaque OUTPUT,@iCliente OUTPUT,@iUsuario OUTPUT,@iCartao OUTPUT,@iConta OUTPUT,@iFranquia OUTPUT


				IF @cBaseOrigem = 'P'
				BEGIN 
					SET @iDeliveryApp = (select top 1 isnull(pe.DeliveryApp,0)
										from   Processadora..ProdutosAgentesEmissores pe with (nolock) 
										where pe.EntCodigo = @iCliente)
				END
				IF @cBaseOrigem = 'C'
				BEGIN 
					SET @iDeliveryApp = (select top 1 isnull(DeliveryApp,0) 
										from   Policard_603078.dbo.Cliente c with (nolock)  
										where c.codigo = @iCliente and c.franquia = @iFranquia)
				END

				
	  END
	  IF @iDeliveryApp = 0
		BEGIN
			SET @iResposta =  275
			RETURN;
		END
	 
END