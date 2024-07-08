
-- =============================================  
-- Author:  Cristiano Silva Barbosa
--Data: 19/02/2017
--Mud/CH.:  2601
-- ============================================= 


 
CREATE PROCEDURE [pr_aut_ConsultaRespostaCielo]  
(  
   @iResposta INT,  
   @Bit039 VARCHAR(2) OUTPUT  
)  
AS  
BEGIN  
  
 SET NOCOUNT ON;  
   
	SELECT @Bit039 = codigo_cielo FROM aut_CodigosResposta WITH (NOLOCK) WHERE codigo = @iResposta
  
END  
