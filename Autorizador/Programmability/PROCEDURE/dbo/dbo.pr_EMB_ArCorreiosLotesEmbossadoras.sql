/*
Create
Data.: 27/07/2017 
Autor: Ricardo Araujo
Chamado.: 403118/3065
Descrição: Informando o AR/Correios vinculado ao lote.
*/

CREATE PROCEDURE [dbo].[pr_EMB_ArCorreiosLotesEmbossadoras]  
	 @DataFechamentoInicial char(10)  
	,@DataFechamentoFinal char(10)  
	,@LteEmbCodigo int
AS

	DECLARE @DIAINICIAL CHAR(2), @MESINICIAL CHAR(2), @ANOINICIAL CHAR(4)
	SET @DIAINICIAL = substring(@DataFechamentoInicial,1,2)
	SET @MESINICIAL = substring(@DataFechamentoInicial,4,2)
	SET @ANOINICIAL = substring(@DataFechamentoInicial,7,4)
	SET @DataFechamentoInicial = @ANOINICIAL + @MESINICIAL + @DIAINICIAL 

	DECLARE @DIAFINAL CHAR(2), @MESFINAL CHAR(2), @ANOFINAL CHAR(4)
	SET @DIAFINAL = substring(@DataFechamentoFinal,1,2)
	SET @MESFINAL = substring(@DataFechamentoFinal,4,2)
	SET @ANOFINAL = substring(@DataFechamentoFinal,7,4)
	SET @DataFechamentoFinal = @ANOFINAL + @MESFINAL + @DIAFINAL

Set Nocount On  

Select  
	AR.LteEmbCodigo AS LoteAr
	,AR.ARCodigo AS Objeto
	,AR.Status AS StatusAr
	,[DataCriacao] = Convert(varchar(10),Cast(AR.DataCriacao as Date),103)
	,[DataFechamento] = Convert(varchar(10),Cast(LE.DataFechamento as Date),103)
FROM EMBOSSAMENTO.DBO.ARCorreios AR with(nolock)
INNER JOIN EMBOSSAMENTO.DBO.LotesEmbossadoras LE with(nolock) ON AR.LteEmbCodigo = LE.LteEmbCodigo
Where   
    Convert(varchar(10),LE.DataFechamento,112) between @DataFechamentoInicial and @DataFechamentoInicial   
AND ((AR.LteEmbCodigo = @LteEmbCodigo) OR (@LteEmbCodigo = 0))
Order by   
    Cast(Le.DataFechamento as Date) 

