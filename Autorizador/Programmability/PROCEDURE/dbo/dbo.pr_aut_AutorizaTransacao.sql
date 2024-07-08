


/*
--------------------------------------------------------------------------
Nome Sistema: Autorização
Objeto: [dbo].[pr_aut_AutorizaTransacao]
Propósito: Procedure responsável por
Autor: Cristiano Silva Barbosa - Policard Systems
--------------------------------------------------------------------------
Data Alteracao: 23/03/2017
Autor: Cristiano Barbosa
CH: 365214 - 2676 --Ajuste
--------------------------------------------------------------------------
Data Alteracao: 30/03/2017
Autor: Cristiano Barbosa
CH: 368851 - 2704 --Ajuste
--------------------------------------------------------------------------
Data Alteracao: 16/05/2017
Autor: Cristiano Barbosa
CH: 383212 - 2839
--------------------------------------------------------------------------
Data Alteração: 06/06/2017
Chamado: 389762 / 2926 
Responsavel: Cristiano Barbosa- Policard Systems
--------------------------------------------------------------------------
Data Alteração: 28/09/2017
Chamados: 399954 / 417680 / 417666 / 3262
Responsavel: Cristiano Barbosa- Policard Systems
--------------------------------------------------------------------------
Data Alteração: 26/04/2018
Chamados: 494467  / 3947
Responsavel: Cristiano Barbosa- Up Brasil
--------------------------------------------------------------------------
Data Alteração: 29/11/2018
Chamados: 581341/4666
Responsavel: João Henrique - Up Brasil
--------------------------------------------------------------------------
Data Alteracao: 25/03/2019
Autor: Kyros
CH: 618588 - Projeto Melhorias SGF - Auto Gestão
Descrição: Criação de uma nova Opção Frota (4) e de uma nova Rede (SGF)
--------------------------------------------------------------------------
Data Alteracao: 21/10/2021
Autor: Cristiano
CH:  - Projeto Carteira Digital CardSE
Descrição: Inclusao do pagamento de carteira digital CardSE
--------------------------------------------------------------------------
Data: 24/02/2022
Autor: João Henrique - Up Brasil
GMUD Emergencial: 1823967
Descrição: Correção fluxo para tratativa de mensagens 0800 do CardSE.
--------------------------------------------------------------------------
Data: 20/06/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1867627
Descrição: Projeto Novas Regras PAT.
-------------------------------------------------------------------------- 	
Data: 08/09/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1843805
Descrição: Projeto ABECS para transações NCR/Scope.
-------------------------------------------------------------------------- 	
Data: 03/10/2023
Autor: Adilson Pereira - Up Brasil
Chamado: 2062670
Descrição: Alteração para notificar o usuário pelo motivo da negativa da transação.
	Squad Rede - Jornada VA
-------------------------------------------------------------------------- 	
Data: 17/10/2023
Autor: Adilson Pereira - Up Brasil
Chamado: 2067391 
Descrição: Altera passagem de parâmetros para processo de envio de notificação por push.
	No caso de transações negadas não é gerado registro nas tabelas finais.
-------------------------------------------------------------------------- 
*/

CREATE PROCEDURE [dbo].[pr_aut_AutorizaTransacao]
	@Bit001in VARCHAR(1000) OUTPUT, @Bit002in VARCHAR(1000) OUTPUT, @Bit003in VARCHAR(1000) OUTPUT, @Bit004in VARCHAR(1000) OUTPUT,
	@Bit005in VARCHAR(1000) OUTPUT, @Bit006in VARCHAR(1000) OUTPUT, @Bit007in VARCHAR(1000) OUTPUT, @Bit008in VARCHAR(1000) OUTPUT,
	@Bit009in VARCHAR(1000) OUTPUT, @Bit010in VARCHAR(1000) OUTPUT, @Bit011in VARCHAR(1000) OUTPUT, @Bit012in VARCHAR(1000) OUTPUT,
	@Bit013in VARCHAR(1000) OUTPUT, @Bit014in VARCHAR(1000) OUTPUT, @Bit015in VARCHAR(1000) OUTPUT, @Bit016in VARCHAR(1000) OUTPUT,
	@Bit017in VARCHAR(1000) OUTPUT, @Bit018in VARCHAR(1000) OUTPUT, @Bit019in VARCHAR(1000) OUTPUT, @Bit020in VARCHAR(1000) OUTPUT,
	@Bit021in VARCHAR(1000) OUTPUT, @Bit022in VARCHAR(1000) OUTPUT, @Bit023in VARCHAR(1000) OUTPUT, @Bit024in VARCHAR(1000) OUTPUT,
	@Bit025in VARCHAR(1000) OUTPUT, @Bit026in VARCHAR(1000) OUTPUT, @Bit027in VARCHAR(1000) OUTPUT, @Bit028in VARCHAR(1000) OUTPUT,
	@Bit029in VARCHAR(1000) OUTPUT, @Bit030in VARCHAR(1000) OUTPUT, @Bit031in VARCHAR(1000) OUTPUT, @Bit032in VARCHAR(1000) OUTPUT,
	@Bit033in VARCHAR(1000) OUTPUT, @Bit034in VARCHAR(1000) OUTPUT, @Bit035in VARCHAR(1000) OUTPUT, @Bit036in VARCHAR(1000) OUTPUT,
	@Bit037in VARCHAR(1000) OUTPUT, @Bit038in VARCHAR(1000) OUTPUT, @Bit039in VARCHAR(1000) OUTPUT, @Bit040in VARCHAR(1000) OUTPUT,
	@Bit041in VARCHAR(1000) OUTPUT, @Bit042in VARCHAR(1000) OUTPUT, @Bit043in VARCHAR(1000) OUTPUT, @Bit044in VARCHAR(1000) OUTPUT,
	@Bit045in VARCHAR(1000) OUTPUT, @Bit046in VARCHAR(1000) OUTPUT, @Bit047in VARCHAR(1000) OUTPUT, @Bit048in VARCHAR(1000) OUTPUT,
	@Bit049in VARCHAR(1000) OUTPUT, @Bit050in VARCHAR(1000) OUTPUT, @Bit051in VARCHAR(1000) OUTPUT, @Bit052in VARCHAR(1000) OUTPUT,
	@Bit053in VARCHAR(1000) OUTPUT, @Bit054in VARCHAR(1000) OUTPUT, @Bit055in VARCHAR(1000) OUTPUT, @Bit056in VARCHAR(1000) OUTPUT,
	@Bit057in VARCHAR(1000) OUTPUT, @Bit058in VARCHAR(1000) OUTPUT, @Bit059in VARCHAR(1000) OUTPUT, @Bit060in VARCHAR(1000) OUTPUT,
	@Bit061in VARCHAR(1000) OUTPUT, @Bit062in VARCHAR(1000) OUTPUT, @Bit063in VARCHAR(1000) OUTPUT, @Bit064in VARCHAR(1000) OUTPUT,
	@Bit065in VARCHAR(1000) OUTPUT, @Bit066in VARCHAR(1000) OUTPUT, @Bit067in VARCHAR(1000) OUTPUT, @Bit068in VARCHAR(1000) OUTPUT,
	@Bit069in VARCHAR(1000) OUTPUT, @Bit070in VARCHAR(1000) OUTPUT, @Bit071in VARCHAR(1000) OUTPUT, @Bit072in VARCHAR(1000) OUTPUT,
	@Bit073in VARCHAR(1000) OUTPUT, @Bit074in VARCHAR(1000) OUTPUT, @Bit075in VARCHAR(1000) OUTPUT, @Bit076in VARCHAR(1000) OUTPUT,
	@Bit077in VARCHAR(1000) OUTPUT, @Bit078in VARCHAR(1000) OUTPUT, @Bit079in VARCHAR(1000) OUTPUT, @Bit080in VARCHAR(1000) OUTPUT,
	@Bit081in VARCHAR(1000) OUTPUT, @Bit082in VARCHAR(1000) OUTPUT, @Bit083in VARCHAR(1000) OUTPUT, @Bit084in VARCHAR(1000) OUTPUT,
	@Bit085in VARCHAR(1000) OUTPUT, @Bit086in VARCHAR(1000) OUTPUT, @Bit087in VARCHAR(1000) OUTPUT, @Bit088in VARCHAR(1000) OUTPUT,
	@Bit089in VARCHAR(1000) OUTPUT, @Bit090in VARCHAR(1000) OUTPUT, @Bit091in VARCHAR(1000) OUTPUT, @Bit092in VARCHAR(1000) OUTPUT,
	@Bit093in VARCHAR(1000) OUTPUT, @Bit094in VARCHAR(1000) OUTPUT, @Bit095in VARCHAR(1000) OUTPUT, @Bit096in VARCHAR(1000) OUTPUT,
	@Bit097in VARCHAR(1000) OUTPUT, @Bit098in VARCHAR(1000) OUTPUT, @Bit099in VARCHAR(1000) OUTPUT, @Bit100in VARCHAR(1000) OUTPUT,
	@Bit101in VARCHAR(1000) OUTPUT, @Bit102in VARCHAR(1000) OUTPUT, @Bit103in VARCHAR(1000) OUTPUT, @Bit104in VARCHAR(1000) OUTPUT,
	@Bit105in VARCHAR(1000) OUTPUT, @Bit106in VARCHAR(1000) OUTPUT, @Bit107in VARCHAR(1000) OUTPUT, @Bit108in VARCHAR(1000) OUTPUT,
	@Bit109in VARCHAR(1000) OUTPUT, @Bit110in VARCHAR(1000) OUTPUT, @Bit111in VARCHAR(1000) OUTPUT, @Bit112in VARCHAR(1000) OUTPUT,
	@Bit113in VARCHAR(1000) OUTPUT, @Bit114in VARCHAR(1000) OUTPUT, @Bit115in VARCHAR(1000) OUTPUT, @Bit116in VARCHAR(1000) OUTPUT,
	@Bit117in VARCHAR(1000) OUTPUT, @Bit118in VARCHAR(1000) OUTPUT, @Bit119in VARCHAR(1000) OUTPUT, @Bit120in VARCHAR(1000) OUTPUT,
	@Bit121in VARCHAR(1000) OUTPUT, @Bit122in VARCHAR(1000) OUTPUT, @Bit123in VARCHAR(1000) OUTPUT, @Bit124in VARCHAR(1000) OUTPUT,
	@Bit125in VARCHAR(1000) OUTPUT, @Bit126in VARCHAR(1000) OUTPUT, @Bit127in VARCHAR(1000) OUTPUT, @Bit128in VARCHAR(1000) OUTPUT
AS
BEGIN
	
	SET NOCOUNT ON;
	
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
			@Bit121 VARCHAR(1000), @Bit122 VARCHAR(1000), @Bit123 VARCHAR(1000), @Bit124 VARCHAR(1000), @Bit125 VARCHAR(1000), @Bit126 VARCHAR(1000), @Bit127 VARCHAR(1000), @Bit128 VARCHAR(1000),
			@dDataHoraSolicitacao DATETIME, @dDataHoraResposta DATETIME, @iCodigoEstabelecimento BIGINT, @nValor_Transacao DECIMAL(15,2)

	SELECT	@Bit001 = [dbo].[f_RemoverSinalizador](@Bit001in), @Bit002 = [dbo].[f_RemoverSinalizador](@Bit002in), @Bit003 = [dbo].[f_RemoverSinalizador](@Bit003in), @Bit004 = [dbo].[f_RemoverSinalizador](@Bit004in),
			@Bit005 = [dbo].[f_RemoverSinalizador](@Bit005in), @Bit006 = [dbo].[f_RemoverSinalizador](@Bit006in), @Bit007 = [dbo].[f_RemoverSinalizador](@Bit007in), @Bit008 = [dbo].[f_RemoverSinalizador](@Bit008in),
			@Bit009 = [dbo].[f_RemoverSinalizador](@Bit009in), @Bit010 = [dbo].[f_RemoverSinalizador](@Bit010in), @Bit011 = [dbo].[f_RemoverSinalizador](@Bit011in), @Bit012 = [dbo].[f_RemoverSinalizador](@Bit012in),
			@Bit013 = [dbo].[f_RemoverSinalizador](@Bit013in), @Bit014 = [dbo].[f_RemoverSinalizador](@Bit014in), @Bit015 = [dbo].[f_RemoverSinalizador](@Bit015in), @Bit016 = [dbo].[f_RemoverSinalizador](@Bit016in),
			@Bit017 = [dbo].[f_RemoverSinalizador](@Bit017in), @Bit018 = [dbo].[f_RemoverSinalizador](@Bit018in), @Bit019 = [dbo].[f_RemoverSinalizador](@Bit019in), @Bit020 = [dbo].[f_RemoverSinalizador](@Bit020in),
			@Bit021 = [dbo].[f_RemoverSinalizador](@Bit021in), @Bit022 = [dbo].[f_RemoverSinalizador](@Bit022in), @Bit023 = [dbo].[f_RemoverSinalizador](@Bit023in), @Bit024 = [dbo].[f_RemoverSinalizador](@Bit024in),
			@Bit025 = [dbo].[f_RemoverSinalizador](@Bit025in), @Bit026 = [dbo].[f_RemoverSinalizador](@Bit026in), @Bit027 = [dbo].[f_RemoverSinalizador](@Bit027in), @Bit028 = [dbo].[f_RemoverSinalizador](@Bit028in),
			@Bit029 = [dbo].[f_RemoverSinalizador](@Bit029in), @Bit030 = [dbo].[f_RemoverSinalizador](@Bit030in), @Bit031 = [dbo].[f_RemoverSinalizador](@Bit031in), @Bit032 = [dbo].[f_RemoverSinalizador](@Bit032in),
			@Bit033 = [dbo].[f_RemoverSinalizador](@Bit033in), @Bit034 = [dbo].[f_RemoverSinalizador](@Bit034in), @Bit035 = [dbo].[f_RemoverSinalizador](@Bit035in), @Bit036 = [dbo].[f_RemoverSinalizador](@Bit036in),
			@Bit037 = [dbo].[f_RemoverSinalizador](@Bit037in), @Bit038 = [dbo].[f_RemoverSinalizador](@Bit038in), @Bit039 = [dbo].[f_RemoverSinalizador](@Bit039in), @Bit040 = [dbo].[f_RemoverSinalizador](@Bit040in),
			@Bit041 = [dbo].[f_RemoverSinalizador](@Bit041in), @Bit042 = [dbo].[f_RemoverSinalizador](@Bit042in), @Bit043 = [dbo].[f_RemoverSinalizador](@Bit043in), @Bit044 = [dbo].[f_RemoverSinalizador](@Bit044in),
			@Bit045 = [dbo].[f_RemoverSinalizador](@Bit045in), @Bit046 = [dbo].[f_RemoverSinalizador](@Bit046in), @Bit047 = [dbo].[f_RemoverSinalizador](@Bit047in), @Bit048 = [dbo].[f_RemoverSinalizador](@Bit048in),
			@Bit049 = [dbo].[f_RemoverSinalizador](@Bit049in), @Bit050 = [dbo].[f_RemoverSinalizador](@Bit050in), @Bit051 = [dbo].[f_RemoverSinalizador](@Bit051in), @Bit052 = [dbo].[f_RemoverSinalizador](@Bit052in),
			@Bit053 = [dbo].[f_RemoverSinalizador](@Bit053in), @Bit054 = [dbo].[f_RemoverSinalizador](@Bit054in), @Bit055 = [dbo].[f_RemoverSinalizador](@Bit055in), @Bit056 = [dbo].[f_RemoverSinalizador](@Bit056in),
			@Bit057 = [dbo].[f_RemoverSinalizador](@Bit057in), @Bit058 = [dbo].[f_RemoverSinalizador](@Bit058in), @Bit059 = [dbo].[f_RemoverSinalizador](@Bit059in), @Bit060 = [dbo].[f_RemoverSinalizador](@Bit060in),
			@Bit061 = [dbo].[f_RemoverSinalizador](@Bit061in), @Bit062 = [dbo].[f_RemoverSinalizador](@Bit062in), @Bit063 = [dbo].[f_RemoverSinalizador](@Bit063in), @Bit064 = [dbo].[f_RemoverSinalizador](@Bit064in),
			@Bit065 = [dbo].[f_RemoverSinalizador](@Bit065in), @Bit066 = [dbo].[f_RemoverSinalizador](@Bit066in), @Bit067 = [dbo].[f_RemoverSinalizador](@Bit067in), @Bit068 = [dbo].[f_RemoverSinalizador](@Bit068in),
			@Bit069 = [dbo].[f_RemoverSinalizador](@Bit069in), @Bit070 = [dbo].[f_RemoverSinalizador](@Bit070in), @Bit071 = [dbo].[f_RemoverSinalizador](@Bit071in), @Bit072 = [dbo].[f_RemoverSinalizador](@Bit072in),
			@Bit073 = [dbo].[f_RemoverSinalizador](@Bit073in), @Bit074 = [dbo].[f_RemoverSinalizador](@Bit074in), @Bit075 = [dbo].[f_RemoverSinalizador](@Bit075in), @Bit076 = [dbo].[f_RemoverSinalizador](@Bit076in),
			@Bit077 = [dbo].[f_RemoverSinalizador](@Bit077in), @Bit078 = [dbo].[f_RemoverSinalizador](@Bit078in), @Bit079 = [dbo].[f_RemoverSinalizador](@Bit079in), @Bit080 = [dbo].[f_RemoverSinalizador](@Bit080in),
			@Bit081 = [dbo].[f_RemoverSinalizador](@Bit081in), @Bit082 = [dbo].[f_RemoverSinalizador](@Bit082in), @Bit083 = [dbo].[f_RemoverSinalizador](@Bit083in), @Bit084 = [dbo].[f_RemoverSinalizador](@Bit084in),
			@Bit085 = [dbo].[f_RemoverSinalizador](@Bit085in), @Bit086 = [dbo].[f_RemoverSinalizador](@Bit086in), @Bit087 = [dbo].[f_RemoverSinalizador](@Bit087in), @Bit088 = [dbo].[f_RemoverSinalizador](@Bit088in),
			@Bit089 = [dbo].[f_RemoverSinalizador](@Bit089in), @Bit090 = [dbo].[f_RemoverSinalizador](@Bit090in), @Bit091 = [dbo].[f_RemoverSinalizador](@Bit091in), @Bit092 = [dbo].[f_RemoverSinalizador](@Bit092in),
			@Bit093 = [dbo].[f_RemoverSinalizador](@Bit093in), @Bit094 = [dbo].[f_RemoverSinalizador](@Bit094in), @Bit095 = [dbo].[f_RemoverSinalizador](@Bit095in), @Bit096 = [dbo].[f_RemoverSinalizador](@Bit096in),
			@Bit097 = [dbo].[f_RemoverSinalizador](@Bit097in), @Bit098 = [dbo].[f_RemoverSinalizador](@Bit098in), @Bit099 = [dbo].[f_RemoverSinalizador](@Bit099in), @Bit100 = [dbo].[f_RemoverSinalizador](@Bit100in),
			@Bit101 = [dbo].[f_RemoverSinalizador](@Bit101in), @Bit102 = [dbo].[f_RemoverSinalizador](@Bit102in), @Bit103 = [dbo].[f_RemoverSinalizador](@Bit103in), @Bit104 = [dbo].[f_RemoverSinalizador](@Bit104in),
			@Bit105 = [dbo].[f_RemoverSinalizador](@Bit105in), @Bit106 = [dbo].[f_RemoverSinalizador](@Bit106in), @Bit107 = [dbo].[f_RemoverSinalizador](@Bit107in), @Bit108 = [dbo].[f_RemoverSinalizador](@Bit108in),
			@Bit109 = [dbo].[f_RemoverSinalizador](@Bit109in), @Bit110 = [dbo].[f_RemoverSinalizador](@Bit110in), @Bit111 = [dbo].[f_RemoverSinalizador](@Bit111in), @Bit112 = [dbo].[f_RemoverSinalizador](@Bit112in),
			@Bit113 = [dbo].[f_RemoverSinalizador](@Bit113in), @Bit114 = [dbo].[f_RemoverSinalizador](@Bit114in), @Bit115 = [dbo].[f_RemoverSinalizador](@Bit115in), @Bit116 = [dbo].[f_RemoverSinalizador](@Bit116in),
			@Bit117 = [dbo].[f_RemoverSinalizador](@Bit117in), @Bit118 = [dbo].[f_RemoverSinalizador](@Bit118in), @Bit119 = [dbo].[f_RemoverSinalizador](@Bit119in), @Bit120 = [dbo].[f_RemoverSinalizador](@Bit120in),
			@Bit121 = [dbo].[f_RemoverSinalizador](@Bit121in), @Bit122 = [dbo].[f_RemoverSinalizador](@Bit122in), @Bit123 = [dbo].[f_RemoverSinalizador](@Bit123in), @Bit124 = [dbo].[f_RemoverSinalizador](@Bit124in),
			@Bit125 = [dbo].[f_RemoverSinalizador](@Bit125in), @Bit126 = [dbo].[f_RemoverSinalizador](@Bit126in), @Bit127 = [dbo].[f_RemoverSinalizador](@Bit127in), @Bit128 = [dbo].[f_RemoverSinalizador](@Bit128in)

	DECLARE  @iAuditoriaTransacoes	BIGINT
			,@iControleTransacoes	BIGINT
			,@iControleAbertura		INT
			,@iRede					INT
		    ,@iRetornoFormGen		INT
			,@iErro					INT
			,@iResposta				INT
			,@iCntAppCodigo			INT
			,@bControleDesfazimento	BIT
		    ,@bKeepAlive			BIT
			,@bEnviaPush			BIT
		    ,@cOrigemTransacao		CHAR(2)
			,@cNSUTrnOriginal		CHAR(6)
			,@cNumeroCartao			CHAR(16)
			,@cData					CHAR(10)
			,@cHora					CHAR(20)
			,@cRedeCaptura			VARCHAR(4)
			,@sMsgErro				VARCHAR(MAX)
			,@cBaseOrigem			CHAR(1)
			,@iTrnCodigo			INT
			,@bAutenticaPWD			BIT
			,@cBit127DesfazimentoScope VARCHAR(1000) = @Bit127
			,@bShowMessageApp		BIT

	SELECT	 @bKeepAlive			= 0
			,@iRetornoFormGen		= 0
			,@iResposta				= 0
			,@iControleAbertura		= COALESCE(CONVERT(INT,@Bit070),0)
			,@dDataHoraSolicitacao	= GETDATE()
			,@iErro					= NULL
			,@sMsgErro				= NULL
			,@bEnviaPush			= 0
			,@bAutenticaPWD			= 0

	IF (@BIT123 NOT LIKE 'SCOPE%' and @bit024 not in ('008', '007'))
		SELECT @cOrigemTransacao = Origem FROM TiposTransacoesTiposMensagens WITH(NOLOCK) WHERE Mensagem = @Bit001 AND CodTipoTransacao = CONVERT(INT, @Bit003)

	IF (@cOrigemTransacao = 'SE')
		SET @Bit024 = '044'
	
	IF ((@cOrigemTransacao = 'TB' OR @Bit001 = '9380') AND @Bit001 NOT IN ('0202','0800'))
		SET @Bit024 = '018'
	
	IF (@Bit024 = '021')
		SET @Bit032 = ''

	/*Autenticar somente a Senha para Gateway da Master*/
	IF (@Bit119 = '1')
		SET @bAutenticaPWD = 1

	IF (@bAutenticaPWD = 0)
	BEGIN

		/* KEEP ALIVE NAO SERA INSERIDO NA TABELA DE AUDITORIATRANSACOES E NEM EXECUTAR UMA ABERTURA DE TERMINAL */
		IF (@Bit001 = '0800' AND @iControleAbertura IN (3,4,301) AND @Bit024 <> '044')
		BEGIN	
		
			SELECT	 @Bit001			= '0810'
					,@iRetornoFormGen	= 0

			IF (@Bit070 = '301')
				SET @bKeepAlive = 1

			ELSE
			BEGIN

				EXEC pr_AUT_Atualiza_KeepAlive  @Bit012 OUTPUT, @Bit013 OUTPUT, @Bit024, @Bit032, @Bit041, @Bit042, @Bit046, @Bit047, @Bit062 OUTPUT, @Bit105
			
				SELECT @Bit039 = '00', @Bit046 = '', @Bit047 = ''

				IF (@Bit062 = '') 
					SET @Bit062 = 'APROVADO'
			END

			IF (@iControleAbertura = 3) /* KEEP ALIVE */
				SET @bKeepAlive = 1
		END
		/* FIM: KEEP ALIVE NAO SERA INSERIDO NA TABELA DE AUDITORIATRANSACOES E NEM EXECUTAR UMA ABERTURA DE TERMINAL */
		/* INI: INSERT AUDITORIATRANSACOES */
		ELSE
		BEGIN
			
			INSERT INTO AuditoriaTransacoes
			VALUES(	 @dDataHoraSolicitacao,NULL,NULL
					,@Bit001, @Bit002, @Bit003, @Bit004, @Bit005, @Bit006, @Bit007, @Bit008, @Bit009, @Bit010, @Bit011, @Bit012, @Bit013, @Bit014, @Bit015, @Bit016
					,@Bit017, @Bit018, @Bit019, @Bit020, @Bit021, @Bit022, @Bit023, @Bit024, @Bit025, @Bit026, @Bit027, @Bit028, @Bit029, @Bit030, @Bit031, @Bit032
					,@Bit033, @Bit034, @Bit035, @Bit036, @Bit037, @Bit038, @Bit039, @Bit040, @Bit041, @Bit042, @Bit043, @Bit044, @Bit045, @Bit046, @Bit047, @Bit048
					,@Bit049, @Bit050, @Bit051, @Bit052, @Bit053, @Bit054, @Bit055, @Bit056, @Bit057, @Bit058, @Bit059, @Bit060, @Bit061, @Bit062, @Bit063, @Bit064
					,@Bit065, @Bit066, @Bit067, @Bit068, @Bit069, @Bit070, @Bit071, @Bit072, @Bit073, @Bit074, @Bit075, @Bit076, @Bit077, @Bit078, @Bit079, @Bit080
					,@Bit081, @Bit082, @Bit083, @Bit084, @Bit085, @Bit086, @Bit087, @Bit088, @Bit089, @Bit090, @Bit091, @Bit092, @Bit093, @Bit094, @Bit095, @Bit096
					,@Bit097, @Bit098, @Bit099, @Bit100, @Bit101, @Bit102, @Bit103, @Bit104, @Bit105, @Bit106, @Bit107, @Bit108, @Bit109, @Bit110, @Bit111, @Bit112
					,@Bit113, @Bit114, @Bit115, @Bit116, @Bit117, @Bit118, @Bit119, @Bit120, @Bit121, @Bit122, @Bit123, @Bit124, @Bit125, @Bit126, @Bit127, @Bit128
					,@iErro, @sMsgErro)
					
			SELECT   @iAuditoriaTransacoes = SCOPE_IDENTITY()
					,@iRede = Autorizador.dbo.f_RetornarRede(@Bit024,@Bit032)
					
		END
		/* FIM: INSERT AUDITORIATRANSACOES */

		IF (@bKeepAlive = 0) /* TRANSAÇÕES DE KEEPALIVE NAO DEVERÃO SER PROCESSADAS NAS PROCEDURES INTERNAS */
		BEGIN

			
			SET @bControleDesfazimento = 1
			SET @cData = CONVERT(VARCHAR(10), @dDataHoraSolicitacao,120)
			SET @cHora = CONVERT(VARCHAR(20), @dDataHoraSolicitacao,114)
			SET @cRedeCaptura = CASE WHEN CONVERT(BIGINT, @Bit032) IN (3165, 6142, 58, 13, 14, 15, 31) THEN CONVERT(BIGINT, @Bit032)
									 WHEN CONVERT(BIGINT, @Bit032) NOT IN (6142, 58) AND CONVERT(BIGINT, @Bit024) IN (SELECT Numero FROM Acquirer.dbo.SubRede WITH(NOLOCK)) THEN CONVERT(BIGINT, @Bit024)
									 WHEN @Bit123 LIKE 'SCOPE%' THEN '007'
								END

			SET @iRede = CASE WHEN @cRedeCaptura = '6142' THEN 10 ELSE CONVERT(INT,@cRedeCaptura) END
			SET @cNumeroCartao = CASE WHEN @Bit002 IS NOT NULL AND LEN(@Bit002) = 16 THEN @Bit002
									  WHEN LEN(@Bit035) >= 16 THEN LEFT(@Bit035, 16)	/* Número do cartão - Trilha 2 do cartão */
									  ELSE SUBSTRING(@Bit045, 2, 16)					/* Número do cartão - Trilha 1 do cartão */
								 END

			IF (@cOrigemTransacao = 'TB' OR @Bit001 = '9380')
				SET @iRede = 18

			
			IF (@iRede NOT IN (14,21) AND @Bit001 IN ('0200','0400','0420')) /* POS ITAU E VT */
			BEGIN

				/* INI: CONTROLE TRANSACIONAL */
				IF (@Bit001 IN ('0400','0420'))
				BEGIN

					DECLARE @cProvedor	VARCHAR(50)
					
					IF (@iRede = 7 AND @Bit123 <> '')
						SET @cProvedor = SUBSTRING(@Bit123,1,12)

					IF (LEN(@Bit090) = 26) AND (@iRede NOT IN (13,22,23,24,25,29,31,32,33,34,35)) /* Transações oriundas de POS Cielo e WALK */  
						SET @cNSUTrnOriginal = SUBSTRING(@Bit090, 21, 6)
					ELSE IF (@iRede IN (29,31))
					BEGIN
						SET @cNSUTrnOriginal = SUBSTRING(@Bit090,5,6)
					END
					ELSE
					BEGIN

						IF (@cProvedor LIKE 'SCOPE%')
							SET @cNSUTrnOriginal = SUBSTRING(@Bit090, 5, 6)
						ELSE
							SET @cNSUTrnOriginal = SUBSTRING(@Bit090, 11, 6)

					END

					IF (@Bit001 = '0420' AND 
								NOT EXISTS(SELECT	1
											FROM	aut_ControleTransacoes WITH(NOLOCK)
											WHERE	(TipoMsg			= '0210' OR TipoMsg = '0410')
													AND Terminal		= @Bit041
													AND Estabelecimento	= @Bit042
													AND Valor			= @Bit004
													AND NsuMcaptura		= @cNSUTrnOriginal
													AND Data			= CONVERT (VARCHAR(10), GETDATE(),120)))
						SET @bControleDesfazimento = 0 /* Nao desfazer a transacao */

				END

				IF NOT EXISTS ( SELECT 1
								FROM	aut_ControleTransacoes WITH(NOLOCK)
								WHERE	TipoMsg				= @Bit001
										AND Terminal		= @Bit041
										AND Estabelecimento	= @Bit042
										AND NsuMcaptura		= @Bit011
										AND Valor			= @Bit004
										AND Data			= CONVERT(VARCHAR(10), GETDATE(),120))
				BEGIN

					INSERT INTO	dbo.Aut_ControleTransacoes
							(Data
							,Hora
							,TipoMsg
							,Terminal
							,Estabelecimento
							,Rede
							,NsuMcaptura
							,NsuTrnOriginal
							,Valor
							,HoraTerminal
							,DataTerminal
							,NumeroCartao)
					VALUES( CONVERT(VARCHAR(10), GETDATE(),120)		/* Data entrada transacao */
							,CONVERT(VARCHAR(20), GETDATE(),114)	/* Hora entrada transacao */
							,@Bit001								/* Tipo de mensagem */
							,@Bit041								/* Terminal			*/
							,@Bit042								/* Estabelecimento	*/
							,@iRede									/* RedeCaptura		*/
							,@Bit011								/* NSU MCaptura		*/
							,@cNSUTrnOriginal						/* NSU Transacao original */
							,@Bit004								/* Valor			*/
							,@Bit012								/* Hora				*/
							,@Bit013								/* Data				*/
							,@cNumeroCartao)						/* Cartao			*/

						SELECT @iControleTransacoes = SCOPE_IDENTITY()
				END
			END
			/* FIM: CONTROLE TRANSACIONAL */
			
			IF (@iRede = 14) /* Rede POS SETIS CB */
			BEGIN

				EXEC [Autorizacao].[dbo].[pr_aut_AutorizarTransacoesItau]
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
					@Bit121 OUTPUT, @Bit122 OUTPUT, @Bit123 OUTPUT, @Bit124 OUTPUT, @Bit125 OUTPUT, @Bit126 OUTPUT, @Bit127 OUTPUT, @Bit128 OUTPUT,
					@iResposta OUTPUT, @iErro OUTPUT, @sMsgErro OUTPUT

				IF (@Bit001 IN ('0202', '0402'))
					SET @iRetornoFormGen = 1 /* Resposta SEM retorno para o FormGen, para transacoes ITAU */
				ELSE
					SET @iRetornoFormGen = 0 /* Resposta COM retorno para o FormGen, para transacoes ITAU */

			END
			ELSE IF (@iRede = 20) /* Rede URA */
			BEGIN
			
				--BEGIN TRAN
				--BEGIN TRY

					EXEC [dbo].[pr_aut_AutorizarTransacoesURA]
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
						@Bit121 OUTPUT, @Bit122 OUTPUT, @Bit123 OUTPUT, @Bit124 OUTPUT, @Bit125 OUTPUT, @Bit126 OUTPUT, @Bit127 OUTPUT, @Bit128 OUTPUT,
						@bEnviaPush OUTPUT, @cBaseOrigem OUTPUT, @iTrnCodigo OUTPUT, @iCntAppCodigo OUTPUT, @iResposta OUTPUT


					IF (DATEDIFF(SECOND, @dDataHoraSolicitacao, GETDATE()) >= 30)
					BEGIN

						--ROLLBACK TRAN

						SET @iResposta = 99
						SET @iRetornoFormGen = 1 /* Resposta SEM retorno para o FormGen */
						SELECT @Bit062 = Descricao_Policard, @Bit039 = codigo_policard, @Bit038 = '' FROM aut_CodigosResposta WITH(NOLOCK) WHERE Codigo = @iResposta
					END
					ELSE
					BEGIN
						SET @iRetornoFormGen = 0 /* Resposta COM retorno para o FormGen, para transacoes URA */
						--COMMIT TRAN
					END

				--END TRY
				--BEGIN CATCH
				--	SET @sMsgErro	= ERROR_MESSAGE()
				--	SET @iErro		= @@ERROR

				--	ROLLBACK TRAN

				--	IF @Bit001 = '0200'
				--		SET @Bit001 = '0210'
				--	ELSE IF @Bit001 = '0400'
				--		SET @Bit001 = '0410'
				--	ELSE IF @Bit001 = '0420'
				--		SET @Bit001 = '0430'
				--	ELSE IF @Bit001 = '0800'
				--		SET @Bit001 = '0810'
				--	ELSE IF @Bit001 = '0100'
				--		SET @Bit001 = '0110'

				
				--	SET @iResposta = 66 /* ERRO SISTEMA */

				--	EXEC pr_aut_ConsultarRespostaPolicard @iResposta, @iRede, @Bit039 OUTPUT, @Bit062 OUTPUT

				--	SET @Bit039 = REPLICATE('0', 2 - LEN(@Bit039)) + @Bit039
				--	SET @iRetornoFormGen = 0 /* Resposta COM Erro, COM retorno para o FormGen */

				--END CATCH

			END
			ELSE IF (@iRede = 21) /* Rede POS SETIS VT */
			BEGIN
			
				EXEC [dbo].[pr_aut_AutorizarTransacoesValeTransporte]
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
					@Bit121 OUTPUT, @Bit122 OUTPUT, @Bit123 OUTPUT, @Bit124 OUTPUT, @Bit125 OUTPUT, @Bit126 OUTPUT, @Bit127 OUTPUT, @Bit128 OUTPUT,
					@iRede, @iResposta OUTPUT, @iErro OUTPUT, @sMsgErro OUTPUT
				
				IF (@Bit001 IN ('0202', '0402'))
					SET @iRetornoFormGen = 1 /* Resposta SEM retorno para o FormGen, para transacoes ITAU */
				ELSE
					SET @iRetornoFormGen = 0 /* Resposta COM retorno para o FormGen, para transacoes ITAU */
			END
			ELSE IF (@iRede = 44 AND @Bit003 IN ('000000','006040' , '006000', '966000')) /*Transacoes QRCode CardSE - Software Express*/
			BEGIN

				EXEC [dbo].[pr_AUT_AutorizarTransacoesCardSE]
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
					@Bit121 OUTPUT, @Bit122 OUTPUT, @Bit123 OUTPUT, @Bit124 OUTPUT, @Bit125 OUTPUT, @Bit126 OUTPUT, @Bit127 OUTPUT, @Bit128 OUTPUT,
					--@iRede, @iResposta OUTPUT, @iErro OUTPUT, @sMsgErro OUTPUT
					--@bEnviaPush OUTPUT, @cBaseOrigem OUTPUT, @iTrnCodigo OUTPUT, @iCntAppCodigo OUTPUT, @iResposta OUTPUT
					@cBaseOrigem OUTPUT, @iTrnCodigo OUTPUT, @iResposta OUTPUT
				
				--IF (@Bit001 IN ('0202', '0402'))
				--	SET @iRetornoFormGen = 1 /* Resposta SEM retorno para o FormGen, para transacoes ITAU */
				--ELSE
					SET @iRetornoFormGen = 0 /* Resposta COM retorno para o FormGen, para transacoes ITAU */

				IF (@Bit001 NOT IN ('0212','0430','0412','0810','0410') AND (@Bit039 = '' OR @Bit062 = ''))
				BEGIN

					EXEC pr_aut_ConsultarRespostaPolicard @iResposta, @iRede, @Bit039 OUTPUT, @Bit062 OUTPUT				

					IF (@iResposta <> 0)
					BEGIN 

						DECLARE @iLenBit062 int
						,@iID501 varchar(1000)
						,@iID502 varchar(1000)


						SET @iLenBit062 = LEN (@Bit062)

						SET @iID501 = '501' + REPLICATE('0', 3 -  LEN(@iLenBit062)) + CONVERT(VARCHAR(3), @iLenBit062) +  @Bit062
						SET @iID502 = '502' + REPLICATE('0', 3 -  LEN(@iLenBit062)) + CONVERT(VARCHAR(3), @iLenBit062) +  @Bit062
						SET @Bit062 = @iID501 + @iID502
					END

				END
		
			END
			ELSE
			BEGIN

				BEGIN TRAN
				BEGIN TRY

					IF (@Bit001 = '0610' AND @Bit061 <> '') SET @cOrigemTransacao = 'TB'

					IF (@cOrigemTransacao = 'TB' OR @Bit001 = '9380')
					BEGIN

						IF (@Bit001 NOT IN ('0800','0810'))
						BEGIN
	
							EXEC [dbo].[pr_AUT_AutorizarTransacoesBanco24Horas]
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
								@Bit121 OUTPUT, @Bit122 OUTPUT, @Bit123 OUTPUT, @Bit124 OUTPUT, @Bit125 OUTPUT, @Bit126 OUTPUT, @Bit127 OUTPUT, @Bit128 OUTPUT,
								@iResposta OUTPUT
							
							IF (@Bit001 NOT IN ('0202', '0402', '0610'))
							BEGIN

								SET @iRetornoFormGen = 0

								IF (DATEDIFF(SECOND, @dDataHoraSolicitacao, GETDATE()) >= 30)
								BEGIN
									ROLLBACK TRAN
									SET @iResposta = 403
									SET @iRetornoFormGen = 1
								END
								ELSE IF (@iResposta = 384)
									ROLLBACK TRAN
								ELSE
									COMMIT
							END
							ELSE
							BEGIN
								COMMIT
								SET @iRetornoFormGen = 1 /* Resposta SEM retorno para o FormGen, '0202,0402,0610' */
							END
						END
					END
					ELSE
					BEGIN

						IF (@bControleDesfazimento = 1)
						BEGIN
							
							EXEC [pr_aut_AutorizarTransacoes]
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
								@Bit121 OUTPUT, @Bit122 OUTPUT, @Bit123 OUTPUT, @Bit124 OUTPUT, @Bit125 OUTPUT, @Bit126 OUTPUT, @Bit127 OUTPUT, @Bit128 OUTPUT,
								@bEnviaPush OUTPUT, @cBaseOrigem OUTPUT, @iTrnCodigo OUTPUT, @iCntAppCodigo OUTPUT, @iResposta OUTPUT, @sMsgErro OUTPUT,
								@iCodigoEstabelecimento	OUTPUT, @cNumeroCartao OUTPUT, @nValor_Transacao OUTPUT;


							IF (@Bit001 NOT IN ('0202', '0402', '0610'))
							BEGIN
								
								DECLARE @iTimeOutTrn INT

								IF (@Bit001 = '599002') /*Recarga Celular 60s*/
									SET @iTimeOutTrn = 60
								ELSE
									SET @iTimeOutTrn = 30

								/* INÍCIO: Verificação do tempo de transação dentro do Autorizador Policard para gerar TIMEOUT e não descontar do usuário */
								IF (DATEDIFF(SECOND, @dDataHoraSolicitacao, GETDATE()) >= @iTimeOutTrn AND @Bit001 <> '0430')
								BEGIN

									ROLLBACK TRAN

									SET @iResposta = 108
									SET @iRetornoFormGen = 1 /* Resposta SEM retorno para o FormGen */
									SELECT @Bit062 = Descricao_Policard, @Bit039 = codigo_policard, @Bit038 = '' FROM aut_CodigosResposta WITH(NOLOCK) WHERE Codigo = @iResposta
								END
								/* FIM: Verificação do tempo de transação dentro do Autorizador Policard para gerar TIMEOUT e não descontar do usuário */
								ELSE
								BEGIN
									IF (@Bit001 IN ('0210','0410') AND 
											EXISTS ( SELECT	1
													FROM	aut_ControleTransacoes WITH(NOLOCK)
													WHERE	TipoMsg				= '0420'
															AND Terminal		= @Bit041
															AND Estabelecimento	= @Bit042
															AND NsuTrnOriginal  = @Bit011
															AND Valor			= @Bit004
															AND Data			= CONVERT (VARCHAR(10), GETDATE(),120)))
									BEGIN
										ROLLBACK TRAN

										SET @iRetornoFormGen = 0 /* Resposta COM retorno para o FormGen */
										SET @iResposta = 155

										IF (@iRede = 10)
											EXEC pr_aut_ConsultaRespostaCielo @iResposta, @Bit039 OUTPUT
										ELSE IF (@iRede = 29) 
											EXEC pr_Consulta_RespostaRedecard @iResposta, @Bit039 OUTPUT
										ELSE
											EXEC pr_aut_ConsultarRespostaPolicard @iResposta, @iRede, @Bit039 OUTPUT, @Bit062 OUTPUT

										SET @Bit039 = REPLICATE('0', 2 - LEN(@Bit039)) + @Bit039
									END

									IF (@Bit001 = '0430' AND EXISTS ( SELECT 1
											FROM	aut_ControleTransacoes WITH(NOLOCK)
											WHERE	(TipoMsg			= '0210' OR TipoMsg = '0410')
													AND Terminal		= @Bit041
													AND Estabelecimento	= @Bit042
													AND Valor			= @Bit004
													AND NsuMcaptura		= @cNSUTrnOriginal
													AND CodigoResposta  IN (108,155) /*Transação com RollBack nas condições acima*/
													AND Data			= CONVERT (VARCHAR(10), GETDATE(),120)))

									BEGIN
										ROLLBACK TRAN
								
										SET @iRetornoFormGen = 0 /* Resposta COM retorno para o FormGen */
										SET @iResposta = 270
										SET @Bit039 = '00' /*Transacao de desfazimento com resposta '00' para nao haver problemas com desfazimentos futuros*/

									END

									IF @iResposta NOT IN (108,155,270) /* Transacao Cancelada TimeOut ou Rollback Controle Transacoes */
									BEGIN
										COMMIT
										SET @iRetornoFormGen = 0 /* Resposta COM retorno para o FormGen */
									END
								END
							END
							ELSE
							BEGIN
								COMMIT
								SET @iRetornoFormGen = 1 /* Resposta SEM retorno para o FormGen, '0202,0402,0610' */
							END
							IF @Bit001 = '0430' AND @Bit123 like 'SCOPE%' AND ISNULL(@cBit127DesfazimentoScope, '') = ''
							BEGIN
								SET @Bit127 = ''
							END
							
						END
						ELSE
						BEGIN

							IF (@Bit001 = '0420')
								SET @Bit001 = '0430'

							SET @iResposta = 271
							SET @Bit039 = REPLICATE('0', 2 - LEN(@Bit039)) + @Bit039
							SET @iRetornoFormGen = 0 /* Resposta COM Erro, COM retorno para o FormGen */

							/*Zerando dados do desfazimento de transacoes Stone nao encontradas*/
							IF (@iRede = 31)
							BEGIN
							
								SELECT @Bit002 = ''
									  ,@Bit012 = ''
									  ,@Bit013 = ''
									  ,@Bit018 = ''
									  ,@Bit022 = ''
									  ,@Bit032 = ''
									  ,@Bit035 = ''
									  ,@Bit049 = ''
									  ,@Bit090 = ''

							END

							COMMIT
							
						END 

						IF (@iRede NOT IN (10,58))
						BEGIN
						
							IF (@iRede = 29 AND @Bit001 = '0430')
								SET @Bit127 = '' 
							ELSE IF @Bit123 LIKE 'SCOPE%' 
							BEGIN
								IF @Bit001 = 0810
								BEGIN
									SET @Bit052 = '' 
									SET @Bit127 = '' 

									IF @Bit070 = '005'
									BEGIN
										SET @Bit062 = ''
									END
								END
								ELSE IF @Bit001 = '0410'
								BEGIN
									SET @Bit015 = ''
									SET @Bit038 = ''
								END
							END
							ELSE IF (@Bit127 = '' OR CONVERT(INT, @Bit127) = 0 OR @Bit127 IS NULL)
								SET @Bit127 = dbo.f_ZerosEsquerda(@iAuditoriaTransacoes,9)
							ELSE
							BEGIN
								IF (LEN(@Bit127) < 9)
									SET @Bit127 = dbo.f_ZerosEsquerda(@Bit127,9)
							END

						END
					END
				END TRY
				BEGIN CATCH
					SET @sMsgErro	= ERROR_MESSAGE()
					SET @iErro		= @@ERROR

					ROLLBACK TRAN

					IF @Bit001 = '0200'
						SET @Bit001 = '0210'
					ELSE IF @Bit001 = '0400'
						SET @Bit001 = '0410'
					ELSE IF @Bit001 = '0420'
						SET @Bit001 = '0430'
					ELSE IF @Bit001 = '0800'
						SET @Bit001 = '0810'
					ELSE IF @Bit001 = '0100'
						SET @Bit001 = '0110'

					IF (@iRede = 18)
						SET @iResposta = 402 /* ERRO NO PROCESSAMENTO TECBAN*/
					ELSE
					SET @iResposta = 66 /* ERRO SISTEMA */

					IF (@iRede = 10)
						EXEC pr_aut_ConsultaRespostaCielo @iResposta, @Bit039 OUTPUT
					ELSE IF (@iRede = 29) 
						EXEC pr_Consulta_RespostaRedecard @iResposta, @Bit039 OUTPUT
					ELSE
						EXEC pr_aut_ConsultarRespostaPolicard @iResposta, @iRede, @Bit039 OUTPUT, @Bit062 OUTPUT

					SET @Bit039 = REPLICATE('0', 2 - LEN(@Bit039)) + @Bit039
					SET @iRetornoFormGen = 0 /* Resposta COM Erro, COM retorno para o FormGen */

				END CATCH
			END
			--END
		END

		IF (@iRede NOT IN (14,21) AND @Bit001 IN ('0210','0410','0430')) /* CB ITAU NAO ENTRA NO CONTROLE DE TRANSACOES */
		BEGIN

			IF NOT EXISTS ( SELECT	1
							FROM aut_ControleTransacoes WITH(NOLOCK)
							WHERE TipoMsg		= @Bit001
							AND Terminal		= @Bit041
							AND Estabelecimento	= @Bit042
							AND NsuMcaptura		= @Bit011
							AND Valor			= @Bit004
							AND Data			= CONVERT(VARCHAR(10), GETDATE(),120))
		
			BEGIN

				INSERT INTO	dbo.Aut_ControleTransacoes
						(CodigoReferencia
						,Data
						,Hora
						,TipoMsg
						,Terminal
						,Estabelecimento
						,Rede
						,NsuMcaptura
						,NsuTrnOriginal
						,Valor
						,HoraTerminal
						,DataTerminal
						,NumeroCartao
						,Resposta
						,CodigoResposta)
				VALUES(	@iControleTransacoes
						,CONVERT(VARCHAR(10), GETDATE(),120)	-- Data
						,CONVERT(VARCHAR(20), GETDATE(),114)	-- Hora
						,@Bit001								-- Tipo de mensagem
						,@Bit041								-- Terminal
						,@Bit042								-- Estabelecimento
						,@iRede									-- Rede Captura
						,@Bit011								-- NSU MCaptura
						,@cNSUTrnOriginal						-- NSU Transacao Original
						,@Bit004								-- Valor
						,@Bit012								-- Hora
						,@Bit013								-- Data
						,@cNumeroCartao							-- Cartao
						,@Bit039
						,@iResposta)
			END
		END

		IF (@iRede = 18 AND @iResposta IN (384,403))
		BEGIN
		
			IF @Bit110 <> ''
			SET @sMsgErro = @Bit110
			SET @iErro			= 0
			SET @Bit110			= ''

			EXEC pr_aut_ConsultarRespostaPolicard @iResposta, @iRede, @Bit039 OUTPUT, @Bit062 OUTPUT
			IF (@Bit127 = '' OR CONVERT(INT, @Bit127) = 0 OR @Bit127 IS NULL)
				SET @Bit127 = dbo.f_ZerosEsquerda(@iAuditoriaTransacoes,9)
		END

		SET @dDataHoraResposta = GETDATE()

		IF (@Bit001 NOT IN ('0202', '0402', '0610') AND CONVERT(INT, @Bit070) NOT IN (3,301))
		BEGIN
			
			INSERT INTO AuditoriaTransacoes
			VALUES(	@dDataHoraResposta, @iResposta, @iAuditoriaTransacoes
					,@Bit001, @Bit002, @Bit003, @Bit004, @Bit005, @Bit006, @Bit007, @Bit008,@Bit009, @Bit010, @Bit011, @Bit012, @Bit013, @Bit014, @Bit015, @Bit016
					,@Bit017, @Bit018, @Bit019, @Bit020, @Bit021, @Bit022, @Bit023, @Bit024,@Bit025, @Bit026, @Bit027, @Bit028, @Bit029, @Bit030, @Bit031, @Bit032
					,@Bit033, @Bit034, @Bit035, @Bit036, @Bit037, @Bit038, @Bit039, @Bit040,@Bit041, @Bit042, @Bit043, @Bit044, @Bit045, @Bit046, @Bit047, @Bit048
					,@Bit049, @Bit050, @Bit051, @Bit052, @Bit053, @Bit054, @Bit055, @Bit056,@Bit057, @Bit058, @Bit059, @Bit060, @Bit061, @Bit062, @Bit063, @Bit064
					,@Bit065, @Bit066, @Bit067, @Bit068, @Bit069, @Bit070, @Bit071, @Bit072,@Bit073, @Bit074, @Bit075, @Bit076, @Bit077, @Bit078, @Bit079, @Bit080
					,@Bit081, @Bit082, @Bit083, @Bit084, @Bit085, @Bit086, @Bit087, @Bit088,@Bit089, @Bit090, @Bit091, @Bit092, @Bit093, @Bit094, @Bit095, @Bit096
					,@Bit097, @Bit098, @Bit099, @Bit100, @Bit101, @Bit102, @Bit103, @Bit104,@Bit105, @Bit106, @Bit107, @Bit108, @Bit109, @Bit110, @Bit111, @Bit112
					,@Bit113, @Bit114, @Bit115, @Bit116, @Bit117, @Bit118, @Bit119, @Bit120,@Bit121, @Bit122, @Bit123, @Bit124, @Bit125, @Bit126, @Bit127, @Bit128
					,@iErro, @sMsgErro);


			SELECT @bShowMessageApp = acr.MostrarMsgApp 
			FROM Autorizador.dbo.aut_CodigosResposta AS acr WITH (NOLOCK)
			WHERE acr.codigo = @iResposta;

		
			IF (@bShowMessageApp = 1 AND @bEnviaPush = 1 AND @Bit001 IN ('0210', '0410'))
				EXEC pr_aut_EnviarPushApp @cBaseOrigem
					,@iTrnCodigo
					,@iCntAppCodigo
					,@iResposta
					,@iCodigoEstabelecimento
					,@cNumeroCartao
					,@iAuditoriaTransacoes;
		END
	END
	ELSE IF (@bAutenticaPWD = 1)
	BEGIN

		SET @dDataHoraSolicitacao = GETDATE()
			
		INSERT INTO [AuditoriaGatewayMasters]
		VALUES(	 @dDataHoraSolicitacao,NULL,NULL
				,@Bit001, @Bit002, @Bit003, @Bit004, @Bit005, @Bit006, @Bit007, @Bit008, @Bit009, @Bit010, @Bit011, @Bit012, @Bit013, @Bit014, @Bit015, @Bit016
				,@Bit017, @Bit018, @Bit019, @Bit020, @Bit021, @Bit022, @Bit023, @Bit024, @Bit025, @Bit026, @Bit027, @Bit028, @Bit029, @Bit030, @Bit031, @Bit032
				,@Bit033, @Bit034, @Bit035, @Bit036, @Bit037, @Bit038, @Bit039, @Bit040, @Bit041, @Bit042, @Bit043, @Bit044, @Bit045, @Bit046, @Bit047, @Bit048
				,@Bit049, @Bit050, @Bit051, @Bit052, @Bit053, @Bit054, @Bit055, @Bit056, @Bit057, @Bit058, @Bit059, @Bit060, @Bit061, @Bit062, @Bit063, @Bit064
				,@Bit065, @Bit066, @Bit067, @Bit068, @Bit069, @Bit070, @Bit071, @Bit072, @Bit073, @Bit074, @Bit075, @Bit076, @Bit077, @Bit078, @Bit079, @Bit080
				,@Bit081, @Bit082, @Bit083, @Bit084, @Bit085, @Bit086, @Bit087, @Bit088, @Bit089, @Bit090, @Bit091, @Bit092, @Bit093, @Bit094, @Bit095, @Bit096
				,@Bit097, @Bit098, @Bit099, @Bit100, @Bit101, @Bit102, @Bit103, @Bit104, @Bit105, @Bit106, @Bit107, @Bit108, @Bit109, @Bit110, @Bit111, @Bit112
				,@Bit113, @Bit114, @Bit115, @Bit116, @Bit117, @Bit118, @Bit119, @Bit120, @Bit121, @Bit122, @Bit123, @Bit124, @Bit125, @Bit126, @Bit127, @Bit128
				,@iErro, @sMsgErro)
					
		SELECT   @iAuditoriaTransacoes = SCOPE_IDENTITY()
		
		EXEC [dbo].[pr_aut_TranslateSenhaCartao]
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
				@Bit121 OUTPUT, @Bit122 OUTPUT, @Bit123 OUTPUT, @Bit124 OUTPUT, @Bit125 OUTPUT, @Bit126 OUTPUT, @Bit127 OUTPUT, @Bit128 OUTPUT,
				@iResposta OUTPUT

		SET @dDataHoraResposta = GETDATE()
		
		INSERT INTO [AuditoriaGatewayMasters]
		VALUES(	@dDataHoraResposta, @iResposta, @iAuditoriaTransacoes
				,@Bit001, @Bit002, @Bit003, @Bit004, @Bit005, @Bit006, @Bit007, @Bit008,@Bit009, @Bit010, @Bit011, @Bit012, @Bit013, @Bit014, @Bit015, @Bit016
				,@Bit017, @Bit018, @Bit019, @Bit020, @Bit021, @Bit022, @Bit023, @Bit024,@Bit025, @Bit026, @Bit027, @Bit028, @Bit029, @Bit030, @Bit031, @Bit032
				,@Bit033, @Bit034, @Bit035, @Bit036, @Bit037, @Bit038, @Bit039, @Bit040,@Bit041, @Bit042, @Bit043, @Bit044, @Bit045, @Bit046, @Bit047, @Bit048
				,@Bit049, @Bit050, @Bit051, @Bit052, @Bit053, @Bit054, @Bit055, @Bit056,@Bit057, @Bit058, @Bit059, @Bit060, @Bit061, @Bit062, @Bit063, @Bit064
				,@Bit065, @Bit066, @Bit067, @Bit068, @Bit069, @Bit070, @Bit071, @Bit072,@Bit073, @Bit074, @Bit075, @Bit076, @Bit077, @Bit078, @Bit079, @Bit080
				,@Bit081, @Bit082, @Bit083, @Bit084, @Bit085, @Bit086, @Bit087, @Bit088,@Bit089, @Bit090, @Bit091, @Bit092, @Bit093, @Bit094, @Bit095, @Bit096
				,@Bit097, @Bit098, @Bit099, @Bit100, @Bit101, @Bit102, @Bit103, @Bit104,@Bit105, @Bit106, @Bit107, @Bit108, @Bit109, @Bit110, @Bit111, @Bit112
				,@Bit113, @Bit114, @Bit115, @Bit116, @Bit117, @Bit118, @Bit119, @Bit120,@Bit121, @Bit122, @Bit123, @Bit124, @Bit125, @Bit126, @Bit127, @Bit128
				,@iErro, @sMsgErro)

		SET @iRetornoFormGen = 0

	END

	IF (@iRetornoFormGen = 0)
	BEGIN
		
		SELECT	@Bit001in = [dbo].[f_Inclui_Sinalizador](@Bit001),  @Bit002in = [dbo].[f_Inclui_Sinalizador](@Bit002), @Bit003in = [dbo].[f_Inclui_Sinalizador](@Bit003), @Bit004in = [dbo].[f_Inclui_Sinalizador](@Bit004),
				@Bit005in = [dbo].[f_Inclui_Sinalizador](@Bit005),  @Bit006in = [dbo].[f_Inclui_Sinalizador](@Bit006), @Bit007in = [dbo].[f_Inclui_Sinalizador](@Bit007), @Bit008in = [dbo].[f_Inclui_Sinalizador](@Bit008),
				@Bit009in = [dbo].[f_Inclui_Sinalizador](@Bit009),  @Bit010in = [dbo].[f_Inclui_Sinalizador](@Bit010), @Bit011in = [dbo].[f_Inclui_Sinalizador](@Bit011), @Bit012in = [dbo].[f_Inclui_Sinalizador](@Bit012),
				@Bit013in = [dbo].[f_Inclui_Sinalizador](@Bit013),	@Bit014in = [dbo].[f_Inclui_Sinalizador](@Bit014), @Bit015in = [dbo].[f_Inclui_Sinalizador](@Bit015), @Bit016in = [dbo].[f_Inclui_Sinalizador](@Bit016),
				@Bit017in = [dbo].[f_Inclui_Sinalizador](@Bit017),	@Bit018in = [dbo].[f_Inclui_Sinalizador](@Bit018), @Bit019in = [dbo].[f_Inclui_Sinalizador](@Bit019), @Bit020in = [dbo].[f_Inclui_Sinalizador](@Bit020),
				@Bit021in = [dbo].[f_Inclui_Sinalizador](@Bit021),	@Bit022in = [dbo].[f_Inclui_Sinalizador](@Bit022), @Bit023in = [dbo].[f_Inclui_Sinalizador](@Bit023), @Bit024in = [dbo].[f_Inclui_Sinalizador](@Bit024),
				@Bit025in = [dbo].[f_Inclui_Sinalizador](@Bit025),	@Bit026in = [dbo].[f_Inclui_Sinalizador](@Bit026), @Bit027in = [dbo].[f_Inclui_Sinalizador](@Bit027), @Bit028in = [dbo].[f_Inclui_Sinalizador](@Bit028),
				@Bit029in = [dbo].[f_Inclui_Sinalizador](@Bit029),	@Bit030in = [dbo].[f_Inclui_Sinalizador](@Bit030), @Bit031in = [dbo].[f_Inclui_Sinalizador](@Bit031), @Bit032in = [dbo].[f_Inclui_Sinalizador](@Bit032),
				@Bit033in = [dbo].[f_Inclui_Sinalizador](@Bit033),	@Bit034in = [dbo].[f_Inclui_Sinalizador](@Bit034), @Bit035in = [dbo].[f_Inclui_Sinalizador](@Bit035), @Bit036in = [dbo].[f_Inclui_Sinalizador](@Bit036),
				@Bit037in = [dbo].[f_Inclui_Sinalizador](@Bit037),	@Bit038in = [dbo].[f_Inclui_Sinalizador](@Bit038), @Bit039in = [dbo].[f_Inclui_Sinalizador](@Bit039), @Bit040in = [dbo].[f_Inclui_Sinalizador](@Bit040),
				@Bit041in = [dbo].[f_Inclui_Sinalizador](@Bit041),	@Bit042in = [dbo].[f_Inclui_Sinalizador](@Bit042), @Bit043in = [dbo].[f_Inclui_Sinalizador](@Bit043), @Bit044in = [dbo].[f_Inclui_Sinalizador](@Bit044),
				@Bit045in = [dbo].[f_Inclui_Sinalizador](@Bit045),  @Bit046in = [dbo].[f_Inclui_Sinalizador](@Bit046), @Bit047in = [dbo].[f_Inclui_Sinalizador](@Bit047), @Bit048in = [dbo].[f_Inclui_Sinalizador](@Bit048),
				@Bit049in = [dbo].[f_Inclui_Sinalizador](@Bit049),	@Bit050in = [dbo].[f_Inclui_Sinalizador](@Bit050), @Bit051in = [dbo].[f_Inclui_Sinalizador](@Bit051), @Bit052in = [dbo].[f_Inclui_Sinalizador](@Bit052),
				@Bit053in = [dbo].[f_Inclui_Sinalizador](@Bit053),	@Bit054in = [dbo].[f_Inclui_Sinalizador](@Bit054), @Bit055in = [dbo].[f_Inclui_Sinalizador](@Bit055), @Bit056in = [dbo].[f_Inclui_Sinalizador](@Bit056),
				@Bit057in = [dbo].[f_Inclui_Sinalizador](@Bit057),	@Bit058in = [dbo].[f_Inclui_Sinalizador](@Bit058), @Bit059in = [dbo].[f_Inclui_Sinalizador](@Bit059), @Bit060in = [dbo].[f_Inclui_Sinalizador](@Bit060),
				@Bit061in = [dbo].[f_Inclui_Sinalizador](@Bit061),	@Bit062in = [dbo].[f_Inclui_Sinalizador](@Bit062), @Bit063in = [dbo].[f_Inclui_Sinalizador](@Bit063), @Bit064in = [dbo].[f_Inclui_Sinalizador](@Bit064),
				@Bit065in = [dbo].[f_Inclui_Sinalizador](@Bit065),	@Bit066in = [dbo].[f_Inclui_Sinalizador](@Bit066), @Bit067in = [dbo].[f_Inclui_Sinalizador](@Bit067), @Bit068in = [dbo].[f_Inclui_Sinalizador](@Bit068),
				@Bit069in = [dbo].[f_Inclui_Sinalizador](@Bit069),	@Bit070in = [dbo].[f_Inclui_Sinalizador](@Bit070), @Bit071in = [dbo].[f_Inclui_Sinalizador](@Bit071), @Bit072in = [dbo].[f_Inclui_Sinalizador](@Bit072),
				@Bit073in = [dbo].[f_Inclui_Sinalizador](@Bit073),	@Bit074in = [dbo].[f_Inclui_Sinalizador](@Bit074), @Bit075in = [dbo].[f_Inclui_Sinalizador](@Bit075), @Bit076in = [dbo].[f_Inclui_Sinalizador](@Bit076),
				@Bit077in = [dbo].[f_Inclui_Sinalizador](@Bit077),	@Bit078in = [dbo].[f_Inclui_Sinalizador](@Bit078), @Bit079in = [dbo].[f_Inclui_Sinalizador](@Bit079), @Bit080in = [dbo].[f_Inclui_Sinalizador](@Bit080),
				@Bit081in = [dbo].[f_Inclui_Sinalizador](@Bit081),	@Bit082in = [dbo].[f_Inclui_Sinalizador](@Bit082), @Bit083in = [dbo].[f_Inclui_Sinalizador](@Bit083), @Bit084in = [dbo].[f_Inclui_Sinalizador](@Bit084),
				@Bit085in = [dbo].[f_Inclui_Sinalizador](@Bit085),	@Bit086in = [dbo].[f_Inclui_Sinalizador](@Bit086), @Bit087in = [dbo].[f_Inclui_Sinalizador](@Bit087), @Bit088in = [dbo].[f_Inclui_Sinalizador](@Bit088),
				@Bit089in = [dbo].[f_Inclui_Sinalizador](@Bit089),  @Bit090in = [dbo].[f_Inclui_Sinalizador](@Bit090), @Bit091in = [dbo].[f_Inclui_Sinalizador](@Bit091), @Bit092in = [dbo].[f_Inclui_Sinalizador](@Bit092),
				@Bit093in = [dbo].[f_Inclui_Sinalizador](@Bit093),	@Bit094in = [dbo].[f_Inclui_Sinalizador](@Bit094), @Bit095in = [dbo].[f_Inclui_Sinalizador](@Bit095), @Bit096in = [dbo].[f_Inclui_Sinalizador](@Bit096),
				@Bit097in = [dbo].[f_Inclui_Sinalizador](@Bit097),	@Bit098in = [dbo].[f_Inclui_Sinalizador](@Bit098), @Bit099in = [dbo].[f_Inclui_Sinalizador](@Bit099), @Bit100in = [dbo].[f_Inclui_Sinalizador](@Bit100),
				@Bit101in = [dbo].[f_Inclui_Sinalizador](@Bit101),	@Bit102in = [dbo].[f_Inclui_Sinalizador](@Bit102), @Bit103in = [dbo].[f_Inclui_Sinalizador](@Bit103), @Bit104in = [dbo].[f_Inclui_Sinalizador](@Bit104),
				@Bit105in = [dbo].[f_Inclui_Sinalizador](@Bit105),	@Bit106in = [dbo].[f_Inclui_Sinalizador](@Bit106), @Bit107in = [dbo].[f_Inclui_Sinalizador](@Bit107), @Bit108in = [dbo].[f_Inclui_Sinalizador](@Bit108),
				@Bit109in = [dbo].[f_Inclui_Sinalizador](@Bit109),	@Bit110in = [dbo].[f_Inclui_Sinalizador](@Bit110), @Bit111in = [dbo].[f_Inclui_Sinalizador](@Bit111), @Bit112in = [dbo].[f_Inclui_Sinalizador](@Bit112),
				@Bit113in = [dbo].[f_Inclui_Sinalizador](@Bit113),	@Bit114in = [dbo].[f_Inclui_Sinalizador](@Bit114), @Bit115in = [dbo].[f_Inclui_Sinalizador](@Bit115), @Bit116in = [dbo].[f_Inclui_Sinalizador](@Bit116),
				@Bit117in = [dbo].[f_Inclui_Sinalizador](@Bit117),	@Bit118in = [dbo].[f_Inclui_Sinalizador](@Bit118), @Bit119in = [dbo].[f_Inclui_Sinalizador](@Bit119), @Bit120in = [dbo].[f_Inclui_Sinalizador](@Bit120),
				@Bit121in = [dbo].[f_Inclui_Sinalizador](@Bit121),	@Bit122in = [dbo].[f_Inclui_Sinalizador](@Bit122), @Bit123in = [dbo].[f_Inclui_Sinalizador](@Bit123), @Bit124in = [dbo].[f_Inclui_Sinalizador](@Bit124),
				@Bit125in = [dbo].[f_Inclui_Sinalizador](@Bit125),	@Bit126in = [dbo].[f_Inclui_Sinalizador](@Bit126), @Bit127in = [dbo].[f_Inclui_Sinalizador](@Bit127), @Bit128in = [dbo].[f_Inclui_Sinalizador](@Bit128)
	END
	
	RETURN @iRetornoFormGen

END


