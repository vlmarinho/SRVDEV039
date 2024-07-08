
--sp_helptext pr_aut_web_AutorizarTransacao_CRM_CAE


--Exec Autorizacao.dbo.pr_aut_web_AutorizarTransacao_CRM_CAE '0200','003000',0,'0','8/10/2016 5:55:17 PM','016','6030780057274733','88880000','64741514',1,'','P', NULL, NULL


/*------------------------------------------------------------------------
Nome Sistema: Autorização
Objeto: [dbo].[pr_aut_web_AutorizarTransacao_CRM_CAE]
Propósito: Procedure responsável por realizar transações via solicitações
	       do CRM e CAE(AVI).
Autor: Cristiano Silva - Policard Systems
--------------------------------------------------------------------------
Data criação: 19/02/2017
Mudança: 2601
--------------------------------------------------------------------------


*/

CREATE PROCEDURE [pr_aut_web_AutorizarTransacao_CRM_CAE_1] (
	 @cTipo_Transacao			CHAR(4)
	,@cCodigoProcessamento		CHAR(6)
	,@nValor_Transacao			VARCHAR(12)
	,@cNSU_MeioCaptura			CHAR(6)
	,@dDataHora_Transacao		DATETIME
	,@cRedeCaptura				CHAR(3)
	,@cNumero_Cartao			VARCHAR(16)
	,@cTerminal					VARCHAR(8)
	,@Cod_Estabelecimento		VARCHAR(15)
	,@cNumero_Parcelas			CHAR(2)
	,@cResponsavel				VARCHAR(50)
	,@cBaseOrigem				CHAR(1)
	,@cNSUPolicard				VARCHAR(12)
	,@cInformacoesAdicionais	VARCHAR(1000)
	,@cSenhaCartao              VARCHAR(1000) = NULL
	)
AS

BEGIN

	SET NOCOUNT ON;

	DECLARE
		 @iResposta			INT
		,@iRespostaRecarga	INT
		,@cResposta			CHAR(3)
		,@cRespostaRecarga	CHAR(3)
		,@nSaldo_Disp		VARCHAR(15)
		,@cNomeUsuario		VARCHAR(100)
		,@cResult			VARCHAR(1000)
		,@cMensagem			VARCHAR(1000)
		,@sNsuOperadora		VARCHAR(10)
		,@cDataHoraGMT		VARCHAR(10)
		,@cHoralocal		VARCHAR(6)
		,@cDatalocal		VARCHAR(4)

	SET @Cod_Estabelecimento	= dbo.f_ZerosEsquerda(@Cod_Estabelecimento,15)
	SET @cNSU_MeioCaptura		= dbo.f_ZerosEsquerda(@cNSU_MeioCaptura,6)
	SET @cNumero_Parcelas		= dbo.f_ZerosEsquerda(@cNumero_Parcelas,2)
	SET @nValor_Transacao		= dbo.f_ZerosEsquerda(REPLACE(@nValor_Transacao,'.',''),12)
	SET @cDataHoraGMT			= SUBSTRING(REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(23), @dDataHora_Transacao,120),'-',''),':',''),' ',''),5,20)
	SET @cDatalocal				= SUBSTRING(@cDataHoraGMT,1,4)
	SET @cHoralocal				= SUBSTRING(@cDataHoraGMT,5,6)
	SET @cInformacoesAdicionais = COALESCE(@cInformacoesAdicionais, '')
		
	/*Gerando NSU_LOJA para CRM e CAE*/
	IF (CONVERT(INT,@cRedeCaptura) IN ( 16, 17, 27))
		EXEC pr_AUT_GerarNSUTransacoes @cNSU_MeioCaptura OUT, 6
				
	IF CONVERT(INT,@cRedeCaptura) = 16
		SET @cResponsavel	= 'CRM/' + @cResponsavel
	ELSE IF CONVERT(INT,@cRedeCaptura) = 19
		SET @cResponsavel = 'SIGRA/' + @cResponsavel
	ELSE IF CONVERT(INT,@cRedeCaptura) <> 27
		SET @cResponsavel = 'CAE/' + @cResponsavel
	
		
	DECLARE @Bit001 VARCHAR(1000), @Bit002 VARCHAR(1000), @Bit003 VARCHAR(1000), @Bit004 VARCHAR(1000), @Bit005 VARCHAR(1000), @Bit006 VARCHAR(1000), @Bit007 VARCHAR(1000), @Bit008 VARCHAR(1000),
			@Bit009 VARCHAR(1000), @Bit010 VARCHAR(1000), @Bit011 VARCHAR(1000), @Bit012 VARCHAR(1000), @Bit013 VARCHAR(1000), @Bit014 VARCHAR(1000), @Bit015 VARCHAR(1000), @Bit016 VARCHAR(1000),
			@Bit017 VARCHAR(1000), @Bit018 VARCHAR(1000), @Bit019 VARCHAR(1000), @Bit020 VARCHAR(1000), @Bit021 VARCHAR(1000), @Bit022 VARCHAR(1000), @Bit023 VARCHAR(1000), @Bit024 VARCHAR(1000),
			@Bit025 VARCHAR(1000), @Bit026 VARCHAR(1000), @Bit027 VARCHAR(1000), @Bit028 VARCHAR(1000), @Bit029 VARCHAR(1000), @Bit030 VARCHAR(1000), @Bit031 VARCHAR(1000), @Bit032 VARCHAR(1000),
			@Bit033 VARCHAR(1000), @Bit034 VARCHAR(1000), @Bit035 VARCHAR(1000), @Bit036 VARCHAR(1000), @Bit037 VARCHAR(1000), @Bit038 VARCHAR(1000), @Bit039 VARCHAR(1000), @Bit040 VARCHAR(1000),
			@Bit041 VARCHAR(1000), @Bit042 VARCHAR(1000), @Bit043 VARCHAR(1000), @Bit044 VARCHAR(1000), @Bit045 VARCHAR(1000), @Bit046 VARCHAR(1000), @Bit047 VARCHAR(1000), @Bit048 VARCHAR(1000),
			@Bit049 VARCHAR(1000), @Bit050 VARCHAR(1000), @Bit051 VARCHAR(1000), @Bit052 VARCHAR(1000), @Bit053 VARCHAR(1000), @Bit054 VARCHAR(1000), @Bit055 VARCHAR(1000), @Bit056 VARCHAR(1000),
			@Bit057 VARCHAR(1000), @Bit058 VARCHAR(1000), @Bit059 VARCHAR(1000), @Bit060 VARCHAR(1000), @Bit061 VARCHAR(1000), @Bit062 VARCHAR(1000), @Bit063 VARCHAR(1000), @Bit064 VARCHAR(1000),
			@Bit065 VARCHAR(1000), @Bit066 VARCHAR(1000), @Bit067 VARCHAR(1000), @Bit068 VARCHAR(1000), @Bit069 VARCHAR(1000), @Bit070 VARCHAR(1000), @Bit071 VARCHAR(1000), @Bit072 VARCHAR(1000),
			@Bit073 VARCHAR(1000), @Bit074 VARCHAR(1000), @Bit075 VARCHAR(1000), @Bit076 VARCHAR(1000), @Bit077 VARCHAR(1000), @Bit078 VARCHAR(1000), @Bit079 VARCHAR(1000), @Bit080 VARCHAR(1000),
			@Bit081 VARCHAR(1000), @Bit082 VARCHAR(1000), @Bit083 VARCHAR(1000), @Bit084 VARCHAR(1000), @Bit085 VARCHAR(1000), @Bit086 VARCHAR(1000), @Bit087 VARCHAR(1000), @Bit088 VARCHAR(1000),
			@Bit089 VARCHAR(1000), @Bit090 VARCHAR(1000), @Bit091 VARCHAR(1000), @Bit092 VARCHAR(1000), @Bit093 VARCHAR(1000), @Bit094 VARCHAR(1000), @Bit095 VARCHAR(1000), @Bit096 VARCHAR(1000),
			@Bit097 VARCHAR(1000), @Bit098 VARCHAR(1000), @Bit099 VARCHAR(1000), @Bit100 VARCHAR(1000), @Bit101 VARCHAR(1000), @Bit102 VARCHAR(1000), @Bit103 VARCHAR(1000), @Bit104 VARCHAR(1000),
			@Bit105 VARCHAR(1000), @Bit106 VARCHAR(1000), @Bit107 VARCHAR(1000), @Bit108 VARCHAR(1000), @Bit109 VARCHAR(1000), @Bit110 VARCHAR(1000), @Bit111 VARCHAR(1000), @Bit112 VARCHAR(1000),
			@Bit113 VARCHAR(1000), @Bit114 VARCHAR(1000), @Bit115 VARCHAR(1000), @Bit116 VARCHAR(1000), @Bit117 VARCHAR(1000), @Bit118 VARCHAR(1000), @Bit119 VARCHAR(1000), @Bit120 VARCHAR(1000),
			@Bit121 VARCHAR(1000), @Bit122 VARCHAR(1000), @Bit123 VARCHAR(1000), @Bit124 VARCHAR(1000), @Bit125 VARCHAR(1000), @Bit126 VARCHAR(1000), @Bit127 VARCHAR(1000), @Bit128 VARCHAR(1000)	

		
	SELECT   
		 @Bit001 = @cTipo_Transacao					--Tipo de Transação
		,@Bit003 = @cCodigoProcessamento			--Codigo Processamento
		,@Bit004 = @nValor_Transacao				--Valor 
		,@Bit007 = @cDataHoraGMT					--DataHora GMT
		,@Bit011 = @cNSU_MeioCaptura				--NSU Meio Captura
		,@Bit012 = @cHoralocal						--Hora Transação
		,@Bit013 = @cDatalocal						--Data Transacso
		,@Bit022 = '011'							--TIPO INPUT CARTAO
		,@Bit024 = @cRedeCaptura					--Rede
		,@Bit032 = SUBSTRING(@cNumero_Cartao,1,11)	--ID Cartao
		,@Bit035 = @cNumero_Cartao					--Numero Cartao
		,@Bit041 = @cTerminal						--Numero Terminal
		,@Bit042 = @Cod_Estabelecimento				--Codigo do estabelecimento
		,@Bit048 = @cResponsavel					--Responsavel pela Operação
		,@Bit049 = '986'							--Codigo da Moeda
		,@Bit052 = @cSenhaCartao					--Senha do cartao, utilizando quando é enviado pelo APP
		,@Bit067 = @cNumero_Parcelas				--Qtde Parcelas
		,@Bit105 = @cInformacoesAdicionais			--Dados do Frota.

	IF (@cCodigoProcessamento = '599002' AND @cInformacoesAdicionais <> '')
		SET @Bit062 = @cInformacoesAdicionais
				
	IF @cTipo_Transacao = '0400'
	BEGIN
		DECLARE @cTrnEstornar		VARCHAR(50)
		
		IF @cBaseOrigem = 'P'
		BEGIN
			SET @cTrnEstornar = (SELECT NSUORIGEM + DataGMT FROM Processadora.dbo.Transacoes (NOLOCK) WHERE TrnCodigo = @cNSUPolicard)
			SET @cTrnEstornar = dbo.f_ZerosEsquerda(@cTrnEstornar,16) /*Preencher com zeros para  */
			SET @Bit090 = '0200003000' + @cTrnEstornar
			SET @Bit125 = @cNSUPolicard
		END
		ELSE 
		BEGIN
			SET @cTrnEstornar = (SELECT CONVERT(VARCHAR,NsuLoja) + DataHoraGMT FROM   Policard_603078.dbo.Transacao_RegistroTEF WITH(NOLOCK) WHERE Codigo_Referencia = @cNSUPolicard)
			SET @cTrnEstornar = dbo.f_ZerosEsquerda(@cTrnEstornar,16)
			SET @Bit090 = '0200003000' + @cTrnEstornar
			SET @Bit125 = @cNSUPolicard
		END
			
	END				
					
	SELECT  
		 @Bit001 = CASE WHEN LEN(@Bit001) > 0 THEN '1' + @Bit001 + ''  ELSE  '0'  END
		,@Bit002 = CASE WHEN LEN(@Bit002) > 0 THEN '1' + @Bit002 + ''  ELSE  '0'  END
		,@Bit003 = CASE WHEN LEN(@Bit003) > 0 THEN '1' + @Bit003 + ''  ELSE  '0'  END
		,@Bit004 = CASE WHEN LEN(@Bit004) > 0 THEN '1' + @Bit004 + ''  ELSE  '0'  END
		,@Bit005 = CASE WHEN LEN(@Bit005) > 0 THEN '1' + @Bit005 + ''  ELSE  '0'  END
		,@Bit006 = CASE WHEN LEN(@Bit006) > 0 THEN '1' + @Bit006 + ''  ELSE  '0'  END
		,@Bit007 = CASE WHEN LEN(@Bit007) > 0 THEN '1' + @Bit007 + ''  ELSE  '0'  END
		,@Bit008 = CASE WHEN LEN(@Bit008) > 0 THEN '1' + @Bit008 + ''  ELSE  '0'  END
		,@Bit009 = CASE WHEN LEN(@Bit009) > 0 THEN '1' + @Bit009 + ''  ELSE  '0'  END
		,@Bit010 = CASE WHEN LEN(@Bit010) > 0 THEN '1' + @Bit010 + ''  ELSE  '0'  END
		,@Bit011 = CASE WHEN LEN(@Bit011) > 0 THEN '1' + @Bit011 + ''  ELSE  '0'  END
		,@Bit012 = CASE WHEN LEN(@Bit012) > 0 THEN '1' + @Bit012 + ''  ELSE  '0'  END
		,@Bit013 = CASE WHEN LEN(@Bit013) > 0 THEN '1' + @Bit013 + ''  ELSE  '0'  END
		,@Bit014 = CASE WHEN LEN(@Bit014) > 0 THEN '1' + @Bit014 + ''  ELSE  '0'  END
		,@Bit015 = CASE WHEN LEN(@Bit015) > 0 THEN '1' + @Bit015 + ''  ELSE  '0'  END
		,@Bit016 = CASE WHEN LEN(@Bit016) > 0 THEN '1' + @Bit016 + ''  ELSE  '0'  END
		,@Bit017 = CASE WHEN LEN(@Bit017) > 0 THEN '1' + @Bit017 + ''  ELSE  '0'  END
		,@Bit018 = CASE WHEN LEN(@Bit018) > 0 THEN '1' + @Bit018 + ''  ELSE  '0'  END
		,@Bit019 = CASE WHEN LEN(@Bit019) > 0 THEN '1' + @Bit019 + ''  ELSE  '0'  END
		,@Bit020 = CASE WHEN LEN(@Bit020) > 0 THEN '1' + @Bit020 + ''  ELSE  '0'  END
		,@Bit021 = CASE WHEN LEN(@Bit021) > 0 THEN '1' + @Bit021 + ''  ELSE  '0'  END
		,@Bit022 = CASE WHEN LEN(@Bit022) > 0 THEN '1' + @Bit022 + ''  ELSE  '0'  END
		,@Bit023 = CASE WHEN LEN(@Bit023) > 0 THEN '1' + @Bit023 + ''  ELSE  '0'  END
		,@Bit024 = CASE WHEN LEN(@Bit024) > 0 THEN '1' + @Bit024 + ''  ELSE  '0'  END
		,@Bit025 = CASE WHEN LEN(@Bit025) > 0 THEN '1' + @Bit025 + ''  ELSE  '0'  END
		,@Bit026 = CASE WHEN LEN(@Bit026) > 0 THEN '1' + @Bit026 + ''  ELSE  '0'  END
		,@Bit027 = CASE WHEN LEN(@Bit027) > 0 THEN '1' + @Bit027 + ''  ELSE  '0'  END
		,@Bit028 = CASE WHEN LEN(@Bit028) > 0 THEN '1' + @Bit028 + ''  ELSE  '0'  END
		,@Bit029 = CASE WHEN LEN(@Bit029) > 0 THEN '1' + @Bit029 + ''  ELSE  '0'  END
		,@Bit030 = CASE WHEN LEN(@Bit030) > 0 THEN '1' + @Bit030 + ''  ELSE  '0'  END
		,@Bit031 = CASE WHEN LEN(@Bit031) > 0 THEN '1' + @Bit031 + ''  ELSE  '0'  END
		,@Bit032 = CASE WHEN LEN(@Bit032) > 0 THEN '1' + @Bit032 + ''  ELSE  '0'  END
		,@Bit033 = CASE WHEN LEN(@Bit033) > 0 THEN '1' + @Bit033 + ''  ELSE  '0'  END
		,@Bit034 = CASE WHEN LEN(@Bit034) > 0 THEN '1' + @Bit034 + ''  ELSE  '0'  END
		,@Bit035 = CASE WHEN LEN(@Bit035) > 0 THEN '1' + @Bit035 + ''  ELSE  '0'  END
		,@Bit036 = CASE WHEN LEN(@Bit036) > 0 THEN '1' + @Bit036 + ''  ELSE  '0'  END
		,@Bit037 = CASE WHEN LEN(@Bit037) > 0 THEN '1' + @Bit037 + ''  ELSE  '0'  END
		,@Bit038 = CASE WHEN LEN(@Bit038) > 0 THEN '1' + @Bit038 + ''  ELSE  '0'  END
		,@Bit039 = CASE WHEN LEN(@Bit039) > 0 THEN '1' + @Bit039 + ''  ELSE  '0'  END
		,@Bit040 = CASE WHEN LEN(@Bit040) > 0 THEN '1' + @Bit040 + ''  ELSE  '0'  END
		,@Bit041 = CASE WHEN LEN(@Bit041) > 0 THEN '1' + @Bit041 + ''  ELSE  '0'  END
		,@Bit042 = CASE WHEN LEN(@Bit042) > 0 THEN '1' + @Bit042 + ''  ELSE  '0'  END
		,@Bit043 = CASE WHEN LEN(@Bit043) > 0 THEN '1' + @Bit043 + ''  ELSE  '0'  END
		,@Bit044 = CASE WHEN LEN(@Bit044) > 0 THEN '1' + @Bit044 + ''  ELSE  '0'  END
		,@Bit045 = CASE WHEN LEN(@Bit045) > 0 THEN '1' + @Bit045 + ''  ELSE  '0'  END
		,@Bit046 = CASE WHEN LEN(@Bit046) > 0 THEN '1' + @Bit046 + ''  ELSE  '0'  END
		,@Bit047 = CASE WHEN LEN(@Bit047) > 0 THEN '1' + @Bit047 + ''  ELSE  '0'  END
		,@Bit048 = CASE WHEN LEN(@Bit048) > 0 THEN '1' + @Bit048 + ''  ELSE  '0'  END
		,@Bit049 = CASE WHEN LEN(@Bit049) > 0 THEN '1' + @Bit049 + ''  ELSE  '0'  END
		,@Bit050 = CASE WHEN LEN(@Bit050) > 0 THEN '1' + @Bit050 + ''  ELSE  '0'  END
		,@Bit051 = CASE WHEN LEN(@Bit051) > 0 THEN '1' + @Bit051 + ''  ELSE  '0'  END
		,@Bit052 = CASE WHEN LEN(@Bit052) > 0 THEN '1' + @Bit052 + ''  ELSE  '0'  END
		,@Bit053 = CASE WHEN LEN(@Bit053) > 0 THEN '1' + @Bit053 + ''  ELSE  '0'  END
		,@Bit054 = CASE WHEN LEN(@Bit054) > 0 THEN '1' + @Bit054 + ''  ELSE  '0'  END
		,@Bit055 = CASE WHEN LEN(@Bit055) > 0 THEN '1' + @Bit055 + ''  ELSE  '0'  END
		,@Bit056 = CASE WHEN LEN(@Bit056) > 0 THEN '1' + @Bit056 + ''  ELSE  '0'  END
		,@Bit057 = CASE WHEN LEN(@Bit057) > 0 THEN '1' + @Bit057 + ''  ELSE  '0'  END
		,@Bit058 = CASE WHEN LEN(@Bit058) > 0 THEN '1' + @Bit058 + ''  ELSE  '0'  END
		,@Bit059 = CASE WHEN LEN(@Bit059) > 0 THEN '1' + @Bit059 + ''  ELSE  '0'  END
		,@Bit060 = CASE WHEN LEN(@Bit060) > 0 THEN '1' + @Bit060 + ''  ELSE  '0'  END
		,@Bit061 = CASE WHEN LEN(@Bit061) > 0 THEN '1' + @Bit061 + ''  ELSE  '0'  END
		,@Bit062 = CASE WHEN LEN(@Bit062) > 0 THEN '1' + @Bit062 + ''  ELSE  '0'  END
		,@Bit063 = CASE WHEN LEN(@Bit063) > 0 THEN '1' + @Bit063 + ''  ELSE  '0'  END
		,@Bit064 = CASE WHEN LEN(@Bit064) > 0 THEN '1' + @Bit064 + ''  ELSE  '0'  END
		,@Bit065 = CASE WHEN LEN(@Bit065) > 0 THEN '1' + @Bit065 + ''  ELSE  '0'  END
		,@Bit066 = CASE WHEN LEN(@Bit066) > 0 THEN '1' + @Bit066 + ''  ELSE  '0'  END
		,@Bit067 = CASE WHEN LEN(@Bit067) > 0 THEN '1' + @Bit067 + ''  ELSE  '0'  END
		,@Bit068 = CASE WHEN LEN(@Bit068) > 0 THEN '1' + @Bit068 + ''  ELSE  '0'  END
		,@Bit069 = CASE WHEN LEN(@Bit069) > 0 THEN '1' + @Bit069 + ''  ELSE  '0'  END
		,@Bit070 = CASE WHEN LEN(@Bit070) > 0 THEN '1' + @Bit070 + ''  ELSE  '0'  END
		,@Bit071 = CASE WHEN LEN(@Bit071) > 0 THEN '1' + @Bit071 + ''  ELSE  '0'  END
		,@Bit072 = CASE WHEN LEN(@Bit072) > 0 THEN '1' + @Bit072 + ''  ELSE  '0'  END
		,@Bit073 = CASE WHEN LEN(@Bit073) > 0 THEN '1' + @Bit073 + ''  ELSE  '0'  END
		,@Bit074 = CASE WHEN LEN(@Bit074) > 0 THEN '1' + @Bit074 + ''  ELSE  '0'  END
		,@Bit075 = CASE WHEN LEN(@Bit075) > 0 THEN '1' + @Bit075 + ''  ELSE  '0'  END
		,@Bit076 = CASE WHEN LEN(@Bit076) > 0 THEN '1' + @Bit076 + ''  ELSE  '0'  END
		,@Bit077 = CASE WHEN LEN(@Bit077) > 0 THEN '1' + @Bit077 + ''  ELSE  '0'  END
		,@Bit078 = CASE WHEN LEN(@Bit078) > 0 THEN '1' + @Bit078 + ''  ELSE  '0'  END
		,@Bit079 = CASE WHEN LEN(@Bit079) > 0 THEN '1' + @Bit079 + ''  ELSE  '0'  END
		,@Bit080 = CASE WHEN LEN(@Bit080) > 0 THEN '1' + @Bit080 + ''  ELSE  '0'  END
		,@Bit081 = CASE WHEN LEN(@Bit081) > 0 THEN '1' + @Bit081 + ''  ELSE  '0'  END
		,@Bit082 = CASE WHEN LEN(@Bit082) > 0 THEN '1' + @Bit082 + ''  ELSE  '0'  END
		,@Bit083 = CASE WHEN LEN(@Bit083) > 0 THEN '1' + @Bit083 + ''  ELSE  '0'  END
		,@Bit084 = CASE WHEN LEN(@Bit084) > 0 THEN '1' + @Bit084 + ''  ELSE  '0'  END
		,@Bit085 = CASE WHEN LEN(@Bit085) > 0 THEN '1' + @Bit085 + ''  ELSE  '0'  END
		,@Bit086 = CASE WHEN LEN(@Bit086) > 0 THEN '1' + @Bit086 + ''  ELSE  '0'  END
		,@Bit087 = CASE WHEN LEN(@Bit087) > 0 THEN '1' + @Bit087 + ''  ELSE  '0'  END
		,@Bit088 = CASE WHEN LEN(@Bit088) > 0 THEN '1' + @Bit088 + ''  ELSE  '0'  END
		,@Bit089 = CASE WHEN LEN(@Bit089) > 0 THEN '1' + @Bit089 + ''  ELSE  '0'  END
		,@Bit090 = CASE WHEN LEN(@Bit090) > 0 THEN '1' + @Bit090 + ''  ELSE  '0'  END
		,@Bit091 = CASE WHEN LEN(@Bit091) > 0 THEN '1' + @Bit091 + ''  ELSE  '0'  END
		,@Bit092 = CASE WHEN LEN(@Bit092) > 0 THEN '1' + @Bit092 + ''  ELSE  '0'  END
		,@Bit093 = CASE WHEN LEN(@Bit093) > 0 THEN '1' + @Bit093 + ''  ELSE  '0'  END
		,@Bit094 = CASE WHEN LEN(@Bit094) > 0 THEN '1' + @Bit094 + ''  ELSE  '0'  END
		,@Bit095 = CASE WHEN LEN(@Bit095) > 0 THEN '1' + @Bit095 + ''  ELSE  '0'  END
		,@Bit096 = CASE WHEN LEN(@Bit096) > 0 THEN '1' + @Bit096 + ''  ELSE  '0'  END
		,@Bit097 = CASE WHEN LEN(@Bit097) > 0 THEN '1' + @Bit097 + ''  ELSE  '0'  END
		,@Bit098 = CASE WHEN LEN(@Bit098) > 0 THEN '1' + @Bit098 + ''  ELSE  '0'  END
		,@Bit099 = CASE WHEN LEN(@Bit099) > 0 THEN '1' + @Bit099 + ''  ELSE  '0'  END
		,@Bit100 = CASE WHEN LEN(@Bit100) > 0 THEN '1' + @Bit100 + ''  ELSE  '0'  END
		,@Bit101 = CASE WHEN LEN(@Bit101) > 0 THEN '1' + @Bit101 + ''  ELSE  '0'  END
		,@Bit102 = CASE WHEN LEN(@Bit102) > 0 THEN '1' + @Bit102 + ''  ELSE  '0'  END
		,@Bit103 = CASE WHEN LEN(@Bit103) > 0 THEN '1' + @Bit103 + ''  ELSE  '0'  END
		,@Bit104 = CASE WHEN LEN(@Bit104) > 0 THEN '1' + @Bit104 + ''  ELSE  '0'  END
		,@Bit105 = CASE WHEN LEN(@Bit105) > 0 THEN '1' + @Bit105 + ''  ELSE  '0'  END
		,@Bit106 = CASE WHEN LEN(@Bit106) > 0 THEN '1' + @Bit106 + ''  ELSE  '0'  END
		,@Bit107 = CASE WHEN LEN(@Bit107) > 0 THEN '1' + @Bit107 + ''  ELSE  '0'  END
		,@Bit108 = CASE WHEN LEN(@Bit108) > 0 THEN '1' + @Bit108 + ''  ELSE  '0'  END
		,@Bit109 = CASE WHEN LEN(@Bit109) > 0 THEN '1' + @Bit109 + ''  ELSE  '0'  END
		,@Bit110 = CASE WHEN LEN(@Bit110) > 0 THEN '1' + @Bit110 + ''  ELSE  '0'  END
		,@Bit111 = CASE WHEN LEN(@Bit111) > 0 THEN '1' + @Bit111 + ''  ELSE  '0'  END
		,@Bit112 = CASE WHEN LEN(@Bit112) > 0 THEN '1' + @Bit112 + ''  ELSE  '0'  END
		,@Bit113 = CASE WHEN LEN(@Bit113) > 0 THEN '1' + @Bit113 + ''  ELSE  '0'  END
		,@Bit114 = CASE WHEN LEN(@Bit114) > 0 THEN '1' + @Bit114 + ''  ELSE  '0'  END
		,@Bit115 = CASE WHEN LEN(@Bit115) > 0 THEN '1' + @Bit115 + ''  ELSE  '0'  END
		,@Bit116 = CASE WHEN LEN(@Bit116) > 0 THEN '1' + @Bit116 + ''  ELSE  '0'  END
		,@Bit117 = CASE WHEN LEN(@Bit117) > 0 THEN '1' + @Bit117 + ''  ELSE  '0'  END
		,@Bit118 = CASE WHEN LEN(@Bit118) > 0 THEN '1' + @Bit118 + ''  ELSE  '0'  END
		,@Bit119 = CASE WHEN LEN(@Bit119) > 0 THEN '1' + @Bit119 + ''  ELSE  '0'  END
		,@Bit120 = CASE WHEN LEN(@Bit120) > 0 THEN '1' + @Bit120 + ''  ELSE  '0'  END
		,@Bit121 = CASE WHEN LEN(@Bit121) > 0 THEN '1' + @Bit121 + ''  ELSE  '0'  END
		,@Bit122 = CASE WHEN LEN(@Bit122) > 0 THEN '1' + @Bit122 + ''  ELSE  '0'  END
		,@Bit123 = CASE WHEN LEN(@Bit123) > 0 THEN '1' + @Bit123 + ''  ELSE  '0'  END
		,@Bit124 = CASE WHEN LEN(@Bit124) > 0 THEN '1' + @Bit124 + ''  ELSE  '0'  END
		,@Bit125 = CASE WHEN LEN(@Bit125) > 0 THEN '1' + @Bit125 + ''  ELSE  '0'  END
		,@Bit126 = CASE WHEN LEN(@Bit126) > 0 THEN '1' + @Bit126 + ''  ELSE  '0'  END
		,@Bit127 = CASE WHEN LEN(@Bit127) > 0 THEN '1' + @Bit127 + ''  ELSE  '0'  END
		,@Bit128 = CASE WHEN LEN(@Bit128) > 0 THEN '1' + @Bit128 + ''  ELSE  '0'  END

		

	EXEC [pr_aut_AutorizaTransacao]
		@Bit001 OUTPUT, @Bit002 OUTPUT, @Bit003 OUTPUT, @Bit004 OUTPUT, @Bit005 OUTPUT, @Bit006 OUTPUT, @Bit007 OUTPUT, @Bit008 OUTPUT,
		@Bit009 OUTPUT, @Bit010 OUTPUT, @Bit011 OUTPUT, @Bit012 OUTPUT, @Bit013 OUTPUT, @Bit014 OUTPUT, @Bit015 OUTPUT, @Bit016 OUTPUT,
		@Bit017 OUTPUT, @Bit018 OUTPUT, @Bit019 OUTPUT, @Bit020 OUTPUT, @Bit021 OUTPUT, @Bit022 OUTPUT, @Bit023 OUTPUT, @Bit024 OUTPUT,
		@Bit025 OUTPUT, @Bit026 OUTPUT, @Bit027 OUTPUT, @Bit028 OUTPUT, @Bit029 OUTPUT, @Bit030 OUTPUT, @Bit031 OUTPUT, @Bit032 OUTPUT,
		@Bit033 OUTPUT, @Bit034 OUTPUT, @Bit035 OUTPUT, @Bit036 OUTPUT, @Bit037 OUTPUT, @Bit038 OUTPUT, @Bit039 OUTPUT, @Bit040 OUTPUT,
		@Bit041 OUTPUT, @Bit042 OUTPUT, @Bit043 OUTPUT, @Bit044 OUTPUT, @Bit045 OUTPUT, @Bit046 OUTPUT, @Bit047 OUTPUT, @Bit048 OUTPUT,
		@Bit049 OUTPUT, @Bit050 OUTPUT, @Bit051 OUTPUT, @Bit052 OUTPUT, @Bit053 OUTPUT, @Bit054 OUTPUT, @Bit055 OUTPUT, @Bit056 OUTPUT,
		@Bit057 OUTPUT, @Bit058 OUTPUT, @Bit059 OUTPUT, @Bit060 OUTPUT, @Bit061 OUTPUT, @Bit062 OUTPUT, @Bit063 OUTPUT, @Bit064 OUTPUT,
		@Bit065 OUTPUT, @Bit066 OUTPUT, @Bit067 OUTPUT, @Bit068 OUTPUT, @Bit069 OUTPUT, @Bit070 OUTPUT, @Bit071 OUTPUT, @Bit072 OUTPUT,
		@Bit073 OUTPUT, @Bit074 OUTPUT, @Bit075 OUTPUT, @Bit076 OUTPUT, @Bit077 OUTPUT, @Bit078 OUTPUT, @Bit079 OUTPUT, @Bit080 OUTPUT,
		@Bit081 OUTPUT, @Bit082 OUTPUT, @Bit083 OUTPUT, @Bit084 OUTPUT, @Bit085 OUTPUT, @Bit086 OUTPUT, @Bit087 OUTPUT, @Bit088 OUTPUT,
		@Bit089 OUTPUT, @Bit090 OUTPUT, @Bit091 OUTPUT, @Bit092 OUTPUT, @Bit093 OUTPUT, @Bit094 OUTPUT, @Bit095 OUTPUT, @Bit096 OUTPUT,
		@Bit097 OUTPUT, @Bit098 OUTPUT, @Bit099 OUTPUT, @Bit100 OUTPUT, @Bit101 OUTPUT, @Bit102 OUTPUT, @Bit103 OUTPUT, @Bit104 OUTPUT,
		@Bit105 OUTPUT, @Bit106 OUTPUT, @Bit107 OUTPUT, @Bit108 OUTPUT, @Bit109 OUTPUT, @Bit110 OUTPUT, @Bit111 OUTPUT, @Bit112 OUTPUT,
		@Bit113 OUTPUT, @Bit114 OUTPUT, @Bit115 OUTPUT, @Bit116 OUTPUT, @Bit117 OUTPUT, @Bit118 OUTPUT, @Bit119 OUTPUT, @Bit120 OUTPUT,
		@Bit121 OUTPUT, @Bit122 OUTPUT, @Bit123 OUTPUT, @Bit124 OUTPUT, @Bit125 OUTPUT, @Bit126 OUTPUT, @Bit127 OUTPUT, @Bit128 OUTPUT

	SET @Bit039 = [DBO].[f_RemoverSinalizador](@Bit039)
	print @bit062
	SET @Bit062 = [DBO].[f_RemoverSinalizador](@Bit062)
			print @bit062
	IF @Bit039 <> ''
	BEGIN
		IF @Bit062 <> ''
		BEGIN
	
			IF (@cCodigoProcessamento = '599002')
			BEGIN
			  print @bit062
				SET @cNomeUsuario		= SUBSTRING(@Bit062,1,(CHARINDEX('|',@Bit062)-1)) SET @Bit062 = SUBSTRING(@Bit062, (CHARINDEX('|',@Bit062)+1), LEN(@Bit062))		
				SET @nSaldo_Disp		= SUBSTRING(@Bit062,1,(CHARINDEX('|',@Bit062)-1)) SET @Bit062 = SUBSTRING(@Bit062, (CHARINDEX('|',@Bit062)+1), LEN(@Bit062))
				SET @sNsuOperadora		= SUBSTRING(@Bit062,1,(CHARINDEX('|',@Bit062)-1)) SET @Bit062 = SUBSTRING(@Bit062, (CHARINDEX('|',@Bit062)+1), LEN(@Bit062))
				SET @cResposta			= SUBSTRING(@Bit062,1,(CHARINDEX('|',@Bit062)-1)) SET @Bit062 = SUBSTRING(@Bit062, (CHARINDEX('|',@Bit062)+1), LEN(@Bit062))
				SET @cRespostaRecarga	= SUBSTRING(@Bit062,1,(CHARINDEX('|',@Bit062)-1)) SET @Bit062 = SUBSTRING(@Bit062, (CHARINDEX('|',@Bit062)+1), LEN(@Bit062))
				SET @cMensagem			= SUBSTRING(@Bit062,1,(CHARINDEX('|',@Bit062)-1)) SET @Bit062 = SUBSTRING(@Bit062, (CHARINDEX('|',@Bit062)+1), LEN(@Bit062))
				SET @cResult			= SUBSTRING(@Bit062,1,(CHARINDEX('|',@Bit062)-1)) SET @Bit062 = SUBSTRING(@Bit062, (CHARINDEX('|',@Bit062)+1), LEN(@Bit062))

				SET @iRespostaRecarga = CONVERT(INT,@cRespostaRecarga)

			END 
			ELSE
			BEGIN

				SET @cNomeUsuario		= SUBSTRING(@Bit062,1,(CHARINDEX('|',@Bit062)-1)) SET @Bit062 = SUBSTRING(@Bit062, (CHARINDEX('|',@Bit062)+1), LEN(@Bit062))		
				SET @nSaldo_Disp		= SUBSTRING(@Bit062,1,(CHARINDEX('|',@Bit062)-1)) SET @Bit062 = SUBSTRING(@Bit062, (CHARINDEX('|',@Bit062)+1), LEN(@Bit062))
				SET @cResposta			= SUBSTRING(@Bit062,1,(CHARINDEX('|',@Bit062)-1)) SET @Bit062 = SUBSTRING(@Bit062, (CHARINDEX('|',@Bit062)+1), LEN(@Bit062))
				SET @cMensagem			= SUBSTRING(@Bit062,1,(CHARINDEX('|',@Bit062)-1)) SET @Bit062 = SUBSTRING(@Bit062, (CHARINDEX('|',@Bit062)+1), LEN(@Bit062))
				SET @cResult			= SUBSTRING(@Bit062,1,(CHARINDEX('|',@Bit062)-1)) SET @Bit062 = SUBSTRING(@Bit062, (CHARINDEX('|',@Bit062)+1), LEN(@Bit062))
			
			END

			SET @iResposta = CONVERT(INT,@cResposta)
			
		END
	END
	ELSE 
	BEGIN
		/*Resposta padrao para casos de algum problema na autorizacao.*/
		SET @iResposta	= 25
		SET @cResult	= 'ERRO INTERNO AUTORIZADOR'
		SET @cMensagem	= 'ERRO NA AUTORIZACAO'
	
	END

	IF (@cCodigoProcessamento = '599002')
	BEGIN

		DECLARE @bDesfazTransacao	BIT

		SET @bDesfazTransacao = 0

		IF (@iResposta = 0 AND @iRespostaRecarga > 0)
		BEGIN

			SET @bDesfazTransacao = 1
			SET @iResposta = @iRespostaRecarga
		
		END

		SELECT 
			 iResposta			= @iResposta
			,cResult			= @cResult
			,cMensagem			= @cMensagem
			,sNomeUsuario		= @cNomeUsuario
			,nSaldo_Disp		= @nSaldo_Disp
			,cAutorizacao		= [DBO].[f_RemoverSinalizador](@Bit038)
			,Codigo_Referencia	= [DBO].[f_RemoverSinalizador](@Bit127)
			,NsuOperadora		= @sNsuOperadora

		IF (@bDesfazTransacao = 1)
		BEGIN

			SELECT @Bit001 = [dbo].[f_RemoverSinalizador](@Bit001), @Bit003 = [dbo].[f_RemoverSinalizador](@Bit003), @Bit011 = [dbo].[f_RemoverSinalizador](@Bit011),
				   @Bit007 = [dbo].[f_RemoverSinalizador](@Bit007), @Bit012 = [dbo].[f_RemoverSinalizador](@Bit012), @Bit013 = [dbo].[f_RemoverSinalizador](@Bit013)
			

			SET @Bit090 = '0200' + @Bit003 + @Bit011 + @Bit007 + @Bit012 + @Bit013

			SELECT  @Bit001 = '0420'
				   ,@Bit003 = '200030'
				   ,@Bit038 = ''
				   ,@Bit039 = ''
				   ,@Bit024 = @cRedeCaptura
				   ,@Bit127 = ''


			SELECT  @Bit001 = CASE WHEN LEN(@Bit001) > 0 THEN '1' + @Bit001 + ''  ELSE  '0'  END
				   ,@Bit003 = CASE WHEN LEN(@Bit003) > 0 THEN '1' + @Bit003 + ''  ELSE  '0'  END
				   ,@Bit007 = CASE WHEN LEN(@Bit007) > 0 THEN '1' + @Bit007 + ''  ELSE  '0'  END
				   ,@Bit011 = CASE WHEN LEN(@Bit011) > 0 THEN '1' + @Bit011 + ''  ELSE  '0'  END
				   ,@Bit012 = CASE WHEN LEN(@Bit012) > 0 THEN '1' + @Bit012 + ''  ELSE  '0'  END
				   ,@Bit013 = CASE WHEN LEN(@Bit013) > 0 THEN '1' + @Bit013 + ''  ELSE  '0'  END
				   ,@Bit024 = CASE WHEN LEN(@Bit024) > 0 THEN '1' + @Bit024 + ''  ELSE  '0'  END
				   ,@Bit090 = CASE WHEN LEN(@Bit090) > 0 THEN '1' + @Bit090 + ''  ELSE  '0'  END

			EXEC [pr_aut_AutorizaTransacao]
				@Bit001 OUTPUT, @Bit002 OUTPUT, @Bit003 OUTPUT, @Bit004 OUTPUT, @Bit005 OUTPUT, @Bit006 OUTPUT, @Bit007 OUTPUT, @Bit008 OUTPUT,
				@Bit009 OUTPUT, @Bit010 OUTPUT, @Bit011 OUTPUT, @Bit012 OUTPUT, @Bit013 OUTPUT, @Bit014 OUTPUT, @Bit015 OUTPUT, @Bit016 OUTPUT,
				@Bit017 OUTPUT, @Bit018 OUTPUT, @Bit019 OUTPUT, @Bit020 OUTPUT, @Bit021 OUTPUT, @Bit022 OUTPUT, @Bit023 OUTPUT, @Bit024 OUTPUT,
				@Bit025 OUTPUT, @Bit026 OUTPUT, @Bit027 OUTPUT, @Bit028 OUTPUT, @Bit029 OUTPUT, @Bit030 OUTPUT, @Bit031 OUTPUT, @Bit032 OUTPUT,
				@Bit033 OUTPUT, @Bit034 OUTPUT, @Bit035 OUTPUT, @Bit036 OUTPUT, @Bit037 OUTPUT, @Bit038 OUTPUT, @Bit039 OUTPUT, @Bit040 OUTPUT,
				@Bit041 OUTPUT, @Bit042 OUTPUT, @Bit043 OUTPUT, @Bit044 OUTPUT, @Bit045 OUTPUT, @Bit046 OUTPUT, @Bit047 OUTPUT, @Bit048 OUTPUT,
				@Bit049 OUTPUT, @Bit050 OUTPUT, @Bit051 OUTPUT, @Bit052 OUTPUT, @Bit053 OUTPUT, @Bit054 OUTPUT, @Bit055 OUTPUT, @Bit056 OUTPUT,
				@Bit057 OUTPUT, @Bit058 OUTPUT, @Bit059 OUTPUT, @Bit060 OUTPUT, @Bit061 OUTPUT, @Bit062 OUTPUT, @Bit063 OUTPUT, @Bit064 OUTPUT,
				@Bit065 OUTPUT, @Bit066 OUTPUT, @Bit067 OUTPUT, @Bit068 OUTPUT, @Bit069 OUTPUT, @Bit070 OUTPUT, @Bit071 OUTPUT, @Bit072 OUTPUT,
				@Bit073 OUTPUT, @Bit074 OUTPUT, @Bit075 OUTPUT, @Bit076 OUTPUT, @Bit077 OUTPUT, @Bit078 OUTPUT, @Bit079 OUTPUT, @Bit080 OUTPUT,
				@Bit081 OUTPUT, @Bit082 OUTPUT, @Bit083 OUTPUT, @Bit084 OUTPUT, @Bit085 OUTPUT, @Bit086 OUTPUT, @Bit087 OUTPUT, @Bit088 OUTPUT,
				@Bit089 OUTPUT, @Bit090 OUTPUT, @Bit091 OUTPUT, @Bit092 OUTPUT, @Bit093 OUTPUT, @Bit094 OUTPUT, @Bit095 OUTPUT, @Bit096 OUTPUT,
				@Bit097 OUTPUT, @Bit098 OUTPUT, @Bit099 OUTPUT, @Bit100 OUTPUT, @Bit101 OUTPUT, @Bit102 OUTPUT, @Bit103 OUTPUT, @Bit104 OUTPUT,
				@Bit105 OUTPUT, @Bit106 OUTPUT, @Bit107 OUTPUT, @Bit108 OUTPUT, @Bit109 OUTPUT, @Bit110 OUTPUT, @Bit111 OUTPUT, @Bit112 OUTPUT,
				@Bit113 OUTPUT, @Bit114 OUTPUT, @Bit115 OUTPUT, @Bit116 OUTPUT, @Bit117 OUTPUT, @Bit118 OUTPUT, @Bit119 OUTPUT, @Bit120 OUTPUT,
				@Bit121 OUTPUT, @Bit122 OUTPUT, @Bit123 OUTPUT, @Bit124 OUTPUT, @Bit125 OUTPUT, @Bit126 OUTPUT, @Bit127 OUTPUT, @Bit128 OUTPUT

		END


	END
	ELSE
	BEGIN
		
		SELECT 
			 iResposta			= @iResposta
			,cResult			= @cResult
			,cMensagem			= @cMensagem
			,sNomeUsuario		= @cNomeUsuario
			,nSaldo_Disp		= @nSaldo_Disp
			,cAutorizacao		= [DBO].[f_RemoverSinalizador](@Bit038)
			,Codigo_Referencia	= [DBO].[f_RemoverSinalizador](@Bit127)
	END

END



