
/*
--------------------------------------------------------------------------
Data........: 27/05/2015
Nome Sistema: Autorizador
Objeto......: pr_DecriptaSenhaPolicard
Propósito...: Procedure responsável por decriptar a senha dos cartões.
--------------------------------------------------------------------------
Data alteração: -
Mudança.......: -
--------------------------------------------------------------------------
*/

CREATE PROC [dbo].[pr_DecriptaSenhaPolicard]
	@Senha VARCHAR(32) OUTPUT
AS
	SELECT @Senha = dbo.DecriptaSenhaPolicard(@Senha,'4F3E17A695A521CDE1643AE21AC67932')
