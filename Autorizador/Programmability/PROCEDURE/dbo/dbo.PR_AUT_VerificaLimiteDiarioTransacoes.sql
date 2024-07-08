/*=========== CHANGELOG ===========
Data: 19/07/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1867627
Descrição: Criação do objeto
--------------------------------------------------------------------------------------------------
Data: 17/10/2023
Autor: Adilson Pereira - Up Brasil
Chamado: 2067120 
Descrição: Altera consulta para considerar apenas transações 0200.
--------------------------------------------------------------------------------------------------
*/
CREATE PROCEDURE dbo.PR_AUT_VerificaLimiteDiarioTransacoes (
	@cNumeroCartao VARCHAR(24)
	,@cBaseOrigem CHAR(1)
	,@nValorTransacao DECIMAL(15, 2)
	,@iResposta INT OUTPUT
	)
AS
BEGIN
	DECLARE @numTransacaoDiaria INT = 0;
	DECLARE @limiteTransacaoDiaria DECIMAL(15, 2) = 0;
	DECLARE @numTransacaoDiariaCartao INT = 0;
	DECLARE @valorTransacaoDiariaCartao DECIMAL(15, 2) = 0;

	SET @iResposta = 0;

	IF (@cBaseOrigem = 'P')
	BEGIN
		DECLARE @crtUsrCodigo INT;
		DECLARE @usarTravaCliente BIT;
		DECLARE @tpoPrdCodigo INT;
		DECLARE @codEntidade INT;
		DECLARE @flgLiberarProximaTransacao BIT;
		DECLARE @flgClienteWhiteList BIT;

		SELECT @usarTravaCliente = ISNULL(pae.UsarTravaCliente, 0)
			,@tpoPrdCodigo = cu.TpoPrdCodigo
			,@crtUsrCodigo = cu.CrtUsrCodigo
			,@numTransacaoDiaria = ISNULL(pae.NumTransacaoDiaria, 0)
			,@limiteTransacaoDiaria = ISNULL(pae.LimiteTransacaoDiaria, 0)
			,@codEntidade = p.EntCodigo
			,@flgLiberarProximaTransacao = ISNULL(cu.LiberarProximaTransacao, 0)
		FROM Processadora.dbo.CartoesUsuarios AS cu WITH (NOLOCK)
		INNER JOIN Processadora.dbo.ContasUsuarios AS cu2 WITH (NOLOCK) ON cu.CntUsrCodigo = cu2.CntUsrCodigo
		INNER JOIN Processadora.dbo.Propostas AS p WITH (NOLOCK) ON cu2.PrpCodigo = p.PrpCodigo
		LEFT JOIN Processadora.dbo.ProdutosAgentesEmissores AS pae WITH (NOLOCK) ON p.EntCodigo = pae.EntCodigo
		WHERE cu.Numero = @cNumeroCartao
			AND pae.PrdCodigo = cu.PrdCodigo
			AND pae.TpoPrdCodigo = cu.TpoPrdCodigo;

		IF @flgLiberarProximaTransacao = 1
		BEGIN
			UPDATE Processadora.dbo.CartoesUsuarios
			SET LiberarProximaTransacao = 0
			WHERE CrtUsrCodigo = @crtUsrCodigo;

			RETURN;
		END
		ELSE
		BEGIN
			SELECT @flgClienteWhiteList = ISNULL(e.WhiteList, 0)
			FROM Processadora.dbo.Entidades AS e WITH (NOLOCK)
			WHERE e.EntCodigo = @codEntidade;

			IF @flgClienteWhiteList = 1
			BEGIN
				RETURN;
			END
		END

		IF @usarTravaCliente = 0
		BEGIN
			SELECT @numTransacaoDiaria = tp.NumTransacaoDiaria
				,@limiteTransacaoDiaria = tp.LimiteTransacaoDiaria
			FROM Processadora.dbo.TiposProdutos AS tp WITH (NOLOCK)
			WHERE tp.TpoPrdCodigo = @tpoPrdCodigo;
		END

		IF @numTransacaoDiaria <> 0
			OR @limiteTransacaoDiaria <> 0
		BEGIN
			SELECT @numTransacaoDiariaCartao = count(1)
				,@valorTransacaoDiariaCartao = sum(t.Valor)
			FROM Processadora.dbo.transacoes AS t WITH (NOLOCK)
			WHERE t.[Data] > cast(GETDATE() AS DATE)
				AND t.CrtUsrCodigo = @crtUsrCodigo
				AND t.STATUS IN (
					'A'
					,'P'
					)
				AND t.TipoMensagem = '0200'
			GROUP BY t.CrtUsrCodigo;

			IF @numTransacaoDiaria <> 0
				AND @numTransacaoDiariaCartao + 1 > @numTransacaoDiaria
				SET @iResposta = 418
			ELSE IF @limiteTransacaoDiaria <> 0
				AND @valorTransacaoDiariaCartao + @nValorTransacao > @limiteTransacaoDiaria
				SET @iResposta = 419
		END
	END
END