#INCLUDE "rwmake.ch"
#include "topconn.ch" 
#INCLUDE "COLORS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FATC027  บ Autor ณ Flแvia Rocha       บ Data ณ  23/11/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Browse que mostra a programa็ใo de Feriados                บฑฑ
ฑฑบ          ณ Tabela 63 do SX5                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Logํstica e SAC                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function FATC027


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cFiltro	:= ""
Local aIndexSX5	:= {}

Private cPerg   := "63"
Private cCadastro := "Cadastro de Feriados"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta um aRotina proprio                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","U_fFeriado(1)",0,2} ,;
             {"Incluir","U_fFeriado(2)",0,3} ,;
             {"Alterar","U_fFeriado(3)",0,4} ,;
             {"Excluir","U_fFeriado(4)",0,5} }

Private cDelFunc := ".F." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SX5"
Private bFiltraBrw := {} 
Private aCampos    := {}

dbSelectArea("SX5")
dbSetOrder(1)

//cPerg   := "Z3"

//Pergunte(cPerg,.F.)
//SetKey(123,{|| Pergunte(cPerg,.T.)}) // Seta a tecla F12 para acionamento dos parametros

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Executa a funcao MBROWSE. Sintaxe:                                  ณ
//ณ                                                                     ณ
//ณ mBrowse(<nLin1,nCol1,nLin2,nCol2,Alias,aCampos,cCampo)              ณ
//ณ Onde: nLin1,...nCol2 - Coordenadas dos cantos aonde o browse sera   ณ
//ณ                        exibido. Para seguir o padrao da AXCADASTRO  ณ
//ณ                        use sempre 6,1,22,75 (o que nao impede de    ณ
//ณ                        criar o browse no lugar desejado da tela).   ณ
//ณ                        Obs.: Na versao Windows, o browse sera exibi-ณ
//ณ                        do sempre na janela ativa. Caso nenhuma este-ณ
//ณ                        ja ativa no momento, o browse sera exibido naณ
//ณ                        janela do proprio SIGAADV.                   ณ
//ณ Alias                - Alias do arquivo a ser "Browseado".          ณ
//ณ aCampos              - Array multidimensional com os campos a serem ณ
//ณ                        exibidos no browse. Se nao informado, os cam-ณ
//ณ                        pos serao obtidos do dicionario de dados.    ณ
//ณ                        E util para o uso com arquivos de trabalho.  ณ
//ณ                        Segue o padrao:                              ณ
//ณ                        aCampos := { {<CAMPO>,<DESCRICAO>},;         ณ
//ณ                                     {<CAMPO>,<DESCRICAO>},;         ณ
//ณ                                     . . .                           ณ
//ณ                                     {<CAMPO>,<DESCRICAO>} }         ณ
//ณ                        Como por exemplo:                            ณ
//ณ                        aCampos := { {"TRB_DATA","Data  "},;         ณ
//ณ                                     {"TRB_COD" ,"Codigo"} }         ณ
//ณ cCampo               - Nome de um campo (entre aspas) que sera usadoณ
//ณ                        como "flag". Se o campo estiver vazio, o re- ณ
//ณ                        gistro ficara de uma cor no browse, senao fi-ณ
//ณ                        cara de outra cor.                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//aCampos := { {"Data", "X5_CHAVE"},; 
//			{"Valor MP", "X5_DESCRI"} }   
			
aCampos := { {"Data", "Substr(X5_DESCRI,1,5) + '/' + Substr(DtoS(dDatabase),3,2)"},; 
			{"Descri็ใo", "Alltrim(Substr(X5_DESCRI,9,Len(X5_DESCRI) - 8))"} } //,;
			//{"**********" , "*********************************************" } }


cFiltro	:= "X5_TABELA = '63' .and. X5_CHAVE != '011' .and. X5_CHAVE != '012' "


If !Empty(cFiltro)
	bFiltraBrw	:= { || FilBrowse("SX5", @aIndexSX5, @cFiltro) }
	Eval(bFiltraBrw)
EndIf


dbSelectArea(cString)
mBrowse( 6,1,22,75,cString, aCampos)

//Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros
If !Empty(cFiltro)
	EndFilBrw("SX5", aIndexSX5)
EndIf

Return                               

******************************
User Function fFeriado(nOpc)
******************************

Local cQuery       := ""
Local x5CHAVE      := ""
Local nSpace       := 0 
Local CHAVEX5      := SX5->X5_CHAVE
Private cDesc      := Space(55)
Private cFeriado   := CtoD("  /  /    ")
Private nOpcA      := 0 
Private cOption    := "" 
Private cDatAnt    := Ctod("  /  /    ") 
Private cDescAnt   := ""



/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑ Declara็ใo de Variaveis Private dos Objetos                             ฑฑ
ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
SetPrvt("oDlg1","oGrp1","oSBtn1","oSBtn2","oSay1","oGet1","oSay2","oGet2")  

If nOpc = 1
	cOption := " - Visualizar"
	cFeriado:= Substr(SX5->X5_DESCRI,1,5) + '/' + Substr(DtoS(dDatabase),3,2)
	cDesc   := Alltrim(Substr(SX5->X5_DESCRI,9,Len(SX5->X5_DESCRI) - 8))
Elseif nOpc = 2
	cOption := " - Incluir"
Elseif nOpc = 3
	cOption := " - Alterar"
	cFeriado:= CtoD(Substr(SX5->X5_DESCRI,1,5) + '/' + Substr(DtoS(dDatabase),3,2))
	cDesc   := Alltrim(Substr(SX5->X5_DESCRI,9,Len(SX5->X5_DESCRI) - 8))
	nSpace  := Len(SX5->X5_DESCRI) - Len(cDesc)               
	cDesc   := Alltrim(Substr(SX5->X5_DESCRI,9,Len(SX5->X5_DESCRI) - 8)) + Space(nSpace)
	
	//cDatAnt := CtoD(Substr(X5_DESCRI,1,5) + '/' + Substr(DtoS(dDatabase),3,2))
	//cDescAnt:= Alltrim(Substr(X5_DESCRI,9,Len(X5_DESCRI) - 8))
Elseif nOpc = 4
	cOption := " - Excluir"
	cFeriado:= CtoD(Substr(SX5->X5_DESCRI,1,5) + '/' + Substr(DtoS(dDatabase),3,2))
	cDesc   := Alltrim(Substr(SX5->X5_DESCRI,9,Len(SX5->X5_DESCRI) - 8))
	nSpace  := Len(SX5->X5_DESCRI) - Len(cDesc)               
	cDesc   := Alltrim(Substr(SX5->X5_DESCRI,9,Len(SX5->X5_DESCRI) - 8)) + Space(nSpace)
	 
	
	
	//cDatAnt := CtoD(Substr(X5_DESCRI,1,5) + '/' + Substr(DtoS(dDatabase),3,2))
	//cDescAnt:= Alltrim(Substr(X5_DESCRI,9,Len(X5_DESCRI) - 8))
Endif

/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑ Definicao do Dialog e todos os seus componentes.                        ฑฑ
ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
oDlg1      := MSDialog():New( 126,254,345,753,"Cadastro de Feriados" + cOption,,,.F.,,,,,,.T.,,,.F. )
oGrp1      := TGroup():New( 012,010,073,238,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

oSay1      := TSay():New( 024,026,{||"Data :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
oSay2      := TSay():New( 044,026,{||"Descri็ใo :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
If nOpc > 1                            
	oGet1      := TGet():New( 024,070,,oGrp1,060,008,'@D',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cFeriado",,)
	oGet2      := TGet():New( 042,070,,oGrp1,154,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDesc",,)

Else                  //read only .T.
	oGet1      := TGet():New( 024,070,,oGrp1,060,008,'@D',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cFeriado",,)
 //oPrevisao   := TGet():New( 145,065,,oGrp1,060,008,'@D',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPrevisao",,)
	oGet2      := TGet():New( 042,070,,oGrp1,154,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cDesc",,)
Endif
oGet1:bSetGet := {|u| If(PCount()>0,cFeriado:=u,cFeriado)}
oGet2:bSetGet := {|u| If(PCount()>0,cDesc:=u,cDesc)}

oSBtn1     := SButton():New( 080,168,1,,oDlg1,,"", )   //ok
oSBtn1:bAction := {||(nOpcA := 1 , oDlg1:End() )}

oSBtn2     := SButton():New( 080,210,2,,oDlg1,,"", )   //cancela
oSBtn2:bAction := {||(nOpcA := 0 , oDlg1:End() )}

oDlg1:Activate(,,,.T.)

If nOpcA = 1
	If nOpc = 2 //incluir
		
		cChave := ""
        //busca a ๚ltima chave cadastrada....
		cQuery := " SELECT TOP 1 X5_CHAVE " + CHR(13) + CHR(10)
		cQuery += "  FROM " + RetSqlName("SX5") + " SX5 "  + CHR(13) + CHR(10)
		cQuery += " WHERE "  + CHR(13) + CHR(10)
		cQuery += " X5_FILIAL = '" + Alltrim(xFilial("SX5")) + "'  "  + CHR(13) + CHR(10)
		cQuery += " AND X5_TABELA = '63' "  + CHR(13) + CHR(10)
		cQuery += " AND D_E_L_E_T_ = '' "  + CHR(13) + CHR(10)
		cQuery += " Order by X5_CHAVE DESC "  + CHR(13) + CHR(10)
		If Select("TEMP1") > 0		
			DbSelectArea("TEMP1")
			DbCloseArea()			
		EndIf
		TCQUERY cQuery NEW ALIAS "TEMP1"
		TEMP1->(DbGoTop())
		If !TEMP1->(EOF())
			While !TEMP1->(Eof())
				cChave:= TEMP1->X5_CHAVE 			
				TEMP1->(DBSKIP())
			Enddo
			x5CHAVE := Strzero(Val( cChave ) + 1,3)  //soma mais um na chave para criar uma nova
			
			DbSelectArea("SX5")
			RecLock("SX5",.T.)
			SX5->X5_FILIAL := xFilial("SX5")
			SX5->X5_TABELA := '63'
			SX5->X5_CHAVE  := x5CHAVE
			SX5->X5_DESCRI := Substr(DTOS(cFeriado),7,2) + '/' + Substr(DTOS(cFeriado),5,2) + Space(4) + cDesc
			SX5->X5_DESCSPA := Substr(DTOS(cFeriado),7,2) + '/' + Substr(DTOS(cFeriado),5,2)+ Space(4) + cDesc
			SX5->X5_DESCENG := Substr(DTOS(cFeriado),7,2) + '/' + Substr(DTOS(cFeriado),5,2)+ Space(4) + cDesc
			SX5->(MsUnlock())
		Endif
	Elseif nOpc = 3 // alterar
		IF Alltrim(CHAVEX5) $ '001/003/004/005/006/007/008/009'   //FERIADOS FIXOS, NรO PODEM SER EXCLUอDOS
			Aviso(	cCadastro,;
					"FERIADO FIXO Nใo Pode ser Alterado !!!",;
					{"&Continua"},,;
					"Feriado: " + DToc(cFeriado) + " - " + cDesc )
		ELSE
			RecLock("SX5",.F.)
			SX5->X5_DESCRI := Substr(DTOS(cFeriado),7,2) + '/' + Substr(DTOS(cFeriado),5,2)+ Space(4) + cDesc
			SX5->X5_DESCSPA := Substr(DTOS(cFeriado),7,2) + '/' + Substr(DTOS(cFeriado),5,2)+ Space(4) + cDesc
			SX5->X5_DESCENG := Substr(DTOS(cFeriado),7,2) + '/' + Substr(DTOS(cFeriado),5,2)+ Space(4) + cDesc
			SX5->(MsUnlock())  
		ENDIF
	
	Elseif nOpc = 4
		IF Alltrim(CHAVEX5) $ '001/003/004/005/006/007/008/009'   //FERIADOS FIXOS, NรO PODEM SER EXCLUอDOS
			Aviso(	cCadastro,;
					"FERIADO FIXO Nใo Pode ser Excluํdo !!!",;
					{"&Continua"},,;
					"Feriado: " + DToc(cFeriado) + " - " + cDesc )
					Return(Nil)
		ELSE
			//MSGBOX("EXCLUSรO OK")
			RecLock("SX5",.F.)
			SX5->(DbDelete())
			SX5->(MsUnlock())
		ENDIF
	ELSE
	Endif
Endif

Return
