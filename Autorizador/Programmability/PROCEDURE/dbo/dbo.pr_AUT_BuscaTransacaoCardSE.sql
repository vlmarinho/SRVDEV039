
CREATE PROCEDURE [dbo].[pr_AUT_BuscaTransacaoCardSE](
	 @cBit041					CHAR(8)
	,@cBit127					VARCHAR(9)		OUTPUT
	,@iCodigoEstabelecimento	INT
	,@cNumeroCartao				VARCHAR(16)		OUTPUT
	,@cNomeUsuario				VARCHAR(30)		OUTPUT
	,@nValor_Transacao			DECIMAL(15,2)
	,@cOrigem					CHAR(1)			OUTPUT
	,@cStatusTrn				CHAR(1)			OUTPUT
	,@iResposta					INT				OUTPUT
	,@cBit011					VARCHAR(6)
	,@iQuantParcelas			INT				OUTPUT
	,@iCodResposta				INT				OUTPUT
	)
AS
/*
--------------------------------------------------------------------------
Nome Sistema: Autorização
Objeto: [pr_aut_BuscaTransacaoCardSE]
Propósito: Procedure responsável por buscar transacoes QrCode da CardSE
Autor: Cristiano Babosa - Cristiano S. Barbosa Info
--------------------------------------------------------------------------
Data Criação: 26/05/2021
Mudança: 
--------------------------------------------------------------------------

*/

BEGIN

	SET NOCOUNT ON;
	
	DECLARE @bFlagIdent	BIT
		
	SET @iResposta	= 0
	SET @bFlagIdent	= 0
	
	IF (@bFlagIdent = 0)
	BEGIN

		SELECT	 @cNumeroCartao		= CUS.Numero
				,@bFlagIdent		= 1
				,@cOrigem			= 'P' -- Transacao Processadora
				,@cBit127			= TRN.TrnCodigo
				,@cStatusTrn		= TRN.Status
				,@iQuantParcelas    = TRN.Parcelas
				,@cNomeUsuario		= CUS.Nome
		FROM	Processadora.dbo.Transacoes TRN WITH(NOLOCK)
		INNER JOIN Processadora.dbo.CartoesUsuarios CUS WITH(Nolock) ON (CUS.CrtUsrCodigo = TRN.CrtUsrCodigo)
		WHERE TRN.NSUOrigem = CONVERT(INT,@cBit011)
		AND TRN.Terminal = @cBit041
		AND TRN.CodEstab = @iCodigoEstabelecimento
		AND TRN.Valor = @nValor_Transacao
		AND CONVERT (VARCHAR(10),TRN.DataAutorizacao, 120) = CONVERT (VARCHAR(10),GETDATE(),120) /*Somente transacoes do dia corrente*/


	END
	

	IF (@bFlagIdent = 0)
	BEGIN


		SELECT	 
			 @cNumeroCartao		= TRT.NumeroCartao
			,@bFlagIdent		= 1
			,@cOrigem			= 'C' -- Transacao Convenio
			,@cStatusTrn		= TRT.StatusTef
			,@cBit127			= TRT.NsuHost
			,@cNomeUsuario		= CU.Nome_usuario
		FROM [Policard_603078].[dbo].[Transacao_RegistroTEF] TRT WITH(Nolock)
		INNER JOIN [Policard_603078].[dbo].[Cartao_Usuario] CU WITH(Nolock) ON TRT.NumeroCartao = CU.CodigoCartao
		WHERE (TRT.NsuLoja = CONVERT(INT,@cBit011))--OR NsuLoja = @cNsuTransacaoOriginal)
		AND TRT.Terminal = @cBit041
		AND TRT.Estabelecimento	= @iCodigoEstabelecimento
		AND TRT.Valor = @nValor_Transacao
		AND CONVERT (VARCHAR(10),TRT.DataAutorizacao, 120) = CONVERT (VARCHAR(10),GETDATE(),120) /* Somente transacoes do dia corrente */

		

	END

	IF (@bFlagIdent = 0)
	BEGIN

		SELECT	 @cNumeroCartao		= CUS.Numero
				,@bFlagIdent		= 1
				,@cOrigem			= TRN.BaseOrigem -- Transacao Processadora
				,@cBit127			= TRN.Codigo
				,@cStatusTrn		= 'N'
				,@iCodResposta		= TRN.CodResposta
				,@cNomeUsuario		= CUS.Nome
		FROM	Processadora.dbo.TransacoesNegadas TRN WITH(NOLOCK)
		INNER JOIN Processadora.dbo.CartoesUsuarios CUS WITH(Nolock) ON (CUS.CrtUsrCodigo = TRN.CodCartao)
		WHERE TRN.NSUOrigem = CONVERT(INT,@cBit011)
		AND TRN.Terminal = @cBit041
		AND TRN.CodEstabelecimento = @iCodigoEstabelecimento
		AND TRN.Valor = @nValor_Transacao
		AND CONVERT (VARCHAR(10),TRN.Data, 120) = CONVERT (VARCHAR(10),GETDATE(),120) /*Somente transacoes do dia corrente*/

	END

	 
		
		
	/*Transacao nao encontrada*/
	IF (@bFlagIdent = 0)
		SET @iResposta = 271


END
