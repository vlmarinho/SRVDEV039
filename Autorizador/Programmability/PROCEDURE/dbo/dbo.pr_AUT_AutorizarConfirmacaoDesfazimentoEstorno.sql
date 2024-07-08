
/*
---------------------------------------------------------------------------
Data........: 06/07/2015
Nome Sistema: Autorizador
Objeto......: pr_AUT_AutorizarConfirmacaoDesfazimentoEstorno
Propósito...: Procedure responsável por processar as requisições de confir-
			  mação, desfazimento e estorno de transações.
--------------------------------------------------------------------------
Criada por:	Luiz Renato
Data: 06/10/2015
CH: 1194 / 212609
---------------------------------------------------------------------------
Data: 08/09/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1843805
Descrição: Projeto ABECS para transações NCR/Scope.
-------------------------------------------------------------------------- 	
*/

CREATE PROCEDURE [dbo].[pr_AUT_AutorizarConfirmacaoDesfazimentoEstorno]
	 @sBit001 VARCHAR(1000) OUT, @sBit002 VARCHAR(1000) OUT, @sBit003 VARCHAR(1000) OUT, @sBit004 VARCHAR(1000) OUT
	,@sBit005 VARCHAR(1000) OUT, @sBit006 VARCHAR(1000) OUT, @sBit007 VARCHAR(1000) OUT, @sBit008 VARCHAR(1000) OUT
	,@sBit009 VARCHAR(1000) OUT, @sBit010 VARCHAR(1000) OUT, @sBit011 VARCHAR(1000) OUT, @sBit012 VARCHAR(1000) OUT
	,@sBit013 VARCHAR(1000) OUT, @sBit014 VARCHAR(1000) OUT, @sBit015 VARCHAR(1000) OUT, @sBit016 VARCHAR(1000) OUT
	,@sBit017 VARCHAR(1000) OUT, @sBit018 VARCHAR(1000) OUT, @sBit019 VARCHAR(1000) OUT, @sBit020 VARCHAR(1000) OUT
	,@sBit021 VARCHAR(1000) OUT, @sBit022 VARCHAR(1000) OUT, @sBit023 VARCHAR(1000) OUT, @sBit024 VARCHAR(1000) OUT
	,@sBit025 VARCHAR(1000) OUT, @sBit026 VARCHAR(1000) OUT, @sBit027 VARCHAR(1000) OUT, @sBit028 VARCHAR(1000) OUT
	,@sBit029 VARCHAR(1000) OUT, @sBit030 VARCHAR(1000) OUT, @sBit031 VARCHAR(1000) OUT, @sBit032 VARCHAR(1000) OUT
	,@sBit033 VARCHAR(1000) OUT, @sBit034 VARCHAR(1000) OUT, @sBit035 VARCHAR(1000) OUT, @sBit036 VARCHAR(1000) OUT
	,@sBit037 VARCHAR(1000) OUT, @sBit038 VARCHAR(1000) OUT, @sBit039 VARCHAR(1000) OUT, @sBit040 VARCHAR(1000) OUT
	,@sBit041 VARCHAR(1000) OUT, @sBit042 VARCHAR(1000) OUT, @sBit043 VARCHAR(1000) OUT, @sBit044 VARCHAR(1000) OUT
	,@sBit045 VARCHAR(1000) OUT, @sBit046 VARCHAR(1000) OUT, @sBit047 VARCHAR(1000) OUT, @sBit048 VARCHAR(1000) OUT
	,@sBit049 VARCHAR(1000) OUT, @sBit050 VARCHAR(1000) OUT, @sBit051 VARCHAR(1000) OUT, @sBit052 VARCHAR(1000) OUT
	,@sBit053 VARCHAR(1000) OUT, @sBit054 VARCHAR(1000) OUT, @sBit055 VARCHAR(1000) OUT, @sBit056 VARCHAR(1000) OUT
	,@sBit057 VARCHAR(1000) OUT, @sBit058 VARCHAR(1000) OUT, @sBit059 VARCHAR(1000) OUT, @sBit060 VARCHAR(1000) OUT
	,@sBit061 VARCHAR(1000) OUT, @sBit062 VARCHAR(1000) OUT, @sBit063 VARCHAR(1000) OUT, @sBit064 VARCHAR(1000) OUT
	,@sBit065 VARCHAR(1000) OUT, @sBit066 VARCHAR(1000) OUT, @sBit067 VARCHAR(1000) OUT, @sBit068 VARCHAR(1000) OUT
	,@sBit069 VARCHAR(1000) OUT, @sBit070 VARCHAR(1000) OUT, @sBit071 VARCHAR(1000) OUT, @sBit072 VARCHAR(1000) OUT
	,@sBit073 VARCHAR(1000) OUT, @sBit074 VARCHAR(1000) OUT, @sBit075 VARCHAR(1000) OUT, @sBit076 VARCHAR(1000) OUT
	,@sBit077 VARCHAR(1000) OUT, @sBit078 VARCHAR(1000) OUT, @sBit079 VARCHAR(1000) OUT, @sBit080 VARCHAR(1000) OUT
	,@sBit081 VARCHAR(1000) OUT, @sBit082 VARCHAR(1000) OUT, @sBit083 VARCHAR(1000) OUT, @sBit084 VARCHAR(1000) OUT
	,@sBit085 VARCHAR(1000) OUT, @sBit086 VARCHAR(1000) OUT, @sBit087 VARCHAR(1000) OUT, @sBit088 VARCHAR(1000) OUT
	,@sBit089 VARCHAR(1000) OUT, @sBit090 VARCHAR(1000) OUT, @sBit091 VARCHAR(1000) OUT, @sBit092 VARCHAR(1000) OUT
	,@sBit093 VARCHAR(1000) OUT, @sBit094 VARCHAR(1000) OUT, @sBit095 VARCHAR(1000) OUT, @sBit096 VARCHAR(1000) OUT
	,@sBit097 VARCHAR(1000) OUT, @sBit098 VARCHAR(1000) OUT, @sBit099 VARCHAR(1000) OUT, @sBit100 VARCHAR(1000) OUT
	,@sBit101 VARCHAR(1000) OUT, @sBit102 VARCHAR(1000) OUT, @sBit103 VARCHAR(1000) OUT, @sBit104 VARCHAR(1000) OUT
	,@sBit105 VARCHAR(1000) OUT, @sBit106 VARCHAR(1000) OUT, @sBit107 VARCHAR(1000) OUT, @sBit108 VARCHAR(1000) OUT
	,@sBit109 VARCHAR(1000) OUT, @sBit110 VARCHAR(1000) OUT, @sBit111 VARCHAR(1000) OUT, @sBit112 VARCHAR(1000) OUT
	,@sBit113 VARCHAR(1000) OUT, @sBit114 VARCHAR(1000) OUT, @sBit115 VARCHAR(1000) OUT, @sBit116 VARCHAR(1000) OUT
	,@sBit117 VARCHAR(1000) OUT, @sBit118 VARCHAR(1000) OUT, @sBit119 VARCHAR(1000) OUT, @sBit120 VARCHAR(1000) OUT
	,@sBit121 VARCHAR(1000) OUT, @sBit122 VARCHAR(1000) OUT ,@sBit123 VARCHAR(1000) OUT, @sBit124 VARCHAR(1000) OUT
	,@sBit125 VARCHAR(1000) OUT, @sBit126 VARCHAR(1000) OUT, @sBit127 VARCHAR(1000) OUT, @sBit128 VARCHAR(1000) OUT
	/* DADOS DE VALIDAÇÃO DE ESTABELECIMENTOS E USUÁRIOS */
	,@iRede				 TINYINT
	,@iEstabelecimento	 INT
	/* INFORMAÇÕES DE RETORNO */
	,@dCreditoDisponivel DECIMAL(15,2)	OUT
	,@sNumeroCartao		 VARCHAR(50)	OUT
	,@sNomeUsuario		 VARCHAR(50)	OUT
	,@sLabelProduto		 VARCHAR(50)	OUT
	,@cBaseOrigem		 CHAR(1)		OUT
	,@iCodTrnOriginal	 BIGINT			OUT
	,@iCodTrnExterna	 BIGINT			OUT
	,@iCodFranquia		 INT			OUT
	,@iResposta			 INT			OUT
	,@iError			 INT			OUT
	,@sErrorMessage		 NVARCHAR(MAX)	OUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE  @iCodTransacao				BIGINT
			,@iCodTransacaoOriginal		BIGINT
			,@iCodTransacaoVenda		BIGINT
			,@iCodCartao				INT
			,@iCodConta					INT
			,@iCodTipoProduto			INT
			,@iCodTipoLancamento		INT
			,@dValorTransacao			DECIMAL(15,2)
			,@dDataTransacao			DATETIME
			,@sBit090Mensagem			VARCHAR(4)
			,@sBit090CodProcessamento	VARCHAR(6)
			,@sBit090NSUTrnOriginal		VARCHAR(6)
			,@cTipoLancamento			CHAR(1)
			,@cTipoStatus				CHAR(1)

	SELECT	 @sBit090Mensagem			= LEFT(@sBit090,4)
			,@sBit090CodProcessamento	= SUBSTRING(@sBit090,5,6)
			,@sBit090NSUTrnOriginal		= SUBSTRING(@sBit090,11,6)
			,@iResposta					= 0
			,@dValorTransacao			= dbo.f_RetornarValor(@sBit004)
			,@iCodTipoLancamento		= CASE WHEN(@sBit001 = '0400') THEN 734
											   WHEN(@sBit001 = '0420' AND LEFT(@sBit090,4) = '0400') THEN 821 -- ALTERAR PARA CODIGO DE LANÇAMENTO DE DESFAZIMENTO DE ESTORNO
											   WHEN(@sBit001 = '0420' AND LEFT(@sBit090,4) = '0200') THEN 820 -- ALTERAR PARA CODIGO DE LANÇAMENTO DE DESFAZIMENTO DE VENDA
										  END
			,@dCreditoDisponivel		= 0
			,@cTipoStatus				= CASE WHEN(@sBit001 = '0400') THEN 'S' ELSE 'D' END
			,@dDataTransacao			= GETDATE()
			,@cBaseOrigem				= ''
			,@iCodTipoProduto			= 0

	SELECT	 @iCodTransacaoOriginal	= T.Codigo
			,@iCodCartao			= T.CodCartao
			,@iCodConta				= C.CntUsrCodigo
			,@iCodTipoProduto		= C.TpoPrdCodigo
			,@sNumeroCartao			= C.Numero
			,@sNomeUsuario			= C.Nome
	FROM	Processadora..TransacoesAutorizadas T WITH(NOLOCK)
			INNER JOIN Processadora..CartoesUsuarios C WITH(NOLOCK) ON (C.CrtUsrCodigo = T.CodCartao)
	WHERE	T.CodEstabelecimento = @iEstabelecimento
			AND T.Valor			 = @dValorTransacao
			AND T.NSUOrigem		 = @sBit090NSUTrnOriginal
			AND CONVERT(VARCHAR(10),T.Data,120) = CONVERT(VARCHAR(10),GETDATE(),120)

	IF (@sBit001 = '0420' AND @sBit090Mensagem = '0400' AND ISNULL(@iCodTransacaoOriginal,0) <> 0)
	BEGIN
		SELECT	 @iCodTransacaoVenda = CodReferencia
				,@cTipoLancamento	 = CASE WHEN (@sBit001 = '0420' AND @sBit090Mensagem = '0400') THEN 'D' ELSE 'C' END
		FROM	Processadora..TransacoesAutorizadas WITH(NOLOCK)
		WHERE	Codigo = @iCodTransacaoOriginal
	END

	EXEC Processadora..pr_PROC_RetornarTipoProdutoCartao @sNumeroCartao, @cBaseOrigem OUT, @iCodTipoProduto OUT, NULL, NULL, NULL, NULL, NULL, @iCodFranquia OUT, @sLabelProduto OUT, NULL

	IF (@iRede = 15)
	BEGIN
		EXEC pr_AUT_AutorizarTransacoes
			 @sBit001 OUT, @sBit002 OUT, @sBit003 OUT, @sBit004 OUT, @sBit005 OUT, @sBit006 OUT, @sBit007 OUT, @sBit008 OUT
			,@sBit009 OUT, @sBit010 OUT, @sBit011 OUT, @sBit012 OUT, @sBit013 OUT, @sBit014 OUT, @sBit015 OUT, @sBit016 OUT
			,@sBit017 OUT, @sBit018 OUT, @sBit019 OUT, @sBit020 OUT, @sBit021 OUT, @sBit022 OUT, @sBit023 OUT, @sBit024 OUT
			,@sBit025 OUT, @sBit026 OUT, @sBit027 OUT, @sBit028 OUT, @sBit029 OUT, @sBit030 OUT, @sBit031 OUT, @sBit032 OUT
			,@sBit033 OUT, @sBit034 OUT, @sBit035 OUT, @sBit036 OUT, @sBit037 OUT, @sBit038 OUT, @sBit039 OUT, @sBit040 OUT
			,@sBit041 OUT, @sBit042 OUT, @sBit043 OUT, @sBit044 OUT, @sBit045 OUT, @sBit046 OUT, @sBit047 OUT, @sBit048 OUT
			,@sBit049 OUT, @sBit050 OUT, @sBit051 OUT, @sBit052 OUT, @sBit053 OUT, @sBit054 OUT, @sBit055 OUT, @sBit056 OUT
			,@sBit057 OUT, @sBit058 OUT, @sBit059 OUT, @sBit060 OUT, @sBit061 OUT, @sBit062 OUT, @sBit063 OUT, @sBit064 OUT
			,@sBit065 OUT, @sBit066 OUT, @sBit067 OUT, @sBit068 OUT, @sBit069 OUT, @sBit070 OUT, @sBit071 OUT, @sBit072 OUT
			,@sBit073 OUT, @sBit074 OUT, @sBit075 OUT, @sBit076 OUT, @sBit077 OUT, @sBit078 OUT, @sBit079 OUT, @sBit080 OUT
			,@sBit081 OUT, @sBit082 OUT, @sBit083 OUT, @sBit084 OUT, @sBit085 OUT, @sBit086 OUT, @sBit087 OUT, @sBit088 OUT
			,@sBit089 OUT, @sBit090 OUT, @sBit091 OUT, @sBit092 OUT, @sBit093 OUT, @sBit094 OUT, @sBit095 OUT, @sBit096 OUT
			,@sBit097 OUT, @sBit098 OUT, @sBit099 OUT, @sBit100 OUT, @sBit101 OUT, @sBit102 OUT, @sBit103 OUT, @sBit104 OUT
			,@sBit105 OUT, @sBit106 OUT, @sBit107 OUT, @sBit108 OUT, @sBit109 OUT, @sBit110 OUT, @sBit111 OUT, @sBit112 OUT
			,@sBit113 OUT, @sBit114 OUT, @sBit115 OUT, @sBit116 OUT, @sBit117 OUT, @sBit118 OUT, @sBit119 OUT, @sBit120 OUT
			,@sBit121 OUT, @sBit122 OUT, @sBit123 OUT, @sBit124 OUT, @sBit125 OUT, @sBit126 OUT, @sBit127 OUT, @sBit128 OUT
			/* DADOS DE VALIDAÇÃO DE ESTABELECIMENTOS E USUÁRIOS */
			,0 -- @bPermiteDigitado
			,0 -- @bPermiteSemSenha
			,0 -- @bSenhaCapturada
			,0 -- @bSenhaValida
			,0 -- @iTipoMeioCaptura
			,@iRede
			,@iEstabelecimento -- @iEstabelecimento
			,0 -- @iCodUsuario
			,0 -- @iCodCartao
			,0 -- @iCodContaUsuario
			,0 -- @iCodCliente
			,0 -- @iCodFranquia
			,0 -- @iCodTipoProduto
			,0 -- @iCodTipoTransacao
			,0 -- @sProvedor
			,0 -- @cBaseOrigem
			/* INFORMAÇÕES DE RETORNO */
			,0 -- @dSaldoDispConta
			,0 -- @dSaldoDispCartao	OUT
			,@iCodTrnExterna	OUT
			,@iResposta			OUT
			,@iError			OUT
			,@sErrorMessage		OUT
	END
	ELSE
	BEGIN
		EXEC pr_AUT_GerarNSUTransacoes @sBit038 OUT, 6

		IF (EXISTS(SELECT 1 FROM Processadora..TransacoesAutorizadas WITH(NOLOCK) WHERE Codigo = @iCodTransacaoOriginal AND Status = 'D'))
			SET @iResposta = 13 /* TRANSAÇÃO JÁ DESFEITA */
		ELSE IF (EXISTS(SELECT 1 FROM Processadora..TransacoesAutorizadas WITH(NOLOCK) WHERE Codigo = @iCodTransacaoOriginal AND Status = 'E'))
			SET @iResposta = 15 /* TRANSAÇÃO JÁ ESTORNADA */
		ELSE
		BEGIN
			IF (@sBit001 IN ('0400','0420'))
			BEGIN
				INSERT INTO Processadora..TransacoesAutorizadas
				SELECT	 CodEstabelecimento
						,CodTipoTransacao
						,CodCartao
						,CodTipoProduto
						,CodTipoMeioCaptura
						,CodRede
						,CodCliente
						,@sBit001
						,@dValorTransacao
						,NULL
						,GETDATE()
						,NULL
						,@sBit007
						,@sBit013
						,@sBit012
						,Terminal
						,Provedor
						,'A'
						,@sBit038
						,@sBit011
						,@sBit127
						,@sBit090NSUTrnOriginal
						,NULL
						,NULL
						,NULL
						,NULL
						,NULL
						,CartaoEMV
						,ModoEntrada
				FROM	Processadora..TransacoesAutorizadas WITH(NOLOCK)
				WHERE	Codigo = @iCodTransacaoOriginal

				SELECT	 @iCodTransacao	  = SCOPE_IDENTITY()
						,@sBit127		  = dbo.f_ZerosEsquerda(CONVERT(VARCHAR,@iCodTransacao),9)

				UPDATE Processadora..TransacoesAutorizadas SET NSUPolicard = @sBit127, CodReferencia = @iCodTransacaoOriginal WHERE Codigo = @iCodTransacao
				UPDATE Processadora..TransacoesAutorizadas SET Status = CASE WHEN(@sBit001 = '0400') THEN 'E' ELSE 'D' END, CodReferencia = @iCodTransacao WHERE Codigo = @iCodTransacaoOriginal

				IF (@sBit001 = '0420' AND @sBit090Mensagem = '0400')
					UPDATE Processadora..TransacoesAutorizadas SET Status = 'A', CodReferencia = NULL WHERE Codigo = @iCodTransacaoVenda

				EXEC Processadora..pr_PROC_AtualizarCreditoDisponivel
						@iCodCartao
					,@iCodConta
					,@iCodTipoProduto
					,@iCodTipoLancamento
					,@iCodTransacao
					,@iCodTransacaoOriginal
					,@dValorTransacao
					,@dCreditoDisponivel OUT
					,@dDataTransacao
					,@cTipoLancamento
					,@cTipoStatus

				IF (@sBit001 = '0400')
					SET @sBit015 = @sBit013
			END
		END
	END

	SET @iCodTrnOriginal = @iCodTransacaoOriginal
END

