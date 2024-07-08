

/*
--------------------------------------------------------------------------
Data........: 27/05/2015
Nome Sistema: Autorizador
Objeto......: pr_DecriptaSenhaBco24Horas
Propósito...: Procedure responsável por decriptar a senha ou identificação
			  positiva do cartão do usuário.
--------------------------------------------------------------------------
Data alteração: -
Mudança.......: -
--------------------------------------------------------------------------
*/

CREATE PROC [dbo].[pr_DecriptaSenhaBco24Horas]
	@Senha		VARCHAR(16) OUTPUT
	,@Cartao	VARCHAR(16) = NULL
	,@IdPos		BIT = 0 -- VERIFICA SE É IDENTIFICAÇÃO POSTIVA OU NÃO
AS
BEGIN
	DECLARE @sChave			VARCHAR(32)
			,@sChaveIdPos	VARCHAR(32)

	SET @sChave		 = 'AA18EFD51A044AAFB9D2451D134091E1'
	SET @sChaveIdPos = '8FB276270C914524A95F0DD2F97DAB98'

	IF (@IdPos = 0)
		SELECT @Senha = dbo.DecriptaSenha(@Senha, @sChave, @Cartao)
	ELSE
	BEGIN
		SELECT @Senha = projeto_cielo_processadora.dbo.DecriptaSenhaPolicard(@Senha, @sChaveIdPos)
		SELECT @Senha = projeto_cielo_processadora.dbo.DecodeIdPositivaTecBan(@Senha)
	END
END


