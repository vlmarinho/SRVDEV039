


/*
--------------------------------------------------------------------------
Data........: 21/05/2015
Nome Sistema: Autorizador
Objeto......: pr_AUT_ValidarIdpSenhaCartao
Propósito...: Procedure responsável por controlar a senha digitada
			  pelo usuário para bloquear o cartão caso necessário.
--------------------------------------------------------------------------
Criada por:	Luiz Renato
Data: 06/10/2015
CH: 1194 / 212609
---------------------------------------------------------------------------
*/

CREATE PROCEDURE pr_AUT_ValidarIdpSenhaCartao
	 @cNumeroCartao				CHAR(16)
	,@cBaseOrigem				CHAR(1)
	,@cSenhaTransacao			VARCHAR(100)
	,@sProvedor					VARCHAR(50)		= NULL
	,@sMascarasIdPositiva		VARCHAR(10)		= NULL
	,@sDadosIdPositiva			VARCHAR(32)		= NULL
	,@bIdentPositiva			BIT				= NULL
	,@bSenhaCapturada			BIT         	= NULL OUT
	,@bSenhaValida				BIT         	= NULL OUT
	,@iLenMascaraIdPositiva		INT				= NULL
	,@iRedeCaptura				INT				= NULL
	,@iCodEstabelecimento		INT				= NULL
	,@iCodCartao				INT				= NULL
	,@iResposta					INT				= NULL OUT
AS
BEGIN
	DECLARE  @iTotalErroSenha			INT
			,@iCodChaveTrabalho			INT
			,@dDataErroSenha			DATETIME
			,@cSenhaBase				VARCHAR(16)
			,@cChaveTrabalho			CHAR(16)
			,@bAtualizaSenhaTransacao	BIT

	SELECT @cSenhaBase = C.Senha, @bAtualizaSenhaTransacao = C.AtualizaSenhaTransacao FROM Processadora..CartoesUsuarios C WITH(NOLOCK) WHERE C.CrtUsrCodigo = @iCodCartao

	IF (@bIdentPositiva = 1) /* VALIDAÇÃO IDENTIFICAÇÃO POSITIVA */
		EXEC pr_AUT_ValidaIdentificacaoPositiva @cNumeroCartao, @sMascarasIdPositiva, @sDadosIdPositiva, @cBaseOrigem, @iLenMascaraIdPositiva, @iResposta OUT
	ELSE IF (ISNULL(@cSenhaTransacao,'') = '' OR  @cSenhaTransacao = '0000000000000000') /* VALIDAÇÃO SENHA */
	BEGIN
		SET @bSenhaCapturada = 0
		SET @bSenhaValida	 = 0
	END
	ELSE
	BEGIN
		BEGIN TRY -- EM CASO DE FALHA NA VALIDAÇÃO DE SENHA
			SET @bSenhaCapturada = 1

			EXEC pr_DecriptaSenhaPolicard @cSenhaBase OUT

			SELECT @cSenhaBase = RIGHT(@cSenhaBase,4)

			IF (CONVERT(INT, @iRedeCaptura) IN (4,5,7)) -- 58,10,13 >> SERA USADO O CODIGO DA REDE A PARTIR DE AGORA E NAO O BIT024/032
				EXEC pr_DecriptaSenha @cNumeroCartao, @cSenhaTransacao OUT
			ELSE
			BEGIN
				IF (@sProvedor IN ('CSI_CTF', 'ITAUTEC','ITAUTEC-SCOPE', 'PHOEBUS', 'DIRECAO', 'PAYGO', 'SOFTWARE EXPRESS', 'VBI'))
				BEGIN
					IF (@sProvedor = 'VBI') /* PROVEDOR VBI COM CHAVE 3DES */
						EXEC pr_DecriptaSenha @cNumeroCartao, @cSenhaTransacao OUT, @sProvedor
					ELSE
					BEGIN
						DECLARE @VTable TABLE (Codigo INT,Chave VARCHAR(128))

						SET @cChaveTrabalho = ''

						INSERT INTO @VTable
							SELECT	TOP 20 Codigo, ChaveTrabalho
							FROM	ChaveTrabalho WITH(NOLOCK)
							WHERE	Provedor = @sProvedor
									AND ChaveTrabalho NOT IN ('-1','-2') /* CHAVE COM ERRO NA GERAÇÃO */
							GROUP BY Codigo, ChaveTrabalho
							ORDER BY MAX(Codigo) DESC

						WHILE EXISTS (SELECT * FROM @VTable)
						BEGIN
							SELECT TOP 1 @iCodChaveTrabalho = Codigo, @cChaveTrabalho = Chave FROM @VTable ORDER BY Codigo DESC

							IF (@sProvedor IN ('PAYGO', 'SOFTWARE EXPRESS'))
								EXEC pr_DecriptarSenhaSEPayGO @cSenhaTransacao, @cChaveTrabalho, @cNumeroCartao, @cSenhaTransacao OUT
							ELSE IF (@sProvedor = 'DIRECAO')
								SELECT @cSenhaTransacao = dbo.DecriptografarDirecao(@cChaveTrabalho, @cSenhaTransacao)
							ELSE IF (@sProvedor IN ('ITAUTEC','ITAUTEC-SCOPE'))
								SELECT @cSenhaTransacao = dbo.DecriptarItautec(@cChaveTrabalho, @cSenhaTransacao)
							ELSE IF (@sProvedor = 'CSI_CTF')
								SELECT @cSenhaTransacao = dbo.DecriptarCSI(@cChaveTrabalho, @cSenhaTransacao)
							ELSE IF (@sProvedor = 'PHOEBUS')
								SELECT @cSenhaTransacao = dbo.DecriptarPhoebus(@cNumeroCartao, @cChaveTrabalho, @cSenhaTransacao)

							IF (ISNUMERIC(@cSenhaTransacao) = 1  AND LEN(@cSenhaTransacao) >= 4)
								BREAK

							DELETE FROM @VTable WHERE Codigo = @iCodChaveTrabalho
						END
					END
				END
				ELSE IF (@iRedeCaptura = 18)
				BEGIN
					EXEC projeto_cielo_processadora.dbo.pr_DecriptaSenhaBco24Horas @cSenhaTransacao OUT, @cNumeroCartao

					SET @cSenhaBase			 = RIGHT(@cSenhaBase,4)
					SET @cSenhaTransacao = RIGHT(@cSenhaTransacao,4)

					IF (@cSenhaBase = @cSenhaTransacao)
						SET @iResposta = 0
					ELSE
						SET @iResposta = 385
				END
			END

			IF (ISNUMERIC(@cSenhaTransacao) = 1 AND LEN(@cSenhaTransacao) >= 4)
			BEGIN
				DECLARE @cSenhaTransacaoAux VARCHAR(16)

				SET	@cSenhaTransacaoAux = @cSenhaTransacao

				IF (LEN(@cSenhaTransacao) > 4)
				BEGIN
					SET @iResposta		= 86 /* TAM. SENHA INVAL. */
					SET @bSenhaValida	= 0 /* SENHA INVALIDA */
				END
				ELSE
				BEGIN
					IF (@bAtualizaSenhaTransacao = 1 AND @cSenhaBase <> @cSenhaTransacao)
					BEGIN
						SET @cSenhaBase = ''
						SET @bSenhaValida = 1

						SELECT @cSenhaTransacaoAux = dbo.f_ZerosEsquerda(@cSenhaTransacao,16)
						EXEC pr_EncriptaSenhaPolicard @cSenhaTransacaoAux OUT
						UPDATE Processadora..CartoesUsuarios SET Senha = @cSenhaTransacaoAux, AtualizaSenhaTransacao = 0 WHERE CrtUsrCodigo = @iCodCartao

						SELECT @cSenhaBase = Senha FROM Processadora..CartoesUsuarios WITH(NOLOCK) WHERE CrtUsrCodigo = @iCodCartao
						EXEC pr_DecriptaSenhaPolicard @cSenhaBase OUT
						SELECT @cSenhaBase = RIGHT(@cSenhaBase,4)
					END
					ELSE IF (@bAtualizaSenhaTransacao = 1 AND @cSenhaBase = @cSenhaTransacao)
						UPDATE Processadora..CartoesUsuarios SET AtualizaSenhaTransacao = 0 WHERE CrtUsrCodigo = @iCodCartao

					IF (@cSenhaBase <> @cSenhaTransacao AND @iRedeCaptura IS NOT NULL)
					BEGIN
						SET @iResposta =  7 /* SENHA INVALIDA - SENHA INVALID */
						SET @bSenhaValida = 0
					END
					ELSE
						SET @bSenhaValida = 1 /* SENHA VALIDA */
				END
			END
			/* ALTERAÇÃO PARA TRAVAR SENHA QUE NAO CONSEGUIU DECRIPTAR */
			ELSE
			BEGIN
				IF (@cSenhaTransacao = 'A')
				BEGIN
					SET @iResposta = 65 /* TENTE DE NOVO - PROBLEMA DECRIPTA SENHA */
					SET @bSenhaValida = 0
				END
				ELSE
				BEGIN
					SET @iResposta = 42 /* PROBLEMA SENHA - PROBLEMA SENHA */
					SET @bSenhaValida = 0
				END
			END
		END TRY
		BEGIN CATCH
			SET @iResposta = 42 /* PROBLEMA SENHA - PROBLEMA SENHA */
		END CATCH
	END

	IF (LTRIM(RTRIM(@cSenhaTransacao)) = '' AND @iRedeCaptura IS NULL)
		SET @iResposta = 385

	SELECT	@iTotalErroSenha = COUNT(CodCartao)
			,@dDataErroSenha = COALESCE(CONVERT(VARCHAR,Data,112), NULL)
	FROM	ControleBloqueioCartao WITH(NOLOCK)
	WHERE	CodCartao		= @iCodCartao
			AND CodResposta = @iResposta
			and baseorigem = @cBaseOrigem
	GROUP BY CONVERT(VARCHAR,Data,112)

	IF (@iResposta = 385)
	BEGIN
		IF (@dDataErroSenha IS NOT NULL)
		BEGIN
			IF (CONVERT(VARCHAR,@dDataErroSenha,112) = CONVERT(VARCHAR,GETDATE(),112))
			BEGIN
				IF (@iTotalErroSenha = 2)
				BEGIN
					UPDATE Processadora..CartoesUsuarios SET Status = 'B', NivelBloqueio = 0 WHERE CrtUsrCodigo = @iCodCartao
					INSERT INTO Processadora..LOG_Tabelas VALUES('CartoesUsuarios', @iCodCartao, 'Status; [TECBAN] Bloqueado por erro de senha: 3 tentativas', 'A', 'B', GETDATE(), CONVERT(VARCHAR, SYSTEM_USER),NULL)
					DELETE FROM ControleBloqueioCartao WHERE CodCartao = @iCodCartao AND CodResposta = @iResposta and baseorigem = @cBaseOrigem

					SET @iResposta = 387
				END
				ELSE
					INSERT INTO ControleBloqueioCartao VALUES(@iCodCartao, NULL,@cBaseOrigem, @iResposta, GETDATE())
			END
			ELSE
				DELETE FROM ControleBloqueioCartao WHERE CodCartao = @iCodCartao AND CodResposta = @iResposta and baseorigem = @cBaseOrigem
		END
		ELSE
			INSERT INTO ControleBloqueioCartao VALUES(@iCodCartao, NULL,@cBaseOrigem, @iResposta, GETDATE())
	END
	ELSE IF (@iResposta = 0)
		DELETE FROM ControleBloqueioCartao WHERE CodCartao = @iCodCartao AND CodResposta = 385 and baseorigem = @cBaseOrigem
END






