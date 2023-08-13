#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPEC007   º Autor ³ AP6 IDE            º Data ³  12/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ EQUIPE 5S                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GPEC007


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cCadastro := "Auditorias Realizadas"
Private aItems    := {" " , "1=CONFORME", "2=NAO-CONFORME" , "3=NAO APLICA" } 
Private cDIR    := "" //define se será ADM, CX (Caixas) ou SC (Sacos)
Private cNOMEDIR:= ""
Private cSetor := Space(30)

Private aCondI := {}  //array das condições inseguras //será utilizado ao final da gravação da auditoria
                      //para incluir as não conformidades apontadas na auditoria, como novas condições inseguras

Private nP1        := 0
Private nP2        := 0
Private nP3        := 0

Private nP4        := 0
Private nP5        := 0
Private nP6        := 0

Private nP7        := 0
Private nP8        := 0
Private nP9        := 0

Private nP10        := 0
Private nP11        := 0
Private nP12        := 0

Private nP13        := 0
Private nP14        := 0
Private nP15        := 0

Private nP16        := 0
Private nP17        := 0
Private nP18        := 0

Private nP19        := 0
Private nP20        := 0
Private nP21        := 0
Private nP22        := 0
Private nP23        := 0
Private nP24        := 0
Private nP25        := 0
Private nP26        := 0
Private nP27        := 0
Private nP28        := 0

Private nBOXP1 := ""
Private nBOXP2 := ""
Private nBOXP3 := ""

Private nBOXP4 := ""
Private nBOXP5 := ""
Private nBOXP6 := "" 

Private nBOXP7 := ""
Private nBOXP8 := ""
Private nBOXP9  := ""

Private nBOXP10 := ""
Private nBOXP11 := ""
Private nBOXP12 := ""

Private nBOXP13 := ""
Private nBOXP14 := ""
Private nBOXP15 := ""

Private nBOXP16 := ""
Private nBOXP17 := ""
Private nBOXP18 := ""

Private nBOXP19 := ""
Private nBOXP20 := ""
Private nBOXP21 := ""
Private nBOXP22 := ""
Private nBOXP23 := ""
Private nBOXP24 := ""
Private nBOXP25 := ""
Private nBOXP26 := ""
Private nBOXP27 := ""
Private nBOXP28 := ""

Private nQC := 0
Private nQNC:= 0
Private nQNA:= 0 
Private nPETOT := 0
Private cModo  := ""   
Private aQP1 := {} //QUESTÕES PÁGINA 1
Private aQP2 := {} //QUESTÕES PÁGINA 2
Private aQP3 := {} //QUESTÕES PÁGINA 3
Private aQP4 := {} //QUESTÕES PÁGINA 4
Private aQP5 := {} //QUESTÕES PÁGINA 5

Private cQuest11 := ""
Private cQuest12 := ""
Private cQuest13 := ""
Private cQuest14 := ""
Private cQuest15 := ""
Private cQuest16 := ""
Private cQuest17 := ""
Private cQuest18 := ""
Private cQuest19 := ""

Private cQuest21 := ""
Private cQuest22 := ""
Private cQuest23 := ""
Private cQuest24 := ""
Private cQuest25 := ""
Private cQuest26 := ""
Private cQuest27 := ""
Private cQuest28 := ""
Private cQuest29 := ""

Private cQuest31 := ""
Private cQuest32 := ""
Private cQuest33 := ""
Private cQuest34 := ""
Private cQuest35 := ""
Private cQuest36 := ""
Private cQuest37 := ""
Private cQuest38 := ""
Private cQuest39 := ""

Private cQuest41 := ""
Private cQuest42 := ""
Private cQuest43 := ""
Private cQuest44 := ""
Private cQuest45 := ""
Private cQuest46 := ""
Private cQuest47 := ""
Private cQuest48 := ""
Private cQuest49 := ""

Private cQuest51 := ""
Private cQuest52 := ""
Private cQuest53 := ""
Private cQuest54 := ""
Private cQuest55 := ""
Private cQuest56 := ""
Private cQuest57 := ""
Private cQuest58 := ""
Private cQuest59 := ""

//página 1
SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay13","oSay15","oCBox1","oCBox2")
SetPrvt("oGet1","oGet2","oGet3","oBtn1","oBtn2","oBtn3","oGrp2","oGet4","oSay7","oSay8","oGet5","oSay9")



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta um aRotina proprio                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","U_Auditoria(2)",0,2} ,;
             {"Incluir","U_Auditoria(3)",0,3} ,;
             {"Alterar","U_Auditoria(4)",0,4} ,;
             {"Excluir","U_Auditoria(5)",0,5} }   //{"Excluir","AxDeleta",0,5} }

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "Z79"
Private nMenuOP    := 0

dbSelectArea("Z79")
dbSetOrder(1)

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString)

Return


********************************
User Function Auditoria(nMenuOp)
********************************

//página 2
SetPrvt("oDlg2","oGrp21","oGrp22", "oSay21","oSay22","oSay23","oSay24","oSay25","oSay26","oSay27",;
"oSay28","oSay29","oSay210","oSay211","oCBox21","oCBox22","oCBox23","oCBox24","oGet21","oGet22","oGet23","oGet24",;
"oBtn21","oBtn22","oBtn23")


PRIVATE nOpcA
PRIVATE nG := ""
PRIVATE cG := ""
Private oDlx
Private oCBoxChoice

Private cAuditor   := Space(15)
Private cCODAUD    := Space(6)
Private cDTAUD     := CTOD("  /  /    ")



//Local lProxPag := .F.
Private aSetores := {}
  


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlgX","oGrp1","oSay1","oCBoxChoice","cCombo","oCombo","oBtn1","oBtn2")

SX5->(Dbsetorder(1))
If SX5->(Dbseek(xFilial("SX5") + "ZW" ))
	While !SX5->(EOF()) .and. SX5->X5_TABELA = 'ZW'
		Aadd( aSetores, SX5->X5_CHAVE + '-' + SX5->X5_DESCRI) 
		SX5->(DBSKIP())
	Enddo
Endif

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
If nMenuOp = 3     //FR  - SE for = 3, é incluir, abre tela pra escolher a DIRETORIA: ADM, SACO OU CAIXAS
    cModo := " INCLUIR"
	oDlgX      := MSDialog():New( 152,414,312,739,"Auditoria 5S",,,.F.,,,,,,.T.,,,.F. )
	oGrp1      := TGroup():New( 004,005,051,155,"",oDlgx,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay1      := TSay():New( 022,008,{||"Escolha a Diretoria: "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	
	oCBoxChoice         := TComboBox():New( 022,064,,{"Administrativa", "Caixas" , "Plástico"},072,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,"nG" )
	oCBoxChoice:bSetGet := {|u| If(PCount()>0,nG:=u,nG)}
	oCBoxChoice:nAt := 1
	
	oBtn1      := TButton():New( 060,118,"Cancel",oDlgx,,037,012,,,,.T.,,"",,,,.F. )
	oBtn1:bAction := {|| (nOpcA := 0,oDlgx:End())}
	
	oBtn2      := TButton():New( 060,076,"OK",oDlgx,,037,012,,,,.T.,,"",,,,.F. )
	oBtn2:bAction := {||fTeste(nMenuOp),oDlgx:End()}
	oDlgx:Activate(,,,.T.)
ElseIf nMenuOp = 2
	cModo := "VISUALIZAR"
Elseif nMenuOp = 4
	cModo := "ALTERAR"
Elseif nMenuOp = 5
	cModo := "EXCLUIR"
Endif

If nMenuOp <> 3
	PrepCampos(nMenuOp)	
Endif



Return

//Esse teste vai dizer se é pra entrar na tela ADM, SACOS, CAIXAS
**********************
Static Function fTeste(nMenuOp)
**********************

IF oCBoxChoice:nAt = 1
	cDIR := "ADM"
	cNomeDIR := "ADMNISTRATIVO"
elseif oCBoxChoice:nAt = 2
	cDIR := "CX"               
	cNomeDIR := "CAIXAS"
elseif oCBoxChoice:nAt = 3
	cDIR := "SC"        
	cNomeDIR := "PLÁSTICO"
endif
LoadQuest(cDIR)  //CARREGA AS PERGUNTAS
CheckLIST(cDIR, nMenuOp) //CHAMA O CHECKLIST

Return

**********************************
Static Function CHECKLIST(cDIR, nMenuOp) 
**********************************

Private aPerg1 := {}

If nMenuOp = 3   //incluir
	cCODAUD    := GetSxENum("Z79","Z79_AUDIT")
	while Z79->( DbSeek( xFilial( "Z79" ) + cCODAUD ) )
	   ConfirmSX8()
	   cCODAUD := GetSxeNum("Z79","Z79_AUDIT")
	end
	
	cAuditor := Substr(cUsuario,7,15) 
	cDTAUD   := dDatabase
	cSetor := Space(30)
	//valores dos pesos
	  nP1        := 0
	  nP2        := 0
	  nP3        := 0	
	  nP4        := 0
	  nP5        := 0
	  nP6        := 0	
	  nP7        := 0
	  nP8        := 0
	  nP9        := 0	
	  nP10        := 0
	  nP11        := 0
	  nP12        := 0	
	  nP13        := 0
	  nP14        := 0
	  nP15        := 0	
	  nP16        := 0
	  nP17        := 0
	  nP18        := 0
	  nP19        := 0
	  nP20        := 0
	  nP21        := 0
	  nP22        := 0
	  nP23        := 0
	  nP24        := 0
	  nP25        := 0
	  nP26        := 0
	  nP27        := 0
	  nP28        := 0
     //box das perguntas
	  nBOXP1 := ""
	  nBOXP2 := ""
	  nBOXP3 := ""
	  nBOXP4 := ""
	  nBOXP5 := ""
	  nBOXP6 := ""
	  nBOXP7 := ""
	  nBOXP8 := ""
	  nBOXP9 := ""
	  nBOXP10 := ""
	  nBOXP11 := ""
	  nBOXP12 := ""	
	  nBOXP13 := ""
	  nBOXP14 := ""
	  nBOXP15 := ""
	  nBOXP16 := ""
	  nBOXP17 := ""
	  nBOXP18 := ""	
	  nBOXP19 := ""
	  nBOXP20 := ""
	  nBOXP21 := ""
	  nBOXP22 := ""
	  nBOXP23 := ""
	  nBOXP24 := ""
	  nBOXP25 := ""
	  nBOXP26 := ""
	  nBOXP27 := ""
	  nBOXP28 := ""
	  nQC := 0
	  nQNC:= 0
	  nQNA:= 0 
	  nPETOT := 0

Endif

If Alltrim(cDIR) != "ADM"
	Aadd(aPerg1, { "1.1" , "" ,;
	               "1.2" , "" ,;
	               "1.3" , "" ,;
	               "1.4" , "" ,;
	               "1.5" , ""  } ) 
Else 
	Aadd(aPerg1, { "1.1" , "" ,;
	               "1.2" , "" ,;
	               "1.3" , ""  } )
Endif

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 119,226,577,1246,"CHECKLIST - " + cNomeDIR + " - " + cModo + "                                                                                                                                                                                                               Pág. 1/5",,,.F.,,,,,,.T.,,,.F. )
oGrp1      := TGroup():New( 032,010,176,500,"  1 - SENSO DE UTILIZAÇÃO ",oDlg1,CLR_HBLUE,CLR_WHITE,.T.,.F. )
oGrp2      := TGroup():New( 003,010,028,498,"  AUDITORIA  ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

oSayNum      := TSay():New( 014,028,{||"Numero:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetNum      := TGet():New( 012,064,,oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cCODAUD",,)
oGetNum:bSetGet := {|u| If(PCount()>0,cCODAUD:=u,cCODAUD)}

oSayDT      := TSay():New( 014,098,{||"Data:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetDT      := TGet():New( 012,135,,oGrp2,060,008,'@D',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDTAUD",,)
oGetDT:bSetGet := {|u| If(PCount()>0,cDTAUD:=u,cDTAUD)}

oSaySet      := TSay():New( 014,212,{||"Setor:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,025,008)
If nMenuOp = 3 .or. nMenuOp = 4
	oCBoxSet     := TComboBox():New( 013,229,,aSetores,102,010,oGrp2,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cSetor )
Else
	oCBoxSet     := TGet():New( 013,229,,oGrp2,102,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cSetor",,)
Endif
oCBoxSet:bSetGet := {|u| If(PCount()>0,cSetor:=u,cSetor)}

oSayAud      := TSay():New( 014,357,{||"Auditor:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetAud      := TGet():New( 014,393,,oGrp2,089,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cAuditor",,)
oGetAud:bSetGet := {|u| If(PCount()>0,cAuditor:=u,cAuditor)}

oSayPeso     := TSay():New( 040,429,{||"Peso"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,017,008)
oSayNivel    := TSay():New( 040,300,{||"Nível de Conformidade"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,060,008)

///perguntas
oSay11      := TSay():New( 048,028,{|| cQuest11},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,253,014)
oSay12      := TSay():New( 074,028,{|| cQuest12},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,253,014)
oSay13      := TSay():New( 100,028,{|| cQuest13},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,253,014)
//gets do valor peso
oGet11      := TGet():New( 048,423,,oGrp1,028,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP1",,)
oGet12      := TGet():New( 074,423,,oGrp1,028,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP2",,)
oGet13      := TGet():New( 100,423,,oGrp1,028,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP3",,)

If Alltrim(cDIR) != "ADM"	
	oSay14      := TSay():New( 126,028,{|| cQuest14},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,253,014)
	oSay15      := TSay():New( 152,028,{|| cQuest15},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,253,014)
	If nMenuOp = 3 .or. nMenuOp = 4
		oCBox11     := TComboBox():New( 048,300,,aItems,074,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP1 )
		oCBox12     := TComboBox():New( 074,300,,aItems,072,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP2 )
		oCBox13     := TComboBox():New( 100,301,,aItems,072,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP3 )
		oCBox14     := TComboBox():New( 126,300,,aItems,074,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP4 )
		oCBox15     := TComboBox():New( 152,300,,aItems,072,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP5 )			
	Else
		oCBox11      := TGet():New( 048,300,,oGrp1,074,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP1",,)
		oCBox12      := TGet():New( 074,300,,oGrp1,074,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP2",,)
		oCBox13      := TGet():New( 100,300,,oGrp1,074,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP3",,)	
		oCBox14      := TGet():New( 126,300,,oGrp1,074,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP4",,)
		oCBox15      := TGet():New( 152,300,,oGrp1,074,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP5",,)			
	Endif
	oCBox14:bSetGet := {|u| If(PCount()>0,nBOXP4:=u,nBOXP4)}
	oCBox15:bSetGet := {|u| If(PCount()>0,nBOXP5:=u,nBOXP5)}                                                                                             

	oGet14      := TGet():New( 126,423,,oGrp1,028,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP4",,)
	oGet15      := TGet():New( 152,423,,oGrp1,028,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP5",,)
	
	If nMenuOp = 3 .or. nMenuOp = 4	
		oGet11:bSetGet := {|| nP1	:= fPeso(1 , nBOXP1,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e a diretoria
		oGet12:bSetGet := {|| nP2	:= fPeso(2 , nBOXP2,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e a diretoria
		oGet13:bSetGet := {|| nP3	:= fPeso(3 , nBOXP3,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e a diretoria
		oGet14:bSetGet := {|| nP4	:= fPeso(4 , nBOXP4,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e a diretoria 
		oGet15:bSetGet := {|| nP5	:= fPeso(5 , nBOXP5,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e a diretoria	
	Else
		oGet11:bSetGet := {|u| If(PCount()>0,nP1:=u,nP1)}
		oGet12:bSetGet := {|u| If(PCount()>0,nP2:=u,nP2)}
		oGet13:bSetGet := {|u| If(PCount()>0,nP3:=u,nP3)}
		oGet14:bSetGet := {|u| If(PCount()>0,nP4:=u,nP4)}
		oGet15:bSetGet := {|u| If(PCount()>0,nP5:=u,nP5)}
	Endif

Else  // = ADM
	If nMenuOp = 3 .or. nMenuOp = 4
		oCBox11     := TComboBox():New( 048,300,,aItems,074,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP1 )
		oCBox12     := TComboBox():New( 074,300,,aItems,072,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP2 )
		oCBox13     := TComboBox():New( 100,301,,aItems,072,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP3 )
	Else
		oCBox11      := TGet():New( 048,300,,oGrp1,074,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP1",,)
		oCBox12      := TGet():New( 074,300,,oGrp1,074,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP2",,)
		oCBox13      := TGet():New( 100,300,,oGrp1,074,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP3",,)	
	Endif
	If nMenuOp = 3 .or. nMenuOp = 4	
		oGet11:bSetGet := {|| nP1	:= fPeso(1 , nBOXP1,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e a diretoria
		oGet12:bSetGet := {|| nP2	:= fPeso(2 , nBOXP2,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e a diretoria
		oGet13:bSetGet := {|| nP3	:= fPeso(3 , nBOXP3,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e a diretoria	
	Else
		oGet11:bSetGet := {|u| If(PCount()>0,nP1:=u,nP1)}
		oGet12:bSetGet := {|u| If(PCount()>0,nP2:=u,nP2)}
		oGet13:bSetGet := {|u| If(PCount()>0,nP3:=u,nP3)}
	Endif

Endif
oCBox11:bSetGet := {|u| If(PCount()>0,nBOXP1:=u,nBOXP1)}
oCBox12:bSetGet := {|u| If(PCount()>0,nBOXP2:=u,nBOXP2)}
oCBox13:bSetGet := {|u| If(PCount()>0,nBOXP3:=u,nBOXP3)}

If nMenuOp <> 5
	If nMenuOp = 3 .or. nMenuOp = 4		
		oBtn3      := TButton():New( 210,088,"SALVAR",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
		oBtn3:bAction := {||( MsAguarde( { || FSALVA( nMenuOP )	 }, "Aguarde. . .", "Gravando Informações . . ." ) , oDlg1:End() ) }  
	Endif
Else
	oBtn3      := TButton():New( 210,088,"EXCLUIR",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
	oBtn3:bAction := {||( MsAguarde( { || FSALVA( nMenuOP )	 }, "Aguarde. . .", "Excluindo Informações . . ." ) , oDlg1:End() ) }  
Endif

oBtn2      := TButton():New( 210,185,"Cancelar",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
oBtn2:bAction := {||oDlg1:End()}

oBtn1      := TButton():New( 210,415,"PRÓXIMO >>",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
oBtn1:bAction := {|| BoxNaoVazio("1" , nMenuOp, aPerg1, cSetor)} 

oDlg1:Activate(,,,.T.)

Return


************************************
Static Function fProxPag(nPag, nMenuOp)
************************************

Private aPerg2 := {}
Private aPerg3 := {}
Private aPerg4 := {}
Private aPerg5 := {}

Private nOpcA := 5




If nPag = 2  //SENSO 2

	If Alltrim(cDIR) = "ADM"
		Aadd(aPerg2, { "2.1" , "" ,;
		               "2.2" , "" ,;
		               "2.3" , "" ,;
		               "2.4" , "" } ) 
	Else 
		Aadd(aPerg2, { "2.1" , "" ,;
		               "2.2" , "" ,;
		               "2.3" , "",;
		               "2.4" , "",;
		               "2.5" , "",;
		               "2.6" , "",;
		               "2.7" , "" } )
	Endif

	oDlg2      := MSDialog():New( 119,226,577,1246,"CHECKLIST - " + cNomeDIR + " - " + cModo + "                                                                                                                                                                                                               Pág. 2/5",,,.F.,,,,,,.T.,,,.F. )
	oGrp21      := TGroup():New( 012,010,205,500,"  2 - SENSO DE ORGANIZAÇÃO E PADRONIZAÇÃO ",oDlg2,CLR_HBLUE,CLR_WHITE,.T.,.F. )

	oSayPeso     := TSay():New( 023,429,{||"Peso"},oGrp21,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,017,008)
	oSayNivel    := TSay():New( 023,302,{||"Nível de Conformidade"},oGrp21,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,060,008)	
	
	///strings das perguntas
	oSay21      := TSay():New( 033,028,{|| cQuest21},oGrp21,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,265,014)	
	oSay22      := TSay():New( 059,028,{|| cQuest22},oGrp21,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,265,014)
	oSay23      := TSay():New( 085,028,{|| cQuest23},oGrp21,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,265,014)	
	oSay24      := TSay():New( 111,028,{|| cQuest24},oGrp21,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,265,014)
	If Alltrim(cDIR) != "ADM"                                                                                                              
		oSay25     := TSay():New( 137,028,{|| cQuest25},oGrp21,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,265,014)	
		oSay26     := TSay():New( 163,028,{|| cQuest26},oGrp21,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,265,014)
		oSay27     := TSay():New( 189,028,{|| cQuest27},oGrp21,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,265,014)
	    
		oGet21      := TGet():New( 033,424,,oGrp21,028,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP6",,)		
		oGet22      := TGet():New( 059,424,,oGrp21,028,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP7",,)		
		oGet23      := TGet():New( 085,424,,oGrp21,028,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP8",,)		
		oGet24      := TGet():New( 111,424,,oGrp21,028,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP9",,)		
		oGet25      := TGet():New( 137,424,,oGrp21,028,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP10",,)		
		oGet26      := TGet():New( 163,424,,oGrp21,028,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP11",,)		
		oGet27      := TGet():New( 189,424,,oGrp21,028,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP12",,)
		
		If nMenuOp = 3 .or. nMenuOp = 4	
	
			oCBox21     := TComboBox():New( 033,300,,aItems,072,010,oGrp21,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP6 )	
			oCBox22     := TComboBox():New( 059,300,,aItems,072,010,oGrp21,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP7 )		
			oCBox23     := TComboBox():New( 085,300,,aItems,072,010,oGrp21,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP8 )		
			oCBox24     := TComboBox():New( 111,300,,aItems,072,010,oGrp21,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP9 )		
			oCBox25     := TComboBox():New( 137,300,,aItems,072,010,oGrp21,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP10 )		
			oCBox26     := TComboBox():New( 163,300,,aItems,072,010,oGrp21,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP11 )		
			oCBox27     := TComboBox():New( 189,300,,aItems,072,010,oGrp21,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP12 )
			
			oGet21:bSetGet := {|| nP6	:= fPeso(6 , nBOXP6,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
			oGet22:bSetGet := {|| nP7	:= fPeso(7 , nBOXP7,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
			oGet23:bSetGet := {|| nP8	:= fPeso(8 , nBOXP8,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
			oGet24:bSetGet := {|| nP9	:= fPeso(9 , nBOXP9,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
			oGet25:bSetGet := {|| nP10	:= fPeso(10 , nBOXP10,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
			oGet26:bSetGet := {|| nP11	:= fPeso(11 , nBOXP11,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
			oGet27:bSetGet := {|| nP12	:= fPeso(12 , nBOXP12,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
				
		Else   //visualização ou exclusão
	
			oCBox21      := TGet():New( 033,300,,oGrp21,072,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP6",,)	
			oCBox22      := TGet():New( 059,300,,oGrp21,072,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP7",,)	
			oCBox23      := TGet():New( 085,300,,oGrp21,072,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP8",,)	
			oCBox24      := TGet():New( 111,300,,oGrp21,072,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP9",,)	
			oCBox25      := TGet():New( 137,300,,oGrp21,072,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP10",,)	
			oCBox26      := TGet():New( 163,300,,oGrp21,072,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP11",,)	
			oCBox27      := TGet():New( 189,300,,oGrp21,072,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP12",,)	
			
			oGet21:bSetGet := {|u| If(PCount()>0,nP6:=u,nP6)}
			oGet22:bSetGet := {|u| If(PCount()>0,nP7:=u,nP7)}
			oGet23:bSetGet := {|u| If(PCount()>0,nP8:=u,nP8)}
			oGet24:bSetGet := {|u| If(PCount()>0,nP9:=u,nP9)}
			oGet25:bSetGet := {|u| If(PCount()>0,nP10:=u,nP10)}
			oGet26:bSetGet := {|u| If(PCount()>0,nP11:=u,nP11)}
			oGet27:bSetGet := {|u| If(PCount()>0,nP12:=u,nP12)}		                                                                
		
		Endif
		oCBox21:bSetGet := {|u| If(PCount()>0,nBOXP6:=u,nBOXP6)}
		oCBox22:bSetGet := {|u| If(PCount()>0,nBOXP7:=u,nBOXP7)} 
		oCBox23:bSetGet := {|u| If(PCount()>0,nBOXP8:=u,nBOXP8)}
		oCBox24:bSetGet := {|u| If(PCount()>0,nBOXP9:=u,nBOXP9)}		                                                                        
		oCBox25:bSetGet := {|u| If(PCount()>0,nBOXP10:=u,nBOXP10)}		                                                                        
		oCBox26:bSetGet := {|u| If(PCount()>0,nBOXP11:=u,nBOXP11)}		                                                                        
		oCBox27:bSetGet := {|u| If(PCount()>0,nBOXP12:=u,nBOXP12)}
	Else // = ADM                       
		oGet21      := TGet():New( 033,424,,oGrp21,028,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP4",,)
		oGet22      := TGet():New( 059,424,,oGrp21,028,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP5",,)
		oGet23      := TGet():New( 085,424,,oGrp21,028,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP6",,)
		oGet24      := TGet():New( 111,424,,oGrp21,028,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP7",,)
	
		If nMenuOp = 3 .or. nMenuOp = 4	
		
			oCBox21     := TComboBox():New( 033,300,,aItems,072,010,oGrp21,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP4 )	
			oCBox22     := TComboBox():New( 059,300,,aItems,072,010,oGrp21,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP5 )		
			oCBox23     := TComboBox():New( 085,300,,aItems,072,010,oGrp21,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP6 )		
			oCBox24     := TComboBox():New( 111,300,,aItems,072,010,oGrp21,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP7 )							
				
   			oGet21:bSetGet := {|| nP4	:= fPeso(4 , nBOXP4,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
			oGet22:bSetGet := {|| nP5	:= fPeso(5 , nBOXP5,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
			oGet23:bSetGet := {|| nP6	:= fPeso(6 , nBOXP6,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
			oGet24:bSetGet := {|| nP7	:= fPeso(7 , nBOXP7,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
			
		Else   //visualização ou exclusão
		
			oCBox21      := TGet():New( 033,300,,oGrp21,072,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP4",,)
			oCBox22      := TGet():New( 059,300,,oGrp21,072,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP5",,)
			oCBox23      := TGet():New( 085,300,,oGrp21,072,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP6",,)	
			oCBox24      := TGet():New( 111,300,,oGrp21,072,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP7",,)			
		
   			oGet21:bSetGet := {|u| If(PCount()>0,nP4:=u,nP4)}
			oGet22:bSetGet := {|u| If(PCount()>0,nP5:=u,nP5)}
			oGet23:bSetGet := {|u| If(PCount()>0,nP6:=u,nP6)}
			oGet24:bSetGet := {|u| If(PCount()>0,nP7:=u,nP7)}   				
		Endif    //incluir / visualizar
		oCBox21:bSetGet := {|u| If(PCount()>0,nBOXP4:=u,nBOXP4)}
		oCBox22:bSetGet := {|u| If(PCount()>0,nBOXP5:=u,nBOXP5)} 
   		oCBox23:bSetGet := {|u| If(PCount()>0,nBOXP6:=u,nBOXP6)}
   		oCBox24:bSetGet := {|u| If(PCount()>0,nBOXP7:=u,nBOXP7)}
	Endif  //ADM ou outros
	
	If nMenuOp <> 5
		If nMenuOp = 3 .or. nMenuOp = 4		
			oBtn21      := TButton():New( 210,088,"SALVAR",oDlg2,,037,012,,,,.T.,,"",,,,.F. )
			oBtn21:bAction := {||( MsAguarde( { || FSALVA( nMenuOP )	 }, "Aguarde. . .", "Gravando Informações . . ." ) ,;
    	 	oDlg1:End(), oDlg2:End() ) }  
   		Endif
	Else
		oBtn21      := TButton():New( 210,088,"EXCLUIR",oDlg2,,037,012,,,,.T.,,"",,,,.F. )
		oBtn21:bAction := {||( MsAguarde( { || FSALVA( nMenuOP )	 }, "Aguarde. . .", "Excluindo Informações . . ." ) ,;
		 oDlg1:End(), oDlg2:End() ) }  		 
	Endif
	
	oBtn22      := TButton():New( 210,185,"Cancelar",oDlg2,,037,012,,,,.T.,,"",,,,.F. )
	oBtn22:bAction := { || ( oDlg1:End(), oDlg2:End() )}
	
	oBtn24      := TButton():New( 210,335,"<< ANTERIOR",oDlg2,,037,012,,,,.T.,,"",,,,.F. )
	oBtn24:bAction := {||oDlg2:End()}
	
	oBtn23      := TButton():New( 210,415,"PRÓXIMO >>",oDlg2,,037,012,,,,.T.,,"",,,,.F. )
	If Alltrim(cDIR) = "ADM"	
		oBtn23:bAction := {|| BoxNaoVazio("2" , nMenuOp, aPerg2, cSetor, 4 )}  //"4" -> START PARA SABER DE QUAL NÚMERO DE BOX TENHO Q CONTAR
	Else
		oBtn23:bAction := {|| BoxNaoVazio("2" , nMenuOp, aPerg2, cSetor, 6 )}
	Endif
	
	oDlg2:Activate(,,,.T.)
//////////////////////////
Elseif nPag = 3 //SENSO 3 
//////////////////////////

	If Alltrim(cDIR) = "ADM"
		Aadd(aPerg3, { "3.1" , "" ,;
		               "3.2" , "" ,;
		               "3.3" , "" ,;
		               "3.4" , "" ,;
		               "3.5" , "" ,;
		               "3.6" , "" ,;
		               "3.7" , "" } ) 
	Else 
		Aadd(aPerg3, { "3.1" , "" ,;
		               "3.2" , "" ,;
		               "3.3" , "",;
		               "3.4" , "",;
		               "3.5" , "" } )
	Endif
	oDlg3      := MSDialog():New( 119,226,577,1246,"CHECKLIST - " + cNomeDIR + " - " + cModo + "                                                                                                                                                                                                               Pág. 3/5",,,.F.,,,,,,.T.,,,.F. )
	oGrp3      := TGroup():New( 005,010,191,500,"  3 - SENSO DE LIMPEZA",oDlg3,CLR_HBLUE,CLR_WHITE,.T.,.F. )

	oSayPeso   := TSay():New( 013,422,{||"Peso"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,021,008)
	oSayNivel    := TSay():New( 013,302,{||"Nível de Conformidade"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,064,008)
	
	oSay31      := TSay():New( 020,028,{|| cQuest31},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,253,014)
	oSay32      := TSay():New( 046,028,{|| cQuest32},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,253,014)
	oSay33      := TSay():New( 072,028,{|| cquest33},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,253,014)
	oSay34      := TSay():New( 098,028,{|| cQuest34},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,253,014)
	oSay35      := TSay():New( 124,028,{|| cQuest35},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,253,014)
	If Alltrim(cDIR) = "ADM"
		oSay36     := TSay():New(150,028,{|| cQuest36},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,253,014)
		oSay37     := TSay():New(176,028,{|| cQuest37},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,253,014)
		
		//gets do valor peso	
		oGet31      := TGet():New( 022,410,,oGrp3,043,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP8",,)		
		oGet32      := TGet():New( 046,410,,oGrp3,043,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP9",,)
		oGet33      := TGet():New( 072,410,,oGrp3,043,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP10",,)		
		oGet34      := TGet():New( 098,410,,oGrp3,043,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP11",,)		
		oGet35      := TGet():New( 124,410,,oGrp3,043,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP12",,)
		oGet36      := TGet():New( 150,410,,oGrp3,043,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP13",,)
		oGet37      := TGet():New( 176,410,,oGrp3,043,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP14",,)
		
		If nMenuOp = 3 .or. nMenuOp = 4	
			oCBox31     := TComboBox():New( 020,299,,aItems,074,010,oGrp3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP8 )
			oCBox32     := TComboBox():New( 046,299,,aItems,074,010,oGrp3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP9 )
			oCBox33     := TComboBox():New( 075,299,,aItems,074,010,oGrp3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP10 )
			oCBox34     := TComboBox():New( 098,299,,aItems,074,010,oGrp3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP11 )
			oCBox35     := TComboBox():New( 124,299,,aItems,074,010,oGrp3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP12 )
			oCBox36     := TComboBox():New( 150,299,,aItems,074,010,oGrp3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP13 )
			oCBox37     := TComboBox():New( 176,299,,aItems,074,010,oGrp3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP14 )
			
			oGet31:bSetGet := {|| nP8	:= fPeso(8 , nBOXP8,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor		
			oGet32:bSetGet := {|| nP9	:= fPeso(9 , nBOXP9,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
			oGet33:bSetGet := {|| nP10	:= fPeso(10 , nBOXP10,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
			oGet34:bSetGet := {|| nP11	:= fPeso(11 , nBOXP11,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
			oGet35:bSetGet := {|| nP12	:= fPeso(12 , nBOXP12,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
			oGet36:bSetGet := {|| nP13	:= fPeso(13 , nBOXP13,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
			oGet37:bSetGet := {|| nP14	:= fPeso(14 , nBOXP14,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor		
		
		Else  //visualizar ou excluir
			oCBox31     := TGet():New( 020,299,,oGrp3,074,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP8",,)
			oCBox32     := TGet():New( 046,299,,oGrp3,074,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP9",,)
			oCBox33     := TGet():New( 072,299,,oGrp3,074,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP10",,)
			oCBox34     := TGet():New( 098,299,,oGrp3,074,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP11",,)
			oCBox35     := TGet():New( 124,299,,oGrp3,074,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP12",,)
			oCBox36     := TGet():New( 150,299,,oGrp3,074,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP13",,)
			oCBox37     := TGet():New( 176,299,,oGrp3,074,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP14",,)					
			
			oGet31:bSetGet := {|u| If(PCount()>0,nP8:=u,nP8)}
			oGet32:bSetGet := {|u| If(PCount()>0,nP9:=u,nP9)}
			oGet33:bSetGet := {|u| If(PCount()>0,nP10:=u,nP10)}
			oGet34:bSetGet := {|u| If(PCount()>0,nP11:=u,nP11)}
			oGet35:bSetGet := {|u| If(PCount()>0,nP12:=u,nP12)}
			oGet36:bSetGet := {|u| If(PCount()>0,nP13:=u,nP13)}
			oGet37:bSetGet := {|u| If(PCount()>0,nP14:=u,nP14)}
		Endif
		oCBox31:bSetGet := {|u| If(PCount()>0,nBOXP8:=u,nBOXP8)}
		oCBox32:bSetGet := {|u| If(PCount()>0,nBOXP9:=u,nBOXP9)}
		oCBox33:bSetGet := {|u| If(PCount()>0,nBOXP10:=u,nBOXP10)}
		oCBox34:bSetGet := {|u| If(PCount()>0,nBOXP11:=u,nBOXP11)}
		oCBox35:bSetGet := {|u| If(PCount()>0,nBOXP12:=u,nBOXP12)}
		oCBox36:bSetGet := {|u| If(PCount()>0,nBOXP13:=u,nBOXP13)}
		oCBox37:bSetGet := {|u| If(PCount()>0,nBOXP14:=u,nBOXP14)}
	
		
	Else // CAIXAS OU PLAST
		//gets do valor peso	
		oGet31      := TGet():New( 022,410,,oGrp3,043,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP13",,)		
		oGet32      := TGet():New( 046,410,,oGrp3,043,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP14",,)
		oGet33      := TGet():New( 072,410,,oGrp3,043,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP15",,)		
		oGet34      := TGet():New( 098,410,,oGrp3,043,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP16",,)		
		oGet35      := TGet():New( 124,410,,oGrp3,043,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP17",,)	
		If nMenuOp = 3 .or. nMenuOp = 4	
			oCBox31     := TComboBox():New( 020,299,,aItems,074,010,oGrp3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP13 )
			oCBox32     := TComboBox():New( 046,299,,aItems,074,010,oGrp3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP14 )
			oCBox33     := TComboBox():New( 072,299,,aItems,074,010,oGrp3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP15 )
			oCBox34     := TComboBox():New( 098,299,,aItems,074,010,oGrp3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP16 )
			oCBox35     := TComboBox():New( 124,299,,aItems,074,010,oGrp3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP17 )			
		
			oGet31:bSetGet := {|| nP13	:= fPeso(13 , nBOXP13,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor		
			oGet32:bSetGet := {|| nP14	:= fPeso(14 , nBOXP14,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
			oGet33:bSetGet := {|| nP15	:= fPeso(15 , nBOXP15,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
			oGet34:bSetGet := {|| nP16	:= fPeso(16 , nBOXP16,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
			oGet35:bSetGet := {|| nP17	:= fPeso(17 , nBOXP17,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor		
		
		Else  //visualizar ou excluir
			oCBox31     := TGet():New( 020,299,,oGrp3,074,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP13",,)
			oCBox32     := TGet():New( 046,299,,oGrp3,074,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP14",,)
			oCBox33     := TGet():New( 072,299,,oGrp3,074,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP15",,)
			oCBox34     := TGet():New( 098,299,,oGrp3,074,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP16",,)
			oCBox35     := TGet():New( 124,299,,oGrp3,074,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP17",,)			
			
			oGet31:bSetGet := {|u| If(PCount()>0,nP13:=u,nP13)}
			oGet32:bSetGet := {|u| If(PCount()>0,nP14:=u,nP14)}
			oGet33:bSetGet := {|u| If(PCount()>0,nP15:=u,nP15)}
			oGet34:bSetGet := {|u| If(PCount()>0,nP16:=u,nP16)}
			oGet35:bSetGet := {|u| If(PCount()>0,nP17:=u,nP17)}
		Endif
		oCBox31:bSetGet := {|u| If(PCount()>0,nBOXP13:=u,nBOXP13)}
		oCBox32:bSetGet := {|u| If(PCount()>0,nBOXP14:=u,nBOXP14)}
		oCBox33:bSetGet := {|u| If(PCount()>0,nBOXP15:=u,nBOXP15)}
		oCBox34:bSetGet := {|u| If(PCount()>0,nBOXP16:=u,nBOXP16)}
		oCBox35:bSetGet := {|u| If(PCount()>0,nBOXP17:=u,nBOXP17)}	
	
		
	Endif  //adm / cx / sc
		
	///////////////////////////////////////////
	If nMenuOp <> 5		
		If nMenuOp = 3 .or. nMenuOp = 4		
			oBtn31      := TButton():New( 210,088,"SALVAR",oDlg3,,037,012,,,,.T.,,"",,,,.F. )
			oBtn31:bAction := {||( MsAguarde( { || FSALVA( nMenuOP )	 }, "Aguarde. . .", "Gravando Informações . . ." ) ,;
		 	oDlg1:End(), oDlg2:End(), oDlg3:End() ) }   	
		Endif
	Else
		oBtn31      := TButton():New( 210,088,"EXCLUIR",oDlg3,,037,012,,,,.T.,,"",,,,.F. )
		oBtn31:bAction := {||( MsAguarde( { || FSALVA( nMenuOP )	 }, "Aguarde. . .", "Excluindo Informações . . ." ) ,;
		 oDlg1:End(), oDlg2:End(), oDlg3:End() ) }  	
	Endif
	
	oBtn22      := TButton():New( 210,185,"Cancelar",oDlg3,,037,012,,,,.T.,,"",,,,.F. )
	oBtn22:bAction := { || ( oDlg1:End(), oDlg2:End(),oDlg3:End() )}
	
	oBtn24      := TButton():New( 210,335,"<< ANTERIOR",oDlg3,,037,012,,,,.T.,,"",,,,.F. )
	oBtn24:bAction := {||oDlg3:End()}
	
	oBtn23      := TButton():New( 210,415,"PRÓXIMO >>",oDlg3,,037,012,,,,.T.,,"",,,,.F. )
	If Alltrim(cDIR) = "ADM"
		oBtn23:bAction := {|| BoxNaoVazio("3" , nMenuOp, aPerg3, cSetor, 8)} 
	Else
		oBtn23:bAction := {|| BoxNaoVazio("3" , nMenuOp, aPerg3, cSetor, 13)} 
	Endif
	
	oDlg3:Activate(,,,.T.)
//////////////////////////	
Elseif nPag = 4 //SENSO 4 
/////////////////////////
	If Alltrim(cDIR) = "ADM"
		Aadd(aPerg4, { "4.1" , "" ,;
		               "4.2" , "" ,;
		               "4.3" , "" ,;
		               "4.4" , ""  } ) 
	Else 
		Aadd(aPerg4, { "4.1" , "" ,;
		               "4.2" , "" ,;
		               "4.3" , "",;
		               "4.4" , "",;
		               "4.5" , "",;
		               "4.6" , "" } )
	Endif
	
	//oDlg4      := MSDialog():New( 119,226,577,1246,"CHECKLIST ADM                                                                                                                                                                                                                                         Pág. 4/5",,,.F.,,,,,,.T.,,,.F. )
	oDlg4      := MSDialog():New( 119,226,577,1246,"CHECKLIST - " + cNomeDIR + " - " + cModo + "                                                                                                                                                                                                               Pág. 4/5",,,.F.,,,,,,.T.,,,.F. )
	oGrp41      := TGroup():New( 015,010,186,500,"  4 - SENSO DE SAÚDE E SEGURANÇA  ",oDlg4,CLR_HBLUE,CLR_WHITE,.T.,.F. )
	
	oSay41     := TSay():New( 033,028,{||cQuest41},oGrp41,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,253,014)
	oSay42     := TSay():New( 059,028,{||cQuest42},oGrp41,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,253,014)
	oSay43     := TSay():New( 085,028,{||cQuest43},oGrp41,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,253,014)
	oSay44     := TSay():New( 111,028,{||cQuest44},oGrp41,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,253,014)
	If Alltrim(cDIR) != "ADM"
		oSay45     := TSay():New( 137,028,{||cQuest45},oGrp41,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,253,014)
		oSay45     := TSay():New( 163,028,{||cQuest45},oGrp41,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,253,014)
	Endif
	
	oSayPeso     := TSay():New( 026,431,{||"Peso"},oGrp41,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,024,008)
	oSayNivel    := TSay():New( 026,302,{||"Nível de Conformidade"},oGrp41,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,064,008)
	If Alltrim(cDIR) = "ADM"
		oGet41     := TGet():New( 033,421,,oGrp41,044,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP15",,)
		oGet42     := TGet():New( 059,420,,oGrp41,044,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP16",,)                            
		oGet43     := TGet():New( 085,421,,oGrp41,044,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP17",,)
		oGet44     := TGet():New( 111,421,,oGrp41,044,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP18",,)
	
		If nMenuOp = 3 .or. nMenuOp = 4	
			oCBox41    := TComboBox():New( 033,300,,aItems,072,010,oGrp41,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP15 )
			oCBox42    := TComboBox():New( 059,300,,aItems,072,010,oGrp41,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP16 )
			oCBox43    := TComboBox():New( 085,300,,aItems,072,010,oGrp41,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP17 )
			oCBox44    := TComboBox():New( 111,300,,aItems,072,010,oGrp41,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP18 )
			
			oGet41:bSetGet := {|| nP15	:= fPeso(15 , nBOXP15,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
			oGet42:bSetGet := {|| nP16	:= fPeso(16 , nBOXP16,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
			oGet43:bSetGet := {|| nP17	:= fPeso(17 , nBOXP17,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
			oGet44:bSetGet := {|| nP18	:= fPeso(18 , nBOXP18,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
		
		Else
			oCBox41    := TGet():New( 033,300,,oGrp41,072,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP15",,) 
			oCBox42    := TGet():New( 059,300,,oGrp41,072,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP16",,) 
			oCBox43    := TGet():New( 085,300,,oGrp41,072,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP17",,) 
			oCBox44    := TGet():New( 111,300,,oGrp41,072,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP18",,) 	
			
			oGet41:bSetGet := {|u| If(PCount()>0,nP15:=u,nP15)}
			oGet42:bSetGet := {|u| If(PCount()>0,nP16:=u,nP16)}
			oGet43:bSetGet := {|u| If(PCount()>0,nP17:=u,nP17)}
			oGet44:bSetGet := {|u| If(PCount()>0,nP18:=u,nP18)}
		
		Endif
		oCBox41:bSetGet := {|u| If(PCount()>0,nBOXP15:=u,nBOXP15)}
		oCBox42:bSetGet := {|u| If(PCount()>0,nBOXP16:=u,nBOXP16)}
		oCBox43:bSetGet := {|u| If(PCount()>0,nBOXP17:=u,nBOXP17)}
		oCBox44:bSetGet := {|u| If(PCount()>0,nBOXP18:=u,nBOXP18)}  
	
	Else    //cx ou plástico
		oGet41     := TGet():New( 033,421,,oGrp41,044,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP18",,)		
		oGet42     := TGet():New( 059,420,,oGrp41,044,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP19",,) 
		oGet43     := TGet():New( 085,421,,oGrp41,044,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP20",,)			
		oGet44     := TGet():New( 111,421,,oGrp41,044,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP21",,)		
		oGet45     := TGet():New( 137,421,,oGrp41,044,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP22",,)		
		oGet46     := TGet():New( 163,421,,oGrp41,044,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP23",,)
		
		If nMenuOp = 3 .or. nMenuOp = 4	
			oCBox41    := TComboBox():New( 033,300,,aItems,072,010,oGrp41,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP18 )
			oCBox42    := TComboBox():New( 059,300,,aItems,072,010,oGrp41,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP19 )
			oCBox43    := TComboBox():New( 085,300,,aItems,072,010,oGrp41,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP20 )
			oCBox44    := TComboBox():New( 111,300,,aItems,072,010,oGrp41,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP21 )
			oCBox45    := TComboBox():New( 137,300,,aItems,072,010,oGrp41,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP22 )
			oCBox46    := TComboBox():New( 163,300,,aItems,072,010,oGrp41,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP23 )
			
			oGet41:bSetGet := {|| nP18	:= fPeso(18 , nBOXP18,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
			oGet42:bSetGet := {|| nP19	:= fPeso(19 , nBOXP19,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
			oGet43:bSetGet := {|| nP20	:= fPeso(20 , nBOXP20,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
			oGet44:bSetGet := {|| nP21	:= fPeso(21 , nBOXP21,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
			oGet45:bSetGet := {|| nP22	:= fPeso(22 , nBOXP22,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
			oGet46:bSetGet := {|| nP23	:= fPeso(23 , nBOXP23,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
		
		Else
			oCBox41    := TGet():New( 033,300,,oGrp41,072,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP18",,) 
			oCBox42    := TGet():New( 059,300,,oGrp41,072,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP19",,) 
			oCBox43    := TGet():New( 085,300,,oGrp41,072,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP20",,) 
			oCBox44    := TGet():New( 111,300,,oGrp41,072,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP21",,) 	
			oCBox45    := TGet():New( 137,300,,oGrp41,072,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP22",,) 	
			oCBox46    := TGet():New( 163,300,,oGrp41,072,010,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP23",,) 	
			
			oGet41:bSetGet := {|u| If(PCount()>0,nP18:=u,nP18)}
			oGet42:bSetGet := {|u| If(PCount()>0,nP19:=u,nP19)}
			oGet43:bSetGet := {|u| If(PCount()>0,nP20:=u,nP20)}
			oGet44:bSetGet := {|u| If(PCount()>0,nP21:=u,nP21)}
			oGet45:bSetGet := {|u| If(PCount()>0,nP22:=u,nP22)}
			oGet46:bSetGet := {|u| If(PCount()>0,nP23:=u,nP23)}
		Endif
		oCBox41:bSetGet := {|u| If(PCount()>0,nBOXP18:=u,nBOXP18)}
		oCBox42:bSetGet := {|u| If(PCount()>0,nBOXP19:=u,nBOXP19)}
		oCBox43:bSetGet := {|u| If(PCount()>0,nBOXP20:=u,nBOXP20)}
		oCBox44:bSetGet := {|u| If(PCount()>0,nBOXP21:=u,nBOXP21)}
		oCBox45:bSetGet := {|u| If(PCount()>0,nBOXP22:=u,nBOXP22)}
		oCBox46:bSetGet := {|u| If(PCount()>0,nBOXP23:=u,nBOXP23)}
		
	Endif	
	
	
	
	If nMenuOp <> 5 
		If nMenuOp = 3 .or. nMenuOp = 4		
			oBtn41      := TButton():New( 210,088,"SALVAR",oDlg4,,037,012,,,,.T.,,"",,,,.F. )
			oBtn41:bAction := {||( MsAguarde( { || FSALVA( nMenuOP )	 }, "Aguarde. . .", "Gravando Informações . . ." ) ,;
		 	oDlg1:End(), oDlg2:End(), oDlg3:End(), oDlg4:End() ) }  
		Endif
	Else
		oBtn41      := TButton():New( 210,088,"EXCLUIR",oDlg4,,037,012,,,,.T.,,"",,,,.F. )
		oBtn41:bAction := {||( MsAguarde( { || FSALVA( nMenuOP )	 }, "Aguarde. . .", "Excluindo Informações . . ." ) ,;
		 oDlg1:End(), oDlg2:End(), oDlg3:End(), oDlg4:End() ) }  
	Endif
	
	oBtn42      := TButton():New( 210,185,"Cancelar",oDlg4,,037,012,,,,.T.,,"",,,,.F. )
	//oBtn42:bAction := {||oDlg4:End()}
	oBtn42:bAction := { || (oDlg1:End(), oDlg2:End(),oDlg3:End(),oDlg4:End() )}
	
	oBtn43      := TButton():New( 210,335,"<< ANTERIOR",oDlg4,,037,012,,,,.T.,,"",,,,.F. )
	oBtn43:bAction := {||oDlg4:End()}
	
	oBtn44      := TButton():New( 210,415,"PRÓXIMO >>",oDlg4,,037,012,,,,.T.,,"",,,,.F. )
	If Alltrim(cDIR) = "ADM"
		oBtn44:bAction := {|| BoxNaoVazio("4" , nMenuOp, aPerg4, cSetor , 15)}
	Else
		oBtn44:bAction := {|| BoxNaoVazio("4" , nMenuOp, aPerg4, cSetor , 18)}
	Endif
		
			
	oDlg4:Activate(,,,.T.)

//////////////////////////	
Elseif nPag = 5 //SENSO 5 
//////////////////////////
	If Alltrim(cDIR) = "ADM"
		Aadd(aPerg5, { "5.1" , "" ,;
		               "5.2" , ""   } ) 
	Else 
		Aadd(aPerg5, { "5.1" , "" ,;
		               "5.2" , "" ,;
		               "5.3" , "",;
		               "5.4" , "",;
		               "5.5" , "" } )
	Endif
		
	//oDlg5      := MSDialog():New( 119,218,651,1238," FINAL >> CHECKLIST ADM                                                                                                                                                                                                                            Pág 5/5",,,.F.,,,,,,.T.,,,.F. )
	oDlg5      := MSDialog():New( 119,226,577,1246," FINAL >> CHECKLIST - " + cNomeDIR + " - " + cModo + "                                                                                                                                                                                                        Pág. 5/5",,,.F.,,,,,,.T.,,,.F. )
	
	oGrp51      := TGroup():New( 008,012,145,500,"  5 - SENSO DE AUTO-DISCIPLINA  ",oDlg5,CLR_HBLUE,CLR_WHITE,.T.,.F. )
	oGrp52      := TGroup():New( 152,012,196,499,"  RESUMO  GERAL  ",oDlg5,CLR_HBLUE,CLR_WHITE,.T.,.F. )
	
	oSayPeso    := TSay():New( 016,432,{||"Peso"},oGrp51,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,021,008)
	oSayNivel   := TSay():New( 016,300,{||"Nível de Conformidade"},oGrp51,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,062,008)
	
	oSay51      := TSay():New( 024,028,{||cQuest51},oGrp51,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,253,012)
	oSay52      := TSay():New( 050,028,{||cQuest52},oGrp51,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,253,012)
	If Alltrim(cDIR) != "ADM"
		oSay53      := TSay():New( 076,028,{||cQuest53},oGrp51,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,253,012)
		oSay54      := TSay():New( 102,028,{||cQuest54},oGrp51,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,253,012)
		oSay55      := TSay():New( 128,028,{||cQuest55},oGrp51,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,253,012)
	Endif
	
	If Alltrim(cDIR) = "ADM"
		///GETS DO VALOR PESO
		oGet51      := TGet():New( 024,420,,oGrp51,043,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP19",,)		
		oGet52      := TGet():New( 050,420,,oGrp51,043,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP20",,) 		
		If nMenuOp = 3 .or. nMenuOp = 4
			oCBox51     := TComboBox():New( 024,300,,aItems,074,010,oGrp51,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP19 )
			oCBox52     := TComboBox():New( 050,300,,aItems,072,010,oGrp51,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP20 )
			oGet51:bSetGet := {|| nP19	:= fPeso(19 , nBOXP19,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
			oGet52:bSetGet := {|| nP20	:= fPeso(20 , nBOXP20,cDIR)  }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
		Else
			oCBox51      := TGet():New( 024,300,,oGrp51,074,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP19",,)
			oCBox52      := TGet():New( 050,300,,oGrp51,074,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP20",,)	
			oGet51:bSetGet := {|u| If(PCount()>0,nP19:=u,nP19)}	  
			oGet52:bSetGet := {|u| If(PCount()>0,nP20:=u,nP20)} 
		Endif
		oCBox51:bSetGet := {|u| If(PCount()>0,nBOXP19:=u,nBOXP19)}
		oCBox52:bSetGet := {|u| If(PCount()>0,nBOXP20:=u,nBOXP20)}
	
		                    
	Else //CAIXA OU PLÁSTICO
		oGet51      := TGet():New( 024,420,,oGrp51,043,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP24",,)		
		oGet52      := TGet():New( 050,420,,oGrp51,043,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP25",,)                     
		oGet53      := TGet():New( 076,420,,oGrp51,043,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP26",,)		
		oGet54      := TGet():New( 102,420,,oGrp51,043,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP27",,)                     
		oGet55      := TGet():New( 128,420,,oGrp51,043,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nP28",,)
		If nMenuOp = 3 .or. nMenuOp = 4
			oCBox51     := TComboBox():New( 024,300,,aItems,074,010,oGrp51,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP24 )
			oCBox52     := TComboBox():New( 050,300,,aItems,072,010,oGrp51,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP25 )
			oCBox53     := TComboBox():New( 076,300,,aItems,072,010,oGrp51,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP26 )
			oCBox54     := TComboBox():New( 102,300,,aItems,072,010,oGrp51,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP27 )
			oCBox55     := TComboBox():New( 128,300,,aItems,072,010,oGrp51,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,nBOXP28 )
			
			oGet51:bSetGet := {|| nP24	:= fPeso(24 , nBOXP24,cDIR) }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
			oGet52:bSetGet := {|| nP25	:= fPeso(25 , nBOXP25,cDIR)  }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
			oGet53:bSetGet := {|| nP26	:= fPeso(26 , nBOXP26,cDIR)  }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
			oGet54:bSetGet := {|| nP27	:= fPeso(27 , nBOXP27,cDIR)  }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
			oGet55:bSetGet := {|| nP28	:= fPeso(28 , nBOXP28,cDIR)  }  //passa como parâmetro o número da pergunta, a resposta da combobox, e o setor
		Else
			oCBox51      := TGet():New( 024,300,,oGrp51,074,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP24",,)
			oCBox52      := TGet():New( 050,300,,oGrp51,074,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP25",,)
			oCBox53      := TGet():New( 076,300,,oGrp51,074,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP26",,)
			oCBox54      := TGet():New( 102,300,,oGrp51,074,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP27",,)
			oCBox55      := TGet():New( 128,300,,oGrp51,074,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nBOXP28",,)
			
			oGet51:bSetGet := {|u| If(PCount()>0,nP24:=u,nP24)}	  
			oGet52:bSetGet := {|u| If(PCount()>0,nP25:=u,nP25)}
			oGet53:bSetGet := {|u| If(PCount()>0,nP26:=u,nP26)}
			oGet54:bSetGet := {|u| If(PCount()>0,nP27:=u,nP27)}
			oGet55:bSetGet := {|u| If(PCount()>0,nP28:=u,nP28)}
		Endif
		oCBox51:bSetGet := {|u| If(PCount()>0,nBOXP24:=u,nBOXP24)}
		oCBox52:bSetGet := {|u| If(PCount()>0,nBOXP25:=u,nBOXP25)}
		oCBox53:bSetGet := {|u| If(PCount()>0,nBOXP26:=u,nBOXP26)}
		oCBox54:bSetGet := {|u| If(PCount()>0,nBOXP27:=u,nBOXP27)}
		oCBox55:bSetGet := {|u| If(PCount()>0,nBOXP28:=u,nBOXP28)}

	Endif    //ADM, CX, PLAST
	
	//oSayCONF      := TSay():New( 120,040,{||"CONFORMES ----------------->>"},oGrp52,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,087,008)
	//oSayNC        := TSay():New( 140,040,{||"NÃO-CONFORMES --------->>"},oGrp52,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,089,008) 
	
	oSayCONF      := TSay():New( 162,028,{||"QTD.CONFORMES"},oGrp52,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,087,008)
	oSayNC        := TSay():New( 162,088,{||"QTD.NÃO-CONFORMES"},oGrp52,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,089,008) 
	oSayNA        := TSay():New( 162,153,{||"QTD.NÃO APLICA"},oGrp52,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,085,008)
	////GETS CONFORME, NÃO CONFORME , NÃO APLICA
	oGetCONF      := TGet():New( 170,028,,oGrp52,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nQC",,)                           
	oGetCONF:bSetGet := {|u| If(PCount()>0,nQC:=u,nQC)}
	
	oGetNC      := TGet():New( 170,092,,oGrp52,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nQNC",,)
	oGetNC:bSetGet := {|u| If(PCount()>0,nQNC:=u,nQNC)}
	
	oGetNA      := TGet():New( 170,153,,oGrp52,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nQNA",,)
	oGetNA:bSetGet := {|u| If(PCount()>0,nQNA:=u,nQNA)}
	
	If nMenuOp = 3 .or. nMenuOp = 4
		oBtn54      := TButton():New( 174,208,"CALCULA NCs",oDlg5,,057,012,,,,.T.,,"",,,,.F. )
		oBtn54:bAction := {|| CalcNCs()}
	//Else
		//oBtn54:Disable()
	Endif		
	
	//oSayQTDE    := TSay():New( 158,129,{||"Quantidade:"},oGrp52,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,033,008)
	oSayPETOT   := TSay():New( 162,320,{||"Peso Total Calculado:"},oGrp52,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,079,008)
	
	
	
	////GET DO PESO TOTAL	
	oGetPETOT      := TGet():New( 162,420,,oGrp52,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","nPETOT",,)
	If nMenuOp = 3 .or. nMenuOp = 4
		oGetPETOT:bSetGet := {|| nPETOT	:= fPETOT() }
	Else
		oGetPETOT:bSetGet := {|u| If(PCount()>0,nPETOT:=u,nPETOT)}
	Endif
	
	oBtn53      := TButton():New( 210,335,"<< ANTERIOR",oDlg5,,037,012,,,,.T.,,"",,,,.F. )
	oBtn53:bAction := {|| oDlg5:End()}
	If nMenuOp <> 5  //2, 3, 4
		oBtn51      := TButton():New( 210,415,"OK",oDlg5,,037,012,,,,.T.,,"",,,,.F. )
		If nMenuOp <> 2
			If Alltrim(cDIR) = "ADM"
				oBtn51:bAction := {|| (nOpcA := 1, BoxNaoVazio("5" , nMenuOp, aPerg5, cSetor , 19)) }   
			Else 
				oBtn51:bAction := {|| (nOpcA := 1, BoxNaoVazio("5" , nMenuOp, aPerg5, cSetor , 24)) }   
			Endif
		Else 
			oBtn51:bAction := {|| ( oDlg1:End(), oDlg2:End(), oDlg3:End(), oDlg4:End(), oDlg5:End() ) }  
		Endif
	Else
		oBtn51      := TButton():New( 210,415,"EXCLUIR",oDlg5,,037,012,,,,.T.,,"",,,,.F. )
		oBtn51:bAction := {||( MsAguarde( { || FSALVA( nMenuOP )	 }, "Aguarde. . .", "Excluindo Informações . . ." ) ,;
		 oDlg1:End(), oDlg2:End(), oDlg3:End(), oDlg4:End(), oDlg5:End() ) }  		  		
	Endif
	
	oBtn52      := TButton():New( 210,185,"Cancelar",oDlg5,,037,012,,,,.T.,,"",,,,.F. )
	oBtn52:bAction := { || ( oDlg1:End(), oDlg2:End(), oDlg3:End() , oDlg4:End(), oDlg5:End() )}
	
	oDlg5:Activate(,,,.T.)
	
Endif


Return


************************************
Static Function fPeso(nPerg, nBox, cDIR)            //atualiza o campo PESO DA PERGUNTA
************************************

Local aPADM := { 6.7 , 6.7, 6.7 ,;   //SENSO 1 -> p1, p2, p3  (números das perguntas)
				 5 , 5  , 5  , 5  ,;  //SENSO 2 -> p4, p5, p6, p7
 				 2.9, 2.9, 2.9, 2.9, 2.8 , 2.8 , 2.8 ,;  //SENSO 3 -> p8, p9, p10, p11, p12, p13, p14
 				 5 , 5  , 5  , 5  ,;   //SENSO 4  -> p15, p16, p17, p18
 				 10 , 10  } //SENSO 5   -> p19, p20  
 				 
Local aPSACO := { 3.5, 3.5, 3.5, 3.5 , 3.5 ,;   //SENSO 1 -> p1, p2, p3, p4, p5  (números das perguntas)
				 2.5 , 2.5  , 2.5  , 2.5  , 2.5, 2.5, 2.5,;  //SENSO 2 -> p6, p7, p8, p9, p10, p11, p12
 				 3.5, 3.5, 3.5, 3.5, 3.5,;  //SENSO 3 -> p13, p14, p15, p16, p17
 				 2.91 , 2.91 , 2.92, 2.92, 2.92, 2.92,;   //SENSO 4  -> p18, p19, p20, p21, p22, p23
 				 6, 6, 6, 6, 6  } //SENSO 5   -> p24, p25, p26, p27, p28

Local aPCX := { 3.5, 3.5, 3.5, 3.5 , 3.5 ,;   //SENSO 1 -> p1, p2, p3, p4, p5  (números das perguntas)
				 2.5 , 2.5  , 2.5  , 2.5  , 2.5, 2.5, 2.5,;  //SENSO 2 -> p6, p7, p8, p9, p10, p11, p12
 				 3.5, 3.5, 3.5, 3.5, 3.5,;  //SENSO 3 -> p13, p14, p15, p16, p17
 				 2.91 , 2.91 , 2.92, 2.92, 2.92, 2.92,;   //SENSO 4  -> p18, p19, p20, p21, p22, p23
 				 6, 6, 6, 6, 6  } //SENSO 5   -> p24, p25, p26, p27, p28


Local nPes := 0
//Local cPes := ""

If Alltrim(cDIR) = "ADM"
	If nBox = "1" //"CONFORME" 
		nPes := aPADM[nPerg]
	Elseif nBox = "2"
		nPes := 0
	Else  //3-não aplica
		nPes := 0
	Endif
 
ElseIf Alltrim(cDIR) = "SC"
	If nBox = "1" //"CONFORME" 
		nPes := aPSACO[nPerg]
	Elseif nBox = "2"
		nPes := 0
	Else  //3-não aplica
		nPes := 0
	Endif
ElseIf Alltrim(cDIR) = "CX"
	If nBox = "1" //"CONFORME" 
		nPes := aPCX[nPerg]
	Elseif nBox = "2"
		nPes := 0
	Else  //3-não aplica
		nPes := 0
	Endif
Endif
	
Return(nPes)  

**************************************
Static Function CalcNCs()
**************************************
Local t := 0
nQC := 0
nQNC:= 0
nQNA:= 0

For t:= 1 to 28
	cVar := "nBOXP"
	cVar += Alltrim(Str(t))  //ficará : nBOXP1 , nBOXP2 ...
    If &(cVar) = "1" 		//conforme
    	nQC++
    Elseif &(cVar) = "2" //não conforme
    	nQNC++                         
    Elseif &(cVar) = "3" //não aplica
    	nQNA++
    Endif
 Next
 
Return

*************************
Static Function fPETOT() 
*************************
Local nTot := 0
nTot := nP1 + nP2 + nP3 + nP4 + nP5 + nP6 + nP7 + nP8 + nP9 + nP10;
        + nP11 + nP12 + nP13 + nP14 + nP15 + nP16 + nP17 + nP18 + nP19 + nP20;
        + nP21 + nP22 + nP23 + nP24 + nP25 + nP26 + nP27 + nP28

Return(nTot)           

*******************************
Static Function BoxNaoVazio(cBloco, nMenuOp, aPergs, cSetor, nStart ) 
******************************* 

Local lVai := .T.
Local t    := 0
Local cVar   := "nBOXP"
Local cNomeBox:= ""
t:= 1              
b:= 1 //número do box

If Alltrim(cBloco) != "1"
	b := nStart //de qual número irá iniciar o número do box, exemplo se cStart = 4, o primeiro box = nBOXP4
Endif
If Empty(cSetor)
	lVai := .F.
	Alert("Por Favor, Preencha o Setor.")
	Return lVai
Endif

While t <= Len(aPergs[1])	
	If Empty(aPergs[1][t])
		cNomeBox := cVar + Alltrim(Str(b))  		
		aPergs[1][t] := cNomeBox 
		b++
	Endif
	t++  
Enddo

t:= 1
b:= 1 
aVazia := {} 
cAlerta:= ""
If nMenuOp = 3 .or. nMenuOp = 4 //só valida preenchimento se for incluir ou alterar
	While t <= ( Len(aPergs[1]) / 2 )
		If Empty( &(aPergs[1][t * 2]) )                           //aPergs[1][t]
			//Alert("Por Favor, Preencha a Resposta da Pergunta " + aPergs[1][b] )
			nTam := Len( aPergs[1][t * 2] )
			nPos := At("P",aPergs[1][t * 2])
			If t = 1
				Aadd( aVazia , { aPergs[1][t] , Substr( aPergs[1][t * 2] ,nPos+1,nTam-nPos)} )     //nBOXP12 -> P = 5
			Else
				//Aadd( aVazia , Substr( aPergs[1][t * 2] ,nPos+1,nTam-nPos))     //nBOXP12 -> P = 5
				Aadd( aVazia , { aPergs[1][(t * 2) - 1]  , Substr( aPergs[1][t * 2] ,nPos+1,nTam-nPos)} )     //nBOXP12 -> P = 5		
			Endif
			lVai := .F.			
			b++
			b++        			
		Endif
		t++
	Enddo

	If Len(aVazia) > 0
		cAlerta := "Por Favor, Preencha a Resposta da(s) Pergunta(s): " + CHR(13) + CHR(10)
		For t := 1 to Len(aVazia)
			If t < Len(aVazia)
				//cAlerta += aVazia[t] + ','	
				cAlerta += aVazia[t,1] + ', '	
			Elseif t = Len(aVazia)  
				//cAlerta += aVazia[t]
				cAlerta += aVazia[t,1]
			Endif			
		Next
		Alert(cAlerta)
	Endif
	

Endif //nMenuOp

If lVai
	If cBloco != "5"
		nProx := 0       
		nProx := VAL( Alltrim(cBloco) ) + 1
		fProxPag(nProx , nMenuOp)
	Else 
		MsAguarde( { || FSALVA( nMenuOP )	 }, "Aguarde. . .", "Gravando Informações . . ." )
		oDlg1:End()
		oDlg2:End()
		oDlg3:End()
		oDlg4:End()
		oDlg5:End()			
	Endif
	
Endif


Return  


*******************************
Static Function FSALVA(nMenuOp)
*******************************


If nMenuOp = 3 .or. nMenuOp = 4

	Z79->(Dbsetorder(1)) //Z79_FILIAL+Z79_AUDIT+Z79_DTAUD
	If Z79->(Dbseek(xFilial("Z79") + cCODAUD + Dtos(cDTAUD) ))  //se encontrar, altera o já existen salvando as informações digitadas até então
		RecLock("Z79", .F. )
	Else                    
		RecLock("Z79", .T. )
	Endif
	
	Z79->Z79_FILIAL := xFilial("Z79")
	Z79->Z79_DIR    := cDIR ///ADM, CX, SC
	//Z79->Z79_AREA   := //DEFINIR DEPOIS COMBO OPÇÕES
	Z79->Z79_SETOR  := Substr(cSetor,1,6)
	Z79->Z79_AUDIT  := cCODAUD //CÓDIGO AUDITORIA
	Z79->Z79_DTAUD  := cDTAUD  //DATA AUDITORIA
	Z79->Z79_USRAUD := __CUSERID //CÓDIGO USUÁRIO AUDITOR
	//VALOR DAS PERGUNTAS
	Z79->Z79_P1     := nP1
	Z79->Z79_P2     := nP2
	Z79->Z79_P3     := nP3
	Z79->Z79_P4     := nP4
	Z79->Z79_P5     := nP5
	Z79->Z79_P6     := nP6
	Z79->Z79_P7     := nP7
	Z79->Z79_P8     := nP8
	Z79->Z79_P9     := nP9
	Z79->Z79_P10     := nP10
	Z79->Z79_P11     := nP11
	Z79->Z79_P12     := nP12
	Z79->Z79_P13     := nP13
	Z79->Z79_P14     := nP14
	Z79->Z79_P15     := nP15
	Z79->Z79_P16     := nP16
	Z79->Z79_P17     := nP17
	Z79->Z79_P18     := nP18
	Z79->Z79_P19     := nP19
	Z79->Z79_P20     := nP20
	Z79->Z79_P20     := nP21
	Z79->Z79_P20     := nP22
	Z79->Z79_P20     := nP23
	Z79->Z79_P20     := nP24
	Z79->Z79_P20     := nP25
	Z79->Z79_P20     := nP26
	Z79->Z79_P20     := nP27
	Z79->Z79_P20     := nP28
	//RESPOSTA DAS PERGUNTAS (1=CONFORME, 2=NÃO CONFORME, 3=NÃO APLICA)
	Z79->Z79_B1     := nBOXP1 //iif(nBOXP1 = '1', "CONFORME" , iif (nBOXP1 = '2',"NAO-CONFORME"  , "NAO APLICA" ) )
	Z79->Z79_B2     := nBOXP2
	Z79->Z79_B3     := nBOXP3
	Z79->Z79_B4     := nBOXP4
	Z79->Z79_B5     := nBOXP5
	Z79->Z79_B6     := nBOXP6
	Z79->Z79_B7     := nBOXP7
	Z79->Z79_B8     := nBOXP8
	Z79->Z79_B9     := nBOXP9
	Z79->Z79_B10    := nBOXP10
	Z79->Z79_B11    := nBOXP11
	Z79->Z79_B12    := nBOXP12
	Z79->Z79_B13    := nBOXP13
	Z79->Z79_B14    := nBOXP14
	Z79->Z79_B15    := nBOXP15
	Z79->Z79_B16    := nBOXP16
	Z79->Z79_B17    := nBOXP17
	Z79->Z79_B18    := nBOXP18
	Z79->Z79_B19    := nBOXP19
	Z79->Z79_B20    := nBOXP20
	Z79->Z79_B20    := nBOXP21
	Z79->Z79_B20    := nBOXP22
	Z79->Z79_B20    := nBOXP23
	Z79->Z79_B20    := nBOXP24
	Z79->Z79_B20    := nBOXP25
	Z79->Z79_B20    := nBOXP26
	Z79->Z79_B20    := nBOXP27
	Z79->Z79_B20    := nBOXP28
	CalcNCs() //calcula as NCs novamente para evitar que na confirmação, a pessoa tenha deixado de calcular
	Z79->Z79_QC     := nQC
	Z79->Z79_QNC    := nQNC
	Z79->Z79_QNA    := nQNA
	
	Z79->(MsUnlock()) 
	
	MSGINFO("Dados Gravados com Sucesso !")
	If nMenuOp = 3 //só faz o link com a tela 5S - Condições Inseguras, na Inclusão da Auditoria
	
		If nQNC > 0  //se possuir não-conformidade, irá abrir tela CONDIÇÕES INSEGURAS PARA CADA NÃO-CONFORME
			aCondII := {}
			For xx := 1 to Len(aCondI)
				If &(aCondI[xx][2]) = '2'  //se = 2 - não conforme
					
					Aadd( aCondII , {aCondI[xx][1] , Substr(cSetor,1,6), Alltrim(Str(xx)) } ) //descritivo do problema, setor
					//array das condições inseguras que houveram não conformidade (só as com NC).
				Endif			
			Next
				
			If MsgYesNo("Existe(m): " + Alltrim(Str(nQNC)) + " Não-Conformidade(s), Deseja Abrir Condição(ões) Insegura(s) ?")
				y := 1
				cAnt := ""
				//aCondII := Asort( aCondII,,, { |X,Y| Substr(X[1],1,3)  < Substr(Y[1],1,3)  } ) 
				cQuest := ""
				cSector:= ""
				While y  <= Len(aCondII)
					cQuest := aCondII[y][1]
					cSector:= aCondII[y][2]
					//alert("questão: " + cQuest + " - setor: " + cSector )
					//If Alltrim(Substr(aCondII[xx][1],1,3)) != Alltrim(cAnt)  //fiz isto porque estava repetindo a inclusão de um mesmo item
						//cAnt := Substr(aCondII[xx][1],1,3)
						U_Tela5S(,,3,.T., cQuest, cSector , cCODAUD ) //lFora = .T. , descritivo da questão, nome setor, código da auditoria											
					//Endif
					y++
				Enddo
			Endif
		
		Endif
	Endif

Elseif nMenuOp = 5  //EXCLUIR
	//Z79->(Dbsetorder(1)) //Z79_FILIAL+Z79_AUDIT+Z79_DTAUD
	//If Z79->(Dbseek(xFilial("Z79") + Z79->Z79_AUDIT + Z79->Z79_DTAUD ))  //se encontrar, altera o já existem salvando as informações digitadas até então
	If MsgYesNo("Deseja REALMENTE EXCLUIR Este Registro de Auditoria ?")			
		RecLock("Z79", .F. )
		Z79->(DbDelete())
		Z79->(MsUnlock())
		MSGINFO("Dados EXCLUÍDOS com Sucesso !")
	Endif

Endif


Return
	
***********************************
Static Function PrepCampos(nMenuOp)
***********************************




Local aUsuarios := {}  
Local aUser     := {}
Local aSUser    := {}

DbSelectArea("Z79")



if nMenuOp <> 3         //Se for: 2 - visualiza , 4 - responder , 5 - exclui, 6 - altera , 7 - feedback

	cCODAUD := Z79->Z79_AUDIT //código da auditoria 
	cAuditor:= NomeOp(Z79->Z79_USRAUD)
	cDIR    := Z79->Z79_DIR
	cDTAUD  := Z79->Z79_DTAUD
	//Z79->Z79_AREA   := //DEFINIR DEPOIS COMBO OPÇÕES
    //VALORES DOS PESOS
	nP1 := Z79->Z79_P1
	nP2 := Z79->Z79_P2
	nP3 := Z79->Z79_P3
	nP4 := Z79->Z79_P4
	nP5 := Z79->Z79_P5
	nP6 := Z79->Z79_P6
	nP7 := Z79->Z79_P7
	nP8 := Z79->Z79_P8
	nP9 := Z79->Z79_P9
	nP10 := Z79->Z79_P10
	nP11 := Z79->Z79_P11
	nP12 := Z79->Z79_P12
	nP13 := Z79->Z79_P13
	nP14 := Z79->Z79_P14
	nP15 := Z79->Z79_P15
	nP16 := Z79->Z79_P16
	nP17 := Z79->Z79_P17
	nP18 := Z79->Z79_P18
	nP19 := Z79->Z79_P19
	nP20 := Z79->Z79_P20
	nP21 := Z79->Z79_P21
	nP22 := Z79->Z79_P22
	nP23 := Z79->Z79_P23
	nP24 := Z79->Z79_P24
	nP25 := Z79->Z79_P25
	nP26 := Z79->Z79_P26
	nP27 := Z79->Z79_P27
	nP28 := Z79->Z79_P28
    ///PESO TOTAL
	nPETOT := nP1 + nP2 + nP3 + nP4 + nP5 + nP6 + nP7 + nP8 + nP9 + nP10 + nP11 + nP12 + nP13 + nP14 + nP15 + nP16 + nP17 + nP18 + nP19 + nP20
	//BOXES
	If nMenuOp = 2 .or. nMenuOp = 5
		cSetor  := POSICIONE("SX5",1,XFILIAL("SX5") + 'ZW' + Z79->Z79_SETOR, Alltrim('X5_DESCRI') )
		nBOXP1 := iif( Alltrim(Z79->Z79_B1) = '1', "CONFORME" , iif ( Alltrim(Z79->Z79_B1) = '2',"NAO-CONFORME"  , "NAO APLICA" ) ) 
		nBOXP2 := iif( Alltrim(Z79->Z79_B2) = '1', "CONFORME" , iif ( Alltrim(Z79->Z79_B2) = '2',"NAO-CONFORME"  , "NAO APLICA" ) ) 
		nBOXP3 := iif( Alltrim(Z79->Z79_B3) = '1', "CONFORME" , iif ( Alltrim(Z79->Z79_B3) = '2',"NAO-CONFORME"  , "NAO APLICA" ) ) 
		nBOXP4 := iif( Alltrim(Z79->Z79_B4) = '1', "CONFORME" , iif ( Alltrim(Z79->Z79_B4) = '2',"NAO-CONFORME"  , "NAO APLICA" ) ) 
		nBOXP5 := iif( Alltrim(Z79->Z79_B5) = '1', "CONFORME" , iif ( Alltrim(Z79->Z79_B5) = '2',"NAO-CONFORME"  , "NAO APLICA" ) ) 
		nBOXP6 := iif( Alltrim(Z79->Z79_B6) = '1', "CONFORME" , iif ( Alltrim(Z79->Z79_B6) = '2',"NAO-CONFORME"  , "NAO APLICA" ) ) 
		nBOXP7 := iif( Alltrim(Z79->Z79_B7) = '1', "CONFORME" , iif ( Alltrim(Z79->Z79_B7) = '2',"NAO-CONFORME"  , "NAO APLICA" ) ) 
		nBOXP8 := iif( Alltrim(Z79->Z79_B8) = '1', "CONFORME" , iif ( Alltrim(Z79->Z79_B8) = '2',"NAO-CONFORME"  , "NAO APLICA" ) ) 
		nBOXP9 := iif( Alltrim(Z79->Z79_B9) = '1', "CONFORME" , iif ( Alltrim(Z79->Z79_B9) = '2',"NAO-CONFORME"  , "NAO APLICA" ) ) 
		nBOXP10 :=iif( Alltrim(Z79->Z79_B10) = '1', "CONFORME" , iif ( Alltrim(Z79->Z79_B10) = '2',"NAO-CONFORME"  , "NAO APLICA" ) ) 
		nBOXP11 :=iif( Alltrim(Z79->Z79_B11) = '1', "CONFORME" , iif ( Alltrim(Z79->Z79_B11) = '2',"NAO-CONFORME"  , "NAO APLICA" ) ) 
		nBOXP12 :=iif( Alltrim(Z79->Z79_B12) = '1', "CONFORME" , iif ( Alltrim(Z79->Z79_B12) = '2',"NAO-CONFORME"  , "NAO APLICA" ) ) 
		nBOXP13 :=iif( Alltrim(Z79->Z79_B13) = '1', "CONFORME" , iif ( Alltrim(Z79->Z79_B13) = '2',"NAO-CONFORME"  , "NAO APLICA" ) ) 
		nBOXP14 :=iif( Alltrim(Z79->Z79_B14) = '1', "CONFORME" , iif ( Alltrim(Z79->Z79_B14) = '2',"NAO-CONFORME"  , "NAO APLICA" ) ) 
		nBOXP15 :=iif( Alltrim(Z79->Z79_B15) = '1', "CONFORME" , iif ( Alltrim(Z79->Z79_B15) = '2',"NAO-CONFORME"  , "NAO APLICA" ) ) 
		nBOXP16 :=iif( Alltrim(Z79->Z79_B16) = '1', "CONFORME" , iif ( Alltrim(Z79->Z79_B16) = '2',"NAO-CONFORME"  , "NAO APLICA" ) ) 
		nBOXP17 :=iif( Alltrim(Z79->Z79_B17) = '1', "CONFORME" , iif ( Alltrim(Z79->Z79_B17) = '2',"NAO-CONFORME"  , "NAO APLICA" ) ) 
		nBOXP18 :=iif( Alltrim(Z79->Z79_B18) = '1', "CONFORME" , iif ( Alltrim(Z79->Z79_B18) = '2',"NAO-CONFORME"  , "NAO APLICA" ) ) 
		nBOXP19 :=iif( Alltrim(Z79->Z79_B19) = '1', "CONFORME" , iif ( Alltrim(Z79->Z79_B19) = '2',"NAO-CONFORME"  , "NAO APLICA" ) ) 
		nBOXP20 :=iif( Alltrim(Z79->Z79_B20) = '1', "CONFORME" , iif ( Alltrim(Z79->Z79_B20) = '2',"NAO-CONFORME"  , "NAO APLICA" ) ) 
		nBOXP21 :=iif( Alltrim(Z79->Z79_B21) = '1', "CONFORME" , iif ( Alltrim(Z79->Z79_B21) = '2',"NAO-CONFORME"  , "NAO APLICA" ) ) 
		nBOXP22 :=iif( Alltrim(Z79->Z79_B22) = '1', "CONFORME" , iif ( Alltrim(Z79->Z79_B22) = '2',"NAO-CONFORME"  , "NAO APLICA" ) ) 
		nBOXP23 :=iif( Alltrim(Z79->Z79_B23) = '1', "CONFORME" , iif ( Alltrim(Z79->Z79_B23) = '2',"NAO-CONFORME"  , "NAO APLICA" ) ) 
		nBOXP24 :=iif( Alltrim(Z79->Z79_B24) = '1', "CONFORME" , iif ( Alltrim(Z79->Z79_B24) = '2',"NAO-CONFORME"  , "NAO APLICA" ) ) 
		nBOXP25 :=iif( Alltrim(Z79->Z79_B25) = '1', "CONFORME" , iif ( Alltrim(Z79->Z79_B25) = '2',"NAO-CONFORME"  , "NAO APLICA" ) ) 
		nBOXP26 :=iif( Alltrim(Z79->Z79_B26) = '1', "CONFORME" , iif ( Alltrim(Z79->Z79_B26) = '2',"NAO-CONFORME"  , "NAO APLICA" ) ) 
		nBOXP27 :=iif( Alltrim(Z79->Z79_B27) = '1', "CONFORME" , iif ( Alltrim(Z79->Z79_B27) = '2',"NAO-CONFORME"  , "NAO APLICA" ) ) 
		nBOXP28 :=iif( Alltrim(Z79->Z79_B28) = '1', "CONFORME" , iif ( Alltrim(Z79->Z79_B28) = '2',"NAO-CONFORME"  , "NAO APLICA" ) ) 
	Else 
		//alert("prepara para alterar")
		nProc  := Ascan(aSetores, Z79->Z79_SETOR)
		cSetor  := aSetores[nProc]
		nBOXP1 := Z79->Z79_B1
		nBOXP2 := Z79->Z79_B2
		nBOXP3 := Z79->Z79_B3
		nBOXP4 := Z79->Z79_B4
		nBOXP5 := Z79->Z79_B5
		nBOXP6 := Z79->Z79_B6
		nBOXP7 := Z79->Z79_B7
		nBOXP8 := Z79->Z79_B8
		nBOXP9 := Z79->Z79_B9
		nBOXP10 :=Z79->Z79_B10
		nBOXP11 :=Z79->Z79_B11
		nBOXP12 :=Z79->Z79_B12
		nBOXP13 :=Z79->Z79_B13
		nBOXP14 :=Z79->Z79_B14
		nBOXP15 :=Z79->Z79_B15
		nBOXP16 :=Z79->Z79_B16
		nBOXP17 :=Z79->Z79_B17
		nBOXP18 :=Z79->Z79_B18
		nBOXP19 :=Z79->Z79_B19
		nBOXP20 :=Z79->Z79_B20
		nBOXP21 :=Z79->Z79_B21
		nBOXP22 :=Z79->Z79_B22
		nBOXP23 :=Z79->Z79_B23
		nBOXP24 :=Z79->Z79_B24
		nBOXP25 :=Z79->Z79_B25
		nBOXP26 :=Z79->Z79_B26
		nBOXP27 :=Z79->Z79_B27
		nBOXP28 :=Z79->Z79_B28
	
	Endif
	nQC  := Z79->Z79_QC     
	nQNC := Z79->Z79_QNC
	nQNA := Z79->Z79_QNA    
	
	LoadQuest(cDIR)  //CARREGA AS PERGUNTAS
	CheckLIST(cDIR, nMenuOp) //CHAMA O CHECKLIST

Endif // FR do nMenuOp <> 3
    
	
	

Return

	
***************

Static Function NomeOp( cOperado )

***************
Local cNome := ""

PswOrder(1)
If PswSeek( cOperado, .T. )
   aUsuarios  := PSWRET() 					
   //cNome := Alltrim(aUsuarios[1][2])     	// Nome do usuário
   cNome := Alltrim(aUsuarios[1][4])     	// Nome do usuário
Endif 

return cNome


                             
********************************
Static Function LoadQuest(cDIR) 
********************************


If Alltrim(cDIR) != "ADM" //PLÁSTICO E CAIXAS SÃO IGUAIS

	cQuest11 := "1.1 - HÁ PRESENÇA DE OBJETOS NÃO PERTENCENTES A ÁREA DE TRABALHO, OBJETOS DE OUTRAS ÁREAS."
	cQuest12 := "1.2 - OS RECURSOS ESTÃO DISPOSTOS NAS QUANTIDADES ADEQUADAS AO USO NA ÁREA DE TRABALHO?(SEM EVIDÊNCIAS DE EXCESSOS E/OU DESPERDÍCIOS)."
	cQuest13 := "1.3 - HÁ  DESPERDICIO INCLUÍ-SE VAZAMENTOS DE INSUMOS MATERIA PRIMA E UTILIDADES"
	cQuest14 := "1.4 - EXISTEM EQUIPAMENTOS OU MÁQUINAS SEM USO NA ÁREA OBSOLETOS,DANIFICADOS"
	cQuest15 := "1.5 - TODOS OS OBJETOS SÃO UTILIZADOS EXATAMENTE PARA OS FINS AOS QUAIS SE DESTINAM"
	
	cQuest21 := "2.1 - EXISTE LOCAL ESPECÍFICO, IDENTIFICADO, DEMARCADO PARA GUARDA E SEGREGAÇÃO DE MATERIAIS/RESÍDUOS? (FERRAMENTAS, MATÉRIA-PRIMA,PRODUTO E NÃO QUALIDADE) "
	cQuest22 := "2.2 - MESAS, BANCADAS MANTIDAS ORGANIZADAS DURANTE A EXECUÇÃO DAS TAREFAS"
	cQuest23 := "2.3 - EXISTÊNCIA DE IDENTIFICAÇÃO DOS MATERIAIS DENTRO DOS PADRÕES DA EMRESA"
	cQuest24 := "2.4 - RESÍDUOS E INUTILIZADO: ACUMULAÇÃO, REMOÇÃO, ARMAZENAMENTO E ELIMINAÇÃO."
	cQuest25 := "2.5 - CORREDOR E ÁREA DE EMPILHAMENTO : FACILIDADE DE ACESSO, DEMARCAÇÃO E DIMENSÕES ADEQUADAS."
	cQuest26 := "2.6 - MATERIAIS PRATELEIRAS , ÁRMARIOS GAVETAS, ETC ESTÃO  IDENTIFICADOS."
	cQuest27 := "2.7 - AS PLACAS DE IDENTIFICAÇÃO (ÁREAS, SALAS, SINALIZAÇÃO) ESTÃO EM BOAS CONDIÇÕES"
	
	cQuest31 := "3.1 - AS MESAS, BANCADAS, GAVETAS , MÁQUINAS E EQUIPAMENTOS ESTÃO LIVRES E DESOBSTRUIDOS DE PRESENÇA DE POEIRA, SUJEIRA "
	cQuest32 := "3.2 - O PISO , AS PARTEDES E JANELAS ESTÃO LIMPOS."
	cQuest33 := "3.3 - DELEGAÇÃO DE RESPONSÁVEIS (RODÍZIO) PELA AVALIAÇÃO DO CHECK LIST E VERIFICAÇÃO DA LIMPEZA."
	cQuest34 := "3.4 - O TETO E AS LUMINARIS  ESTÃO LIMPOS"
	cQuest35 := "3.5 - OS UNIFORMES DOS FUNCIONÁRIOS ESTÃO LIMPOS E BEM CONSERVADOS"
	
	cQuest41 := "4.1 - TODAS AS ÁREAS, ATIVIDADES E MÁQUINAS ESTÃO EM CONDIÇÕES SEGURAS E ADEQUADAS AO DESENVOLVIMENTO DO TRABALHO ,INSTALAÇÕES ELÉTRICAS : INSTALAÇÃO, FIOS, E CONEXÕES (EXISTÊNCIA DE GAMBIARRAS, TEMPERATURA, ILUMINAÇÃO,ETC)"
	cQuest42 := "4.2 - AS FAIXAS DE SEGURANÇA ESTÃO VISÍVEIS"
	cQuest43 := "4.3 - TODOS OS FUNCIONÁRIOS FAZEM USO ADEQUADO DE E.P.I "
	cQuest44 := "4.4 - EXTINTORES E EQUIPAMENTOS DE EMERGENCIA DE FÁCIL ACESSO, EM BOM ESTADO, DENTRO DO PRAZO DE VALIDADE"
	cQuest45 := "4.5 - EXISTE SINALIZAÇÃO ATUALIZADA DOS RICOS DA ÁREA (MAPA DE RISCO) ."
	cQuest46 := "4.6 - AS SAÍDAS DE EMERGÊNCIAS ESTÃ SINALIZADAS E DESOBSTRUÍDAS"
	
	cQuest51 := "5.1 - O LOCAL ESTÁ ISENTO DE MATERIAIS DESNECESSÁRIOS"
	cQuest52 := "5.2 - AS PLACAS DE IDENTIFICAÇÃO ESTÃO EM BOAS CONDIÇÕES"
	cQuest53 := "5.3 - O REFEITÓRIO ESTÁ LIMPO, ORGANIZADO, ESTRUTURA ADEQUADA"
	cQuest54 := "5.4 - EXISTE PAPÉIS E OUTROS RESÍDUOS JOGADOS NO CHÃO"
	cQuest55 := "5.5 - OS BANHEIROS E VESTIÁRIOS, PÁTIOS ESTÃO LIMPOS E BEM CONSERVADOS" 
	
	//adicionarei todas as perguntas, mas somente usarei as que a resposta for = 2-não conforme
	///senso 1
	num  := 1 
	numB := 1 
	xx   := 0 
	cVar := ""                       
	cVarB:= ""
	For num := 1 to 5
		cVar := "cQuest1" + Alltrim(Str(num)) //cQuest11
		cVarB:= "nBoxP" + Alltrim(Str(numB))  //nBoxP1
		Aadd(aCondI , { &(cVar) , cVarB } )  //0 -> resposta do box, se for = 2-não conforme, irá gerar a solicitação de condição insegura
		numB++
	Next
	//aCondI[x][1] = cQuest11
	//aCondI[x][2] = nBoxP1
	
	//senso 2
	num  := 1  
	xx   := 0 
	cVar := ""
	cVarB:= ""                       
	For num := 1 to 7
		cVar := "cQuest2" + Alltrim(Str(num)) //cQuest21
		cVarB:= "nBoxP" + Alltrim(Str(numB))  //nBoxP1
		Aadd(aCondI , { &(cVar) , cVarB } )  //0 -> resposta do box, se for = 2-não conforme, irá gerar a solicitação de condição insegura
		numB++
	Next
	
	//senso 3
	num  := 1  
	xx   := 0 
	cVar := ""
	cVarB:= ""                       
	For num := 1 to 5
		cVar := "cQuest3" + Alltrim(Str(num)) //cQuest31
		cVarB:= "nBoxP" + Alltrim(Str(numB))  //nBoxP1
		Aadd(aCondI , { &(cVar) , cVarB } )  //0 -> resposta do box, se for = 2-não conforme, irá gerar a solicitação de condição insegura
		numB++
	Next
	
	//senso 4
	num  := 1  
	xx   := 0 
	cVar := ""
	cVarB:= ""                       
	For num := 1 to 6
		cVar := "cQuest4" + Alltrim(Str(num)) //cQuest41
		cVarB:= "nBoxP" + Alltrim(Str(numB))  //nBoxP1
		Aadd(aCondI , { &(cVar) , cVarB } )  //0 -> resposta do box, se for = 2-não conforme, irá gerar a solicitação de condição insegura
		numB++
	Next
	
	//senso 5
	num  := 1  
	xx   := 0 
	cVar := ""
	cVarB:= ""                       
	For num := 1 to 5
		cVar := "cQuest5" + Alltrim(Str(num)) //cQuest51
		cVarB:= "nBoxP" + Alltrim(Str(numB))  //nBoxP1
		Aadd(aCondI , { &(cVar) , cVarB } )  //0 -> resposta do box, se for = 2-não conforme, irá gerar a solicitação de condição insegura
		numB++
	Next
	
Else //ADM
	cQuest11 := "1.1 - EXISTEM PAPEIS OU MATERIAIS EM EXCESSO CIRCULANDO NO AMBIENTE DE TRABALHO, EM LOCAIS INADEQUADOS, QUE PODEM SER DESCARTADOS ?"
	cQuest12 := "1.2 - EXISTEM OBJETOS ESTRANHOS, QUE NÃO CORRESPONDAM AO AMBIENTE DE TRABALHO, SOBRE OU ATRÁS DE ARMARIOS OU ARQUIVOS, QUE PODEM SER DESCARTADOS ?"
	cQuest13 := "1.3 - O MOBILIARIO, EQUIPAMENTOS E MATERIAIS APARENTAM ESTAR EM BOAS CONDIÇÕES DE USO , SEM NECESSIDADE DE DESCARTE?"
	
	cQuest21 := "2.1 - EXISTE LOCAL DETERMINADO PARA CADA TIPO DE OBJETO, DOCUMENTO, FERRAMENTA ETC"
	cQuest22 := "2.2 - ARMARIOS, ARQUIVOS, FERRAMENTAS, PORTAS, EQUIPAMENTOS, QUANDO DE USO COLETIVO, ESTÃO IDENTIFICADOS"
	cQuest23 := "2.3 - SOBRE AS MESAS ESTAO MATERIAIS DE TRABALHO, SEM ACÚMULO (QUANTIDADE EXCESSIVA) DE OUTROS OBJETOS (ENFEITES, PASTAS, PAPEIS OU CAIXAS ETC)"
	cQuest24 := "2.4 - O AMBIENTE APRESENTA, DE FORMA GERAL, A IMPRESSÃO DE SER ORGANIZADO"
	
	cQuest31 := "3.1 - PRESENÇA DE POEIRA, SUJEIRA (CHÃO, PORTAS, PAREDES, VIDROS, MESAS, )."
	cQuest32 := "3.2 - AS MÁQUINAS E EQUIPAMENTOS ESTÃO BEM CONSERVADOS"
	cQuest33 := "3.3 - ARRUMAÇÃO DE ARMÁRIOS, MESAS, ETC."
	cQuest34 := "3.4 - OS DEPÓSITOS, CORREDORES E ESCADAS ESTAO LIMPOS E BEM CONSERVADOS"
	cQuest35 := "3.5 - AS LÂMPADAS, LUMINÁRIAS, SINALIZADORES, ESTÃO LIMPOS E BEM CONSERVADOS, NÃO POSSUI FIOS EXPOSTOS, PENDURADOS E BEM CONSERVADOS"
	cQuest36 := "3.6 - O LOCAL POSSUI COLETORES DE LIXO QUE SÃO ADEQUADO AO AMBIENTE"
	cQuest37 := "3.7 - CONDIÇÕES DO TETO / FORRO / PAREDES / JANELAS (ESTADO GERAL)."
	
	cQuest41 := "4.1 - INSTALAÇÕES ELÉTRICAS : INSTALAÇÃO, FIOS, E CONEXÕES."
	cQuest42 := "4.2 - EXTINTORES PORTÁTEIS : INSTALAÇÃO CORRETA, SINAIS DE LOCALIZAÇÃO E INSTRUÇÕES, LIVRE ACESSO E CONDIÇÕES OPERACIONAIS"
	cQuest43 := "4.3 - EXAMES PERIODICOS ESTÃO ATUALIZADOS"
	cQuest44 := "4.4 - OS BANHEIROS E VESTIARIOS SÃO DE USO COMUM,E ENCONTRAM-SE LIMPOS E ORGANIZADOS?"
	
	cQuest51 := "5.1 - OS COLABORADORES DO SETOR TEM CONHECIMENTO DO SIGNIFICADO DOS SENSOS"
	cQuest52 := "5.2 - ADERÊNCIA ÀS REGRAS GERAIS DA EMPRESA, COMO O USO DO CRACHÁ, POR EXEMPLO "
	
	///senso 1
	num  := 1
	numB := 1  
	xx   := 0
	cVar := ""
	cVarB:= ""                        
	For num := 1 to 3
		cVar := "cQuest1" + Alltrim(Str(num)) //cQuest11
		cVarB:= "nBoxP" + Alltrim(Str(numB))  //nBoxP1
		Aadd(aCondI , { &(cVar) , cVarB } )  //0 -> resposta do box, se for = 2-não conforme, irá gerar a solicitação de condição insegura
		numB++
	Next
	
	//senso 2
	num  := 1
	xx   := 0 
	cVar := ""                           
	cVarB:= ""
	For num := 1 to 4
		cVar := "cQuest2" + Alltrim(Str(num)) //cQuest21
		cVarB:= "nBoxP" + Alltrim(Str(numB))  //nBoxP1
		Aadd(aCondI , { &(cVar) , cVarB } )  //0 -> resposta do box, se for = 2-não conforme, irá gerar a solicitação de condição insegura
		numB++
	Next
	
	//senso 3
	num  := 1  
	xx   := 0
	cVar := "" 
	cVarB:= ""                       
	For num := 1 to 7
		cVar := "cQuest3" + Alltrim(Str(num)) //cQuest31
		cVarB:= "nBoxP" + Alltrim(Str(numB))  //nBoxP1
		Aadd(aCondI , { &(cVar) , cVarB } )  //0 -> resposta do box, se for = 2-não conforme, irá gerar a solicitação de condição insegura
		numB++
	Next
	
	//senso 4
	num  := 1  
	xx   := 0                        
	cVar := "" 
	cVarB:= ""
	For num := 1 to 4
		cVar := "cQuest4" + Alltrim(Str(num)) //cQuest41
		cVarB:= "nBoxP" + Alltrim(Str(numB))  //nBoxP1
		Aadd(aCondI , { &(cVar) , cVarB } )  //0 -> resposta do box, se for = 2-não conforme, irá gerar a solicitação de condição insegura
		numB++
	Next
	
	//senso 5
	num  := 1  
	xx   := 0 
	cVar := ""  
	cVarB:= ""                     
	For num := 1 to 2
		cVar := "cQuest5" + Alltrim(Str(num)) //cQuest51
		cVarB:= "nBoxP" + Alltrim(Str(numB))  //nBoxP1
		Aadd(aCondI , { &(cVar) , cVarB } )  //0 -> resposta do box, se for = 2-não conforme, irá gerar a solicitação de condição insegura
		numB++
	Next

Endif

Return




