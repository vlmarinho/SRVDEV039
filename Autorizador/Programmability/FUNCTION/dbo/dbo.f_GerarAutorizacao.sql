

-- =============================================
-- Author: Cristiano Silva Barbosa
--Data: 19/02/2017
--Mud/CH.:  2601
-- =============================================
CREATE FUNCTION [dbo].[f_GerarAutorizacao]()
RETURNS CHAR(18)
AS
BEGIN

	DECLARE @ResultVar varchar(18)

	SET @ResultVar = '1' + REPLACE(REPLACE(REPLACE(REPLACE (CONVERT(VARCHAR, GETDATE(), 121),'-',''),':',''),' ',''),'.','')
	
	RETURN @ResultVar

END



