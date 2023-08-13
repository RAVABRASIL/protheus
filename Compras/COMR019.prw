#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "tbiconn.CH"
#include "topconn.ch"

// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : COMR019
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 16/07/19 | Gustavo Costa     | Gera pedido de compra automatico a partir da NF de saída 
// ---------+-------------------+-----------------------------------------------------------


User Function COMR019()

Local aCabec 	:= {}
Local aItens 	:= {}
Local aLinha 	:= {}
Local lOk 		:= .T.
local cQry		:= ''
Local cTES		:= ""
Local cCondPG	:= ""
Local cCodFor	:= ""
Local cLoja		:= ""
Local cCodPC	:= GetSXENum("SC7","C7_NUM")

If !Pergunte("COMR19",.T.)

	Return 

EndIf

PRIVATE lMsErroAuto := .F.

//PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "FAT" TABLES "SC7"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Abertura do ambiente |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ConOut(Repl("-",80))

Do Case
	Case FWCodFil() = "01" //pedido digitado na Rava
		If mv_par01 = "07" //Se vier da Total
			cTES 	:= '004'
			cCodFor	:= "35073 "
			cLoja	:= "01"
			cCondPG	:= "200"
		ElseIf mv_par01 = "06" //Se vier da Nova
			cTES 	:= '004'
			cCodFor	:= "35015 "
			cLoja	:= "01"
			cCondPG	:= "200"
		EndIf
	Case FWCodFil() = "06" //pedido digitado na Nova 

		If mv_par01 = "01" //Se vier da Rava
			cTES 	:= '004'
			cCodFor	:= "000077" 
			cLoja	:= "01"
			cCondPG	:= "200"
		ElseIf mv_par01 = "07" //Se vier da Total
			cTES 	:= '004'
			cCodFor	:= "35073 " 
			cLoja	:= "01"
			cCondPG	:= "200"
		EndIf

	Case FWCodFil() = "07" //pedido digitado na Total

		If mv_par01 = "01" //Se vier da Rava
			cTES 	:= '005'
			cCodFor	:= "000077" 
			cLoja	:= "01"
			cCondPG	:= "200"
		ElseIf mv_par01 = "06" //Se vier da Nova
			cTES 	:= '005'
			cCodFor	:= "35015 " 
			cLoja	:= "01"
			cCondPG	:= "200"
		EndIf

EndCase

dbSelectArea("SF4")
dbSetOrder(1)
If !SF4->(MsSeek(xFilial("SF4")+cTES))
lOk := .F.
ConOut("Cadastrar TES: " + cTES)
EndIf
dbSelectArea("SE4")
dbSetOrder(1)
If !SE4->(MsSeek(xFilial("SE4") + cCondPG))
lOk := .F.
ConOut("Cadastrar condicao de pagamento: " + cCondPG)
EndIf

dbSelectArea("SA2")
dbSetOrder(1)
If !SA2->(MsSeek(xFilial("SA2") + cCodFor + cLoja))
lOk := .F.
ConOut("Cadastrar fornecedor:" + cCodFor + cLoja)
EndIf
If lOk
ConOut("Inicio: "+Time())
EndIf

//aadd(aCabec,{"C7_FILIAL"	, xFilial("SC7")			})
aadd(aCabec,{"C7_NUM" 		, cCodPC					})
aadd(aCabec,{"C7_EMISSAO" 	, dDataBase					})
aadd(aCabec,{"C7_FORNECE" 	, cCodFor					})
aadd(aCabec,{"C7_LOJA" 		, cLoja						})
aadd(aCabec,{"C7_COND" 		, cCondPG					})
aadd(aCabec,{"C7_CONTATO" 	, "COMR019"					})
aadd(aCabec,{"C7_FILENT" 	, FWCodFil()				})


cQry:=" SELECT D2_SERIE, D2_DOC, D2_ITEM, D2_COD, D2_QUANT, D2_PRCVEN, D2_CLIENTE, D2_LOJA, A1_CGC, "
cQry+=" D2_VALIPI, D2_IPI, B1_POSIPI FROM " + RetSqlName("SD2") + " D2 "
cQry+=" INNER JOIN " + RetSqlName("SA1") + " A1 "
cQry+=" ON D2_CLIENTE + D2_LOJA = A1_COD + A1_LOJA "
cQry+=" INNER JOIN " + RetSqlName("SB1") + " B1 "
cQry+=" ON D2_COD = B1_COD "
cQry+=" WHERE D2_FILIAL = '" + mv_par01 + "' "
cQry+=" AND D2_SERIE = '" + mv_par02 + "' "
cQry+=" AND D2_DOC = '" + mv_par03 + "' "
cQry+=" AND D2.D_E_L_E_T_ = '' "
cQry+=" AND A1.D_E_L_E_T_ = '' "
cQry+=" AND B1.D_E_L_E_T_ = '' "

If Select("XC3") > 1
	XC3->(dbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS  "XC3"

dbSelectArea("XC3")
XC3->(dbGoTop())

While XC3->(!EOF())

	aLinha := {}
	aadd(aLinha,{"C7_PRODUTO" 	,U_TRANSGEN(XC3->D2_COD)		,Nil})
	aadd(aLinha,{"C7_QUANT" 	,XC3->D2_QUANT 					,Nil})
	aadd(aLinha,{"C7_PRECO" 	,XC3->D2_PRCVEN 				,Nil})
	aadd(aLinha,{"C7_TOTAL" 	,XC3->D2_QUANT * XC3->D2_PRCVEN ,Nil})
	aadd(aLinha,{"C7_IPI" 		,XC3->D2_IPI	 				,Nil})
	aadd(aLinha,{"C7_VALIPI" 	,XC3->D2_VALIPI 				,Nil})
	aadd(aLinha,{"C7_NCM" 		,XC3->B1_POSIPI	 				,Nil})
	aadd(aLinha,{"C7_TES" 		,cTES 							,Nil})
	aadd(aItens,aLinha)
	
	XC3->(dbSkip())
	
EndDo


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Teste de Inclusao |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Begin Transaction

	MATA120(1,aCabec,aItens,3,,)

	IF lMsErroAuto

		If (!IsBlind()) // COM INTERFACE GRÁFICA
		    
			MostraErro()
		        
		Else // EM ESTADO DE JOB
		    
			cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
		
		    ConOut(PadC("Erro na inclusao do pedido de compra", 120))
		    ConOut("Error: "+ cError)
		        
		EndIf

		DisarmTransaction()
		Break

	Else
		MsgAlert("Pedido incluído com sucesso! - " + cCodPC)
	Endif

End Transaction
ConOut("Fim : "+Time())
//	RESET ENVIRONMENT

Return

//--< fim de arquivo >----------------------------------------------------------------------
