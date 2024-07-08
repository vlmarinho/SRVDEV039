

-- ===============================================
-- Description:	Função para capitalizar uma string
-- Data: 19/02/2017
-- Mud/CH.:  2601
-- ===============================================
CREATE FUNCTION [dbo].[InitCap] (@Texto VARCHAR(8000))
RETURNS VARCHAR(8000)
AS
BEGIN
	DECLARE @sRetorno	VARCHAR(8000)
			,@cChar		CHAR(1)
			,@bAlphaNum BIT
			,@iLen		INT
			,@iPos		INT

	SET @sRetorno	= LOWER(@Texto)
	SET @bAlphaNum	= 0
	SET @iLen		= LEN(@Texto)
	SET @iPos		= 1

	-- Percorre todos os caracteres de entrada
	WHILE (@iPos <= @iLen)
	BEGIN
		-- Captura o próximo caractere
		SET @cChar = SUBSTRING(@Texto, @iPos, 1)

		-- Se a primeira posição, ou o caractere anterior não é alfanumérico, converte o caractere atual para maiúsculo.
		IF @iPos = 1 OR @bAlphaNum = 0
			SET @sRetorno = STUFF(@sRetorno, @iPos, 1, UPPER(@cChar))
 
		SET @iPos = @iPos + 1
 
		-- Define se o caractere atual não é alfanumérico
		IF (ASCII(@cChar) <= 47 OR (ASCII(@cChar) BETWEEN 58 AND 64) OR (ASCII(@cChar) BETWEEN 91 AND 96) OR (ASCII(@cChar) BETWEEN 123 AND 126))
			SET @bAlphaNum = 0
		ELSE
			SET @bAlphaNum = 1
	END
 
	RETURN @sRetorno
END



