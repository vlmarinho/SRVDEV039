
/*
------------------------------------------------------------------------------------------------
Proposito: Formatar mascarar número no formato CNPJ quando tiver 14 digitos e quanto tiver 11
		   usar o formato de CPF
Autor    : Cristiano Silva Barbosa
Data: 19/02/2017
Mud/CH.:  2601

------------------------------------------------------------------------------------------------
*/

CREATE FUNCTION [dbo].[f_FormatarCNPJ_CPF](@Valor VARCHAR(18))

RETURNS VARCHAR(18) 

AS  

BEGIN
	
	DECLARE @retorno VARCHAR(18)
		
	IF	LEN(@Valor) = 14 
		SET @retorno = SUBSTRING(@Valor, 1, 2) + '.' + SUBSTRING(@Valor, 3, 3) + '.' + SUBSTRING(@Valor, 6, 3) + '/' + SUBSTRING(@Valor, 9, 4) + '-' + SUBSTRING(@Valor, 13, 2)
	ELSE 
		SET @retorno = SUBSTRING(@Valor, 1, 3) + '.' + SUBSTRING(@Valor, 4, 3) + '.' + SUBSTRING(@Valor, 7, 3) + '-' + SUBSTRING(@Valor, 10, 2)		

  RETURN @retorno

END


