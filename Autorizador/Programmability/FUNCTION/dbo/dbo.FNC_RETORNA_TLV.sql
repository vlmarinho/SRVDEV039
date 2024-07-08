
CREATE FUNCTION dbo.FNC_RETORNA_TLV(
	@PVCH_DS_TAG VARCHAR(MAX), 
	@PINT_TAMANHO INTEGER
) 
RETURNS @VTBL_RETORNO TABLE (CD_TAG VARCHAR(3), CD_LEN VARCHAR(3), CD_VALUE VARCHAR(8000))
/*********************************************************************
Nome Sistema: Autorização
Objeto: [dbo].[FNC_RETORNA_TLV]
Propósito: Retornar Tag Len e Value
Autor: Cristiano Silva Barbosa
*********************************************************************/
AS 
BEGIN

	DECLARE @VVCH_TAG VARCHAR(3),
			@VVCH_LEN VARCHAR(3),
			@VVCH_VALUE VARCHAR(MAX),
			@VINT_POS	INT = 1
	
	IF (LTRIM(RTRIM(@PVCH_DS_TAG)) <> '')
	BEGIN

		WHILE (@VINT_POS >= 1)
		BEGIN

			SET @VVCH_TAG = ''
			SET @VVCH_LEN = ''
			SET @VVCH_VALUE = ''

			SET @VVCH_TAG = SUBSTRING(@PVCH_DS_TAG,@VINT_POS,@PINT_TAMANHO)
			SET @VINT_POS = @VINT_POS + LEN(@VVCH_TAG)
			SET @VVCH_LEN = SUBSTRING(@PVCH_DS_TAG,@VINT_POS,@PINT_TAMANHO)

			IF (ISNUMERIC(@VVCH_LEN) = 1)
			BEGIN

				SET @VINT_POS = @VINT_POS + LEN(@VVCH_LEN)
				SET @VVCH_VALUE = SUBSTRING (@PVCH_DS_TAG, @VINT_POS, CONVERT (INT,@VVCH_LEN))

				IF (LEN(@VVCH_TAG) = @PINT_TAMANHO)
				BEGIN

					INSERT INTO @VTBL_RETORNO
						(CD_TAG
						,CD_LEN
						,CD_VALUE) 
						VALUES (
						 @VVCH_TAG
						,@VVCH_LEN
						,@VVCH_VALUE
						)

				END

				SET @VINT_POS = @VINT_POS + CONVERT(INT,@VVCH_LEN)

				IF (@VINT_POS > LEN(@PVCH_DS_TAG))
					SET @VINT_POS = 0

			END
			ELSE
				SET @VINT_POS = 0

		END
	
	END

	RETURN 
	
END
