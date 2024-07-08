

-- =============================================
-- Author:		Cristiano Silva Barbosa
--Data: 19/02/2017
--Mud/CH.:  2601
-- Description:	Função para converter Binario p/
--				Decimal.
-- =============================================
CREATE FUNCTION [dbo].[f_BinarioParaDecimal](@Valor VARCHAR(255))
RETURNS BIGINT
AS
BEGIN
	DECLARE @Cnt		TINYINT
			,@Tamanho	TINYINT
			,@Retorno	BIGINT

	SET @Cnt = 1
	SET @Tamanho = LEN(@Valor)
	SET @Retorno = CAST(SUBSTRING(@Valor,@Tamanho, 1) AS BIGINT)

	WHILE(@Cnt < @Tamanho)
	BEGIN
		SET @Retorno = @Retorno + POWER(CAST(SUBSTRING(@Valor, @Tamanho - @Cnt, 1) * 2 AS BIGINT), @Cnt)
		SET @Cnt = @Cnt + 1
	END

	RETURN @Retorno
END


