
--------------------------------------------------------------------------
/*
--------------------------------------------------------------------------
Nome Sistema: Autorização
Objeto: [pr_aut_BuscaDesfazimentoEstorno]
Propósito: Procedure responsável por
Autor: Cristiano Silva Babosa - Tecnologia Policard
--------------------------------------------------------------------------
Data Criação: 19/02/2017
Mudança: 2601
--------------------------------------------------------------------------
Data Alteração: 06/06/2017
Chamado: 389762 / 2926 
Responsavel: Cristiano Barbosa- Policard Systems
--------------------------------------------------------------------------
Data Alteração: 28/09/2017
Chamados: 399954  / 3262
Responsavel: Cristiano Barbosa- Policard Systems
--------------------------------------------------------------------------
Data Alteração: 26/04/2018
Chamados: 494467  / 3947
Responsavel: Cristiano Barbosa- Up Brasil
--------------------------------------------------------------------------
Data: 08/09/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1843805
Descrição: Projeto ABECS para transações NCR/Scope.
-------------------------------------------------------------------------- 	
Data: 2024-01-18
Autor: Adilson Pereira - Up Brasil
Chamado: 2096954 
Descrição: Ajuste na tratativa de transações da rede CardSE (44)
--------------------------------------------------------------------------
*/

CREATE   PROCEDURE [dbo].[pr_aut_BuscaDesfazimentoEstorno](
	 @cBit001					VARCHAR(4)
	,@cBit041					CHAR(8)
	,@cBit090					VARCHAR(100)
	,@cBit105					VARCHAR(100)
	,@cBit127					VARCHAR(9)		OUTPUT
	,@cProvedor					VARCHAR(50)
	,@iRedeNumero				INT
	,@iCodigoEstabelecimento	INT
	,@iEstCodigo				INT
	,@cNumeroCartao				VARCHAR(16)		OUTPUT
	,@iCrtUsrCodigo				INT				OUTPUT
	,@bCartaoEmv				BIT				OUTPUT
	,@iFranquiaUsuario			INT				OUTPUT
	,@iCliente					INT				OUTPUT
	,@nValor_Transacao			DECIMAL(15,2)
	,@cOrigem					CHAR(1)			OUTPUT
	,@bPermiteSMS				BIT				OUTPUT
	,@iCntAppCodigo				INT				OUTPUT
	,@bEnviaPush				BIT				OUTPUT
	,@iResposta					INT				OUTPUT
	)
AS
BEGIN
	
	DECLARE 
		 @cCodigoMensagem			CHAR(4)
		,@cCodigoAutorizacao		CHAR(6)	
		,@cCodigoProcessamento		CHAR(6)
		,@cDataHoraGMT				CHAR(10)
		,@cDataTransacao			CHAR(4)
		,@cHoraTransacao			CHAR(6)
		,@cNsuTransacaoOriginal		CHAR(6) --BIT11
		,@bFlagIdent				BIT
		,@cStatusTrn				CHAR(1)
		,@sCPF						VARCHAR(20)
		
	SET @iResposta	= 0
	SET @bFlagIdent	= 0

	
	IF (@iRedeNumero IN (10,29,31,44,58))
	BEGIN

		IF (@iRedeNumero IN (29,31,44))
		BEGIN 

			SELECT 
				 @cCodigoMensagem		= SUBSTRING(@cBit090,1,4)
				,@cNsuTransacaoOriginal	= SUBSTRING(@cBit090,5,6)
				,@cDataTransacao		= SUBSTRING(@cBit090,11,4)
				,@cHoraTransacao		= SUBSTRING(@cBit090,15,6)
			
		END
		ELSE 
		BEGIN

			SELECT 
				 @cCodigoMensagem		= SUBSTRING(@cBit090,1,4)
				,@cCodigoAutorizacao	= SUBSTRING(@cBit090,5,6)
				,@cDataTransacao		= SUBSTRING(@cBit090,11,4)
				,@cHoraTransacao		= SUBSTRING(@cBit090,15,6)
				,@cNsuTransacaoOriginal = SUBSTRING(@cBit090,21,6)
		END

	END
	ELSE
	BEGIN
	
		IF (@cProvedor = 'SCOPEPRIVATE')
		BEGIN
		
			SELECT
				 @cCodigoMensagem		= SUBSTRING(@cBit090,1,4)
				,@cNsuTransacaoOriginal	= SUBSTRING(@cBit090,5,6)
				,@cDataTransacao		= SUBSTRING(@cBit090,11,4)
				,@cHoraTransacao		= SUBSTRING(@cBit090,15,6)
			
		END
		ELSE IF (@iRedeNumero IN (26,32,33,38,39,40,41,42,43,46,47,48,49,50,51,52,53,54))
		BEGIN
		
			SELECT
				 @cCodigoMensagem		= SUBSTRING(@cBit090,1,4)
				,@cCodigoAutorizacao	= SUBSTRING(@cBit090,5,6)
				,@cNsuTransacaoOriginal	= SUBSTRING(@cBit090,11,6)
				,@cHoraTransacao		= SUBSTRING(@cBit090,17,6)
				,@cDataTransacao		= SUBSTRING(@cBit090,23,4)
				
			
		END
		ELSE
		BEGIN
		
			SELECT 
				 @cCodigoMensagem		= SUBSTRING(@cBit090,1,4)
				,@cCodigoProcessamento	= SUBSTRING(@cBit090,5,6)
				,@cNsuTransacaoOriginal = SUBSTRING(@cBit090,11,6)
				,@cDataHoraGMT			= SUBSTRING(@cBit090,17,10)
				,@cHoraTransacao		= SUBSTRING(@cBit090,27,6)
				,@cDataTransacao		= SUBSTRING(@cBit090,33,4)
		END
		
	END
	
	IF (@bFlagIdent = 0)
	BEGIN

		SELECT	 @cNumeroCartao		= CUS.Numero
				,@cBit127			= TRN.trncodigo
				,@bFlagIdent		= 1
				,@cOrigem			= 'P' -- Transacao Processadora
				,@cStatusTrn		= TRN.Status
				,@iCrtUsrCodigo		= CUS.CrtUsrCodigo
				,@iCliente			= TRN.CodCliente
				,@iFranquiaUsuario	= 0
				,@bCartaoEmv		= CUS.Chip
				,@sCPF				= CUS.CPF
		FROM	Processadora.dbo.Transacoes TRN WITH(NOLOCK)
		INNER JOIN Processadora.dbo.CartoesUsuarios CUS WITH(Nolock) ON (CUS.CrtUsrCodigo = TRN.CrtUsrCodigo)
		WHERE (TRN.TrnCodigo = CONVERT(INT,@cBit127) OR TRN.NSUOrigem = @cNsuTransacaoOriginal)
		AND (TRN.Terminal = @cBit041 OR TRN.Terminal IN ('88888888','80808080'))
		AND TRN.CodEstab = @iCodigoEstabelecimento
		AND TRN.Valor = @nValor_Transacao
		AND CONVERT (VARCHAR(10),TRN.DataAutorizacao, 120) = CONVERT (VARCHAR(10),GETDATE(),120) /*Somente transacoes do dia corrente*/

		IF (@bFlagIdent = 0 AND @cBit105 <> '')
		BEGIN

			SELECT	
				 @cNumeroCartao	= cus.Numero
				,@bFlagIdent	= 1
				,@cOrigem		= 'P' -- Transacao Processadora
				,@cStatusTrn	= FRQ.Status
				,@cBit127		= FRQ.Codigo
				,@iCrtUsrCodigo	= CUS.CrtUsrCodigo
				,@iFranquiaUsuario = 0
				,@bCartaoEmv	= CUS.Chip
				,@sCPF			= CUS.CPF
			FROM Processadora.dbo.Frete_Quitacao FRQ WITH(Nolock)
			INNER JOIN Processadora.dbo.CartoesUsuarios CUS WITH(NOLOCK) ON CUS.CrtUsrCodigo = FRQ.CartaoUsuario
			WHERE (FRQ.CODIGO = CONVERT(INT,@cBit127) OR FRQ.NSUMeioCaptura = CONVERT(VARCHAR, @cNsuTransacaoOriginal))
			AND CONVERT(VARCHAR, frq.Data, 103) = CONVERT(VARCHAR, GETDATE(), 103)

		END
	END
	
	IF (@bFlagIdent = 0)
	BEGIN
	
		SELECT	 
			 @cNumeroCartao		= TRT.NumeroCartao
			,@cBit127			= TRT.NsuHost
			,@bFlagIdent		= 1
			,@cOrigem			= 'C' -- Transacao Convenio
			,@cStatusTrn		= TRT.StatusTef
			,@iCrtUsrCodigo		= CU.Codigo
			,@iFranquiaUsuario	= CU.Franquia
			,@iCliente			= CU.Cliente
			,@bCartaoEmv		= CU.Chip
			,@sCPF				= CU.CU_Cpf
		FROM [Policard_603078].[dbo].[Transacao_RegistroTEF] TRT WITH(Nolock)
		INNER JOIN [Policard_603078].[dbo].[Cartao_Usuario] CU WITH(Nolock) ON TRT.NumeroCartao = CU.CodigoCartao
		WHERE (TRT.NsuHost = CONVERT(INT,@cBit127) OR NsuLoja = @cNsuTransacaoOriginal)
		AND (TRT.Terminal = @cBit041 OR TRT.Terminal IN ('88888888','80808080'))
		AND TRT.Estabelecimento	= @iCodigoEstabelecimento
			--AND TRT.Valor = @nValor_Transacao
		AND CONVERT (VARCHAR(10),TRT.DataAutorizacao, 120) = CONVERT (VARCHAR(10),GETDATE(),120) /* Somente transacoes do dia corrente */

	END
		
	/*Transacao nao encontrada*/
	IF (@bFlagIdent = 0)
		SET @iResposta = 271
	ELSE 
	BEGIN

		IF (@cBit001 IN ('0410','0430') AND @cStatusTrn IN ('D','E'))
			SET @iResposta = 74

		IF (@cOrigem = 'P')
			SELECT @bPermiteSMS = 1 FROM Autorizacao.dbo.UsuarioPermiteSMS WITH(NOLOCK) WHERE CodCartao = @iCrtUsrCodigo AND Base = 'P'
		ELSE
			SELECT @bPermiteSMS = 1 FROM Autorizacao.dbo.UsuarioPermiteSMS WITH(NOLOCK) WHERE CodCartao = @iCrtUsrCodigo AND Franquia = @iFranquiaUsuario AND Base = 'C'

	END

	IF (@iResposta = 0 AND (@sCPF IS NOT NULL OR @sCPF <> ''))
	BEGIN

		SELECT @iCntAppCodigo = uc.usrcntcodigo
			  ,@bEnviaPush = 1
		FROM [Usuarios].[dbo].[UsuariosControles] uc with (NOLOCK)
		INNER JOIN [Usuarios].[dbo].[UsuariosControlesSistemas] us with (NOLOCK) ON uc.UsrCntCodigo = us.UsrCntCodigo
		INNER JOIN [Notificacao].[dbo].UserDevice ud with (NOLOCK) ON ud.UserId = uc.UsrCntCodigo
		INNER JOIN [Notificacao].[dbo].UserProfile  up with (NOLOCK) ON up.UserId = ud.UserId
		WHERE us.SstCodigo = 57
		AND ud.Status = 1
		AND up.AcceptTerms = 1
		AND uc.CPF IN (@sCPF, REPLACE(REPLACE (@sCPF,'.',''),'-',''))

	END


END
