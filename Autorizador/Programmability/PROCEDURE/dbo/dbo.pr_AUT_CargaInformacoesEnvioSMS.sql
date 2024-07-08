
/*
--------------------------------------------------------------------------
Data........: 11/08/2015
Nome Sistema: Autorizador
Objeto......: pr_AUT_CargaInformacoesEnvioSMS
Propósito...: Procedure responsável por armazenar as informações dos usuá-
			  rios para envio de SMS após transações.
--------------------------------------------------------------------------
Criada por:	Luiz Renato
Data: 06/10/2015
CH: 1194 / 212609
---------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[pr_AUT_CargaInformacoesEnvioSMS]
	 @iCodCartaoUsuario	INT
	,@iFranquiaUsuario	INT
	,@iQtdParcelas		INT			 = NULL
	,@dValor			DECIMAL(15,2)
	,@dSaldoDisponivel	DECIMAL(15,2)
	,@dDataTransacao	DATETIME
	,@cNumeroCartao		VARCHAR(16)
	,@sNomeEstab		VARCHAR(100) = NULL
	,@cBaseOrigem		CHAR(1)
	,@cTipoMensagem		CHAR(4)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE  @cMensagemSMS		VARCHAR(200)
			,@iCodUsuarioSMS	INT
			,@iCodTelefoneSMS	INT

    SELECT @iCodUsuarioSMS = Codigo FROM UsuarioPermiteSMS WITH(NOLOCK) WHERE CodCartao = @iCodCartaoUsuario AND Franquia = @iFranquiaUsuario AND Base = @cBaseOrigem

	IF (@iCodUsuarioSMS IS NOT NULL OR @iCodUsuarioSMS > 0)
	BEGIN
		DECLARE @VTable TABLE (CodUsuario INT, CodTelefone INT, Inserido BIT)

		INSERT INTO @VTable
			SELECT	TU.CodUsuarioSMS, TU.CodTelefoneSMS, 0
			FROM	TelefonesUsuariosSMS TU WITH(NOLOCK)
					INNER JOIN TelefonesSMS T WITH(NOLOCK) ON (T.Codigo = TU.CodTelefoneSMS)
			WHERE	TU.CodUsuarioSMS = @iCodUsuarioSMS
					AND T.Ativo = 1

		WHILE EXISTS (SELECT * FROM @VTable WHERE Inserido = 0)
		BEGIN
			SELECT TOP 1 @iCodTelefoneSMS = CodTelefone FROM @VTable WHERE Inserido = 0

			IF (@cTipoMensagem = '0200')
			BEGIN
				IF (ISNULL(@iQtdParcelas,1) = 1)
					SELECT	@cMensagemSMS = REPLACE(REPLACE(REPLACE(MsgTicket, '<CARTAO>', SUBSTRING(@cNumeroCartao,13,4)),'<DATA>',CONVERT(VARCHAR(10),@dDataTransacao,103)),'<HORA>',CONVERT(VARCHAR(5),@dDataTransacao,108))
					FROM	TicketsRetorno WITH(NOLOCK) WHERE Codigo = 7
				ELSE
					SELECT	@cMensagemSMS = REPLACE(REPLACE(REPLACE(REPLACE(MsgTicket, '<CARTAO>', SUBSTRING(@cNumeroCartao,13,4)),'<PARCELAS>', CONVERT(VARCHAR,@iQtdParcelas)),'<DATA>',CONVERT(VARCHAR(10),@dDataTransacao,103)),'<HORA>',CONVERT(VARCHAR(5),@dDataTransacao,108)) 
					FROM	TicketsRetorno WITH(NOLOCK) WHERE Codigo = 8
			END
			ELSE 
				IF (@cTipoMensagem IN ('0400','0420'))
					SELECT	@cMensagemSMS = REPLACE(REPLACE(REPLACE(MsgTicket, '<CARTAO>', SUBSTRING(@cNumeroCartao,13,4)),'<DATA>',CONVERT(VARCHAR(10),@dDataTransacao,103)),'<HORA>',CONVERT(VARCHAR(5),@dDataTransacao,108)) 
					FROM	TicketsRetorno WITH(NOLOCK) WHERE Codigo = 9

			IF (@iFranquiaUsuario = 80)
				SET @cMensagemSMS = REPLACE(@cMensagemSMS, ' Saldo atual: <SALDO>.','')

			IF (@cTipoMensagem <> '0610')
			BEGIN
				INSERT INTO EnviaSMS(
						 CodUsuario
						,CodTelefone
						,Mensagem
						,NomeEstabelecimento
						,Valor
						,Saldo
						,DataTransacao
						,Enviado)
				VALUES(  @iCodUsuarioSMS
						,@iCodTelefoneSMS
						,@cMensagemSMS
						,@sNomeEstab
						,@dValor
						,@dSaldoDisponivel
						,@dDataTransacao
						,0)
			END

			UPDATE @VTable SET Inserido = 1 WHERE CodUsuario = @iCodUsuarioSMS AND CodTelefone = @iCodTelefoneSMS
		END
	END
END
