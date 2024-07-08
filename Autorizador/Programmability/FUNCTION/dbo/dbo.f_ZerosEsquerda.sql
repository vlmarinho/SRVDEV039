
/*
----------------------------------------------------------------------------
Data........: 13/10/2015 -- 15:31 
Nome Sistema: Autorizador
Objeto......: f_ZerosEsquerda
Propósito...: Função responsável o número do Estabelecimento para validação.
Autor: Luiz Renato
----------------------------------------------------------------------------
Data alteração: -
Mudança.......: -
----------------------------------------------------------------------------
*/

CREATE FUNCTION [dbo].[f_ZerosEsquerda]
(
	@Valor		VARCHAR(100)
	,@Tamanho	INTEGER
)
RETURNS VARCHAR(100)
AS 
BEGIN
	DECLARE @ValorFormatado VARCHAR(100)

	SELECT  @ValorFormatado = CASE WHEN (@Tamanho <= LEN(@Valor))
									THEN @Valor
									ELSE RIGHT(REPLICATE('0', @Tamanho) + @Valor, @Tamanho)
							  END

	RETURN(@ValorFormatado)
END
