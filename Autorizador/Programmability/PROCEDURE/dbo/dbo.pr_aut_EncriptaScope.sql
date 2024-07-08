
/*
SERVIDOR: SRVUDI039\PROCESSADORA
Base de dados: Autorizador
Data criação: 19/02/2017
Mudança: 2601
Autor: Cristiano Silva
--------------------------------------------------------------------------
Data: 08/09/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1843805
Descrição: Projeto ABECS para transações NCR/Scope.
-------------------------------------------------------------------------- 	
*/

--drop proc [pr_aut_EncriptaScope]

CREATE PROCEDURE [dbo].[pr_aut_EncriptaScope] (
	@cBit123 VARCHAR(1000),
	@cWorkingKey VARCHAR(32) OUTPUT
)    
AS     
BEGIN   
	IF @cBit123 like '%0303'
		SELECT @cWorkingKey = dbo.EncriptaSenhaPolicard(@cWorkingKey,'5937B8D129EBCFFCB82FFC281A217092');
	ELSE 
		SELECT @cWorkingKey = dbo.EncriptaSenhaPolicard(@cWorkingKey,'EC219B2AFBB80B91306498668E2BD439');
END    
  
  



