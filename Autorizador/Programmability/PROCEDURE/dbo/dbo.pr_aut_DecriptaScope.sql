

/*
SERVIDOR: SRVUDI039\PROCESSADORA
BANCO DE DADOS: Autorizador
Data: 19/02/2017
Mud/CH.:  2601
Autor: Cristiano Silva
--------------------------------------------------------------------------
Data: 08/09/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1843805
Descrição: Projeto ABECS para transações NCR/Scope.
-------------------------------------------------------------------------- 	
*/


CREATE PROCEDURE [dbo].[pr_aut_DecriptaScope] (
	@cBit123 VARCHAR(1000) OUTPUT,
	@cWorkingKey VARCHAR(32) OUTPUT
)  
AS   
BEGIN  
	IF @cBit123 LIKE '%0303'
		SELECT @cWorkingKey = dbo.DecriptaSenhaPolicard(@cWorkingKey,'5937B8D129EBCFFCB82FFC281A217092') 
	ELSE
		SELECT @cWorkingKey = dbo.DecriptaSenhaPolicard(@cWorkingKey,'EC219B2AFBB80B91306498668E2BD439') 
	
END  






