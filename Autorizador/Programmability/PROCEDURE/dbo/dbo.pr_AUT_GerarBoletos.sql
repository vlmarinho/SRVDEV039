

/*
----------------------------------------------------------------------------
Data........: 07/12/2015
Nome Sistema: Autorizador
Objeto......: pr_AUT_GerarBoletos
Propósito...: Procedure responsável por gerar boletos para impressão no POS.
----------------------------------------------------------------------------
Data alteração: 29/12/2015
Mudança.......: 1499 / 235909
----------------------------------------------------------------------------
Data alteração: 31/03/2016
Mudança.......: 257079
Autor: Shuster Roberto
--------------------------------------------------------------------------
Data Alteracao: 21/09/2017
Autor: Cristiano Barbosa
CH: 410827 - 3239
--------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[pr_AUT_GerarBoletos]
	 @Bit003			VARCHAR(6)
	,@Bit004			VARCHAR(12)		= NULL	
	,@Bit074			VARCHAR(10)		= NULL
	,@iRede				INT
	,@iEstabelecimento	INT	
	,@bPrePago			BIT
	,@Bit062			VARCHAR(1000)	= NULL OUT
	,@iResposta			INT				= NULL OUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TB_Retorno table(Bit062 VARCHAR(1000))

	DECLARE  @sNomeCedente		VARCHAR(100)
			,@sNomeBanco		VARCHAR(100)
			,@sLabelBanco		VARCHAR(20)
			,@sCnpjCedente		VARCHAR(20)
			,@sEderencoCedente	VARCHAR(50)
			,@sSql				NVARCHAR(2000)
			,@dValorBoleto		DECIMAL(15,2)
			,@iCodBoletoGerado	INT

	SELECT	@sLabelBanco		= Descricao FROM Acquirer..ParametroSistema WITH(NOLOCK) WHERE CodigoParametroSistema = 66
	SELECT	@sNomeCedente		= Descricao FROM Acquirer..ParametroSistema WITH(NOLOCK) WHERE CodigoParametroSistema = 67
	SELECT	@sCnpjCedente		= Descricao FROM Acquirer..ParametroSistema WITH(NOLOCK) WHERE CodigoParametroSistema = 68
	SELECT	@sEderencoCedente	= Descricao FROM Acquirer..ParametroSistema WITH(NOLOCK) WHERE CodigoParametroSistema = 69
	SELECT	@sNomeBanco			= Descricao FROM Acquirer..ParametroSistema WITH(NOLOCK) WHERE CodigoParametroSistema = 70
	SELECT	@dValorBoleto		= CONVERT(DECIMAL(15,2),@Bit004/100)
			,@iResposta			= 0
	
	IF (@Bit003 = '000100' AND @bPrePago = 1)
		EXEC [SRVUDI009\SIADE].Siade.sankhya.pr_VT_EmitirBoletoPrePago @iEstabelecimento, @dValorBoleto, @iCodBoletoGerado OUT
	ELSE IF (@Bit003 = '000100' AND @bPrePago = 0)
		SET @iResposta = 29

		
	SET @sSql = ' SELECT	''' + COALESCE(@sLabelBanco,'') + '@''
				+ CONVERT(VARCHAR,T.CodBco) + ''@''
				+ LTRIM(RTRIM(T.LinhaDigitavel)) + ''@''
				+ LTRIM(RTRIM(T.CodigoBarra)) + ''@''
				+ CONVERT(VARCHAR(10),GETDATE(),103) + ''@''
				+ CONVERT(VARCHAR(10),T.DtNeg,103) + ''@''
				+ ''R$'' + ''@''
				+ CONVERT(VARCHAR,TC.Carteira) + ''@''
				+ CONVERT(VARCHAR,T.NumNota) + ''@''
				+ CONVERT(VARCHAR(10),T.DtVenc,103) + ''@''
				+ LTRIM(RTRIM(TC.CodAge)) + ''/'' + LTRIM(RTRIM(TC.CodCtaBco)) + ''@''
				+ LTRIM(RTRIM(T.NossoNum)) + ''@''
				+ CONVERT(VARCHAR,T.VlrDesdob) + ''@''
				+ CONVERT(VARCHAR,T.VlrDesc) + ''@''
				+ CONVERT(VARCHAR,0.00) + ''@''
				+ CONVERT(VARCHAR,T.VlrMulta) + ''@''
				+ CONVERT(VARCHAR,0.00) + ''@''
				+ CONVERT(VARCHAR,T.VlrDesdob + T.VlrMulta - T.VlrDesc) + ''@''
				+ ''ATE O VENCIMENTO, PAGAR PREFERENCIALMENTE NO ITAU'' + ''@''
				+ ''' + COALESCE(@sNomeCedente,'') + '@''
				+ ''' + COALESCE(@sEderencoCedente,'') + '@''
				+ ''USO EXCLUSIVO DO CORRESPONDENTE ITAU. NAO RECEBER PAGAMENTO EM CHEQUE'' + ''@''
				+ CONVERT(VARCHAR,EBV.CodigoEstabelecimento) + ''@''
				+ E.RazaoSocial COLLATE DATABASE_DEFAULT + ''@''
				+ ''' + COALESCE(@sNomeBanco,'') + '@''
		 FROM	Acquirer..EstabelecimentoBoletoVT EBV WITH(NOLOCK)
				INNER JOIN Acquirer..Estabelecimento E WITH(NOLOCK) ON (E.CodigoEstabelecimento = EBV.CodigoEstabelecimento)
				INNER JOIN [SRVUDI009\SIADE].Siade.Sankhya.TgfFin T WITH(NOLOCK) ON (EBV.NumeroDocumento = T.NuFin)
				INNER JOIN [SRVUDI009\SIADE].Siade.Sankhya.TsiCta TC WITH(NOLOCK) ON (TC.CodCtaBcoInt = T.CodCtaBcoInt)
				INNER JOIN [SRVUDI009\SIADE].Siade.Sankhya.TgfPar TP WITH(NOLOCK) ON (TP.CodParc = T.CodParc)
		WHERE	EBV.CodigoEstabelecimento = ' + CONVERT(VARCHAR,@iEstabelecimento) -- 6474514

	IF (@Bit003 = '000100' AND @bPrePago = 1) -- PRÉ-PAGO
		SET @sSql = @sSql + ' AND EBV.CodigoBoleto = ' + CONVERT(VARCHAR,@iCodBoletoGerado)

	IF (@Bit003 IN ('000110','000120')) -- FECHAMENTO E REIMPRESSÃO
	BEGIN
		SET @sSql = @sSql + ' AND EBV.PrePago = 0'
		SET @sSql = @sSql + ' AND EBV.CodigoStatus IN (1,2)'

		IF (@Bit003 = '000110') -- FECHAMENTO
			SET @sSql = @sSql + ' AND CONVERT(VARCHAR,EBV.DataEmissao,112) = CONVERT(VARCHAR,GETDATE(),112)'

		IF (@Bit003 = '000120') -- REIMPRESSÃO
			SET @sSql = @sSql + ' AND CONVERT(VARCHAR,EBV.DataEmissao,112) = CONVERT(VARCHAR,CONVERT(DATETIME,''' + @Bit074 + '''),112)'
	END

	INSERT INTO @TB_Retorno EXEC(@sSql)

	SELECT @Bit062 = Bit062 FROM @TB_Retorno

	IF (LTRIM(RTRIM(@Bit062)) = '') 
		SET @iResposta = 26
END
