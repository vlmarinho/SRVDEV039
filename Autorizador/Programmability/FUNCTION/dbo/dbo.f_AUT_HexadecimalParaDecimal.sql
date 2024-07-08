-- =============================================
-- Author:		Luiz Renato
-- Create date: 24/11/2014
-- Description:	Função para converter Decimal p/
--				Binario.
-- CH./Mud.: 229199/1394
-- =============================================
CREATE FUNCTION f_AUT_HexadecimalParaDecimal(@Valor VARCHAR(50))
RETURNS VARCHAR(256)
AS
BEGIN
	DECLARE @iRetorno	BIGINT
			,@cChar		CHAR(1)
			,@iChar		BIGINT
			,@vcBinario	VARCHAR(100)

	SET @iRetorno	= 0
	SET @iChar		= 0

	WHILE(@iChar < LEN(@Valor))
	BEGIN
		SET @cChar = SUBSTRING(@Valor, (LEN(@Valor) - @iChar), 1)

		SET @iRetorno = @iRetorno + (POWER(16,(@iChar)) * (CASE WHEN ISNUMERIC(@cChar) = 1 THEN CONVERT(BIGINT, @cChar)
																WHEN @cChar = 'A' THEN 10
																WHEN @cChar = 'B' THEN 11
																WHEN @cChar = 'C' THEN 12
																WHEN @cChar = 'D' THEN 13
																WHEN @cChar = 'E' THEN 14
																WHEN @cChar = 'F' THEN 15
														  END))

		SET @iChar = @iChar + 1
	END

	RETURN @iRetorno
END
