#Include "Rwmake.ch"
#Include "colors.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "Protheus.ch"
#INCLUDE 'FONT.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT110ROT ºAutor  ³Gustavo Costa        º Data ³  10/25/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE no inico da rotina e antes da execução da Mbrowse da SC,º±±
±±º          ³ utilizado para adicionar mais opções no aRotina.           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


/*
----------------------------------------------------------------------------
Programa: MT110ROT - PONTO DE ENTRADA NA ROTINA DE SOLICITAÇÕES DE COMPRA
Alterado por: Flávia Rocha
Data    : 03/10/2013
Objetivo: Possibilitar tela para Pré-Aprovação de SCs Manutenção
----------------------------------------------------------------------------
*/

*************************
User Function MT110ROT() 
*************************

//Define Array contendo as Rotinas a executar do programa     
// ----------- Elementos contidos por dimensao ------------    
// 1. Nome a aparecer no cabecalho                             
// 2. Nome da Rotina associada                                 
// 3. Usado pela rotina                                        
// 4. Tipo de Transa‡„o a ser efetuada                         
//    1 - Pesquisa e Posiciona em um Banco de Dados            
//    2 - Simplesmente Mostra os Campos                        
//    3 - Inclui registros no Bancos de Dados                  
//    4 - Altera o registro corrente                           
//    5 - Remove o registro corrente do Banco de Dados         
//    6 - Altera determinados campos sem incluir novos Regs     

AAdd( aRotina, { 'PRÉ-APROVAÇÃO', 'U_PreApro("SC1", SC1->(recno()), 4)', 0, 4 } )
AAdd( aRotina, { 'Consulta Lib.', 'U_fConsultaLib()', 0, 4 } )

Return aRotina                          

***************************************
User Function PreApro(cAlias, nRecno) 
***************************************
Local cRespManut:= GetMv("RV_110BLO1")  //Codigo usuário responsável pela Manutenção -> 000008 - JORGE   
Local cPreManut  := GetMv("RV_110STTS") //tipos de produtos que precisam de pré-aprovação do ger. manutenção
Local dEmissao  := CTOD("  /  /    ")
Local oVerd
Local oVerm
Local oAzul
Local oPreto
Local oBranco
Local cSolicit	:= "" 
Local cObs      := ""
Private cJust     := Space(200)

Private coTbl1


Private cNumSC	:= ""
Private nOk       := 0

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oBrw1","oGrp1","oSay1","oGet1","oCBox1","oBtn1","oBtn2","oBtn3")

	If ( SC1->C1_PREOK = "S" .or. SC1->C1_PREOK = "D" )
		Aviso(	"Pré-Aprovação",;
					"Esta SC Já Foi Pré-Aprovada.",;
					{"&Continua"},,;
					"SC: " + SC1->C1_NUM )
					Return(Nil)
	EndIf

If __cUserId $ cRespManut .or. __cUserId $ '000000'  //'000008' //Ger. Manutenção Jorge
	If !Empty(SC1->C1_PREAPRO) .OR. (SUBSTR(SC1->C1_PRODUTO,1,2) $ cPreManut)
	
		SC1->(Dbgoto(nRecno))
		dEmissao := SC1->C1_EMISSAO 
		cNumSC   := SC1->C1_NUM
		
		//oDlg1 := MSDialog():New( 116,154,601,1050,"Pré-Aprovação SC",,,.F.,,,,,,.T.,,,.F. )
		oDlg1 := MSDialog():New( 116,154,501,1050,"Pré-Aprovação SC",,,.F.,,,,,,.T.,,,.F. )
		oTbl1()
		
		cSolicit  := SC1->C1_SOLICIT 
		cObs      := SC1->C1_OBS
			
		fGetSC( SC1->C1_NUM  )
		
		DbSelectArea("TMPFR")
		
		
		oVerd       := LoadBitmap( GetResources(), "BR_VERDE" )
		oVerm       := LoadBitmap( GetResources(), "BR_VERMELHO" )
		oAzul       := LoadBitmap( GetResources(), "BR_AZUL" )
		oPreto      := LoadBitmap( GetResources(), "BR_PRETO" )
		oBranco     := LoadBitmap( GetResources(), "BR_BRANCO" )
		
		
		
		oBrw1 := MsSelect():New( "TMPFR","","",{{"C1IT","","Item",""},;
											  {"C1PROD","","Produto",""},;
											  {"C1TIPO","","Tipo Prod.",""},;
		  									  {"B1DESC","","Descrição",""},;
		                                      {"C1QT","","Quantidade",""},;
		                                      {"C1UM","","Und.Medida",""},;
		                                      {"C1ENTR","","Prev.Entrega",""} },.F.,,;
		                                      {065,004,138,398},,, oDlg1 )   //
		                                       //alt1,col,alt2,larg  //alt1 = posicionamento na dialog , alt2 = altura do msselect
		                       
		oGrp1 := TGroup():New( 003,004,048,425," Dados da SC ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oSayCOT := TSay():New( 014,010,{||"Numero SC"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oGetCOT := TGet():New( 013,040,,oGrp1,60,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cNumSC",,)
		oGetCOT:bSetGet := {|u| If(PCount()>0,cSC:=u,cNumSC)}
		
		
		oSayFORN := TSay():New( 014,110,{||"Solicitante: "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oGetFORN := TGet():New( 013,150,,oGrp1,100,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cSolicit",,)
		oGetFORN:bSetGet := {|u| If(PCount()>0,cSolicit:=u,cSolicit)}   
		
		oSayVALT := TSay():New( 036,010,{||"Emissão: "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oGetVALT := TGet():New( 035,040,,oGrp1,60,008,'@D',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","dEmissao",,)
		oGetVALT :bSetGet := {|u| If(PCount()>0,dEmissao:=u,dEmissao)} 
		
		oSayVALT := TSay():New( 036,110,{||"Observação: "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oGetVALT := TGet():New( 035,150,,oGrp1,120,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cObs",,)
		oGetVALT :bSetGet := {|u| If(PCount()>0,cObs:=u,cObs)} 
	
		oSayIT := TSay():New( 054,007,{||"Itens:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		
		oSayJUST := TSay():New( 150,007,{||"Justificativa: "},oDlg1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
		oGetJUST := TGet():New( 149,044,,oDlg1,200,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cJust",,)
		oGetJUST :bSetGet := {|u| If(PCount()>0,cJust:=u,cJust)} 
	
		//oBtn3 := TButton():New( 218,205," OK ",oDlg1,,043,012,,,,.T.,,"",,,,.F. )
		oBtn3 := TButton():New( 168,205," OK ",oDlg1,,043,012,,,,.T.,,"",,,,.F. )
		oBtn3:bAction := {|| (nOK := 1 , VerCampos(cJust) ) }
		
		//oBtn4 := TButton():New( 218,275," Cancelar ",oDlg1,,043,012,,,,.T.,,"",,,,.F. )
		oBtn4 := TButton():New( 168,275," Cancelar ",oDlg1,,043,012,,,,.T.,,"",,,,.F. )
		oBtn4:bAction := {|| (nOK := 0 , oDlg1:End() )}
		
		oDlg1:Activate(,,,.T.)
		
		TMPFR->(DbCloseArea())
		Ferase(coTbl1+".DBF")
		Ferase(coTbl1+OrdBagExt())
        
	Else //C1_PREAPRO vazio
		Alert("Esta SC Não Precisa de Pré-Aprovação")
	Endif
Else  //se o usuário logado é o Ger. Manutenção (Jorge)
	Alert("Somente o Gerente de Manutenção Tem Acesso a Esta Opção!")
Endif

                                
Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl1() - Cria temporario para o Alias: TMP
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl1()

Local aFds := {}

Aadd( aFds, {"C1IT"       ,"C",004,000} )
Aadd( aFds, {"C1PROD"     ,"C",009,000} )
Aadd( aFds, {"C1TIPO"     ,"C",002,000} )
Aadd( aFds, {"C1UM"       ,"C",002,000} )
Aadd( aFds, {"B1DESC"     ,"C",030,000} )
Aadd( aFds, {"C1QT"       ,"N",014,002} )
Aadd( aFds, {"C1ENTR"     ,"D",008,000} )

coTbl1 := CriaTrab( aFds, .T. )
Use (coTbl1) Alias TMPFR New Exclusive
//Index On DOC + SERIE To ( coTbl1 )

Return 


************************************************************************************************
Static Function fGetSC( cSC )
************************************************************************************************

Local cQuery    := ""
Local cAlias    := "SC1X"
Local aCols		:= {}        
Local LF 		:= CHR(13) + CHR(10)


		cQuery := " SELECT  * " + LF
	    cQuery += " From " + RetSqlname("SC1") + " SC1 " + LF
	    cQuery += " ," + RetSqlname("SB1") + " SB1 " + LF
		cQuery += " WHERE " + LF
		cQuery += " C1_FILIAL  = '" + xFilial("SC1") + "' " + LF
		cQuery += " AND C1_NUM = '"  + Alltrim(cSC)  + "' " + LF
		cQuery += " AND C1_PRODUTO = B1_COD " + LF
		cQuery += " AND SC1.D_E_L_E_T_ = ' '  "
		cQuery += " AND SB1.D_E_L_E_T_ = ' '  "
		cQuery += " ORDER BY C1_NUM, C1_ITEM " + LF
MemoWrite("C:\Temp\FGETSC.SQL",cQuery)

If Select("SC1X") > 0
	DbSelectArea("SC1X")
	DbCloseArea()	
EndIf 

// Cria tabela temporaria
MsAguarde({|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)},"Aguarde...","Processando Dados...")

TCSetField( cAlias, "C1_EMISSAO", "D")
TCSetField( cAlias, "C1_DATPRF", "D")


SC1X->(Dbgotop())
While ! SC1X->(EOF())
   
 	RecLock("TMPFR",.T.)	   		 
 	TMPFR->C1IT   := SC1X->C1_ITEM
	TMPFR->C1PROD := SC1X->C1_PRODUTO
	TMPFR->C1TIPO := SC1X->B1_TIPO
	TMPFR->C1UM   := SC1X->C1_UM
	TMPFR->C1QT   := Round(SC1X->C1_QUANT,4)
	TMPFR->C1ENTR := SC1X->C1_DATPRF
	TMPFR->B1DESC := SC1X->B1_DESC
	TMPFR->(MsUnLock())
  

   SC1X->(DbSkip())
Enddo

TMPFR->(DbGoTop())
SC1X->(DbCloseArea())

Return
      








/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :fConsultaLib ³ Autor :Gustavo Costa      ³ Data :25/10/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao : Monta a tela com as liberações das solicitações.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function fConsultaLib()

Local cQuery		:= ""
Local cSolic		:= SC1->C1_SOLICIT
Local cNum			:= SC1->C1_NUM
Local cCC 			:= SC1->C1_CC
Local cContaC		:= ""
Local cContaAdm	:= Posicione("SB1",1,xFilial("SB1")+SC1->C1_PRODUTO, "B1_XCCADM")
Local cContaPro	:= Posicione("SB1",1,xFilial("SB1")+SC1->C1_PRODUTO, "B1_XCCPROD")
Local aCampos 	:= {}
Local aCmp			:= {}
Local cObs	
Local cContaProd := ""
Local cContaAdm  := ""		

cQuery	:= " SELECT * FROM " + RETSQLNAME("ZB5")
cQuery	+= " WHERE ZB5_NUM = '" + SC1->C1_NUM + "' "
cQuery	+= " AND D_E_L_E_T_ <> '*' "
cQuery	+= " AND ZB5_FILIAL = '" + xFilial("ZB5") + "' " 

If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

TMP->(dbgotop())

If Empty(TMP->ZB5_NUM)
	MsgAlert("Sem Registro!")
	TMP->(DBCLOSEAREA())
	Return
EndIf

If SubStr(cCC,1,1) == "7"
	cContaC		:= cContaProd
Else
	cContaC		:= cContaAdm
EndIf

AADD(aCmp,{"ZB5_NUM" 	,"","Número"  	,""  	})					
AADD(aCmp,{"ZB5_SEQ" 	,"","Seq."			,""  	})					
AADD(aCmp,{"ZB5_DATA"	,"","Data" 		,""		})					
AADD(aCmp,{"ZB5_HORA"	,"","Hora" 		,""		})					
AADD(aCmp,{"ZB5_USUARI"	,"","Usuário"		,""		})					

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oPanel1","oGrp1","oBrw1","oGrp2","oMGet1","oSay1","oGet1","oSay2","oGet2","oSay3","oGet3")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 186,373,562,979,"",,,.F.,,,,,,.T.,,,.F. )
oPanel1    := TPanel():New( 000,000,"",oDlg1,,.F.,.F.,,,301,044,.T.,.F. )
oGrp1      := TGroup():New( 044,000,126,301,"Liberações",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
DbSelectArea("ZB5")

oBrw1      := MsSelect():New( "ZB5",,"ZB5->ZB5_NUM == SC1->C1_NUM",aCmp,.F.,,{052,004,123,297},,, oGrp1 ) 
//oBrw1      := MsSelect():New( "XLIB","","",aCmp,.F.,,{052,004,123,297},,, oGrp1 ) 
oBrw1:oBrowse:nClrPane := CLR_BLACK
oBrw1:oBrowse:nClrText := CLR_BLACK
oBrw1:oBrowse:bChange := {|| cOBS := ZB5->ZB5_OBS, oMGet1:Refresh() }

oGrp2      := TGroup():New( 126,000,183,301,"Observação",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oMGet1     := TMultiGet():New( 133,004,,oGrp2,293,048,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
oMGet1:bSetGet := {|u| If(PCount()>0,cOBS:=u,cOBS)}

oSay1      := TSay():New( 006,004,{||"Solicitante"},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet1      := TGet():New( 005,040,,oPanel1,070,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet1:bSetGet := {|u| If(PCount()>0,cSolic:=u,cSolic)}

oSay2      := TSay():New( 006,124,{||"Centro de Custo"},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,041,008)
oGet2      := TGet():New( 006,169,,oPanel1,128,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet2:bSetGet := {|u| If(PCount()>0,cCC:=u,Alltrim(cCC) + " - " + Posicione("CTT",1,xFilial("CTT")+cCC,"CTT_DESC01"))}

oSay3      := TSay():New( 024,004,{||"Conta"},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet3      := TGet():New( 023,040,,oPanel1,257,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet3:bSetGet := {|u| If(PCount()>0,cContaC:=u,AllTrim(cContaC) + " - " + Posicione("CT1",1,xFilial("CT1")+cContaC,"CT1_DESC01"))}

oDlg1:Activate(,,,.T.)

Return

*************************************
Static Function VerCampos(cCampo)    
************************************

If Empty(cCampo)
			Aviso(	"Pré-Aprovação",;			
				'Por favor, Preencha a Justificativa...' ,;
				{"&Continua"},,;
				"SC: " + SC1->C1_NUM )
			
Elseif Alltrim(cCampo) = '.' .or. Alltrim(UPPER(cCampo)) $ 'XXXXXX/AAAAAA/CCCCCC/DDDDDD/KKKKK/ZZZZZZ'
	Aviso(	"Pré-Aprovação",;			
				'Por favor, Preencha a Justificativa...' ,;
				{"&Continua"},,;
				"SC: " + SC1->C1_NUM )
			
Else			//se estiver tudo preenchido....GRava
	While SC1->C1_FILIAL == xFilial("SC1") .AND. SC1->C1_NUM == cNumSC
		If RecLock("SC1", .F.)
			SC1->C1_PREOK := "S"       
			SC1->C1_NOMEPRE:= Substr(cUsuario,7,15)
			SC1->C1_PREJUST:= Alltrim(cCampo)
			SC1->(MsUnlock())
			Alert("SC Pré-Aprovada OK!")
		Endif
		SC1->(DBSKIP())
	Enddo
	oDlg1:End()

Endif 
                             
Return