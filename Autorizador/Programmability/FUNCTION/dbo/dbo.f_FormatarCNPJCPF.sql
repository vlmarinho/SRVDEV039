
/*
----------------------------------------------------------
Data........: 15/06/2015
Nome Sistema: Diversos
Objeto......: f_FormatarCNPJCPF
Propósito...: Função responsável por formatar CNPJ e CPF.
----------------------------------------------------------
Data alteração: -
Mudança.......: -
----------------------------------------------------------
*/

CREATE FUNCTION [dbo].[f_FormatarCNPJCPF](@Valor VARCHAR(20), @Label VARCHAR(10))
RETURNS VARCHAR(18)
AS
BEGIN
	DECLARE @sRetorno VARCHAR(18)

	SET @Valor = REPLACE(REPLACE(REPLACE(@Valor,'.',''),'-',''),'/','')

	IF (@Label = 'CNPJ')
		SET @sRetorno = LEFT(@Valor,2) + '.' + SUBSTRING(@Valor,3,3) + '.' + SUBSTRING(@Valor,6,3) + '/' + SUBSTRING(@Valor,9,4) + '-' + RIGHT(@Valor,2)
	ELSE IF (@Label = 'CPF')
		SET @sRetorno = LEFT(@Valor,3) + '.' + SUBSTRING(@Valor,4,3) + '.' + SUBSTRING(@Valor,7,3) + '-' + RIGHT(@Valor,2)

	RETURN @sRetorno
END
