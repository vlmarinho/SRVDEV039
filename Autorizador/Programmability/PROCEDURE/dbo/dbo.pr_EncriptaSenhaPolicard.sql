
/*
--------------------------------------------------------------------------
Data........: 28/05/2015
Nome Sistema: Autorizador
Objeto......: pr_EncriptaSenhaPolicard
Propósito...: Procedure responsável por encriptar a senha do cartão.
--------------------------------------------------------------------------
Criada por:	Luiz Renato
Data: 06/10/2015
CH: 1194 / 212609
---------------------------------------------------------------------------
*/

CREATE PROC [dbo].[pr_EncriptaSenhaPolicard]
	@Senha VARCHAR(32) OUTPUT
AS
BEGIN
	SELECT @Senha = dbo.EncriptaSenhaPolicard(@Senha,'4F3E17A695A521CDE1643AE21AC67932')
END
