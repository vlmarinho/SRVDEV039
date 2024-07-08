
/*
----------------------------------------------------------------------------
Data........: 12/06/2015
Nome Sistema: Autorizador
Objeto......: f_FormatarValor
Propósito...: Função responsável por formatar um valor decimal em string.
----------------------------------------------------------------------------
Data alteração: -
Mudança.......: -
----------------------------------------------------------------------------
*/

CREATE FUNCTION [dbo].[f_FormatarValor](@Valor DECIMAL(18,4), @SepMilhar CHAR(1), @SepDecimal CHAR(1))
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @Inteiro		BIGINT
			,@Texto			VARCHAR(50)
			,@ValorDecimal	VARCHAR(4)

	SET @Texto			= RTRIM(CAST(@Valor AS VARCHAR(50)))
	SET @Inteiro		= CAST(@Valor AS BIGINT)
	SET @ValorDecimal	= SUBSTRING(@Texto, LEN(@Texto) - 3, 2)

	IF LEN(@Inteiro) = 1
		SET @Texto = SUBSTRING(CAST(@Inteiro AS VARCHAR(10)), 1, 1) + @SepDecimal + @ValorDecimal

	IF LEN(@Inteiro) = 2
		SET @Texto = SUBSTRING(CAST(@Inteiro AS VARCHAR(10)), 1, 2) + @SepDecimal + @ValorDecimal

	IF LEN(@Inteiro) = 3
		SET @Texto = SUBSTRING(CAST(@Inteiro AS VARCHAR(10)), 1, 3) + @SepDecimal + @ValorDecimal

	IF LEN(@Inteiro) = 4
		SET @Texto = SUBSTRING(CAST(@Inteiro AS VARCHAR(10)), 1, 1) + @SepMilhar + SUBSTRING(CAST(@Inteiro AS VARCHAR(10)), 2, 3) + @SepDecimal + @ValorDecimal

	IF LEN(@Inteiro) = 5
		SET @Texto = SUBSTRING(CAST(@Inteiro AS VARCHAR(10)), 1, 2) + @SepMilhar + SUBSTRING(CAST(@Inteiro AS VARCHAR(10)), 3, 3) + @SepDecimal + @ValorDecimal

	IF LEN(@Inteiro) = 6
		SET @Texto = SUBSTRING(CAST(@Inteiro AS VARCHAR(10)), 1, 3) + @SepMilhar + SUBSTRING(CAST(@Inteiro AS VARCHAR(10)), 4, 3) + @SepDecimal + @ValorDecimal

	IF LEN(@Inteiro) = 7
		SET @Texto = SUBSTRING(CAST(@Inteiro AS VARCHAR(10)), 1, 1) + @SepMilhar + SUBSTRING(CAST(@Inteiro AS VARCHAR(10)), 2, 3) + @SepMilhar +
					 SUBSTRING(CAST(@Inteiro AS VARCHAR(10)), 5, 3) + @SepDecimal + @ValorDecimal

	IF LEN(@Inteiro) = 8
		SET @Texto = SUBSTRING(CAST(@Inteiro AS VARCHAR(10)), 1, 2) + @SepMilhar + SUBSTRING(CAST(@Inteiro AS VARCHAR(10)), 3, 3) + @SepMilhar +
					 SUBSTRING(CAST(@Inteiro AS VARCHAR(10)), 6, 3) + @SepDecimal + @ValorDecimal

	IF LEN(@Inteiro) = 9
		SET @Texto = SUBSTRING(CAST(@Inteiro AS VARCHAR(10)), 1, 3) + @SepMilhar + SUBSTRING(CAST(@Inteiro AS VARCHAR(10)), 4, 3) + @SepMilhar +
					 SUBSTRING(CAST(@Inteiro AS VARCHAR(10)), 7, 3) + @SepDecimal + @ValorDecimal

	IF LEN(@Inteiro) = 10
		SET @Texto = SUBSTRING(CAST(@Inteiro AS VARCHAR(10)), 1, 1) + @SepMilhar + SUBSTRING(CAST(@Inteiro AS VARCHAR(10)), 2, 3) + @SepMilhar +
					 SUBSTRING(CAST(@Inteiro AS VARCHAR(10)), 5, 3) + @SepMilhar + SUBSTRING(CAST(@Inteiro AS VARCHAR(10)), 8, 3) + @SepDecimal + @ValorDecimal

	IF LEN(@Inteiro) = 11
		SET @Texto = SUBSTRING(CAST(@Inteiro AS VARCHAR(20)), 1, 2) + @SepMilhar + SUBSTRING(CAST(@Inteiro AS VARCHAR(20)), 3, 3) + @SepMilhar +
					 SUBSTRING(CAST(@Inteiro AS VARCHAR(20)), 6, 3) + @SepMilhar + SUBSTRING(CAST(@Inteiro AS VARCHAR(20)), 9, 3) + @SepDecimal + @ValorDecimal

	IF LEN(@Inteiro) = 12
		SET @Texto = SUBSTRING(CAST(@Inteiro AS VARCHAR(20)), 1, 3) + @SepMilhar + SUBSTRING(CAST(@Inteiro AS VARCHAR(20)), 4, 3) + @SepMilhar +
					 SUBSTRING(CAST(@Inteiro AS VARCHAR(20)), 7, 3) + @SepMilhar + SUBSTRING(CAST(@Inteiro AS VARCHAR(20)), 10, 3) + @SepDecimal + @ValorDecimal

	IF (SUBSTRING(@Texto,1,1) = '-' AND LEN(@Texto) = 8)
		SET @Texto = REPLACE(@Texto,'.','')

	RETURN @Texto
END

