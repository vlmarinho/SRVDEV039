


-- ===================================================================
-- Projeto:		Banco 24 Horas
-- Author:		Luiz Renato
-- Create date: 17/04/2015
-- Description:	Procedure responsável por Localizar transações penden-
--         tes da rede Banco 24 Horas e enviar uma transação de sonda.
-- ===================================================================
--Data criação: 19/02/2017
--Mudança: 2601

CREATE PROCEDURE [pr_aut_VerificaSonda24Horas](
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
	@Bit125 VARCHAR(1000) OUTPUT, @Bit126 VARCHAR(1000) OUTPUT, @Bit127 VARCHAR(1000) OUTPUT, @Bit128 VARCHAR(1000) OUTPUT)
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT	@Bit001 = '0600', @Bit002 = [dbo].[f_RemoverSinalizador](@Bit002), @Bit003 = [dbo].[f_RemoverSinalizador](@Bit003), @Bit004 = [dbo].[f_RemoverSinalizador](@Bit004),
			@Bit005 = [dbo].[f_RemoverSinalizador](@Bit005), @Bit006 = [dbo].[f_RemoverSinalizador](@Bit006), @Bit007 = [dbo].[f_RemoverSinalizador](@Bit007), @Bit008 = [dbo].[f_RemoverSinalizador](@Bit008),
			@Bit009 = [dbo].[f_RemoverSinalizador](@Bit009), @Bit010 = [dbo].[f_RemoverSinalizador](@Bit010), @Bit011 = [dbo].[f_RemoverSinalizador](@Bit011), @Bit012 = [dbo].[f_RemoverSinalizador](@Bit012),
			@Bit013 = [dbo].[f_RemoverSinalizador](@Bit013), @Bit014 = [dbo].[f_RemoverSinalizador](@Bit014), @Bit015 = [dbo].[f_RemoverSinalizador](@Bit015), @Bit016 = [dbo].[f_RemoverSinalizador](@Bit016),
			@Bit017 = [dbo].[f_RemoverSinalizador](@Bit017), @Bit018 = [dbo].[f_RemoverSinalizador](@Bit018), @Bit019 = [dbo].[f_RemoverSinalizador](@Bit019), @Bit020 = [dbo].[f_RemoverSinalizador](@Bit020),
			@Bit021 = [dbo].[f_RemoverSinalizador](@Bit021), @Bit022 = [dbo].[f_RemoverSinalizador](@Bit022), @Bit023 = [dbo].[f_RemoverSinalizador](@Bit023), @Bit024 = [dbo].[f_RemoverSinalizador](@Bit024),
			@Bit025 = [dbo].[f_RemoverSinalizador](@Bit025), @Bit026 = [dbo].[f_RemoverSinalizador](@Bit026), @Bit027 = [dbo].[f_RemoverSinalizador](@Bit027), @Bit028 = [dbo].[f_RemoverSinalizador](@Bit028),
			@Bit029 = [dbo].[f_RemoverSinalizador](@Bit029), @Bit030 = [dbo].[f_RemoverSinalizador](@Bit030), @Bit031 = [dbo].[f_RemoverSinalizador](@Bit031), @Bit032 = [dbo].[f_RemoverSinalizador](@Bit032),
			@Bit033 = [dbo].[f_RemoverSinalizador](@Bit033), @Bit034 = [dbo].[f_RemoverSinalizador](@Bit034), @Bit035 = [dbo].[f_RemoverSinalizador](@Bit035), @Bit036 = [dbo].[f_RemoverSinalizador](@Bit036),
			@Bit037 = [dbo].[f_RemoverSinalizador](@Bit037), @Bit038 = [dbo].[f_RemoverSinalizador](@Bit038), @Bit039 = [dbo].[f_RemoverSinalizador](@Bit039), @Bit040 = [dbo].[f_RemoverSinalizador](@Bit040),
			@Bit041 = [dbo].[f_RemoverSinalizador](@Bit041), @Bit042 = [dbo].[f_RemoverSinalizador](@Bit042), @Bit043 = [dbo].[f_RemoverSinalizador](@Bit043), @Bit044 = [dbo].[f_RemoverSinalizador](@Bit044),
			@Bit045 = [dbo].[f_RemoverSinalizador](@Bit045), @Bit046 = [dbo].[f_RemoverSinalizador](@Bit046), @Bit047 = [dbo].[f_RemoverSinalizador](@Bit047), @Bit048 = [dbo].[f_RemoverSinalizador](@Bit048),
			@Bit049 = [dbo].[f_RemoverSinalizador](@Bit049), @Bit050 = [dbo].[f_RemoverSinalizador](@Bit050), @Bit051 = [dbo].[f_RemoverSinalizador](@Bit051), @Bit052 = [dbo].[f_RemoverSinalizador](@Bit052),
			@Bit053 = [dbo].[f_RemoverSinalizador](@Bit053), @Bit054 = [dbo].[f_RemoverSinalizador](@Bit054), @Bit055 = [dbo].[f_RemoverSinalizador](@Bit055), @Bit056 = [dbo].[f_RemoverSinalizador](@Bit056),
			@Bit057 = [dbo].[f_RemoverSinalizador](@Bit057), @Bit058 = [dbo].[f_RemoverSinalizador](@Bit058), @Bit059 = [dbo].[f_RemoverSinalizador](@Bit059), @Bit060 = [dbo].[f_RemoverSinalizador](@Bit060),
			@Bit061 = [dbo].[f_RemoverSinalizador](@Bit061), @Bit062 = [dbo].[f_RemoverSinalizador](@Bit062), @Bit063 = [dbo].[f_RemoverSinalizador](@Bit063), @Bit064 = [dbo].[f_RemoverSinalizador](@Bit064),
			@Bit065 = [dbo].[f_RemoverSinalizador](@Bit065), @Bit066 = [dbo].[f_RemoverSinalizador](@Bit066), @Bit067 = [dbo].[f_RemoverSinalizador](@Bit067), @Bit068 = [dbo].[f_RemoverSinalizador](@Bit068),
			@Bit069 = [dbo].[f_RemoverSinalizador](@Bit069), @Bit070 = [dbo].[f_RemoverSinalizador](@Bit070), @Bit071 = [dbo].[f_RemoverSinalizador](@Bit071), @Bit072 = [dbo].[f_RemoverSinalizador](@Bit072),
			@Bit073 = [dbo].[f_RemoverSinalizador](@Bit073), @Bit074 = [dbo].[f_RemoverSinalizador](@Bit074), @Bit075 = [dbo].[f_RemoverSinalizador](@Bit075), @Bit076 = [dbo].[f_RemoverSinalizador](@Bit076),
			@Bit077 = [dbo].[f_RemoverSinalizador](@Bit077), @Bit078 = [dbo].[f_RemoverSinalizador](@Bit078), @Bit079 = [dbo].[f_RemoverSinalizador](@Bit079), @Bit080 = [dbo].[f_RemoverSinalizador](@Bit080),
			@Bit081 = [dbo].[f_RemoverSinalizador](@Bit081), @Bit082 = [dbo].[f_RemoverSinalizador](@Bit082), @Bit083 = [dbo].[f_RemoverSinalizador](@Bit083), @Bit084 = [dbo].[f_RemoverSinalizador](@Bit084),
			@Bit085 = [dbo].[f_RemoverSinalizador](@Bit085), @Bit086 = [dbo].[f_RemoverSinalizador](@Bit086), @Bit087 = [dbo].[f_RemoverSinalizador](@Bit087), @Bit088 = [dbo].[f_RemoverSinalizador](@Bit088),
			@Bit089 = [dbo].[f_RemoverSinalizador](@Bit089), @Bit090 = [dbo].[f_RemoverSinalizador](@Bit090), @Bit091 = [dbo].[f_RemoverSinalizador](@Bit091), @Bit092 = [dbo].[f_RemoverSinalizador](@Bit092),
			@Bit093 = [dbo].[f_RemoverSinalizador](@Bit093), @Bit094 = [dbo].[f_RemoverSinalizador](@Bit094), @Bit095 = [dbo].[f_RemoverSinalizador](@Bit095), @Bit096 = [dbo].[f_RemoverSinalizador](@Bit096),
			@Bit097 = [dbo].[f_RemoverSinalizador](@Bit097), @Bit098 = [dbo].[f_RemoverSinalizador](@Bit098), @Bit099 = [dbo].[f_RemoverSinalizador](@Bit099), @Bit100 = [dbo].[f_RemoverSinalizador](@Bit100),
			@Bit101 = [dbo].[f_RemoverSinalizador](@Bit101), @Bit102 = [dbo].[f_RemoverSinalizador](@Bit102), @Bit103 = [dbo].[f_RemoverSinalizador](@Bit103), @Bit104 = [dbo].[f_RemoverSinalizador](@Bit104),
			@Bit105 = [dbo].[f_RemoverSinalizador](@Bit105), @Bit106 = [dbo].[f_RemoverSinalizador](@Bit106), @Bit107 = [dbo].[f_RemoverSinalizador](@Bit107), @Bit108 = [dbo].[f_RemoverSinalizador](@Bit108),
			@Bit109 = [dbo].[f_RemoverSinalizador](@Bit109), @Bit110 = [dbo].[f_RemoverSinalizador](@Bit110), @Bit111 = [dbo].[f_RemoverSinalizador](@Bit111), @Bit112 = [dbo].[f_RemoverSinalizador](@Bit112),
			@Bit113 = [dbo].[f_RemoverSinalizador](@Bit113), @Bit114 = [dbo].[f_RemoverSinalizador](@Bit114), @Bit115 = [dbo].[f_RemoverSinalizador](@Bit115), @Bit116 = [dbo].[f_RemoverSinalizador](@Bit116),
			@Bit117 = [dbo].[f_RemoverSinalizador](@Bit117), @Bit118 = [dbo].[f_RemoverSinalizador](@Bit118), @Bit119 = [dbo].[f_RemoverSinalizador](@Bit119), @Bit120 = [dbo].[f_RemoverSinalizador](@Bit120),
			@Bit121 = [dbo].[f_RemoverSinalizador](@Bit121), @Bit122 = [dbo].[f_RemoverSinalizador](@Bit122), @Bit123 = [dbo].[f_RemoverSinalizador](@Bit123), @Bit124 = [dbo].[f_RemoverSinalizador](@Bit124),
			@Bit125 = [dbo].[f_RemoverSinalizador](@Bit125), @Bit126 = [dbo].[f_RemoverSinalizador](@Bit126), @Bit127 = [dbo].[f_RemoverSinalizador](@Bit127), @Bit128 = [dbo].[f_RemoverSinalizador](@Bit128)

	DECLARE	@iRetorno			INT
			,@iEstCodigo		INT
			,@iRede				INT
			,@iCodigoAutSonda	INT
			,@dValor			DECIMAL(15,2)
			,@cTipoTerminal		VARCHAR(20)
			,@cNumeroCartao		CHAR(16)
			,@cBaseOrigem		CHAR(1)

	DECLARE @TB_Sonda24Horas TABLE (NsuHost			INT				NULL
									,Retorno		INT				NULL
									,Bit007			VARCHAR(1000)	NULL
									,Bit011			VARCHAR(1000)	NULL
									,Bit012			VARCHAR(1000)	NULL
									,Bit013			VARCHAR(1000)	NULL
									,Bit032			VARCHAR(1000)	NULL
									,Bit041			VARCHAR(1000)	NULL
									,Bit042			VARCHAR(1000)	NULL
									,Bit061			VARCHAR(1000)	NULL
									,Bit125			VARCHAR(1000)	NULL
									,Bit127			VARCHAR(1000)	NULL
									,Valor			DECIMAL(15,2)	NULL
									,NumeroCartao	CHAR(16)		NULL
									,BaseOrigem		CHAR(1)			NULL
									,DtInicioSonda	DATETIME		NULL
									,StatusSonda	CHAR(2)			NULL
									,NivelSonda		VARCHAR(10)		NULL
									,QtdSonda		INT				NULL)

	SET @iRetorno	= 1
	SET @iEstCodigo = 0
	SET @iRede		= 18

	/* INI: BUSCA CONVENIO */
	INSERT INTO @TB_Sonda24Horas
		SELECT	TOP 1
				NsuHost		= T.NsuHost
				,Retorno	= 0
				,Bit007		= LTRIM(RTRIM(T.DataHoraGMT)) -- T.DataLocal + T.HoraLocal
				,Bit011		= dbo.f_ZerosEsquerda(T.NsuLoja, 6)
				,Bit012		= T.HoraLocal
				,Bit013		= T.DataLocal
				,Bit032		= '000' + LEFT(T.NumeroCartao,6) + '00'
				,Bit041		= dbo.f_ZerosEsquerda(T.Terminal, 8)
				,Bit042		= dbo.f_ZerosEsquerda(T.Estabelecimento, 15)
				,Bit061		= T.TipoTerminal
				,Bit125		= dbo.f_ZerosEsquerda(T.NsuLoja, 6)
				,Bit127		= dbo.f_ZerosEsquerda(T.NsuHost, 9)
				,Valor		= T.Valor
				,NumeroCartao = T.NumeroCartao
				,BaseOrigem	= 'C' /* Convenio */
				,NULL
				,NULL
				,NULL
				,NULL
		FROM	  Policard_603078.dbo.Transacao_RegistroTEF T WITH(NOLOCK)
		WHERE	T.StatusTef				 = 'P'
				AND CONVERT(INT, T.Rede) = 18 /* REDE BANCO 24 HORAS */
				AND T.DataAutorizacao BETWEEN REPLACE(CONVERT(VARCHAR(10), GETDATE(), 120), '.', '-') + ' 00:00:00' AND DATEADD(s, -90, GETDATE())
				AND NOT EXISTS (SELECT 1 FROM ControleSonda WITH(NOLOCK) WHERE Nsu_Policard = T.NsuHost AND NumeroCartao = T.NumeroCartao AND Valor = T.Valor)
		ORDER BY T.NsuHost ASC
	/* FIM: BUSCA CONVENIO */

	SELECT @iRetorno = ISNULL(Retorno,1) FROM @TB_Sonda24Horas

	/* INI: BUSCA PROCESSADORA */
	IF (@iRetorno = 1)
	BEGIN
		declare @x char(1)
	END
	/* FIM: BUSCA PROCESSADORA */

	SELECT	@iCodigoAutSonda= NsuHost
			,@iRetorno		= Retorno
			,@Bit007		= Bit007
			,@Bit011		= Bit011
			,@Bit012		= Bit012
			,@Bit013		= Bit013
			,@Bit032		= Bit032
			,@Bit041		= Bit041
			,@Bit042		= Bit042
			,@Bit061		= Bit061
			,@Bit125		= Bit125
			,@Bit127		= Bit127
			,@dValor		= Valor
			,@cNumeroCartao	= NumeroCartao
			,@cBaseOrigem	= BaseOrigem
	FROM	@TB_Sonda24Horas

	IF (NOT EXISTS(SELECT 1 FROM @TB_Sonda24Horas))
		SET @iRetorno = 0

	IF (@iRetorno = 0)
	BEGIN
		IF (@iRede = 18) -- REDE BANCO 24 HORAS
		BEGIN
			IF (EXISTS(SELECT 1 FROM @TB_Sonda24Horas))
			BEGIN
				INSERT INTO ControleSonda
						(Nsu_Policard
						,CodigoMensagem
						,Valor
						,NumeroCartao
						,DataInicioSonda
						,BaseOrigem
						,NsuOrigem
						,Estabelecimento
						,SondaEnviada
						,NivelSonda
						,QtdSonda)
				VALUES( @Bit127
						,@Bit001
						,@dValor
						,@cNumeroCartao
						,GETDATE()
						,@cBaseOrigem
						,@Bit125
						,@Bit042
						,1
						,'T2'
						,1)
			END
			ELSE
			BEGIN
				DECLARE @dDataInicio	DATETIME
						,@dDataResp		DATETIME
						,@sNSUOrigem	VARCHAR(6)
						,@sNivelSonda	VARCHAR(10)
						,@cStatusSonda	CHAR(2)
						,@iQtdSonda		INT

				SET @iRetorno = 1

				INSERT INTO @TB_Sonda24Horas(NsuHost, DtInicioSonda, StatusSonda, NivelSonda, QtdSonda, BaseOrigem)
					SELECT	TOP 1
							NSU_Policard
							,DataInicioSonda
							,StatusSonda
							,NivelSonda
							,QtdSonda
							,BaseOrigem
					FROM	ControleSonda A WITH(NOLOCK)
					WHERE	NivelSonda IN ('T2','T3')
							AND QtdSonda < 5
					ORDER BY Codigo

				SELECT	@iCodigoAutSonda = NsuHost
						,@dDataInicio	 = DtInicioSonda
						,@cStatusSonda	 = StatusSonda
						,@sNivelSonda	 = NivelSonda
						,@iQtdSonda		 = QtdSonda
				FROM	@TB_Sonda24Horas

				IF (EXISTS(SELECT 1 FROM @TB_Sonda24Horas WHERE BaseOrigem = 'C'))
				BEGIN
					SELECT	@Bit007	 = LTRIM(RTRIM(TRT.DataHoraGMT))
							,@Bit011 = dbo.f_ZerosEsquerda(TRT.NsuLoja, 6)
							,@Bit012 = TRT.HoraLocal
							,@Bit013 = TRT.DataLocal
							,@Bit032 = '000' + LEFT(TRT.NumeroCartao,6) + '00'
							,@Bit041 = dbo.f_ZerosEsquerda(TRT.Terminal, 8)
							,@Bit042 = dbo.f_ZerosEsquerda(TRT.Estabelecimento, 15)
							,@Bit061 = TRT.TipoTerminal
							,@Bit125 = dbo.f_ZerosEsquerda(TRT.NsuLoja, 6)
							,@Bit127 = dbo.f_ZerosEsquerda(TRT.NsuHost, 9)
					FROM	@TB_Sonda24Horas T
							INNER JOIN   Policard_603078.dbo.Transacao_RegistroTEF TRT WITH(NOLOCK) ON (TRT.NsuHost = T.NsuHost)
					WHERE	T.NsuHost = @iCodigoAutSonda
				END

				IF ((@cStatusSonda IN ('09','77') OR @cStatusSonda IS NULL) AND @iQtdSonda > 0)
				BEGIN
					IF (@iQtdSonda = 4)
						SET @iRetorno = 1
					ELSE
					BEGIN
						IF (@iQtdSonda = 1 AND (DATEDIFF(mi, @dDataInicio, GETDATE()) BETWEEN 10 AND 14))
						BEGIN
							SET @iRetorno = 0
							UPDATE ControleSonda SET NivelSonda = 'T3', QtdSonda = @iQtdSonda + 1 WHERE Codigo = @iCodigoAutSonda
						END

						IF (@iQtdSonda = 2 AND (DATEDIFF(mi, @dDataInicio, GETDATE()) BETWEEN 20 AND 24))
						BEGIN
							SET @iRetorno = 0
							UPDATE ControleSonda SET QtdSonda = @iQtdSonda + 1 WHERE Codigo = @iCodigoAutSonda
						END

						IF (@iQtdSonda = 3 AND (DATEDIFF(mi, @dDataInicio, GETDATE()) BETWEEN 30 AND 34))
						BEGIN
							SET @iRetorno = 0
							UPDATE ControleSonda SET QtdSonda = @iQtdSonda + 1 WHERE Codigo = @iCodigoAutSonda
						END
					END
				END
			END
		END

		IF (@iRetorno = 0)
		BEGIN
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

			SELECT	@Bit001 = [dbo].[f_Inclui_Sinalizador](@Bit001), @Bit002 = [dbo].[f_Inclui_Sinalizador](@Bit002), @Bit003 = [dbo].[f_Inclui_Sinalizador](@Bit003), @Bit004 = [dbo].[f_Inclui_Sinalizador](@Bit004),
					@Bit005 = [dbo].[f_Inclui_Sinalizador](@Bit005), @Bit006 = [dbo].[f_Inclui_Sinalizador](@Bit006), @Bit007 = [dbo].[f_Inclui_Sinalizador](@Bit007), @Bit008 = [dbo].[f_Inclui_Sinalizador](@Bit008),
					@Bit009 = [dbo].[f_Inclui_Sinalizador](@Bit009), @Bit010 = [dbo].[f_Inclui_Sinalizador](@Bit010), @Bit011 = [dbo].[f_Inclui_Sinalizador](@Bit011), @Bit012 = [dbo].[f_Inclui_Sinalizador](@Bit012),
					@Bit013 = [dbo].[f_Inclui_Sinalizador](@Bit013), @Bit014 = [dbo].[f_Inclui_Sinalizador](@Bit014), @Bit015 = [dbo].[f_Inclui_Sinalizador](@Bit015), @Bit016 = [dbo].[f_Inclui_Sinalizador](@Bit016),
					@Bit017 = [dbo].[f_Inclui_Sinalizador](@Bit017), @Bit018 = [dbo].[f_Inclui_Sinalizador](@Bit018), @Bit019 = [dbo].[f_Inclui_Sinalizador](@Bit019), @Bit020 = [dbo].[f_Inclui_Sinalizador](@Bit020),
					@Bit021 = [dbo].[f_Inclui_Sinalizador](@Bit021), @Bit022 = [dbo].[f_Inclui_Sinalizador](@Bit022), @Bit023 = [dbo].[f_Inclui_Sinalizador](@Bit023), @Bit024 = [dbo].[f_Inclui_Sinalizador](@Bit024),
					@Bit025 = [dbo].[f_Inclui_Sinalizador](@Bit025), @Bit026 = [dbo].[f_Inclui_Sinalizador](@Bit026), @Bit027 = [dbo].[f_Inclui_Sinalizador](@Bit027), @Bit028 = [dbo].[f_Inclui_Sinalizador](@Bit028),
					@Bit029 = [dbo].[f_Inclui_Sinalizador](@Bit029), @Bit030 = [dbo].[f_Inclui_Sinalizador](@Bit030), @Bit031 = [dbo].[f_Inclui_Sinalizador](@Bit031), @Bit032 = [dbo].[f_Inclui_Sinalizador](@Bit032),
					@Bit033 = [dbo].[f_Inclui_Sinalizador](@Bit033), @Bit034 = [dbo].[f_Inclui_Sinalizador](@Bit034), @Bit035 = [dbo].[f_Inclui_Sinalizador](@Bit035), @Bit036 = [dbo].[f_Inclui_Sinalizador](@Bit036),
					@Bit037 = [dbo].[f_Inclui_Sinalizador](@Bit037), @Bit038 = [dbo].[f_Inclui_Sinalizador](@Bit038), @Bit039 = [dbo].[f_Inclui_Sinalizador](@Bit039), @Bit040 = [dbo].[f_Inclui_Sinalizador](@Bit040),
					@Bit041 = [dbo].[f_Inclui_Sinalizador](@Bit041), @Bit042 = [dbo].[f_Inclui_Sinalizador](@Bit042), @Bit043 = [dbo].[f_Inclui_Sinalizador](@Bit043), @Bit044 = [dbo].[f_Inclui_Sinalizador](@Bit044),
					@Bit045 = [dbo].[f_Inclui_Sinalizador](@Bit045), @Bit046 = [dbo].[f_Inclui_Sinalizador](@Bit046), @Bit047 = [dbo].[f_Inclui_Sinalizador](@Bit047), @Bit048 = [dbo].[f_Inclui_Sinalizador](@Bit048),
					@Bit049 = [dbo].[f_Inclui_Sinalizador](@Bit049), @Bit050 = [dbo].[f_Inclui_Sinalizador](@Bit050), @Bit051 = [dbo].[f_Inclui_Sinalizador](@Bit051), @Bit052 = [dbo].[f_Inclui_Sinalizador](@Bit052),
					@Bit053 = [dbo].[f_Inclui_Sinalizador](@Bit053), @Bit054 = [dbo].[f_Inclui_Sinalizador](@Bit054), @Bit055 = [dbo].[f_Inclui_Sinalizador](@Bit055), @Bit056 = [dbo].[f_Inclui_Sinalizador](@Bit056),
					@Bit057 = [dbo].[f_Inclui_Sinalizador](@Bit057), @Bit058 = [dbo].[f_Inclui_Sinalizador](@Bit058), @Bit059 = [dbo].[f_Inclui_Sinalizador](@Bit059), @Bit060 = [dbo].[f_Inclui_Sinalizador](@Bit060),
					@Bit061 = [dbo].[f_Inclui_Sinalizador](@Bit061), @Bit062 = [dbo].[f_Inclui_Sinalizador](@Bit062), @Bit063 = [dbo].[f_Inclui_Sinalizador](@Bit063), @Bit064 = [dbo].[f_Inclui_Sinalizador](@Bit064),
					@Bit065 = [dbo].[f_Inclui_Sinalizador](@Bit065), @Bit066 = [dbo].[f_Inclui_Sinalizador](@Bit066), @Bit067 = [dbo].[f_Inclui_Sinalizador](@Bit067), @Bit068 = [dbo].[f_Inclui_Sinalizador](@Bit068),
					@Bit069 = [dbo].[f_Inclui_Sinalizador](@Bit069), @Bit070 = [dbo].[f_Inclui_Sinalizador](@Bit070), @Bit071 = [dbo].[f_Inclui_Sinalizador](@Bit071), @Bit072 = [dbo].[f_Inclui_Sinalizador](@Bit072),
					@Bit073 = [dbo].[f_Inclui_Sinalizador](@Bit073), @Bit074 = [dbo].[f_Inclui_Sinalizador](@Bit074), @Bit075 = [dbo].[f_Inclui_Sinalizador](@Bit075), @Bit076 = [dbo].[f_Inclui_Sinalizador](@Bit076),
					@Bit077 = [dbo].[f_Inclui_Sinalizador](@Bit077), @Bit078 = [dbo].[f_Inclui_Sinalizador](@Bit078), @Bit079 = [dbo].[f_Inclui_Sinalizador](@Bit079), @Bit080 = [dbo].[f_Inclui_Sinalizador](@Bit080),
					@Bit081 = [dbo].[f_Inclui_Sinalizador](@Bit081), @Bit082 = [dbo].[f_Inclui_Sinalizador](@Bit082), @Bit083 = [dbo].[f_Inclui_Sinalizador](@Bit083), @Bit084 = [dbo].[f_Inclui_Sinalizador](@Bit084),
					@Bit085 = [dbo].[f_Inclui_Sinalizador](@Bit085), @Bit086 = [dbo].[f_Inclui_Sinalizador](@Bit086), @Bit087 = [dbo].[f_Inclui_Sinalizador](@Bit087), @Bit088 = [dbo].[f_Inclui_Sinalizador](@Bit088),
					@Bit089 = [dbo].[f_Inclui_Sinalizador](@Bit089), @Bit090 = [dbo].[f_Inclui_Sinalizador](@Bit090), @Bit091 = [dbo].[f_Inclui_Sinalizador](@Bit091), @Bit092 = [dbo].[f_Inclui_Sinalizador](@Bit092),
					@Bit093 = [dbo].[f_Inclui_Sinalizador](@Bit093), @Bit094 = [dbo].[f_Inclui_Sinalizador](@Bit094), @Bit095 = [dbo].[f_Inclui_Sinalizador](@Bit095), @Bit096 = [dbo].[f_Inclui_Sinalizador](@Bit096),
					@Bit097 = [dbo].[f_Inclui_Sinalizador](@Bit097), @Bit098 = [dbo].[f_Inclui_Sinalizador](@Bit098), @Bit099 = [dbo].[f_Inclui_Sinalizador](@Bit099), @Bit100 = [dbo].[f_Inclui_Sinalizador](@Bit100),
					@Bit101 = [dbo].[f_Inclui_Sinalizador](@Bit101), @Bit102 = [dbo].[f_Inclui_Sinalizador](@Bit102), @Bit103 = [dbo].[f_Inclui_Sinalizador](@Bit103), @Bit104 = [dbo].[f_Inclui_Sinalizador](@Bit104),
					@Bit105 = [dbo].[f_Inclui_Sinalizador](@Bit105), @Bit106 = [dbo].[f_Inclui_Sinalizador](@Bit106), @Bit107 = [dbo].[f_Inclui_Sinalizador](@Bit107), @Bit108 = [dbo].[f_Inclui_Sinalizador](@Bit108),
					@Bit109 = [dbo].[f_Inclui_Sinalizador](@Bit109), @Bit110 = [dbo].[f_Inclui_Sinalizador](@Bit110), @Bit111 = [dbo].[f_Inclui_Sinalizador](@Bit111), @Bit112 = [dbo].[f_Inclui_Sinalizador](@Bit112),
					@Bit113 = [dbo].[f_Inclui_Sinalizador](@Bit113), @Bit114 = [dbo].[f_Inclui_Sinalizador](@Bit114), @Bit115 = [dbo].[f_Inclui_Sinalizador](@Bit115), @Bit116 = [dbo].[f_Inclui_Sinalizador](@Bit116),
					@Bit117 = [dbo].[f_Inclui_Sinalizador](@Bit117), @Bit118 = [dbo].[f_Inclui_Sinalizador](@Bit118), @Bit119 = [dbo].[f_Inclui_Sinalizador](@Bit119), @Bit120 = [dbo].[f_Inclui_Sinalizador](@Bit120),
					@Bit121 = [dbo].[f_Inclui_Sinalizador](@Bit121), @Bit122 = [dbo].[f_Inclui_Sinalizador](@Bit122), @Bit123 = [dbo].[f_Inclui_Sinalizador](@Bit123), @Bit124 = [dbo].[f_Inclui_Sinalizador](@Bit124),
					@Bit125 = [dbo].[f_Inclui_Sinalizador](@Bit125), @Bit126 = [dbo].[f_Inclui_Sinalizador](@Bit126), @Bit127 = [dbo].[f_Inclui_Sinalizador](@Bit127), @Bit128 = [dbo].[f_Inclui_Sinalizador](@Bit128)
		END
	END

	RETURN @iRetorno
END






