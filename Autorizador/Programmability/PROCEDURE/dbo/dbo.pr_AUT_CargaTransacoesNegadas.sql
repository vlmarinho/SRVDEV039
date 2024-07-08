/*
---------------------------------------------------------------------------
Data........: 29/06/2015
Nome Sistema: Autorizador
Objeto......: pr_AUT_CargaTransacoesNegadas
Propósito...: Procedure responsável por inserir os dados das transações não
			  autorizadas na tabela "TransacoesNegadas".
--------------------------------------------------------------------------
Criada por:	Luiz Renato
Data: 06/10/2015
CH: 1194 / 212609
---------------------------------------------------------------------------
Alterada Por: Luiz Renato
Data: 13/10/2015 -- 15:57
Ch: 1194 / Mudança de Correção: 1240
Obs.: Será aberto uma emergencia. A modificação esta relacionada a inclusão de novos campos nos selects da procedure.
*/

CREATE PROCEDURE pr_AUT_CargaTransacoesNegadas
	 @Bit001			VARCHAR(1000)
	,@Bit004			VARCHAR(1000)
	,@Bit007			VARCHAR(1000)
	,@Bit011			VARCHAR(1000)
	,@Bit012			VARCHAR(1000)
	,@Bit013			VARCHAR(1000)
	,@Bit022			VARCHAR(1000)
	,@Bit038			VARCHAR(1000)
	,@Bit041			VARCHAR(1000)
	,@Bit048			VARCHAR(1000)
	,@Bit052			VARCHAR(1000)
	,@Bit090			VARCHAR(1000)
	,@Bit127			VARCHAR(1000)
	,@cBaseOrigem		CHAR(1)
	,@iTipoMeioCaptura	TINYINT
	,@iRede				TINYINT
	,@iQtdParcelas		TINYINT
	,@iCodTrnOriginal	BIGINT
	,@iEstabelecimento	INT
	,@iCodTipoTransacao	INT
	,@iCodCartao		INT
	,@iCodTipoProduto	INT
	,@iCodCliente		INT
	,@iCodFranquia		INT
	,@iResposta			INT
	,@bSenhaCapturada	BIT
	,@bSenhaValida		BIT
	,@dDataTransacao	DATETIME
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE  @iModoEntrada		TINYINT
			,@bCartaoEMV		BIT
			,@dValorTransacao	DECIMAL(15,2)

	SELECT	 @iModoEntrada		= Codigo FROM Processadora..ModoEntradaTransacao WITH(NOLOCK) WHERE Tipo = @Bit022
	SELECT	 @Bit052			= CASE WHEN(@iResposta = 7) THEN @Bit052 ELSE NULL END
			,@Bit038			= CASE WHEN(LTRIM(RTRIM(@Bit038)) <> '') THEN @Bit038 ELSE NULL END
			,@Bit127			= CASE WHEN(LTRIM(RTRIM(@Bit127)) <> '') THEN @Bit127 ELSE NULL END
			,@bCartaoEMV		= CASE WHEN(@Bit022 = '051') THEN 1 ELSE 0 END
			,@dValorTransacao	= dbo.f_RetornarValor(@Bit004)
			,@Bit048			= CASE	WHEN(@iRede = 15) THEN 'POS POLICARD'
										WHEN(LTRIM(RTRIM(@Bit048)) = '') THEN NULL
										ELSE @Bit048
								  END

	IF (@iResposta = 14)
		INSERT INTO Processadora..TransacoesNegadas
		SELECT	 @iEstabelecimento
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL -- FRANQUIA (ATUALIZAR QUANDO FOR DESENVOLVER O CONVENIO)
				,@iCodTrnOriginal
				,@iResposta
				,@cBaseOrigem
				,@Bit001
				,@dValorTransacao
				,NULL
				,@dDataTransacao
				,@Bit007
				,@Bit013
				,@Bit012
				,@Bit041
				,@Bit048 -- REVISAR PARA RETORNAR O PROVEDOR
				,NULL
				,NULL
				,@Bit011
				,NULL
				,SUBSTRING(@Bit090,11,6)
				,@Bit090
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
	ELSE IF (@Bit001 IN ('0400','0420'))
		INSERT INTO Processadora..TransacoesNegadas
		SELECT	 CodEstabelecimento
				,CodTipoTransacao
				,CodCartao
				,CodTipoProduto
				,CodTipoMeioCaptura
				,CodRede
				,CodCliente
				,@iCodFranquia
				,@iCodTrnOriginal
				,@iResposta
				,@cBaseOrigem
				,@Bit001
				,@dValorTransacao
				,NULL
				,@dDataTransacao
				,@Bit007
				,@Bit013
				,@Bit012
				,@Bit041
				,@Bit048
				,NULL
				,@Bit038
				,@Bit011
				,@Bit127
				,SUBSTRING(@Bit090,11,6)
				,@Bit090
				,NULL
				,NULL
				,NULL
				,NULL
				,ModoEntrada
				,NULL
		FROM	Processadora..TransacoesAutorizadas WITH(NOLOCK)
		WHERE	Codigo = @iCodTrnOriginal
	ELSE
		INSERT INTO Processadora..TransacoesNegadas
		SELECT	 @iEstabelecimento
				,@iCodTipoTransacao
				,@iCodCartao
				,@iCodTipoProduto
				,@iTipoMeioCaptura
				,@iRede
				,@iCodCliente
				,@iCodFranquia
				,@iCodTrnOriginal
				,@iResposta
				,@cBaseOrigem
				,@Bit001
				,@dValorTransacao
				,@iQtdParcelas
				,@dDataTransacao
				,@Bit007
				,@Bit013
				,@Bit012
				,@Bit041
				,@Bit048
				,NULL
				,@Bit038
				,@Bit011
				,NULL
				,NULL
				,NULL
				,@Bit052
				,@bSenhaCapturada
				,@bSenhaValida
				,@bCartaoEMV
				,@iModoEntrada
				,NULL
END
