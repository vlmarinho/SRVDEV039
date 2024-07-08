/*   
--------------------------------------------------------------------------  
Projeto: Vale Transporte  
Objeto: pr_VT_EnviarKeepAlive
Propósito: Enviar Keep Alive aos equipamentos VT.  
Autor: Shuster Roberto - Tecnologia Policard  
--------------------------------------------------------------------------  
Data criação: 05/04/2016
Chamado: 258344
--------------------------------------------------------------------------  
Autor: Shuster Silva
Data alteração: 27/10/2016
Chamado: 320679/2294
-------------------------------------------------------------------------- 
*/  
  
CREATE PROCEDURE [dbo].[pr_VT_EnviarKeepAlive]    
AS    
BEGIN    
DECLARE  
	@bit001 char(4),   
	@bit003 char(6),   
	@bit007 char(10),    
	@bit011 char(6),
	@bit012 char(6), 
	@bit013 char(4),       
	@bit038 char(6),
	@bit041 char(8),   
	@bit042 char(15),   
	@bit047 char(10),   
	@bit049 char(3),   
	@bit057 Varchar(1024),   
	@iProximoNSU  int,    
	@dData_hora   datetime,    
	@dDataValidada  datetime,    
	@dDataCorte   datetime,    
	
	@cMsgIsoItauEnvio   varchar(8000),    
	@cMsgIsoItauRetorno varchar(8000) 

	SET @dData_hora = getdate()    
	SET @dDataValidada = DATEADD (mi , -1 , getdate())    
	SET @dDataCorte = converT(datetime, substring (convert(varchar, getdate(), 20),1, 10))    
    
	SELECT @iProximoNSU = COALESCE(MAX(NSU),0) + 1 
		FROM autorizacao..cb_keepalive WITH (NOLOCK) 
		WHERE data_hora >= @dDataCorte   
	 
	INSERT INTO autorizacao..cb_keepalive (data_hora, nsu) values (@dData_hora, @iProximoNSU)  
    
	SET @bit001 = '0800'     
	SET @bit003 = '000100'
	SET @bit011 = rtrim(ltrim(dbo.f_ZerosEsquerda(CONVERT(varchar, @iProximoNSU),6)))
	SET @bit012 = replace(convert(varchar, @dData_hora, 8), ':', '')    
	SET @bit013 = substring (convert(varchar, @dData_hora, 12), 3,4) 
	SET @bit007 = @bit013 + @bit012
	SET @bit038 = '043050'
	SET @bit041 = '00000166'	
	SET @bit042 = '000000000000050'	
	SET @bit047 = '000002246'	
	SET @bit049 = '986'
	SET @bit057 = '#210201002301000002246F00C30000001EAC0000000A00040008A4CBFEE00202015E0014001A4F40050000003336000000C10000000900040008A4CBFEE00102015E0013001A4F48050000003337000001530000000800040008A4CBFEE00202015E0012001A4F48050000003336000000C00000000700040008A4CBFEE00102015E0011001A4F48050000003337000001520000000400000005780000000500000006D600000000000000000000000000000000000000000000000000000A0200000000000000000000000000000000730389F7A17133628F164B5C5572AF0D#'
	
	SET @cMsgIsoItauEnvio = @bit001+'||'+@bit003+'||||'+@bit007+'||||'+@bit011+'|'+@bit012+'|'+@bit013
							+ '||||||||||||||||||||||||||||'+@bit041+'|'+@bit042+'|||||'+@bit047+'||'+ @bit049 
							+ '||||||||'+@bit057+'|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||'
     
	--SET @cMsgIsoItauEnvio = '054308002238000000C280800001000519105926719671105926051900000154000000000000038100000022463986450#210201002301000002246300C300000030AC0000000400040008A4CBFEE00202015E0022001AF348050000003336000000D50000000300040008A4CBFEE00102015E0021001AF348050000003336000000D400000002000400081B53423D0202015E003C001A4F40050000003336000000CF00000001000400081B53423D0102015E003B001A4F480500000033370000016300000000000000000000000001000000015E00000000000000000000000000000000000000000000000000000A02000000000000000000000000000000001F4BE09080E2AAFFD384FF8B1115D78B#'
    
	BEGIN TRY
	BEGIN TRAN		
		SELECT @cMsgIsoItauRetorno = dbo.ProcessaTransacaoVT(@cMsgIsoItauEnvio)       	

		COMMIT TRAN
	END TRY  
	BEGIN CATCH  
		---TRATAR FALHA DE KEEPALIVE
		ROLLBACK TRAN		
	END CATCH  
END
-- EXECUTE [dbo].[pr_VT_EnviarKeepAlive]    