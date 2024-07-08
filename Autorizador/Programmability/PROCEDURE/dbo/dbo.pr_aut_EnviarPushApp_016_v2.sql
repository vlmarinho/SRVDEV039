/*     
=====================================================================     
Projeto: Notificação via APP     
Descrição: Procedure utilizada para enviar nofitificação via APP     
Autor: Cristiano Silva Barbosa     
Data Criacao: 28/09/2017     
Chamado/Mudança: 399954 / 3262     
=====================================================================     
Data: 21/09/2023
Autor: Adilson Pereira - Up Brasil
Chamado: 2056783
Descrição: Alteração para notificar o usuário pelo motivo da negativa da transação.
	Squad Rede - Jornada VA
-----------------------------------------------------------------------------------
Data: 17/10/2023
Autor: Adilson Pereira - Up Brasil
Chamado: 2067391 
Descrição: Altera passagem de parâmetros para processo de envio de notificação por push.
	No caso de transações negadas não é gerado registro nas tabelas finais.
-------------------------------------------------------------------------- 
*/     
   
--EXEC pr_aut_EnviarPushApp 'P',228173244,1423997, 92   
--EXEC pr_aut_EnviarPushApp_016_v2 'P',228173244,1423997, 92, 7825210, '4202670639426733', 623235243;
     
CREATE PROCEDURE [dbo].[pr_aut_EnviarPushApp_016_v2] (     
  @cBaseOrigem CHAR(1)     
 ,@iTrnCodigo INT     
 ,@iCntAppCodigo INT
 ,@iCodigoResposta INT
 ,@iCodigoEstabelecimento BIGINT = NULL
 ,@sNumeroCartao CHAR(16) = NULL
 ,@iAuditCodigo BIGINT
 )     
     
AS     
BEGIN     
     
 SET NOCOUNT ON;     
     PRINT 'ENVIO'
 DECLARE       
   @sUrl      VARCHAR(100)     
  ,@sDescricao    VARCHAR(50)     
  ,@cTipo      CHAR(1)     
  ,@sRamoAtividade   VARCHAR(10)     
  ,@sCntAppCodigo    VARCHAR(10)     
  ,@sCodigoEstabelecimento VARCHAR(10)     
  ,@sHttpMethod    VARCHAR(10)     
  ,@sParamsValues    VARCHAR(MAX)     
  ,@sAction     VARCHAR(1024)     
  ,@sMetodo     VARCHAR(1024)     
  ,@sRetorno     VARCHAR(MAX)     
  ,@sAuxiliar     VARCHAR(MAX)     
  ,@iRetorno     INT     
  ,@iCrtUsrCodigo    INT     
  ,@resultado     VARCHAR(16)     
  ,@sDataTransacao   VARCHAR(20)     
  ,@sValorTransacao   VARCHAR(15)     
  ,@sCodigoResposta	VARCHAR(8)
  ,@sMessageApp	VARCHAR(150)
  ,@nValorTransacao DECIMAL(15,2)
  ,@cTipoMensagem VARCHAR(8)   

	SELECT @cTipoMensagem = atr.Bit001
		,@sDataTransacao = CONVERT(VARCHAR, atr.DataHora, 120)
		,@nValorTransacao = CASE atr.bit004
			WHEN ''
				THEN 0
			ELSE convert(DECIMAL(15, 2), isnull(atr.bit004, '0')) / 100
			END
	FROM Autorizador.dbo.AuditoriaTransacoes AS atr WITH (NOLOCK)
	WHERE atr.Codigo = @iAuditCodigo
 
 SET @sValorTransacao = @nValorTransacao
 SET @sCntAppCodigo = @iCntAppCodigo   
 SET @sCodigoResposta = @iCodigoResposta 
 SET @sCodigoEstabelecimento = @iCodigoEstabelecimento	
	
 SET @sDescricao = CASE @cTipoMensagem
 					WHEN '0200' THEN 'Compra'     
        			WHEN '0400' THEN 'Estorno'    
        			ELSE ''
       			END;

 SET @cTipo = CASE @cTipoMensagem
 					WHEN '0200' THEN 'D'     
       				WHEN '0400' THEN 'C'     
       				ELSE ''
       			END;
     
 IF (@cBaseOrigem = 'P')     
 BEGIN 
	 
  SELECT @iCrtUsrCodigo = cu.CrtUsrCodigo 
  FROM Processadora.dbo.CartoesUsuarios as cu with (nolock)
  WHERE cu.Numero = @sNumeroCartao;
     
 END     
 ELSE IF (@cBaseOrigem = 'C')     
 BEGIN     

	SELECT @iCrtUsrCodigo = cu.Codigo  
  	FROM Policard_603078.dbo.Cartao_Usuario as cu with (nolock)
  	WHERE cu.CodigoCartao = @sNumeroCartao;
     
 END   

 
 select @sRamoAtividade = e.RamAtvCodigo 
 from Processadora.dbo.estabelecimentos as e with (nolock)
 where e.Numero  = @iCodigoEstabelecimento;
     
 SELECT @sMessageApp=ISNULL(t.MsgApp, t.descricao)
FROM Autorizador.dbo.aut_CodigosResposta AS t WITH (NOLOCK)
where t.codigo  = @iCodigoResposta;
     
     
 IF (@sNumeroCartao <> '' OR @sNumeroCartao IS NOT NULL)     
 BEGIN     
     
  SET @sHttpMethod = 'POST'     
  --SET @sUrl = 'https://wssapp.policard.com.br/api/notification/transaction/v3'     
  SET @sUrl = 'https://wssapp.upbrasil.com/api/notification/transaction/v3'    
  SET @sAuxiliar = 'Q0ExRDgyRkQwQzc1NzRENTJFNjk2MUI0QzA0QzA3OUI'     
     
  SET @sParamsValues = CONCAT('[{ "usrCntCodigo": ', @sCntAppCodigo , ' , "cartao": "', @sNumeroCartao ,'" , "descricao": "' , @sDescricao ,'" , "tipo": "' ,     
        @cTipo ,'", "codRamoAtividade": ' , @sRamoAtividade ,', "codEstabelecimento": ', @sCodigoEstabelecimento ,', "dataLancamento": "' ,      
        @sDataTransacao ,'", "valor": ' , @sValorTransacao , ', "responseCode": ' , @sCodigoResposta , ', "responseMessage": "' ,
        @sMessageApp , '"}]')   
 
  print @sParamsValues
  --return

  --EXEC dbo.[pr_Aut_RequestHttpWebService] @sUrl, @sHttpMethod, @sParamsValues, @sAction, @sMetodo, @resultado, @sAuxiliar OUTPUT, @sRetorno OUTPUT, @iRetorno OUTPUT     
     
  INSERT INTO Autorizador.dbo.AuditoriaNotifyAPP (     
    Data     
   ,TipoMensagem     
   ,NsuHost     
   ,CrtUsrcodigo     
   ,CntAppCodigo     
   ,BaseOrigem     
   ,Tipo     
   ,Status)     
  VALUES(     
   GETDATE()     
   ,@cTipoMensagem     
   ,@iTrnCodigo     
   ,@iCrtUsrCodigo     
   ,@iCntAppCodigo     
   ,@cBaseOrigem     
   ,@cTipo     
   ,0     
   )     
       
  UPDATE      
   Autorizador.dbo.EnviarPushApp      
  SET      
   Enviado = 1     
  WHERE 
   AuditCodigo = @iAuditCodigo
   AND CntAPPCodigo = @iCntAPPCodigo      
   AND Enviado = 0      
 END     
END     
     
   
