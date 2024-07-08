
/***************************************************************************************************************************     
--------------------------------------------------------------------------                   
Nome Sistema: Site Policard                   
Nome Procedure: [dbo].[pr_EST_RetornaRedeCredenciada]                   
Propósito: Retornar estabelecimentos credenciadados à Policard.                   
--------------------------------------------------------------------------                   
Criada por: José Eustaquio Medeiros                      
Data: 07/03/2013                      
Chamado:26636                   
--------------------------------------------------------------------------                   
Data alteração: 27/07/2017                   
Chamado: 406269 / 3082                   
--------------------------------------------------------------------------                   
Data de alteração: 17/10/2017                 
Objetivo: Incluir campo guia Online                 
CH: 427315 / 3325                 
Autor: Karoline Knychala - P&D                 
--------------------------------------------------------------------------                 
Data de alteração: 16/11/2017                 
Objetivo: Incluir latitude e longitude para conseguir disponibilizar a rede credenciada no mapa do Google                 
CH: 444315 / 3430                 
Autor: Karoline Knychala - P&D                 
--------------------------------------------------------------------------                 
Data de alteração: 09/04/2018                 
Objetivo: Duplo convívio com acquirerNew               
CH: 44132               
Autor: Kyros               
--------------------------------------------------------------------------                 
Alterado por: Karoline Knychala               
Motivo: Subindo  2º entrega AcquireNew da Kyros               
Data: 25/05/2018                 
Chamado: 514560                
--------------------------------------------------------------------------           
Data de alteração: 17/08/2018                 
Objetivo: Restruturação de todas as consultas           
CH:543861/4329           
Autor: Felipe Marcelo Silva           
--------------------------------------------------------------------------            
Data de alteração: 11/09/2018                 
Objetivo: Adicinado a checagem de variáveis nulas.           
CH:549424/--           
Autor: Felipe Marcelo Silva           
--------------------------------------------------------------------------            
Data de alteração: 03/01/2019           
Objetivo: Permitir apenas estabelecimentos com POS Up ou TEF retornar para            
          consulta do produto Frota.           
CH: 556207/--           
Autor: Jeferson Martins Borges     
 
select getdate()       
--------------------------------------------------------------------------            
----------------------------------------------------------------------------------------------------------------------           
-- DATA ALTERACAO: 18/02/2018             
-- AUTOR: Karoline Knychala           
-- Objetivo: Projeto DEFN_536500- SWB           
-- Chamado/Mud.: 597775/           
----------------------------------------------------------------------------------------------------------------------          
  -- DATA ALTERACAO: 28/03/2019            
-- AUTOR: Victor Moraes / Jonicleber Galvão       
-- Objetivo: Inclusão do -4, que é a correspondente bancário       
----------------------------------------------------------------------------------------------------------------------          
----------------------------------------------------------------------------------------------------------------------           
-- DATA ALTERACAO: 06/05/2019             
-- AUTOR: ELIVANDO/VICTOR          
-- Objetivo:          
-- Chamado/Mud.: 635687     
----------------------------------------------------------------------------------------------------------------------        
--@CodigoProduto = 0 Todos os Produtos       
--@CodigoProduto = -4 Correspondente Bancário       
--@CodigoProduto = 5 Alimentação       
--@CodigoProduto = 6 Convênio       
--@CodigoProduto = 24 Refeição       
--@CodigoProduto = 59 Frete Eletrônico       
--@CodigoProduto = 60 Gestão de Frota       
--@CodigoProduto = 64 Cultura Up Brasil   
--@CodigoProduto = 65 Viagem     
--@CodigoProduto = 66 NATAL       
--@CodigoProduto = 67 Presente       
--@CodigoProduto = 68 Premiação       
--@CodigoProduto = 73 Combustível Up Brasil      
--@CodigoProduto = 95 Up Valemais       
       
EXEC pr_EST_RetornaRedeCredenciada        
 @Latitude = -30.0346471       
    ,@Longitude = -51.217658400000005       
    ,@Radius =50 -- KM       
    ,@CodigoProduto = 65       
    ,@NomeEstabelecimento = null       
     
----------------------------------------------------------------------------------------------------------------------           
-- DATA ALTERACAO: 24/05/2019             
-- AUTOR: Lígia S. Mendes          
-- Objetivo: Ajustar a pesquisa quando o filtro é por cidade.         
-- Chamado/Mud.: 640523     
----------------------------------------------------------------------------------------------------------------------      
 
----------------------------------------------------------------------------------------------------------------------           
-- DATA ALTERACAO: 11/02/2019             
-- AUTOR: Marcos Vinicius Carvalho Rosa        
-- Objetivo: Retornar o codigo do ramo de atividade para o novo portal do usuario       
-- Chamado/Mud.:   
---------------------------------------------------------------------------------------------------------------------- 
-- DATA ALTERACAO: 23/04/2021            
-- AUTOR: Julio Santos       
-- Objetivo: Retornar um bit com nome QRCod, ele será marcado toda vez que um estabelecimento 
	estiver com o Cielo habilitado e/ou quando estiver com o campo MPOS da tabela estabelecimento marcado.      
-- Chamado/Mud.:   
 
---------------------------------------------------------------------------------------------------------------------- 
-- DATA ALTERACAO: 11/10/2021        
-- AUTOR: KAROLINE KNYCHALA ALMEIDA
-- Objetivo: Incluindo regra de meio de captura para cartões GESTÃO DE FROTA, COMBUSTIVEL E UP GO estabelecimentos Postos
-- e GESTÃO DE FROTA não pode ser grande rede
-- Chamado/Mud.: 1765955
----------------------------------------------------------------------------------------------------------------------  
-- DATA ALTERACAO: 26/10/2021        
-- AUTOR: KAROLINE KNYCHALA ALMEIDA
-- Objetivo: Opção QRCode apresentar apenas quando estiver marcado MPOS ou possuir transação Cielo nos ultimos 3 meses
-- Chamado/Mud.: 1765955
----------------------------------------------------------------------------------------------------------------------  
-- DATA ALTERACAO: 24/03/2023        
-- AUTOR: KAROLINE KNYCHALA ALMEIDA
-- Objetivo: Criar grupo para produto Up Valemais
-- Chamado/Mud.: 1986138
------------------------------------------------------------------------------------------------------------ 
-- DATA ALTERACAO: 30/08/2023
-- AUTOR: KAROLINE KNYCHALA ALMEIDA
-- Objetivo: Retirar Franquia da regra para aparecer no APP
--Reduzir o prazo para consulta do APP de 90 dias para 60 dias
--Acrescentar na regra de subir Grandes Redes somente se o TEF estiver habilitado
--Retirar a apresentação de QRCode quando possuir transação Cielo nos ultimos 3 meses
-- Chamado/Mud.:2047527  
***************************************************************************************************************************/     
--Pr_Est_Retornaredecredenciada  '-18.9203685',	'-48.2812125',1,60,''--113910
CREATE PROCEDURE [dbo].[pr_EST_RetornaRedeCredenciada_2]     
                 @Latitude            FLOAT     
               , @Longitude           FLOAT     
               , @Radius              FLOAT     
               , @CodigoProduto       INT     
               , @NomeEstabelecimento VARCHAR(250)
               , @NumeroCartao        VARCHAR(32) = NULL
               , @BaseOrigem          CHAR(1) = NULL
AS     
     BEGIN     
         SET ANSI_NULLS, QUOTED_IDENTIFIER, CONCAT_NULL_YIELDS_NULL, ANSI_WARNINGS, ANSI_PADDING ON;     
         BEGIN         
     
/******************************************************************************************     
*************************** DECLARAÇÃO DE VARIAVEIS E TABELAS ***************************       
******************************************************************************************/     
     
             DECLARE @GestaoFrota CHAR(1) = NULL
             	,@CntUsrCodigo BIGINT
             	,@EntCodigo INT
             DECLARE @TEMP TABLE     
(     
                                 Codigo    INT     
                               , Cnpj      VARCHAR(18)     
                               , Nome      VARCHAR(250)     
                               , Estado    CHAR(2)     
                               , Cidade    VARCHAR(250)     
                               , Endereco  VARCHAR(900)     
                               , Bairro    VARCHAR(250)     
                               , Cep       VARCHAR(10)     
                               , Ramo      VARCHAR(500) 
							   , CodRamoAtividade INT 
                               , Distancia FLOAT     
                               , Latitude  FLOAT     
                               , Longitude FLOAT 
							   , QRcode				Bit 
)     
             DECLARE @TEMP_FONE TABLE     
(     
                                      Codigoestabelecimento INT     
                                  , Telefone              VARCHAR(50)     
)     
             DECLARE @TEMP_PRODUTO TABLE     
(     
                                         Codigoproduto INT     
                                       , Nomeproduto   VARCHAR(250)     
)

	DECLARE @LISTA_CODESTAB_AUXILIAR TABLE (
		CodigoEstabelecimento INT
	)
       
/*************************************************************************     
*************************** AGRUPAR PRODUTOS ***************************       
*************************************************************************/     
     
             IF ISNULL(@CodigoProduto, 0) IN (-4, 0) -- Todos os Produtos /Correspondente Bancário       
             BEGIN     
                 INSERT INTO @TEMP_PRODUTO     
                        SELECT     
                               Tpoprdcodigo     
                             , Nome     
                               FROM  Processadora.Dbo.Tiposprodutos Tp WITH (Nolock)     
                               WHERE Status = 'A'     
                                     AND Empresaorigem IS NOT NULL     
             END     
             IF @CodigoProduto = 5 -- Alimentação       
             BEGIN     
                 INSERT INTO @TEMP_PRODUTO     
                        SELECT     
                               Tpoprdcodigo     
                             , Nome     
                               FROM  Processadora.Dbo.Tiposprodutos Tp WITH (Nolock)     
                               WHERE Tp.Tpoprdcodigo IN     
								(62 -- Alimentação Up Brasil       
								, 78 -- UP PLAN Alimentação       
								, 80 -- Vale Mais Alimentação       
								, 82 -- Cesta Básica Up Brasil       
								, 87 -- Alimentação Up Não Pat       
							--	, 95 -- Up Valemais        
								)     
             END 
			 IF @CodigoProduto = 95 -- Up Valemais       
             BEGIN     
                 INSERT INTO @TEMP_PRODUTO     
                        SELECT     
                               Tpoprdcodigo     
                             , Nome     
                               FROM  Processadora.Dbo.Tiposprodutos Tp WITH (Nolock)     
                               WHERE Tp.Tpoprdcodigo IN     
								(95 -- Up Valemais        
								)     
             END 
             IF @CodigoProduto = 6 -- Convênio       
      BEGIN     
                 INSERT INTO @TEMP_PRODUTO     
                        SELECT     
                               Tpoprdcodigo     
                             , Nome     
                               FROM  Processadora.Dbo.Tiposprodutos Tp WITH(Nolock)     
                               WHERE Tp.Tpoprdcodigo IN (6 -- Convênio (UP GO)       
                        )     
             END     
             IF @CodigoProduto = 24 -- Refeição       
             BEGIN     
                 INSERT INTO @TEMP_PRODUTO     
                        SELECT     
                               Tpoprdcodigo     
                             , Nome     
                               FROM  Processadora.Dbo.Tiposprodutos Tp WITH (Nolock)     
                               WHERE Tp.Tpoprdcodigo IN     
								(63 -- Refeição Up Brasil       
                               , 72 -- Voucher Refeição Up Brasil       
                               , 79 -- UP PLAN Refeição       
                               , 81 -- Vale Mais Refeição       
                               , 88 -- Refeição Up Não Pat       
)     
             END     
             IF @CodigoProduto = 59 -- Frete Eletrônico       
             BEGIN     
                 INSERT INTO @TEMP_PRODUTO     
                        SELECT     
                               Tpoprdcodigo     
                             , Nome     
                               FROM  Processadora.Dbo.Tiposprodutos Tp WITH (Nolock)     
                               WHERE Tp.Tpoprdcodigo IN(59) -- Frete Eletrônico                   
             END     
             IF @CodigoProduto = 60 -- Gestão de Frota       
             BEGIN     
                 INSERT INTO @TEMP_PRODUTO     
                        SELECT     
                               Tpoprdcodigo     
                             , Nome     
                               FROM  Processadora.Dbo.Tiposprodutos Tp WITH (Nolock)     
                               WHERE Tp.Tpoprdcodigo IN     
								(6 -- Convênio       
                               , 60 -- Gestão de Frota       
     , 94 -- Up Valemais Gestão de Frota       
)     
                 SET @GestaoFrota = 'S'     
             END     
             IF @CodigoProduto = 64 -- Cultura Up Brasil       
             BEGIN     
                 INSERT INTO @TEMP_PRODUTO     
                        SELECT     
                               Tpoprdcodigo     
                             , Nome     
                               FROM  Processadora.Dbo.Tiposprodutos Tp WITH (Nolock)     
                               WHERE Tp.Tpoprdcodigo IN(64)  -- Cultura Up Brasil       
             END     
             IF @CodigoProduto = 65 -- Viagem       
             BEGIN     
                 INSERT INTO @TEMP_PRODUTO     
                        SELECT     
                               Tpoprdcodigo     
                             , Nome     
                               FROM  Processadora.Dbo.Tiposprodutos Tp WITH(Nolock)   
                               WHERE Tp.Tpoprdcodigo IN (65 -- Viagem        
                        )     
             END   
             IF @CodigoProduto = 66 -- NATAL       
             BEGIN     
                 INSERT INTO @TEMP_PRODUTO     
                        SELECT     
                               Tpoprdcodigo     
                             , Nome     
                               FROM  Processadora.Dbo.Tiposprodutos Tp WITH (Nolock)     
                               WHERE Tp.Tpoprdcodigo IN     
								(66 -- Natal Up Brasil       
                               , 90 --Vale Mais Natal       
								) 
             END     
             IF @CodigoProduto = 67 -- Presente       
             BEGIN     
                 INSERT INTO @TEMP_PRODUTO     
                        SELECT     
                               Tpoprdcodigo     
                             , Nome     
                               FROM  Processadora.Dbo.Tiposprodutos Tp WITH (Nolock)     
                               WHERE Tp.Tpoprdcodigo IN     
								(67 -- Presente Up Brasil       
                               , 85 -- UP PLAN Presente       
                               , 89     
								) -- VALE MAIS PRESENTE              
             END     
             IF @CodigoProduto = 68 -- Premiação       
             BEGIN     
                 INSERT INTO @TEMP_PRODUTO     
                        SELECT     
								Tpoprdcodigo     
                             ,	Nome     
								FROM  Processadora.Dbo.Tiposprodutos Tp WITH (Nolock)     
								WHERE Tp.Tpoprdcodigo IN     
								(68 -- Premiação Up Brasil       
                               , 84     
								) -- UP PLAN Premiação       
             END     
             IF @CodigoProduto = 73 -- Combustível Up Brasil       
             BEGIN     
                 INSERT INTO @TEMP_PRODUTO     
                        SELECT     
                               Tpoprdcodigo     
                             , Nome     
                               FROM  Processadora.Dbo.Tiposprodutos Tp WITH (Nolock)     
                               WHERE Tp.Tpoprdcodigo IN     
								(73 -- Combustível Up Brasil       
                               , 83 -- UP PLAN Combustível       
                               , 91     
								) -- VALE MAIS COMBUSTIVEL       
             END       
       
/**********************************************************************************************************     
*************************** BUSCA DE ESTABELECIMENTO DE ACORDO COM OS FILTROS ***************************       
**********************************************************************************************************/     
     
             INSERT INTO @TEMP     
                    SELECT     
                           E.Numero AS Codigo     
                         , E.Cnpj     
                         , LTRIM(RTRIM(ISNULL(E.Nome, E.Razaosocial))) AS Nome     
                         , LTRIM(RTRIM(E.Estado)) AS Estado     
, LTRIM(RTRIM(E.Cidade)) AS Cidade     
                         , LTRIM(RTRIM(E.Endereco)) AS Endereco     
                         , LTRIM(RTRIM(E.Bairro)) AS Bairro     
                         , LTRIM(RTRIM(E.Cep)) AS Cep     
                         , LTRIM(RTRIM(Ra.Nome)) AS Ramo 
                         , E.RamAtvCodigo AS CodRamoAtividade 
                         , 6371 * ACOS(CASE     
                                           WHEN COS(RADIANS(@Latitude)) * COS(RADIANS(E.Lat)) * COS(RADIANS(E.Lng) - RADIANS(@Longitude)) + SIN(RADIANS(@Latitude)) * SIN(RADIANS(E.Lat)) > 1 THEN 1     
                                           WHEN COS(RADIANS(@Latitude)) * COS(RADIANS(E.Lat)) * COS(RADIANS(E.Lng) - RADIANS(@Longitude)) + SIN(RADIANS(@Latitude)) * SIN(RADIANS(E.Lat)) < 0 THEN 0     
                                           ELSE COS(RADIANS(@Latitude)) * COS(RADIANS(E.Lat)) * COS(RADIANS(E.Lng) - RADIANS(@Longitude)) + SIN(RADIANS(@Latitude)) * SIN(RADIANS(E.Lat))     
                                       END) AS Distancia     
                         , Lat AS Latitude     
                         , Lng AS Longitude 
						 , (CASE     
                                --WHEN exists (Select 1 from UltimaTransacaoAdquirente u with (nolock) where u.EstCodigo = e.EstCodigo and u.data >= dateadd(day,-60,getdate()) )  THEN 1     
                                WHEN (Select MPOS from estabelecimentos where EstCodigo = e.EstCodigo ) >= 1 THEN 1     
                                ELSE 0     
                             END) As QRcode 
                           FROM  Processadora.Dbo.Estabelecimentos E WITH (Nolock)     
                           INNER JOIN Processadora.Dbo.Ramosatividades Ra WITH (Nolock) ON E.Ramatvcodigo = Ra.Ramatvcodigo     
                           WHERE E.Status = 'A'     
                                 AND E.Guiaonline = 'S'     
                                 AND E.Lat IS NOT NULL     
                                 AND E.Lat BETWEEN @Latitude - @Radius / 111.045 AND @Latitude + @Radius / 111.045     
                                 AND E.Lng BETWEEN @Longitude - @Radius / (111.045 * COS(RADIANS(@Latitude))) AND @Longitude + @Radius / (111.045 * COS(RADIANS(@Latitude)))     
                                 AND NOT EXISTS     
                                                (     
                                                SELECT     
														*     
														FROM  Acquirer.Dbo.Historicomigracaoestabelecimento H WITH (Nolock)     
														WHERE E.Numero = H.Codigoestabelecimento     
                                                )     
                                 AND EXISTS     
                                            (     
                                            SELECT     
                                                   *     
                                                   FROM  Processadora.Dbo.Estabelecimentostiposprodutos Etp WITH (Nolock)     
                                                   INNER JOIN @TEMP_PRODUTO Tp ON Etp.Tpoprdcodigo = Tp.Codigoproduto     
                                                                                  AND Etp.Status = 'A'     
                                                                                  AND Etp.Guiaonlineprd = 1     
                                                   WHERE Etp.Estcodigo = E.Estcodigo     
                                            )     
                    UNION ALL     
                    SELECT     
                           E.Codigoestabelecimento AS Codigo     
                         , E.Cnpj   		 
                         , LTRIM(RTRIM(ISNULL(E.Nome, E.Razaosocial))) AS Nome     
                         , LTRIM(RTRIM(Ee.Uf)) AS Estado     
                         , LTRIM(RTRIM(Ee.Cidade)) AS Cidade     
                         , LTRIM(RTRIM(Ee.Logradouro+', '+Ee.Numero+','+Ee.Complemento)) AS Endereco     
                         , LTRIM(RTRIM(Ee.Bairro)) AS Bairro     
   , LTRIM(RTRIM(Ee.Cep)) AS Cep     
                         , LTRIM(RTRIM(Cn.Descricao)) AS Ramo 
                         , ISNULL(Cnaedepara.CodigoRamoAtividade, 0) AS CodRamoAtividade 
                         , 6371 * ACOS(CASE     
                                           WHEN COS(RADIANS(@Latitude)) * COS(RADIANS(E.Lat)) * COS(RADIANS(E.Lng) - RADIANS(@Longitude)) + SIN(RADIANS(@Latitude)) * SIN(RADIANS(E.Lat)) > 1 THEN 1     
                                           WHEN COS(RADIANS(@Latitude)) * COS(RADIANS(E.Lat)) * COS(RADIANS(E.Lng) - RADIANS(@Longitude)) + SIN(RADIANS(@Latitude)) * SIN(RADIANS(E.Lat)) < 0 THEN 0     
                                           ELSE COS(RADIANS(@Latitude)) * COS(RADIANS(E.Lat)) * COS(RADIANS(E.Lng) - RADIANS(@Longitude)) + SIN(RADIANS(@Latitude)) * SIN(RADIANS(E.Lat))     
                                       END) AS Distancia     
                         , Lat AS Latitude     
                         , Lng AS Longitude  
						 , (CASE     
                                --WHEN (Select habilitadoCielo from estabelecimentos where EstCodigo = e.Codigoestabelecimento ) >= 1 THEN 1     
                                WHEN (Select MPOS from estabelecimentos where EstCodigo = e.Codigoestabelecimento ) >= 1 THEN 1     
                                ELSE 0     
                             END) As QRcode 
                           FROM Acquirer.Dbo.Estabelecimento E WITH (Nolock) 
                           INNER JOIN Acquirer.Dbo.Estabelecimentoendereco Ee WITH (Nolock) ON Ee.Codigoestabelecimento = E.Codigoestabelecimento     
                  AND Codigotipoendereco = 1     
                           INNER JOIN Acquirer.Dbo.Cnae Cn WITH (Nolock) ON Cn.Codigocnae = E.Codigocnae     
                           INNER JOIN Acquirer.Dbo.Estabelecimentoconfiguracoesadicionais Eca WITH (Nolock) ON Eca.Codigoestabelecimento = E.Codigoestabelecimento     
                                                                                                               AND Eca.Guiaonline = 1  
                           LEFT JOIN Acquirer.Dbo.Cnaedepara Cnaedepara WITH (Nolock) ON Cn.Codigocnae   = Cnaedepara.Codigocnae 
                           WHERE E.Codigoentidadestatus = 1 -- Ativo                                   
                                 AND EXISTS     
                                            (     
                                            SELECT     
                                                   *     
                                                   FROM  Acquirer.Dbo.Estabelecimentotipoproduto Etp WITH (Nolock)     
                                                   INNER JOIN @TEMP_PRODUTO Tp ON Etp.Codigoproduto = Tp.Codigoproduto     
                                                                                  AND Etp.Codigoprodutostatus = 1 -- Ativo       
                                                                  AND Etp.Guiaonlineprd = 1     
                                                   WHERE Etp.Codigoestabelecimento = E.Codigoestabelecimento     
                                            )     
                                            AND E.Lat IS NOT NULL     
                                            AND E.Lat BETWEEN @Latitude - @Radius / 111.045 AND @Latitude + @Radius / 111.045     
                                            AND E.Lng BETWEEN @Longitude - @Radius / (111.045 * COS(RADIANS(@Latitude))) AND @Longitude + @Radius / (111.045 * COS(RADIANS(@Latitude)))         
       
/***********************************************************************************************     
*************************** VERIFICAÇÃO DO PRODUTO GESTÃO DE FROTA ***************************       
***********************************************************************************************/     
     
             IF @CodigoProduto = 60 -- GESTÃO DE FROTA       
             BEGIN     
                 DELETE       T
                        FROM @TEMP T
                        WHERE
                              NOT EXISTS
                                         (
                                         SELECT
                                                *
                                                FROM  Policard_603078.Dbo.Fornecedor F WITH (Nolock)
                                                WHERE F.Codigo_Novo = T.Codigo
                                                      AND ISNULL(F.Stshabilitafrota, 'N') = @GestaoFrota
                                                      AND NOT EXISTS
                                                                     (
                                                                     SELECT
                                                                            *
                                                                            FROM  Acquirer.Dbo.Historicomigracaoestabelecimento H WITH (Nolock)
                                                                            WHERE F.Codigo_Novo = H.Codigoestabelecimento
                                                                     )
                                         --) 
										  and not exists (
													select 1
													from Estabelecimentos e  with (nolock) 										 
													 WHERE  e.numero = t.codigo 
													-- verificando grande rede pelo campo segmento
													and e.DS_SegmentoEstabelecimento not in ('GRANDE REDE REGIONAL', 'GRANDE REDE NACIONAL', 
																  'GRANDE REDE REGIONAL PRATA', 'GRANDE REDE REGIONAL OURO'))
									
							--Se for posto aparecer somente se tiver TEF, SysData ou POS UP
							and ( not exists (
										select 1
										from Estabelecimentos e  with (nolock) 
										 inner join ramosatividades r with (nolock) on r.RamAtvCodigo = e.RamAtvCodigo
										 WHERE  e.numero = t.codigo 
										 and r.Nome like '%posto%'
										) 
								  or exists (SELECT 1
											 FROM Estabelecimentos e  with (nolock) 
											 inner join ramosatividades r with (nolock) on r.RamAtvCodigo = e.RamAtvCodigo
											 WHERE  e.numero = t.codigo and
											 (exists (select 1
													 FROM EstabelecimentosRedes er  with (nolock)
													 WHERE  
														(er.RdeCodigo = 2 -- TEF
														or er.RdeCodigo = 25 --Rede Sysdata
															)
														and er.estcodigo = e.estcodigo
													 )
											 or exists (select 1 
														FROM HistoricoAlocacaoMeiosCaptura h with (nolock)
														inner join  MeiosCaptura m on  m.MeiCptCodigo = h.MeiCptCodigo
														where tpomeicptcodigo = 20 -- POS UP Brasil
														and h.EstCodigo = e.EstCodigo ))
											and r.Nome like '%posto%')
											 or not exists	(
															SELECT 1
															FROM  
																Policard_603078.dbo.Transacao_Eletronica te(NOLOCK) 
																INNER JOIN Policard_603078.dbo.Fornecedor f (NOLOCK) ON (te.Fornecedor = f.Codigo and te.Franquia_Fornecedor = f.Franquia) 
															WHERE  
																 T.Codigo = f.Codigo_Novo and
																 te.Data between  dateadd(day,-60,getdate()) AND getdate()
																 and te.Responsavel = 'SYSDATA'
															UNION ALL 

															SELECT  1
															FROM  
																Policard_603078.dbo.financiamento fi WITH(NOLOCK) 
																INNER JOIN Policard_603078.dbo.Fornecedor f WITH(NOLOCK) ON	(fi.Fornecedor = f.Codigo AND fi.Franquia_fornecedor = f.Franquia) 
															WHERE   
																	T.Codigo = f.Codigo_Novo and
																	fi.Data BETWEEN   dateadd(day,-60,getdate()) AND getdate()
																	and fi.Responsavel = 'SYSDATA' 
															union all
															SELECT 1
															FROM  
																processadora.dbo.Transacoes te With (NoLock) 			
																INNER JOIN processadora.dbo.estabelecimentos e With (NoLock) ON te.EstCodigo = e.EstCodigo
															WHERE  T.Codigo = e.numero and
																te.Data BETWEEN   dateadd(day,-60,getdate()) AND getdate()
																AND te.TpoTrnCodigo <> 50000 
																and te.Provedor = 'SYSDATA')
												
													
										)
												)
             END       
       
/********************************************************************************************     
*************************** VERIFICAÇÃO CORRESPONDENTE BANCÁRIO ***************************       
********************************************************************************************/     
     
             IF @CodigoProduto = -4 -- Correspondente Bancário       
             BEGIN     
                 DELETE       T     
                        FROM @TEMP T     
                        WHERE     
     NOT EXISTS     
                                         (       
        -- CORRESPONDENTE BANCÁRIO BRADESCO ACQUIRER OLD       
                                         SELECT     
                                                E.Numero AS Codigoestabelecimento     
                                                FROM   Processadora.Dbo.Estabelecimentos E WITH (Nolock)     
                                                WHERE E.Codprospeccao > 0     
                                                      AND E.Codstatuscb = 1 -- CB - Implantado            
                                                      AND T.Codigo = E.Numero     
                                                   AND NOT EXISTS     
                                                                     (     
                                                                     SELECT     
                                                                            *     
                                                                            FROM  Acquirer.Dbo.Historicomigracaoestabelecimento H WITH (Nolock)     
                                          WHERE E.Numero = H.Codigoestabelecimento     
                                                                     )     
                                         UNION ALL       
        -- CORRESPONDENTE BANCÁRIO ITAÚ ACQUIRER OLD       
                                         SELECT     
                                                E.Numero AS Codigoestabelecimento     
                                                FROM   Processadora.Dbo.Estabelecimentos E WITH (Nolock)     
                                                INNER JOIN Processadora.Dbo.Cb_Dadoscorrespondente AS Cdc WITH (Nolock) ON E.Estcodigo = Cdc.Estcodigo     
             AND Cdc.Statuscb = 1  -- CB - Implantado       
                                                WHERE T.Codigo = E.Numero     
                                                      AND NOT EXISTS     
                                                                     (     
                                          SELECT     
                                                                            *     
                                                                            FROM  Acquirer.Dbo.Historicomigracaoestabelecimento H WITH (Nolock)     
                                                                            WHERE E.Numero = H.Codigoestabelecimento     
                                                                     )     
                                         UNION ALL       
        -- CORRESPONDENTE BANCÁRIO BRADESCO ACQUIRER NEW       
                                         SELECT     
                                                Ecb.Codigoestabelecimento     
                                                FROM   Acquirer.Dbo.Estabelecimentocorrespondentebancariobradesco Ecb     
                                                WHERE Ecb.Codigoestabelecimento = T.Codigo     
                                                      AND Ecb.Codigostatuscorrespondentebancario = 1  -- CB - Implantado                                          
                                         UNION ALL       
        -- CORRESPONDENTE BANCÁRIO ITAÚ ACQUIRER NEW       
                                         SELECT     
                                                Eci.Codigoestabelecimento     
                                                FROM  Acquirer.Dbo.Estabelecimentocorrespondentebancarioitau Eci     
                                                WHERE Eci.Codigoestabelecimento = T.Codigo     
                                AND Eci.Codigostatuscorrespondentebancario = 1  -- CB - Implantado       
                                         )     
             END        
     
/**************************************************************************     
*************************** BUSCA DO TELEFONE ***************************       
**************************************************************************/     
     
             INSERT INTO @TEMP_FONE     
                    SELECT DISTINCT     
                           E.Codigo AS Codigoestabelecimento     
                         , T.Codigoarea + Numtelefone AS Telefone     
                           FROM @TEMP E     
                           INNER JOIN Acquirer.Dbo.Telefoneestabelecimento T WITH (Nolock) ON E.Codigo = T.Codigoestabelecimento         
       
/****************************************************************************     
*************************** REMOVENDO ESTABELECIMENTOS COM RESTRICAO ********
****************************************************************************/     
	IF @NumeroCartao IS NOT NULL
	BEGIN
		IF @BaseOrigem = 'C'
			AND EXISTS (
				SELECT TOP 1 1
				FROM Policard_603078.dbo.Cartao_Usuario AS cu WITH (NOLOCK)
					,Policard_603078.dbo.Cliente AS c WITH (NOLOCK)
				WHERE cu.CodigoCartao = @NumeroCartao
					AND cu.Cliente = c.Codigo
					AND cu.Franquia = c.Franquia
					AND c.Restringe_Fornecedor = 1
				)
		BEGIN
			INSERT INTO @LISTA_CODESTAB_AUXILIAR
			SELECT f.Codigo_Novo
			FROM Policard_603078.dbo.Cartao_Usuario AS cu WITH (NOLOCK)
				,Policard_603078.dbo.Restricao_Fornecedor AS rf WITH (NOLOCK)
				,Policard_603078.dbo.Fornecedor AS f WITH (NOLOCK)
			WHERE cu.CodigoCartao = @NumeroCartao
				AND cu.Cliente = rf.Cliente
				AND cu.Franquia = rf.Franquia_Cliente
				AND rf.Fornecedor = f.codigo
				AND rf.Franquia_Fornecedor = f.Franquia;
	
			DELETE
			FROM @TEMP
			WHERE Codigo IN (
					SELECT CodigoEstabelecimento
					FROM @LISTA_CODESTAB_AUXILIAR
					);
		END
		ELSE IF @BaseOrigem = 'P'
		BEGIN
			
			select @CntUsrCodigo=cu.CntUsrCodigo , @EntCodigo=p.EntCodigo 
			from Processadora.dbo.CartoesUsuarios as cu with (nolock)
			, Processadora.dbo.ContasUsuarios as cu2 with (nolock)
			, Processadora.dbo.Propostas as p with (nolock)
			where cu.Numero = @NumeroCartao
			and cu.Status = 'A'
			and cu.CntUsrCodigo = cu2.CntUsrCodigo
			and cu2.PrpCodigo = p.PrpCodigo;
		
			IF EXISTS (select top 1 1 from Autorizacao.dbo.RestricoesEstabelecimento as re with (nolock)
				where re.CntUsrCodigo  = @CntUsrCodigo	or re.AgtEmsCodigo = @EntCodigo)
			BEGIN
				
				INSERT INTO @LISTA_CODESTAB_AUXILIAR
				select Numero 
				from Autorizacao.dbo.RestricoesEstabelecimento as re with (nolock),
				Processadora.dbo.Estabelecimentos as e with (nolock)
				where (re.CntUsrCodigo  = @CntUsrCodigo	or re.AgtEmsCodigo = @EntCodigo)
				and re.EstCodigo = e.EstCodigo;
			
				DELETE
				FROM @TEMP
				WHERE Codigo NOT IN (
						SELECT CodigoEstabelecimento
						FROM @LISTA_CODESTAB_AUXILIAR
						);			
			
			
			END
			


		END
	END

/****************************************************************************     
*************************** RETORNO DA CONSULTA ***************************       
****************************************************************************/     
     
             SELECT     
                    Codigo     
                  , Cnpj     
                  , Nome     
                  , Endereco     
                  , Estado     
                  , Cidade     
                  , Bairro     
                  , Cep    
                  , Telefone = (STUFF((SELECT T.Telefone + ', '     
                      FROM  @TEMP_FONE T 
               WHERE Codigo = T.CodigoEstabelecimento      
                    FOR XML PATH(''), TYPE      
                    ).value('.', 'VARCHAR(8000)') ,1,1,''))     
                  , Ramo  
                  , CodRamoAtividade    
                  , CONVERT(INT, Distancia * 1000) AS Distancia     
                  , Latitude     
                  , Longitude     
                  , ROW_NUMBER() OVER(ORDER BY Est.Distancia) AS Rnumber   
				  , QRcode 
				  , (select top 1 IdResponsibleConsumption 
					 from EstebelecimentoResponsibleConsumption er 
					 inner join estabelecimentos e on er.estcodigo = e.estcodigo
					where e.numero = est.codigo) as IdResponsibleConsumption
					
				  ,  (select top 1 Description 
					 from EstebelecimentoResponsibleConsumption er 
					 inner join estabelecimentos e on er.estcodigo = e.estcodigo
					 inner join ResponsibleConsumption r on er.IdResponsibleConsumption = r.Id
					where e.numero = est.codigo) as ResponsibleConsumption 
                    FROM @TEMP Est    
					
                    WHERE Est.Distancia <= @Radius     
                          AND (Est.Nome LIKE '%'+@NomeEstabelecimento+'%'     
                               OR ISNULL(@NomeEstabelecimento, '') = '')     
                    GROUP BY     
                             Codigo     
                           , Cnpj     
                           , Nome     
						   , Estado     
                           , Cidade     
                           , Endereco     
                           , Bairro     
                           , Cep     
                           , Ramo     
                           , CodRamoAtividade 
                           , Distancia     
                           , Latitude     
                           , Longitude  
						   , QRcode 
         END     
     END 
