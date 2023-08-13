#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#Include 'Topconn.ch'
#include "ap5mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINC012  ºAutor  ³Flávia Rocha         º Data ³  15/07/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exibe browse do SX5, tabela PJ (% JUROS)                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Humberto / Controller Financeiro                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
***************************************
User Function FINC012()
***************************************

								
Private cCadastro  := "Atualização da % Juros"

U_AtuJURS()

Return 



*****************************
User Function AtuJURS()         
*****************************


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private cDescTP    := Space(30)
Private cTPJUR     := Space(10)
Private nOK		   := 0 
Private coTbl1


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oBrw1","oGrp1","oSay1","oGet1","oCBox1","oBtn1","oBtn2","oBtn3")
SetPrvt("oDlg1","oGrp1","oSayTPJ","oSayPerc","oGetTP","oGetPerc","oGetDescTP")


//oDlg1 := MSDialog():New( 116,154,601,1050,"Atualiza % Juros",,,.F.,,,,,,.T.,,,.F. )
oDlg1 := MSDialog():New( 116,154,301,650,"Atualiza % Juros",,,.F.,,,,,,.T.,,,.F. )
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

oTbl1()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/



fGetJURS()
DbSelectArea("TMPFR")


/*
oBrw1 := MsSelect():New( "TMPFR","","",{{"X5COD","","Tipo",""},;
									  {"X5DESCRI","","Descrição",""},;
									  {"X5CONTEUD","","Percentual",""} },.F.,,;
                                      {005,004,78,248},,, oDlg1 )   //
                                       //alt1,col,alt2,larg  //alt1 = posicionamento na dialog , alt2 = altura do msselect
                       
*/

oBrw1 := MsSelect():New( "TMPFR","","",{  {"X5DESCRI","","Descrição",""},;
									  {"X5CONTEUD","","Percentual",""} },.F.,,;
                                      {005,004,58,248},,, oDlg1 )   //
                                       //alt1,col,alt2,larg  //alt1 = posicionamento na dialog , alt2 = altura do msselect
                       
                       
oAtualiza:= TButton():New( 070,112,"Atualiza",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
oAtualiza:bAction := {|| fAtualiza( TMPFR->X5COD, TMPFR->X5DESCRI)  }  

oSair:= TButton():New( 070,192,"Sair",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
oSair:bAction := {|| oDlg1:End() }


oDlg1:Activate(,,,.T.)

TMPFR->(DbCloseArea())
Ferase(coTbl1+".DBF")
Ferase(coTbl1+OrdBagExt())

Return

****************************
Static Function fAtualiza(cTPJUR,cDescTP) 
****************************
Local nPerc := 0
Private oDlg2
Private oGrp2
Private oGetDescTP
Private OK       		//botão
Private Cancelar        //botão
Private cQuemPode := GetMv("RV_FINC012")

If !Upper(Substr(cUsuario,7,15))  $ cQuemPode
	Alert("Você Não Tem Acesso Para Atualizar a Taxa de Juros! " + CHR(13) + CHR(10) + "Somente: " + cQuemPode)
	RETURN .F.
Endif	

oDlg2      := MSDialog():New( 685,809,877,1180,"Percentual Juros",,,.F.,,,,,,.T.,,,.F. )
oGrp2      := TGroup():New( 004,004,064,176,"  Informe Aqui   ",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )

oSayTPJ    := TSay():New( 019,016,{||"Tipo Juros:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetDescTP := TGet():New( 018,064,,oGrp2,104,008,'@!',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cDescTP",,)
oGetDescTP:bSetGet := {|u| If(PCount()>0,cDescTP:=u,cDescTP)}

oSayPerc   := TSay():New( 043,016,{||"Percentual:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetPerc   := TGet():New( 042,064,,oGrp2,060,008,'@E 999.99',,CLR_BLUE,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nPerc",,)
oGetPerc:bSetGet := {|u| If(PCount()>0,nPerc:=u,nPerc)}


OK         := TButton():New( 075,082,"OK",oGrp2,,037,012,,,,.T.,,"",,,,.F. )
OK:bAction := {|| (nOK := 1 , oDlg2:End() ) }

Cancelar   := TButton():New( 075,134,"Cancelar",oGrp2,,037,012,,,,.T.,,"",,,,.F. )
Cancelar:bAction := {|| (nOK := 0 , oDlg2:End() ) }



oDlg2:Activate(,,,.T.)
cPercen:= ''
If nOK = 1
	//alert("grava x5")  
	RecLock("TMPFR", .F.)
	TMPFR->X5CONTEUD := nPerc
	TMPFR->(MsUnlock())
	SX5->(Dbsetorder(1))
	If SX5->(Dbseek(xFilial("SX5") + 'PJ' + TMPFR->X5COD ))
		RecLock("SX5", .F.) 
		cPercen := Str(nPerc)
		SX5->X5_DESCRI := cPercen 	
		SX5->(MsUnlock()) 
	Endif
Endif


Return


***************************
Static Function fGETJURS() 
***************************

Local cQuery := ""
Local LF     := CHR(13) + CHR(10) 
Local cAlias := "SX5X"

cQuery := "Select * from " + LF
cQuery += " " + RetSqlName("SX5") + " SX5 " + LF
cQuery += " Where X5_TABELA = 'PJ' " + LF
cQuery += " AND X5_CHAVE IN ( 'JURMES' , 'INFANO') " + LF
cQuery += " AND D_E_L_E_T_ = '' " + LF
cQuery += " AND X5_FILIAL = '" + Alltrim(xFilial("SX5")) + " ' " + LF
MemoWrite("C:\Temp\FGETCOT.SQL",cQuery)

If Select("SX5X") > 0
	DbSelectArea("SX5X")
	DbCloseArea()	
EndIf 

// Cria tabela temporaria
MsAguarde({|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)},"Aguarde...","Processando Dados...")

//TCSetField( cAlias, "C8_EMISSAO", "D")
//TCSetField( cAlias, "C8_DATPRF", "D")


SX5X->(Dbgotop())
While ! SX5X->(EOF())
   
 	RecLock("TMPFR",.T.)	   		 
 	TMPFR->X5COD   := SX5X->X5_CHAVE
 	If SX5X->X5_CHAVE = 'JURDIA'
		TMPFR->X5DESCRI:= 'JUROS AO DIA'
	ElseIf SX5X->X5_CHAVE = 'JURMES'
		TMPFR->X5DESCRI:= 'JUROS AO MES'
	ElseIf SX5X->X5_CHAVE = 'INFANO'
		TMPFR->X5DESCRI:= 'INFLACAO ANUAL'
	Endif
	TMPFR->X5CONTEUD := Val(SX5X->X5_DESCRI)
	TMPFR->(MsUnLock())
  

   SX5X->(DbSkip())
Enddo

TMPFR->(DbGoTop())
SX5X->(DbCloseArea())

Return


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl1() - Cria temporario para o Alias: TMP
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl1()

Local aFds := {}

//Aadd( aFds, {"AT"      ,"C",001,000} )
Aadd( aFds, {"X5COD"       ,"C",006,000} )
Aadd( aFds, {"X5DESCRI"     ,"C",030,000} )
Aadd( aFds, {"X5CONTEUD"     ,"N",006,002} )

coTbl1 := CriaTrab( aFds, .T. )
Use (coTbl1) Alias TMPFR New Exclusive
//Index On DOC + SERIE To ( coTbl1 )

Return 
