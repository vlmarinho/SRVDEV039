

-- =============================================
--Data: 19/02/2017
--Mud/CH.:  2601
-- =============================================
CREATE FUNCTION [dbo].[f_Inclui_Sinalizador]
(
	@Texto varchar(1000)
)
RETURNS varchar(1000)
AS
BEGIN

	DECLARE @ResultVar varchar(1000)

	IF @Texto IS NULL 
	BEGIN

		SET @ResultVar = '0'

	END ELSE
	BEGIN

		IF (Len(@Texto) > 0 )
			SET @ResultVar = '1' + @Texto 
		ELSE
			SET @ResultVar = '0'
			
	END

	RETURN @ResultVar

END



