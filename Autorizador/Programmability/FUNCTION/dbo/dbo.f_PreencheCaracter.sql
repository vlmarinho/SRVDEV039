/*  
--------------------------------------------------------------------------
Data: 28/09/2017
Autor: Cristiano Barbosa - Tecnologia Policard
Chamado: 417680 / 3262
--------------------------------------------------------------------------
*/  

CREATE FUNCTION [dbo].[f_PreencheCaracter]
(  
     @CCARACTERE AS CHAR
    ,@VALOR AS VARCHAR(20)
    ,@TAMANHO AS INTEGER 
    ,@IDIRECAO AS CHAR  
)  
  
RETURNS VARCHAR(20) AS      
BEGIN  
     
	DECLARE @VALORFORMATADO VARCHAR(20)
			,@IVARIACAO INTEGER  

	SELECT @IVARIACAO = @TAMANHO - LEN(@VALOR)
		  ,@VALORFORMATADO = @VALOR
  
	IF (LEN(@VALOR) > @TAMANHO)  
	BEGIN  
		SET @VALORFORMATADO = SUBSTRING(@VALOR, 1, @TAMANHO)  
	END  
	ELSE    
	BEGIN  
		WHILE (@IVARIACAO > 0)  
		BEGIN
		   IF (@IDIRECAO = 'D')  
			  SET @VALORFORMATADO = @VALORFORMATADO + @CCARACTERE  
		   ELSE  
		   BEGIN  
			  IF (@IDIRECAO = 'E')  
				 SET @VALORFORMATADO = @CCARACTERE + @VALORFORMATADO  
			  ELSE  
				 SET @IVARIACAO = - 1  
		   END
		   SET @IVARIACAO = @IVARIACAO - 1
		END  
	END  
   
	RETURN(@VALORFORMATADO)

END