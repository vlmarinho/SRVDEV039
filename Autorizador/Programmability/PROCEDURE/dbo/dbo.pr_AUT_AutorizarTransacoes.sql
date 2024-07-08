
 
 
-------------------------------------------------------------------------- 
/* 
-------------------------------------------------------------------------- 
Projeto: Novo Autorizador Policard 
Objeto: pr_aut_AutorizarTransacoes 
Propósito: Autorizar,Cancelar e desfazer transações. 
Autor: Cristiano Silva Barbosa - Tecnologia Policard 
-------------------------------------------------------------------------- 
Data Criação: 19/02/2017 
Chamado: 2601 
-------------------------------------------------------------------------- 
Data: 24/02/2017 
Mud/CH.: 359154 / 2627 
-------------------------------------------------------------------------- 
Data: 09/03/2017 
Mud/CH.: 362146 / 2648 
-------------------------------------------------------------------------- 
Data Alteracao: 16/05/2017 
Autor: Cristiano Barbosa 
CH: 383212 - 2839 
-------------------------------------------------------------------------- 
Data Alteração: 06/06/2017 
Chamado: 389762 / 2926  
Responsavel: Cristiano Barbosa- Policard Systems 
-------------------------------------------------------------------------- 
Data Alteração: 24/08/2017 
Chamado: 409745 / 3170  
Responsavel: Cristiano Barbosa- Policard Systems 
-------------------------------------------------------------------------- 
Data Alteração: 28/09/2017 
Chamados: 399954 / 417666 / 3262 
Responsavel: Cristiano Barbosa- Policard Systems 
-------------------------------------------------------------------------- 
Data Alteração: 21/03/2018 
Chamados: 492571 /  
Responsavel: Cristiano Barbosa- Policard Systems 
-------------------------------------------------------------------------- 
Data Alteração: 26/04/2018 
Chamados: 494467  / 3947 
Responsavel: Cristiano Barbosa- Up Brasil 
-------------------------------------------------------------------------- 
Data Alteracao: 25/03/2019 
Autor: Kyros 
CH: 618588 - Projeto Melhorias SGF - Auto Gestão 
Descrição: Criação de uma nova Opção Frota (4) e de uma nova Rede (SGF) 
-------------------------------------------------------------------------- 
Data Alteracao: 06/05/2019 
Autor: João Henrique 
CH:  
Descrição: Inclusão da rede 27 nas transações com cartão digitado. 
-------------------------------------------------------------------------- 
Data Alteracao: 19/07/2019 
Autor: João Henrique 
CH:  
Descrição: SAFRAPAY. 
-------------------------------------------------------------------------- 
Data Alteracao: 28/10/2019 
Autor: João Henrique 
CH:  
Descrição: FirstData. 
-------------------------------------------------------------------------- 
Data Alteracao: 16/11/2020 
Autor: João Henrique 
CH: 1630679 
Descrição: Inclusção das Adquirentes Adyen e Global Payments. 
-------------------------------------------------------------------------- 
Data Alteracao: 26/03/2021 
Autor: João Henrique 
CH: 1690953  
Descrição: Remoção da trava de transação digitada Cielo, para atender captura QRCode 
-------------------------------------------------------------------------- 
Data Alteracao: 06/04/2021 
Autor: João Henrique 
CH: 1690953  
Descrição: Ajuste de validação de data na transação Cielo via QRCode 
-------------------------------------------------------------------------- 
Data Alteracao: 05/08/2021  
Autor: João Henrique  
CH: 1741118   
Descrição: Inclusão da captura dos cartões PAT na PagSeguro  
--------------------------------------------------------------------------  
Data Alteracao: 29/10/2021  
Autor: João Henrique  
CH:    
Descrição: Adição do campo de rede na procedure de validação de EC Getnet  
--------------------------------------------------------------------------  
Data Alteracao: 01/11/2021  
Autor: João Henrique  
CH:  1778396   
Descrição: Correção do fluxo de habilitação de estabelecimento Softnex  
--------------------------------------------------------------------------  
Data Alteracao: 18/02/2022  
Autor:   
CH:   
Descrição: Inclusao do CardSE 
--------------------------------------------------------------------------  
Data: 30/03/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1812108
Descrição: Acrescenta passagem da quantidade de parcelas para persistência 
	na tabela TransacoesNegadas
-------------------------------------------------------------------------- 	
Data: 08/09/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1843805 
Descrição: Projeto ABECS para transações NCR/Scope.
-------------------------------------------------------------------------- 
Data: 05/10/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1920459
Descrição: Corrige string de retorno para recarga, quando há negativa do autorizador.
-------------------------------------------------------------------------- 
Data: 05/01/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1961498
Descrição: Incluir o processamento da 0202 para todas as redes que enviam a transação 0202.
-------------------------------------------------------------------------- 
Data: 14/03/2023
Autor: Adilson Pereira - Up Brasil
Chamado: 1986162
Descrição: Projeto cashback - Integração plataforma Parantez.
-------------------------------------------------------------------------- 
Data: 11/04/2023
Autor: Adilson Pereira - Up Brasil
Chamado: 1968953
Descrição: Projeto App Delivery - Integração CardHub.
-------------------------------------------------------------------------- 
Data: 11/05/2023
Autor: Adilson Pereira - Up Brasil
Chamado: 2009473
Descrição: Tratativa das redes 46, 47, 48, 49, 50 e 51 (Adyen) por procedure específica.
-------------------------------------------------------------------------- 
Data: 18/05/2923
Autor: Adilson Pereira - Up Brasil
Chamado: 2012351  
Descrição: Inclui apps Adyen na verificação de cartão digitado.
-------------------------------------------------------------------------- 
Data: 10/08/2923
Autor: Adilson Pereira - Up Brasil
Chamado: 2043750 
Descrição: Tratativa das redes 49, 50 e 51 (GlobalPayments) por procedure específica.
-------------------------------------------------------------------------- 
Data: 17/10/2023
Autor: Adilson Pereira - Up Brasil
Chamado: 2067391 
Descrição: Altera passagem de parâmetros para processo de envio de notificação por push.
	No caso de transações negadas não é gerado registro nas tabelas finais.
-------------------------------------------------------------------------- 
Data: 06/11/2023
Autor: Adilson Pereira - Up Brasil
Chamado: 2073246
Descrição: Ajuste passagem de parâmetros para pr_aut_desfaz_trn_convenio: adicionado @cProvedor.
-----------------------------------------------------------------------------------------------------------
Data: 27/11/2023
Autor: Adilson Pereira - Up Brasil
Chamado: 2080623
Descrição: Corrigir validação da data de expiração do cartão em transações recebidas 
	das redes E-COMMERCE, APP ADYEN e APP GLOBAL PAYMENTS, que não fazem a leitura 
	da trilha do cartão, não enviando os bit's 35 e 45. A data de expiração é informada
	no bit 14.
--------------------------------------------------------------------------   
Data: 04/01/2024
Autor: Adilson Pereira - Up Brasil
Chamado: 2092171
Descrição: Inclui redes E-COMMERCE, APP ADYEN e APP GLOBAL PAYMENTS às exceção de transação sem senha.
-----------------------------------------------------------------------------------------------------------
*/  
  
CREATE PROCEDURE [dbo].[pr_AUT_AutorizarTransacoes] (  
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
	@bEnviaPush BIT OUTPUT, @cBaseOrigem CHAR(1) OUTPUT, @iTrnCodigo INT OUTPUT, @iCntAppCodigo INT OUTPUT, @iResposta INT OUTPUT, 
	@cMsgErro VARCHAR(MAX) OUTPUT, @iCodigoEstabelecimento	BIGINT = NULL OUTPUT, @cNumeroCartao CHAR(16) = NULL OUTPUT,
	@nValor_Transacao DECIMAL(15,2) = NULL OUTPUT
	)  
AS  
BEGIN  
	  
	SET NOCOUNT ON;  
	  
	DECLARE 		  
		@bPermiteDigitado			BIT  
		,@bPermiteSemSenha			BIT  
		,@bCartaoEmv				BIT  
		,@bEstabMigrado				BIT  
		,@bMonitorTrn				BIT  
		,@bPermiteSMS				BIT  
		,@cAutorizacao				CHAR(18)  
		,@cUltimosDigCartao			CHAR(4)  
		,@dDataHora_Transacao		DATETIME  
		,@iMeiCptCodigo				INT  
		,@iTipoMeioCaptura			INT  
		,@iCrtUsrCodigo				INT  
		,@iCntUsrCodigo				INT  
		,@iCliente					INT  
		,@iRedeNumero				INT  
		,@iRedeCodigo				INT  
		,@iUsuario					INT  
		,@iPrdCodigo				INT  
		,@iRespostaRecarga			INT  
		,@iFranquiaUsuario			SMALLINT  
		,@cMsgCodigo				VARCHAR(4)  
		,@cProvedor					VARCHAR(50)  
		,@cServiceCode				VARCHAR(3)  
		,@cVencimentoCartao			VARCHAR(4)  
		,@cIdVerificacao			VARCHAR(6)  
		,@iCodTipoTransacao		INT
		,@returnCode INT
		,@returnMessage VARCHAR(4000)		

	SET @dDataHora_Transacao	= GETDATE()  
	SET @cMsgCodigo				= @cBit001  
	SET @iResposta				= 0  
	SET @bPermiteDigitado		= 0  
	SET @bPermiteSemSenha		= 0  
	SET @bPermiteSMS			= 0  
	SET @bEnviaPush				= 0  
	SET @iCliente				= 0  
	SET @iFranquiaUsuario		= 0  
	SET @bCartaoEmv				= 0  
	SET @bEstabMigrado			= 0  
	SET @iCodigoEstabelecimento	= 0  
	SET @iRespostaRecarga		= 0  
	SET @cBit041                = CONVERT(CHAR(8),@cBit041)  
	SET @cBit042				= REPLACE(@cBit042,'.','')  
	  
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
						  WHEN @cBit123 LIKE 'SCOPE%' THEN 'SCOPEPRIVATE'   
					  ELSE @cBit048 END  
  
	IF @cMsgCodigo = '0200'  
		SET @cMsgCodigo = '0210'  
	ELSE IF @cMsgCodigo = '0400'  
		SET @cMsgCodigo = '0410'  
	ELSE IF @cMsgCodigo = '0420'  
		SET @cMsgCodigo = '0430'  
	ELSE IF @cMsgCodigo = '0500'  
		SET @cMsgCodigo = '0510'  
	ELSE IF @cMsgCodigo = '0800'  
		SET @cMsgCodigo = '0810'  
	ELSE IF @cMsgCodigo = '0100'  
		SET @cMsgCodigo = '0110'  
	ELSE   
		SET @cMsgCodigo = @cBit001  
  
	IF @cMsgCodigo NOT IN ('0110','0202','0210','0402','0410','0430','0510','0610','0810') /* MENSAGEM INVALIDA */  
		SET @iResposta = 265 /* MENSAGEM INVALIDA */  
	  
	IF @iResposta = 0  
		SET @cBit001 = @cMsgCodigo  
	  
	/*Validar se o codigo do estabelecimento é numerico*/  
	IF (ISNUMERIC(@cBit042) = 1)  
	BEGIN  
  
		DECLARE @sCodigoEstabelecimento VARCHAR(15)  
				,@cStatus CHAR(1)  
				,@bHabilitadoStone BIT  
				,@bHabilitadoSafra BIT   
				,@bHabilitadoGetNet BIT   
				,@bHabilitadoRede BIT   
				,@bHabilitadoPagseguro BIT  
				,@bHabilitadoAdyen BIT
				,@bHabilitadoGlobalPayments BIT
  
		SET @sCodigoEstabelecimento = @cBit042  
  
		IF (@iRedeCodigo = 31)  
		BEGIN  
			EXEC [dbo].[pr_AUT_RetornarEstabelecimentoStone]  @sCodigoEstabelecimento OUTPUT, @cStatus OUTPUT ,@bEstabMigrado OUTPUT, @bHabilitadoStone OUTPUT  
  
			IF (@bHabilitadoStone = 0)  
				SET @iResposta = 320  
		END  
    	ELSE IF (@iRedeCodigo = 36)    
		BEGIN    
  
			EXEC [dbo].[pr_AUT_RetornarEstabelecimentoSafra]  @sCodigoEstabelecimento OUTPUT, @cStatus OUTPUT ,@bEstabMigrado OUTPUT, @bHabilitadoSafra OUTPUT    
    
			IF (@bHabilitadoSafra = 0)    
				SET @iResposta = 320    
 
		END    
  		ELSE IF (@iRedeCodigo in (26,32,33,34,35,38,39,40,41,42,43,52,53,54))    
		BEGIN    
  
			EXEC [dbo].[pr_AUT_RetornarEstabelecimentoGetNet]  @sCodigoEstabelecimento OUTPUT, @cStatus OUTPUT ,@bEstabMigrado OUTPUT, @bHabilitadoGetNet OUTPUT  , @iRedeCodigo  
  
			IF (@bHabilitadoGetNet = 0 and @iRedeCodigo in (38,39,40,41,42,43,52,53,54)) /*regra criada para autorizar todas as transações FistData sem retorno de habilitação*/  
				SET @bHabilitadoGetNet = 1  
  
			IF (@bHabilitadoGetNet = 0)    
				SET @iResposta = 320    
    
		END   
  		ELSE IF (@iRedeCodigo in (46,47,48))    
		BEGIN    
  
			EXEC [dbo].[pr_AUT_RetornarEstabelecimentoAdyen]  @sCodigoEstabelecimento OUTPUT, @cStatus OUTPUT ,@bEstabMigrado OUTPUT, @bHabilitadoAdyen OUTPUT
  
			IF (@bHabilitadoAdyen = 0)    
				SET @iResposta = 320    
    
		END   		
  		ELSE IF (@iRedeCodigo in (49,50,51))    
		BEGIN    
  
			EXEC [dbo].[pr_aut_RetornarEstabelecimentoGlobalPayments]  @sCodigoEstabelecimento OUTPUT, @cStatus OUTPUT ,@bEstabMigrado OUTPUT, @bHabilitadoGlobalPayments OUTPUT
  
			IF (@bHabilitadoGlobalPayments = 0)    
				SET @iResposta = 320    
    
		END   				
  		ELSE 	IF (@iRedeCodigo = 29)    
		BEGIN    
  
			EXEC [dbo].[pr_AUT_RetornarEstabelecimentoRede]  @sCodigoEstabelecimento OUTPUT, @cStatus OUTPUT ,@bEstabMigrado OUTPUT, @bHabilitadoRede OUTPUT    
    
			IF (@bHabilitadoRede = 0)    
				SET @iResposta = 320    
    
		END  
  		ELSE IF (@iRedeCodigo in (55,56))  
		BEGIN  
  
			EXEC [dbo].[pr_AUT_RetornarEstabelecimentoPagseguro]  @sCodigoEstabelecimento OUTPUT, @cStatus OUTPUT ,@bEstabMigrado OUTPUT, @bHabilitadoPagseguro OUTPUT  				  
  
			IF (@bHabilitadoPagseguro = 0)    
				SET @iResposta = 320   
  
		END  
		  
		--IF (@iRedeCodigo in (38,39,40,41,42,43))    
		--BEGIN    
  
		--	EXEC [dbo].[pr_AUT_RetornarEstabelecimentoFirstData]  @sCodigoEstabelecimento OUTPUT, @cStatus OUTPUT ,@bEstabMigrado OUTPUT, --@bHabilitadoGetNet OUTPUT    
    
		--IF (@bHabilitadoGetNet = 0)    
		--SET @iResposta = 320    
    
		--END   
		ELSE  
			EXEC [dbo].[pr_AUT_RetornarEstabelecimento]  @sCodigoEstabelecimento OUTPUT, @cStatus OUTPUT ,@bEstabMigrado OUTPUT  
	  
		SELECT @iCodigoEstabelecimento = CONVERT(BIGINT,@sCodigoEstabelecimento)  
			  
		IF (@iCodigoEstabelecimento = 0 OR @iCodigoEstabelecimento IS NULL)  
			SET @iResposta = 116  
  
		IF (@cMsgCodigo IN ('0110','0210','0410') AND @iResposta = 0 AND @cStatus <> 'A')  
			SET @iResposta = 320  
  
  
	END  
	ELSE  
		SET @iResposta = 116  
  
  
	/*Executa Validacao do estabelecimento e meios de captura */  
	IF (@iResposta = 0)  
	BEGIN  
  
		DECLARE    
			 @cCNPJ_Estabelecimento		CHAR(20)  
			,@cNome_Estabelecimento		VARCHAR(30)  
			,@cEndereco_Estabelecimento	VARCHAR(50)  
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
  
	IF (@iResposta = 0)  
	BEGIN  
	  
		/*Capturando Cartão */  
		IF (@cBit002 <> '' AND LEN (@cBit002) = 16 AND @cMsgCodigo IN ('0110','0210'))  
		BEGIN  
			SET @cNumeroCartao = @cBit002		/* Número do cartão - Digitação manual */  
			SET @cVencimentoCartao = @cBit014	/* Data de vencimento*/  
  
			IF (@iRedeNumero = 10) /*Tratativa para captura QRCode Cielo*/  
			BEGIN  
				SET @cBit014 = @cBit014 + '01'  
				SET @cBit014 = CONVERT(VARCHAR(10),DATEADD(MM,1,@cBit014),120)  
				SET @cBit014 = SUBSTRING(REPLACE(SUBSTRING(@cBit014,1,7), '-',''),3,4)  
				SET @cVencimentoCartao = @cBit014  
			END  
  
  
			IF (@iRedeNumero NOT IN (10,16,17,19,20,26,27,35,44,48,51) AND @bPermiteDigitado = 0)  
				SET @iResposta = 281 /*Estabelecimento nao Permite Transacao Digitada*/  
		END  
		ELSE  
		BEGIN  
  
			SET @cNumeroCartao = @cBit002 /* Número do cartão - Digitação manual */  /* CH - 58085 */  
  
			IF (@cNumeroCartao IS NULL) OR (@cNumeroCartao = '')  
			BEGIN  
				SET @cNumeroCartao = LEFT(@cBit035,16)				/* Número do cartão - Trilha 2 do cartão */  
				SET @cVencimentoCartao = SUBSTRING(@cBit035,18,4)	/* Data de vencimento*/  
				SET @cServiceCode = SUBSTRING (@cBit035,22,3)		/*Service Code*/  
				SET @cIdVerificacao = SUBSTRING (@cBit035,25,6)		/*Id Verificacao*/  
				  
			END  
  
			IF (@cNumeroCartao IS NULL) OR (@cNumeroCartao = '')  
			BEGIN  
				SET @cNumeroCartao = SUBSTRING(@cBit045,2,16)		/* Número do cartão - Trilha 1 do cartão */  
				SET @cVencimentoCartao = SUBSTRING(@cBit045,46,4)	/* Data de vencimento*/  
				SET @cServiceCode = SUBSTRING(@cBit045,50,3)		/*Service Code*/  
			END  
  
		END  
				   
		/*Confirmando transacao via 0202,0402 e 0610*/  
		IF (@cMsgCodigo IN ('0202','0402','0410','0430','0610'))  
		BEGIN  
		  
			DECLARE    
				 @cOrigem			CHAR(1)  
				,@cCodProcessOrig	CHAR(6)   
				,@cTipoTransacao	VARCHAR(4)  
			  
			IF @cMsgCodigo IN ('0410','0430')  
				SET @cCodProcessOrig = SUBSTRING(@cBit090, 5,6)  
			  
			  
			EXEC [dbo].[pr_aut_BuscaDesfazimentoEstorno]   
				 @cBit001  
				,@cBit041  
				,@cBit090  
				,@cBit105  
				,@cBit127			OUTPUT  
				,@cProvedor  
				,@iRedeNumero  
				,@iCodigoEstabelecimento  
				,@iEstCodigo  
				,@cNumeroCartao		OUTPUT  
				,@iCrtUsrCodigo		OUTPUT  
				,@bCartaoEmv		OUTPUT  
				,@iFranquiaUsuario	OUTPUT  
				,@iCliente			OUTPUT  
				,@nValor_Transacao  
				,@cOrigem			OUTPUT  
				,@bPermiteSMS		OUTPUT  
				,@iCntAppCodigo		OUTPUT  
				,@bEnviaPush		OUTPUT  
				,@iResposta			OUTPUT  
  
			IF (@cBit001 IN ('0202', '0402') AND @iRedeNumero IN (7, 22, 24, 25, 27, 29, 36, 55, 56, 57)) -- Confirmação de venda ou estorno  
			BEGIN  
			  
				IF (@cBit127 IS NOT NULL)  
				BEGIN  
													  
					IF (@cBit001 = '0202') -- Confirmação de venda  
						EXEC pr_aut_Confirmar_Transacao_Venda @iCodigoEstabelecimento, @cBit127 , @cNumeroCartao, @cOrigem, @bPermiteSMS, @bEstabMigrado  
					ELSE -- 0402  
						EXEC pr_aut_Confirmar_Transacao_Estorno @iCodigoEstabelecimento, @cBit127, @cNumeroCartao, @cOrigem, @bPermiteSMS, @bEstabMigrado  
				END  
			  
			END  
			ELSE IF (@cBit001 = '0610') -- Sonda  
			BEGIN  
			  
				EXEC pr_AUT_AutorizarTransacoesSonda  
					 @cBit011  
					,@cBit012  
					,@cBit013  
					,@dDataHora_Transacao  
					,@cBit039  
					,@iCodigoEstabelecimento  
					,@cBit125  
					,@cBit127  
					,@iRedeNumero					  
						  
				SET @iResposta = 0 /* A transação de sonda, não tem resposta para a ponta, caso não tenha sido transacionado ok, uma nova transação de sonda resolverá o problema*/  
  
			END  
			  
			IF (@cMsgCodigo = '0430' AND (@cNumeroCartao IS NULL OR @cNumeroCartao = ''))  
				SET @iResposta = 271  
		  
		END  
		  
	END  
		  
	IF (@cNumeroCartao IS NOT NULL AND @cNumeroCartao <> '')  
	BEGIN  
  
		DECLARE    
			 @iTpoPrdCodigo		INT  
			,@bSenhaCapturada	BIT  
			,@bSenhaValida		BIT  
						      
		SET @cBaseOrigem = '' 
		SET @iTpoPrdCodigo = 0 
		  
		IF (@cBit052 = '' OR @cBit052 IS NULL OR  @cBit052 = '0000000000000000')  
		BEGIN  
			SET @bSenhaCapturada = 0  
			SET @bSenhaValida = 0  
		END  
		ELSE  
			SET @bSenhaCapturada = 1  

			
		--Buscando dados do cartão  
		EXEC Processadora.dbo.pr_PROC_RetornarTipoProdutoCartao @cNumeroCartao, @cBaseOrigem OUT, @iTpoPrdCodigo OUT	  
		  
		IF (@iResposta = 0 AND @cMsgCodigo IN ('0110','0210'))  
		BEGIN  
		  
			IF (@cBaseOrigem IN ('C','P'))  
			BEGIN  
			  
				EXEC [dbo].[pr_aut_VerificaUsuarioCliente]  
					 @cBit011  
					,@cBit041  
					,@cBit052				OUTPUT  
					,@cBit059  
					,@cBit063				OUTPUT  
					,@cBit104  
					,@cBit105  
					,@cBit120  
					,@cBaseOrigem  
					,@cProvedor  
					,@iCodigoEstabelecimento  
					,@bEstabMigrado  
					,@bSenhaCapturada  
					,@dDataHora_Transacao  
					,@iRedeNumero  
					,@nValor_Transacao  
					,@cVencimentoCartao		/* Data de vencimento*/  
					,@cServiceCode			/*Service Code*/  
					,@cIdVerificacao  
					,@cBit123
					,@cBit124
					,@cBit003
					,@cBit014
					,@cNumeroCartao			OUTPUT  
					,@bSenhaValida			OUTPUT  
					,@iCntUsrCodigo         OUTPUT  
					,@iCrtUsrCodigo			OUTPUT  
					,@iFranquiaUsuario		OUTPUT  
					,@iCliente				OUTPUT  
					,@iUsuario				OUTPUT  
					,@iPrdCodigo			OUTPUT  
					,@bCartaoEmv			OUTPUT  
					,@iCntAppCodigo			OUTPUT  
					,@bEnviaPush			OUTPUT  
					,@iResposta				OUTPUT	
					,@cMsgErro				OUTPUT
		  
				IF (@iResposta <> 0 AND @cBit003 = '599002')  
					SET @cBit062 = ''  
  
				IF (@iResposta <> 0 AND @iRedeNumero IN (27,44)) 
					SET @cBit062 = '||'--UTILIZANDO NO PARSER DO APP  
										  
			END  
			ELSE  
				SET @iResposta = 12  
							  
			/* Validando se Estabelecimento permite transacao sem senha, exceto CRM, SIGRA e CAE que nao solicita senha*/  
			IF (@iResposta = 0 AND @bPermiteSemSenha = 0)  
			BEGIN  
				IF (@iRedeNumero NOT IN (16,17,19,20,26,37, 27, 11, 48, 51) AND @bSenhaCapturada = 0 )  /*Regra que falhou 17/05*/  
				BEGIN  
	  
					SET @iResposta = 294 --NAO PERMITE TRANSACAO SEM SENHA  
  
					IF (@iRedeNumero = 10 and (@cbit002 <> '' and @cbit022 = '010') )  
					SET @iResposta = 0  
  
				END  
			END  
		END  
	END  
  
	IF (@iResposta = 0 AND @cMsgCodigo IN ('0110','0210'))/* Verificando se existe restrição de compras */  
	BEGIN   
	  
		EXEC [pr_aut_VerificaRestricaoCompra]  
			 @cBaseOrigem  
			,@iCodigoEstabelecimento  
			,@bEstabMigrado  
			,@iTpoPrdCodigo  
			,@iCntUsrCodigo  
			,@iCrtUsrCodigo  
			,@iFranquiaUsuario  
			,@iCliente  
			,@bMonitorTrn		OUTPUT  
			,@iResposta			OUTPUT  
  
	  
	END   
	   
	IF (@iResposta = 0 AND @cMsgCodigo IN ('0510','0810'))/* A estrutura dentro desse bloco condicional é baseada na documentação do padrão ISO8583 Policard */  
	BEGIN   
		  
		IF (@cMsgCodigo = '0510')  
		BEGIN  
		  
			IF (@iRedeNumero = 15)  
			BEGIN  
  
				EXEC [pr_aut_RelatorioCabecalho]/*Relatorio MultiBandeira*/  
					 @cBit041  
					,@iCodigoEstabelecimento  
					,@bEstabMigrado  
					,@cBit063  
					,@cBit039 OUTPUT  
					,@cBit062 OUTPUT  
			END  
			ELSE		  
			BEGIN  
  
				DECLARE   
					 @bEnviaRelatorio	BIT  
					,@bMultiBandeira	BIT  
					,@cModeloPOS		VARCHAR (20)  
					,@cVersaoPOS		VARCHAR (10)  
					,@cVersaoProducao	VARCHAR (10)  
					,@iQtdeNotificacao	INT  
  
				SET @bEnviaRelatorio = 1  
				SET @iQtdeNotificacao = 1  
				SET @cVersaoPOS = ''  
				SET @cVersaoProducao = ''  
  
				IF (@iRedeNumero = 13 AND @bEstabMigrado = 0)  
				BEGIN  
  
					SELECT @cModeloPOS		= COALESCE(Modelo,modeloterminal)  
						  ,@cVersaoPOS		= COALESCE(versaoframework, '')  
						  ,@bMultiBandeira	= COALESCE(MultiBandeira,0)  
					FROM Processadora.dbo.MeiosCaptura WITH(NOLOCK)   
					WHERE Numero = @cBit041   
					AND TpoMeiCptCodigo = 14  
  
					/*Nao enviar mensagem para POS Multi Bandeira*/  
					IF (@bMultiBandeira = 0)  
					BEGIN  
					  
						IF (@cModeloPOS = 'VX-520')  
						BEGIN  
						  
							SELECT TOP 1 @cVersaoProducao = CodigoVersao   
							FROM Processadora.dbo.VersaoAplicacaoMeiosCaptura WITH (NOLOCK)   
							WHERE Id_ModeloPOS = 4   
							AND Status = 1   
							ORDER BY ID_VersaoAplicacao DESC 
						END  
						ELSE  
						BEGIN  
							SELECT TOP 1 @cVersaoProducao = CodigoVersao   
							FROM Processadora.dbo.VersaoAplicacaoMeiosCaptura WITH (NOLOCK)   
							WHERE Id_ModeloPOS = 2   
							AND Status = 1   
							ORDER BY ID_VersaoAplicacao DESC  
						END  
  
						IF(@cVersaoProducao <> @cVersaoPOS)  
						BEGIN  
						  
							/*Caso nao tenha enviado nenhuma notificacao, será enviado no primeiro relatorio*/  
							IF NOT EXISTS (SELECT 1 FROM AtualizacaoTerminal WITH (NOLOCK)  
											WHERE Terminal = @cBit041 AND STATUS = 'E') /*STATUS: A = ATUALIZADO E = MSG ENVIADA PARA ATUALIZAR*/  
  
							BEGIN  
  
								INSERT INTO AtualizacaoTerminal VALUES (GETDATE(),@iCodigoEstabelecimento, @cBit041, @cModeloPOS, @cVersaoPOS, @cVersaoProducao, @iRedeNumero,'E', @iQtdeNotificacao)  
  
								SET @bEnviaRelatorio = 0  
  
							END  
							ELSE  
							BEGIN  
								  
								/*Caso nao tenha enviado nenhuma notificacao no dia será enviado no primeiro relatorio diario*/  
								IF NOT EXISTS (SELECT 1 FROM AtualizacaoTerminal WITH (NOLOCK)  
											WHERE Terminal = @cBit041   
												AND STATUS = 'E'/*STATUS: A = ATUALIZADO E = MSG ENVIADA PARA ATUALIZAR*/  
												AND CONVERT(VARCHAR(10),DataHora,103) = CONVERT(VARCHAR(10), GETDATE (),103)  
												)  
  
								BEGIN  
  
									SELECT @iQtdeNotificacao = QtdeNotificacao + 1 FROM AtualizacaoTerminal WITH (NOLOCK) WHERE Terminal = @cBit041  
  
									UPDATE AtualizacaoTerminal SET DataHora = GETDATE (), QtdeNotificacao = @iQtdeNotificacao WHERE Terminal = @cBit041  
																		  
									SET @bEnviaRelatorio = 0  
  
								END  
							END  
						END  
						ELSE  
						BEGIN  
  
							IF EXISTS (SELECT 1 FROM AtualizacaoTerminal WITH (NOLOCK)  
											WHERE Terminal = @cBit041 AND STATUS = 'E') /*STATUS: A = ATUALIZADO // E = MSG ENVIADA PARA ATUALIZAR*/  
												--AND VersaoTerminal = @cVersaoProducao)   
  
							BEGIN  
	  
								UPDATE AtualizacaoTerminal  
								SET VersaoProducao = @cVersaoProducao  
									,VersaoTerminal = @cVersaoPOS  
									,DataHora = GETDATE ()  
									,STATUS = 'A'/*STATUS: A = ATUALIZADO*/  
								WHERE TERMINAL = @cBit041   
  
							END  
						END  
					END  
				END  
				  
				IF (@bEnviaRelatorio = 1)  
				BEGIN  
  
					EXEC [pr_aut_RelatorioFechamentoPOS]/*Relatorio diario*/  
						 @cBit041  
						,@cBit042  
						,@bEstabMigrado  
						,@cBit063  
						,@cBit039	OUTPUT  
						,@cBit062	OUTPUT  
				END  
				ELSE  
				BEGIN  
  
					SELECT @cBit062 = WALK_MSGTICKET   
						,@cBit039 = '00'  
					FROM  Autorizacao.dbo.AUT_MENSAGENSRESPOSTA WITH(NOLOCK)   
					WHERE TPOPRDCODIGO = 0   
					AND TPOTRNCODIGO = 1   
					AND REDE = 58  
									  
									  
					IF (@cModeloPOS = 'VX-520')  
						SET @cBit062 = REPLACE(@cBit062, '<MENSAGEM>','TECLE F2@ESCOLHA A OPCAO: 2.REALIZAR TELECARGA@DIGITE A SENHA 7874 OU 257864')  
					ELSE  
					BEGIN  
						SET @cBit062 = REPLACE(@cBit062, '<DIV>','--------------------------------------')  
						SET @cBit062 = REPLACE(@cBit062, '<MENSAGEM>','TECLE VERDE@ESCOLHA A OPCAO: FUNCOES TECNICAS@DESPOIS A OPCAO: TELECARGA@E ENFIM A OPCAO: REALIZAR TELECARGA@DIGITE A SENHA 7874 OU 257864')  
					END  
				END  
			END  
		END  
		  
		IF (@cMsgCodigo = '0810')  
		BEGIN  
  
			IF (@cBit003 = '008010' AND @iRedeCodigo = 36)  
			BEGIN  
				EXEC [dbo].[pr_aut_RealizaCargaTabela_Safra]  
					 @cBit003		OUTPUT  
					,@cBit041  
					,@iCodigoEstabelecimento  
					,@bEstabMigrado  
					,@cBit059		OUTPUT  /* Bit utilizano no retorno de carga de tabelas*/  
					,@cBit060		OUTPUT  /* Bit utilizano no retorno de carga de tabelas*/  
					,@cBit080		OUTPUT	/* BIT080 - Versao da Tabela */  
					,@cBit081		OUTPUT	/* BIT081 - Controle de tabelas enviadas */  
					,@iResposta		OUTPUT	/* Codigo de Resposta Interno */  
  
			END  
			ELSE IF (@cBit003 = '008010')  
			BEGIN  
  
				EXEC [dbo].[pr_aut_RealizaCargaTabela]  
					 @cBit003		OUTPUT  
					,@cBit041  
					,@iCodigoEstabelecimento  
					,@bEstabMigrado  
					,@cBit059		OUTPUT  /* Bit utilizano no retorno de carga de tabelas*/  
					,@cBit060		OUTPUT  /* Bit utilizano no retorno de carga de tabelas*/  
					,@cBit080		OUTPUT	/* BIT080 - Versao da Tabela */  
					,@cBit081		OUTPUT	/* BIT081 - Controle de tabelas enviadas */  
					,@iResposta		OUTPUT	/* Codigo de Resposta Interno */  
  
			END  
			ELSE IF (@cBit070 = '005')  
			BEGIN  
			  
				EXEC [dbo].[pr_aut_RealizaCargaTabelaScope]  
					 @iCodigoEstabelecimento  
					,@bEstabMigrado  
					,@cBit123
					,@cBit042			OUTPUT  
					,@cBit063			OUTPUT  
					,@cBit120			OUTPUT  
					,@cBit121			OUTPUT  
					,@cBit122			OUTPUT  
					,@iResposta			OUTPUT	/* Codigo de Resposta Interno */  
					  
			END			  
			ELSE IF (@cBit003 IN ('008020', '008030'))  
			BEGIN  
				  
				EXEC [Autorizacao].[dbo].[pr_aut_InstalacaoDesbloqueio]  
					 @cBit003		OUTPUT  
					,@cBit012  
					,@cBit013  
					,@iRedeNumero  
					,@cBit039		OUTPUT  
					,@cBit041  
					,@iCodigoEstabelecimento  
					,@cBit062		OUTPUT  /* Ticket*/  
					,@iResposta		OUTPUT	/* Codigo de Resposta Interno */  
  
			END  
			ELSE  
			BEGIN  
  
				EXEC [dbo].[pr_aut_AberturaFechamento]  
					 @cBit003		OUTPUT  
					,@cBit012		OUTPUT		/* HORA LOCAL - POS */  
					,@cBit013		OUTPUT		/* DATA LOCAL - POS */  
					,@iRedeNumero				/* IDENTIFICAÇÃO DE REDE */  
					,@cBit039		OUTPUT		/* RESPOSTA */  
					,@cBit041					/* TERMINAL */  
					,@iCodigoEstabelecimento	/* ESTABELECIMENTO */  
					,@bEstabMigrado  
					,@cBit047		OUTPUT		/* Dados do terminal */  
					,@cProvedor					/* NOME IDENTIFICADOR PROVEDOR TEF */  
					,@cBit052		OUTPUT		/* CHAVE CRIPTO */  
					,@cBit059		OUTPUT  
					,@cBit060		OUTPUT  
					,@cBit061		OUTPUT  
					,@cBit062		OUTPUT  
					,@cBit063		OUTPUT  
					,@cBit070					/* CODIGO DE GERENCIAMENTO - 001 ABERTURA - 002 FECHAMENTO */  
					,@cBit080  
					,@cBit091		OUTPUT	/* BIT091 - INDICADOR DE CARGA DE TABELAS */  
					,@cBit124		OUTPUT	/* CHAVE 3DES PROVEDOR ITAUTEC SCOPE */  
					,@cBit123
					,@iResposta		OUTPUT	/* CODIGO DE RESPOSTA INTERNO */  
  
  
			END  
		END  
	END  
	ELSE IF (@iResposta = 0 AND @cBit001 NOT IN ('0202', '0610'))  
	BEGIN /* A estrutura dentro desse bloco condicional é baseada na documentação do padrão ISO8583 Cielo */  
  
		 /*    
		  Trava: ValorNaoPermitido    
		  Descricao: Transações com valor inferior ou igual á zero  / transações com valor acima de 5000 que não sejam do produto gestão de frota (Chamado Gestão de Risco 554419)  
		  Código: 58    
		 */    
		IF (@nValor_Transacao > 0.00 OR (@nValor_Transacao > 5000.00 and @iTpoPrdCodigo <> 60) OR @cMsgCodigo = '0110' OR @cBit105 <> '') /* @cBit105 - Inf adicionais Policard utilizadas no quitação de carta frete */  
		BEGIN  
			/*  
			Trava: CodigoRedeCapturaInvalido  
			Descricao: Código de rede do meio de captura inválido  
			Código: 304  
			*/  
			IF (@iRedeNumero > 0)  
			BEGIN  
				/*  
				Trava: EstabelecimentoInvalido  
				Descricao: Estabelecimento inválido  
				Código: 297  
				*/  
				IF (@iCodigoEstabelecimento > 0)  
				BEGIN  
				  
					/*  
					Trava: TerminalInvalido  
					Descricao: Terminal inválido  
					Código: 85  
					*/  
					IF (@cBit041 IS NOT NULL AND @cBit041 <> '')  
					BEGIN  
						/* 
						Trava: CartaoInvalido  
						Descricao: Cartao inválido  
						Código: 12  
						*/  
						IF (@cNumeroCartao IS NOT NULL AND @cNumeroCartao <> '')  
						BEGIN  
  
							IF (@cBaseOrigem = 'C')  
							BEGIN  
								IF (@cMsgCodigo= '0210')  
								BEGIN  
									IF @cBit003 NOT IN ('599000','599100','599110')  
									BEGIN  
										
										IF @iRedeCodigo = 27 AND EXISTS (select top 1 1 from Processadora.dbo.CardHubProduct t where t.Name = @cBit062)
										BEGIN
											EXEC Autorizador.dbo.PR_Aut_ValidateCardHubSale @cNumeroCartao, @nValor_Transacao, @cBit062, @iTpoPrdCodigo, @iResposta OUTPUT;
										END
										
									
										IF @iResposta = 0
										BEGIN
  
											EXEC [policard_603078].[dbo].[pr_aut_autoriza_trn_convenio]  
												 @cBit003			OUTPUT	/* Código de Processamento */  
												,@cBit007					/* Data e Hora GMT da Transação (MMDDHHMMSS) */  
												,@cBit011			OUTPUT	/* NSU do Meio de Captura */  
												,@cBit012					/* Hora da Transação (HHMMSS) */  
												,@cBit013					/* Data da Transação (MMDD) */  
												,@cBit014			OUTPUT	/* Data de Validade do Cartão */  
												,@cBit022  
												,@cBit037			OUTPUT	/* NSU da Rede de Captura */  
												,@cBit038			OUTPUT	/* NSU Policard - Comprovante Formgen */  
												,@cBit039			OUTPUT	/* Codigo de resposta*/  
												,@cBit041			OUTPUT	/* Identificação do Terminal */  
												,@cBit048			OUTPUT	/* Informações Adcionais */  
												,@cBit052			OUTPUT	/* Senha Criptografada */  
												,@cBit062			OUTPUT	/* Ticket da transação */  
												,@cBit063			OUTPUT	/* Ticket da transação */  
												,@cBit067					/* Qtde de parcelas */  
												,@cBit105			OUTPUT	/* Dados Gestão de frota */  
												,@cBit112					/* Quantidade de parcelas Stone */  
												,@cBit122  
												,@cBit123
												,@cBit047			OUTPUT
												,@cBit127			OUTPUT	/* NSU Policard*/  
												,@cNumeroCartao		OUTPUT	/* Número do Cartão */  
												,@nValor_Transacao	OUTPUT	/* Valor da Transação */  
												,@dDataHora_Transacao		/* Data e Hora Corrente (GETDATE) */  
												,@iRedeNumero				/* Código de Identificação da Rede de Captura */  
												,@iCodigoEstabelecimento	/* Código de Identificação do Estabelecimento (Filiação) */  
												,@bEstabMigrado  
												,@iTipoMeioCaptura  
												,@bSenhaCapturada  
												,@iResposta			OUTPUT	/* Código de Resposta Interno */  
												,@iRespostaRecarga	OUTPUT	/* Código de Resposta Interno */  
										END
																																	  
									END   
									ELSE  
									BEGIN  
  
										EXEC Policard_603078.dbo.pr_AUT_Autorizar_Pagamento_Convenio  
											 @cNumeroCartao						-- Número do Cartão  
											,@cBit003							-- Código de Processamento  
											,@nValor_Transacao					-- Valor da Transação  
											,@cBit067							-- Quantidade de parcelas do pagamento de contas  
											,@cBit007							-- Data e Hora GMT da Transação (MMDDHHMMSS)  
											,@dDataHora_Transacao  
											,@cBit011							-- Número de identificação da transação da solução de captura  
											,@cBit012							-- Hora da transação (HHMMSS)  
											,@cBit013							-- Data da transação (MMDD)  
											,@iRedeNumero						-- Código de Identificação da Rede de Captura  
											,@cBit127					OUTPUT	-- NSU da Rede de Captura  
											,@cBit038					OUTPUT	-- Authorization Identification Response  
											,@cBit041							-- Identificação do terminal  
											,@iCodigoEstabelecimento						-- Código de identificação do Estabelecimento (Filiação)  
											,@bEstabMigrado  
											,@cBit052							-- Senha Criptografada  
											,@cBit062					OUTPUT	-- Ticket da transação  
											,@iResposta					OUTPUT  
									  
									END  
								END  
								ELSE IF (@cMsgCodigo= '0410')  
								BEGIN  
  
									IF (@cCodProcessOrig NOT IN ('599000','599100','599110'))  
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
											  
									END  
									ELSE  
									BEGIN	  
  
										EXEC Policard_603078.dbo.pr_aut_estornar_pagamento_convenio  
											 @cBit041  
											,@iCodigoEstabelecimento  
											,@bEstabMigrado  
											,@nValor_Transacao  
											,@cBit127				OUTPUT  
											,@cBit011  
											,@iRedeNumero  
											,@cBit038				OUTPUT	/* NSU Policard - Comprovante Formgen */  
											,@cBit062				OUTPUT  
											,@iResposta				OUTPUT  
  
									END	  
								END  
								ELSE IF (@cMsgCodigo = '0430')  
								BEGIN  
  
									IF (@cCodProcessOrig NOT IN ('599000','599100','599110'))  
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
									ELSE  
									BEGIN  
  
										EXEC [Policard_603078].[dbo].[pr_aut_desfazer_pagamento_convenio]  
											 @cBit041				/* Identificação do Terminal */	  
											,@iCodigoEstabelecimento/* Código de Identificação do Estabelecimento (Filiação) */  
											,@bEstabMigrado			/* Estabelecimento migrado para novo Acquirer */  
											,@nValor_Transacao		/* Valor da Transação */  
											,@cBit127				/* NSU HOST POLICARD */  
											,@cBit011		  		/* NSU do Meio de Captura */  
											,@iRedeNumero  
											,@iResposta		 OUTPUT /* Código de Resposta Interno */  
									  
									END  
								END  
								ELSE IF (@cMsgCodigo= '0110')  
								BEGIN  
  
									EXEC [Policard_603078].[dbo].[pr_aut_ConsultaSaldo_Convenio]  
										 @cNumeroCartao  
										,@iRedeNumero				OUTPUT  
										,@cBit041					OUTPUT  
										,@iCodigoEstabelecimento	OUTPUT  
										,@cBit052  
										,@cBit062					OUTPUT  
										,@iResposta					OUTPUT  
										,@dDataHora_Transacao  
										,@cBit048  
								END  
							END  
							ELSE  
							BEGIN  
  
								IF (@cMsgCodigo= '0210')  
								BEGIN  
									
									IF @iRedeCodigo = 27 AND EXISTS (select top 1 1 from Processadora.dbo.CardHubProduct t where t.Name = @cBit062)
									BEGIN
										EXEC Autorizador.dbo.PR_Aut_ValidateCardHubSale @cNumeroCartao, @nValor_Transacao, @cBit062, @iTpoPrdCodigo, @iResposta OUTPUT;
									END
								
									IF @iResposta = 0
									BEGIN
									
  
										EXEC [dbo].[pr_aut_AutorizarProcessadora]  
											 @cBit003					OUTPUT	/* Código de Processamento */  
											,@cBit004							/* Valor Transacao */  
											,@cBit007							/* Data e Hora GMT da Transação (MMDDHHMMSS) */  
											,@cBit011							/* NSU do Meio de Captura */  
											,@cBit012							/* Hora da Transação (HHMMSS) */  
											,@cBit013							/* Data da Transação (MMDD) */  
											,@cBit014					OUTPUT	/* Data Validade do Cartão */  
											,@cBit022							/* Modo de entrada */  
											,@cBit037					OUTPUT	/* NSU da Rede de Captura */  
											,@cBit038					OUTPUT	/* NSU Policard - Comprovante Formgen */  
											,@cBit039					OUTPUT	/* Codigo de resposta*/  
											,@cBit041							/* Identificação do Terminal */  
											,@cBit048					OUTPUT	/* Informações Adcionais */  
											,@cBit052					OUTPUT	/* Senha Criptografada */  
											,@cBit060					OUTPUT	/* Dados Adicionais de Terminal */  
											,@cBit062					OUTPUT	/* Ticket da transação */  
											,@cBit063					OUTPUT	/* Ticket da transação */  
											,@cBit105					OUTPUT	/* Informações de Quitação para o produto PoliFrete */  
											,@cBit123  
											,@cBit047					OUTPUT  
											,@cBit127					OUTPUT	/* NSU Policard - Comprovante Formgen */  
											,@cNumeroCartao				OUTPUT	/* Número do Cartão */  
											,@nValor_Transacao			OUTPUT	/* Valor da Transação */  
											,@dDataHora_Transacao				/* Data e Hora Corrente (GETDATE)*/  
											,@iRedeNumero						/* Código da Rede na Tabela Redes */  
											,@iMeiCptCodigo  
											,@iCodigoEstabelecimento	OUTPUT	/* Código de Identificação do Estabelecimento (Filiação) */  
											,@bEstabMigrado				  
											,@bSenhaCapturada  
											,@iResposta					OUTPUT	/* Código de Resposta Interno */  
											
									END
  
								END  
								ELSE IF (@cMsgCodigo= '0410')  
								BEGIN  
									
									DECLARE @transactionId BIGINT = convert(BIGINT, @cBit127);
									EXEC Autorizador.dbo.PR_Aut_ParantezTransaction @iCodigoEstabelecimento
										,@transactionId
										,'P'
										,@cNumeroCartao
										,1
										,@returnCode OUTPUT
										,@returnMessage OUTPUT;									
								  
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
										  
  
								END  
								ELSE IF (@cMsgCodigo= '0430')  
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
								ELSE IF (@cMsgCodigo= '0110')  
								BEGIN  
  
									EXEC[dbo].[pr_aut_ConsultaSaldoProcessadora]  
										 @cBit003  
										,@cNumeroCartao  
										,@iRedeNumero				OUTPUT  
										,@iCodigoEstabelecimento	OUTPUT  
										,@bEstabMigrado  
										,@cBit062					OUTPUT  
										,@cBit041  
										,@cBit011					  
										,@dDataHora_Transacao  
										,@iResposta					OUTPUT  
								END  
							END  
						END  
						ELSE   
							SET @iResposta = 12  /* CARTAO INVALIDO OU INEXISTENTE */  
					END  
					ELSE   
						SET @iResposta = 85 /* TERMINAL INVALIDO OU INEXISTENTE */  
				END  
				ELSE   
					SET @iResposta = 297 /* ESTABELECIMENTO INVALIDO */  
			END  
			ELSE   
				SET @iResposta = 304 /* CODIGO REDE DE CAPTURA NAO CADASTRADO */  
		END  
		ELSE   
			SET @iResposta = 58 /* VALOR INVALIDO - MENSAGEM INVALIDA */  
	END  
  
	IF  (@cBit001 NOT IN ('0202', '0610'))  
	BEGIN  
  
		IF (@iRedeNumero = 10)  
		BEGIN  
			EXEC pr_aut_ConsultaRespostaCielo @iResposta, @cBit039 OUTPUT  
			SET @cBit062 = ''  
		END  
		ELSE IF (@iRedeNumero = 29)  
			EXEC pr_Consulta_RespostaRedecard @iResposta, @cBit039 OUTPUT  
		ELSE  
		BEGIN  
  
			IF @iRedeNumero IN (16,17,19,27,37,44)  
			BEGIN  
	  
				DECLARE	  
					 @cResult			VARCHAR(1000)  
					,@cMsgDisplay		VARCHAR(1000)  
					,@cResposta			CHAR(3)  
					,@cRespostaRecarga	CHAR(3)  
  
				IF (LTRIM(RTRIM(@cBit062)) = '')  
					SET @cBit062 = ' | | '  
  
				IF (@cBit003 = '599002')  
				BEGIN  
  
					IF (@iResposta = 0)  
					BEGIN  
  
						SELECT   
							@cBit039		= Codigo_Resposta,   
							@cMsgDisplay	= COALESCE(descricao, 'OUTROS'),  
							@cResult		= COALESCE(descricao, 'OUTROS')  
						FROM   
							Aut_CodigosRespostaRecargaCelular WITH(NOLOCK)  
						WHERE   
							codigo = @iRespostaRecarga  
					END  
					ELSE  
					BEGIN   
  
						SELECT   
							@cBit039		= codigo_policard,   
							@cMsgDisplay	= COALESCE(descricao, descricao_policard),  
							@cResult		= descricao_policard  
						FROM   
							aut_CodigosResposta WITH(NOLOCK)  
						WHERE   
							codigo = @iResposta  
							  
					END  
						  
					IF (@iResposta <> 0 OR @iRespostaRecarga <> 0)  
						SET @bEnviaPush = 0  
  
					SET @cResposta = CONVERT(VARCHAR,@iResposta)  
					SET @cRespostaRecarga = ISNULL(CONVERT(VARCHAR,@iRespostaRecarga),'1')  
					SET @cBit062 = @cBit062 + '|' + @cResposta + '|' + @cRespostaRecarga + '|' + @cResult + '|' + @cMsgDisplay + '|'  
					--SET @cBit062 = @cBit062 + '|' + @cResposta + '|' + @cResult + '|' + @cMsgDisplay + '|'  
  
				END  
				ELSE  
				BEGIN  
				  
					SELECT   
						@cBit039		= codigo_policard,   
						@cMsgDisplay	= COALESCE(descricao, descricao_policard),  
						@cResult		= descricao_policard  
					FROM   
						aut_CodigosResposta WITH(NOLOCK)  
					WHERE   
						codigo = @iResposta  
  
					SET @cResposta = CONVERT(VARCHAR,@iResposta)  
					SET @cBit062 = @cBit062 + '|' + @cResposta + '|' + @cResult + '|' + @cMsgDisplay + '|'  
  
				END  
  
			END  
			ELSE  
			BEGIN  
  
				/* Realizar a substituição dos campos */  
				IF (@iResposta = 0 AND @cMsgCodigo <> '0430')  
				BEGIN  
			  
					IF (@cMsgCodigo IN ('0210', '0410', '0110'))  
					BEGIN  
			  
						SET @cBit062 = REPLACE(@cBit062, '<CARTAO>', SUBSTRING(@cNumeroCartao,1,6) + '******' + SUBSTRING(@cNumeroCartao,13,4))  
						SET @cBit062 = REPLACE(@cBit062, '<CNPJ>', COALESCE(@cCNPJ_Estabelecimento,''))  
						SET @cBit062 = REPLACE(@cBit062, '<NOME_ESTABELECIMENTO>', @cNome_Estabelecimento)  
						SET @cBit062 = REPLACE(@cBit062, '<ENDERECO>', COALESCE(@cEndereco_Estabelecimento,''))  
						SET @cBit062 = REPLACE(@cBit062, '<CIDADE>', COALESCE(@cCidade_Estabelecimento, ''))  
						SET @cBit062 = REPLACE(@cBit062, '<ESTADO>', COALESCE(@cEstado_Estabelecimento,''))  
						SET @cBit062 = REPLACE(@cBit062, '<NSU_HOST>', CASE WHEN @iRedeNumero IN (10,58) THEN dbo.f_ZerosEsquerda(@cBit038,6) ELSE @cBit127 END)  
						SET @cBit062 = REPLACE(@cBit062, '<NSU_LOJA>', COALESCE(@cBit011,''))  
						SET @cBit062 = REPLACE(@cBit062, '<CODIGO_ESTABELECIMENTO>', CONVERT(VARCHAR,CONVERT(BIGINT, @cBit042)))  
						SET @cBit062 = REPLACE(@cBit062, '<TERMINAL>', @cBit041)  
						SET @cBit062 = REPLACE(@cBit062, '<DATA>',dbo.f_ZerosEsquerda(CONVERT(VARCHAR,DAY(GETDATE())), 2) + '/' + dbo.f_ZerosEsquerda(CONVERT(VARCHAR,MONTH(GETDATE())), 2))  
						SET @cBit062 = REPLACE(@cBit062, '<HORA>', SUBSTRING (CONVERT(VARCHAR, GETDATE(), 108 ),1,5))  
						SET @cBit062 = REPLACE(@cBit062, '<VALOR>', COALESCE(CONVERT(VARCHAR, CONVERT(DECIMAL(15,2), CONVERT(DECIMAL(15,2),@nValor_Transacao))),''))  
					  
						IF (@iRedeNumero = 7 AND @cBit123 LIKE 'SCOPE%') /*Ticket impresso sem saldo disponivel do usuario*/  
						BEGIN  
							--EXEC autorizacao..pr_aut_BuscaMensagemTicket @iTpoPrdCodigo, @iCodTipoTransacao, @iRedeNumero, @cBit063 OUTPUT
							
							SET @cBit063 = REPLACE(@cBit063, '<CARTAO>', SUBSTRING(@cNumeroCartao,1,6) + '******' + SUBSTRING(@cNumeroCartao,13,4))  
							SET @cBit063 = REPLACE(@cBit063, '<CNPJ>', COALESCE(@cCNPJ_Estabelecimento,''))  
							SET @cBit063 = REPLACE(@cBit063, '<NOME_ESTABELECIMENTO>', @cNome_Estabelecimento)  
							SET @cBit063 = REPLACE(@cBit063, '<ENDERECO>', COALESCE(@cEndereco_Estabelecimento,''))  
							SET @cBit063 = REPLACE(@cBit063, '<CIDADE>', COALESCE(@cCidade_Estabelecimento, ''))  
							SET @cBit063 = REPLACE(@cBit063, '<ESTADO>', COALESCE(@cEstado_Estabelecimento,''))  
							SET @cBit063 = REPLACE(@cBit063, '<NSU_HOST>', CASE WHEN @iRedeNumero IN (10,58) THEN dbo.f_ZerosEsquerda(@cBit038,6) ELSE @cBit127 END)  
							SET @cBit063 = REPLACE(@cBit063, '<NSU_LOJA>', COALESCE(@cBit011,''))  
							SET @cBit063 = REPLACE(@cBit063, '<CODIGO_ESTABELECIMENTO>', CONVERT(VARCHAR,CONVERT(BIGINT, @cBit042)))  
							SET @cBit063 = REPLACE(@cBit063, '<TERMINAL>', @cBit041)  
							SET @cBit063 = REPLACE(@cBit063, '<DATA>',dbo.f_ZerosEsquerda(CONVERT(VARCHAR,DAY(GETDATE())), 2) + '/' + dbo.f_ZerosEsquerda(CONVERT(VARCHAR,MONTH(GETDATE())), 2))  
							SET @cBit063 = REPLACE(@cBit063, '<HORA>', SUBSTRING (CONVERT(VARCHAR, GETDATE(), 108 ),1,5)) 
							SET @cBit063 = REPLACE(@cBit063, '<VALOR>', COALESCE(CONVERT(VARCHAR, CONVERT(DECIMAL(15,2), CONVERT(DECIMAL(15,2),@nValor_Transacao))),''))  
	  
						END  
					END  
					ELSE IF (@cMsgCodigo NOT IN ('0510','0810') AND @cBit003 NOT IN ('','008010'))/*Relatorio ou Carga de tabela*/  
						EXEC pr_aut_ConsultarRespostaPolicard @iResposta, @iRedeNumero, @cBit039 OUTPUT, @cBit062 OUTPUT  
							  
				END  
				ELSE  
				BEGIN  
				 
					DECLARE @cSaldo VARCHAR(1000)  
					  
					SET @cSaldo = @cBit062  
  
					EXEC pr_aut_ConsultarRespostaPolicard @iResposta, @iRedeNumero, @cBit039 OUTPUT, @cBit062 OUTPUT  
  
					IF (@iResposta IN (92,93,94))  
						SET @cBit062 = @cBit062 + 'R$ ' + @cSaldo  
  
				END  
			END  
		END  
	END  
		  
	/*Inserindo na tabela de transacoes negadas*/  
	IF ( @cBit001 IN ('0110','0210','0410') AND (@iResposta <> 0 OR @iRespostaRecarga <> 0))  
	BEGIN  
  
		DECLARE @iRespAuxiliar			INT  
				,@bNegadaOperadora		BIT  
				,@cTipoTransacaoExterno	CHAR(2)  
				,@iQuantParcelas		INT  
				,@iTipoFinanciamento	INT  
				,@dDataPrimeiraParcela	DATETIME  
  
		SET @iRespAuxiliar = 0  
		SET @bNegadaOperadora = 0  
  
		IF (LEN(@cBit067) = 2)  
			SET @iQuantParcelas = CONVERT(INT, @cBit067)  
		ELSE IF (@iRedeNumero IN (10,58))  
			EXEC pr_aut_LeInfoAdicionais_VendaParcelada @cBit048, @iTipoFinanciamento OUTPUT, @iQuantParcelas OUTPUT, @dDataPrimeiraParcela OUTPUT  
			  
		IF @cBaseOrigem = 'P'  
		BEGIN  
  
			SET @iRespAuxiliar = @iResposta  
  
			IF (@cBit003 = '002000' OR @cBit003 = '003000')  
			BEGIN  
				IF LEN(@cBit105) = ''  
					SET @cTipoTransacaoExterno = 'VV' /* Venda a vista */  
				ELSE  
					SET @cTipoTransacaoExterno = 'QT' /* QUITACAO DE FRETE*/  
  
			END  
			ELSE IF @cBit003 = '001000'  
			BEGIN  
				IF @iQuantParcelas > 1  
					SET @cTipoTransacaoExterno = 'VP' /* Venda parcelada sem juros */  
				ELSE  
				BEGIN  
					SET @cTipoTransacaoExterno = 'VV' /* Venda a vista */  
				END  
			END  
			ELSE IF @cBit003 = '002100'  
				SET @cTipoTransacaoExterno = 'SQ'  
							  
			SELECT	@iCodTipoTransacao		= CodTipoTransacao  
			FROM Autorizador.dbo.TiposProdutosTiposTransacoes WITH(NOLOCK)  
			WHERE CodTipoProduto = @iTpoPrdCodigo  
			AND TipoTransacao = @cTipoTransacaoExterno  
  
			IF (@iCodTipoTransacao IS NULL)  
				SET @iCodTipoTransacao = @cBit003  
	  
		END  
		ELSE  
		BEGIN  
  
			IF (@iResposta <> 0 AND (@iRespostaRecarga = 0 OR @iRespostaRecarga IS NULL))  
				SET @iRespAuxiliar = @iResposta  
			ELSE   
			BEGIN  
			  
				SET @bNegadaOperadora = 1  
				SET @iRespAuxiliar = @iRespostaRecarga  
  
			END  
  
			IF (@cBit003 IN ('001000', '002000', '172000', '003000'))  
			BEGIN  
				IF (@iQuantParcelas > 1)  
					SET @iCodTipoTransacao = '320000' -- Venda parcelada sem juros  
				ELSE  
					SET @iCodTipoTransacao = '300000' -- Venda a vista / Resgate de Pontos  
  
			END  
			ELSE   
				SET @iCodTipoTransacao = @cBit003  
  
		END  
		  
		/* Gerando o numero da Autorizacao */  
		SET @cAutorizacao = [dbo].[f_GerarAutorizacao]()  
  
		INSERT INTO Processadora.dbo.TransacoesNegadas  
		   (  CodEstabelecimento  
		   ,CodTipoTransacao  
		          ,CodCartao  
		          ,CodTipoProduto  
		          ,CodTipoMeioCaptura  
		          ,CodRede  
		          ,CodCliente  
		          ,CodFranquia  
		          ,CodResposta  
		          ,BaseOrigem  
		          ,TipoMensagem  
		          ,Valor  
 				  ,QtdParcelas		          
		          ,Data  
		          ,DataGMT  
		 ,DataLocal  
		          ,HoraLocal  
		          ,Terminal  
		          ,Provedor  
		          ,Autorizacao  
		          ,Comprovante  
		          ,NSUOrigem  
		          ,NSUPolicard  
		          ,Senha  
		          ,SenhaCapturada  
		          ,SenhaValida  
		          ,CartaoEMV  
		          ,ModoEntrada  
		          ,Migrado  
				  ,NegadaOperadora  
		        )  
		VALUES  (  @iCodigoEstabelecimento 		-- CodEstabelecimento - int  
		          ,@iCodTipoTransacao	-- CodTipoTransacao - int  
		          ,@iCrtUsrCodigo 		-- CodCartao - int  
		          ,@iTpoPrdCodigo 		-- CodTipoProduto - int  
		          ,@iTipoMeioCaptura	-- TipoMeioCaptura - int  
		          ,@iRedeCodigo 		-- CodRede - int  
		 ,@iCliente 			-- CodCliente - int  
		          ,@iFranquiaUsuario	-- CodFranquia - int  
		          ,@iRespAuxiliar		-- CodResposta - int  
		          ,@cBaseOrigem			-- BaseOrigem --char(1)  
		          ,@cBit001 			-- TipoMensagem - char(4)  
		          ,@nValor_Transacao	-- Valor - decimal  
		          ,@iQuantParcelas		-- Quantidade de parcelas - int
		          ,GETDATE() 			-- Data - datetime  
		          ,@cBit007 			-- DataGMT - varchar(10)  
		          ,@cBit013 			-- DataLocal - char(4)  
		          ,@cBit012 			-- HoraLocal - char(6)  
		          ,@cBit041 			-- Terminal - char(8)  
		          ,@cProvedor 			-- Provedor - varchar(50)  
		          ,@cAutorizacao 		-- Autorizacao - char(18)  
		          ,SUBSTRING(@cAutorizacao,13,6) -- Comprovante - char(6)  
		          ,@cBit011 			-- NSUOrigem - char(6)  
		          ,NULL					-- NSUPolicard - char(9)  
		          ,@cBit052 			-- Senha - varchar(16)  
		          ,@bSenhaCapturada		-- SenhaCapturada - bit  
		          ,@bSenhaValida		-- SenhaValida - bit  
		          ,@bCartaoEmv 			-- CartaoEMV - bit  
		          ,@cBit022				-- ModoEntrada - tinyint  
		          ,@bEstabMigrado  
				  ,@bNegadaOperadora  
		          )  
  
	END  
	  
	/*Inserindo na tabela de transacoes desfeitas*/  
	IF (@iResposta = 0 AND @cBit001 = '0430')  
	BEGIN  
		  
		/* Gerando o numero da Autorizacao */  
		SET @cAutorizacao = [dbo].[f_GerarAutorizacao]()  
		  
		INSERT INTO Processadora.dbo.TransacoesDesfeitas  
		        (  CodEstabelecimento  
		          ,CodTipoTransacao  
		    ,CodCartao  
		          ,CodTipoProduto  
		          ,CodTipoMeioCaptura  
		          ,CodRede  
		          ,CodCliente  
		          ,CodFranquia  
		          ,CodResposta  
		          ,BaseOrigem  
		          ,TipoMensagem  
		          ,Valor  
		          ,Data  
		    ,DataGMT  
		          ,DataLocal  
		          ,HoraLocal  
		          ,Terminal  
		          ,Provedor  
		          ,Autorizacao  
		          ,Comprovante  
		          ,NSUOrigem  
		  ,NSUPolicard  
		          ,CartaoEMV  
		          ,ModoEntrada  
		          ,Migrado  
		        )  
		VALUES  (  @iCodigoEstabelecimento		-- CodEstabelecimento - int  
		          ,@cBit003				-- CodTipoTransacao - int  
		          ,@iCrtUsrCodigo		-- CodCartao - int  
		          ,@iTpoPrdCodigo		-- CodTipoProduto - int  
		          ,@iTipoMeioCaptura	-- CodTipoMeioCaptura - int  
		          ,@iRedeCodigo			-- CodRede - int  
		          ,@iCliente			-- CodCliente - int  
		          ,@iFranquiaUsuario	-- CodFranquia - int  
		          ,@iResposta			-- CodResposta - int  
		          ,@cBaseOrigem			-- BaseOrigem - char(1)  
		          ,@cBit001 			-- TipoMensagem - char(4)  
		          ,@nValor_Transacao	-- Valor - decimal  
		          ,GETDATE() 			-- Data - datetime  
		          ,@cBit007 			-- DataGMT - varchar(10)  
		          ,@cBit013 			-- DataLocal - char(4)  
		          ,@cBit012 			-- HoraLocal - char(6)  
		          ,@cBit041 			-- Terminal - char(8)  
		          ,@cProvedor 			-- Provedor - varchar(50)  
		          ,@cAutorizacao		-- Autorizacao - char(18)  
		          ,SUBSTRING(@cAutorizacao,13,6) -- Comprovante - char(6)  
		          ,@cBit011				-- NSUOrigem - char(6)  
		          ,@cBit127 			-- NSUPolicard - char(9)  
				  ,@bCartaoEmv 			-- CartaoEMV - bit  
		          ,@cBit022 			-- ModoEntrada - smallint  
		          ,@bEstabMigrado		-- Migrado - bit  
		        )  
	  
	END  
  
	/* Inserindo no monitoramento de validacao de senha, exceto CRM,SIGRA e AVI */  
	IF (@cMsgCodigo IN ('0110','0210') AND @iResposta IN (0,27,42,65,86) AND @iRedeNumero NOT IN (16,17,19,37))  
	BEGIN  
		  
		DECLARE @iTempoSegundos	INT  
				,@cBIN CHAR(6)  
  
		SET	@cBIN = LEFT(@cNumeroCartao,6)  

		SET @iTempoSegundos = DATEDIFF(SECOND, @dDataHora_Transacao, GETDATE())  

		INSERT INTO dbo.MonitorSenhaTransacoes  
				(Data  
				,TrnCodigo  
				,Estabelecimento  
				,Terminal  
				,Provedor  
				,Rede  
				,NSU   
				,Valor  
				,Senha  
				,SenhaValida  
				,BaseOrigem  
				,BIN  
			 	,PrdCodigo  
				,TpoPrdCodigo  
				,CrtUsrCodigo  
				,CntUsrCodigo  
				,TempoSegundos  
				,Resposta  
				,SenhaCapturada  
				,Franquia_Usuario  
				,Usuario  
				)  
		VALUES(	@dDataHora_Transacao  
				,@cBit127  
				,@iCodigoEstabelecimento   
				,@cBit041  
				,@cProvedor  
				,@iRedeNumero  
				,@cBit011  
				,@nValor_Transacao  
				,@cBit052  
				,@bSenhaValida  
				,@cBaseOrigem  
				,@cBIN  
				,@iPrdCodigo  
				,@iTpoPrdCodigo  
				,@iCrtUsrCodigo  
				,@iCntUsrCodigo  
				,@iTempoSegundos  
				,@iResposta  
				,@bSenhaCapturada  
				,@iFranquiaUsuario  
				,@iUsuario  
				)  
	END	  
  
	/* Bits que devem ser retornados em branco nas  transações */  
	IF @cMsgCodigo IN ('0110','0210','0410','0430','0810')  
	BEGIN 
		
		IF (@cMsgCodigo = '0810')  
		BEGIN  
			  
			SET @cBit024 = ''  
			SET @cBit048 = ''  
			  
			/*Carga de Tabela*/  
			IF @cBit003 = '008010'   
				SET @cBit070 = ''  
			ELSE  
				SET @cBit080 = ''
  
		END
		ELSE IF @cMsgCodigo = '0210' AND @cBit123 LIKE 'SCOPE%'
		BEGIN
			SET @cBit022 = ''
			SET @cBit035 = ''
			SET @cBit052 = ''
			SET @cBit061 = ''
			SET @cBit124 = ''				
			SET @cBit055 = '8A023030'

			IF (@iResposta = 0 AND @cMsgCodigo IN ('0210','0410','0430'))  
				SET @iTrnCodigo = CONVERT(INT, @cBit127)  

		END
		ELSE  
		BEGIN	  
	  
			SET @cBit002 = ''  
			SET @cBit014 = ''  
			SET @cBit018 = ''  
			SET @cBit022 = ''  
			SET @cBit023 = ''  
			SET @cBit024 = ''  
			SET @cBit035 = ''  
			SET @cBit043 = ''  
			SET @cBit045 = ''  
			SET @cBit052 = ''  
			SET @cBit055 = ''  
			SET @cBit059 = ''  
			SET @cBit060 = ''  
			SET @cBit061 = ''  
			SET @cBit067 = ''  
			SET @cBit104 = ''  
			SET @cBit120 = ''  
			SET @cBit125 = ''  
  
			IF (@iResposta = 0 AND @cMsgCodigo IN ('0210','0410','0430'))  
				SET @iTrnCodigo = CONVERT(INT, @cBit127)  
  
			/*POS CIELO e POS Walk nao utilizam alguns bits*/  
			IF (@iRedeNumero IN (10,58))  
			BEGIN  
				SET @cBit015 = ''  
				SET @cBit037 = ''  
				SET @cBit127 = ''  
			END  
			ELSE IF (@iRedeNumero = 29)  
			BEGIN  
  
				SET @cBit015 = ''  
				SET @cBit048 = ''  
				SET @cBit127 = dbo.f_ZerosEsquerda(@cBit038,9)  
				SET @cBit038 = ''  
				SET @cBit063 = ''  
  
				IF @cMsgCodigo = '0430'  
					SET @cBit013 = ''  
  
				IF (@cBit039 = '72')  
					SET @cBit062 = dbo.f_ZerosEsquerda(REPLACE(@cBit062,'.',''),11)  
				ELSE IF (@iResposta <> 0)  
					SET @cBit062 = ''  
  
			END  
			ELSE IF (@iRedeNumero = 30)  
			BEGIN  
				SET @cBit015 = @cBit013  
				SET @cBit048 = ''  
				SET @cBit123 = ''  
			END  
			ELSE IF (@iRedeNumero = 31)  
			BEGIN  
				SET @cBit012 = ''  
				SET @cBit013 = ''  
				SET @cBit015 = ''  
				SET @cBit019 = ''  
				SET @cBit032 = ''  
				SET @cBit062 = ''  
  
				IF (@cBit003 = '000200' AND @cBit048 <> '')  
					SET @cBit054 = '0202986C0' + SUBSTRING (@cBit048,8,11)  
				  
				SET @cBit048 = ''  
				SET @cBit090 = ''  
				--SET @cBit112 = ''  
				--SET @cBit127 = ''  
			END  
  
  
			ELSE IF @cProvedor = 'SCOPEPRIVATE'  
				SET @cBit015 = ''  
			ELSE  
			BEGIN  
  
				SET @cBit015 = @cBit013  
				  
				IF (@iResposta <> 0)  
					SET @cBit048 = ''  
			END  
				  
			IF (@cMsgCodigo = '0430')  
			BEGIN  
  
				SET @cBit015 = ''  
				SET @cBit048 = ''  
				SET @cBit062 = ''  
  
				IF @iRedeNumero <> 29  
					SET @cBit049 = ''  
				  
				/*Desfazimento nao encontrado, setando bit39 = 00*/  
				IF (@iResposta IN (270,271))  
					SET @cBit039 = '00'  
  
				/*Codigo de autorizacao de desfazimento somente CIELO e POS Walk*/  
				IF (@iRedeNumero NOT IN (10,58))  
					SET @cBit038 = ''  
  
			END				  
		  
		END		  
	END  
	  
	SET @cBit105 = ''  
	SET @cBit039 = REPLICATE('0', 2 - LEN(@cBit039)) + @cBit039  
END  
