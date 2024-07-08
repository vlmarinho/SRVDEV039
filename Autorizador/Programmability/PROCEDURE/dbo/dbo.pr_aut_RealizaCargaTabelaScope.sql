/* --
--------------------------------------------------------------------------
Nome Sistema: Autorização
Objeto: [dbo].[pr_aut_RealizaCargaTabelaScope]
Propósito: Carga de tabela cartao EMV provedor Scope
Autor: Cristiano Silva Barbosa - Tecnologia Policard
--------------------------------------------------------------------------
Data criação: 19/02/2017
Mudança: 2601
Autor: Cristiano Silva
--------------------------------------------------------------------------
Data: 13/04/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1843805
Descrição: Projeto ABECS para transações NCR/Scope.
-------------------------------------------------------------------------- 	
Data: 08/09/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1843805
Descrição: Projeto ABECS para transações NCR/Scope.
-------------------------------------------------------------------------- 	
*/



CREATE PROCEDURE [dbo].[pr_aut_RealizaCargaTabelaScope](
		 @iCodigoEstabelecimento	INT
		,@bEstabMigrado				BIT
		,@cBit123					VARCHAR(1000)		
		,@cBit042					VARCHAR(15)		OUTPUT
		,@cBit063					VARCHAR(1000)	OUTPUT
		,@cBit120					VARCHAR(1000)	OUTPUT
		,@cBit121					VARCHAR(1000)	OUTPUT
		,@cBit122					VARCHAR(1000)	OUTPUT
		,@iResposta					INT				OUTPUT	/* Codigo de Resposta Interno */
		)
AS
SET NOCOUNT ON
BEGIN
	
	DECLARE
		 @iAux				INT
		,@iCount			INT
		,@cHeader			VARCHAR(6)
		,@cAuxTabela		CHAR(13)
		,@cAux				VARCHAR(999)
		,@cVersaoCargaTbl	VARCHAR(10)
		,@cIdBandeira		CHAR(3)
		,@cTipoBandeira		CHAR(2)
		
	SELECT @cVersaoCargaTbl = Versao FROM dbo.VersaoCargaTabela WITH (NOLOCK) WHERE Ativo = 1 ORDER BY Codigo
	
	SET @cBit120 = ''
	SET @cBit121 = ''
	SET @cBit122 = ''
	SET @iResposta = 0
	--SET @cAuxTabela = ''
	SET @cAuxTabela = @cBit063


	IF (RIGHT(@cAuxTabela,3) = '001')
	BEGIN

		DECLARE  @CodProduto					CHAR(3)
				,@cNomeProduto					CHAR(20)
				,@cTipoProduto					CHAR(2)
				,@cDadosEMVProduto				CHAR(6)
				,@cCodigoAid					CHAR(3)
				,@CodigoAid						CHAR (3)
				,@cLenAID						CHAR (2)
				,@cAID							VARCHAR(32)
				,@cTipoAplicacao				CHAR (2)
				,@cNomeAplicacao				CHAR (16)
				,@cAID_Version_1				VARCHAR (16)
				,@cAID_Version_2				VARCHAR (16)
				,@cAID_Version_3				VARCHAR (16)
				,@cTermCapabilities 			VARCHAR (24)
				,@cAddTermCapabilities			VARCHAR (40)
				,@cTerminalId					VARCHAR (8)
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
				--,@iCodAux						INT
				,@iQtdeAplicacoes				INT
				,@1StGenerateAC					CHAR(99)
				,@2NdGenerateAC					CHAR(99)
				,@cNome_Estab					CHAR(23)
				,@cEndereo_Estab1				CHAR(23)
				,@cEndereo_Estab2				CHAR(23)
				,@cCNPJ							CHAR(14)
				,@cAuxCnpj						VARCHAR(20)
		
		IF (@bEstabMigrado = 0)
		BEGIN

			SELECT
				 @cNome_Estab		= SUBSTRING(Nome, 1,40)
				,@cEndereo_Estab1	= SUBSTRING(Endereco,1,23)
				,@cEndereo_Estab2	= SUBSTRING(Endereco,24,23)
				,@cAuxCnpj			= COALESCE(CNPJ, '11.111.111/1111-11')/*Envio obrigatorio de um CNPJ*/
			FROM	Processadora.dbo.Estabelecimentos WITH (NOLOCK)
			WHERE	Numero = @iCodigoEstabelecimento

		END
		ELSE
		BEGIN
			
			SELECT	
				 @cNome_Estab = LTRIM(RTRIM(SUBSTRING(E.Nome, 1,40)))
				,@cEndereo_Estab1	= SUBSTRING(EE.Logradouro,1,23)
				,@cEndereo_Estab2	= SUBSTRING(EE.Logradouro,24,23)
				,@cAuxCnpj = COALESCE(Cnpj,'11111111111111')
			FROM Acquirer.dbo.Estabelecimento E WITH (NOLOCK)
			INNER JOIN Acquirer.dbo.EstabelecimentoEndereco EE WITH (NOLOCK) ON E.CodigoEstabelecimento = EE.CodigoEstabelecimento
			WHERE E.CodigoEstabelecimento = @iCodigoEstabelecimento
			
		END
				
		SET @cCNPJ	= REPLACE(REPLACE(REPLACE(@cAuxCnpj,'.',''),'/',''),'-','')
		SET @cAux	= ''
		SET @iAux	= 0
		SET @iCount = 0
		SET @cHeader = '01' /*Estabelecimento*/
			
		
		/*Tabela de Estabelecimento (Tipo 01)*/ 
		SET @cNome_Estab = dbo.f_FormatarTexto(@cNome_Estab)
		SET @cBit120 = @cHeader + @cNome_Estab + @cEndereo_Estab1 + @cEndereo_Estab2 + @cCNPJ + '076' + '986' + '0'  + @cBit042 + '0000' + '1' + '00' /* Tabela de parametros do Estabelecimento */
		SET @cBit120 = @cBit120 + REPLICATE('0',32)
	
		SET @1StGenerateAC = '9F029F039F1A955F2A9A9C9F379F359F349F269F109F36825F345A9F279F33'
		SET @2NdGenerateAC = '918A959F379F269F109F36825F345A9F279F33'

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
				,TerminalId							VARCHAR (8)
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
				,IdBandeira							CHAR (3)
				,TipoBandeira						CHAR (2)
				)
		SET @cTerminalId = '00000001'
		--SET @cTermCapabilities = 'E06800'
		--SET @cAddTermCapabilities = '7000F0A001'
		--SET @iCodAux = CONVERT(INT,SUBSTRING(@cAuxTabela,4,7)) + 1

		SET @cHeader = '02'/*AID*/
		SELECT @iQtdeAplicacoes = COUNT (CodigoAid) FROM EMV_Aplicacoes WITH (NOLOCK)
		
		INSERT INTO @VTableApp
		SELECT 
			
			 CodigoAid
			,LEN (AID) AS LenAID
			,AID + REPLICATE('0',32 - LEN (AID))
			,TipoAplicacao
			,NomeAplicacao
			,AID_Version_1
			,AID_Version_2
			,AID_Version_3
			,DBO.f_InteiroParaHexadecimal(DBO.f_BinarioParaDecimal(TermCapabilities))
			,DBO.f_InteiroParaHexadecimal(DBO.f_BinarioParaDecimal(AddTermCapabilities))
			,@cTerminalId
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
			,B.IdBandeira
			,B.TipoBandeira
		FROM
			dbo.EMV_Aplicacoes A WITH (NOLOCK)
		INNER JOIN dbo.Emv_Bandeiras B WITH (NOLOCK) ON A.IdBandeira = B.IdBandeira
		ORDER BY A.CodigoAid ASC

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
				,@cTerminalId						= TerminalId
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
				,@cIdBandeira						= IdBandeira
				,@cTipoBandeira						= TipoBandeira
			FROM @VTableApp ORDER BY CodigoAid ASC

			SET @iAux = @iAux + LEN(@cAux)

			SET @cAux = RIGHT(@CodigoAid,2) + @cIdBandeira + @cLenAID + @cAID + @cTipoAplicacao + @cNomeAplicacao + '03' + @cAID_Version_1 + @cAID_Version_2 + @cAID_Version_3
						+ @cTerminalId + @cTermCapabilities + @cAddTermCapabilities + @cTerminalType + @cTAC_Default + @cTAC_Denial + @cTAC_Online + @cFloorLimit + @cTCC
						+ @cTDOL + @cDDOL + @1StGenerateAC + @2NdGenerateAC

			
			IF (@iAux <= 999)
			BEGIN

				IF (@iAux + LEN(@cAux) <= 999)
				BEGIN
					
					IF (@iCount = 0)
						SET @cBit121 = @cHeader + '02'
					
					SET @cBit121 = @cBit121 + @cAux
					SET @iCount = @iCount + 1
					
				END
				ELSE
				BEGIN
					SET @cBit122 = @cHeader + '02'
					SET @cBit122 = @cBit122 + @cAux
				END
			END
			ELSE IF (LEN(@cBit122) + LEN(@cAux) <= 999)
				SET @cBit122 = @cBit122 + @cAux

			DELETE FROM @VTableApp WHERE CodigoAid = @CodigoAid
			
		END
		
		SET @cBit063 = @cVersaoCargaTbl + '001C'
			
	END
	
	IF (RIGHT(@cAuxTabela,3) = '002')
	BEGIN
			
		DECLARE
			 @cRID					VARCHAR (10)
			,@cCA_PubKeyIndex		VARCHAR (8)
			,@cCA_PubKeyExpLen		CHAR 	(1)
			,@cCA_PubKeyExp			VARCHAR (24)
			,@cCA_PublicKeyLen		CHAR	(3)
			,@cCA_PublicKey			VARCHAR (496)
			,@cChecksumStatus		CHAR	(1)
			,@cCA_PubKeyChecksum	VARCHAR (40)
			,@iQtdeChaves			INT
			,@iCodigo				INT
		
		SET @cAux = ''
		SET @iAux = 0
		SET @iCount = 0
		SET @cHeader = '030101'/*CAPK*/
		
		DECLARE @VTableKey TABLE (Codigo INT, RID VARCHAR (40),CA_PubKeyIndex VARCHAR (8),CA_PubKeyExpLen CHAR(1),CA_PubKeyExp VARCHAR (24),CA_PublicKeyLen CHAR(3)
								,CA_PublicKey VARCHAR (496),ChecksumStatus CHAR(1),CA_PubKeyChecksum VARCHAR(48))--,IndiceMasterKey CHAR(2),WorkingKey VARCHAR(32))
			
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
		FROM dbo.EMV_KeyPublic WITH (NOLOCK)
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
			FROM @VTableKey ORDER BY CA_PubKeyIndex DESC

			SET @iAux = @iAux + LEN(@cAux)
			SET @cAux = @cHeader + @cRID + @cCA_PubKeyIndex + @cCA_PubKeyExpLen + @cCA_PubKeyExp + @cCA_PublicKeyLen 
						+ @cCA_PublicKey + @cChecksumStatus + @cCA_PubKeyChecksum
			
			IF (@iAux <= 999)
			BEGIN
				IF (@iAux + LEN(@cAux) <= 999)
					SET @cBit120 = @cBit120 + @cAux
				ELSE
					SET @cBit121 = @cBit121 + @cAux
				
			END
			ELSE IF (LEN(@cBit121) + LEN(@cAux) <= 999)
				SET @cBit121 = @cBit121 + @cAux
			ELSE IF (LEN(@cBit122) + LEN(@cAux) <= 999)
				SET @cBit122 = @cBit122 + @cAux

			DELETE FROM @VTableKey WHERE Codigo = @iCodigo
			
		END
		
		SET @cBit063 = @cVersaoCargaTbl + '002C'
			
	END
	
	IF (RIGHT(@cAuxTabela,3) = '003')
	BEGIN
				
		DECLARE	 @cBinINI			CHAR(19)
				,@cBinFIM			CHAR(19)
				,@cNomeBandeira		CHAR(32)
				,@cOption1			CHAR(8)
				,@cOption2			CHAR(8)
				,@cOption3			CHAR(8)
				,@cIndiceRegistro	CHAR(3)
				,@cQtdeRegistro		CHAR(2)
				,@cRegistro			CHAR(3)
				
		DECLARE @VTableBin TABLE (IndiceRegistro CHAR(3), BinINI CHAR(19),BinFIM CHAR(19),IdBandeira CHAR(3))

		INSERT INTO @VTableBin
		SELECT dbo.f_ZerosEsquerda(ep2.Codigo, 3) AS IndiceRegistro
			,LEFT(ep2.BinINI + REPLICATE('0', 19), 19) AS BinINI
			,LEFT(ep2.BinFIM + REPLICATE('9', 19), 19) AS BinFIM
			,ea.IdBandeira
		FROM Autorizador.dbo.EMV_Aplicacoes AS ea WITH (NOLOCK)
		INNER JOIN (
			SELECT ep.Codigo
				,ep.BinINI
				,ep.BinFIM
				,CASE 
					WHEN ep.BinINI = '6030788500'
						THEN '007'
					WHEN ep.BinINI IN (
							'6277027100'
							,'3083458700'
							,'3083458800'
							)
						THEN '008'
					ELSE ep.CodigoAid
					END AS CodigoAid
			FROM Autorizador.dbo.EMV_Produtos AS ep WITH (NOLOCK)
			WHERE ep.Ativo = 1
				AND ep.Codigo NOT IN (
					25
					,26
					,27
					,28
					)
			) AS ep2 ON ea.CodigoAid = ep2.CodigoAid
		INNER JOIN Autorizador.dbo.EMV_Bandeiras AS eb WITH (NOLOCK) ON ea.IdBandeira = eb.IdBandeira
		ORDER BY ep2.Codigo ASC;

		SELECT @cQtdeRegistro = dbo.f_ZerosEsquerda(count (IndiceRegistro),2) FROM  @VTableBin
		
		SET @iAux = 0
		SET @iCount = 0
		SET @cAux = ''
		SET @cRegistro = ''
		SET @cHeader = '04' /*CARD RANGES*/

		WHILE EXISTS (SELECT * FROM @VTableBin)
		BEGIN

			SET @iCount = @iCount + 1
			SET @cRegistro = dbo.f_ZerosEsquerda(@iCount, 3)
			
			SELECT TOP 1 @cIndiceRegistro = IndiceRegistro, @cBinINI = BinINI, @cBinFIM = BinFIM, @cIdBandeira = IdBandeira FROM @VTableBin
			
			SET @iAux = @iAux + LEN(@cAux)	
			SET @cAux = @cRegistro + @cBinINI + @cBinFIM + @cIdBandeira
			
			IF @cBit123 IN ('SCOPEPRIVATE0303', 'SCOPEPRIVEMV0303')
			BEGIN
				SET @cAux = @cAux + REPLICATE('1', 8)
			END			

			IF (@iAux <= 999)
			BEGIN
				
				IF (@iCount = 1)
					SET @cBit120 = @cHeader + @cQtdeRegistro
			
				IF (@iAux + LEN(@cAux) <= 999)
				BEGIN
					SET @cBit120 = @cBit120 + @cAux
					
				END
			END

			DELETE FROM @VTableBin WHERE IndiceRegistro = @cIndiceRegistro
			
		END
		
		DECLARE @VTableBandeira TABLE (IdBandeira CHAR(3), NomeBandeira CHAR(32),TipoBandeira CHAR(2),Option1 CHAR(8), Option2 CHAR(8), Option3 CHAR(8))
		
		INSERT INTO @VTableBandeira
		SELECT 
			 IdBandeira
			,NomeBandeira
			,TipoBandeira
			,Options1
			,Options2
			,Options3
		FROM dbo.EMV_Bandeiras A WITH (NOLOCK)
		ORDER BY IdBandeira ASC
		
		SELECT @cQtdeRegistro = dbo.f_ZerosEsquerda(COUNT(*),2) FROM  @VTableBandeira
		
		SET @cAux = ''
		SET @iAux = 0
		SET @iCount = 0
		SET @cHeader = '05' /*BANDEIRAS*/
		
		WHILE EXISTS (SELECT * FROM @VTableBandeira)
		BEGIN
			
			SELECT TOP 1 @cIdBandeira = IdBandeira, @cNomeBandeira = NomeBandeira, @cTipoBandeira = TipoBandeira, @cOption1 = Option1, @cOption2 = Option2, @cOption3 = Option3  FROM @VTableBandeira
			
			SET @iAux = @iAux + LEN(@cAux)	
			SET @cAux = @cIdBandeira + @cNomeBandeira + @cTipoBandeira + @cOption1 + @cOption2 + @cOption3

			IF (@iAux <= 999)
			BEGIN
				
				IF (@iCount = 0)
					SET @cBit121 = @cHeader + @cQtdeRegistro
			
				IF (@iAux + LEN(@cAux) <= 999)
				BEGIN
					SET @cBit121 = @cBit121 + @cAux
					SET @iCount = @iCount + 1	
				END
			END

			DELETE FROM @VTableBandeira WHERE IdBandeira = @cIdBandeira

		END

		SET @cBit063 = @cVersaoCargaTbl + '003F'
	
	END
	
--
				--SET @cBit120 = SUBSTRING(@cBit120,1,LEN(@cBit120)-1)
				--SET @cBit121 = '|' + SUBSTRING(@cBit121,1,LEN(@cBit121)-1)
				--SELECT @cBit080 = Versao FROM dbo.Aut_VersaoCargaTabela WITH (NOLOCK) WHERE Ativo = 1 ORDER BY Codigo
				--SET @cBit081 = ''

			--END
		--END
--	END

	
END

