

/*  
--------------------------------------------------------------------------
Projeto: Autorização
Objeto:  pr_AUT_EstornarTransacoesTesteProcessadora
Propósito: Estornar transações dos clientes TESTE da Base Processadora
		   todos os dias antes da virada do dia.
Autor:  Wanderson Gomes Colatino - P&D
--------------------------------------------------------------------------
Criação: 18/02/2017
Chamado:356946 / 2603
---------------------------------------------------------------------------
Alteração: 21/12/2017
Chamado: 412948/3544
Autor: Raimundo de Souza Miranda Junior
--------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[pr_AUT_EstornarTransacoesTesteProcessadora]
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @VTable TABLE	(TrnCodigo			 INT			NULL
							,EstCodigo			 INT			NULL
							,TpoTrnCodigo		 INT			NULL
							,CrtUsrCodigo		 INT			NULL
							,NumeroCartao		 VARCHAR(16)	NULL
							,Estabelecimento	 INT			NULL
							,TpoPrdCodigo		 INT			NULL
							,MeiCptCodigo		 INT			NULL
							,RdeCodigo			 INT			NULL
							,Valor				 DECIMAL(15,2)	NULL
							,Data				 DATETIME		NULL
							,Parcelas			 INT			NULL
							,DataGMT			 CHAR(10)		NULL
							,TaxaJuros			 DECIMAL(6,2)	NULL
							,Status				 CHAR(1)		NULL
							,DataAutorizacao	 DATETIME		NULL
							,DataSolicitacao	 DATETIME		NULL
							,Lote				 INT			NULL
							,Comprovante		 CHAR(6)		NULL
							,Autorizacao		 CHAR(18)		NULL
							,NSUOrigem			 CHAR(6)		NULL
							,Comissao			 DECIMAL(5,2)	NULL
							,PrdCodigo			 INT			NULL
							,TipoMensagem		 CHAR(4)		NULL
							,Terminal			 CHAR(8)		NULL
							--,NroDocumentoPago	 VARCHAR(50)	NULL
							--,NSU_Phoebus		 INT			NULL
							,Comprovante_FormGen CHAR(6)		NULL
							,DataLocal			 CHAR(4)		NULL
							,HoraLocal			 CHAR(6)		NULL
							,FlagTarifacao		 INT			NULL
							,VinculoTransacao	 INT			NULL
							,Estornado			 BIT
							,EstabMigrado        BIT            NULL)

	DECLARE @DataHora DATETIME
	SET @DataHora = GETDATE()

	INSERT INTO @VTable
	SELECT	 T.TrnCodigo
			,T.EstCodigo
			,T.TpoTrnCodigo
			,T.CrtUsrCodigo
			,C.Numero
			,T.codestab
			,T.TpoPrdCodigo
			,T.MeiCptCodigo
			,r.Numero
			,T.Valor
			,T.Data
			,T.Parcelas
			,T.DataGMT
			,T.TaxaJuros
			,T.Status
			,T.DataAutorizacao
			,T.DataSolicitacao
			,T.Lote
			,T.Comprovante
			,T.Autorizacao
			,T.NSUOrigem
			,T.Comissao
			,T.PrdCodigo
			,T.TipoMensagem
			,T.Terminal
			--,T.NroDocumentoPago
		--	,T.NSU_Phoebus
			,T.Comprovante_FormGen
			,T.DataLocal
			,T.HoraLocal
			,T.FlagTarifacao
			,T.VinculoTransacao
			,0
			,T.estabMigrado
	FROM	Processadora.dbo.Transacoes T WITH(NOLOCK)
			INNER JOIN Processadora.dbo.Redes r with (nolock) ON t.RdeCodigo = r.RdeCodigo
			INNER JOIN Processadora.dbo.CartoesUsuarios C WITH(NOLOCK) ON (C.CrtUsrCodigo = T.CrtUsrCodigo)
		--	INNER JOIN ContasUsuarios CO WITH(NOLOCK) ON (CO.CntUsrCodigo = C.CntUsrCodigo)
		--	INNER JOIN Processadora..Propostas P WITH(NOLOCK) ON (P.PrpCodigo = CO.PrpCodigo)
		--	INNER JOIN Processadora..Entidades E WITH(NOLOCK) ON (E.EntCodigo = P.EntCodigo)
		--	INNER JOIN Estabelecimentos ES WITH(NOLOCK) ON (ES.EstCodigo = T.EstCodigo)
	WHERE	T.CodCliente IN (49959,49960,49961,49962,50143,82879,106406,178991)
			AND T.Status NOT IN ('D','E') -- D = Desfazimento | E = Estorno
			AND T.TipoMensagem <> '0400'
			AND T.Valor > 0
			AND CONVERT(CHAR(10),DataAutorizacao,120) BETWEEN CONVERT(CHAR(10),@DataHora - 1,120) AND CONVERT(CHAR(10),@DataHora,120)
	ORDER BY TrnCodigo DESC

	WHILE EXISTS (SELECT * FROM @VTable WHERE Estornado = 0)
	BEGIN
		DECLARE  @TrnCodigo								INT
				,@iEstCodigo							INT
				,@cNumeroCartao							CHAR(16)
				,@cCodigoProcessamento					CHAR(6)
				,@nValor								DECIMAL(15,2)
				,@cDataHoraGMT							CHAR(10)
				,@cNumeroIdentificacaoTransacao			CHAR(6)
				,@cHoraLocal							CHAR(6)
				,@cDataLocal							CHAR(4)
				,@cCodigoIdentificaoRedeCaptura			CHAR(4)
				,@cNSURedeCaptura						CHAR(12)
				,@cComprovanteResposta					CHAR(6)
				,@cBit039                               CHAR(2)
				,@cIdentificaoTerminal					CHAR(8)
				,@iCodigoIdentificacaoEstabelecimento	INT
				,@cInformacoesAdicionais				VARCHAR(1000)
				,@cDadosAdicionaisTerminal				VARCHAR(5)
				,@cDadosIdentificaoTransacaoOriginal	VARCHAR(99)
				,@cInfPolicard							VARCHAR(1000)
				,@cBit123								VARCHAR(16)	
				,@cTicketRetorno						VARCHAR(1000)
				,@cBit063								VARCHAR(1000)
				,@iResposta								INT
				,@dDataHora_Transacao					DATETIME
				,@cResponsavel_Transacao				VARCHAR(50)
				,@estabMigrado                          BIT

		SELECT	 TOP 1
				 @TrnCodigo								= TrnCodigo
				,@cNumeroCartao							= NumeroCartao
				,@iEstCodigo							= EstCodigo
				,@cCodigoProcessamento					= '210000'
				,@nValor								= Valor
				,@cDataHoraGMT							= DataGMT
				,@cNumeroIdentificacaoTransacao			= NSUOrigem
				,@cHoraLocal							= HoraLocal
				,@cDataLocal							= DataLocal
				,@cCodigoIdentificaoRedeCaptura			= CONVERT(VARCHAR, RdeCodigo)
				,@cNSURedeCaptura						= ''
				,@cComprovanteResposta					= ''
				,@cBit039								= ''
				,@cIdentificaoTerminal					= Terminal
				,@iCodigoIdentificacaoEstabelecimento	= Estabelecimento
				,@cInformacoesAdicionais				= ''
				,@cDadosAdicionaisTerminal				= ''
				,@cDadosIdentificaoTransacaoOriginal	= TipoMensagem + '003000' + NSUOrigem + DataGMT + HoraLocal + DataLocal + '000000'
				,@cInfPolicard							= ''
				,@cBit123     							= ''
				,@cTicketRetorno						= ''
				,@cBit063	                            = ''
				,@iResposta								= 0
				,@dDataHora_Transacao					= DataAutorizacao
				,@cResponsavel_Transacao				= ''
				,@estabMigrado                          = estabMigrado
		FROM	@VTable
		WHERE	Estornado = 0

		EXEC Autorizador.dbo.pr_aut_EstornarProcessadora
											 @cCodigoProcessamento						OUTPUT	--@cBit003
											,@nValor											--@cBit004
											,@cDataHoraGMT      								--@cBit007
											,@cNumeroIdentificacaoTransacao				OUTPUT  --@cBit011
											,@cHoraLocal										--@cBit012
											,@cDataLocal										--@cBit013
											,@cNSURedeCaptura							OUTPUT  --@cBit037
											,@cComprovanteResposta						OUTPUT  --@cBit038 
											,@cBit039									OUTPUT	--@cBit039
											,@cIdentificaoTerminal								--@cBit041
											,@cInformacoesAdicionais					OUTPUT  --@cBit048
											,@cDadosAdicionaisTerminal							--@cBit060
											,@cTicketRetorno							OUTPUT	--@cBit062
											,@cBit063									OUTPUT	--@cBit063
											,@cDadosIdentificaoTransacaoOriginal		OUTPUT  --@cBit090
											,@cInfPolicard								OUTPUT  --@cBit105
											,@cBit123   										--@cBit123					
											,@TrnCodigo									OUTPUT  --@cBit127
											,@cNumeroCartao								OUTPUT  --@cNumeroCartao
											,@nValor									OUTPUT	--@nValor_Transacao
											,@dDataHora_Transacao								--@dDataHora_Transacao 
											,@cCodigoIdentificaoRedeCaptura						--@iRedeNumero		
											,@iCodigoIdentificacaoEstabelecimento				--@iCodigoEstabelecimento
											,@estabMigrado										--@bEstabMigrado
											,@iResposta									OUTPUT  --@iResposta
											 
		
	

		UPDATE @VTable SET Estornado = 1 WHERE TrnCodigo = @TrnCodigo
	END
END



