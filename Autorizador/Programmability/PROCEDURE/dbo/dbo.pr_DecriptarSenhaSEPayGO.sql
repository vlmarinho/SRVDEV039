
/*
--------------------------------------------------------------------------
Data........: 28/05/2015
Nome Sistema: Autorizador
Objeto......: pr_DecriptarSenhaSEPayGO
Propósito...: Procedure responsável por decriptar a senha da transação p/
			  SoftwareExpress e PayGo.
--------------------------------------------------------------------------
Criada por:	Luiz Renato
Data: 06/10/2015
CH: 1194 / 212609
---------------------------------------------------------------------------
*/

CREATE PROC [dbo].[pr_DecriptarSenhaSEPayGO]
	 @cSenhaCriptografada VARCHAR(32)
	,@cChaveTrabalho	  VARCHAR(32)
	,@cNumeroCartao		  CHAR(16)
	,@cSenhaPlana		  VARCHAR(32) OUTPUT
AS
BEGIN
	SELECT @cSenhaPlana = dbo.DecriptarSenhaSEPayGO(@cSenhaCriptografada, @cChaveTrabalho, '001', NULL, @cNumeroCartao, '0')
END
