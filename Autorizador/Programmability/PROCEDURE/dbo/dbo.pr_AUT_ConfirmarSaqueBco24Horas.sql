
/*
--------------------------------------------------------------------------
Nome Sistema: Autorização
Objeto: [dbo].[pr_AUT_ConfirmarSaqueBco24Horas]
Propósito: Procedure responsável por confirmar transacoes banco 24 horas.
Autor: Cristiano Silva - Tecnologia Policard
--------------------------------------------------------------------------
Author:		Cristiano Barbosa
Data: 19/02/2017
Mud/CH.:  2601
===================================================================
*/


CREATE PROCEDURE [pr_AUT_ConfirmarSaqueBco24Horas]
	 @sBit001	VARCHAR(4)
	,@sBit003	VARCHAR(6)
	,@sBit004	VARCHAR(12)
	,@sBit007	VARCHAR(10)
	,@sBit011	VARCHAR(6)
	,@sBit022	VARCHAR(3)
	,@sBit032	VARCHAR(11)
	,@sBit039	VARCHAR(2)
	,@sBit041	VARCHAR(8)
	,@sBit042	VARCHAR(15)
	,@sBit049	VARCHAR(3)
	,@sBit061	VARCHAR(8)
	,@sBit127	VARCHAR(9)
	
AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE  @cStatusSaque		CHAR(1)
			,@dValorTransacao	DECIMAL (15,2)
			,@iCodigoSaque		INT
			,@iFlagIdent		INT
			,@cOrigem			CHAR(1)
			,@iNSUHost			INT
			,@dDataTransacao	DATETIME
			,@iStatusSaque		INT
			,@cStatusTransacao	CHAR(1)
			,@iResposta			INT
			,@cComprovante		CHAR(6)

	SELECT @iResposta = 0
		,@dDataTransacao  = GETDATE()
		,@dValorTransacao = CASE WHEN @sBit004 = '' THEN 0 ELSE CONVERT(DECIMAL(15, 2), @sBit004) / 100 END
		,@iFlagIdent = 0
		,@cComprovante = RIGHT(@sBit127,6)

	SELECT	 @iFlagIdent		= 1
			,@iNSUHost			= TRT.NsuHost
			,@cOrigem			= 'C' -- Transacao Convenio
			,@iCodigoSaque		= TRT.Codigo_Referencia
	FROM	  Policard_603078.dbo.Transacao_RegistroTEF TRT WITH(NOLOCK)
	WHERE	TRT.NsuLoja			= @sBit011
		AND TRT.Tabela	= 'S'
		AND TRT.Terminal = @sBit041
		AND TRT.Valor = @dValorTransacao
		AND CONVERT (BIGINT,TRT.Comprovante_FormGen) = CONVERT(BIGINT, @sBit127)
		AND CONVERT (VARCHAR(10),TRT.DataAutorizacao, 120) = CONVERT (VARCHAR(10),GETDATE(),120) /* Somente transacoes do dia corrente */

	IF (@iFlagIdent = 1 AND @cOrigem = 'C')
	BEGIN

		SET @iStatusSaque = CASE WHEN @sBit039 = '00' THEN 11 ELSE 1 END
		SET @cStatusTransacao = CASE WHEN @sBit039 = '00' THEN 'A' ELSE 'D' END
		
		INSERT INTO   [SAQUE].[DBO].[HISTORICOSSAQUE] ( [DATAHISTORICO], [SAQUECODIGO], [STATUSSAQUECODIGO], [RESPONSAVEL] ) VALUES ( @dDataTransacao, @iCodigoSaque, @iStatusSaque, 'BCO24HORAS')

		UPDATE   Policard_603078.dbo.Transacao_RegistroTEF SET StatusTef = @cStatusTransacao WHERE NsuHost = @iNSUHost AND StatusTef = 'P'

	END
	ELSE
	--IF (@iFlagIdent = 1 AND @cOrigem = 'P')
	BEGIN

		DECLARE  @iHistoricoSaque	INT
				,@iTrnCodigoSaque	INT
				,@sNSUPolicard		VARCHAR(9)
				,@sNumeroCartao		VARCHAR(16)
				,@iCntUsrCodigo		INT
				,@iCrtUsrCodigo		INT
				,@iEstabelecimento	INT
			
		SELECT @iHistoricoSaque = 0
			  ,@iTrnCodigoSaque = 0
			
		SELECT	 @iTrnCodigoSaque	= T.TrnCodigo
				,@sNSUPolicard		= T.Comprovante
				,@iEstabelecimento	= T.CodEstab
				,@sNumeroCartao		= CU.Numero
				,@iCntUsrCodigo		= CU.CntUsrCodigo
				,@iCrtUsrCodigo		= CU.CrtUsrCodigo
		FROM	Processadora.dbo.Transacoes T WITH(NOLOCK)
		INNER JOIN Processadora.dbo.CartoesUsuarios CU WITH (NOLOCK) ON T.CrtUsrCodigo = CU.CrtUsrCodigo
		WHERE	T.Comprovante	= @cComprovante
			AND T.NSUOrigem		= @sBit011
			AND T.TpoTrnCodigo	= '350000'
			AND T.Valor			= @dValorTransacao
			AND T.Status		= 'P'
			AND CONVERT (VARCHAR(10),T.DataAutorizacao, 120) = CONVERT (VARCHAR(10),GETDATE(),120) /* Somente transacoes do dia corrente */


		IF @iTrnCodigoSaque > 0
		BEGIN

			IF (@sBit039 = '00')
			BEGIN

				UPDATE Processadora.dbo.Transacoes SET Status = 'A' WHERE TrnCodigo = @iTrnCodigoSaque AND Status = 'P'
				UPDATE TransacoesRegistro SET StatusTef = 'A' WHERE TrnCodigo = @iTrnCodigoSaque AND StatusTef = 'P'
				
			END
			ELSE
			BEGIN
				
				EXEC pr_AUT_CancelaSaqueBco24Horas
					 @iTrnCodigoSaque
					,@sNumeroCartao
					,@dValorTransacao
					,@dDataTransacao
					,@iEstabelecimento
					,@sBit041
					,@iResposta		OUTPUT

				IF (@iResposta = 0)
				BEGIN

					UPDATE TransacoesRegistro SET StatusTef = 'E' WHERE TrnCodigo = @iTrnCodigoSaque
					
					SELECT @iHistoricoSaque = MAX(Codigo)
					FROM 
						Processadora.dbo.HistoricoSaldoExtratoBanco24Hrs WITH (NOLOCK)
					WHERE TipoOperacao = 'S' 
						AND CntUsrCodigo = @iCntUsrCodigo 
						AND CrtUsrCodigo = @iCrtUsrCodigo
						AND DataConsulta > CAST(FLOOR(CAST(GETDATE() AS FLOAT)) AS DATETIME)
					
					IF @iHistoricoSaque > 0
						DELETE FROM Processadora.dbo.HistoricoSaldoExtratoBanco24Hrs WHERE codigo = @iHistoricoSaque

				END
			END
		END
	END
END



