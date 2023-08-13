#include "rwmake.ch"
#INCLUDE "Topconn.CH"
#INCLUDE "fivewin.CH"
#INCLUDE "PROTHEUS.CH"
#DEFINE ENTER Chr(13)+Chr(10)

**********************
User Function MTA416PV()      // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
**********************
/*                                                            
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MTA416PV    ³ Autor ³ Gustavo Costa         ³ Data ³ 30/10/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Ponto de entrada APOS GERACAO DO ACOLS NA BAIXA ORCAMENTO     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Local nAux := PARAMIXB 
Local nPOSPDESC   := aScan( _aHeader,{ |x| AllTrim( x[2] ) == "C6_PDESC" } )
Local nPOSVDESC   := aScan( _aHeader,{ |x| AllTrim( x[2] ) == "C6_VDESC" } )
Local nPOSPRUNIT  := aScan( _aHeader,{ |x| AllTrim( x[2] ) == "C6_PRUNIT" } )
Local nPOSVALOR   := aScan( _aHeader,{ |x| AllTrim( x[2] ) == "C6_VALOR" } )
Local nPOSPRCVEN  := aScan( _aHeader,{ |x| AllTrim( x[2] ) == "C6_PRCVEN" } )
Local nPOSDESCRI  := aScan( _aHeader,{ |x| AllTrim( x[2] ) == "C6_DESCRI" } )
Local aArea			:= getArea()

_aCols[nAux][nPOSPDESC] := TMP1->CK_PDESC  //C6_PDESC 
_aCols[nAux][nPOSDESCRI] := POSICIONE("SB1",1,XFILIAL("SB1") + TMP1->CK_PRODUTO,"B1_DESC") 

//If FWCodFil() == "06"

//	_aCols[nAux][nPOSPRCVEN] := TMP1->CK_PRCVEN * 1.15                         
//	_aCols[nAux][nPOSPRUNIT] := TMP1->CK_PRCVEN //* 1.15                         
//	_aCols[nAux][nPOSPDESC] := -15                          
//	_aCols[nAux][nPOSVDESC] := (TMP1->CK_QTDVEN * _aCols[nAux][nPOSPRUNIT]) - (TMP1->CK_QTDVEN * _aCols[nAux][nPOSPRCVEN])                           
//	_aCols[nAux][nPOSVALOR] := TMP1->CK_QTDVEN * _aCols[nAux][nPOSPRUNIT]  
	//RunTrigger(2,nAux,nil,,'C6_PDESC')                       

//Else
	
	_aCols[nAux][nPOSVDESC] := TMP1->CK_VDESC  //C6_VDESC                        
	//_aCols[nAux][nPOSPRCVEN] := TMP1->CK_PRCVEN
	_aCols[nAux][nPOSPRUNIT] := TMP1->CK_PRCVEN  //C6_VDESC                        

//EndIf
	
//RunTrigger(2,nAux,nil,,'C6_QTDVEN')
//RunTrigger(2,nAux,nil,,'C6_PRUNIT')

//TMP1->(dbSkip())
//Alert('Passou pelo ponto entrada MTA416PV.')


If !Empty(SCJ->CJ_OBSERVA)
	M->C5_OBSERVA 	:= AllTrim(SCJ->CJ_OBSERVA)
EndIf

	M->C5_MENNOTA 	:= AllTrim(SCJ->CJ_MENNOTA)
//	M->C5_MENNOT1 	:= AllTrim(SCJ->CJ_MENNOTA)

If !Empty(SCJ->CJ_OCCLI)
	M->C5_OCCLI 	:= AllTrim(SCJ->CJ_OCCLI)
EndIf

DbSelectArea("SA1")
DbSetOrder(1)
SA1->( DbSeek(xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA) )

M->C5_TIPO := SA1->A1_TIPO

DbSelectArea("CC2")
DbSetOrder(1)
CC2->( dbSeek(XFILIAL("CC2")+SA1->A1_EST + SA1->A1_COD_MUN ))
                                                        
M->C5_LOCALIZ := CC2->CC2_CODMUN


DbSelectArea("SZZ")
DbSetOrder(2)
SZZ->( DbSeek( xFilial("SZZ")+SA1->A1_COD_MUN+"S" ) )
   
M->C5_TRANSP := SZZ->ZZ_TRANSP

//RunTrigger(1,nil,nil,,'C5_CLIENTE')
//RunTrigger(1,nil,nil,,'C5_LOJACLI')

If SA1->A1_EST $ "'AC','RO','RR','TO','AL','MA','PI','RN','SE','AP','AM','PA','MT','MS'"
	M->C5_VEND3 := "0357"
	M->C5_COMIS3 := 0.17
EndIf
If SA1->A1_EST $ "'PE','RJ','SC','CE','MG','PR','ES','DF','RS','SP','BA','PB','GO'"
	M->C5_VEND2 := "2348"
	M->C5_COMIS2 := 0.35
EndIf

//M->C5_LOCALIZ := SA1->A1_COD_MUN

/*
If SA1->A1_XNOVA == "1" .AND. FWCodFil() == "01"
      MsgAlert("Este cliente está elegível para faturar pela NOVA! Verificar possíbilidade de transferir o pedido.")
      //RestArea(aArea)
	//Return .F.
EndIf
*/
  
RestArea(aArea)

TMP1->(dbSkip())
Return Nil
