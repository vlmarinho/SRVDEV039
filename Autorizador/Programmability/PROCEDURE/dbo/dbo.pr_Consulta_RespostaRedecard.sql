
-- =============================================  
-- Responsavel:  Cristiano Silva Barbosa
-- Data: 22/05/2017
-- Descrição: Responsavel por consultar respostas da RedeCard
-- CH: 383212 - 2839
-- ============================================= 
 
CREATE PROCEDURE [pr_Consulta_RespostaRedecard]  
(  
   @iResposta INT,  
   @Bit039 VARCHAR(2) OUTPUT  
)  
AS  
BEGIN  
  
	SET NOCOUNT ON;
   
	SELECT @Bit039 = codigo_redecard FROM aut_CodigosResposta WITH (NOLOCK) WHERE codigo = @iResposta

	IF (@Bit039 = '' OR @Bit039 IS NULL)
		SET @Bit039 = '71'
  
END  
