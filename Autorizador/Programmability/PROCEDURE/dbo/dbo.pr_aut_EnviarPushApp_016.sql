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
*/     
   
--EXEC pr_aut_EnviarPushApp 'P',228173244,1423997, 92   
     
CREATE PROCEDURE [dbo].[pr_aut_EnviarPushApp_016] (     
  @cBaseOrigem CHAR(1)     
 ,@iTrnCodigo INT     
 ,@iCntAppCodigo INT
 ,@iCodigoResposta INT
 )     
     
AS     
BEGIN     
     
 SET NOCOUNT ON;     
     
 DECLARE       
   @sUrl      VARCHAR(100)     
  ,@sNumeroCartao    VARCHAR(16)     
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
  ,@cTipoMensagem    CHAR(4)
  ,@sCodigoResposta	VARCHAR(8)
  ,@sMessageApp	VARCHAR(150)
     
 SET @sCntAppCodigo = @iCntAppCodigo   
 SET @sCodigoResposta = @iCodigoResposta 
 SET @sDescricao = ''     
 SET @cTipo = ''     
     
 IF (@cBaseOrigem = 'P')     
 BEGIN     
       
  SELECT @sNumeroCartao = C.NUMERO     
     ,@iCrtUsrCodigo = C.CrtUsrCodigo     
     ,@sRamoAtividade = E.RamAtvCodigo     
     ,@sCodigoEstabelecimento = e.Numero     
     ,@sDataTransacao = CONVERT(VARCHAR(20),T.Data,120)     
     ,@sValorTransacao = REPLACE (T.Valor,',','.')     
     ,@cTipoMensagem = T.TipoMensagem     
     ,@sDescricao = CASE WHEN T.TipoMensagem = '0200' THEN 'Compra'     
        WHEN T.TipoMensagem = '0400' THEN 'Estorno'     
       END     
     ,@cTipo = CASE WHEN T.TipoMensagem = '0200' THEN 'D'     
       WHEN T.TipoMensagem = '0400' THEN 'C'     
       END     
  FROM Processadora.dbo.Transacoes T WITH(NOLOCK)      
  INNER JOIN Processadora.dbo.estabelecimentos E WITH(NOLOCK) ON T.CodEstab = E.Numero     
  INNER JOIN Processadora.dbo.CartoesUsuarios C WITH(NOLOCK) ON T.CrtUsrCodigo = C.CrtUsrCodigo     
  WHERE T.TRNCODIGO = @iTrnCodigo     
     
 END     
 ELSE IF (@cBaseOrigem = 'C')     
 BEGIN     
     
  SELECT @sNumeroCartao = T.NumeroCartao     
     ,@iCrtUsrCodigo = C.Codigo     
     ,@sRamoAtividade = E.RamAtvCodigo     
     ,@sCodigoEstabelecimento = T.Estabelecimento     
     ,@sDataTransacao = CONVERT(VARCHAR(20),T.DataAutorizacao,120)     
     ,@sValorTransacao = REPLACE (T.Valor,',','.')     
     ,@cTipoMensagem = T.Tipo_Mensagem     
     ,@sDescricao = CASE WHEN T.Tipo_Mensagem = '0200' THEN 'Compra'     
        WHEN T.Tipo_Mensagem = '0400' THEN 'Estorno'     
       END     
     ,@cTipo = CASE WHEN T.Tipo_Mensagem = '0200' THEN 'D'     
       WHEN T.Tipo_Mensagem = '0400' THEN 'C'     
       END     
  FROM Policard_603078.dbo.Transacao_RegistroTEF T WITH(NOLOCK)      
  INNER JOIN Policard_603078.dbo.Cartao_Usuario C WITH(NOLOCK) ON T.NumeroCartao = C.CodigoCartao     
  INNER JOIN Processadora.dbo.estabelecimentos E WITH(NOLOCK) ON T.Estabelecimento = E.Numero     
  WHERE T.NsuHost = @iTrnCodigo     
     
 END     
     
 SELECT @sMessageApp=ISNULL(t.MsgApp, t.descricao)
FROM Autorizador.dbo.aut_CodigosResposta AS t WITH (NOLOCK)
where t.codigo  = @iCodigoResposta;
     
     
 IF (@sNumeroCartao <> '' OR @sNumeroCartao IS NOT NULL)     
 BEGIN     
     
  SET @sHttpMethod = 'POST'     
  SET @sUrl = 'https://wssapp.policard.com.br/api/notification/transaction/v3'     
  --SET @sUrl = 'https://wssapp.upbrasil.com/api/notification/transaction/v3'    
  SET @sAuxiliar = 'Q0ExRDgyRkQwQzc1NzRENTJFNjk2MUI0QzA0QzA3OUI'     
     
  SET @sParamsValues = '[{ "usrCntCodigo": '+  @sCntAppCodigo + ' , "cartao": "'+ @sNumeroCartao +'" , "descricao": "' + @sDescricao +'" , "tipo": "' +      
        @cTipo +'", "codRamoAtividade": ' + @sRamoAtividade +', "codEstabelecimento": '+ @sCodigoEstabelecimento +', "dataLancamento": "' +      
        @sDataTransacao +'", "valor": ' + @sValorTransacao + ', "responseCode": ' + @sCodigoResposta + ', "responseMessage": "' +
        @sMessageApp + '"}]'     
 
  PRINT @sParamsValues
  RETURN;
  EXEC dbo.[pr_Aut_RequestHttpWebService] @sUrl, @sHttpMethod, @sParamsValues, @sAction, @sMetodo, @resultado, @sAuxiliar OUTPUT, @sRetorno OUTPUT, @iRetorno OUTPUT     
     
  INSERT INTO [dbo].[AuditoriaNotifyAPP] (     
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
   EnviarPushApp      
  SET      
   enviado = 1     
  WHERE      
   Trncodigo = @iTrncodigo      
   AND CntAPPCodigo = @iCntAPPCodigo      
   AND enviado = 0      
 END     
END     
     
   
