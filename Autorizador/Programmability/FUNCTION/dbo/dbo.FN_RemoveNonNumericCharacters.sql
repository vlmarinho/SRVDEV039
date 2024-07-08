/***************************************************************************************************
 * Sistema: Autorizador
 * Objeto: [dbo].[FN_RemoveNonNumericCharacters]
 * Propósito: Remove todos os caracteres não numéricos do string.
 *  Parâmetros:
 *    @inputString String original para remoção de caracteres - VARCHAR(MAX)
 ***************************************************************************************************
 */
/*=========== CHANGELOG ===========
Data: 08/09/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1843805
Descrição: Projeto ABECS para transações NCR/Scope.
-------------------------------------------------------------------------- 	
*/
CREATE FUNCTION dbo.FN_RemoveNonNumericCharacters (@inputString AS VARCHAR(MAX))  
RETURNS VARCHAR(MAX) WITH SCHEMABINDING AS    
BEGIN
  WHILE PATINDEX('%[^0-9]%',@inputString)>0
        SET @inputString = STUFF(@inputString,PATINDEX('%[^0-9]%',@inputString),1,'')     
  RETURN @inputString
END;