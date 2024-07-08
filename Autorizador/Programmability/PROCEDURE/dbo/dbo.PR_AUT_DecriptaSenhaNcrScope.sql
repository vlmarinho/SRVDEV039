/*=========== CHANGELOG ===========
Data: 08/09/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1843805
Descrição: Projeto ABECS para transações NCR/Scope.
-------------------------------------------------------------------------- 	
*/
CREATE PROCEDURE dbo.PR_AUT_DecriptaSenhaNcrScope (
	@bEncriptaPinBlock BIT
	,@cBaseOrigem CHAR(1)
	,@cBit052 VARCHAR(1000)
	,@cBit059 VARCHAR(1000)
	,@cBit123 VARCHAR(1000)
	,@cBit124 VARCHAR(200)
	,@cNumeroCartao VARCHAR(16)
	,@cPlanoBanco VARCHAR(16)
	,@cProvedor VARCHAR(50)
	,@iCodigoEstabelecimento INT
	,@iCrtUsrCodigo INT
	,@iFranquiaUsuario INT
	,@iRedeNumero INT
	,@iTamanhoSenha INT
	,@sPinBlockPWD VARCHAR(16)
	,@bDecryptPasswordHSM BIT OUTPUT
	,@bSenhaValida BIT OUTPUT
	,@cPlanoAutorizador VARCHAR(16) OUTPUT
	,@iResposta INT OUTPUT
	,@returnCode INT OUTPUT
	,@returnMessage VARCHAR(4000) OUTPUT
	)
AS
BEGIN
	BEGIN
		DECLARE @tipoCriptografia CHAR(1);
		DECLARE @cIdentificadorWK VARCHAR(16);
	END

	BEGIN
		SET NOCOUNT ON;
		SET @returnCode = 0;
		SET @returnMessage = 'OK';
		SET @bDecryptPasswordHSM = 0;

			IF @cBit123 IN (
					'SCOPEPRIVATE0303'
					,'SCOPEPRIVEMV0303'
					)
			BEGIN
				--verifica bit 124 e decide se é translate ou hsm
				SET @tipoCriptografia = SUBSTRING(@cBit124, 6, 1);

				IF @tipoCriptografia = 1 /* Translate por software */
				BEGIN
					EXEC Autorizador.dbo.PR_AUT_DecriptaSenhaNcrScopePorTranslate 
						@iCodigoEstabelecimento
						,@cProvedor
						,@cBit052
						,@cNumeroCartao
						,@cPlanoBanco
						,@cBit123
						,@cPlanoAutorizador OUTPUT
						,@iResposta OUTPUT
						,@returnCode OUTPUT
						,@returnMessage OUTPUT;
						
					IF @returnCode <> 0
						THROW 500001, @returnMessage, 1;							
					
				END
				ELSE IF @tipoCriptografia = 3 /* ABECS classe 3 */
				BEGIN
					
					SET @bDecryptPasswordHSM = 1;
				
					SET @cIdentificadorWK = SUBSTRING(@cBit124, 8, 5)
				
				
					EXEC [pr_Aut_DecriptaSenhaHSM]  
						 @cNumeroCartao 
						,@iCrtUsrCodigo 
						,@iFranquiaUsuario 
						,@cPlanoAutorizador 
						,@cBaseOrigem 
						,@iRedeNumero 
						,@iCodigoEstabelecimento 
						,@cProvedor 
						,@cBit059 
						,@iTamanhoSenha 
						,@cPlanoBanco 
						,@sPinBlockPWD 
						,@bEncriptaPinBlock
						,@bSenhaValida		OUTPUT 
						,@iResposta			OUTPUT 		
						,@cIdentificadorWK;
					
				END
				ELSE
				BEGIN
					SET @returnCode = 1;
					SET @returnMessage = 'Tipo de criptografia não implementado => ' + @tipoCriptografia;
				END
			END
			ELSE
			BEGIN
				--translate antigo (informações criptográficas no bit 062) 
					EXEC Autorizador.dbo.PR_AUT_DecriptaSenhaNcrScopePorTranslate 
						@iCodigoEstabelecimento
						,@cProvedor
						,@cBit052
						,@cNumeroCartao
						,@cPlanoBanco
						,@cBit123
						,@cPlanoAutorizador OUTPUT
						,@iResposta OUTPUT
						,@returnCode OUTPUT
						,@returnMessage OUTPUT;
						
						
					IF @returnCode <> 0
						THROW 500001, @returnMessage, 1;	
			END
	END
END