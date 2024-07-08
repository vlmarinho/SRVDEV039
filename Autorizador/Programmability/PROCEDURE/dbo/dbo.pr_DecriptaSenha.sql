
/*
-----------------------------------------------------------------------------
Data........: 27/05/2015
Nome Sistema: Autorizador
Objeto......: pr_AUT_ValidarIdpSenhaCartao
Propósito...: Procedure responsável por descriptografar a senha da transação.
-----------------------------------------------------------------------------
Data Alteracao: 21/03/2017
Autor: Cristiano Barbosa
CH: 365214 - 2676
--------------------------------------------------------------------------
Data Alteracao: 16/05/2017
Autor: Cristiano Barbosa
CH: 383212 -  2839
--------------------------------------------------------------------------
Data Alteracao: 04/07/2019
Autor: João Henrique
CH: 
--------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[pr_DecriptaSenha]
	 @NumeroCartao	VARCHAR(32)
	,@Senha			VARCHAR(32) OUTPUT
	,@cProvedor		VARCHAR(32) = ''
AS
BEGIN
	SELECT @Senha = CASE WHEN (@cProvedor = '')			  THEN dbo.DecriptaSenha(@Senha, '19D1FF47B254C52A9254147DF63BCA67', @NumeroCartao)  
						 WHEN (@cProvedor = 'PAYGO')	  THEN dbo.DecriptaSenha(@Senha, '3AE295A51AC64F3E793217A6E16421CD', @NumeroCartao)  
						 WHEN (@cProvedor = 'VBI')		  THEN dbo.DecriptaSenha(@Senha, 'CA6719D1F63BFF47147DB2549254C52A', @NumeroCartao)  
						 WHEN (@cProvedor =	'REDE')		  THEN dbo.DecriptaSenha(@Senha, 'FCCD4D213AACB76317A5EE393F06E23A', @NumeroCartao)
						 WHEN (@cProvedor =	'REDE_2')	  THEN dbo.DecriptaSenha(@Senha, 'A056D045BA2AD93213B0BC59E66239AF', @NumeroCartao)
						 WHEN (@cProvedor =	'COMUNIX')	  THEN dbo.DecriptaSenha(@Senha, '9DDAC026F816D48D8BA813159C3DEC91', @NumeroCartao)
						 WHEN (@cProvedor = 'RESOMAQ')	  THEN dbo.DecriptaSenha(@Senha, 'BF121B4FCE210940C8250040EF0C0045', @NumeroCartao) --Validação senha Resomaq
						 WHEN (@cProvedor = 'APP MOBILE') THEN DBO.DecriptaSenhaPolicard (@SENHA, '4F3279C61AE23A64E1CD21A595A6173E')
						 ELSE 'AAAA'
					END
END
