/*------------------------------------------------------------------------
Nome Sistema: Processadora
Objeto: PR_CRT_GeraSenhaCartao
Propósito: Procedure responsável pela geração da  senha cartão
Autor: Adriano Dutra.
--------------------------------------------------------------------------
Data Criação: 07/07/2017
CH:363845
-------------------------------------------------------------------------- 
Data alteração: 12/07/2017
CH:395871/3033
-------------------------------------------------------------------------- 
Data alteração: 18/08/2017
CH: 413604
--------------------------------------------------------------------------
*/

CREATE PROCEDURE PR_CRT_GeraSenhaCartao(
	 @TpoPrdCodigo AS INT
	,@CodSenha AS CHAR(16) OUTPUT
	)
AS
BEGIN

	DECLARE @TamanhoSenha INT
		   ,@QTD NUMERIC(16)

	IF (@TpoPrdCodigo IS NOT NULL)
	BEGIN 
		SELECT @TamanhoSenha = TP.TamanhoSenha 
		FROM processadora.dbo.TiposProdutos TP WITH (NOLOCK) 
		WHERE TP.TpoPrdCodigo = @TpoPrdCodigo
	END 
   
	SET @TamanhoSenha = ISNULL(@TamanhoSenha,4)
   
	IF (@CodSenha IS NULL OR @CodSenha = '0000000000000000')
    BEGIN
		SET @QTD = CONVERT(NUMERIC(16),RIGHT(REPLICATE('9',@TamanhoSenha),16))
		SET @CodSenha = RIGHT(REPLICATE('0',16) + RTRIM(LTRIM(CONVERT(NUMERIC(16), RAND() * @QTD + 1))),16)
	END

	IF (LEN(@CodSenha) < 16)
		SET @CodSenha = REPLICATE('0', 16 - LEN(@CodSenha)) + @CodSenha

	EXEC dbo.pr_EncriptaSenhaPolicard @CodSenha OUT
	SET @CodSenha = @CodSenha

END


  
 