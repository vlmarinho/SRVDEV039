



/*...
-- ==================================================================
-- Author:		Luiz Renato
-- Create date: 17/12/2014
-- Description:	Procedure responsável por controlar a senha digitada
--				pelo usuário para bloquear o cartão caso necessário.
-- ==================================================================
Data criação: 19/02/2017
Mudança: 2601
---------------------------------------------------------------------
Data Alteracao: 16/05/2017
Autor: Cristiano Barbosa
CH: 383212 - 2839
--------------------------------------------------------------------------

*/

--drop proc pr_aut_GerenciamentoCartao

CREATE PROCEDURE [dbo].[pr_aut_GerenciamentoCartao]
	 @cNumeroCartao				CHAR(16)
	,@cSenhaCriptografada		VARCHAR(100)
	,@cIdProvedor				VARCHAR(100)	= NULL
	,@sProvedor					VARCHAR(50)		= NULL
	,@sMascarasIdPositiva		VARCHAR(10)		= NULL
	,@sDadosIdPositiva			VARCHAR(32)		= NULL
	,@dDataHora_Transacao		DATETIME		= NULL
	,@bAtualizaSenhaTransacao	BIT				= NULL
	,@bIdentPositiva			BIT				= NULL
	,@iLenMascaraIdPositiva		INT				= NULL
	,@iRedeCaptura				INT
	,@iCodEstabelecimento		INT				= NULL
	,@iTempoSegundos			INT				= NULL OUTPUT
	,@iResposta					INT				= NULL OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE 
		@iCrtUsrCodigo		INT
		,@iTotalErroSenha	INT
		,@iTpoPrdCodigo		INT
		,@bSenhaCapturada	BIT
		,@bSenhaValida		BIT
		,@cSenhaBase		CHAR(16)
		,@cBase				CHAR(1)
		,@dDataErroSenha	DATETIME
		,@sStatusCartoes	CHAR(1)

	SET @cBase = ''
	SET @iTpoPrdCodigo = 0

	EXEC Processadora.dbo.pr_PROC_RetornarTipoProdutoCartao @cNumeroCartao, @cBase OUTPUT, @iTpoPrdCodigo OUTPUT

	SELECT	 
		  @iCrtUsrCodigo = CrtUsrCodigo
		 ,@cSenhaBase = Senha
		 ,@sStatusCartoes = Status
	FROM Processadora.dbo.CartoesUsuarios WITH(NOLOCK)
	WHERE Numero = @cNumeroCartao
	AND FlagTransferido = 0
		
	IF @sStatusCartoes <> 'A'
		SET @iResposta = 382
	ELSE
	BEGIN	
	
		IF (@bIdentPositiva = 1) /* VALIDAÇÃO IDENTIFICAÇÃO POSITIVA */
			EXEC pr_AUT_ValidaIdentificacaoPositiva @cNumeroCartao, @sMascarasIdPositiva, @sDadosIdPositiva, @cBase, @iLenMascaraIdPositiva, @iResposta OUTPUT
		ELSE IF (@cSenhaCriptografada = '' OR @cSenhaCriptografada IS NULL OR  @cSenhaCriptografada = '0000000000000000') /* VALIDAÇÃO SENHA */
		BEGIN
			SET @bSenhaCapturada = 0
			SET @bSenhaValida = 0
			
			IF (@iRedeCaptura = 18)
				SET @iResposta =  385 /* SENHA INVALIDA - BCO 24HRS NAO ACEITA SEM SENHA */
			
		END
		ELSE
		BEGIN
			BEGIN TRY -- EM CASO DE FALHA NA VALIDAÇÃO DE SENHA
				DECLARE	
					 @cChaveTrabalho	CHAR(16)
					,@planoBanco		VARCHAR(16)
					,@planoAutorizador	VARCHAR(16)

				SET @bSenhaCapturada	= 1
				SET @planoAutorizador	= @cSenhaCriptografada

				EXEC dbo.pr_DecriptaSenhaPolicard @cSenhaBase OUTPUT

				SELECT @planoBanco = RIGHT(@cSenhaBase, 4)

				IF (@iRedeCaptura IN (58, 10, 13,18))
				BEGIN 

					IF (@iRedeCaptura = 18)
						EXEC projeto_cielo_processadora.dbo.pr_DecriptaSenhaBco24Horas @planoAutorizador OUT, @cNumeroCartao
					ELSE
						EXEC dbo.pr_DecriptaSenha @cNumeroCartao, @planoAutorizador OUTPUT
				END
				--ELSE
				--BEGIN
				--	IF (@cIdProvedor IN ('CSI_CTF', 'ITAUTEC','ITAUTEC-SCOPE', 'PHOEBUS', 'DIRECAO', 'PAYGO', 'SOFTWARE EXPRESS', 'VBI'))
				--	BEGIN
				--		IF (@cIdProvedor = 'VBI')/* PROVEDOR VBI COM CHAVE 3DES */
				--			EXEC dbo.pr_DecriptaSenha @cNumeroCartao, @planoAutorizador OUTPUT, @cIdProvedor
				--		ELSE
				--		BEGIN
				--			DECLARE @VTable TABLE (Chave VARCHAR(128), Processado BIT)

				--			SET @cChaveTrabalho = ''

				--			INSERT INTO @VTable
				--				SELECT	TOP 50 ChaveTrabalho, 0
				--				FROM	ChaveAberturaTEF WITH(NOLOCK)
				--				WHERE	Estabelecimento = @iCodEstabelecimento
				--						AND Provedor = @cIdProvedor
				--						AND ChaveTrabalho NOT IN ('-1','-2') /* Chave com erro na geração */
				--				ORDER BY ChaveAberturaTefCodigo DESC

				--			WHILE EXISTS (SELECT * FROM @VTable WHERE Processado = 0)
				--			BEGIN
				--				SELECT TOP 1 @cChaveTrabalho = Chave FROM @VTable WHERE Processado = 0

				--				IF (@cIdProvedor IN ('PAYGO', 'SOFTWARE EXPRESS'))
				--					EXEC    projeto_cielo_convenio.dbo.pr_DecriptarSenhaSEPayGO @cSenhaCriptografada, @cChaveTrabalho, @cNumeroCartao, @planoAutorizador OUT
				--				ELSE IF (@cIdProvedor = 'DIRECAO')
				--					SELECT @planoAutorizador = [dbo].[DecriptografarDirecao] (@cChaveTrabalho, @cSenhaCriptografada)
				--				ELSE IF (@cIdProvedor IN ('ITAUTEC','ITAUTEC-SCOPE'))
				--					SELECT @planoAutorizador = [dbo].[DecriptarItautec] (@cChaveTrabalho, @cSenhaCriptografada)
				--				ELSE IF (@cIdProvedor = 'CSI_CTF')
				--					SELECT @planoAutorizador = [dbo].[DecriptarCSI] (@cChaveTrabalho, @cSenhaCriptografada)
				--				ELSE IF (@cIdProvedor = 'PHOEBUS')
				--					SELECT @planoAutorizador = [dbo].[DecriptarPhoebus] (@cNumeroCartao, @cChaveTrabalho, @cSenhaCriptografada)

				--				IF (ISNUMERIC(@planoAutorizador) = 1  AND LEN(@planoAutorizador) >= 4)
				--					BREAK

				--				UPDATE @VTable SET Processado = 1 WHERE Chave = @cChaveTrabalho
				--			END
				--		END
				--	END
				--END

				IF (ISNUMERIC(@planoAutorizador) = 1 AND LEN(@planoAutorizador) >= 4)
				BEGIN
				
					 DECLARE @pBanco	VARCHAR(16)
							,@pAut		VARCHAR(16)

					SET	@pAut = @planoAutorizador

					IF (LEN(@planoAutorizador) > 4)
					BEGIN
						SET @iResposta		= 86 /* TAM. SENHA INVAL. */
						SET @bSenhaValida	= 0 /* SENHA INVALIDA */
						SET @iTempoSegundos = DATEDIFF(SECOND, @dDataHora_Transacao, GETDATE())
					END
					ELSE
					BEGIN

						IF (@bAtualizaSenhaTransacao = 1 AND @planoBanco <> @planoAutorizador)
						BEGIN

							SET @planoBanco = ''
							SET @bSenhaValida = 1

							SELECT @planoAutorizador = dbo.f_ZerosEsquerda(@planoAutorizador,16)
							EXEC dbo.pr_EncriptaSenhaPolicard @planoAutorizador OUT
							UPDATE Processadora.dbo.CartoesUsuarios SET Senha = @planoAutorizador, AtualizaSenhaTransacao = 0 WHERE CrtUsrCodigo = @iCrtUsrCodigo

							SELECT @pBanco = Senha FROM Processadora.dbo.CartoesUsuarios WITH(NOLOCK) WHERE CrtUsrCodigo = @iCrtUsrCodigo
							EXEC dbo.pr_DecriptaSenhaPolicard @pBanco OUTPUT
							SELECT @planoBanco = SUBSTRING(@pBanco, 13, 4)
						END
						ELSE IF (@bAtualizaSenhaTransacao = 1 AND @planoBanco = @planoAutorizador)
							UPDATE Processadora.dbo.CartoesUsuarios SET AtualizaSenhaTransacao = 0 WHERE CrtUsrCodigo = @iCrtUsrCodigo

						IF (@planoBanco <> @pAut AND @iRedeCaptura IS NOT NULL)
						BEGIN
							IF @iRedeCaptura = 18
								SET @iResposta =  385 /* SENHA INVALIDA - BCO 24HRS*/
							ELSE
								SET @iResposta =  27 /* SENHA INVALIDA - SENHA INVALID */
							
							SET @bSenhaValida = 0
							SET @iTempoSegundos = DATEDIFF(SECOND, @dDataHora_Transacao, GETDATE())
						END
						ELSE
							SET @bSenhaValida = 1 /* SENHA VALIDA */
					END
				END
				/* ALTERAÇÃO PARA TRAVAR SENHA QUE NAO CONSEGUIU DECRIPTAR */
				ELSE
				BEGIN
					IF (@planoAutorizador = 'A')
					BEGIN
						SET @iResposta = 65 /* TENTE DE NOVO - PROBLEMA DECRIPTA SENHA */
						SET @bSenhaValida = 0
						SET @iTempoSegundos = DATEDIFF(SECOND, @dDataHora_Transacao, GETDATE())
					END
					ELSE
					BEGIN
						SET @iResposta = 42 /* PROBLEMA SENHA - PROBLEMA SENHA */
						SET @bSenhaValida = 0
						SET @iTempoSegundos = DATEDIFF(SECOND, @dDataHora_Transacao, GETDATE())
					END
				END
			END TRY
			BEGIN CATCH
				SET @iResposta = 42 /* PROBLEMA SENHA - PROBLEMA SENHA */
			END CATCH
		END
	END
	

	IF (LTRIM(RTRIM(@cSenhaCriptografada)) = '' AND @iRedeCaptura IS NULL)
		SET @iResposta = 385

	SELECT	@iTotalErroSenha = COUNT(CodCartao)
			,@dDataErroSenha = COALESCE(CONVERT(VARCHAR,Data,112), NULL)
	FROM	ControleBloqueioCartao WITH(NOLOCK)
	WHERE	CodCartao		= @iCrtUsrCodigo
		AND BaseOrigem = @cBase
		AND CodResposta = @iResposta
	GROUP BY CONVERT(VARCHAR,Data,112)
	

	IF (@iResposta = 385)
	BEGIN

		IF (@dDataErroSenha IS NOT NULL)
		BEGIN

			IF (CONVERT(VARCHAR,@dDataErroSenha,112) = CONVERT(VARCHAR,GETDATE(),112))
			BEGIN

				IF (@iTotalErroSenha = 2)
				BEGIN

					UPDATE Processadora.dbo.CartoesUsuarios SET Status = 'B', NivelBloqueio = 0, MtvSttCodigo = 21 WHERE CrtUsrCodigo = @iCrtUsrCodigo
					INSERT INTO Processadora.dbo.LOG_Tabelas VALUES('CartoesUsuarios', @iCrtUsrCodigo, 'Status; [TECBAN] Bloqueado por erro de senha: 3 tentativas', 'A', 'B', GETDATE(), CONVERT(VARCHAR, SYSTEM_USER),NULL)
					DELETE FROM ControleBloqueioCartao WHERE CodCartao = @iCrtUsrCodigo AND BaseOrigem = @cBase AND CodResposta = @iResposta

					SET @iResposta = 387
				END
				ELSE
					INSERT INTO ControleBloqueioCartao VALUES(@iCrtUsrCodigo, NULL, @cBase, @iResposta, GETDATE())
			END
			ELSE
				DELETE FROM ControleBloqueioCartao WHERE CodCartao = @iCrtUsrCodigo AND BaseOrigem = @cBase AND CodResposta = @iResposta
		END
		ELSE
			INSERT INTO ControleBloqueioCartao VALUES(@iCrtUsrCodigo, NULL, @cBase ,@iResposta, GETDATE())
	END
	ELSE IF (@iResposta = 0)
		DELETE FROM ControleBloqueioCartao WHERE CodCartao = @iCrtUsrCodigo AND BaseOrigem = @cBase AND CodResposta IN (385)
END









