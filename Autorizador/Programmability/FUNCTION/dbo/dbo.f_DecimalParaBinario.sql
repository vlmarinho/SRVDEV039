

-- =============================================
--Data: 19/02/2017
--Mud/CH.:  2601
-- Description:	Função para converter Decimal p/
--				Binario.
-- =============================================
CREATE FUNCTION [dbo].[f_DecimalParaBinario](@Valor BIGINT)
RETURNS VARCHAR(255)
AS
BEGIN
	DECLARE @Retorno VARCHAR(255)

	SET @Retorno = ''

	WHILE(@Valor > 0)
	BEGIN
		SET @Retorno = @Retorno + CAST((@Valor % 2) AS VARCHAR)
		SET @Valor = @Valor / 2
	END

	RETURN REVERSE(@Retorno)
END


