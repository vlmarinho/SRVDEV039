/*
=====================================================================
Projeto: Notificação via APP
Descrição: Procedure utilizada para enviar nofitificação via APP
Autor:	Arnaldo oliveira dos Santos
Data Criacao: 24/10/2017
Chamado/Mudança: 398936/3346
=====================================================================
*/

CREATE PROCEDURE dbo.pr_EnviarPushAppCredito (
@CntCrrUsrCodigo int )
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE  
		 @sUrl						VARCHAR(100)
		,@sNumeroCartao				VARCHAR(16)
		,@sDescricao				VARCHAR(50)
		,@cTipo						CHAR(1)
		,@sRamoAtividade			VARCHAR(10)
		,@sCntAppCodigo				VARCHAR(10)
		,@sCodigoEstabelecimento	VARCHAR(10)
		,@sHttpMethod				VARCHAR(10)
		,@sParamsValues				VARCHAR(MAX)
		,@sAction					VARCHAR(1024)
		,@sMetodo					VARCHAR(1024)
		,@sCPF					VARCHAR(18)
		,@sAuxiliar					VARCHAR(MAX)
		,@sRetorno					VARCHAR(MAX)
		,@iRetorno					INT
		,@iCrtUsrCodigo				varchar(20)
		,@resultado					VARCHAR(16)
		,@sDataTransacao			VARCHAR(20)
		,@sValorTransacao			VARCHAR(15)
		,@cTipoMensagem				CHAR(4)
		,@bEnviaPush				Bit

	SET @sDescricao = ''
	SET @cTipo = ''
	SET @bEnviaPush=0


				SELECT	@sNumeroCartao = C.NUMERO
						,@iCrtUsrCodigo = C.CrtUsrCodigo
						,@sRamoAtividade = 142
						,@sCodigoEstabelecimento = 0
						,@sDataTransacao = CONVERT(VARCHAR(20),T.DataMovimento,120)
						,@sValorTransacao	= REPLACE (T.Valor,',','.')
						,@sDescricao = 'Credito'
						,@cTipo = 'C'
						,@sCPF	=C.CPF	 
		FROM Processadora.dbo.ContasCorrentesUsuarios T WITH(NOLOCK) 
		INNER JOIN Processadora.dbo.CartoesUsuarios C WITH(NOLOCK) ON T.CrtUsrCodigo = C.CrtUsrCodigo
		WHERE T.CntCrrUsrCodigo = @CntCrrUsrCodigo


		SELECT @sCntAppCodigo = uc.usrcntcodigo
			 ,@bEnviaPush = 1
		  FROM [Usuarios].[dbo].[UsuariosControles] uc with (NOLOCK)
		  INNER JOIN [Usuarios].[dbo].[UsuariosControlesSistemas] us with (NOLOCK) ON uc.UsrCntCodigo = us.UsrCntCodigo
		  INNER JOIN [Notificacao].[dbo].UserDevice ud with (NOLOCK) ON ud.UserId = uc.UsrCntCodigo
		  INNER JOIN [Notificacao].[dbo].UserProfile  up with (NOLOCK) ON up.UserId = ud.UserId
		  WHERE us.SstCodigo = 57
		  AND ud.Status = 1
		  AND up.AcceptTerms = 1
		  AND uc.CPF IN (@sCPF, REPLACE(REPLACE (@sCPF,'.',''),'-',''))



	IF @bEnviaPush=1
	BEGIN
	
		SET @sHttpMethod = 'POST'
		SET @sUrl = 'https://wssapp.policard.com.br/api/notification/transaction/v3'
		SET @sAuxiliar = 'Q0ExRDgyRkQwQzc1NzRENTJFNjk2MUI0QzA0QzA3OUI'
	
		SET @sParamsValues = '[{ "usrCntCodigo": '+  @sCntAppCodigo + ' , "cartao": "'+ @sNumeroCartao +'" , "descricao": "' + @sDescricao +'" , "tipo": "' + 
								@cTipo +'", "codRamoAtividade": ' + @sRamoAtividade +', "codEstabelecimento": '+ @sCodigoEstabelecimento +', "dataLancamento": "' + 
								@sDataTransacao +'", "valor": ' + @sValorTransacao + '}]'
	Print @sParamsValues
		EXEC Autorizador.dbo.[pr_Aut_RequestHttpWebService] @sUrl, @sHttpMethod, @sParamsValues, @sAction, @sMetodo, @resultado, @sAuxiliar OUTPUT, @sRetorno OUTPUT, @iRetorno OUTPUT

	print @iRetorno
	
	END
END