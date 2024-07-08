/*=========== CHANGELOG ===========
Data: 08/09/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1843805
Descrição: Projeto ABECS para transações NCR/Scope.
-------------------------------------------------------------------------- 	
*/

CREATE PROCEDURE dbo.PR_AUT_DecriptaSenhaNcrScopePorTranslate (
	@iCodigoEstabelecimento INT
	,@cProvedor VARCHAR(50)
	,@cBit052 VARCHAR(1000)
	,@cNumeroCartao VARCHAR(16)
	,@cPlanoBanco VARCHAR(16)
	,@cBit123 VARCHAR(1000)
	,@cPlanoAutorizador VARCHAR(16) OUTPUT
	,@iResposta INT OUTPUT
	,@returnCode INT OUTPUT
	,@returnMessage VARCHAR(4000) OUTPUT
	)
AS
BEGIN
	BEGIN
		DECLARE @VTableScope TABLE (
			Codigo INT
			,Chave VARCHAR(32)
			,Processado BIT
			);
		DECLARE @cWorkingKey VARCHAR(32);
		DECLARE @cWorkingKeyAux VARCHAR(32);
	END

	BEGIN
		SET NOCOUNT ON;
		SET @returnCode = 0;
		SET @returnMessage = 'OK';

			INSERT INTO @VTableScope
			SELECT TOP 10 Codigo
				,ChaveTrabalho
				,0
			FROM dbo.WorkingKey WITH (NOLOCK)
			WHERE Estabelecimento = @iCodigoEstabelecimento
				AND Provedor = @cProvedor
			ORDER BY 1 DESC

			WHILE EXISTS (
					SELECT *
					FROM @VTableScope
					WHERE Processado = 0
					)
			BEGIN
				SELECT TOP 1 @cWorkingKey = Chave
				FROM @VTableScope
				WHERE Processado = 0
				ORDER BY Codigo DESC
				
				SET @cWorkingKeyAux = @cWorkingKey

				EXEC dbo.pr_aut_DecriptaScope @cBit123, @cWorkingKey OUTPUT

				IF LEN(@cWorkingKey) = 32
					SELECT @cPlanoAutorizador = dbo.DecriptaSenha(@cBit052, @cWorkingKey, @cNumeroCartao)

				/*Valida se a senha retornada é numerica e maior ou igual a 4 digitos*/
				IF (
						@cPlanoBanco = @cPlanoAutorizador
						OR (
							ISNUMERIC(@cPlanoAutorizador) = 1
							AND @cPlanoAutorizador NOT LIKE '%[A-Z]%'
							AND LEN(@cPlanoAutorizador) >= 4
							)
						)
					BREAK

				UPDATE @VTableScope
				SET Processado = 1
				WHERE Chave = @cWorkingKeyAux
			END
	END
END