
/*
--------------------------------------------------------------------------
Data........: 29/06/2015
Nome Sistema: Autorizador
Objeto......: pr_EncriptaTDES
Propósito...: Procedure responsável por encriptar chaves de trabalho.
--------------------------------------------------------------------------
Criada por:	Luiz Renato
Data: 06/10/2015
CH: 1194 / 212609
---------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[pr_EncriptaTDES]
	@cWorkingKey VARCHAR(32) OUTPUT
AS
BEGIN
	SELECT @cWorkingKey = dbo.EncriptaSenhaPolicard(@cWorkingKey,'D84827A9816F4AD4AE02C92E9A32A59A')
END
