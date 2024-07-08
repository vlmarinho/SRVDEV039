 /*
  * Data: 22/07/2022
  * Autor: Adilson Pereira - Up Brasil
  * Chamado: 1885461
  * Descrição: Altera forma de identificação do estabelecimento origem, de número para cnpj
  */
/*
-----------------------------------------------------------------------------------------------------------
Data: 06/11/2023
Autor: Adilson Pereira - Up Brasil
Chamado: 2073246
Descrição: Ajuste passagem de parâmetros para pr_aut_desfaz_trn_convenio: adicionado @cProvedor.
-----------------------------------------------------------------------------------------------------------
*/


CREATE PROCEDURE [dbo].[pr_AUT_AutorizarTransacoesCardSE] (
	@cBit001 VARCHAR(1000) OUTPUT, @cBit002 VARCHAR(1000) OUTPUT, @cBit003 VARCHAR(1000) OUTPUT, @cBit004 VARCHAR(1000) OUTPUT,
	@cBit005 VARCHAR(1000) OUTPUT, @cBit006 VARCHAR(1000) OUTPUT, @cBit007 VARCHAR(1000) OUTPUT, @cBit008 VARCHAR(1000) OUTPUT,
	@cBit009 VARCHAR(1000) OUTPUT, @cBit010 VARCHAR(1000) OUTPUT, @cBit011 VARCHAR(1000) OUTPUT, @cBit012 VARCHAR(1000) OUTPUT,
	@cBit013 VARCHAR(1000) OUTPUT, @cBit014 VARCHAR(1000) OUTPUT, @cBit015 VARCHAR(1000) OUTPUT, @cBit016 VARCHAR(1000) OUTPUT,
	@cBit017 VARCHAR(1000) OUTPUT, @cBit018 VARCHAR(1000) OUTPUT, @cBit019 VARCHAR(1000) OUTPUT, @cBit020 VARCHAR(1000) OUTPUT,
	@cBit021 VARCHAR(1000) OUTPUT, @cBit022 VARCHAR(1000) OUTPUT, @cBit023 VARCHAR(1000) OUTPUT, @cBit024 VARCHAR(1000) OUTPUT,
	@cBit025 VARCHAR(1000) OUTPUT, @cBit026 VARCHAR(1000) OUTPUT, @cBit027 VARCHAR(1000) OUTPUT, @cBit028 VARCHAR(1000) OUTPUT,
	@cBit029 VARCHAR(1000) OUTPUT, @cBit030 VARCHAR(1000) OUTPUT, @cBit031 VARCHAR(1000) OUTPUT, @cBit032 VARCHAR(1000) OUTPUT,
	@cBit033 VARCHAR(1000) OUTPUT, @cBit034 VARCHAR(1000) OUTPUT, @cBit035 VARCHAR(1000) OUTPUT, @cBit036 VARCHAR(1000) OUTPUT,
	@cBit037 VARCHAR(1000) OUTPUT, @cBit038 VARCHAR(1000) OUTPUT, @cBit039 VARCHAR(1000) OUTPUT, @cBit040 VARCHAR(1000) OUTPUT,
	@cBit041 VARCHAR(1000) OUTPUT, @cBit042 VARCHAR(1000) OUTPUT, @cBit043 VARCHAR(1000) OUTPUT, @cBit044 VARCHAR(1000) OUTPUT,
	@cBit045 VARCHAR(1000) OUTPUT, @cBit046 VARCHAR(1000) OUTPUT, @cBit047 VARCHAR(1000) OUTPUT, @cBit048 VARCHAR(1000) OUTPUT,
	@cBit049 VARCHAR(1000) OUTPUT, @cBit050 VARCHAR(1000) OUTPUT, @cBit051 VARCHAR(1000) OUTPUT, @cBit052 VARCHAR(1000) OUTPUT,
	@cBit053 VARCHAR(1000) OUTPUT, @cBit054 VARCHAR(1000) OUTPUT, @cBit055 VARCHAR(1000) OUTPUT, @cBit056 VARCHAR(1000) OUTPUT,
	@cBit057 VARCHAR(1000) OUTPUT, @cBit058 VARCHAR(1000) OUTPUT, @cBit059 VARCHAR(1000) OUTPUT, @cBit060 VARCHAR(1000) OUTPUT,
	@cBit061 VARCHAR(1000) OUTPUT, @cBit062 VARCHAR(1000) OUTPUT, @cBit063 VARCHAR(1000) OUTPUT, @cBit064 VARCHAR(1000) OUTPUT,
	@cBit065 VARCHAR(1000) OUTPUT, @cBit066 VARCHAR(1000) OUTPUT, @cBit067 VARCHAR(1000) OUTPUT, @cBit068 VARCHAR(1000) OUTPUT,
	@cBit069 VARCHAR(1000) OUTPUT, @cBit070 VARCHAR(1000) OUTPUT, @cBit071 VARCHAR(1000) OUTPUT, @cBit072 VARCHAR(1000) OUTPUT,
	@cBit073 VARCHAR(1000) OUTPUT, @cBit074 VARCHAR(1000) OUTPUT, @cBit075 VARCHAR(1000) OUTPUT, @cBit076 VARCHAR(1000) OUTPUT,
	@cBit077 VARCHAR(1000) OUTPUT, @cBit078 VARCHAR(1000) OUTPUT, @cBit079 VARCHAR(1000) OUTPUT, @cBit080 VARCHAR(1000) OUTPUT,
	@cBit081 VARCHAR(1000) OUTPUT, @cBit082 VARCHAR(1000) OUTPUT, @cBit083 VARCHAR(1000) OUTPUT, @cBit084 VARCHAR(1000) OUTPUT,
	@cBit085 VARCHAR(1000) OUTPUT, @cBit086 VARCHAR(1000) OUTPUT, @cBit087 VARCHAR(1000) OUTPUT, @cBit088 VARCHAR(1000) OUTPUT,
	@cBit089 VARCHAR(1000) OUTPUT, @cBit090 VARCHAR(1000) OUTPUT, @cBit091 VARCHAR(1000) OUTPUT, @cBit092 VARCHAR(1000) OUTPUT,
	@cBit093 VARCHAR(1000) OUTPUT, @cBit094 VARCHAR(1000) OUTPUT, @cBit095 VARCHAR(1000) OUTPUT, @cBit096 VARCHAR(1000) OUTPUT,
	@cBit097 VARCHAR(1000) OUTPUT, @cBit098 VARCHAR(1000) OUTPUT, @cBit099 VARCHAR(1000) OUTPUT, @cBit100 VARCHAR(1000) OUTPUT,
	@cBit101 VARCHAR(1000) OUTPUT, @cBit102 VARCHAR(1000) OUTPUT, @cBit103 VARCHAR(1000) OUTPUT, @cBit104 VARCHAR(1000) OUTPUT,
	@cBit105 VARCHAR(1000) OUTPUT, @cBit106 VARCHAR(1000) OUTPUT, @cBit107 VARCHAR(1000) OUTPUT, @cBit108 VARCHAR(1000) OUTPUT,
	@cBit109 VARCHAR(1000) OUTPUT, @cBit110 VARCHAR(1000) OUTPUT, @cBit111 VARCHAR(1000) OUTPUT, @cBit112 VARCHAR(1000) OUTPUT,
	@cBit113 VARCHAR(1000) OUTPUT, @cBit114 VARCHAR(1000) OUTPUT, @cBit115 VARCHAR(1000) OUTPUT, @cBit116 VARCHAR(1000) OUTPUT,
	@cBit117 VARCHAR(1000) OUTPUT, @cBit118 VARCHAR(1000) OUTPUT, @cBit119 VARCHAR(1000) OUTPUT, @cBit120 VARCHAR(1000) OUTPUT,
	@cBit121 VARCHAR(1000) OUTPUT, @cBit122 VARCHAR(1000) OUTPUT ,@cBit123 VARCHAR(1000) OUTPUT, @cBit124 VARCHAR(1000) OUTPUT,
	@cBit125 VARCHAR(1000) OUTPUT, @cBit126 VARCHAR(1000) OUTPUT, @cBit127 VARCHAR(1000) OUTPUT, @cBit128 VARCHAR(1000) OUTPUT,
	@cBaseOrigem CHAR(1) OUTPUT, @iTrnCodigo INT OUTPUT, @iResposta INT OUTPUT
	)
AS
BEGIN
	
	SET NOCOUNT ON;

	
	DECLARE
		 @iCodigoEstabelecimento	BIGINT
		,@iTrnReferencia			INT
		,@iTrnCodigoQrCode			INT
		,@bPermiteDigitado			BIT
		,@bPermiteSemSenha			BIT
		,@bEstabMigrado				BIT
		,@cNome_Estabelecimento		VARCHAR(30)
		,@cCNPJ_Estabelecimento		VARCHAR(20)
		,@cAutorizacao				CHAR(18)
		,@cNumeroCartao				VARCHAR(16)
		,@cStatusTrn				CHAR(1)
		,@dDataHora_Transacao		DATETIME
		,@nValor_Transacao			DECIMAL(15,2)
		,@iMeiCptCodigo				INT
		,@iTipoMeioCaptura			INT
		,@iRedeNumero				INT
		,@iRedeCodigo				INT
		,@cMsgCodigo				VARCHAR(4)
		,@cMsgResposta				VARCHAR(1000)
		,@iLenMsgResposta			INT
		,@cProvedor					VARCHAR(50)
		,@iTempoEspera				INT
		,@iTempoTransacao			INT
		,@iQuantParcelas			INT
		,@sLabelProduto				VARCHAR(50)
		,@sNomeUsuario				VARCHAR(30)
		,@nCreditoDisponivelCartao	DECIMAL(15,2)
		,@iCodResposta				INT
		,@iMes						SMALLINT
		,@iAno						SMALLINT
		,@iFranquia_Usuario			INT
		,@iCliente					INT
		,@iUsuario					INT
		,@nSaldo_Disponivel_Cliente	DECIMAL(15,2)
		,@nSaldo_Disponivel_Usuario	DECIMAL(15,2)
				
	SET @dDataHora_Transacao	= GETDATE()
	SET @cMsgCodigo				= @cBit001
	SET @iResposta				= 0
	SET @bPermiteDigitado		= 0
	SET @bPermiteSemSenha		= 0
	SET @iTempoEspera			= 0
	SET @iTempoTransacao		= 0
	SET @bEstabMigrado			= 0
	SET @iCodigoEstabelecimento	= 0
	SET @cBit041                = CONVERT(CHAR(8),@cBit041)
	SET @cBit042				= REPLACE(@cBit042,'.','')
	SET @cMsgResposta			= 'APROVADO'
	SET @nSaldo_Disponivel_Cliente = 0
	SET @nSaldo_Disponivel_Usuario = 0

	IF (@cBit004 <> '')
		SET @nValor_Transacao = CONVERT(DECIMAL(15,2),@cBit004)/100

	SET @iRedeNumero = CASE WHEN CONVERT(BIGINT, @cBit032) IN (58, 13, 14, 15, 31) THEN CONVERT(BIGINT, @cBit032)
							WHEN CONVERT(BIGINT, @cBit032) = 6142 AND @cBit001 <> '0800' THEN 10 /*Abertura de POS Walk envia Bit32 = 6142*/				  
							WHEN CONVERT(BIGINT, @cBit032) NOT IN (6142, 58, 31) AND CONVERT(BIGINT, @cBit024) IN (SELECT Numero FROM Acquirer.dbo.SubRede WITH(NOLOCK)) THEN CONVERT(BIGINT, @cBit024)
							WHEN @cBit123 LIKE 'SCOPE%' THEN 7
						ELSE 0 END
						
	SELECT @iRedeCodigo = CodigoSubRede FROM Acquirer.dbo.SubRede WITH (NOLOCK) WHERE Numero = @iRedeNumero
	
	/*Provedor para monitoramento de Senha valida*/
	SET @cProvedor = CASE WHEN @iRedeNumero = 58 THEN 'POS WALK'
						  WHEN @iRedeNumero = 10 THEN 'CIELO'
						  WHEN @iRedeNumero = 29 THEN 'REDE'
						  WHEN @iRedeNumero = 31 THEN 'STONE'
						  WHEN @iRedeNumero = 44 THEN 'CardSE'
						  WHEN @cBit123 LIKE 'SCOPE%' THEN 'SCOPEPRIVATE'   
					  ELSE @cBit048 END

	IF @cMsgCodigo IN ('0200','0201')
		SET @cMsgCodigo = '0210'
	ELSE IF @cMsgCodigo = '0202'
		SET @cMsgCodigo = '0212'
	ELSE IF @cMsgCodigo = '0400'
		SET @cMsgCodigo = '0410'
	ELSE IF @cMsgCodigo = '0402'
		SET @cMsgCodigo = '0412'
	ELSE IF @cMsgCodigo = '0420'
		SET @cMsgCodigo = '0430'
	ELSE IF @cMsgCodigo = '0100'
		SET @cMsgCodigo = '0110'
	ELSE IF @cMsgCodigo = '0800'
		SET @cMsgCodigo = '0810'
	ELSE 
		SET @cMsgCodigo = @cBit001

	

	IF @cMsgCodigo NOT IN ('0110','0212','0210','0402','0410','0412','0430','0610','0810') /* MENSAGEM INVALIDA */
		SET @iResposta = 265 /* MENSAGEM INVALIDA */
	

	/*Validar se o codigo do estabelecimento é numerico*/
	IF (@iResposta = 0 AND ISNUMERIC(@cBit042) = 1 AND @cMsgCodigo <> '0810')
	BEGIN

		DECLARE @sCodigoEstabelecimento VARCHAR(15)
				,@cStatus CHAR(1)
				,@bHabilitadoStone BIT
				,@bHabilitadoSafra BIT 
				,@bHabilitadoGetNet BIT 
				,@bHabilitadoRede BIT 

--=================		
		SET @iCodigoEstabelecimento = NULL;
		SELECT @iCodigoEstabelecimento = e.CodigoEstabelecimento
			,@cStatus = CASE e.CodigoEntidadeStatus
				WHEN 1
					THEN 'A'
				WHEN 2
					THEN 'I'
				WHEN 3
					THEN 'C'
				WHEN 4
					THEN 'P'
				WHEN 6
					THEN 'B'
				END
			,@bEstabMigrado = 1
		FROM Acquirer.dbo.Estabelecimento AS e WITH(NOLOCK)
		WHERE e.Cnpj = RIGHT(@cBit042, 14);
	
		IF ISNULL(@iCodigoEstabelecimento, 0) = 0 
		BEGIN
			SELECT TOP 1 @iCodigoEstabelecimento=cs.Code
				,@cStatus=cs.Status
				,@bEstabMigrado=0
			FROM Processadora.dbo.CE_Store AS cs WITH(NOLOCK)
			WHERE cs.TaxpayerIdentificationNumber = RIGHT(@cBit042, 14)
			ORDER BY cs.Status;		
		END 
--=================				
			
		IF (@iCodigoEstabelecimento = 0 OR @iCodigoEstabelecimento IS NULL)
			SET @iResposta = 116

		IF (@cMsgCodigo IN ('0110','0210','0410') AND @iResposta = 0 AND @cStatus <> 'A')
			SET @iResposta = 320

	END
	ELSE IF (@cMsgCodigo = '0810')
	BEGIN
	
		SET @cBit039 = '00'
		SET @cBit062 = ''
		
		GOTO Trn_ECO /*Vai direto pro final da procedure*/
		
	END 
	ELSE
		SET @iResposta = 116

	
	/*Executa Validacao do estabelecimento e meios de captura */
	IF (@iResposta = 0)
	BEGIN

		DECLARE  
			 @cEndereco_Estabelecimento	VARCHAR(50)
			,@cCidade_Estabelecimento	VARCHAR(30)
			,@cEstado_Estabelecimento	CHAR(2)
			,@iEstCodigo				INT
		
		EXEC pr_aut_VerificaEstabelecimentoMeioCaptura 		 
			 @cBit001
			,@cBit041
			,@cBit047
			,@iRedeNumero
			,@iCodigoEstabelecimento
			,@bEstabMigrado
			,@cProvedor		
			,@iEstCodigo					OUTPUT
			,@cCNPJ_Estabelecimento			OUTPUT
			,@cNome_Estabelecimento			OUTPUT
			,@cEndereco_Estabelecimento		OUTPUT
			,@cCidade_Estabelecimento		OUTPUT
			,@cEstado_Estabelecimento		OUTPUT
			,@bPermiteDigitado				OUTPUT
			,@bPermiteSemSenha				OUTPUT
			,@iTipoMeioCaptura				OUTPUT
			,@iMeiCptCodigo					OUTPUT
			,@iResposta						OUTPUT

	END

	IF(@iResposta = 0)
	BEGIN

		IF (@cBit001 NOT IN ('0201','0202','0402'))
		BEGIN

			IF (@cMsgCodigo = '0110')
			BEGIN

				DECLARE @cDadosQrCode VARCHAR(1000)
					,@cIdTag		VARCHAR(3)
					,@cLenTag		VARCHAR(3)
					,@cValueTag		VARCHAR(1000)
					,@cAux			VARCHAR(1000)
					,@iLenAux		INT
					,@cIdGlobal		VARCHAR(14)
					,@cDataHoraTrn	VARCHAR(12)

				DECLARE @vTableTag TABLE (IdTag CHAR(2),LenTag CHAR(2),ValueTag VARCHAR(1000))

				SET @cAutorizacao = [dbo].[f_GerarAutorizacao]()
				SET @cBit038 = RIGHT(@cAutorizacao, 6)
		
				SET @cBit047 = '259'

				SET @cDadosQrCode = ''

				INSERT INTO @vTableTag
				SELECT IDTAG
				,TamanhoTag
				,TagValue 
				FROM TagQrCode WITH(NOLOCK)
				WHERE IdTag IN ('00', '01','26','53','54','58','59','70','81')
				ORDER BY IdTag ASC


				WHILE EXISTS (SELECT 1 FROM @vTableTag)
				BEGIN

					SET @cIdTag = ''
					SET @cLenTag = ''
					SET @cValueTag = ''
					SET @cAux = ''
					SET @iLenAux = 0

					SELECT TOP 1 @cIdTag = IdTag
						,@cLenTag = LenTag
						,@cValueTag = ValueTag
					FROM @vTableTag
					ORDER BY IdTag ASC

					IF (@cIdTag IN('26','54','59','70','81'))
					BEGIN

						IF (@cIdTag = '26')
						BEGIN
							
							SET @cCNPJ_Estabelecimento = REPLACE(REPLACE(REPLACE(@cCNPJ_Estabelecimento,'.',''),'/',''),'-','')


							SET @cDadosQrCode = @cDadosQrCode + @cIdTag 
							SET @iLenAux = LEN(@cValueTag)
							SET @cAux = @cAux + '00' + REPLICATE('0',2 - LEN(@iLenAux)) + CONVERT(VARCHAR(3), @iLenAux) + @cValueTag
							SET @iLenAux = LEN(@cCNPJ_Estabelecimento)
							SET @cAux = @cAux + '01' + REPLICATE('0',2 - LEN(@iLenAux)) + CONVERT(VARCHAR(3), @iLenAux) + LTRIM(RTRIM(@cCNPJ_Estabelecimento))
							SET @iLenAux = LEN(@cBit041)
							SET @cAux = @cAux + '02' + REPLICATE('0',2 - LEN(@iLenAux)) + CONVERT(VARCHAR(3), @iLenAux) + @cBit041
							SET @cAux = @cAux + '03' + '04' + '0001' 
							SET @iLenAux = LEN (@cAux)

							SET @cDadosQrCode = @cDadosQrCode + CONVERT(VARCHAR(3), @iLenAux ) + @cAux

						END
						ELSE IF(@cIdTag = '54')
						BEGIN
	
							SET @iLenAux = LEN (@nValor_Transacao)
							
							SET @cDadosQrCode = @cDadosQrCode + @cIdTag +  REPLICATE ('0', 2 - LEN (@iLenAux)) + CONVERT(VARCHAR(3),@iLenAux) + CONVERT(VARCHAR(13),@nValor_Transacao)
						END
						ELSE IF(@cIdTag = '59')
						BEGIN

							SET @cNome_Estabelecimento = LEFT(REPLACE (@cNome_Estabelecimento,' ','_'),25)

							SET @iLenAux = LEN (@cNome_Estabelecimento)

							SET @cDadosQrCode = @cDadosQrCode + @cIdTag + REPLICATE ('0', 2 - LEN (@iLenAux)) + CONVERT(VARCHAR(3),@iLenAux) + LEFT(@cNome_Estabelecimento,25)

						END
						ELSE IF (@cIdTag = '70')
						BEGIN

							SET @iLenAux = LEN(@cBit011)
							SET @cDadosQrCode = @cDadosQrCode + @cIdTag + REPLICATE ('0', 2 - LEN (@iLenAux)) + CONVERT(VARCHAR(3),@iLenAux) + @cBit011

						END
						ELSE IF(@cIdTag = '81')
						BEGIN

							SET @cIdGlobal = 'br.com.padraoq'
							SET @cDataHoraTrn = SUBSTRING(@cBit007, 3,2) + SUBSTRING(@cBit007,1,2) + RIGHT(DATEPART(YEAR, @dDataHora_Transacao),2) + @cBit012


							SET @cDadosQrCode = @cDadosQrCode + @cIdTag
							SET @iLenAux = LEN(@cIdGlobal)
							SET @cAux = @cAux + '00' + REPLICATE('0',2 - LEN(@iLenAux)) + CONVERT(VARCHAR(3), @iLenAux) + @cIdGlobal -- Globally Unique Identifier
							SET @iLenAux = LEN(@cDataHoraTrn)
							SET @cAux = @cAux + '01' + REPLICATE('0',2 - LEN(@iLenAux)) + CONVERT(VARCHAR(3), @iLenAux) + @cDataHoraTrn -- Transaction Date
							SET @cAux = @cAux + '02' + '04' + '0000' -- Main Product ???? Verifica
							SET @cAux = @cAux + '03' + '02' + '01' -- Numero de Parcelas ???? Verificar
							SET @cAux = @cAux + '04' + '02' + '01' -- Transaction Type - 01 Venda
							SET @cAux = @cAux + '05' + '02' + '03' -- Fonte de dados do pagamento - 03 QrCode

							SET @iLenAux = LEN (@cAux)

							SET @cDadosQrCode = @cDadosQrCode + CONVERT(VARCHAR(3), @iLenAux) + @cAux

						END

					END
					ELSE
					BEGIN
						SET @cDadosQrCode = @cDadosQrCode + @cIdTag + @cLenTag + @cValueTag
					END
					
					DELETE FROM @vTableTag WHERE IdTag = @cIdTag

				END 

				SET @iLenAux = LEN(@cDadosQrCode)

				SET @cBit047 = @cBit047 + CONVERT(VARCHAR(3), @iLenAux) + @cDadosQrCode

				SET @iLenMsgResposta = LEN(@cMsgResposta)
				
				SET @cBit062 = '501' + REPLICATE('0', 3 -  LEN(@iLenMsgResposta)) + CONVERT(VARCHAR(3), @iLenMsgResposta) + @cMsgResposta
				SET @cBit062 = @cBit062 + '505' + REPLICATE('0', 3 -  LEN(@iLenMsgResposta)) + CONVERT(VARCHAR(3), @iLenMsgResposta) + @cMsgResposta

			END
			ELSE IF (@cMsgCodigo = '0210')
			BEGIN
			
				IF (@cBit003 = '006000')
				BEGIN 
					SELECT @cBit038 = Autorizacao 
						,@iTrnReferencia = TrnCodigo
					FROM TransacaoQrCode WITH(NOLOCK) 
					WHERE TipoMensagem = '0110'  --PEGAR O CODIGO DE AUTORIZACAO DA CONSULTA 0110
					AND CONVERT (VARCHAR(10),DataHora, 120) = CONVERT (VARCHAR(10),@dDataHora_Transacao,120) /* Somente transacoes do dia corrente */
					AND CodEstab = @iCodigoEstabelecimento
					AND Valor = @nValor_Transacao
					AND Terminal = @cBit041 
					AND NSUOrigem = @cBit011

					SELECT @iTempoEspera = ISNULL(CD_VALUE,0)
					FROM DBO.FNC_RETORNA_TLV(@cBit047,3)
					WHERE CD_TAG = 260

					SET @cMsgResposta = 'TRANSACAO EM@ANDAMENTO'
					SET @iLenMsgResposta = LEN(@cMsgResposta)
					SET @cBit062 = '501' + REPLICATE('0', 3 -  LEN(@iLenMsgResposta)) + CONVERT(VARCHAR(3), @iLenMsgResposta) + @cMsgResposta
					SET @iResposta = 44
					SET @cBit039 = '77'
					SET @cBit047 = ''

				END 
				--ELSE
				--BEGIN
					
				--	PRINT '<> 006000'

					
				--END


			END
			ELSE IF (@cMsgCodigo IN ('0410','0430'))
			BEGIN

				DECLARE @cMsgCodigoOriginal VARCHAR(4)
					,@cNsuOriginal VARCHAR(6)
					,@cDataOriginal VARCHAR(4)
					,@cHoraOriginal VARCHAR(6)

				SELECT @cMsgCodigoOriginal = CASE WHEN SUBSTRING (@cBit090, 1,4) = '0100' THEN '0110'
												WHEN SUBSTRING (@cBit090, 1,4) = '0200' THEN '0210' END
					,@cNsuOriginal = SUBSTRING (@cBit090, 5,6)
					,@cDataOriginal = SUBSTRING (@cBit090, 11,4)
					,@cHoraOriginal = SUBSTRING (@cBit090, 15,6)

				EXEC pr_aut_BuscaTransacaoCardSE
					 @cBit041
					,@cBit127					OUTPUT
					,@iCodigoEstabelecimento
					,@cNumeroCartao				OUTPUT
					,@sNomeUsuario				OUTPUT
					,@nValor_Transacao
					,@cBaseOrigem				OUTPUT
					,@cStatusTrn				OUTPUT
					,@iResposta					OUTPUT
					,@cNsuOriginal					
					,@iQuantParcelas			OUTPUT
					,@iCodResposta				OUTPUT

				IF (@cMsgCodigo = '0410' AND @cBaseOrigem IN ('C','P'))
				BEGIN

					IF (@cBaseOrigem = 'P')
					BEGIN

						EXEC [dbo].[pr_aut_EstornarProcessadora]
							 @cBit003				OUTPUT	/* Código de Processamento */
							,@cBit004						/* Valor */
							,@cBit007						/* Data e Hora GMT da Transação (MMDDHHMMSS) */
							,@cBit011				OUTPUT	/* NSU do Meio de Captura */
							,@cBit012						/* Hora da Transação (HHMMSS) */
							,@cBit013						/* Data da Transação (MMDD) */
							,@cBit037				OUTPUT	/* NSU da Rede de Captura */
							,@cBit038				OUTPUT	/* NSU Policard - Comprovante Formgen */
							,@cBit039				OUTPUT	/* Codigo de Resposta*/
							,@cBit041						/* Identificação do Terminal */
							,@cBit048				OUTPUT	/* Informações Adicionais */
							,@cBit060     					/* Dados adicionais de terminal */
							,@cBit062				OUTPUT	/* Ticket, via do usuario */
							,@cBit063				OUTPUT	/* Ticket, via do estabelecimento */
							,@cBit090				OUTPUT	/* Dados da Transação a ser Estornada */
							,@cBit105				OUTPUT  /* Informações de Quitação para o produto PoliFrete */
							,@cBit123
							,@cBit127				OUTPUT	/* NSU Policard - Comprovante Formgen */
							,@cNumeroCartao			OUTPUT	/* Número do Cartão */
							,@nValor_Transacao		OUTPUT	/* Valor da Transação */
							,@dDataHora_Transacao			/* Data e Hora Corrente (GETDATE) */
							,@iRedeNumero					/* Código de Identificação da Rede de Captura */
							,@iCodigoEstabelecimento		/* Código de Identificação do Estabelecimento (Filiação) */
							,@bEstabMigrado
							,@iResposta				OUTPUT	/* Código de Resposta Interno */

						IF (@iResposta = 0)
						BEGIN

							SELECT @nCreditoDisponivelCartao = COALESCE(CU.CreditoDisponivel, 0)
								--,@sNomeUsuario = CU.Nome
								,@sLabelProduto = LTRIM(RTRIM(UPPER(COALESCE(TP.Descricao, TP.NOME))))
							FROM Processadora.dbo.CartoesUsuarios CU WITH (HOLDLOCK,ROWLOCK)
							INNER JOIN Processadora.dbo.TiposProdutos TP WITH (NOLOCK) ON (TP.TpoPrdCodigo = CU.TpoPrdCodigo)
							WHERE CU.Numero = @cNumeroCartao
							AND FlagTransferido = 0
					
							SET @sLabelProduto = REPLACE(Autorizador.dbo.f_FormatarTexto(@sLabelProduto), 'CARTAO', '')

							EXEC [dbo].[pr_AUT_RetornarTicketTransacao] '0400'
								,@cBit003
								,@cBit004
								,0
								,@cBit011
								,@cBit038
								,@cBit041
								,@cMsgResposta OUTPUT
								,@iQuantParcelas
								,@cBit127
								,@cCNPJ_Estabelecimento
								,@cNumeroCartao
								,NULL
								,@sLabelProduto
								,@sNomeUsuario
								,@cNome_Estabelecimento
								,@cEndereco_Estabelecimento
								,@cCidade_Estabelecimento
								,@cEstado_Estabelecimento
								,0
								,@nCreditoDisponivelCartao
								,@iRedeNumero
								,@iCodigoEstabelecimento
								,0


							SET @cBit062 = '505' + CONVERT(VARCHAR(3),LEN(@cMsgResposta)) + @cMsgResposta + '506' + CONVERT(VARCHAR(3),LEN (@cMsgResposta)) + @cMsgResposta
							SET @cBit047 = ''
							SET @cBit127 = ''

						END
						ELSE
						BEGIN 
						
							SET @cBit047 = ''
							SET @cBit062 = ''
							SET @cBit127 = ''

						END 

					END
					ELSE IF(@cBaseOrigem = 'C')
					BEGIN

						EXEC [policard_603078].[dbo].[pr_aut_estorna_trn_convenio]
							@cBit003					OUTPUT	/* Código de Processamento */
							,@cBit007							/* Data e Hora GMT da Transação (MMDDHHMMSS) */
							,@cBit011					OUTPUT	/* NSU do Meio de Captura */
							,@cBit012							/* Hora da Transação (HHMMSS) */
							,@cBit013							/* Data da Transação (MMDD) */
							,@cBit037					OUTPUT	/* NSU da Rede de Captura */
							,@cBit038					OUTPUT	/* NSU Policard - Comprovante Formgen */
							,@cBit041					OUTPUT	/* Identificação do Terminal */
							,@cBit048							/* Identificacao responsavel */
							,@cBit062					OUTPUT	/* Ticket, via do usuario */
							,@cBit063					OUTPUT	/* Ticket, via do estabelecimento */
							,@cBit090					OUTPUT	/* Dados da Transação a ser Estornada */
							,@cBit123
							,@cBit125					OUTPUT
							,@cBit127					OUTPUT	/* NSU Policard*/
							,@cNumeroCartao				OUTPUT	/* Número do Cartão */
							,@nValor_Transacao			OUTPUT	/* Valor da Transação */
							,@iRedeNumero						/* Código de Identificação da Rede de Captura */
							,@iCodigoEstabelecimento	OUTPUT	/* Código de Identificação do Estabelecimento (Filiação) */
							,@bEstabMigrado						/* Estabelecimento migrado do acquirer antigo para o novo */
							,@dDataHora_Transacao				/* Data e Hora Corrente (GETDATE) */
							,@iResposta					OUTPUT	/* Código de Resposta Interno */

						IF (@iResposta = 0)
						BEGIN
						
							SELECT 
								@iMes		  = DATEPART(MONTH,@dDataHora_Transacao)
							   ,@iAno		  = DATEPART(YEAR,@dDataHora_Transacao)

							SELECT	 
									 @iFranquia_Usuario		= COALESCE(C.Franquia,0)
									,@iCliente				= COALESCE(C.Cliente,0)
									,@iUsuario				= COALESCE(C.Usuario,0)
							FROM	[policard_603078].[dbo].[Cartao_usuario] C WITH(HOLDLOCK, ROWLOCK)
							INNER JOIN [policard_603078].[dbo].[Franquia] F WITH(NOLOCK)ON F.Codigo = C.Franquia
							WHERE C.CodigoCartao = @cNumeroCartao
							AND C.StsTransferenciaUsuario IS NULL

							EXEC [policard_603078].[dbo].[pr_RetornaSaldoUsuario] @iFranquia_Usuario, @iCliente, @iUsuario, @iAno, @iMes, @nSaldo_Disponivel_Cliente OUTPUT, @nSaldo_Disponivel_Usuario OUTPUT 

							EXEC [Autorizacao].[dbo].[pr_aut_BuscaMensagemTicket] 6, 210000, 7, @cMsgResposta OUT

							SET @cMsgResposta = REPLACE(@cMsgResposta, '<NOME_USUARIO>', @sNomeUsuario)
							SET @cMsgResposta = REPLACE(@cMsgResposta, '<SALDO_DISPONIVEL>', COALESCE(CONVERT(VARCHAR, @nSaldo_Disponivel_Usuario), ''))
															
							SET @cMsgResposta = REPLACE(@cMsgResposta, '<CARTAO>', SUBSTRING(@cNumeroCartao,1,6) + '******' + SUBSTRING(@cNumeroCartao,13,4))
							SET @cMsgResposta = REPLACE(@cMsgResposta, '<CNPJ>', COALESCE(@cCNPJ_Estabelecimento,''))
							SET @cMsgResposta = REPLACE(@cMsgResposta, '<NOME_ESTABELECIMENTO>', @cNome_Estabelecimento)
							SET @cMsgResposta = REPLACE(@cMsgResposta, '<ENDERECO>', COALESCE(@cEndereco_Estabelecimento,''))
							SET @cMsgResposta = REPLACE(@cMsgResposta, '<CIDADE>', COALESCE(@cCidade_Estabelecimento, ''))
							SET @cMsgResposta = REPLACE(@cMsgResposta, '<ESTADO>', COALESCE(@cEstado_Estabelecimento,''))
							SET @cMsgResposta = REPLACE(@cMsgResposta, '<NSU_HOST>', CASE WHEN @iRedeNumero IN (10,58) THEN dbo.f_ZerosEsquerda(@cBit038,6) ELSE @cBit127 END)
							SET @cMsgResposta = REPLACE(@cMsgResposta, '<NSU_LOJA>', COALESCE(@cBit011,''))
							SET @cMsgResposta = REPLACE(@cMsgResposta, '<CODIGO_ESTABELECIMENTO>', CONVERT(VARCHAR,CONVERT(BIGINT, @cBit042)))
							SET @cMsgResposta = REPLACE(@cMsgResposta, '<TERMINAL>', @cBit041)
							SET @cMsgResposta = REPLACE(@cMsgResposta, '<DATA>',dbo.f_ZerosEsquerda(CONVERT(VARCHAR,DAY(GETDATE())), 2) + '/' + dbo.f_ZerosEsquerda(CONVERT(VARCHAR,MONTH(GETDATE())), 2))
							SET @cMsgResposta = REPLACE(@cMsgResposta, '<HORA>', SUBSTRING (CONVERT(VARCHAR, GETDATE(), 108 ),1,5))
							SET @cMsgResposta = REPLACE(@cMsgResposta, '<VALOR>', COALESCE(CONVERT(VARCHAR, CONVERT(DECIMAL(15,2), CONVERT(DECIMAL(15,2),@nValor_Transacao))),''))
							
							SET @cBit062 = '505' + CONVERT(VARCHAR(3),LEN(@cMsgResposta)) + @cMsgResposta + '506' + CONVERT(VARCHAR(3),LEN (@cMsgResposta)) + @cMsgResposta
							SET @cBit047 = ''
							SET @cBit127 = ''
							
						END

					END
					
				END
				ELSE IF (@cMsgCodigo = '0430' AND @cBaseOrigem IN ('C','P'))
				BEGIN

					IF (@cBaseOrigem = 'P')
					BEGIN

						EXEC [dbo].[pr_aut_DesfazerProcessadora]
							 @cNumeroCartao		OUTPUT	/* Número do Cartão */
							,@cBit003			OUTPUT	/* Código de Processamento */
							,@nValor_Transacao	OUTPUT	/* Valor da Transação */
							,@cBit007			
							,@cBit011			OUTPUT	/* NSU do Meio de Captura */
							,@cBit012					/* Hora da Transação (HHMMSS) */
							,@cBit013					/* Data da Transação (MMDD) */
							,@iRedeNumero				/* Código de Identificação da Rede de Captura */
							,@cBit038			OUTPUT	/* NSU Policard - Comprovante Formgen */
							,@cBit041					/* Identificação do Terminal */
							,@iCodigoEstabelecimento	/* Código de identificação do Estabelecimento (Filiação) */
							,@bEstabMigrado				/* Estabelecimento Migrado para o novo Acquirer*/
							,@cProvedor					/* Provedor de origem */
							,@cBit090			OUTPUT	/* Dados da Transação a ser Desfeita */
							,@cBit105			OUTPUT	/* Informações de Quitação para o produto PoliFrete */
							,@iResposta			OUTPUT	/* Código de Resposta Interno */
							,@dDataHora_Transacao		/* Data e Hora Corrente (GETDATE) */
							,@cBit127			OUTPUT	/* Informações de Quitação para o produto PoliFrete */

					END
					ELSE 
					BEGIN

						EXEC [policard_603078].[dbo].[pr_aut_desfaz_trn_convenio]
							 @cBit003					OUTPUT	/* Código de Processamento */
							,@cBit011					OUTPUT	/* NSU do Meio de Captura */
							,@cBit012							/* Hora da Transação (HHMMSS) */
							,@cBit013							/* Data da Transação (MMDD) */
							,@cBit038					OUTPUT	/* NSU Policard - Comprovante Formgen */
							,@cBit041					OUTPUT	/* Identificação do Terminal */
							,@cBit090					OUTPUT	/* Dados da Transação a ser Desfeita */
							,@cBit127
							,@cNumeroCartao				OUTPUT	/* Número do Cartão */
							,@nValor_Transacao			OUTPUT	/* Valor da Transação */
							,@iRedeNumero						/* Código de Identificação da Rede de Captura */
							,@iCodigoEstabelecimento	OUTPUT	/* Código de Identificação do Estabelecimento (Filiação) */
							,@bEstabMigrado
							,@dDataHora_Transacao				/* Data e Hora Corrente (GETDATE) */
							,@iResposta					OUTPUT	/* Código de Resposta Interno */
							,@cProvedor
						
					END
									   					 
					SET @CBIT062 = ''
					SET @cBit127 = ''

				END 

			END

			IF (@cMsgCodigo <> '0430' AND NOT EXISTS (SELECT TOP 1 1 FROM TransacaoQrCode WITH(NOLOCK) WHERE DataLocal = @cBit013 and HoraLocal = @cBit012
							AND TipoMensagem = @cMsgCodigo AND TpoTrnCodigo = @cBit003 AND CodEstab = @iCodigoEstabelecimento 
							AND Valor = @nValor_Transacao AND Terminal = @cBit041 AND NSUOrigem = @cBit011))
			BEGIN

				INSERT INTO TransacaoQrCode (
					 DataHora
					,DataLocal
					,HoraLocal
					,TrnReferencia
					,TipoMensagem
					,TpoTrnCodigo
					,CodEstab
					,MeiCptCodigo
					,RdeCodigo
					,Valor
					,Autorizacao
					,ModoEntrada
					,Provedor
					,Status
					,Terminal
					,NSUOrigem
					,EstabMigrado)
				VALUES (
					 @dDataHora_Transacao
					,@cBit013
					,@cBit012
					,CASE WHEN @iTrnReferencia > 0 THEN @iTrnReferencia ELSE NULL END
					,@cMsgCodigo
					,@cBit003
					,@iCodigoEstabelecimento
					,@iMeiCptCodigo
					,@iRedeCodigo
					,@nValor_Transacao
					,@cBit038--RIGHT(@cAutorizacao, 6)
					,@cBit022
					,@cProvedor
					,CASE WHEN @cMsgCodigo = '0110' THEN 'A' ELSE 'P' END
					,@cBit041
					,@cBit011
					,@bEstabMigrado
				)

				SELECT   @iTrnCodigoQrCode = SCOPE_IDENTITY()

				UPDATE TransacaoQrCode
				SET TrnReferencia = @iTrnCodigoQrCode
				WHERE TrnCodigo = @iTrnReferencia

			END
			ELSE
			BEGIN

				IF (@cMsgCodigo = '0110')
					SET @iResposta =  33 -- Transacao duplicada

				SET @cBit047 = ''

			END
			
		END
		ELSE IF(@cBit001 = '0201')
		BEGIN
	
			EXEC pr_aut_BuscaTransacaoCardSE
				 @cBit041
				,@cBit127					OUTPUT
				,@iCodigoEstabelecimento
				,@cNumeroCartao				OUTPUT
				,@sNomeUsuario				OUTPUT
				,@nValor_Transacao
				,@cBaseOrigem				OUTPUT
				,@cStatusTrn				OUTPUT
				,@iResposta					OUTPUT
				,@cBit011					
				,@iQuantParcelas			OUTPUT
				,@iCodResposta				OUTPUT


			SELECT @iTempoTransacao = ISNULL(CD_VALUE,0)
			FROM DBO.FNC_RETORNA_TLV(@cBit047,3)
			WHERE CD_TAG = 261

			IF (@iResposta = 271 AND @iTempoTransacao > 0)
				SET @iResposta = 44
			
			
			IF (@cStatusTrn <> 'N')
			BEGIN
				SELECT @cBit038 = Autorizacao 
				FROM TransacaoQrCode WITH(NOLOCK) 
				WHERE TipoMensagem = '0210'  --PEGAR O CODIGO DE AUTORIZACAO DA 0210
				AND CONVERT (VARCHAR(10),DataHora, 120) = CONVERT (VARCHAR(10),@dDataHora_Transacao,120) /* Somente transacoes do dia corrente */
				AND CodEstab = @iCodigoEstabelecimento
				AND Valor = @nValor_Transacao
				AND Terminal = @cBit041 
				AND NSUOrigem = @cBit011
			END

			IF (@cStatusTrn = 'N')
			BEGIN
				SET @iResposta = @iCodResposta
			END 

			IF (@iResposta = 0)
			BEGIN 
	
				IF(@cBit038 > 0)
				BEGIN 

					UPDATE A
					SET BaseOrigem = @cBaseOrigem
					FROM TransacaoQrCode A
					WHERE TipoMensagem IN ('0110', '0210')  --PEGAR O CODIGO DE AUTORIZACAO DA 0210
					AND CONVERT (VARCHAR(10),DataHora, 120) = CONVERT (VARCHAR(10),@dDataHora_Transacao,120) /* Somente transacoes do dia corrente */
					AND CodEstab = @iCodigoEstabelecimento
					AND Valor = @nValor_Transacao
					AND Terminal = @cBit041 
					AND NSUOrigem = @cBit011
					--AND [Status] = 'P'

					
				END

				SET @cMsgResposta = 'TRANSACAO@FINALIZADA'
				SET @iLenMsgResposta = LEN(@cMsgResposta)
				SET @cBit062 = '501' + REPLICATE('0', 3 -  LEN(@iLenMsgResposta)) + CONVERT(VARCHAR(3), @iLenMsgResposta) + @cMsgResposta

				SET @cMsgResposta = ''
				
				IF (@cBaseOrigem = 'P')
				BEGIN

					SELECT @nCreditoDisponivelCartao = COALESCE(CU.CreditoDisponivel, 0)
						--,@sNomeUsuario = CU.Nome
						,@sLabelProduto = LTRIM(RTRIM(UPPER(COALESCE(TP.Descricao, TP.NOME))))
					FROM Processadora.dbo.CartoesUsuarios CU WITH (HOLDLOCK,ROWLOCK)
					INNER JOIN Processadora.dbo.TiposProdutos TP WITH (NOLOCK) ON (TP.TpoPrdCodigo = CU.TpoPrdCodigo)
					WHERE CU.Numero = @cNumeroCartao
					AND FlagTransferido = 0
					
					SET @sLabelProduto = REPLACE(Autorizador.dbo.f_FormatarTexto(@sLabelProduto), 'CARTAO', '')

					EXEC [dbo].[pr_AUT_RetornarTicketTransacao] '0200'
							,@cBit003
							,@cBit004
							,0
							,@cBit011
							,@cBit038
							,@cBit041
							,@cMsgResposta OUTPUT
							,@iQuantParcelas
							,@cBit127
							,@cCNPJ_Estabelecimento
							,@cNumeroCartao
							,NULL
							,@sLabelProduto
							,@sNomeUsuario
							,@cNome_Estabelecimento
							,@cEndereco_Estabelecimento
							,@cCidade_Estabelecimento
							,@cEstado_Estabelecimento
							,0
							,@nCreditoDisponivelCartao
							,@iRedeNumero
							,@iCodigoEstabelecimento
							,0

				END
				ELSE IF (@cBaseOrigem = 'C')
				BEGIN


					SELECT 
						@iMes		  = DATEPART(MONTH,@dDataHora_Transacao)
						,@iAno		  = DATEPART(YEAR,@dDataHora_Transacao)

					SELECT	 
								@iFranquia_Usuario		= COALESCE(C.Franquia,0)
							,@iCliente				= COALESCE(C.Cliente,0)
							,@iUsuario				= COALESCE(C.Usuario,0)
					FROM	[policard_603078].[dbo].[Cartao_usuario] C WITH(HOLDLOCK, ROWLOCK)
					INNER JOIN [policard_603078].[dbo].[Franquia] F WITH(NOLOCK)ON F.Codigo = C.Franquia
					WHERE C.CodigoCartao = @cNumeroCartao
					AND C.StsTransferenciaUsuario IS NULL

					EXEC [policard_603078].[dbo].[pr_RetornaSaldoUsuario] @iFranquia_Usuario, @iCliente, @iUsuario, @iAno, @iMes, @nSaldo_Disponivel_Cliente OUTPUT, @nSaldo_Disponivel_Usuario OUTPUT 

					
					EXEC [Autorizacao].[dbo].pr_aut_BuscaMensagemTicket 6, 300000, 7, @cMsgResposta OUT
					
					SET @cMsgResposta = REPLACE(@cMsgResposta, '<NOME_USUARIO>', @sNomeUsuario)
					SET @cMsgResposta = REPLACE(@cMsgResposta, '<SALDO_DISPONIVEL>', COALESCE(CONVERT(VARCHAR, @nSaldo_Disponivel_Usuario), ''))
					--SET @cMsgResposta = REPLACE(@cMsgResposta, '<NUMERO_PARCELAS>', CONVERT(VARCHAR, @iQuantParcelas))
													
					SET @cMsgResposta = REPLACE(@cMsgResposta, '<CARTAO>', SUBSTRING(@cNumeroCartao,1,6) + '******' + SUBSTRING(@cNumeroCartao,13,4))
					SET @cMsgResposta = REPLACE(@cMsgResposta, '<CNPJ>', COALESCE(@cCNPJ_Estabelecimento,''))
					SET @cMsgResposta = REPLACE(@cMsgResposta, '<NOME_ESTABELECIMENTO>', @cNome_Estabelecimento)
					SET @cMsgResposta = REPLACE(@cMsgResposta, '<ENDERECO>', COALESCE(@cEndereco_Estabelecimento,''))
					SET @cMsgResposta = REPLACE(@cMsgResposta, '<CIDADE>', COALESCE(@cCidade_Estabelecimento, ''))
					SET @cMsgResposta = REPLACE(@cMsgResposta, '<ESTADO>', COALESCE(@cEstado_Estabelecimento,''))
					SET @cMsgResposta = REPLACE(@cMsgResposta, '<NSU_HOST>', CASE WHEN @iRedeNumero IN (10,58) THEN dbo.f_ZerosEsquerda(@cBit038,6) ELSE @cBit127 END)
					SET @cMsgResposta = REPLACE(@cMsgResposta, '<NSU_LOJA>', COALESCE(@cBit011,''))
					SET @cMsgResposta = REPLACE(@cMsgResposta, '<CODIGO_ESTABELECIMENTO>', CONVERT(VARCHAR,CONVERT(BIGINT, @cBit042)))
					SET @cMsgResposta = REPLACE(@cMsgResposta, '<TERMINAL>', @cBit041)
					SET @cMsgResposta = REPLACE(@cMsgResposta, '<DATA>',dbo.f_ZerosEsquerda(CONVERT(VARCHAR,DAY(GETDATE())), 2) + '/' + dbo.f_ZerosEsquerda(CONVERT(VARCHAR,MONTH(GETDATE())), 2))
					SET @cMsgResposta = REPLACE(@cMsgResposta, '<HORA>', SUBSTRING (CONVERT(VARCHAR, GETDATE(), 108 ),1,5))
					SET @cMsgResposta = REPLACE(@cMsgResposta, '<VALOR>', COALESCE(CONVERT(VARCHAR, CONVERT(DECIMAL(15,2), CONVERT(DECIMAL(15,2),@nValor_Transacao))),''))

					PRINT @cMsgResposta
				END

				SET @cBit062 = @cBit062 + '505' + CONVERT(VARCHAR(3),LEN(@cMsgResposta)) + @cMsgResposta + '506' + CONVERT(VARCHAR(3),LEN (@cMsgResposta)) + @cMsgResposta


			END
			ELSE IF (@iResposta = 44)
			BEGIN
			
				IF (@iTempoTransacao > 0)
				BEGIN
					
					SET @cMsgResposta = 'TRANSACAO EM@ANDAMENTO'
					SET @iLenMsgResposta = LEN(@cMsgResposta)
					SET @cBit062 = '501' + REPLICATE('0', 3 -  LEN(@iLenMsgResposta)) + CONVERT(VARCHAR(3), @iLenMsgResposta) + @cMsgResposta
					SET @iResposta = 44
					SET @cBit039 = '77'

				END

			END 

			SELECT @iTempoEspera = ISNULL(CD_VALUE,0)
			FROM DBO.FNC_RETORNA_TLV(@cBit047,3)
			WHERE CD_TAG = 260

			SET @cBit047 = ''
			SET @cBit127 = ''

		END
		ELSE IF (@cBit001 IN ('0202', '0402'))
		BEGIN 
	
			IF (@cBit001 = '0202')
			BEGIN

				SELECT @cBit038 = ISNULL(Autorizacao ,0)
				FROM TransacaoQrCode WITH(NOLOCK) 
				WHERE TipoMensagem = '0210'  --PEGAR O CODIGO DE AUTORIZACAO DA 0210
				AND CONVERT (VARCHAR(10),DataHora, 120) = CONVERT (VARCHAR(10),@dDataHora_Transacao,120) /* Somente transacoes do dia corrente */
				AND CodEstab = @iCodigoEstabelecimento
				AND Valor = @nValor_Transacao
				AND Terminal = @cBit041 
				AND NSUOrigem = @cBit011
				AND [Status] = 'P'


				IF(@cBit038 > 0)
				BEGIN 

					UPDATE A
					SET [Status] = 'A'
					FROM TransacaoQrCode A
					WHERE TipoMensagem = '0210'
					AND CONVERT (VARCHAR(10),DataHora, 120) = CONVERT (VARCHAR(10),@dDataHora_Transacao,120) /* Somente transacoes do dia corrente */
					AND CodEstab = @iCodigoEstabelecimento
					AND Valor = @nValor_Transacao
					AND Terminal = @cBit041 
					AND NSUOrigem = @cBit011
					AND Autorizacao = @cBit038
					AND [Status] = 'P'

				END

			END
			ELSE
			BEGIN 

				DECLARE @iTrnOrigem INT = 0

				SELECT @iTrnOrigem = TrnCodigo 
					,@cBaseOrigem = BaseOrigem
				FROM TransacaoQrCode with(nolock)
				WHERE TipoMensagem = '0210'
				AND CONVERT (VARCHAR(10),DataHora, 120) = CONVERT (VARCHAR(10),@dDataHora_Transacao,120) /* Somente transacoes do dia corrente */
				AND CodEstab = @iCodigoEstabelecimento
				AND Valor = @nValor_Transacao
				AND Terminal = @cBit041 
				--AND NSUOrigem = @cBit011
				--AND Autorizacao = @cBit038
				AND [Status] = 'A'
				
				IF (@iTrnOrigem > 0)
				BEGIN

					UPDATE A
					SET [Status] = 'A'
						,TrnReferencia = @iTrnOrigem
						,BaseOrigem = @cBaseOrigem
					FROM TransacaoQrCode A
					WHERE TipoMensagem = '0410'
					AND CONVERT (VARCHAR(10),DataHora, 120) = CONVERT (VARCHAR(10),@dDataHora_Transacao,120) /* Somente transacoes do dia corrente */
					AND CodEstab = @iCodigoEstabelecimento
					AND Valor = @nValor_Transacao
					AND Terminal = @cBit041 
					AND NSUOrigem = @cBit011
					AND Autorizacao = @cBit038
					AND [Status] = 'P'

					UPDATE A
					SET [Status] = 'E'
					FROM TransacaoQrCode A
					WHERE TrnCodigo = @iTrnOrigem
					AND [Status] = 'A'

				END

			END 

		END

	END


	Trn_ECO:

	/* Bits que devem ser retornados em branco nas  transações */
	IF @cMsgCodigo IN ('0110','0210','0212','0410','0430','0810', '0412')
	BEGIN

			SET @cBit001 = @cMsgCodigo

			SET @cBit002 = ''
			--SET @cBit004 = ''
			SET @cBit014 = ''
			SET @cBit018 = ''
			SET @cBit022 = ''
			SET @cBit023 = ''
			SET @cBit024 = ''
			SET @cBit035 = ''
			SET @cBit043 = ''
			SET @cBit045 = ''
			SET @cBit049 = ''
			SET @cBit052 = ''
			SET @cBit055 = ''
			SET @cBit059 = ''
			SET @cBit060 = ''
			SET @cBit067 = ''
			SET @cBit104 = ''
			SET @cBit120 = ''
			SET @cBit125 = ''

			

			IF (@cMsgCodigo <> '0430')
			BEGIN
				SET @cBit061 = ''
				SET @cBit090 = ''
			END

			IF (@cMsgCodigo = '0412')
				SET @cBit062 = ''

	END

	IF (@iResposta = 0)
		SET @cBit039 = REPLICATE('0', 2 - LEN(@cBit039)) + @cBit039
	
	IF (@iTempoEspera > 0)
	BEGIN 

		DECLARE @DELAY VARCHAR(8)

		IF @iTempoEspera >= DATEDIFF(ss, @dDataHora_Transacao, GETDATE())
			SET @iTempoEspera = @iTempoEspera - DATEDIFF(ss, @dDataHora_Transacao, GETDATE())
		ELSE 
			SET @iTempoEspera = 0
			
		SELECT @DELAY = cast(dateadd(ss, @iTempoEspera, '00:00:00') AS TIME(0))

		WAITFOR DELAY @DELAY

	END

END