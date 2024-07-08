
/* 
--------------------------------------------------------------------------
Nome Sistema: Autorização
Objeto: [dbo].[pr_aut_RealizaCargaTabela_Safra]
Propósito: Carga de tabela cartao EMV
Autor: João Henrique - Tecnologia Policard
--------------------------------------------------------------------------
Data criação: 24/09/2019
Chamado/Mudança: Inclusão Safrapay tabela FULL
--------------------------------------------------------------------------
Data: 27/04/2022
Autor: João Henrique - Up Brasil
Chamado: 1848228 
Descrição: Adequação na carga de tabela devido à inclusão de novas faixas
	de BIN's.
-------------------------------------------------------------------------- 		
Data: 08/09/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1843805
Descrição: Projeto ABECS para transações NCR/Scope.
-------------------------------------------------------------------------- 	
Data: 18/04/2023
Autor: Adilson Pereira - Up Brasil
Chamado: 1993183
Descrição: Alteradas consultas para considerar apenas combustíveis e serviços
	ativos na tabela.
-------------------------------------------------------------------------- 		
*/

CREATE PROCEDURE [dbo].[pr_aut_RealizaCargaTabela_Safra](
		 @cBit003					CHAR(6)			OUTPUT
		,@cBit041					CHAR(8)
		,@iCodigoEstabelecimento	INT
		,@bEstabMigrado				CHAR(1)
		,@cBit059					VARCHAR(999)	OUTPUT  /* Bit utilizano no retorno de carga de tabelas*/
		,@cBit060					VARCHAR(999)	OUTPUT  /* Bit utilizano no retorno de carga de tabelas*/
		,@cBit080					CHAR(10)		OUTPUT	/* BIT080 - Versao da Tabela */
		,@cBit081					CHAR(10)		OUTPUT	/* BIT081 - Controle de tabelas enviadas */
		,@iResposta					INT				OUTPUT	/* Codigo de Resposta Interno */
		)
AS
SET NOCOUNT ON
BEGIN
	
	DECLARE
		 @cAuxTabela			CHAR(10)
		,@iEstabelecimento		INT 
		,@cNome_Estabelecimento	CHAR(40)
		,@bPermiteDigitado		BIT
		,@bPermiteSemSenha		BIT
		,@bCargaTabelaFull		BIT

	SET @iResposta = 0

	IF (@bEstabMigrado = 0)
	BEGIN
		SELECT	
			 @cNome_Estabelecimento = LTRIM(RTRIM (SUBSTRING(Nome, 1,40)))
			,@bPermiteDigitado = ISNULL(PermiteTransacaoDigitada,0)
			,@bPermiteSemSenha = ISNULL(PermiteTransacaoSemSenha,0)
			,@bCargaTabelaFull = ISNULL(CargaTabelaFull,0)
		FROM Processadora.dbo.Estabelecimentos WITH (NOLOCK)
		WHERE Numero = @iCodigoEstabelecimento
	END
	ELSE IF (@bEstabMigrado = 1)
	BEGIN
		SELECT	
			 @cNome_Estabelecimento = LTRIM(RTRIM (SUBSTRING(Nome, 1,40)))
			,@bPermiteDigitado = ECA.TransacaoDigitada
			,@bPermiteSemSenha = ECA.TransacaoSemSenha
		FROM Acquirer.dbo.Estabelecimento E WITH (NOLOCK)
		INNER JOIN Acquirer.dbo.EstabelecimentoConfiguracoesAdicionais ECA WITH (NOLOCK) ON E.CodigoEstabelecimento = ECA.CodigoEstabelecimento
		WHERE E.CodigoEstabelecimento = @iCodigoEstabelecimento

	END
	
	IF EXISTS (select 1 from acquirer..EstabelecimentoSafra (nolock) where CodigoEstabelecimento = @iCodigoEstabelecimento and Habilitado = 1) /*Safrapay deve fazer a atualização da carga de tabelas completa*/
		SET @bCargaTabelaFull = 1

	SET @cAuxTabela = @cBit081
	
	/*
	Trava: CodigoEstabelecimentoInvalido
	Descricao: Código do estabelecimento inválido ou não informado
	Código: --
	*/
	IF (@iCodigoEstabelecimento IS NOT NULL AND @iCodigoEstabelecimento <> '')
	BEGIN
	
		/*Inicio de carga de tabelas EMV*/
		IF (@cBit003 = '008010')
		BEGIN
				
			DECLARE  @CodProduto		CHAR(3)
					,@cNomeProduto		CHAR(20)
					,@cTipoProduto		CHAR(2)
					,@cDadosEMVProduto	CHAR(6)
					,@cCodigoAid		CHAR(3)
					,@cBinINI			CHAR(10)
					,@cBinFIM			CHAR(10)
					,@cAux				VARCHAR(999)
					,@iAux				INT
				
			SET @cAux = ''
			SET @iAux = 0
			SET @cBit059 = ''
			SET @cBit060 = ''
				
			--IF (@cAuxTabela = '' OR @cAuxTabela = '0000000000')
			IF (@cAuxTabela = '')
			BEGIN

				SET @cNome_Estabelecimento = dbo.f_FormatarTexto(@cNome_Estabelecimento)
					
				/*Tabela de Produtos (Tipo 001)*/ 
				SET @cBit059 = '001' + @cNome_Estabelecimento + REPLICATE('',40 - LEN (@cNome_Estabelecimento)) + '986' + '0' + '076' + '1234' /* Tabela de parametros do Estabelecimento */
					
				/*Tabela de Produtos (Tipo 002)*/
				DECLARE @VTableProd TABLE (Codigo CHAR(3),NomeProduto CHAR(20),TipoProduto CHAR(2),DadosEMVProduto CHAR(6), CodigoAid CHAR(3))

				IF (@bCargaTabelaFull = 0)
				BEGIN

					INSERT INTO @VTableProd
					SELECT 
						 dbo.f_ZerosEsquerda(Codigo,3) AS Codigo
						,NomeProduto
						,TipoProduto
						,DadosEMVProduto
						,CASE WHEN CodigoAid = '006' THEN '001' ELSE CodigoAid END AS CodigoAid
					FROM EMV_Produtos WITH (NOLOCK) 
					WHERE Ativo = 1
					AND Codigo not in (21,22,23,24)
					--AND ProdutoMigrado = 0
					ORDER BY Codigo ASC

				END
				ELSE
				BEGIN

					INSERT INTO @VTableProd
					SELECT 
						 dbo.f_ZerosEsquerda(Codigo,3) AS Codigo
						,NomeProduto
						,TipoProduto
						,DadosEMVProduto
						,CASE WHEN CodigoAid = '006' THEN '001' ELSE CodigoAid END AS CodigoAid
					FROM EMV_Produtos WITH (NOLOCK)
					WHERE 
					Ativo = 1
					AND Codigo not in (21,22,23,24)
					ORDER BY Codigo ASC

				END

					
				WHILE EXISTS (SELECT * FROM @VTableProd)
				BEGIN

					SELECT TOP 1 @CodProduto = Codigo, @cNomeProduto = NomeProduto, @cTipoProduto = TipoProduto, @cDadosEMVProduto = DadosEMVProduto, @cCodigoAid = CodigoAid FROM @VTableProd
					
					IF (@CodProduto = '001' AND @bPermiteDigitado = 1 AND @bPermiteSemSenha = 1)
						SET @cDadosEMVProduto = 'FCC000' /* Permite Digitado e sem senha*/
					
					SET @cAux = '|002' + @CodProduto + @cNomeProduto + @cTipoProduto + @cDadosEMVProduto + @cCodigoAid
						
					IF (LEN(@cBit059) + LEN(@cAux) < 1000)
						SET @cBit059 = @cBit059 + @cAux

					DELETE FROM @VTableProd WHERE Codigo = @CodProduto

				END

				DECLARE @VTableBin TABLE (CodProduto CHAR(3),BinINI CHAR(10),BinFIM CHAR(10))
				
				
				IF (@bCargaTabelaFull = 0)
				BEGIN

					INSERT INTO @VTableBin
					SELECT 
						 dbo.f_ZerosEsquerda(Codigo,3) AS CodProduto
						,BinINI
						,BinFIM
					FROM EMV_Produtos WITH (NOLOCK) 
					WHERE Ativo = 1
					AND Codigo not in (21,22,23,24)
					--AND ProdutoMigrado = 0
					ORDER BY Codigo ASC
				
				END
				ELSE
				BEGIN

					INSERT INTO @VTableBin
					SELECT 
						 dbo.f_ZerosEsquerda(Codigo,3) AS CodProduto
						,BinINI
						,BinFIM
					FROM EMV_Produtos WITH (NOLOCK)
					WHERE 
					Ativo = 1
					AND Codigo not in (21,22,23,24)
					ORDER BY Codigo ASC

				END

					

				WHILE EXISTS (SELECT * FROM @VTableBin)
				BEGIN
						
					SELECT TOP 1 @CodProduto = CodProduto, @cBinINI = BinINI, @cBinFIM = BinFIM FROM @VTableBin
						
					SET @iAux = @iAux + LEN(@cAux)	

					SET @cAux = '|003' + @CodProduto + @cBinINI + @cBinFIM
					
					IF (@iAux <= 999)
					BEGIN
						IF (@iAux + LEN(@cAux) <= 999)
							SET @cBit060 = @cBit060 + @cAux
					END

					DELETE FROM @VTableBin WHERE CodProduto = @CodProduto

				END
				SET @cBit081 = '0040000000'
			END
				
			/*Tabela de Range de BINs (Tipo 004)*/
			IF (SUBSTRING(@cAuxTabela,1,3) = '004')
			BEGIN
					
				DECLARE
					 @CodigoAid						CHAR (3)
					,@cLenAID						CHAR (2)
					,@cAID							VARCHAR(32)
					,@cTipoAplicacao				CHAR (2)
					,@cNomeAplicacao				CHAR (16)
					,@cAID_Version_1				VARCHAR (16)
					,@cAID_Version_2				VARCHAR (16)
					,@cAID_Version_3				VARCHAR (16)
					,@cTermCapabilities 			VARCHAR (24)
					,@cAddTermCapabilities			VARCHAR(40)
					,@cTerminalType					CHAR (2)
					,@cTAC_Default					VARCHAR (40)
					,@cTAC_Denial					VARCHAR (40)
					,@cTAC_Online					VARCHAR (40)
					,@cFloorLimit					VARCHAR (32)
					,@cTCC							CHAR (1)
					,@cTDOL							VARCHAR (160)
					,@cDDOL							VARCHAR (160)
					,@cAutRespCodeOfflineAppoved	CHAR (2)
					,@cAutRespCodeOfflineDenied		CHAR (2)
					,@cAutRespCodeUnableOfflineApproved CHAR (2)
					,@cAutRespCodeUnableOfflineDenied CHAR (2)
					,@cTargetPercentage				CHAR (2)
					,@cThresholdValue				CHAR(4)
					,@cMaxTargetPercentage			CHAR(2)
					,@iCodAux						INT

				DECLARE @VTableApp TABLE 
						(
						 CodigoAid							CHAR (3)
						,LenAID								CHAR (2)
						,AID								VARCHAR (32)
						,TipoAplicacao						CHAR (2)
						,NomeAplicacao						CHAR (16)
						,AID_Version_1						VARCHAR (16)
						,AID_Version_2						VARCHAR (16)
						,AID_Version_3						VARCHAR (16)
						,TermCapabilities					VARCHAR (24)
						,AddTermCapabilities				VARCHAR (40)
						,TerminalType						CHAR (2)
						,TAC_Default						VARCHAR (40)
						,TAC_Denial							VARCHAR (40)
						,TAC_Online							VARCHAR (40)
						,FloorLimit							VARCHAR (32)
						,TCC								CHAR (1)
						,TDOL								VARCHAR (160)
						,DDOL								VARCHAR (160)
						,AutRespCodeOfflineAppoved			CHAR (2)
						,AutRespCodeOfflineDenied			CHAR (2)
						,AutRespCodeUnableOfflineApproved	CHAR (2)
						,AutRespCodeUnableOfflineDenied		CHAR (2)
						,TargetPercentage					CHAR (2)
						,ThresholdValue						CHAR (4)
						,MaxTargetPercentage				CHAR (2)
						)
					
					
				SET @iCodAux = CONVERT(INT,SUBSTRING(@cAuxTabela,4,7)) + 1
					
				INSERT INTO @VTableApp
				SELECT 
						 
					CodigoAid
					,LenAID
					,AID + REPLICATE('0',32 - LEN (AID))
					,TipoAplicacao
					,NomeAplicacao
					,AID_Version_1
					,AID_Version_2
					,AID_Version_3
					,DBO.f_InteiroParaHexadecimal(DBO.f_BinarioParaDecimal(TermCapabilities))
					,DBO.f_InteiroParaHexadecimal(DBO.f_BinarioParaDecimal(AddTermCapabilities))
					,TerminalType
					,DBO.f_InteiroParaHexadecimal(DBO.f_BinarioParaDecimal(TAC_Default))
					,DBO.f_InteiroParaHexadecimal(DBO.f_BinarioParaDecimal(TAC_Denial))
					,DBO.f_InteiroParaHexadecimal(DBO.f_BinarioParaDecimal(TAC_Online))
					,FloorLimit
					,TCC
					,TDOL
					,DDOL
					,AutRespCodeOfflineAppoved
					,AutRespCodeOfflineDenied
					,AutRespCodeUnableOfflineApproved
					,AutRespCodeUnableOfflineDenied
					,TargetPercentage
					,ThresholdValue
					,MaxTargetPercentage
				FROM
					dbo.EMV_Aplicacoes WITH (NOLOCK)
				WHERE CodigoAid < '006'
				ORDER BY CodigoAid ASC

				WHILE EXISTS (SELECT * FROM @VTableApp)
				BEGIN
						
					SELECT TOP 1 				
								 							
							 @CodigoAid							= CodigoAid
							,@cLenAID							= LenAID
							,@cAID								= AID
							,@cTipoAplicacao					= TipoAplicacao
							,@cNomeAplicacao					= NomeAplicacao
							,@cAID_Version_1					= AID_Version_1
							,@cAID_Version_2					= AID_Version_2
							,@cAID_Version_3					= AID_Version_3
							,@cTermCapabilities					= TermCapabilities
							,@cAddTermCapabilities				= AddTermCapabilities
							,@cTerminalType						= TerminalType
							,@cTAC_Default						= TAC_Default
							,@cTAC_Denial						= TAC_Denial
							,@cTAC_Online						= TAC_Online
							,@cFloorLimit						= FloorLimit
							,@cTCC								= TCC
							,@cTDOL								= TDOL
							,@cDDOL								= DDOL
							,@cAutRespCodeOfflineAppoved		= AutRespCodeOfflineAppoved
							,@cAutRespCodeOfflineDenied			= AutRespCodeOfflineDenied
							,@cAutRespCodeUnableOfflineApproved	= AutRespCodeUnableOfflineApproved
							,@cAutRespCodeUnableOfflineDenied	= AutRespCodeUnableOfflineDenied
							,@cTargetPercentage					= TargetPercentage
							,@cThresholdValue					= ThresholdValue
							,@cMaxTargetPercentage				= MaxTargetPercentage
					FROM @VTableApp ORDER BY CodigoAid ASC
						
					SET @iAux = @iAux + LEN(@cAux)
					SET @cAux = '|004' + @CodigoAid + @cLenAID + @cAID + @cTipoAplicacao + @cNomeAplicacao + @cAID_Version_1 + @cAID_Version_2 + @cAID_Version_3
								+ @cTermCapabilities + @cAddTermCapabilities + @cTerminalType + @cTAC_Default + @cTAC_Denial + @cTAC_Online + @cFloorLimit + @cTCC
								+ @cTDOL + @cDDOL + @cAutRespCodeOfflineAppoved + @cAutRespCodeOfflineDenied + @cAutRespCodeUnableOfflineApproved 
								+ @cAutRespCodeUnableOfflineDenied + @cTargetPercentage + @cThresholdValue + @cMaxTargetPercentage
						
					IF (@iAux <= 999)
					BEGIN
						SET @cBit081 = '004' + dbo.f_ZerosEsquerda(@CodigoAid,7)
						IF (@iAux + LEN(@cAux) <= 999)
							SET @cBit059 = @cBit059 + @cAux
						ELSE
							SET @cBit060 = @cBit060 + @cAux
					END
					ELSE IF (LEN(@cBit060) + LEN(@cAux) <= 999)
					BEGIN
						SET @cBit060 = @cBit060 + @cAux
						SET @cBit081 = '004' + dbo.f_ZerosEsquerda(@CodigoAid,7)
					END

					DELETE FROM @VTableApp WHERE CodigoAid = @CodigoAid

				END
					
				IF @cBit081 = '0040000005' 
					SET @cBit081 = '0050000000'

			END
				
			/*Tabela de Range de Chaves Publicas (Tipo 005)*/
			IF (SUBSTRING(@cAuxTabela,1,3) = '005')
			BEGIN
					
				DECLARE
					 @cRID					VARCHAR (10)
					,@cCA_PubKeyIndex		VARCHAR (8)
					,@cCA_PubKeyExpLen		CHAR 	(1)
					,@cCA_PubKeyExp			VARCHAR (24)
					,@cCA_PublicKeyLen		CHAR	(3)
					,@cCA_PublicKey			VARCHAR (496)
					,@cChecksumStatus		CHAR	(1)
					,@cCA_PubKeyChecksum	VARCHAR (48)
					,@cIndiceMasterKey		CHAR	(2)
					,@cWorkingKey			VARCHAR (32)
					,@iQtdeChaves			INT
					,@iCodigo				INT
					
				DECLARE @VTableKey TABLE (Codigo INT, RID VARCHAR (40),CA_PubKeyIndex VARCHAR (8),CA_PubKeyExpLen CHAR(1),CA_PubKeyExp VARCHAR (24),CA_PublicKeyLen CHAR(3)
										,CA_PublicKey VARCHAR (496),ChecksumStatus CHAR(1),CA_PubKeyChecksum VARCHAR(48),IndiceMasterKey CHAR(2),WorkingKey VARCHAR(32))
					
				IF (CONVERT(INT,SUBSTRING(@cAuxTabela,4,7)) = 0)
					SET @iCodAux = 0
				ELSE
					SET @iCodAux = CONVERT(INT,SUBSTRING(@cAuxTabela,4,7)) --+ 1
						
				SELECT @iQtdeChaves = COUNT (Codigo) FROM EMV_KeyPublic WITH (NOLOCK)
					
				INSERT INTO @VTableKey
				SELECT 
					 Codigo
					,RID
					,CA_PubKeyIndex
					,CA_PubKeyExpLen
					,CA_PubKeyExp
					,CA_PublicKeyLen
					,CA_PublicKey
					,ChecksumStatus
					,CA_PubKeyChecksum
					,IndiceMasterKey
					,WorkingKey
				FROM dbo.EMV_KeyPublic WITH (NOLOCK)
				WHERE Codigo > @iCodAux
				ORDER BY CA_PubKeyIndex DESC
					
				WHILE EXISTS (SELECT * FROM @VTableKey)
				BEGIN
					
					SELECT 
						 @iCodigo				= Codigo
						,@cRID					= RID
						,@cCA_PubKeyIndex		= CA_PubKeyIndex
						,@cCA_PubKeyExpLen		= CA_PubKeyExpLen
						,@cCA_PubKeyExp			= CA_PubKeyExp
						,@cCA_PublicKeyLen		= CA_PublicKeyLen
						,@cCA_PublicKey			= CA_PublicKey
						,@cChecksumStatus		= ChecksumStatus
						,@cCA_PubKeyChecksum	= CA_PubKeyChecksum
						,@cIndiceMasterKey		= IndiceMasterKey
						,@cWorkingKey			= WorkingKey
					FROM @VTableKey ORDER BY CA_PubKeyIndex DESC
						
					SET @iAux = @iAux + LEN(@cAux)
					SET @cAux = '|005' + @cRID + @cCA_PubKeyIndex + @cCA_PubKeyExpLen + @cCA_PubKeyExp + @cCA_PublicKeyLen + @cCA_PublicKey + @cChecksumStatus + @cCA_PubKeyChecksum
								+ @cIndiceMasterKey + @cWorkingKey
						
					IF (@iAux <= 999)
					BEGIN
						SET @cBit081 = '005' + dbo.f_ZerosEsquerda(@iCodigo,7)
						IF (@iAux + LEN(@cAux) <= 999)
							SET @cBit059 = @cBit059 + @cAux
						ELSE
							SET @cBit060 = @cBit060 + @cAux
							
								
					END
					ELSE IF (LEN(@cBit060) + LEN(@cAux) <= 999)
					BEGIN
						SET @cBit060 = @cBit060 + @cAux
						SET @cBit081 = '005' + dbo.f_ZerosEsquerda(@iCodigo,7)
					END

					DELETE FROM @VTableKey WHERE Codigo = @iCodigo
						
				END
					
				IF @cBit081 = '005000000' + CONVERT (VARCHAR,@iQtdeChaves)-- '0040000011'
					SET @cBit081 = '0060000000'
					
			END
				
			IF (SUBSTRING(@cAuxTabela,1,3) = '006')
			BEGIN
				
				DECLARE 
						@cTipoItem CHAR(2)
					,@cIdItem	CHAR(2)
					,@cDescricaoItem CHAR(40)
					
				DECLARE @VTableFrota TABLE (TipoItem CHAR(2), IdItem CHAR(2), DescricaoItem CHAR(40))
					
				INSERT INTO @VTableFrota
				/*Abastecimento*/
				SELECT 
					'01'
					,dbo.f_ZerosEsquerda(Codigo,2)
					,UPPER(Nome)
					FROM   Policard_603078.dbo.SGF_TipoCombustivel WITH(NOLOCK)
					WHERE StsAtivo = 1
				UNION ALL
				/*Serviços*/
				SELECT 
					'02'
					,dbo.f_ZerosEsquerda(Codigo,2)
					,UPPER(Nome)
					FROM   Policard_603078.dbo.SGF_ItensManutencao WITH(NOLOCK)
					WHERE StsAtivo = 1
						AND Codigo <> 19					
				UNION ALL
				/*Manutenção*/
				SELECT 
					'03'
					,'00'
					,'MANUTENCAO'
					
				WHILE EXISTS (SELECT * FROM @VTableFrota)
				BEGIN
					SELECT 
						 @cTipoItem = TipoItem
						,@cIdItem	= IdItem
						,@cDescricaoItem = DescricaoItem
					FROM @VTableFrota 
					ORDER BY TipoItem DESC, IdItem DESC
						
					SET @iAux = @iAux + LEN(@cAux)
					IF (LEN (@cBit060) = 0) AND (LEN(@cAux) = 0)
						SET @cAux = '|006' + @cTipoItem + @cIdItem + @cDescricaoItem + REPLICATE('',40 - LEN (@cDescricaoItem)) + '|'
					ELSE
						SET @cAux = '006' + @cTipoItem + @cIdItem + @cDescricaoItem + REPLICATE('',40 - LEN (@cDescricaoItem)) + '|'
						
					IF (@iAux <= 999)
					BEGIN
						IF (@iAux + LEN(@cAux) <= 999)
							SET @cBit059 = @cBit059 + @cAux
						ELSE
							SET @cBit060 = @cBit060 + @cAux

					END
					ELSE IF (LEN(@cBit060) + LEN(@cAux) <= 999)
						SET @cBit060 = @cBit060 + @cAux

					DELETE FROM @VTableFrota WHERE TipoItem = @cTipoItem AND IdItem = @cIdItem
					
				END
					
				SET @cBit059 = SUBSTRING(@cBit059,1,LEN(@cBit059)-1)
				SET @cBit060 = '|' + SUBSTRING(@cBit060,1,LEN(@cBit060)-1)
				SELECT @cBit080 = Versao FROM dbo.VersaoCargaTabela WITH (NOLOCK) WHERE Ativo = 1 ORDER BY Codigo
				SET @cBit081 = ''

			END
		END
	END
	ELSE 
	SET @iResposta = 337

	IF @iResposta <> 0
		SET @cBit081 = ''
	
END




