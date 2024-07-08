

/*
--------------------------------------------------------------------------
Nome Sistema: Autorização
Objeto: [dbo].[pr_AUT_ConfirmarTransacoes2Vias]
Propósito: Procedure responsável por confirmar Transações Pendentes 2 Vias
		   (Sem '0202' e '0402')
Autor: Cristiano Silva Barbosa - Policard Systems
--------------------------------------------------------------------------
Data criação: 19/02/2017
Mudança: 2601
--------------------------------------------------------------------------
*/



CREATE PROCEDURE [pr_aut_ConfirmarTransacoes2Vias](
	 @iRdeCodigo				INT
	,@iCodigoEstabelecimento	INT
	,@cTerminal					VARCHAR(8)
	,@cNroCartao				VARCHAR(16)		= NULL
	,@cTipoMensagem				CHAR(4)			= NULL
	,@cNSURefEstorno			VARCHAR(6)		= NULL
	,@dValorTransacao			DECIMAL(18,2)	= NULL
	)
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	DECLARE @iTrnCodigoTransacoes	BIGINT
			,@iEstCodigoUpd			INT
			,@cTerminalUpd			VARCHAR(8)
			,@iFrqFornecedor		INT
			,@Tabela				CHAR(1)
			,@iNSUHost				BIGINT
			,@iFlag					TINYINT

	SET @iFlag = 0

	SELECT @iRdeCodigo = RdeCodigo FROM Processadora.dbo.Redes WITH(NOLOCK) WHERE Numero = @iRdeCodigo

	/* INICIO: Alteração para contemplar as transações do ECommerce */
	IF (@iRdeCodigo = 11)
	BEGIN
		DECLARE @iNSUTrnOriginal INT

		IF (@cTipoMensagem <> '0200')
		BEGIN
			SELECT	@iNSUHost		 = NsuHost
					,@cNSURefEstorno = Codigo_Ref_Estorno
			FROM	  Policard_603078.dbo.Transacao_RegistroTEF
			WHERE	NumeroCartao			= @cNroCartao
					AND Comprovante_FormGen	= @cNSURefEstorno
					AND Valor				= @dValorTransacao

			SELECT	@iNSUTrnOriginal	= NsuHost
					,@Tabela			= Tabela
			FROM	  Policard_603078.dbo.Transacao_RegistroTEF
			WHERE	NumeroCartao			= @cNroCartao
					AND Comprovante_FormGen	= @cNSURefEstorno
					AND Valor				= @dValorTransacao

			UPDATE   Policard_603078.dbo.Transacao_RegistroTEF
			SET		StatusTef = 'A'
			WHERE	NsuHost = @iNSUHost

			UPDATE   Policard_603078.dbo.Transacao_RegistroTEF
			SET		StatusTef = 'E'
			WHERE	NsuHost = @iNSUTrnOriginal
		END
	END
	/* FIM: Alteração para contemplar as transações do ECommerce*/

	IF (CONVERT(INT, @iRdeCodigo) NOT IN (2,4) OR (CONVERT(INT, @iRdeCodigo) = 4 AND CONVERT(INT, @iRdeCodigo) <> 2 AND @cTerminal LIKE 'G0%'))
	BEGIN

		SELECT TOP 1
			 @iTrnCodigoTransacoes	= T.TrnCodigo
			,@iEstCodigoUpd			= T.CodEstab
			,@cTerminalUpd			= T.Terminal
			,@iFlag					= 1
		FROM Processadora.dbo.Transacoes T WITH(NOLOCK)
		WHERE T.CodEstab = @iCodigoEstabelecimento
		AND T.Terminal = @cTerminal
		AND T.Status = 'P'
		ORDER BY T.TrnCodigo DESC

		IF (@cTerminal = @cTerminalUpd)
		BEGIN
			--UPDATE	TransacoesRegistroTEF
			--SET		StatusTef = 'A'
			--WHERE	TrnCodigo IN (	SELECT	TrnCodigo
			--						FROM	Transacoes WITH(NOLOCK)
			--						WHERE	TrnCodigo = @iTrnCodigoTransacoes
			--								AND EstCodigo = @iEstCodigoUpd
			--								AND Terminal = @cTerminalUpd
			--								AND Status = 'P')

			UPDATE	Processadora.dbo.Transacoes
			SET		Status = 'A'
			WHERE	TrnCodigo = @iTrnCodigoTransacoes
					AND CodEstab = @iEstCodigoUpd
					AND Terminal = @cTerminalUpd
					AND Status = 'P'
		END

		IF (@iFlag = 0)
		BEGIN
			SELECT	TOP 1
					 @Tabela		= Tabela
					,@iEstCodigoUpd	= Estabelecimento
					,@cTerminalUpd	= Terminal
					,@iNSUHost		= NsuHost
			FROM	  Policard_603078.dbo.Transacao_RegistroTEF WITH(NOLOCK)
			WHERE	Estabelecimento	= @iCodigoEstabelecimento
					AND Terminal	= @cTerminal
					AND StatusTef	= 'P'
			ORDER BY NsuHost DESC

			IF (@cTerminal = @cTerminalUpd)
			BEGIN
				IF (@Tabela = 'T')
				BEGIN
					UPDATE	  Policard_603078.dbo.Transacao_RegistroTEF
					SET		StatusTef = 'A'
					WHERE	Estabelecimento	= @iEstCodigoUpd
							AND Terminal	= @cTerminalUpd
							AND NsuHost		= @iNSUHost
							AND StatusTef	= 'P'
							AND Tabela		= 'T'
				END
				ELSE IF (@Tabela = 'F')
				BEGIN
					UPDATE	  Policard_603078.dbo.Transacao_RegistroTEF
					SET		StatusTef = 'A'
					WHERE	Estabelecimento	= @iEstCodigoUpd
							AND Terminal	= @cTerminalUpd
							AND NsuHost		= @iNSUHost
							AND StatusTef	= 'P'
							AND Tabela		= 'F'

					SELECT @iNSUHost = Codigo_Referencia FROM   Policard_603078.dbo.Transacao_RegistroTEF WITH(NOLOCK) WHERE NsuHost = @iNSUHost
					SELECT @iEstCodigoUpd = Codigo, @iFrqFornecedor = Franquia FROM   Policard_603078.dbo.Fornecedor WITH(NOLOCK) WHERE Codigo_Novo = @iEstCodigoUpd ORDER BY Codigo DESC

					UPDATE	  Policard_603078.dbo.Financiamento
					SET		Status = 'A'
					WHERE	Fornecedor				= @iEstCodigoUpd
							AND Franquia_Fornecedor = @iFrqFornecedor
							AND Terminal			= @cTerminalUpd
							AND Codigo				= @iNSUHost
							AND Status				= 'P'
				END
			END
		END
	END
END



