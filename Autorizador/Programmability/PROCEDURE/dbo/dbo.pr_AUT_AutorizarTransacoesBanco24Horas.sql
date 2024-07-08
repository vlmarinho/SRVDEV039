      
      
      
/*      
===================================================================      
Projeto: Banco 24 Horas      
Author: Luiz Renato      
Create date: 17/04/2015      
Description: Autorizar transações da Rede TecBan (Banco 24 Horas).      
===================================================================      
Author: Luiz Renato      
Data: 19/02/2017      
Mud/CH.:  2601      
===================================================================      
Author: Cristiano Barbosa      
Data: 05/06/2018      
CH.: 501627 / 503824 Mud.: 4062      
===================================================================      
Author: Cristiano Barbosa      
Data: 06/06/2018      
CH.: 501627 / 503824 Mud.: 4062 AJUSTE      
===================================================================      
Author: João Henrique      
Data: 04/12/2018      
CH.: 581912  Mud.:       
===================================================================      
Author: João Henrique      
Data: 12/04/2023      
CH.:   Mud.: Alteração realizada em carater emergencial na linha 433, responsável pela verificação positiva      
devido a falha de transações na migração de Tecban para Resomaq      
===================================================================      
Data: 19/09/2023
Autor: Adilson Pereira - Up Brasil
Chamado: 2057405 
Descrição: Corrigir validação de transações do banco 24 horas, 
	para ignorar restrições da blocklist geradas por alteração de telefone via app.
-----------------------------------------------------------------------------------	
*/      
      
      
CREATE PROCEDURE [dbo].[pr_AUT_AutorizarTransacoesBanco24Horas]      
 @sBit001 VARCHAR(1000) OUTPUT, @sBit002 VARCHAR(1000) OUTPUT, @sBit003 VARCHAR(1000) OUTPUT, @sBit004 VARCHAR(1000) OUTPUT,      
 @sBit005 VARCHAR(1000) OUTPUT, @sBit006 VARCHAR(1000) OUTPUT, @sBit007 VARCHAR(1000) OUTPUT, @sBit008 VARCHAR(1000) OUTPUT,      
 @sBit009 VARCHAR(1000) OUTPUT, @sBit010 VARCHAR(1000) OUTPUT, @sBit011 VARCHAR(1000) OUTPUT, @sBit012 VARCHAR(1000) OUTPUT,      
 @sBit013 VARCHAR(1000) OUTPUT, @sBit014 VARCHAR(1000) OUTPUT, @sBit015 VARCHAR(1000) OUTPUT, @sBit016 VARCHAR(1000) OUTPUT,      
 @sBit017 VARCHAR(1000) OUTPUT, @sBit018 VARCHAR(1000) OUTPUT, @sBit019 VARCHAR(1000) OUTPUT, @sBit020 VARCHAR(1000) OUTPUT,      
 @sBit021 VARCHAR(1000) OUTPUT, @sBit022 VARCHAR(1000) OUTPUT, @sBit023 VARCHAR(1000) OUTPUT, @sBit024 VARCHAR(1000) OUTPUT,      
 @sBit025 VARCHAR(1000) OUTPUT, @sBit026 VARCHAR(1000) OUTPUT, @sBit027 VARCHAR(1000) OUTPUT, @sBit028 VARCHAR(1000) OUTPUT,      
 @sBit029 VARCHAR(1000) OUTPUT, @sBit030 VARCHAR(1000) OUTPUT, @sBit031 VARCHAR(1000) OUTPUT, @sBit032 VARCHAR(1000) OUTPUT,      
 @sBit033 VARCHAR(1000) OUTPUT, @sBit034 VARCHAR(1000) OUTPUT, @sBit035 VARCHAR(1000) OUTPUT, @sBit036 VARCHAR(1000) OUTPUT,      
 @sBit037 VARCHAR(1000) OUTPUT, @sBit038 VARCHAR(1000) OUTPUT, @sBit039 VARCHAR(1000) OUTPUT, @sBit040 VARCHAR(1000) OUTPUT,      
 @sBit041 VARCHAR(1000) OUTPUT, @sBit042 VARCHAR(1000) OUTPUT, @sBit043 VARCHAR(1000) OUTPUT, @sBit044 VARCHAR(1000) OUTPUT,      
 @sBit045 VARCHAR(1000) OUTPUT, @sBit046 VARCHAR(1000) OUTPUT, @sBit047 VARCHAR(1000) OUTPUT, @sBit048 VARCHAR(1000) OUTPUT,      
 @sBit049 VARCHAR(1000) OUTPUT, @sBit050 VARCHAR(1000) OUTPUT, @sBit051 VARCHAR(1000) OUTPUT, @sBit052 VARCHAR(1000) OUTPUT,      
 @sBit053 VARCHAR(1000) OUTPUT, @sBit054 VARCHAR(1000) OUTPUT, @sBit055 VARCHAR(1000) OUTPUT, @sBit056 VARCHAR(1000) OUTPUT,      
 @sBit057 VARCHAR(1000) OUTPUT, @sBit058 VARCHAR(1000) OUTPUT, @sBit059 VARCHAR(1000) OUTPUT, @sBit060 VARCHAR(1000) OUTPUT,      
 @sBit061 VARCHAR(1000) OUTPUT, @sBit062 VARCHAR(1000) OUTPUT, @sBit063 VARCHAR(1000) OUTPUT, @sBit064 VARCHAR(1000) OUTPUT,      
 @sBit065 VARCHAR(1000) OUTPUT, @sBit066 VARCHAR(1000) OUTPUT, @sBit067 VARCHAR(1000) OUTPUT, @sBit068 VARCHAR(1000) OUTPUT,      
 @sBit069 VARCHAR(1000) OUTPUT, @sBit070 VARCHAR(1000) OUTPUT, @sBit071 VARCHAR(1000) OUTPUT, @sBit072 VARCHAR(1000) OUTPUT,      
 @sBit073 VARCHAR(1000) OUTPUT, @sBit074 VARCHAR(1000) OUTPUT, @sBit075 VARCHAR(1000) OUTPUT, @sBit076 VARCHAR(1000) OUTPUT,      
 @sBit077 VARCHAR(1000) OUTPUT, @sBit078 VARCHAR(1000) OUTPUT, @sBit079 VARCHAR(1000) OUTPUT, @sBit080 VARCHAR(1000) OUTPUT,      
 @sBit081 VARCHAR(1000) OUTPUT, @sBit082 VARCHAR(1000) OUTPUT, @sBit083 VARCHAR(1000) OUTPUT, @sBit084 VARCHAR(1000) OUTPUT,      
 @sBit085 VARCHAR(1000) OUTPUT, @sBit086 VARCHAR(1000) OUTPUT, @sBit087 VARCHAR(1000) OUTPUT, @sBit088 VARCHAR(1000) OUTPUT,      
 @sBit089 VARCHAR(1000) OUTPUT, @sBit090 VARCHAR(1000) OUTPUT, @sBit091 VARCHAR(1000) OUTPUT, @sBit092 VARCHAR(1000) OUTPUT,      
 @sBit093 VARCHAR(1000) OUTPUT, @sBit094 VARCHAR(1000) OUTPUT, @sBit095 VARCHAR(1000) OUTPUT, @sBit096 VARCHAR(1000) OUTPUT,      
 @sBit097 VARCHAR(1000) OUTPUT, @sBit098 VARCHAR(1000) OUTPUT, @sBit099 VARCHAR(1000) OUTPUT, @sBit100 VARCHAR(1000) OUTPUT,      
 @sBit101 VARCHAR(1000) OUTPUT, @sBit102 VARCHAR(1000) OUTPUT, @sBit103 VARCHAR(1000) OUTPUT, @sBit104 VARCHAR(1000) OUTPUT,      
 @sBit105 VARCHAR(1000) OUTPUT, @sBit106 VARCHAR(1000) OUTPUT, @sBit107 VARCHAR(1000) OUTPUT, @sBit108 VARCHAR(1000) OUTPUT,      
 @sBit109 VARCHAR(1000) OUTPUT, @sBit110 VARCHAR(1000) OUTPUT, @sBit111 VARCHAR(1000) OUTPUT, @sBit112 VARCHAR(1000) OUTPUT,      
 @sBit113 VARCHAR(1000) OUTPUT, @sBit114 VARCHAR(1000) OUTPUT, @sBit115 VARCHAR(1000) OUTPUT, @sBit116 VARCHAR(1000) OUTPUT,      
 @sBit117 VARCHAR(1000) OUTPUT, @sBit118 VARCHAR(1000) OUTPUT, @sBit119 VARCHAR(1000) OUTPUT, @sBit120 VARCHAR(1000) OUTPUT,      
 @sBit121 VARCHAR(1000) OUTPUT, @sBit122 VARCHAR(1000) OUTPUT ,@sBit123 VARCHAR(1000) OUTPUT, @sBit124 VARCHAR(1000) OUTPUT,      
 @sBit125 VARCHAR(1000) OUTPUT, @sBit126 VARCHAR(1000) OUTPUT, @sBit127 VARCHAR(1000) OUTPUT, @sBit128 VARCHAR(1000) OUTPUT,      
 @iResposta INT OUTPUT      
AS      
BEGIN      
      
 SET NOCOUNT ON;      
      
 DECLARE  @sNSURetorno    VARCHAR(9)      
   ,@iRedeCaptura    INT      
   ,@sBit061Binario   VARCHAR(100)      
   ,@CVV      VARCHAR(4)      
   ,@cNumeroCartao    VARCHAR(16)      
   ,@sNomeCartao    VARCHAR(100)      
   ,@sCpfUsuario    VARCHAR(100)      
   ,@sHoraTransacao   VARCHAR(6)      
   ,@sReferenciaTecban   VARCHAR(6)      
   ,@cBase      CHAR(1)      
   ,@cStatusCartao    CHAR(1)      
   ,@cStatusUsuario   CHAR(1)      
   ,@cStatusConta    CHAR(1)      
   ,@cStatusCliente   CHAR(1)      
   ,@cTipoOperacao    CHAR(1)      
   ,@cPermiteSaque    CHAR(1)      
   ,@cStatusProduto   CHAR(1)      
   ,@iCodigo     INT      
   ,@iEstCodigo    INT      
   ,@iQtdColDisplay   INT      
   ,@iCliente     INT      
   ,@iCodCartao    INT      
   ,@iCodUsuario    INT      
   ,@iFranquiaUsuario   INT      
   ,@iTpoPrdCodigo    INT      
   ,@iEstabelecimento   BIGINT      
   ,@bAtualizaSenhaTransacao BIT      
   ,@bCartaoEMV    BIT      
   ,@bRetemSaldo    BIT      
   ,@dDataTransacao   DATETIME      
   ,@dDataExtrato    DATETIME      
   ,@dDataInicio    DATETIME      
   ,@dDataFim     DATETIME      
   ,@dDataVencimento   DATETIME      
   ,@dValorMaximoSaqueTerminal DECIMAL(15,2)      
   ,@sAux      VARCHAR(999)      
   ,@iAux      INT      
   /* INI: IDENTIFICAÇÃO POSITIVA */      
   ,@iIdPositiva    TINYINT      
   ,@iLayoutIdPositiva   TINYINT      
   ,@iControleCaptura   TINYINT      
   ,@iTipoDado     TINYINT      
   ,@sMsgIdPositiva1   CHAR(28)      
   ,@sMsgIdPositiva2   CHAR(28)      
   ,@cQtdTelas     CHAR(2)      
   ,@cTamanhoMascara   CHAR(2)      
   ,@sTipoMascara    VARCHAR(10)      
   ,@sMascarasIdPositiva  VARCHAR(10)      
   ,@sDadosIdPositiva   VARCHAR(32)      
   ,@bIdPositiva    BIT      
   ,@iLenMascaraIdPositiva  INT      
   /* FIM: IDENTIFICAÇÃO POSITIVA */      
   /* INI: PLANOS DE PAGAMENTO (SAQUE CDC) DESATIVAR */      
   ,@sInfoPlanos    VARCHAR(2000)      
   ,@dValorSaque    DECIMAL(15,2)      
   ,@iQtdParcelas    INT      
   /* FIM: PLANOS DE PAGAMENTO (SAQUE CDC) DESATIVAR */      
   ,@iCodigoReferencia   INT      
   ,@iCodigoTrnOriginal  INT      
      
 SET @iCodigoTrnOriginal = 0      
      
 INSERT INTO LogTransacoesTecBan (      
    Data_hora      
   ,BIT001      
   ,BIT003      
   ,BIT004      
   ,BIT007      
   ,BIT011      
   ,BIT012      
   ,BIT013      
   ,BIT022      
   ,BIT032      
   ,BIT033      
   ,BIT035      
   ,BIT037      
   ,BIT039      
   ,BIT041      
   ,BIT042      
   ,BIT052      
   ,BIT061      
   ,BIT067      
   ,BIT100      
   ,BIT120      
   )      
  VALUES      
   (GETDATE()      
   ,@sBit001      
   ,@sBit003      
   ,@sBit004      
   ,@sBit007      
   ,@sBit011      
   ,@sBit012      
   ,@sBit013      
   ,@sBit022      
   ,@sBit032      
   ,@sBit033      
   ,@sBit035      
   ,@sBit037      
   ,@sBit039      
   ,@sBit041      
   ,@sBit042      
   ,@sBit052      
   ,@sBit061      
   ,@sBit067      
   ,@sBit100      
   ,@sBit120      
   )      
      
 SET @iCodigoReferencia = SCOPE_IDENTITY()      
       
 IF (@sBit001 = '0202')      
 BEGIN      
  /* INI: CONFIRMAÇÃO DE SAQUE */      
  EXEC pr_AUT_ConfirmarSaqueBco24Horas      
     @sBit001      
   ,@sBit003      
   ,@sBit004     ,@sBit007      
   ,@sBit011      
   ,@sBit022      
   ,@sBit032      
   ,@sBit039      
   ,@sBit041      
   ,@sBit042      
   ,@sBit049      
   ,@sBit061      
   ,@sBit127      
         
  SELECT @iCodigoTrnOriginal = Codigo       
  FROM LogTransacoesTecBan WITH(NOLOCK)       
  WHERE BIT001 = '0210'       
   AND BIT003 = @sBit003       
   AND BIT004 = @sBit004      
   AND BIT007 = @sBit007       
   AND BIT041 = @sBit041       
   AND BIT042 = @sBit042      
   AND BIT127 = @sBit127      
      
  IF @iCodigoTrnOriginal > 0      
   UPDATE LogTransacoesTecBan SET CodigoReferencia = @iCodigoTrnOriginal WHERE Codigo = @iCodigoReferencia      
      
 END      
 ELSE      
 /* FIM: CONFIRMAÇÃO DE SAQUE */      
 BEGIN      
      
  SET @dValorMaximoSaqueTerminal = 1000      
  SET @dDataTransacao = GETDATE()      
  SET @sHoraTransacao = @sBit012      
  SET @sInfoPlanos = @sBit061      
  SET @bIdPositiva = 0      
  SET @iResposta  = 0      
  SET @sBit062  = ''      
  SET @sNomeCartao = ''      
  SET @sCpfUsuario = ''      
  SET @iRedeCaptura = CASE WHEN(@sBit001 IN ('0202','0610')) THEN 18      
         WHEN CONVERT(BIGINT, @sBit032) IN (58, 13, 14, 15) THEN CONVERT(BIGINT, @sBit032)      
         WHEN CONVERT(BIGINT, @sBit032) = 6142 AND @sBit001 <> '0800' THEN 10 /*Abertura de POS Walk envia Bit32 = 6142*/             
         WHEN CONVERT(BIGINT, @sBit032) NOT IN (6142, 58) AND CONVERT(BIGINT, @sBit024) IN (SELECT Numero FROM Processadora.dbo.Redes WITH(NOLOCK)) THEN CONVERT(BIGINT, @sBit024)      
       ELSE 0 END      
      
  IF (@sBit001 = '0200') SET @sBit001 = '0210'      
  IF (@sBit001 = '0600') SET @sBit001 = '0610'      
  IF (@sBit001 = '0800') SET @sBit001 = '0810'      
  IF (@sBit001 = '9000') SET @sBit001 = '9010'      
  IF (@sBit001 = '9080') SET @sBit001 = '9090'      
  IF (@sBit001 = '9180') SET @sBit001 = '9190'      
  IF (@sBit001 = '9380') SET @sBit001 = '9390'      
      
  /* LOCALIZA ESTABELECIMENTO */      
  IF (ISNUMERIC(@sBit042) = 1)      
  BEGIN      
   SET @iEstabelecimento = 7316862 -- (TECBAN)      
   SELECT @iEstCodigo = E.EstCodigo FROM Processadora.dbo.Estabelecimentos E WITH(NOLOCK) WHERE E.Numero = @iEstabelecimento      
  END      
      
  /* LOCALIZA CARTAO */      
  SET @cNumeroCartao = CASE WHEN @sBit002 IS NOT NULL AND LEN(@sBit002) = 16 THEN @sBit002 /* Número do cartão - Digitado */      
         WHEN LEN(@sBit035) >= 16 THEN LEFT(@sBit035, 16)    /* Número do cartão - Trilha 2 do cartão */      
         ELSE SUBSTRING(@sBit045, 2, 16)         /* Número do cartão - Trilha 1 do cartão */      
        END      
      
  /* VALIDA CARTAO */      
  IF (@sBit001 NOT IN ('0202','0610','0810') AND (@cNumeroCartao IS NULL OR LEN(@cNumeroCartao) <> 16))      
   SET @iResposta = 381 -- CARTAO INVALIDO      
  ELSE      
  BEGIN      
   SET @cBase   = ''      
   --SET @cPermiteSaque = ''      
   SET @iTpoPrdCodigo = 0      
      
   EXEC Processadora.dbo.pr_PROC_RetornarTipoProdutoCartao @cNumeroCartao, @cBase OUTPUT, @iTpoPrdCodigo OUTPUT, @cPermiteSaque OUTPUT      
         
   /* INI: VALIDAÇÃO DO CARTÃO */      
   IF (@iResposta = 0 AND @sBit001 NOT IN ('0202','0610','0810') AND ((@cBase = '' OR @cBase IS NULL) AND (@iTpoPrdCodigo = 0 OR @iTpoPrdCodigo IS NULL)))          SET @iResposta = 381      
   /* FIM: VALIDAÇÃO DO CARTÃO */      
  END      
      
  /* VALIDA MENSAGEM */      
  IF (@iResposta = 0 AND @sBit001 NOT IN ('0810','0610','9390') AND NOT EXISTS(SELECT 1 FROM TiposTransacoesTiposMensagens WITH(NOLOCK) WHERE Mensagem = @sBit001 AND CodTipoTransacao = CONVERT(INT, @sBit003)))      
   SET @iResposta = 384      
      
  IF (@sBit001 = '0610')      
   EXEC pr_AUT_AutorizarTransacoesSonda      
     @sBit011 -- NSU Rede      
    ,@sBit012 -- HoraLocal      
    ,@sBit013 -- DataLocal      
    ,@dDataTransacao      
  ,@sBit039 -- Resposta Sonda      
    ,@sBit042 -- Estabelecimento      
    ,@sBit125 -- NSU Trn. Original      
    ,@sBit127 -- NSU Policard      
    ,@iRedeCaptura      
      
  /* VALIDA ESTABELECIMENTO */      
  IF (@iResposta = 0 AND @iEstCodigo IS NULL AND @cBase = 'P')      
   SET @iResposta = 116      
      
  IF (@iResposta = 0 AND @sBit001 NOT IN ('0202','0610'))      
  BEGIN      
      
   EXEC pr_AUT_GerarNSUTransacoes @sNSURetorno OUTPUT,6      
       
   SET @sAux = ''      
   SET @iAux = 0      
      
   IF (@cBase = 'C')      
   BEGIN      
      
    SELECT       
       @iCliente = C.Cliente      
     , @iCodCartao = C.Codigo      
     , @iCodUsuario = C.Usuario      
     , @iFranquiaUsuario = C.Franquia      
     , @cStatusCartao = C.Status      
     , @CVV = C.CodVerificador      
     , @dDataVencimento = C.Data_Expiracao      
     , @sNomeCartao = C.Nome_Usuario      
     , @sCpfUsuario = COALESCE (U.CPF, C.CU_Cpf)      
     , @cStatusUsuario = U.Status      
     , @cStatusCliente = CL.Status      
     , @bCartaoEMV = ISNULL(c.Chip,0)      
    FROM Policard_603078.dbo.Cartao_Usuario C WITH(NOLOCK)      
    INNER JOIN Policard_603078.dbo.Usuario U WITH(NOLOCK) ON (U.Codigo = C.Usuario AND U.Franquia = C.Franquia)      
    INNER JOIN Policard_603078.dbo.Cliente CL WITH(NOLOCK) ON (CL.Codigo = C.Cliente AND CL.Franquia = C.Franquia)      
    WHERE C.CodigoCartao = @cNumeroCartao       
    AND C.StsTransferenciaUsuario IS NULL      
          
   END      
   ELSE IF (@cBase = 'P')      
   BEGIN      
      
    SELECT  @cStatusCartao    = C.Status      
      ,@cStatusConta    = CO.Status      
      ,@CVV      = C.CodVerificador      
      ,@dDataVencimento   = C.DataVencimento      
      ,@sNomeCartao    = C.Nome      
      ,@sCpfUsuario    = C.CPF      
      ,@iCodCartao    = C.CrtUsrCodigo      
      ,@iFranquiaUsuario   = 0      
      ,@bAtualizaSenhaTransacao = C.AtualizaSenhaTransacao      
      ,@bCartaoEMV    = ISNULL(c.Chip,0)      
      ,@iCliente     = P.EntCodigo      
      ,@cStatusCliente   = E.Status      
      ,@bRetemSaldo    = ISNULL(e.ReterSaldo,1)      
      ,@cStatusProduto   = TPE.Status      
    FROM Processadora.dbo.CartoesUsuarios C WITH(NOLOCK)      
    INNER JOIN Processadora.dbo.ContasUsuarios CO WITH (NOLOCK) ON (C.CntUsrCodigo = CO.CntUsrCodigo)      
    INNER JOIN Processadora.dbo.Propostas P WITH(NOLOCK) ON (P.PrpCodigo = CO.PrpCodigo)      
    INNER JOIN Processadora.dbo.Entidades E WITH(NOLOCK) ON (E.EntCodigo = P.EntCodigo)      
    INNER JOIN Processadora.dbo.TiposProdutosEntidades TPE WITH(NOLOCK) ON (E.EntCodigo = TPE.EntCodigo and CO.TpoPrdCodigo = TPE.TpoPrdCodigo)      
    WHERE C.Numero = @cNumeroCartao      
    AND ISNULL(CrtUsrCodigoTransferido,0) = 0      
      
   END      
      
   /* INI: VALIDAÇÃO PRODUTOS HABILITADOS NA REDE TECBAN */      
   IF (ISNULL(@cPermiteSaque,'N') = 'N' OR ISNULL(@iTpoPrdCodigo,0) = 0)      
    SET @iResposta = 386      
   /* FIM: VALIDAÇÃO PRODUTOS HABILITADOS NA REDE TECBAN */      
      
      
   /* INI: GERAÇÃO MENSAGENS E MONTAGEM DO BIT DA IDENTIFICAÇÃO POSITIVA */      
   IF (@iResposta = 0 AND @sBit001 = '9390')      
   BEGIN      
      
    SELECT @iIdPositiva  = 1      
      ,@iLayoutIdPositiva = 1      
      ,@iControleCaptura = 0 -- 0 > Mascarado | 2 > Aberto      
      ,@cQtdTelas   = '02'      
      ,@iTipoDado   = 7      
      
    DECLARE @TB_IdPositiva TABLE(Codigo  INT      
  ,Mensagem1 CHAR(28)      
           ,Mensagem2 CHAR(28)      
           ,Tamanho CHAR(2)      
           ,Mascara VARCHAR(10))      
      
    INSERT INTO @TB_IdPositiva      
     SELECT TOP 2 * FROM MensagensIdPositivaBco24Horas WITH(NOLOCK) WHERE CODIGO <> 5 ORDER BY NEWID() /*CVV não pode ser informado pois o cartão com chip fica acoplado ao terminal durante a transação*/      
      
    WHILE (EXISTS(SELECT COUNT(Mascara) FROM @TB_IdPositiva GROUP BY Mascara HAVING COUNT(Mascara) > 1) OR EXISTS(SELECT * FROM @TB_IdPositiva WHERE Codigo IN (3,4)))      
    BEGIN      
     DELETE FROM @TB_IdPositiva      
      
     INSERT INTO @TB_IdPositiva      
      SELECT TOP 2 * FROM MensagensIdPositivaBco24Horas WITH(NOLOCK) WHERE CODIGO <> 5 ORDER BY NEWID()      
    END      
      
    IF (LEN(@CVV) = 4 AND EXISTS(SELECT 1 FROM @TB_IdPositiva WHERE Codigo = 5))      
     UPDATE @TB_IdPositiva SET Tamanho = '04' WHERE Codigo = 5      
      
    WHILE (EXISTS(SELECT * FROM @TB_IdPositiva))      
    BEGIN      
     SELECT TOP 1      
        @iCodigo   = Codigo      
       ,@sMsgIdPositiva1 = Mensagem1      
       ,@sMsgIdPositiva2 = Mensagem2      
       ,@cTamanhoMascara = Tamanho      
       ,@sTipoMascara  = Mascara      
     FROM @TB_IdPositiva      
     ORDER BY Codigo      
      
     SET @sAux = @sAux + @sMsgIdPositiva1 + @sMsgIdPositiva2 + @cTamanhoMascara + LEFT(REPLICATE(@sTipoMascara, CONVERT(INT,@cTamanhoMascara)),CONVERT(INT,@cTamanhoMascara))      
     DELETE FROM @TB_IdPositiva WHERE Codigo = @iCodigo      
    END      
      
    SET @iAux = LEN(@iIdPositiva) + LEN(@iLayoutIdPositiva) + LEN(@iControleCaptura) + LEN(@cQtdTelas) + LEN(@iTipoDado) + LEN(@sAux)      
    SET @sBit062 = CONVERT(VARCHAR,@iIdPositiva) + CONVERT(VARCHAR,@iLayoutIdPositiva) +      
        CONVERT(VARCHAR,@iControleCaptura) + @cQtdTelas + CONVERT(VARCHAR,@iTipoDado) + @sAux      
   END      
   /* FIM: GERAÇÃO MENSAGENS E MONTAGEM DO BIT DA IDENTIFICAÇÃO POSITIVA */      
      
   IF (@iResposta = 0 AND @sBit001 IN ('0210','9010','9190'))      
   BEGIN      
        
    SELECT @sBit061Binario = dbo.f_HexadecimalParaBinario(LEFT(@sBit061,8)) -- @sBit061      
    SELECT @iQtdColDisplay = dbo.f_BinarioParaDecimal(SUBSTRING(@sBit061Binario, 16, 8))      
             
    EXEC pr_AUT_ValidaSenhaCartaoBco24Horas      
      @cNumeroCartao      
     ,@sBit052      
     ,@sMascarasIdPositiva      
     ,@sDadosIdPositiva      
     ,@cBase      
     ,@bIdPositiva      
     ,@iLenMascaraIdPositiva      
     ,@bAtualizaSenhaTransacao      
     ,@iRedeCaptura      
     ,@iResposta  OUTPUT      
           
      
    IF (@iResposta = 0)      
    BEGIN      
       
         
    IF (@sBit123 IS NOT NULL AND LTRIM(RTRIM(@sBit123)) <> '')      
     BEGIN      
      
      SET @bIdPositiva   = 1      
      SET @iLenMascaraIdPositiva = CONVERT(INT,SUBSTRING(@sBit123, 3, 2))      
      SET @sMascarasIdPositiva = SUBSTRING(@sBit123, 5, @iLenMascaraIdPositiva)      
      SET @sDadosIdPositiva  = CASE WHEN(@iLenMascaraIdPositiva < 9) THEN RIGHT(@sBit123, 16) ELSE RIGHT(@sBit123, 32) END      
     END     
      
     /* VALIDAÇÃO SENHA E IDENTIFICAÇÃO POSITIVA */      
     EXEC pr_AUT_ValidaSenhaCartaoBco24Horas      
       @cNumeroCartao      
      ,@sBit052      
      ,@sMascarasIdPositiva      
      ,@sDadosIdPositiva      
      ,@cBase      
      ,@bIdPositiva      
      ,@iLenMascaraIdPositiva      
      ,@bAtualizaSenhaTransacao      
      ,@iRedeCaptura      
      ,@iResposta  OUTPUT      
      
     /* INI: VALIDAÇÃO DO STATUS E DATA DE VENCIMENTO DO CARTÃO */      
     IF (@iResposta = 0 AND (@cStatusCartao <> 'A' OR @cStatusConta <> 'A' OR @cStatusUsuario <> 'A'))      
      SET @iResposta = 382      
      
     IF (@iResposta = 0 AND @cStatusCliente <> 'A')      
      SET @iResposta = 405      
      
     IF (@iResposta = 0 AND @cStatusProduto <> 'A' AND @cBase = 'P')      
     BEGIN      
      
      IF (@cStatusProduto = 'B')      
      BEGIN       
      
       IF (@bRetemSaldo = 1)      
        SET @iResposta = 413      
      END      
      ELSE      
       SET @iResposta = 413      
             
     END      
      
     IF (@iResposta = 0 AND LEFT(CONVERT(VARCHAR,@dDataVencimento,112),6) < LEFT(CONVERT(VARCHAR,GETDATE(),112),6))      
      SET @iResposta = 383      
     /* FIM: VALIDAÇÃO DO STATUS E DATA DE VENCIMENTO DO CARTÃO */      
      
	/* Validação black List */
	IF (@iResposta = 0)
	BEGIN
		DECLARE @iCodigoCategoria INT = 0
		DECLARE @iCodigoMotivo INT = 0
	
		SELECT TOP 1 @iCodigoCategoria = D.CodigoCategoria
			,@iCodigoMotivo = D.MotivoCodigo
		FROM Processadora.dbo.BlackListAlcada A WITH (NOLOCK)
		INNER JOIN Processadora.dbo.BlackListPFAlcada B WITH (NOLOCK) ON (B.BlackListCodigo = A.BlackListCodigo)
		INNER JOIN Processadora.dbo.BlackListMotivosAlcada D WITH (NOLOCK) ON (D.MotivoCodigo = A.MotivoCodigo)
		INNER JOIN Processadora.dbo.BlacklistCategoria E WITH (NOLOCK) ON (E.Codigo = D.CodigoCategoria)
		WHERE LTRIM(RTRIM(REPLACE(REPLACE(B.CPF, '.', ''), '-', ''))) = LTRIM(RTRIM(REPLACE(REPLACE(@sCpfUsuario, '.', ''), '-', '')))
		ORDER BY E.Prioridade
	
		IF (
				(
					@iCodigoCategoria > 0
					AND @iCodigoCategoria NOT IN (5, 10)
					)
				OR (
					@iCodigoMotivo > 0
					AND @iCodigoMotivo NOT IN (44, 52)
					)
				) /*5 - Liberado, 52 - alteração telefone*/
			SET @iResposta = 412
	END
      
     IF (@iResposta = 0)      
     BEGIN      
           
      /* INI: CONSULTA DE SALDO E EXTRATO TODOS OS PRODUTOS */      
      IF (@sBit001 = '9010')      
      BEGIN      
       SET @sBit062 = @sNomeCartao      
            
       EXEC pr_AUT_RetornarSaldoExtratoCartoes @cNumeroCartao, @cBase, @iTpoPrdCodigo, @sBit003, @iQtdColDisplay, @sBit062 OUT, @sBit120 OUT, @iResposta OUT      
      
       /* PREENCIMENTO DOS BITS PARA RETORNO DE SALDO */      
       IF (@sBit003 = '303000')      
       BEGIN      
        SET @sBit004 = '000000000000'      
        SET @sBit049 = '076' -- Moeda BR      
       END      
      END      
      /* FIM: CONSULTA DE SALDO E EXTRATO TODOS OS PRODUTOS */      
           
      
      /* INI: CONSULTA INFORMAÇÕES SAQUE */      
      IF (@sBit001 = '9190')      
      BEGIN      
       DECLARE @sMsgBit120  VARCHAR(360)      
         ,@sNroParcelas VARCHAR(40)      
         ,@sTarifaSaque VARCHAR(40)      
         ,@sIOFMonetario VARCHAR(40)      
         ,@sIOFPercent VARCHAR(40)      
         ,@sCETAnual  VARCHAR(40)      
         ,@iTamanho  INT      
         ,@iTamanhoTT INT      
      
       SET @sReferenciaTecban = LEFT (@sBit037,6)      
            
       IF (LEFT(@sBit120,3) = '222')      
       BEGIN      
        SET @iQtdParcelas = CASE WHEN @sBit067 = '' THEN 0 ELSE CONVERT(INT,@sBit067) END      
        SET @dValorSaque = CONVERT(DECIMAL(15, 2), RIGHT(@sBit120,12)) / 100      
        SET @cTipoOperacao = 'C'      
       END      
       ELSE IF (LEFT(@sBit120,3) = '009')      
       BEGIN      
        SET @iQtdParcelas = CASE WHEN @sBit067 = '' THEN 0 ELSE CONVERT(INT,@sBit067) END      
        SET @cTipoOperacao = 'P'      
      
        IF (LEN(@sBit120) = 3)      
        BEGIN      
         SET @dValorSaque = 0      
         SET @sBit062 = 'Confirmar transação?                            '      
        END      
        ELSE      
         SET @dValorSaque = CONVERT(DECIMAL(15, 2), RIGHT(@sBit120,12)) / 100      
       END      
      
       IF (@cBase = 'C')      
        EXEC   Policard_603078.dbo.pr_SQE_OperacoesSaqueBco24Horas      
          @cTipoOperacao      
         ,@iCodCartao      
         ,@iFranquiaUsuario      
         ,@dValorSaque      
         ,@iQtdParcelas      
         ,@sNSURetorno      
         ,@sBit011      
         ,@sBit042      
         ,@sBit041      
         ,@iRedeCaptura      
         ,@sBit013      
         ,@sHoraTransacao      
         ,@dValorMaximoSaqueTerminal      
         ,@sReferenciaTecban      
         ,@sInfoPlanos OUTPUT      
         ,@iResposta  OUTPUT      
       ELSE IF (@cBase = 'P')      
        EXEC pr_AUT_OperacoesSaqueBco24Horas                @cTipoOperacao      
         ,@iCodCartao      
         ,@dValorSaque      
         ,@iQtdParcelas      
         ,@sNSURetorno      
         ,@sBit011      
         ,@sBit022      
         ,@sBit042      
         ,@sBit041      
         ,@iRedeCaptura      
         ,@dDataTransacao      
         ,@sBit007      
         ,@sBit013      
         ,@sHoraTransacao      
         ,@sBit039      
         ,@sReferenciaTecban      
         ,@sInfoPlanos  OUTPUT      
         ,@iResposta   OUTPUT      
      
      
       IF (@iResposta = 0)      
       BEGIN      
        IF (LEFT(@sBit120,3) = '222')      
        BEGIN      
      
         SET @sTarifaSaque = dbo.f_FormatarValor(CONVERT(VARCHAR,CONVERT(DECIMAL(15, 2), LEFT(@sInfoPlanos,12)) / 100),'.',',')      
         SET @sIOFMonetario = '0'      
         SET @sIOFPercent = '0'      
         SET @sCETAnual  = dbo.f_FormatarValor(CONVERT(VARCHAR,CONVERT(DECIMAL(15, 2), SUBSTRING(@sInfoPlanos,27,41)) / 100),'.',',')      
         SET @sNroParcelas = 'Numero de Parcelas:                   01'      
         SET @sTarifaSaque = 'Tarifa:' + REPLICATE(' ', 40 - (LEN('Tarifa:') + LEN('R$') + LEN(@sTarifaSaque) + 1)) + 'R$ ' + @sTarifaSaque             SET @sCETAnual  = 'CET Anual:' + REPLICATE(' ', 40 - (LEN('CET Anual:') + LEN(@sCETAnual) + LEN('%') + 
  
1)) + @sCETAnual + ' %'      
         SET @sAux   = '0101360'      
         SET @sMsgBit120  = @sNroParcelas + @sTarifaSaque /*+ @sIOFMonetario + @sIOFPercent*/ + @sCETAnual      
         SET @sMsgBit120  = @sMsgBit120 + REPLICATE(' ', 360 - LEN(@sMsgBit120))      
         SET @iTamanho  = LEN(@sMsgBit120)      
         SET @iTamanhoTT  = LEN(@sAux + @sMsgBit120 + REPLICATE('0', 4 - LEN(@iTamanho)) + CONVERT(VARCHAR, @iTamanho))      
         SET @sBit120  = REPLICATE('0', 4 - LEN(@iTamanho)) + CONVERT(VARCHAR, @iTamanho) + @sAux + @sMsgBit120      
        END      
        ELSE IF (LEFT(@sBit120,3) = '009')      
        BEGIN      
              
         IF (@cBase = 'C')      
         BEGIN      
          SET @sAux   = '0101T04'      
          SET @iTamanho  = LEN(@sInfoPlanos)      
          SET @iTamanhoTT  = LEN(@sAux) + LEN(@sInfoPlanos) + LEN(RIGHT(REPLICATE('0',4) + CONVERT(VARCHAR,@iTamanho),4))      
          SET @sBit120  = RIGHT(REPLICATE('0',4) + CONVERT(VARCHAR, @iTamanho),4) + @sAux + @sInfoPlanos      
         END      
         ELSE      
         BEGIN            SET @sBit120 = ''      
          SET @iResposta = 395      
         END      
        END      
       END      
      END      
      /* FIM: CONSULTA INFORMAÇÕES SAQUE */      
      
      /* INI: EFETIVAÇÃO SAQUE */      
      IF (@sBit001 = '0210')      
      BEGIN      
      
       SET @sNomeCartao = LEFT('Nome: ' + dbo.InitCap(@sNomeCartao) + REPLICATE(' ',24),24)      
       SET @sCpfUsuario = LEFT('CPF : ' + dbo.InitCap(@sCpfUsuario) + REPLICATE(' ',24),24)      
       SET @sReferenciaTecban = LEFT (@sBit037,6)      
      
      
       IF (@iResposta = 0)      
       BEGIN      
        SET @cTipoOperacao = 'S'      
        SET @dValorSaque = CASE WHEN @sBit004 = '' THEN 0 ELSE CONVERT(DECIMAL(15, 2), @sBit004) / 100 END      
        SET @iQtdParcelas = CASE WHEN @sBit067 IN ('','00') THEN 1 ELSE CONVERT(INT, COALESCE(@sBit067,1)) END      
      
       IF (@cBase = 'C')      
        EXEC   Policard_603078.dbo.pr_SQE_OperacoesSaqueBco24Horas      
          @cTipoOperacao      
         ,@iCodCartao      
         ,@iFranquiaUsuario      
         ,@dValorSaque      
         ,@iQtdParcelas      
         ,@sNSURetorno      
         ,@sBit011      
         ,@sBit042      
         ,@sBit041      
         ,@iRedeCaptura      
         ,@sBit013      
         ,@sHoraTransacao      
         ,@dValorMaximoSaqueTerminal      
         ,@sReferenciaTecban      
         ,@sInfoPlanos OUTPUT      
         ,@iResposta  OUTPUT      
       ELSE IF (@cBase = 'P')      
        EXEC pr_AUT_OperacoesSaqueBco24Horas      
          @cTipoOperacao      
         ,@iCodCartao      
 ,@dValorSaque      
         ,@iQtdParcelas      
         ,@sNSURetorno      
         ,@sBit011      
         ,@sBit022      
         ,@sBit042      
         ,@sBit041      
         ,@iRedeCaptura      
         ,@dDataTransacao      
         ,@sBit007      
         ,@sBit013      
         ,@sHoraTransacao      
         ,@sBit039      
         ,@sReferenciaTecban      
         ,@sInfoPlanos  OUTPUT      
         ,@iResposta   OUTPUT      
      
       END      
      
       IF (@iResposta IN (298,299))      
        SET @iResposta = 391      
      
       SET @sBit038 = '' -- VERIFICAR COM TECBAN PARA OPERAÇÕES DE CARTÕES DE CRÉDITO      
      END      
      /* FIM: EFETIVAÇÃO SAQUE */      
     END      
    END      
   END      
  END      
      
  SET @iQtdParcelas = CASE WHEN @sBit067 IN ('','00') THEN 1 ELSE CONVERT(INT, COALESCE(@sBit067,1)) END      
        
      
  --IF (@iResposta IN (92,93,98,117))      
  -- SET @iResposta = 392      
      
  SELECT @sBit039 = codigo_policard FROM aut_CodigosResposta WITH(NOLOCK) WHERE Codigo = @iResposta      
      
  IF (@sBit001 = '0210' AND @sBit062 = '' AND @iResposta = 0)      
  BEGIN      
   SELECT @sBit062 = descricao_policard FROM aut_CodigosResposta WITH(NOLOCK) WHERE Codigo = @iResposta      
      
   IF (@iQtdParcelas > 1)      
    SET @sBit062 = REPLICATE(' ', 8) + dbo.InitCap(@sBit062) + REPLICATE(' ', 8) + REPLICATE(' ', 24) + @sNomeCartao + @sCpfUsuario      
   ELSE      
    SET @sBit062 = LEFT(dbo.InitCap(@sBit062) + REPLICATE(' ', 24),24) + REPLICATE(' ', 24) + @sNomeCartao + @sCpfUsuario      
  END      
      
  IF (@iResposta <> 0)      
  BEGIN      
      
   DECLARE @bSenhaCapturada BIT      
    ,@bSenhaValida BIT      
      
   IF (@sBit052 <> '')      
   BEGIN      
    SET @bSenhaCapturada = 1      
      
    IF (@bSenhaCapturada = 1 AND @iResposta <> 385)      
     SET @bSenhaValida = 1      
    ELSE      
     SET @bSenhaValida = 0      
      
   END      
   ELSE      
    SELECT @bSenhaValida = 0      
       ,@bSenhaCapturada = 0      
      
   IF (@iResposta = 384 AND @sInfoPlanos <> '') SET @sBit110 = LEFT(@sInfoPlanos,1000)      
      
   IF (@iResposta IN (388,389))      
    SELECT @sBit062 = Descricao_Tecban FROM aut_CodigosResposta WITH(NOLOCK) WHERE Codigo = @iResposta      
  ELSE      
    SELECT @sBit062 = CONVERT(VARCHAR,@iResposta) + Descricao_Tecban FROM aut_CodigosResposta WITH(NOLOCK) WHERE Codigo = @iResposta      
      
   SET @sBit062 = CASE WHEN(@sBit062 = LTRIM(RTRIM('')) OR @sBit062 IS NULL) THEN '' ELSE @sBit062 END      
      
   IF (@dValorSaque IS NULL)      
   BEGIN      
      
    IF (@sBit001 = '9190')      
    BEGIN      
      
     IF (LEFT(@sBit120,3) = '222')      
     BEGIN      
      SET @iQtdParcelas = CASE WHEN @sBit067 = '' THEN 0 ELSE CONVERT(INT,@sBit067) END      
      SET @dValorSaque = CONVERT(DECIMAL(15, 2), RIGHT(@sBit120,12)) / 100      
     END      
     ELSE IF (LEFT(@sBit120,3) = '009')      
     BEGIN      
      SET @iQtdParcelas = CASE WHEN @sBit067 = '' THEN 0 ELSE CONVERT(INT,@sBit067) END      
      
      IF (LEN(@sBit120) = 3)      
       SET @dValorSaque = 0      
      ELSE      
       SET @dValorSaque = CONVERT(DECIMAL(15, 2), RIGHT(@sBit120,12)) / 100      
     END      
    END      
    ELSE      
     SET @dValorSaque = CASE WHEN @sBit004 = '' THEN 0 ELSE CONVERT(DECIMAL(15, 2), @sBit004) / 100 END      
   END      
      
   INSERT INTO Processadora.dbo.TransacoesNegadas      
    (CodEstabelecimento      
    ,CodTipoTransacao      
    ,CodCartao      
    ,CodTipoProduto      
    ,CodTipoMeioCaptura      
    ,CodRede      
    ,CodCliente      
    ,CodFranquia      
    ,CodResposta      
    ,BaseOrigem      
    ,TipoMensagem      
    ,Valor      
    ,QtdParcelas      
    ,Data      
    ,DataGMT      
    ,DataLocal      
    ,HoraLocal      
    ,Terminal      
    ,Provedor      
    ,NSUOrigem      
    ,NSUPolicard      
    ,Senha      
    ,SenhaCapturada      
    ,SenhaValida      
    ,CartaoEMV      
    ,ModoEntrada      
    ,Migrado      
   )VALUES(      
     @iEstabelecimento      
    ,@sBit003      
    ,@iCodCartao      
    ,@iTpoPrdCodigo      
    ,0      
    ,@iRedeCaptura      
    ,@iCliente      
    ,@iFranquiaUsuario      
    ,@iResposta      
    ,@cBase      
    ,@sBit001      
    ,@dValorSaque      
    ,@iQtdParcelas      
    ,@dDataTransacao      
    ,@sBit007      
    ,@sBit013      
    ,@sBit012      
    ,@sBit041      
    ,'BCO 24 HRS'      
    ,@sBit011      
    ,@sNSURetorno      
    ,@sBit052      
    ,@bSenhaCapturada      
    ,@bSenhaValida      
    ,@bCartaoEMV      
    ,@sBit022      
    ,0         
   )      
          
  END      
      
  SET @sBit015 = ''      
  SET @sBit022 = ''      
  SET @sBit024 = ''      
  SET @sBit037 = ''      
  SET @sBit035 = ''      
  SET @sBit052 = ''      
  SET @sBit067 = ''      
  SET @sBit123 = ''      
  SET @sBit127 = dbo.f_ZerosEsquerda(@sNSURetorno,9)      
      
      
  INSERT INTO LogTransacoesTecBan (      
    CodigoReferencia      
   ,Data_hora      
   ,BIT001      
   ,BIT003      
   ,BIT004      
   ,BIT007      
   ,BIT011      
   ,BIT012      
   ,BIT013      
   ,BIT032      
   ,BIT033      
   ,BIT035      
   ,BIT037      
   ,BIT039      
   ,BIT041      
   ,BIT042      
   ,BIT052      
   ,BIT061      
   ,BIT062      
   ,BIT100      
   ,BIT120      
   ,BIT127      
   ,CodResposta)      
  VALUES      
   (@iCodigoReferencia      
   ,GETDATE()      
   ,@sBit001      
   ,@sBit003      
   ,@sBit004      
   ,@sBit007      
   ,@sBit011      
   ,@sBit012      
   ,@sBit013      
   ,@sBit032      
   ,@sBit033      
   ,@sBit035      
   ,@sBit037      
   ,@sBit039      
   ,@sBit041      
   ,@sBit042      
   ,@sBit052      
   ,@sBit061      
   ,@sBit062      
   ,@sBit100      
   ,@sBit120      
   ,@sBit127      
   ,@iResposta)             
 END      
END 