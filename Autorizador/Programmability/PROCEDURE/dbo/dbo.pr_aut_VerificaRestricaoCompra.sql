---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* 
------------------------------------------------------------------------------
Nome Sistema: Autorização
Objeto: [dbo].[pr_aut_VerificaRestricaoCompra]
Propósito: Procedure responsável por verificar restricoes do estabelecimento e 
cliente
Autor: Cristiano Silva Barbosa - Tecnologia Policard
-------------------------------------------------------------------------------
Chamado:364190
MUDANCA: 2670
-------------------------------------------------------------------------------
Chamado:637283
MUDANCA: Emergencial
Autor: João Henrique
-------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[pr_aut_VerificaRestricaoCompra](
		 @cBaseOrigem				CHAR(1)
		,@iCodigoEstabelecimento	INT
		,@bEstabMigrado				BIT
		,@iTpoPrdCodigo				INT
		,@iCntUsrCodigo				INT
		,@iCrtUsrCodigo				INT
		,@iFranquiaUsuario			INT
		,@iCliente					INT
		,@bMonitorTrn				BIT		OUTPUT
		,@iResposta					INT		OUTPUT

	)

AS
BEGIN

	SET NOCOUNT ON;

	DECLARE 
		 @iRstRegiao				INT
		,@iDvsEstCodigo				INT
		,@iRamAtvCodigo				INT
		,@iEstCodigo				INT
		,@cCidade_Estabelecimento	VARCHAR(50)
		,@cEstado_Estabelecimento	CHAR(2)
		,@bRestricaoEstabelecimento	BIT
		,@cStatus_AgenteEmissor		CHAR(1)
		,@bRetemSaldo				BIT
		,@iTpoEntCodigo				INT
		,@iEntCodigo				INT
		,@iPrpCodigo				INT
	

	IF (@bEstabMigrado = 0)
	BEGIN 
		
		IF(@cBaseOrigem = 'P')
		BEGIN

			/* Consulta base de estabelecimento */
			SELECT 
				 @iDvsEstCodigo					= EST.DvsEstCodigo
				,@iEstCodigo					= EST.EstCodigo
				,@IRamAtvCodigo					= EST.RamAtvCodigo
				,@iRstRegiao					= EST.RstRegiao
				,@cCidade_Estabelecimento		= LTRIM(RTRIM(EST.Cidade))
				,@cEstado_Estabelecimento		= EST.Estado
			FROM Processadora.dbo.Estabelecimentos EST WITH(NOLOCK)
			WHERE EST.Numero = @iCodigoEstabelecimento

			SET @cCidade_Estabelecimento = dbo.f_FormatarTexto(@cCidade_Estabelecimento)


			IF (@iResposta = 0)
			BEGIN

				SELECT   @iPrpCodigo = CU.PrpCodigo
				FROM	Processadora.dbo.ContasUsuarios CU WITH(HOLDLOCK, ROWLOCK)
				WHERE	CU.CntUsrCodigo = @iCntUsrCodigo

				SELECT	@iEntCodigo = EntCodigo
				FROM	Processadora.dbo.Propostas WITH(NOLOCK)
				WHERE	PrpCodigo = @iPrpCodigo

				SELECT	 @iTpoEntCodigo = TpoEntCodigo
						,@bRetemSaldo = ISNULL(ReterSaldo,1)
				FROM	Processadora.dbo.Entidades WITH(NOLOCK)
				WHERE	EntCodigo = @iEntCodigo
				

				SELECT	@cStatus_AgenteEmissor = Status
						,@bRestricaoEstabelecimento = ISNULL(Restricao,0)
				FROM Processadora.dbo.TiposProdutosEntidades WITH(NOLOCK)
				WHERE TpoEntCodigo = @iTpoEntCodigo	-- Constante 4 que é o código referente ao tipo em questão cadastrado.
				AND TpoPrdCodigo = @iTpoPrdCodigo	-- Campo "TpoPrdCodigo" obtido na consulta a entidade cartoesusuarios
				AND EntCodigo = @iEntCodigo			-- Campo "EntCodigo" obtido na consulta a entidade Entidades


				----------------------------------------------------------------------------------------------
				--Nome      : Validar_Status_AgenteEmissor
				--Descrição : Caso o campo "Status", obtido na consulta a entidade TiposProdutosEntidades for diferente de 'A'
				--Cod. resp.: --
				----------------------------------------------------------------------------------------------
				IF (@cStatus_AgenteEmissor <> 'A')
				BEGIN
					IF (@cStatus_AgenteEmissor = 'B')
					BEGIN
						IF (@bRetemSaldo = 1)
							SET @iResposta = 329
					END
					ELSE
						SET @iResposta = 292 /* AGENTE EMISSOR BLOQUEADO OU CANCELADO - TRANSACAO NAO AUTORIZADA */
				END
			END



			IF (@iResposta = 0)
			BEGIN
				----------------------------------------------------------------------------------------------
				--Nome      : Validar_Restricao_Estabelecimento_Conta_usuario
				--Descrição : Valida existência de restrições para o estabelecimento de acordo com a regra abaixo:
				--			  Caso o campo "CntUsrCodigo" obtido na consulta a entidade RestricoesEstabelecimento
				--			  for semelhante ao campo "CntUsrCodigo" obtido na consulta a entidade contasusuarios.
				--Cod. resp.: --
				----------------------------------------------------------------------------------------------
				IF EXISTS  (SELECT	TOP 1 1
							FROM	Autorizacao.dbo.RestricoesEstabelecimento WITH(NOLOCK)
							WHERE	AgtEmsCodigo		= @iCliente
									AND CntUsrCodigo	= @iCntUsrCodigo -- Campo "CntUsrCodigo" obtido na consulta a entidade Contasusuarios ou que o valor do campo seja 0
									AND TipoVerificacao = 'E')
					SET @iResposta = 276 /* CLIENTE NAO AUTORIZOU VENDAS NESSE ESTABELECIMENTO - NAO PERMITIDA */

				----------------------------------------------------------------------------------------------
				--Nome      : Validar_Restricao_Estabelecimento_Regiao
				--Descrição : Valida existência de restrições para o estabelecimento de acordo com a regra abaixo:
				--			  Caso o campo "RstRegiao" obtido na consulta a entidade RestricoesEstabelecimento
				--			  for semelhante ao campo "RstRegiao" obtido na consulta a entidade contasusuarios.
				--Cod. resp.: --
				----------------------------------------------------------------------------------------------
				IF EXISTS ( SELECT	TOP 1 1
							FROM	Autorizacao.dbo.RestricoesEstabelecimento WITH(NOLOCK)
							WHERE	AgtEmsCodigo		= @iCliente
									AND (CntUsrCodigo	= 0 OR CntUsrCodigo = @iCntUsrCodigo)
									AND TipoVerificacao = 'E'
									AND RstRegiao		= @iRstRegiao)
					SET @iResposta = 276 /* CLIENTE NAO AUTORIZOU VENDAS NESSE ESTABELECIMENTO - NAO PERMITIDA */

				----------------------------------------------------------------------------------------------
				--Nome      : Validar_Restricao_Estabelecimento_PorCodigo
				--Descrição : Valida existência de restrições para o estabelecimento de acordo com a regra abaixo:
				--			  Caso o campo "EstCodigo" obtido na consulta a entidade RestricoesEstabelecimento
				--			  for semelhante ao Parâmetro de entrada referente ao código Policard do estabelecimento.
				----------------------------------------------------------------------------------------------
				IF EXISTS ( SELECT	TOP 1 1
							FROM	Autorizacao.dbo.RestricoesEstabelecimento WITH(NOLOCK)
							WHERE	AgtEmsCodigo		= @iCliente
									AND (CntUsrCodigo	= 0 OR CntUsrCodigo = @iCntUsrCodigo)
									AND TipoVerificacao = 'E'
									AND EstCodigo		= @iEstCodigo)
					SET @iResposta = 276 /* CLIENTE NAO AUTORIZOU VENDAS NESSE ESTABELECIMENTO - NAO PERMITIDA */

				----------------------------------------------------------------------------------------------
				--Nome      : Validar_Restricao_Estabelecimento_DvsEstCodigo
				--Descrição : Valida existência de restrições para o estabelecimento de acordo com a regra abaixo:
				--			  Caso o campo "DvsEstCodigo" obtido na consulta a entidade RestricoesEstabelecimento
				--			  for semelhante ao campo "DvsEstCodigo" obtido na consulta a entidade contasusuarios.
				----------------------------------------------------------------------------------------------
				IF EXISTS ( SELECT	TOP 1 1
							FROM	Autorizacao.dbo.RestricoesEstabelecimento WITH(NOLOCK)
							WHERE	AgtEmsCodigo		= @iCliente
									AND (CntUsrCodigo	= 0 OR CntUsrCodigo = @iCntUsrCodigo)
									AND TipoVerificacao = 'E'
									AND DvsEstCodigo	= @iDvsEstCodigo)
					SET @iResposta = 276 /* CLIENTE NAO AUTORIZOU VENDAS NESSE ESTABELECIMENTO - NAO PERMITIDA */

				----------------------------------------------------------------------------------------------
				--Nome      : Validar_Restricao_Estabelecimento_Ramo_Atividade
				--Descrição : Valida existência de restrições para o estabelecimento de acordo com a regra abaixo:
				--			  Caso o campo "RamAtvCodigo" obtido na consulta a entidade RestricoesEstabelecimento
				--			  for semelhante ao campo "RamAtvCodigo" obtido na consulta a entidade contasusuarios.
				----------------------------------------------------------------------------------------------
				IF EXISTS ( SELECT	TOP 1 1
							FROM	Autorizacao.dbo.RestricoesEstabelecimento WITH(NOLOCK)
							WHERE	AgtEmsCodigo		= @iCliente
									AND (CntUsrCodigo	= 0 OR CntUsrCodigo = @iCntUsrCodigo)
									AND TipoVerificacao = 'E'
									AND RamAtvCodigo	= @iRamAtvCodigo)
					SET @iResposta = 276 /* CLIENTE NAO AUTORIZOU VENDAS NESSE ESTABELECIMENTO - NAO PERMITIDA */
			
				IF (@bRestricaoEstabelecimento = 1)
				BEGIN
		
					IF NOT EXISTS ( SELECT	TOP 1 1
							FROM	Autorizacao.dbo.RestricoesEstabelecimento WITH(NOLOCK)
							WHERE	AgtEmsCodigo		= @iCliente
									AND (CntUsrCodigo	= 0 OR CntUsrCodigo = @iCntUsrCodigo)
									AND TipoVerificacao = 'I'
									AND EstCodigo		= @iEstCodigo)-- ESTABELECIMENTO - NAO PERMITIDA */
			
					SET @iResposta = 337
			
			
					IF EXISTS ( SELECT	TOP 1 1
							FROM	Autorizacao.dbo.RestricoesEstabelecimento WITH(NOLOCK)
							WHERE	AgtEmsCodigo		= @iCliente
									AND (CntUsrCodigo	= 0 OR CntUsrCodigo = @iCntUsrCodigo)
									AND TipoVerificacao = 'E'
									AND EstCodigo		= @iEstCodigo)-- ESTABELECIMENTO - NAO PERMITIDA */
			
					SET @iResposta = 337
			
				END
		
			END

		END 


	END
	ELSE IF (@bEstabMigrado = 1)
	BEGIN


		DECLARE @bPermissao	 BIT
			,@CodigoRedeRestricao INT
		
		IF(@cBaseOrigem = 'P')
			SET @iFranquiaUsuario = 0

		EXEC aCQUIRER..pr_ACQ_ConsultarPermissaoEstabelecimento  
			 @iCodigoEstabelecimento	
			,@iCliente					
			,@iTpoPrdCodigo		
			,@iFranquiaUsuario			
			,@bPermissao			OUTPUT	
			,@CodigoRedeRestricao	OUTPUT

		IF @CodigoRedeRestricao <> 0
			SET @iResposta = 276

	
	END

	-- INI: TRAVA EMERGENCIAL PARA TRANSAÇÕES DE CARTÕES PAT DE OUTROS ESTADOS NO ESTADO DE SP
	-- CHAMADO: 169173
	IF (@iResposta = 0)
	BEGIN

		DECLARE  @cUfCliente	CHAR(2)
				,@sCidadeUsr	VARCHAR(100)
				
		SET @bMonitorTrn = 0

		SELECT	
			 @cUfCliente  = COALESCE(E.Estado,'')
			,@sCidadeUsr = COALESCE(E.Cidade,'')
		FROM Processadora.dbo.CartoesUsuarios C WITH(NOLOCK)
		INNER JOIN Processadora.dbo.ContasUsuarios CO WITH(NOLOCK) ON (CO.CntUsrCodigo = C.CntUsrCodigo)
		INNER JOIN Processadora.dbo.Propostas P WITH(NOLOCK) ON (P.PrpCodigo = CO.PrpCodigo)
		INNER JOIN Processadora.dbo.Entidades E WITH(NOLOCK) ON (E.EntCodigo = P.EntCodigo)
		WHERE C.CrtUsrCodigo = @iCrtUsrCodigo
		AND C.CntUsrCodigo = @iCntUsrCodigo
		AND C.TpoPrdCodigo IN (5,24,30,31,62,63,66,68)
		AND E.EntCodigo NOT IN (82879,84105,132114,136617) /*Usuarios do cliente Policard, Embasa e Petrox poderão efetuar vendas*/
		--AND (E.EntCodigo = 114055 OR E.Cidade = 'JUIZ DE FORA')/*Regra implementada incorretamente e removida conforme solicitação da Gestão de Risco*/

		IF (@cEstado_Estabelecimento = 'SP' AND @cUfCliente <> 'SP')
		BEGIN
			IF (EXISTS (SELECT	1
						FROM Processadora..TiposProdutos TP WITH(NOLOCK)
						INNER JOIN Processadora..TiposProdutosEntidades TPE WITH(NOLOCK) ON (TPE.TpoPrdCodigo = TP.TpoPrdCodigo)
						WHERE	TPE.EntCodigo = @iCliente
								AND TPE.TpoPrdCodigo = @iTpoPrdCodigo
								AND TP.inSGP = 'S')
								AND @cCidade_Estabelecimento IN ('SAO PAULO','SUZANO','MOGI DAS CRUZES','RIBEIRAO PIRES','MAUA','SAO BERNARDO DO CAMPO','SANTO ANDRE','ITAPECERICA DA SERRA'
								,'OSASCO','ITAPEVI','GUARULHOS','BARUERI','SANATANA DE PARNAIBA','ITAQUAQUECETUBA','EMBU','SANTOS','GUARUJA','PRAIA GRANDE','TAIACUPEBA'
								,'RIO GRANDE DA SERRA','CAEIRAS','POA','MONGUAGUA','ITANHAEM','PERUIBE','EMBU GUACU','VARGEM GRANDE PAULISTA','CAJAMAR','COTIA','JANDIRA'
								,'FRANCO DA ROCHA','FRANCISCO MORATO','MAIRIPORA','SAO ROQUE','ARUJA','CUBATAO','SAO VICENTE','TABOAO DA SERRA','DIADEMA','SAO CAETANO DO SUL','SAO BENTO'
								,'CARAPICUIBA','ARACARIGUAMA','PIRAPORA DO BOM JESUS','VAZEA PAULISTA','JUNDIAI','ATIBAIA','SOROCABA','VOTORANTIM','JACARE','MARACANA','BOM JESUS DOS PERDOES'
								,'VINHEDO','VALINHOS','CAMPINAS','ITATIBA','BRAGANCA PAULISTA','JACAREI','JUQUITIBA','CABREUVA','ITU','TATUI','NOVA HELIOPOLIS')

				
				
				AND @cEstado_Estabelecimento = 'SP') 
			BEGIN
				--SET @iResposta	 = 100
				SET @bMonitorTrn = 1
			END
		END
	END


	-- INI: TRAVA EMERGENCIAL PARA TRANSAÇÕES DE CARTÕES PAT DO ESTADO DA BA NO ESTADO DE GO
	IF (@cEstado_Estabelecimento = 'GO' AND @cUfCliente = 'BA')
	BEGIN
		SET @iResposta = 337
	END


	-- FIM: TRAVA EMERGENCIAL PARA TRANSAÇÕES DE CARTÕES PAT DE OUTROS ESTADOS NO ESTADO DE 

	--/* INICIO: ENVIA EMAIL GESTAO DE RISCO */
	--IF (@bMonitorTrn = 1)
	--BEGIN
	--	DECLARE  
	--		 @sPw				VARCHAR(10)
	--		,@sRede				VARCHAR(20)
	--		,@html				NVARCHAR(MAX)
	--		,@cUltimaNegada		VARCHAR (1000)
	--		,@cUltimaAutorizada VARCHAR (1000)

	--	SELECT TOP 1 @cUltimaNegada = CONVERT (VARCHAR, e.Numero) + ' - ' + e.Nome + ' - ' + CONVERT(VARCHAR(10),tn.Data,103) + ' ' + CONVERT (VARCHAR (10), tn.Data,108)+ ' - ' + LTRIM(RTRIM(e.Cidade)) + '-' + e.Estado
	--	FROM Processadora.dbo.TransacoesNegadas TN WITH (NOLOCK)
	--	INNER JOIN Processadora.dbo.Estabelecimentos E WITH (NOLOCK) ON (TN.CodEstabelecimento = E.Numero)
	--	WHERE TN.BaseOrigem = 'P'
	--	AND TN.CodCartao = @iCrtUsrCodigo
	--	ORDER BY TN.Codigo DESC
				
	--	SELECT TOP 1  @cUltimaAutorizada = CONVERT (VARCHAR, e.Numero) + ' - ' + e.Nome + ' - ' + CONVERT(VARCHAR(10),t.Data,103) + ' ' + CONVERT (VARCHAR (10), t.Data,108) + ' - ' + LTRIM(RTRIM(e.Cidade)) + '-' + e.Estado
	--	FROM Processadora.dbo.Transacoes T WITH (NOLOCK)
	--	INNER JOIN PROCESSADORA.dbo.Estabelecimentos E WITH (NOLOCK) ON (T.CodEstab = E.Numero)
	--	WHERE T.CrtUsrCodigo = @iCrtUsrCodigo AND T.Status = 'A'
	--	ORDER BY T.TrnCodigo DESC

	--	IF (@cUltimaAutorizada IS NULL)
	--	BEGIN

	--		SELECT TOP 1  @cUltimaAutorizada = CONVERT (VARCHAR, e.Numero) + ' - ' + e.Nome + ' - ' + CONVERT(VARCHAR(10),t.Data,103) + ' ' + CONVERT (VARCHAR (10), t.Data,108) + ' - ' + LTRIM(RTRIM(e.Cidade)) + '-' + e.Estado
	--		FROM PROCESSADORA.dbo.Transacoes T WITH (NOLOCK)
	--		INNER JOIN PROCESSADORA.dbo.Estabelecimentos E WITH (NOLOCK) ON (T.CodEstab = E.Numero)
	--		WHERE T.CrtUsrCodigo = @iCrtUsrCodigo
	--		ORDER BY T.TrnCodigo DESC
		
	--	END

	--	SELECT	@cBit062 = descricao_policard
	--			,@sPw = CASE WHEN(@cBit052 <> LTRIM(RTRIM(''))) THEN 'SIM' ELSE 'NAO' END
	--	FROM	aut_CodigosResposta WITH(NOLOCK)
	--	WHERE	Codigo = @iResposta

	--	SELECT @cProdutoResponsavel = REPLACE(REPLACE(REPLACE(Nome,'CARTAO ',''),'Cartão ',''),'-','') FROM Processadora..TiposProdutos WITH(NOLOCK) WHERE TpoPrdCodigo = @iTpoPrdCodigo
	--	SELECT @sRede = REPLACE(Nome,'REDE ','') FROM Redes (NOLOCK) WHERE RdeCodigo = @iRedeCodigo

	--	SET @html = '<html><body><font face=''Lucida Console'' size=''2px''>' -- <b>
	--	SET @html = @html + 'Informa&ccedil&otildees da Transa&ccedil&atildeo <br/><br/>'
	--	SET @html = @html + 'Data...........: ' + '<font color=''red''>' + CONVERT(VARCHAR(10),@dDataHora_Transacao,103) + '</font>' + '<br/>'
	--	SET @html = @html + 'Hora...........: ' + '<font color=''red''>' + CONVERT(VARCHAR(10),@dDataHora_Transacao,108) + '</font>' + '<br/>'
	--	SET @html = @html + 'Estabelecimento: ' + '<font color=''red''>' + CONVERT(VARCHAR,@iCodigoEstabelecimento) + '</font>' + '<br/>'
	--	SET @html = @html + 'Nome Estab.....: ' + '<font color=''red''>' + @sNome_Estabelecimento + '</font>' + '<br/>'
	--	SET @html = @html + 'Cidade Estab...: ' + '<font color=''red''>' + @sCidade_Estabelecimento + ' - ' + @sEstado_Estabelecimento + '</font>' + '<br/>'
	--	SET @html = @html + 'Valor..........: ' + '<font color=''red''>' + CONVERT(VARCHAR,@nValor_Transacao) + '</font>' + '<br/>'
	--	SET @html = @html + 'NSU............: ' + '<font color=''red''>' + COALESCE (@cBit011, '-') + '</font>' + '<br/>'
	--	SET @html = @html + 'Cart&atildeo.........: ' + '<font color=''red''>' + @cNumeroCartao + '</font>' + '<br/>'
	--	SET @html = @html + 'Cidade Usu&aacuterio.: ' + '<font color=''red''>' + @sCidadeUsr + '</font>' + '<br/>'
	--	SET @html = @html + 'CIR............: ' + '<font color=''red''>' + CONVERT(VARCHAR,@iResposta) + '</font>' + '<br/>'
	--	SET @html = @html + 'Resposta.......: ' + '<font color=''red''>' + @cBit062 + '</font>' + '<br/>'
	--	SET @html = @html + 'Senha..........: ' + '<font color=''red''>' + @sPw + '</font>' + '<br/>'
	--	SET @html = @html + 'Rede...........: ' + '<font color=''red''>' + @sRede + '</font>' + '<br/>'
	--	SET @html = @html + 'Terminal.......: ' + '<font color=''red''>' + @cBit041 + '</font>' + '<br/>'
	--	SET @html = @html + 'Ultima Aprovada.: ' + '<font color=''red''>' + COALESCE (@cUltimaAutorizada,'-') + '</font>' + '<br/>'
	--	SET @html = @html + 'Ultima Negada...: ' + '<font color=''red''>' + COALESCE (@cUltimaNegada,'-') + '</font>' + '<br/>'
	--	SET @html = @html + 'Produto........: ' + '<font color=''red''>' + REPLACE(REPLACE(@cProdutoResponsavel,'ç','&ccedil'),'ã','&atilde') + '</font>'
	--	SET @html = @html + '</font></body></html>' -- </b>

	--	INSERT INTO Processadora.dbo.Email VALUES
	--		('genai.rodrigues@policard.com.br'
	--		,'notificacao.sistemas@redepolicard.com.br'
	--		,'Transações Fora Estado Origem - Alimentação e Refeição'
	--		,@html
	--		,'Notificação'
	--		,GETDATE()
	--		,NULL
	--		,0
	--		,NULL
	--		,'regis.marcondes@policard.com.br'
	--		,NULL)
	--END
	--/* FIM: Envia Email Gestao de Risco */


END

