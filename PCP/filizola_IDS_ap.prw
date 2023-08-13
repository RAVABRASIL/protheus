#Include "RwMake.ch"
//#Include "protheus.ch"
#include "topconn.ch"
#INCLUDE 'COLORS.CH'

*************

User Function FILIZO_IDS()

*************

SetPrvt( "oDLG1," )
SetPrvt( "oFONT1,oFONT2,oFONT3," )
SetPrvt( "oGrp01,oGrp02,oGrp03," )
SetPrvt( "oMaq01,oMaq02,oMaq03," )
SetPrvt( "oOP01,oOP02,oOP03," )
SetPrvt( "oPROD01,oPROD02,oPROD03,oNumSer" )
SetPrvt( "oDESCR101,oDESCR102,oDESCR103,," )
SetPrvt( "oDESCR201,oDESCR202,oDESCR203,," )
SetPrvt( "oPROGKG01,oPROGKG02,oPROGKG03,," )
SetPrvt( "oPRODKG01,oPRODKG02,oPRODKG03," )
SetPrvt( "oTURN1KG01,oTURN1KG02,oTURN1KG03," )
SetPrvt( "oTURN2KG01,oTURN2KG02,oTURN2KG03," )
SetPrvt( "oTURN3KG01,oTURN3KG02,oTURN3KG03," )
SetPrvt( "oPRODDKG01,oPRODDKG02,oPRODDKG03," )
SetPrvt( "cTURNO1,cTURNO2,cTURNO3,cTURNO1_A,cTURNO2_A,cTURNO3_A, " )
SetPrvt( "nCONT, nTOLERA, aIMP, nPESO, cOP, oMAQ, cPORTA, nHandle, aUSUARIO, oTIPO, cTIPO, aTIPO, " )
SetPrvt( "nQTDLIB, cUSULIM, nLIMITE, cSEQ, cEMBALAD, cNumSer " )
Private LPERDINF := .F.
cEMBALAD := ""
Validperg()
If ! Pergunte( "MONMQ2", .T. )
   Return NIL                                                                
//else
//	mv_par01 := PesqOp( mv_par01 )
EndIf

cNumSer		:= Space(1)
xMV_PAR01 := MV_PAR01
xMV_PAR02 := MV_PAR02
xMV_PAR03 := MV_PAR03
xMV_PAR04 := MV_PAR04
lBalanca  :=  GetMV("MV_BALEXTR")  

nTOLERA := Getmv( "MV_PESOTOL" )
nLIMITE := GetMv( "MV_LIMAXOP" )
nPVAROP := GetMv( "MV_PVAROP" )
nLIMAAG := GetMv( "MV_LIMAXAG" )
nValendo:=SuperGetMV("RV_EXTRUSO",,.T.)

SC2->( DbSetOrder( 1 ) )
SB1->( DbSetOrder( 1 ) )
SB5->( DbSetOrder( 1 ) )
SH1->( DbSetOrder( 1 ) )
SG1->( DbSetOrder( 1 ) )
Z00->( DbSetOrder( 1 ) )
nHANDLE   := -1
//cPORTABAL := "1" 
cPORTABAL := "4"
cPORTAIMP := "3"
aIMP      := {}
aUSUARIO  := {}
nPESO     := 0
cOP       := Space( 11 )
cMAQ      := Space( 06 )
cAlmoPro:=""
lPesqM := .T.
cTURNO1   := GetMv( "MV_TURNO1" )
cTURNO2   := GetMv( "MV_TURNO2" )
cTURNO3   := GetMv( "MV_TURNO3" )
cTURNO1_A := Left( U_Somahora( Left( cTURNO1, 5 ) + ":00", "00:15:00" ), 5 ) + "," + SubStr( cTURNO1, 7, 5 )  // Soma 15 minutos p/ apara
cTURNO2_A := Left( U_Somahora( Left( cTURNO2, 5 ) + ":00", "00:15:00" ), 5 ) + "," + SubStr( cTURNO2, 7, 5 )
cTURNO3_A := Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", "00:15:00" ), 5 ) + "," + SubStr( cTURNO3, 7, 5 )

@ 000,000 TO 595,790 Dialog oDLG1 Title "Situacao atual da producao de extrusoras - Dia: " + Dtoc( If( Time() < Left( cTURNO1, 5 ) + ":00", date() - 1, date() ) )
U_MONMAQ_2()
@ 190,220 Say "OP:"
@ 189,230 Get cOP Object oOP Size 60,40 F3 "EXT" Valid PesqOp( cOP )
@ 190,305 Say "Equipamento:"
@ 189,335 Get cMAQ Object oMAQ Size 30,40 F3 "SH1" Valid PesqMaq( cMAQ )
@ 210,220 Say "Peso (Kg):"
@ 210,260 Say nPESO Object oPESO Size 40,40 Picture "@E 999.99"

@ 230,220 Say "Cod. Qualidade:"
@ 229,265 Get cNumSer Object oNumSer Size 30,40 Valid fValidaNS( cNumSer )

/*@ 240,250 Button "_Ler balanca" Size 50,15 Action Pegar()
//@ 240,310 BMPButton Type 2 Action oDlg1:End()//Close( oDLG1 )
@ 240,310 Button "encerrar" Size 50,15 Action cancOP( cOP )*/

@ 260,220 Button "_Ler balanca" Size 50,15 Action Pegar()
@ 260,275 Button "_Encerrar OP" Size 50,15 Action cancOP( cOP )
@ 285,300 Button "_Reimp. Etiqueta" Size 50,11 Action Processa({|| fReImpEt() }, "Aguarde...", "Carregando definição dos campos...",.F.)
@ 285,355 BMPButton Type 2 Action oDlg1:End()//Close( oDLG1 )
//@ 240,330 Button "_Reimprimir" Size 50,15 Action Reimprime()

Activate Dialog oDLG1 Centered On Init Atualiza()
Return NIL


***************
Static Function PesaMan()
***************

private nPesoMan := 0

SetPrvt( "oDlg99,oSay1,oPesoMan,oSBtn1," )

/*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis                                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

oDlg99     := MSDialog():New( 159,315,227,559,"Peso Manual",,,,,,,,,.T.,,, )
oSay1      := TSay():New( 004,004,{||"Informar Peso:"},oDlg99,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,037,008)
oPesoMan   := TGet():New( 014,004,{|u| If(PCount()>0,nPesoMan:=u,nPesoMan)},oDlg99,060,010,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,,,,.F.,.F.,,.F.,.F.,"","nPesoMan",,)
oSBtn1     := SButton():New( 008,080,1,{||OkPeso()},oDlg99,,, )

oDlg99:lCentered := .T.
oDlg99:Activate()

Return nPesoMan

/*ÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ OkPeso()()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function OkPeso()
   oDlg99:End()
Return



***************
Static Function Pegar()
***************
Local nVal1 := nVal2 := nTara := 0
Local cMemox
lEncerra := .T.
aIMP      := {}
nPct:=0.05 


// valida se a maquina e a mesma da extrusora da OP 
_ExtOP:=fExtruso(substr(cOP,1,6))
if alltrim(cMaq)<>alltrim(_ExtOP)

   alert('A Maquina '+alltrim(cMaq)+' Escolhida não é a mesma da OP '+alltrim(_ExtOP))
   ObjectMethod( oMAQ, "SetFocus()" )
   Return NIL

endif

if alltrim(cMaq)='E01'

   cAlmoPro:="10"

Elseif alltrim(cMaq)='E02'

   cAlmoPro:="20" 

Elseif alltrim(cMaq)='E03'

   cAlmoPro:= "30"   

Elseif alltrim(cMaq)='E04'

   cAlmoPro:="40"

Elseif alltrim(cMaq)='E05'

   cAlmoPro:="50"

endif


if empty(cAlmoPro)

   alert("Problema no Almoxarifado da Extrusora"+alltrim(cMaq) )
	ObjectMethod( oMAQ, "SetFocus()" )
	Return NIL

endif

//


dbSelectArea('SC2')/*Inserido em 06/07/15**/
if !Empty( SC2->C2_BLOQUEA )
	cMemox := iif(!empty(SC2->C2_OBSBLOQ), MSMM(SC2->C2_OBSBLOQ),"SEM EXPLICAÇÃO SOBRE O BLOQUEIO")
	Aviso("OP Bloqueada",cMemox,{"OK"} )//MsgAlert( "Esta OP está bloqueada pelo setor de qualidade! ! !" )
	ObjectMethod( oMAQ, "SetFocus()" )
	Return NIL
EndIf


if ! alltrim( cMAQ ) $ 'I01/I02/I03/I04/I05/I06/I07/I08/I09'  .AND. SUBSTR(SC2->C2_PRODUTO,1,3)='PII' 
	MsgAlert( " Esse Produto( "+alltrim(SC2->C2_PRODUTO)+" ) Nao pode ser Pesado Nessa Maquina "+alltrim(cMaq) )
	ObjectMethod( oMAQ, "SetFocus()" )
	Return NIL
ENDIF

if  alltrim( cMAQ ) $ 'I01/I02/I03/I04/I05/I06/I07/I08/I09'  .AND. ! SUBSTR(SC2->C2_PRODUTO,1,3)='PII' 
	MsgAlert( " Esse Produto( "+alltrim(SC2->C2_PRODUTO)+" ) Nao pode ser Pesado Nessa Maquina "+alltrim(cMaq) )
	ObjectMethod( oMAQ, "SetFocus()" )
	Return NIL
ENDIF

if Empty( cMAQ )
	MsgAlert( "Maquina nao informada" )
	ObjectMethod( oMAQ, "SetFocus()" )
	Return NIL
EndIf

aUSUARIO := u_senha2( "04", 1, "Operador da maquina" )

If ! aUSUARIO[ 1 ]
	Return NIL
EndIf

cEMBALAD := aUSUARIO[ 2 ]


if lBalanca
	/**/
	If  alltrim(cMAQ)!='A01'  // Diferente de Aglutinador 
		nTara := taraTub()
		Do Case
			Case nTara == 2
				nTara	:= 2.05
			Case nTara == 3
				nTara	:= 2.70
			Case nTara == 4
				nTara	:= 2.55
			Case nTara == 5
				nTara	:= 3.30
			Case nTara == 6
				nTara	:= 4.45
			Case nTara == 7
				nTara	:= 4.40
			Case nTara == 8
				nTara	:= 5.40
			Case nTara == 9
				nTara	:= 5.50
			Case nTara == 10
				nTara	:= 6.40
			Case nTara == 11
				nTara	:= 7.90
			Case nTara == 12
				nTara	:= 10.50	
			Case nTara == 13
				nTara	:= 12	
			otherwise
		   msgAlert("Escolha a tara do tubete! ! !")
		   return Pegar()
	    endCase	
	EndIf
	/**/
   cDLL     := "toledo9091.dll"
   nHandle  := ExecInDllOpen( cDLL )
   if nHandle = -1
   	   MsgAlert( "Nao foi possível encontrar a DLL " + cDLL )
       Return NIL
   EndIf
   // Parametro 1 = Porta serial do indicador
   cRETDLL := ExecInDLLRun( nHandle, 1, cPORTABAL )
   //cRETDLL := '60'
   nPESO := Val( Strtran( cRETDLL, ",", "." ) ) - nTara
   ExecInDLLClose( nHandle )
else
   nPeso := PesaMan()
endif

ObjectMethod( oPESO, "SetText( Trans( nPESO, '@E 999.99' ) )" )
If nPESO <= 0 .or. Empty( cOP )
	MsgAlert( "Campo(s) sem informacao ou com valor(es) incorreto(s)" )
	Return NIL
EndIf

_codPi:=SC2->C2_PRODUTO

IF nValendo

	if ! PI_SALDO(cOP,SC2->C2_PRODUTO,SC2->C2_QUANT)
		Return NIL
	endif

ENDIF




//------------teste impressao
/*cSEQ := ProxSeq()
Aadd( aIMP, { "B" + "Rava Embalagens", "B" + iif(SC2->C2_OPLIC == 'S',"Amostra: ","Produto: ") +;
AllTrim( SB1->B1_COD ), "A" + AllTrim( Left( SB1->B1_DESC, 39 ) ), Left( cOP, 6 )  } )

For _x	:= 1 to 2 //imprime 2 vias, uma para o produto e outra para o documento
	If Abre_Impress()
		Inc_Linha( aIMP[ 1, 2 ], .T. )
		//Inc_Linha( aIMP[ 1, 4 ], .F. )
		Inc_Linha( aIMP[ 1, 4 ], .F. )
		Fecha_Impress()
	else
		msgAlert("Problema de comunicação com a impressora!")
		lLoop := .F.
	EndIf		
Next
      
aIMP      := {}
*///------------teste impressao

cUSULIM := ""

cQuery := "SELECT Sum( Z00_PESO ) AS PESO "
cQuery += "FROM " + RetSqlName( "Z00" ) + " Z00 "
cQuery += "WHERE Z00.Z00_OP = '" + cOP + "' AND Z00.Z00_BAIXA = 'N' AND "
cQuery += "Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "Z00X"

If ( ( SC2->C2_QUANT - SC2->C2_QUJE ) + ( nLIMITE * SC2->C2_QUANT / 100 ) ) < Z00X->PESO + nPESO
   If ! MsgBox( OemToAnsi( "Producao desta OP ja atingiu o previsto (" + AllTrim( Str( SC2->C2_QUANT ) ) + " - " + ;
    AllTrim( Str( SC2->C2_QUJE + Z00X->PESO + nPESO ) ) + "). Confirma?" ), "Escolha", "YESNO" )
      Z00X->( DbCloseArea() )
      Return NIL
   EndIf
   
   aUSUARIO := u_senha2( "03",, "Liberar quantidade da OP" )
   If ! aUSUARIO[ 1 ]
      Z00X->( DbCloseArea() )
      Return NIL
   EndIf
   
   /**/
   lEncerra := .T.
	 nVal1 := (SC2->C2_QUANT - SC2->C2_QUJE)  + ( nLIMITE * SC2->C2_QUANT / 100 )
	 nVal2 := Z00X->PESO + nPESO
   /**/
   cUSULIM  := aUSUARIO[ 2 ]
   aUSUARIO := {}
EndIf
Z00X->( DbCloseArea() )

//If  alltrim(cMAQ)!='A01'  // Diferente de Aglutinador 
    
IF alltrim(cMAQ)!='A01' 
    dbselectarea('Z67')
    If !CheckExt()  // verificacao dos itens para extrusora
       Return 
    endif
ENDIF    
	
	If fNewProd() //Producao()
	   Grava()
	   Atualiza()
	   if lBalanca
	      Msgbox( "Bobina inserida com sucesso!  Tecle <SAIDA> na balanca para imprimir etiqueta.", "Mensagem", "info" )
	   endif
	   /**/
	   //if lEncerra
		 if nVal1 < nVal2
	   	/*if MsgBox( OemToAnsi( "A Producao da OP "+alltrim(SC2->C2_NUM)+" ja atingiu o previsto. Deseja encerrá-la ?" ),"Escolha", "YESNO" )
				   		endOP( alltrim(SC2->C2_NUM ) )
			endIf*/
	   	lEncerra := .F.
	   endIf
	   /**/
	Else
	   MsgAlert( "Erro na inclusao desta bobina no estoque (" + AllTrim( SC2->C2_PRODUTO ) + ")" )
	EndIf

/*
Else

	Do while .T.
		If nPESO <  nLIMAAG * (1-nPct )
		   Alert("O produto pesado esta MUITO ABAIXO do peso limite.  So podera ser liberado pelo Gerente de Producao.")
		   aUSUARI2 := u_senha2( "06", 1, "Margem de peso menor que o limite" )
		   If ! aUSUARI2[ 1 ]
		     EXIT
		   Endif
		EndIf
		
		If nPESO > nLIMAAG * (1+nPct )
		   Alert("O produto pesado esta MUITO ACIMA do peso limite.  So podera ser liberado pelo Gerente de Producao.")
		   aUSUARI2 := u_senha2( "06", 1, "Margem de peso menor que o limite" )
		   If ! aUSUARI2[ 1 ]
		      EXIT
		   Endif
		EndIf
		// grava na Tabela de Pesagem 		
		If Abre_Impress()
			cSEQ := ProxSeq()
			RecLock( "Z00", .T. )
			Z00->Z00_SEQ    := cSEQ
			Z00->Z00_OP     := cOP
			Z00->Z00_PESO   := nPESO
			Z00->Z00_QUANT  := nPESO
			Z00->Z00_MAQ    := cMAQ
			Z00->Z00_DATA   := Date()
			Z00->Z00_HORA   := Left( Time(), 5 )
			Z00->Z00_USULIM := cUSULIM
			Z00->Z00_BAIXA  := "N"                                                                                                  
			Z00->Z00_NOME   := cEMBALAD //Voltou a ser gravado em 19/11/07 a pedido de lindenberg, não se sabe pq não gravava mais (desde mês 08 de 2006)
			Z00->Z00_CODBAR := substr(cOP,1,6) + cSEQ 
            Z00->Z00_CODIGO := SB1->B1_COD
			Z00->( MsUnlock() )
			ConfirmSX8()
			Z00->( DbCommit() )
			If SC2->C2_RECURSO <> cMAQ
			  RecLock( "SC2", .F. )
			  SC2->C2_RECURSO := cMAQ
			  SC2->( MsUnlock() )
			  SC2->( DbCommit() )
			EndIf
			//				
			Aadd( aIMP, { "B" + "Rava Embalagens", "B" + iif(SC2->C2_OPLIC == 'S',"Amostra: ","Produto: ") +;
			AllTrim( SB1->B1_COD ), "A" + AllTrim( Left( SB1->B1_DESC, 39 ) ), Left( cOP, 6 ) + cSEQ } )
		
		   Inc_Linha( aIMP[ 1, 2 ], .T. )
		   Inc_Linha( aIMP[ 1, 4 ], .F. )
		   Fecha_Impress()
           
           Atualiza()
		   alert("Etiqueta impressa com Sucesso" )
		else
		   alert("Problema na Impressao da Etiqueta, sua Pesagem foi Desconsiderada" )
		endif
	    exit
	ENDDO
Endif
*/

nPESO := 0
cOP   := Space( 11 )
cMAQ  := Space( 06 )
ObjectMethod( oPESO, "SetText( Trans( nPESO, '@E 999.99' ) )" )
ObjectMethod( oOP, "SetFocus()" )

Return NIL



***************

Static Function Grava()

***************

cSEQ := ProxSeq()
RecLock( "Z00", .T. )
Z00->Z00_SEQ    := cSEQ
Z00->Z00_OP     := cOP
Z00->Z00_PESO   := nPESO
Z00->Z00_MAQ    := cMAQ
Z00->Z00_DATA   :=  Date()
Z00->Z00_HORA   :=  Left( Time(), 5 )
Z00->Z00_USULIM := cUSULIM
Z00->Z00_BAIXA  := "S"                                                                                                  
Z00->Z00_NOME   := cEMBALAD //Voltou a ser gravado em 19/11/07 a pedido de lindenberg, não se sabe pq não gravava mais (desde mês 08 de 2006)
nORD := SD3->( Indexord() )
SD3->( DbSetOrder( 4 ) )
SD3->( DbGobottom() )
SD3->( DbSetOrder( nORD ) )
Z00->Z00_DOC := SD3->D3_DOC
Z00->( MsUnlock() )
ConfirmSX8()
Z00->( DbCommit() )
If SC2->C2_RECURSO <> cMAQ
  RecLock( "SC2", .F. )
  SC2->C2_RECURSO := cMAQ
  SC2->( MsUnlock() )
  SC2->( DbCommit() )
EndIf

aArea	:= getArea()
//-------------------------------------------
//Cria o Saldo da Bobina
//-------------------------------------------

_descPi:=Posicione( "SB1", 1, xFilial("SB1") + _codPI , "B1_DESC" )

dbSelectArea("ZB9")

RecLock("ZB9",.T.)
		
ZB9->ZB9_FILIAL		:= xFilial("ZB9")
ZB9->ZB9_COD		:= _codPi//SB1->B1_COD 
ZB9->ZB9_DESC		:= _descPi //SB1->B1_DESC
ZB9->ZB9_QINI		:= nPESO
ZB9->ZB9_SALDO		:= nPESO
ZB9->ZB9_SEQ		:= cSEQ

ZB9->(MsUnLock())

RestArea(aArea)

//AllTrim( SB1->B1_COD ), "A" + AllTrim( Left( SB1->B1_DESC, 39 ) ), Left( cOP, 6 ) + cSEQ  } )
Aadd( aIMP, { "B" + "Rava Embalagens",iif(SC2->C2_OPLIC == 'S',"Amostra: ","Produto: ") +;
AllTrim( _codPi ), "A" + AllTrim( Left( _descPi, 39 ) ), Left( cOP, 6 ) + cSEQ  } )

  
For _x	:= 1 to 3 //imprime 3 vias, uma para produto, uma para apara e outra para o documento
	If Abre_Impress()
		Inc_Linha( DtoC(dDataBase) + " - " + aIMP[ 1, 2 ], .T. ) // Data + Produto
		Inc_Linha( alltrim(cMAQ)+' - '+ UPPER(AllTrim(cEMBALAD)) + " - Peso: " + Transform(nPESO, "@E 999.99"), .T. ) // Nome e peso
		Inc_Linha( aIMP[ 1, 4 ], .F. ) //cod barras
		Fecha_Impress()
	else
		msgAlert("Problema de comunicação com a impressora!")
		lLoop := .F.
	EndIf		
Next


Return NIL



***************

Static Function Producao()

***************

Local aMATRIZ := {}

lMsErroAuto := .F.

aMATRIZ := { { "D3_OP",      cOP,  NIL },;
				     { "D3_COD",     SC2->C2_PRODUTO,    NIL },;
				     { "D3_EMISSAO", Date(),          NIL },;
				     { "D3_QUANT",   nPESO, NIL },;
				     { "D3_USULIM", cUSULIM,                NIL },;
				     { "D3_PARCTOT", "P",                NIL } }

Begin Transaction
	MSExecAuto( { | x | MATA250( x ) }, aMATRIZ )
	IF lMsErroAuto
		DisarmTransaction()
		Break
	Endif
End Transaction
Return ! lMSErroAuto


***************

Static Function fNewProd()

***************

Local aMATRIZ := {}
LOCAL lOk:=.T.

lMsErroAuto := .F.
//MsgAlert("OP "+cOP)
aMATRIZ := {{ "D3_OP"		,cOP		,  NIL },;
		     { "D3_TM"		,"101"		,  NIL },;
		     { "D3_EMISSAO"	,Date()	,  NIL },;
		     { "D3_QUANT"		,nPESO		,  NIL },;
		     { "D3_USULIM"	,cUSULIM	,  NIL }}

Begin Transaction

	MSExecAuto({|x, y| mata250(x, y)},aMATRIZ, 3 )
	//MSExecAuto( { | x | MATA250( x ) }, aMATRIZ )
	IF lMsErroAuto
       lOk:=.F.
		Mostraerro()
		DisarmTransaction()
		Break

	Endif


	If lOk  

	    If nValendo

	       lMsErroAuto := .F.
		   PI_CONSOME(cOP,SC2->C2_PRODUTO,SC2->C2_QUANT)

	    Endif

	Endif
	


End Transaction



Return ! lMSErroAuto


***************

Static Function PesqOp(cOP)

***************

Local lRET := .T.

If Len( AllTrim( cOP ) ) < 6
	MsgAlert( OemToAnsi( "Numero de OP invalido" ) )
	Return .F. //''
Endif
If Len( AllTrim( cOP ) ) < 11
   SC2->( DbSeek( xFilial( "SC2" ) + Left( cOP, 6 ), .T. ) )
   Do While SC2->C2_NUM == Left( cOP, 6 )
      If Left( SC2->C2_PRODUTO, 2 ) == 'PI' .and. SC2->C2_SEQPAI $ '   *001'
         cOP := SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN
         Exit
      EndIf
      SC2->( DbSkip() )
   EndDo
   If SC2->C2_NUM <> Left( cOP, 6 )
      MsgAlert( OemToAnsi( "Numero de OP invalido" ) )
      Return .F.//''
   Endif
Endif
SC2->( DbSeek( xFilial( "SC2" ) + cOP, .T. ) )
If SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN <> cOP
	MsgAlert( OemToAnsi( "OP nao cadastrada" ) )
    Return .F.//''
Else
	If SB1->( Dbseek( xFilial( "SB1" ) + SC2->C2_PRODUTO ) )
		If ! SB1->B1_TIPO $ "PI"
			MsgAlert( OemToAnsi( "Esta OP nao‚ de bobina" ) )
      		Return .F.//''
		EndIf
	Else
		MsgAlert( OemToAnsi( "Produto desta OP nao cadastrado" ) )
      	Return .F.//''
	EndIf
	If lRET .and. ! Empty( SC2->C2_DATRF )
		MsgAlert( OemToAnsi( "Esta OP ja foi encerrada" ) )
      	Return .F.//''
	EndIf        
EndIf

/*
If lRET
	If ! Empty( SC2->C2_RECURSO )
		cMAQ := SC2->C2_RECURSO
	EndIf
EndIf
*/

If lRET

    cMAQ := fExtruso(substr(cOP,1,6))

EndIf

Return cOP

***************

Static Function PesqMaq()

***************

lRET := .T.

If ! SH1->( DbSeek( xFilial( "SH1" ) + cMAQ ) )
	MsgAlert( OemToAnsi( "Maquina nao cadastrada" ) )
	lRET := .F.
EndIf

If lRET
	If ! Empty( SC2->C2_RECURSO ) .and. cMAQ <> SC2->C2_RECURSO
     lRET := u_senha2( "02",, "Alteracao de Maquina" )[ 1 ]
	EndIf
EndIf



Return lRET



***************

Static Function ATUALIZA()

***************

dDIA := If( Time() < Left( cTURNO1, 5 ) + ":00", date() - 1, date() )
oDlg1:cCaption := "Situacao atual da producao de extrusoras - Dia: " + Dtoc( dDIA )
If xMV_PAR01 == 1
 	If ! Empty( xMV_PAR02 )
 		 Mostra( xMV_PAR02, "01" )
 	Endif
 	If ! Empty( xMV_PAR03 )
 		 Mostra( xMV_PAR03, "02" )
 	Endif
 	If ! Empty( xMV_PAR04 )
 		 Mostra( xMV_PAR04, "03" )
 	Endif
EndIf
Return NIL



***************

Static Function Mostra( cMAQ, cNUM )

***************

SB1->( DbSetOrder( 1 ) )
SC2->( DbSetOrder( 1 ) )
cQUERY := "SELECT Z00.Z00_OP,Z00.Z00_PESO,Z00_APARA,Z00.Z00_HORA,Z00.Z00_QUANT,Z00.Z00_DATA,Z00.Z00_PESCAP,Z00.Z00_PESDIF "
cQUERY += "FROM " + RetSqlName( "Z00" ) + " Z00 "
cQUERY += "WHERE Z00.Z00_DATA BETWEEN '" + Dtos( dDIA ) + "' AND '" + Dtos( date() ) + "' AND "
cQUERY += "Z00.Z00_MAQ = '" + cMAQ + "' AND Z00.Z00_APARA = ' ' AND "
cQUERY += "Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
cQUERY += "ORDER BY Z00.Z00_DATA,Z00.Z00_HORA "
cQUERY := ChangeQuery( cQUERY )
TCQUERY cQUERY NEW ALIAS "Z00X"
TCSetField( 'Z00X', "Z00_DATA", "D" )
Z00X->( DbGotop() )
nTURNO1KG := nTURNO2KG := nTURNO3KG := 0
nTURNO1   := nTURNO2   := nTURNO3   := 0
nPRODDKG  := 0
cOP       := Space( 11 )
Do While ! Z00X->( Eof() )
   SC2->( DbSeek( xFilial( "SC2" ) + Z00X->Z00_OP, .T. ) )
   SB5->( Dbseek( xFilial( "SB5" ) + SC2->C2_PRODUTO ) )
	 If Z00X->Z00_DATA == dDIA .and. Z00X->Z00_HORA >= Left( cTURNO1, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO1, 5 ) + ":00", SubStr( cTURNO1, 7, 5 ) + ":00" ), 5 )
		 nTURNO1KG += Z00X->Z00_PESO
		 nPRODDKG  += Z00X->Z00_PESO
	 ElseIf Z00X->Z00_DATA == dDIA .and. Z00X->Z00_HORA >= Left( cTURNO2, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO2, 5 ) + ":00", SubStr( cTURNO2, 7, 5 ) + ":00" ), 5 )
		 nTURNO2KG += Z00X->Z00_PESO
		 nPRODDKG  += Z00X->Z00_PESO
	 ElseIf ( Z00X->Z00_DATA == dDIA .and. Z00X->Z00_HORA >= Left( cTURNO3, 5 ) ) .or. ;
		 ( Z00X->Z00_DATA == dDIA + 1 .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( cTURNO3, 7, 5 ) + ":00" ), 5 ) )
		nTURNO3KG += Z00X->Z00_PESO
		nPRODDKG  += Z00X->Z00_PESO
	 EndIf
	 cOP := Z00X->Z00_OP
	 Z00X->( DbSkip() )
EndDo
Z00X->( DbCloseArea() )
If ! Empty( cOP )
	cQuery := "SELECT Sum( Z00_QUANT ) AS QUANT,Sum( Z00_PESO + Z00_PESCAP ) AS PESO "
	cQuery += "FROM " + RetSqlName( "Z00" ) + " Z00 "
	cQuery += "WHERE Z00.Z00_OP = '" + cOP + "' AND "
	cQuery += "Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
	cQuery := ChangeQuery( cQuery )
	TCQUERY cQuery NEW ALIAS "Z00X"
	SC2->( DbSeek( xFilial( "SC2" ) + cOP, .T. ) )
	SB1->( Dbseek( xFilial( "SB1" ) + SC2->C2_PRODUTO ) )
	SB5->( Dbseek( xFilial( "SB5" ) + SC2->C2_PRODUTO ) )
	oOP&cNUM:cCaption      := Left( cOP, 6 )
	oPROGKG&cNUM:cCaption  := Trans( SC2->C2_QUANT / ( 1 + ( nPVarOp / 100 ) ), "@E 999999.99" )
	oPRODKG&cNUM:cCaption  := Trans( Z00X->PESO, "@E 999999.99" )
	oPROD&cNUM:cCaption    := SC2->C2_PRODUTO
	oDESCR1&cNUM:cCaption  := Left( SB1->B1_DESC, 29 )
	oDESCR2&cNUM:cCaption  := SubStr( SB1->B1_DESC, 30, 20 )
	Z00X->( DbCloseArea() )
EndIf
oMAQ&cNUM:cCaption     := cMAQ
oTURN1KG&cNUM:cCaption := Trans( nTURNO1KG, "@E 999999.99" )
oTURN2KG&cNUM:cCaption := Trans( nTURNO2KG, "@E 999999.99" )
oTURN3KG&cNUM:cCaption := Trans( nTURNO3KG, "@E 999999.99" )
oPRODDKG&cNUM:cCaption := Trans( nPRODDKG, "@E 999999.99" )

Return NIL



***************

Static Function PROXSEQ()

***************

cSEQ := GetSx8Num( "Z00", "Z00_SEQ" )
Do While Z00->( DbSeek( xFilial( "Z00" ) + cSEQ ) )
   ConfirmSX8()
   cSEQ := GetSx8Num( "Z00", "Z00_SEQ" )
EndDo
Return cSEQ



***************

Static Function ValidPerg()

***************

PutSx1( "MONMQ2", '01', 'Setor              ?', '', '', 'mv_ch1', 'N', 01, 0, 0, 'G', '', ''   , '', '', 'mv_par01', ''               , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
PutSx1( "MONMQ2", '02', 'Maquina 1 Setor 1  ?', '', '', 'mv_ch2', 'C', 06, 0, 0, 'G', '', 'SH1', '', '', 'mv_par02', ''               , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
PutSx1( "MONMQ2", '03', 'Maquina 2 Setor 1  ?', '', '', 'mv_ch3', 'C', 06, 0, 0, 'G', '', 'SH1', '', '', 'mv_par03', ''               , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
PutSx1( "MONMQ2", '04', 'Maquina 3 Setor 1  ?', '', '', 'mv_ch4', 'C', 06, 0, 0, 'G', '', 'SH1', '', '', 'mv_par04', ''               , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
Return NIL

***************

Static Function endOP( cOPx )

***************
/*
Obs.: O SD3 já chega posicionado no registro que deve ser alterado.
*/

Local lMsErroAuto := .F.
Local aMata250 := {}
Local nRec := SD3->( recno() )
Local nIdx := SD3->( indexOrd() )
//dbSelectArea('SD3')
SD3->( dbSetOrder(1) )

if ! SD3->( dbSeek( xFilial('SD3') + padr(alltrim(cOPx),13) + SC2->C2_PRODUTO, .T. ) )
	msgbox( "Impossível encontrar a OP "+ alltrim(cOPx) +"!" )
	msgbox( "ENCERRAMENTO ABORTADO ! ! !" )
	SD3->( dbGoTo( nRec ) )
	SD3->( dbSetOrder( nIdx ) )
	Return
endIf
msgBox("A OP "+cOPx+" foi encerrada com sucesso!")
Private l250Auto := .T.
Private lIntQual := .F.
Private mv_par03 := 2
Private dDataFec := getMV('MV_ULMES')
Private LDELOPSC := getMV('MV_DELOPSC') == 'S'
Private LPRODAUT := getMV('MV_PRODAUT')

A250Encer('SD3', SD3->( recno() ), 5 )

SD3->( dbGoTo( nRec ) )
SD3->( dbSetOrder( nIdx ) )

Return

***************

Static Function  cancOP( cOP )

***************

dbSelectArea('SB1')
SB1->( dbSeek( xFilial('SB1') + SC2->C2_PRODUTO ), .T. )

if MsgBox( OemToAnsi( "Deseja encerrar a OP :"+alltrim(cOP)+" ("+alltrim(SB1->B1_DESC)+") " ),"Escolha", "YESNO" )
	endOP( cOP )
endIf

SB1->( dbCloseArea() )
cOP   := Space( 11 )
cMAQ  := Space( 06 )
ObjectMethod( oOP,  "refresh()" )
ObjectMethod( oMAQ, "refresh()" )
ObjectMethod( oOP, "SetFocus()" )
Atualiza()

Return

***************

Static Function taraTub()

***************

local oDlg1,oCBox1,oGrp1,oSBtn1,oSBtn2
local nAt := 0
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 139,330,352,682,"Tara dos tubetes",,,,,,,,,.T.,,, )
oCBox1     := TComboBox():New( 028,049,,{"","40 - 2,05  kg","40 - 2,70  kg","50 - 2,55  kg","65 - 3,30  kg","65 - 4,45  kg","80 - 4,40  kg","80 - 5,40  kg","100- 5,50  kg","126- 6,40  kg","156- 7,90  kg","156- 10,50 kg","178- 12 kg"},072,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
oGrp1      := TGroup():New( 004,004,092,168,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSBtn1     := SButton():New( 064,040,1,{ || nAt := oCBox1:nAt, oDlg1:End() },oGrp1,,"", )
oSBtn2     := SButton():New( 064,108,2,{ || nAt := 0         , oDlg1:End() },oGrp1,,"", )

oDlg1:Activate(,,,.T.)

Return nAt


***************

Static Function Abre_Impress()

***************

cDLL    := "impressora451.dll"
nHandle := ExecInDllOpen( cDLL )
if nHandle = -1
	 MsgAlert( "Nao foi possível encontrar a DLL " + cDLL )
	 Return .F.
EndIf
// Parametro 1 = Porta serial da impressora
ExecInDLLRun( nHandle, 1, cPORTAIMP )
Return .T.



***************

Static Function Inc_Linha( cIMP, lPRIMLINHA )

***************

// Parametro 1 = Linha a ser impressa
// Parametro 2 = Limpa buffer
ExecInDLLRun( nHandle, 2, cIMP + "," + If( lPRIMLINHA, "1", "0" ) )
Return NIL



***************

Static Function Fecha_Impress()

***************

ExecInDLLRun( nHandle, 3, "" )
ExecInDLLClose( nHandle )
Return NIL


***************

Static Function Reimprime()

***************
/*
If  alltrim(cMAQ)!='A01'  // Diferente de Aglutinador 
    alert('So Aglutinado Reimprime Etiqueta!!!')	
    nPESO := 0
    cOP   := Space( 11 )
    cMAQ  := Space( 06 )
    ObjectMethod( oPESO, "SetText( Trans( nPESO, '@E 999.99' ) )" )
    ObjectMethod( oOP, "SetFocus()" )
    Return 
EndIF

if len(aIMP)=0
   ALERT('Sem Informação para Reimprimir' )
   nPESO := 0
   cOP   := Space( 11 )
   cMAQ  := Space( 06 )
   ObjectMethod( oPESO, "SetText( Trans( nPESO, '@E 999.99' ) )" )
   ObjectMethod( oOP, "SetFocus()" )
   return 
ENDIF

aUSUARIO := u_senha2( "04", 1, "Operador da maquina" )
If ! aUSUARIO[ 1 ]
	Return
EndIf


If Abre_Impress()
	Inc_Linha( aIMP[ 1, 2 ], .T. )
	Inc_Linha( aIMP[ 1, 4 ], .F. )
	Fecha_Impress()
	alert('Etiqueta Reimpressa com Sucesso')	
EndIf

nPESO := 0
cOP   := Space( 11 )
cMAQ  := Space( 06 )
ObjectMethod( oPESO, "SetText( Trans( nPESO, '@E 999.99' ) )" )
ObjectMethod( oOP, "SetFocus()" )
*/
Return NIL

//
*************

Static Function CheckExt()

*************

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
local lret:=.T.
Public _ltudook:=.T.
Private coTbl2
Private cMarca := GetMark()
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlgLe","oBrw1","oGrp1","oBtn1")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

oDlgLe     := MSDialog():New( 127,254,622,697,"Verificacao Extrusora",,,.F.,,,,,,.T.,,,.F. )
oTbl2()
DbSelectArea("TMP2")
oBrw1      := MsSelect():New( "TMP2","MARCA","",{{"MARCA","","",""},;
{"CODIGO","","Codigo",""},;
{"DESC","","Descricao",""}},.F.,cMarca,{006,009,221,209},,, oDlgLe ) 
oBrw1:bAval := {||TMP2Mark()}
oBrw1:oBrowse:bAllMark := {||TMP2MkAll()}
oBrw1:oBrowse:lHasMark := .T.
oBrw1:oBrowse:lCanAllmark := .T.

oGrp1      := TGroup():New( 000,004,227,214,"",oDlgLe,CLR_BLACK,CLR_WHITE,.T.,.F. )
oBtn1      := TButton():New( 230,177,"&Ok",oDlgLe,,037,012,,,,.T.,,"",,,,.F. )
oBtn1:bAction:={|| lret:=OK() }
GetLegen()     		

oDlgLe:Activate(,,,.T.)

TMP2->(DBCloseArea())  
if _ltudook
   dbselectarea('Z67')
   CheckExt()
ENDIF 
Ferase(coTbl2) // APAGA O ARQUIVO DO DISCO

Return lret

****************

Static Function oTbl2()

***************

Local aFds := {}
Aadd( aFds , {"MARCA"   ,"C",002,000} )
Aadd( aFds , {"CODIGO"  ,"C",006,000} )
Aadd( aFds , {"DESC"   ,"C",055,000} )

coTbl2 := CriaTrab( aFds, .T. )
Use (coTbl2) Alias TMP2 New Exclusive
Return 

***************
Static Function GetLegen()
***************

TMP2->( __DbZap() ) // LIMPAR O CONTEUDO DA TABELA TEMPORARIA 
dbSelectArea("SX5")
dbSetOrder(1)
If  SX5->(DbSeek(xFilial("SX5")+'ZT'))
    While SX5->(!EOF()) .AND. SX5->X5_TABELA=='ZT'      
     RecLock("TMP2",.T.)			     
     TMP2->CODIGO:=SX5->X5_CHAVE
     TMP2->DESC:=SX5->X5_DESCRI
     TMP2->(MsUnlock())
     SX5->(DBSKIP())
    ENDDO
Endif
TMP2->(DBGOTOP())

IF SELECT ('TMP2')>0
   dbSelectArea("SX5")
ENDIF

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ TMP2Mark() - Funcao para marcar o Item MsSelect
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function TMP2Mark()

Local lDesMarca := TMP2->(IsMark("MARCA", cMarca))

RecLock("TMP2", .F.)
if lDesmarca
   TMP2->MARCA := "  "
else
   TMP2->MARCA := cMarca
endif


TMP2->(MsUnlock())

return


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ TMP2MkaLL() - Funcao para marcar todos os Itens MsSelect
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function TMP2MkAll()

local nRecno := TMP2->(Recno())

TMP2->(DbGotop())
while ! TMP2->(EOF())
   RecLock("TMP2",.F.)
   if Empty(TMP2->MARCA)
      TMP2->MARCA := cMarca
   else
      TMP2->MARCA := "  "
   endif
   TMP2->(MsUnlock())
   TMP2->(DbSkip())
end
TMP2->(DbGoto(nRecno))

return .T.           


***************
Static Function OK()
***************
Local aItens:={}
local nCnt:=nCntOK:=0
Local  _lRetOk:=.F.

TMP2->(DbGotop())
while ! TMP2->(EOF())
   RecLock("Z67",.T.) 
   Z67->Z67_FILIAL :="01"
   Z67->Z67_ITEM :=TMP2->CODIGO   
   Z67->Z67_OP :=cOP
   Z67->Z67_MAQ :=cMaq   
   Z67->Z67_DATA   := Date()
   Z67->Z67_HORA   := Left( Time(), 5 )
   if !Empty(TMP2->MARCA)
      Z67->Z67_MARCA := "S"
      nCntOK+=1
   else
      Z67->Z67_MARCA := "N"
      Aadd( aItens, {TMP2->CODIGO,TMP2->DESC } )
   endif
   Z67->(MsUnlock())
   ncnt+=1
   TMP2->(DbSkip())
enddo

if ncnt=nCntOK
   _lRetOk:=.T.
else
   
   oProcess:=TWFProcess():New("CheckExt","CheckExt")
   oProcess:NewTask('Inicio',"\workflow\http\emp01\CheckExt.html")
   oHtml   := oProcess:oHtml
   oHtml:ValByName("cOP",cOP  )	
   oHtml:ValByName("cMaq",cMaq )		
	
	For _X:=1 to len(aItens) 
	   aadd( oHtml:ValByName("it.cItem") ,aItens[_X][1] )    
	   aadd( oHtml:ValByName("it.cDesc") ,aItens[_X][2] )    
	Next
	
	 _user := Subs(cUsuario,7,15)
	 oProcess:ClientName(_user)
	 oProcess:cTo := "marcelo@ravaembalagens.com.br;marcio@ravaembalagens.com.br;jorge@ravaembalagens.com.br;josenilton@ravaembalagens.com.br;rodrigo.perreira@ravaembalagens.com.br;robinson@ravaembalagens.com.br" 	         
	 subj	:= "Itens em Desconformidade na verificacao Extrusora"
	 oProcess:cSubject  := subj
	 oProcess:Start()
	 WfSendMail() 
     aUSUARIO := u_senha2( "03",, "Liberar quantidade da OP" ) 
      _lRetOk:=aUSUARIO[ 1 ]
endif
_ltudook:=.F.
oDlgLe:END()

Return _lRetOk
//



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :fReImpEt ³ Autor :Gustavo Costa          ³ Data :02/02/2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao : Reimprime as etiquetas das bobinas pesadas.                ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fReImpEt()

Local cQuery	:= ""
Local cNVia	:= "1"
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

SetPrvt("oFontNegrito","oDlgRI","oPanelA","oBrwBob","oPanelB","oBtnImp","oBtnSair","oSayOP","oSayNOP")
SetPrvt("oCBoxNVIA")

If Len( AllTrim( cOP ) ) < 6
	MsgAlert( OemToAnsi( "Numero de OP invalido" ) )
	Return
Endif


if empty(cMAQ) 
   alert('Favor Digitar a Maquina para ReImprimir a Etiqueta!!!')
   return 
endif


//Cria tabela temporária
oTbl3()

cQuery	:= "SELECT ZB9_COD, ZB9_DESC, ZB9_SALDO, ZB9_QINI, ZB9_SEQ, Z00_NOME, Z00_DATA, Z00_HORA FROM ZB9020 B9 "
cQuery	+= "INNER JOIN Z00020 Z0 "
cQuery	+= "ON ZB9_SEQ = Z00_SEQ "
cQuery	+= "WHERE Z0.D_E_L_E_T_ <> '*' "
cQuery	+= "AND B9.D_E_L_E_T_ <> '*' "
cQuery	+= "AND Z00_OP LIKE '" + cOP + "' "
cQuery	+= "ORDER BY Z00_DATA, Z00_HORA DESC "


If Select("XPI") > 0
	DbSelectArea("XPI")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "XPI"
TCSetField( 'XPI', "Z00_DATA", "D" )

XPI->( DbGoTop() )
ProcRegua(RecCount())
			
While XPI->(!EOF())

	IncProc()
	RecLock("TMP3",.T.)

	TMP3->PROD 	:= XPI->ZB9_COD
	TMP3->OPERA 	:= XPI->Z00_NOME
	TMP3->PESO 	:= XPI->ZB9_QINI
	TMP3->DATAX 	:= XPI->Z00_DATA
	TMP3->HORAX 	:= XPI->Z00_HORA
	TMP3->SEQ 		:= XPI->ZB9_SEQ
	
	MsUnLock()
	XPI->(dbSkip())

EndDo

If Empty(TMP3->PROD)
	MsgAlert("Nenhuma bobina encontrada para esta OP!")
	Return
EndIf

DbSelectArea("XPI")
XPI->(DbCloseArea())
	
TMP3->( DbGoTop() )

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFontNegri := TFont():New( "MS Sans Serif",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
oDlgRI     := MSDialog():New( 126,254,393,1008,"Reimpressao de Etiqueta de Bobina",,,.F.,,,,,,.T.,,,.F. )
oPanelA    := TPanel():New( 000,000,"",oDlgRI,,.F.,.F.,,,375,024,.T.,.F. )
DbSelectArea("TMP3")
oBrwBob    := MsSelect():New( "TMP3","","",{{"PROD"	,"","Codigo"	,""},;
												{"PESO"	,"","Peso"		,"@E 999,999.99"},;
												{"OPERA"	,"","Operador","@!"},;
												{"DATAX"	,"","Data"		,""},;
												{"HORAX"	,"","Hora"		,""};
												},.F.,,{023,000,108,374},,, oDlgRI ) 
oBrwBob:oBrowse:nClrPane := CLR_BLACK
oBrwBob:oBrowse:nClrText := CLR_BLACK
oPanelB    := TPanel():New( 109,000,"",oDlgRI,,.F.,.F.,,,374,023,.T.,.F. )

oBtnImp    := TButton():New( 005,235,"Imprimir",oPanelB,,066,012,,,,.T.,,"",,,,.F. )
oBtnImp:bAction := { || fImprime(Val(cNVia)) }

//oBtnImp:bAction := { || MsgAlert("Imprimir " + cNVia + " vez(es) a etiqueta: " + TMP3->SEQ + " EM " + DtoC(TMP3->DATAX) + " - " + TMP3->HORAX) }

oBtnSair   := TButton():New( 005,305,"Sair",oPanelB,,062,012,,,,.T.,,"",,,,.F. )
oBtnSair:bAction := { || Processa({ || oDlgRI:END() }) }

oSayOP     := TSay():New( 005,008,{||"OP:"},oPanelA,,oFontNegrito,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,013,008)
oSayNOP    := TSay():New( 005,024,{|| cOp },oPanelA,,oFontNegrito,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,051,008)
oSayVia    := TSay():New( 005,283,{||"Vias"},oPanelA,,oFontNegrito,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,018,008)
oCBoxNVIA  := TComboBox():New( 003,305,{|u| If(PCount()>0,cNVia:=u,cNVia)},{"1","2","3"},031,012,oPanelA,,,,CLR_BLACK,CLR_WHITE,.T.,oFontNegrito,"",,,,,,,cNVia )

oDlgRI:Activate(,,,.T.)

Return


****************

Static Function oTbl3()

***************

Local aFds := {}
Aadd( aFds , {"PROD"   ,"C",015,000} )
Aadd( aFds , {"PESO"   ,"N",010,002} )
Aadd( aFds , {"OPERA"  ,"C",020,000} )
Aadd( aFds , {"DATAX"  ,"D",010,000} )
Aadd( aFds , {"HORAX"  ,"C",005,000} )
Aadd( aFds , {"SEQ"    ,"C",006,000} )

If Select("TMP3") > 0
	DbSelectArea("TMP3")
	TMP3->(DbCloseArea())
EndIf

coTbl3 := CriaTrab( aFds, .T. )
Use (coTbl3) Alias TMP3 New Exclusive

Return 


**********************************
Static Function fImprime(nVia)
**********************************

if empty(cMAQ) 
   alert('Favor Digitar a Maquina para ReImprimir a Etiqueta!!!')
   return 
endif

For _x	:= 1 to nVia //imprime
	If Abre_Impress()
		Inc_Linha( DtoC(TMP3->DATAX) + " - " + Alltrim(TMP3->PROD), .T. ) // Data + Produto
		Inc_Linha( alltrim(cMAQ)+' - '+UPPER(AllTrim(TMP3->OPERA)) + " - Peso: " + Transform(TMP3->PESO, "@E 999.99"), .T. ) // Nome e peso
		Inc_Linha( SubStr(cOp,1,6) + TMP3->SEQ , .F. ) //cod barras
		Fecha_Impress()
	else
		msgAlert("Problema de comunicação com a impressora!")
		lLoop := .F.
	EndIf		
Next

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :fVldQuali ³ Autor :Gustavo Costa         ³ Data :13/04/2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao : Valida se foi feito o teste de qualidade das bobinas.      ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fVldQuali()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Local cQuery	:= ""
Local lRet		:= .T.
Local cTurno1	:= GetMv( "MV_TURNO1" )
Local cTurno3	:= GetMv( "MV_TURNO3" )
Local cHora		:= Substr(time(),1,5)
Local lIncluiTeste	:= .F.
Local aArea		:= GetArea()

//Se a OP for digitada incompleta
If Len( AllTrim( cOP ) ) < 6

	MsgAlert( OemToAnsi( "Numero de OP invalido" ) )
	Return .F.

Endif

//Se a quantidade de bobina for maior que a quantidade de testes, inclui mais um teste
If fQtdBob(cOP) > fQtdTeste(cOP)
	//Inclui um teste para esta bobina
	lIncluiTeste	:= .T.
	
EndIf
/*
//Se o horário for do 3 turno, libera
If cHora > cTurno3 .and. cHora < cTurno1
	
	If lIncluiTeste
		//Inclui um teste para esta bobina
		U_fIncQPK(cOP)
		
	EndIf
	
	Return .T.

EndIf

//Libera nos domingos
If DOW(date()) = 1 //Domigo
	
	If lIncluiTeste
		//Inclui um teste para esta bobina
		U_fIncQPK(cOP)
		
	EndIf

	Return .T.

EndIf
*/

If lIncluiTeste
	//Inclui um teste para esta bobina
	U_fIncQPK(cOP)
	
EndIf

cQuery	:= "SELECT * FROM " + RetSqlName("QPK") + " Q "
cQuery	+= "WHERE Q.D_E_L_E_T_ <> '*' "
cQuery	+= "AND QPK_OP = '" + cOP + "' "
cQuery	+= "AND QPK_FILIAL = '" + xFilial("QPK") + "' "
cQuery	+= "AND QPK_LOTE = '" + StrZero(Val(cNumSer),16) + "' "
cQuery	+= "ORDER BY QPK_LOTE "

If Select("XQP") > 0
	DbSelectArea("XQP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "XQP"

XQP->( DbGoTop() )
ProcRegua(RecCount())
			
While XQP->(!EOF())

	//XQP->
	XQP->(dbSkip())

EndDo

If Empty(XQP->PROD)
	MsgAlert("Nenhuma bobina encontrada para esta OP!")
	Return
EndIf

DbSelectArea("XQP")
XQP->(DbCloseArea())

RestArea(aArea)

Return lRet



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :fQtdBob(cOP) ³ Autor :Gustavo Costa      ³ Data :14/04/2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao : Conta quantas bobinas já foram produzidas na OP.           ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fQtdBob(cOP)

Local cQuery	:= ""
Local nRet		:= 1 //começa com um, porque já conta com a bobina que está incluindo no momento
 
cQuery	:= "SELECT COUNT(*) QTD FROM Z00020 "
cQuery	+= "WHERE Z00_OP = '" + cOP + "' "
cQuery	+= "AND Z00_FILIAL = '" + xFilial("Z00") + "' "
cQuery	+= "AND D_E_L_E_T_ <> '*' "

If Select("X00") > 0
	DbSelectArea("X00")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "X00"

X00->( DbGoTop() )
ProcRegua(RecCount())
			
While X00->(!EOF())

	nRet		:= X00->QTD + nRet
	X00->(dbSkip())

EndDo

DbSelectArea("X00")
X00->(DbCloseArea())

Return nRet


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :fQtdTeste(cOP) ³ Autor :Gustavo Costa    ³ Data :14/04/2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao : Conta quantos testes foram cadastrados para esta OP.       ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fQtdTeste(cOP)

Local cQuery	:= ""
Local nRet		:= 0
 
cQuery	:= "SELECT COUNT(*) QTD FROM " + RetSqlName("QPK") + " Q "
cQuery	+= "WHERE Q.D_E_L_E_T_ <> '*' "
cQuery	+= "AND QPK_OP = '" + cOP + "' "
cQuery	+= "AND QPK_FILIAL = '" + xFilial("QPK") + "' "

If Select("XQK") > 0
	DbSelectArea("XQK")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "XQK"

XQK->( DbGoTop() )
ProcRegua(RecCount())
			
While XQK->(!EOF())

	nRet		:= XQK->QTD
	XQK->(dbSkip())

EndDo

DbSelectArea("XQK")
XQK->(DbCloseArea())

Return nRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :fValidaNS ³ Autor :Gustavo Costa         ³ Data :13/04/2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao : Valida se foi digitado o numero do controle de qualidade.  ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fValidaNS()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Local lRet		:= .T.
Local cTurno1	:= GetMv( "MV_TURNO1" )
Local cTurno3	:= GetMv( "MV_TURNO3" )
Local cHora		:= Substr(time(),1,5)

/*
//Se o horário for do 3 turno, libera
If cHora > cTurno3 .and. cHora < cTurno1
	
	Return .T.

EndIf
*/
//Libera nos domingos
If DOW(date()) = 1 //Domigo
	
	Return .T.

EndIf

Return lRet

***************

Static Function fExtruso(cNumOP)

***************

local cQry:=''
local cRet:=""


cQry:="SELECT C2_EXTRUSO FROM "+ RetSqlName( "SC2" ) +" SC2  WHERE C2_NUM='"+cNumOP+"' AND C2_ITEM='01' AND C2_SEQUEN='001' AND D_E_L_E_T_=''  "

If Select("AUXX") > 0
	DbSelectArea("AUXX")
	AUXX->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "AUXX"

IF AUXX->(!EOF())

   cret:=AUXX->C2_EXTRUSO

ENDIF

AUXX->(DBCLOSEAREA())

Return cret 


***************

Static Function PI_SALDO(cNUMOP,cCod,nQtdPi)

***************

local cQry:=''
local nSaldo:=0


cQry:="SELECT D4_OP,D4_COD,D4_QTDEORI FROM SD4020 "
cQry+="WHERE D4_OP='"+cNUMOP+"' "
cQry+="AND D_E_L_E_T_='' "

If Select("TMPS") > 0
  DbSelectArea("TMPS")
  TMPS->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "TMPS"

If ! TMPS->( Eof() )  

   Do While ! TMPS->( Eof() )        
                                
       _nPerc:= TMPS->D4_QTDEORI/nQtdPi
       _nSaldo:=Saldo(TMPS->D4_COD)
       
       if  nPeso * _nPerc >  _nSaldo           

          alert( alltrim(cCod)+' Qtd: '+cvaltochar(nQtdPi)+chr(13)+;
                 alltrim(TMPS->D4_COD)+' Qtd: '+cvaltochar(TMPS->D4_QTDEORI)+chr(13)+;          
                 'Percentual--> '+cvaltochar(_nPerc)+chr(13)+;
                 'Peso--> '+cvaltochar(nPeso)+chr(13)+;
                 'Qtd a Consumir--> '+cvaltochar(nPeso*_nPerc)+chr(13)+;
                 'Saldo--> '+cvaltochar(_nSaldo)+chr(13)+;
                 'Extrusora--> '+alltrim(cMaq)+chr(13)+;
                 'Almoxarifado--> '+alltrim(cAlmoPro) )                                 

          return .F.

       endif
   
      TMPS->(dbskip())
   Enddo 

ELSE

   ALERT('OP '+alltrim(cNUMOP)+' não Teve Empenho' )
   return .F.

EndIf

TMPS->(DbCloseArea())
  
Return .T.


***************

Static Function SALDO(cCod)

***************

local cQry:=''
local nRet:=0


cQry:="SELECT B2_COD,B2_QATU,* "
cQry+="FROM SB2020 SB2 "
cQry+="WHERE B2_COD='"+cCod+"' "
cQry+="AND B2_FILIAL='"+xFilial('SB2')+"'  "
cQry+="AND B2_LOCAL='"+cAlmoPro+"'  "
cQry+="AND SB2.D_E_L_E_T_!='*'  "


If Select("TMPP") > 0
  DbSelectArea("TMPP")
  TMPP->(DbCloseArea())
EndIf
TCQUERY cQry NEW ALIAS "TMPP"

If ! TMPP->( Eof() )  
   nRet:=TMPP->B2_QATU
Endif

TMPP->(DbCloseArea())
                      
Return nRet



***************

Static Function PI_CONSOME(cNUMOP,cCod,nQtdPi)

***************

local cQry:=''
local nSaldo:=0
LOCAL aMATRIZC:={}

cQry:="SELECT D4_OP,D4_COD,D4_QTDEORI FROM SD4020 "
cQry+="WHERE D4_OP='"+cNUMOP+"' "
cQry+="AND D_E_L_E_T_='' "

If Select("TMPS") > 0
  DbSelectArea("TMPS")
  TMPS->(DbCloseArea())
EndIf
TCQUERY cQry NEW ALIAS "TMPS"


If ! TMPS->( Eof() )  
   Do While ! TMPS->( Eof() )        
   
   _nPerc:= TMPS->D4_QTDEORI/nQtdPi   
   
    aMATRIZC     := { { "D3_TM"  , "504"                                                          , ""},;
                 { "D3_DOC"      , NextNumero( "SD3", 2, "D3_DOC", .T. )                          , NIL},;
                 { "D3_FILIAL"   , xFilial( "SD3" )                                               , NIL},;
                 { "D3_OP"       ,cNUMOP                                                          , NIL },;
                 { "D3_LOCAL"    , cAlmoPro                                                       , NIL },;
                 { "D3_COD"      , TMPS->D4_COD                                                   , NIL},;
                 { "D3_UM"       , Posicione( "SB1", 1, xFilial("SB1") + TMPS->D4_COD , "B1_UM" ) , NIL },;
                 { "D3_QUANT"    ,nPESO*_nPerc                                                    , NIL },;
                 { "D3_EMISSAO"  , Date()                                                         , NIL} }


    MSExecAuto( { | x, y | MATA240( x, y ) }, aMATRIZC, 3 )
	IF lMsErroAuto

		DisarmTransaction()
		MostraErro()
        return .F.

	Endif

      TMPS->(dbskip())

   Enddo 

ELSE

   ALERT('OP '+alltrim(cNUMOP)+' não Teve Empenho' )
   return .F.

EndIf

TMPS->(DbCloseArea())
  
Return .T.

