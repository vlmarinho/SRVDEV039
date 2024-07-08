
/*
--------------------------------------------------------------------------
Data........: 18/05/2015
Nome Sistema: Autorizador
Objeto......: pr_AUT_ProcessarTransacoes
Propósito...: Procedure responsável por capturar os  dados das transações
			  para validá-los e processar a transação.
--------------------------------------------------------------------------
Data alteração: 10/11/2015
Mudança.......: 1337-225666
Autor: Luiz Renato
--------------------------------------------------------------------------
Data alteração: 18/11/2015
Mudança.......: 1349-225666
Autor: Luiz Renato
--------------------------------------------------------------------------
Data alteração: 29/12/2015
Mudança.......: 1499-235909
Autor: Luiz Renato
--------------------------------------------------------------------------
Data alteração: 31/03/2016
Mudança.......: 239460
Autor: Shuster Roberto
--------------------------------------------------------------------------
Data alteração: 04/10/2016 -- 13:50 hs
Mudança.......: 268725
Autor: Shuster Roberto
--------------------------------------------------------------------------
*/

CREATE PROCEDURE [pr_AUT_ProcessarTransacoes]
	 @Bit001 VARCHAR(1000) OUT, @Bit002 VARCHAR(1000) OUT, @Bit003 VARCHAR(1000) OUT, @Bit004 VARCHAR(1000) OUT
	,@Bit005 VARCHAR(1000) OUT, @Bit006 VARCHAR(1000) OUT, @Bit007 VARCHAR(1000) OUT, @Bit008 VARCHAR(1000) OUT
	,@Bit009 VARCHAR(1000) OUT, @Bit010 VARCHAR(1000) OUT, @Bit011 VARCHAR(1000) OUT, @Bit012 VARCHAR(1000) OUT
	,@Bit013 VARCHAR(1000) OUT, @Bit014 VARCHAR(1000) OUT, @Bit015 VARCHAR(1000) OUT, @Bit016 VARCHAR(1000) OUT
	,@Bit017 VARCHAR(1000) OUT, @Bit018 VARCHAR(1000) OUT, @Bit019 VARCHAR(1000) OUT, @Bit020 VARCHAR(1000) OUT
	,@Bit021 VARCHAR(1000) OUT, @Bit022 VARCHAR(1000) OUT, @Bit023 VARCHAR(1000) OUT, @Bit024 VARCHAR(1000) OUT
	,@Bit025 VARCHAR(1000) OUT, @Bit026 VARCHAR(1000) OUT, @Bit027 VARCHAR(1000) OUT, @Bit028 VARCHAR(1000) OUT
	,@Bit029 VARCHAR(1000) OUT, @Bit030 VARCHAR(1000) OUT, @Bit031 VARCHAR(1000) OUT, @Bit032 VARCHAR(1000) OUT
	,@Bit033 VARCHAR(1000) OUT, @Bit034 VARCHAR(1000) OUT, @Bit035 VARCHAR(1000) OUT, @Bit036 VARCHAR(1000) OUT
	,@Bit037 VARCHAR(1000) OUT, @Bit038 VARCHAR(1000) OUT, @Bit039 VARCHAR(1000) OUT, @Bit040 VARCHAR(1000) OUT
	,@Bit041 VARCHAR(1000) OUT, @Bit042 VARCHAR(1000) OUT, @Bit043 VARCHAR(1000) OUT, @Bit044 VARCHAR(1000) OUT
	,@Bit045 VARCHAR(1000) OUT, @Bit046 VARCHAR(1000) OUT, @Bit047 VARCHAR(1000) OUT, @Bit048 VARCHAR(1000) OUT
	,@Bit049 VARCHAR(1000) OUT, @Bit050 VARCHAR(1000) OUT, @Bit051 VARCHAR(1000) OUT, @Bit052 VARCHAR(1000) OUT
	,@Bit053 VARCHAR(1000) OUT, @Bit054 VARCHAR(1000) OUT, @Bit055 VARCHAR(1000) OUT, @Bit056 VARCHAR(1000) OUT
	,@Bit057 VARCHAR(1000) OUT, @Bit058 VARCHAR(1000) OUT, @Bit059 VARCHAR(1000) OUT, @Bit060 VARCHAR(1000) OUT
	,@Bit061 VARCHAR(1000) OUT, @Bit062 VARCHAR(1000) OUT, @Bit063 VARCHAR(1000) OUT, @Bit064 VARCHAR(1000) OUT
	,@Bit065 VARCHAR(1000) OUT, @Bit066 VARCHAR(1000) OUT, @Bit067 VARCHAR(1000) OUT, @Bit068 VARCHAR(1000) OUT
	,@Bit069 VARCHAR(1000) OUT, @Bit070 VARCHAR(1000) OUT, @Bit071 VARCHAR(1000) OUT, @Bit072 VARCHAR(1000) OUT
	,@Bit073 VARCHAR(1000) OUT, @Bit074 VARCHAR(1000) OUT, @Bit075 VARCHAR(1000) OUT, @Bit076 VARCHAR(1000) OUT
	,@Bit077 VARCHAR(1000) OUT, @Bit078 VARCHAR(1000) OUT, @Bit079 VARCHAR(1000) OUT, @Bit080 VARCHAR(1000) OUT
	,@Bit081 VARCHAR(1000) OUT, @Bit082 VARCHAR(1000) OUT, @Bit083 VARCHAR(1000) OUT, @Bit084 VARCHAR(1000) OUT
	,@Bit085 VARCHAR(1000) OUT, @Bit086 VARCHAR(1000) OUT, @Bit087 VARCHAR(1000) OUT, @Bit088 VARCHAR(1000) OUT
	,@Bit089 VARCHAR(1000) OUT, @Bit090 VARCHAR(1000) OUT, @Bit091 VARCHAR(1000) OUT, @Bit092 VARCHAR(1000) OUT
	,@Bit093 VARCHAR(1000) OUT, @Bit094 VARCHAR(1000) OUT, @Bit095 VARCHAR(1000) OUT, @Bit096 VARCHAR(1000) OUT
	,@Bit097 VARCHAR(1000) OUT, @Bit098 VARCHAR(1000) OUT, @Bit099 VARCHAR(1000) OUT, @Bit100 VARCHAR(1000) OUT
	,@Bit101 VARCHAR(1000) OUT, @Bit102 VARCHAR(1000) OUT, @Bit103 VARCHAR(1000) OUT, @Bit104 VARCHAR(1000) OUT
	,@Bit105 VARCHAR(1000) OUT, @Bit106 VARCHAR(1000) OUT, @Bit107 VARCHAR(1000) OUT, @Bit108 VARCHAR(1000) OUT
	,@Bit109 VARCHAR(1000) OUT, @Bit110 VARCHAR(1000) OUT, @Bit111 VARCHAR(1000) OUT, @Bit112 VARCHAR(1000) OUT
	,@Bit113 VARCHAR(1000) OUT, @Bit114 VARCHAR(1000) OUT, @Bit115 VARCHAR(1000) OUT, @Bit116 VARCHAR(1000) OUT
	,@Bit117 VARCHAR(1000) OUT, @Bit118 VARCHAR(1000) OUT, @Bit119 VARCHAR(1000) OUT, @Bit120 VARCHAR(1000) OUT
	,@Bit121 VARCHAR(1000) OUT, @Bit122 VARCHAR(1000) OUT, @Bit123 VARCHAR(1000) OUT, @Bit124 VARCHAR(1000) OUT
	,@Bit125 VARCHAR(1000) OUT, @Bit126 VARCHAR(1000) OUT, @Bit127 VARCHAR(1000) OUT, @Bit128 VARCHAR(1000) OUT
	,@iResposta INT OUT, @iError INT OUT, @sErrorMessage VARCHAR(MAX) OUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE /* INI: DADOS ESTABELECIMENTO */
			 @sCNPJ					VARCHAR(20)
			,@sNomeEstab			VARCHAR(50)
			,@sEndereco				VARCHAR(50)
			,@sCidade				VARCHAR(30)
			,@sProvedor				VARCHAR(50)
			,@sRelatorioPOS			VARCHAR(1000)
			,@cEstado				CHAR(2)
			,@bPermiteDigitado		BIT
			,@bPermiteSemSenha		BIT
			,@bSenhaCapturada		BIT
			,@bSenhaValida			BIT
			,@iTipoMeioCaptura		TINYINT
			,@iRede					TINYINT
			,@iEstabelecimento		INT
			/* FIM: DADOS ESTABELECIMENTO */
			/* INI: DADOS USUARIO E CARTAO */
			,@iCodUsuario			INT
			,@iCodCartao			INT
			,@iCodContaUsuario		INT
			,@iCodCliente			INT
			,@iCodFranquia			INT
			,@iCodTipoProduto		INT
			,@dSaldoDispCartao		DECIMAL(15,2)
			,@dSaldoDispConta		DECIMAL(15,2)
			,@sNumeroCartao			VARCHAR(50)
			,@sNomeUsuario			VARCHAR(50)
			,@sLabelProduto			VARCHAR(50)
			,@cBaseOrigem			CHAR(1)
			/* FIM: DADOS USUARIO E CARTAO */
			/* INI: DADOS TRANSAÇÃO */
			,@iCodTrnOriginal		BIGINT
			,@iCodTransacaoExterna	BIGINT
			,@iCodTipoTransacao		INT
			,@iQtdParcelas			INT
			,@iQtdTrnDesfazimento	TINYINT
			,@dValorTransacao		DECIMAL(15,2)
			,@dDataTransacao		DATETIME
			,@sSaldoDisponivel		VARCHAR(50)
			,@sValorTransacao		VARCHAR(50)
			,@sCabecalhoTicket		VARCHAR(50)
			,@sRodapeTicket1		VARCHAR(50)
			,@sRodapeTicket2		VARCHAR(50)
			,@sTicketRetorno		VARCHAR(500)
			,@sNroDocumento			VARCHAR(20)
			,@sBit005Aux			VARCHAR(50)
			,@cTipoOeracao			CHAR(2)
			,@bPagtoContas			BIT
			,@dValorMinimoRecarga   DECIMAL(15,2)
			/* FIM: DADOS TRANSAÇÃO */

	SELECT	 @iResposta		 = 0
			,@bPagtoContas	 = 0
			,@dDataTransacao = GETDATE()
			,@iQtdParcelas	 = CASE WHEN(@Bit067 = '') THEN NULL ELSE COALESCE(CONVERT(INT,@Bit067),0) END
			,@sBit005Aux	 = @Bit005

	/* INI: VALIDAÇÃO INICIAL DO ESTABELECIMENTO */
	EXEC pr_AUT_RetornarDadosEstabelecimento
		 @Bit001			/* Cabeçalho ISO */
		,@Bit002			/* Id Cartão para validação do VT */
		,@Bit004			/* Valor para validação do VT */
		,@Bit024			/* Rede */
		,@Bit032			/* Rede */
		,@Bit041			/* Terminal */
		,@Bit042			/* Estabelecimento */
		,@Bit047			/* Informações Terminal */
		,@Bit048			/* Informações Provedor */
		,@Bit090			/* Informações Transação Original */
		,@Bit125			/* NSU Transação Original */
		,@sProvedor			OUT
		,@sCNPJ				OUT
		,@sNomeEstab		OUT
		,@sEndereco			OUT
		,@sCidade			OUT
		,@cEstado			OUT
		,@bPermiteDigitado	OUT
		,@bPermiteSemSenha	OUT
		,@iTipoMeioCaptura	OUT
		,@iRede				OUT
		,@iEstabelecimento	OUT
		,@iResposta			OUT
	/* FIM: VALIDAÇÃO INICIAL DO ESTABELECIMENTO */

	IF (@Bit001 = '0100') /* CONSULTAS E GERAÇÃO DE BOLETOS */
	BEGIN	
		EXEC pr_AUT_GerarBoletos
			 @Bit003
			,@Bit004			
			,@Bit074
			,@iRede
			,@iEstabelecimento
			,@Bit062			OUT
			,@iResposta			OUT	
	END
	ELSE IF (@Bit001 = '0500') /* RELATORIO */
	BEGIN
		EXEC pr_AUT_RelatorioFechamento
			 @Bit041
			,@Bit063
			,@sCNPJ
			,@sNomeEstab
			,@sEndereco
			,@sCidade
			,@cEstado
			,@iEstabelecimento
			,@iRede
			,@Bit062			OUT
			,@iResposta			OUT
	END
	ELSE /* TRANSAÇÕES */
	BEGIN	
		IF (@Bit001 = '0800' AND @iRede <> 15)
			EXEC pr_AUT_AberturaFechamento
				 @Bit003			OUT
				,@Bit012			OUT
				,@Bit013			OUT
				,@iRede
				,@Bit039			OUT
				,@Bit041
				,@iEstabelecimento
				,@Bit048
				,@Bit052			OUT
				,@Bit059			OUT
				,@Bit060			OUT
				,@Bit062			OUT
				,@Bit070
				,@Bit080
				,@Bit091			OUT	/* INDICADOR DE CARGA DE TABELAS */
				,@iResposta			OUT
							
		ELSE
		BEGIN
			IF (@Bit001 = '0200') AND (LTRIM(RTRIM(@Bit002)) = '')
				SET @iResposta = 27 --TIPO RECARGA NAO AUTORIZADA

			IF (@Bit001 = '0200') 
			BEGIN
				/****** TRAVA DE VALOR MÍNIMO DE RECARGA - PARAMETROS DO ACQUIRER ******/
				SELECT @dValorMinimoRecarga = CONVERT(DECIMAL(15,2), Descricao)
				  FROM Acquirer.dbo.ParametroSistema
				 WHERE CodigoParametroSistema = 67
				
				IF @dValorMinimoRecarga > (CONVERT(DECIMAL(15,2), @Bit004)/100)
					SET @iResposta = 28					
			END

			IF (@Bit001 NOT IN ('0202','0402','0400','0420','0600')) /* TRANSAÇÕES DE VENDAS POLICARD */
			BEGIN
				/* INI: VALIDAÇÃO INICIAL DO USUARIO */
				IF (@iResposta = 0 AND @iRede <> 15)
				BEGIN
					EXEC pr_AUT_RetornarDadosUsuario
						 @Bit002
						,@Bit035
						,@Bit045
						,@Bit052
						,@sProvedor
						,@sNumeroCartao		OUT
						,@sNomeUsuario		OUT
						,@sLabelProduto		OUT
						,@cBaseOrigem		OUT
						,@bSenhaCapturada	OUT
						,@bSenhaValida		OUT
						,@iRede
						,@iEstabelecimento
						,@iCodUsuario		OUT
						,@iCodCartao		OUT
						,@iCodContaUsuario	OUT
						,@iCodCliente		OUT
						,@iCodFranquia		OUT
						,@iCodTipoProduto	OUT
						,@dSaldoDispCartao	OUT
						,@dSaldoDispConta	OUT
						,@iResposta			OUT
					
				END
				/* FIM: VALIDAÇÃO INICIAL DO USUARIO */
				
				SELECT	 @iCodTipoTransacao	= dbo.f_RetornarTipoTransacao(@Bit003,@Bit105,@iCodTipoProduto,NULL)
						,@dValorTransacao	= dbo.f_RetornarValor(@Bit004)

				/* INI: AUTORIZAÇÃO DAS TRANSAÇÕES DE VENDA */
				IF (@iResposta = 0)
				BEGIN
					EXEC pr_AUT_GerarNSUTransacoes @Bit038 OUT, 6

					EXEC pr_AUT_AutorizarTransacoes
						 @Bit001 OUT, @Bit002 OUT, @Bit003 OUT, @Bit004 OUT, @Bit005 OUT, @Bit006 OUT, @Bit007 OUT, @Bit008 OUT
						,@Bit009 OUT, @Bit010 OUT, @Bit011 OUT, @Bit012 OUT, @Bit013 OUT, @Bit014 OUT, @Bit015 OUT, @Bit016 OUT
						,@Bit017 OUT, @Bit018 OUT, @Bit019 OUT, @Bit020 OUT, @Bit021 OUT, @Bit022 OUT, @Bit023 OUT, @Bit024 OUT
						,@Bit025 OUT, @Bit026 OUT, @Bit027 OUT, @Bit028 OUT, @Bit029 OUT, @Bit030 OUT, @Bit031 OUT, @Bit032 OUT
						,@Bit033 OUT, @Bit034 OUT, @Bit035 OUT, @Bit036 OUT, @Bit037 OUT, @Bit038 OUT, @Bit039 OUT, @Bit040 OUT
						,@Bit041 OUT, @Bit042 OUT, @Bit043 OUT, @Bit044 OUT, @Bit045 OUT, @Bit046 OUT, @Bit047 OUT, @Bit048 OUT
						,@Bit049 OUT, @Bit050 OUT, @Bit051 OUT, @Bit052 OUT, @Bit053 OUT, @Bit054 OUT, @Bit055 OUT, @Bit056 OUT
						,@Bit057 OUT, @Bit058 OUT, @Bit059 OUT, @Bit060 OUT, @Bit061 OUT, @Bit062 OUT, @Bit063 OUT, @Bit064 OUT
						,@Bit065 OUT, @Bit066 OUT, @Bit067 OUT, @Bit068 OUT, @Bit069 OUT, @Bit070 OUT, @Bit071 OUT, @Bit072 OUT
						,@Bit073 OUT, @Bit074 OUT, @Bit075 OUT, @Bit076 OUT, @Bit077 OUT, @Bit078 OUT, @Bit079 OUT, @Bit080 OUT
						,@Bit081 OUT, @Bit082 OUT, @Bit083 OUT, @Bit084 OUT, @Bit085 OUT, @Bit086 OUT, @Bit087 OUT, @Bit088 OUT
						,@Bit089 OUT, @Bit090 OUT, @Bit091 OUT, @Bit092 OUT, @Bit093 OUT, @Bit094 OUT, @Bit095 OUT, @Bit096 OUT
						,@Bit097 OUT, @Bit098 OUT, @Bit099 OUT, @Bit100 OUT, @Bit101 OUT, @Bit102 OUT, @Bit103 OUT, @Bit104 OUT
						,@Bit105 OUT, @Bit106 OUT, @Bit107 OUT, @Bit108 OUT, @Bit109 OUT, @Bit110 OUT, @Bit111 OUT, @Bit112 OUT
						,@Bit113 OUT, @Bit114 OUT, @Bit115 OUT, @Bit116 OUT, @Bit117 OUT, @Bit118 OUT, @Bit119 OUT, @Bit120 OUT
						,@Bit121 OUT, @Bit122 OUT, @Bit123 OUT, @Bit124 OUT, @Bit125 OUT, @Bit126 OUT, @Bit127 OUT, @Bit128 OUT
						/* DADOS DE VALIDAÇÃO DE ESTABELECIMENTOS E USUÁRIOS */
						,@bPermiteDigitado
						,@bPermiteSemSenha
						,@bSenhaCapturada
						,@bSenhaValida
						,@iTipoMeioCaptura
						,@iRede
						,@iEstabelecimento
						,@iCodUsuario
						,@iCodCartao
						,@iCodContaUsuario
						,@iCodCliente
						,@iCodFranquia
						,@iCodTipoProduto
						,@iCodTipoTransacao
						,@sProvedor
						,@cBaseOrigem
						/* INFORMAÇÕES DE RETORNO */
						,@dSaldoDispConta
						,@dSaldoDispCartao		OUT
						,@iCodTransacaoExterna	OUT
						,@iResposta				OUT
						,@iError				OUT
						,@sErrorMessage			OUT
				END
				
				/* FIM: AUTORIZAÇÃO DAS TRANSAÇÕES DE VENDA */

				/* INI: AUTORIZAÇÃO TRANSAÇÕES CORRESPONDENTE BANCÁRIO */
				/* FIM: AUTORIZAÇÃO TRANSAÇÕES CORRESPONDENTE BANCÁRIO */
			END
			ELSE /* CONFIRMAÇÃO DE TRANSAÇÕES DE VENDA E ESTORNO, DESFAZIMENTO, ESTORNO E SONDA POLICARD */
			BEGIN
				
				/* INI: CONFIRMAÇÃO, DESFAZIMENTO OU ESTORNO DE TRANSAÇÕES */
				IF (@iResposta = 0)
				BEGIN
					EXEC pr_AUT_AutorizarConfirmacaoDesfazimentoEstorno
						 @Bit001 OUT, @Bit002 OUT, @Bit003 OUT, @Bit004 OUT, @Bit005 OUT, @Bit006 OUT, @Bit007 OUT, @Bit008 OUT
						,@Bit009 OUT, @Bit010 OUT, @Bit011 OUT, @Bit012 OUT, @Bit013 OUT, @Bit014 OUT, @Bit015 OUT, @Bit016 OUT
						,@Bit017 OUT, @Bit018 OUT, @Bit019 OUT, @Bit020 OUT, @Bit021 OUT, @Bit022 OUT, @Bit023 OUT, @Bit024 OUT
						,@Bit025 OUT, @Bit026 OUT, @Bit027 OUT, @Bit028 OUT, @Bit029 OUT, @Bit030 OUT, @Bit031 OUT, @Bit032 OUT
						,@Bit033 OUT, @Bit034 OUT, @Bit035 OUT, @Bit036 OUT, @Bit037 OUT, @Bit038 OUT, @Bit039 OUT, @Bit040 OUT
						,@Bit041 OUT, @Bit042 OUT, @Bit043 OUT, @Bit044 OUT, @Bit045 OUT, @Bit046 OUT, @Bit047 OUT, @Bit048 OUT
						,@Bit049 OUT, @Bit050 OUT, @Bit051 OUT, @Bit052 OUT, @Bit053 OUT, @Bit054 OUT, @Bit055 OUT, @Bit056 OUT
						,@Bit057 OUT, @Bit058 OUT, @Bit059 OUT, @Bit060 OUT, @Bit061 OUT, @Bit062 OUT, @Bit063 OUT, @Bit064 OUT
						,@Bit065 OUT, @Bit066 OUT, @Bit067 OUT, @Bit068 OUT, @Bit069 OUT, @Bit070 OUT, @Bit071 OUT, @Bit072 OUT
						,@Bit073 OUT, @Bit074 OUT, @Bit075 OUT, @Bit076 OUT, @Bit077 OUT, @Bit078 OUT, @Bit079 OUT, @Bit080 OUT
						,@Bit081 OUT, @Bit082 OUT, @Bit083 OUT, @Bit084 OUT, @Bit085 OUT, @Bit086 OUT, @Bit087 OUT, @Bit088 OUT
						,@Bit089 OUT, @Bit090 OUT, @Bit091 OUT, @Bit092 OUT, @Bit093 OUT, @Bit094 OUT, @Bit095 OUT, @Bit096 OUT
						,@Bit097 OUT, @Bit098 OUT, @Bit099 OUT, @Bit100 OUT, @Bit101 OUT, @Bit102 OUT, @Bit103 OUT, @Bit104 OUT
						,@Bit105 OUT, @Bit106 OUT, @Bit107 OUT, @Bit108 OUT, @Bit109 OUT, @Bit110 OUT, @Bit111 OUT, @Bit112 OUT
						,@Bit113 OUT, @Bit114 OUT, @Bit115 OUT, @Bit116 OUT, @Bit117 OUT, @Bit118 OUT, @Bit119 OUT, @Bit120 OUT
						,@Bit121 OUT, @Bit122 OUT ,@Bit123 OUT, @Bit124 OUT, @Bit125 OUT, @Bit126 OUT, @Bit127 OUT, @Bit128 OUT
						,@iRede
						,@iEstabelecimento
						/* INFORMAÇÕES DE RETORNO */
						,@dSaldoDispCartao		OUT
						,@sNumeroCartao			OUT
						,@sNomeUsuario			OUT
						,@sLabelProduto			OUT
						,@cBaseOrigem			OUT
						,@iCodTrnOriginal		OUT
						,@iCodTransacaoExterna	OUT
						,@iCodFranquia			OUT
						,@iResposta				OUT
						,@iError				OUT
						,@sErrorMessage			OUT
				END
				ELSE
				BEGIN
					
					/* INI: CONTROLE DE DESFAZIMENTO DE TRANSAÇÕES */
					SELECT	@iQtdTrnDesfazimento = COUNT(*)
					FROM	ControleDesfazimento WITH(NOLOCK)
					WHERE	Rede				= @iRede
							AND TipoMensagem	= @Bit001
							AND Terminal		= @Bit041
							AND Estabelecimento = @Bit042
							AND NsuTrnOriginal	= SUBSTRING(@Bit090,5,6)
							AND CONVERT(VARCHAR,DataHora,112) = CONVERT(VARCHAR,GETDATE(),112)

					IF (@Bit001 = '0420' AND COALESCE(@iQtdTrnDesfazimento,0) <= 2)
						INSERT INTO ControleDesfazimento
							SELECT	 GETDATE()
									,@Bit001
									,@Bit041
									,@Bit042
									,@iRede
									,@Bit011
									,SUBSTRING(@Bit090,5,6)
									,@Bit004
									,@Bit012
									,@Bit013
									,NULL
					/* FIM: CONTROLE DE DESFAZIMENTO DE TRANSAÇÕES */
				END
				/* FIM: CONFIRMAÇÃO, DESFAZIMENTO OU ESTORNO DE TRANSAÇÕES */
			END
		END
			
		/* INI: RETORNAR TICKETS DE TRANSAÇÕES */
		IF (@Bit001 IN ('0200','0210','0400','0410') AND @iResposta = 0)
		BEGIN			
			IF (@Bit005 = '') SET @Bit005 = @sBit005Aux

			EXEC pr_AUT_RetornarTicketTransacao
				 @Bit001
				,@Bit004
				,@Bit005
				,@Bit011
				,@Bit038
				,@Bit041
				,@Bit062 OUT
				,@Bit067
				,@Bit127
				,@sCNPJ
				,@sNumeroCartao
				,@sNroDocumento
				,@sLabelProduto
				,@sNomeUsuario
				,@sNomeEstab
				,@sEndereco
				,@sCidade
				,@cEstado
				,@bPagtoContas
				,@dSaldoDispCartao
				,@iRede
				,@iEstabelecimento
				,@iCodTransacaoExterna
		END
		/* FIM: RETORNAR TICKETS DE TRANSAÇÕES */
	END

	IF (@iRede <> 0)
	BEGIN
		--IF (@Bit001 <> '0800')
		--	IF (@iResposta <> 0)
		--		SELECT @Bit039 = CodPolicard, @Bit062 = 'D' + DescricaoPolicard FROM CodigosResposta WITH(NOLOCK) WHERE Codigo = @iResposta
		SELECT @Bit039 = CodPolicard
		     , @Bit062 = CASE WHEN(@Bit062 <> '') THEN @Bit062 
			                                      ELSE 'D' + DescricaoPolicard 
						 END 
		  FROM CodigosResposta WITH(NOLOCK) 
		 WHERE codigo = @iResposta 
	END

	/* INI: INSERT NA TABELA TRANSAÇÕES NEGADAS 
	IF (@iResposta <> 0)
	BEGIN
		EXEC pr_AUT_CargaTransacoesNegadas
			 @Bit001
			,@Bit004
			,@Bit007
			,@Bit011
			,@Bit012
			,@Bit013
			,@Bit022
			,@Bit038
			,@Bit041
			,@Bit048
			,@Bit052
			,@Bit090
			,@Bit127
			,@cBaseOrigem
			,@iTipoMeioCaptura
			,@iRede
			,@iQtdParcelas
			,@iCodTrnOriginal
			,@iEstabelecimento
			,@iCodTipoTransacao
			,@iCodCartao
			,@iCodTipoProduto
			,@iCodCliente
			,@iCodFranquia
			,@iResposta
			,@bSenhaCapturada
			,@bSenhaValida
			,@dDataTransacao
	END*/
	/* FIM: INSERT NA TABELA TRANSAÇÕES NEGADAS */

	EXEC pr_AUT_RetornarBitsIso
		 @Bit001 OUT, @Bit002 OUT, @Bit003 OUT, @Bit004 OUT, @Bit005 OUT, @Bit006 OUT, @Bit007 OUT, @Bit008 OUT
		,@Bit009 OUT, @Bit010 OUT, @Bit011 OUT, @Bit012 OUT, @Bit013 OUT, @Bit014 OUT, @Bit015 OUT, @Bit016 OUT
		,@Bit017 OUT, @Bit018 OUT, @Bit019 OUT, @Bit020 OUT, @Bit021 OUT, @Bit022 OUT, @Bit023 OUT, @Bit024 OUT
		,@Bit025 OUT, @Bit026 OUT, @Bit027 OUT, @Bit028 OUT, @Bit029 OUT, @Bit030 OUT, @Bit031 OUT, @Bit032 OUT
		,@Bit033 OUT, @Bit034 OUT, @Bit035 OUT, @Bit036 OUT, @Bit037 OUT, @Bit038 OUT, @Bit039 OUT, @Bit040 OUT
		,@Bit041 OUT, @Bit042 OUT, @Bit043 OUT, @Bit044 OUT, @Bit045 OUT, @Bit046 OUT, @Bit047 OUT, @Bit048 OUT
		,@Bit049 OUT, @Bit050 OUT, @Bit051 OUT, @Bit052 OUT, @Bit053 OUT, @Bit054 OUT, @Bit055 OUT, @Bit056 OUT
		,@Bit057 OUT, @Bit058 OUT, @Bit059 OUT, @Bit060 OUT, @Bit061 OUT, @Bit062 OUT, @Bit063 OUT, @Bit064 OUT
		,@Bit065 OUT, @Bit066 OUT, @Bit067 OUT, @Bit068 OUT, @Bit069 OUT, @Bit070 OUT, @Bit071 OUT, @Bit072 OUT
		,@Bit073 OUT, @Bit074 OUT, @Bit075 OUT, @Bit076 OUT, @Bit077 OUT, @Bit078 OUT, @Bit079 OUT, @Bit080 OUT
		,@Bit081 OUT, @Bit082 OUT, @Bit083 OUT, @Bit084 OUT, @Bit085 OUT, @Bit086 OUT, @Bit087 OUT, @Bit088 OUT
		,@Bit089 OUT, @Bit090 OUT, @Bit091 OUT, @Bit092 OUT, @Bit093 OUT, @Bit094 OUT, @Bit095 OUT, @Bit096 OUT
		,@Bit097 OUT, @Bit098 OUT, @Bit099 OUT, @Bit100 OUT, @Bit101 OUT, @Bit102 OUT, @Bit103 OUT, @Bit104 OUT
		,@Bit105 OUT, @Bit106 OUT, @Bit107 OUT, @Bit108 OUT, @Bit109 OUT, @Bit110 OUT, @Bit111 OUT, @Bit112 OUT
		,@Bit113 OUT, @Bit114 OUT, @Bit115 OUT, @Bit116 OUT, @Bit117 OUT, @Bit118 OUT, @Bit119 OUT, @Bit120 OUT
		,@Bit121 OUT, @Bit122 OUT, @Bit123 OUT, @Bit124 OUT, @Bit125 OUT, @Bit126 OUT, @Bit127 OUT, @Bit128 OUT
		,@iRede, @iResposta

	IF (@Bit001 IN ('0420','0430'))
	BEGIN
		IF (@iresposta <> 0)
		BEGIN
			IF (@iQtdTrnDesfazimento < 2)
				SET @Bit039 = '92'
			ELSE
				SET @Bit039 = '00'
		END
	END
		
	SELECT @Bit039 = COALESCE(CodPolicard,99)
	     , @Bit062 = Descricao
	  FROM CodigosResposta CER
	 WHERE CodPolicard = CONVERT(CHAR(2), @iResposta)
	
	IF @iResposta = 28	
		SET @Bit062 = REPLACE( @Bit062,'@VALOR',  @dValorMinimoRecarga )
					
	/* INI: CARGA DADOS SMS */
	IF (@iResposta = 0 AND @Bit001 NOT IN ('0800','0500','0600','0810','0510','0610'))
	BEGIN
		IF EXISTS (SELECT 1 FROM UsuarioPermiteSMS WITH(NOLOCK) WHERE CodCartao = @iCodCartao AND Franquia = @iCodFranquia AND Base = @cBaseOrigem)
		BEGIN
			SELECT	 @iQtdParcelas		= COALESCE(CONVERT(INT,@Bit067),1)
					,@dDataTransacao	= GETDATE()
					,@dValorTransacao	= dbo.f_RetornarValor(@Bit004)

			EXEC pr_AUT_CargaInformacoesEnvioSMS
				 @iCodCartao
				,@iCodFranquia
				,@iQtdParcelas
				,@dValorTransacao
				,@dSaldoDispCartao
				,@dDataTransacao
				,@sNumeroCartao
				,@sNomeEstab
				,@cBaseOrigem
				,@Bit001
		END
	END
	/* FIM: CARGA DADOS SMS */
		
	IF @Bit001 = '0100' SET @Bit001 = '0110'
	ELSE IF @Bit001 = '0200' SET @Bit001 = '0210'
	ELSE IF @Bit001 = '0400' SET @Bit001 = '0410'
	ELSE IF @Bit001 = '0420' SET @Bit001 = '0430'
	ELSE IF @Bit001 = '0500' SET @Bit001 = '0510'
	ELSE IF @Bit001 = '0800' SET @Bit001 = '0810'

END



