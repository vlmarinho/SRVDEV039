/* =============================================
Autor: Cristiano Silva Barbosa (Policard Systems)
Objetivo: Atualizar dados do Keep Alive enviados dos POS Walk e Policard.
Data Criacao: 09/09/2013
CH: 61136
-------------------------------------------------------------------
DATA: 19/02/2017
CH: 355660
-------------------------------------------------------------------
DATA: 19/02/2017
Chamado/Mudança: 355660 / 2601
-------------------------------------------------------------------
Data Alteração: 24/08/2017
Chamado: 409745 / 3170 
Responsavel: Cristiano Barbosa- Policard Systems
--------------------------------------------------------------------------

============================================= */
CREATE PROCEDURE [dbo].[pr_AUT_Atualiza_KeepAlive]
(
	 @cBit012	CHAR(6)			OUTPUT  -- Hora do terminal
	,@cBit013	CHAR(4)			OUTPUT  -- Data do terminal	
	,@cBit024	CHAR(3)					-- Rede de captura BIT024
	,@cBit032	VARCHAR(20)				-- Rede de captura BIT032
	,@cBit041	CHAR(8)					-- Numero Terminal
	,@cBit042	VARCHAR(15)				-- Codigo de estabelecimento
	,@cBit046	VARCHAR(1000)			-- Informacoes de comunicacao do POS
	,@cBit047	VARCHAR(1000)			-- Informacoes do POS
	,@cBit062	VARCHAR(1000)	OUTPUT	-- Informacoes do POS
	,@cBit105	CHAR(2)					-- Confirmar transacao anterior
)
AS

BEGIN

	DECLARE
		 @iRedeCaptura		  INT
		,@cNumero_Loja		  VARCHAR(15)
		,@cCodigoLoja		  VARCHAR(15)
		,@iResposta			  INT
		,@bTipoTrn			  BIT
		,@fl_Multibandeiras   BIT
		,@cDataMigracaoMaster DATETIME
		,@Prefixo             VARCHAR(20)		
		,@cStatusVersao       BIT
		,@VersaoPOS           VARCHAR(50)
		
	SET @bTipoTrn = 1
	
	SET @iRedeCaptura = CASE WHEN CONVERT(BIGINT, @cBit032) IN (6142, 58, 13, 14) THEN CONVERT(BIGINT, @cBit032)
							 WHEN CONVERT(BIGINT, @cBit032) NOT IN (6142, 58) AND CONVERT(BIGINT, @cBit024) IN (SELECT Numero FROM Acquirer.dbo.Subrede WITH(NOLOCK)) THEN CONVERT(BIGINT, @cBit024)
						END
	
	IF (@iRedeCaptura = 58 AND (@cBit046 <> '' OR @cBit046 IS NOT NULL)) /*POS Walk envia os dados de comunicacao no Bit046*/
		SET @cBit047 = @cBit047 + SUBSTRING(@cBit046, 2, LEN(@cBit046))
	
	
	IF (@iRedeCaptura IN (13,14) AND @cBit047 <> '')
	BEGIN

		DECLARE  @cAtualizaVersao	CHAR(1)
				,@cVersaoProducao	CHAR(6)
				,@cDataTelecarga	DATETIME
				,@cNomeAplicacao	VARCHAR(20)
				,@VersaoFramework   VARCHAR(20)
		
		/*Atualizando data e hora do terminal*/
		SELECT @cBit012 = REPLACE(CONVERT (VARCHAR(8),GETDATE(),108),':','')
			  ,@cBit013 = REPLACE(CONVERT (VARCHAR(5),GETDATE(),110),'-','')
			
		--CAPTURANDO DADOS DO MEIO DE CAPTURA
		SELECT @cAtualizaVersao = FL_Atualiza_Versao 
		     , @fl_Multibandeiras = Multibandeira
			 , @cDataMigracaoMaster = Data_MigracaoMaster
			 , @Prefixo = Prefixo
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
	END
		
	
	/*Validando estabelecimento*/						
	IF @iRedeCaptura <> 14
	BEGIN
		EXEC Processadora.[dbo].[pr_AUT_Verifica_Meioscaptura] @cBit041, @cBit042, @cBit047, @iRedeCaptura, @bTipoTrn, @iResposta OUTPUT
	END
	ELSE
	BEGIN
		
		SET	@cNumero_Loja	= SUBSTRING(@cBit042, 2,7)
		SET	@cCodigoLoja	= SUBSTRING(@cBit042, 9,7)

		SELECT 
			@cBit042 = EST.Numero
		FROM 
			Processadora.dbo.Estabelecimentos EST WITH(NOLOCK)
			JOIN Processadora.dbo.CB_DadosCorrespondente DCO WITH(NOLOCK) ON DCO.estcodigo = EST.estcodigo
		WHERE 
			EST.Numero =  CONVERT (BIGINT, @cBit042) 
			OR (DCO.CodigoLoja = @cCodigoLoja AND DCO.NumeroLoja = @cNumero_Loja)
			
		EXEC Processadora.[dbo].[pr_AUT_Verifica_Meioscaptura] @cBit041, @cBit042, @cBit047, @iRedeCaptura,@bTipoTrn, @iResposta OUTPUT
		
		/*Confirmar transacoes do correspondente bancario pendente.*/
		IF (@cBit105 = '01')
		BEGIN
			DECLARE 
				 @iCodigoUltimaTransacao	INT
				,@cTipoUltimaTransacao		CHAR(4)
				,@cStatusUltimaTransacao	CHAR(1)
				,@cConfirmaPgtoPolicard		CHAR(1)

			SELECT	TOP 1 
				 @iCodigoUltimaTransacao = Codigo
				,@cTipoUltimaTransacao	 = Cabecalho_ISO
				,@cStatusUltimaTransacao = [Status]
				,@cConfirmaPgtoPolicard	 = FormaPagto
			FROM autorizacao.dbo.CB_Transacoes WITH(NOLOCK)
			WHERE Terminal = @cBit041
			ORDER BY Codigo DESC

			/*Atualizando status da transacao anterior*/
			IF (@cTipoUltimaTransacao IN ('0200', '0400') AND @cStatusUltimaTransacao = 'P')
			BEGIN
				UPDATE autorizacao.dbo.CB_Transacoes SET [Status] = 'A' WHERE Codigo = @iCodigoUltimaTransacao
			END
		END
	END
END



