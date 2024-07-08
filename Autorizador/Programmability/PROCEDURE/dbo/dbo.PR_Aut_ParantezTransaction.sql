/***************************************************************************************************
 * Objeto: [dbo].[PR_Aut_ParantezTransaction]
 * Propósito: Centraliza envio de transações cashback para Parantez.
 * 	Parâmetros:
 * 		@merchantCode Código do Estabelecimento (Número)
 * 		@transactionId Id da transação
 * 		@sourceDatabase Base de origem (C - convênio; P - processadora)
 * 		@cardNumber Número do cartão
 * 		@isReverse Indica se se trata de um estorno
 ***************************************************************************************************
 */
/*=========== CHANGELOG ===========
 Data: 14/03/2023
 Autor: Adilson Pereira - Up Brasil
 Chamado: 1986162
 Descrição: Criação do objeto
----------------------------------------------------------------------------------------------------
*/
CREATE PROCEDURE dbo.PR_Aut_ParantezTransaction (
	@merchantCode INT
	,@transactionId INT
	,@sourceDatabase CHAR(1)
	,@cardNumber VARCHAR(16)
	,@isReverse BIT
	,@returnCode INT OUTPUT
	,@returnMessage VARCHAR(4000) OUTPUT
	)
AS
DECLARE @isValidMerchant BIT = 0
	,@userCampaignAcceptance BIT = 0
	,@userDocument VARCHAR(16)
	,@originSystem INT
	,@uuid VARCHAR(64)
	,@value DECIMAL(15, 2)
	,@transactionDate DATETIME
	,@productTypeId INT

BEGIN
	SET @returnCode = 0;
	SET @returnMessage = 'OK';
	SET @originSystem = CASE @sourceDatabase
			WHEN 'P'
				THEN 0
			WHEN 'C'
				THEN 1
			END;

	BEGIN TRY
		IF @sourceDatabase = 'P'
		BEGIN
			SELECT @uuid = T.UUID
				,@value = t.Valor
				,@transactionDate = t.DataAutorizacao
			FROM Processadora.dbo.transacoes AS t WITH (NOLOCK)
			WHERE t.TrnCodigo = convert(BIGINT, @transactionId);
		END
		ELSE
		BEGIN
			SET @ReturnCode = 1;
			SET @ReturnMessage = CONCAT (
					'Transaction '
					,@cardNumber
					,' not not found'
					);

			RETURN;
		END

		IF @isReverse = 0
		BEGIN
			SET @isValidMerchant = ISNULL((
						SELECT e.CampanhaParantez
						FROM Processadora.dbo.Estabelecimentos AS e WITH (NOLOCK)
						WHERE e.Numero = convert(BIGINT, @merchantCode)
						), 0);

			IF @isValidMerchant = 0
			BEGIN
				SET @ReturnCode = 1;
				SET @ReturnMessage = CONCAT (
						'Merchant '
						,@merchantCode
						,' not registered for the campaign'
						);

				RETURN;
			END

			IF @sourceDatabase = 'P'
			BEGIN
				SELECT @userCampaignAcceptance = p.AceiteCampanhas
					,@userDocument = pp.CPF
					,@productTypeId = cu.TpoPrdCodigo
				FROM Processadora.dbo.CartoesUsuarios AS cu WITH (NOLOCK)
					,Processadora.dbo.ContasUsuarios AS cu2 WITH (NOLOCK)
					,Processadora.dbo.Propostas AS p WITH (NOLOCK)
					,Processadora.dbo.PropostasPF AS pp WITH (NOLOCK)
				WHERE cu.Numero = @cardNumber
					AND cu.CntUsrCodigo = cu2.CntUsrCodigo
					AND cu2.PrpCodigo = p.PrpCodigo
					AND p.PrpCodigo = pp.PrpPFCodigo;
			END

			SET @userCampaignAcceptance = ISNULL(@userCampaignAcceptance, 0);

			IF @userCampaignAcceptance = 0
			BEGIN
				SET @ReturnCode = 1;
				SET @ReturnMessage = CONCAT (
						'User '
						,@cardNumber
						,' not registered for the campaign'
						);

				RETURN;
			END

			INSERT INTO ExternalApi.dbo.ParantezTransaction (
				TransactionId
				,MerchantId
				,UserId
				,Amount
				,TransactionDate
				,OriginSystem
				,CreatedAt
				,IsReversed
				,ProductId
				,CardNumber
				)
			VALUES (
				@uuid
				,@merchantCode
				,@userDocument
				,@value
				,@transactionDate
				,@originSystem
				,GETDATE()
				,0
				,@productTypeId
				,@cardNumber
				);

		END
		ELSE
		BEGIN
			UPDATE ExternalApi.dbo.ParantezTransaction
			SET IsReversed = 1
				,UpdatedAt = GETDATE()
			WHERE TransactionId = @uuid
				AND OriginSystem = @originSystem;
		END

	END TRY

	BEGIN CATCH
		SET @ReturnCode = 99;
		SET @ReturnMessage = N'Erro geral ao executar procedure: (ERROR_PROCEDURE: ' + ERROR_PROCEDURE() + '; ERROR_NUMBER=' + CONVERT(VARCHAR(4000), ERROR_NUMBER()) + '; ERROR_SEVERITY=' + CONVERT(VARCHAR(4000), ERROR_SEVERITY()) + '; ERROR_STATE=' + CONVERT(VARCHAR(4000), ERROR_STATE()) + '; ERROR_LINE=' + CONVERT(VARCHAR(4000), ERROR_LINE()) + '; ERROR_MESSAGE=' + ERROR_MESSAGE() + ')';
	END CATCH;
END;