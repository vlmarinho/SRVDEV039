

-- =============================================
--Data: 19/02/2017
--Mud/CH.:  2601
-- Description:	Função para converter Decimal p/
--				Binario.
-- =============================================
CREATE FUNCTION [dbo].[f_HexadecimalParaBinario](@Valor VARCHAR(50))
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

	SELECT @vcBinario = dbo.f_DecimalParaBinario(@iRetorno)

	RETURN @vcBinario
END


