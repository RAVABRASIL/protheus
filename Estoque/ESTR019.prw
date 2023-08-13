#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
#include "Tbiconn.ch "

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} doLoadData
Programa para imprimir as etiquetas do fardão.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     22/04/2015
/*/
//------------------------------------------------------------------------------------------
User Function ESTR019()

Local _cPorta	  := 'LPT1'//'COM1:9600,8,N,1' //'LPT1'
Local nQuant	  := 1
Local cOP		  := ""
local _cLote      := ""
Local cCodBar	  := ""
Local cProd		  := ""
Local cCodProd	  := ""
Local cAdj		  := ""
Local cCapac	  := ""
Local nQFardinho := 0
Local nQFardo	  := 0
Local lReg       := .F.
Local cSLin      := ""
Local cReg       := "ISENTO"

Private _nQuant  := 0
Private _cMaq	  := ""
Private nOPC
Private nTipo
Private cTurno
Private cLado	  := " "
PRIVATE cTURNO1  := SubStr(GetMv( "MV_TURNO1" ),1,5) 
PRIVATE cTURNO2  := SubStr(GetMv( "MV_TURNO2" ),1,5)
PRIVATE cTURNO3  := SubStr(GetMv( "MV_TURNO3" ),1,5)

Do Case
	case Time() > cTURNO1 .and. Time() < cTURNO2
		cTurno	:= "1"
	case Time() > cTURNO2 .and. Time() < cTURNO3
		cTurno	:= "2"
	OtherWise	
		cTurno	:= "3"
EndCase

cOP		:= fQtdImp()

dbSelectArea("SC2")
dbSetOrder(1)

If _nQuant	> 200
	MsgAlert("Quantidade máxima permitida é 200!")
	Return
EndIf

If !SC2->(dbSeek(xFilial('SC2') + cOP))
	MsgAlert("OP não encontrada!")
	Return
Else	
	cCodProd	:= SC2->C2_PRODUTO
    
    // funcao que retorna o lote em que a OP pertence  
	_cLote      :=   fLote(SC2->C2_NUM)

    if empty(_cLote)
       MsgAlert("OP sem Lote. Favor Contactar o PCP!!!")
	   Return    
    endif
    //
    
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1") + cCodProd)
	
	If SB1->B1_TIPO <> 'PA'
		MsgAlert("Este produto não é um PA!")
		Return
	EndIf
	
	Do Case
		Case nOPC == '1' //Fardinho
			cCodBar		:= SB1->B1_CODPACO
		Case nOPC == '2' //Fardo
			cCodBar		:= SB1->B1_CODFARD
		//Case nOPC = 3 //Capa
	EndCase
	
     cProd:= StrTran( UPPER(Alltrim(SB1->B1_DESC)) , "CM" , "cm" )// A PALAVRA "CM" TEM QUE SAIR EM MINUSCULO , NORMA DO IMETRO
	
	//cProd		:= Alltrim(SB1->B1_DESC)
	
	if SB1->B1_SETOR $ "08,09,10,11,12,13,14,30,34,35,36,41,55"
	   cSLin := "INF"
	   //Somente a Linha 1 tera a informação do numero do reg na etiqueta
	   if Alltrim(B1_COD) $ SUPERGETMV("RV_COL1H",,"CDB155,CGB156,CIB157,CKB158,CDB154,CGB155,CIB156,CKB157")  
	      cReg := "80056810004"
	   endif   
	elseif SB1->B1_SETOR $ "05,37,40,56"
	   cSLin := "HAM"
	elseif SB1->B1_SETOR $ "06,54,98"
	   cSLin := "OBI"
	else
	   cSLin := ""   
	endif	
	lReg := !Empty(cSLin)	
EndIf
                                            
dbSelectArea("SB5")
dbSetOrder(1)
dbSeek(xFilial("SB5") + cCodProd)

nQFardinho	:= SB5->B5_QTDEMB
nQFardo		:= SB5->B5_QTDFIM // SB5->B5_QE1
cCPD        := Alltrim(SB5->B5_CAPACID) //Letra que identifica a Capacidade

Do Case
	Case nTipo == "6" //Lanlimp
		cProd:= StrTran( UPPER(Alltrim(SB5->B5_CEME)) , "CM" , "" )
EndCase

dbSelectArea("SX5")
dbSetOrder(1)
If !Empty(Alltrim(SB5->B5_CAPACID))

	dbSeek(xFilial("SX5") + "Z0" + Alltrim(SB5->B5_CAPACID))
	cCapac	:= AllTrim(SX5->X5_DESCRI)

Else 

	cCapac	:= ""

EndIf

MSCBPRINTER("ZEBRA",_cPorta,NIL,,.F.,,,,,,.T.)

For i := 1 To _nQuant
	
	Conout("Antes MSCBBEGIN")
	//MSCBINFOETI("Etiqueta Termica EXPEDICAO","MODELO 1") 
	MSCBBEGIN(1,1)                             
	 
	//Conout("Antes MSCBBOX")
	//MSCBBOX(05,05,79,62,6) //Box Geral
	Do Case
		Case nTipo == "1"
			
			MSCBSAY(07,06,"RAVA","N","0","80")	// Horizontal
			MSCBSAY(08,14,"EMBALAGENS","N","C","14")	// Horizontal

		Case nTipo == "2"
			
			MSCBSAY(07,06,"Probag","N","0","70")	// Horizontal
			MSCBSAY(06,14,"09.449.930/0001-00","N","C","14")	// Horizontal
		
		Case nTipo == "3"

			MSCBSAY(12,03,"ELLO","N","0","70")	// Horizontal
			MSCBSAY(07,10,"Atacadão de Produtos Ltda","N","C","12")	// Horizontal
			MSCBSAY(09,12,"Fone: 71 3016-8800","N","C","12")	// Horizontal
			MSCBSAY(09,14,"www.grupoello.com","N","C","12")	// Horizontal
			MSCBSAY(03,16,"FABRICADO P/ 41.150.160/0001-02","R","0","18")	// Horizontal

		Case nTipo == "4" // SOS SUPER SACOS

			MSCBSAY(06,03,"SUPER SACOS","N","0","45")	// Horizontal
			MSCBSAY(07,12,"71 3379-4432/9238","N","C","10")	// Horizontal

		Case nTipo == "5"
			
			MSCBSAY(07,05,"TRIUNFO","N","0","50")	// Horizontal

		Case nTipo == "6"
			
			MSCBSAY(07,05,"LANLIMP","N","0","60")	// Horizontal

		Case nTipo == "7"
			
			MSCBSAY(07,05,"ATACALIMP","N","0","50")	// Horizontal

		Case nTipo == "8"
			
			If nOPC == '1' //Fardinho
				MSCBBOX(06,05,77,14,50)
			EndIf 
			MSCBSAY(12,05,"ENC. DAS ÁGUAS","N","0","55",.T.)	// Horizontal
			//MSCBSAY(07,12,"DAS ÁGUAS","N","C","45")	// Horizontal
		Case nTipo == "9"
			
			If nOPC == '1' //Fardinho
				MSCBBOX(06,05,77,14,50)
			EndIf 
			MSCBSAY(12,05,"O BARATÃO","N","0","55",.T.)	// Horizontal
			MSCBSAY(55,07,"(84) 3025-5555","N","0","25",.T.)	// Horizontal
			MSCBSAY(09,14,"DAS EMBALAGENS","N","C","25",.T.)	// Horizontal

		Case nTipo == "A"
			
			If nOPC == '1' //Fardinho
				MSCBBOX(06,05,77,14,50)
			EndIf 
			MSCBSAY(12,05,"DISK","N","0","55",.T.)	// Horizontal
			MSCBSAY(55,07,"(84) 3213-6387","N","0","25",.T.)	// Horizontal
			MSCBSAY(09,14,"EMBALAGENS","N","C","25",.T.)	// Horizontal
			
	    Case nTipo == "B"
			
			If nOPC == '1' //Fardinho
				MSCBBOX(06,05,77,14,50)
			EndIf 
			MSCBSAY(12,05,"BUNZL HIGIENE E LIMPEZA","N","0","40",.T.)	// Horizontal

		Case nTipo == "C"
			
			MSCBSAY(07,05,"GRAMPEL","N","0","54")	// Horizontal


	EndCase
	
	Do Case
		Case "SUP." $ cProd
			cAdj	:= "SUPER REF."
		Case "REF" $ cProd
			cAdj	:= "REFORÇADO"
		Case "LEVE" $ cProd
			cAdj	:= "LEVE"
	EndCase
	
	If nOPC == '1' //Fardinho
		
		//Reforçcado/leve/super
		If !( nTipo $ "8/9/A/B" )
			MSCBBOX(38,05,77,14,50) //comentar para Probag
		EndIf
		
	EndIf
	
	If !( nTipo $ "8/9/A/B" )
		MSCBSAY(39,07,cAdj,"N","0","60",.T.)	// Horizontal
	EndIf
	
	//Litragem
	MSCBBOX(38,14,77,22,50) //comentar para Probag
	MSCBSAY(39,16,cCapac,"N","0","55",.T.)	// Horizontal

	//If nTipo <> "4"
		MSCBSAY(23,23,"COD.: " + cCodProd ,"N","0","28")	// Horizontal
		MSCBSAY(23,27,SubStr(cProd,1,29),"N","0","28")	// Horizontal
		MSCBSAY(23,30,SubStr(cProd,30,65),"N","0","28")	// Horizontal
		//MSCBSAY(07,31,"OP: " + cOP + "  MAQ.: " + _cMaq + " LADO: " + cLado + " TURNO: " + cTurno + "  LOTE: "+cCPD+"-"+ SubStr(DtoC(dDatabase),4,7),"N","0","20")	// Horizontal
		MSCBSAY(23,34,"OP: " + SUBSTR(cOP,1,6) + "  MAQ.: " + _cMaq + " LADO: " + cLado + " TURNO: " + cTurno ,"N","0","20")	// Horizontal
		MSCBSAY(23,37,"LOTE: " + alltrim(_cLote),"N","0","20")	// Horizontal
	//EndIf
	MSCBSAY(23,40,"- Manter fora do alcance de criancas","N","0","20")	// Horizontal
	MSCBSAY(23,43,"- Nao adequado para objetos perfurantes","N","0","20")	// Horizontal
	
	If nTipo == "8"
		MSCBSAY(23,46,"PRODUZIDO POR:","N","0","20")	// Horizontal
		MSCBSAY(23,49,"CNPJ:41.150.160/0001-02","N","0","20")	// Horizontal
	Else
		If !( nTipo $ "C" )
			MSCBSAY(23,46,"Resp.Tecn.: VALERIA PEREGRINO DE BRITO","N","0","20")	// Horizontal
			MSCBSAY(23,49,"CRQ:01.201.360","N","0","20")	// Horizontal
		EndIf
    EndIf
		MSCBSAY(23,52,if(lReg,"REG. M.S.: "+cReg+" - ","")+"Validade: Indeterminada","N","0","20")	// Horizontal
		MSCBSAY(23,55,"Fab.: "+SubStr(DtoC(dDatabase),4,7),"N","0","20")	// Horizontal
	MSCBSAY(23,58,"CONTEM","N","0","20")	// Horizontal
	
	Do Case
		Case nOPC == '1' //Fardinho
			MSCBSAY(33,58,STRZero(nQFardinho,4) + " UN" ,"N","0","20")	// Horizontal 
		Case nOPC == '2' //Fardo
			//MSCBSAY(07,39,STRZero(nQFardinho,4) + " X " + STRZero(nQFardo,4) + " FD","N","0","20")	// Horizontal
			MSCBSAY(33,58,STRZero(nQFardo,5) + " UN","N","0","20")	// Horizontal
	EndCase
	
	MSCBSAYBAR(10,18,ALLTRIM(cCodBar),"R","C",10,.F.,.T.,.F.,,2,1,.F.) 
//String com o tipo de Rotação (N,R,I,B): N - Normal R - Cima para baixo I - Invertido B - Baixo para cima
	
	MSCBEND() 	
Next

MSCBCLOSEPRINTER() 

Return

***************
Static Function fQtdImp()
***************

private _cOP 	:= Space(11)

SetPrvt( "oDlg99,oSay1,oOP,oPesoMan,oCBox1,oCBox2,oSBtn1,oCBox3" )

//_nQuant	:= 0001
_cMaq	:= Space(3)

/*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis                                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

oDlg99     	:= MSDialog():New( 159,355,400,559,"Ordem de Produção",,,,,,,,,.T.,,, )
oSay1      	:= TSay():New( 004,004,{||"OP:"},oDlg99,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,037,008)
oOP   		:= TGet():New( 014,004,{|u| If(PCount()>0,_cOP:=u,_cOP)},oDlg99,060,010,/*Mascara*/,,CLR_BLACK,CLR_WHITE,,,,.T.,,,,.F.,.F.,,.F.,.F.,"SC2","_cOP",,)
oSay1      	:= TSay():New( 026,004,{||"Quantidade:"},oDlg99,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,037,008)
oPesoMan   	:= TGet():New( 036,004,{|u| If(PCount()>0,_nQuant:=u,_nQuant)},oDlg99,060,010,"@E 999",,CLR_BLACK,CLR_WHITE,,,,.T.,,,,.F.,.F.,,.F.,.F.,"","_nQuant",,)
oSay1      	:= TSay():New( 048,004,{||"Máquina:"},oDlg99,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,037,008)
oMaq   		:= TGet():New( 058,004,{|u| If(PCount()>0,_cMaq:=u,_cMaq)},oDlg99,060,010,"@!",,CLR_BLACK,CLR_WHITE,,,,.T.,,,,.F.,.F.,,.F.,.F.,"","_cMaq",,)
oSay1      	:= TSay():New( 070,004,{||"Lado:"},oDlg99,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,037,008)
oCBox1     	:= TComboBox():New( 080,004,{|u| If(PCount()>0,cLado:=u,cLado)},{ "A", "B" },040,010,oDlg99,,,,;
  														CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, ) 
oSay1      	:= TSay():New( 092,004,{||"Tipo:"},oDlg99,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,037,008)
oCBox2     	:= TComboBox():New( 102,004,{|u| If(PCount()>0,nOPC:=u,nOPC)},{ "1=Fardinho", "2=Fardo" },040,010,oDlg99,,,,;
  														CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, ) 

aOpcoes	:= { "1=Rava","2=Probag","3=Ello","4=SOS","5=Triunfo","6=Lanlimp","7=Atacalimp","8=Encontro","9=Baratao","A=Disk","B=BUNZL","C=GRAMPEL" }

oSay1      	:= TSay():New( 092,054,{||"Modelo:"},oDlg99,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,037,008)
oCBox3     	:= TComboBox():New( 102,054,{|u| If(PCount()>0,nTipo:=u,nTipo)},aOpcoes,040,010,oDlg99,,,,;
  														CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, ) 
oSBtn1     	:= SButton():New( 058,078,1,{||oDlg99:End()},oDlg99,,, )

oDlg99:lCentered := .T.
oDlg99:Activate()

Return _cOP


***************

Static Function fLote(_cOPLo)

***************

local cQry:=''
local cRet:=''

cQry:="SELECT distinct ZZC_LOTE FROM "+RetSqlName("ZZC")+" ZZC "
cQry+="WHERE ZZC_OP='"+_cOPLo+"' "
cQry+="AND ZZC.D_E_L_E_T_='' "

If Select("LOTX") > 0
	DbSelectArea("LOTX")
	LOTX->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS 'LOTX'    

IF LOTX->(!EOF())

   cRet:= LOTX->ZZC_LOTE 

ENDIF

LOTX->(DbCloseArea())

Return cRet



//Mesma rotina de impressao só para a NOVA filial 06
 
User Function ESTR01906()

Local _cPorta	  := 'LPT1'//'COM1:9600,8,N,1' //'LPT1'
Local nQuant	  := 1
Local cOP		  := ""
local _cLote      := ""
Local cCodBar	  := ""
Local cProd		  := ""
Local cCodProd	  := ""
Local cAdj		  := ""
Local cCapac	  := ""
Local nQFardinho := 0
Local nQFardo	  := 0
Local lReg       := .F.
Local cSLin      := ""
Local cReg       := "ISENTO"

Private _nQuant  := 0
Private _cMaq	  := ""
Private nOPC
Private nTipo
Private cTurno
Private cLado	  := " "
PRIVATE cTURNO1  := SubStr(GetMv( "MV_TURNO1" ),1,5) 
PRIVATE cTURNO2  := SubStr(GetMv( "MV_TURNO2" ),1,5)
PRIVATE cTURNO3  := SubStr(GetMv( "MV_TURNO3" ),1,5)

Do Case
	case Time() > cTURNO1 .and. Time() < cTURNO2
		cTurno	:= "1"
	case Time() > cTURNO2 .and. Time() < cTURNO3
		cTurno	:= "2"
	OtherWise	
		cTurno	:= "3"
EndCase

cOP		:= fQtdImp06()

dbSelectArea("SC2")
dbSetOrder(1)

If _nQuant	> 200
	MsgAlert("Quantidade máxima permitida é 200!")
	Return
EndIf

If !SC2->(dbSeek(xFilial('SC2') + cOP))
	MsgAlert("OP não encontrada!")
	Return
Else	
	cCodProd	:= SC2->C2_PRODUTO
    
    /* funcao que retorna o lote em que a OP pertence  
	_cLote      :=   fLote(SC2->C2_NUM)

    if empty(_cLote)
       MsgAlert("OP sem Lote. Favor Contactar o PCP!!!")
	   Return    
    endif
    */
    
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1") + cCodProd)
	
	If SB1->B1_TIPO <> 'PA'
		MsgAlert("Este produto não é um PA!")
		Return
	EndIf
	
	Do Case
		Case nOPC == '1' //Fardinho
			cCodBar		:= SB1->B1_CODPACO
		Case nOPC == '2' //Fardo
			cCodBar		:= SB1->B1_CODFARD
		//Case nOPC = 3 //Capa
	EndCase
	
     cProd:= StrTran( UPPER(Alltrim(SB1->B1_DESC)) , "CM" , "cm" )// A PALAVRA "CM" TEM QUE SAIR EM MINUSCULO , NORMA DO IMETRO
	
	//cProd		:= Alltrim(SB1->B1_DESC)
	
	if SB1->B1_SETOR $ "08,09,10,11,12,13,14,30,34,35,36,41,55"
	   cSLin := "INF"
	   //Somente a Linha 1 tera a informação do numero do reg na etiqueta
	   if Alltrim(B1_COD) $ SUPERGETMV("RV_COL1H",,"CDB155,CGB156,CIB157,CKB158,CDB154,CGB155,CIB156,CKB157")  
	      cReg := "80056810004"
	   endif   
	elseif SB1->B1_SETOR $ "05,37,40,56"
	   cSLin := "HAM"
	elseif SB1->B1_SETOR $ "06,54,98"
	   cSLin := "OBI"
	else
	   cSLin := ""   
	endif	
	lReg := !Empty(cSLin)	
EndIf
                                            
dbSelectArea("SB5")
dbSetOrder(1)
dbSeek(xFilial("SB5") + cCodProd)

nQFardinho	:= SB5->B5_QTDEMB
nQFardo		:= SB5->B5_QTDFIM // SB5->B5_QE1
cCPD        := Alltrim(SB5->B5_CAPACID) //Letra que identifica a Capacidade

dbSelectArea("SX5")
dbSetOrder(1)
If !Empty(Alltrim(SB5->B5_CAPACID))

	dbSeek(xFilial("SX5") + "Z0" + Alltrim(SB5->B5_CAPACID))
	cCapac	:= AllTrim(SX5->X5_DESCRI)

Else 

	cCapac	:= ""

EndIf

MSCBPRINTER("ZEBRA",_cPorta,NIL,,.F.,,,,,,.T.)

For i := 1 To _nQuant
	
	Conout("Antes MSCBBEGIN")
	//MSCBINFOETI("Etiqueta Termica EXPEDICAO","MODELO 1") 
	MSCBBEGIN(1,1)                             
	 
	//Conout("Antes MSCBBOX")
	//MSCBBOX(05,05,79,62,6) //Box Geral
	Do Case
		Case nTipo == "1"
			
			MSCBSAY(07,06,"NOVA","N","0","80")	// Horizontal
			MSCBSAY(08,14,"INDUSTRIAL","N","C","14")	// Horizontal

		Case nTipo == "2"
			
			MSCBSAY(07,05,"TRIUNFO","N","0","50")	// Horizontal
			//MSCBSAY(07,06,"Probag","N","0","70")	// Horizontal
			//MSCBSAY(06,14,"09.449.930/0001-00","N","C","14")	// Horizontal
		
		Case nTipo == "3"
			
			MSCBSAY(07,06,"Probag","N","0","70")	// Horizontal
			MSCBSAY(06,14,"09.449.930/0001-00","N","C","14")	// Horizontal

		Case nTipo == "4"
			
			MSCBSAY(07,05,"BRAVURA","N","0","50")	// Horizontal

		Case nTipo == "5"
			
			MSCBSAY(07,06,"ENCONTRO","N","0","80")	// Horizontal
			MSCBSAY(08,14,"DAS ÁGUAS","N","C","14")	// Horizontal
			
	EndCase
	
	Do Case
		Case "SUP." $ cProd
			cAdj	:= "SUPER REF."
		Case "REF" $ cProd
			cAdj	:= "REFORÇADO"
		Case "LEVE" $ cProd
			cAdj	:= "LEVE"
	EndCase
	
	If nOPC == '1' //Fardinho
		
		//Reforçcado/leve/super
		MSCBBOX(38,05,77,14,50) //comentar para Probag
	
	EndIf
	MSCBSAY(39,07,cAdj,"N","0","60",.T.)	// Horizontal

	//Litragem
	MSCBBOX(38,14,77,22,50) //comentar para Probag
	MSCBSAY(39,16,cCapac,"N","0","55",.T.)	// Horizontal

	If nTipo <> "0"
		MSCBSAY(23,23,"COD.: " + cCodProd ,"N","0","28")	// Horizontal
		MSCBSAY(23,27,SubStr(cProd,1,29),"N","0","28")	// Horizontal
		MSCBSAY(23,30,SubStr(cProd,30,65),"N","0","28")	// Horizontal
		//MSCBSAY(07,31,"OP: " + cOP + "  MAQ.: " + _cMaq + " LADO: " + cLado + " TURNO: " + cTurno + "  LOTE: "+cCPD+"-"+ SubStr(DtoC(dDatabase),4,7),"N","0","20")	// Horizontal
		MSCBSAY(23,34,"OP: " + SUBSTR(cOP,1,6) + "  MAQ.: " + _cMaq + " LADO: " + cLado + " TURNO: " + cTurno ,"N","0","20")	// Horizontal
		//MSCBSAY(23,37,"LOTE: " + alltrim(_cLote),"N","0","20")	// Horizontal
	EndIf
	MSCBSAY(23,40,"- Manter fora do alcance de criancas","N","0","20")	// Horizontal
	MSCBSAY(23,43,"- Nao adequado para objetos perfurantes","N","0","20")	// Horizontal
	
	If nTipo <> "4"
		MSCBSAY(23,46,"Resp.Tecn.: VALERIA PEREGRINO DE BRITO","N","0","20")	// Horizontal
		MSCBSAY(23,49,"CRQ:01.201.360","N","0","20")	// Horizontal
		MSCBSAY(23,52,if(lReg,"REG. M.S.: "+cReg+" - ","")+"Validade: Indeterminada","N","0","20")	// Horizontal
		MSCBSAY(23,55,"Fab.: "+SubStr(DtoC(dDatabase),4,7),"N","0","20")	// Horizontal
    EndIf
	MSCBSAY(23,58,"CONTEM","N","0","20")	// Horizontal
	
	Do Case
		Case nOPC == '1' //Fardinho
			MSCBSAY(33,58,STRZero(nQFardinho,4) + " UN" ,"N","0","20")	// Horizontal 
		Case nOPC == '2' //Fardo
			//MSCBSAY(07,39,STRZero(nQFardinho,4) + " X " + STRZero(nQFardo,4) + " FD","N","0","20")	// Horizontal
			MSCBSAY(33,58,STRZero(nQFardo,5) + " UN","N","0","20")	// Horizontal
	EndCase
	
	MSCBSAYBAR(10,18,ALLTRIM(cCodBar),"R","C",10,.F.,.T.,.F.,,2,1,.F.) 
//String com o tipo de Rotação (N,R,I,B): N - Normal R - Cima para baixo I - Invertido B - Baixo para cima
	
	MSCBEND() 	
Next

MSCBCLOSEPRINTER() 

Return

***************
Static Function fQtdImp06()
***************

private _cOP 	:= Space(11)

SetPrvt( "oDlg99,oSay1,oOP,oPesoMan,oCBox1,oCBox2,oSBtn1,oCBox3" )

//_nQuant	:= 0001
_cMaq	:= Space(3)

/*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis                                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

oDlg99     	:= MSDialog():New( 159,355,400,559,"Ordem de Produção",,,,,,,,,.T.,,, )
oSay1      	:= TSay():New( 004,004,{||"OP:"},oDlg99,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,037,008)
oOP   		:= TGet():New( 014,004,{|u| If(PCount()>0,_cOP:=u,_cOP)},oDlg99,060,010,/*Mascara*/,,CLR_BLACK,CLR_WHITE,,,,.T.,,,,.F.,.F.,,.F.,.F.,"SC2","_cOP",,)
oSay1      	:= TSay():New( 026,004,{||"Quantidade:"},oDlg99,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,037,008)
oPesoMan   	:= TGet():New( 036,004,{|u| If(PCount()>0,_nQuant:=u,_nQuant)},oDlg99,060,010,"@E 999",,CLR_BLACK,CLR_WHITE,,,,.T.,,,,.F.,.F.,,.F.,.F.,"","_nQuant",,)
oSay1      	:= TSay():New( 048,004,{||"Máquina:"},oDlg99,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,037,008)
oMaq   		:= TGet():New( 058,004,{|u| If(PCount()>0,_cMaq:=u,_cMaq)},oDlg99,060,010,"@!",,CLR_BLACK,CLR_WHITE,,,,.T.,,,,.F.,.F.,,.F.,.F.,"","_cMaq",,)
oSay1      	:= TSay():New( 070,004,{||"Lado:"},oDlg99,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,037,008)
oCBox1     	:= TComboBox():New( 080,004,{|u| If(PCount()>0,cLado:=u,cLado)},{ "A", "B" },040,010,oDlg99,,,,;
  														CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, ) 
oSay1      	:= TSay():New( 092,004,{||"Tipo:"},oDlg99,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,037,008)
oCBox2     	:= TComboBox():New( 102,004,{|u| If(PCount()>0,nOPC:=u,nOPC)},{ "1=Fardinho", "2=Fardo" },040,010,oDlg99,,,,;
  														CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, ) 

oSay1      	:= TSay():New( 092,054,{||"Modelo:"},oDlg99,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,037,008)
oCBox3     	:= TComboBox():New( 102,054,{|u| If(PCount()>0,nTipo:=u,nTipo)},{ "1=NOVA","2=TRIUNFO", "3=ProBag", "4=BRAVURA", "5=Encontro" },040,010,oDlg99,,,,;
  														CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, ) 
oSBtn1     	:= SButton():New( 058,078,1,{||oDlg99:End()},oDlg99,,, )

oDlg99:lCentered := .T.
oDlg99:Activate()

Return _cOP

