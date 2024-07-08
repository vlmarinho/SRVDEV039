CREATE VIEW V_LOCKS_UP 
AS 
     SELECT COUNT (*) AS EXPRESSION FROM SYS.DM_OS_WAITING_TASKS WITH (NOLOCK) 
     WHERE WAIT_TYPE LIKE 'LCK%' AND WAIT_DURATION_MS > 3000
       


