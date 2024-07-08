/*
--------------------------------------------------------------------------
Nome Sistema: Autorização
Objeto: [dbo].[FN_FORMATAR_TEXTO] 
Propósito: Retirar acentos e caracteres especiais
Autor: Cristiano Silva Barbosa - Tecnologia Policard
--------------------------------------------------------------------------
Data: 19/02/2017
Mud/CH.:  2601
--------------------------------------------------------------------------
*/
CREATE FUNCTION [f_FormatarTexto] 
( 
	@cTexto VARCHAR(MAX) 
) 
RETURNS VARCHAR(MAX) 
AS BEGIN 

	DECLARE @cTexto_Formatado VARCHAR(MAX) 
		   ,@cStrings VARCHAR(100)


	SET @cStrings = '><()!?@/\-+*{}[]?€“%'

	SET @cTexto = REPLACE(@cTexto,'Ãƒ','Â')
	SET @cTexto = REPLACE(@cTexto,'Ã‡','Ç')


	SET @cTexto_Formatado = UPPER(@cTexto) 
	COLLATE sql_latin1_general_cp1250_ci_as 
	
	
	SET @cTexto_Formatado = UPPER(@cTexto_Formatado)
	COLLATE sql_latin1_general_cp1251_ci_as 


	
	;WITH CTE AS
	(
		SELECT SUBSTRING(@cStrings, 1, 1) AS [String], 1 AS [Start], 1 AS [Counter]
		UNION ALL
		SELECT SUBSTRING(@cStrings, [Start] + 1, 1) AS [String], [Start] + 1, [Counter] + 1 
		FROM CTE 
		WHERE [Counter] < LEN(@cStrings)
	)

	SELECT @cTexto_Formatado = REPLACE(@cTexto_Formatado, CTE.[String], '') FROM CTE

	RETURN @cTexto_Formatado 
END 

