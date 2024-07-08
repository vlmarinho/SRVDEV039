/*
=====================================================================
Projeto: Notificação via APP
Descrição: Procedure utilizada para enviar nofitificação via APP
Autor:	Cristiano Silva Barbosa
Data Criacao: 28/09/2017
Chamado/Mudança: 399954 / 3262
=====================================================================
Data: 03/09/2023
Autor: Adilson Pereira - Up Brasil
Chamado: 2062670
Descrição: Alteração para notificar o usuário pelo motivo da negativa da transação.
	Squad Rede - Jornada VA
-----------------------------------------------------------------------------------
Data: 17/10/2023
Autor: Adilson Pereira - Up Brasil
Chamado: 2067391 
Descrição: Altera passagem de parâmetros para processo de envio de notificação por push.
	No caso de transações negadas não é gerado registro nas tabelas finais.
-------------------------------------------------------------------------- 
*/

CREATE PROCEDURE [dbo].[pr_aut_EnviarPushApp] (
	@cBaseOrigem CHAR(1)
	,@iTrnCodigo INT
	,@iCntAppCodigo INT
	,@iCodigoResposta INT
	,@iCodigoEstabelecimento BIGINT = NULL
	,@cNumeroCartao CHAR(16) = NULL
	,@iAuditCodigo BIGINT
	)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO Autorizador.dbo.EnviarPushApp (
		TrnCodigo
		,BaseOrigem
		,CntAPPCodigo
		,Enviado
		,DataInsercao
		,CodigoResposta
		,CodigoEstabelecimento
		,NumeroCartao
		,AuditCodigo
		)
	VALUES (
		@iTrnCodigo
		,@cBaseOrigem
		,@iCntAppCodigo
		,0
		,Getdate()
		,@iCodigoResposta
		,@iCodigoEstabelecimento
		,@cNumeroCartao
		,@iAuditCodigo
		)
END

