/*
--------------------------------------------------------------------------
Projeto: Migracao URA
Objeto: pr_aut_AutorizarTransacoesURA
Propósito: Autorizar transações da URA
Autor: Cristiano Silva Barbosa - Tecnologia Policard
--------------------------------------------------------------------------
Autor: Cristiano Barbosa
Data: 19/02/2017
Mud/CH.:  2601
--------------------------------------------------------------------------
Data alteração: 12/07/2017
CH:395871/3033
--------------------------------------------------------------------------
Data alteração: 07/08/2017
Chamado: 409269 / 3124
--------------------------------------------------------------------------
Data alteração: 08/08/2017
Chamado: 409269 / 3124 -- Ajuste
--------------------------------------------------------------------------
Data alteração: 12/09/2017
Chamado/Mudança: 417666 / 
--------------------------------------------------------------------------
Data Alteração: 28/09/2017
Chamados: 399954 / 417666 / 3262
Responsavel: Cristiano Barbosa- Policard Systems
--------------------------------------------------------------------------
Data Alteração: 26/10/2017
Chamado: 410966 - Adequações conta Correios - M: 3374
Responsavel: Paulo Kyros
--------------------------------------------------------------------------
Data Alteração: 11/01/2017
Responsavel: Cristiano Barbosa- Policard Systems
Chamado: 457832
--------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[pr_aut_AutorizarTransacoesURA]
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
	@bEnviaPush BIT OUTPUT, @cBaseOrigem CHAR(1) OUTPUT, @iTrnCodigo INT OUTPUT, @iCntAppCodigo INT OUTPUT, @iResposta INT OUTPUT
	

AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE 
		 @bValidarCpf				BIT
		,@bValidarDataNascimento	BIT
		,@bValidarCodSeguranca		BIT
		,@bEstabMigrado				BIT
		,@cAutorizacao				CHAR(18)
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
		,@cTipoProduto				CHAR(2)
		,@cMotivoBloqueio			CHAR(1)
		,@cTipoAtendimento			CHAR(1)
		,@cBinCartao				CHAR(6)
		,@cFilialUP					CHAR(2)
		,@dDataNascimento			DATETIME
		,@dDataNascimentoBase		DATETIME
		,@dDataVencCartao			DATETIME
		,@dDataHora_Transacao		DATETIME
		,@nValor_Transacao			DECIMAL(15,2)
		,@nSaldo_Disponivel			DECIMAL(15,2)
		,@iCodTipoAtendimento		INT
		,@iCliente					INT
		,@iCodigoEstabelecimento	INT
		,@iEstCodigo				INT
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
		,@iMtvSttCodigo				INT
		,@iRespostaRecarga			INT
		,@iQtdeParcelas				INT
		,@iLenNovaSenha				INT
		,@iDia						SMALLINT
		,@iAno						SMALLINT
		,@iMes						SMALLINT
		,@cCodigo					VARCHAR(10)
		,@cCodigoSeguranca			VARCHAR(4)
		,@cCPF						VARCHAR(20)
		,@cCpfBase					VARCHAR(20)
		,@cNumeroCartao				VARCHAR(16)
		,@cSenhaBanco				VARCHAR(16)
		,@cSenhaAtual				VARCHAR(16)
		,@cSenhaNova				VARCHAR(16)
		,@cSenhaConfirmacao			VARCHAR(16)
		,@cTelefoneOrigem			VARCHAR(20)
		,@cNomeProduto				VARCHAR(30)
		,@cResponsavel				VARCHAR(50)
		,@cObservacao				VARCHAR(100)
		,@cDescricaoMotivo			VARCHAR(100)
		,@cNomeCliente				VARCHAR(100)
		,@cAux						VARCHAR(999)
		,@cObservacaoAtendimento	VARCHAR(200)
		,@cProduto					VARCHAR(100)
		,@iTamanhoSenha				INT

				   
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

	/* Transacoes de Consulta */
	IF (@iResposta = 0 AND @cBit001 = '0110')
	BEGIN
		
		IF (@cFilialUP = '01' AND @cBit003 IN ('000001','000011'))
		BEGIN
			
			IF (@iResposta = 0 AND CONVERT(VARCHAR(6),@dDataVencCartao,112) < CONVERT(VARCHAR(6), GETDATE(),112))
				SET @iResposta = 371 /* CARTAO VENCIDO - CARTAO VENCIDO*/

			IF (@cBaseOrigem = 'P')
			BEGIN

				SELECT @cSaldoLimite  = 1
					  ,@cSaldoUsuario = 1

				SET @cBit062 = @cSaldoLimite + @cSaldoUsuario + @cCartaoBlack + @cCartaoConvenio + @cCartaoFrota + @cVendaParcelada	+ @cProdutoAgregado
				
			END
			ELSE
			BEGIN

				IF @iFranquiaUsuario = 80 
					SET @cCartaoBlack = 1
					
				IF @iTipoProduto = 3
					SET @cCartaoConvenio = 1

				IF @iTipoProduto = 1
				BEGIN
					SET @cCartaoFrota = 1
					SET @cVendaParcelada = 0
				END
											
				SET @cBit062 = @cSaldoLimite + @cSaldoUsuario + @cCartaoBlack + @cCartaoConvenio + @cCartaoFrota + @cVendaParcelada	+ @cProdutoAgregado

			END

		END

		IF (@cBit003 = '000002')
		BEGIN
				
			SET @cAux = ''
			SET @cCodigo = ''

			IF (@cBit047 <> '' AND LEN (@cBit047) = 11)
			BEGIN

				SET @cCPF = SUBSTRING(@cBit047,1,3) + '.' + SUBSTRING(@cBit047,4,3) + '.' + SUBSTRING(@cBit047,7,3) + '-' + SUBSTRING(@cBit047,10,2)
			
				DECLARE @VTableProd TABLE (Codigo INT, TipoProduto CHAR(2),NomeProduto VARCHAR(30), NumeroCartao VARCHAR(16))

				SELECT dbo.f_zerosesquerda(cu.tpoprdcodigo,2) AS TpoPrdCodigo
					  ,CASE WHEN TP.TpoPrdCodigo IN (5,30,62,71,78,80) THEN 'ALIMENTACAO' /*Case para a URA falar o numero do produto corretamente*/
							WHEN TP.TpoPrdCodigo IN (24,31,63,72,79,81) THEN 'REFEICAO'
							ELSE dbo.f_FormatarTexto(REPLACE(tp.nome,'POLICARD','')) END AS NomeProduto
					  ,cu.numero AS NumeroCartao
				INTO #temp
				FROM Processadora.dbo.CartoesUsuarios cu WITH(NOLOCK)
				INNER JOIN Processadora.dbo.tiposprodutos tp WITH(NOLOCK) ON cu.tpoprdcodigo = tp.tpoprdcodigo
				WHERE cu.cpf = @cCPF
				AND cu.FlagTransferido = 0
				AND cu.status <> 'C'

				UNION ALL

				SELECT 
	
					CASE ISNULL(CL.TipoProduto, 3)  
						WHEN 1 THEN '60'
						WHEN 2 THEN '61'  
						ELSE '06' END AS TpoPrdCodigo,  
					CASE ISNULL(CL.TipoProduto, 3)  
						WHEN 1 THEN 'FROTA'
						WHEN 2 THEN 'COMBUSTIVEL'
						WHEN 3 THEN 'CONVENIO'
						WHEN 5 THEN 'AGN'
						WHEN 6 THEN 'EMPRESARIAL'END AS NomeProduto,
					CU.CodigoCartao AS NumeroCartao
				FROM Policard_603078.dbo.Cartao_Usuario CU WITH (NOLOCK)  
				INNER JOIN Policard_603078.dbo.Cliente CL WITH (NOLOCK) ON (CL.Codigo = CU.Cliente AND CL.Franquia = CU.Franquia)  
				WHERE
					cu.CU_Cpf = @cCPF
				AND cu.StsTransferenciaUsuario IS NULL 
				AND CU.Status <> 'C'
				
				INSERT INTO @VTableProd
				SELECT ROW_NUMBER() OVER (ORDER BY TpoPrdCodigo) As Codigo,*  FROM #temp

				DROP TABLE #temp

				WHILE EXISTS (SELECT * FROM @VTableProd)
				BEGIN
	
					SELECT TOP 1 @cCodigo = Codigo, @cTipoProduto = TipoProduto, @cNomeProduto = LTRIM(RTRIM(NomeProduto)), @cNumeroCartao = NumeroCartao FROM @VTableProd

					SET @cAux = @cCodigo + @cTipoProduto + @cNomeProduto + '|'
					SET @cBit063 = @cBit063 + @cAux
								
					DELETE FROM @VTableProd WHERE Codigo = @cCodigo

				END

				IF (@cBit063 = '')
					SET @iResposta = 99
				
			END
			ELSE
				SET @iResposta = 99

		END

		IF (@cBit003 = '000003')
		BEGIN
			IF (@cBaseOrigem = 'P')
			BEGIN

				IF @nSaldo_Disponivel < 0
					SET @nSaldo_Disponivel = 0
					
				SET @cBit004 = REPLACE(REPLACE(@nSaldo_Disponivel,'.',''),',','')
				SET @cBit004 = dbo.f_ZerosEsquerda (@cBit004,12)

			END
			ELSE
			BEGIN

				SELECT	 @iDia	= DATEPART(DAY,@dDataHora_Transacao)
						,@iMes	= DATEPART(MONTH,@dDataHora_Transacao)
						,@iAno	= DATEPART(YEAR,@dDataHora_Transacao)

				IF (@iDia >= @iDia_Inicio_Periodo AND @iDia <= 31)
					EXEC   Policard_603078.dbo.Get_next_month @iAno, @iMes, @iAno OUTPUT, @iMes OUTPUT

				SELECT	@nSaldo_Disponivel	= (ISNULL(C.Limite_Mensal, 0) + (ISNULL(C.Saldo_Lancamentos, 0) + ISNULL(C.Saldo_Anterior, 0) + ISNULL(C.Saldo_Vendas, 0) + ISNULL(C.Saldo_Manutencao, 0)))
				FROM Policard_603078.dbo.Conta_usuario C WITH(HOLDLOCK, ROWLOCK)
				WHERE C.Franquia = @iFranquiaUsuario
				AND C.Usuario = @iUsuario
				AND C.Ano = @iAno
				AND C.Mes = @iMes

				IF (@nSaldo_Disponivel < 0)
					SET @nSaldo_Disponivel = 0

				SET @cBit004 = REPLACE(REPLACE(@nSaldo_Disponivel,'.',''),',','')
				SET @cBit004 = dbo.f_ZerosEsquerda (@cBit004,12)

			END
		END

		/* Validar CVV */
		IF (@cBit003 = '000007')
		BEGIN

			SET @bValidarCodSeguranca = 0

			IF (@cBit100 <> '' AND LEN (@cBit100) <= 4)
				SET @bValidarCodSeguranca = 1

			IF (@bValidarCodSeguranca = 1 AND @cBit100 <> @cCodigoSeguranca)
				SET @iResposta = 370 

		END

		IF (@cBit003 = '000009')
		BEGIN

			IF (@iResposta = 0)
			BEGIN

				SELECT @bValidarCpf = 0
					  ,@bValidarDataNascimento = 0

				IF (@cBit046 <> '' AND LEN (@cBit046) = 8)
					SET @bValidarDataNascimento = 1

				IF (@cBit047 <> '' AND LEN (@cBit047) = 11)
					SET @bValidarCpf = 1

				SET @cCPF = SUBSTRING(@cBit047,1,3) + '.' + SUBSTRING(@cBit047,4,3) + '.' + SUBSTRING(@cBit047,7,3) + '-' + SUBSTRING(@cBit047,10,2)
				SET @dDataNascimento = @cBit046

				IF (@cBaseOrigem IS NULL AND @bValidarCpf = 1)
				BEGIN
					
					SELECT
						 @cCpfBase = CPF
						,@dDataNascimentoBase = DataNascimento
						,@cBaseOrigem	= 'P'
					FROM Processadora.dbo.CartoesUsuarios WITH (NOLOCK)
					WHERE CPF = @cCPF
					AND FlagTransferido = 0
					AND status <> 'C'

					IF (@cBaseOrigem IS NULL)
					BEGIN 

						SELECT
							 @cCpfBase = COALESCE(U.CPF,C.CU_CPF)
							,@dDataNascimentoBase	= COALESCE(U.Data_nascimento,C.CU_DataNascimento)
						FROM Policard_603078.dbo.Cartao_Usuario C WITH(NOLOCK)
						INNER JOIN Policard_603078.dbo.usuario U WITH (nolock) ON (C.FRANQUIA = U.FRANQUIA AND C.USUARIO = U.CODIGO)
						WHERE
							U.Cpf = @cCPF
						AND C.StsTransferenciaUsuario IS NULL 
						AND C.Status <> 'C'
						
					END
										
				END
								
				IF (@bValidarCpf = 1 AND @cCpfBase <> @cCPF)
					SET @iResposta = 99
				
				IF (@iResposta = 0 AND @bValidarDataNascimento = 1 AND CONVERT(VARCHAR(8),@dDataNascimentoBase,112) <> CONVERT(VARCHAR(8),@dDataNascimento,112))
					SET @iResposta = 99
				
			END
		END
		
		/* Consulta Migração */
		IF (@cBit003 = '000011')
		BEGIN

			SET @cBit063 = @cFilialUP

			IF (@cFilialUP <> '01')
				SET @cBit062 = ''
		END
		
		IF (@cBit003 = '000020')
		BEGIN

			/* Consulta base de estabelecimento */
			IF (@iResposta = 0)
			BEGIN
	
				/* Validando se o estabelecimento foi encontrado no cadastro*/
				IF (@iCodigoEstabelecimento IS NULL OR @iCodigoEstabelecimento = 0)
					SET @iResposta = 116 -- ESTABELECIMENTO INVALIDO

				/* Estabelecimento Bloqueado / Cancelado */
				IF (@iResposta = 0  AND @cStatusEstab <> 'A' )
					SET @iResposta = 99

			END
		END
	END
	
	/* Transacoes de Efetivacao*/
	IF (@iResposta = 0 AND @cBit001 = '0210')
	BEGIN

		/* Solicitacao de bloqueio de cartão*/
		IF (@cBit003 = '000002')
		BEGIN

			SET @cCPF = SUBSTRING(@cBit047,1,3) + '.' + SUBSTRING(@cBit047,4,3) + '.' + SUBSTRING(@cBit047,7,3) + '-' + SUBSTRING(@cBit047,10,2)
			
			IF (CONVERT(INT, @cBit068) = 6)
			BEGIN
			
				SELECT TOP 1
					 @iCartaoUsuario = C.CODIGO
					,@iFranquiaUsuario = C.FRANQUIA
					,@cBaseOrigem = 'C'
				FROM Policard_603078.dbo.Cartao_Usuario C WITH(NOLOCK)
				INNER JOIN Policard_603078.dbo.usuario U WITH (nolock) ON (C.FRANQUIA = U.FRANQUIA AND C.USUARIO = U.CODIGO)
				WHERE
					C.CU_Cpf = @cCPF
				AND C.StsTransferenciaUsuario IS NULL 
				AND c.status <> 'C'

			END
			ELSE
			BEGIN
			
				SELECT TOP 1 @iCartaoUsuario = CrtUsrCodigo
					  ,@iContaUsuario = CntUsrCodigo
					  ,@cCpfBase = ISNULL(CPF, 0)
					  ,@cBaseOrigem	= 'P'
				FROM Processadora.dbo.CartoesUsuarios cu WITH(NOLOCK)
				INNER JOIN Processadora.dbo.tiposprodutos tp WITH(NOLOCK) ON cu.tpoprdcodigo = tp.tpoprdcodigo
				WHERE cu.cpf = @cCPF
				AND CONVERT(INT,CU.TpoPrdCodigo) = CONVERT(INT, @cBit068)
				AND cu.FlagTransferido = 0
				AND cu.status <> 'C'

			END

			SET @cMotivoBloqueio = 'P'
			
			IF (@cBaseOrigem = 'P')
			BEGIN
				
				SET @cResponsavel = 'URA POLICARD'
				
				SET @iMtvSttCodigo = 3

				SELECT @cDescricaoMotivo = Descricao FROM processadora.dbo.MotivosStatus WITH (NOLOCK) WHERE MtvSttCodigo = @iMtvSttCodigo

				EXEC Processadora.dbo.PR_PROC_GeraSegundaViaCartao @iCartaoUsuario, @cMotivoBloqueio, @iMtvSttCodigo, @cDescricaoMotivo, @cResponsavel

				SELECT @cStatusCartao = STATUS FROM Processadora.dbo.CartoesUsuarios WITH (NOLOCK) WHERE CrtUsrCodigo = @iCartaoUsuario

				IF @cStatusCartao = 'A'
					SET @iResposta = 99

				
			END
			ELSE
			BEGIN
				
				SET @cObservacao = 'CARTAO BLOQUEADO PELA URA POLICARD'
				SET @cResponsavel = 'URA POLICARD'
												
				EXEC   Policard_603078.dbo.pr_aut_SolicitaSegundaVia @iCartaoUsuario, @iFranquiaUsuario, @cMotivoBloqueio, @cResponsavel, @cObservacao, @iResposta OUTPUT

				IF @iResposta <> 0
					SET @iResposta = 99

			END

		END

		/*Transacao de consulta de Saldo*/
		IF (@cBit003 = '000003')
		BEGIN

			IF (@cBaseOrigem = 'P')
			BEGIN

				IF @nSaldo_Disponivel < 0
					SET @nSaldo_Disponivel = 0
					
				SET @cBit004 = REPLACE(REPLACE(@nSaldo_Disponivel,'.',''),',','')
				SET @cBit004 = dbo.f_ZerosEsquerda (@cBit004,12)

			END
			ELSE
			BEGIN

				SELECT @iDia = DATEPART(DAY,@dDataHora_Transacao)
					  ,@iMes = DATEPART(MONTH,@dDataHora_Transacao)
					  ,@iAno = DATEPART(YEAR,@dDataHora_Transacao)

				IF (@iDia >= @iDia_Inicio_Periodo AND @iDia <= 31)
					EXEC   Policard_603078.dbo.Get_next_month @iAno, @iMes, @iAno OUTPUT, @iMes OUTPUT

				SELECT	@nSaldo_Disponivel	= (ISNULL(C.Limite_Mensal, 0) + (ISNULL(C.Saldo_Lancamentos, 0) + ISNULL(C.Saldo_Anterior, 0) + ISNULL(C.Saldo_Vendas, 0) + ISNULL(C.Saldo_Manutencao, 0)))
				FROM Policard_603078.dbo.Conta_usuario C WITH(HOLDLOCK, ROWLOCK)
				WHERE C.Franquia = @iFranquiaUsuario
				AND C.Usuario = @iUsuario
				AND C.Ano = @iAno
				AND C.Mes = @iMes

				IF (@nSaldo_Disponivel < 0)
					SET @nSaldo_Disponivel = 0

				SET @cBit004 = REPLACE(REPLACE(@nSaldo_Disponivel,'.',''),',','')
				SET @cBit004 = dbo.f_ZerosEsquerda (@cBit004,12)

			END
			
		END

		/* Solicitacao de Troca de Senha */
		IF (@cBit003 = '000005')
		BEGIN

			IF (@cBaseOrigem = 'P')
			BEGIN

				IF (@cTipoCartao <> 'P')
				BEGIN
					
					IF (LEN (@cBit047) = 32)
					BEGIN

						SELECT @cSenhaAtual = @cBit052
							  ,@cSenhaNova = SUBSTRING(@cBit047,1,16)
							  ,@cSenhaConfirmacao = SUBSTRING(@cBit047,17,16)
							  ,@iLenNovaSenha = CASE WHEN @cBit120 = '' THEN 4 
													ELSE CONVERT(INT, @cBit120) 
												END

						EXEC dbo.pr_DecriptaSenhaPolicard @cSenhaBanco OUTPUT
						EXEC dbo.pr_aut_DecriptaSenhaURA @cSenhaAtual OUTPUT
						EXEC dbo.pr_aut_DecriptaSenhaURA @cSenhaNova OUTPUT
						EXEC dbo.pr_aut_DecriptaSenhaURA @cSenhaConfirmacao OUTPUT
						
						SELECT @iTpoPrdCodigo = T.TpoPrdCodigo
							  ,@iTamanhoSenha = ISNULL(T.TamanhoSenha,4)
						FROM Processadora.dbo.CartoesUsuarios C WITH (NOLOCK) 
  					    INNER JOIN Processadora.dbo.TiposProdutos T WITH (NOLOCK) ON T.TpoPrdCodigo = C.TpoPrdCodigo
						WHERE C.CrtUsrCodigo = @iCartaoUsuario

						--(16 é o tamanho da string + 1 a posição de inicio) - @iTamanhoSenha a quantidade 
						SELECT @cSenhaBanco	= SUBSTRING(@cSenhaBanco,17-@iTamanhoSenha,@iTamanhoSenha)
							  ,@cSenhaAtual	= SUBSTRING(@cSenhaAtual,17-@iTamanhoSenha,@iTamanhoSenha)
							  ,@cSenhaNova	= SUBSTRING(@cSenhaNova,17-@iTamanhoSenha,@iTamanhoSenha)
							  ,@cSenhaConfirmacao = SUBSTRING(@cSenhaConfirmacao,17-@iTamanhoSenha,@iTamanhoSenha)

						IF (@cSenhaBanco = @cSenhaAtual)
						BEGIN

							IF (@cSenhaNova = @cSenhaConfirmacao)
							BEGIN

								IF (@iLenNovaSenha = @iTamanhoSenha)
								BEGIN

									SET @cSenhaNova = REPLICATE('0', 16 - LEN(@cSenhaNova)) + @cSenhaNova
									EXEC dbo.pr_EncriptaSenhaPolicard @cSenhaNova OUT
							
									UPDATE Processadora.dbo.CartoesUsuarios 
									SET Senha = @cSenhaNova
									,DataAlteracaoSenha = GETDATE() 
									WHERE CrtUsrCodigo = @iCartaoUsuario
								END
								ELSE
									SET @iResposta = 86
							END
							ELSE
								SET @iResposta = 99
						END
						ELSE
							SET @iResposta = 27
					END
					ELSE
						SET @iResposta = 99
				END
				ELSE
					SET @iResposta = 99

			END
			ELSE
			BEGIN

				IF (@cTipoCartao <> 'P')
				BEGIN

					IF (LEN (@cBit047) = 32)
					BEGIN
						SELECT @cSenhaAtual = @cBit052
								,@cSenhaNova = SUBSTRING(@cBit047,1,16)
								,@cSenhaConfirmacao = SUBSTRING(@cBit047,17,16)
								,@iLenNovaSenha = CASE WHEN @cBit120 = '' THEN 4
													ELSE CONVERT(INT, @cBit120)
												END

						EXEC dbo.pr_DecriptaSenhaPolicard @cSenhaBanco OUTPUT
						EXEC dbo.pr_aut_DecriptaSenhaURA @cSenhaAtual OUTPUT
						EXEC dbo.pr_aut_DecriptaSenhaURA @cSenhaNova OUTPUT
						EXEC dbo.pr_aut_DecriptaSenhaURA @cSenhaConfirmacao OUTPUT
						

						SELECT   @cSenhaBanco = SUBSTRING(@cSenhaBanco,13,4)
								,@cSenhaAtual = SUBSTRING(@cSenhaAtual,13,4)
								,@cSenhaNova = SUBSTRING(@cSenhaNova,13,4)
								,@cSenhaConfirmacao = SUBSTRING(@cSenhaConfirmacao,13,4)
								,@iTamanhoSenha = 4 -- Cartoes Convenio senha de 4 digitos

						IF (@cSenhaBanco = @cSenhaAtual)
						BEGIN

							IF (@cSenhaNova = @cSenhaConfirmacao)
							BEGIN
	
								IF (@iLenNovaSenha = @iTamanhoSenha)
								BEGIN

									SET @cSenhaNova = REPLICATE('0', 16 - LEN(@cSenhaNova)) + @cSenhaNova
									EXEC dbo.pr_EncriptaSenhaPolicard @cSenhaNova OUTPUT
						
									UPDATE Policard_603078.dbo.Cartao_Usuario 
									SET Senha = @cSenhaNova
									,DataAlteracaoSenha = GETDATE()
									WHERE Codigo = @iCartaoUsuario
									AND Franquia = @iFranquiaUsuario

								END
								ELSE 
									SET @iResposta = 86
							END
							ELSE
								SET @iResposta = 99
						END
						ELSE
							SET @iResposta = 27
					END
					ELSE
						SET @iResposta = 99
				END
				ELSE
					SET @iResposta = 99

			END
		END

		/* Solicitacao de Reset de Senha */
		IF (@cBit003 = '000006')
		BEGIN

			/*A transacao de reset de senha nao será permitida pela gestao de risco*/
			SET @iResposta = 99

			--IF (@cBaseOrigem = 'P')
			--BEGIN
				
			--	IF (@cTipoCartao <> 'P')
			--	BEGIN
				
			--		IF (LEN (@cBit047) = 32)
			--		BEGIN
			--			SELECT @cSenhaNova = SUBSTRING(@cBit047,1,16)
			--				  ,@cSenhaConfirmacao = SUBSTRING(@cBit047,17,16)

						
			--			EXEC dbo.pr_aut_DecriptaSenhaURA @cSenhaNova OUTPUT
			--			EXEC dbo.pr_aut_DecriptaSenhaURA @cSenhaConfirmacao OUTPUT
						
			--			SELECT @cSenhaNova	= SUBSTRING(@cSenhaNova,13,4)
			--				  ,@cSenhaConfirmacao = SUBSTRING(@cSenhaConfirmacao,13,4)

			--			IF (@cSenhaNova = @cSenhaConfirmacao)
			--			BEGIN

			--				SET @cSenhaNova = REPLICATE('0', 16 - LEN(@cSenhaNova)) + @cSenhaNova
			--				EXEC dbo.pr_EncriptaSenhaPolicard @cSenhaNova OUTPUT

			--				UPDATE processadora.dbo.CartoesUsuarios SET Senha = @cSenhaNova WHERE CrtUsrCodigo = @iCartaoUsuario 

			--			END
			--			ELSE
			--				SET @iResposta = 99
			--		END
			--		ELSE
			--			SET @iResposta = 99
			--	END
			--	ELSE
			--		SET @iResposta = 99

			--END
			--ELSE
			--BEGIN

			--	IF (@cTipoCartao <> 'P')
			--	BEGIN

					

			--		IF (LEN (@cBit047) = 32)
			--		BEGIN
			--			SELECT @cSenhaNova = SUBSTRING(@cBit047,1,16)
			--				  ,@cSenhaConfirmacao = SUBSTRING(@cBit047,17,16)

			--			EXEC dbo.pr_aut_DecriptaSenhaURA @cSenhaNova OUTPUT
			--			EXEC dbo.pr_aut_DecriptaSenhaURA @cSenhaConfirmacao OUTPUT
						
			--			SELECT	@cSenhaNova	= SUBSTRING(@cSenhaNova,13,4)
			--				   ,@cSenhaConfirmacao = SUBSTRING(@cSenhaConfirmacao,13,4)

			--			IF (@cSenhaNova = @cSenhaConfirmacao)
			--			BEGIN

			--				SET @cSenhaNova = REPLICATE('0', 16 - LEN(@cSenhaNova)) + @cSenhaNova
			--				EXEC dbo.pr_EncriptaSenhaPolicard @cSenhaNova OUTPUT

							--UPDATE Policard_603078.dbo.Cartao_Usuario 
							--SET Senha = @cSenhaNova
							--WHERE Codigo = @iCartaoUsuario
							--AND Franquia = @iFranquiaUsuario

			--			END
			--			ELSE
			--				SET @iResposta = 99

			--		END
			--		ELSE
			--			SET @iResposta = 99
			--	END
			--	ELSE
			--		SET @iResposta = 99

			--END

		END
		
		/* Solicitacao de 2 via*/
		IF (@cBit003 = '000007')
		BEGIN
			
			
			IF (@cBaseOrigem = 'P')
			BEGIN

				SELECT   @cMotivoBloqueio = 'P'
						,@cResponsavel = 'URA POLICARD'
						,@iMtvSttCodigo = 4

				SELECT @cDescricaoMotivo = Descricao FROM Processadora.dbo.MotivosStatus WITH (NOLOCK) WHERE MtvSttCodigo = @iMtvSttCodigo
								
				EXEC Processadora.dbo.PR_PROC_GeraSegundaViaCartao @iCartaoUsuario, @cMotivoBloqueio, @iMtvSttCodigo, @cDescricaoMotivo, @cResponsavel
				
			END
			ELSE
			BEGIN

				SELECT	 @cMotivoBloqueio = 'P'
						,@cObservacao = 'Cartao Cancelado Pela URA POLICARD'
						,@cResponsavel = 'URA POLICARD'
								
				EXEC   Policard_603078.dbo.pr_aut_SolicitaSegundaVia @iCartaoUsuario, @iFranquiaUsuario, @cMotivoBloqueio, @cResponsavel, @cObservacao, @iResposta OUTPUT

				IF @iResposta <> 0
					SET @iResposta = 99


			END
		END

		/* Transacoes de Desbloqueio*/
		IF (@cBit003 = '000008')
		BEGIN
			
			IF (@cBaseOrigem = 'P')
			BEGIN

				IF LEN (@cBit052) = 16
				BEGIN

					SELECT @cSenhaAtual = @cBit052

					EXEC dbo.pr_DecriptaSenhaPolicard @cSenhaBanco OUTPUT
					EXEC dbo.pr_aut_DecriptaSenhaURA @cSenhaAtual OUTPUT


					SELECT @iTpoPrdCodigo = T.TpoPrdCodigo,
						   @iTamanhoSenha = T.TamanhoSenha 
					  FROM Processadora.dbo.CartoesUsuarios C WITH (NOLOCK) 
  					 INNER JOIN Processadora.dbo.TiposProdutos T WITH (NOLOCK) ON T.TpoPrdCodigo = C.TpoPrdCodigo
					 WHERE C.CrtUsrCodigo = @iCartaoUsuario
																		
					SELECT @cSenhaBanco = SUBSTRING(@cSenhaBanco,17-@iTamanhoSenha,@iTamanhoSenha)
						  ,@cSenhaAtual = SUBSTRING(@cSenhaAtual,17-@iTamanhoSenha,@iTamanhoSenha)
					
					IF (@cSenhaBanco = @cSenhaAtual)
					BEGIN
							
						IF (@cStatusCartao = 'B')
						BEGIN

							EXEC processadora.dbo.pr_aut_desbloqueia_Cartao @iCartaoUsuario
							
							SELECT @cStatusCartao = STATUS FROM Processadora.dbo.CartoesUsuarios WITH (NOLOCK) WHERE CrtUsrCodigo = @iCartaoUsuario

							IF @cStatusCartao <> 'A'
								SET @iResposta = 99
						END
						ELSE
							SET @iResposta = 99
					END
					ELSE
						SET @iResposta = 27
				END
				ELSE 
					SET @iResposta = 99

			END
			ELSE
			BEGIN			
			
				IF (@cStatusCartao = 'B')
				BEGIN

					IF LEN (@cBit052) = 16
					BEGIN

						SELECT @cSenhaAtual = @cBit052

						EXEC dbo.pr_DecriptaSenhaPolicard @cSenhaBanco OUTPUT
						EXEC dbo.pr_aut_DecriptaSenhaURA @cSenhaAtual OUTPUT
						
						SELECT @cSenhaBanco = SUBSTRING(@cSenhaBanco,13,4)
								,@cSenhaAtual = SUBSTRING(@cSenhaAtual,13,4)
					
						IF (@cSenhaBanco = @cSenhaAtual)
						BEGIN

							SET @cResponsavel = 'URA POLICARD'
				
							EXEC Policard_603078.dbo.pr_App_DesbloquearCartao  @iCartaoUsuario, @iFranquiaUsuario, @cResponsavel, @iResposta OUTPUT

						END
						ELSE
							SET @iResposta = 27
					END
					ELSE 
						SET @iResposta = 99
				END
				ELSE 
					SET @iResposta = 99
			END

		END

		/* Transacoes Outros Servicos */
		IF (@cBit003 = '000009')
		BEGIN
			
			IF (@iResposta = 0)
			BEGIN

				SELECT @bValidarCpf = 0
					  ,@bValidarDataNascimento = 0

				IF (@cBit046 <> '' AND LEN (@cBit046) = 8)
					SET @bValidarDataNascimento = 1

				IF (@cBit047 <> '' AND LEN (@cBit047) = 11)
					SET @bValidarCpf = 1

				SET @cCPF = SUBSTRING(@cBit047,1,3) + '.' + SUBSTRING(@cBit047,4,3) + '.' + SUBSTRING(@cBit047,7,3) + '-' + SUBSTRING(@cBit047,10,2)

				IF (@bValidarCpf = 1 AND @cCpfBase <> @cCPF)
					SET @iResposta = 99

				IF (@iResposta = 0 AND @bValidarDataNascimento = 1 AND CONVERT(VARCHAR(8),@dDataNascimentoBase,112) <> CONVERT(VARCHAR(8),@dDataNascimento,112))
					SET @iResposta = 99

			END

		END

		/* Transacoes de Saque*/
		IF (@cBit003 = '000010')
		BEGIN
			SET @iResposta = 99
		END

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
					@bEnviaPush OUTPUT, @cBaseOrigem OUTPUT, @iTrnCodigo OUTPUT, @iCntAppCodigo OUTPUT, @iResposta OUTPUT

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


END




