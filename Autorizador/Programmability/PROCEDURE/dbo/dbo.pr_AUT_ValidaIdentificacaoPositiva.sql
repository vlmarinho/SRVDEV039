



-- ================================================
-- Author:		Cristiano Silva Barbosa
-- Create date: 
-- Description:	Procedure responsável por validar
--				os dados da Identificação Positiva.
-- ================================================
-- DATA..: 23/07/2015
-- CH/MUD: 200579/988
-- AUTOR.: Cristiano
-- ================================================
--Data criação: 19/02/2017
--Mudança: 2601


CREATE PROCEDURE [pr_AUT_ValidaIdentificacaoPositiva]
	 @cNumeroCartao			VARCHAR(16)
	,@sMascarasIdPositiva	VARCHAR(10)
	,@sDadosIdPositiva		VARCHAR(32)
	,@cBase					CHAR(1)
	,@iLenMascaraIdPositiva	INT
	,@iResposta				INT OUTPUT
AS
BEGIN
	DECLARE  @sMask1			VARCHAR(10)
			,@sMask2			VARCHAR(10)
			,@sPartData1		VARCHAR(32)
			,@sPartData2		VARCHAR(32)
			,@iDiaNascBase		INT
			,@iMesNascBase		INT
			,@iAnoNascBase		INT
			,@iCpfBase			INT
			,@iCVVBase			INT
			/* CONTROLE DE ERROS IDENTIFICAÇÃO POSITIVA */
			,@iTotalErroIdPos	INT
			,@iCodCartao		INT
			,@iFranquia			INT
			,@dDataErroIdPos	DATETIME

	SET @iTotalErroIdPos = 0
	SET @dDataErroIdPos  = GETDATE()

	IF (@cBase = 'C')
	BEGIN
		SELECT	 @iCodCartao	= C.Codigo
				,@iFranquia		= C.Franquia
				,@iDiaNascBase	= CASE WHEN (C.CU_DataNascimento IS NOT NULL OR LTRIM(RTRIM(C.CU_DataNascimento)) <> '')
											THEN COALESCE(DATEPART(DAY, C.CU_DataNascimento),0)
											ELSE COALESCE(DATEPART(DAY, U.Data_Nascimento),0)
								  END
				,@iMesNascBase	= CASE WHEN (C.CU_DataNascimento IS NOT NULL OR LTRIM(RTRIM(C.CU_DataNascimento)) <> '')
											THEN COALESCE(DATEPART(MONTH, C.CU_DataNascimento),0)
											ELSE COALESCE(DATEPART(MONTH, U.Data_Nascimento),0)
								  END
				,@iAnoNascBase	= CASE WHEN (C.CU_DataNascimento IS NOT NULL OR LTRIM(RTRIM(C.CU_DataNascimento)) <> '')
											THEN COALESCE(DATEPART(YEAR, C.CU_DataNascimento),0)
											ELSE COALESCE(DATEPART(YEAR, U.Data_Nascimento),0)
								  END
				,@iCVVBase		= CONVERT(INT,C.CodVerificador)
				,@iCpfBase		= CASE WHEN (C.CU_Cpf IS NOT NULL OR LTRIM(RTRIM(C.CU_Cpf)) <> '')
											THEN COALESCE(RIGHT(REPLACE(REPLACE(C.CU_Cpf,'.',''),'-',''), 5),0)
											ELSE COALESCE(RIGHT(REPLACE(REPLACE(U.Cpf,'.',''),'-',''), 5),0)
								  END
		FROM	  Policard_603078.dbo.Cartao_Usuario C WITH(NOLOCK)
				INNER JOIN   Policard_603078.dbo.Usuario U WITH(NOLOCK) ON (U.Codigo = C.Usuario AND U.Franquia = C.Franquia)
		WHERE	C.CodigoCartao = @cNumeroCartao
		and C.StsTransferenciaUsuario IS NULL

	END
	ELSE IF (@cBase = 'P')
	BEGIN
		SELECT	 @iCodCartao	= C.CrtUsrCodigo
				,@iDiaNascBase	= CASE WHEN (C.DataNascimento IS NOT NULL OR LTRIM(RTRIM(C.DataNascimento)) <> '')
											THEN COALESCE(DATEPART(DAY, C.DataNascimento),0)
											ELSE COALESCE(DATEPART(DAY, P.DataNascimento),0)
								  END
				,@iMesNascBase	= CASE WHEN (C.DataNascimento IS NOT NULL OR LTRIM(RTRIM(C.DataNascimento)) <> '')
											THEN COALESCE(DATEPART(MONTH, C.DataNascimento),0)
											ELSE COALESCE(DATEPART(MONTH, P.DataNascimento),0)
								  END
				,@iAnoNascBase	= CASE WHEN (C.DataNascimento IS NOT NULL OR LTRIM(RTRIM(C.DataNascimento)) <> '')
											THEN COALESCE(DATEPART(YEAR, C.DataNascimento),0)
											ELSE COALESCE(DATEPART(YEAR, P.DataNascimento),0)
								  END
				,@iCVVBase		= CONVERT(INT, C.CodVerificador)
				,@iCpfBase		= CASE WHEN (C.CPF IS NOT NULL OR LTRIM(RTRIM(C.CPF)) <> '')
											THEN COALESCE(RIGHT(REPLACE(REPLACE(C.CPF,'.',''),'-',''), 5),0)
											ELSE COALESCE(RIGHT(REPLACE(REPLACE(P.CPF,'.',''),'-',''), 5),0)
								  END
		FROM Processadora.dbo.CartoesUsuarios C WITH(NOLOCK)
		INNER JOIN Processadora.dbo.ContasUsuarios CO WITH(NOLOCK) ON (CO.CntUsrCodigo = C.CntUsrCodigo)
		INNER JOIN Processadora.dbo.PropostasPF P WITH(NOLOCK) ON (P.PrpPFCodigo = CO.PrpCodigo)
		WHERE C.Numero = @cNumeroCartao
		AND C.FlagTransferido = 0
	END

	IF (@iLenMascaraIdPositiva < 9)
		EXEC projeto_cielo_processadora.dbo.pr_DecriptaSenhaBco24Horas @sDadosIdPositiva OUT, NULL, 1
	ELSE
	BEGIN
		SET @sPartData1 = LEFT(@sDadosIdPositiva,16)
		SET @sPartData2 = RIGHT(@sDadosIdPositiva,16)
	
		EXEC projeto_cielo_processadora.dbo.pr_DecriptaSenhaBco24Horas @sPartData1 OUT, NULL, 1
		EXEC projeto_cielo_processadora.dbo.pr_DecriptaSenhaBco24Horas @sPartData2 OUT, NULL, 1
	
		SET @sDadosIdPositiva = @sPartData1 + RIGHT(@sPartData2,1)
	END
--print @sDadosIdPositiva
--print @sPartData1
--print @sPartData2
--print @sMascarasIdPositiva
	/* INI: VALIDAÇÃO DADOS IDENTIFICAÇÃO POSITIVA */
	IF (@iLenMascaraIdPositiva = 4) -- DDMM: 43B697B273044CA5, MMDD: D2B61D60115A8602
	BEGIN
		SET @sMask1 = LEFT(@sMascarasIdPositiva,2)
		SET @sMask2 = RIGHT(@sMascarasIdPositiva,2)

		IF (@sMask1 = 'DD' AND @sMask2 = 'MM')
		BEGIN
			IF (@iDiaNascBase <> CONVERT(INT, LEFT(@sDadosIdPositiva,6)) OR
				@iMesNascBase <> CONVERT(INT, RIGHT(@sDadosIdPositiva,2)))
				SET @iResposta = 1
		END
		ELSE IF (@sMask1 = 'MM' AND @sMask2 = 'DD')
		BEGIN
			IF (@iDiaNascBase <> CONVERT(INT, RIGHT(@sDadosIdPositiva,2)) OR
				@iMesNascBase <> CONVERT(INT, LEFT(@sDadosIdPositiva,6)))
				SET @iResposta = 1
		END
	END
	ELSE IF (@iLenMascaraIdPositiva = 5) -- 999DD: 67520E2ECDC7BAC6, 999MM: F9026AB01DF26443, DD999: 21D299E095986AF7, MM999: 3CFC366061F2086A
	BEGIN
		IF (ISNUMERIC(LEFT(@sMascarasIdPositiva,1)) = 1)
		BEGIN
			SET @sMask1 = LEFT(@sMascarasIdPositiva,3)
			SET @sMask2 = RIGHT(@sMascarasIdPositiva,2)
		END
		ELSE
		BEGIN
			SET @sMask1 = LEFT(@sMascarasIdPositiva,2)
			SET @sMask2 = RIGHT(@sMascarasIdPositiva,3)
		END

		IF (ISNUMERIC(@sMask1) = 1)
		BEGIN
			IF (@sMask2 = 'DD')
			BEGIN
				IF (@iCVVBase <> CONVERT(INT, LEFT(@sDadosIdPositiva,6)) OR
					@iDiaNascBase <> CONVERT(INT, RIGHT(@sDadosIdPositiva,2)))
					SET @iResposta = 1
			END
			ELSE IF (@sMask2 = 'MM')
			BEGIN
				IF (@iCVVBase <> CONVERT(INT, LEFT(@sDadosIdPositiva,6)) OR
					@iMesNascBase <> CONVERT(INT, RIGHT(@sDadosIdPositiva,2)))
					SET @iResposta = 1
			END
		END
		ELSE
		BEGIN
			IF (@sMask1 = 'DD')
			BEGIN
				IF (@iCVVBase <> CONVERT(INT, RIGHT(@sDadosIdPositiva,3)) OR
					@iDiaNascBase <> CONVERT(INT, LEFT(@sDadosIdPositiva,5)))
					SET @iResposta = 1
			END
			ELSE IF (@sMask1 = 'MM')
			BEGIN
				IF (@iCVVBase <> CONVERT(INT, RIGHT(@sDadosIdPositiva,3)) OR
					@iMesNascBase <> CONVERT(INT, LEFT(@sDadosIdPositiva,5)))
					SET @iResposta = 1
			END
		END
	END
	ELSE IF (@iLenMascaraIdPositiva = 6) -- AAAADD: F4EDA49A0B39D9AA, AAAAMM: 3139D676FDA73D0C, DDAAAA: DA0A51E09A92494A, MMAAAA: 0BB461B08FC5CBE5, 9999DD: A88DE45FF88E1E12, 9999MM: 7794276695A5B122, DD9999: FE9F118CB8582D11, MM9999: BF19562C8CAC5390
	BEGIN
		IF (LEFT(@sMascarasIdPositiva,1) = 'A' OR ISNUMERIC(LEFT(@sMascarasIdPositiva,1)) = 1)
		BEGIN
			SET @sMask1 = LEFT(@sMascarasIdPositiva,4)
			SET @sMask2 = RIGHT(@sMascarasIdPositiva,2)
		END
		ELSE
		BEGIN
			SET @sMask1 = LEFT(@sMascarasIdPositiva,2)
			SET @sMask2 = RIGHT(@sMascarasIdPositiva,4)
		END

		IF (@sMask1 = 'AAAA' OR ISNUMERIC(@sMask1) = 1)
		BEGIN
			IF (@sMask1 = 'AAAA')
			BEGIN
				IF (@sMask2 = 'DD')
				BEGIN
					IF (@iAnoNascBase <> CONVERT(INT, LEFT(@sDadosIdPositiva,6)) OR
						@iDiaNascBase <> CONVERT(INT, RIGHT(@sDadosIdPositiva,2)))
						SET @iResposta = 1
				END
				ELSE IF (@sMask2 = 'MM')
				BEGIN
					IF (@iAnoNascBase <> CONVERT(INT, LEFT(@sDadosIdPositiva,6)) OR
						@iMesNascBase <> CONVERT(INT, RIGHT(@sDadosIdPositiva,2)))
						SET @iResposta = 1
				END
			END
			ELSE
			BEGIN
				IF (@sMask2 = 'DD')
				BEGIN
					IF (@iCVVBase <> CONVERT(INT, LEFT(@sDadosIdPositiva,6)) OR
						@iDiaNascBase <> CONVERT(INT, RIGHT(@sDadosIdPositiva,2)))
						SET @iResposta = 1
				END
				ELSE IF (@sMask2 = 'MM')
				BEGIN
					IF (@iCVVBase <> CONVERT(INT, LEFT(@sDadosIdPositiva,6)) OR
						@iMesNascBase <> CONVERT(INT, RIGHT(@sDadosIdPositiva,2)))
						SET @iResposta = 1
				END
			END
		END
		ELSE
		BEGIN
			IF (@sMask2 = 'AAAA')
			BEGIN
				IF (@sMask1 = 'DD')
				BEGIN
					IF (@iAnoNascBase <> CONVERT(INT, RIGHT(@sDadosIdPositiva,4)) OR
						@iDiaNascBase <> CONVERT(INT, LEFT(@sDadosIdPositiva,4)))
						SET @iResposta = 1
				END
				ELSE IF (@sMask1 = 'MM')
				BEGIN
					IF (@iAnoNascBase <> CONVERT(INT, RIGHT(@sDadosIdPositiva,4)) OR
						@iMesNascBase <> CONVERT(INT, LEFT(@sDadosIdPositiva,4)))
						SET @iResposta = 1
				END
			END
			ELSE
			BEGIN
				IF (@sMask1 = 'DD')
				BEGIN
					IF (@iCVVBase <> CONVERT(INT, RIGHT(@sDadosIdPositiva,4)) OR
						@iDiaNascBase <> CONVERT(INT, LEFT(@sDadosIdPositiva,4)))
						SET @iResposta = 1
				END
				ELSE IF (@sMask1 = 'MM')
				BEGIN
					IF (@iCVVBase <> CONVERT(INT, RIGHT(@sDadosIdPositiva,4)) OR
						@iMesNascBase <> CONVERT(INT, LEFT(@sDadosIdPositiva,4)))
						SET @iResposta = 1
				END
			END
		END
	END
	ELSE IF (@iLenMascaraIdPositiva = 7) -- AAAA999: E400BBE8CDBCC0D6, 999AAAA: 542AE8D5FD24C971, DD99999: 078484F02DA8C986, 99999DD: FE5CBDB0C2FE23DA, MM99999: 3CB4F278C9BD3AF4, 99999MM: C943E56A89C10C0B
	BEGIN
		IF (LEFT(@sMascarasIdPositiva,1) IN ('A','D','M'))
		BEGIN
			IF (LEFT(@sMascarasIdPositiva,1) = 'A')
			BEGIN
				SET @sMask1 = LEFT(@sMascarasIdPositiva,4)
				SET @sMask2 = RIGHT(@sMascarasIdPositiva,3)
			END
			ELSE
			BEGIN
				SET @sMask1 = LEFT(@sMascarasIdPositiva,2)
				SET @sMask2 = RIGHT(@sMascarasIdPositiva,5)
			END
		END
		ELSE
		BEGIN
			IF (ISNUMERIC(LEFT(@sMascarasIdPositiva,5)) = 1)
			BEGIN
				SET @sMask1 = LEFT(@sMascarasIdPositiva,5)
				SET @sMask2 = RIGHT(@sMascarasIdPositiva,2)
			END
			ELSE
			BEGIN
				SET @sMask1 = LEFT(@sMascarasIdPositiva,3)
				SET @sMask2 = RIGHT(@sMascarasIdPositiva,4)
			END
		END

		IF (ISNUMERIC(@sMask1) = 0)
		BEGIN
			IF (@sMask1 = 'AAAA')
			BEGIN
				IF (@iAnoNascBase <> CONVERT(INT, LEFT(@sDadosIdPositiva,5)) OR
					@iCVVBase <> CONVERT(INT, RIGHT(@sDadosIdPositiva,3)))
					SET @iResposta = 1
			END
			ELSE IF (@sMask1 = 'DD')
			BEGIN
				IF (@iDiaNascBase <> CONVERT(INT, LEFT(@sDadosIdPositiva,3)) OR
					@iCpfBase <> CONVERT(INT, RIGHT(@sDadosIdPositiva,5)))
					SET @iResposta = 1
			END
			ELSE IF (@sMask1 = 'MM')
			BEGIN
				IF (@iMesNascBase <> CONVERT(INT, LEFT(@sDadosIdPositiva,3)) OR
					@iCpfBase <> CONVERT(INT, RIGHT(@sDadosIdPositiva,5)))
					SET @iResposta = 1
			END
		END
		ELSE
		BEGIN
			IF (ISNUMERIC(LEFT(@sMascarasIdPositiva,5)) = 1)
			BEGIN
				IF (@sMask2 = 'DD')
				BEGIN
					IF (@iDiaNascBase <> CONVERT(INT, RIGHT(@sDadosIdPositiva,2)) OR
						@iCpfBase <> CONVERT(INT, LEFT(@sDadosIdPositiva,6)))
						SET @iResposta = 1
				END
				ELSE IF (@sMask2 = 'MM')
				BEGIN
					IF (@iMesNascBase <> CONVERT(INT, RIGHT(@sDadosIdPositiva,2)) OR
						@iCpfBase <> CONVERT(INT, LEFT(@sDadosIdPositiva,6)))
						SET @iResposta = 1
				END
			END
			ELSE
			BEGIN
				IF (@iAnoNascBase <> CONVERT(INT, RIGHT(@sDadosIdPositiva,4)) OR
					@iCVVBase <> CONVERT(INT, LEFT(@sDadosIdPositiva,4)))
					SET @iResposta = 1
			END
		END
	END
	ELSE IF (@iLenMascaraIdPositiva = 8) -- AAAA9999: 149035C671927206, 9999AAAA: D7CEED82E7314D83
	BEGIN
		SET @sMask1 = LEFT(@sMascarasIdPositiva,4)
		SET @sMask2 = RIGHT(@sMascarasIdPositiva,4)

		IF (ISNUMERIC(@sMask1) = 0)
		BEGIN
			IF (@iAnoNascBase <> CONVERT(INT, LEFT(@sDadosIdPositiva,4)) OR
				@iCVVBase <> CONVERT(INT, RIGHT(@sDadosIdPositiva,4)))
				SET @iResposta = 1
		END
		ELSE
		BEGIN
			IF (@iAnoNascBase <> CONVERT(INT, RIGHT(@sDadosIdPositiva,4)) OR
				@iCVVBase <> CONVERT(INT, LEFT(@sDadosIdPositiva,4)))
				SET @iResposta = 1
		END
	END
	ELSE IF (@iLenMascaraIdPositiva = 9) -- AAAA99999: 308829D9DDA68D415E2D15334B34D418, 99999AAAA: 5C3D773B3C2DD6950262CF00EF28A1F6
	BEGIN
		IF (ISNUMERIC(LEFT(@sMascarasIdPositiva,1)) = 0)
		BEGIN
			SET @sMask1 = LEFT(@sMascarasIdPositiva,4)
			SET @sMask2 = RIGHT(@sMascarasIdPositiva,5)
		END
		ELSE
		BEGIN
			SET @sMask1 = LEFT(@sMascarasIdPositiva,5)
			SET @sMask2 = RIGHT(@sMascarasIdPositiva,4)
		END

		IF (ISNUMERIC(@sMask1) = 0)
		BEGIN
			IF (@iAnoNascBase <> CONVERT(INT, LEFT(@sDadosIdPositiva,4)) OR
				@iCpfBase <> CONVERT(INT, RIGHT(@sDadosIdPositiva,5)))
				SET @iResposta = 1
		END
		ELSE
		BEGIN
			IF (@iAnoNascBase <> CONVERT(INT, RIGHT(@sDadosIdPositiva,4)) OR
				@iCpfBase <> CONVERT(INT, LEFT(@sDadosIdPositiva,5)))
				SET @iResposta = 1
		END
	END
	/* FIM: VALIDAÇÃO DADOS IDENTIFICAÇÃO POSITIVA */

	/* INI: VALIDAÇÃO QUANTIDADE ERROS IDENTIFICAÇÃO POSITIVA */
	SELECT	@iTotalErroIdPos = COUNT(COALESCE(CodCartao,0))
			,@dDataErroIdPos = COALESCE(CONVERT(VARCHAR,Data,112), NULL)
	FROM	ControleBloqueioCartao WITH(NOLOCK)
	WHERE	CodCartao		= @iCodCartao
		AND CodResposta NOT IN (385,387)
		AND BaseOrigem =  @cBase
	GROUP BY CONVERT(VARCHAR,Data,112)

	IF (@iTotalErroIdPos = 0)
	BEGIN
		IF (@iResposta <> 0)
		BEGIN
			SET @iResposta = 388

			IF (@cBase = 'C')
				INSERT INTO ControleBloqueioCartao VALUES(@iCodCartao, @iFranquia,@cBase, @iResposta, GETDATE())
			ELSE
				INSERT INTO ControleBloqueioCartao VALUES(@iCodCartao, NULL, @cBase, @iResposta, GETDATE())
		END
	END
	ELSE
	BEGIN
		IF (@iTotalErroIdPos = 1)
		BEGIN
			IF (@iResposta = 0)
				DELETE FROM ControleBloqueioCartao WHERE CodCartao = @iCodCartao AND BaseOrigem = @cBase AND CodResposta IN (388,389)
			ELSE
			BEGIN
				SET @iResposta = 389

				IF (@cBase = 'C')
					INSERT INTO ControleBloqueioCartao VALUES(@iCodCartao, @iFranquia, @cBase, @iResposta, GETDATE())
				ELSE
					INSERT INTO ControleBloqueioCartao VALUES(@iCodCartao, NULL, @cBase, @iResposta, GETDATE())
			END
		END
		ELSE IF (@iTotalErroIdPos = 2)
		BEGIN
			IF (@iResposta <> 0)
				SET @iResposta = 390

			DELETE FROM ControleBloqueioCartao WHERE CodCartao = @iCodCartao AND BaseOrigem =  @cBase AND CodResposta IN (388,389)
		END
	END
	/* FIM: VALIDAÇÃO QUANTIDADE ERROS IDENTIFICAÇÃO POSITIVA */
END




----------------------




----------------------




