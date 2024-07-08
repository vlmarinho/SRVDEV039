
/*
---------------------------------------------------------------------------
Data........: 17/06/2015
Nome Sistema: Autorizador
Objeto......: pr_AUT_AtualizaKeepAlive
Propósito...: Procedure responsável por gerenciar o Keep Alive de POS.
--------------------------------------------------------------------------
Criada por:	Luiz Renato
Data: 06/10/2015
CH: 1194 / 212609
---------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[pr_AUT_AtualizaKeepAlive]
	 @sBit012 VARCHAR(6)	OUT	-- Hora do terminal
	,@sBit013 VARCHAR(4)	OUT	-- Data do terminal
	,@sBit024 VARCHAR(3)		-- Rede de captura BIT024
	,@sBit032 VARCHAR(20)		-- Rede de captura BIT032
	,@sBit041 VARCHAR(8)		-- Numero Terminal
	,@sBit042 VARCHAR(15)		-- Codigo de estabelecimento
	,@sBit046 VARCHAR(1000)		-- Informacoes de comunicacao do POS
	,@sBit047 VARCHAR(1000)		-- Informacoes do POS
	,@sBit062 VARCHAR(1000)	OUT	-- Informacoes do POS
	,@sBit105 VARCHAR(2)		-- Confirmar transacao anterior
AS
BEGIN
	DECLARE  @iRede			 INT
			,@iResposta		 INT
			,@bTipoTransacao BIT
			,@sNumeroLoja	 VARCHAR(15)
			,@sCodigoLoja	 VARCHAR(15)

	SET @bTipoTransacao = 1
	SET @iRede = dbo.f_RetornarRede(@sBit024,@sBit032)

	IF (@iRede = 4 AND (@sBit046 <> '' OR @sBit046 IS NOT NULL)) /* POS WALK ENVIA OS DADOS DE COMUNICACAO NO BIT046 */
		SET @sBit047 = @sBit047 + SUBSTRING(@sBit046,2,LEN(@sBit046))

	IF (@iRede IN (7,8) AND @sBit047 <> '')
	BEGIN
		DECLARE  @bAtualizaVersao	BIT
				,@cVersaoProducao	CHAR(6)
				,@sNomeAplicacao	VARCHAR(20)
				,@dDataTelecarga	DATETIME

		/* ATUALIZANDO DATA E HORA DO TERMINAL */
		SELECT	@bAtualizaVersao = AtualizarVersaoPOS
				,@sBit012		 = REPLACE(CONVERT (VARCHAR(8),GETDATE(),108),':','')
				,@sBit013		 = REPLACE(CONVERT (VARCHAR(5),GETDATE(),110),'-','')
		FROM	Acquirer..MeioCaptura WITH(NOLOCK)
		WHERE	NumeroLogico = @sBit041

		IF (@bAtualizaVersao = 1)
		BEGIN
			SELECT	@cVersaoProducao = V.CodigoVersao
					,@dDataTelecarga = P.Data
					,@sNomeAplicacao = P.Nome
			FROM	Acquirer..VersaoAplicacaoMeiosCaptura V WITH(NOLOCK)
					INNER JOIN Acquirer..ModeloPOS MP WITH(NOLOCK) ON (MP.CodigoModeloPOS = V.CodModeloPOS)
					INNER JOIN Acquirer..PacoteAtualizacaoVersao P WITH(NOLOCK) ON (P.CodVersaoAplicacao = V.Codigo)
					INNER JOIN Acquirer..EstabelecimentoAtualizacaoVersaoAplicacao EA WITH(NOLOCK) ON (EA.CodPacoteVersaoAplicacao = P.Codigo)
					INNER JOIN Acquirer..Estabelecimento E WITH(NOLOCK) ON (E.CodigoEstabelecimento = EA.CodEstabelecimento)
					INNER JOIN Acquirer..EstabelecimentoMeioCaptura EM WITH(NOLOCK) ON (E.CodigoEstabelecimento = EM.CodigoEstabelecimento)
					INNER JOIN Acquirer..MeioCaptura MC WITH(NOLOCK) ON (MC.CodigoMeioCaptura = EM.CodigoMeioCaptura)
			WHERE	MC.NumeroLogico = @sBit041

			SET @sBit062 = @cVersaoProducao + '|' + @sNomeAplicacao + '|' + SUBSTRING(CONVERT(VARCHAR(10),@dDataTelecarga,112),3,8) + REPLACE(CONVERT(VARCHAR(10),@dDataTelecarga,108),':','')

			/* ATUALIZANDO TERMINAL PARA NAO ATUALIZAR NOVAMENTE */
			UPDATE Acquirer..MeioCaptura SET AtualizarVersaoPOS = 0 WHERE NumeroLogico = @sBit041
		END
	END

	/* VALIDANDO ESTABELECIMENTO */
	IF (@iRede <> 8) /* CB ITAU */
		EXEC Processadora..pr_AUT_Verifica_Meioscaptura @sBit041, @sBit042, @sBit047, @iRede, @bTipoTransacao, @iResposta OUTPUT
	ELSE
	BEGIN
		SET	@sNumeroLoja = SUBSTRING(@sBit042,2,7)
		SET	@sCodigoLoja = SUBSTRING(@sBit042,9,7)

		SELECT	@sBit042 = E.Numero
		FROM	Processadora..Estabelecimentos E WITH(NOLOCK)
				INNER JOIN Processadora..CB_DadosCorrespondente DC WITH(NOLOCK) ON (DC.estcodigo = E.estcodigo)
		WHERE	E.Numero = CONVERT (BIGINT, @sBit042) OR (DC.CodigoLoja = @sCodigoLoja AND DC.NumeroLoja = @sNumeroLoja)

		EXEC Processadora..pr_AUT_Verifica_Meioscaptura @sBit041, @sBit042, @sBit047, @iRede, @bTipoTransacao, @iResposta OUT

		/* CONFIRMAR TRANSACOES DO CORRESPONDENTE BANCARIO PENDENTE */
		IF (@sBit105 = '01')
		BEGIN
			DECLARE  @iCodigoUltimaTransacao	INT
					,@cTipoUltimaTransacao		CHAR(4)
					,@cStatusUltimaTransacao	CHAR(1)
					,@cConfirmaPgtoPolicard		CHAR(1)

			SELECT	TOP 1
					 @iCodigoUltimaTransacao = Codigo
					,@cTipoUltimaTransacao	 = CabecalhoISO
					,@cStatusUltimaTransacao = Status
					,@cConfirmaPgtoPolicard	 = FormaPagto
			FROM	CBTransacoes WITH(NOLOCK)
			WHERE	Terminal = @sBit041
			ORDER BY Codigo DESC

			/* ATUALIZANDO STATUS DA TRANSACAO ANTERIOR */
			IF (@cTipoUltimaTransacao IN ('0200','0400') AND @cStatusUltimaTransacao = 'P')
				UPDATE CBTransacoes SET Status = 'A' WHERE Codigo = @iCodigoUltimaTransacao
		END
	END
END
