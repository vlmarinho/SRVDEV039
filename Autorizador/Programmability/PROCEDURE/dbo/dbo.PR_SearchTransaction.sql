/***************************************************************************************************
 * Sistema: Autorizador
 * Objeto: [dbo].[PR_SearchTransaction]
 * Propósito: Busca de transações para exibição de dados no sistema Acquirer.Autorização, um novo
 * 		módulo criado para o Acquirer-web.
 * 	Parâmetros:
 * 		@initialDate Data inicial para pesquisa (OBRIGATÓRIO) - DATETIME
 * 		@finalDate Data final para pesquisa (OBRIGATÓRIO) - DATETIME
 * 		@paymentSystem Rede da transação (não usado no momento - VARCHAR(50) = NULL
 * 		@storeNumber Número do estabelecimento; coluna Processadora..Estabelecimentos(Numero) - BIGINT = NULL
 * 		@cardNumber Número do cartão - VARCHAR(16) = NULL
 * 		@returnCode Código de retorno - INT OUTPUT
 * 		@returnMessage Mensagem de retorno - NVARCHAR(MAX) OUTPUT
 * 		@returnObjectId Id do objeto, a depender da natureza da procedure - BIGINT OUTPUT
 ***************************************************************************************************
 */
/*=========== CHANGELOG ===========
Data: 14/02/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1820522
Descrição: Criação do objeto
-----------------------------------------------------------------------------------------------------
Data: 04/04/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1836035
Descrição: Inclui SafraPay e estabelecimento mapeados na tabela Acquirer.dbo.EstabelecimentoGetnet
-----------------------------------------------------------------------------------------------------
Data: 07/04/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1836035 - AJUSTE
Descrição: Corrige conversão de valores na consulta
-----------------------------------------------------------------------------------------------------
Data: 16/05/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1855897
Descrição: Trata a possibilidade de o bit 032 não ser númerico
-----------------------------------------------------------------------------------------------------
Data: 08/05/2024
Autor: Adilson Pereira - Up Brasil
Chamado: 2121964
Descrição: Reformulação da procedure, para usar tabelas finais em vez da auditoria.
-----------------------------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[PR_SearchTransaction] @initialDate DATETIME
	,@finalDate DATETIME
	,@paymentSystem VARCHAR(50) = NULL
	,@storeNumber BIGINT
	,@cardNumber VARCHAR(16) = NULL
	,@returnCode INT OUTPUT
	,@returnMessage NVARCHAR(MAX) OUTPUT
	,@returnObjectId BIGINT OUTPUT
AS
BEGIN
	SET @returnObjectId = 0;

	BEGIN TRY
		IF @initialDate IS NULL
			OR @finalDate IS NULL
		BEGIN
			SET @returnCode = 1;
			SET @returnMessage = 'Obrigatório informar data inicial e data final!';

			RETURN;
		END

		IF ISNULL(@cardNumber, '') = ''
			OR LEN(@cardNumber) <> 16
		BEGIN
			SET @cardNumber = NULL;
		END

		IF ISNULL(@storeNumber, 0) = 0
		BEGIN
			SET @storeNumber = NULL;
		END

		SELECT tn.Codigo AS TransactionId
			,CASE tn.TipoMensagem
				WHEN '0210'
					THEN 'AUTORIZACAO'
				WHEN '0410'
					THEN 'ESTORNO'
				WHEN '0430'
					THEN 'DESFAZIMENTO'
				WHEN '0810'
					THEN 'ABERTURA'
				END AS TransactionTypeDescription
			,tn.CodResposta AS ResponseCode
			,NULL AS Bit039
			,'NEGADA' AS ResponseDescription
			,tn.[Data] AS TransactionDate
			,tn.NSUOrigem AS Bit011
			,tn.Valor AS TransactionValue
			,tn.Provedor AS PaymentSystem
			,NULL AS Bit042
			,cu.CodigoCartao AS CardNumber
			,tn.CodEstabelecimento AS StoreNumber
			,e.Nome AS StoreName
			,(
				SELECT tp.Nome
				FROM Processadora.dbo.TiposProdutos AS tp WITH (NOLOCK)
				WHERE tp.TpoPrdCodigo = tn.CodtipoProduto
				) AS Product
			,cu.Nome_Usuario AS CardHolderName
		FROM Processadora.dbo.TransacoesNegadas AS tn WITH (NOLOCK)
			,Policard_603078.dbo.Cartao_Usuario AS cu WITH (NOLOCK)
			,Processadora.dbo.Estabelecimentos AS e WITH (NOLOCK)
		WHERE tn.BaseOrigem = 'C'
			AND tn.CodCartao = cu.Codigo
			AND tn.Codfranquia = cu.Franquia
			AND e.Numero = tn.CodEstabelecimento
			AND tn.Data >= @initialDate
			AND tn.Data < @finalDate
			AND (
				@storeNumber IS NULL
				OR E.Numero = @storeNumber
				)
			AND (
				@cardNumber IS NULL
				OR cu.CodigoCartao = @cardNumber
				)
		
		UNION ALL
		
		SELECT tn.Codigo AS TransactionId
			,CASE tn.TipoMensagem
				WHEN '0210'
					THEN 'AUTORIZACAO'
				WHEN '0410'
					THEN 'ESTORNO'
				WHEN '0430'
					THEN 'DESFAZIMENTO'
				WHEN '0810'
					THEN 'ABERTURA'
				END AS TransactionTypeDescription
			,tn.CodResposta AS ResponseCode
			,NULL AS Bit039
			,'NEGADA' AS ResponseDescription
			,tn.[Data] AS TransactionDate
			,tn.NSUOrigem AS Bit011
			,tn.Valor AS TransactionValue
			,tn.Provedor AS PaymentSystem
			,NULL AS Bit042
			,cu.Numero AS CardNumber
			,tn.CodEstabelecimento AS StoreNumber
			,e.Nome AS StoreName
			,(
				SELECT tp.Nome
				FROM Processadora.dbo.TiposProdutos AS tp WITH (NOLOCK)
				WHERE tp.TpoPrdCodigo = tn.CodtipoProduto
				) AS Product
			,cu.Nome AS CardHolderName
		FROM Processadora.dbo.TransacoesNegadas AS tn WITH (NOLOCK)
			,Processadora.dbo.CartoesUsuarios AS cu WITH (NOLOCK)
			,Processadora.dbo.Estabelecimentos AS e WITH (NOLOCK)
		WHERE tn.BaseOrigem = 'P'
			AND tn.CodCartao = cu.CrtUsrCodigo
			AND e.Numero = tn.CodEstabelecimento
			AND tn.Data >= @initialDate
			AND tn.Data < @finalDate
			AND (
				@storeNumber IS NULL
				OR E.Numero = @storeNumber
				)
			AND (
				@cardNumber IS NULL
				OR cu.Numero = @cardNumber
				)
		
		UNION ALL
		
		SELECT trt.NsuHost
			,CASE trt.Tipo_Mensagem
				WHEN '0200'
					THEN 'AUTORIZACAO'
				WHEN '0400'
					THEN 'ESTORNO'
				WHEN '0420'
					THEN 'DESFAZIMENTO'
				END AS TransactionTypeDescription
			,0 AS ResponseCode
			,'00' AS Bit039
			,CASE trt.StatusTef
				WHEN 'A'
					THEN 'AUTORIZADA'
				WHEN 'P'
					THEN 'PENDENTE'
				WHEN 'E'
					THEN 'ESTORNADA'
				WHEN 'D'
					THEN 'DESFEITA'
				END AS ResponseDescription
			,trt.DataAutorizacao AS TransactionDate
			,RIGHT(CONCAT (
					'000000'
					,trt.NsuLoja
					), 6) AS Bit011
			,trt.Valor AS TransactionValue
			,trt.ProvedorTef AS PaymentSystem
			,NULL AS Bit042
			,trt.NumeroCartao AS CardNumber
			,trt.Estabelecimento AS StoreNumber
			,e.Nome AS StoreName
			,(
				SELECT tp.Nome
				FROM Policard_603078.dbo.Cliente AS c WITH (NOLOCK)
					,Policard_603078.dbo.TipoProduto AS tp WITH (NOLOCK)
				WHERE cu.CodigoCartao = trt.NumeroCartao
					AND cu.Data_Digitacao < trt.DataAutorizacao
					AND (
						cu.Data_Cancelamento IS NULL
						OR cu.Data_Cancelamento > trt.DataAutorizacao
						)
					AND cu.Cliente = c.Codigo
					AND cu.Franquia = c.Franquia
					AND c.TipoProduto = tp.TipoProduto
				)  AS Product
			,cu.Nome_Usuario AS CardHolderName
		FROM Policard_603078.dbo.Transacao_RegistroTEF AS trt WITH (NOLOCK)
			,Policard_603078.dbo.Cartao_Usuario AS cu WITH (NOLOCK)
			,Processadora.dbo.Estabelecimentos AS e WITH (NOLOCK)
		WHERE trt.NumeroCartao = cu.CodigoCartao
			AND e.Numero = trt.Estabelecimento
			AND trt.DataAutorizacao >= @initialDate
			AND trt.DataAutorizacao < @finalDate
			AND (
				@storeNumber IS NULL
				OR E.Numero = @storeNumber
				)
			AND (
				@cardNumber IS NULL
				OR cu.CodigoCartao = @cardNumber
				)
		
		UNION ALL
		
		SELECT t.TrnCodigo AS TransactionId
			,CASE t.TipoMensagem
				WHEN '0200'
					THEN 'AUTORIZACAO'
				WHEN '0400'
					THEN 'ESTORNO'
				WHEN '0420'
					THEN 'DESFAZIMENTO'
				END AS TransactionTypeDescription
			,0 AS ResponseCode
			,'00' AS Bit039
			,CASE t.STATUS
				WHEN 'A'
					THEN 'AUTORIZADA'
				WHEN 'P'
					THEN 'PENDENTE'
				WHEN 'E'
					THEN 'ESTORNADA'
				WHEN 'D'
					THEN 'DESFEITA'
				END AS ResponseDescription
			,t.[Data] AS TransactionDate
			,t.NSUOrigem AS Bit011
			,t.Valor AS TransactionValue
			,t.Provedor AS PaymentSystem
			,NULL AS Bit042
			,cu.numero AS CardNumber
			,e.Numero AS StoreNumber
			,e.Nome AS StoreName
			,(
				SELECT tp.Nome
				FROM Processadora.dbo.TiposProdutos AS tp WITH (NOLOCK)
				WHERE tp.TpoPrdCodigo = cu.TpoPrdCodigo
				) AS Product
			,cu.Nome AS CardHolderName
		FROM Processadora.dbo.transacoes AS t WITH (NOLOCK)
			,Processadora.dbo.CartoesUsuarios AS cu WITH (NOLOCK)
			,Processadora.dbo.Estabelecimentos AS e WITH (NOLOCK)
		WHERE t.CrtUsrCodigo = cu.CrtUsrCodigo
			AND t.EstCodigo = e.EstCodigo
			AND t.Data >= @initialDate
			AND t.Data < @finalDate
			AND (
				@storeNumber IS NULL
				OR e.Numero = @storeNumber
				)
			AND (
				@cardNumber IS NULL
				OR cu.Numero = @cardNumber
				)
		ORDER BY TransactionDate;

		/*
		SELECT atr1.Codigo AS TransactionId
			,atr1.Bit001 AS TransactionTypeCode
			,CASE atr1.Bit001
				WHEN '0400'
					THEN 'ESTORNO'
				WHEN '0420'
					THEN 'DESFAZIMENTO'
				ELSE 'AUTORIZAÇÃO'
				END AS TransactionTypeDescription
			,atr2.CodigoResposta AS ResponseCode
			,atr2.Bit039 AS Bit039
			,(
				SELECT acr.descricao
				FROM Autorizador..aut_CodigosResposta acr WITH (NOLOCK)
				WHERE acr.codigo = atr2.CodigoResposta
				) AS ResponseDescription
			,atr1.DATAHORA AS TransactionDate
			,atr1.Bit011 AS Bit011
			,CONVERT(DECIMAL(15, 2), CONVERT(DECIMAL(15, 2), atr1.Bit004) / 100) AS TransactionValue
			,'CIELO' AS PaymentSystem
			,atr1.Bit042 AS Bit042
			,tcard.CardNumber
			,e.Numero AS StoreNumber
			,e.Nome AS StoreName
			,CASE 
				WHEN tcard.CardNumber LIKE '6030780%'
					THEN IIF(tcard.CardNumber LIKE '60307800%', 'CONVENIO', 'FROTA')
				ELSE (
						SELECT tp.Nome
						FROM Processadora.dbo.TiposProdutos tp WITH (NOLOCK)
						WHERE tp.TpoPrdCodigo = (
								SELECT TOP 1 cu.TpoPrdCodigo
								FROM Processadora.dbo.CartoesUsuarios cu WITH (NOLOCK)
								WHERE cu.Numero = tcard.CardNumber
								)
						)
				END AS Product
			,CASE 
				WHEN tcard.CardNumber LIKE '6030780%'
					THEN (
							SELECT TOP 1 cu.Nome_usuario
							FROM Policard_603078.dbo.Cartao_Usuario cu WITH (NOLOCK)
							WHERE cu.CodigoCartao = tcard.CardNumber
							)
				ELSE (
						SELECT TOP 1 cu.Nome
						FROM Processadora.dbo.CartoesUsuarios cu WITH (NOLOCK)
						WHERE cu.Numero = tcard.CardNumber
						)
				END AS CardHolderName
		FROM Autorizador..AuditoriaTransacoes atr1 WITH (
				NOLOCK
				,INDEX (IDX_N_AuditoriaTransacoes_001)
				)
			,(
				SELECT atr0.Codigo
					,CASE 
						WHEN SUBSTRING(atr0.bit035, 0, 17) <> ' '
							THEN SUBSTRING(atr0.bit035, 0, 17)
						WHEN SUBSTRING(atr0.Bit045, 2, 16) <> ' '
							THEN SUBSTRING(atr0.Bit045, 2, 16)
						ELSE atr0.Bit002
						END AS CardNumber
				FROM Autorizador..AuditoriaTransacoes atr0 WITH (NOLOCK)
				) AS tcard
			,Autorizador..AuditoriaTransacoes atr2 WITH (NOLOCK)
			,Processadora..EstabelecimentoCielo ec WITH (NOLOCK)
			,Processadora..Estabelecimentos e WITH (NOLOCK)
		WHERE atr1.DataHora >= @initialDate
			AND atr1.DataHora < @finalDate
			AND atr1.Bit001 IN (
				'0200'
				,'0400'
				,'0420'
				)
			AND ISNUMERIC(atr1.bit032) = 1
			AND CONVERT(BIGINT, atr1.bit032) = 6142
			AND atr1.Codigo = tcard.Codigo
			AND atr1.Codigo = atr2.CodigoReferencia
			AND (
				@storeNumber IS NULL
				OR E.Numero = @storeNumber
				)
			AND (
				@cardNumber IS NULL
				OR tcard.CardNumber = @cardNumber
				)
			AND CONVERT(VARCHAR, CONVERT(BIGINT, atr1.Bit042)) = EC.CodigoCielo
			AND ec.EstCodigo = e.EstCodigo
		
		UNION ALL
		
		SELECT atr1.Codigo AS TransactionId
			,atr1.Bit001 AS TransactionTypeCode
			,CASE atr1.Bit001
				WHEN '0400'
					THEN 'ESTORNO'
				WHEN '0420'
					THEN 'DESFAZIMENTO'
				ELSE 'AUTORIZAÇÃO'
				END AS TransactionTypeDescription
			,atr2.CodigoResposta AS ResponseCode
			,atr2.Bit039 AS Bit039
			,(
				SELECT acr.descricao
				FROM Autorizador..aut_CodigosResposta acr WITH (NOLOCK)
				WHERE acr.codigo = atr2.CodigoResposta
				) AS ResponseDescription
			,atr1.DATAHORA AS TransactionDate
			,atr1.Bit011 AS Bit011
			,CONVERT(DECIMAL(15, 2), CONVERT(DECIMAL(15, 2), atr1.Bit004) / 100) AS TransactionValue
			,'STONE' AS PaymentSystem
			,atr1.Bit042 AS Bit042
			,tcard.CardNumber
			,e.Numero AS StoreNumber
			,e.Nome AS StoreName
			,CASE 
				WHEN tcard.CardNumber LIKE '6030780%'
					THEN IIF(tcard.CardNumber LIKE '60307800%', 'CONVENIO', 'FROTA')
				ELSE (
						SELECT tp.Nome
						FROM Processadora.dbo.TiposProdutos tp WITH (NOLOCK)
						WHERE tp.TpoPrdCodigo = (
								SELECT TOP 1 cu.TpoPrdCodigo
								FROM Processadora.dbo.CartoesUsuarios cu WITH (NOLOCK)
								WHERE cu.Numero = tcard.CardNumber
								)
						)
				END AS Product
			,CASE 
				WHEN tcard.CardNumber LIKE '6030780%'
					THEN (
							SELECT TOP 1 cu.Nome_usuario
							FROM Policard_603078.dbo.Cartao_Usuario cu WITH (NOLOCK)
							WHERE cu.CodigoCartao = tcard.CardNumber
							)
				ELSE (
						SELECT TOP 1 cu.Nome
						FROM Processadora.dbo.CartoesUsuarios cu WITH (NOLOCK)
						WHERE cu.Numero = tcard.CardNumber
						)
				END AS CardHolderName
		FROM Autorizador..AuditoriaTransacoes atr1 WITH (
				NOLOCK
				,INDEX (IDX_N_AuditoriaTransacoes_001)
				)
			,(
				SELECT atr0.Codigo
					,CASE 
						WHEN SUBSTRING(atr0.bit035, 0, 17) <> ' '
							THEN SUBSTRING(atr0.bit035, 0, 17)
						WHEN SUBSTRING(atr0.Bit045, 2, 16) <> ' '
							THEN SUBSTRING(atr0.Bit045, 2, 16)
						ELSE atr0.Bit002
						END AS CardNumber
				FROM Autorizador..AuditoriaTransacoes atr0 WITH (NOLOCK)
				) AS tcard
			,Autorizador..AuditoriaTransacoes atr2 WITH (NOLOCK)
			,Acquirer..EstabelecimentoStone es WITH (NOLOCK)
			,Processadora..Estabelecimentos e WITH (
				NOLOCK
				,INDEX (IX_N_ESTABELECIMENTO_002)
				)
		WHERE atr1.DataHora >= @initialDate
			AND atr1.DataHora < @finalDate
			AND atr1.Bit001 IN (
				'0200'
				,'0400'
				,'0420'
				)
			AND ISNUMERIC(atr1.bit032) = 1
			AND CONVERT(BIGINT, atr1.bit032) = 31
			AND atr1.Codigo = tcard.Codigo
			AND atr1.Codigo = atr2.CodigoReferencia
			AND (
				@storeNumber IS NULL
				OR E.Numero = @storeNumber
				)
			AND (
				@cardNumber IS NULL
				OR tcard.CardNumber = @cardNumber
				)
			AND CONVERT(BIGINT, atr1.Bit042) = es.CodigoStone
			AND es.CodigoEstabelecimento = e.Numero
		
		UNION ALL
		
		SELECT atr1.Codigo AS TransactionId
			,atr1.Bit001 AS TransactionTypeCode
			,CASE atr1.Bit001
				WHEN '0400'
					THEN 'ESTORNO'
				WHEN '0420'
					THEN 'DESFAZIMENTO'
				ELSE 'AUTORIZAÇÃO'
				END AS TransactionTypeDescription
			,atr2.CodigoResposta AS ResponseCode
			,atr2.Bit039 AS Bit039
			,(
				SELECT acr.descricao
				FROM Autorizador..aut_CodigosResposta acr WITH (NOLOCK)
				WHERE acr.codigo = atr2.CodigoResposta
				) AS ResponseDescription
			,atr1.DATAHORA AS TransactionDate
			,atr1.Bit011 AS Bit011
			,CONVERT(DECIMAL(15, 2), CONVERT(DECIMAL(15, 2), atr1.Bit004) / 100) AS TransactionValue
			,CASE 
				WHEN CONVERT(BIGINT, atr1.Bit032) = 58
					THEN 'POS WALK'
				WHEN CONVERT(BIGINT, atr1.Bit024) = 29
					THEN 'REDE'
				WHEN atr1.Bit123 LIKE 'SCOPE%'
					THEN SUBSTRING(atr1.Bit123, 1, 12)
				WHEN CONVERT(BIGINT, atr1.Bit024) = 18
					THEN 'TECBAN'
				WHEN CONVERT(BIGINT, atr1.Bit024) = 21
					THEN 'VALE TRANSPORTE'
				WHEN CONVERT(BIGINT, atr1.Bit024) = 17
					THEN 'CAE'
				WHEN CONVERT(BIGINT, atr1.Bit024) = 16
					THEN 'CRM'
				ELSE atr1.Bit048
				END AS PaymentSystem
			,atr1.Bit042 AS Bit042
			,tcard.CardNumber
			,e.Numero AS StoreNumber
			,e.Nome AS StoreName
			,CASE 
				WHEN tcard.CardNumber LIKE '6030780%'
					THEN IIF(tcard.CardNumber LIKE '60307800%', 'CONVENIO', 'FROTA')
				ELSE (
						SELECT tp.Nome
						FROM Processadora.dbo.TiposProdutos tp WITH (NOLOCK)
						WHERE tp.TpoPrdCodigo = (
								SELECT TOP 1 cu.TpoPrdCodigo
								FROM Processadora.dbo.CartoesUsuarios cu WITH (NOLOCK)
								WHERE cu.Numero = tcard.CardNumber
								)
						)
				END AS Product
			,CASE 
				WHEN tcard.CardNumber LIKE '6030780%'
					THEN (
							SELECT TOP 1 cu.Nome_usuario
							FROM Policard_603078.dbo.Cartao_Usuario cu WITH (NOLOCK)
							WHERE cu.CodigoCartao = tcard.CardNumber
							)
				ELSE (
						SELECT TOP 1 cu.Nome
						FROM Processadora.dbo.CartoesUsuarios cu WITH (NOLOCK)
						WHERE cu.Numero = tcard.CardNumber
						)
				END AS CardHolderName
		FROM Autorizador..AuditoriaTransacoes atr1 WITH (
				NOLOCK
				,INDEX (IDX_N_AuditoriaTransacoes_001)
				)
			,(
				SELECT atr0.Codigo
					,CASE 
						WHEN SUBSTRING(atr0.bit035, 0, 17) <> ' '
							THEN SUBSTRING(atr0.bit035, 0, 17)
						WHEN SUBSTRING(atr0.Bit045, 2, 16) <> ' '
							THEN SUBSTRING(atr0.Bit045, 2, 16)
						ELSE atr0.Bit002
						END AS CardNumber
				FROM Autorizador..AuditoriaTransacoes atr0 WITH (NOLOCK)
				) AS tcard
			,Autorizador..AuditoriaTransacoes atr2 WITH (NOLOCK)
			,Processadora..Estabelecimentos e WITH (
				NOLOCK
				,INDEX (IX_N_ESTABELECIMENTO_002)
				)
		WHERE atr1.DataHora >= @initialDate
			AND atr1.DataHora < @finalDate
			AND atr1.Bit001 IN (
				'0200'
				,'0400'
				,'0420'
				)
			AND ISNUMERIC(atr1.bit032) = 1
			AND CONVERT(BIGINT, atr1.bit032) NOT IN (
				6142
				,31
				)
			AND atr1.Codigo = tcard.Codigo
			AND atr1.Codigo = atr2.CodigoReferencia
			AND (
				@storeNumber IS NULL
				OR E.Numero = @storeNumber
				)
			AND (
				@cardNumber IS NULL
				OR tcard.CardNumber = @cardNumber
				)
			AND CONVERT(BIGINT, atr1.Bit042) = e.Numero
		
		UNION ALL
		
		SELECT atr1.Codigo AS TransactionId
			,atr1.Bit001 AS TransactionTypeCode
			,CASE atr1.Bit001
				WHEN '0400'
					THEN 'ESTORNO'
				WHEN '0420'
					THEN 'DESFAZIMENTO'
				ELSE 'AUTORIZAÇÃO'
				END AS TransactionTypeDescription
			,atr2.CodigoResposta AS ResponseCode
			,atr2.Bit039 AS Bit039
			,(
				SELECT acr.descricao
				FROM Autorizador..aut_CodigosResposta acr WITH (NOLOCK)
				WHERE acr.codigo = atr2.CodigoResposta
				) AS ResponseDescription
			,atr1.DATAHORA AS TransactionDate
			,atr1.Bit011 AS Bit011
			,CONVERT(DECIMAL(15, 2), CONVERT(DECIMAL(15, 2), atr1.Bit004) / 100) AS TransactionValue
			,'SAFRAPAY' AS PaymentSystem
			,atr1.Bit042 AS Bit042
			,tcard.CardNumber
			,e.Numero AS StoreNumber
			,e.Nome AS StoreName
			,CASE 
				WHEN tcard.CardNumber LIKE '6030780%'
					THEN IIF(tcard.CardNumber LIKE '60307800%', 'CONVENIO', 'FROTA')
				ELSE (
						SELECT tp.Nome
						FROM Processadora.dbo.TiposProdutos tp WITH (NOLOCK)
						WHERE tp.TpoPrdCodigo = (
								SELECT TOP 1 cu.TpoPrdCodigo
								FROM Processadora.dbo.CartoesUsuarios cu WITH (NOLOCK)
								WHERE cu.Numero = tcard.CardNumber
								)
						)
				END AS Product
			,CASE 
				WHEN tcard.CardNumber LIKE '6030780%'
					THEN (
							SELECT TOP 1 cu.Nome_usuario
							FROM Policard_603078.dbo.Cartao_Usuario cu WITH (NOLOCK)
							WHERE cu.CodigoCartao = tcard.CardNumber
							)
				ELSE (
						SELECT TOP 1 cu.Nome
						FROM Processadora.dbo.CartoesUsuarios cu WITH (NOLOCK)
						WHERE cu.Numero = tcard.CardNumber
						)
				END AS CardHolderName
		FROM Autorizador..AuditoriaTransacoes atr1 WITH (
				NOLOCK
				,INDEX (IDX_N_AuditoriaTransacoes_001)
				)
			,(
				SELECT atr0.Codigo
					,CASE 
						WHEN SUBSTRING(atr0.bit035, 0, 17) <> ' '
							THEN SUBSTRING(atr0.bit035, 0, 17)
						WHEN SUBSTRING(atr0.Bit045, 2, 16) <> ' '
							THEN SUBSTRING(atr0.Bit045, 2, 16)
						ELSE atr0.Bit002
						END AS CardNumber
				FROM Autorizador..AuditoriaTransacoes atr0 WITH (NOLOCK)
				) AS tcard
			,Autorizador..AuditoriaTransacoes atr2 WITH (NOLOCK)
			,Acquirer..EstabelecimentoSafra es WITH (NOLOCK)
			,Processadora..Estabelecimentos e WITH (NOLOCK)
		WHERE atr1.DataHora >= @initialDate
			AND atr1.DataHora < @finalDate
			AND atr1.Bit001 IN (
				'0200'
				,'0400'
				,'0420'
				)
			AND ISNUMERIC(atr1.bit032) = 1
			AND CONVERT(BIGINT, atr1.bit032) NOT IN (
				6142
				,31
				)
			AND atr1.Codigo = tcard.Codigo
			AND atr1.Codigo = atr2.CodigoReferencia
			AND (
				@storeNumber IS NULL
				OR E.Numero = @storeNumber
				)
			AND (
				@cardNumber IS NULL
				OR tcard.CardNumber = @cardNumber
				)
			AND CONVERT(BIGINT, atr1.Bit042) = es.CodigoSafra
			AND es.CodigoEstabelecimento = e.Numero
		
		UNION ALL
		
		SELECT atr1.Codigo AS TransactionId
			,atr1.Bit001 AS TransactionTypeCode
			,CASE atr1.Bit001
				WHEN '0400'
					THEN 'ESTORNO'
				WHEN '0420'
					THEN 'DESFAZIMENTO'
				ELSE 'AUTORIZAÇÃO'
				END AS TransactionTypeDescription
			,atr2.CodigoResposta AS ResponseCode
			,atr2.Bit039 AS Bit039
			,(
				SELECT acr.descricao
				FROM Autorizador..aut_CodigosResposta acr WITH (NOLOCK)
				WHERE acr.codigo = atr2.CodigoResposta
				) AS ResponseDescription
			,atr1.DATAHORA AS TransactionDate
			,atr1.Bit011 AS Bit011
			,CONVERT(DECIMAL(15, 2), CONVERT(DECIMAL(15, 2), atr1.Bit004) / 100) AS TransactionValue
			,(
				SELECT sr.Descricao
				FROM Acquirer.dbo.SubRede AS sr WITH (NOLOCK)
				WHERE sr.Numero = eg.CodRede
				) AS PaymentSystem
			,atr1.Bit042 AS Bit042
			,tcard.CardNumber
			,e.Numero AS StoreNumber
			,e.Nome AS StoreName
			,CASE 
				WHEN tcard.CardNumber LIKE '6030780%'
					THEN IIF(tcard.CardNumber LIKE '60307800%', 'CONVENIO', 'FROTA')
				ELSE (
						SELECT tp.Nome
						FROM Processadora.dbo.TiposProdutos tp WITH (NOLOCK)
						WHERE tp.TpoPrdCodigo = (
								SELECT TOP 1 cu.TpoPrdCodigo
								FROM Processadora.dbo.CartoesUsuarios cu WITH (NOLOCK)
								WHERE cu.Numero = tcard.CardNumber
								)
						)
				END AS Product
			,CASE 
				WHEN tcard.CardNumber LIKE '6030780%'
					THEN (
							SELECT TOP 1 cu.Nome_usuario
							FROM Policard_603078.dbo.Cartao_Usuario cu WITH (NOLOCK)
							WHERE cu.CodigoCartao = tcard.CardNumber
							)
				ELSE (
						SELECT TOP 1 cu.Nome
						FROM Processadora.dbo.CartoesUsuarios cu WITH (NOLOCK)
						WHERE cu.Numero = tcard.CardNumber
						)
				END AS CardHolderName
		FROM Autorizador..AuditoriaTransacoes atr1 WITH (
				NOLOCK
				,INDEX (IDX_N_AuditoriaTransacoes_001)
				)
			,(
				SELECT atr0.Codigo
					,CASE 
						WHEN SUBSTRING(atr0.bit035, 0, 17) <> ' '
							THEN SUBSTRING(atr0.bit035, 0, 17)
						WHEN SUBSTRING(atr0.Bit045, 2, 16) <> ' '
							THEN SUBSTRING(atr0.Bit045, 2, 16)
						ELSE atr0.Bit002
						END AS CardNumber
				FROM Autorizador..AuditoriaTransacoes atr0 WITH (NOLOCK)
				) AS tcard
			,Autorizador..AuditoriaTransacoes atr2 WITH (NOLOCK)
			,(
				SELECT *
				FROM Acquirer..EstabelecimentoGetnet tab WITH (NOLOCK)
				WHERE tab.CodigoGetnet <> 0
				) AS eg
			,Processadora..Estabelecimentos e WITH (NOLOCK)
		WHERE atr1.DataHora >= @initialDate
			AND atr1.DataHora < @finalDate
			AND atr1.Bit001 IN (
				'0200'
				,'0400'
				,'0420'
				)
			AND ISNUMERIC(atr1.bit032) = 1				
			AND CONVERT(BIGINT, atr1.bit032) NOT IN (
				6142
				,31
				)
			AND atr1.Codigo = tcard.Codigo
			AND atr1.Codigo = atr2.CodigoReferencia
			AND (
				@storeNumber IS NULL
				OR E.Numero = @storeNumber
				)
			AND (
				@cardNumber IS NULL
				OR tcard.CardNumber = @cardNumber
				)
			AND CONVERT(BIGINT, atr1.Bit042) = eg.CodigoGetnet
			AND eg.CodigoEstabelecimento = e.Numero
		ORDER BY TransactionDate
*/
		SET @returnCode = 0;
		SET @returnMessage = 'OK';
	END TRY

	BEGIN CATCH
		SET @returnCode = 99
		SET @returnMessage = N'(ERROR_PROCEDURE: ' + ERROR_PROCEDURE() + '; ERROR_NUMBER=' + CONVERT(VARCHAR(4000), ERROR_NUMBER()) + '; ERROR_SEVERITY=' + CONVERT(VARCHAR(4000), ERROR_SEVERITY()) + '; ERROR_STATE=' + CONVERT(VARCHAR(4000), ERROR_STATE()) + '; ERROR_LINE=' + CONVERT(VARCHAR(4000), ERROR_LINE()) + '; ERROR_MESSAGE=' + ERROR_MESSAGE() + ')';
	END CATCH
END