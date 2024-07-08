

-- =============================================
-- Author:		Cristiano Silva Barbosa
--Data: 19/02/2017
--Mud/CH.:  2601
-- =============================================
CREATE FUNCTION [dbo].[f_PMT](

	@R FLOAT, 
	@NPER INT, 
	@PV FLOAT, 
	@FV FLOAT, 
	@TYPE INT
)
RETURNS NUMERIC (38,9)
AS
BEGIN
 
	DECLARE @PMT FLOAT

	IF (@NPER = 0)
		SET @PMT = 0
	ELSE IF (@R = 0)
		SET @PMT = (@FV - @PV) / @NPER;
	ELSE
		SET @PMT = @R / (POWER(1 + @R, @NPER) - 1)
				   * -(@PV * POWER(1 + @R, @NPER) + @FV);

	IF (@TYPE = 1) 
		SET @PMT = @PMT / (1 + @R);

	RETURN @PMT;

END



