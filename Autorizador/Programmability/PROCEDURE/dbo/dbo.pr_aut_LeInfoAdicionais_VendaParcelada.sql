-- =============================================
-- Author:		Cristiano Silva Barbosa
--Data criação: 19/02/2017
--Mudança: 2601
-- =============================================



CREATE PROCEDURE [pr_aut_LeInfoAdicionais_VendaParcelada] 
(
	 @Bit048				VARCHAR(1000)
	,@iTipoFinanciamento	INT			OUTPUT
    ,@iQuantParcelas		INT			OUTPUT
    ,@dDataPrimeiraParcela	DATETIME	OUTPUT
)
AS
BEGIN
    DECLARE 
		 @iTamanho	INT
		,@strAux	VARCHAR(1000)
		,@indice	INT
	
	IF @Bit048 IS NULL 
	BEGIN

		RETURN 

	END ELSE
	BEGIN

		IF (LEN(@Bit048) > 0 )
		BEGIN
			SELECT @strAux = S.CAMPO
			  FROM dbo.splitString ('*',@Bit048) S
			 WHERE S.CAMPO <> ''
			   AND S.CAMPO LIKE 'VPS%'
   
			SET @iTamanho = CONVERT(INT,SUBSTRING(@strAux, 4, 3)) 
			
			IF (@iTamanho = 11)-- Tipo de CDC
				SET @dDataPrimeiraParcela = CONVERT(DATETIME,SUBSTRING(@strAux, 10, 8))

			SET @iTipoFinanciamento = CONVERT(INT,SUBSTRING(@strAux, 7, 1)) 
			SET @iQuantParcelas = CONVERT(INT,SUBSTRING(@strAux, 8, 2))  
			
		END ELSE
			RETURN
			
	END

	RETURN 

END

