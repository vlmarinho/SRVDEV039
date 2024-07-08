

/*
--------------------------------------------------------------------------
Nome Sistema: Autorização
Objeto: [dbo].[pr_aut_Confirmar_Transacao_Estorno]
Propósito: Procedure responsável por Sondar Estabelecimento
Autor: Cristiano Silva Barbosa - Tecnologia Policard
--------------------------------------------------------------------------
Data criação: 19/02/2017
Mudança: 2601
--------------------------------------------------------------------------

*/

--drop PROCEDURE [pr_aut_VerificaSonda]

CREATE PROCEDURE [pr_aut_VerificaSonda](
	@Bit001 VARCHAR(1000) OUTPUT, @Bit002 VARCHAR(1000) OUTPUT, @Bit003 VARCHAR(1000) OUTPUT, @Bit004 VARCHAR(1000) OUTPUT,
	@Bit005 VARCHAR(1000) OUTPUT, @Bit006 VARCHAR(1000) OUTPUT, @Bit007 VARCHAR(1000) OUTPUT, @Bit008 VARCHAR(1000) OUTPUT,
	@Bit009 VARCHAR(1000) OUTPUT, @Bit010 VARCHAR(1000) OUTPUT, @Bit011 VARCHAR(1000) OUTPUT, @Bit012 VARCHAR(1000) OUTPUT,
	@Bit013 VARCHAR(1000) OUTPUT, @Bit014 VARCHAR(1000) OUTPUT, @Bit015 VARCHAR(1000) OUTPUT, @Bit016 VARCHAR(1000) OUTPUT,
	@Bit017 VARCHAR(1000) OUTPUT, @Bit018 VARCHAR(1000) OUTPUT, @Bit019 VARCHAR(1000) OUTPUT, @Bit020 VARCHAR(1000) OUTPUT,
	@Bit021 VARCHAR(1000) OUTPUT, @Bit022 VARCHAR(1000) OUTPUT, @Bit023 VARCHAR(1000) OUTPUT, @Bit024 VARCHAR(1000) OUTPUT,
	@Bit025 VARCHAR(1000) OUTPUT, @Bit026 VARCHAR(1000) OUTPUT, @Bit027 VARCHAR(1000) OUTPUT, @Bit028 VARCHAR(1000) OUTPUT,
	@Bit029 VARCHAR(1000) OUTPUT, @Bit030 VARCHAR(1000) OUTPUT, @Bit031 VARCHAR(1000) OUTPUT, @Bit032 VARCHAR(1000) OUTPUT,
	@Bit033 VARCHAR(1000) OUTPUT, @Bit034 VARCHAR(1000) OUTPUT, @Bit035 VARCHAR(1000) OUTPUT, @Bit036 VARCHAR(1000) OUTPUT,
	@Bit037 VARCHAR(1000) OUTPUT, @Bit038 VARCHAR(1000) OUTPUT, @Bit039 VARCHAR(1000) OUTPUT, @Bit040 VARCHAR(1000) OUTPUT,
	@Bit041 VARCHAR(1000) OUTPUT, @Bit042 VARCHAR(1000) OUTPUT, @Bit043 VARCHAR(1000) OUTPUT, @Bit044 VARCHAR(1000) OUTPUT,
	@Bit045 VARCHAR(1000) OUTPUT, @Bit046 VARCHAR(1000) OUTPUT, @Bit047 VARCHAR(1000) OUTPUT, @Bit048 VARCHAR(1000) OUTPUT,
	@Bit049 VARCHAR(1000) OUTPUT, @Bit050 VARCHAR(1000) OUTPUT, @Bit051 VARCHAR(1000) OUTPUT, @Bit052 VARCHAR(1000) OUTPUT,
	@Bit053 VARCHAR(1000) OUTPUT, @Bit054 VARCHAR(1000) OUTPUT, @Bit055 VARCHAR(1000) OUTPUT, @Bit056 VARCHAR(1000) OUTPUT,
	@Bit057 VARCHAR(1000) OUTPUT, @Bit058 VARCHAR(1000) OUTPUT, @Bit059 VARCHAR(1000) OUTPUT, @Bit060 VARCHAR(1000) OUTPUT,
	@Bit061 VARCHAR(1000) OUTPUT, @Bit062 VARCHAR(1000) OUTPUT, @Bit063 VARCHAR(1000) OUTPUT, @Bit064 VARCHAR(1000) OUTPUT,
	@Bit065 VARCHAR(1000) OUTPUT, @Bit066 VARCHAR(1000) OUTPUT, @Bit067 VARCHAR(1000) OUTPUT, @Bit068 VARCHAR(1000) OUTPUT,
	@Bit069 VARCHAR(1000) OUTPUT, @Bit070 VARCHAR(1000) OUTPUT, @Bit071 VARCHAR(1000) OUTPUT, @Bit072 VARCHAR(1000) OUTPUT,
	@Bit073 VARCHAR(1000) OUTPUT, @Bit074 VARCHAR(1000) OUTPUT, @Bit075 VARCHAR(1000) OUTPUT, @Bit076 VARCHAR(1000) OUTPUT,
	@Bit077 VARCHAR(1000) OUTPUT, @Bit078 VARCHAR(1000) OUTPUT, @Bit079 VARCHAR(1000) OUTPUT, @Bit080 VARCHAR(1000) OUTPUT,
	@Bit081 VARCHAR(1000) OUTPUT, @Bit082 VARCHAR(1000) OUTPUT, @Bit083 VARCHAR(1000) OUTPUT, @Bit084 VARCHAR(1000) OUTPUT,
	@Bit085 VARCHAR(1000) OUTPUT, @Bit086 VARCHAR(1000) OUTPUT, @Bit087 VARCHAR(1000) OUTPUT, @Bit088 VARCHAR(1000) OUTPUT,
	@Bit089 VARCHAR(1000) OUTPUT, @Bit090 VARCHAR(1000) OUTPUT, @Bit091 VARCHAR(1000) OUTPUT, @Bit092 VARCHAR(1000) OUTPUT,
	@Bit093 VARCHAR(1000) OUTPUT, @Bit094 VARCHAR(1000) OUTPUT, @Bit095 VARCHAR(1000) OUTPUT, @Bit096 VARCHAR(1000) OUTPUT,
	@Bit097 VARCHAR(1000) OUTPUT, @Bit098 VARCHAR(1000) OUTPUT, @Bit099 VARCHAR(1000) OUTPUT, @Bit100 VARCHAR(1000) OUTPUT,
	@Bit101 VARCHAR(1000) OUTPUT, @Bit102 VARCHAR(1000) OUTPUT, @Bit103 VARCHAR(1000) OUTPUT, @Bit104 VARCHAR(1000) OUTPUT,
	@Bit105 VARCHAR(1000) OUTPUT, @Bit106 VARCHAR(1000) OUTPUT, @Bit107 VARCHAR(1000) OUTPUT, @Bit108 VARCHAR(1000) OUTPUT,
	@Bit109 VARCHAR(1000) OUTPUT, @Bit110 VARCHAR(1000) OUTPUT, @Bit111 VARCHAR(1000) OUTPUT, @Bit112 VARCHAR(1000) OUTPUT,
	@Bit113 VARCHAR(1000) OUTPUT, @Bit114 VARCHAR(1000) OUTPUT, @Bit115 VARCHAR(1000) OUTPUT, @Bit116 VARCHAR(1000) OUTPUT,
	@Bit117 VARCHAR(1000) OUTPUT, @Bit118 VARCHAR(1000) OUTPUT, @Bit119 VARCHAR(1000) OUTPUT, @Bit120 VARCHAR(1000) OUTPUT,
	@Bit121 VARCHAR(1000) OUTPUT, @Bit122 VARCHAR(1000) OUTPUT, @Bit123 VARCHAR(1000) OUTPUT, @Bit124 VARCHAR(1000) OUTPUT,
	@Bit125 VARCHAR(1000) OUTPUT, @Bit126 VARCHAR(1000) OUTPUT, @Bit127 VARCHAR(1000) OUTPUT, @Bit128 VARCHAR(1000) OUTPUT
)

AS
BEGIN
	
	SET NOCOUNT ON

	SELECT	@Bit001 = '0600', @Bit002 = [DBO].[f_RemoverSinalizador](@Bit002), @Bit003 = [DBO].[f_RemoverSinalizador](@Bit003), @Bit004 = [DBO].[f_RemoverSinalizador](@Bit004),
			@Bit005 = [DBO].[f_RemoverSinalizador](@Bit005), @Bit006 = [DBO].[f_RemoverSinalizador](@Bit006), @Bit007 = [DBO].[f_RemoverSinalizador](@Bit007), @Bit008 = [DBO].[f_RemoverSinalizador](@Bit008),
			@Bit009 = [DBO].[f_RemoverSinalizador](@Bit009), @Bit010 = [DBO].[f_RemoverSinalizador](@Bit010), @Bit011 = [DBO].[f_RemoverSinalizador](@Bit011), @Bit012 = [DBO].[f_RemoverSinalizador](@Bit012),
			@Bit013 = [DBO].[f_RemoverSinalizador](@Bit013), @Bit014 = [DBO].[f_RemoverSinalizador](@Bit014), @Bit015 = [DBO].[f_RemoverSinalizador](@Bit015), @Bit016 = [DBO].[f_RemoverSinalizador](@Bit016),
			@Bit017 = [DBO].[f_RemoverSinalizador](@Bit017), @Bit018 = [DBO].[f_RemoverSinalizador](@Bit018), @Bit019 = [DBO].[f_RemoverSinalizador](@Bit019), @Bit020 = [DBO].[f_RemoverSinalizador](@Bit020),
			@Bit021 = [DBO].[f_RemoverSinalizador](@Bit021), @Bit022 = [DBO].[f_RemoverSinalizador](@Bit022), @Bit023 = [DBO].[f_RemoverSinalizador](@Bit023), @Bit024 = [DBO].[f_RemoverSinalizador](@Bit024),
			@Bit025 = [DBO].[f_RemoverSinalizador](@Bit025), @Bit026 = [DBO].[f_RemoverSinalizador](@Bit026), @Bit027 = [DBO].[f_RemoverSinalizador](@Bit027), @Bit028 = [DBO].[f_RemoverSinalizador](@Bit028),
			@Bit029 = [DBO].[f_RemoverSinalizador](@Bit029), @Bit030 = [DBO].[f_RemoverSinalizador](@Bit030), @Bit031 = [DBO].[f_RemoverSinalizador](@Bit031), @Bit032 = [DBO].[f_RemoverSinalizador](@Bit032),
			@Bit033 = [DBO].[f_RemoverSinalizador](@Bit033), @Bit034 = [DBO].[f_RemoverSinalizador](@Bit034), @Bit035 = [DBO].[f_RemoverSinalizador](@Bit035), @Bit036 = [DBO].[f_RemoverSinalizador](@Bit036),
			@Bit037 = [DBO].[f_RemoverSinalizador](@Bit037), @Bit038 = [DBO].[f_RemoverSinalizador](@Bit038), @Bit039 = [DBO].[f_RemoverSinalizador](@Bit039), @Bit040 = [DBO].[f_RemoverSinalizador](@Bit040),
			@Bit041 = [DBO].[f_RemoverSinalizador](@Bit041), @Bit042 = [DBO].[f_RemoverSinalizador](@Bit042), @Bit043 = [DBO].[f_RemoverSinalizador](@Bit043), @Bit044 = [DBO].[f_RemoverSinalizador](@Bit044),
			@Bit045 = [DBO].[f_RemoverSinalizador](@Bit045), @Bit046 = [DBO].[f_RemoverSinalizador](@Bit046), @Bit047 = [DBO].[f_RemoverSinalizador](@Bit047), @Bit048 = [DBO].[f_RemoverSinalizador](@Bit048),
			@Bit049 = [DBO].[f_RemoverSinalizador](@Bit049), @Bit050 = [DBO].[f_RemoverSinalizador](@Bit050), @Bit051 = [DBO].[f_RemoverSinalizador](@Bit051), @Bit052 = [DBO].[f_RemoverSinalizador](@Bit052),
			@Bit053 = [DBO].[f_RemoverSinalizador](@Bit053), @Bit054 = [DBO].[f_RemoverSinalizador](@Bit054), @Bit055 = [DBO].[f_RemoverSinalizador](@Bit055), @Bit056 = [DBO].[f_RemoverSinalizador](@Bit056),
			@Bit057 = [DBO].[f_RemoverSinalizador](@Bit057), @Bit058 = [DBO].[f_RemoverSinalizador](@Bit058), @Bit059 = [DBO].[f_RemoverSinalizador](@Bit059), @Bit060 = [DBO].[f_RemoverSinalizador](@Bit060),
			@Bit061 = [DBO].[f_RemoverSinalizador](@Bit061), @Bit062 = [DBO].[f_RemoverSinalizador](@Bit062), @Bit063 = [DBO].[f_RemoverSinalizador](@Bit063), @Bit064 = [DBO].[f_RemoverSinalizador](@Bit064),
			@Bit065 = [DBO].[f_RemoverSinalizador](@Bit065), @Bit066 = [DBO].[f_RemoverSinalizador](@Bit066), @Bit067 = [DBO].[f_RemoverSinalizador](@Bit067), @Bit068 = [DBO].[f_RemoverSinalizador](@Bit068),
			@Bit069 = [DBO].[f_RemoverSinalizador](@Bit069), @Bit070 = [DBO].[f_RemoverSinalizador](@Bit070), @Bit071 = [DBO].[f_RemoverSinalizador](@Bit071), @Bit072 = [DBO].[f_RemoverSinalizador](@Bit072),
			@Bit073 = [DBO].[f_RemoverSinalizador](@Bit073), @Bit074 = [DBO].[f_RemoverSinalizador](@Bit074), @Bit075 = [DBO].[f_RemoverSinalizador](@Bit075), @Bit076 = [DBO].[f_RemoverSinalizador](@Bit076),
			@Bit077 = [DBO].[f_RemoverSinalizador](@Bit077), @Bit078 = [DBO].[f_RemoverSinalizador](@Bit078), @Bit079 = [DBO].[f_RemoverSinalizador](@Bit079), @Bit080 = [DBO].[f_RemoverSinalizador](@Bit080),
			@Bit081 = [DBO].[f_RemoverSinalizador](@Bit081), @Bit082 = [DBO].[f_RemoverSinalizador](@Bit082), @Bit083 = [DBO].[f_RemoverSinalizador](@Bit083), @Bit084 = [DBO].[f_RemoverSinalizador](@Bit084),
			@Bit085 = [DBO].[f_RemoverSinalizador](@Bit085), @Bit086 = [DBO].[f_RemoverSinalizador](@Bit086), @Bit087 = [DBO].[f_RemoverSinalizador](@Bit087), @Bit088 = [DBO].[f_RemoverSinalizador](@Bit088),
			@Bit089 = [DBO].[f_RemoverSinalizador](@Bit089), @Bit090 = [DBO].[f_RemoverSinalizador](@Bit090), @Bit091 = [DBO].[f_RemoverSinalizador](@Bit091), @Bit092 = [DBO].[f_RemoverSinalizador](@Bit092),
			@Bit093 = [DBO].[f_RemoverSinalizador](@Bit093), @Bit094 = [DBO].[f_RemoverSinalizador](@Bit094), @Bit095 = [DBO].[f_RemoverSinalizador](@Bit095), @Bit096 = [DBO].[f_RemoverSinalizador](@Bit096),
			@Bit097 = [DBO].[f_RemoverSinalizador](@Bit097), @Bit098 = [DBO].[f_RemoverSinalizador](@Bit098), @Bit099 = [DBO].[f_RemoverSinalizador](@Bit099), @Bit100 = [DBO].[f_RemoverSinalizador](@Bit100),
			@Bit101 = [DBO].[f_RemoverSinalizador](@Bit101), @Bit102 = [DBO].[f_RemoverSinalizador](@Bit102), @Bit103 = [DBO].[f_RemoverSinalizador](@Bit103), @Bit104 = [DBO].[f_RemoverSinalizador](@Bit104),
			@Bit105 = [DBO].[f_RemoverSinalizador](@Bit105), @Bit106 = [DBO].[f_RemoverSinalizador](@Bit106), @Bit107 = [DBO].[f_RemoverSinalizador](@Bit107), @Bit108 = [DBO].[f_RemoverSinalizador](@Bit108),
			@Bit109 = [DBO].[f_RemoverSinalizador](@Bit109), @Bit110 = [DBO].[f_RemoverSinalizador](@Bit110), @Bit111 = [DBO].[f_RemoverSinalizador](@Bit111), @Bit112 = [DBO].[f_RemoverSinalizador](@Bit112),
			@Bit113 = [DBO].[f_RemoverSinalizador](@Bit113), @Bit114 = [DBO].[f_RemoverSinalizador](@Bit114), @Bit115 = [DBO].[f_RemoverSinalizador](@Bit115), @Bit116 = [DBO].[f_RemoverSinalizador](@Bit116),
			@Bit117 = [DBO].[f_RemoverSinalizador](@Bit117), @Bit118 = [DBO].[f_RemoverSinalizador](@Bit118), @Bit119 = [DBO].[f_RemoverSinalizador](@Bit119), @Bit120 = [DBO].[f_RemoverSinalizador](@Bit120),
			@Bit121 = [DBO].[f_RemoverSinalizador](@Bit121), @Bit122 = [DBO].[f_RemoverSinalizador](@Bit122), @Bit123 = [DBO].[f_RemoverSinalizador](@Bit123), @Bit124 = [DBO].[f_RemoverSinalizador](@Bit124),
			@Bit125 = [DBO].[f_RemoverSinalizador](@Bit125), @Bit126 = [DBO].[f_RemoverSinalizador](@Bit126), @Bit127 = [DBO].[f_RemoverSinalizador](@Bit127), @Bit128 = [DBO].[f_RemoverSinalizador](@Bit128)

	DECLARE  @iRetorno			INT
			,@dValor			DECIMAL(15,2)
			,@cNumeroCartao		CHAR(16)
			,@iEstCodigo		INT
			,@cBaseOrigem		CHAR(1)
			,@cNivelSonda		VARCHAR(10)
			,@iQtdeSonda		INT
			,@dDataInicioSonda	DATETIME
			,@dDataHoraResposta	DATETIME
			,@iCodigoSonda		INT
			,@bSondaRespondida	BIT
			,@iEstabelecimento	INT
			
	SET @bSondaRespondida = 0
	SET @cNivelSonda = ''
	SET @iQtdeSonda = 0
	SET @iRetorno = 1
	SET @iEstabelecimento = 0

	-- Validando processadora
	SELECT @iEstabelecimento = Processadora.dbo.f_RetornarEstabelecimento(@Bit042)

	IF @iEstabelecimento > 0
		SELECT @iEstCodigo = EstCodigo FROM Processadora.dbo.Estabelecimentos WITH (NOLOCK) WHERE Numero = @iEstabelecimento
	
	IF (@iEstCodigo IS NOT NULL OR @iEstCodigo <> '')
	BEGIN
		
		/*INICIO ***Transacoes que foram sondadas e nao respondidas serão sondadas novamente***/
		IF EXISTS (SELECT 1 FROM dbo.ControleSonda WITH (NOLOCK)
					WHERE Estabelecimento = @Bit042
					AND DataRespSonda IS NULL 
					AND DataInicioSonda BETWEEN REPLACE(CONVERT(VARCHAR(10), GETDATE(), 120), '.', '-') + ' 00:00:00' AND DATEADD(n, -2, GETDATE()) /*Transacoes sondadas e nao respondidas em dois minutos*/
					)
		BEGIN
			DELETE FROM dbo.ControleSonda 
			WHERE Estabelecimento = @Bit042 
			AND DataRespSonda IS NULL 
			AND DataInicioSonda BETWEEN REPLACE(CONVERT(VARCHAR(10), GETDATE(), 120), '.', '-') + ' 00:00:00' AND DATEADD(n, -2, GETDATE())
		END
		/*FIM ***Transacoes que foram sondadas e nao respondidas***/
		
		/*INICIO ***Transacoes que foram sondadas e respondidas como 77 => Pendente e 09 => Em andamento***/
		IF EXISTS (SELECT 1 FROM dbo.ControleSonda WITH (NOLOCK)
					WHERE Estabelecimento = @Bit042
					AND StatusSonda IN ('09','77')
					AND DataInicioSonda BETWEEN REPLACE(CONVERT(VARCHAR(10), GETDATE(), 120), '.', '-') + ' 00:00:00' AND GETDATE()
					)
		BEGIN
			
			SET @bSondaRespondida = 1
			
			SELECT 
				 @cNivelSonda		= NivelSonda
				,@Bit007			= DataGMT
				,@Bit011			= NsuOrigem
				,@Bit012			= HoraLocal
				,@Bit013			= DataLocal
				,@Bit125			= NsuOrigem
				,@Bit127			= NSU_Policard
				,@cBaseOrigem		= BaseOrigem
				,@dDataInicioSonda	= DataInicioSonda
				,@dDataHoraResposta	= DataRespSonda
				,@iCodigoSonda		= Codigo
				,@iQtdeSonda		= QtdSonda
			FROM dbo.ControleSonda WITH (NOLOCK)
			WHERE Estabelecimento = @Bit042
			AND StatusSonda IN ('09','77')
			AND DataInicioSonda BETWEEN REPLACE(CONVERT(VARCHAR(10), GETDATE(), 120), '.', '-') + ' 00:00:00' AND GETDATE()
			ORDER BY DataRespSonda ASC
			
			IF (@cNivelSonda = 'T1')
			BEGIN

				IF (DATEDIFF(n, @dDataInicioSonda, GETDATE()) >= 2)
				BEGIN 
				
					IF @cBaseOrigem = 'P'
					BEGIN	
					
											
						IF EXISTS (SELECT 1 
								FROM Processadora.dbo.Transacoes TRN WITH(NOLOCK)	
								JOIN Processadora.dbo.CartoesUsuarios C WITH(NOLOCK) ON (C.CrtUsrCodigo = TRN.CrtUsrCodigo)
								WHERE TRN.TrnCodigo = @Bit127
								AND TRN.Status = 'P')
						BEGIN

							SET @iRetorno = 0
							--SET @bSondaRespondida = 1
							UPDATE dbo.ControleSonda SET NivelSonda = 'T2',StatusSonda = NULL, QtdSonda = @iQtdeSonda + 1 WHERE Codigo = @iCodigoSonda
						
						END
					END
					ELSE IF @cBaseOrigem = 'C'
					BEGIN
												
						IF EXISTS (SELECT 1						
									FROM   [Policard_603078].[dbo].Transacao_RegistroTEF T WITH(NOLOCK)
									WHERE NsuHost = @Bit127
									AND T.StatusTef = 'P')
						BEGIN
							SET @iRetorno = 0
							--SET @bSondaRespondida = 1
							UPDATE dbo.ControleSonda SET NivelSonda = 'T2', StatusSonda = NULL, QtdSonda = @iQtdeSonda + 1 WHERE Codigo = @iCodigoSonda
						END
					END
				END
				
			END
			ELSE IF (@cNivelSonda = 'T2')
			BEGIN
				IF (DATEDIFF(MINUTE, @dDataInicioSonda, GETDATE()) >= 5)
				BEGIN
					IF @cBaseOrigem = 'P'
					BEGIN						
						IF EXISTS (SELECT 1 
								FROM Processadora.dbo.Transacoes TRN WITH(NOLOCK)	
								INNER JOIN Processadora.dbo.CartoesUsuarios C WITH(NOLOCK) ON (C.CrtUsrCodigo = TRN.CrtUsrCodigo)
								WHERE TRN.TrnCodigo = @Bit127
								AND TRN.Status = 'P')
						BEGIN
							SET @iRetorno = 0
							--SET @bSondaRespondida = 1
							UPDATE dbo.ControleSonda SET NivelSonda = 'T3',StatusSonda = NULL, QtdSonda = @iQtdeSonda + 1 WHERE Codigo = @iCodigoSonda
						END
					END
					ELSE IF @cBaseOrigem = 'C'
					BEGIN
						IF EXISTS (SELECT 1						
									FROM   [Policard_603078].[dbo].Transacao_RegistroTEF T WITH(NOLOCK)
									WHERE NsuHost = @Bit127
									AND T.StatusTef = 'P')
						BEGIN
							SET @iRetorno = 0
							--SET @bSondaRespondida = 1
							UPDATE dbo.ControleSonda SET NivelSonda = 'T3', StatusSonda = NULL, QtdSonda = @iQtdeSonda + 1 WHERE Codigo = @iCodigoSonda
						END
					END
				END
			END			
			ELSE IF (@cNivelSonda = 'T3')
			BEGIN
				IF (DATEDIFF(MINUTE, @dDataInicioSonda, GETDATE()) >= 10)
				BEGIN
					IF (@cBaseOrigem = 'P')
					BEGIN						
						IF EXISTS (SELECT 1 
								FROM Processadora.dbo.Transacoes TRN WITH(NOLOCK)	
								INNER JOIN Processadora.dbo.CartoesUsuarios C WITH(NOLOCK) ON (C.CrtUsrCodigo = TRN.CrtUsrCodigo)
								WHERE TRN.TrnCodigo = @Bit127
								AND TRN.Status = 'P')
						BEGIN
							SET @iRetorno = 0
							--SET @bSondaRespondida = 1
							UPDATE dbo.ControleSonda SET StatusSonda = NULL, QtdSonda = @iQtdeSonda + 1 WHERE Codigo = @iCodigoSonda
						END
					END
					ELSE IF (@cBaseOrigem = 'C')
					BEGIN
						IF EXISTS (SELECT 1						
									FROM   [Policard_603078].[dbo].Transacao_RegistroTEF T WITH(NOLOCK)
									WHERE NsuHost = @Bit127
									AND T.StatusTef = 'P')
						BEGIN
							SET @iRetorno = 0
							--SET @bSondaRespondida = 1
							UPDATE dbo.ControleSonda SET StatusSonda = NULL, QtdSonda = @iQtdeSonda + 1 WHERE Codigo = @iCodigoSonda
						END
					END
				END
			END
		END
		/*FIM ***Transacoes que foram sondadas e respondidas como pendente ou em andamento***/
		
		
		IF (@iRetorno = 1) -- Validando processadora
		BEGIN


			SELECT	TOP 1
					 @iRetorno		= 0
					,@cNivelSonda	= 'T1'
					,@Bit007 		= LTRIM(RTRIM(TRN.DataGMT))
					,@Bit011 		= TRN.NsuOrigem
					,@Bit012 		= TRN.HoraLocal
					,@Bit013 		= TRN.DataLocal
					,@Bit125 		= dbo.f_ZerosEsquerda(TRN.NsuOrigem, 6)
					,@Bit127 		= dbo.f_ZerosEsquerda(TRN.TrnCodigo, 9)
					,@dValor 		= TRN.Valor
					,@cNumeroCartao = C.Numero
					,@cBaseOrigem	= 'P' /*Processadora*/
					,@iQtdeSonda	= 1
					,@bSondaRespondida = 0
			FROM	Processadora.dbo.Transacoes TRN WITH(NOLOCK)
					INNER JOIN Processadora.dbo.CartoesUsuarios C WITH(NOLOCK) ON (C.CrtUsrCodigo = TRN.CrtUsrCodigo)
			WHERE	TRN.Status = 'P'
					AND TRN.RdeCodigo = 2 /* INCLUSÃO DE VALIDAÇÃO DA REDE (TEF DEDICADO) PARA NÃO SONDAR TRANSAÇÕES 2 VIAS */
					AND TRN.EstCodigo = @iEstCodigo
					AND TRN.DataAutorizacao BETWEEN REPLACE(CONVERT(VARCHAR(10), GETDATE(), 120), '.', '-') + ' 00:00:00' AND DATEADD(s, -30, GETDATE())
					AND NOT EXISTS (SELECT 1 FROM ControleSonda WITH(NOLOCK) WHERE Nsu_Policard = TRN.TrnCodigo AND NumeroCartao = C.Numero AND Valor = TRN.Valor)
			ORDER BY TRN.TrnCodigo ASC

		
		END

		IF (@iRetorno = 1) -- Validando Convenio
		BEGIN
			SELECT	TOP 1
					 @iRetorno		= 0
					,@cNivelSonda	= 'T1'
					,@Bit007 		= LTRIM(RTRIM(T.DataHoraGMT))--T.DataLocal + T.HoraLocal
					,@Bit011 		= dbo.f_ZerosEsquerda(T.NsuLoja, 6)
					,@Bit012 		= T.HoraLocal
					,@Bit013 		= T.DataLocal
					,@Bit125 		= dbo.f_ZerosEsquerda(T.NsuLoja, 6)
					,@Bit127 		= dbo.f_ZerosEsquerda(T.NsuHost, 9)
					,@dValor 		= T.Valor
					,@cNumeroCartao = T.NumeroCartao
					,@cBaseOrigem	= 'C' /*Convenio*/
					,@iQtdeSonda	= 1
					,@bSondaRespondida = 0
			FROM	  [Policard_603078].[dbo].Transacao_RegistroTEF T WITH(NOLOCK)
			WHERE	T.StatusTef = 'P'
					AND CONVERT(INT, T.Rede) = 7 /* INCLUSÃO DE VALIDAÇÃO DA REDE (TEF DEDICADO) PARA NÃO SONDAR TRANSAÇÕES 2 VIAS */
					AND T.Estabelecimento = CONVERT(INT, @Bit042)
					AND T.DataAutorizacao BETWEEN REPLACE(CONVERT(VARCHAR(10), GETDATE(), 120), '.', '-') + ' 00:00:00' AND DATEADD(s, -30, GETDATE())
					AND NOT EXISTS (SELECT 1 FROM ControleSonda WITH(NOLOCK) WHERE Nsu_Policard = T.NsuHost AND NumeroCartao = T.NumeroCartao AND Valor = T.Valor)
			ORDER BY T.NsuHost ASC
		END
--
--		IF (@iRetorno = 1) -- Validando Frete
--		BEGIN
--			SELECT	TOP 1
--					 @iRetorno = 0
--					,@Bit007 = DataGMT
--					,@Bit011 = FRQ.NSUMeioCaptura
--					,@Bit012 = FRQ.HoraLocal
--					,@Bit013 = FRQ.DataLocal
--					,@Bit125 = FRQ.NSUMeioCaptura
--					,@Bit127 = FRQ.Codigo
--					,@dValor = FRQ.ValorQuitracao
--					,@cNumeroCartao = CUS.numero
--					,@cBaseOrigem	= 'P' /*Processadora*/
--			FROM	Processadora.dbo.Frete_Quitacao FRQ WITH(HOLDLOCK, ROWLOCK)
--					JOIN Estabelecimentos EST WITH(NOLOCK) ON (EST.EstCodigo = FRQ.Estabelecimento)
--					JOIN Cartoesusuarios CUS WITH(nolock) ON (CUS.CrtUsrCodigo = FRQ.CartaoUsuario)
--					--JOIN AuditoriaTransacoes AUD WITH(NOLOCK) ON (CONVERT(INT, AUD.Bit127) = FRQ.NSUMeioCaptura AND EST.Numero = CONVERT(INT, AUD.Bit042))
--			WHERE	EST.Numero = CONVERT(INT, @Bit042)
--					AND CONVERT(VARCHAR, FRQ.DataQuitacao, 103) = CONVERT(VARCHAR, GETDATE(), 103)
--					AND FRQ.DataQuitacao BETWEEN CONVERT(VARCHAR(10), GETDATE(), 120) + ' 00:00:00' AND DATEADD(s, -30, GETDATE())
--					AND FRQ.Status = 'P'
--					AND FRQ.RdeCodigo = 7
--					AND NOT EXISTS (SELECT 1 FROM ControleSonda WITH(NOLOCK) WHERE Nsu_Policard = FRQ.Codigo AND NumeroCartao = CUS.Numero AND Valor = FRQ.ValorQuitracao)
--			ORDER BY FRQ.Codigo ASC
--			
--			IF @iRetorno = 0
--			BEGIN
--				SET @Bit125 = dbo.fn_ZerosEsquerda(@Bit125,6)
--				SET @Bit127 = dbo.fn_ZerosEsquerda(@Bit127,9)
--			END
--			
--		END
	END

	
	IF (@iRetorno = 0)
	BEGIN

		IF (@bSondaRespondida = 0)
		BEGIN

			INSERT INTO ControleSonda(
					 Nsu_Policard
					,CodigoMensagem
					,Valor
					,NumeroCartao
					,DataInicioSonda
					,BaseOrigem
					,NsuOrigem
					,Estabelecimento
					,SondaEnviada
					,NivelSonda
					,QtdSonda
					,DataGMT
					,DataLocal
					,HoraLocal
					)
			VALUES( 
					 @Bit127
					,@Bit001
					,@dValor
					,@cNumeroCartao
					,GETDATE()
					,@cBaseOrigem
					,@Bit011
					,@Bit042
					,1
					,@cNivelSonda
					,@iQtdeSonda
					,@Bit007
					,@Bit013
					,@Bit012
					)
		END

		INSERT INTO dbo.AuditoriaTransacoes(DataHora,
				Bit001, Bit002, Bit003, Bit004, Bit005, Bit006, Bit007, Bit008, Bit009, Bit010, Bit011, Bit012, Bit013, Bit014, Bit015, Bit016,
				Bit017, Bit018, Bit019, Bit020, Bit021, Bit022, Bit023, Bit024, Bit025, Bit026, Bit027, Bit028, Bit029, Bit030, Bit031, Bit032,
				Bit033, Bit034, Bit035, Bit036, Bit037, Bit038, Bit039, Bit040, Bit041, Bit042, Bit043, Bit044, Bit045, Bit046, Bit047, Bit048,
				Bit049, Bit050, Bit051, Bit052, Bit053, Bit054, Bit055, Bit056, Bit057, Bit058, Bit059, Bit060, Bit061, Bit062, Bit063, Bit064,
				Bit065, Bit066, Bit067, Bit068, Bit069, Bit070, Bit071, Bit072, Bit073, Bit074, Bit075, Bit076, Bit077, Bit078, Bit079, Bit080,
				Bit081, Bit082, Bit083, Bit084, Bit085, Bit086, Bit087, Bit088, Bit089, Bit090, Bit091, Bit092, Bit093, Bit094, Bit095, Bit096,
				Bit097, Bit098, Bit099, Bit100, Bit101, Bit102, Bit103, Bit104, Bit105, Bit106, Bit107, Bit108, Bit109, Bit110, Bit111, Bit112,
				Bit113, Bit114, Bit115, Bit116, Bit117, Bit118, Bit119, Bit120, Bit121, Bit122, Bit123, Bit124, Bit125, Bit126, Bit127, Bit128)
		VALUES( GETDATE(),
				@Bit001, @Bit002, @Bit003, @Bit004, @Bit005, @Bit006, @Bit007, @Bit008, @Bit009, @Bit010, @Bit011, @Bit012, @Bit013, @Bit014, @Bit015, @Bit016,
				@Bit017, @Bit018, @Bit019, @Bit020, @Bit021, @Bit022, @Bit023, @Bit024, @Bit025, @Bit026, @Bit027, @Bit028, @Bit029, @Bit030, @Bit031, @Bit032,
				@Bit033, @Bit034, @Bit035, @Bit036, @Bit037, @Bit038, @Bit039, @Bit040, @Bit041, @Bit042, @Bit043, @Bit044, @Bit045, @Bit046, @Bit047, @Bit048,
				@Bit049, @Bit050, @Bit051, @Bit052, @Bit053, @Bit054, @Bit055, @Bit056, @Bit057, @Bit058, @Bit059, @Bit060, @Bit061, @Bit062, @Bit063, @Bit064,
				@Bit065, @Bit066, @Bit067, @Bit068, @Bit069, @Bit070, @Bit071, @Bit072, @Bit073, @Bit074, @Bit075, @Bit076, @Bit077, @Bit078, @Bit079, @Bit080,
				@Bit081, @Bit082, @Bit083, @Bit084, @Bit085, @Bit086, @Bit087, @Bit088, @Bit089, @Bit090, @Bit091, @Bit092, @Bit093, @Bit094, @Bit095, @Bit096,
				@Bit097, @Bit098, @Bit099, @Bit100, @Bit101, @Bit102, @Bit103, @Bit104, @Bit105, @Bit106, @Bit107, @Bit108, @Bit109, @Bit110, @Bit111, @Bit112,
				@Bit113, @Bit114, @Bit115, @Bit116, @Bit117, @Bit118, @Bit119, @Bit120, @Bit121, @Bit122, @Bit123, @Bit124, @Bit125, @Bit126, @Bit127, @Bit128)
	

		SELECT	@Bit001 = [DBO].[f_Inclui_Sinalizador](@Bit001), @Bit002 = [DBO].[f_Inclui_Sinalizador](@Bit002), @Bit003 = [DBO].[f_Inclui_Sinalizador](@Bit003), @Bit004 = [DBO].[f_Inclui_Sinalizador](@Bit004),
				@Bit005 = [DBO].[f_Inclui_Sinalizador](@Bit005), @Bit006 = [DBO].[f_Inclui_Sinalizador](@Bit006), @Bit007 = [DBO].[f_Inclui_Sinalizador](@Bit007), @Bit008 = [DBO].[f_Inclui_Sinalizador](@Bit008),
				@Bit009 = [DBO].[f_Inclui_Sinalizador](@Bit009), @Bit010 = [DBO].[f_Inclui_Sinalizador](@Bit010), @Bit011 = [DBO].[f_Inclui_Sinalizador](@Bit011), @Bit012 = [DBO].[f_Inclui_Sinalizador](@Bit012),
				@Bit013 = [DBO].[f_Inclui_Sinalizador](@Bit013), @Bit014 = [DBO].[f_Inclui_Sinalizador](@Bit014), @Bit015 = [DBO].[f_Inclui_Sinalizador](@Bit015), @Bit016 = [DBO].[f_Inclui_Sinalizador](@Bit016),
				@Bit017 = [DBO].[f_Inclui_Sinalizador](@Bit017), @Bit018 = [DBO].[f_Inclui_Sinalizador](@Bit018), @Bit019 = [DBO].[f_Inclui_Sinalizador](@Bit019), @Bit020 = [DBO].[f_Inclui_Sinalizador](@Bit020),
				@Bit021 = [DBO].[f_Inclui_Sinalizador](@Bit021), @Bit022 = [DBO].[f_Inclui_Sinalizador](@Bit022), @Bit023 = [DBO].[f_Inclui_Sinalizador](@Bit023), @Bit024 = [DBO].[f_Inclui_Sinalizador](@Bit024),
				@Bit025 = [DBO].[f_Inclui_Sinalizador](@Bit025), @Bit026 = [DBO].[f_Inclui_Sinalizador](@Bit026), @Bit027 = [DBO].[f_Inclui_Sinalizador](@Bit027), @Bit028 = [DBO].[f_Inclui_Sinalizador](@Bit028),
				@Bit029 = [DBO].[f_Inclui_Sinalizador](@Bit029), @Bit030 = [DBO].[f_Inclui_Sinalizador](@Bit030), @Bit031 = [DBO].[f_Inclui_Sinalizador](@Bit031), @Bit032 = [DBO].[f_Inclui_Sinalizador](@Bit032),
				@Bit033 = [DBO].[f_Inclui_Sinalizador](@Bit033), @Bit034 = [DBO].[f_Inclui_Sinalizador](@Bit034), @Bit035 = [DBO].[f_Inclui_Sinalizador](@Bit035), @Bit036 = [DBO].[f_Inclui_Sinalizador](@Bit036),
				@Bit037 = [DBO].[f_Inclui_Sinalizador](@Bit037), @Bit038 = [DBO].[f_Inclui_Sinalizador](@Bit038), @Bit039 = [DBO].[f_Inclui_Sinalizador](@Bit039), @Bit040 = [DBO].[f_Inclui_Sinalizador](@Bit040),
				@Bit041 = [DBO].[f_Inclui_Sinalizador](@Bit041), @Bit042 = [DBO].[f_Inclui_Sinalizador](@Bit042), @Bit043 = [DBO].[f_Inclui_Sinalizador](@Bit043), @Bit044 = [DBO].[f_Inclui_Sinalizador](@Bit044),
				@Bit045 = [DBO].[f_Inclui_Sinalizador](@Bit045), @Bit046 = [DBO].[f_Inclui_Sinalizador](@Bit046), @Bit047 = [DBO].[f_Inclui_Sinalizador](@Bit047), @Bit048 = [DBO].[f_Inclui_Sinalizador](@Bit048),
				@Bit049 = [DBO].[f_Inclui_Sinalizador](@Bit049), @Bit050 = [DBO].[f_Inclui_Sinalizador](@Bit050), @Bit051 = [DBO].[f_Inclui_Sinalizador](@Bit051), @Bit052 = [DBO].[f_Inclui_Sinalizador](@Bit052),
				@Bit053 = [DBO].[f_Inclui_Sinalizador](@Bit053), @Bit054 = [DBO].[f_Inclui_Sinalizador](@Bit054), @Bit055 = [DBO].[f_Inclui_Sinalizador](@Bit055), @Bit056 = [DBO].[f_Inclui_Sinalizador](@Bit056),
				@Bit057 = [DBO].[f_Inclui_Sinalizador](@Bit057), @Bit058 = [DBO].[f_Inclui_Sinalizador](@Bit058), @Bit059 = [DBO].[f_Inclui_Sinalizador](@Bit059), @Bit060 = [DBO].[f_Inclui_Sinalizador](@Bit060),
				@Bit061 = [DBO].[f_Inclui_Sinalizador](@Bit061), @Bit062 = [DBO].[f_Inclui_Sinalizador](@Bit062), @Bit063 = [DBO].[f_Inclui_Sinalizador](@Bit063), @Bit064 = [DBO].[f_Inclui_Sinalizador](@Bit064),
				@Bit065 = [DBO].[f_Inclui_Sinalizador](@Bit065), @Bit066 = [DBO].[f_Inclui_Sinalizador](@Bit066), @Bit067 = [DBO].[f_Inclui_Sinalizador](@Bit067), @Bit068 = [DBO].[f_Inclui_Sinalizador](@Bit068),
				@Bit069 = [DBO].[f_Inclui_Sinalizador](@Bit069), @Bit070 = [DBO].[f_Inclui_Sinalizador](@Bit070), @Bit071 = [DBO].[f_Inclui_Sinalizador](@Bit071), @Bit072 = [DBO].[f_Inclui_Sinalizador](@Bit072),
				@Bit073 = [DBO].[f_Inclui_Sinalizador](@Bit073), @Bit074 = [DBO].[f_Inclui_Sinalizador](@Bit074), @Bit075 = [DBO].[f_Inclui_Sinalizador](@Bit075), @Bit076 = [DBO].[f_Inclui_Sinalizador](@Bit076),
				@Bit077 = [DBO].[f_Inclui_Sinalizador](@Bit077), @Bit078 = [DBO].[f_Inclui_Sinalizador](@Bit078), @Bit079 = [DBO].[f_Inclui_Sinalizador](@Bit079), @Bit080 = [DBO].[f_Inclui_Sinalizador](@Bit080),
				@Bit081 = [DBO].[f_Inclui_Sinalizador](@Bit081), @Bit082 = [DBO].[f_Inclui_Sinalizador](@Bit082), @Bit083 = [DBO].[f_Inclui_Sinalizador](@Bit083), @Bit084 = [DBO].[f_Inclui_Sinalizador](@Bit084),
				@Bit085 = [DBO].[f_Inclui_Sinalizador](@Bit085), @Bit086 = [DBO].[f_Inclui_Sinalizador](@Bit086), @Bit087 = [DBO].[f_Inclui_Sinalizador](@Bit087), @Bit088 = [DBO].[f_Inclui_Sinalizador](@Bit088),
				@Bit089 = [DBO].[f_Inclui_Sinalizador](@Bit089), @Bit090 = [DBO].[f_Inclui_Sinalizador](@Bit090), @Bit091 = [DBO].[f_Inclui_Sinalizador](@Bit091), @Bit092 = [DBO].[f_Inclui_Sinalizador](@Bit092),
				@Bit093 = [DBO].[f_Inclui_Sinalizador](@Bit093), @Bit094 = [DBO].[f_Inclui_Sinalizador](@Bit094), @Bit095 = [DBO].[f_Inclui_Sinalizador](@Bit095), @Bit096 = [DBO].[f_Inclui_Sinalizador](@Bit096),
				@Bit097 = [DBO].[f_Inclui_Sinalizador](@Bit097), @Bit098 = [DBO].[f_Inclui_Sinalizador](@Bit098), @Bit099 = [DBO].[f_Inclui_Sinalizador](@Bit099), @Bit100 = [DBO].[f_Inclui_Sinalizador](@Bit100),
				@Bit101 = [DBO].[f_Inclui_Sinalizador](@Bit101), @Bit102 = [DBO].[f_Inclui_Sinalizador](@Bit102), @Bit103 = [DBO].[f_Inclui_Sinalizador](@Bit103), @Bit104 = [DBO].[f_Inclui_Sinalizador](@Bit104),
				@Bit105 = [DBO].[f_Inclui_Sinalizador](@Bit105), @Bit106 = [DBO].[f_Inclui_Sinalizador](@Bit106), @Bit107 = [DBO].[f_Inclui_Sinalizador](@Bit107), @Bit108 = [DBO].[f_Inclui_Sinalizador](@Bit108),
				@Bit109 = [DBO].[f_Inclui_Sinalizador](@Bit109), @Bit110 = [DBO].[f_Inclui_Sinalizador](@Bit110), @Bit111 = [DBO].[f_Inclui_Sinalizador](@Bit111), @Bit112 = [DBO].[f_Inclui_Sinalizador](@Bit112),
				@Bit113 = [DBO].[f_Inclui_Sinalizador](@Bit113), @Bit114 = [DBO].[f_Inclui_Sinalizador](@Bit114), @Bit115 = [DBO].[f_Inclui_Sinalizador](@Bit115), @Bit116 = [DBO].[f_Inclui_Sinalizador](@Bit116),
				@Bit117 = [DBO].[f_Inclui_Sinalizador](@Bit117), @Bit118 = [DBO].[f_Inclui_Sinalizador](@Bit118), @Bit119 = [DBO].[f_Inclui_Sinalizador](@Bit119), @Bit120 = [DBO].[f_Inclui_Sinalizador](@Bit120),
				@Bit121 = [DBO].[f_Inclui_Sinalizador](@Bit121), @Bit122 = [DBO].[f_Inclui_Sinalizador](@Bit122), @Bit123 = [DBO].[f_Inclui_Sinalizador](@Bit123), @Bit124 = [DBO].[f_Inclui_Sinalizador](@Bit124),
				@Bit125 = [DBO].[f_Inclui_Sinalizador](@Bit125), @Bit126 = [DBO].[f_Inclui_Sinalizador](@Bit126), @Bit127 = [DBO].[f_Inclui_Sinalizador](@Bit127), @Bit128 = [DBO].[f_Inclui_Sinalizador](@Bit128)
	END
	
	RETURN @iRetorno
	
END






