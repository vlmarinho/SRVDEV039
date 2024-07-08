
-- =============================================
-- Author:		Cristiano Silva Barbos
--Data: 19/02/2017
--Mud/CH.:  2601
-- Description:	Função para converter Inteiro p/
--				Hexadecimal.
-- =============================================
CREATE FUNCTION [f_InteiroParaHexadecimal](@Valor BIGINT)
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @cSeq		CHAR(16)
			,@vcRetorno VARCHAR(50)
			,@cDigito	CHAR(1)

    SET @cSeq = '0123456789ABCDEF'

    SET @vcRetorno = SUBSTRING(@cSeq, (@Valor % 16) + 1, 1)

    WHILE(@Valor > 0)
    BEGIN
        SET @cDigito = SUBSTRING(@cSeq, ((@Valor / 16) % 16) + 1, 1)

        SET @Valor = @Valor / 16
        IF @Valor <> 0 SET @vcRetorno = @cDigito + @vcRetorno
    END

    RETURN @vcRetorno
END

