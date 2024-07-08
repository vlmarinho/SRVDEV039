/*   
--------------------------------------------------------------------------   
Nome Sistema: Autorização   
Objeto: [dbo].[pr_aut_VerificaUsuarioCliente]   
Propósito: Procedure responsável por verificar usuario e cliente.   
Autor: Cristiano Silva Barbosa - Tecnologia Policard   
--------------------------------------------------------------------------   
Data Criação: 19/02/2017   
Chamado: 2601   
--------------------------------------------------------------------------   
Data Alteração: 28/09/2017   
Chamados: 399954  / 3262   
Responsavel: Cristiano Barbosa- Policard Systems   
--------------------------------------------------------------------------   
Autor: Cristiano Silva Barbosa   
Data Criacao: 30/10/2017   
Chamado/Mudança: 440910/3388   
--------------------------------------------------------------------------   
Autor: Cristiano Silva Barbosa   
Data Criacao: 18/12/2017   
Chamado/Mudança: 457657/   
--------------------------------------------------------------------------   
Autor: Cristiano Silva Barbosa   
Data Criacao: 05/02/2018   
Chamado/Mudança: 474911   
--------------------------------------------------------------------------   
Data Alteração: 17/04/2018   
Chamados: 494467  /    
Responsavel: Cristiano Barbosa- Up Brasil   
--------------------------------------------------------------------------   
Data Alteração: 30/04/2018   
Chamados: 508483 /    
Responsavel: Cristiano Barbosa- Up Brasil   
--------------------------------------------------------------------------   
Data Alteração: 17/05/2018   
Chamados: 512551 / 4013   
Responsavel: Cristiano Barbosa- Up Brasil   
--------------------------------------------------------------------------   
Data Alteração: 24/08/2018   
Chamados: 549384/ 4359   
Responsavel: João Henrique - Up Brasil   
--------------------------------------------------------------------------   
Data Alteração: 29/11/2018   
Chamados: 581341/4666   
Responsavel: João Henrique - Up Brasil   
--------------------------------------------------------------------------   
Data Alteração: 12/12/2018   
Chamados:    
Responsavel: João Henrique - Up Brasil   
--------------------------------------------------------------------------   
Data Alteração: 16/04/2019   
Chamados: 5070/628394   
Responsavel: João Henrique - Up Brasil   
Descrição: Validação OTP   
--------------------------------------------------------------------------   
Data Alteração: 04/07/2019   
Chamados:    
Responsavel: João Henrique - Up Brasil   
Descrição: Migração Resomaq   
--------------------------------------------------------------------------   
Data Alteração: 15/07/2019   
Chamados:    
Responsavel: João Henrique - Up Brasil   
Descrição: Migração Redecard   
--------------------------------------------------------------------------   
Data Alteração: 31/07/2019   
Chamados: 671129   
Responsavel: Jeferson Borges - Up Brasil   
--------------------------------------------------------------------------   
Data Alteração: 20/08/2019   
Chamados: 676831    
Responsavel: Jeferson Borges - Up Brasil   
--------------------------------------------------------------------------   
Data Alteração: 29/08/2019   
Chamados: 670058    
Responsavel: Jeferson Borges - Up Brasil   
--------------------------------------------------------------------------   
Data Alteração: 30/12/2019   
Chamados: 1503228   
Responsavel: João Henrique - Up Brasil   
--------------------------------------------------------------------------   
Data Alteração: 03/01/2020   
Chamados: remover regra validação redecard antiga   
Responsavel: João Henrique - Up Brasil   
--------------------------------------------------------------------------   
Data Alteração: 14/04/2020   
Chamados: adicionar validação de senha de 6 digitos na Itautec    
Responsavel: João Henrique - Up Brasil   
--------------------------------------------------------------------------   
Data Alteração: 16/11/2020   
Chamados: 1630679  Adicionar adquirente Adyen e Global Payments   
Responsavel: João Henrique - Up Brasil   
--------------------------------------------------------------------------   
Data Alteração: 16/11/2020   
Chamados: 1630679  Adicionar adquirente Adyen e Global Payments PAGAMENTOS VIA APP   
Responsavel: João Henrique - Up Brasil   
--------------------------------------------------------------------------   
Data Alteracao: 05/08/2021   
Autor: João Henrique   
CH: 1741118    
Descrição: Inclusão da captura dos cartões PAT na PagSeguro   
--------------------------------------------------------------------------   
Data Alteracao: 21/09/2021   
Autor: João Henrique   
CH: 1761235   
Descrição: Ajuste de regra para validação de Serice Code e Id Verificação de todos os cartões   
--------------------------------------------------------------------------   
Data Alteracao: 18/02/2022  
Autor: João Henrique   
CH:   
Descrição: Inclusao da Rede 44 - CardSE  
--------------------------------------------------------------------------   
Data: 19/07/2022    
Autor: Adilson Pereira - Up Brasil  
Chamado: 1867627  
Descrição: Projeto Novas Regras PAT.  
--------------------------------------------------------------------------    
Data: 09/08/2022  
Autor: Adilson Pereira - Up Brasil  
Chamado: 1893271 - GMUD: 1893858   
Descrição: Correção da passagem do parâmetro iCodigoEstabelecimento para consulta  
 na WorkingKey (de INT para VARCHAR).  
--------------------------------------------------------------------------   
Data: 12/08/2022   
Autor: João Henrique dos Santos - Up Brasil   
Chamado: Validação de Fraude   
Descrição: Criação de regra para coibir recargas indevidas   
--------------------------------------------------------------------------    
Data: 30/08/2022  
Autor: Adilson Pereira - Up Brasil  
Chamado: 1903595  
Descrição: Altera tratativa de senha para o parceiro DIRECAO: considerar apenas o   
 tamanho de senha do tipo do produto (ignorar o bit 120).  
--------------------------------------------------------------------------    
Data: 08/09/2022  
Autor: Adilson Pereira - Up Brasil  
Chamado: 1843805  
Descrição: Projeto ABECS para transações NCR/Scope.  
--------------------------------------------------------------------------    
Data: 08/09/2022  
Autor: Adilson Pereira - Up Brasil  
Chamado: 1888210  
Descrição: Projeto ABECS para transações Auttar/Getnet.  
--------------------------------------------------------------------------    
Data: 08/09/2022  
Autor: Adilson Pereira - Up Brasil  
Chamado: 1907778  
Descrição: Projeto ABECS para transações SoftwareExpress/FiServ.  
--------------------------------------------------------------------------    
Data: 13/09/2022  
Autor: Adilson Pereira - Up Brasil  
Chamado: 1888212  
Descrição: Inclui verificação de existência de transação QrCode relacionada  
 quando oportuno.  
--------------------------------------------------------------------------    
Data: 30/09/2022  
Autor: Adilson Pereira - Up Brasil  
Chamado: 1918543  
Descrição: Corrigir validação de existência de transação QrCode em andamento.  
--------------------------------------------------------------------------   
Data: 08/09/2023  
Autor: Adilson Pereira - Up Brasil  
Chamado: 2053334  
Descrição: Cria trava para transações do APP, CRM ou CAE para usuários quem tenham  
 alteração de telefone ainda não confirmada pelo RH.  
--------------------------------------------------------------------------   
Data: 01/11/2023  
Autor: Adilson Pereira - Up Brasil  
Chamado: 2072942  
Descrição: Cria exceção para cartões Callink vencidos em outubro e novembro de 2023, não 
	replastificados automaticamente.
--------------------------------------------------------------------------   
Data: 27/11/2023
Autor: Adilson Pereira - Up Brasil
Chamado: 2080623
Descrição: Corrigir validação da data de expiração do cartão em transações recebidas 
	das redes E-COMMERCE, APP ADYEN e APP GLOBAL PAYMENTS, que não fazem a leitura 
	da trilha do cartão, não enviando os bit's 35 e 45. A data de expiração é informada
	no bit 14.
--------------------------------------------------------------------------   
*/   
   
CREATE PROCEDURE [dbo].[pr_aut_VerificaUsuarioCliente](   
  @cBit011     VARCHAR(6)   
 ,@cBit041     VARCHAR(8)   
 ,@cBit052     VARCHAR(16)  OUTPUT   
 ,@cBit059     VARCHAR(1000)   
 ,@cBit063     VARCHAR(1000)   OUTPUT   
 ,@cBit104     CHAR(3)   
 ,@cBit105     VARCHAR(100)   
 ,@cBit120     VARCHAR(100)   
 ,@cBaseOrigem    CHAR(1)   
 ,@cProvedor     VARCHAR(50)   
 ,@iCodigoEstabelecimento INT   
 ,@bEstabMigrado    BIT   
 ,@bSenhaCapturada   BIT   
 ,@dDataHora_Transacao  DATETIME   
 ,@iRedeNumero    INT   
 ,@nValor_Transacao   DECIMAL(15,2)   
 ,@cVencimentoCartao   VARCHAR(4)   
 ,@cServiceCode    VARCHAR(3)   
 ,@cIdVerificacao   VARCHAR(6)   
 ,@cBit123     VARCHAR(1000)  
 ,@cBit124     VARCHAR(1000)  
 ,@cBit003     VARCHAR(1000)  
 ,@cBit014		VARCHAR(1000)
 ,@cNumeroCartao    VARCHAR(16)  OUTPUT   
 ,@bSenhaValida    BIT          OUTPUT   
 ,@iCntUsrCodigo    INT    OUTPUT   
 ,@iCrtUsrCodigo    INT    OUTPUT   
 ,@iFranquiaUsuario   INT    OUTPUT   
 ,@iCliente     INT    OUTPUT   
 ,@iUsuario     INT    OUTPUT   
 ,@iPrdCodigo    INT    OUTPUT   
 ,@bCartaoEmv    BIT    OUTPUT   
 ,@iCntAppCodigo    INT    OUTPUT   
 ,@bEnviaPush    BIT    OUTPUT   
 ,@iResposta     INT    OUTPUT   
 ,@sMsgErro     VARCHAR(MAX) OUTPUT  
)   
AS   
   
BEGIN   
   
 SET NOCOUNT ON;   
    
 DECLARE @bAtualizaSenhaTransacao BIT   
     ,@bEncriptaPinBlock   BIT   
     ,@iTpoPrdCodigo    INT   
     ,@iPrpCodigo     INT   
     ,@iStatusProposta   INT   
     ,@iClienteGestaoFrota  INT   
   ,@cSenhaBase     VARCHAR(16)   
     ,@cStatusCartao    CHAR(1)   
     ,@cStatusConta    CHAR(1)   
     ,@dDataVencCartao   DATETIME   
     ,@iQtdSenhaAlterada   INT   
     ,@cIdVerificacaoCartao  VARCHAR(6)   
     ,@sNomeCliente    VARCHAR(100)   
     ,@sQuery      NVARCHAR(1000)   
     ,@iTamanhoSenha    INT   
     ,@sCPF      VARCHAR(20)   
     ,@sPinBlockPWD    VARCHAR(16)   
     ,@bNaoDesbloquearCartaoAutomatico BIT   
     ,@iOTP        BIT   
     ,@iCVV      CHAR(3)   
     ,@cNomeUsuario    VARCHAR(30)   
     ,@cANO      CHAR (2)   
     ,@cMES      CHAR (2)   
     ,@cData1      VARCHAR(4)   
     ,@cData2      VARCHAR(4)   
     ,@iTotalTrocaSenha   INT   
     ,@iTotalErroSenha   INT   
     ,@dDataErroSenha    DATETIME   
     ,@sProtocolo     VARCHAR(10)   
     ,@dDataAlteracaoSenha        DATETIME   
     ,@iValorMaximoRecarga  INT     
     ,@returnCode     INT  
     ,@returnMessage    VARCHAR(4000)  
     ,@identificadorWK   VARCHAR(64)  
     ,@loteWK      VARCHAR(64)  
     ,@countActiveLockByPhoneChange  INT = 0  
       
 /*Preenchendo a variavel da OTP para evitar possiveis falhas*/   
 SET @iOTP = 0       
   
 /*Capturando BIN do cartão para controle de erro de senha*/    
 SET @iClienteGestaoFrota = 0   
 SET @bEnviaPush = 0   
   
 IF (@cBaseOrigem = 'P')   
 BEGIN   
        
  SELECT  @bAtualizaSenhaTransacao = CU.AtualizaSenhaTransacao   
      ,@iCrtUsrCodigo    = CU.CrtUsrCodigo      
      ,@iCntUsrCodigo    = CU.CntUsrCodigo   
    ,@iTpoPrdCodigo    = CU.TpoPrdCodigo   
      ,@iPrdCodigo     = TP.PrdCodigo   
      ,@cSenhaBase     = CU.Senha   
      ,@cStatusCartao    = CU.Status   
      ,@cStatusConta    = CT.Status   
      ,@dDataVencCartao   = CU.DataVencimento   
      ,@iPrpCodigo     = CT.PrpCodigo   
      ,@bCartaoEmv        = COALESCE (CU.Chip,0)   
      ,@sCPF      = LTRIM(RTRIM (CU.CPF))   
      ,@iTamanhoSenha    = TP.TamanhoSenha   
      ,@sPinBlockPWD    = CU.PinBlock   
      ,@bEncriptaPinBlock   = CASE WHEN PinBlock IS NULL THEN 1   
             WHEN DataAlteracaoSenha <> DataAlteracaoPinBlock THEN 1   
             WHEN DataAlteracaoPinBlock IS NULL THEN 1   
            ELSE 0 END   
      ,@iCVV                       = CU.CCVV   
      ,@cNomeUsuario               = CU.Nome   
      ,@dDataAlteracaoSenha  = CU.DataAlteracaoSenha   
  FROM Processadora.dbo.CartoesUsuarios CU WITH(HOLDLOCK, ROWLOCK)   
  INNER JOIN Processadora.dbo.ContasUsuarios CT WITH (HOLDLOCK, ROWLOCK) ON (CU.CntUsrCodigo = CT.CntUsrCodigo)   
  INNER JOIN Processadora.dbo.TiposProdutos TP WITH(NOLOCK) ON (TP.TpoPrdCodigo = CU.TpoPrdCodigo)   
  WHERE CU.Numero = @cNumeroCartao    
  AND CU.FlagTransferido = 0   
       
  SELECT @iCliente = P.EntCodigo   
     ,@iStatusProposta = PrpAtivo   
     ,@bNaoDesbloquearCartaoAutomatico = ISNULL(NaoDesbloquearCartaoAutomatico,0)   
     ,@sNomeCliente = COALESCE (E.Nome,'')   
  FROM Processadora.dbo.Propostas P WITH(NOLOCK)    
  INNER JOIN Processadora.dbo.Entidades E WITH(NOLOCK) on p.entcodigo = E.entcodigo   
  INNER JOIN Processadora.dbo.ProdutosAgentesEmissores PAE WITH(NOLOCK) ON P.EntCodigo = PAE.EntCodigo   
  WHERE PrpCodigo = @iPrpCodigo   
  AND PAE.PrdCodigo = @iPrdCodigo   
  AND PAE.TpoPrdCodigo = @iTpoPrdCodigo   
     
  SET @sNomeCliente = CONVERT (VARCHAR (10),@iCliente) + '-' + @sNomeCliente   
   
   
  /* validação para unificação de produtos*/   
  IF EXISTS (select 1 from Processadora..MigracaoProdutoCartao (nolock) where CrtUsrCodigo = @iCrtUsrCodigo and CreatedAt > @dDataAlteracaoSenha)   
  BEGIN   
   SET  @iTamanhoSenha = 6    
  END    
     
  IF @iRedeNumero IN ( 27, 44)  
  BEGIN  
  
   SELECT @countActiveLockByPhoneChange = count (a.BlackListCodigo)    FROM   Processadora.dbo.BlackListAlcada A WITH(NOLOCK)       INNER JOIN   Processadora.dbo.BlackListPFAlcada B WITH(NOLOCK) ON (B.BlackListCodigo = A.BlackListCodigo)      WHERE LTRIM(
RTRIM(REPLACE(REPLACE(B.CPF,'.',''),'-',''))) = LTRIM(RTRIM(REPLACE(REPLACE(@sCPF,'.',''),'-','')))      and a.CodigoCategoria = 10 and a.MotivoCodigo = 52 and a.TipoPessoa = 'F'  
  END  
   
 END   
 ELSE IF (@cBaseOrigem = 'C')   
 BEGIN   
   
  DECLARE  @cStatus_Produto  CHAR(1)   
    ,@iTipo_SegundaVia  INT   
    ,@cStatus_Cliente  CHAR(1)   
    ,@cSGF_IdCondutor  CHAR(11)   
   
  SET @cSGF_IdCondutor = SUBSTRING(@cBit105, 23, 11)   
       
  SELECT    
    @iCrtUsrCodigo    = COALESCE(C.Codigo,0)   
   ,@iFranquiaUsuario   = COALESCE(C.Franquia,0)   
   ,@iCliente     = COALESCE(C.Cliente,0)   
   ,@cStatusCartao    = C.Status   
   ,@cSenhaBase    = C.senha   
   ,@bAtualizaSenhaTransacao = C.AtualizaSenhaTransacao   
   ,@iUsuario     = C.Usuario   
   ,@cSenhaBase    = C.senha   
   ,@dDataVencCartao   = C.Data_Expiracao   
   ,@bCartaoEmv    = COALESCE(c.Chip,0)   
   ,@cIdVerificacaoCartao  = C.ID_Verificacao   
   ,@iTipo_SegundaVia   = C.Tipo_SegundaVia   
   ,@iQtdSenhaAlterada   = ISNULL(C.QtdAlteracaoSenha,0)   
   ,@sCPF      = COALESCE(c.CU_Cpf, u.cpf)   
   ,@iTamanhoSenha    = 4   
   ,@iPrdCodigo    = 6   
   ,@sPinBlockPWD    = C.PinBlock   
   ,@bEncriptaPinBlock   = CASE WHEN PinBlock IS NULL THEN 1   
              WHEN DataAlteracaoSenha <> DataAlteracaoPinBlock THEN 1   
              WHEN DataAlteracaoPinBlock IS NULL THEN 1   
           ELSE 0 END   
   ,@iCVV                       = CCVV   
   ,@cNomeUsuario               = C.Nome_usuario   
  FROM    
    Policard_603078.dbo.Cartao_usuario C WITH(NOLOCK)   
  INNER JOIN POLICARD_603078.dbo.Usuario U WITH(NOLOCK) ON (U.Codigo = C.Usuario AND U.Franquia = C.Franquia)   
  WHERE    
   C.CodigoCartao = @cNumeroCartao   
  AND C.StsTransferenciaUsuario IS NULL   
   
  IF (@bEstabMigrado = 0)   
  BEGIN   
   
   SELECT @cStatus_Produto = ETP.STATUS   
   FROM Processadora.dbo.ESTABELECIMENTOS E WITH (NOLOCK)   
   INNER JOIN Processadora.dbo.EstabelecimentosTiposProdutos ETP WITH (NOLOCK) ON E.ESTCODIGO = ETP.ESTCODIGO   
   WHERE E.NUMERO = @iCodigoEstabelecimento    
   AND ETP.TPOPRDCODIGO = 6   
   
   IF (@cStatus_Produto <> 'A')   
    SET @iResposta = 279   
     
  END   
      
  IF (@iResposta = 0)   
  BEGIN   
   SELECT @iCliente   = CL.Codigo   
      ,@cStatus_Cliente  = CL.Status   
      ,@iClienteGestaoFrota = ISNULL(CL.ProdutoSGF,0)   
      ,@sNomeCliente  = CL.Razao_social   
   FROM  Policard_603078.dbo.Cliente CL WITH(NOLOCK)   
   WHERE CL.Codigo = @iCliente   
   AND CL.Franquia = @iFranquiaUsuario   
     
   IF (@iCliente IS NULL OR @iCliente = 0)   
    SET @iResposta =  284 /* CLIENTE INVALIDO OU INEXISTENTE */   
   ELSE    
    SET @sNomeCliente = CONVERT (VARCHAR (10),@iCliente) + '-' + @sNomeCliente   
   
  END   
    
  IF @iRedeNumero IN ( 27, 44)  
  BEGIN    
   SELECT @countActiveLockByPhoneChange = count (a.BlackListCodigo)    FROM   Processadora.dbo.BlackListAlcada A WITH(NOLOCK)       INNER JOIN   Processadora.dbo.BlackListPFAlcada B WITH(NOLOCK) ON (B.BlackListCodigo = A.BlackListCodigo)      WHERE LTRIM(
RTRIM(REPLACE(REPLACE(B.CPF,'.',''),'-',''))) = LTRIM(RTRIM(REPLACE(REPLACE(@sCPF,'.',''),'-','')))      and a.CodigoCategoria = 10 and a.MotivoCodigo = 52 and a.TipoPessoa = 'F'  
  END    
   
 END   
   
 /*-------------------------------------------------------------------------------------------  
  * Descrição: Validar se existe alteração de telefone sem confirmação do RH, para  
  * transações do APP, CRM ou CAE  
  * Codigo: 425  
  * -------------------------------------------------------------------------------------------  
  */  
   
 IF @iRedeNumero IN (27, 44) AND @countActiveLockByPhoneChange > 0  
 BEGIN   
  SET @iResposta = 425  
 END  
    
 ----------------------------------------------------------------------------------------------   
 --Trava: ValidarExistenciaCartaoUsuario   
 --Descrição : Valida a existência do cartão   
 --Código: 12   
 ----------------------------------------------------------------------------------------------   
 IF (@iResposta = 0)   
 BEGIN   
  IF (@iCrtUsrCodigo = 0 OR @iCrtUsrCodigo IS NULL OR @iCrtUsrCodigo = '')   
   SET @iResposta = 12  /* CARTAO INVALIDO - CARTAOINVALIDO*/   
 END   
   
 IF (@iResposta = 0 AND @bSenhaCapturada = 1)   
 BEGIN     
   
  BEGIN TRY -- EM CASO DE FALHA NA VALIDAÇÃO DE SENHA   
   DECLARE  @cChaveTrabalho CHAR(16)   
     ,@planoBanco  VARCHAR(16)   
     ,@planoAutorizador VARCHAR(16)   
     ,@bDecriptaHSM  BIT   
   
     SET @planoAutorizador = @cBit052   
   /* Diferenciação entre FROTA e Convenio */   
   IF (@iClienteGestaoFrota = 0 OR @iRedeNumero IN (27,44))  
    EXEC dbo.pr_DecriptaSenhaPolicard @cSenhaBase OUTPUT   
   ELSE   
    EXEC  Policard_603078.dbo.pr_SGF_AuthBuscaSenha_FormGen @cNumeroCartao, @cSGF_IdCondutor, @cSenhaBase OUTPUT   
   
   SELECT @planoBanco = SUBSTRING(@cSenhaBase, LEN (@cSenhaBase ) - @iTamanhoSenha + 1 , @iTamanhoSenha)   
   
   IF (@iRedeNumero IN (10, 13, 22, 23, 24, 25, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 38, 39, 40, 41, 42, 43,44, 46, 47, 49, 50, 52, 53, 55, 56, 58) OR @cBit104 = '003')   
   BEGIN   
       
    DECLARE @cWorkingKey VARCHAR(32)   
        ,@cWorkingKeyAux VARCHAR (32)   
       
    SET @cWorkingKey = ''   
   
        
    IF (@iRedeNumero IN (22,23,24))   
    BEGIN   
   
     IF EXISTS (SELECT 1 FROM dbo.WorkingKey WITH (NOLOCK) WHERE Terminal = @cBit041)   
     BEGIN    
     /* Modificação realizada para atender a abertura Masters*/   
      --SELECT @cWorkingKey = ChaveTrabalho FROM WorkingKey WITH (NOLOCK) WHERE terminal = @cBit041   
      SELECT top 1 @cWorkingKey = ChaveTrabalho FROM WorkingKey WITH (NOLOCK) WHERE terminal = @cBit041 order by DataCriacaoChave desc   
     END    
     ELSE   
     BEGIN   
    
      INSERT INTO WorkingKey (TERMINAL, ChaveTrabalho, DataCriacaoChave, Provedor, Estabelecimento)   
      (   
      SELECT TERMINAL, ChaveTrabalho, DataCriacaoChave, Provedor, Estabelecimento    
      FROM Autorizacao.dbo.Aut_WorkingKey WITH(NOLOCK)   
      WHERE terminal = @cBit041   
      )   
      /* Modificação realizada para atender a abertura Masters*/   
      SELECT top 1 @cWorkingKey = ChaveTrabalho FROM WorkingKey WITH (NOLOCK) WHERE terminal = @cBit041 order by DataCriacaoChave desc   
   
     END        
   
     EXEC dbo.pr_aut_DecriptaTDES @cWorkingKey OUTPUT   
            
     IF LEN (@cWorkingKey) = 32   
      SELECT @planoAutorizador = dbo.DecriptaSenha (@planoAutorizador, @cWorkingKey, @cNumeroCartao)   
   
    END   
    ELSE IF (@iRedeNumero = 25)   
    BEGIN    
        
     SET @cBit063 = CONVERT (CHAR(2),@cBit063)   
   
     SELECT @cWorkingKey  = CHAVE FROM dbo.MasterkeySysdata WITH(NOLOCK) WHERE Indice = @cBit063   
   
     IF LEN (@cWorkingKey) = 32   
      SELECT @planoAutorizador = dbo.DecriptaSenha (@planoAutorizador, @cWorkingKey, @cNumeroCartao)   
   
     SET @cBit063 = ''   
   
    END   
    ELSE IF (@cBit104 = '003' AND @cProvedor = 'PAYGO')   
    BEGIN   
        
     IF EXISTS (SELECT 1 FROM dbo.WorkingKey WITH (NOLOCK) WHERE Terminal = @cBit041 AND Estabelecimento = CONVERT(VARCHAR, ISNULL(@iCodigoEstabelecimento, 0)) )   
     BEGIN    
      SELECT @cWorkingKey = ChaveTrabalho FROM WorkingKey WITH (NOLOCK) WHERE terminal = @cBit041 AND Estabelecimento = CONVERT(VARCHAR, ISNULL(@iCodigoEstabelecimento, 0))  
     END   
     ELSE   
     BEGIN   
   
      INSERT INTO WorkingKey (TERMINAL, ChaveTrabalho, DataCriacaoChave, Provedor, Estabelecimento)   
      (   
      SELECT TERMINAL, ChaveTrabalho, DataCriacaoChave, Provedor, Estabelecimento    
      FROM Autorizacao.dbo.Aut_WorkingKey WITH(NOLOCK)   
      WHERE terminal = @cBit041 AND Estabelecimento = CONVERT(VARCHAR, ISNULL(@iCodigoEstabelecimento, 0))    
      )   
      SELECT @cWorkingKey = ChaveTrabalho FROM WorkingKey WITH (NOLOCK) WHERE terminal = @cBit041 AND Estabelecimento = CONVERT(VARCHAR, ISNULL(@iCodigoEstabelecimento, 0))    
   
     END   
             
     EXEC dbo.pr_aut_DecriptaTDES @cWorkingKey OUTPUT   
             
     IF LEN (@cWorkingKey) = 32   
      SELECT @planoAutorizador = dbo.DecriptaSenha (@planoAutorizador, @cWorkingKey, @cNumeroCartao)   
   
    END   
    ELSE IF (@iRedeNumero IN (27,44))  
    BEGIN   
       
     IF ISNUMERIC(@cBit052) = 0 /*Validação implementadada para validar a OTP*/   
     BEGIN   
        
      EXEC dbo.pr_DecriptaSenha @cNumeroCartao, @planoAutorizador OUTPUT, 'APP MOBILE'   
      SET @planoAutorizador = SUBSTRING(@planoAutorizador, 13, 4)   
     END   
     ELSE   
     BEGIN   
   
         
      EXEC pr_Aut_ValidarToken @cBit052 , @iResposta output   
   
      SET @iOTP  = 1   
     END   
   
   
    END   
    ELSE IF (@iRedeNumero IN (28,29,30))   
    BEGIN   
   
     SET @planoAutorizador = @cBit052   
     EXEC dbo.pr_DecriptaSenha @cNumeroCartao, @planoAutorizador OUTPUT, @cProvedor   
     /*Novo processo para redecard*/   
     IF (@iRedeNumero = 29 and ( ISNUMERIC(@planoAutorizador)= 0 or LEN (@planoAutorizador)<> 4))   
     BEGIN   
      SET @planoAutorizador = @cBit052   
      EXEC dbo.pr_DecriptaSenha @cNumeroCartao, @planoAutorizador OUTPUT, 'REDE_2'   
     END    
        
   
    END   
    ELSE IF @iRedeNumero in (31,32,33,34,35,36,38,39,40,41,42,43,46,47,49,50,52,53,55,56)   
    BEGIN   
      
       
     --EXEC dbo.pr_DecriptaSenha @cNumeroCartao, @planoAutorizador OUTPUT, @cProvedor   
        
     IF @iRedeNumero in (32,33,34,35,38,39,40,41,42,43,46,47,49,50,52,53)   
      SET @iRedeNumero = 32   
         
     SET @bDecriptaHSM = 1   
        
     EXEC [pr_Aut_DecriptaSenhaHSM]    
       @cNumeroCartao   
      ,@iCrtUsrCodigo   
      ,@iFranquiaUsuario   
      ,@planoAutorizador   
      ,@cBaseOrigem   
      ,@iRedeNumero   
      ,@iCodigoEstabelecimento   
      ,@cProvedor   
      ,@cBit059   
      ,@iTamanhoSenha   
      ,@planoBanco   
      ,@sPinBlockPWD   
      ,@bEncriptaPinBlock   
      ,@bSenhaValida  OUTPUT   
      ,@iResposta   OUTPUT   
   
        
    END   
       
   
    --ELSE IF(@iRedeNumero = 10 and @cNumeroCartao like '639240%') --SUBSTRING(@cNumeroCartao,1,6) = '639240') --Validação senha Resomaq   
    --BEGIN   
    -- EXEC dbo.pr_DecriptaSenha @cNumeroCartao, @planoAutorizador OUTPUT, 'RESOMAQ'   
    --END   
   
    ELSE   
     EXEC dbo.pr_DecriptaSenha @cNumeroCartao, @planoAutorizador OUTPUT   
   
   
   
   END   
   
   ELSE   
   BEGIN   
   
    IF (@cProvedor = 'SCOPEPRIVATE')   
    BEGIN    
   
     EXEC dbo.PR_AUT_DecriptaSenhaNcrScope  
      @bEncriptaPinBlock  
      ,@cBaseOrigem  
      ,@cBit052  
      ,@cBit059  
      ,@cBit123  
      ,@cBit124  
      ,@cNumeroCartao  
      ,@planoBanco  
      ,@cProvedor  
      ,@iCodigoEstabelecimento  
      ,@iCrtUsrCodigo  
      ,@iFranquiaUsuario  
      ,@iRedeNumero  
      ,@iTamanhoSenha  
      ,@sPinBlockPWD  
      ,@bDecriptaHSM OUTPUT  
      ,@bSenhaValida OUTPUT  
      ,@planoAutorizador OUTPUT  
      ,@iResposta OUTPUT  
      ,@returnCode OUTPUT  
      ,@returnMessage OUTPUT;    
        
      IF @returnCode <> 0   
       THROW 500001, @returnMessage, 1;    
  
   
    END   
    ELSE IF (@cProvedor = 'VBI')/*PROVEDOR VBI COM CHAVE 3DES*/   
    BEGIN   
   
     SET @planoAutorizador = @cBit052   
   
     EXEC dbo.pr_DecriptaSenha @cNumeroCartao, @planoAutorizador OUTPUT, @cProvedor   
   
    END    
    ELSE IF (@cProvedor = 'SOFTWARE EXPRESS') /*PROVEDOR SOFTWARE EXPRESS COM CHAVE 3DES*/   
    BEGIN   
   
     SET @planoAutorizador = @cBit052   
  
     EXEC dbo.pr_aut_DecriptaSenhaSE3DES @planoAutorizador OUTPUT, @bSenhaValida OUTPUT   
  
     IF @bSenhaValida = 0  
     BEGIN  
  
      SET @planoAutorizador = @cBit052   
  
      SET @bDecriptaHSM = 1   
   
      EXEC [pr_Aut_DecriptaSenhaHSM]    
        @cNumeroCartao   
       ,@iCrtUsrCodigo   
       ,@iFranquiaUsuario   
       ,@planoAutorizador   
       ,@cBaseOrigem   
       ,@iRedeNumero   
       ,@iCodigoEstabelecimento   
       ,@cProvedor   
       ,@cBit059   
       ,@iTamanhoSenha   
       ,@planoBanco   
       ,@sPinBlockPWD   
       ,@bEncriptaPinBlock   
       ,@bSenhaValida  OUTPUT   
       ,@iResposta   OUTPUT   
  
     END  
          
    END  
    ELSE IF @cProvedor = 'CSI_CTF' AND SUBSTRING(@cBit059, 7, 1) = '1'  
    BEGIN  
     SET @bDecriptaHSM = 1   
     SET @loteWK = SUBSTRING(@cBit059, 14, 2)  
     SET @identificadorWK = SUBSTRING(@cBit059, 16, 2)  
   
     EXEC [pr_Aut_DecriptaSenhaHSM]    
       @cNumeroCartao   
      ,@iCrtUsrCodigo   
      ,@iFranquiaUsuario   
      ,@planoAutorizador   
      ,@cBaseOrigem   
      ,@iRedeNumero   
      ,@iCodigoEstabelecimento   
      ,@cProvedor   
      ,@cBit059   
      ,@iTamanhoSenha   
      ,@planoBanco   
      ,@sPinBlockPWD   
      ,@bEncriptaPinBlock   
      ,@bSenhaValida  OUTPUT   
      ,@iResposta   OUTPUT   
      ,@identificadorWK  
      ,@loteWK  
  
    END  
    ELSE IF (@cProvedor IN ('CSI_CTF','ITAUTEC', 'ITAUTEC-SCOPE', 'DIRECAO', 'PAYGO', 'CONDUCTOR'))   
    BEGIN   
    
     IF (@cProvedor = 'CONDUCTOR')   
     BEGIN   
      SELECT @cChaveTrabalho = ChaveTrabalho   
      FROM dbo.ChaveAberturaTEF WITH(NOLOCK)   
      WHERE CONVERT(VARCHAR (10),DataCriacaoChave,120) = CONVERT(VARCHAR (10),GETDATE(),120)    
      AND Provedor = @cProvedor    
   
      SELECT @planoAutorizador = [dbo].[DecriptarItautec] (@cChaveTrabalho, @cBit052)   
     END   
   
     DECLARE @VTable TABLE (Chave VARCHAR(16), Processado BIT)   
   
     SET @cChaveTrabalho = ''   
   
     INSERT INTO @VTable   
     SELECT TOP 20 ChaveTrabalho, 0   
     FROM dbo.ChaveAberturaTEF WITH(NOLOCK)   
     WHERE Estabelecimento = @iCodigoEstabelecimento   
     AND Provedor = @cProvedor   
     AND ChaveTrabalho NOT IN ('-1','-2','') /*Chave com erro na geração*/   
     ORDER BY ChaveAberturaTefCodigo DESC   
        
     WHILE EXISTS (SELECT * FROM @VTable WHERE Processado = 0)   
     BEGIN   
   
      SELECT TOP 1 @cChaveTrabalho = Chave FROM @VTable WHERE Processado = 0   
         
      IF (@cProvedor = 'DIRECAO')   
      BEGIN   
   
       SELECT @planoAutorizador = [dbo].[DecriptografarDirecao] (@cChaveTrabalho, @cBit052, @iTamanhoSenha)      
          
      END   
      ELSE IF (@cProvedor IN ('ITAUTEC','ITAUTEC-SCOPE'))   
      BEGIN   
       SELECT @planoAutorizador = [dbo].[DecriptarItautec] (@cChaveTrabalho, @cBit052)   
          
       IF (@iTamanhoSenha < 6) /*capturar senhas 6 digitos na itautec*/   
        SET @planoAutorizador = right (@planoAutorizador,@iTamanhoSenha)   
   
      END   
      ELSE IF (@cProvedor = 'CSI_CTF')   
       SELECT @planoAutorizador = [dbo].[DecriptarCSI] (@cChaveTrabalho, @cBit052, @iTamanhoSenha)   
   
      IF (ISNUMERIC(@planoAutorizador) = 1  AND LEN(@planoAutorizador) >= 4) BREAK   
   
      UPDATE @VTable SET Processado = 1 WHERE Chave = @cChaveTrabalho   
   
     END   
    END   
   END   
   
   
   IF (@bDecriptaHSM = 1)   
   BEGIN   
    
         
    IF (@bAtualizaSenhaTransacao = 1 AND @iResposta = 0)   
    BEGIN   
   
     IF (@cBaseOrigem = 'P')   
      UPDATE Processadora.dbo.CartoesUsuarios SET AtualizaSenhaTransacao = 0 WHERE CrtUsrCodigo = @iCrtUsrCodigo   
     ELSE IF @cBaseOrigem = 'C'   
     BEGIN   
      IF (@bAtualizaSenhaTransacao = 1 AND COALESCE(@iClienteGestaoFrota, 0) <> 1)   
       EXEC  [Policard_603078].[dbo].[pr_aut_AtualizarCartao] @iCrtUsrCodigo, @iFranquiaUsuario, 0, 0   
     END   
   
    END   
    IF (@iResposta <> 0 )   
       BEGIN   
          
        --SET @iResposta =  27 /* SENHA INVALIDA - SENHA INVALID */   
        --SET @bSenhaValida = 0   
   
        SELECT @iTotalErroSenha = COUNT(CodCartao)   
          ,@dDataErroSenha = COALESCE(CONVERT(VARCHAR,Data,112), NULL)   
        FROM ControleBloqueioCartao WITH(NOLOCK)   
        WHERE CodCartao = @iCrtUsrCodigo   
          AND Franquia = @iFranquiaUsuario   
          AND BaseOrigem = @cBaseOrigem   
          AND CodResposta = @iResposta   
        GROUP BY CONVERT(VARCHAR,Data,112)   
   
        IF (@dDataErroSenha IS NOT NULL)   
        BEGIN   
         IF (CONVERT(VARCHAR,@dDataErroSenha,112) = CONVERT(VARCHAR,GETDATE(),112))   
         BEGIN   
            
          IF (@iTotalErroSenha = 4)   
          BEGIN   
             
           IF (@cStatusCartao = 'A')   
           BEGIN   
   
            DELETE FROM ControleBloqueioCartao WHERE CodCartao = @iCrtUsrCodigo AND Franquia = @iFranquiaUsuario AND BaseOrigem = @cBaseOrigem AND CodResposta = @iResposta   
   
            IF @cBaseOrigem = 'C'   
            BEGIN   
            EXEC  [Policard_603078].[dbo].[pr_aut_InserirHistorico]    
              @iFranquiaUsuario   
             ,4   
             ,@iCrtUsrCodigo   
             ,'Status'   
             ,'B'   
             ,'AUTORIZADOR'   
             ,'Bloqueado por erro de senha: 4 tentativas'   
   
                         EXEC  [Policard_603078].[dbo].[pr_aut_AtualizarCartao] @iCrtUsrCodigo, @iFranquiaUsuario, 0, 1   
            END   
   
            /*Inserindo para verificar o Historico no CRM*/   
            IF @cBaseOrigem = 'P'   
            BEGIN   
               
             UPDATE Processadora.dbo.CartoesUsuarios SET Status = 'B', NivelBloqueio = 0 , MtvSttCodigo = 21 WHERE CrtUsrCodigo = @iCrtUsrCodigo   
             INSERT INTO Processadora.dbo.LOG_Tabelas VALUES('CartoesUsuarios', @iCrtUsrCodigo, 'Status; Bloqueado por erro de senha: 4 tentativas', 'A', 'B', GETDATE(), CONVERT(VARCHAR, SYSTEM_USER),NULL)   
   
   
             EXEC Processadora.dbo.pr_CRM_InsertHistoricoAtendimento 29,'Bloqueado por excesso de tentativas com senha incorreta', @sNomeCliente, '', 'AUTORIZADOR',@cNumeroCartao   
            END   
            SET @iResposta = 95   
            
           END    
           ELSE   
            SET @iResposta = 95   
   
          END   
          ELSE   
           INSERT INTO ControleBloqueioCartao VALUES(@iCrtUsrCodigo, @iFranquiaUsuario, @cBaseOrigem, @iResposta, GETDATE())   
         END   
         ELSE   
          DELETE FROM ControleBloqueioCartao WHERE CodCartao = @iCrtUsrCodigo AND Franquia = @iFranquiaUsuario AND BaseOrigem = @cBaseOrigem AND CodResposta = @iResposta   
        END   
        ELSE   
   
         INSERT INTO ControleBloqueioCartao VALUES(@iCrtUsrCodigo, @iFranquiaUsuario, @cBaseOrigem, @iResposta, GETDATE())   
   
   
       END   
       ELSE   
       BEGIN   
   
        SET @bSenhaValida = 1 /* Senha Valida*/   
   
        IF EXISTS (SELECT 1 FROM ControleBloqueioCartao WITH(NOLOCK)   
          WHERE CodCartao = @iCrtUsrCodigo   
           AND Franquia = @iFranquiaUsuario   
           AND BaseOrigem = @cBaseOrigem   
           AND CodResposta = 27)   
        BEGIN   
         DELETE FROM ControleBloqueioCartao WHERE CodCartao = @iCrtUsrCodigo AND Franquia = @iFranquiaUsuario AND BaseOrigem = @cBaseOrigem AND CodResposta = 27   
        END   
       END   
   
   
   
   END   
   ELSE    
   BEGIN   
   
    IF (ISNUMERIC(@planoAutorizador)= 1 AND @planoAutorizador NOT LIKE '%[A-Z]%' AND LEN(@planoAutorizador) >= 4 AND @iOTP <> 1)   
    BEGIN   
       
   
     DECLARE @pBanco VARCHAR(16)   
         ,@pAutorizador VARCHAR(16)   
   
     SET @pAutorizador = @planoAutorizador   
   
     IF (LEN(@planoAutorizador) <> @iTamanhoSenha)   
     BEGIN   
      SET @iResposta = 86 /* TAM. SENHA INVAL.*/   
      SET @bSenhaValida = 0 /* Senha invalida*/   
     END   
     ELSE   
     BEGIN   
        
   
   
      IF (@cBaseOrigem = 'P')   
      BEGIN   
   
       IF (@bAtualizaSenhaTransacao = 1 AND @planoBanco <> @planoAutorizador)   
       BEGIN   
          
        SET @planoBanco = ''   
        SET @bSenhaValida = 1   
        SET @iTotalTrocaSenha = 0   
   
        SELECT @iQtdSenhaAlterada = QtdAlteracaoSenha   
        FROM Processadora.dbo.CartoesUsuarios WITH (NOLOCK)   
        WHERE CrtUsrCodigo = @iCrtUsrCodigo   
         
        SET @iQtdSenhaAlterada = @iQtdSenhaAlterada + 1   
   
        SELECT @iTotalTrocaSenha = COUNT(CrtUsrCodigo)   
        FROM ControleAlteracaoSenha WITH (NOLOCK)   
        WHERE CrtUsrCodigo = @iCrtUsrCodigo   
        AND CntUsrCodigo = @iCntUsrCodigo   
        AND Data BETWEEN GETDATE() -15 AND GETDATE()   
                
        IF (@iTotalTrocaSenha <= 2)   
        BEGIN   
   
         SELECT @planoAutorizador = autorizacao.dbo.f_ZerosEsquerda(@planoAutorizador,16)   
         EXEC dbo.pr_EncriptaSenhaPolicard @planoAutorizador OUT   
           
         UPDATE Processadora.dbo.CartoesUsuarios    
         SET Senha = @planoAutorizador   
          ,AtualizaSenhaTransacao = 0   
          ,QtdAlteracaoSenha = @iQtdSenhaAlterada   
          ,DataAlteracaoSenha = GETDATE()   
         WHERE CrtUsrCodigo = @iCrtUsrCodigo   
         
         SELECT @pBanco = Senha FROM Processadora.dbo.CartoesUsuarios WITH(NOLOCK) WHERE CrtUsrCodigo = @iCrtUsrCodigo   
         EXEC dbo.pr_DecriptaSenhaPolicard @pBanco OUTPUT   
           
         SELECT @planoBanco = SUBSTRING(@pBanco, len (@pBanco) - @iTamanhoSenha + 1 , @iTamanhoSenha)   
           
         INSERT INTO ControleAlteracaoSenha(   
           CrtUsrCodigo   
          ,CntUsrCodigo   
          ,PrdCodigo   
          ,TpoPrdCodigo   
          ,Data)   
          VALUES   
          (@iCrtUsrCodigo   
          ,@iCntUsrCodigo   
          ,@iPrdCodigo   
          ,@iTpoPrdCodigo   
          ,GETDATE()   
          )   
   
        END   
        ELSE   
        BEGIN   
   
         DELETE FROM ControleAlteracaoSenha WHERE CrtUsrCodigo = @iCrtUsrCodigo AND CntUsrCodigo = @iCntUsrCodigo   
          
         UPDATE Processadora.dbo.CartoesUsuarios SET Status = 'B', NivelBloqueio = 0 , MtvSttCodigo = 22, AtualizaSenhaTransacao = 0 WHERE CrtUsrCodigo = @iCrtUsrCodigo   
         INSERT INTO Processadora.dbo.LOG_Tabelas VALUES('CartoesUsuarios', @iCrtUsrCodigo, 'Status; Bloqueado por excesso de troca de senha', 'A', 'B', GETDATE(), CONVERT(VARCHAR, SYSTEM_USER),NULL)   
         
         EXEC Processadora.dbo.pr_CRM_InsertHistoricoAtendimento 29,'Bloqueado por excesso de trocas de senha no periodo de 15 dias', @sNomeCliente, '', 'AUTORIZADOR',@cNumeroCartao   
         SET @iResposta = 95   
          
        END   
   
       END   
       ELSE IF (@bAtualizaSenhaTransacao = 1 AND @planoBanco = @planoAutorizador)   
        UPDATE Processadora.dbo.CartoesUsuarios SET AtualizaSenhaTransacao = 0 WHERE CrtUsrCodigo = @iCrtUsrCodigo   
         
   
       IF (@iResposta = 0 AND @planoBanco <> @pAutorizador)   
       BEGIN    
         
        SET @iResposta =  27 /* SENHA INVALIDA - SENHA INVALID */   
        SET @bSenhaValida = 0   
   
        SELECT @iTotalErroSenha = COUNT(CodCartao)   
          ,@dDataErroSenha = COALESCE(CONVERT(VARCHAR,Data,112), NULL)   
        FROM ControleBloqueioCartao WITH(NOLOCK)   
        WHERE CodCartao  = @iCrtUsrCodigo   
         AND CodResposta = @iResposta   
         AND BaseOrigem = @cBaseOrigem   
        GROUP BY CONVERT(VARCHAR,Data,112)   
   
        IF (@dDataErroSenha IS NOT NULL)   
        BEGIN   
         IF (CONVERT(VARCHAR,@dDataErroSenha,112) = CONVERT(VARCHAR,GETDATE(),112))   
         BEGIN   
   
          IF (@iTotalErroSenha = 4)   
          BEGIN   
   
           IF (@cStatusCartao = 'A')   
           BEGIN   
              
            UPDATE Processadora.dbo.CartoesUsuarios SET Status = 'B', NivelBloqueio = 0 , MtvSttCodigo = 21 WHERE CrtUsrCodigo = @iCrtUsrCodigo   
            INSERT INTO Processadora.dbo.LOG_Tabelas VALUES('CartoesUsuarios', @iCrtUsrCodigo, 'Status; Bloqueado por erro de senha: 4 tentativas', 'A', 'B', GETDATE(), CONVERT(VARCHAR, SYSTEM_USER),NULL)   
            DELETE FROM ControleBloqueioCartao WHERE CodCartao = @iCrtUsrCodigo AND BaseOrigem = @cBaseOrigem AND CodResposta = @iResposta   
   
            /*Inserindo para verificar o Historico no CRM*/   
            EXEC Processadora.dbo.pr_CRM_InsertHistoricoAtendimento 29,'Bloqueado por excesso de tentativas com senha incorreta', @sNomeCliente, '', 'AUTORIZADOR',@cNumeroCartao   
   
            SET @iResposta = 95   
            
           END    
           ELSE   
            SET @iResposta = 95   
   
          END   
          ELSE   
           INSERT INTO ControleBloqueioCartao VALUES(@iCrtUsrCodigo, NULL, @cBaseOrigem, @iResposta, GETDATE())   
         END   
         ELSE   
          DELETE FROM ControleBloqueioCartao WHERE CodCartao = @iCrtUsrCodigo AND BaseOrigem = @cBaseOrigem AND CodResposta = @iResposta   
        END   
        ELSE   
         INSERT INTO ControleBloqueioCartao VALUES(@iCrtUsrCodigo, NULL, @cBaseOrigem, @iResposta, GETDATE())   
   
       END   
       ELSE   
       BEGIN   
   
        SET @bSenhaValida = 1 /* Senha Valida*/   
   
        IF EXISTS (SELECT 1 FROM ControleBloqueioCartao WITH(NOLOCK)   
          WHERE CodCartao = @iCrtUsrCodigo   
          AND BaseOrigem = @cBaseOrigem   
          AND CodResposta = 27)   
        BEGIN   
   
         DELETE FROM ControleBloqueioCartao WHERE CodCartao = @iCrtUsrCodigo AND BaseOrigem = @cBaseOrigem AND CodResposta = 27   
   
        END   
       END   
      END   
      ELSE    
      BEGIN   
    
       /* Caso sejam diferentes, é necessário validar se o cartão está marcado para atualização de senha   
       na próxima transação e não é um cartão de produto FROTA */   
       IF (@bAtualizaSenhaTransacao = 1 AND COALESCE(@iClienteGestaoFrota, 0) <> 1 AND @planoBanco <> @planoAutorizador)   
       BEGIN   
   
        SET @planoBanco = ''   
        SET @bSenhaValida = 1 /* Senha Valida*/   
        SET @iTotalTrocaSenha = 0   
   
        SELECT @iTotalTrocaSenha = COUNT(CrtUsrCodigo)   
        FROM ControleAlteracaoSenha WITH (NOLOCK)   
        WHERE CrtUsrCodigo = @iCrtUsrCodigo   
        AND UsuarioCodigo = @iUsuario   
        AND Franquia = @iFranquiaUsuario   
        AND Data BETWEEN GETDATE() -15 AND GETDATE()   
   
        IF (@iTotalTrocaSenha <= 2)   
        BEGIN   
   
         SET @iQtdSenhaAlterada = @iQtdSenhaAlterada + 1   
   
         /* Atualização de senha na próxima transação */   
         EXEC  Policard_603078.dbo.pr_aut_AtualizaSenhaProximaTransacao_FormGen @cNumeroCartao, @planoAutorizador, @planoAutorizador, @iQtdSenhaAlterada   
         SELECT @pBanco = Senha FROM  Policard_603078.dbo.Cartao_Usuario WITH(NOLOCK) WHERE CodigoCartao = @cNumeroCartao   
   
         EXEC dbo.pr_DecriptaSenhaPolicard @pBanco OUTPUT   
         SELECT @planoBanco = SUBSTRING(@pBanco, 13, 4)   
           
          
         INSERT INTO ControleAlteracaoSenha(   
           CrtUsrCodigo   
          ,UsuarioCodigo   
          ,Franquia   
          ,Data)   
         VALUES   
          (@iCrtUsrCodigo   
          ,@iUsuario   
          ,@iFranquiaUsuario   
          ,GETDATE()   
          )   
           
        END   
        ELSE   
        BEGIN   
           
         SET @iResposta = 95   
   
         DELETE FROM ControleAlteracaoSenha WHERE CrtUsrCodigo = @iCrtUsrCodigo AND Franquia = @iFranquiaUsuario   
   
         EXEC  [Policard_603078].[dbo].[pr_aut_AtualizarCartao] @iCrtUsrCodigo, @iFranquiaUsuario, 0, 1   
           
         EXEC  [Policard_603078].[dbo].[pr_aut_InserirHistorico]    
            @iFranquiaUsuario   
           ,4   
           ,@iCrtUsrCodigo   
           ,'Status'   
           ,'B'   
           ,'AUTORIZADOR'   
           ,'Bloqueado por excesso de troca de senha: 3 tentativas'   
           
         EXEC Processadora.dbo.pr_CRM_InsertHistoricoAtendimento 29,'Bloqueado por excesso de trocas de senha no periodo de 15 dias', @sNomeCliente, '', 'AUTORIZADOR',@cNumeroCartao   
   
        END   
   
       END   
       ELSE IF @iClienteGestaoFrota = 1 AND @planoBanco <> @planoAutorizador -- ATUALIZAR SENHA CONDUTORES SGF   
       BEGIN    
     
        DECLARE @AtualizaSenhaCondutor BIT   
      
        SELECT @AtualizaSenhaCondutor = AtualizarSenha    
         FROM Policard_603078.dbo.SGF_CONDUTORES WITH(NOLOCK)    
         WHERE IdentificadorTransacao = @cSGF_IdCondutor   
         AND Cliente = @iCliente   
         AND Franquia = @iFranquiaUsuario   
   
        IF @AtualizaSenhaCondutor = 1   
        BEGIN   
        UPDATE Policard_603078.dbo.SGF_Condutores   
         SET AtualizarSenha = 0   
         WHERE IdentificadorTransacao = @cSGF_IdCondutor   
         AND Cliente = @iCliente   
         AND Franquia = @iFranquiaUsuario   
   
         EXEC Policard_603078.dbo.pr_aut_AtualizaSenhaProximaTransacao_Condutor    
            @iCliente   
          , @iFranquiaUsuario   
          , @cSGF_IdCondutor   
          , @planoAutorizador   
   
         SET @planoBanco = @planoAutorizador   
        END   
       END          
       ELSE IF (@bAtualizaSenhaTransacao = 1 AND COALESCE(@iClienteGestaoFrota, 0) <> 1 AND @planoBanco = @planoAutorizador)   
        EXEC  [Policard_603078].[dbo].[pr_aut_AtualizarCartao] @iCrtUsrCodigo, @iFranquiaUsuario, 0, 0   
   
       IF (@iResposta = 0 AND @planoBanco <> @pAutorizador)   
       BEGIN   
          
        SET @iResposta =  27 /* SENHA INVALIDA - SENHA INVALID */   
        SET @bSenhaValida = 0   
   
        SELECT @iTotalErroSenha = COUNT(CodCartao)   
          ,@dDataErroSenha = COALESCE(CONVERT(VARCHAR,Data,112), NULL)   
        FROM ControleBloqueioCartao WITH(NOLOCK)   
        WHERE CodCartao = @iCrtUsrCodigo   
          AND Franquia = @iFranquiaUsuario   
    AND BaseOrigem = @cBaseOrigem   
          AND CodResposta = @iResposta   
        GROUP BY CONVERT(VARCHAR,Data,112)   
   
        IF (@dDataErroSenha IS NOT NULL)   
        BEGIN   
         IF (CONVERT(VARCHAR,@dDataErroSenha,112) = CONVERT(VARCHAR,GETDATE(),112))   
         BEGIN   
   
          IF (@iTotalErroSenha = 4)   
          BEGIN   
   
           IF (@cStatusCartao = 'A')   
           BEGIN   
   
            DELETE FROM ControleBloqueioCartao WHERE CodCartao = @iCrtUsrCodigo AND Franquia = @iFranquiaUsuario AND BaseOrigem = @cBaseOrigem AND CodResposta = @iResposta   
   
            EXEC  [Policard_603078].[dbo].[pr_aut_InserirHistorico]    
              @iFranquiaUsuario   
             ,4   
             ,@iCrtUsrCodigo   
             ,'Status'   
             ,'B'   
             ,'AUTORIZADOR'   
             ,'Bloqueado por erro de senha: 4 tentativas'   
   
   
            EXEC  [Policard_603078].[dbo].[pr_aut_AtualizarCartao] @iCrtUsrCodigo, @iFranquiaUsuario, 0, 1   
   
            /*Inserindo para verificar o Historico no CRM*/   
            EXEC Processadora.dbo.pr_CRM_InsertHistoricoAtendimento 29,'Bloqueado por excesso de tentativas com senha incorreta', @sNomeCliente, '', 'AUTORIZADOR',@cNumeroCartao   
   
            SET @iResposta = 95   
            
           END    
           ELSE   
            SET @iResposta = 95   
   
          END   
          ELSE   
           INSERT INTO ControleBloqueioCartao VALUES(@iCrtUsrCodigo, @iFranquiaUsuario, @cBaseOrigem, @iResposta, GETDATE())   
         END   
         ELSE   
          DELETE FROM ControleBloqueioCartao WHERE CodCartao = @iCrtUsrCodigo AND Franquia = @iFranquiaUsuario AND BaseOrigem = @cBaseOrigem AND CodResposta = @iResposta   
        END   
        ELSE   
   
         INSERT INTO ControleBloqueioCartao VALUES(@iCrtUsrCodigo, @iFranquiaUsuario, @cBaseOrigem, @iResposta, GETDATE())   
   
   
       END   
       ELSE   
       BEGIN   
   
        SET @bSenhaValida = 1 /* Senha Valida*/   
   
        IF EXISTS (SELECT 1 FROM ControleBloqueioCartao WITH(NOLOCK)   
          WHERE CodCartao = @iCrtUsrCodigo   
           AND Franquia = @iFranquiaUsuario   
           AND BaseOrigem = @cBaseOrigem   
           AND CodResposta = 27)   
        BEGIN   
         DELETE FROM ControleBloqueioCartao WHERE CodCartao = @iCrtUsrCodigo AND Franquia = @iFranquiaUsuario AND BaseOrigem = @cBaseOrigem AND CodResposta = 27   
        END   
       END   
      END   
     END   
    END   
    /*Alteração para travar senha que nao conseguiu decriptar*/   
    ELSE IF (@iOTP <> 1)/*OTP não segue os padrões de validação de senha*/   
    BEGIN   
         
     SET @iResposta = 65 /* TENTE DE NOVO - PROBLEMA DECRIPTA SENHA*/   
     SET @bSenhaValida = 0   
      
    END   
   END   
  END TRY   
  BEGIN CATCH   
      
   SET @iResposta = 42 /* PROBLEMA SENHA - PROBLEMA SENHA*/   
   SET @sMsgErro = ERROR_MESSAGE()   
      
  END CATCH   
   
 END   
   
 ------------------------------------------------------------------------------------------------------   
 --Nome      : Validar_Status_Cartao_usuario   
 --Descrição : Caso o campo "status" obtido na consulta da tabela cartoesusuarios seja diferente de 'A'   
 --Cod. resp.: --   
 IF (@iResposta = 0)   
 BEGIN   
   
  IF (@cBaseOrigem = 'P')   
  BEGIN   
   
   IF (ISNULL(@iStatusProposta,1) <> 1)   
    SET @iResposta = 247   
   ELSE IF (@cStatusCartao = 'B')   
   BEGIN   
   
    IF (@bNaoDesbloquearCartaoAutomatico = 0)   
    BEGIN   
   
     EXEC Processadora.dbo.pr_aut_desbloqueia_Cartao @iCrtUsrCodigo   
     SELECT @cStatusCartao = Status FROM PROCESSADORA.dbo.CartoesUsuarios WITH (NOLOCK) WHERE CrtUsrCodigo = @iCrtUsrCodigo   
     SELECT @cStatusConta = Status from PROCESSADORA.dbo.ContasUsuarios WITH (NOLOCK) WHERE CntUsrCodigo = @iCntUsrCodigo   
        
     IF (@cStatusCartao = 'A')   
      EXEC Processadora.dbo.pr_CRM_InsertHistoricoAtendimento 5,'CARTAO DESBLOQUEADO PELO AUTORIZADOR', @sNomeCliente, '', 'AUTORIZADOR',@cNumeroCartao   
   
    END   
   
   END   
     
   ------------------------------------------------------------------------------------------------------   
   --Nome      : Validar_Status_Cartao_usuario   
   --Descrição : Caso o campo "status" obtido na consulta da tabela cartoesusuarios seja diferente de 'A'   
   --Cod. resp.: --   
   ------------------------------------------------------------------------------------------------------   
   IF (@iResposta = 0 AND @cStatusCartao <> 'A')   
    SET @iResposta = 95 /* CARTAO BLOQUEADO - CARTAO CANC / BLOQ */   
   
   ----------------------------------------------------------------------------------------------   
   --Nome      : Validar_Status_Conta_Usuario   
   --Descrição : Caso o campo "Status" obtido na consulta da entidade Conta_usuario seja diferente de 'A'   
   --Cod. resp.: --   
   ----------------------------------------------------------------------------------------------   
   IF (@iResposta = 0 AND @cStatusConta <> 'A')   
    SET @iResposta = 328 /* CONTA BLOQUEADA OU CANCELADA - CONTA CANC / BLOQ */   
   
  END   
  ELSE IF (@cBaseOrigem = 'C')   
  BEGIN   
   
   IF (@iResposta = 0 AND @cStatusCartao <> 'A')   
   BEGIN   
   
    IF (@cStatusCartao = 'B')   
    BEGIN   
   
     IF (@iTipo_SegundaVia = 4 AND @iFranquiaUsuario = 80)   
     BEGIN   
   
      EXEC  [Policard_603078].[dbo].[pr_aut_InserirHistorico]    
        @iFranquiaUsuario   
        ,4   
        ,@iCrtUsrCodigo   
        ,'Status'   
        ,'A'   
        ,'AUTORIZADOR'   
        ,'CARTAO DESBLOQUEADO PELO AUTORIZADOR'   
   
      EXEC Processadora.dbo.pr_CRM_InsertHistoricoAtendimento 5,'CARTAO DESBLOQUEADO PELO AUTORIZADOR', @sNomeCliente, '', 'AUTORIZADOR',@cNumeroCartao   
   
     END   
     ELSE   
      SET @iResposta = 95  /* CARTAO BLOQUEADO */   
       
    END   
    ELSE   
     SET @iResposta = 325 /* CARTAO CANCELADO */   
   END   
  END   
 END   
   
 IF (@iResposta = 0)   
 BEGIN  
    
  IF (@iRedeNumero = 44 AND @cBit003 = '003000')  
  BEGIN  
     
   DECLARE @existsInitialTransaction BIT = 0;  
   DECLARE @initialDate DATETIME = CONVERT(DATE, @dDataHora_Transacao);  
   DECLARE @finalDate DATETIME = @initialDate + 1;   
     
   SELECT TOP 1 @existsInitialTransaction = 1  
   FROM Autorizador.dbo.TransacaoQrCode AS tqc WITH (NOLOCK)  
   WHERE tqc.TipoMensagem = '0110'  
    AND tqc.CodEstab = @iCodigoEstabelecimento  
    AND tqc.Valor = @nValor_Transacao  
    AND tqc.NSUOrigem = @cBit011  
    AND tqc.Terminal = @cBit041  
    AND tqc.DataHora >= @initialDate  
    AND tqc.DataHora < @finalDate;  
     
   IF @existsInitialTransaction = 0  
   BEGIN  
    SET @iResposta = 421; --NÃO EXISTE TRANSACAO QR_CODE RELACIONADA EM ABERTO  
   END  
  END  
   
  IF (@cBaseOrigem = 'P')   
  BEGIN   
     
   IF (@iResposta = 0)   
   BEGIN   
   
    IF EXISTS ( SELECT 1    
      FROM Processadora.dbo.Transacoes TR WITH(NOLOCK)   
      WHERE TR.CrtUsrCodigo = @iCrtUsrCodigo   
      AND TR.CodEstab = @iCodigoEstabelecimento   
      AND TR.Valor = @nValor_Transacao   
      AND TR.Terminal = @cBit041   
      AND TR.Data >= DATEADD(MINUTE, -10, GETDATE())   
      AND TR.[Status] IN ('A','P')   
      AND TR.TipoMensagem = '0200')   
     
      SET @iResposta = 288 /* TRANSACAO NAO AUTORIZADA - MESMA TRANSACAO A VISTA EM MENOS DE DEZ MINUTOS */  
        
   END  
  END   
  ELSE IF (@cBaseOrigem = 'C')   
  BEGIN   
   
   ----------------------------------------------------------------------------------------------   
   --Nome      : Validar_Existencia_de_Transacao_ASA   
   --Descrição : Verifica a existência de transação de mesmo valor para o mesmo estabelecimento,  
   --   dentro do tempo de 1 minuto, caso exista, a transação será duplicada.   
   --Cod. resp : --   
   ----------------------------------------------------------------------------------------------   
   IF (@iResposta = 0)   
   BEGIN   
   
    IF EXISTS ( SELECT 1   
       FROM  Policard_603078.dbo.Transacao_Eletronica WITH(NOLOCK)   
       WHERE Cartao_usuario = @iCrtUsrCodigo   
         AND Valor_operacao = @nValor_Transacao   
         AND CodigoEstabelecimento = @iCodigoEstabelecimento   
         AND Franquia_Usuario = @iFranquiaUsuario   
         AND Usuario = @iUsuario   
         AND Cliente = @iCliente   
         AND Data >= DATEADD(MINUTE, -10, GETDATE())   
         AND Estorno IS NULL)   
     SET @iResposta = 288 /* TRANSACAO NAO AUTORIZADA - MESMA TRANSACAO A VISTA EM MENOS DE DEZ MINUTOS */   
   
   END   
   
   ----------------------------------------------------------------------------------------------   
   --Nome      : Validar_Existencia_de_Transacao_Parcelada_ASA   
   --Descrição : Verifica a existência de transação parcelada de mesmo valor para o mesmo estabelecimento,   
   --            e mesmo cartao dentro do tempo de 1 minuto, caso exista, a transação será duplicada.   
   --Cod. resp : --   
   ----------------------------------------------------------------------------------------------   
   IF (@iResposta = 0)   
   BEGIN     
   
    IF EXISTS( SELECT 1   
       FROM  Policard_603078.dbo.Financiamento WITH(NOLOCK)   
       WHERE Cartao_usuario = @iCrtUsrCodigo   
         AND Valor_base = @nValor_Transacao   
         AND CodigoEstabelecimento = @iCodigoEstabelecimento   
         AND Franquia_Usuario = @iFranquiaUsuario   
         AND Usuario = @iUsuario   
         AND Cliente = @iCliente   
         AND Data >= DATEADD(MINUTE,-10,GETDATE())   
         AND Autorizacao_Estorno IS NULL)   
     SET @iResposta = 288 /* TRANSACAO NAO AUTORIZADA - MESMA TRANSACAO A VISTA EM MENOS DE DEZ MINUTOS */   
   END   
   
   /*Verificar se existe uma recarga em andamento em menos de 1 minuto*/   
   IF (@iResposta = 0 and @iRedeNumero IN (16,27,44))   
   BEGIN   
   
    IF EXISTS(SELECT 1   
       FROM Policard_603078.dbo.Transacao_RegistroTEF WITH(NOLOCK)   
       WHERE NumeroCartao = @cNumeroCartao   
        AND Estabelecimento = @iCodigoEstabelecimento   
        AND Valor = @nValor_Transacao   
        AND DataAutorizacao >= DATEADD(MINUTE,-10,GETDATE())   
        AND CodProcessOriginal = '599002')   
     SET @iResposta = 288 /* TRANSACAO NAO AUTORIZADA - MESMA TRANSACAO A VISTA EM MENOS DE DEZ MINUTOS */   
   END   
  END   
 END   
    
 ----------------------------------------------------------------------------------------------   
 --Nome      : Validar_DataValidade_Cartao_usuario   
 --Descrição : Caso o campo "DataVencimento" obtido na consulta a tabela cartoesusuarios seja menor a data da transação obtida como parâmetro de entrada.   
 --Cod. resp.: --   
 ----------------------------------------------------------------------------------------------   
 IF (@cBaseOrigem <> 'P' 
 	OR @iCliente NOT IN (21140,22271,57257,127634)
 	OR @iTpoPrdCodigo NOT IN (62, 63)
 	OR @dDataVencCartao < '2023-10-01'
 	OR @dDataVencCartao >= '2023-12-01'
 	OR @cStatusCartao <> 'A')
 	BEGIN 
 
		 IF (@iResposta = 0 AND @iTpoPrdCodigo NOT IN (78,79,83,84,85,86,66) AND CONVERT(VARCHAR(6),@dDataVencCartao,112) < CONVERT(VARCHAR(6), GETDATE(),112))   
		  SET @iResposta = 26 /* CARTAO VENCIDO - CARTAO VENCIDO*/   
  
  END
    
 IF (@iResposta = 0 AND LEN (@cVencimentoCartao) = 4 AND @cVencimentoCartao <> LEFT(@cNumeroCartao,4) AND @iTpoPrdCodigo <> 66) /*Cartoes Vale mais legado nao tem tratativa de data de vencimento na trilha -- 66 Cartões Natal Vencidos*/   
 BEGIN   
   
   
  SET @cData1 = CONVERT(VARCHAR(4),@dDataVencCartao,12)   
  SET @cData2 = @cData1   
  SET @cANO   = SUBSTRING(@cData1,1,2)   
 SET @cMES   = SUBSTRING(@cData1,3,2)   
  SET @cData1 = @cMES+@cANO   
     
      
  IF (@cData1 = @cVencimentoCartao)   
   SET @iResposta = 0   
  ELSE IF (@cData2 = @cVencimentoCartao)   
   SET @iResposta = 0   
  ELSE   
   SET @iResposta = 129   
   
 END   
   
 IF (@iResposta = 0 AND @cVencimentoCartao <> '') /*Caso tenha capturado a informação de vencimento, validar se foi enviado o service code*/   
 BEGIN   
   
  IF (@bCartaoEmv = 1 AND @cServiceCode <> '601')   
   SET @iResposta = 126 /* Cartao com chip e servicecode <> 601 */   
  ELSE IF (@bCartaoEmv = 0 AND @cServiceCode <> '501')   
   SET @iResposta = 127 /* Cartao sem chip e servicecode <> 501 */   
     
  IF ((exists(select 1 from BlackListCartao with(nolock) where NumeroCartao = @cNumeroCartao )) OR (SUBSTRING(@cNumeroCartao,1,6) = '639240' and @iResposta in (126,127))) /*adicionado para acompanhar falha de embossing*/   
   SET @iResposta = 0   
   
  IF(@cServiceCode = '200' and @iResposta in (126,127))   
   SET @iResposta = 0   
   
  IF  (@iResposta = 0 AND @cServiceCode in( '501','000') and @bCartaoEmv = 0  AND  @cIdVerificacao <> '')     
  BEGIN   
   
   DECLARE @cAux VARCHAR(6)   
     
   SELECT @cIdVerificacaoCartao = ID_VERIFICACAO FROM EMBOSSAMENTO.DBO.CARTOESUSUARIOS WITH (NOLOCK) WHERE NUMEROCARTAO = @cNumeroCartao    
   SET @cAux = ''   
      
   SELECT @cAux = [dbo].[DecriptIdVerificacao] (@cIdVerificacao,321)   
   SELECT @cAux = [dbo].[DecriptIdVerificacao] (@cAux,123)   
   IF (@cAux <> @cIdVerificacaoCartao AND @cIdVerificacaoCartao IS NOT NULL)   
    SET @iResposta = 132   
  END   
 END   
   
   
 IF ((@cBit063 is not null or @cBit063 <> '') and @iRedeNumero in (51,48,11) AND @iResposta = 0) /*Validação do CVV, Data vencimento, Nome Cartão e Documento nas transações via APP */   
 BEGIN   
   
 DECLARE    
  @CVV VARCHAR(6),   
  @NOME VARCHAR(30),   
  @DOC VARCHAR(30),   
  @TPDOC INT,   
  @LENDOC INT,   
  @POSITION1 INT,   
  @POSITION2 INT,   
  @POSITION3 INT   
   
     
   
   SET @POSITION1 = CHARINDEX ('*',@cBit063)   
   
   SET @POSITION2 = CHARINDEX ('*',SUBSTRING (@cBit063,@POSITION1+1, LEN(@cBit063)))   
    
   SET @POSITION3 = CHARINDEX ('*',SUBSTRING (@cBit063,@POSITION2+2, LEN(@cBit063)))   
   
   IF @POSITION3 = 0   
   set @POSITION3 = LEN(@cBit063)+6   
   
   SET @CVV = SUBSTRING(@cBit063,9,3)   
   
   
   SET @NOME = SUBSTRING(@cBit063,@POSITION2+7,@POSITION3-6)   
   
   SET @DOC = SUBSTRING(@cBit063, @POSITION3+@POSITION2+2, LEN(@cBit063))   
   SET @TPDOC = SUBSTRING(@DOC,4, 1)   
      
   SET @LENDOC = SUBSTRING(@DOC,6, 2)   
   SET @DOC = SUBSTRING(@DOC,8, @LENDOC)   
      
   
   
  SET @cData1 = CONVERT(VARCHAR(4),@dDataVencCartao,12)   
  SET @cData2 = @cData1   
  SET @cANO   = SUBSTRING(@cData1,1,2)   
  SET @cMES   = SUBSTRING(@cData1,3,2)   
  SET @cData1 = @cMES+@cANO   
   
  set @sCPF = REPLACE(replace(@sCPF,'.',''),'-','')   
   
  IF(REPLACE(@CVV,' ','') <> @iCVV  AND @iResposta = 0)   
   SET @iResposta = 415   
   
  IF((@NOME <> @cNomeUsuario or @NOME = '') AND @iResposta = 0 )   
   SET @iResposta = 416   
   
   
  IF(@DOC <> @sCPF and @DOC <> ''  AND @iResposta = 0)   
   SET @iResposta = 417   
   
   IF @iResposta = 0   
   BEGIN   
    IF (@cData1 = @cBit014)   
     SET @iResposta = 0   
    ELSE IF (@cData2 = @cBit014 )   
     SET @iResposta = 0   
    ELSE   
     SET @iResposta = 371   
   END   
   
  set @cBit063= ''   
   
 END   
   
 IF (@iResposta <> 0 AND @iClienteGestaoFrota = 1)   
 BEGIN   
   
  DECLARE  @cSGF_Descricao_Trava VARCHAR(150)   
       
  SET @cSGF_Descricao_Trava = (SELECT Descricao FROM dbo.aut_CodigosResposta with(nolock) WHERE Codigo = @iResposta)   
   
  EXEC  POLICARD_603078.DBO.pr_aut_SGF_Transacoes_Nao_Autorizadas   
    @iCrtUsrCodigo      
   ,@iUsuario       
   ,@iCliente       
   ,@iFranquiaUsuario     
   ,@iCodigoEstabelecimento   
   ,@bEstabMigrado   
   ,@cSGF_Descricao_Trava   
   ,@nValor_Transacao     
   ,@cProvedor       
   ,@cNumeroCartao      
   ,@dDataHora_Transacao    
   ,@cBit041       
   ,@cBit105       
   
 END   
   
 ----------------------------------------------------------------------------------------------   
 -- Verifica limite de valor e transação diário - Regras PAT  
 ----------------------------------------------------------------------------------------------   
 IF (@iResposta = 0)   
  EXEC Autorizador.dbo.PR_AUT_VerificaLimiteDiarioTransacoes @cNumeroCartao, @cBaseOrigem, @nValor_Transacao, @iResposta OUTPUT    
   
   
 ----------------------------------------------------------------------------------------------     
 -- Verifica limite de valor Recarga Celular - Regras Segurança   
 ----------------------------------------------------------------------------------------------    
 IF (@iResposta = 0 and @cBaseOrigem = 'C' and @iCodigoEstabelecimento = 6516041 )    
 BEGIN   
   SELECT  @iValorMaximoRecarga = ISNULL(SUM(Valor_operacao) ,0)   
    FROM Policard_603078..transacao_eletronica WITH (NOLOCK)    
    WHERE    
    usuario = @iUsuario    
    and franquia_usuario = @iFranquiaUsuario   
    and Cartao_Usuario = @iCrtUsrCodigo   
    and Cliente = @iCliente   
    and codigoestabelecimento = 6516041 -- RV Tecnologia   
    and CONVERT(VARCHAR (7),data,120) = CONVERT(VARCHAR (7),GETDATE(),120)   
   
   IF (@iValorMaximoRecarga> 100 or @nValor_Transacao + @iValorMaximoRecarga >100)   
    SET @iResposta = 420   
   
 END    
    
 IF (@iResposta in (0, 418, 419) AND (@sCPF IS NOT NULL OR @sCPF <> ''))   
 BEGIN   
   
  SELECT @iCntAppCodigo = uc.usrcntcodigo   
     ,@bEnviaPush = 1   
  FROM [Usuarios].[dbo].[UsuariosControles] uc with (NOLOCK)   
  INNER JOIN [Usuarios].[dbo].[UsuariosControlesSistemas] us with (NOLOCK) ON uc.UsrCntCodigo = us.UsrCntCodigo   
  INNER JOIN [Notificacao].[dbo].UserDevice ud with (NOLOCK) ON ud.UserId = uc.UsrCntCodigo   
  INNER JOIN [Notificacao].[dbo].UserProfile  up with (NOLOCK) ON up.UserId = ud.UserId   
  WHERE us.SstCodigo = 57   
  AND ud.Status = 1   
  AND up.AcceptTerms = 1   
  AND uc.CPF IN (@sCPF, REPLACE(REPLACE (@sCPF,'.',''),'-',''))   
   
 END   
   
END 