/*
-- =============================================  
-- Author: Cristiano Silva Barbosa
-- Data criação: 19/02/2017
-- Mudança: 2601
-- =============================================  
--------------------------------------------------------------------------
Data: 20/06/2017
Autor: Cristiano Silva Barbosa - Tecnologia Policard
Chamado/Mudança:  390759 - 
--------------------------------------------------------------------------
*/


CREATE PROCEDURE [pr_aut_GravaInfoAdicionais_Saldo]
(  
	 @Bit048		VARCHAR(1000)	OUTPUT
	,@nValor_Saldo	DECIMAL(15,2)      
)  
AS  
BEGIN  
    DECLARE @strValue	VARCHAR(20),  
            @strAux		VARCHAR(1000),  
            @intValue	INT  
   
    SET @strAux = '*SDO011'  
  
    --009 a 015 – Valor do SALDO (formato: 9 Int ,2 Dec)  
    SET @intValue = ISNULL(@nValor_Saldo,0) * 100  
    SET @strValue = CONVERT(VARCHAR,@intValue)  
    SET @strAux = @strAux + REPLICATE('0', 11 - DATALENGTH(@strValue)) + @strValue  
  
   
   SET @Bit048 = @strAux

END  

