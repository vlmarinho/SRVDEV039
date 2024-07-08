CREATE PROCEDURE [dbo].[PR_DBA_RELATORIOTRANSACOES] 
@DATAINICIO DATETIME, 
@DATAFIM DATETIME, 
@REDE VARCHAR(50),
@CODESTAB BIGINT, 
@NUMCARTAO VARCHAR(16)

AS
BEGIN

	DECLARE 
	 @SQL_1 NVARCHAR(MAX),
	 @SQL NVARCHAR(MAX),
	 @dDATAINI DATETIME = @DATAINICIO,
	 @dDATAFIM DATETIME = @DATAFIM, 
	 @cREDE VARCHAR(50) = @REDE,
	 @iCODESTAB INT = @CODESTAB,
	 @cCARTAO VARCHAR(16) = @NUMCARTAO


DECLARE @TEMP TABLE  (TIPO VARCHAR(20),
					CODIGORESPOSTA INT,
					BIT039 VARCHAR(2),
					DESCRICAO VARCHAR(200),
					[Data] Varchar(10),
					[Hora] Varchar(8),
					NSU Varchar(10),
					VALOR DECIMAL(15,2),
					REDE VARCHAR(100),
					BIT042 VARCHAR(30),
					CARTAO VARCHAR(16))
					

	 SET @SQL_1 =N' SELECT 
			 CASE A.BIT001
			 WHEN ''0400'' THEN ''ESTORNO''
			 WHEN ''0420'' THEN ''DESFAZIMENTO''
			 ELSE ''AUTORIZAÇÃO'' END AS TIPO,
			 A1.CODIGORESPOSTA,
			 A1.BIT039,
			 AA.DESCRICAO,
			 convert(varchar(10), A.DataHora ,103) as [Data],
			convert(varchar(8), A.DataHora ,108) as [Hora],
			A.BIT011,
			 (convert(decimal(15,2),(convert(decimal(15,2),convert(bigint, A.BIT004)))/100)) as VALOR,
			 CASE 
				WHEN CONVERT(BIGINT, A.BIT032) =58 THEN ''POS WALK''
				WHEN CONVERT(BIGINT, A.BIT032) = 6142 AND A.BIT001 <> ''0800'' THEN ''CIELO''
				WHEN CONVERT(BIGINT, A.BIT024) = 29 THEN ''REDE''
				WHEN CONVERT(BIGINT, A.BIT032) = 31 THEN ''STONE''
				WHEN A.BIT123 LIKE ''SCOPE%'' THEN SUBSTRING(A.BIT123,1,12)
				WHEN CONVERT(BIGINT, A.BIT024) = 18  THEN ''TECBAN''
				WHEN CONVERT(BIGINT, A.BIT024)= 21 THEN ''VALE TRANSPORTE''
				WHEN CONVERT(BIGINT, A.BIT024)= 17 THEN ''CAE''
				WHEN CONVERT(BIGINT, A.BIT024)= 16 THEN ''CRM''
			 ELSE A.BIT048 END AS ''REDE'', 
			 A.BIT042,
				 CASE (CASE SUBSTRING(A.BIT035,0,17)
				WHEN  '' '' THEN SUBSTRING(A.BIT045,2,16) 
				ELSE SUBSTRING(A.BIT035,0,17)
			END) WHEN  '' '' THEN  A.BIT002  ELSE CASE SUBSTRING(A.BIT035,0,17)
				WHEN  '' '' THEN SUBSTRING(A.BIT045,2,16) 
				ELSE SUBSTRING(A.BIT035,0,17)
			END END AS CARTAO 
			 --SUBSTRING(A.BIT035,0,17) AS CARTAO,
			 --SUBSTRING(A.BIT045,2,16) AS BIT045,
			 --A.BIT002
		 FROM 
		 AuditoriaTransacoes A (NOLOCK)
			INNER JOIN AuditoriaTransacoes A1 (NOLOCK) ON A.CODIGO = A1.CODIGOREFERENCIA
			INNER JOIN AUT_CODIGOSRESPOSTA AA (NOLOCK) ON A1.CODIGORESPOSTA = AA.CODIGO
		 WHERE A.BIT001 in (''0200'',''0400'',''0420'')'
			   
	 IF  (@dDATAINI IS NOT NULL and @dDATAFIM IS NOT NULL)
		BEGIN
		 SET @SQL_1 = @SQL_1 + CHAR(10)+ 'AND A.DataHora BETWEEN '''+ Convert(Varchar,@dDATAINI,120) + ''' AND '''+ Convert(Varchar,@dDATAFIM,120) + ''''
		END
	 IF (@iCODESTAB IS NOT NULL AND ISNUMERIC(@iCODESTAB ) = 1)
		BEGIN
		 SET @SQL_1 = @SQL_1 +CHAR(10)+ 'AND A.BIT042 LIKE ''%'+CONVERT(VARCHAR,@iCODESTAB)+''''
		END
	 IF (@cCARTAO IS NOT NULL AND LEN(@cCARTAO) = 16)
		BEGIN
			SET @SQL_1 = @SQL_1 +CHAR(10)+ 'AND (A.BIT035 LIKE '''+CONVERT(VARCHAR,@cCARTAO)+'%'' OR A.BIT002 = '''+CONVERT(VARCHAR,@cCARTAO)+''' OR A.BIT045 LIKE ''%'+CONVERT(VARCHAR,@cCARTAO)+'%'')'
		END
	IF (@cCARTAO IS NOT NULL AND LEN(@cCARTAO) < 16)
	BEGIN
		SET @SQL_1 = @SQL_1 +CHAR(10)+ 'AND (A.BIT035 LIKE '''+CONVERT(VARCHAR,@cCARTAO)+'%'' OR A.BIT002 = '''+CONVERT(VARCHAR,@cCARTAO)+''' OR A.BIT045 LIKE ''%'+CONVERT(VARCHAR,@cCARTAO)+'%'')'
	END
	IF (@cREDE IS NOT NULL AND LEN(@cREDE) > 1)
		BEGIN
			SET @SQL_1 = @SQL_1 +CHAR(10)+ 'AND (A.BIT048 LIKE ''%'+CONVERT(VARCHAR,@cREDE)+'%'')'
		END	

	SET @SQL_1 = @SQL_1 +CHAR(10)+ 'ORDER BY A.DataHora'
	
	INSERT INTO @TEMP 
	EXEC SP_EXECUTESQL @SQL_1

	select @SQL_1


	
	SELECT 
		T.TIPO,
		T.CODIGORESPOSTA,
		T.BIT039,
		T.DESCRICAO,
		T.NSU,
		T.[Data],
        T.[Hora],
		T.VALOR,
		T.REDE,
		processadora.dbo.fn_SCR_MascararNumeroCartao(T.CARTAO,1) as NumCARTAO,
		TP.nome PRODUTO,
		CU.NOME AS NOME_NumCARTAO,
		E.NUMERO AS CODIGO_ESTABELECIMENTO,
		E.NOME AS NOME_ESTABELECIMENTO
		
	FROM @TEMP T
		INNER JOIN Processadora..Estabelecimentos E (nolock) on CONVERT(BIGINT,T.BIT042) = E.NUMERO
		INNER JOIN Processadora..CartoesUsuarios CU (Nolock) on t.CARTAO = cu.Numero and left(t.CARTAO,7) <> '6030780'
		INNER JOIN Processadora..TiposProdutos TP(nolock) on cu.tpoprdcodigo = tp.tpoprdcodigo
	WHERE T.REDE NOT IN ('CIELO', 'STONE')
	
		UNION
	SELECT 
		T.TIPO,
		T.CODIGORESPOSTA,
		T.BIT039,
		T.DESCRICAO,
		T.NSU,
		T.[Data],
        T.[Hora],
		T.VALOR,
		T.REDE,
		processadora.dbo.fn_SCR_MascararNumeroCartao(T.CARTAO,1) as NumCARTAO,
		TP.nome PRODUTO,
		CU.NOME AS NOME_NumCARTAO,
		E.CodigoEstabelecimento AS CODIGO_ESTABELECIMENTO,
		E.NOME AS NOME_ESTABELECIMENTO
	FROM @TEMP T
		INNER JOIN Acquirer..Estabelecimento E (nolock) on CONVERT(BIGINT,T.BIT042) = E.CodigoEstabelecimento
		INNER JOIN Processadora..CartoesUsuarios CU (Nolock) on t.CARTAO = cu.Numero and left(t.CARTAO,7) <> '6030780'
		INNER JOIN Processadora..TiposProdutos TP(nolock) on cu.tpoprdcodigo = tp.tpoprdcodigo
	WHERE T.REDE NOT IN ('CIELO', 'STONE')

	
	UNION

	SELECT 
		T.TIPO,
		T.CODIGORESPOSTA,
		T.BIT039,
		T.DESCRICAO,
		T.NSU,
		T.[Data],
        T.[Hora],
		T.VALOR,
		T.REDE,
		processadora.dbo.fn_SCR_MascararNumeroCartao(T.CARTAO,1) as CARTAO,
		CASE 
			WHEN left(t.CARTAO,8) = '60307800' THEN 'CONVENIO' 
			ELSE 'FROTA' 
		END AS PRODUTO ,
		CU.Nome_usuario AS NOME_NumCARTAO,
		E.NUMERO AS CODIGO_ESTABELECIMENTO,
		E.NOME AS NOME_ESTABELECIMENTO
	FROM @TEMP T
		INNER JOIN Processadora..Estabelecimentos E (nolock) on CONVERT(BIGINT,T.BIT042) = E.NUMERO
		INNER JOIN Policard_603078..Cartao_Usuario CU (Nolock) on t.CARTAO = cu.CodigoCartao and left(t.CARTAO,7) = '6030780'
	WHERE T.REDE NOT IN ('CIELO', 'STONE')

	UNION

	SELECT 
		T.TIPO,
		T.CODIGORESPOSTA,
		T.BIT039,
		T.DESCRICAO,
		T.NSU,
		T.[Data],
        T.[Hora],
		T.VALOR,
		T.REDE,
		processadora.dbo.fn_SCR_MascararNumeroCartao(T.CARTAO,1) as CARTAO,
		CASE 
			WHEN left(t.CARTAO,8) = '60307800' THEN 'CONVENIO' 
			ELSE 'FROTA' 
		END AS PRODUTO ,
		CU.Nome_usuario AS NOME_NumCARTAO,
		E.CodigoEstabelecimento AS CODIGO_ESTABELECIMENTO,
		E.NOME AS NOME_ESTABELECIMENTO
	FROM @TEMP T
		INNER JOIN Acquirer..Estabelecimento E (nolock) on CONVERT(BIGINT,T.BIT042) = E.CodigoEstabelecimento
		INNER JOIN Policard_603078..Cartao_Usuario CU (Nolock) on t.CARTAO = cu.CodigoCartao and left(t.CARTAO,7) = '6030780'
	WHERE T.REDE NOT IN ('CIELO', 'STONE')

	UNION

	SELECT 
		T.TIPO,
		T.CODIGORESPOSTA,
		T.BIT039,
		T.DESCRICAO,
		T.NSU,
		T.[Data],
        T.[Hora],
		T.VALOR,
		T.REDE,
		processadora.dbo.fn_SCR_MascararNumeroCartao(T.CARTAO,1) as CARTAO,
		TP.nome PRODUTO,
		CU.NOME AS NOME_NumCARTAO, 
		E.NUMERO AS CODIGO_ESTABELECIMENTO, 
		E.NOME AS NOME_ESTABELECIMENTO
	FROM @TEMP T
		INNER JOIN Processadora..EstabelecimentoCielo EC (NOLOCK) ON CONVERT(VARCHAR,CONVERT(BIGINT,T.BIT042)) = EC.CodigoCielo
		INNER JOIN Processadora..Estabelecimentos E (nolock) on EC.EstCodigo = E.EstCodigo
		INNER JOIN Processadora..CartoesUsuarios CU (Nolock) on t.CARTAO = cu.Numero and left(t.CARTAO,7) <> '6030780'
		INNER JOIN Processadora..TiposProdutos TP(nolock) on cu.tpoprdcodigo = tp.tpoprdcodigo
	WHERE T.REDE = 'CIELO'

	UNION

	SELECT 
		T.TIPO,
		T.CODIGORESPOSTA,
		T.BIT039,
		T.DESCRICAO,
		T.NSU,
		T.[Data],
        T.[Hora],
		T.VALOR,
		T.REDE,
		processadora.dbo.fn_SCR_MascararNumeroCartao(T.CARTAO,1) as CARTAO,
		TP.nome PRODUTO,
		CU.NOME AS NOME_NumCARTAO, 
		E.CodigoEstabelecimento AS CODIGO_ESTABELECIMENTO, 
		E.NOME AS NOME_ESTABELECIMENTO
	FROM @TEMP T
		INNER JOIN Acquirer..EstabelecimentoCielo EC (NOLOCK) ON CONVERT(VARCHAR,CONVERT(BIGINT,T.BIT042)) = EC.CodigoEstabelecimentoCielo
		INNER JOIN Acquirer..Estabelecimento E (nolock) on EC.CodigoEstabelecimento = E.CodigoEstabelecimento
		INNER JOIN Processadora..CartoesUsuarios CU (Nolock) on t.CARTAO = cu.Numero and left(t.CARTAO,7) <> '6030780'
		INNER JOIN Processadora..TiposProdutos TP(nolock) on cu.tpoprdcodigo = tp.tpoprdcodigo
	WHERE T.REDE = 'CIELO'

	UNION

	SELECT 
		T.TIPO,
		T.CODIGORESPOSTA,
		T.BIT039,
		T.DESCRICAO,
		T.NSU,
		T.[Data],
        T.[Hora],
		T.VALOR,
		T.REDE,
		processadora.dbo.fn_SCR_MascararNumeroCartao(T.CARTAO,1) as CARTAO,
		CASE 
			WHEN left(t.CARTAO,8) = '60307800' THEN 'CONVENIO' 
			ELSE 'FROTA' 
		END AS PRODUTO ,
		CU.Nome_usuario AS NOME_NumCARTAO,
		E.CodigoEstabelecimento AS CODIGO_ESTABELECIMENTO, 
		E.NOME AS NOME_ESTABELECIMENTO
	FROM @TEMP T
		INNER JOIN Acquirer..EstabelecimentoCielo EC (NOLOCK) ON CONVERT(VARCHAR,CONVERT(BIGINT,T.BIT042)) = EC.CodigoEstabelecimentoCielo
		INNER JOIN Acquirer..Estabelecimento E (nolock) on EC.CodigoEstabelecimento = E.CodigoEstabelecimento
		INNER JOIN Policard_603078..Cartao_Usuario CU (Nolock) on t.CARTAO = cu.CodigoCartao and left(t.CARTAO,7) = '6030780'
	WHERE T.REDE = 'CIELO'

	UNION

	SELECT 
		T.TIPO,
		T.CODIGORESPOSTA,
		T.BIT039,
		T.DESCRICAO,
		T.NSU,
		T.[Data],
        T.[Hora],
		T.VALOR,
		T.REDE,
		processadora.dbo.fn_SCR_MascararNumeroCartao(T.CARTAO,1) as CARTAO,
		CASE 
			WHEN left(t.CARTAO,8) = '60307800' THEN 'CONVENIO' 
			ELSE 'FROTA' 
		END AS PRODUTO ,
		CU.Nome_usuario AS NOME_NumCARTAO,
		E.NUMERO AS CODIGO_ESTABELECIMENTO, 
		E.NOME AS NOME_ESTABELECIMENTO
	FROM @TEMP T
		INNER JOIN Processadora..EstabelecimentoCielo EC (NOLOCK) ON CONVERT(VARCHAR,CONVERT(BIGINT,T.BIT042)) = EC.CodigoCielo
		INNER JOIN Processadora..Estabelecimentos E (nolock) on EC.EstCodigo = E.EstCodigo
		INNER JOIN Policard_603078..Cartao_Usuario CU (Nolock) on t.CARTAO = cu.CodigoCartao and left(t.CARTAO,7) = '6030780'
	WHERE T.REDE = 'CIELO'

	UNION

	SELECT 
		T.TIPO,
		T.CODIGORESPOSTA,
		T.BIT039,
		T.DESCRICAO,
		T.NSU,
		T.[Data],
        T.[Hora],
		T.VALOR,
		T.REDE,
		processadora.dbo.fn_SCR_MascararNumeroCartao(T.CARTAO,1) as CARTAO,
		TP.nome PRODUTO,
		CU.NOME AS NOME_NumCARTAO, 
		E.NUMERO AS CODIGO_ESTABELECIMENTO, 
		E.NOME AS NOME_ESTABELECIMENTO
	FROM @TEMP T
		INNER JOIN Acquirer..EstabelecimentoStone Es (NOLOCK) ON CONVERT(BIGINT,T.BIT042) = es.Codigoestabelecimento
		INNER JOIN Processadora..Estabelecimentos E (nolock) on Es.Codigoestabelecimento = E.Numero
		INNER JOIN Processadora..CartoesUsuarios CU (Nolock) on t.CARTAO = cu.Numero and left(t.CARTAO,7) <> '6030780'
		INNER JOIN Processadora..TiposProdutos TP(nolock) on cu.tpoprdcodigo = tp.tpoprdcodigo
	WHERE T.REDE = 'STONE'

	UNION

	SELECT 
		T.TIPO,
		T.CODIGORESPOSTA,
		T.BIT039,
		T.DESCRICAO,
		T.NSU,
		T.[Data],
        T.[Hora],
		T.VALOR,
		T.REDE,
		processadora.dbo.fn_SCR_MascararNumeroCartao(T.CARTAO,1) as CARTAO,
		TP.nome PRODUTO,
		CU.NOME AS NOME_NumCARTAO, 
		E.Codigoestabelecimento AS CODIGO_ESTABELECIMENTO, 
		E.NOME AS NOME_ESTABELECIMENTO
	FROM @TEMP T
		INNER JOIN Acquirer..EstabelecimentoStone Es (NOLOCK) ON CONVERT(BIGINT,T.BIT042) = es.Codigoestabelecimento
		INNER JOIN Acquirer..Estabelecimento E (nolock) on Es.Codigoestabelecimento = E.Codigoestabelecimento
		INNER JOIN Processadora..CartoesUsuarios CU (Nolock) on t.CARTAO = cu.Numero and left(t.CARTAO,7) <> '6030780'
		INNER JOIN Processadora..TiposProdutos TP(nolock) on cu.tpoprdcodigo = tp.tpoprdcodigo
	WHERE T.REDE = 'STONE'

	UNION

	SELECT 
		T.TIPO,
		T.CODIGORESPOSTA,
		T.BIT039,
		T.DESCRICAO,
		T.NSU,
		T.[Data]  as [Data],
         T.[Hora]  as [Hora],
		T.VALOR,
		T.REDE,
		processadora.dbo.fn_SCR_MascararNumeroCartao(T.CARTAO,1) as NumCARTAO,
		CASE 
			WHEN left(t.CARTAO,8) = '60307800' THEN 'CONVENIO' 
			ELSE 'FROTA' 
		END AS PRODUTO ,
		CU.Nome_usuario AS NOME_NumCARTAO,
		E.NUMERO AS CODIGO_ESTABELECIMENTO, 
		E.NOME AS NOME_ESTABELECIMENTO
	FROM @TEMP T
		INNER JOIN Acquirer..EstabelecimentoStone Es (NOLOCK) ON CONVERT(BIGINT,T.BIT042) = es.Codigoestabelecimento
		INNER JOIN Processadora..Estabelecimentos E (nolock) on Es.Codigoestabelecimento = E.Numero
		INNER JOIN Policard_603078..Cartao_Usuario CU (Nolock) on t.CARTAO = cu.CodigoCartao and left(t.CARTAO,7) = '6030780'
	WHERE T.REDE = 'STONE'

	UNION

	SELECT 
		T.TIPO,
		T.CODIGORESPOSTA,
		T.BIT039,
		T.DESCRICAO,
		T.NSU,
		T.[Data] ,
        T.[Hora] ,
		T.VALOR,
		T.REDE,
		processadora.dbo.fn_SCR_MascararNumeroCartao(T.CARTAO,1) as NumCARTAO,
		CASE 
			WHEN left(t.CARTAO,8) = '60307800' THEN 'CONVENIO' 
			ELSE 'FROTA' 
		END AS PRODUTO ,
		CU.Nome_usuario AS NOME_NumCARTAO,
		E.Codigoestabelecimento AS CODIGO_ESTABELECIMENTO, 
		E.NOME AS NOME_ESTABELECIMENTO
	FROM @TEMP T
		INNER JOIN Acquirer..EstabelecimentoStone Es (NOLOCK) ON CONVERT(BIGINT,T.BIT042) = es.Codigoestabelecimento
		INNER JOIN Acquirer..Estabelecimento E (nolock) on Es.Codigoestabelecimento = E.Codigoestabelecimento
		INNER JOIN Policard_603078..Cartao_Usuario CU (Nolock) on t.CARTAO = cu.CodigoCartao and left(t.CARTAO,7) = '6030780'
	WHERE T.REDE = 'STONE'
	order by 6,7
	
END

-- exec PR_DBA_RELATORIOTRANSACOES null,null,null,null,null