

/*
SERVIDOR: SRVUDI039\PROCESSADORA
BANCO DE DADOS: Autorizador
AUTOR:Cristiano
Data criação: 19/02/2017
Mudança: 2601
--------------------------------------------------------------------------------------------------

*/

--drop proc [pr_aut_DecriptaTDES]

CREATE PROCEDURE [dbo].[pr_aut_DecriptaTDES] (
	@cWorkingKey VARCHAR(32) OUTPUT
)  
AS   
BEGIN  
	SELECT @cWorkingKey = dbo.DecriptaSenhaPolicard(@cWorkingKey,'D84827A9816F4AD4AE02C92E9A32A59A') 
END  





