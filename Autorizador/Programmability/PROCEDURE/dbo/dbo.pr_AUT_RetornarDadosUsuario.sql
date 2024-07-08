
/*
--------------------------------------------------------------------------
Data........: 19/05/2015
Nome Sistema: Autorizador
Objeto......: pr_AUT_RetornarDadosUsuario
Propósito...: Procedure responsável por retornar os dados para validação
			  do Usuário.
--------------------------------------------------------------------------
Criada por:	Luiz Renato
Data: 06/10/2015
CH: 1194 / 212609
---------------------------------------------------------------------------
*/

CREATE PROCEDURE pr_AUT_RetornarDadosUsuario
	 @sBit002				VARCHAR(20)	/* Cartão */
	,@sBit035				VARCHAR(20)	/* Cartão */
	,@sBit045				VARCHAR(20)	/* Cartão */
	,@sSenhaTransacao		VARCHAR(32)
	,@sProvedor				VARCHAR(50)		= NULL
	,@sNumeroCartao			VARCHAR(16)		= NULL	OUT
	,@sNomeUsuario			VARCHAR(50)		= NULL	OUT
	,@sLabelProduto			VARCHAR(50)		= NULL	OUT
	,@cBaseOrigem			CHAR(1)					OUT
	,@bSenhaCapturada		BIT				= NULL	OUT
	,@bSenhaValida			BIT				= NULL	OUT
	,@iRedeCaptura			INT
	,@iCodEstabelecimento	INT				= NULL
	,@iCodUsuario			INT						OUT
	,@iCodCartao			INT						OUT
	,@iCodContaUsuario		INT						OUT
	,@iCodCliente			INT						OUT
	,@iCodFranquia			INT						OUT
	,@iCodTipoProduto		INT						OUT
	,@dSaldoDispCartao		DECIMAL(15,2)	= 0		OUT
	,@dSaldoDispConta		DECIMAL(15,2)	= 0		OUT
	,@iResposta				INT						OUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @cPermiteSaque		CHAR(1)
			,@cStatusCartao		CHAR(1)
			,@cStatusCliente	CHAR(1)
			,@cStatusConta		CHAR(1)
			,@cStatusUsuario	CHAR(1)
			,@bSenha			BIT

	SELECT	@iCodTipoProduto = 0
			,@cBaseOrigem	 = ''
			,@sNumeroCartao	 = dbo.f_RetornarNumeroCartao(@sBit002,@sBit035,@sBit045)
			,@iResposta		 = 0

	EXEC Processadora..pr_PROC_RetornarTipoProdutoCartao
		 @sNumeroCartao
		,@cBaseOrigem		OUT
		,@iCodTipoProduto	OUT
		,@cPermiteSaque		OUT
		,@iCodCliente		OUT
		,@iCodUsuario		OUT
		,@iCodCartao		OUT
		,@iCodContaUsuario	OUT
		,@iCodFranquia		OUT
		,@sLabelProduto		OUT
		,@sNomeUsuario		OUT

	IF (@cBaseOrigem = 'C')
	BEGIN
		PRINT 'CONVENIO NÃO DISPONÍVEL'
	END
	ELSE IF (@cBaseOrigem = 'P')
	BEGIN
		SELECT	 @cStatusCartao		= C.Status
				,@cStatusConta		= CO.Status
				,@dSaldoDispCartao	= C.CreditoDisponivel
				,@dSaldoDispConta	= CO.CreditoDisponivel
		FROM	Processadora..CartoesUsuarios C WITH(NOLOCK)
				INNER JOIN Processadora..ContasUsuarios CO WITH(NOLOCK) ON (CO.CntUsrCodigo = C.CntUsrCodigo)
		WHERE	C.CrtUsrCodigo = @iCodCartao

		IF (@cStatusConta <> 'A')
			SET @iResposta = 4 /* CONTA BLOQUEADA OU CANCELADA */
		IF (@cStatusCartao <> 'A')
			SET @iResposta = 5 /* CARTÃO BLOQUEADO OU CANCELADO */

		IF (@iResposta = 0)
		BEGIN
			EXEC pr_AUT_ValidarIdpSenhaCartao
				 @sNumeroCartao
				,@cBaseOrigem
				,@sSenhaTransacao
				,@sProvedor
				,NULL
				,NULL
				,0
				,@bSenhaCapturada	OUT
				,@bSenhaValida		OUT
				,NULL
				,@iRedeCaptura
				,@iCodEstabelecimento
				,@iCodCartao
				,@iResposta			OUT
		END
	END
	ELSE
		SET @iResposta = 6 /* CARTÃO INVÁLIDO */
END
