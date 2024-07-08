
/*
BANCO DE DADOS: Autorizador
Data: 19/02/2017
Mud/CH.:  2601
Autor: Cristiano Silva
--------------------------------------------------------------------------
*/

CREATE PROC [dbo].[pr_aut_DecriptaSenhaSE3DES] (
	 @sSENHA		VARCHAR(32) OUTPUT
	,@bSenhaValida	BIT			OUTPUT
)  
AS   
BEGIN

	SET @bSenhaValida = 0

	SELECT @sSENHA = dbo.DecriptaSenhaPolicard(@sSENHA,'EC3FCA8533C24A55F20A951E2FB9D49F') 

	SET @sSENHA = REPLACE (@sSENHA,'F','' )

	IF (ISNUMERIC(@sSENHA)= 1 AND @sSENHA NOT LIKE '%[A-Z]%' AND LEN(@sSENHA) >= 4)
		SET @bSenhaValida = 1

END  
