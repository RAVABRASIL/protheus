#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#Include 'Topconn.ch'
#include "ap5mail.ch"

//--------------------------------------------------------------------------
//Programa: FATC004 - Expedir NFs e enviar por email aviso de expedição 
//			juntamente com o espelho da NF como anexo.
//Objetivo: Por solicitação do chamado 001445 - João Emanuel - Simplificar 
//          a tela de Expedição de NFs para uso do depto. de Logística
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 12/01/10
//--------------------------------------------------------------------------
                                                                 	
******************************
User Function FATC004()
******************************

Local aAlias	:= { "SA1", "SF2", "SD2" }
Local aAmb		:= {}
Local aArea     := GetArea() 
Local aAreaSF2  := SF2->(GetArea())
Local aAmb      := U_GETAMB( aAlias )
Local oSay1
//Local oBtn1, oBtn2, oBtn3
//Local cARQTMP := ''
Local aESTRUT := {}
Local cAlias  := ""
Private cPesquisa  := Space(15)
Private oCBox1, oDlgNF, oGrp1, oBrw1, oFont1,oFont2,oFont3,oFont4
Private cARQTMP := "" 
Private oBtnBus, oBtnDSai, oBtnFech, oBtnAT


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

oFont1  := TFont():New( "Courier New"           ,0,-19,,.T.,0,,700,.F.,.F.,,,,,, )     		//FONTE DO TOTAIS
oFont2  := TFont():New( "Franklin Gothic Medium",0,-19,,.F.,0,,400,.F.,.F.,,,,,, )          //FONTE DA HORA
oFont3  := TFont():New( "Arial",0,-24,,.T.,0,,700,.F.,.F.,,,,,, ) 
oFont4  := TFont():New( "Arial",0,-15,,.T.,0,,700,.F.,.F.,,,,,, ) 					//FONTE DO AVISO DA TECLA
//oDlg1   := MSDialog():New( 126,254,701,1049,"Produção acumulada",,,.F.,,,,,,.T.,,,.F. )   //PAINEL EM VOLTA
//oDlg1   := MSDialog():New( 126,254,701,1000,"Notas Fiscais Saida",,,.F.,,,,,,.T.,,oFont3,.F. )   //PAINEL branco em volta do Grid / o "oFont3 é o fonte maior
oDlgNF   := MSDialog():New( 126,254,701,1155,"Notas Fiscais Saida",,,.F.,,,,,,.T.,,oFont3,.F. )   //PAINEL branco em volta do Grid / o "oFont3 é o fonte maior

//oGrp1   := TGroup():New( 003,003,283,363,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. ) //LINHA FINA EM VOLTA DO GRID
oGrp1   := TGroup():New( 003,003,283,443,"",oDlgNF,CLR_BLACK,CLR_WHITE,.T.,.F. ) //LINHA FINA EM VOLTA DO GRID


 
aESTRUT := {{ "FIL"    ,   "C", 002, 0 },; 
			{ "NFISCAL",   "C", 009, 0 },; 
			{ "SERIE"  ,   "C", 003, 0 },;
		    { "EMISS"  ,   "D", 008, 0 },;
		    { "DTEXP"  ,   "D", 008, 0 },;
		    { "TRANSP" ,   "C", 006, 0 },;
		    { "LOCALIZ" ,   "C", 006, 0 }}
            
cARQTMP := CriaTrab( aESTRUT, .T. )

cAlias := Alias()
DbcloseArea(cAlias)

DbUseArea( .T.,, cARQTMP, "EXP", .F., .F. )
Index On NFISCAL To &cARQTMP 
/*
oBrw1   := MsSelect():New( "EXP",,,;
{{ "FIL"        ,   "", "Filial"       ,				         "" },;
{ "NFISCAL"     ,   "", "Nota Fiscal"  ,				         "" },;
 { "SERIE"       ,   "", "Série "        ,				         "" },;
 { "EMISS"       ,   "", "Emissão "      ,			             "" },;
 { "DTEXP"       ,   "", "Dt.Expedição" ,			             "" },;
 { "TRANSP"       ,   "", "Transportadora" ,		             "" }  },.F.,,{010,007,201,280},,, oGrp1 )   //Grid 
 */
 oBrw1   := MsSelect():New( "EXP",,,;
{{ "FIL"        ,  "", "Filial"       ,				         "" },;
{ "NFISCAL"     ,  "", "Nota Fiscal"  ,				         "" },;
 { "SERIE"      ,  "", "Série "        ,			         "" },;
 { "EMISS"      ,  "", "Emissão "      ,		             "" },;
 { "DTEXP"      ,  "", "Dt.Expedição"  ,		             "" },;
 { "TRANSP"     ,  "", "Transportadora" ,		             "" },;
 { "LOCALIZ"     , "", "Localização"    ,		             "" }  },.F.,,{010,007,201,370},,, oGrp1 )   //Grid 
															                //{010,007,241,387} o penúltimo número é a altura,o último é a largura 
oBrw1:oBrowse:nLinhas := 2	//FR: Define a altura da linha do grid



oSay1 := TSay():New( 220,010,{||"Pesquisar:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,016)
oGet1 := TGet():New( 239,140,,oGrp1,145,016,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPesquisa",,)
oGet1:bSetGet := {|u| If(PCount()>0,cPesquisa:=u,cPesquisa)}

oCBox1 := TComboBox():New( 239,010,,{"Nota Fiscal","Emissão"},115,050,oDlgNF,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
oCBox1:bChange := {||CBChange(cARQTMP)}

oCBox1:nAt :=1              //é necessário já iniciar esta variável como 1 porque senão, a pesquisa só funciona qdo alterado o combo
Eval( oCBox1:bChange )      
/*
oBtn1 := TButton():New( 240,295,"Buscar",oDlg1,,055,018,,,,.T.,,"",,,,.F. )
oBtn1:bAction := {||Pesq()}

oBtn2 := TButton():New( 036,295,"Dt.Saída",oDlg1,,055,018,,,,.T.,,"",,,,.F. )
oBtn2:bAction := {||U_MUDDAT2()}

oBtn3 := TButton():New( 070,295,"Fechar",oDlg1,,055,018,,,,.T.,,"",,,,.F. )
oBtn3:bAction := {||oDlg1:End()}
*/

oBtnBus := TButton():New( 240,375,"Buscar",oDlgNF,,055,018,,,,.T.,,"",,,,.F. )
oBtnBus:bAction := {||Pesq()}

oBtnDSai := TButton():New( 036,375,"Dt.Saída",oDlgNF,,055,018,,,,.T.,,"",,,,.F. )
oBtnDSai:bAction := {||U_MUDDAT2()}

oBtnAT := TButton():New( 070,375,"Muda Transp.",oDlgNF,,055,018,,oFont4,,.T.,,"",,,,.F. )
oBtnAT:bAction := {||U_MUDDATT()}
//oBtnAT :Action := { || U_FUNCTRANS(M->C5_LOCALIZ,M->C5_TRANSP) }

oBtnFech := TButton():New( 104,375,"Fechar",oDlgNF,,055,018,,,,.T.,,"",,,,.F. )
oBtnFech:bAction := {||oDlgNF:End()}


MsAguarde( {|| MostraNFS() }, OemToAnsi( "Aguarde" ), OemToAnsi( "Lendo Notas Fiscais..." ) )


oDlgNF:Activate(,,,.T.)
DbselectArea("EXP")
DbcloseArea("EXP")
//Ferase( &cARQTMP +".DBF" )
//Ferase( &cARQTMP + OrdBagExt() )
RestArea(aArea)
RestArea(aAreaSF2)
U_RESTAMB( aAmb )

Return

****************************
Static Function CBChange(cARQTMP)
****************************
   DbSelectArea("EXP")
   if oCBox1:nAt = 1
      //Index On NFISCAL To cARQTMP
      //Index On NFISCAL To (&cARQTMP)
   else
      Index On DTOS(EMISSAO) To ( &cARQTMP )       //se estiver como DtoS, não encontra a Data
      //Index On EMISSAO To cARQTMP 	
   endif          
Return


***********************
Static Function Pesq() 
***********************

if oCBox1:nAt = 1
   EXP->(DbSeek( Alltrim(cPesquisa) ) )   
else
   //EXP->(DbSeek( Dtos( Ctod( Alltrim(cPesquisa) ) ) ) )
   LOCATE FOR CtoD( TRIM(cPesquisa) )   == EXP->EMISS    //a procura da data só funcionou com Locate
   
endif

Return


************************************************************************************************
Static Function MostraNFs()
************************************************************************************************

Local cQuery    := ""
Local cAlias    := "SF2X"


cQuery := " SELECT F2_FILIAL, F2_DOC, F2_SERIE, F2_DTEXP, F2_EMISSAO, F2_TRANSP, F2_LOCALIZ "
cQuery += " FROM " + RetSqlName("SF2") + " SF2 "
cQuery += " WHERE F2_EMISSAO >= '20091117' " 
//cQuery += " AND RTRIM( F2_TRANSP ) <> '024' "  //->05/04/10: Chamado 001551 - JOão Emanuel pediu para incluir esta transportadora (O MESMO).
cQuery += " AND F2_DTEXP = '' "
cQuery += " AND (SF2.F2_SERIE = '0' OR LEN(SF2.F2_DOC) = 6) "
cQuery += " and SF2.D_E_L_E_T_ = ' '  "
cQuery += " AND F2_FILIAL  = '" + xFilial("SF2") + "' "
cQuery += " ORDER by F2_DOC, F2_SERIE "
//MemoWrite("C:\FATC004.SQL",cQuery)

If Select("SF2X") > 0
	DbSelectArea("SF2X")
	DbCloseArea()	
EndIf 

TCQUERY cQuery NEW ALIAS "SF2X" 
TCSetField( cAlias, "F2_EMISSAO", "D")
TCSetField( cAlias, "F2_DTEXP", "D")

nLin		:= 0


SF2X->(Dbgotop())
While ! SF2X->(EOF())
   
    DbselectArea("EXP") 
	RecLock("EXP",.T.) 
	EXP->FIL		:= SF2X->F2_FILIAL	   		
	EXP->NFISCAL	:= SF2X->F2_DOC
	EXP->SERIE		:= SF2X->F2_SERIE
	EXP->EMISS		:= SF2X->F2_EMISSAO
	EXP->DTEXP		:= SF2X->F2_DTEXP
	EXP->TRANSP		:= SF2X->F2_TRANSP
	EXP->LOCALIZ    := SF2X->F2_LOCALIZ
	EXP->(MsUnLock())   

   SF2X->(DbSkip())
Enddo

EXP->(DbGoTop())
SF2X->(DbCloseArea())

Return 

********************************************
User Function MUDDAT2()
********************************************

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private dDtExp     := dDatabase 	//CtoD("  /  /    ")
Private cTran      := EXP->TRANSP
Private cLocalid   := EXP->LOCALIZ
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlgOk","oGrpOk","oGetOk","oSay1","oSBtn1","oSBtn2","oGetOKT", "oSayT", "oSBtnT")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/


oDlgOk  := MSDialog():New( 226,432,315,738,"Nota Fiscal",,,.F.,,,,,,.T.,,,.F. )
oGrpOk  := TGroup():New( 002,003,025,134,"",oDlgOk,CLR_BLACK,CLR_WHITE,.T.,.F. )

oSay1  := TSay():New( 009,009,{||"Data Saída:"},oGrpOk,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
oGetOk  := TGet():New( 008,064,,oGrpOk,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtExp",,)
oGetOk:bSetGet := {|u| If(PCount()>0,dDtExp:=u,dDtExp)} 

oSBtn1 := SButton():New( 028,076,1,{||MsAguarde({||Ok( EXP->FIL, EXP->NFISCAL, EXP->SERIE, dDtExp, EXP->TRANSP )},"Aguarde...","Processando Dados...")},oDlgOk,,"", )

oSBtn2 := SButton():New( 028,108,2,{||oDlgOk:End()},oDlgOk,,"", )
oSBtn2:bAction := {||oDlgOk:End()}


oDlgOk:Activate(,,,.T.)

Return  

//muda transp
********************************************
User Function MUDDATT()
********************************************

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
//Local nOPT         := 0
Private cTran      := EXP->TRANSP
Private cLocalid   := EXP->LOCALIZ
Private cTraNew    := ""
Private aOPTT      := {}
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlgTT","oGrpTT","oGetTT","oSayTT","oSBtnT1","oSBtnT2")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/


aOPTT := U_FUNCTRANS(cLocalid,cTran)
//alert("gerou array")

If aOPTT[1] = 1
	cTraNew := aOPTT[2]
	OKTT(cTraNew)
//Else
//	alert("sem alteração")
Endif

Return

************************************
Static Function OKTT( cTranspNew)
************************************

DbselectArea("EXP") 
RecLock("EXP",.F.)       //altera no arquivo temporário primeiro
EXP->TRANSP     := cTranspNew
EXP->(MsUnLock())

Return



**************************************************
Static Function Ok( cFIL, cDOC, cSERIE, dDtExp, cTranspNew )
**************************************************

local cMsg		:= ""
Local cTit		:= ""
local cEspelho 	:= ""
local dDtEntr
Local cTransp 	:= ""
Local nRegistro 
Local cCodUser  := ""
Local eEmail	:= "" 
Local cRedesp	:= ""
Local cTransp1	:= ""
Local cLocaliz	:= ""
Local dPrev		:= Ctod("  /  /    ") 
Local cVendedor := ""
Local cPedido   := ""
Local lMostraPCli:= .F. 
LOCAL nSaldoNF:=0
Local cPedCli   := ""
Local cSuper    := "" 
Local cTES      := ""
Local cPedVenda := ""

If dDtExp < dDatabase        //se o usuário não tiver acesso para mudar a database,conseguirá passar por esta crítica.
	MsgBox("A Data de Saída não pode ser menor que a data de Hoje!")
	Return .F.
Endif

DbSelectArea("SA1")
DbsetORder(1)
SA1->(DbSeek(xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA)))
If Alltrim(SA1->A1_DAE) = "S"
	MsgInfo("LEMBRETE: Esta NF Somente Poderá Sair da Rava, Com o Comprovante do DAE PAGO!!")
Endif

//If !MsgYesNo("Continua?")
//	Return
//Endif

dbSelectArea("SF2")
SF2->(dbSetOrder(1))
//If SF2->( DbSeek(xFilial("SF2") + cDOC + cSERIE ) )
cPedVenda := ""
aPedVenda := {}
t := 0
If SF2->( DbSeek( cFIL + cDOC + cSERIE ) )
	
	cTransp1 := SF2->F2_TRANSP
	cLocaliz := SF2->F2_LOCALIZ
	cRedesp  := SF2->F2_REDESP
	cVendedor := SF2->F2_VEND1		
	nRegistro := SF2->(Recno())
	
	//Atualiza o SF2 - F2_DTEXP
	RecLock("SF2", .F.)
	SF2->F2_DTEXP := dDtExp
	SF2->F2_TRANSP:= cTranspNew
	SF2->(MsUnLock())
	
	DBSelectArea("SD2")
	SD2->(Dbsetorder(3))
	If SD2->( DbSeek( cFIL + cDOC + cSERIE ) )
		While !SD2->(EOF()) .And. SD2->D2_FILIAL == xFilial("SD2") .and. SD2->D2_DOC == cDOC ;
		  .and. SD2->D2_SERIE == cSERIE
		  
			cPedVenda := SD2->D2_PEDIDO
			If Ascan(aPedVenda , cPedVenda) == 0
				Aadd(aPedVenda , cPedVenda )
			Endif
			SD2->(Dbskip())
		Enddo
	Endif
	
	/////////////////////////////////////////////////////////////////////////////////
	///SOLICITADO POR EURIVAN - ETAPAS PEDIDO VENDA
	///FR 15/10/13 - FLÁVIA ROCHA - IMPLEMENTAR HISTÓRICO DO PEDIDO A CADA ETAPA REALIZADA
	///AQUI, QDO LIBERAR EXPEDIR A NF, IRÁ REGISTRAR NO HISTÓRICO ZAC
	/////////////////////////////////////////////////////////////////////////////////
	If Len(aPedVenda) > 0
		For t := 1 to Len(aPedVenda)
			DbSelectArea("ZAC")		
			RecLock("ZAC", .T.)
			ZAC->ZAC_FILIAL := xFilial("SF2")	
			ZAC->ZAC_PEDIDO := aPedVenda[t]  //cPedVenda
			ZAC->ZAC_STATUS := '04'  //ANTES ERA 03, MAS COM A ENTRADA DE PRODUÇÃO/FATURAMENTO ESTE VIROU 03  
			ZAC->ZAC_DESCST := "PRODUTO(S) EM TRANSPORTE"
			ZAC->ZAC_DTSTAT := dDtExp  //Date()
			ZAC->ZAC_HRSTAT := Time()
			ZAC->ZAC_USER   := __CUSERID //código do usuário que criou
			ZAC->(MsUnlock())
			
			SC5->(Dbsetorder(1))   
			If SC5->(Dbseek(xFilial("SC5") + aPedVenda [t] ))  // cPedVenda ))
				RecLock("SC5", .F. )
				SC5->C5_STATUS := '04'  //produtos em transporte
				SC5->(MsUnlock())
			Endif
		Next
	Endif  
	//FR - 15/10/13
	
	DBSelectArea("SC5")
	SC5->(Dbsetorder(1))
	If SC5->( DbSeek(xFilial("SC5") + cPedVenda ) )
		RecLock("SC5", .F.)
		SC5->C5_TRANSP := cTranspNew
		SC5->(MsUnLock())	
	Endif
Endif
     
//Calcula o prazo de entrega, para depois atualizar o F2_PREVCHG
//dPrev	:= U_FATC005( cFIL, cDOC, cSERIE, cTransp1, cRedesp, cLocaliz )
dPrev	:= U_FATC005( cFIL, cDOC, cSERIE, cTranspNew, cRedesp, cLocaliz )
If SF2->( DbSeek(xFilial("SF2") + cDOC + cSERIE ) )

	//Atualiza o SF2 - F2_PREVCHG
	RecLock("SF2", .F.)
	SF2->F2_PREVCHG := dPrev
	SF2->(MsUnLock())
Endif 

DbselectArea("EXP") 
RecLock("EXP",.F.)	   		
EXP->DTEXP		:= dDtExp
EXP->TRANSP     := cTranspNew
EXP->(MsUnLock())
   

oDlgOk:End() 



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a pilha da funcao fiscal                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cCodUser := __CUSERID
eEmail := ""		//Chamado 001469 - João solicitou que retirasse o email dele da cópia.


DbselectArea("SA3")
DbsetOrder(1)
If Alltrim(cVendedor) != '0255'
	If SA3->(Dbseek(xFilial("SA3") + cVendedor ))
		eEmail := GetNewPar("MV_XFATR50",'comercial@ravaembalagens.com.br;gustavo@ravaembalagens.com.br')           //Chamado 001272 - Daniela - Solicitou incluir o email do representante/vendedor para também receber este e-mail
		cSuper := SA3->A3_SUPER
		If AllTrim(SA3->A3_EMAIL) <> ''
			eEmail += ";" + SA3->A3_EMAIL
		EndIf
	Endif
	If Alltrim(cSuper) != '0256'
		DbsetOrder(1)
		SA3->(Dbgotop())
		If SA3->(Dbseek(xFilial("SA3") + cSuper ))
			eEmail += ";" + SA3->A3_EMAIL     //email do coordenador			
		Endif                            
	Endif
Endif

If !Empty( SF2->F2_REDESP )
	cTransp := SF2->F2_REDESP
Else
	cTransp := SF2->F2_TRANSP
Endif                        

DbSelectArea("SA4")
DbSetORder(1)
SA4->(DbSeek(xFilial("SA4") + cTransp ))

DbSelectArea("SZZ")
DbSetOrder(1)
SZZ->(DbSeek(xFilial("SZZ") + cTransp + SF2->F2_LOCALIZ))

DbSelectArea("SA1")
DbsetORder(1)
SA1->(DbSeek(xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA)))

//FR - 08/05/2011
DbSelectArea("SD2")
SD2->(DBSETORDER(3))
If SD2->(Dbseek(xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE ))
	cPedido := SD2->D2_PEDIDO
	cTES    := SD2->D2_TES
Endif

DbSelectArea("SC5")
DbsetORder(1)
If SC5->(DbSeek(xFilial("SC5")+ cPedido )) 	
	lMostraPCli := U_FATC017(  SC5->C5_OCCLI  )	
	cPedCli     := SC5->C5_OCCLI								
Endif
//FR


cMsg := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
cMsg += '<html xmlns="http://www.w3.org/1999/xhtml">'
cMsg += '<head>'
cMsg += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />'
cMsg += '<title>Untitled Document</title>'
cMsg += '<style type="text/css">'
cMsg += '<!--'
cMsg += '.style1 {font-family: Arial, Helvetica, sans-serif}'
cMsg += '.style2 {font-family: Arial, Helvetica, sans-serif; font-size: 9px; }'
cMsg += '.style3 {font-size: 11px}'
cMsg += '.style4 {font-size: 16px}'
cMsg += '.style5 {font-size: 12px}'
cMsg += '.style7 {font-family: Arial, Helvetica, sans-serif; font-size: 11px; }'
cMsg += '.style9 {font-size: 12px; color: #FF0000; }'
cMsg += '.style13 {color: #009900}'
cMsg += '.style14 {font-size: 10px}'
cMsg += '.style15 {'
cMsg += '	color: #FF0000;'
cMsg += '	font-weight: bold;'
cMsg += '}'
cMsg += '.style16 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; }'
cMsg += '.style17 {font-family: Arial, Helvetica, sans-serif; color: #009900;}'
cMsg += '-->'
cMsg += '</style>'
cMsg += '</head>'
cMsg += '<body>'
cMsg += '<p><a href="http://www.ravaembalagens.com.br" target="_blank"><span style="text-decoration:none;text-underline:none"><img'
cMsg += '  src="http://www.ravaembalagens.com.br/figuras/topemail.gif" name="_x0000_i1025" width="682"'
cMsg += '  height="88" border="0" id="_x0000_i1025" /></span></a></p>'
cMsg += '<p><span class="style1"><span class="style5"><strong>Cabedelo -</strong> <strong>PB,</strong> <strong>'+StrZero(Day(dDataBase),2)+' de '+MesExtenso(dDataBase)+' de '+Str(Year(dDataBase))+'</strong></span><br />'
cMsg += '</span></p>'
cMsg += '<table border="1" cellspacing="0" cellpadding="0">'
cMsg += '  <tr>'
cMsg += '    <td width="682" height="66" valign="top" class="style1"><div align="center"><strong><span class="style4">P&Oacute;S-VENDAS    / RAVA </span><br />'
cMsg += '        <span class="style5">INFORMATIVO DE FATURAMENTO DE PEDIDO DE COMPRA</span> <br />'
cMsg += '        <span class="style14">PROGRAMA&Ccedil;&Atilde;O DE ENTREGA DE ACORDO COM O PRAZO DA TRANSPORTADORA PARA SUA LOCALIDADE</span></strong> </div></td>'
cMsg += '  </tr>'
cMsg += '</table>'
cMsg += '<p class="style1"><strong><span class="style5">Empresa / Cliente:&nbsp; '+SA1->A1_NREDUZ+'<br />'
cMsg += '    At.: Dep. de Compras/Sr.(a)&nbsp; '+SA1->A1_CONTATO+' <br />'
cMsg += '    <br />'
cMsg += '    <br />'
cMsg += '    Passamos dados abaixo em rela&ccedil;&atilde;o ao envio de sua mercadoria: <br />'
cMsg += '    Data do faturamento: '+StrZero(Day(SF2->F2_EMISSAO),2)+' de '+MesExtenso(SF2->F2_EMISSAO)+' de '+Str(Year(SF2->F2_EMISSAO))+'<br />'
cMsg += '    <strong>Data de  Sa&iacute;da: '+StrZero(Day(SF2->F2_DTEXP),2)+' de '+MesExtenso(SF2->F2_DTEXP)+' de '+Str(Year(SF2->F2_DTEXP))+'<br />'
cMsg += '    Transportadora:&nbsp;'+SA4->A4_NREDUZ+'<br />' //Incluir transportadora redespacho quando Cliente  Manaus / Boa Vista / Macapa
cMsg += '    Nota(s) Fiscal (is): '+SF2->F2_DOC+'<br />'

If lMostraPCli
	cMsg += '    Ordem de Compra Cliente: '+ cPedCli + '<br />'
Endif        

//colocado em 25/05/2011 por antonio

nSaldoNF:=SaldoNF(cPedido)
If nSaldoNF=0
   If QtdNF(cPedido)=1
      cMsg += '    Faturamento Total <br />'
      cTit	:= 'Faturamento Total'
   else
      cMsg += '    Saldo <br />'
      cTit	:= 'Saldo'
   endif
else
   cMsg += '    Faturamento Parcial <br />'
      cTit	:= 'Faturamento Parcial'
Endif 

//

cMsg += '    Valor (es) total (is): R$ &nbsp; '+Transform(SF2->F2_VALBRUT,"@E 9,999,999,999.99")+'<br />'
//dDtEntr := U_CalcPrv(SF2->F2_DTEXP,SA4->A4_DIATRAB, SZZ->ZZ_PRZENT)
dDtEntr := U_CalPrv(SF2->F2_DTEXP,SA4->A4_DIATRAB, SZZ->ZZ_PRZENT)

cMsg += '    Previs&atilde;o de entrega: '+StrZero(Day(dDtEntr),2)+' de '+MesExtenso(dDtEntr)+' de '+Str(Year(dDtEntr))+'</strong></span><span class="style5"></span></p>'
cMsg += '<table border="1" cellspacing="0" cellpadding="0" width="682">'
cMsg += '  <tr>'
cMsg += '    <td width="682" valign="top" class="style2"><p><br />'
cMsg += '        <span class="style5"><strong>Procuramos atender a todas as exig&ecirc;ncias, portanto    solicitamos que nos comuniquem as ocorr&ecirc;ncias de eventuais problemas como:    atraso na entrega, devolu&ccedil;&atilde;o de mercadorias, o n&atilde;o recebimento do boleto    banc&aacute;rio, o n&atilde;o recebimento de aviso de vencimento e caso haja solicita&ccedil;&atilde;o de    prorroga&ccedil;&atilde;o gentileza nos comunicar com 15 dias de anteced&ecirc;ncia ao    vencimento.</strong></span></p>'
cMsg += '      <p align="center"><span class="style5"><span class="style15"></span></span><span class="style3"><span class="style9"><strong>ATEN&Ccedil;&Atilde;O:</strong><br />'
cMsg += '        <strong><em><u>N&atilde;o aceitaremos devolu&ccedil;&atilde;o sem a pr&eacute;via    autoriza&ccedil;&atilde;o do nosso servi&ccedil;o de P&oacute;s-Vendas ao cliente.</u></em></strong> </span></span></p></td>'
cMsg += '  </tr>'
cMsg += '  <tr>'
cMsg += '    <td width="647" valign="top" class="style1"><p>&nbsp;</p></td>'
cMsg += '  </tr>'
cMsg += '</table>'
//FR - 25/07/12 - Solicitado por DANIELA : Aviso para não responder este informativo
cMsg += '<p align="center"><span class="style5"><span class="style15"></span></span><span class="style3"><span class="style9"><strong><em><u>ESTE É UM EMAIL AUTOMÁTICO DO SISTEMA, E NÃO DEVERÁ SER RESPONDIDO.</u></em></strong></span></span></p></td>'

//email do sac
cMsg += '<p class="style16"> Solicita&ccedil;&otilde;es de total  acompanhamento de entrega atrav&eacute;s do e-mail&nbsp; <a href="mailto:posvendas@ravaembalagens.com.br">posvenda@ravaembalagens.com.br</a> ou <a href="mailto:sac@ravaembalagens.com.br">sac@ravaembalagens.com.br</a> ou 0800 014 2345.</p>'
//cMsg += '<p class="style16"> Solicita&ccedil;&otilde;es de total  acompanhamento de entrega atrav&eacute;s do e-mail&nbsp; <a href="mailto:posvendas@ravaembalagens.com.br">posvenda@ravaembalagens.com.br</a> ou <a href="mailto:sac@ravaembalagens.com.br">sac@ravaembalagens.com.br</a> ou 0800 727 1915.</p>'
cMsg += '<table border="0" cellspacing="0" cellpadding="0" width="681">'
cMsg += '  <tr>'
cMsg += '    <td width="682" valign="top" class="style7"><div class="style5">'
cMsg += '      <p><strong>Obrigado por confiar em nossos servi&ccedil;os.&nbsp; Esperamos que as    mercadorias cheguem de acordo com seus desejos e nos declaramos prontos para    atender a qualquer reclama&ccedil;&atilde;o.</strong></p>'
cMsg += '    </div></td>'
cMsg += '  </tr>'
cMsg += '</table>'
cMsg += '<p align="left" class="style7">&nbsp;<br />'
cMsg += '  <span class="style5"><strong>P&oacute;s-Vendas/Rava </strong></span></p>'
cMsg += '<table width="682" border="0" cellpadding="0" cellspacing="0">'
cMsg += '  <tr>'
cMsg += '    <td width="682"><div align="justify" class="style14"><span class="style17">Rua Jos&eacute; Ger&ocirc;nimo da  Silva Filho (Ded&eacute;), 66 &ndash; Renascer &ndash; Cabedelo - PB / CEP:58310-000 / Contato:(83) 30481315</span></div></td>'
cMsg += '  </tr>'
cMsg += '  <tr>'
cMsg += '    <td><div align="justify" class="style14"><span class="style1"><a href="mailto:sac@ravaembalagens.com.br">sac@ravaembalagens.com.br</a>&nbsp;<span class="style13"> -&nbsp;&nbsp;  Atendimento&nbsp; a&nbsp; Clientes&nbsp;  0800 014 2345&nbsp;&nbsp; &ndash;&nbsp;&nbsp;&nbsp; CNPJ: 41.150.160/0001-02&nbsp;&nbsp;&nbsp; -&nbsp;  Insc. Estadual:&nbsp; 16.100.765-1</span></span></div></td>'
//cMsg += '    <td><div align="justify" class="style14"><span class="style1"><a href="mailto:sac@ravaembalagens.com.br">sac@ravaembalagens.com.br</a>&nbsp;<span class="style13"> -&nbsp;&nbsp;  Atendimento&nbsp; a&nbsp; Clientes&nbsp;  0800 727 1915&nbsp;&nbsp; &ndash;&nbsp;&nbsp;&nbsp; CNPJ: 41.150.160/0001-02&nbsp;&nbsp;&nbsp; -&nbsp;  Insc. Estadual:&nbsp; 16.100.765-1</span></span></div></td>'
cMsg += '  </tr>'
cMsg += '</table>'
cMsg += '</body>'
cMsg += '</html>'

//MsgInfo("Em anexo a este E-mail para o cliente, será enviado também, o espelho da Nota Fiscal.", "INFORMAÇÃO" )


//DBUSEAREA(.T.,"dbfcdxads", "\system\sigamat.emp","SM0", .T., .T. ) 
//DBCREATEINDEX ("\Temp\SM0-IND.cdx","M0_FILIAL+M0_CODIGO",{ || M0_FILIAL+M0_CODIGO },.F.)

//DBCREATEINDEX( cNome , cExpChave , [ bExpChave ], [ lUnico ]) --> Nil
//DBCREATEINDEX ("\teste\ind2.cdx","Nome+End",{ || Nome+End },.T.)

/*
DbUseArea(.t.,"DBFCDX",cArquivo,left(cArquivo,3),iModo,iLeitura)
//--> cArquivo : Nome do Arquivo
//--> ALias do arquivo
//--> iModo : .f. Exclusivo ou .t. Compartilhado
//--> iLeitura : .t. só Leitura ou .f. Leitura e Gravação
//--> iIndice : .t. Abre ou .f. Não Abre
*/         

cEspelho := U_FATR009( "SF2", nRegistro )
//DbCloseArea("SM0")
//DbClearIndex()
/*
If Alltrim(cTES) $ "507/516/543/547"
	eEmail += ";comercial@ravaembalagens.com.br"
	//eEmail += ";flavia.norat@ravaembalagens.com.br"
Endif                                              
*/

//If !Empty(SA1->A1_EMAIL)
   U_Send2Mail( Alltrim(SA1->A1_EMAIL) , eEmail, 'Informativo de Faturamento - Pedido - ' + cPedido + ' - ' + cTit,cMsg, cEspelho )  //voltar
   //qdo for testar, habilitar as duas linhas abaixo e desabilitar esta acima
   //eEmail := ""
   //U_Send2Mail( "flavia.rocha@ravaembalagens.com.br" , eEmail, 'Informativo de Faturamento',cMsg, cEspelho )
   
   
//Else
//   Alert( 'O e-mail não foi enviado ao cliente pois, o cadastro não está preenchido. Informar ao Pos-Vendas.')
//Endif

Return

***************

Static Function SaldoNF(cNum)

***************
local cQry:=''
local nRet

cQry:="SELECT C6_NUM,SUM(C6_QTDVEN-C6_QTDENT) SALDO "
cQry+="FROM "+RetSqlName("SC6")+" SC6 "
cQry+=" WHERE C6_NUM='"+cNum+"' " 
//cQry+= " WHERE C6_FILIAL='"+xFilial('SC6')+"' "
cQry+=" and C6_FILIAL='"+xFilial('SC6')+"' "
cQry+=" AND SC6.D_E_L_E_T_!='*' "
cQry+="GROUP BY C6_NUM " 

If Select("_TMPZ") > 0       ///FR - 24/05/11 - VERIFICAR SE O ALIAS JÁ ESTÁ ABERTO E FECHAR NA NOVA CONSULTA
	DbSelectArea("_TMPZ")    ///SENÃO, DÁ ERRO
	DbCloseArea()
Endif
TCQUERY cQry NEW ALIAS "_TMPZ"  


If ! _TMPZ->( EOF() )
   nRet:=_TMPZ->SALDO
endif 


Return nRet           

***************

Static Function QtdNF(cPedido)

***************
local cQry:=''
local nRet:=0

cQry:="SELECT COUNT(*) QTD FROM "+RetSqlName("SF2")+" SF2 WITH (NOLOCK) "
cQry+="WHERE F2_FILIAL='"+XFILIAL('SF2')+"' AND F2_DOC IN (select D2_DOC  from "+RetSqlName("SD2")+" SD2 WITH (NOLOCK) "
cQry+="WHERE "
cQry+="F2_FILIAL='"+XFILIAL('SD2')+"' AND D2_PEDIDO='"+cPedido+"' "
cQry+="AND D2_SERIE!='' "
cQry+="AND SD2.D_E_L_E_T_!='*' "
cQry+="GROUP BY  D2_DOC,D2_SERIE) "
cQry+="AND SF2.D_E_L_E_T_!='*' "

If Select("_TMPY") > 0       
	DbSelectArea("_TMPY")    
	DbCloseArea()
Endif

TCQUERY cQry NEW ALIAS "_TMPY" 

If  _TMPY->( !Eof() )
    nRet:=_TMPY->QTD
EndIf

_TMPY->(DBCLOSEAREA())

Return nRet



 
*************
User Function FUNCTRANS(cLocalid,cTran)
*************

Local cLocaliz := ""
Local nOP      := 0
Local aRET_tt  := {}
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private coTbl1

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oBrw1","oBtn1")
	
cLocaliz := cLocalid 
//posiciona na tab. de LOCALIDADExTRANSportadora
DbSelectArea("SZZ")
DbSetOrder(2) 

if SZZ->(DbSeek(xFilial("SZZ")+cLocaliz))     

	
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	oDlg1      := MSDialog():New( 148,385,347,853,"Selecione a Transportadora",,,.F.,,,,,,.T.,,,.F. )
	oTbl1()
	DbSelectArea("TMP")
	oBrw1      := MsSelect():New( "TMP","","",{{"TRANSP","","Codigo",""},;
	{"NOME","","Nome",""}},.F.,,{004,003,064,227},,, oDlg1 )
	oBtn1      := TButton():New( 072,190,"Ok",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
	oBtn1:bAction := {|| aRET_tt := conftrans()}
	
	TMP->( __DbZap() ) // LIMPAR O CONTEUDO DA TABELA TEMPORARIA
	
	DbSelectArea("SA4" )
	DbSetOrder(1)
	
	while SZZ->(!EOF()) .AND. SZZ->ZZ_LOCAL = cLocaliz
		If SA4->(DbSeek(xFilial("SA4")+SZZ->ZZ_TRANSP,.F.))
			If A4_ATIVO!='N'
				If SZZ->ZZ_ATIVO != 'N'
					RecLock("TMP",.T.)
					TMP->TRANSP	:= SZZ->ZZ_TRANSP
					TMP->NOME	:= SA4->A4_NOME //POSICIONE("SA4", 1, xFilial("SA4") +SZZ->ZZ_TRANSP , "A4_NOME" )
					TMP->(MsUnLock())
				EndIf
			EndIf
		Endif
		SZZ->(dbskip())
		
	EndDo
	
	IF !EMPTY(cLocaliz)
		RecLock("TMP",.T.)
		TMP->TRANSP:='024' // O Mesmo
		TMP->NOME:=POSICIONE("SA4", 1, xFilial("SA4") +'024' , "A4_NOME" )
		TMP->(MsUnLock())
	ENDIF
	
	TMP->( DbGotop() )
	
	oBrw1:oBrowse:Refresh()
	
	oDlg1:Activate(,,,.T.)
	
	TMP->(DBCloseArea())
	Ferase(coTbl1) // APAGA O ARQUIVO DO DISCO
	

Else
		
	alert('Localidade não Encontrada ou Escolha outra Localidade para a transportadora!!!!')
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	oDlg1      := MSDialog():New( 148,385,347,853,"Selecione a Transportadora",,,.F.,,,,,,.T.,,,.F. )
	oTbl1()
	DbSelectArea("TMP")
	oBrw1      := MsSelect():New( "TMP","","",{{"TRANSP","","Codigo",""},;
	{"NOME","","Nome",""}},.F.,,{004,003,064,227},,, oDlg1 )
	oBtn1      := TButton():New( 072,190,"Ok",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
	oBtn1:bAction := {|| aRET_tt:= conftrans()}
	
	TMP->( __DbZap() ) // LIMPAR O CONTEUDO DA TABELA TEMPORARIA
	  	
  	IF !EMPTY(cLocaliz)
		RecLock("TMP",.T.)
		TMP->TRANSP:='024' // O Mesmo
		TMP->NOME:=POSICIONE("SA4", 1, xFilial("SA4") +'024' , "A4_NOME" )
		TMP->(MsUnLock())
	ENDIF
	
	TMP->( DbGotop() )
	
	oBrw1:oBrowse:Refresh()
	
	oDlg1:Activate(,,,.T.)
	
	TMP->(DBCloseArea())
	Ferase(coTbl1) // APAGA O ARQUIVO DO DISCO
  // lRet:=.T.
EndIF

Return(aRET_tt) //  .T. //lRet


***************

Static Function conftrans()

***************

Local nOPCONF := 0
Local aOPTrans:= {}
    //if alltrim(upper(FunName())) == "FATC019"
	//   M->ZC5_TRANSP:=TMP->TRANSP            
    //else
	//   M->C5_TRANSP:=TMP->TRANSP            
    //Endif
    cTran := TMP->TRANSP
    //oGetTT:bSetGet := {|u| If(PCount()>0,cTran:=u,cTran)}  
	
	//cRtTransp:=TMP->TRANSP 
	//lRet:=.T.
	//dbselectarea('SC5') 
	oDlg1:End()
//Endif

If MsgYesNo("Confirma Alteração de Transportadora ?")
	nOPCONF := 1
	Aadd(aOPTrans, nOPCONF)
	Aadd(aOPTrans, cTran)
Else
	nOPCONF := 0
	cTran   := ""
	Aadd(aOPTrans, nOPCONF)
	Aadd(aOPTrans, cTran)
Endif


Return(aOPTrans) 


return cRtTransp 


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl1() - Cria temporario para o Alias: TMP
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl1()

Local aFds := {}

Aadd( aFds , {"TRANSP"  ,"C",006,000} )
Aadd( aFds , {"NOME"    ,"C",040,000} )

coTbl1 := CriaTrab( aFds, .T. )
Use (coTbl1) Alias TMP New Exclusive

Return 