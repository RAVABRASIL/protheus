#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#include "topconn.ch"       // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function RESTPROD()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt( "NORDEM,TAMANHO,TITULO,CDESC1,CDESC2,CDESC3," )
SetPrvt( "ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA," )
SetPrvt( "NLIN,WNREL,M_PAG,CABEC1,CABEC2,MPAG," )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³  TURNPROD  ³ Autor ³   Mauricio Barros    ³ Data ³11/10/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Acompanhamento de producao por turno                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Cliente Rava Embalagens                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Da data                              ³
//³ mv_par02             // Ate a data                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// CORRETO
tamanho   := "G"
titulo    := "RESUMO DE PRODUCAO POR TURNO"
cDesc1    := "Este programa ira emitir o resumo de"
cDesc2    := "producao por maquina/turno."
cDesc3    := ""
cNatureza := ""
aReturn   := { "Producao", 1, "Administracao", 1, 2, 1, "", 1 }
nomeprog  := "RESTPROD"
cPerg     := "TURPRD"
nLastKey  := 0
lContinua := .T.
nLin      := 9
wnrel     := "RESTPROD"
M_PAG     := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Validperg()
Pergunte( cPerg, .F. )               // Pergunta no SX1

cString := "Z00"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint( cString, wnrel, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho )

If nLastKey == 27
   Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Posicao do Formulario na Impressora                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetDefault( aReturn, cString )

If nLastKey == 27
   Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento do Relatorio                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
Return


// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Function RptDetail
Static Function RptDetail()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa  de variaveis                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//  criada funcao fturno para determinar se e de seg. a sexta, sabado, domingo 
cTURNO1   := GetMv( "MV_TURNO1" )
cTURNO2   := GetMv( "MV_TURNO2" )
cTURNO3   := GetMv( "MV_TURNO3" )
cTURNO1_A := Left( cTURNO1, 5 ) + "," + SubStr( cTURNO1, 7, 5 )  
cTURNO2_A := Left( cTURNO2, 5 ) + "," + SubStr( cTURNO2, 7, 5 )
cTURNO3_A := Left( cTURNO3, 5 ) + "," + SubStr( cTURNO3, 7, 5 )


/*
cTURNO1_A := Left( U_Somahora( Left( cTURNO1, 5 ) + ":00", "00:15:00" ), 5 ) + "," + SubStr( cTURNO1, 7, 5 )  // Soma 15 minutos p/ apara
cTURNO2_A := Left( U_Somahora( Left( cTURNO2, 5 ) + ":00", "00:15:00" ), 5 ) + "," + SubStr( cTURNO2, 7, 5 )
cTURNO3_A := Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", "00:15:00" ), 5 ) + "," + SubStr( cTURNO3, 7, 5 )
*/
Cabec1 := "     QUANT  /----------------- T U R N O   1 ----------------\  /----------------- T U R N O   2 ----------------\  /----------------- T U R N O   3 ----------------\  /------------------- T O T A L ------------------\"
Cabec2 := "MAQ  PROD.      (KG)         (MR/UN)     APARA(KG)  APARA(%)        (KG)          (MR/UN)     APARA(KG)  APARA(%)       (KG)          (MR/UN)     APARA(KG)  APARA(%)       (KG)          (MR/UN)     APARA(KG)  APARA(%)"
Cabec3 := "     PROD.      (KG)         (MR/UN)     APARA(KG)  APARA(%)        (KG)          (MR/UN)     APARA(KG)  APARA(%)       (KG)          (MR/UN)     APARA(KG)  APARA(%)       (KG)          (MR/UN)     APARA(KG)  APARA(%)"
//         XXX  9999   9,999,999.99  9,999,999.99  9,999,999.99     99.99  9,999,999.99  9,999,999.99  9,999,999.99     99.99  9,999,999.99  9,999,999.99  9,999,999.99     99.99  9,999,999.99  9,999,999.99  9,999,999.99     99.99
//         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456701234567890123456789012345678901234567890123456789
//         0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16      17        18        19        20        21
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa  regua de impressao                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQuery := "SELECT Z00.Z00_OP,Z00.Z00_MAQ,Z00.Z00_PESO,Z00_APARA,Z00.Z00_HORA,Z00.Z00_QUANT,Z00.Z00_DATA,Z00.Z00_PESCAP,Z00.Z00_PESDIF "
cQuery += "FROM " + RetSqlName( "Z00" ) + " Z00 "
cQuery += "WHERE Z00.Z00_DATA >= '" + Dtos( mv_par01 ) + "' AND Z00.Z00_DATA <= '" + Dtos( mv_par02 + 1 ) + "' AND "
cQuery += "Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "   
cQuery += "AND Z00.Z00_MAQ!='XXX' " // COLOCADO EM 03/06/09 
cQuery += "ORDER BY Z00.Z00_MAQ "
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "Z00X"

TCSetField( 'Z00X', "Z00_DATA", "D" )

nTQTDKG1   := nTQTDKG2   := nTQTDKG3   := 0
nTQTDMR1   := nTQTDMR2   := nTQTDMR3   := 0
nTAPARA1   := nTAPARA2   := nTAPARA3   := 0
nTQTDKG1_2 := nTQTDKG2_2 := nTQTDKG3_2 := 0
nTQTDMR1_2 := nTQTDMR2_2 := nTQTDMR3_2 := 0
nTAPARA1_2 := nTAPARA2_2 := nTAPARA3_2 := 0
Z00X->( DBGoTop() )
SetRegua( Lastrec() )
mPag := 1

//tmp:=0
TITULO := AllTrim( TITULO ) + " - " + Dtoc( MV_PAR01 ) + " A " + Dtoc( MV_PAR02 )
Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  //Impressao do cabecalho
aResult 	:= {}
aResult2	:= {}
aResultPI 	:= {}
aResult3 	:= {}
aResult4 	:= {}
aResultTT	:= {}
Do While ! Z00X->( Eof() )  

 If !EMPTY(Z00X->Z00_MAQ) .AND. !(alltrim(Z00X->Z00_MAQ) $ 'EXT/COST')

 	cMAQ    := Z00X->Z00_MAQ
 	nQTDKG1 := nQTDKG2 := nQTDKG3 := 0
 	nQTDMR1 := nQTDMR2 := nQTDMR3 := 0
 	nAPARA1 := nAPARA2 := nAPARA3 := 0
 	aOP     := {}
 	nOP     := 0
	ntop	:= 0
  
 	Do While ! Z00X->( Eof() ) .and. Z00X->Z00_MAQ == cMAQ
 		lOP := .F.
// RETIRADO APOS MUDANCA NO HORARIO  A PEDIDO DE ROBINSON 
// 		fTurno(Z00X->Z00_DATA) // aqui alimento as variaveis do turno de acordo com o dia( sabado,domingo, seg. a sexta )
 		If Empty(Z00X->Z00_APARA) //se nao produzir apara
 			If Z00X->Z00_DATA <= mv_par02 .and. Z00X->Z00_HORA >= Left( cTURNO1, 5 ) .and. Z00X->Z00_HORA < Left( cTURNO2, 5 ) //Left( U_Somahora( Left( cTURNO1, 5 ) + ":00", SubStr( cTURNO1, 7, 5 ) + ":00" ), 5 )
 			 	nQTDKG1  += Z00X->Z00_PESO + Z00X->Z00_PESCAP
 			 	nQTDMR1  += Z00X->Z00_QUANT
 			 	nTQTDKG1 += Z00X->Z00_PESO + Z00X->Z00_PESCAP
 			 	nTQTDMR1 += Z00X->Z00_QUANT
 				lOP := .T.
 			ElseIf Z00X->Z00_DATA <= mv_par02 .and. Z00X->Z00_HORA >= Left( cTURNO2, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO2, 5 ) + ":00", SubStr( cTURNO2, 7, 5 ) + ":00" ), 5 )
 			 	nQTDKG2  += Z00X->Z00_PESO + Z00X->Z00_PESCAP
 			 	nQTDMR2  += Z00X->Z00_QUANT
 			 	nTQTDKG2 += Z00X->Z00_PESO + Z00X->Z00_PESCAP
 			 	nTQTDMR2 += Z00X->Z00_QUANT
 				lOP := .T.
 			ElseIf ( Z00X->Z00_DATA <= mv_par02 .and. Z00X->Z00_HORA >= Left( cTURNO3, 5 ) ) .or. ;
 			 ( Z00X->Z00_DATA >= mv_par01 + 1 .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( cTURNO3, 7, 5 ) + ":00" ), 5 ) )
 			 	nQTDKG3  += Z00X->Z00_PESO + Z00X->Z00_PESCAP
 			 	nQTDMR3  += Z00X->Z00_QUANT
 			 	nTQTDKG3 += Z00X->Z00_PESO + Z00X->Z00_PESCAP
 			 	nTQTDMR3 += Z00X->Z00_QUANT
 				lOP := .T.
 			EndIf
        ElseIf !Empty(Z00X->Z00_APARA) .and. Z00X->Z00_APARA != "W" //"12" //checa se apara possui 1 ou 2, caso produza refugo
 			If Z00X->Z00_DATA <= mv_par02 .and. Z00X->Z00_HORA >= Left( cTURNO1_A, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO1_A, 5 ) + ":00", SubStr( cTURNO1_A, 7, 5 ) + ":00" ), 5 )
 				nAPARA1  += Z00X->Z00_PESO
 				nTAPARA1 += Z00X->Z00_PESO
 			ElseIf Z00X->Z00_DATA <= mv_par02 .and. Z00X->Z00_HORA >= Left( cTURNO2_A, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO2_A, 5 ) + ":00", SubStr( cTURNO2_A, 7, 5 ) + ":00" ), 5 )
 				nAPARA2  += Z00X->Z00_PESO
 				nTAPARA2 += Z00X->Z00_PESO
 			ElseIf ( Z00X->Z00_DATA <= mv_par02 .and. Z00X->Z00_HORA >= Left( cTURNO3_A, 5 ) ) .or. ;
 			 ( Z00X->Z00_DATA >= mv_par01 + 1 .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO3_A, 5 ) + ":00", SubStr( cTURNO3_A, 7, 5 ) + ":00" ), 5 ) )
 				nAPARA3  += Z00X->Z00_PESO
 				nTAPARA3 += Z00X->Z00_PESO
 			EndIf
 		EndIf
 		If lOP .and. Ascan( aOP, Z00X->Z00_OP ) == 0   //caso nao haja correspondeica no array
 		 	Aadd( aOP, Z00X->Z00_OP )
 		 	nTOP++
			nOP++
 		EndIf
 		Z00X->( DbSkip() )
 	 	IncRegua()
 	EndDo

	IF Alltrim(cMAQ) $ "E01 /E02 /E03 /E04 /A01 /E05 "	
		Aadd (aResultPI, {cMAQ, nOP, nQTDKG1, nQTDMR1, nTQTDKG1, nTQTDMR1, nAPARA1, nTAPARA1,;        //1 turno
											  nQTDKG2, nQTDMR2, nTQTDKG2, nTQTDMR2, nAPARA2, nTAPARA2,;        //2 turno
											  nQTDKG3, nQTDMR3, nTQTDKG3, nTQTDMR3, nAPARA3, nTAPARA3, nTOP} ) //3 turno
	ElseIF Alltrim(cMAQ) $ "I01   /I02   "
	    Aadd (aResult3, {cMAQ, nOP, nQTDKG1, nQTDMR1, nTQTDKG1, nTQTDMR1, nAPARA1, nTAPARA1,;          //1 turno
											nQTDKG2, nQTDMR2, nTQTDKG2, nTQTDMR2, nAPARA2, nTAPARA2,;          //2 turno
											nQTDKG3, nQTDMR3, nTQTDKG3, nTQTDMR3, nAPARA3, nTAPARA3, nTOP} )   //3 turno
	ElseIF  Alltrim(cMAQ)!= "C01" .AND. Alltrim(cMAQ) $ "CX    /ICVR  /MONT  /CVP   /PLAST /DOB   /LA01  /FC01  /SEL  /CVFEVA  /TRIMAQ  /"
	    Aadd (aResult4, {cMAQ, nOP, nQTDKG1, nQTDMR1, nTQTDKG1, nTQTDMR1, nAPARA1, nTAPARA1,;          //1 turno
											nQTDKG2, nQTDMR2, nTQTDKG2, nTQTDMR2, nAPARA2, nTAPARA2,;          //2 turno
											nQTDKG3, nQTDMR3, nTQTDKG3, nTQTDMR3, nAPARA3, nTAPARA3, nTOP} )   //3 turno
	Else
		Aadd (aResult, {cMAQ, nOP, nQTDKG1, nQTDMR1, nTQTDKG1, nTQTDMR1, nAPARA1, nTAPARA1,;          //1 turno
											nQTDKG2, nQTDMR2, nTQTDKG2, nTQTDMR2, nAPARA2, nTAPARA2,;          //2 turno
											nQTDKG3, nQTDMR3, nTQTDKG3, nTQTDMR3, nAPARA3, nTAPARA3, nTOP} )   //3 turno
	ENDIF
/*Novo a partir daqui*/
 ElseIf !EMPTY(Z00X->Z00_MAQ) .AND. (alltrim(Z00X->Z00_MAQ) $ 'EXT/COST')
  	cMaq_2    := Z00X->Z00_MAQ
 	nQTDKG1_2 := nQTDKG2_2 := nQTDKG3_2 := 0
 	nQTDMR1_2 := nQTDMR2_2 := nQTDMR3_2 := 0
 	nAPARA1_2 := nAPARA2_2 := nAPARA3_2 := 0
 	aOP_2     := {}
 	nOP_2     := 0
	ntop_2	  := 0

 	Do While ! Z00X->( Eof() ) .and. Z00X->Z00_MAQ == cMaq_2
 		lOP := .F.
 	   //	fTurno(Z00X->Z00_DATA) // aqui alimento as variaveis do turno de acordo com o dia( sabado,domingo, seg. a sexta )
 		If Empty(Z00X->Z00_APARA) //se nao produzir apara
 			If Z00X->Z00_DATA <= mv_par02 .and. Z00X->Z00_HORA >= Left( cTURNO1, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO1, 5 ) + ":00", SubStr( cTURNO1, 7, 5 ) + ":00" ), 5 )
 			 	nQTDKG1_2  += Z00X->Z00_PESO + Z00X->Z00_PESCAP
 			 	nQTDMR1_2  += Z00X->Z00_QUANT
 			 	nTQTDKG1_2 += Z00X->Z00_PESO + Z00X->Z00_PESCAP
 			 	nTQTDMR1_2 += Z00X->Z00_QUANT
 				lOP := .T.
 			ElseIf Z00X->Z00_DATA <= mv_par02 .and. Z00X->Z00_HORA >= Left( cTURNO2, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO2, 5 ) + ":00", SubStr( cTURNO2, 7, 5 ) + ":00" ), 5 )
 			 	nQTDKG2_2  += Z00X->Z00_PESO + Z00X->Z00_PESCAP
 			 	nQTDMR2_2  += Z00X->Z00_QUANT
 			 	nTQTDKG2_2 += Z00X->Z00_PESO + Z00X->Z00_PESCAP
 			 	nTQTDMR2_2 += Z00X->Z00_QUANT
 				lOP := .T.
 			ElseIf ( Z00X->Z00_DATA <= mv_par02 .and. Z00X->Z00_HORA >= Left( cTURNO3, 5 ) ) .or. ;
 			 ( Z00X->Z00_DATA >= mv_par01 + 1 .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( cTURNO3, 7, 5 ) + ":00" ), 5 ) )
 			 	nQTDKG3_2  += Z00X->Z00_PESO + Z00X->Z00_PESCAP
 			 	nQTDMR3_2  += Z00X->Z00_QUANT
 			 	nTQTDKG3_2 += Z00X->Z00_PESO + Z00X->Z00_PESCAP
 			 	nTQTDMR3_2 += Z00X->Z00_QUANT
 				lOP := .T.
 			EndIf
        ElseIf !Empty(Z00X->Z00_APARA) .and. Z00X->Z00_APARA != "W"  //Desprezo apara de alca //"12" //checa se apara possui 1 ou 2, caso produza refugo
 			If Z00X->Z00_DATA <= mv_par02 .and. Z00X->Z00_HORA >= Left( cTURNO1_A, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO1_A, 5 ) + ":00", SubStr( cTURNO1_A, 7, 5 ) + ":00" ), 5 )
 				nAPARA1_2  += Z00X->Z00_PESO
 				nTAPARA1_2 += Z00X->Z00_PESO
 			ElseIf Z00X->Z00_DATA <= mv_par02 .and. Z00X->Z00_HORA >= Left( cTURNO2_A, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO2_A, 5 ) + ":00", SubStr( cTURNO2_A, 7, 5 ) + ":00" ), 5 )
 				nAPARA2_2  += Z00X->Z00_PESO
 				nTAPARA2_2 += Z00X->Z00_PESO
 			ElseIf ( Z00X->Z00_DATA <= mv_par02 .and. Z00X->Z00_HORA >= Left( cTURNO3_A, 5 ) ) .or. ;
 			 ( Z00X->Z00_DATA >= mv_par01 + 1 .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO3_A, 5 ) + ":00", SubStr( cTURNO3_A, 7, 5 ) + ":00" ), 5 ) )
 				nAPARA3_2  += Z00X->Z00_PESO
 				nTAPARA3_2 += Z00X->Z00_PESO
 			EndIf
 		EndIf
 		If lOP .and. Ascan( aOP_2, Z00X->Z00_OP ) == 0   //caso nao haja correspondeica no array
 		 	Aadd( aOP_2, Z00X->Z00_OP )
 		 	ntop_2++
			nOP_2++
 		EndIf
 		Z00X->( DbSkip() )
 	 	IncRegua()
 	EndDo

	Aadd (aResult2, {cMaq_2, nOP_2, nQTDKG1_2, nQTDMR1_2, nTQTDKG1_2, nTQTDMR1_2, nAPARA1_2, nTAPARA1_2,;          //1 turno
	                                nQTDKG2_2, nQTDMR2_2, nTQTDKG2_2, nTQTDMR2_2, nAPARA2_2, nTAPARA2_2,;          //2 turno
								    nQTDKG3_2, nQTDMR3_2, nTQTDKG3_2, nTQTDMR3_2, nAPARA3_2, nTAPARA3_2, ntop_2} ) //3 turno
/*Novo até aqui*/ 
 Else	
   Z00X->( DbSkip() )
 Endif
Enddo
if Len(aResult2) <= 0 .and. Len(aResult) <= 0 .and.Len(aResult4) <= 0 .and.Len(aResult3) <= 0 .and.Len(aResultPI) <= 0
	alert("Sem qualquer produção no momento!")
	Quit
endIF
If Len(aResult) > 0
    //
	nTTotOPEX1 := nTTotKGEX1 := nTTotMLEX1 := nTTotAPEX1 := nTTotKGEX2 := nTTotMLEX2 := nTTotAPEX2 := nTTotKGEX3 := nTTotMLEX3 := nTTotAPEX3 := 0
	//
	nTotOPEX1 := nTotKGEX1 := nTotMLEX1 := nTotAPEX1 := nTotKGEX2 := nTotMLEX2 := nTotAPEX2 := nTotKGEX3 := nTotMLEX3 := nTotAPEX3 := 0

	FOR X := 1 TO Len(aResult)
	 	//
	 	if X > 1
	      if Left(aResult[X,1],1) != Left(aResult[X-1,1],1)
	         @ Prow() + 2,000 PSAY Repl( "-", 220 )
		     @ Prow() +1 ,000 PSAY "SUB"
		     @ Prow()    ,005 PSAY nTotOPEX1 Picture "@E 9999"
		     @ Prow()    ,011 PSAY nTotKGEX1 Picture "@E 99,999,999.99"
		     @ Prow()    ,025 PSAY nTotMLEX1 Picture "@E 99,999,999.99"
		     @ Prow()    ,039 PSAY nTotAPEX1 Picture "@E 99,999,999.99"
		     @ Prow()    ,056 PSAY (nTotAPEX1 / ( nTotKGEX1 + nTotAPEX1 ) ) * 100 Picture "@E 999.99"
		     
		     @ Prow()    ,063 PSAY nTotKGEX2 Picture "@E 99,999,999.99"
		     @ Prow()    ,077 PSAY nTotMLEX2 Picture "@E 99,999,999.99"
		     @ Prow()    ,091 PSAY nTotAPEX2 Picture "@E 99,999,999.99"
		     @ Prow()    ,108 PSAY (nTotAPEX2 / ( nTotKGEX2 + nTotAPEX2 ) ) * 100 Picture "@E 999.99"

		     @ Prow()    ,115 PSAY nTotKGEX3 Picture "@E 99,999,999.99"
		     @ Prow()    ,129 PSAY nTotMLEX3 Picture "@E 99,999,999.99"
		     @ Prow()    ,143 PSAY nTotAPEX3 Picture "@E 99,999,999.99"
		     @ Prow()    ,160 PSAY (nTotAPEX3 / ( nTotKGEX3 + nTotAPEX3 ) ) * 100 Picture "@E 999.99"

		     @ Prow()    ,167 PSAY nTotKGEX1 + nTotKGEX2 + nTotKGEX3 Picture "@E 99,999,999.99"

             @ Prow()    ,181 PSAY nTotMLEX1 + nTotMLEX2 + nTotMLEX3 Picture "@E 99,999,999.99"

		     @ Prow()    ,195 PSAY nTotAPEX1 + nTotAPEX2 + nTotAPEX3 Picture "@E 99,999,999.99"

		     @ Prow()    ,212 PSAY ((nTotAPEX1 + nTotAPEX2 + nTotAPEX3) / (nTotKGEX1 + nTotKGEX2 + nTotKGEX3 + nTotAPEX1 + nTotAPEX2 + nTotAPEX3) ) * 100 Picture "@E 999.99"
	         
	         nTTotOPEX1 += nTotOPEX1 
		     nTTotKGEX1 += nTotKGEX1 
		     nTTotMLEX1 += nTotMLEX1 
		     nTTotAPEX1 += nTotAPEX1 

		     nTTotKGEX2 += nTotKGEX2 
		     nTTotMLEX2 += nTotMLEX2 
		     nTTotAPEX2 += nTotAPEX2 

		     nTTotKGEX3 += nTotKGEX3 
		     nTTotMLEX3 += nTotMLEX3 
		     nTTotAPEX3 += nTotAPEX3 
     
     	     nTotOPEX1 := nTotKGEX1 := nTotMLEX1 := nTotAPEX1 := nTotKGEX2 := nTotMLEX2 := nTotAPEX2 := nTotKGEX3 := nTotMLEX3 := nTotAPEX3 := 0
	 
	      endIf
        endIf
	 	//
	 	@ Prow() + 2,000 PSAY Left( aResult[X,1], 3 )
	 	@ Prow()    ,005 PSAY aResult[X,2]     Picture "@E 9999"
	 	@ Prow()    ,012 PSAY aResult[X,3] Picture "@E 9,999,999.99"
	 	@ Prow()    ,026 PSAY aResult[X,4] Picture "@E 9,999,999.99"
	 	@ Prow()    ,040 PSAY aResult[X,7] Picture "@E 9,999,999.99"
	 	@ Prow()    ,056 PSAY aResult[X,7] / ( aResult[X,3] + aResult[X,7] ) * 100 Picture "@E 999.99"
	 	@ Prow()    ,064 PSAY aResult[X,9] Picture "@E 9,999,999.99"
	 	@ Prow()    ,078 PSAY aResult[X,10] Picture "@E 9,999,999.99"
	 	@ Prow()    ,092 PSAY aResult[X,13] Picture "@E 9,999,999.99"
	 	@ Prow()    ,108 PSAY aResult[X,13] / ( aResult[X,9] + aResult[X,13] ) * 100 Picture "@E 999.99"
	 	@ Prow()    ,116 PSAY aResult[X,15] Picture "@E 9,999,999.99"
	 	@ Prow()    ,130 PSAY aResult[X,16] Picture "@E 9,999,999.99"
	 	@ Prow()    ,144 PSAY aResult[X,19] Picture "@E 9,999,999.99"
	 	@ Prow()    ,160 PSAY aResult[X,19] / ( aResult[X,15] + aResult[X,19] ) * 100 Picture "@E 999.99"
	 	@ Prow()    ,168 PSAY aResult[X,3] + aResult[X,9] + aResult[X,15] Picture "@E 9,999,999.99"
	 	@ Prow()    ,182 PSAY aResult[X,4] + aResult[X,10] + aResult[X,16] Picture "@E 9,999,999.99"
	 	@ Prow()    ,196 PSAY aResult[X,7] + aResult[X,13] + aResult[X,19] Picture "@E 9,999,999.99"
	 	@ Prow()    ,212 PSAY ( aResult[X,7] + aResult[X,13] + aResult[X,19] ) / ( aResult[X,3] + aResult[X,9] + aResult[X,15] + aResult[X,7] + aResult[X,13] + aResult[X,19] ) * 100 Picture "@E 999.99"

		nTotOPEX1 := nTotOPEX1 + aResult[X,2]
		nTotKGEX1 := nTotKGEX1 + aResult[X,3]
		nTotMLEX1 := nTotMLEX1 + aResult[X,4]
		nTotAPEX1 := nTotAPEX1 + aResult[X,7]

		nTotKGEX2 := nTotKGEX2 + aResult[X,9]
		nTotMLEX2 := nTotMLEX2 + aResult[X,10]
		nTotAPEX2 := nTotAPEX2 + aResult[X,13]

		nTotKGEX3 := nTotKGEX3 + aResult[X,15]
		nTotMLEX3 := nTotMLEX3 + aResult[X,16]
		nTotAPEX3 := nTotAPEX3 + aResult[X,19]

	NEXT
	    //
	    @ Prow() + 2,000 PSAY Repl( "-", 220 )
		@ Prow() + 1,000 PSAY "SUB "
		@ Prow()    ,005 PSAY nTotOPEX1 Picture "@E 9999"
		@ Prow()    ,011 PSAY nTotKGEX1 Picture "@E 99,999,999.99"
		@ Prow()    ,025 PSAY nTotMLEX1 Picture "@E 99,999,999.99"
		@ Prow()    ,039 PSAY nTotAPEX1 Picture "@E 99,999,999.99"
		@ Prow()    ,056 PSAY (nTotAPEX1 / ( nTotKGEX1 + nTotAPEX1 ) ) * 100 Picture "@E 999.99"
		   
		@ Prow()    ,063 PSAY nTotKGEX2 Picture "@E 99,999,999.99"
		@ Prow()    ,077 PSAY nTotMLEX2 Picture "@E 99,999,999.99"
		@ Prow()    ,091 PSAY nTotAPEX2 Picture "@E 99,999,999.99"
		@ Prow()    ,108 PSAY (nTotAPEX2 / ( nTotKGEX2 + nTotAPEX2 ) ) * 100 Picture "@E 999.99"

		@ Prow()    ,115 PSAY nTotKGEX3 Picture "@E 99,999,999.99"
		@ Prow()    ,129 PSAY nTotMLEX3 Picture "@E 99,999,999.99"
		@ Prow()    ,143 PSAY nTotAPEX3 Picture "@E 99,999,999.99"
		@ Prow()    ,160 PSAY (nTotAPEX3 / ( nTotKGEX3 + nTotAPEX3 ) ) * 100 Picture "@E 999.99"

		@ Prow()    ,167 PSAY nTotKGEX1 + nTotKGEX2 + nTotKGEX3 Picture "@E 99,999,999.99"

        @ Prow()    ,181 PSAY nTotMLEX1 + nTotMLEX2 + nTotMLEX3 Picture "@E 99,999,999.99"

		@ Prow()    ,195 PSAY nTotAPEX1 + nTotAPEX2 + nTotAPEX3 Picture "@E 99,999,999.99"

		@ Prow()    ,212 PSAY ((nTotAPEX1 + nTotAPEX2 + nTotAPEX3) / (nTotKGEX1 + nTotKGEX2 + nTotKGEX3 + nTotAPEX1 + nTotAPEX2 + nTotAPEX3) ) * 100 Picture "@E 999.99"
	         
	    nTTotOPEX1 += nTotOPEX1 
		nTTotKGEX1 += nTotKGEX1 
		nTTotMLEX1 += nTotMLEX1 
		nTTotAPEX1 += nTotAPEX1 

		nTTotKGEX2 += nTotKGEX2 
		nTTotMLEX2 += nTotMLEX2 
		nTTotAPEX2 += nTotAPEX2 

		nTTotKGEX3 += nTotKGEX3 
		nTTotMLEX3 += nTotMLEX3 
		nTTotAPEX3 += nTotAPEX3 
	    //                      
	    
	    @ Prow() + 2,000 PSAY Repl( "-", 220 )
	    @ Prow() +1 ,000 PSAY "TOTAL"
        @ Prow()    ,005 PSAY nTTotOPEX1 Picture "@E 9999"
		@ Prow()    ,011 PSAY nTTotKGEX1 Picture "@E 99,999,999.99"
		@ Prow()    ,025 PSAY nTTotMLEX1 Picture "@E 99,999,999.99"
		@ Prow()    ,039 PSAY nTTotAPEX1 Picture "@E 99,999,999.99"
		@ Prow()    ,056 PSAY (nTTotAPEX1 / ( nTTotKGEX1 + nTTotAPEX1 ) ) * 100 Picture "@E 999.99"

		@ Prow()    ,063 PSAY nTTotKGEX2 Picture "@E 99,999,999.99"
		@ Prow()    ,077 PSAY nTTotMLEX2 Picture "@E 99,999,999.99"
		@ Prow()    ,091 PSAY nTTotAPEX2 Picture "@E 99,999,999.99"
		@ Prow()    ,108 PSAY (nTTotAPEX2 / ( nTTotKGEX2 + nTTotAPEX2 ) ) * 100 Picture "@E 999.99"

		@ Prow()    ,115 PSAY nTTotKGEX3 Picture "@E 99,999,999.99"
		@ Prow()    ,129 PSAY nTTotMLEX3 Picture "@E 99,999,999.99"
		@ Prow()    ,143 PSAY nTTotAPEX3 Picture "@E 99,999,999.99"
		@ Prow()    ,160 PSAY (nTTotAPEX3 / ( nTTotKGEX3 + nTTotAPEX3 ) ) * 100 Picture "@E 999.99"

		@ Prow()    ,167 PSAY nTTotKGEX1 + nTTotKGEX2 + nTTotKGEX3 Picture "@E 99,999,999.99"

		@ Prow()    ,181 PSAY nTTotMLEX1 + nTTotMLEX2 + nTTotMLEX3 Picture "@E 99,999,999.99"

		@ Prow()    ,195 PSAY nTTotAPEX1 + nTTotAPEX2 + nTTotAPEX3 Picture "@E 99,999,999.99"

		@ Prow()    ,212 PSAY ((nTTotAPEX1 + nTTotAPEX2 + nTTotAPEX3) / (nTTotKGEX1 + nTTotKGEX2 + nTTotKGEX3 + nTTotAPEX1 + nTTotAPEX2 + nTTotAPEX3) ) * 100 Picture "@E 999.99"
    //  
ENDIF // TESTE     
    If Len(aResult3) > 0
       
       nTotOPEX1 := nTotKGEX1 := nTotMLEX1 := nTotAPEX1 := nTotKGEX2 := nTotMLEX2 := nTotAPEX2 := nTotKGEX3 := nTotMLEX3 := nTotAPEX3 := 0
	   Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  // Impressao do cabecalho
	   
		FOR X := 1 TO Len(aResult3)

		 	@ Prow() + 2,000 PSAY Left( aResult3[X,1], 3 )
		 	@ Prow()    ,005 PSAY aResult3[X,2]     Picture "@E 9999"
		 	@ Prow()    ,012 PSAY aResult3[X,3] Picture "@E 9,999,999.99"
		 	@ Prow()    ,026 PSAY aResult3[X,4] Picture "@E 9,999,999.99"
		 	@ Prow()    ,040 PSAY aResult3[X,7] Picture "@E 9,999,999.99"
		 	@ Prow()    ,056 PSAY aResult3[X,7] / ( aResult3[X,3] + aResult3[X,7] ) * 100 Picture "@E 999.99"

		 	@ Prow()    ,064 PSAY aResult3[X,9] Picture "@E 9,999,999.99"
		 	@ Prow()    ,078 PSAY aResult3[X,10] Picture "@E 9,999,999.99"
		 	@ Prow()    ,092 PSAY aResult3[X,13] Picture "@E 9,999,999.99"
		 	@ Prow()    ,108 PSAY aResult3[X,13] / ( aResult3[X,9] + aResult3[X,13] ) * 100 Picture "@E 999.99"

		 	@ Prow()    ,116 PSAY aResult3[X,15] Picture "@E 9,999,999.99"
		 	@ Prow()    ,130 PSAY aResult3[X,16] Picture "@E 9,999,999.99"
		 	@ Prow()    ,144 PSAY aResult3[X,19] Picture "@E 9,999,999.99"
		 	@ Prow()    ,160 PSAY aResult3[X,19] / ( aResult3[X,15] + aResult3[X,19] ) * 100 Picture "@E 999.99"

		 	@ Prow()    ,168 PSAY aResult3[X,3] + aResult3[X,9] + aResult3[X,15] Picture "@E 9,999,999.99"
		 	@ Prow()    ,182 PSAY aResult3[X,4] + aResult3[X,10] + aResult3[X,16] Picture "@E 9,999,999.99"
		 	@ Prow()    ,196 PSAY aResult3[X,7] + aResult3[X,13] + aResult3[X,19] Picture "@E 9,999,999.99"
		 	@ Prow()    ,212 PSAY ( aResult3[X,7] + aResult3[X,13] + aResult3[X,19] ) / ( aResult3[X,3] + aResult3[X,9] + aResult3[X,15] + aResult3[X,7] + aResult3[X,13] + aResult3[X,19] ) * 100 Picture "@E 999.99"

		NEXT

		@ Prow() + 2,000 PSAY Repl( "-", 220 )

		For Y := 1 To Len(aResult3) //da pra otmizar, basta colocar no for do x
			nTotOPEX1 := nTotOPEX1 + aResult3[Y,2]
			nTotKGEX1 := nTotKGEX1 + aResult3[Y,3]
			nTotMLEX1 := nTotMLEX1 + aResult3[Y,4]
			nTotAPEX1 := nTotAPEX1 + aResult3[Y,7]

			nTotKGEX2 := nTotKGEX2 + aResult3[Y,9]
			nTotMLEX2 := nTotMLEX2 + aResult3[Y,10]
			nTotAPEX2 := nTotAPEX2 + aResult3[Y,13]

			nTotKGEX3 := nTotKGEX3 + aResult3[Y,15]
			nTotMLEX3 := nTotMLEX3 + aResult3[Y,16]
			nTotAPEX3 := nTotAPEX3 + aResult3[Y,19]
		Next

		@ Prow() + 1,005 PSAY nTotOPEX1 Picture "@E 9999"
		@ Prow()    ,011 PSAY nTotKGEX1 Picture "@E 99,999,999.99"
		@ Prow()    ,025 PSAY nTotMLEX1 Picture "@E 99,999,999.99"
		@ Prow()    ,039 PSAY nTotAPEX1 Picture "@E 99,999,999.99"
		@ Prow()    ,056 PSAY (nTotAPEX1 / ( nTotKGEX1 + nTotAPEX1 ) ) * 100 Picture "@E 999.99"

		@ Prow()    ,063 PSAY nTotKGEX2 Picture "@E 99,999,999.99"
		@ Prow()    ,077 PSAY nTotMLEX2 Picture "@E 99,999,999.99"
		@ Prow()    ,091 PSAY nTotAPEX2 Picture "@E 99,999,999.99"
		//@ Prow()    ,108 PSAY (nTotAPEX2 / ( nTotAPEX2 + nTotAPEX2 ) ) * 100 Picture "@E 999.99"
		@ Prow()    ,108 PSAY (nTotAPEX2 / ( nTotKGEX2 + nTotAPEX2 ) ) * 100 Picture "@E 999.99"

		@ Prow()    ,115 PSAY nTotKGEX3 Picture "@E 99,999,999.99"
		@ Prow()    ,129 PSAY nTotMLEX3 Picture "@E 99,999,999.99"
		@ Prow()    ,143 PSAY nTotAPEX3 Picture "@E 99,999,999.99"
		@ Prow()    ,160 PSAY (nTotAPEX3 / ( nTotKGEX3 + nTotAPEX3 ) ) * 100 Picture "@E 999.99"

		@ Prow()    ,167 PSAY nTotKGEX1 + nTotKGEX2 + nTotKGEX3 Picture "@E 99,999,999.99"

		@ Prow()    ,181 PSAY nTotMLEX1 + nTotMLEX2 + nTotMLEX3 Picture "@E 99,999,999.99"

		@ Prow()    ,195 PSAY nTotAPEX1 + nTotAPEX2 + nTotAPEX3 Picture "@E 99,999,999.99"

		@ Prow()    ,212 PSAY ( (nTotAPEX1 + nTotAPEX2 + nTotAPEX3) / (nTotKGEX1 + nTotKGEX2 + nTotKGEX3 + nTotAPEX1 + nTotAPEX2 + nTotAPEX3) ) * 100 Picture "@E 999.99"

	EndIf
    // 
    If Len(aResult4) > 0
       //
	   nTTotOPEX1 := nTTotKGEX1 := nTTotMLEX1 := nTTotAPEX1 := nTTotKGEX2 := nTTotMLEX2 := nTTotAPEX2 := nTTotKGEX3 := nTTotMLEX3 := nTTotAPEX3 := 0
	   //
	   nTotOPEX1 := nTotKGEX1 := nTotMLEX1 := nTotAPEX1 := nTotKGEX2 := nTotMLEX2 := nTotAPEX2 := nTotKGEX3 := nTotMLEX3 := nTotAPEX3 := 0
       Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  // Impressao do cabecalho
	   
	   FOR X := 1 TO Len(aResult4)
	 	//
	 	if X > 1
	      if Left(aResult4[X,1],2) != Left(aResult4[X-1,1],2)
	         @ Prow() + 2,000 PSAY Repl( "-", 220 )
		     @ Prow() +1 ,000 PSAY "SUB"
		     @ Prow()    ,005 PSAY nTotOPEX1 Picture "@E 9999"
		     @ Prow()    ,011 PSAY nTotKGEX1 Picture "@E 99,999,999.99"
		     @ Prow()    ,025 PSAY nTotMLEX1 Picture "@E 99,999,999.99"
		     @ Prow()    ,039 PSAY nTotAPEX1 Picture "@E 99,999,999.99"
		     @ Prow()    ,056 PSAY (nTotAPEX1 / ( nTotKGEX1 + nTotAPEX1 ) ) * 100 Picture "@E 999.99"
		     
		     @ Prow()    ,063 PSAY nTotKGEX2 Picture "@E 99,999,999.99"
		     @ Prow()    ,077 PSAY nTotMLEX2 Picture "@E 99,999,999.99"
		     @ Prow()    ,091 PSAY nTotAPEX2 Picture "@E 99,999,999.99"
		     @ Prow()    ,108 PSAY (nTotAPEX2 / ( nTotKGEX2 + nTotAPEX2 ) ) * 100 Picture "@E 999.99"

		     @ Prow()    ,115 PSAY nTotKGEX3 Picture "@E 99,999,999.99"
		     @ Prow()    ,129 PSAY nTotMLEX3 Picture "@E 99,999,999.99"
		     @ Prow()    ,143 PSAY nTotAPEX3 Picture "@E 99,999,999.99"
		     @ Prow()    ,160 PSAY (nTotAPEX3 / ( nTotKGEX3 + nTotAPEX3 ) ) * 100 Picture "@E 999.99"

		     @ Prow()    ,167 PSAY nTotKGEX1 + nTotKGEX2 + nTotKGEX3 Picture "@E 99,999,999.99"

             @ Prow()    ,181 PSAY nTotMLEX1 + nTotMLEX2 + nTotMLEX3 Picture "@E 99,999,999.99"

		     @ Prow()    ,195 PSAY nTotAPEX1 + nTotAPEX2 + nTotAPEX3 Picture "@E 99,999,999.99"

		     @ Prow()    ,212 PSAY ((nTotAPEX1 + nTotAPEX2 + nTotAPEX3) / (nTotKGEX1 + nTotKGEX2 + nTotKGEX3 + nTotAPEX1 + nTotAPEX2 + nTotAPEX3) ) * 100 Picture "@E 999.99"
	         
	         nTTotOPEX1 += nTotOPEX1 
		     nTTotKGEX1 += iif(alltrim(aResult4[X-1,1]) $ 'MONT/TRIMAQ',nTotKGEX1,0) 
		     nTTotMLEX1 += iif(alltrim(aResult4[X-1,1]) $ 'MONT/TRIMAQ',nTotMLEX1,0) 
		     nTTotAPEX1 += nTotAPEX1 

		     nTTotKGEX2 += iif(alltrim(aResult4[X-1,1])$ 'MONT/TRIMAQ',nTotKGEX2,0) 
		     nTTotMLEX2 += iif(alltrim(aResult4[X-1,1])$ 'MONT/TRIMAQ',nTotMLEX2,0) 
		     nTTotAPEX2 += nTotAPEX2 

		     nTTotKGEX3 += iif(alltrim(aResult4[X-1,1])$ 'MONT/TRIMAQ',nTotKGEX3,0) 
		     nTTotMLEX3 += iif(alltrim(aResult4[X-1,1])$ 'MONT/TRIMAQ',nTotMLEX3,0) 
		     nTTotAPEX3 += nTotAPEX3 
          	     
     	     nTotOPEX1 := nTotKGEX1 := nTotMLEX1 := nTotAPEX1 := nTotKGEX2 := nTotMLEX2 := nTotAPEX2 := nTotKGEX3 := nTotMLEX3 := nTotAPEX3 := 0
	         
	      endIf
        endIf
	 	//                                                     
	 	
	 	@ Prow() + 2,000 PSAY Left( aResult4[X,1], 5 )
	 	@ Prow()    ,005 PSAY aResult4[X,2]     Picture "@E 9999"
	 	@ Prow()    ,012 PSAY aResult4[X,3] Picture "@E 9,999,999.99"
	 	@ Prow()    ,026 PSAY aResult4[X,4] Picture "@E 9,999,999.99"
	 	@ Prow()    ,040 PSAY aResult4[X,7] Picture "@E 9,999,999.99"
	 	@ Prow()    ,056 PSAY aResult4[X,7] / ( aResult4[X,3] + aResult4[X,7] ) * 100 Picture "@E 999.99"
	 	@ Prow()    ,064 PSAY aResult4[X,9] Picture "@E 9,999,999.99"
	 	@ Prow()    ,078 PSAY aResult4[X,10] Picture "@E 9,999,999.99"
	 	@ Prow()    ,092 PSAY aResult4[X,13] Picture "@E 9,999,999.99"
	 	@ Prow()    ,108 PSAY aResult4[X,13] / ( aResult4[X,9] + aResult4[X,13] ) * 100 Picture "@E 999.99"
	 	@ Prow()    ,116 PSAY aResult4[X,15] Picture "@E 9,999,999.99"
	 	@ Prow()    ,130 PSAY aResult4[X,16] Picture "@E 9,999,999.99"
	 	@ Prow()    ,144 PSAY aResult4[X,19] Picture "@E 9,999,999.99"
	 	@ Prow()    ,160 PSAY aResult4[X,19] / ( aResult4[X,15] + aResult4[X,19] ) * 100 Picture "@E 999.99"
	 	@ Prow()    ,168 PSAY aResult4[X,3] + aResult4[X,9] + aResult4[X,15] Picture "@E 9,999,999.99"
	 	@ Prow()    ,182 PSAY aResult4[X,4] + aResult4[X,10] + aResult4[X,16] Picture "@E 9,999,999.99"
	 	@ Prow()    ,196 PSAY aResult4[X,7] + aResult4[X,13] + aResult4[X,19] Picture "@E 9,999,999.99"
	 	@ Prow()    ,212 PSAY ( aResult4[X,7] + aResult4[X,13] + aResult4[X,19] ) / ( aResult4[X,3] + aResult4[X,9] + aResult4[X,15] + aResult4[X,7] + aResult4[X,13] + aResult4[X,19] ) * 100 Picture "@E 999.99"

		nTotOPEX1 := nTotOPEX1 + aResult4[X,2]
		nTotKGEX1 := nTotKGEX1 + aResult4[X,3]
		nTotMLEX1 := nTotMLEX1 + aResult4[X,4]
		nTotAPEX1 := nTotAPEX1 + aResult4[X,7]

		nTotKGEX2 := nTotKGEX2 + aResult4[X,9]
		nTotMLEX2 := nTotMLEX2 + aResult4[X,10]
		nTotAPEX2 := nTotAPEX2 + aResult4[X,13]

		nTotKGEX3 := nTotKGEX3 + aResult4[X,15]
		nTotMLEX3 := nTotMLEX3 + aResult4[X,16]
		nTotAPEX3 := nTotAPEX3 + aResult4[X,19]
       

	NEXT
	    //
	    @ Prow() + 2,000 PSAY Repl( "-", 220 )
		@ Prow() + 1,000 PSAY "SUB "
		@ Prow()    ,005 PSAY nTotOPEX1 Picture "@E 9999"
		@ Prow()    ,011 PSAY nTotKGEX1 Picture "@E 99,999,999.99"
		@ Prow()    ,025 PSAY nTotMLEX1 Picture "@E 99,999,999.99"
		@ Prow()    ,039 PSAY nTotAPEX1 Picture "@E 99,999,999.99"
		@ Prow()    ,056 PSAY (nTotAPEX1 / ( nTotKGEX1 + nTotAPEX1 ) ) * 100 Picture "@E 999.99"
		   
		@ Prow()    ,063 PSAY nTotKGEX2 Picture "@E 99,999,999.99"
		@ Prow()    ,077 PSAY nTotMLEX2 Picture "@E 99,999,999.99"
		@ Prow()    ,091 PSAY nTotAPEX2 Picture "@E 99,999,999.99"
		@ Prow()    ,108 PSAY (nTotAPEX2 / ( nTotKGEX2 + nTotAPEX2 ) ) * 100 Picture "@E 999.99"

		@ Prow()    ,115 PSAY nTotKGEX3 Picture "@E 99,999,999.99"
		@ Prow()    ,129 PSAY nTotMLEX3 Picture "@E 99,999,999.99"
		@ Prow()    ,143 PSAY nTotAPEX3 Picture "@E 99,999,999.99"
		@ Prow()    ,160 PSAY (nTotAPEX3 / ( nTotKGEX3 + nTotAPEX3 ) ) * 100 Picture "@E 999.99"

		@ Prow()    ,167 PSAY nTotKGEX1 + nTotKGEX2 + nTotKGEX3 Picture "@E 99,999,999.99"

        @ Prow()    ,181 PSAY nTotMLEX1 + nTotMLEX2 + nTotMLEX3 Picture "@E 99,999,999.99"

		@ Prow()    ,195 PSAY nTotAPEX1 + nTotAPEX2 + nTotAPEX3 Picture "@E 99,999,999.99"

		@ Prow()    ,212 PSAY ((nTotAPEX1 + nTotAPEX2 + nTotAPEX3) / (nTotKGEX1 + nTotKGEX2 + nTotKGEX3 + nTotAPEX1 + nTotAPEX2 + nTotAPEX3) ) * 100 Picture "@E 999.99"
	         
	    nTTotOPEX1 += nTotOPEX1 
		nTTotKGEX1 += iif(alltrim(aResult4[len(aResult4),1])$ 'MONT/TRIMAQ',nTotKGEX1,0) 
		nTTotMLEX1 += iif(alltrim(aResult4[len(aResult4),1])$ 'MONT/TRIMAQ',nTotMLEX1,0) 
		nTTotAPEX1 += nTotAPEX1 

		nTTotKGEX2 += iif(alltrim(aResult4[len(aResult4),1])$ 'MONT/TRIMAQ',nTotKGEX2,0) 
		nTTotMLEX2 += iif(alltrim(aResult4[len(aResult4),1])$ 'MONT/TRIMAQ',nTotMLEX2,0) 
		nTTotAPEX2 += nTotAPEX2 

		nTTotKGEX3 += iif(alltrim(aResult4[len(aResult4),1])$ 'MONT/TRIMAQ',nTotKGEX3,0) 
		nTTotMLEX3 += iif(alltrim(aResult4[len(aResult4),1])$ 'MONT/TRIMAQ',nTotMLEX3,0) 
		nTTotAPEX3 += nTotAPEX3 
	    
	    
	    //                      
	    
	    @ Prow() + 2,000 PSAY Repl( "-", 220 )
	    @ Prow() +1 ,000 PSAY "TOTAL"
        @ Prow()    ,005 PSAY nTTotOPEX1 Picture "@E 9999"
		//aValor:=VALOR('MONT','1')
		//nTTotKGEX1:=aValor[1]
		//nTTotMLEX1:=aValor[2]
		@ Prow()    ,011 PSAY nTTotKGEX1 Picture "@E 99,999,999.99"
		@ Prow()    ,025 PSAY nTTotMLEX1 Picture "@E 99,999,999.99"
		@ Prow()    ,039 PSAY nTTotAPEX1 Picture "@E 99,999,999.99"
		@ Prow()    ,056 PSAY (nTTotAPEX1 / ( nTTotKGEX1 + nTTotAPEX1 ) ) * 100 Picture "@E 999.99"
        //aValor:=VALOR('MONT','2')
		//nTTotKGEX2:=aValor[1]
		//nTTotMLEX2:=aValor[2]
		@ Prow()    ,063 PSAY nTTotKGEX2 Picture "@E 99,999,999.99"
		@ Prow()    ,077 PSAY nTTotMLEX2 Picture "@E 99,999,999.99"
		@ Prow()    ,091 PSAY nTTotAPEX2 Picture "@E 99,999,999.99"
		@ Prow()    ,108 PSAY (nTTotAPEX2 / ( nTTotKGEX2 + nTTotAPEX2 ) ) * 100 Picture "@E 999.99"
        //aValor:=VALOR('MONT','3')
        //nTTotKGEX3:=aValor[1]
		//nTTotMLEX3:=aValor[2]
		@ Prow()    ,115 PSAY nTTotKGEX3 Picture "@E 99,999,999.99"
		@ Prow()    ,129 PSAY nTTotMLEX3 Picture "@E 99,999,999.99"
		@ Prow()    ,143 PSAY nTTotAPEX3 Picture "@E 99,999,999.99"
		@ Prow()    ,160 PSAY (nTTotAPEX3 / ( nTTotKGEX3 + nTTotAPEX3 ) ) * 100 Picture "@E 999.99"
        
        
		@ Prow()    ,167 PSAY nTTotKGEX1 + nTTotKGEX2 + nTTotKGEX3 Picture "@E 99,999,999.99"

		@ Prow()    ,181 PSAY nTTotMLEX1 + nTTotMLEX2 + nTTotMLEX3 Picture "@E 99,999,999.99"

		@ Prow()    ,195 PSAY nTTotAPEX1 + nTTotAPEX2 + nTTotAPEX3 Picture "@E 99,999,999.99"

		@ Prow()    ,212 PSAY ((nTTotAPEX1 + nTTotAPEX2 + nTTotAPEX3) / (nTTotKGEX1 + nTTotKGEX2 + nTTotKGEX3 + nTTotAPEX1 + nTTotAPEX2 + nTTotAPEX3) ) * 100 Picture "@E 999.99"
    //
    
	EndIf
    //
	If Len(aResultPI) > 0
    
	nTotOPEX1 := nTotKGEX1 := nTotMLEX1 := nTotAPEX1 := nTotKGEX2 := nTotMLEX2 := nTotAPEX2 := nTotKGEX3 := nTotMLEX3 := nTotAPEX3 := 0
    
	Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  // Impressao do cabecalho
	FOR X := 1 TO Len(aResultPI)
	 	//
	 	if X > 1
	      if Left(aResultPI[X,1],1) != Left(aResultPI[X-1,1],1)
	         @ Prow() + 2,000 PSAY Repl( "-", 220 )
		     @ Prow() +1 ,000 PSAY "SUB"
		     @ Prow()    ,005 PSAY nTotOPEX1 Picture "@E 9999"
		     @ Prow()    ,011 PSAY nTotKGEX1 Picture "@E 99,999,999.99"
		     @ Prow()    ,025 PSAY nTotMLEX1 Picture "@E 99,999,999.99"
		     @ Prow()    ,039 PSAY nTotAPEX1 Picture "@E 99,999,999.99"
		     @ Prow()    ,056 PSAY (nTotAPEX1 / ( nTotKGEX1 + nTotAPEX1 ) ) * 100 Picture "@E 999.99"
		     
		     @ Prow()    ,063 PSAY nTotKGEX2 Picture "@E 99,999,999.99"
		     @ Prow()    ,077 PSAY nTotMLEX2 Picture "@E 99,999,999.99"
		     @ Prow()    ,091 PSAY nTotAPEX2 Picture "@E 99,999,999.99"
		     @ Prow()    ,108 PSAY (nTotAPEX2 / ( nTotKGEX2 + nTotAPEX2 ) ) * 100 Picture "@E 999.99"

		     @ Prow()    ,115 PSAY nTotKGEX3 Picture "@E 99,999,999.99"
		     @ Prow()    ,129 PSAY nTotMLEX3 Picture "@E 99,999,999.99"
		     @ Prow()    ,143 PSAY nTotAPEX3 Picture "@E 99,999,999.99"
		     @ Prow()    ,160 PSAY (nTotAPEX3 / ( nTotKGEX3 + nTotAPEX3 ) ) * 100 Picture "@E 999.99"

		     @ Prow()    ,167 PSAY nTotKGEX1 + nTotKGEX2 + nTotKGEX3 Picture "@E 99,999,999.99"

             @ Prow()    ,181 PSAY nTotMLEX1 + nTotMLEX2 + nTotMLEX3 Picture "@E 99,999,999.99"   

		     @ Prow()    ,195 PSAY nTotAPEX1 + nTotAPEX2 + nTotAPEX3 Picture "@E 99,999,999.99"    

		     @ Prow()    ,212 PSAY ((nTotAPEX1 + nTotAPEX2 + nTotAPEX3) / (nTotKGEX1 + nTotKGEX2 + nTotKGEX3 + nTotAPEX1 + nTotAPEX2 + nTotAPEX3) ) * 100 Picture "@E 999.99"  
		     
     	     nTotOPEX1 := nTotKGEX1 := nTotMLEX1 := nTotAPEX1 := nTotKGEX2 := nTotMLEX2 := nTotAPEX2 := nTotKGEX3 := nTotMLEX3 := nTotAPEX3 := 0
	 
	      endIf
        endIf
	 	//
	 	@ Prow() + 2,000 PSAY Left( aResultPI[X,1], 3 )
	 	@ Prow()    ,005 PSAY aResultPI[X,2]     Picture "@E 9999"
	 	@ Prow()    ,012 PSAY aResultPI[X,3] Picture "@E 9,999,999.99"
	 	@ Prow()    ,026 PSAY aResultPI[X,4] Picture "@E 9,999,999.99"
	 	@ Prow()    ,040 PSAY aResultPI[X,7] Picture "@E 9,999,999.99"
	 	@ Prow()    ,056 PSAY aResultPI[X,7] / ( aResultPI[X,3] + aResultPI[X,7] ) * 100 Picture "@E 999.99"
	 	@ Prow()    ,064 PSAY aResultPI[X,9] Picture "@E 9,999,999.99"
	 	@ Prow()    ,078 PSAY aResultPI[X,10] Picture "@E 9,999,999.99"
	 	@ Prow()    ,092 PSAY aResultPI[X,13] Picture "@E 9,999,999.99"
	 	@ Prow()    ,108 PSAY aResultPI[X,13] / ( aResultPI[X,9] + aResultPI[X,13] ) * 100 Picture "@E 999.99"
	 	@ Prow()    ,116 PSAY aResultPI[X,15] Picture "@E 9,999,999.99"
	 	@ Prow()    ,130 PSAY aResultPI[X,16] Picture "@E 9,999,999.99"
	 	@ Prow()    ,144 PSAY aResultPI[X,19] Picture "@E 9,999,999.99"
	 	@ Prow()    ,160 PSAY aResultPI[X,19] / ( aResultPI[X,15] + aResultPI[X,19] ) * 100 Picture "@E 999.99"
	 	@ Prow()    ,168 PSAY aResultPI[X,3] + aResultPI[X,9] + aResultPI[X,15] Picture "@E 9,999,999.99"
	 	@ Prow()    ,182 PSAY aResultPI[X,4] + aResultPI[X,10] + aResultPI[X,16] Picture "@E 9,999,999.99"   
	 	@ Prow()    ,196 PSAY aResultPI[X,7] + aResultPI[X,13] + aResultPI[X,19] Picture "@E 9,999,999.99"        // --KG--
	 	@ Prow()    ,212 PSAY ( aResultPI[X,7] + aResultPI[X,13] + aResultPI[X,19] ) / ( aResultPI[X,3] + aResultPI[X,9] + aResultPI[X,15] + aResultPI[X,7] + aResultPI[X,13] + aResultPI[X,19] ) * 100 Picture "@E 999.99" // --%--

		nTotOPEX1 := nTotOPEX1 + aResultPI[X,2]
		nTotKGEX1 := nTotKGEX1 + aResultPI[X,3]
		nTotMLEX1 := nTotMLEX1 + aResultPI[X,4]
		nTotAPEX1 := nTotAPEX1 + aResultPI[X,7]

		nTotKGEX2 := nTotKGEX2 + aResultPI[X,9]
		nTotMLEX2 := nTotMLEX2 + aResultPI[X,10]
		nTotAPEX2 := nTotAPEX2 + aResultPI[X,13]

		nTotKGEX3 := nTotKGEX3 + aResultPI[X,15]
		nTotMLEX3 := nTotMLEX3 + aResultPI[X,16]
		nTotAPEX3 := nTotAPEX3 + aResultPI[X,19]

	NEXT
	    //
	    @ Prow() + 2,000 PSAY Repl( "-", 220 )
		@ Prow() + 1,000 PSAY "SUB "
		@ Prow()    ,005 PSAY nTotOPEX1 Picture "@E 9999"
		@ Prow()    ,011 PSAY nTotKGEX1 Picture "@E 99,999,999.99"
		@ Prow()    ,025 PSAY nTotMLEX1 Picture "@E 99,999,999.99"
		@ Prow()    ,039 PSAY nTotAPEX1 Picture "@E 99,999,999.99"
		@ Prow()    ,056 PSAY (nTotAPEX1 / ( nTotKGEX1 + nTotAPEX1 ) ) * 100 Picture "@E 999.99"
		   
		@ Prow()    ,063 PSAY nTotKGEX2 Picture "@E 99,999,999.99"
		@ Prow()    ,077 PSAY nTotMLEX2 Picture "@E 99,999,999.99"
		@ Prow()    ,091 PSAY nTotAPEX2 Picture "@E 99,999,999.99"
		@ Prow()    ,108 PSAY (nTotAPEX2 / ( nTotKGEX2 + nTotAPEX2 ) ) * 100 Picture "@E 999.99"

		@ Prow()    ,115 PSAY nTotKGEX3 Picture "@E 99,999,999.99"
		@ Prow()    ,129 PSAY nTotMLEX3 Picture "@E 99,999,999.99"
		@ Prow()    ,143 PSAY nTotAPEX3 Picture "@E 99,999,999.99"
		@ Prow()    ,160 PSAY (nTotAPEX3 / ( nTotKGEX3 + nTotAPEX3 ) ) * 100 Picture "@E 999.99"

		@ Prow()    ,167 PSAY nTotKGEX1 + nTotKGEX2 + nTotKGEX3 Picture "@E 99,999,999.99"

        @ Prow()    ,181 PSAY nTotMLEX1 + nTotMLEX2 + nTotMLEX3 Picture "@E 99,999,999.99"

		@ Prow()    ,195 PSAY nTotAPEX1 + nTotAPEX2 + nTotAPEX3 Picture "@E 99,999,999.99"

		@ Prow()    ,212 PSAY ((nTotAPEX1 + nTotAPEX2 + nTotAPEX3) / (nTotKGEX1 + nTotKGEX2 + nTotKGEX3 + nTotAPEX1 + nTotAPEX2 + nTotAPEX3) ) * 100 Picture "@E 999.99"
	          
	    //                      
	    
	    
    //        
	EndIf
//EndIf // TESTE 
If Len(aResult2) > 0
	nTotOPEX1 := nTotKGEX1 := nTotMLEX1 := nTotAPEX1 := nTotKGEX2 := nTotMLEX2 := nTotAPEX2 := nTotKGEX3 := nTotMLEX3 := nTotAPEX3 := 0
	Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  // Impressao do cabecalho
	FOR X := 1 TO Len(aResult2)
	 	@ Prow() + 2,000 PSAY Left( aResult2[X,1], 3 )
	 	@ Prow()    ,005 PSAY aResult2[X,2]  Picture "@E 9999"
	 	@ Prow()    ,012 PSAY aResult2[X,3]  Picture "@E 9,999,999.99"
	 	@ Prow()    ,026 PSAY aResult2[X,4]  Picture "@E 9,999,999.99"
	 	@ Prow()    ,040 PSAY aResult2[X,7]  Picture "@E 9,999,999.99"
	 	@ Prow()    ,056 PSAY aResult2[X,7] / ( aResult2[X,3] + aResult2[X,7] ) * 100    Picture "@E 999.99"
	 	@ Prow()    ,064 PSAY aResult2[X,9]  Picture "@E 9,999,999.99"
	 	@ Prow()    ,078 PSAY aResult2[X,10] Picture "@E 9,999,999.99"
	 	@ Prow()    ,092 PSAY aResult2[X,13] Picture "@E 9,999,999.99"
	 	@ Prow()    ,108 PSAY aResult2[X,13] / ( aResult2[X,9] + aResult2[X,13] ) * 100  Picture "@E 999.99"
	 	@ Prow()    ,116 PSAY aResult2[X,15] Picture "@E 9,999,999.99"
	 	@ Prow()    ,130 PSAY aResult2[X,16] Picture "@E 9,999,999.99"
	 	@ Prow()    ,144 PSAY aResult2[X,19] Picture "@E 9,999,999.99"
	 	@ Prow()    ,160 PSAY aResult2[X,19] / ( aResult2[X,15] + aResult2[X,19] ) * 100 Picture "@E 999.99"
	 	@ Prow()    ,168 PSAY aResult2[X,3] + aResult2[X,9 ] + aResult2[X,15] Picture "@E 9,999,999.99"
	 	@ Prow()    ,182 PSAY aResult2[X,4] + aResult2[X,10] + aResult2[X,16] Picture "@E 9,999,999.99"
	 	@ Prow()    ,196 PSAY aResult2[X,7] + aResult2[X,13] + aResult2[X,19] Picture "@E 9,999,999.99"
	 	@ Prow()    ,212 PSAY ( aResult2[X,7] + aResult2[X,13] + aResult2[X,19] ) / ( aResult2[X,3] + aResult2[X,9] + aResult2[X,15] + aResult2[X,7] + aResult2[X,13] + aResult2[X,19] ) * 100 Picture "@E 999.99"

		nTotOPEX1 := nTotOPEX1 + aResult2[X,2 ]
		nTotKGEX1 := nTotKGEX1 + aResult2[X,3 ]
		nTotMLEX1 := nTotMLEX1 + aResult2[X,4 ]
		nTotAPEX1 := nTotAPEX1 + aResult2[X,7 ]

		nTotKGEX2 := nTotKGEX2 + aResult2[X,9 ]
		nTotMLEX2 := nTotMLEX2 + aResult2[X,10]
		nTotAPEX2 := nTotAPEX2 + aResult2[X,13]

		nTotKGEX3 := nTotKGEX3 + aResult2[X,15]
		nTotMLEX3 := nTotMLEX3 + aResult2[X,16]
		nTotAPEX3 := nTotAPEX3 + aResult2[X,19]

	NEXT
	    @ Prow() + 2,000 PSAY Repl( "-", 220 )
		@ Prow() + 1,005 PSAY nTotOPEX1 Picture "@E 9999"
		@ Prow()    ,011 PSAY nTotKGEX1 Picture "@E 99,999,999.99"
		@ Prow()    ,025 PSAY nTotMLEX1 Picture "@E 99,999,999.99"
		@ Prow()    ,039 PSAY nTotAPEX1 Picture "@E 99,999,999.99"
		@ Prow()    ,056 PSAY (nTotAPEX1 / ( nTotKGEX1 + nTotAPEX1 ) ) * 100 Picture "@E 999.99"

		@ Prow()    ,063 PSAY nTotKGEX2 Picture "@E 99,999,999.99"
		@ Prow()    ,077 PSAY nTotMLEX2 Picture "@E 99,999,999.99"
		@ Prow()    ,091 PSAY nTotAPEX2 Picture "@E 99,999,999.99"
		@ Prow()    ,108 PSAY (nTotAPEX2 / ( nTotKGEX2 + nTotAPEX2 ) ) * 100 Picture "@E 999.99"

		@ Prow()    ,115 PSAY nTotKGEX3 Picture "@E 99,999,999.99"
		@ Prow()    ,129 PSAY nTotMLEX3 Picture "@E 99,999,999.99"
		@ Prow()    ,143 PSAY nTotAPEX3 Picture "@E 99,999,999.99"
		@ Prow()    ,160 PSAY (nTotAPEX3 / ( nTotKGEX3 + nTotAPEX3 ) ) * 100 Picture "@E 999.99"

		@ Prow()    ,167 PSAY nTotKGEX1 + nTotKGEX2 + nTotKGEX3 Picture "@E 99,999,999.99"

		@ Prow()    ,181 PSAY nTotMLEX1 + nTotMLEX2 + nTotMLEX3 Picture "@E 99,999,999.99"

		@ Prow()    ,195 PSAY nTotAPEX1 + nTotAPEX2 + nTotAPEX3 Picture "@E 99,999,999.99"

		@ Prow()    ,212 PSAY ((nTotAPEX1 + nTotAPEX2 + nTotAPEX3) / (nTotKGEX1 + nTotKGEX2 + nTotKGEX3 + nTotAPEX1 + nTotAPEX2 + nTotAPEX3) ) * 100 Picture "@E 999.99"	
endIF

Z00X->( DbCloseArea() )
Roda( 0, "", TAMANHO )

If aReturn[ 5 ] == 1
   Set Printer To
   Commit
   ourspool( wnrel ) //Chamada do Spool de Impressao
Endif


Return NIL



***************

Static Function ValidPerg()

***************
PutSx1( cPerg, '01', 'Da Data            ?', '', '', 'mv_ch1', 'D', 8, 0, 0, 'G', '', ''   , '', '', 'mv_par01', '', '', '',;
        '' , '', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cPerg, '02', 'Ate a Data         ?', '', '', 'mv_ch2', 'D', 8, 0, 0, 'G', '', ''   , '', '', 'mv_par02', '', '', '',;
        '' , '', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )        
/*_sAlias := Alias()
dbSelectArea( "SX1" )
dbSetOrder( 1 )
cPerg := PADR( cPerg, 6 )
aRegs := {}
AADD(aRegs,{cPerg,"01","Da Data            ?","","","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","S","",""})
AADD(aRegs,{cPerg,"02","Ate a Data         ?","","","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","S","",""})
For i:=1 to Len( aRegs )
    If ! dbSeek( padr( cPerg, 10 ) + aRegs[ i, 2 ] )
   		 RecLock( "SX1", .T. )
		   For j := 1 to FCount()
			     FieldPut( j, aRegs[ i, j ] )
		   Next
		   MsUnlock()
       dbCommit()
	  Endif
Next
dbSelectArea( _sAlias )*/
Return NIL	



***************

Static Function VALOR(cMaq,cTurno)

***************
Local cQry:=''
LOCAL aRet:={}

cQry:="SELECT SUM(Z00_PESO+Z00_PESCAP) VALOR ,SUM(Z00_QUANT) VALOR_UN "
cQry+="FROM " + RetSqlName( "Z00" ) + " Z00 "
cQry+="WHERE 
cQry+="Z00_MAQ='"+cMaq+"' "

// 1Turno
If cTurno='1'
   cQry+="AND Z00_DATHOR >= '"+DtoS(MV_PAR01)+Left(cTURNO1,5)+"' AND  Z00_DATHOR < '"+DtoS(MV_PAR02)+Left(cTURNO2,5)+"'  " 
   cQry+="AND CASE WHEN Z00_HORA >= '"+Left(cTURNO1,5)+"' AND Z00_HORA < '"+Left(cTURNO2,5)+"'  THEN '1'  END ='1' " 
Endif
// 2Turno
If cTurno='2'
   cQry+="AND Z00_DATHOR >= '"+DtoS(MV_PAR01)+Left(cTURNO2,5)+"' AND Z00_DATHOR < '"+DtoS(MV_PAR02)+Left(cTURNO3,5)+"'  " 
   cQry+="AND CASE WHEN Z00_HORA >= '"+Left(cTURNO2,5)+"' AND Z00_HORA <'"+Left(cTURNO3,5)+"'  THEN '2'  END ='2' "
Endif
// 3Turno
If cTurno='3'
   cQry+="AND Z00_DATHOR >= '"+DtoS(MV_PAR01)+Left(cTURNO3,5)+"' AND Z00_DATHOR < '"+DtoS(MV_PAR02+1)+Left(cTURNO1,5)+"'   "     
   cQry+="AND CASE WHEN ( (Z00_HORA >= '"+Left(cTURNO3,5)+"' AND Z00_HORA <= '24:00')  OR (Z00_HORA >= '00:00' AND Z00_HORA < '"+Left(cTURNO1,5)+"' ) ) THEN '3' END='3' " 
Endif
// total
If cTurno='T'
   cQry+="AND Z00.Z00_DATHOR >= '"+DtoS(MV_PAR01)+Left(cTURNO1,5)+"' AND Z00.Z00_DATHOR <'"+DtoS(MV_PAR02+1)+Left(cTURNO1,5)+"'   " 
Endif
//

cQry+="AND Z00.Z00_FILIAL = '"+xfilial('Z00')+"' "
cQry+="AND Z00.Z00_APARA='' "
cQry+="AND Z00.D_E_L_E_T_ = '' "
TCQUERY cQry NEW ALIAS "AUUX"

IF AUUX->(!EOF())
   AADD(aRet,AUUX->VALOR)
   AADD(aRet,AUUX->VALOR_UN)
ENDIF

AUUX->(DBCLOSEAREA())

Return aRet


***************

Static Function fTurno(dData)

***************

if dow(dData)=7 // sabado
	cTURNO1   := GetMv( "MV_TURNO1S" )
	cTURNO2   := GetMv( "MV_TURNO2S" )
	cTURNO3   := GetMv( "MV_TURNO3S" )
	cTURNO1_A := Left( cTURNO1, 5 ) + "," + SubStr( cTURNO1, 7, 5 )  
	cTURNO2_A := Left( cTURNO2, 5 ) + "," + SubStr( cTURNO2, 7, 5 )
	cTURNO3_A := Left( cTURNO3, 5 ) + "," + SubStr( cTURNO3, 7, 5 )
elseif dow(dData)=1 // domingo
	cTURNO1   := GetMv( "MV_TURNO1D" )
	cTURNO2   := GetMv( "MV_TURNO2D" )
	cTURNO3   := GetMv( "MV_TURNO3D" )
	cTURNO1_A := Left( cTURNO1, 5 ) + "," + SubStr( cTURNO1, 7, 5 )  
	cTURNO2_A := Left( cTURNO2, 5 ) + "," + SubStr( cTURNO2, 7, 5 )
	cTURNO3_A := Left( cTURNO3, 5 ) + "," + SubStr( cTURNO3, 7, 5 )
else // seg. a sexta
	cTURNO1   := GetMv( "MV_TURNO1" )
	cTURNO2   := GetMv( "MV_TURNO2" )
	cTURNO3   := GetMv( "MV_TURNO3" )
	cTURNO1_A := Left( cTURNO1, 5 ) + "," + SubStr( cTURNO1, 7, 5 )  
	cTURNO2_A := Left( cTURNO2, 5 ) + "," + SubStr( cTURNO2, 7, 5 )
	cTURNO3_A := Left( cTURNO3, 5 ) + "," + SubStr( cTURNO3, 7, 5 )
endif


Return 