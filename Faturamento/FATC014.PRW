#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"


//*************************************************************************************************
//Programa  -> LibVen 
//Descricao -> Rotinas de gatilho, inicializadores, validacao,
//FR: Coloquei esta função no SX3 do SC6:
//Campos:
//C6_TES -> X3_RELACAO = U_AVEN04("T")
//C6_CF  -> X3_RELACAO = U_AVEN04("C")
//Criei dois gatilhos porque ao digitar o produto, "zerava" o campo inicializado com o TES e CFOP
//C6_PRODUTO -> seq: 005 -> C6_TES -> U_AVEN04("T")
//C6_PRODUTO -> seq: 006 ->C6_CFOP -> U_AVEN04("C")

//**************************************************************************************************
// Descricao -> Rotina para copiar o TES e CFOP para todos os itens do pedido
// Usado no pedido de venda / Autoria: Flávia Rocha  / Data 22/12/2010
//**************************************************************************************************

//*************************************************************************************************
//Alteração em 23/07/13
//Incluída a função AVEN05 que captura o TES do cadastro de Cliente e insere na 1a. linha do aCols
//*************************************************************************************************
***************************
USER FUNCTION AVEN04(cCpo) 
***************************


Local nPosTES   := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_TES"})
Local nPosCF	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_CF"})
Local cTES	:= ""  
Local cCF	:= "" 

//If Inclui 	
	If Len(aCols) >= 2     	//se já tem um item e foi para o 2o., 3o. em diante	
	 cTES := aCols[1][nPosTES]           //armazena o que está na primeira linha do aCols
	 cCF  := aCols[1][nPosCF]	 
	Endif 
//Endif

If cCpo = "T"		//TES
	Return( cTES )
Elseif cCpo = "C"	//CFOP
	Return( cCF )
Endif 


***************************
USER FUNCTION AVEN05(cCpo) 
***************************
//retorna o TES do cadastro do cliente na linha do SC6 , campo C6_TES
//só no primeiro item, pois a função AVEN04 repete para os demais itens

Local nPosTES   := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_TES"})
Local nPosCF	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_CF"})
Local cTES	:= ""  
Local cCF	:= "" 
Local cCli  := M->C5_CLIENTE
Local cLJ   := M->C5_LOJACLI

//If Inclui 	
	SA1->(Dbseek(xFilial("SA1")+ cCli + cLj))
	cTES:=SA1->A1_TES
	//cCF := //TRAZER CFOP       
//Endif

//Return( cTES )

If cCpo = "T"		//TES
	Return( cTES )
Elseif cCpo = "C"	//CFOP
	Return( cCF )
Endif 






//*****************************************************************************************
// Descricao -> Rotina para apresenta um botao na linha superior do orcamento
// Usado no cadastramento de orcamento / Autor Edson  / Data 11/04/02 
//*****************************************************************************************
/*
USER FUNCTION TMKCBPRO(aBtnSup)
Aadd(aBtnSup,{"S4WB005N",&("{||U_AVEN08()}"),"Alteracao da Descricao"})
Aadd(aBtnSup,{"S4WB006N",&("{||U_AVEN11()}"),"Copia Itens de Outro Orçamento"})
Aadd(aBtnSup,{"S4WB007N",&("{||U_AVEN12()}"),"Texto Final da Proposta"})
//   Ld   051005   Aadd(aBtnSup,{"S4WB008N",&("{||U_AVEN13()}"),"Texto do Serviço"}) COMENTAR APOS MIGRACAO
//Aadd(aBtnSup,{"S4WB008N",&("{||U_AVEN13()}"),"Texto do Serviço"})
Return(aBtnSup)                                                                       
*/                                   
              
                             

//*****************************************************************************************
// Rotinas ligadas a manutencao do pedido de vendas (CIV)                                  
// Autor Edson  -> Funcoes AVen21, AVen22, AVen23, AVen24, AVen25, AVen26, AVen27
//                         AVen28, AVen29, AVen30, AVen31, AVen32
//*****************************************************************************************



/*
//*****************************************************************************************
// Descricao -> Rotina para apresenta um botao na linha superior do Pedido de Vendas
// Usado no cadastramento do pedido de vendas / Autor Edson  / Data 23/04/02 
//*****************************************************************************************
USER FUNCTION A410CONS
aButtons := {}
Aadd(aButtons,{"S4WB005N",&("{||U_AVEN22()}") ,"Alteração da Descrição do Item"})
Aadd(aButtons,{"S4WB006N",&("{||U_AVEN25()}") ,"Observação do item para o Mercado"})
Aadd(aButtons,{"S4WB007N",&("{||U_AVEN24()}") ,"Atualiza Preço de Tabela"})  
Aadd(aButtons,{"S4WB008N",&("{||U_AVEN29()}") ,"Dipositivo da Nota fiscal"})  
Aadd(aButtons,{"S4WB009N",&("{||U_AVEN32()}") ,"Dipositivo do Serviço na Nota fiscal"})  
Aadd(aButtons,{"S4WB010N",&("{||U_ATRL51A()}") ,"IMPRIMIR O CIV"})  
Aadd(aButtons,{"S4WB001N",&("{||U_AVEN37()}") ,"Copia Itens OP"})    //Disquete
//
//Aadd(aButtons,{"S4WB004N",&("{||U_ATRL51A()}") ," 04 "})  //Lanterna
//Aadd(aButtons,{"S4WB005N",&("{||U_ATRL51A()}") ," 05 "})  //duas folhas
//Aadd(aButtons,{"S4WB006N",&("{||U_ATRL51A()}") ," 06 "})  //Tesoura
//Aadd(aButtons,{"S4WB007N",&("{||U_ATRL51A()}") ," 07 "})  //prancheta+folha
//Aadd(aButtons,{"S4WB008N",&("{||U_ATRL51A()}") ," 08 "})  //caderno
//Aadd(aButtons,{"S4WB009N",&("{||U_ATRL51A()}") ," 09 "})  //
//Aadd(aButtons,{"S4WB010N",&("{||U_ATRL51A()}") ," 10 "})  //impressora
//Aadd(aButtons,{"S4WB011N",&("{||U_ATRL51A()}") ," 11 "})  //folha + lupa
//Aadd(aButtons,{"S4WB013N",&("{||U_ATRL51A()}") ," 13 "})  //grafico de pizza
//Aadd(aButtons,{"S4WB014N",&("{||U_ATRL51A()}") ," 14 "})  //calendario
//
Return(aButtons)                                                                       
*/



//*****************************************************************************************
// Descricao -> Rotina para calcular a comissao padrao  
// Usado no cadastramento de pedido de venda / Autor Edson  / Data 30/04/02 
//*****************************************************************************************
/*
USER FUNCTION AVEN26(lGrava)
Local TotPesoL  := 0,;
      TotQtd    := 0,;
      TotVal    := 0,;
      TotBasCom := 0,;
      TotCom    := 0,;
      TotComCal := 0,;
      TotPesoB  := 0,;
      i         := 0,;
      aAlias := {"SB1"},;
      aAmb   := U_GETAMB( aAlias )


If ValType("lGrava")="U"
 lGrava := "M"
endif 

If lGrava = "G"
 For i=1 to Len(aHeader)
  vCampo   := AllTrim(aHeader[i][2])
  p&vCampo := i
 next

 For i=1 to Len(aHeader)
  vCampo   := Substr(AllTrim(aHeader[i][2]),1,2)+Substr(AllTrim(aHeader[i][2]),4,7)
  p&vCampo := i
 next
endif

For i=1 to len(aCols) 
 if !aCols[i][len(aCols[i])]
  SB1->(DBSETORDER(1))
  if SB1->(DBSEEK(XFILIAL("SB1")+aCols[i][pC6_Produto]))
   TotPesoL += aCols[i][pC6_QtdVen] * SB1->B1_Peso
  endif 
  TotVal    += aCols[i][pC6_Valor]
  TotQtd    += aCols[i][pC6_QtdVen]
  TotBasCom += aCols[i][pC6_BaseCom]
  TotCom    += aCols[i][pC6_ValCom]
  TotComCal += (aCols[i][pC6_BaseCom] * aCols[i][pC6ComiCal]) / 100
 endif 
Next

If lGrava="G"
 SC5->C5_BaseCom := TotBasCom
 SC5->C5_Comis1  := (TotCom*100)/TotBasCom
 SC5->C5_ValCom  := TotCom
 SC5->C5_ComiCal := (TotComCal*100)/TotBasCom
 if SC5->C5_PesoL=0
  SC5->C5_PesoL   := TotPesoL
  SC5->C5_PBruto  := TotPesoL*1.1
 endif
else
 M->C5_BaseCom := TotBasCom
 M->C5_Comis1  := (TotCom*100)/TotBasCom
 M->C5_ValCom  := TotCom
 M->C5_ComiCal := (TotComCal*100)/TotBasCom
 if M->C5_PesoL=0
  M->C5_PesoL   := TotPesoL
  M->C5_PBruto  := TotPesoL*1.1
 endif
endif

U_RESTAMB( aAmb )

Return .t.
*/

/*
//*****************************************************************************************
// Descricao -> Rotina para liberar item para o faturamento  
// Usado na liberacao do estoque / Autor Edson  / Data 20/06/02 
//*****************************************************************************************
USER FUNCTION MTA455I
Local aAlias := {"SB2","SC9"},;
      aAmb := U_GETAMB( aAlias ),;
      nDisp:=0      

If MsgBox("Deseja liberar todos os itens deste pedido","Liberar para Faturamento","YESNO")
 vFinAp  := GetMV("MV_FINAP")  
 vPedido := SC9->C9_PEDIDO
 vRetona := .F. 
 dbSelectArea("SC9")
 dbSetOrder(1)
 If ( MsSeek(xFilial("SC9")+vPedido,.F.) )
  While !Eof() .And. SC9->C9_FILIAL = xFilial("SC9") .And. SC9->C9_PEDIDO = vPedido
   if SB2->(DbSeek(xFILIAL("SB2")+SC9->C9_PRODUTO+SC9->C9_Local)) 
    //if SB2->B2_qAtu > SC9->C9_QtdLib
    nDisp:= SB2->(B2_QATU - (B2_Reserva + B2_QAClass + B2_QTNP))
    If nDisp > SC9->C9_QtdLib
	     SA1->(DBSetOrder(1)) 
	     if SA1->(MsSeek(xFilial("SA1")+SC9->C9_Cliente+SC9->C9_Loja,.F.)) .and. ;
	        vFinAP$SA1->(A1_SitFin1+A1_SitFin1+A1_SitFin1) .and. RecLock("SC9",.F.)
	      	SC9->C9_BlEst := space(02)
	      	MSUNLOCK()
	     elseif SA2->(MsSeek(xFilial("SA2")+SC9->C9_Cliente+SC9->C9_Loja,.F.)) .and. RecLock("SC9",.F.)   
			&& FR 26/04/07 precisa localizar tb no cadastro de fornecedores qdo o pedido for tipo B
			SC9->C9_BlEst := space(02)
	      	MSUNLOCK()     
	     else     	     
		      if SA1->(EOF())
		       MsgBox("Cliente "+SC9->C9_Cliente+"/"+SC9->C9_Loja+" não esta cadastrado","Liberacao para faturamento","ALERT")
		      elseif !vFinAP$SA1->(A1_SitFin1+A1_SitFin1+A1_SitFin1) 
		       MsgBox("Cliente nao esta liberado pelo financeiro !!","Liberacao para faturamento","ALERT")
		      elseif !RecLock("SC9",.F.)
		       MsgBox("Registro sendo usado, não pode ser atualizado.","Liberacao para faturamento","ALERT")
		      endif
	      	  vRetona := .t.
	     endif
    else 
     MsgBox("Produto "+SC9->C9_Produto+" sem saldo ->"+Trans(SB2->B2_qAtu,"999,999.99"),"Liberacao para faturamento","ALERT")
     vRetona := .t.
    endif
   else 
    MsgBox("Produto "+SC9->C9_Produto+" nao esta cadastrado","Liberacao para faturamento","ALERT")
    vRetona := .t.
   endif
   if vRetona
    Exit
   endif 
  Enddo
    
  if vRetona .and. MsSeek(xFilial("SC9")+vPedido,.F.)
   While !Eof() .And. SC9->C9_FILIAL = xFilial("SC9") .And. SC9->C9_PEDIDO = vPedido
    if RecLock("SC9",.F.)
     SC9->C9_BlEst := "20"
     MSUNLOCK()
    endif 
    SC9->(DbSkip())
   Enddo
  endif  
 endif
endif

U_RESTAMB( aAmb )

return(.t.)
*/

/*
//************************************************************************************
// Programa AVEN34.prw  / Autor Edson  / Data 28/04/05 
// Descricao -> Verifica se o numero do pedido de vendas ja existe 
//************************************************************************************
USER FUNCTION AVEN34(pNumPed)
LOCAL cAlias  := ALIAS(),;
      aAlias  := {"SC5"},; 
      aAmb    := U_GETAMB(aAlias),;
      vRet    := .T.
if Inclui 
 SC5->(DbSetOrder(1))
 If SC5->(DbSeek(xFilial("SC5")+pNumPed))
  MsgBox("Este numero ja foi utilizado !!!","Cadastramento do Pedido","ALERT")
  While SC5->(DbSeek(xFilial("SC5")+pNumPed))
   pNumPed := StrZero(Val(pNumPed)+1,6)
  Enddo 
  M->C5_Num := pNumPed
  vRet := .F.
 endif
endif 

U_RESTAMB( aAmb )

Return(vRet)                            
*/

//************************************************************************************
// Programa AVEN35.prw  / Autor Edson  / Data 28/04/05 
// Descricao -> sugeri o proximo numero do pedido de vendas
//************************************************************************************

/*
//*****************************************
   USER FUNCTION AVEN35()                  // NOVA FUNCTION - FR 26/09/06
//*****************************************

Local aAreaAtu	:= GetArea()
Local aAreaSX6	:= SX6->(GetArea())
Local cNumPed	:= CriaVar("C5_NUM",.F.)

dbSelectArea("SX6")
dbSetOrder(1)
If !MsSeek(xFilial("SC5")+"AT_PVENDA")
	If !MsSeek("  AT_PVENDA")
		Aviso(	"Pedido de Venda",;
					"Não foi localizado o parâmetro que define o número do pedido de venda. Contate o Administrador.",;
					{"&Continua"},,;
					"A T E N Ç Ã O ")
	EndIf
EndIf

If Found()
	RecLock("SX6",.F.)
	cNumPed				:= StrZero(Val(SX6->X6_CONTEUD),TAMSX3("C5_NUM")[1])
	SX6->X6_CONTEUD	:= Soma1(cNumPed,TAMSX3("C5_NUM")[1])
	MsUnLock()
EndIf

RestArea(aAreaSX6)
RestArea(aAreaAtu)

Return(cNumPed)
*/

//************************************************************************************
// Programa M440SC9I.prw  / Autor Edson  / Data 26/10/04 
// Descricao -> Grava os campos customizados no SC9  
//************************************************************************************
/*
USER FUNCTION M440SC9I()
LOCAL cAlias := ALIAS(),;
      aAlias := {"SA1"},; 
      aAmb   := U_GETAMB(aAlias)

If Empty(SC9->C9_NomRed) .and. SC9->(RECLOCK("SC9",.F.))
 SC9->C9_NomRed := Posicione("SA1",1,xFilial("SA1")+SC9->(C9_Cliente+C9_Loja),"A1_NReduz")
 SC9->(MSUNLOCK())
endif 

U_RESTAMB(aAmb)
DBSELECTAREA(cAlias )
RETURN
*/



//*****************************************************************************************
// Descricao -> Rotina para apresenta um botao na linha lateral do orcamento
// Usado no cadastramento de orcamento / Autor Leila Dantas  / Data 10/05/05 
//*****************************************************************************************
//USER FUNCTION TMKBARLA(aBtnLat)     // ld 051005
//Aadd(aBtnLat,{"S4WB008N",&("{||U_AVEN13()}"),"Texto do Serviço"})
//Return(aBtnLat)       

//------------------------------------------------------------------------------
//*****************************************************************************************
// Descricao -> Rotina para retirar os acentos  (NF saida e CNAB)
// Usado na geração da NF e no CNAB / Autor EDSON  / Data 21/12/05 
//*****************************************************************************************
/*
User Function fLimpa(Texto)  &&alterar caracteres para retirar os acentos
Local pTabAce := "ãáàâõóòôéèêíìúùüÃÁÀÂÕÓÒÔÉÈÊÍÌÚÙÛÜÇç"
Local pTabLim := "aaaaooooeeeiiuuuAAAAOOOOEEEIIUUUUCc"
Local vCont := 1
LocaL I := 1
For I=1 to len(Texto) 
 if at(substr(Texto,I,1),pTabAce)#0
  vPos := at(substr(Texto,I,1),pTabAce)
  texto := substr(texto,1,I-1)+substr(pTabLim,vPos,1)+substr(Texto,I+1,len(Texto)-I)
 endif 
Next
return(Texto)
*/

/*
*******************************************************************************************************************
User Function ExFiscal(cGrCli,cGrPro,cEst,cTpCli)
*******************************************************************************************************************
// A exceção fiscal padrão requer SC5 posicionado, por esta razão trata a parte

Local aAreaAtu	:= GetArea()
Local aAreaSF7	:= SF7->(GetArea())
Local nRet		:= 0
Local cChave	:= ""

If Empty(cGrCli) .Or. Empty(cGrPro)
	Return(nRet)
EndIf

dbSelectArea("SF7")
dbSetOrder(1)
If MsSeek(xFilial("SF7")+cGrPro+cGrCli)
	cChave := SF7->F7_FILIAL+SF7->F7_GRTRIB+SF7->F7_GRPCLI
	While !Eof() .And. SF7->(F7_FILIAL+F7_GRTRIB+F7_GRPCLI) = cChave
		If (cEst == SF7->F7_EST .Or. SF7->F7_EST = "**") .And. ;
			(cTpCli == SF7->F7_TIPOCLI .Or. SF7->F7_TIPOCLI="*")
			If cEst == GetMv("MV_ESTADO")
				nRet	:= SF7->F7_ALIQINT
			Else
				nRet	:= SF7->F7_ALIQEXT 
			Endif   
			Exit
		Endif
		SF7->(DbSkip())
	Enddo
Endif

Return(nRet)
*/



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³ EHREPRES ³ Verifica se o usuário é um representante externo.            º±±
±±º             ³          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor       ³ 20.02.06 ³ TI0607 - Almir Bandina                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Produção    ³ 02.03.06 ³ TI0607 - Almir Bandina                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Parâmetros  ³ ExpC1 = Id do usuário se ser pesquisado                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno     ³ ExpA1 = 1o. Elemento - Código do Vendedor                               º±±
±±º             ³         2o. Elemento - .T. é representante Externo .F. apenas vendedor  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observações ³ Função utilizada no campo X3_WHEN e programas específicos               º±±
±±º             ³                                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Alterações  ³ 99/99/99 - Consultor - Descricao da alteração                           º±±
±±º             ³                                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*
User Function EhRepres(cIdUser)

Local aAreaAtu	:= GetArea()
Local aAreaSA3	:= SA3->(GetArea())
Local aRet		:= {}

cIdUser	:= If(Type("cIdUser") == "U", __cUserId, cIdUser)

dbSelectArea("SA3")
dbSetOrder(7)
If MsSeek(xFilial("SA3")+cIdUser)
	If SA3->A3_TIPO == "E"
		aRet	:= {SA3->A3_COD, .T.}
	Else
		aRet	:= {SA3->A3_COD, .F.}
	EndIf
Else
	aRet	:= {"", .F.}
EndIf

RestArea(aAreaSA3)
RestArea(aAreaAtu)

Return(aRet)
*/	