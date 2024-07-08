

/*
--------------------------------------------------------------------------
Data........: 18/05/2015
Nome Sistema: Autorizador
Objeto......: pr_AUT_RetornarDadosEstabelecimento
Propósito...: Procedure responsável por  retornar os dados  para validação
			  do Estabelecimento.
--------------------------------------------------------------------------
Data alteração: 10/11/2015 -- 08:33 hs
Mudança.......: 1337-225666
autor: Luiz
--------------------------------------------------------------------------
Data alteração: 18/11/2015 -- 09:30 hs
Mudança.......: 1349-225666
autor: Luiz
--------------------------------------------------------------------------
Data alteração: 24/11/2015 -- 22:58 hs
Mudança.......: 229199 / 1394
autor: Luiz
--------------------------------------------------------------------------
Data alteração: 29/12/2015 -- 22:35 hs
Mudança.......: 235909 / 1499
autor: Luiz
--------------------------------------------------------------------------
Data alteração: 04/10/2016 -- 13:50 hs
Mudança.......: 268725
Autor: Shuster Roberto
--------------------------------------------------------------------------
Data alteração: 21/02/2017
Mudança.......: 355660 - Ajuste de mudança 2601
Autor: Shuster Roberto
--------------------------------------------------------------------------
Data alteração: 14/03/2017
Mudança.......: 363857  / 2667- Retirada da consulta do iRede 
Autor: Rafael A. M. Borges
--------------------------------------------------------------------------
Data Alteracao: 21/09/2017
Autor: Cristiano Barbosa
CH: 410827 - 3239
--------------------------------------------------------------------------

*/

CREATE PROCEDURE [dbo].[pr_AUT_RetornarDadosEstabelecimento]
	 @sBit001			VARCHAR(20)		-- Cabeçalho ISO
	,@sBit002			VARCHAR(20)		-- Id Cartão para validação do VT
	,@sBit004			VARCHAR(20)		-- Valor para validação do VT
	,@sBit024			VARCHAR(20)		-- Rede
	,@sBit032			VARCHAR(20)		-- Rede
	,@sBit041			VARCHAR(8)		-- Terminal
	,@sBit042			VARCHAR(20)		-- Estabelecimento
	,@sBit047			VARCHAR(200)	-- Informações Terminal
	,@sBit048			VARCHAR(200)	-- Informações Provedor
	,@sBit090			VARCHAR(200)	-- Informações Provedor
	,@sBit125			VARCHAR(10)		-- NSU Transação Original
	,@sProvedor			VARCHAR(50)		= NULL OUT
	,@sCNPJ				VARCHAR(20)		= NULL OUT
	,@sNome				VARCHAR(30)		= NULL OUT
	,@sEndereco			VARCHAR(50)		= NULL OUT
	,@sCidade			VARCHAR(30)		= NULL OUT
	,@cEstado			CHAR(2)			= NULL OUT
	,@bPermiteDigitado	BIT				= NULL OUT
	,@bPermiteSemSenha	BIT				= NULL OUT
	,@iTipoMeioCaptura	TINYINT			= NULL OUT
	,@iRede				TINYINT			= NULL OUT
	,@iEstabelecimento	INT				= NULL OUT
	,@bPrePago			BIT				= NULL OUT
	,@iResposta			INT				= NULL OUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE  @dLimiteEstab		DECIMAL(15,2)
			,@dSaldoUtilizado	DECIMAL(15,2)
			,@dValorTransacao	DECIMAL(15,2)
			,@iStatus			TINYINT
			,@iStatusVT			TINYINT
			,@iCodTrnExterna	BIGINT
			,@iEstabAux			INT
			,@bRestringeRede	BIT
			,@bPontoVT			BIT
			,@sTerminalExt		VARCHAR(20)
			,@sEstabExterno		VARCHAR(20)
			,@sNumSerieSam		VARCHAR(20)

	SELECT	 @iResposta			= 0
			,@iStatus			= 0
			,@iCodTrnExterna	= 0
			,@bRestringeRede	= 1
			,@iEstabelecimento	= dbo.f_RetornarEstabelecimento(@sBit042)
			--,@iRede				= dbo.f_RetornarRede(@sBit024,@sBit032)
			,@dValorTransacao	= COALESCE(dbo.f_RetornarValor(@sBit004),0)

	IF (@iEstabelecimento > 0)
	BEGIN
		SET @sProvedor = CASE WHEN(@iRede = 4) THEN 'POS WALK'
							  WHEN(@iRede = 5) THEN 'CIELO'
						 ELSE @sBit048 END
		SET @iEstabAux = 0
		
		SELECT	 @iStatus			= E.CodigoEntidadeStatus
				,@sCNPJ				= CASE  WHEN(E.Cnpj IS NOT NULL) THEN dbo.f_FormatarCNPJCPF(E.Cnpj,'CNPJ')
											WHEN(E.Cnpj IS NULL AND E.Cpf IS NOT NULL) THEN dbo.f_FormatarCNPJCPF(E.Cpf,'CPF')
									  ELSE NULL END
				,@sNome				= LTRIM(RTRIM(dbo.f_RemoverAcentos(E.Nome)))
				,@sEndereco			= dbo.f_RemoverAcentos(TL.Descricao) + ' ' + LTRIM(RTRIM(dbo.f_RemoverAcentos(EE.Logradouro))) + ', ' + LTRIM(RTRIM(EE.Numero))
				,@sCidade			= LTRIM(RTRIM(dbo.f_RemoverAcentos(EE.Cidade)))
				,@cEstado			= LTRIM(RTRIM(EE.UF))
				,@bPermiteDigitado	= COALESCE(ECA.TransacaoDigitada,0)
				,@bPermiteSemSenha	= COALESCE(ECA.TransacaoSemSenha,0)
				,@iTipoMeioCaptura	= MC.CodigoTipoMeioCaptura
				,@dLimiteEstab		= ISNULL(ES.LimiteLiberado,0)
				,@dSaldoUtilizado	= ISNULL(ES.SaldoAtual,0)
				,@iEstabAux			= E.CodigoEstabelecimento
				,@bPontoVT			= ES.PontoRecargaVT
				,@bPrePago			= ISNULL(ES.PrePago,0)
				,@iStatusVT			= ES.CodigoStatus
				,@sTerminalExt		= COALESCE(MC.CodTerminalExterno,'')
				,@sEstabExterno		= COALESCE(MC.CodLojaExterno,'')
				,@sNumSerieSam		= MC.NumeroSerieSam
		FROM	Acquirer..Estabelecimento E WITH(NOLOCK)
		LEFT JOIN Acquirer..EstabelecimentoServicos ES WITH(NOLOCK) ON (ES.CodigoEstabelecimento = E.CodigoEstabelecimento)
		INNER JOIN Acquirer..EstabelecimentoMeioCaptura EMC WITH(NOLOCK) ON (EMC.CodigoEstabelecimento = E.CodigoEstabelecimento)
		INNER JOIN Acquirer..MeioCaptura MC WITH(NOLOCK) ON (MC.CodigoMeioCaptura = EMC.CodigoMeioCaptura)
		INNER JOIN Acquirer..EstabelecimentoEndereco EE WITH(NOLOCK) ON (EE.CodigoEstabelecimento = E.CodigoEstabelecimento AND EE.CodigoTipoEndereco = 1)
		LEFT JOIN Acquirer..TipoLogradouro TL WITH(NOLOCK) ON (TL.CodigoTipoLogradouro = EE.CodigoTipoLogradouro)
		LEFT JOIN Acquirer..EstabelecimentoConfiguracoesAdicionais ECA WITH(NOLOCK) ON (ECA.CodigoEstabelecimento = E.CodigoEstabelecimento)
		WHERE E.CodigoEstabelecimento = @iEstabelecimento
		AND MC.NumeroLogico = @sBit041
		AND EE.CodigoTipoEndereco = 1
								
		IF (@iRede = 21)
		BEGIN
			SELECT @sBit047 = dbo.f_AUT_HexadecimalParaDecimal(RIGHT(@sBit047,8))
						
			IF( @sBit047 <> @sBit047 )
				SET @iResposta = 406 --SAM PDV NAO CADASTRADO
			
			IF ((@sEstabExterno = '' OR @sTerminalExt = '') AND @iResposta = 0 AND @sBit001 <> '0100')
			BEGIN
				IF (@iResposta = 0 AND @sBit001 IN ('0400','0420'))
				BEGIN
					SELECT	@iCodTrnExterna	= TE.Codigo
					FROM	Processadora..TransacoesExternas TE WITH(NOLOCK)
							INNER JOIN Acquirer..EstabelecimentoContaCorrenteVT ECC WITH(NOLOCK) ON (ECC.CodTransacao = TE.Codigo)
					WHERE	TE.Valor				= @dValorTransacao
							AND TE.IdCartaoExterno	= @sBit002
							AND TE.TipoMensagem		IN ('0200','0400')
							AND (TE.NSUOrigem		= RIGHT(@sBit125,6) OR TE.NSUOrigem = SUBSTRING(@sBit090,5,6))
							AND CONVERT(VARCHAR(8),TE.Data,112) = CONVERT(VARCHAR(8), GETDATE(),112)
							AND ECC.Estornado		= 'N'
				END
			END
		END
		
		IF (@iResposta = 0 AND @iRede = 14 AND @iCodTrnExterna = 0 AND @sBit001 IN ('0400','0420'))
			SET @iResposta = 14

		IF (@iEstabAux > 0)
		BEGIN
			IF (@iRede = 21) /* TRAVA DE LIMITE VALE TRANSPORTE */
			BEGIN
				IF (@bPontoVT = 0)
					SET @iResposta = 20

				IF (@iStatusVT IN (2,3))
					SET @iResposta = 1

				IF (@sBit001 = '0200' AND @iResposta = 0)
				BEGIN
					IF (@dSaldoUtilizado < 0)
					BEGIN
						IF (@dLimiteEstab + @dSaldoUtilizado = 0)
							SET @iResposta = 18 /* LIMITE DIÁRIO DO ESTABELECIMENTO EXCEDIDO */
					END

					IF (@dValorTransacao > @dLimiteEstab + @dSaldoUtilizado)
						SET @iResposta = 19 /* SALDO INSUFICIENTE */
				END
			END
		END
		ELSE
			SET @iResposta = 21 /* PROBLEMA CONFIG. ESTAB. */

		SELECT @bRestringeRede = 0 FROM Acquirer..SubRedeEstabelecimento WITH(NOLOCK) WHERE CodigoEstabelecimento = @iEstabelecimento
	END
	ELSE
		SET @iResposta = 2 /* ESTABELECIMENTO INVÁLIDO */ -- ATUAL 116

	IF (@iResposta = 0)
	BEGIN
		IF (@iStatus IN (3,5)) /* ESTABELECIMENTO BLOQUEADO/CANCELADO */ -- ATUAL 331 (VERIFICAR A POSSILIDADE DE SEPARAR CODIGOS PARA BLOQUEADO E CANCELADO)
			SET @iResposta = 1
		ELSE IF (@bRestringeRede = 1) /* ESTABELECIMENTO NAO ASSOCIADO A REDE */ -- ATUAL 277
			SET @iResposta = 3

		IF @iStatusVT NOT IN (1,5)
			SET @iResposta = 21 
	END
END




