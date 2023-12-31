#Include "Rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#Include "ap5mail.ch"


//---------------------------------------------------------------------------------------------
// Ponto de Entrada: MT160GRPC                                                                //
// Autoria : Fl�via Rocha - 31/05/13                                                          //
// Ponto de entrada disponibilizado para grava��o de valores e campos espec�ficos             //
// do Pedido de Compra (SC7).                                                                 //
// Executado durante a gera��o do pedido de compra na an�lise da cota��o.                     //
// Ap�s sa�da do pto de entrada MT160AOK, com retorno .T., caso a An�lise da Cota��o tenha    //
// sido liberada pela Diretoria, ir� gravar no campo espec�fico do Sc7, a fim de sabermos     //
// que determinado pedido foi gravado por libera��o da Diretoria.                             //
//----------------------------------------------------------------------------------------------


**************************
User Function MT160GRPC()
**************************

If RecLock("SC7" , .F. )
	SC7->C7_OBSDIR := "LIBERADO DIRETORIA"  //liberado pela Diretoria
	MsUnlock()
Endif

Return NIL

