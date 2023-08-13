#Include "Rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#Include "ap5mail.ch"


//---------------------------------------------------------------------------------------------
// Ponto de Entrada: MT160GRPC                                                                //
// Autoria : Flávia Rocha - 31/05/13                                                          //
// Ponto de entrada disponibilizado para gravação de valores e campos específicos             //
// do Pedido de Compra (SC7).                                                                 //
// Executado durante a geração do pedido de compra na análise da cotação.                     //
// Após saída do pto de entrada MT160AOK, com retorno .T., caso a Análise da Cotação tenha    //
// sido liberada pela Diretoria, irá gravar no campo específico do Sc7, a fim de sabermos     //
// que determinado pedido foi gravado por liberação da Diretoria.                             //
//----------------------------------------------------------------------------------------------


**************************
User Function MT160GRPC()
**************************

If RecLock("SC7" , .F. )
	SC7->C7_OBSDIR := "LIBERADO DIRETORIA"  //liberado pela Diretoria
	MsUnlock()
Endif

Return NIL

