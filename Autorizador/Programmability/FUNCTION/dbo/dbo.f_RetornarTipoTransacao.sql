
/*
----------------------------------------------------------------------------
Data........: 08/06/2015
Nome Sistema: Autorizador
Objeto......: f_RetornarTipoTransacao
Propósito...: Função responsável por retornar o tipo da transação corrente.
----------------------------------------------------------------------------
Data alteração: -
Mudança.......: -
----------------------------------------------------------------------------
*/

CREATE FUNCTION [f_RetornarTipoTransacao]
(
	 @Bit003		VARCHAR(20)
	,@Bit105		VARCHAR(1000)	= NULL
	,@TipoProduto	TINYINT			= NULL
	,@QtdParcelas	TINYINT			= NULL
)
RETURNS BIGINT
AS
BEGIN
	DECLARE  @iRetorno		 BIGINT
			,@iTipoTransacao BIGINT
			,@sTipoTransacao CHAR(2)

	SELECT @Bit003 = SUBSTRING(@Bit003,PATINDEX('%[a-z,1-9]%',@Bit003),LEN(@Bit003))

	IF (ISNUMERIC(@Bit003) = 1)
		SET @iRetorno = CONVERT(BIGINT,@Bit003)
	ELSE
		SET @iRetorno = 0

	IF (@iRetorno > 0)
	BEGIN
		IF (@iRetorno IN (2000,3000))
		BEGIN
			IF (@Bit105 IS NULL OR LTRIM(RTRIM(@Bit105)) = '')
				SET @sTipoTransacao = 'VV' /* VENDA A VISTA */
			ELSE
				SET @sTipoTransacao = 'QT' /* QUITAÇÃO */
		END
		ELSE IF (@iRetorno = 1000)
		BEGIN
			IF (@QtdParcelas IS NOT NULL OR @QtdParcelas > 1)
				SET @sTipoTransacao = 'VP' /* VENDA PARCELADA SEM JUROS */
			ELSE
				SET @sTipoTransacao = 'VV' /* VENDA A VISTA */
		END
		ELSE IF (@iRetorno = 2100)
			SET @sTipoTransacao = 'SQ'

		IF (@sTipoTransacao IS NOT NULL OR @sTipoTransacao <> '')
			SELECT	@iTipoTransacao = T.CodTipoTransacao
			FROM	TiposProdutosTiposTransacoes T WITH(NOLOCK)
			WHERE	T.CodTipoProduto	= @TipoProduto
					AND TipoTransacao	= @sTipoTransacao
		ELSE
			SELECT TOP 1 @iTipoTransacao = T.CodTipoTransacao FROM TiposTransacoes T WITH(NOLOCK) WHERE T.CodTipoTransacao = @iRetorno
	END

	IF (ISNULL(@iTipoTransacao,0) = 0)
		SET @iRetorno = 0
	ELSE
		SET @iRetorno = @iTipoTransacao

	RETURN @iRetorno
END
