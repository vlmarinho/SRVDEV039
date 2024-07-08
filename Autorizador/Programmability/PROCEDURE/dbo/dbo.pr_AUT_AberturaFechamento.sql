	/* 
--------------------------------------------------------------------------
Nome Sistema: Autorização
Objeto: [dbo].[pr_aut_AberturaFechamento]
Propósito: Procedure responsável por realizar abertura e fechamento.
Autor: Cristiano Silva Barbosa - Tecnologia Policard
--------------------------------------------------------------------------
Data: 19/02/2017
Mud/CH.:  2601
--------------------------------------------------------------------------
Data: 24/02/2017
Mud/CH.: 359154 / 2627
--------------------------------------------------------------------------
Data Alteracao: 16/05/2017
Autor: Cristiano Barbosa
CH: 383212 -  2839
--------------------------------------------------------------------------
Data Alteração: 24/08/2017
Chamado: 409745 / 3170 
Responsavel: Cristiano Barbosa- Policard Systems
--------------------------------------------------------------------------
Data Alteração: 26/04/2018
Chamados: 494467  / 3947
Responsavel: Cristiano Barbosa- Up Brasil
--------------------------------------------------------------------------
Data Alteração: 24/08/2018
Chamados: 549384 / 4359
Responsavel: João Henrique - Up Brasil
--------------------------------------------------------------------------
Data: 08/09/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1843805
Descrição: Projeto ABECS para transações NCR/Scope.
-------------------------------------------------------------------------- 	
Data: 08/09/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1888210
Descrição: Projeto ABECS para transações Auttar/Getnet.
-------------------------------------------------------------------------- 	
Data: 16/11/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1940185
Descrição: Correção retorno 0800, envio do bit 052.
-------------------------------------------------------------------------- 	
*/

CREATE PROCEDURE [dbo].[pr_AUT_AberturaFechamento](
		 @cBit003					CHAR (6)		OUTPUT
		,@cBit012					CHAR(06)		OUTPUT
		,@cBit013					CHAR(04)		OUTPUT
		,@iRedeNumero				INT
		,@cBit039					CHAR(2)			OUTPUT
		,@cBit041					CHAR(08)
		,@iCodigoEstabelecimento	INT
		,@bEstabMigrado				BIT
		,@cBit047					varchar(1000)	OUTPUT
		,@cProvedor					VARCHAR(20)	 
		,@cBit052					VARCHAR(16)		OUTPUT
		,@cBit059					VARCHAR(1000)	OUTPUT
		,@cBit060					VARCHAR(1000)	OUTPUT
		,@cBit061					VARCHAR(1000)	OUTPUT
		,@cBit062					VARCHAR(1000)	OUTPUT
		,@cBit063					CHAR(10)		OUTPUT
		,@cBit070					CHAR(03)
		,@cBit080					VARCHAR(10)
		,@cBit091					CHAR(1)			OUTPUT	/* BIT091 - Indicador de carga de tabelas */
		,@cBit124					VARCHAR(1000)	OUTPUT	/* BIT124 - Chave 3DES para TEF SCOPE PRIVATE*/
		,@cBit123					VARCHAR(1000)			/* Versão protocolo NCR/Scope */
		,@iResposta					INT				OUTPUT
	)

AS
BEGIN

	SET NOCOUNT ON;

	DECLARE
		 @iMeiCptCodigo_MeiosCaptura	INT
		,@cStatus_MeiosCaptura			CHAR(1)
		,@cNumeroSerie					VARCHAR(50)
		,@bMultiBandeira				BIT
		,@cModelo						VARCHAR(20)
		,@cVersao						VARCHAR(20)
		,@cOPeradora					VARCHAR(10)
		,@cSimId						VARCHAR(50)
		,@cWorkingKey					VARCHAR(32)
		,@iEstCodigo_Estabelecimentos	INT
		,@cNomeEstab					VARCHAR(38)
		,@cEnderecoEstab				VARCHAR(38)
		,@cCidadeEstab					VARCHAR(34)
		,@cEstadoEstab					VARCHAR(2)
		,@cCNPJ							VARCHAR(20)
		,@cStatus_Estabelecimentos		CHAR(1)
		,@Kcv							VARCHAR(64)
		,@IdentificadorWk				VARCHAR(64)
				
	SET @iResposta = 0
	SET @cBit060 = ''

	IF (@bEstabMigrado = 0)
	BEGIN
	
		SELECT	 @iMeiCptCodigo_MeiosCaptura = MeiCptCodigo
				,@cStatus_MeiosCaptura		 = [Status]
				,@bMultiBandeira			 = MultiBandeira
		FROM Processadora.dbo.MeiosCaptura WITH(NOLOCK)
		WHERE Numero = @cBit041	
			
		SELECT	 @iEstCodigo_Estabelecimentos	= EstCodigo
				,@cStatus_Estabelecimentos		= [Status]
				,@cNomeEstab					= LTRIM(RTRIM(Nome))
				,@cEnderecoEstab				= LTRIM(RTRIM(Endereco))
				,@cCidadeEstab					= LTRIM(RTRIM(Cidade))
				,@cEstadoEstab					= LTRIM(RTRIM(Estado))
				,@cCNPJ							= LTRIM(RTRIM(CNPJ))
		FROM Processadora.dbo.Estabelecimentos WITH(NOLOCK)
		WHERE Numero = @iCodigoEstabelecimento

	END
	ELSE IF (@bEstabMigrado = 1)
	BEGIN

		SELECT 
			 @cStatus_Estabelecimentos = CASE WHEN E.CodigoEntidadeStatus = 1 THEN 'A'
											  WHEN E.CodigoEntidadeStatus = 2 THEN 'I'
											  WHEN E.CodigoEntidadeStatus = 3 THEN 'C'
											  WHEN E.CodigoEntidadeStatus = 4 THEN 'P'
											  WHEN E.CodigoEntidadeStatus = 6 THEN 'B'
										 END
			,@cCNPJ				= dbo.f_FormatarCNPJ_CPF(E.Cnpj)
			,@cNomeEstab		= LTRIM(RTRIM(E.Nome))
			,@cEnderecoEstab	= LTRIM(RTRIM(EE.Logradouro))
			,@cCidadeEstab		= LTRIM(RTRIM(EE.Cidade))
			,@cEstadoEstab		= EE.UF
			,@iEstCodigo_Estabelecimentos = 0
			,@iMeiCptCodigo_MeiosCaptura = 0 /*VERIFICAR*/
			,@cStatus_MeiosCaptura	= 'A' /*VERIFICAR*/
		FROM Acquirer.dbo.Estabelecimento E WITH (NOLOCK)
		INNER JOIN Acquirer.dbo.EstabelecimentoEndereco EE WITH (NOLOCK) ON E.CodigoEstabelecimento = EE.CodigoEstabelecimento
		WHERE E.CodigoEstabelecimento = @iCodigoEstabelecimento
		AND EE.CodigoTipoEndereco = 1

	END
	
	IF (@cBit003 = '008000')
	BEGIN
		DECLARE @cVersaoCargaTbl VARCHAR(10)
		SELECT @cVersaoCargaTbl = Versao FROM dbo.VersaoCargaTabela WITH (NOLOCK) WHERE Ativo = 1 ORDER BY Codigo
		
		IF @cBit080 = @cVersaoCargaTbl
			SET @cBit091 = 0
		ELSE
			SET @cBit091 = 1
	END
	ELSE 
		SET @cBit091 = ''

		

	/*
	Trava: CodigoEstabelecimentoInvalido
	Descricao: Código do estabelecimento inválido ou não informado
	Código: --
	*/
	IF (@iCodigoEstabelecimento IS NOT NULL AND @iCodigoEstabelecimento <> '')
	BEGIN
		/*
		Trava: CodigoGerenciamentoInvalido
		Descricao: Código de gerenciamento inválido ou não informado
		Código: --
		*/
		IF (@cBit070 IS NOT NULL AND @cBit070 <> '')
		BEGIN				
			/*
			Trava: CodigoMeioCapturaInvalido
			Descricao: Código do meio de captura inválido ou não informado
			Código: --
			*/	
			
			
			IF ((@iMeiCptCodigo_MeiosCaptura IS NOT NULL) OR @iRedeNumero NOT IN (8,13,57,58))-- VERIFICA CADASTRO MEIO CAPTURA DE TEF DISCADO, POS POLICARD, POS PHOEBUS e POS WALK
			BEGIN
			
				/*   
				Trava: Validar_Status_MeiosCaptura      
				Descrição : Verifica o status do meio de captura.    
				Código: --  
				*/ 
				IF(@cStatus_MeiosCaptura = 'A' OR @iRedeNumero NOT IN (8,13,57,58)) --VERIFICA CADASTRO MEIO CAPTURA DE TEF DISCADO, POS POLICARD, POS PHOEBUS e POS WALK
				BEGIN	
					
					/* Geração da chave de trabalho */
					IF (@iRedeNumero IN (13,22,23,24,25,58)) /*POS POLICARD, POS MASTER E POS WALK não devem gerar chave de trabalho*/
					BEGIN

						IF (@cBit070 = '001' AND @iRedeNumero IN (22,23,24))
						BEGIN
							
							SELECT @cBit059 = CONVERT(VARCHAR(32), dbo.GerarChaveTrabalho ('TDES'))
							SET @cWorkingKey = @cBit059
																						
							EXEC [dbo].[pr_EncriptaTDES] @cWorkingKey OUTPUT
														
							IF (LEN (@cWorkingKey) = 32)
							BEGIN
								/* Modificação realizada para atender a abertura Masters*/
								--IF NOT EXISTS (SELECT 1 FROM dbo.WorkingKey WITH (NOLOCK)
								--			WHERE Terminal = @cBit041)
											
								--BEGIN

									INSERT INTO dbo.WorkingKey
											( Terminal ,
											  ChaveTrabalho ,
											  DataCriacaoChave ,
											  Provedor, 
											  Estabelecimento
											)
									VALUES  ( @cBit041 ,	-- Terminal - varchar(8)
											  @cWorkingKey ,-- ChaveTrabalho - varchar(32)
											  GETDATE(),	-- DataCriacaoChave - datetime
											  @cProvedor,		-- Provedor - varchar(30)
											  @iCodigoEstabelecimento -- Estabelecimento
											)
									/* Modificação realizada para atender a abertura Masters*/
								--END
								--ELSE
								--	UPDATE dbo.WorkingKey SET ChaveTrabalho = @cWorkingKey, Estabelecimento = @iCodigoEstabelecimento, DataCriacaoChave = GETDATE() WHERE Terminal = @cBit041
							END
						END
					END
					ELSE
					BEGIN 

						/*PAYGO VAI UTILIZAR CHAVE DES E 3DES ATE QUE SEJA ATUALIZADO*/
						IF (@cProvedor IN ('SCOPEPRIVATE','PAYGO')) 
						BEGIN 
						
							IF (@cBit070 = '001')
							BEGIN
								
								IF (@cProvedor = 'SCOPEPRIVATE') 
								BEGIN 								
								
									IF (@cBit123 like 'SCOPEPRIVATE0300%')
									BEGIN
										
										SET @cBit041 = 'IT000000' /*TEF SCOPEPRIVATE NAO ENVIA TERMINAL NA ABERTURA*/ 
										SELECT @cWorkingKey = CONVERT(VARCHAR(32), dbo.GerarChaveTrabalho ('TDES')) 
										 
										EXEC [dbo].[pr_aut_EncriptaScope] @cBit123, @cWorkingKey OUTPUT 
	 
										IF (LEN (@cWorkingKey) = 32) 
										BEGIN 
											 
											SET @cBit124 = @cWorkingKey 
	 
											INSERT INTO dbo.WorkingKey 
													( Terminal , 
														ChaveTrabalho , 
														DataCriacaoChave , 
														Provedor,  
														Estabelecimento 
													) 
											VALUES  ( @cBit041 ,	-- Terminal - varchar(8) 
														@cWorkingKey ,-- ChaveTrabalho - varchar(32) 
														GETDATE(),	-- DataCriacaoChave - datetime 
														@cProvedor,		-- Provedor - varchar(30) 
														@iCodigoEstabelecimento 
													) 
										END 
									END
									/* 3DES ncr */
									ELSE
									BEGIN
										
										IF (ISNULL(@cBit124, '') = '')
										BEGIN
											
											SET @cBit124 = 'DC0144412010000032'
											
											SET @cBit041 = 'IT000000' /*TEF SCOPEPRIVATE NAO ENVIA TERMINAL NA ABERTURA*/ 
											SELECT @cWorkingKey = CONVERT(VARCHAR(32), dbo.GerarChaveTrabalho ('TDES')) 
											 
											EXEC [dbo].[pr_aut_EncriptaScope] @cBit123, @cWorkingKey OUTPUT 
		 
											IF (LEN (@cWorkingKey) = 32) 
											BEGIN 
												 
												SET @cBit124 = @cBit124 + @cWorkingKey 
		 
												INSERT INTO dbo.WorkingKey 
														( Terminal , 
															ChaveTrabalho , 
															DataCriacaoChave , 
															Provedor,  
															Estabelecimento 
														) 
												VALUES  ( @cBit041 ,	-- Terminal - varchar(8) 
															@cWorkingKey ,-- ChaveTrabalho - varchar(32) 
															GETDATE(),	-- DataCriacaoChave - datetime 
															@cProvedor,		-- Provedor - varchar(30) 
															@iCodigoEstabelecimento 
														) 
											END
										END
										ELSE
										BEGIN
											
											
											
											SELECT TOP 1 @Kcv = LEFT(t.Kcv + SPACE(32), 32)
												,@IdentificadorWk = t.IdentificadorWK
											FROM dbo.aut_ChavesHSM t
											WHERE t.Provedor = 'SCOPEPRIVATE'
												AND t.LabelChavePOS LIKE 'UP.NCR.PRD.%'
												AND t.LabelChaveTDB = 'PLC.01.TDB'
												AND t.LoteWK = @cBit124
											ORDER BY NEWID();		
										
											SET @cBit124 = 'DC024431209'
											SET @cBit124 = @cBit124 + @IdentificadorWk + '32' + @Kcv;
											SET @cBit124 = @cBit124 + '44412000000032';
	
											
											SET @cBit041 = 'IT000000' /*TEF SCOPEPRIVATE NAO ENVIA TERMINAL NA ABERTURA*/ 
											SELECT @cWorkingKey = CONVERT(VARCHAR(32), dbo.GerarChaveTrabalho ('TDES')) 
											 
											EXEC [dbo].[pr_aut_EncriptaScope] @cBit123, @cWorkingKey OUTPUT 
		 
											IF (LEN (@cWorkingKey) = 32) 
											BEGIN 
												 
												SET @cBit124 = @cBit124 + @cWorkingKey 
		 
												INSERT INTO dbo.WorkingKey 
														( Terminal , 
															ChaveTrabalho , 
															DataCriacaoChave , 
															Provedor,  
															Estabelecimento 
														) 
												VALUES  ( @cBit041 ,	-- Terminal - varchar(8) 
															@cWorkingKey ,-- ChaveTrabalho - varchar(32) 
															GETDATE(),	-- DataCriacaoChave - datetime 
															@cProvedor,		-- Provedor - varchar(30) 
															@iCodigoEstabelecimento 
														) 
											END										
										END 
									END
								END 
								ELSE
								BEGIN

									SELECT @cBit059 = CONVERT(VARCHAR(32), dbo.GerarChaveTrabalho ('TDES'))
									SET @cWorkingKey = @cBit059
								
																							
									EXEC [dbo].[pr_EncriptaTDES] @cWorkingKey OUTPUT
															
									IF (LEN (@cWorkingKey) = 32)
									BEGIN
									
										IF NOT EXISTS (SELECT 1 FROM dbo.WorkingKey WITH (NOLOCK)
													WHERE Terminal = @cBit041 AND Estabelecimento = @iCodigoEstabelecimento)
												
										BEGIN

											INSERT INTO dbo.WorkingKey
													( Terminal ,
													  ChaveTrabalho ,
													  DataCriacaoChave ,
													  Provedor, 
													  Estabelecimento
													)
											VALUES  ( @cBit041 ,	-- Terminal - varchar(8)
													  @cWorkingKey ,-- ChaveTrabalho - varchar(32)
													  GETDATE(),	-- DataCriacaoChave - datetime
													  @cProvedor,		-- Provedor - varchar(30)
													  @iCodigoEstabelecimento
													)
										
										END
										ELSE
											UPDATE dbo.WorkingKey SET ChaveTrabalho = @cWorkingKey, DataCriacaoChave = GETDATE() WHERE Terminal = @cBit041 AND Estabelecimento = @iCodigoEstabelecimento
									END
								END
							END
						
						END 
						ELSE IF (@cProvedor = 'CSI_CTF' AND @cBit061 LIKE '%VersaoAuttar1.0%')
						BEGIN
							
							DECLARE @identificadorWorkinKey VARCHAR(64)
							SELECT TOP 1 @identificadorWorkinKey=ach.IdentificadorWK
							FROM Autorizador.dbo.aut_ChavesHSM ach WITH (NOLOCK)
							WHERE ach.Provedor = @cProvedor
								AND ach.LoteWK = RIGHT(@cBit061, 2)
							ORDER BY NEWID()
							
							SET @cBit061 = '001015VersaoAuttar1.0006002' + @identificadorWorkinKey;
						
							SELECT @cBit052 = CONVERT(VARCHAR(16), dbo.GerarChaveTrabalho (@cProvedor))

							IF (LEN (@cBit052) < 16)
							BEGIN

								IF EXISTS (SELECT 1 FROM dbo.ChaveAberturaTEF WITH (NOLOCK)
											WHERE Estabelecimento = @iCodigoEstabelecimento
											AND Provedor = @cProvedor
											AND LEN(ChaveTrabalho) = 16)

								BEGIN /*Caso o estabelecimento ja tenha gerado uma chave de trabalho valida*/
									SELECT TOP 1 @cBit052 =  ChaveTrabalho 
									FROM dbo.ChaveAberturaTEF WITH (NOLOCK) 
									WHERE Estabelecimento = @iCodigoEstabelecimento
									AND Provedor = @cProvedor
									AND LEN(ChaveTrabalho) = 16 
									ORDER BY ChaveAberturaTefCodigo DESC
								END                                                                                                                      
								ELSE /*Caso o estabelecimento ainda nao tenha nenhuma chave de trabalho valida sera utilizada a ultima chave gerada para o provedor*/
								BEGIN
									SELECT TOP 1 @cBit052 = ChaveTrabalho 
									FROM dbo.ChaveAberturaTEF WITH (NOLOCK) 
									WHERE Provedor = @cProvedor
										AND LEN(ChaveTrabalho) = 16 
									ORDER BY ChaveAberturaTefCodigo DESC
								END
							END

						END
						ELSE						
						BEGIN 			
							
							SELECT @cBit052 = CONVERT(VARCHAR(16), dbo.GerarChaveTrabalho (@cProvedor))

							IF (LEN (@cBit052) < 16)
							BEGIN

								IF EXISTS (SELECT 1 FROM dbo.ChaveAberturaTEF WITH (NOLOCK)
											WHERE Estabelecimento = @iCodigoEstabelecimento
											AND Provedor = @cProvedor
											AND LEN(ChaveTrabalho) = 16)

								BEGIN /*Caso o estabelecimento ja tenha gerado uma chave de trabalho valida*/
									SELECT TOP 1 @cBit052 =  ChaveTrabalho 
									FROM dbo.ChaveAberturaTEF WITH (NOLOCK) 
									WHERE Estabelecimento = @iCodigoEstabelecimento
									AND Provedor = @cProvedor
									AND LEN(ChaveTrabalho) = 16 
									ORDER BY ChaveAberturaTefCodigo DESC
								END                                                                                                                      
								ELSE /*Caso o estabelecimento ainda nao tenha nenhuma chave de trabalho valida sera utilizada a ultima chave gerada para o provedor*/
								BEGIN
									SELECT TOP 1 @cBit052 = ChaveTrabalho 
									FROM dbo.ChaveAberturaTEF WITH (NOLOCK) 
									WHERE Provedor = @cProvedor
										AND LEN(ChaveTrabalho) = 16 
									ORDER BY ChaveAberturaTefCodigo DESC
								END
							END
						END
					END
							

					/*   
					Trava: Validar_Existencia_Estabelecimento     
					Descrição : Verifica a existência do estabelecimento.    
					Código: --  
					*/ 

					IF(@iEstCodigo_Estabelecimentos IS NOT NULL)
					BEGIN
					
						/*   
						Trava: Validar_Status_Estabelecimentos      
						Descrição : Verifica o status do estabelecimento.    
						Código: --  
						*/

						IF(@cStatus_Estabelecimentos = 'A' OR @iRedeNumero = 7)/*Permitir realizar abertura de PDV de estabelecimentos bloq/cancel. com tef dedicado*/
						BEGIN

							DECLARE 
								@cStatus_TransacoesStatusTEF CHAR(1)
								
								
							/*INFORMACAO DA REDE PARA O SCOPE-PRIVATE*/	
							IF (@cProvedor = 'SCOPEPRIVATE')
							BEGIN
								SET @cBit062 = 'A028POLICARD            0100'
								SELECT @cBit063 = Versao FROM dbo.VersaoCargaTabela WITH (NOLOCK) WHERE Ativo = 1 ORDER BY Codigo
							END
							ELSE
								EXEC pr_aut_ConsultarRespostaPolicard @iResposta, @iRedeNumero, @cBit039 OUTPUT, @cBit062 OUTPUT
							

							IF(@cBit070 = '001')
								SET @cStatus_TransacoesStatusTEF = 'A'
							ELSE
								SET @cStatus_TransacoesStatusTEF = 'F'
								
							/*Atualizando data e hora do POS*/
							IF (@iRedeNumero IN (13,58))
								SELECT @cBit012 = REPLACE(CONVERT (VARCHAR(8),GETDATE(),108),':','')
									  ,@cBit013 = REPLACE(CONVERT (VARCHAR(5),GETDATE(),110),'-','')
						
							IF(@cBit070 NOT IN ('003','004')) /*003 = Keep Alive /004 = Monitoramento via Semáforo*/
							BEGIN

								INSERT INTO	TransacoesStatusTEF (
											Estabelecimento, 
											Terminal, 
											[Status], 
											Data)
								VALUES(
											@iCodigoEstabelecimento,
											@cBit041,
											@cStatus_TransacoesStatusTEF,
											GETDATE())
							END

							IF (@iRedeNumero = 13 AND @bMultiBandeira = 1)
								SET @cBit060 = @cNomeEstab + '@' + @cEnderecoEstab + '@' + @cCidadeEstab + ' - ' + @cEstadoEstab + '@' + @cCNPJ + '@'
							
							IF (@iRedeNumero NOT IN (13,22,23,24,25,58) AND @cProvedor <> 'SCOPEPRIVATE') /*Pos Policard, Pos Master e Pos Walk nao utilizam chave de trabalho*/
							BEGIN


								IF (@cProvedor = 'SOFTWARE EXPRESS' AND @cBit061 <> '')
								BEGIN
								
									DECLARE 
										 @iRandomDES	INT
										,@iRandom3DES	INT
										,@iUpperDES		INT
										,@iUpper3DES	INT
										,@iLowerDES		INT
										,@iLower3DES	INT
										,@cTAG			CHAR(3)
										,@cLENGHT		CHAR(3)
										,@cLenghtKeyDES CHAR(3)
										,@cLenghtKey3DES CHAR(3)
										,@sVALUE		VARCHAR(100)
										,@sChaveDES		VARCHAR(16)
										,@sChave3DES	VARCHAR(32)
										
									SET @cTAG	= SUBSTRING(@cBit061,1,3)
									SET @cLENGHT= SUBSTRING(@cBit061,4,3)
									SET @sVALUE = SUBSTRING(@cBit061,7, CONVERT(INT,@cLENGHT))
									SET @sVALUE = SUBSTRING(@sVALUE,7,5) + SUBSTRING(@sVALUE,1,6)

									SET @cBit061 = @cTAG + @cLENGHT + @sVALUE

									SET @iLowerDES = 1 -- Primeira chave DES da Tabela
									SET @iUpperDES = 6 -- Ultima chave DES da Tabela - 1

									SET @iLower3DES = 6 -- Primeira chave 3DES da Tabela
									SET @iUpper3DES = 11 --Ultima chave 3DES da Tabela - 1
									
									SELECT @iRandomDES = ROUND(((@iUpperDES - @iLowerDES -1) * RAND() + @iLowerDES), 0)
									SELECT @iRandom3DES = ROUND(((@iUpper3DES - @iLower3DES -1) * RAND() + @iLower3DES), 0)

									/* Coletando chaves DES */
									SELECT @cLenghtKeyDES = LenChave,  @sChaveDES = ValueChave, @cTAG = '002' FROM Aut_Chaves_SE_TMK WITH(NOLOCK) WHERE IdChave = @iRandomDES
									
									SET @cBit061 = @cBit061 + @cTAG + @cLenghtKeyDES + @sChaveDES

									/* Coletando chaves 3DES */
									SELECT @cLenghtKey3DES = LenChave,  @sChave3DES = ValueChave, @cTAG = '003' FROM Aut_Chaves_SE_TMK WITH(NOLOCK) WHERE IdChave = @iRandom3DES

									SET @cBit061 = @cBit061 + @cTAG + @cLenghtKey3DES + @sChave3DES
									
									INSERT INTO ChaveAberturaTEF(
										 Estabelecimento
										,ChaveTrabalho
										,DataCriacaoChave
										,Provedor
										,IDX_DES
										,IDX_3DES														
									)VALUES(
										 @iCodigoEstabelecimento
										,@cBit052
										,GETDATE()
										,@cProvedor
										,@iRandomDES
										,@iRandom3DES
									)

								END
								ELSE
								BEGIN


									/*Caso nao tenha as ultimas 20 chaves, serão inseridas as chaves da base autorizacao*/
									IF (SELECT COUNT (ChaveAberturaTefCodigo) FROM ChaveAberturaTEF WITH (NOLOCK) 
										WHERE Estabelecimento = @iCodigoEstabelecimento
										AND Provedor = @cProvedor
										AND LEN (ChaveTrabalho) = 16) < 20

									BEGIN

										DECLARE  @cChaveTrabalho CHAR(16)
												,@dDataCriacaoChave DATETIME
											
										DECLARE @VTable TABLE (Chave VARCHAR(16), DataCriacaoChave DATETIME, Estabelecimento INT, Provedor VARCHAR(30), Processado BIT)
									
										INSERT INTO @VTable
										SELECT	TOP 20 ChaveTrabalho,DataCriacaoChave,Estabelecimento,Provedor,  0
										FROM	Autorizacao.dbo.ChaveAberturaTEF WITH(NOLOCK)
										WHERE	Estabelecimento = @iCodigoEstabelecimento
										AND Provedor = @cProvedor
										AND LEN (ChaveTrabalho) = 16
										ORDER BY ChaveAberturaTefCodigo DESC
									
										WHILE EXISTS (SELECT * FROM @VTable WHERE Processado = 0)
										BEGIN

											SET @cChaveTrabalho = ''
											SET @dDataCriacaoChave = ''

											SELECT TOP 1 @cChaveTrabalho = Chave, @dDataCriacaoChave = DataCriacaoChave FROM @VTable WHERE Processado = 0 ORDER BY DataCriacaoChave ASC

											INSERT INTO ChaveAberturaTEF (Estabelecimento,ChaveTrabalho,DataCriacaoChave,Provedor)
											(
											SELECT TOP 1 Estabelecimento,  Chave, DataCriacaoChave, Provedor FROM @VTable WHERE Processado = 0 AND DataCriacaoChave = @dDataCriacaoChave
											)

											UPDATE @VTable SET Processado = 1 WHERE Chave = @cChaveTrabalho AND DataCriacaoChave = @dDataCriacaoChave
										
										END
									END								 

									INSERT INTO ChaveAberturaTEF(
										 Estabelecimento
										,ChaveTrabalho
										,DataCriacaoChave
										,Provedor)
									VALUES
										(@iCodigoEstabelecimento
										,@cBit052
										,GETDATE()
										,@cProvedor)
								END
							END
						END
						ELSE 
							SET @iResposta = 320 /* ESTABELECIMENTO CANCELADO OU BLOQUEADO */
					END
					ELSE 
						SET @iResposta = 321 /* ESTABELECIMENTO INEXISTENTE */
				END
				ELSE 
					SET @iResposta = 322 /* MEIO DE CAPTURA CANCELADO OU BLOQUEADO */
			END
			ELSE 
				SET @iResposta = 323 /* MEIO DE CAPTURA INEXISTENTE */
		END
		ELSE 
			SET @iResposta = 338
	END
	ELSE 
		SET @iResposta = 337

	IF (@iResposta = 0 AND (@iRedeNumero IN (13,14) AND @cBit047 <> ''))
	BEGIN

		DECLARE  @cAtualizaVersao	CHAR(1)
				,@cVersaoProducao	CHAR(6)
				,@cDataTelecarga	DATETIME
				,@cNomeAplicacao	VARCHAR(20)
				,@VersaoFramework   VARCHAR(20)
				,@VersaoPOS           VARCHAR(50)
		
		/*Atualizando data e hora do terminal*/
		SELECT @cBit012 = REPLACE(CONVERT (VARCHAR(8),GETDATE(),108),':','')
			  ,@cBit013 = REPLACE(CONVERT (VARCHAR(5),GETDATE(),110),'-','')
			
		--CAPTURANDO DADOS DO MEIO DE CAPTURA
		SELECT @cAtualizaVersao = FL_Atualiza_Versao 
			 , @VersaoFramework = COALESCE(VersaoFramework,0)
		  FROM Processadora.dbo.MeiosCaptura WITH (NOLOCK) 
		WHERE Numero = @cBit041

		IF (@cAtualizaVersao = 'T')
		BEGIN

			IF EXISTS (SELECT 1 FROM Processadora.dbo.VersaoAplicacaoMeiosCaptura AS VAMC WITH (NOLOCK) 
				 INNER JOIN Processadora.dbo.ModeloPOS AS MP WITH (NOLOCK) ON VAMC.Id_ModeloPOS = MP.Id_ModeloPOS 
				 INNER JOIN Processadora.dbo.PacoteAtualizacaoVersao AS PAV WITH (NOLOCK) ON VAMC.ID_VersaoAplicacao = PAV.ID_VersaoAplicacao 
				 INNER JOIN Processadora.dbo.EstabelecimentoAtualizacaoVersaoAplicacao AS EAVA WITH (NOLOCK) ON PAV.ID_PacoteVersaoAplicacao = EAVA.ID_PacoteVersaoAplicacao 
				 WHERE EAVA.Status = 1 AND EAVA.NumeroTerminal = @cBit041)
			
			BEGIN

				SET @VersaoPOS = SUBSTRING( @cBit047, CHARINDEX('|',@cBit047), LEN(@cBit047) ) 
				SET @VersaoPOS = SUBSTRING(@VersaoPOS, (CHARINDEX('|',@VersaoPOS)+1), LEN(@VersaoPOS)) 
				SET @VersaoPOS = SUBSTRING(@VersaoPOS, (CHARINDEX('|',@VersaoPOS)+1), LEN(@VersaoPOS)) 
				SET @VersaoPOS = SUBSTRING(SUBSTRING(@VersaoPOS, (CHARINDEX('|',@VersaoPOS)+1), LEN(@VersaoPOS)),1,6)

				SELECT @cVersaoProducao = VAMC.CodigoVersao
					  ,@cNomeAplicacao = VAMC.Nome
					  ,@cDataTelecarga = COALESCE (EAVA.DataTelecarga, GETDATE())
				FROM Processadora.dbo.VersaoAplicacaoMeiosCaptura AS VAMC WITH (NOLOCK) 
				INNER JOIN Processadora.dbo.ModeloPOS AS MP WITH (NOLOCK) ON VAMC.Id_ModeloPOS = MP.Id_ModeloPOS 
				INNER JOIN Processadora.dbo.PacoteAtualizacaoVersao AS PAV WITH (NOLOCK) ON VAMC.ID_VersaoAplicacao = PAV.ID_VersaoAplicacao 
				INNER JOIN Processadora.dbo.EstabelecimentoAtualizacaoVersaoAplicacao AS EAVA WITH (NOLOCK) ON PAV.ID_PacoteVersaoAplicacao = EAVA.ID_PacoteVersaoAplicacao 
				WHERE EAVA.Status = 1 
				AND EAVA.NumeroTerminal = @cBit041

				IF CONVERT(INT, @cVersaoProducao) <> CONVERT(INT, @VersaoPOS)
					SET @cBit062 = @cVersaoProducao  + '|' + @cNomeAplicacao + '|' + SUBSTRING(CONVERT (VARCHAR(10),@cDataTelecarga,112),3,8) + REPLACE(CONVERT (VARCHAR(10),@cDataTelecarga,108),':','')
				ELSE
				BEGIN

					/* ATUALIZA CODIGO DA VERSAO NO BANCO, CASO JA TENHA ATUALIZADO */
					UPDATE Processadora.dbo.MeiosCaptura
					SET FL_Atualiza_Versao = 'F'
					, VersaoFramework = @cVersaoProducao
					WHERE Numero = @cBit041

					UPDATE Processadora.dbo.EstabelecimentoAtualizacaoVersaoAplicacao 
					SET Status = 0
					WHERE NumeroTerminal = @cBit041
					AND Status = 1

					SET @cBit062 = 'APROVADO'

				END

			END
			ELSE
			BEGIN

				UPDATE processadora.dbo.MeiosCaptura
				SET FL_Atualiza_Versao = 'F'
				WHERE Numero = @cBit041

				SET @cBit062 = 'APROVADO'

			END
		END

		SET @cBit047 = ''

	END
				
END
