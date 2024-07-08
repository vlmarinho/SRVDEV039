

/* 
--------------------------------------------------------------------------
Nome Sistema: Autorização
Objeto: [dbo].pr_aut_ConsultarRespostaPolicard
Propósito: Procedure responsável por
Autor: Cristiano Silva Barbosa - Policard Systems
--------------------------------------------------------------------------
Data criação: 19/02/2017
Mudança: 2601
--------------------------------------------------------------------------
Data Alteração: 26/04/2018
Chamados: 494467  / 3947
Responsavel: Cristiano Barbosa- Up Brasil
--------------------------------------------------------------------------

 
*/

CREATE PROCEDURE [dbo].[pr_aut_ConsultarRespostaPolicard] (      
	 @iResposta INT
	,@iRede     INT  
	,@Bit039    CHAR(2)		OUTPUT
	,@Bit062    VARCHAR(35)	OUTPUT      
)      
AS      
BEGIN
	SET NOCOUNT ON;      

	SELECT 
		@Bit039 = CASE WHEN @iRede = 31 THEN codigo_stone ELSE codigo_policard END,
		@Bit062 = descricao_policard    
	FROM 
		aut_CodigosResposta (NOLOCK)   
	WHERE 
		codigo = @iResposta    

	IF (@iRede IN (7,8))
		SET @Bit062 = 'D' + @Bit062
END 
