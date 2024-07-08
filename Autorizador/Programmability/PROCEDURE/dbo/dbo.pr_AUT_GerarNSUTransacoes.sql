
/*
---------------------------------------------------------------------------
Data........: 09/06/2015
Nome Sistema: Autorizador
Objeto......: pr_AUT_GerarNSUTransacoes
Propósito...: Procedure responsável por inserir as transações e lançamentos
			  para USUÁRIOS, ESTABELECIMENTOS e COMISSÃO.
--------------------------------------------------------------------------
Criada por:	Luiz Renato
Data: 06/10/2015
CH: 1194 / 212609
---------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[pr_AUT_GerarNSUTransacoes]
	 @NSU		 VARCHAR(200) OUTPUT
	,@LenRetorno INT
AS
BEGIN
	DECLARE @MAX BIGINT

	SELECT @MAX = MAX(Codigo) FROM NSUTransacoes WITH(NOLOCK)

	IF (@MAX = 999999)
		TRUNCATE TABLE NSUTransacoes

	INSERT INTO NSUTransacoes VALUES(GETDATE())

	SET @NSU = SCOPE_IDENTITY()
	SET @NSU = dbo.f_ZerosEsquerda(@NSU,@LenRetorno)
END
