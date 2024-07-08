-- =============================================
-- Author:		Cristiano Silva Barbosa
--Data criação: 19/02/2017
--Mudança: 2601
-- =============================================

--drop proc [pr_aut_GravaInfoAdicionais_VendaParcelada]

CREATE PROCEDURE [pr_aut_GravaInfoAdicionais_VendaParcelada] (
		 @Bit048				VARCHAR(1000) OUTPUT
		,@iTipoFinanciamento	INT
		,@nValor_Tarifa			DECIMAL(15,2) 
		,@nValor_Tributos		DECIMAL(15,2) 
		,@nValor_Seguros		DECIMAL(15,2) 
		,@nValor_Terceiros		DECIMAL(15,2) 
		,@nValor_Registros		DECIMAL(15,2) 
		,@nValor_Emissor		DECIMAL(15,2) 
		,@dDataPrimeiraParcela	DATETIME
		,@iQuantParcelas		INT
		,@nJuros_Mensal			DECIMAL(15,2) 
		,@nJuros_Anual			DECIMAL(15,2) 
		,@nValor_Parcela		DECIMAL(15,2) 
    
)
AS
BEGIN
    DECLARE @strValue	VARCHAR(20),
            @strAux		VARCHAR(1000),
            @intValue	INT
    
	SET @Bit048 = ''
	
    SET @strAux = '*VPR071'
	--008 a 008 – Tipo de financiamento (Domínio: 1 – Sem Juros / 2 – Com Juros / 3 – CDC)
	SET @strAux = @strAux + CONVERT(VARCHAR,@iTipoFinanciamento) 


	--009 a 015 – Valor da Tarifa (formato: 5 Int ,2 Dec)
	SET @intValue = @nValor_Tarifa * 100
    SET @strValue = CONVERT(VARCHAR,@intValue)
    SET @strAux = @strAux + REPLICATE('0', 7 - DATALENGTH(@strValue))

	--016 a 022 – Valor dos Tributos (formato: 5 Int ,2 Dec
	SET @intValue = @nValor_Tributos * 100
    SET @strValue = CONVERT(VARCHAR,@intValue)
    SET @strAux = @strAux + REPLICATE('0', 7 - DATALENGTH(@strValue))

	--023 a 029 – Valor dos Seguros (formato: 5 Int ,2 Dec)
	SET @intValue = @nValor_Seguros * 100
    SET @strValue = CONVERT(VARCHAR,@intValue)
    SET @strAux = @strAux + REPLICATE('0', 7 - DATALENGTH(@strValue))

	--030 a 036 – Valor do pagamento a terceiros (formato: 5 Int ,2 Dec)
	SET @intValue = @nValor_Terceiros * 100
    SET @strValue = CONVERT(VARCHAR,@intValue)
    SET @strAux = @strAux + REPLICATE('0', 7 - DATALENGTH(@strValue))

	--037 a 043 – Valor dos pagamentos de registros (formato: 5 Int , 2 Dec)
	SET @intValue = @nValor_Registros * 100
    SET @strValue = convert(varchar,@intValue)
    SET @strAux = @strAux + REPLICATE('0', 7 - DATALENGTH(@strValue))

	--044 a 051 – Valor Total Calculado pelo Emissor (formato: 6 Int , 2 Dec) (valor final)
	SET @intValue = @nValor_Emissor * 100
    SET @strValue = convert(varchar,@intValue)
    SET @strAux = @strAux + REPLICATE('0', 8 - DATALENGTH(@strValue))

	--052 a 057 – Data de Pagamento da Primeira Parcela (formato: AAMMDD)
    SET @strAux = @strAux + REPLICATE('0', 6 - DATALENGTH(CONVERT(VARCHAR,@dDataPrimeiraParcela,12)))

    --058 a 059 – Quantidade de parcelas (formato: 2 Int)
    SET @strValue = CONVERT(VARCHAR,@iQuantParcelas)
    SET @strAux = @strAux + REPLICATE('0', 2 - DATALENGTH(@strValue))

	--060 a 064 – Taxa Mensal de Juros (formato: 3 Int , 2 Dec)
    SET @intValue = @nJuros_Mensal * 100
    SET @strValue = CONVERT(VARCHAR,@intValue)
    SET @strAux = @strAux + REPLICATE('0', 5 - DATALENGTH(@strValue))

	--065 a 071 – Taxa de Juros Anualizada (formato: 5 Int, 2 Dec) (CET)
    SET @intValue = @nJuros_Anual * 100
    SET @strValue = CONVERT(VARCHAR,@intValue)
    SET @strAux = @strAux + REPLICATE('0', 7 - DATALENGTH(@strValue))

	--072 a 078 – Valor da Parcela (formato: 5 Int, 2 Dec)
    SET @intValue = @nValor_Parcela * 100
    SET @strValue = CONVERT(VARCHAR,@intValue)
    SET @strAux = @strAux + REPLICATE('0', 7 - DATALENGTH(@strValue))		

END

