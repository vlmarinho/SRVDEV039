---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE SP_WHO4
AS
 SELECT DISTINCT GETDATE(), e.blocking_session_id from sys.dm_exec_requests e JOIN SYS.DM_EXEC_SESSIONS S 
			 ON E.Session_id = S.session_id Where e.wait_type LIKE 'LCK%' and E.wait_time > 3000
             and S.login_name LIKE '%Fepas%'


