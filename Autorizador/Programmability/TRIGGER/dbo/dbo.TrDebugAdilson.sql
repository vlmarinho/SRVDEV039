
CREATE TRIGGER dbo.TrDebugAdilson ON Autorizador.dbo.DebugAdilson
FOR INSERT, UPDATE
	,DELETE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE
        @EventData XML = EVENTDATA();
       
    PRINT '=>' + ISNULL(CONVERT(VARCHAR, @EventData), 'NULL') + '<=';
END
