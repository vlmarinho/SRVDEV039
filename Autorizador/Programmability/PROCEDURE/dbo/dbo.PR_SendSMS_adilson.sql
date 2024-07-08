
/***************************************************************************************************  
 * Sistema: Controle de Acesso  
 * Objeto: [dbo].[PR_SendSMS]  
 * Propósito: Envia SMS para o telefone passado como parâmetro.  
 *  Parâmetros:  
 *   @cellPhoneNumber Login do usuário - VARCHAR(MAX)  
 *   @message Senha do usuario - VARCHAR(MAX)  
 *   @returnCode Código de retorno - INT OUTPUT  
 *   @returnMessage Mensagem de retorno - NVARCHAR(MAX) OUTPUT  
 ***************************************************************************************************  
 */  
/*=========== CHANGELOG ===========  
 Data: 21/03/2022  
 Autor: Adilson Pereira - Up Brasil  
 Chamado: 1823576  
 Descrição: Criação do objeto  
-----------------------------------------------------------------------------------------------------
 Data: 18/11/2023
 Autor: Gabriel Ed. - Up Brasil  
 Chamado: Emergencial  
 Descrição: Alterado serviço para Wavy
-----------------------------------------------------------------------------------------------------  
DECLARE @returnCode INT
DECLARE @returnMessage NVARCHAR(MAX)
EXEC Usuarios.dbo.PR_SendSMS_PRD '+5534984076233', '[Up Brasil] Outro Chamado Aberto', @returnCode OUTPUT , @returnMessage OUTPUT
SELECT @returnCode, @returnMessage
-----------------------------------------------------------------------------------------------------
*/  
CREATE PROCEDURE dbo.PR_SendSMS_adilson (  
   @cellPhoneNumber VARCHAR(18)  
 , @message VARCHAR(160)  
 , @returnCode INT OUTPUT  
 , @returnMessage NVARCHAR(MAX) OUTPUT  
)  
AS  
BEGIN  
	BEGIN TRY
		DECLARE @errorDescription VARCHAR(255)  
		DECLARE @errorSource VARCHAR(255)
		DECLARE @objectId INT
		DECLARE @httpStatus INT

		-- Remove special characteres
		SET @cellPhoneNumber = Processadora.dbo.f_SoNumeros(@cellPhoneNumber)

		-- Validates DDD + 8 numbers
		IF(LEN(@cellPhoneNumber) < 10)
		BEGIN
			-- Invalid number
			SET @ReturnCode = -1
			SET @returnMessage = 'Número de telefone inválido'
			RETURN 
		END

		IF(LEN(@cellPhoneNumber) < 12)
		BEGIN
			-- SET DDI
			SET @cellPhoneNumber = '55' + @cellPhoneNumber
		END

		PRINT @cellPhoneNumber

		DECLARE @requestBody VARCHAR(MAX) = '{"destination": "'+@cellPhoneNumber+'" , "messageText": "'+@message+'"}'

		-- Creates server
		EXEC @returnCode = sp_OACreate 'MSXML2.ServerXMLHttp' ,@objectId OUT  
		
		IF @returnCode <> 0  
			BEGIN  
				EXEC sp_OAGetErrorInfo @objectId  
					,@errorSource OUTPUT  
					,@errorDescription OUTPUT 
					  
				SET @returnMessage = 'Erro no sp_OACreate: {"@errorSource": "' + ISNULL(@errorSource, '') + '", "@errorDescription": "' + ISNULL(@errorDescription, '') + '"}';  
				  
			RETURN
		END 

		EXEC @returnCode = sp_OAMethod @objectId  
			,'open'  
			, NULL  
			,'POST'  
			, 'https://api-messaging.wavy.global/v1/send-sms'  
			, false

		IF @returnCode <> 0  
			BEGIN  
				EXEC sp_OAGetErrorInfo @objectId  
					,@errorSource OUTPUT  
					,@errorDescription OUTPUT;  
  
				SET @returnMessage = 'Erro no Open: {"@errorSource": "' + ISNULL(@errorSource, '') + '", "@errorDescription": "' + ISNULL(@errorDescription, '') + '"}';  
  
				RETURN;  
			END  
		
		-- Define Headers
		EXEC @returnCode = sp_OAMethod 
			  @objectId  
			, 'setRequestHeader'  
			, NULL  
			, 'Content-Type'  
			, 'application/json'  
  
		IF @returnCode <> 0  
			BEGIN  
				EXEC sp_OAGetErrorInfo @objectId  
					,@errorSource OUTPUT  
					,@errorDescription OUTPUT;  
  
				SET @returnMessage = 'Erro no set Content-Type: {"@errorSource": "' + ISNULL(@errorSource, '') + '", "@errorDescription": "' + ISNULL(@errorDescription, '') + '"}';  
  
				RETURN  
			END  

		EXEC @returnCode = sp_OAMethod 
			  @objectId  
			, 'setRequestHeader'  
			, NULL  
			, 'authenticationtoken'  
			, 'qCjrf2aBEDha1Ncnvcodk65hQA4WRparYoZX9vTz'  
  
		IF @returnCode <> 0  
			BEGIN  
				EXEC sp_OAGetErrorInfo @objectId  
					,@errorSource OUTPUT  
					,@errorDescription OUTPUT;  
  
				SET @returnMessage = 'Erro no set Content-Type: {"@errorSource": "' + ISNULL(@errorSource, '') + '", "@errorDescription": "' + ISNULL(@errorDescription, '') + '"}';  
  
				RETURN  
			END  

		EXEC @returnCode = sp_OAMethod 
			  @objectId  
			, 'setRequestHeader'  
			, NULL  
			, 'username'  
			, 'upbrasil@wavy.global'  
  
		IF @returnCode <> 0  
			BEGIN  
				EXEC sp_OAGetErrorInfo @objectId  
					,@errorSource OUTPUT  
					,@errorDescription OUTPUT;  
  
				SET @returnMessage = 'Erro no set Content-Type: {"@errorSource": "' + ISNULL(@errorSource, '') + '", "@errorDescription": "' + ISNULL(@errorDescription, '') + '"}';  
  
				RETURN  
			END  

		EXEC @returnCode = sp_OAMethod 
			  @objectId  
			, 'send'  
			, NULL  
			, @requestBody; 
  
		IF @returnCode <> 0  
			BEGIN  
				EXEC sp_OAGetErrorInfo @objectId  
					,@errorSource OUTPUT  
					,@errorDescription OUTPUT;  
  
				SET @returnMessage = 'Erro no set Send: {"@errorSource": "' + ISNULL(@errorSource, '') + '", "@errorDescription": "' + ISNULL(@errorDescription, '') + '"}';  
  
				RETURN
			END 

		SET @returnMessage = 'Enviado com Sucesso'
	END TRY

	BEGIN CATCH
		DECLARE @parameters VARCHAR(8000) = '{"@cellPhoneNumber": "' + @cellPhoneNumber + '", "@message": "' + @message + '"}';  
  
		SET @returnCode = 99;  
  
		SET @returnMessage = '(ERROR_PROCEDURE: ' + ERROR_PROCEDURE() + '; ERROR_NUMBER=' + CONVERT(VARCHAR(4000), ERROR_NUMBER()) + '; ERROR_SEVERITY=' + CONVERT(VARCHAR(4000), ERROR_SEVERITY()) + '; ERROR_STATE=' + CONVERT(VARCHAR(4000), ERROR_STATE()) + '; ERROR_LINE=' + CONVERT(VARCHAR(4000), ERROR_LINE()) + '; ERROR_MESSAGE=' + ERROR_MESSAGE() + ')' + ' parâmetros: ' + @parameters;  

		PRINT @returnMessage
	END CATCH
END