/***************************************************************************************************
 * Objeto: [dbo].[PR_Aut_ConfirmarTransacaoJob]
 * Propósito: Procedure confirmação de transações pendentes e envio para Parantez..
 ***************************************************************************************************
 */
/*=========== CHANGELOG ===========
 Data: 14/03/2023
 Autor: Adilson Pereira - Up Brasil
 Chamado: 1986162
 Descrição: Criação do objeto
----------------------------------------------------------------------------------------------------
*/

CREATE PROCEDURE dbo.PR_Aut_ConfirmarTransacaoJob
AS
DECLARE @exceptionMessage VARCHAR(4000);

BEGIN
	BEGIN TRY
		UPDATE Policard_603078.dbo.Transacao_RegistroTEF
		SET StatusTef = 'A'
		WHERE StatusTef = 'P'
			AND DataAutorizacao < cast(GETDATE() AS DATE);

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
		SELECT t.UUID AS transactionId
			,t.CodEstab AS MerchantId
			,pp.CPF AS UserId
			,t.Valor AS Amount
			,t.DataAutorizacao AS TransactionDate
			,0 AS OriginSystem
			,GETDATE() AS CreatedAt
			,0 AS IsReversed
			,cu.TpoPrdCodigo AS ProductId
			,cu.Numero AS CardNumber
		FROM Processadora.dbo.transacoes AS t WITH (NOLOCK)
			,Processadora.dbo.CartoesUsuarios AS cu WITH (NOLOCK)
			,Processadora.dbo.ContasUsuarios AS cu2 WITH (NOLOCK)
			,Processadora.dbo.Propostas AS p WITH (NOLOCK)
			,Processadora.dbo.PropostasPF pp WITH (NOLOCK)
			,Processadora.dbo.Estabelecimentos AS e WITH (NOLOCK)
		WHERE t.STATUS = 'P'
			AND t.CrtUsrCodigo = cu.CrtUsrCodigo
			AND cu.CntUsrCodigo = cu2.CntUsrCodigo
			AND cu2.PrpCodigo = p.PrpCodigo
			AND p.PrpCodigo = pp.PrpPfCodigo
			AND t.EstCodigo = e.EstCodigo
			AND e.CampanhaParantez = 1
			AND p.AceiteCampanhas = 1
			AND t.DataAutorizacao < cast(GETDATE() AS DATE)
			AND t.UUID IS NOT NULL;

		UPDATE Processadora.dbo.transacoes
		SET STATUS = 'A'
		WHERE STATUS = 'P'
			AND DataAutorizacao < cast(GETDATE() AS DATE)
	END TRY

	BEGIN CATCH
		SET @exceptionMessage = N'Erro geral ao executar procedure: (ERROR_PROCEDURE: ' + ERROR_PROCEDURE() + '; ERROR_NUMBER=' + CONVERT(VARCHAR(4000), ERROR_NUMBER()) + '; ERROR_SEVERITY=' + CONVERT(VARCHAR(4000), ERROR_SEVERITY()) + '; ERROR_STATE=' + CONVERT(VARCHAR(4000), ERROR_STATE()) + '; ERROR_LINE=' + CONVERT(VARCHAR(4000), ERROR_LINE()) + '; ERROR_MESSAGE=' + ERROR_MESSAGE() + ')';
		THROW 500001, @exceptionMessage, 1;
	END CATCH;
END;