

/*..
===============================================
Author:		Luiz Renato
Create date: 17/12/2014
Description:	Procedure para validar a senha
do cartão (Banco 24 Horas)
===============================================
Data criação: 19/02/2017
Mudança: 2601
-----------------------------------------------
*/

CREATE PROCEDURE [pr_aut_ValidaSenhaCartaoBco24Horas](
	 @cNumeroCartao				VARCHAR(16)
	,@cSenha					VARCHAR(16)
	,@sMascarasIdPositiva		VARCHAR(10)	= NULL
	,@sDadosIdPositiva			VARCHAR(32)	= NULL
	,@cBase						CHAR(1)
	,@bIdPositiva				BIT			= 0
	,@iLenMascaraIdPositiva		INT			= NULL
	,@bAtualizaSenhaTransacao	BIT
	,@iRedeCaptura				INT
	,@iResposta					INT			OUTPUT
	)
AS
BEGIN
	
	IF (@cBase = 'C')
		EXEC   Policard_603078.dbo.pr_CONV_GerenciamentoCartao
			 @cNumeroCartao
			,@cSenha
			,NULL
			,@sMascarasIdPositiva
			,@sDadosIdPositiva
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,@bIdPositiva
			,@iLenMascaraIdPositiva
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,@iResposta OUTPUT
	ELSE
		EXEC pr_AUT_GerenciamentoCartao
			 @cNumeroCartao
			,@cSenha
			,NULL
			,NULL
			,@sMascarasIdPositiva
			,@sDadosIdPositiva
			,NULL
			,@bAtualizaSenhaTransacao
			,@bIdPositiva
			,@iLenMascaraIdPositiva
			,@iRedeCaptura
			,NULL
			,NULL
			,@iResposta OUTPUT
END



