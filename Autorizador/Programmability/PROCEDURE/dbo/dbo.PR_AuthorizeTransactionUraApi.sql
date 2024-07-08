/* 
-------------------------------------------------------------------------------- 
-- NOME:      dbo.PR_AuthorizeTransactionUraApi   
--      
-- DESCRIÇÃO: Criação da procedure para realizar transações via URA/Vocalcom. 
--               
-- AUTOR:     Guilherme Brito Garcia 
-- DATA:      2021-04-23   
-- CHAMADO:   1702570   
-------------------------------------------------------------------------------- 
Data: 08/09/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1843805
Descrição: Projeto ABECS para transações NCR/Scope.
-------------------------------------------------------------------------- 	
*/ 
CREATE PROCEDURE [dbo].[PR_AuthorizeTransactionUraApi] 
	@transactionMessageTypeId VARCHAR(4) = '0210', 
	@cardNumber VARCHAR(16), 
	@transactionProcessId VARCHAR(6) = '002000', 
	@transactionValue VARCHAR(12), 
	@transactionDate VARCHAR(14), --YYYYMMDDHHMMSS 
	@providerId VARCHAR(15), 
	@phoneNumber VARCHAR(15) = '000000000000000', 
	@installments VARCHAR(2) = '01', 
	@cvv VARCHAR(4) 
AS 
BEGIN 
	SET NOCOUNT ON; 
	DECLARE @bEnviaPush BIT,  
		@cBaseOrigem CHAR(1),  
		@iTrnCodigo INT,  
		@iCntAppCodigo INT,  
		@iResposta INT, 
		@networkId VARCHAR(3) = '020', --URA 
		@terminalId VARCHAR(8) = '88888888', 
		@cNSU_MeioCaptura CHAR(6),
		@cMsgErro VARCHAR(MAX)
 
	/*Gerando NSU_LOJA para URA*/ 
	IF (CONVERT(INT,@networkId) = 20) 
		EXEC pr_AUT_GerarNSUTransacoes @cNSU_MeioCaptura OUT, 6 
 
	DECLARE @cBIT001 VARCHAR(1000) = @transactionMessageTypeId --Código da Mensagem 
	DECLARE @cBIT002 VARCHAR(1000) = @cardNumber--'6030788401854731' --Número do cartão (Presente somente quando digitado) 
	DECLARE @cBIT003 VARCHAR(1000) = @transactionProcessId --Código de Processamento: 001000 – Venda Crédito / 002000 – Venda Débito/Voucher 
	DECLARE @cBIT004 VARCHAR(1000) = @transactionValue --Valor da Transação 
	DECLARE @cBIT005 VARCHAR(1000) = '0' 
	DECLARE @cBIT006 VARCHAR(1000) = '0' 
	DECLARE @cBIT007 VARCHAR(1000) = SUBSTRING(@transactionDate, 5, 10) --Data/Horário da Transação. Formato: MMDDHHMMSS 
	DECLARE @cBIT008 VARCHAR(1000) = '0' 
	DECLARE @cBIT009 VARCHAR(1000) = '0' 
	DECLARE @cBIT010 VARCHAR(1000) = '0' 
	DECLARE @cBIT011 VARCHAR(1000) = @cNSU_MeioCaptura --NSU (Número Sequencial Único) 
	DECLARE @cBIT012 VARCHAR(1000) = SUBSTRING(@transactionDate, 9, 6) --Hora Local da Transação. Formato: HHMMSS 
	DECLARE @cBIT013 VARCHAR(1000) = SUBSTRING(@transactionDate, 11, 4) --Data Local da Transação. Formato: MMDD 
	DECLARE @cBIT014 VARCHAR(1000) = '0' 
	DECLARE @cBIT015 VARCHAR(1000) = '0' 
	DECLARE @cBIT016 VARCHAR(1000) = '0' 
	DECLARE @cBIT017 VARCHAR(1000) = '0' 
	DECLARE @cBIT018 VARCHAR(1000) = '0' 
	DECLARE @cBIT019 VARCHAR(1000) = '0' 
	DECLARE @cBIT020 VARCHAR(1000) = '0' 
	DECLARE @cBIT021 VARCHAR(1000) = '0' 
	DECLARE @cBIT022 VARCHAR(1000) = '011' --Modo de Entrada: 011 – Número do Cartão Digitado / 021 – Leitura Magnética / 051 – Chip EMV || ** Somente se um dos seguintes bits estiver presente: 2 ou 35 
	DECLARE @cBIT023 VARCHAR(1000) = '0' 
	DECLARE @cBIT024 VARCHAR(1000) = @networkId --Identificação da Rede: 020 - URA 
	DECLARE @cBIT025 VARCHAR(1000) = '0' 
	DECLARE @cBIT026 VARCHAR(1000) = '0' 
	DECLARE @cBIT027 VARCHAR(1000) = '0' 
	DECLARE @cBIT028 VARCHAR(1000) = '0' 
	DECLARE @cBIT029 VARCHAR(1000) = '0' 
	DECLARE @cBIT030 VARCHAR(1000) = '0' 
	DECLARE @cBIT031 VARCHAR(1000) = '0' 
	DECLARE @cBIT032 VARCHAR(1000) = SUBSTRING(@CARDnUMBER, 1, 11) --Código do Produto (11 primeiros dígitos do Número do Cartão) 
	DECLARE @cBIT033 VARCHAR(1000) = '0' 
	DECLARE @cBIT034 VARCHAR(1000) = '0' 
	DECLARE @cBIT035 VARCHAR(1000) = '0' 
	DECLARE @cBIT036 VARCHAR(1000) = '0' 
	DECLARE @cBIT037 VARCHAR(1000) = '0' 
	DECLARE @cBIT038 VARCHAR(1000) = '0' --Código de Autorização: Se transação Autorizada será enviado um código de autorização com 6 dígitos que deverão ser falado pela ura. 
	DECLARE @cBIT039 VARCHAR(1000) = '0' --Código de resposta: Se igual a “00”: Transação Autorizada / Se diferente de “00”: Transação Negada / Se igual a “99”: direcionar para atendimento humano 
	DECLARE @cBIT040 VARCHAR(1000) = '0' 
	DECLARE @cBIT041 VARCHAR(1000) = @terminalId --Identificação do Terminal: 88888888 
	DECLARE @cBIT042 VARCHAR(1000) = @providerId --Identificação do Estabelecimento – alinhado à direita, completado com zeros à esquerda. Exemplo: 000000006474514 
	DECLARE @cBIT043 VARCHAR(1000) = '0' 
	DECLARE @cBIT044 VARCHAR(1000) = '0' 
	DECLARE @cBIT045 VARCHAR(1000) = '0' 
	DECLARE @cBIT046 VARCHAR(1000) = '0' 
	DECLARE @cBIT047 VARCHAR(1000) = '0' 
	DECLARE @cBIT048 VARCHAR(1000) = 'URA' --Nome Identificador do Provedor (Max. 20 Bytes) - URA 
	DECLARE @cBIT049 VARCHAR(1000) = '986' --Cod. Moeda R$ 
	DECLARE @cBIT050 VARCHAR(1000) = '0' 
	DECLARE @cBIT051 VARCHAR(1000) = '0' 
	DECLARE @cBIT052 VARCHAR(1000) = '' --Senha criptografada 
	DECLARE @cBIT053 VARCHAR(1000) = '0' 
	DECLARE @cBIT054 VARCHAR(1000) = '0' 
	DECLARE @cBIT055 VARCHAR(1000) = '0' 
	DECLARE @cBIT056 VARCHAR(1000) = '0' 
	DECLARE @cBIT057 VARCHAR(1000) = '0' 
	DECLARE @cBIT058 VARCHAR(1000) = '0' 
	DECLARE @cBIT059 VARCHAR(1000) = @phoneNumber --Numero do telefone de origem 
	DECLARE @cBIT060 VARCHAR(1000) = '0' 
	DECLARE @cBIT061 VARCHAR(1000) = '0' 
	DECLARE @cBIT062 VARCHAR(1000) = '0' --Mensagem de Resposta 
	DECLARE @cBIT063 VARCHAR(1000) = '0' 
	DECLARE @cBIT064 VARCHAR(1000) = '0' 
	DECLARE @cBIT065 VARCHAR(1000) = '0' 
	DECLARE @cBIT066 VARCHAR(1000) = '0' 
	DECLARE @cBIT067 VARCHAR(1000) = @installments --Quantidade de parcelas: "01" para venda à vista; / "0X" ou "XX" para venda parcelada, onde "X" é um valor maior que "01". 
	DECLARE @cBIT068 VARCHAR(1000) = '0' 
	DECLARE @cBIT069 VARCHAR(1000) = '0' 
	DECLARE @cBIT070 VARCHAR(1000) = '0' 
	DECLARE @cBIT071 VARCHAR(1000) = '0' 
	DECLARE @cBIT072 VARCHAR(1000) = '0' 
	DECLARE @cBIT073 VARCHAR(1000) = '0' 
	DECLARE @cBIT074 VARCHAR(1000) = '0' 
	DECLARE @cBIT075 VARCHAR(1000) = '0' 
	DECLARE @cBIT076 VARCHAR(1000) = '0' 
	DECLARE @cBIT077 VARCHAR(1000) = '0' 
	DECLARE @cBIT078 VARCHAR(1000) = '0' 
	DECLARE @cBIT079 VARCHAR(1000) = '0' 
	DECLARE @cBIT080 VARCHAR(1000) = '0' 
	DECLARE @cBIT081 VARCHAR(1000) = '0' 
	DECLARE @cBIT082 VARCHAR(1000) = '0' 
	DECLARE @cBIT083 VARCHAR(1000) = '0' 
	DECLARE @cBIT084 VARCHAR(1000) = '0' 
	DECLARE @cBIT085 VARCHAR(1000) = '0' 
	DECLARE @cBIT086 VARCHAR(1000) = '0' 
	DECLARE @cBIT087 VARCHAR(1000) = '0' 
	DECLARE @cBIT088 VARCHAR(1000) = '0' 
	DECLARE @cBIT089 VARCHAR(1000) = '0' 
	DECLARE @cBIT090 VARCHAR(1000) = '0' 
	DECLARE @cBIT091 VARCHAR(1000) = '0' 
	DECLARE @cBIT092 VARCHAR(1000) = '0' 
	DECLARE @cBIT093 VARCHAR(1000) = '0' 
	DECLARE @cBIT094 VARCHAR(1000) = '0' 
	DECLARE @cBIT095 VARCHAR(1000) = '0' 
	DECLARE @cBIT096 VARCHAR(1000) = '0' 
	DECLARE @cBIT097 VARCHAR(1000) = '0' 
	DECLARE @cBIT098 VARCHAR(1000) = '0' 
	DECLARE @cBIT099 VARCHAR(1000) = '0' 
	DECLARE @cBIT100 VARCHAR(1000) = @cvv --Código Verificador (CVV) do cartão (com 3 ou 4 dígitos) 
	DECLARE @cBIT101 VARCHAR(1000) = '0' 
	DECLARE @cBIT102 VARCHAR(1000) = '0' 
	DECLARE @cBIT103 VARCHAR(1000) = '0' 
	DECLARE @cBIT104 VARCHAR(1000) = '0' 
	DECLARE @cBIT105 VARCHAR(1000) = '' --Tipo transação: 'VV' - Venda a vista / 'QT' - QUITACAO DE FRETE / 'VP' - Venda parcelada sem juros || Default: '' -> 'VV' 
	DECLARE @cBIT106 VARCHAR(1000) = '0' 
	DECLARE @cBIT107 VARCHAR(1000) = '0' 
	DECLARE @cBIT108 VARCHAR(1000) = '0' 
	DECLARE @cBIT109 VARCHAR(1000) = '0' 
	DECLARE @cBIT110 VARCHAR(1000) = '0' 
	DECLARE @cBIT111 VARCHAR(1000) = '0' 
	DECLARE @cBIT112 VARCHAR(1000) = '0' 
	DECLARE @cBIT113 VARCHAR(1000) = '0' 
	DECLARE @cBIT114 VARCHAR(1000) = '0' 
	DECLARE @cBIT115 VARCHAR(1000) = '0' 
	DECLARE @cBIT116 VARCHAR(1000) = '0' 
	DECLARE @cBIT117 VARCHAR(1000) = '0' 
	DECLARE @cBIT118 VARCHAR(1000) = '0' 
	DECLARE @cBIT119 VARCHAR(1000) = '0' 
	DECLARE @cBIT120 VARCHAR(1000) = '0' --SenhaCapturada 
	DECLARE @cBIT121 VARCHAR(1000) = '0' 
	DECLARE @cBIT122 VARCHAR(1000) = '0' 
	DECLARE @cBIT123 VARCHAR(1000) = '0' 
	DECLARE @cBIT124 VARCHAR(1000) = '0' 
	DECLARE @cBIT125 VARCHAR(1000) = '0' 
	DECLARE @cBIT126 VARCHAR(1000) = '0' 
	DECLARE @cBIT127 VARCHAR(1000) = '0' --NSU Host - alinhado à direita, completado com zeros à esquerda. Exemplo: 000013945 
	DECLARE @cBIT128 VARCHAR(1000) = '0' 
 
	DECLARE  
		@bEstabMigrado				BIT 
		,@cStatusEstab				CHAR(1) 
		,@cStatusCartao				CHAR(1) 
		,@cSaldoLimite				CHAR(1) 
		,@cSaldoUsuario				CHAR(1) 
		,@cCartaoBlack				CHAR(1) 
		,@cCartaoConvenio			CHAR(1) 
		,@cCartaoFrota				CHAR(1) 
		,@cVendaParcelada			CHAR(1) 
		,@cProdutoAgregado			CHAR(1) 
		,@cTipoCartao				CHAR(1) 
		,@cTipoAtendimento			CHAR(1) 
		,@cBinCartao				CHAR(6) 
		,@cFilialUP					CHAR(2) 
		,@dDataNascimentoBase		DATETIME 
		,@dDataVencCartao			DATETIME 
		,@dDataHora_Transacao		DATETIME 
		,@nValor_Transacao			DECIMAL(15,2) 
		,@nSaldo_Disponivel			DECIMAL(15,2) 
		,@iCodTipoAtendimento		INT 
		,@iCliente					INT 
		,@iCodigoEstabelecimento	INT 
		,@iRedeCodigo				INT 
		,@iTpoPrdCodigo				INT 
		,@iCartaoUsuario			INT 
		,@iUsuario					INT 
		,@iContaUsuario				INT 
		,@iFranquiaUsuario			INT 
		,@iRedeNumero				INT 
		,@iMeiCptCodigo				INT 
		,@iTipoMeioCaptura			INT 
		,@iDia_Inicio_Periodo		INT 
		,@iDia_Fim_Periodo			INT 
		,@iTipoProduto				INT 
		,@iCodigoReferencia			INT 
		,@iRespostaRecarga			INT 
		,@iQtdeParcelas				INT 
		,@cCodigoSeguranca			VARCHAR(4) 
		,@cCpfBase					VARCHAR(20) 
		,@cNumeroCartao				VARCHAR(16) 
		,@cSenhaBanco				VARCHAR(16) 
		,@cTelefoneOrigem			VARCHAR(20) 
		,@cNomeCliente				VARCHAR(100) 
		,@cObservacaoAtendimento	VARCHAR(200) 
		,@cProduto					VARCHAR(100) 
				    
	SELECT @cSaldoLimite			= 0 
		  ,@cSaldoUsuario			= 0 
		  ,@cCartaoBlack			= 0 
		  ,@cCartaoConvenio			= 0 
		  ,@cCartaoFrota			= 0 
		  ,@cVendaParcelada			= 0 
		  ,@cProdutoAgregado		= 0 
		  ,@iTipoProduto			= 0 
		  ,@iResposta				= 0 
		  ,@iRespostaRecarga		= 0 
		  ,@iTpoPrdCodigo			= 0 
		  ,@iMeiCptCodigo			= 2 
		  ,@iTipoMeioCaptura		= 2 
		  ,@nSaldo_Disponivel		= 0 
		  ,@iCodigoReferencia		= 0 
		  ,@iRedeCodigo				= 20 
		  ,@iFranquiaUsuario		= 0 
		  ,@iCodigoEstabelecimento	= 0 
		  ,@iQtdeParcelas			= ISNULL(CONVERT(INT,@cBit067),1) 
		  ,@iRedeNumero				= CONVERT(BIGINT, @cBit024) 
		  ,@dDataHora_Transacao		= GETDATE() 
		  ,@cTelefoneOrigem			= REPLACE(@cBit059,'.','') 
 
		   
	SET @cTipoAtendimento = CASE WHEN @cBit003 IN ('000020','001000','002000') THEN 'E' /*Estabelecimento*/ 
							ELSE 'U'/* Usuario */ END 
 
	IF (@cBit004 <> '') 
		SET @nValor_Transacao = CONVERT(DECIMAL(15,2),@cBit004)/100 
 
	IF @cBit001 = '0200' 
		SET @cBit001 = '0210' 
	ELSE IF @cBit001 = '0400' 
		SET @cBit001 = '0410' 
	ELSE IF @cBit001 = '0420' 
		SET @cBit001 = '0430' 
	ELSE IF @cBit001 = '0800' 
		SET @cBit001 = '0810' 
	ELSE IF @cBit001 = '0100' 
		SET @cBit001 = '0110' 
 
	/* Validar Cartao */ 
	IF (@cBit002 <> '') 
	BEGIN 
		/*Capturando Cartão */ 
		IF (LEN (@cBit002) = 16 AND @cBit001 IN ('0110','0210')) 
		BEGIN 
			SET @cNumeroCartao = @cBit002 /* Número do cartão - Digitação manual */ 
		END 
		ELSE 
			SET @iResposta = 12 
 
		IF (@iResposta = 0) 
		BEGIN 
			SET @cBinCartao = SUBSTRING(@cNumeroCartao,1,6) 
 
			EXEC Processadora.dbo.pr_PROC_RetornarTipoProdutoCartao @cNumeroCartao, @cBaseOrigem OUT, @iTpoPrdCodigo OUT 
 
			IF (@cBaseOrigem = '' OR @cBaseOrigem IS NULL) 
			BEGIN 
 
				IF (@cBinCartao = '639240') 
					SET @cFilialUP = '02' 
				ELSE IF (@cBinCartao = '606283') 
					SET @cFilialUP = '03' 
				ELSE 
					SET @iResposta = 12 
			END 
			ELSE 
				SET @cFilialUP = '01' 
		END 
	END 
 
	/* Validar Estabelecimento */ 
	IF (@cBit042 <> '') 
	BEGIN 
 
		/*Validar se o codigo do estabelecimento é numerico*/ 
		IF (ISNUMERIC(@cBit042) = 1) 
		BEGIN 
			DECLARE @sCodigoEstabelecimento VARCHAR(15) 
 
			SET @sCodigoEstabelecimento = @cBit042 
		 
			EXEC [dbo].[pr_AUT_RetornarEstabelecimento]  @sCodigoEstabelecimento OUTPUT, @cStatusEstab OUTPUT ,@bEstabMigrado OUTPUT 
	 
			SELECT @iCodigoEstabelecimento = CONVERT(BIGINT,@sCodigoEstabelecimento) 
		END 
		ELSE 
			SET @iResposta = 99 
	END 
 
	IF (@iResposta = 0 AND @cBaseOrigem IN ('C','P')) 
	BEGIN 
		IF @cBaseOrigem = 'P' 
		BEGIN 
			SELECT @iCartaoUsuario		= CA.CrtUsrCodigo 
				  ,@iContaUsuario		= CO.CntUsrCodigo 
				  ,@dDataVencCartao		= CA.DataVencimento 
				  ,@nSaldo_Disponivel	= CO.CreditoDisponivel 
				  ,@cSenhaBanco			= CA.Senha 
				  ,@cTipoCartao			= CA.Tipo 
				  ,@cStatusCartao		= CA.Status 
				  ,@cCodigoSeguranca	= CA.CodVerificador 
			      ,@cCpfBase			= ISNULL(CA.CPF, 0) 
				  ,@dDataNascimentoBase	= CA.DataNascimento 
			FROM Processadora.dbo.CartoesUsuarios CA WITH (NOLOCK) 
			INNER JOIN Processadora.dbo.ContasUsuarios CO WITH (NOLOCK) ON CA.CNTUSRCODIGO = CO.CNTUSRCODIGO 
			WHERE CA.Numero = @cNumeroCartao 
			AND CA.FlagTransferido = 0 
			AND CA.Status <> 'C' 
		END 
		ELSE 
		BEGIN 
			SELECT	  
				 @cProdutoAgregado		= CASE WHEN CL.Produtos_Agregados = 1 OR ISNULL(CL.PermiteDesbloqueioUraSiteApp,0) = 1 THEN 0 ELSE 1 END 
				,@iCartaoUsuario		= C.Codigo 
				,@iFranquiaUsuario		= C.Franquia 
				,@dDataVencCartao		= C.Data_Expiracao 
				,@iTipoProduto			= ISNULL (CL.TipoProduto,3) 
				,@cVendaParcelada		= ISNULL (C.PermiteFinanciamento,0) 
				,@iUsuario				= C.Usuario 
				,@iDia_Inicio_Periodo	= CL.Dia_inicio_periodo 
				,@iDia_Fim_Periodo		= CL.Dia_fim_periodo 
				,@cSenhaBanco			= C.Senha 
				,@cTipoCartao			= C.Tipo_Cartao 
				,@cStatusCartao			= C.Status 
				,@cCodigoSeguranca		= C.CodVerificador 
				,@cCpfBase				= COALESCE(U.CPF, C.CU_Cpf) 
				,@dDataNascimentoBase	= COALESCE(U.Data_nascimento,C.CU_DataNascimento) 
				,@iCliente				= C.Cliente 
				,@cNomeCliente			= CONVERT(VARCHAR, CL.Codigo) + ' - ' + CL.Nome 
			FROM Policard_603078.dbo.Cartao_Usuario C WITH(NOLOCK) 
			INNER JOIN Policard_603078.dbo.usuario U WITH (nolock) ON (C.FRANQUIA = U.FRANQUIA AND C.USUARIO = U.CODIGO) 
			INNER JOIN Policard_603078.dbo.Cliente CL WITH(NOLOCK) ON (C.Cliente = CL.Codigo AND C.Franquia = CL.Franquia) 
			INNER JOIN Policard_603078.dbo.TipoProduto TP WITH(NOLOCK) ON (TP.TipoProduto = CL.TipoProduto) 
			WHERE C.CodigoCartao = @cNumeroCartao 
			AND C.StsTransferenciaUsuario IS NULL 
			AND C.Status <> 'C' 
		END 
	END 
	 
	INSERT INTO LogTransacoesUra ( 
		 Data_hora 
		,Tipo 
		,BaseOrigem 
		,TpoPrdCodigo 
		,CodMensagem 
		,NumCartao 
		,CodProcessamento 
		,ValorTransacao 
		,DataHora 
		,NsuOrigem 
		,Hora 
		,Data 
		,ModoEntrada 
		,Rede 
		,Terminal 
		,Estabelecimento 
		,InfoBit46 
		,InfoBit47 
		,Provedor 
		,SenhaCripto 
		,InfoBit63 
		,QtdParcelas 
		,InfoBit68 
		,CodigoCVV 
		,TelefoneOrigem 
		) 
	VALUES 
		(GETDATE() 
		,@cTipoAtendimento 
		,@cBaseOrigem 
		,@iTpoPrdCodigo 
		,@cBit001 
		,@cBit002 
		,@cBit003	 
		,@nValor_Transacao 
		,@cBit007 
		,@cBit011 
		,@cBit012 
		,@cBit013 
		,@cBit022 
		,@cBit024 
		,@cBit041 
		,@iCodigoEstabelecimento 
		,@cBit046 
		,@cBit047 
		,@cBit048 
		,@cBit052 
		,@cBit063 
		,@iQtdeParcelas 
		,@cBit068 
		,@cBit100 
		,@cTelefoneOrigem 
		) 
 
	SET @iCodigoReferencia = SCOPE_IDENTITY() 
	 
	/* Valida Quantidade Minima de Parcelas */ 
	IF TRY_CONVERT(INT, @installments) < 1 
	BEGIN 
		SET @iResposta = 18 
	END 
 
	/* Valida valor minimo da transacao */ 
	IF TRY_CONVERT(INT, @transactionValue) <= 0 
	BEGIN 
		SET @iResposta = 58 
	END 
 
	/* Validar CVV */ 
	IF (@cBit100 <> @cCodigoSeguranca) 
	BEGIN 
		SET @iResposta = 370  
	END 
 
	/* Verifica vencimento Cartao */ 
	IF (@iResposta = 0 AND CONVERT(VARCHAR(6),@dDataVencCartao,112) < CONVERT(VARCHAR(6), GETDATE(),112)) 
	BEGIN 
		SET @iResposta = 371 /* CARTAO VENCIDO - CARTAO VENCIDO*/ 
	END 
 
	/* Consulta base de estabelecimento */ 
	IF (@iResposta = 0) 
	BEGIN 
		/* Validando se o estabelecimento foi encontrado no cadastro*/ 
		IF (@iCodigoEstabelecimento IS NULL OR @iCodigoEstabelecimento = 0) 
		BEGIN 
			SET @iResposta = 116 -- ESTABELECIMENTO INVALIDO 
		END 
 
		/* Estabelecimento Bloqueado / Cancelado */ 
		IF (@iResposta = 0  AND @cStatusEstab <> 'A' ) 
		BEGIN 
			SET @iResposta = 99 
		END 
	END 
	 
	/* Transacoes de Efetivacao*/ 
	IF (@iResposta = 0 AND @cBit001 = '0210') 
	BEGIN 
		/* Transacoes de venda*/ 
		IF (@cBit003 IN ('001000','002000')) 
		BEGIN 
			 
			DECLARE @bSenhaCapturada	BIT 
				   ,@cServiceCode		VARCHAR(3) 
				   ,@cIdVerificacao		VARCHAR(6) 
				   ,@bSenhaValida		BIT 
				   ,@iCrtUsrCodigo		INT 
				   ,@bCartaoEmv			BIT 
			 
			SET @bSenhaCapturada = 0 
			SET @cServiceCode = '' 
 
			EXEC pr_aut_AutorizarTransacoes 
					@cBit001 OUTPUT, @cBit002 OUTPUT, @cBit003 OUTPUT, @cBit004 OUTPUT, @cBit005 OUTPUT, @cBit006 OUTPUT, @cBit007 OUTPUT, @cBit008 OUTPUT, 
					@cBit009 OUTPUT, @cBit010 OUTPUT, @cBit011 OUTPUT, @cBit012 OUTPUT, @cBit013 OUTPUT, @cBit014 OUTPUT, @cBit015 OUTPUT, @cBit016 OUTPUT, 
					@cBit017 OUTPUT, @cBit018 OUTPUT, @cBit019 OUTPUT, @cBit020 OUTPUT, @cBit021 OUTPUT, @cBit022 OUTPUT, @cBit023 OUTPUT, @cBit024 OUTPUT, 
					@cBit025 OUTPUT, @cBit026 OUTPUT, @cBit027 OUTPUT, @cBit028 OUTPUT, @cBit029 OUTPUT, @cBit030 OUTPUT, @cBit031 OUTPUT, @cBit032 OUTPUT, 
					@cBit033 OUTPUT, @cBit034 OUTPUT, @cBit035 OUTPUT, @cBit036 OUTPUT, @cBit037 OUTPUT, @cBit038 OUTPUT, @cBit039 OUTPUT, @cBit040 OUTPUT, 
					@cBit041 OUTPUT, @cBit042 OUTPUT, @cBit043 OUTPUT, @cBit044 OUTPUT, @cBit045 OUTPUT, @cBit046 OUTPUT, @cBit047 OUTPUT, @cBit048 OUTPUT, 
					@cBit049 OUTPUT, @cBit050 OUTPUT, @cBit051 OUTPUT, @cBit052 OUTPUT, @cBit053 OUTPUT, @cBit054 OUTPUT, @cBit055 OUTPUT, @cBit056 OUTPUT, 
					@cBit057 OUTPUT, @cBit058 OUTPUT, @cBit059 OUTPUT, @cBit060 OUTPUT, @cBit061 OUTPUT, @cBit062 OUTPUT, @cBit063 OUTPUT, @cBit064 OUTPUT, 
					@cBit065 OUTPUT, @cBit066 OUTPUT, @cBit067 OUTPUT, @cBit068 OUTPUT, @cBit069 OUTPUT, @cBit070 OUTPUT, @cBit071 OUTPUT, @cBit072 OUTPUT, 
					@cBit073 OUTPUT, @cBit074 OUTPUT, @cBit075 OUTPUT, @cBit076 OUTPUT, @cBit077 OUTPUT, @cBit078 OUTPUT, @cBit079 OUTPUT, @cBit080 OUTPUT, 
					@cBit081 OUTPUT, @cBit082 OUTPUT, @cBit083 OUTPUT, @cBit084 OUTPUT, @cBit085 OUTPUT, @cBit086 OUTPUT, @cBit087 OUTPUT, @cBit088 OUTPUT, 
					@cBit089 OUTPUT, @cBit090 OUTPUT, @cBit091 OUTPUT, @cBit092 OUTPUT, @cBit093 OUTPUT, @cBit094 OUTPUT, @cBit095 OUTPUT, @cBit096 OUTPUT, 
					@cBit097 OUTPUT, @cBit098 OUTPUT, @cBit099 OUTPUT, @cBit100 OUTPUT, @cBit101 OUTPUT, @cBit102 OUTPUT, @cBit103 OUTPUT, @cBit104 OUTPUT, 
					@cBit105 OUTPUT, @cBit106 OUTPUT, @cBit107 OUTPUT, @cBit108 OUTPUT, @cBit109 OUTPUT, @cBit110 OUTPUT, @cBit111 OUTPUT, @cBit112 OUTPUT, 
					@cBit113 OUTPUT, @cBit114 OUTPUT, @cBit115 OUTPUT, @cBit116 OUTPUT, @cBit117 OUTPUT, @cBit118 OUTPUT, @cBit119 OUTPUT, @cBit120 OUTPUT, 
					@cBit121 OUTPUT, @cBit122 OUTPUT, @cBit123 OUTPUT, @cBit124 OUTPUT, @cBit125 OUTPUT, @cBit126 OUTPUT, @cBit127 OUTPUT, @cBit128 OUTPUT, 
					@bEnviaPush OUTPUT, @cBaseOrigem OUTPUT, @iTrnCodigo OUTPUT, @iCntAppCodigo OUTPUT, @iResposta OUTPUT, @cMsgErro OUTPUT; 
 
			SET @cBit015 = '' 
			SET @cBit059 = '' 
 
			SELECT @cNomeCliente = CONVERT (varchar, E.EntCodigo) + ' - ' + E.Nome 
			FROM Processadora.dbo.ContasUsuarios CU WITH (NOLOCK) 
			INNER JOIN Processadora.dbo.Propostas P WITH (NOLOCK) ON CU.PrpCodigo = P.PrpCodigo 
			INNER JOIN Processadora.dbo.Entidades E WITH (NOLOCK) ON P.EntCodigo = E.EntCodigo 
			WHERE CU.CntUsrCodigo = @iContaUsuario 
 
			IF (@iResposta = 0) 
				SET @cBit062 = 'APROVADO' 
 
			SET @iCodTipoAtendimento = 18 
			 
			SET @cObservacaoAtendimento = CASE WHEN @iResposta = 0 THEN 'URA - Transacao Autorizada - Autorizacao: ' + @cBit038  ELSE 'URA - Transacao Nao Autorizada' END 
 
			EXEC Processadora.dbo.pr_CRM_InsertHistoricoAtendimento @iCodTipoAtendimento ,@cObservacaoAtendimento , @cNomeCliente , @cProduto , 'URA' ,@cNumeroCartao, @cTelefoneOrigem 
			 
		END 
 
	END 
 
	SELECT @cBit039 = codigo_policard FROM aut_CodigosResposta WITH (NOLOCK) WHERE codigo = @iResposta 
 
	IF (@cBit127 IS NULL OR @cBit127 = '') 
		EXEC Autorizador.dbo.[pr_AUT_GerarNSUTransacoes] @cBit127 OUTPUT, 9 
 
	IF (@cBit001 = '0210' AND @iTpoPrdCodigo > 0 AND  @cTipoAtendimento = 'U')/*Atendimento de Usuario*/ 
	BEGIN 
 
		SET @iCodTipoAtendimento = CASE WHEN @cBit003 = '000002' THEN 7 
										WHEN @cBit003 = '000003' THEN 1 
										WHEN @cBit003 = '000005' THEN 23	 
										WHEN @cBit003 = '000006' THEN 4 
										WHEN @cBit003 = '000007' THEN 6 
										WHEN @cBit003 = '000008' THEN 5 
										WHEN @cBit003 = '000009' THEN 17 
										WHEN @cBit003 = '000010' THEN 20 
									ELSE 0	END 
		 
		IF (@iCodTipoAtendimento > 0) 
		BEGIN 
			 
			SELECT @cObservacaoAtendimento = Descricao FROM PROCESSADORA.dbo.TipoAtendimento WHERE Codigo = @iCodTipoAtendimento 
 
			SET @cObservacaoAtendimento = CASE WHEN @iResposta = 0 THEN @cObservacaoAtendimento +  ' - AUTORIZADO' ELSE @cObservacaoAtendimento + ' - NAO AUTORIZADO' END 
			 
			IF @cBaseOrigem = 'P' 
			BEGIN 
 
				SELECT @cNomeCliente = CONVERT (varchar, E.EntCodigo) + ' - ' + E.Nome 
				FROM Processadora.dbo.ContasUsuarios CU WITH (NOLOCK) 
				INNER JOIN Processadora.dbo.Propostas P WITH (NOLOCK) ON CU.PrpCodigo = P.PrpCodigo 
				INNER JOIN Processadora.dbo.Entidades E WITH (NOLOCK) ON P.EntCodigo = E.EntCodigo 
				WHERE CU.CntUsrCodigo = @iContaUsuario 
 
			END 
			 
			SELECT @cProduto = dbo.f_zerosesquerda(tpoprdcodigo,2) + ' - ' + dbo.f_FormatarTexto(nome) 
			FROM processadora.dbo.tiposprodutos tp WITH(NOLOCK) 
			WHERE tpoprdcodigo = @iTpoPrdCodigo 
 
			EXEC Processadora.dbo.pr_CRM_InsertHistoricoAtendimento @iCodTipoAtendimento ,@cObservacaoAtendimento , @cNomeCliente , @cProduto , @cBit048 , @cNumeroCartao, @cTelefoneOrigem 
						 
		END 
	END 
 
	UPDATE LogTransacoesUra  
	SET  Autorizacao = @cBit038 
		,CodResposta = @cBit039 
		,MsgResposta = @cBit062 
		,InfoBit63   = @cBit063 
		,NsuHost	 = @cBit127 
		,CodIntResposta = @iResposta 
	WHERE codigo = @iCodigoReferencia 
 
	IF (@cBit003 NOT IN ('000002','000011')) 
		SET @cBit063 = '' 
 
	SET @cBit002 = '' 
	SET @cBit022 = '' 
	SET @cBit024 = '' 
	SET @cBit046 = '' 
	SET @cBit047 = '' 
	SET @cBit048 = '' 
	SET @cBit068 = '' 
	SET @cBit100 = '' 
	SET @cBit120 = '' 
	 
	SELECT @iCodigoReferencia ReferenceId 
		,@iResposta ResponseId --Cod. Resposta Interna [aut_CodigosResposta.Codigo] 
		,@cBit039 TransactionResponseId 
		,@cBit038 AuthorizationId 
		--,@cBit063 InfoBit63 
		,@cBit127 NsuHostId 
		,ISNULL(( 
			SELECT ISNULL(descricao, descricao_policard)  
			FROM aut_CodigosResposta WITH (NOLOCK)  
			WHERE Codigo = @iResposta), @cBit062) InternalResponseMessage 
		,@cBit062 ResponseMessage 
END 