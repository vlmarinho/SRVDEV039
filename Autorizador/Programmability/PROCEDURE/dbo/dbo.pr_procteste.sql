
/* 
--====================================================================== 
Autor:  Cristiano Silva Barbosa 
Data de Criação: 27/04/2017 
Chamado: 313169 
--====================================================================== 
--Ch.:313169 
--====================================================================== 

Autor:  Luismar Ferreira
Data de Criação: 06/04/2021
Chamado: 1671979
ordenar corretamente a insercao de saldo nas tabelas ContasUsuarios e CartoesUsuarios, mover update para dentro do if
--====================================================================== 

*/ 
 
CREATE PROCEDURE [dbo].[pr_AtualizarCreditoDisponivel] 
	 @iCrtUsrCodigo		 INT 
	,@iCntUsrCodigo		 INT 
	,@cTipoCartao		 CHAR(1) 
	,@nValorTransacao	 MONEY 
	,@iQuantParcelas	 INT 
	,@iTpoPrdCodigo		 INT 
	,@iTpoTrnCodigo		 INT 
	,@cTipoTransacao	 CHAR(1) 
	,@iLimiteExtraCartao INT 
	,@iTrnCodigo		 INT 
	,@iTpoLncCodigo		 INT 
AS 
BEGIN 


			----------- texto para facilitar teste em densovolvimento: Luismar 2021-04-08
			----------declare	@iCrtUsrCodigo		 INT = 3376474
			----------declare	@iCntUsrCodigo		 INT =  2891911
			----------declare	@cTipoCartao		 CHAR(1)  = null
			----------declare	@nValorTransacao	 MONEY = 18.00
			----------declare	@iQuantParcelas	     INT = 1
			----------declare	@iTpoPrdCodigo		 INT = 59
			----------declare	@iTpoTrnCodigo		 INT = null
			----------declare	@cTipoTransacao	    CHAR(1) ='D'
			----------declare	@iLimiteExtraCartao INT = null
			----------declare	@iTrnCodigo			INT = 0
			----------declare	@iTpoLncCodigo		INT = 769  

			----------769	SAQUE BCO 24 HS  ==> @cTipoTransacao = D , sinal positivo
			----------495	Adiantamento Frete  ==> @cTipoTransacao = C, sinal positivo
			----------492	Transferência de Créditos entre Contas ==> @cTipoTransacao = C, sinal positivo
 



 
	DECLARE @nValorLancamento	MONEY 
			,@iFtrUsrCodigo		INT 
 
	SET @nValorLancamento = @nValorTransacao 
 
	/* *********************************************************/ 
	/* INI: PROCESSAMENTO DE ATUALIZAÇÃO DE CREDITO DISPONIVEL */ 
	/* *********************************************************/ 
	 
	IF (@cTipoTransacao = 'C') /* D = DESFAZIMENTO -- C = ESTORNO */ 
	BEGIN 
		IF (@nValorTransacao > 0) 
			SET @nValorTransacao = @nValorTransacao * -1 
	END 
 
				---------------------------------------------
				----------UPDATE	CO 
				----------SET	CO.CreditoDisponivel = CO.CreditoDisponivel - @nValorTransacao 
				----------FROM Autorizacao.dbo.ContasUsuarios CO WITH(HOLDLOCK, ROWLOCK) 
				----------WHERE CO.CntUsrCodigo = @iCntUsrCodigo 
 
				----------UPDATE CA 
				----------SET	CA.CreditoDisponivel = CO.CreditoDisponivel 
				----------FROM Autorizacao.dbo.CartoesUsuarios CA WITH(HOLDLOCK, ROWLOCK) 
				----------INNER JOIN Autorizacao.dbo.ContasUsuarios CO WITH(NOLOCK) ON (CO.CntUsrCodigo = CA.CntUsrCodigo AND CO.CntUsrCodigo = @iCntUsrCodigo) 
				----------WHERE CA.Status <> 'C' 
	 
				----------UPDATE	CO 
				----------SET	CO.CreditoDisponivel = CO.CreditoDisponivel - @nValorTransacao 
				----------FROM Processadora.dbo.ContasUsuarios CO WITH(HOLDLOCK, ROWLOCK) 
				----------WHERE CO.CntUsrCodigo = @iCntUsrCodigo 
 
				----------UPDATE	CA 
				----------SET	CA.CreditoDisponivel = CO.CreditoDisponivel 
				----------FROM Processadora.dbo.CartoesUsuarios CA WITH(HOLDLOCK, ROWLOCK) 
				----------INNER JOIN Processadora.dbo.ContasUsuarios CO WITH(HOLDLOCK, ROWLOCK) ON (CO.CntUsrCodigo = CA.CntUsrCodigo AND CO.CntUsrCodigo = @iCntUsrCodigo) 
				----------WHERE CA.Status <> 'C' 
	 
				----------/* *********************************************************/ 
				----------/* FIM: PROCESSAMENTO DE ATUALIZAÇÃO DE CREDITO DISPONIVEL */ 
				----------/* *********************************************************/ 

	 
	IF (@iTpoPrdCodigo <> 59) 
		BEGIN 
 


 			-----------------------------------
			UPDATE	CO 
			SET	CO.CreditoDisponivel = CO.CreditoDisponivel - @nValorTransacao 
			FROM Autorizacao.dbo.ContasUsuarios CO WITH(HOLDLOCK, ROWLOCK) 
			WHERE CO.CntUsrCodigo = @iCntUsrCodigo 
 
			UPDATE CA 
			SET	CA.CreditoDisponivel = CO.CreditoDisponivel 
			FROM Autorizacao.dbo.CartoesUsuarios CA WITH(HOLDLOCK, ROWLOCK) 
			INNER JOIN Autorizacao.dbo.ContasUsuarios CO WITH(NOLOCK) ON (CO.CntUsrCodigo = CA.CntUsrCodigo AND CO.CntUsrCodigo = @iCntUsrCodigo) 
			WHERE CA.Status <> 'C' 
	 
			UPDATE	CO 
			SET	CO.CreditoDisponivel = CO.CreditoDisponivel - @nValorTransacao 
			FROM Processadora.dbo.ContasUsuarios CO WITH(HOLDLOCK, ROWLOCK) 
			WHERE CO.CntUsrCodigo = @iCntUsrCodigo 
 
			UPDATE	CA 
			SET	CA.CreditoDisponivel = CO.CreditoDisponivel 
			FROM Processadora.dbo.CartoesUsuarios CA WITH(HOLDLOCK, ROWLOCK) 
			INNER JOIN Processadora.dbo.ContasUsuarios CO WITH(HOLDLOCK, ROWLOCK) ON (CO.CntUsrCodigo = CA.CntUsrCodigo AND CO.CntUsrCodigo = @iCntUsrCodigo) 
			WHERE CA.Status <> 'C' 
	 
			/* *********************************************************/ 
			/* FIM: PROCESSAMENTO DE ATUALIZAÇÃO DE CREDITO DISPONIVEL */ 
			/* *********************************************************/ 




			/* *********************************************************/ 
			/*  INÍCIO: INSERIR REGISTROS NA CONTA CORRENTE DO USUÁRIO */ 
			/* *********************************************************/ 
			INSERT INTO Processadora.dbo.ContasCorrentesUsuarios( 
				 CrtUsrCodigo 
				,CntUsrCodigo 
				,TpoPrdCodigo 
				,DataMovimento 
				,Valor 
				,Saldo 
				,TrnCodigo 
				,Estornado 
				,TpoLncCodigo) 
			SELECT	C.CrtUsrCodigo 
				,C.CntUsrCodigo 
				,C.TpoPrdCodigo 
				,GETDATE() 
				,@nValorLancamento 
				,CO.CreditoDisponivel 
				,@iTrnCodigo 
				,'N' 
				,@iTpoLncCodigo 
			FROM Processadora.dbo.CartoesUsuarios C WITH(HOLDLOCK, ROWLOCK) 
			INNER JOIN Processadora.dbo.ContasUsuarios CO WITH(HOLDLOCK, ROWLOCK) ON (CO.CntUsrCodigo = C.CntUsrCodigo) 
			WHERE CO.CntUsrCodigo = @iCntUsrCodigo 
			AND C.CrtUsrCodigo = @iCrtUsrCodigo 
			/* *********************************************************/ 
			/* FIM: INSERIR RETISTROS NA CONTATO CORRENTE DO USUÁRIO   */ 
			/* *********************************************************/ 
		END 

	ELSE 

		BEGIN 
 


			     EXEC Processadora.dbo.Pr_Proc_RetornaUltimaFatura @iCntUsrCodigo, @iFtrUsrCodigo OUTPUT 
		 

		 		  -----------------------------------
					UPDATE	CO 
					SET	CO.CreditoDisponivel = CO.CreditoDisponivel - @nValorTransacao 
					FROM Autorizacao.dbo.ContasUsuarios CO WITH(HOLDLOCK, ROWLOCK) 
					WHERE CO.CntUsrCodigo = @iCntUsrCodigo 
 
					UPDATE CA 
					SET	CA.CreditoDisponivel = CO.CreditoDisponivel 
					FROM Autorizacao.dbo.CartoesUsuarios CA WITH(HOLDLOCK, ROWLOCK) 
					INNER JOIN Autorizacao.dbo.ContasUsuarios CO WITH(NOLOCK) ON (CO.CntUsrCodigo = CA.CntUsrCodigo AND CO.CntUsrCodigo = @iCntUsrCodigo) 
					WHERE CA.Status <> 'C' 
	 
					UPDATE	CO 
					SET	CO.CreditoDisponivel = CO.CreditoDisponivel - @nValorTransacao 
					FROM Processadora.dbo.ContasUsuarios CO WITH(HOLDLOCK, ROWLOCK) 
					WHERE CO.CntUsrCodigo = @iCntUsrCodigo 
 
					UPDATE	CA 
					SET	CA.CreditoDisponivel = CO.CreditoDisponivel 
					FROM Processadora.dbo.CartoesUsuarios CA WITH(HOLDLOCK, ROWLOCK) 
					INNER JOIN Processadora.dbo.ContasUsuarios CO WITH(HOLDLOCK, ROWLOCK) ON (CO.CntUsrCodigo = CA.CntUsrCodigo AND CO.CntUsrCodigo = @iCntUsrCodigo) 
					WHERE CA.Status <> 'C' 
	 
					/* *********************************************************/ 
					/* FIM: PROCESSAMENTO DE ATUALIZAÇÃO DE CREDITO DISPONIVEL */ 
					/* *********************************************************/ 

			IF (@iFtrUsrCodigo > 0) 
				BEGIN
					EXEC Processadora.dbo.[pr_PROC_LancamentoFaturasTransacao] @iCntUsrCodigo, @nValorLancamento, @iTpoLncCodigo, @iTrnCodigo, 'AUTORIZADOR' 
		  	    end
	 
	END 
END 
