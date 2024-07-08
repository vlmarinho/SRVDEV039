

/*
 ===============================================
 Author:  Luiz Renato
 Create Date: 12/12/2014
 Description: Procedure responsável  por  retor-
			  nar saldo e extrato dos cartões
			  das bases Convênio e Processadora.
 ===============================================
--------------------------------------------------------------------------
Data Alteração: 22/01/2015
Autor:  Mário Négri - CEDRO TECHNOLOGIES
Projeto: Banco 24H
--------------------------------------------------------------------------
Data criação: 19/02/2017
Mudança: 2601
--------------------------------------------------------------------------
Data Alteração: 12/03/2019
Chamado: 613709
--------------------------------------------------------------------------
Data Alteração: 02/07/2019
Chamado: 641097
--------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[pr_AUT_RetornarSaldoExtratoCartoes](
	@cNumeroCartao		CHAR(16)
	,@cBase				CHAR(1)
	,@iTpoPrdCodigo		INT
	,@iCodProcessamento INT
	,@iQtdColDisplay	INT
	,@sBit062			VARCHAR(1000) OUTPUT
	,@sBit120			VARCHAR(1000) OUTPUT
	,@iResposta			INT OUTPUT
	)
AS
BEGIN
	DECLARE @sQuery							 NVARCHAR(MAX)
			,@sQueryOQ						 NVARCHAR(MAX)
			,@sParametros					 NVARCHAR(500)
			,@sMensagem						 VARCHAR(50)
			,@sMsgLimSaqueAVista			 VARCHAR(50)
			,@sMsgLimSaqueParcelado			 VARCHAR(50)
			,@sValorExtrato					 VARCHAR(20)
			,@sTotalCredito					 VARCHAR(20)
			,@sTotalDebito					 VARCHAR(20)
			,@sNomeCartao					 VARCHAR(50)
			,@sAux							 VARCHAR(999)
			,@cDebitoCredito				 CHAR(1)
			,@inSGP							 CHAR(1)
			,@iCont							 INT
			,@iCliente						 INT
			,@iCodCartao					 INT
			,@iCodUsuario					 INT
			,@iFranquiaUsuario				 INT
			,@iDiaInicioPeriodo				 INT
			,@iDiaFimPeriodo				 INT
			,@iAno							 INT
			,@iMes							 INT
			,@iCntUsrCodigo					 INT
			,@iCodigo						 INT
			,@iAux							 INT
			,@dCreditoDisponivel			 DECIMAL(15,2)
			,@dTotalCredito					 DECIMAL(15,2)
			,@dTotalDebito					 DECIMAL(15,2)
			,@dValorExtrato					 DECIMAL(15,2)
			,@dDataTransacao				 DATETIME
			,@dDataExtrato					 DATETIME
			,@dDataInicio					 DATETIME
			,@dDataFim						 DATETIME
			,@sLimSaqueParcelado			 VARCHAR(50)
			,@sLimSaqueAvista				 VARCHAR(50)
			-- SAQUE
			,@iClienteSaque					 INT
			,@iCodigoPerfil					 INT
			,@iQtdOperacaoMensal			 INT
			,@iQtdSaldoPromocional			 INT
			,@iQtdExtratoPromocional		 INT
			,@iTipoLancamento				 SMALLINT
			,@dValorLancamento				 DECIMAL(15,2)
			,@dValorTarifaSaldoPromocional	 DECIMAL(15,2)
			,@dValorTarifaSaldoNormal		 DECIMAL(15,2)
			,@dValorTarifaExtratoPromocional DECIMAL(15,2)
			,@dValorTarifaExtratoNormal		 DECIMAL(15,2)
			,@CreditoDisponivel				 DECIMAL(15,2)
			,@sHistorico					 VARCHAR(50)
			,@iCodigoPerfilBanco24Hrs		 INT
			-- PROCESSADORA
			,@iClienteProcessadora			 INT
			,@iCrtUsrCodigo					 INT
			,@iPrdCodigo					 INT
			,@dValorTarifaProcessadora		 DECIMAL(15,2)
			,@CodTaxaBco24Horas				 INT

	DECLARE @TB_CabecalhoExtratoConv TABLE( Nome					VARCHAR(100)	NULL
											,Codigo					INT				NULL
											,Endereco				VARCHAR(100)	NULL
											,Bairro					VARCHAR(100)	NULL
											,CEP					VARCHAR(100)	NULL
											,Cidade					VARCHAR(100)	NULL
											,Limite_Mensal			DECIMAL(15,2)	NULL
											,Limite_Financiamento	DECIMAL(15,2)	NULL
											,LimExtra				DECIMAL(15,2)	NULL
											,CredRotativo			DECIMAL(15,2)	NULL
											,NomeCliente			VARCHAR(100)	NULL
											,Dia_Inicio_Periodo		INT				NULL
											,CreditoDisponivel		DECIMAL(15,2)	NULL
											,LimSaqueParcelado		DECIMAL(15,2)	NULL
											,LimSaqueAvista			DECIMAL(15,2)	NULL)

	DECLARE @TB_Saldo TABLE(Id					INT IDENTITY(1,1)
							,IdSolic			INT				NULL
							,Nome				VARCHAR(100)	NULL
							,Usuario			INT				NULL
							,LimMensal			DECIMAL(15,2)	NULL
							,LimFinanc			DECIMAL(15,2)	NULL
							,Cliente			VARCHAR(100)	NULL
							,Descricao			VARCHAR(100)	NULL
							,Lancamento			INT				NULL
							,Fornecedor			INT				NULL
							,Valor				DECIMAL(15,2)	NULL
							,DC					CHAR(1)			NULL
							,Mensagem			VARCHAR(100)	NULL
							,CreditoDisponivel	DECIMAL(15,2)	NULL
							,Data				DATETIME
							,Origem				CHAR(1)			NULL
							,Status				CHAR(1)			NULL
							,LimSaqueParcelado	DECIMAL(15,2)	NULL
							,LimSaqueAvista		DECIMAL(15,2)	NULL
							,TipoCartao			VARCHAR(1)		NULL
							,CodCartao			INT				NULL
							,Endereco			VARCHAR(50)		NULL
							,Bairro				VARCHAR(20)		NULL
							,CEP				VARCHAR(20)		NULL
							,Cidade				VARCHAR(50)		NULL
							,LE					DECIMAL(15,2)	NULL
							,CR					DECIMAL(15,2)	NULL
							,DiaInicioPeriodo	INT				NULL
							,IdEstabelecimento	INT				NULL
							,RamoAtividade		VARCHAR(200)	NULL
							,CodRamoAtividade	INT				NULL)

	DECLARE @TB_Extrato TABLE(Id					INT IDENTITY(1,1)
							,Limite_Mensal			DECIMAL(15,2)	NULL
							,Limite_Financiamento	DECIMAL(15,2)	NULL
							,Mensagem				VARCHAR(100)	NULL
							,CodLancamento			INT				NULL
							,Valor					DECIMAL(15,2)	NULL
							,Debito_Credito			CHAR(1)			NULL
							,Data					DATETIME		NULL
							,Lim_Saque_Avista		DECIMAL(15,2)	NULL
							,Lim_Saque_Parcelado	DECIMAL(15,2)	NULL
							,NumeroCartao			VARCHAR(20)		NULL)

	SET @sNomeCartao	= dbo.InitCap(@sBit062)
	SET @dDataTransacao = GETDATE()
	SET @dDataInicio	= DATEADD(DAY,-30,GETDATE())
	SET @dDataFim		= GETDATE()
	SET @iResposta		= 0
	SET @iAux			= 0
	SET @sAux			= ''
	SET @sBit062		= ''
	SET @sBit120		= ''
	SET @iCodigoPerfilBanco24Hrs = 0

	IF (@iResposta = 0)
	BEGIN
		/* INI: RETORNA DADOS NECESSÁRIOS PARA CONSULTAR SALDO OU EXTRATO */
		IF (@cBase = 'C')
		BEGIN
			SET @sQueryOQ = N'SELECT C.Cliente, C.Codigo, C.Usuario, C.Franquia, CL.Dia_Inicio_Periodo, CL.Dia_Fim_Periodo
							  FROM   Policard_603078.dbo.Cartao_Usuario C WITH(NOLOCK)
							  INNER  JOIN Policard_603078.dbo.Cliente CL WITH(NOLOCK) ON (CL.Codigo = C.Cliente AND CL.Franquia = C.Franquia)
							  WHERE StsTransferenciaUsuario IS NULL and CodigoCartao = ''''' + @cNumeroCartao + ''''''

			SET @sQuery = N'SELECT @Cliente = Cliente, @CodigoCartao = Codigo, @CodigoUsuario = Usuario, @FranquiaUsuario = Franquia, @DiaInicioPeriodo = Dia_Inicio_Periodo, @DiaFimPeriodo = Dia_Fim_Periodo
							FROM OPENQUERY([SRVUDI039\PROCESSADORA], ''' + @sQueryOQ + ''')'

			SET @sParametros = N'@Cartao CHAR(16), @Cliente INT OUTPUT, @CodigoCartao INT OUTPUT, @CodigoUsuario INT OUTPUT, @FranquiaUsuario INT OUTPUT, @DiaInicioPeriodo INT OUTPUT, @DiaFimPeriodo INT OUTPUT'

			EXEC sys.sp_executesql
				@sQuery
				,@sParametros
				,@Cartao			= @cNumeroCartao
				,@Cliente			= @iCliente			 OUTPUT
				,@CodigoCartao		= @iCodCartao		 OUTPUT
				,@CodigoUsuario		= @iCodUsuario		 OUTPUT
				,@FranquiaUsuario	= @iFranquiaUsuario  OUTPUT
				,@DiaInicioPeriodo	= @iDiaInicioPeriodo OUTPUT
				,@DiaFimPeriodo		= @iDiaFimPeriodo	 OUTPUT

			-- Selecionando cliente saque
			SELECT	@iClienteSaque = Codigo
			FROM	  Saque.dbo.Clientes WITH(NOLOCK)
			WHERE	CodigoSistemaExterno = @iCliente
					AND CodigoFranquia	 = @iFranquiaUsuario

			SELECT	@iCodigoPerfil = PerfilCodigo
			FROM	  Saque.dbo.ClientesPerfil WITH(NOLOCK)
			WHERE	ClienteCodigo = @iClienteSaque

			SET @dValorLancamento	= 0
			SET @sQueryOQ			= N'SELECT Policard_603078.dbo.f_RetornaAnoPeriodo(''''' + CONVERT(VARCHAR,@dDataTransacao,121) + ''''',' + CONVERT(VARCHAR,@iDiaInicioPeriodo) + ') AS Ano'
			SET @sQuery				= N'SELECT @AnoOut = Ano FROM OPENQUERY([SRVUDI039\PROCESSADORA], ''' + @sQueryOQ + ''')'
			SET @sParametros		= N'@AnoOut INT OUTPUT'

			EXEC sys.sp_executesql @sQuery, @sParametros, @AnoOut = @iAno OUTPUT

			SET @sQueryOQ	 = N'SELECT Policard_603078.dbo.f_RetornaMesPeriodo(''''' + CONVERT(VARCHAR,@dDataTransacao,121) + ''''',' + CONVERT(VARCHAR,@iDiaInicioPeriodo) + ') AS Mes'
			SET @sQuery		 = N'SELECT @MesOut = Mes FROM OPENQUERY([SRVUDI039\PROCESSADORA], ''' + @sQueryOQ + ''')'
			SET @sParametros = N'@MesOut INT OUTPUT'

			EXEC sys.sp_executesql @sQuery, @sParametros, @MesOut = @iMes OUTPUT
			
			SELECT	@iCodigoPerfilBanco24Hrs			= Codigo
					,@iQtdSaldoPromocional			= QtdSaldoPromocional
					,@dValorTarifaSaldoPromocional	= ValorTarifaSaldoPromocional
					,@dValorTarifaSaldoNormal		= ValorTarifaSaldoNormal
					,@iQtdExtratoPromocional		= QtdExtratoPromocional
					,@dValorTarifaExtratoPromocional = ValorTarifaExtratoPromocional
					,@dValorTarifaExtratoNormal		 = ValorTarifaExtratoNormal
			FROM   Saque.dbo.PerfilBanco24Hrs WITH(NOLOCK)
			WHERE CodigoPerfil = @iCodigoPerfil

			IF (@iCodigoPerfilBanco24Hrs = 0)
			BEGIN
				SELECT	TOP 1
					@iQtdSaldoPromocional			= QtdSaldoPromocional
					,@dValorTarifaSaldoPromocional	= ValorTarifaSaldoPromocional
					,@dValorTarifaSaldoNormal		= ValorTarifaSaldoNormal
					,@iQtdExtratoPromocional		= QtdExtratoPromocional
					,@dValorTarifaExtratoPromocional = ValorTarifaExtratoPromocional
					,@dValorTarifaExtratoNormal		 = ValorTarifaExtratoNormal
				FROM   Saque.dbo.ConfigPerfilBco24Horas WITH(NOLOCK)
			END

		END
		ELSE IF (@cBase = 'P')
		BEGIN
			SELECT	@iCntUsrCodigo			= C.CntUsrCodigo
					,@inSGP					= COALESCE(TP.inSGP,'N')
					,@iClienteProcessadora	= PR.EntCodigo
					,@iPrdCodigo			= TP.PrdCodigo
					,@iCrtUsrCodigo			= C.CrtUsrCodigo
			FROM	Processadora.dbo.CartoesUsuarios C WITH(NOLOCK)
			INNER JOIN Processadora.dbo.TiposProdutos TP WITH(NOLOCK) ON (TP.TpoPrdCodigo = C.TpoPrdCodigo)
			INNER JOIN Processadora.dbo.ContasUsuarios CO WITH(NOLOCK) ON (CO.CntUsrCodigo = C.CntUsrCodigo)
			INNER JOIN Processadora.dbo.Propostas PR WITH(NOLOCK) ON (PR.PrpCodigo = CO.PrpCodigo)
			WHERE	C.Numero		= @cNumeroCartao
				AND C.TpoPrdCodigo	= @iTpoPrdCodigo
				AND ISNULL(c.CrtUsrCodigoTransferido,0) = 0
		END
		/* FIM: RETORNA DADOS NECESSÁRIOS PARA CONSULTAR SALDO OU EXTRATO */

		SET @sBit062 = LEFT('Nome: ' + @sNomeCartao + REPLICATE(' ', @iQtdColDisplay), @iQtdColDisplay) + '@'

		/* INI: CONSULTA DE SALDO CONVENIO E PROCESSADORA */
		IF (@iCodProcessamento = 303000)
		BEGIN

			IF (@cBase = 'C')
			BEGIN
				--S -> Saque C -> Saldo  E -> Extrato
				EXEC  Policard_603078.dbo.pr_ConsultaMovimentacaoMensalHistorico 'C', @iCodCartao, @iFranquiaUsuario, @iQtdOperacaoMensal OUTPUT
				EXEC  Policard_603078.dbo.pr_InsereHistoricoSaldoExtratoSaqueBco24H 'C', @iCodCartao, @iCodUsuario, @iFranquiaUsuario, @iCliente

				---TODO: Alterar código de acordo com o de produção criado.
				SET @sMsgLimSaqueAVista		= 'Saque à vista:'
				SET @sMsgLimSaqueParcelado	= 'Saque parcelado:'
				SET @iTipoLancamento		= 31214
				SET @sHistorico				= 'Qtde. Tarifa de consulta saldo Banco 24h: ' + CONVERT(VARCHAR, @iQtdOperacaoMensal)

				IF (@iQtdSaldoPromocional > @iQtdOperacaoMensal)
					SET @dValorLancamento = @dValorTarifaSaldoPromocional
				ELSE
					SET @dValorLancamento = @dValorTarifaSaldoNormal

				-------------------------------------------------------------------------------------------------------------------
				SET @CreditoDisponivel = 0

				INSERT INTO @TB_CabecalhoExtratoConv
					EXEC  Policard_603078.dbo.pr_USR_CabecalhoExtratoConv @iCodUsuario, @iFranquiaUsuario

				SELECT @CreditoDisponivel = CreditoDisponivel FROM @TB_CabecalhoExtratoConv
				-------------------------------------------------------------------------------------------------------------------

				IF (@dValorLancamento > 0 AND @CreditoDisponivel >= @dValorLancamento)
				BEGIN
					IF (@dValorLancamento > 0)

					EXEC  Policard_603078.dbo.sp_LancamentoContaFutura
						@iCodUsuario
						,@iFranquiaUsuario
						,@iAno
						,@iMes
						,@iCodCartao
						,@dDataTransacao
						,1
						,@iTipoLancamento
						,@dValorLancamento
						,0
						,'BCO24HORAS'
						,@sHistorico
				END
				ELSE IF (@dValorLancamento > 0 AND @CreditoDisponivel < @dValorLancamento)
					SET @iResposta = 392

				INSERT INTO @TB_Saldo(Nome,Usuario,Endereco,Bairro,CEP,Cidade,LimMensal,LimFinanc,LE,CR,Cliente,DiaInicioPeriodo,CreditoDisponivel,LimSaqueParcelado,LimSaqueAvista)
					EXEC  Policard_603078.dbo.pr_USR_CabecalhoExtratoConv @iCodUsuario, @iFranquiaUsuario
					UPDATE @TB_Saldo SET Mensagem = 'Compras:'

				SET @sBit062 = @sBit062 + REPLICATE('-', @iQtdColDisplay) + '@'
				SET @sBit062 = @sBit062 + LEFT('Limites Disponíveis' + REPLICATE(' ', @iQtdColDisplay), @iQtdColDisplay) + '@'

			END
			ELSE IF (@cBase = 'P')
			BEGIN

				
				--S -> Saque C -> Saldo  E -> Extrato
				EXEC Processadora.dbo.pr_PROC_ConsultaMovimentacaoMensalHistorico 'C', @iCrtUsrCodigo, @iTpoPrdCodigo, @iCntUsrCodigo, @iQtdOperacaoMensal OUTPUT
				
				SELECT @dCreditoDisponivel = CreditoDisponivel FROM Processadora.dbo.ContasUsuarios WITH (NOLOCK) WHERE CntUsrCodigo = @iCntUsrCodigo
				SELECT @CodTaxaBco24Horas = Codigo FROM Processadora.dbo.TaxaBanco24Hrs WHERE	CodigoCliente = @iClienteProcessadora AND CodigoProduto = @iTpoPrdCodigo

				IF (@CodTaxaBco24Horas IS NULL)
				BEGIN
					SELECT	@dValorTarifaProcessadora = ISNULL( CASE WHEN(@iQtdOperacaoMensal >= QtdSaldoPromocional)
																		THEN ValorTarifaSaldoNormal
																		ELSE ValorTarifaSaldoPromocional
																END, 0)
					FROM	Processadora.dbo.ConfigTaxaBco24Horas
					WHERE	Status = 1
				END
				ELSE
				BEGIN
					SELECT	TOP 1
							@dValorTarifaProcessadora =	ISNULL(CASE WHEN(@iQtdOperacaoMensal >= QtdSaldoPromocional)
																		THEN ValorTarifaSaldoNormal ELSE ValorTarifaSaldoPromocional
															   END, 0)
					FROM	Processadora.dbo.TaxaBanco24Hrs
					WHERE	CodigoCliente		= @iClienteProcessadora
							AND CodigoProduto	= @iTpoPrdCodigo
				END

				
				IF (@dCreditoDisponivel > @dValorTarifaProcessadora)
				BEGIN
					EXEC Processadora.dbo.pr_PROC_InsereHistoricoSaldoExtratoSaqueBco24H 'C', @iCrtUsrCodigo, @iTpoPrdCodigo, @iCntUsrCodigo
					
					IF (@dValorTarifaProcessadora > 0)
					BEGIN
						IF (@iTpoPrdCodigo = 59 AND @iPrdCodigo = 23)
						BEGIN
							IF (@dCreditoDisponivel > 0)
								EXEC Processadora.dbo.pr_PROC_LancamentoBco24HrsPLF @iCntUsrCodigo, @iCrtUsrCodigo, @iClienteProcessadora, @dValorTarifaProcessadora, 775
							ELSE
								SET @iResposta = 392
						END
						ELSE
							EXEC Processadora.dbo.pr_PROC_LancamentoBco24HrsSGP @iCntUsrCodigo, @iCrtUsrCodigo, @iClienteProcessadora, @dValorTarifaProcessadora, 775
							
					END
				END
				ELSE
					SET @iResposta = 392
					
				IF (@iResposta = 0)
				BEGIN

					INSERT INTO @TB_Saldo(Mensagem, CreditoDisponivel, Data)
					SELECT TOP 1  
						'SALDO' Mensagem  
						,C.CreditoDisponivel
						,GETDATE() Data  
					FROM Processadora.dbo.Cartoesusuarios CU WITH(NOLOCK)
					INNER JOIN Processadora.dbo.Contasusuarios C WITH(NOLOCK) ON CU.cntusrcodigo = c.cntusrcodigo
					WHERE CU.CntUsrCodigo = @iCntUsrCodigo 
					AND CU.CrtUsrCodigo = @iCrtUsrCodigo
					AND CU.Tipo = 'T'  
					ORDER BY CU.Status, CU.DataEmissao DESC

					SET @dCreditoDisponivel		= 0
					SET @sMsgLimSaqueAVista		= 'Saldo disponível para Saque:'
					SET @sMsgLimSaqueParcelado	= 'Saldo disponível para Compra:'
				END
			END
			
			IF (@iResposta = 0)
			BEGIN

				WHILE (EXISTS(SELECT * FROM @TB_Saldo))
				BEGIN
					SELECT	TOP 1
							 @iCodigo			 = Id
							,@sMensagem			 = dbo.InitCap(Mensagem)
							,@dCreditoDisponivel = CreditoDisponivel
							,@sLimSaqueParcelado = dbo.f_FormatarValor(CONVERT(VARCHAR,LimSaqueParcelado),'.',',')
							,@sLimSaqueAvista	 = dbo.f_FormatarValor(CONVERT(VARCHAR,(LimSaqueAvista - @dValorTarifaProcessadora)),'.',',')
							,@sLimSaqueAvista	 = dbo.f_FormatarValor(CONVERT(VARCHAR,(LimSaqueAvista)),'.',',')
					FROM	@TB_Saldo
					ORDER BY Id

					SET @sValorExtrato = dbo.f_FormatarValor(CONVERT(VARCHAR,@dCreditoDisponivel),'.',',')
					SET @iAux = @iAux + LEN(@sAux)
					
					IF (@cBase = 'C')    
					
						SET @sAux = @sMensagem + REPLICATE(' ', @iQtdColDisplay - (LEN(@sMensagem) + LEN(@sValorExtrato))) + @sValorExtrato + '@'
									+ @sMsgLimSaqueAVista + REPLICATE(' ', @iQtdColDisplay - (LEN(@sMsgLimSaqueAVista) + LEN(@sLimSaqueAvista))) + @sLimSaqueAvista + '@'
									+ @sMsgLimSaqueParcelado + REPLICATE(' ', @iQtdColDisplay - (LEN(@sMsgLimSaqueParcelado) + LEN(@sLimSaqueParcelado))) + @sLimSaqueParcelado + '@'
						
					ELSE
						SET @sAux = '@' + @sMsgLimSaqueAVista + REPLICATE(' ', @iQtdColDisplay - (LEN(@sMsgLimSaqueAVista) + LEN(@sValorExtrato))) + @sValorExtrato + '@'
									+ @sMsgLimSaqueParcelado + REPLICATE(' ', @iQtdColDisplay - (LEN(@sMsgLimSaqueParcelado) + LEN(@sValorExtrato))) + @sValorExtrato

					IF (@iAux + LEN(@sAux) <= 999)
						SET @sBit062 = @sBit062 + @sAux

					DELETE FROM @TB_Saldo WHERE Id = @iCodigo
				END
			END
		END
		/* FIM: CONSULTA DE SALDO CONVENIO E PROCESSADORA */
		/* INI: CONSULTA DE EXTRATO CONVENIO E PROCESSADORA */
		ELSE IF (@iCodProcessamento = 313000)
		BEGIN

			IF (@cBase = 'C')
			BEGIN
				--S -> Saque  C -> Saldo  E -> Extrato
				EXEC  Policard_603078.dbo.pr_ConsultaMovimentacaoMensalHistorico 'E', @iCodCartao, @iFranquiaUsuario, @iQtdOperacaoMensal OUTPUT
				EXEC  Policard_603078.dbo.pr_InsereHistoricoSaldoExtratoSaqueBco24H 'E', @iCodCartao, @iCodUsuario, @iFranquiaUsuario, @iCliente

				SET @sMsgLimSaqueAVista		= 'Saque à vista:'
				SET @sMsgLimSaqueParcelado	= 'Saque parcelado:'
				SET @iTipoLancamento		= 31212
				SET @sHistorico				= 'Qtde. Tarifa de extrato Banco 24h: ' + CONVERT(VARCHAR,@iQtdOperacaoMensal)



				IF (@iQtdExtratoPromocional > @iQtdOperacaoMensal)
					SET @dValorLancamento = @dValorTarifaExtratoPromocional
				ELSE
					SET @dValorLancamento = @dValorTarifaExtratoNormal

				INSERT INTO @TB_CabecalhoExtratoConv
					EXEC  Policard_603078.dbo.pr_USR_CabecalhoExtratoConv @iCodUsuario, @iFranquiaUsuario

				SELECT @CreditoDisponivel = CreditoDisponivel FROM @TB_CabecalhoExtratoConv

				IF (COALESCE(@dValorLancamento,0) > 0 AND @CreditoDisponivel > COALESCE(@dValorLancamento,0))
				BEGIN
					EXEC  Policard_603078.dbo.sp_LancamentoContaFutura
						@iCodUsuario
						,@iFranquiaUsuario
						,@iAno
						,@iMes
						,@iCodCartao
						,@dDataTransacao
						,1
						,@iTipoLancamento
						,@dValorLancamento
						,0
						,'BCO24HORAS'
						,@sHistorico
				END
				ELSE IF (@dValorLancamento > 0 AND @CreditoDisponivel < @dValorLancamento)
					SET @iResposta = 392

				INSERT INTO @TB_CabecalhoExtratoConv
					EXEC  Policard_603078.dbo.pr_USR_CabecalhoExtratoConv @iCodUsuario, @iFranquiaUsuario

				SELECT @dCreditoDisponivel = CreditoDisponivel FROM @TB_CabecalhoExtratoConv
				
				INSERT INTO @TB_Extrato (Limite_Mensal,Limite_Financiamento,Mensagem,CodLancamento,Valor,Debito_Credito,Data,Lim_Saque_Avista,Lim_saque_parcelado,NumeroCartao)
						EXEC  Policard_603078.dbo.pr_Aut_ExtratoBanco24Hrs @iCodUsuario, @iFranquiaUsuario, @iMes, @iAno

				SELECT	TOP 1
						 @sLimSaqueParcelado = ISNULL (Lim_saque_parcelado,0)
						,@sLimSaqueAvista = ISNULL (Lim_Saque_Avista,0)
				FROM	@TB_Extrato

			END
			ELSE IF (@cBase = 'P')
			BEGIN
				SET @dDataInicio = DATEADD(DAY,-30,GETDATE())
				SET @dDataFim	 = GETDATE()

				--S -> Saque C -> Saldo  E -> Extrato
				EXEC Processadora..pr_PROC_ConsultaMovimentacaoMensalHistorico 'E', @iCrtUsrCodigo, @iTpoPrdCodigo, @iCntUsrCodigo, @iQtdOperacaoMensal OUTPUT
				
				SELECT @dCreditoDisponivel = CreditoDisponivel FROM Processadora.dbo.ContasUsuarios WITH (NOLOCK) WHERE CntUsrCodigo = @iCntUsrCodigo
				SELECT @CodTaxaBco24Horas = Codigo FROM Processadora.dbo.TaxaBanco24Hrs WHERE CodigoCliente = @iClienteProcessadora AND CodigoProduto = @iTpoPrdCodigo

				IF (@CodTaxaBco24Horas IS NULL)
				BEGIN
					SELECT	@dValorTarifaProcessadora = ISNULL(CASE WHEN(@iQtdOperacaoMensal >= QtdExtratoPromocional)
																		THEN ValorTarifaExtratoNormal ELSE ValorTarifaExtratoPromocional
															   END, 0)
					FROM	Processadora..ConfigTaxaBco24Horas
					WHERE	Status = 1
				END
				ELSE
				BEGIN
					SELECT	TOP 1
							@dValorTarifaProcessadora = ISNULL(CASE WHEN(@iQtdOperacaoMensal >= QtdExtratoPromocional)
																		THEN ValorTarifaExtratoNormal ELSE ValorTarifaExtratoPromocional
															   END, 0)
					FROM	Processadora..TaxaBanco24Hrs
					WHERE	CodigoCliente		= @iClienteProcessadora
							AND CodigoProduto	= @iTpoPrdCodigo
				END
				
				IF (@dCreditoDisponivel > @dValorTarifaProcessadora)
				BEGIN
					EXEC Processadora.dbo.pr_PROC_InsereHistoricoSaldoExtratoSaqueBco24H 'E', @iCrtUsrCodigo, @iTpoPrdCodigo, @iCntUsrCodigo

					IF (@dValorTarifaProcessadora > 0)
					BEGIN
						IF (@iTpoPrdCodigo = 59 AND @iPrdCodigo = 23)
						BEGIN
							IF (@dCreditoDisponivel > 0)
								EXEC Processadora.dbo.pr_PROC_LancamentoBco24HrsPLF @iCntUsrCodigo, @iCrtUsrCodigo, @iClienteProcessadora, @dValorTarifaProcessadora, 773
							ELSE
								SET @iResposta = 392
						END
						ELSE
							EXEC Processadora.dbo.pr_PROC_LancamentoBco24HrsSGP @iCntUsrCodigo, @iCrtUsrCodigo, @iClienteProcessadora, @dValorTarifaProcessadora, 773
					END
				END
				ELSE
					SET @iResposta = 392
					
				IF (@iResposta = 0)
				BEGIN
								
					IF (@inSGP = 'S')
					BEGIN

						INSERT INTO @TB_Saldo (Usuario, Status, Nome, Cliente, Data, Origem, Mensagem, Valor, DC, CreditoDisponivel, IdEstabelecimento, RamoAtividade, CodRamoAtividade)
							EXEC Processadora.dbo.pr_USR_DetalhamentoExtratoSGP @iCntUsrCodigo, @iTpoPrdCodigo, @dDataInicio, @dDataFim

						/* Verificando se existe transacoes na base autorizacao */
						IF EXISTS (SELECT 1 FROM Processadora.dbo.Transacoes  WITH (NOLOCK)
									WHERE CrtUsrCodigo = @iCrtUsrCodigo	
									AND CONVERT(VARCHAR(10), Data, 102) = CONVERT(VARCHAR(10), GETDATE(), 102)
									AND Status IN ('A', 'P', 'E') 
									AND TipoMensagem IN ('0200','0400'))
						BEGIN
							INSERT INTO @TB_Saldo (Usuario, Status, Nome, Cliente, Data, Origem, Mensagem, Valor, DC)
							SELECT t.CrtUsrCodigo
								 , t.Status
								 , c.Nome
								 , c.Numero
								 , t.Data
								 , 'T'
								 , SUBSTRING(e.Nome, 1, 30) AS Nome
								 , T.Valor
								 , CASE WHEN T.TipoMensagem = '0200' THEN 'D' 
										WHEN T.TipoMensagem = '0400' THEN 'C'
									END AS DC
								FROM Processadora.dbo.Transacoes t WITH (NOLOCK) 
								INNER JOIN Processadora.dbo.CartoesUsuarios c WITH (NOLOCK) ON t.CrtUsrCodigo = c.CrtUsrCodigo
								INNER JOIN Processadora.dbo.Estabelecimentos e WITH (NOLOCK) ON t.EstCodigo = e.EstCodigo
								WHERE T.CrtUsrCodigo = @iCrtUsrCodigo	
								AND CONVERT(VARCHAR(10), T.Data, 102) = CONVERT(VARCHAR(10), GETDATE(), 102)
								AND T.Status IN ('A', 'P', 'E')
								AND TipoMensagem IN ('0200','0400')
							ORDER BY TrnCodigo DESC
						END
						
					END
					ELSE
					BEGIN
						INSERT INTO @TB_Saldo (Usuario, Nome, Status, Cliente, Mensagem, Data, Origem, Valor, DC, IdEstabelecimento, RamoAtividade, CodRamoAtividade)
							EXEC Processadora.dbo.pr_USR_DetalhamentoExtratoProc @iCntUsrCodigo, @dDataInicio, @dDataFim
					END
					
					SET @dCreditoDisponivel = 0

					DECLARE @TB_Aux TABLE(Mensagem VARCHAR(100) NULL, CreditoDisponivel DECIMAL(15,2) NULL, Data DATETIME NULL)

					INSERT INTO @TB_Aux(Mensagem, CreditoDisponivel, Data)
					SELECT TOP 1  
						'SALDO' Mensagem  
						,C.CreditoDisponivel
						,GETDATE() Data  
					FROM Processadora.dbo.Cartoesusuarios CU WITH(NOLOCK)
					INNER JOIN Processadora.dbo.Contasusuarios C WITH(NOLOCK) ON CU.cntusrcodigo = c.cntusrcodigo
					WHERE CU.CntUsrCodigo = @iCntUsrCodigo 
					AND CU.CrtUsrCodigo = @iCrtUsrCodigo
					AND CU.Tipo = 'T'  
					ORDER BY CU.Status, CU.DataEmissao DESC

					SELECT @dCreditoDisponivel = CreditoDisponivel FROM @TB_Aux

					SET @sMsgLimSaqueAVista		= 'Saldo disponível para Saque:'
					SET @sMsgLimSaqueParcelado	= 'Saldo disponível para Compra:'

				END
			END

			SET @sBit062		= @sBit062 + '@' + LEFT('ÚLTIMOS LANÇAMENTOS' + REPLICATE(' ', @iQtdColDisplay),@iQtdColDisplay) + '@'
			SET @sBit062		= @sBit062 + 'Data  Descricao' + REPLICATE(' ', @iQtdColDisplay - (LEN('Data  Descricao') + LEN('Valor12'))) + 'Valor@@'
			SET @dTotalCredito	= 0
			SET @dTotalDebito	= 0
			SET @iCont			= 0

			IF (@iCodProcessamento = 313000 AND @cBase = 'C')
			BEGIN

				SELECT TOP 11 * INTO #TMPEXTRATO FROM @TB_Extrato ORDER BY Data DESC

				WHILE (EXISTS(SELECT * FROM #TMPEXTRATO)) -- @TB_Saldo
				BEGIN
					SELECT	TOP 1
							 @iCodigo		 = Id
							,@dDataExtrato	 = Data
							,@sMensagem		 = dbo.InitCap(Mensagem)
							,@dValorExtrato	 = Valor
							,@cDebitoCredito = Debito_Credito
					FROM	#TMPEXTRATO -- @TB_Saldo
					ORDER BY Id

					SET @sValorExtrato	= dbo.f_FormatarValor(CONVERT(VARCHAR,@dValorExtrato),'.',',')
					SET @dTotalCredito	= @dTotalCredito + CASE WHEN(@cDebitoCredito = 'C') THEN @dValorExtrato ELSE 0 END
					SET @dTotalDebito	= @dTotalDebito + CASE WHEN(@cDebitoCredito = 'D') THEN @dValorExtrato ELSE 0 END
					SET @sMensagem		= LEFT(@sMensagem, @iQtdColDisplay - (LEN(CONVERT(VARCHAR(5), @dDataExtrato, 3)) + LEN(@sValorExtrato) + 4))
					SET @iAux			= @iAux + LEN(@sAux)
					SET @sAux			= CONVERT(VARCHAR(5), @dDataExtrato, 3) + ' ' + @sMensagem + REPLICATE(' ', @iQtdColDisplay - (LEN(CONVERT(VARCHAR(5), @dDataExtrato, 3)) + LEN(@sMensagem) + LEN(@sValorExtrato) + 3)) + @sValorExtrato + ' ' + @cDebitoCredito + '@'

					IF (@iAux + LEN(@sAux) <= 999 - (@iQtdColDisplay + @iQtdColDisplay + LEN(@sNomeCartao)))
						SET @sBit062 = @sBit062 + @sAux

					SET @iCont = @iCont + 1

					DELETE FROM #TMPEXTRATO WHERE Id = @iCodigo -- @TB_Saldo

					IF (@iCont = 9 AND @cBase = 'C') BREAK
				END

				DROP TABLE #TMPEXTRATO
				
			END
			ELSE
			BEGIN

				SELECT TOP 11 * INTO #TMPSALDO FROM @TB_Saldo ORDER BY Data DESC
			
				WHILE (EXISTS(SELECT * FROM #TMPSALDO)) -- @TB_Saldo
				BEGIN
					SELECT	TOP 1
							 @iCodigo		 = Id
							,@dDataExtrato	 = Data
							,@sMensagem		 = dbo.InitCap(Mensagem)
							,@dValorExtrato	 = Valor
							,@cDebitoCredito = DC
					FROM	#TMPSALDO -- @TB_Saldo
					ORDER BY Id

					SET @sValorExtrato	= dbo.f_FormatarValor(CONVERT(VARCHAR,@dValorExtrato),'.',',')
					SET @dTotalCredito	= @dTotalCredito + CASE WHEN(@cDebitoCredito = 'C') THEN @dValorExtrato ELSE 0 END
					SET @dTotalDebito	= @dTotalDebito + CASE WHEN(@cDebitoCredito = 'D') THEN @dValorExtrato ELSE 0 END
					SET @sMensagem		= LEFT(@sMensagem, @iQtdColDisplay - (LEN(CONVERT(VARCHAR(5), @dDataExtrato, 3)) + LEN(@sValorExtrato) + 4))
					SET @iAux			= @iAux + LEN(@sAux)
					SET @sAux			= CONVERT(VARCHAR(5), @dDataExtrato, 3) + ' ' + @sMensagem + REPLICATE(' ', @iQtdColDisplay - (LEN(CONVERT(VARCHAR(5), @dDataExtrato, 3)) + LEN(@sMensagem) + LEN(@sValorExtrato) + 3)) + @sValorExtrato + ' ' + @cDebitoCredito + '@'

					IF (@iAux + LEN(@sAux) <= 999 - (@iQtdColDisplay + @iQtdColDisplay + LEN(@sNomeCartao)))
						SET @sBit062 = @sBit062 + @sAux

					SET @iCont = @iCont + 1

					DELETE FROM #TMPSALDO WHERE Id = @iCodigo -- @TB_Saldo

					IF (@iCont = 9 AND @cBase = 'C') BREAK
				END

				DROP TABLE #TMPSALDO
			
			END

			SET @sLimSaqueParcelado = dbo.f_FormatarValor(CONVERT(VARCHAR,@sLimSaqueParcelado,0),'.',',')
			SET @sLimSaqueAvista = dbo.f_FormatarValor(CONVERT(VARCHAR,@sLimSaqueAvista,0),'.',',')


			SET @sValorExtrato	= dbo.f_FormatarValor(CONVERT(VARCHAR,@dCreditoDisponivel),'.',',')
			SET @sTotalCredito	= dbo.f_FormatarValor(CONVERT(VARCHAR,@dTotalCredito),'.',',')
			SET @sTotalDebito	= dbo.f_FormatarValor(CONVERT(VARCHAR,@dTotalDebito),'.',',')

			IF (@dTotalCredito > 0 OR @dTotalDebito > 0)
			BEGIN
				IF (@cBase = 'C')
					SET @sBit062 =	@sBit062 + '@Total Crédito' + REPLICATE(' ', @iQtdColDisplay - (LEN('Total Crédito') + LEN(@sTotalCredito))) + @sTotalCredito + '@'
									+ 'Total Débito' + REPLICATE(' ', @iQtdColDisplay - (LEN('Total Débito') + LEN(@sTotalDebito))) + @sTotalDebito + '@'
									+ REPLICATE('-', @iQtdColDisplay) + '@' + LEFT('Limites Disponíveis' + REPLICATE(' ', @iQtdColDisplay), @iQtdColDisplay) + '@'
									+ 'Compras' + REPLICATE(' ', @iQtdColDisplay - (LEN('Compras') + LEN(@sValorExtrato))) + @sValorExtrato + '@'
									+ @sMsgLimSaqueAVista + REPLICATE(' ', @iQtdColDisplay - (LEN(@sMsgLimSaqueAVista) + LEN(@sLimSaqueAvista))) + @sLimSaqueAvista + '@'
									+ @sMsgLimSaqueParcelado + REPLICATE(' ', @iQtdColDisplay - (LEN(@sMsgLimSaqueParcelado) + LEN(@sLimSaqueParcelado))) + @sLimSaqueParcelado + '@'
				ELSE
					SET @sBit062 =	@sBit062 + '@Total Crédito' + REPLICATE(' ', @iQtdColDisplay - (LEN('Total Crédito') + LEN(@sTotalCredito))) + @sTotalCredito + '@'
									+ 'Total Débito' + REPLICATE(' ', @iQtdColDisplay - (LEN('Total Débito') + LEN(@sTotalDebito))) + @sTotalDebito + '@' + REPLICATE('-', @iQtdColDisplay) + '@'
									+ @sMsgLimSaqueAVista + REPLICATE(' ', @iQtdColDisplay - (LEN(@sMsgLimSaqueAVista) + LEN(@sValorExtrato))) + @sValorExtrato + '@'
									+ @sMsgLimSaqueParcelado + REPLICATE(' ', @iQtdColDisplay - (LEN(@sMsgLimSaqueParcelado) + LEN(@sValorExtrato))) + @sValorExtrato + '@'
			END
			ELSE
				SET @sBit062 =	LEFT('Nome: ' + @sNomeCartao + REPLICATE(' ', @iQtdColDisplay), @iQtdColDisplay) + '@@' + LEFT('Não existem lançamentos para este cartão' + REPLICATE(' ', @iQtdColDisplay),@iQtdColDisplay) + '@@'
								+ @sMsgLimSaqueAVista + REPLICATE(' ', @iQtdColDisplay - (LEN(@sMsgLimSaqueAVista) + LEN(@sValorExtrato))) + @sValorExtrato + '@'
								+ @sMsgLimSaqueParcelado + REPLICATE(' ', @iQtdColDisplay - (LEN(@sMsgLimSaqueParcelado) + LEN(@sValorExtrato))) + @sValorExtrato + '@'

			
		END
		/* FIM: CONSULTA DE EXTRATO CONVENIO E PROCESSADORA */
	END

	IF (@iResposta <> 0)
	BEGIN
		SET @sBit062 = ''
		SET @sBit120 = ''
	END
END



