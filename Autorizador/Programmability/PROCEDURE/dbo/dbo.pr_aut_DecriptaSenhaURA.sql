-- ===========================================
-- Author:	 Cristiano Silva Barbosa
-- Description: Encriptar senha URA.
--Data criação: 19/02/2017
--Mudança: 2601
-- ===========================================

--drop proc [pr_aut_DecriptaSenhaURA]

CREATE PROC [dbo].[pr_aut_DecriptaSenhaURA]
    @Senha VARCHAR(32) OUTPUT
AS
BEGIN
    SELECT @Senha = dbo.DecriptaSenhaPolicard(@Senha,'EB10A89316154DBE87F3708EAD7CB819')
	--'1CDAF397480B43FAC321908BD87983A1') -- CHAVE TRABALHO ALGAR - PROJETO URA
END

