
/*
--------------------------------------------------------------------------
Data........: 11/11/2015
Nome Sistema: Autorizador
Objeto......: pr_AUT_RetornarTicketTransacao
Propósito...: Procedure responsável por retornar os tickets de transações.
--------------------------------------------------------------------------
Criada por:	Luiz Renato
Data: 06/10/2015
CH: 1194 / 212609
---------------------------------------------------------------------------
Alterada por:	Luiz Renato
Data: 18/11/2015
Mud./CH: 1349 / 225666
---------------------------------------------------------------------------
Alterada por:	Luiz Renato
Data: 29/12/2015
Mud./CH: 1499 / 235909
---------------------------------------------------------------------------
Alterada por:	Rafael A. M. Borges
Data: 13/03/2017
Mud./CH: 363857
---------------------------------------------------------------------------
Data Alteracao: 21/03/2017
Autor: Cristiano Barbosa
CH: 365214 - 2676
--------------------------------------------------------------------------
Data Alteracao: 16/05/2017
Autor: Cristiano Barbosa
CH: 383212 - 2389
--------------------------------------------------------------------------
Data: 23/05/2017
Autor: Cristiano Barbosa - Tecnologia Policard
Chamado: 367344 - 2856
--------------------------------------------------------------------------
Data: 11/11/2017
Autor: Cristiano Barbosa - Tecnologia Policard
Chamado/Mudança: 417480 - 3420
--------------------------------------------------------------------------
Data: 30/01/2018
Autor: Cristiano Barbosa - Tecnologia Policard
Chamado/Mudança: 464382 - 
--------------------------------------------------------------------------
Data: 08/09/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1843805
Descrição: Projeto ABECS para transações NCR/Scope.
-------------------------------------------------------------------------- 	
Data: 25/10/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1930438
Descrição: Ajuste de marca nos comprovantes de transações: muitos deles 
	ainda exibem a marca Policard.
-------------------------------------------------------------------------- 	
*/

CREATE PROCEDURE [dbo].[pr_AUT_RetornarTicketTransacao]
	 @Bit001			VARCHAR(1000)
	,@Bit003			VARCHAR(1000)
	,@Bit004			VARCHAR(1000)
	,@Bit005			VARCHAR(1000)
	,@Bit011			VARCHAR(1000)
	,@Bit038			VARCHAR(1000)
	,@Bit041			VARCHAR(1000)
	,@Bit062			VARCHAR(1000)	OUTPUT
	,@Bit067			VARCHAR(1000)
	,@Bit127			VARCHAR(1000)
	,@sCNPJ				VARCHAR(20)		= NULL
	,@sNumeroCartao		VARCHAR(50)		= NULL
	,@sNroDocumento		VARCHAR(20)		= NULL
	,@sLabelProduto		VARCHAR(50)		= NULL
	,@sNomeUsuario		VARCHAR(50)		= NULL
	,@sNomeEstab		VARCHAR(50)		= NULL
	,@sEndereco			VARCHAR(50)		= NULL
	,@sCidade			VARCHAR(30)		= NULL
	,@cEstado			CHAR(2)			= NULL
	,@bPagtoContas		BIT				= NULL
	,@dSaldoDispCartao	DECIMAL(15,2)	= NULL
	,@iRede				TINYINT
	,@iEstabelecimento	INT
	,@iCodTrnExterna	INT
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE  @sSaldoDisponivel	VARCHAR(50)
			,@sCabecalhoTicket	VARCHAR(100)
			,@sTipoOperacao		VARCHAR(50)
			,@sValorTransacao	VARCHAR(50)
			,@sRodapeTicket1	VARCHAR(50)
			,@sRodapeTicket2	VARCHAR(50)
			,@dValorTransacao	DECIMAL(15,2)
			,@dSaldoDispVT		DECIMAL(15,2)

	SELECT	 @dValorTransacao	= dbo.f_RetornarValor(@Bit004)
			,@dSaldoDispVT		= dbo.f_RetornarValor(@Bit005)
	SELECT	 @sSaldoDisponivel	= CASE WHEN(@iRede = 21) THEN dbo.f_FormatarValor(@dSaldoDispVT,'.',',') ELSE dbo.f_FormatarValor(@dSaldoDispCartao,'.',',') END
	SELECT	 @sSaldoDisponivel	= dbo.f_CentralizarMensagem('SALDO DISPONIVEL: ' + @sSaldoDisponivel,'@',39)
			,@sValorTransacao	= dbo.f_FormatarValor(@dValorTransacao,'.',',')

	IF (@iRede = 21)
	BEGIN

		SET @sTipoOperacao = CASE WHEN(@Bit001 IN('0200','0210') AND @Bit003 = ('000012')) THEN 'RECARGA CIDADAO'
								  WHEN(@Bit001 IN('0200','0210') AND @Bit003 = ('000013')) THEN 'RECARGA ESTUDANTE'
								  WHEN(@Bit001 IN('0400','0410')) THEN 'ESTORNO'
							 END

		SELECT	 @sCabecalhoTicket	= dbo.f_CentralizarMensagem('OPERADORA: UP BRASIL','@',39) + dbo.f_CentralizarMensagem(@sTipoOperacao,'@',39) + ' @ '
				,@Bit062			= CASE WHEN(@Bit001 = '0110') THEN @Bit062 ELSE MsgTicket END
		FROM	TicketsRetorno WITH(NOLOCK)
		WHERE	Codigo = 10
		
		SET @Bit062 = REPLACE(@Bit062, '<CNPJ>', @sCNPJ)
		SET @Bit062 = REPLACE(@Bit062, '<NOME_ESTABELECIMENTO>', @sNomeEstab)
		SET @Bit062 = REPLACE(@Bit062, '<CIDADE>', @sCidade)
		SET @Bit062 = REPLACE(@Bit062, '<ESTADO>', @cEstado)
		SET @Bit062 = REPLACE(@Bit062, '<CODIGO_ESTABELECIMENTO>', CONVERT(VARCHAR,@iEstabelecimento))
		SET @Bit062 = REPLACE(@Bit062, '<TERMINAL>', @Bit041)
		SET @Bit062 = REPLACE(@Bit062, '<DATA>', CONVERT(VARCHAR(10),GETDATE(),103))
		SET @Bit062 = REPLACE(@Bit062, '<HORA>', CONVERT(VARCHAR(5),GETDATE(),108))
		SET @Bit062 = REPLACE(@Bit062, '<DATA_EFETIVACAO>', CONVERT(VARCHAR(10),GETDATE(),103))
		SET @Bit062 = REPLACE(@Bit062, '<NSU_LOJA>', @Bit011)
		SET @Bit062 = REPLACE(@Bit062, '<NSU_HOST>', @Bit127)
		SET @Bit062 = REPLACE(@Bit062, '<CARTAO>', @sNumeroCartao)
		SET @Bit062 = REPLACE(@Bit062, '<VALOR>', @sValorTransacao)
		SET @Bit062 = 'F' + @sCabecalhoTicket + @Bit062 + @sSaldoDisponivel + '@'

		UPDATE Processadora..TransacoesExternas SET Ticket = @Bit062 WHERE Codigo = @iCodTrnExterna
	END
	ELSE
	BEGIN
	
		IF (@Bit001 IN ('0100','0200'))
			SELECT	 @sRodapeTicket1 = 'TRANSACAO AUTORIZADA MEDIANTE'
					,@sRodapeTicket2 = 'O USO DE SENHA PESSOAL @ '
		ELSE IF(@Bit001 = '0400')
			SELECT	 @sRodapeTicket1 = 'RECONHECO QUE O VALOR ACIMA FOI'
					,@sRodapeTicket2 = 'ESTORNADO DE MINHA CONTA. @ '

		SELECT	 @sNumeroCartao		= LEFT(@sNumeroCartao,6) + '******' + RIGHT(@sNumeroCartao,4)
				,@sSaldoDisponivel	= 'SALDO DISPONIVEL: ' + dbo.f_FormatarValor(@dSaldoDispCartao,'.',',')
				,@sValorTransacao	= dbo.f_FormatarValor(@dValorTransacao,'.',',')
				,@sLabelProduto		= dbo.f_CentralizarMensagem(@sLabelProduto,'@',38)
				,@sNumeroCartao		= dbo.f_CentralizarMensagem(@sNumeroCartao,'@',38)
				,@sNomeUsuario		= dbo.f_CentralizarMensagem(@sNomeUsuario,'@',38)
				,@sRodapeTicket1	= dbo.f_CentralizarMensagem(@sRodapeTicket1,NULL,38)
				,@sRodapeTicket2	= dbo.f_CentralizarMensagem(@sRodapeTicket2,'@',38)
				,@sSaldoDisponivel	= dbo.f_CentralizarMensagem(@sSaldoDisponivel,'@',38) + '@'
				,@sNroDocumento		= CASE WHEN(@iRede IN (10,58)) THEN @Bit038 ELSE @Bit127 END

		SELECT	 @sCabecalhoTicket	= MsgCabecalho
				,@Bit062			= MsgTicket
		FROM	TicketsRetorno WITH(NOLOCK)
		WHERE	Codigo = CASE WHEN (@Bit001 = '0100') THEN 13 --Consulta de Saldo
							  WHEN (@Bit001 = '0200' AND @Bit003 = '002100') THEN 14
							  WHEN (@Bit001 = '0200' AND (@iRede = 7 OR CONVERT(INT,@Bit067) IN (0,1))) THEN 1
							  WHEN (@Bit001 = '0200' AND CONVERT(INT,@Bit067) > 1) THEN 3
							  WHEN (@Bit001 = '0200' AND @bPagtoContas = 1) THEN 5
							  WHEN (@Bit001 = '0200' AND @iRede = 21) THEN 10 -- VT
							  WHEN (@Bit001 = '0400' AND (@iRede = 7 OR CONVERT(INT,@Bit067) IN (0,1))) THEN 2
							  WHEN (@Bit001 = '0400' AND CONVERT(INT,@Bit067) > 1) THEN 4
							  WHEN (@Bit001 = '0400' AND @bPagtoContas = 1) THEN 6
							  WHEN (@Bit001 = '0400' AND @iRede = 21) THEN 10 -- VT
							  
						 END

		SET @Bit062 = REPLACE(@Bit062, '<CNPJ>', @sCNPJ)
		SET @Bit062 = REPLACE(@Bit062, '<NOME_ESTABELECIMENTO>', @sNomeEstab)
		--SET @Bit062 = REPLACE(@Bit062, '<ENDERECO>', @sEndereco)
		SET @Bit062 = REPLACE(@Bit062, '<CIDADE>', @sCidade)
		SET @Bit062 = REPLACE(@Bit062, '<ESTADO>', @cEstado)
		SET @Bit062 = REPLACE(@Bit062, '<NSU_HOST>', @sNroDocumento)
		SET @Bit062 = REPLACE(@Bit062, '<NSU_LOJA>', @Bit011)
		SET @Bit062 = REPLACE(@Bit062, '<CODIGO_ESTABELECIMENTO>', CONVERT(VARCHAR,@iEstabelecimento))
		SET @Bit062 = REPLACE(@Bit062, '<TERMINAL>', @Bit041)
		SET @Bit062 = REPLACE(@Bit062, '<DATA>', CONVERT(VARCHAR(5),GETDATE(),103))
		SET @Bit062 = REPLACE(@Bit062, '<HORA>', CONVERT(VARCHAR(5),GETDATE(),108))
		SET @Bit062 = REPLACE(@Bit062, '<VALOR>', @sValorTransacao)
		SET @Bit062 = REPLACE(@Bit062, '<NOME_USUARIO>', @sNomeUsuario)

		IF (@iRede IN (7,8,30))
			SET @Bit062 = @sCabecalhoTicket + @sLabelProduto + @sNumeroCartao + @Bit062 + @sRodapeTicket1 + @sRodapeTicket2 + @sNomeUsuario + @sSaldoDisponivel
		ELSE IF (@iRede = 13)
			SET @Bit062 = 'F' + @sLabelProduto + @sNumeroCartao + @Bit062 + @sRodapeTicket1 + @sRodapeTicket2 + @sNomeUsuario + @sSaldoDisponivel
		ELSE IF (@iRede = 29)
			SET @Bit062 = dbo.f_ZerosEsquerda(REPLACE(@dSaldoDispCartao,'.',''),11)
		ELSE
			SET @Bit062 = @sLabelProduto + @sNumeroCartao + @Bit062 + @sRodapeTicket1 + @sRodapeTicket2 + @sNomeUsuario + @sSaldoDisponivel
	END
END



