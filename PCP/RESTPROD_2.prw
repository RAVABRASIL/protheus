#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#include "topconn.ch"       // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#include "fivewin.ch"

User Function PCPR010()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

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

cTURNO1   := GetMv( "MV_TURNO1" )
cTURNO2   := GetMv( "MV_TURNO2" )
cTURNO3   := GetMv( "MV_TURNO3" )
cTURNO1_A := Left( cTURNO1, 5 ) + "," + SubStr( cTURNO1, 7, 5 )  // Soma 15 minutos p/ apara
cTURNO2_A := Left( cTURNO2, 5 ) + "," + SubStr( cTURNO2, 7, 5 )
cTURNO3_A := Left( cTURNO3, 5 ) + "," + SubStr( cTURNO3, 7, 5 )

Cabec1 := "MAQ  QUANT   /-----------------  PRODUCAO  -----------------\  /------------PARADA-----------\"
Cabec2 := "TUR  PROD.          (KG)          (MR)     APARA(KG)  APARA(%)   EFIC    TEMPO            (%)     "
Cabec3 := "     PROD.          (KG)          (MR)     APARA(KG)  APARA(%)          (KG)          (MR)     APARA(KG)  APARA(%)          (KG)          (MR)     APARA(KG)  APARA(%)          (KG)          (MR)     APARA(KG)  APARA(%)"
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
//cQuery += "ORDER BY Z00.Z00_MAQ "
//cQuery += "AND Z00_MAQ = 'C11' "
cQuery += "ORDER BY Z00.Z00_MAQ,Z00.Z00_DATA,Z00.Z00_HORA "
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "Z00X"

TCSetField( 'Z00X', "Z00_DATA", "D" )

nTQTDKG1   := nTQTDKG2   := nTQTDKG3   := 0
nTQTDMR1   := nTQTDMR2   := nTQTDMR3   := 0
nTAPARA1   := nTAPARA2   := nTAPARA3   := 0
nTQTDKG1_2 := nTQTDKG2_2 := nTQTDKG3_2 := 0
nTQTDMR1_2 := nTQTDMR2_2 := nTQTDMR3_2 := 0
nTAPARA1_2 := nTAPARA2_2 := nTAPARA3_2 := 0

QUANTMR1 := QUANTMR2 :=QUANTMR3 :=0		
META1:=META2:=META3:=0
EFICI1:=EFICI2:=EFICI3:=0

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
// op 
DbSelectArea("SC2")
SC2->(DbSetOrder(1))
// meta
DbSelectArea("ZB1")
ZB1->(DbSetOrder(1))

Do While ! Z00X->( Eof() )  

 If !EMPTY(Z00X->Z00_MAQ) .AND. !(alltrim(Z00X->Z00_MAQ) $ 'EXT/COST')

 	cMAQ    := Z00X->Z00_MAQ
 	nQTDKG1 := nQTDKG2 := nQTDKG3 := 0
 	nQTDMR1 := nQTDMR2 := nQTDMR3 := 0
 	nAPARA1 := nAPARA2 := nAPARA3 := 0
 	lok1:=lok2:=lok3:=.T.
 	aOP     := {}
 	nOP     := 0
	ntop	:= 0
    
    QUANTMR1 := QUANTMR2 :=QUANTMR3 :=0		
    META1:=META2:=META3:=0
    EFICI1:=EFICI2:=EFICI3:=0
 	
 	_aTemPara:={}
 	
 	Do While ! Z00X->( Eof() ) .and. Z00X->Z00_MAQ == cMAQ
 		lOP := .F.
 		
 		SC2->( DbSeek( xFilial( "SC2" ) + Z00X->Z00_OP, .T. ) )
        //ZB1->( DbSeek( xFilial( "ZB1" ) + Alltrim(cMAQ) + SC2->C2_PRODUTO ) )

		If Empty(Z00X->Z00_APARA) //se nao produzir apara
 			If Z00X->Z00_DATA <= mv_par02 .and. Z00X->Z00_HORA >= Left( cTURNO1, 5 ) .and. Z00X->Z00_HORA < Left( cTURNO2, 5 ) //Left( U_Somahora( Left( cTURNO1, 5 ) + ":00", SubStr( cTURNO1, 7, 5 ) + ":00" ), 5 )
 			 	
 			 	nQTDKG1  += Z00X->Z00_PESO + Z00X->Z00_PESCAP
 			 	nQTDMR1  += Z00X->Z00_QUANT
 			 	nTQTDKG1 += Z00X->Z00_PESO + Z00X->Z00_PESCAP
 			 	nTQTDMR1 += Z00X->Z00_QUANT
 				// eficiencia
 				if ZB1->( DbSeek( xFilial( "ZB1" ) + Alltrim(cMAQ) + SC2->C2_PRODUTO,.T. ) )
	 				if lok1
	 				   cinterAnt1:=GetInterv('1',Z00X->Z00_HORA)[1]
	 				   META1 :=  ZB1->( ZB1_META * ZB1_LADOS )
	 				   META1 :=(META1/3600)*GetInterv('1',Z00X->Z00_HORA)[2]
	 				   lok1:=.F.
	 				endif
	 				
	 				QUANTMR1 += Z00X->Z00_QUANT /1000		
	                
    	            If cinterAnt1!=GetInterv('1',Z00X->Z00_HORA)[1]
	                   META1 +=  ZB1->( ZB1_META * ZB1_LADOS )
	                   META1 :=(META1/3600)*GetInterv('1',Z00X->Z00_HORA)[2]
	                   cinterAnt1:=GetInterv('1',Z00X->Z00_HORA)[1]
	                endif
	                EFICI1   :=  Round( ( QUANTMR1 / META1 ) * 100, 2 )
 				endif
 				//
 				lOP := .T.
 				
 			ElseIf Z00X->Z00_DATA <= mv_par02 .and. Z00X->Z00_HORA >= Left( cTURNO2, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO2, 5 ) + ":00", SubStr( cTURNO2, 7, 5 ) + ":00" ), 5 )
 			 	nQTDKG2  += Z00X->Z00_PESO + Z00X->Z00_PESCAP
 			 	nQTDMR2  += Z00X->Z00_QUANT
 			 	nTQTDKG2 += Z00X->Z00_PESO + Z00X->Z00_PESCAP
 			 	nTQTDMR2 += Z00X->Z00_QUANT
 				// eficiencia
 				if ZB1->( DbSeek( xFilial( "ZB1" ) + Alltrim(cMAQ) + SC2->C2_PRODUTO,.T. ) )
	 				if lok2
	 				   cinterAnt2:=GetInterv('2',Z00X->Z00_HORA)[1]
	 				   META2 :=  ZB1->( ZB1_META * ZB1_LADOS )
	 				   META2 :=(META2/3600)*GetInterv('2',Z00X->Z00_HORA)[2]
	 				   lok2:=.F.
	 				endif
	 				
	 				QUANTMR2 += Z00X->Z00_QUANT /1000		
	                
	                If cinterAnt2!=GetInterv('2',Z00X->Z00_HORA)[1]
	                   META2 +=  ZB1->( ZB1_META * ZB1_LADOS )
	                   META2 :=(META2/3600)*GetInterv('2',Z00X->Z00_HORA)[2]
	                   cinterAnt2:=GetInterv('2',Z00X->Z00_HORA)[1]
	                endif
	                EFICI2   :=  Round( ( QUANTMR2 / META2 ) * 100, 2 )
 				endif
 				//
 				lOP := .T.
 			ElseIf ( Z00X->Z00_DATA <= mv_par02 .and. Z00X->Z00_HORA >= Left( cTURNO3, 5 ) ) .or. ;
 			 ( Z00X->Z00_DATA >= mv_par01 + 1 .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( cTURNO3, 7, 5 ) + ":00" ), 5 ) )
 			 	nQTDKG3  += Z00X->Z00_PESO + Z00X->Z00_PESCAP
 			 	nQTDMR3  += Z00X->Z00_QUANT
 			 	nTQTDKG3 += Z00X->Z00_PESO + Z00X->Z00_PESCAP
 			 	nTQTDMR3 += Z00X->Z00_QUANT
 				// eficiencia
 				IF ZB1->( DbSeek( xFilial( "ZB1" ) + Alltrim(cMAQ) + SC2->C2_PRODUTO,.T. ) )
	 				if lok3
	 				   cinterAnt3:=GetInterv('3',Z00X->Z00_HORA)[1]
	 				   META3 :=  ZB1->( ZB1_META * ZB1_LADOS )
	 				   META3 :=(META3/3600)*GetInterv('3',Z00X->Z00_HORA)[2]
	 				   lok3:=.F.
	 				endif
	 				
	 				QUANTMR3 += Z00X->Z00_QUANT /1000		
	                
	                If cinterAnt3!=GetInterv('3',Z00X->Z00_HORA)[1]
	                   META3 +=  ZB1->( ZB1_META * ZB1_LADOS )              
	                   META3 :=(META3/3600)*GetInterv('3',Z00X->Z00_HORA)[2]
	                   cinterAnt3:=GetInterv('3',Z00X->Z00_HORA)[1]
	                endif
	                EFICI3   :=  Round( ( QUANTMR3 / META3 ) * 100, 2 )
 				ENDIF
 				//
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

	IF Alltrim(cMAQ) $ "E01 /E02 /E03 /E04 /A01 "	
		Aadd (aResultPI, {cMAQ, nOP, nQTDKG1, nQTDMR1, nTQTDKG1, nTQTDMR1, nAPARA1, nTAPARA1,;        //1 turno
											  nQTDKG2, nQTDMR2, nTQTDKG2, nTQTDMR2, nAPARA2, nTAPARA2,;        //2 turno
											  nQTDKG3, nQTDMR3, nTQTDKG3, nTQTDMR3, nAPARA3, nTAPARA3, nTOP} ) //3 turno
	ElseIF Alltrim(cMAQ) $ "I01   /I02   "
	    Aadd (aResult3, {cMAQ, nOP, nQTDKG1, nQTDMR1, nTQTDKG1, nTQTDMR1, nAPARA1, nTAPARA1,;          //1 turno
											nQTDKG2, nQTDMR2, nTQTDKG2, nTQTDMR2, nAPARA2, nTAPARA2,;          //2 turno
											nQTDKG3, nQTDMR3, nTQTDKG3, nTQTDMR3, nAPARA3, nTAPARA3, nTOP} )   //3 turno
	ElseIF Alltrim(cMAQ) $ "CX    /ICVR  /MONT  /CVP   /PLAST "
	    Aadd (aResult4, {cMAQ, nOP, nQTDKG1, nQTDMR1, nTQTDKG1, nTQTDMR1, nAPARA1, nTAPARA1,;          //1 turno
											nQTDKG2, nQTDMR2, nTQTDKG2, nTQTDMR2, nAPARA2, nTAPARA2,;          //2 turno
											nQTDKG3, nQTDMR3, nTQTDKG3, nTQTDMR3, nAPARA3, nTAPARA3, nTOP} )   //3 turno
	Else
		        
	    _aTemPara:=U_TemPara(cMaq,'','Z','','Z',mv_par01,mv_par02)
		
		if  !empty(_aTemPara)
		    Aadd (aResult, {cMAQ, nOP, nQTDKG1, nQTDMR1, nTQTDKG1, nTQTDMR1, nAPARA1, nTAPARA1,;          //1 turno
												nQTDKG2, nQTDMR2, nTQTDKG2, nTQTDMR2, nAPARA2, nTAPARA2,;          //2 turno
											nQTDKG3, nQTDMR3, nTQTDKG3, nTQTDMR3, nAPARA3, nTAPARA3,;     //3 turno
											nTOP,EFICI1,EFICI2,EFICI3,QUANTMR1,QUANTMR2,QUANTMR3,META1,META2,META3,_aTemPara[1][16],_aTemPara[1][17],_aTemPara[1][18],_aTemPara[1][19],_aTemPara[1][20],_aTemPara[1][21],_aTemPara[1][22],_aTemPara[1][23],_aTemPara[1][24] } )  
	    else
	       Aadd (aResult, {cMAQ, nOP, nQTDKG1, nQTDMR1, nTQTDKG1, nTQTDMR1, nAPARA1, nTAPARA1,;          //1 turno
												nQTDKG2, nQTDMR2, nTQTDKG2, nTQTDMR2, nAPARA2, nTAPARA2,;          //2 turno
											nQTDKG3, nQTDMR3, nTQTDKG3, nTQTDMR3, nAPARA3, nTAPARA3,;     //3 turno
											nTOP,EFICI1,EFICI2,EFICI3,QUANTMR1,QUANTMR2,QUANTMR3,META1,META2,META3,'','','','','','','','','' } )  
	    endif
	
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
if Len(aResult2) <= 0 .and. Len(aResult) <= 0
	alert("Sem qualquer produção no momento!")
	Quit
endIF
If Len(aResult) > 0
    //
	nTTotOPEX1 := nTTotKGEX1 := nTTotMLEX1 := nTTotAPEX1 := nTTotKGEX2 := nTTotMLEX2 := nTTotAPEX2 := nTTotKGEX3 := nTTotMLEX3 := nTTotAPEX3 := 0
	nTTotQTEX1:=nTTotQTEX2:=nTTotQTEX3:=0
	nTTotMTEX1:=nTTotMTEX2:=nTTotMTEX3:=0
	nTTotPAEX1:=nTTotPAEX2:=nTTotPAEX3:='00:00:00'
	nTTotDUEX1:=nTTotDUEX2:=nTTotDUEX3:='00:00:00'
	//
	nTotOPEX1 := nTotKGEX1 := nTotMLEX1 := nTotAPEX1 := nTotKGEX2 := nTotMLEX2 := nTotAPEX2 := nTotKGEX3 := nTotMLEX3 := nTotAPEX3 := 0
    nTotQTEX1:=nTotQTEX2:=nTotQTEX3:=0
    nTotMTEX1:=nTotMTEX2:=nTotMTEX3:=0
    nTotPAEX1:=nTotPAEX2:=nTotPAEX3:='00:00:00'
    nTotDUEX1:=nTotDUEX2:=nTotDUEX3:='00:00:00'
    //
	
	FOR X := 1 TO Len(aResult)
	 	
	 	If Prow()  > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
           Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  // Impressao do cabecalho
           //Prow() + 2
        Endif	 	
	 	
	 	//
	 	if X > 1
	      if Left(aResult[X,1],1) != Left(aResult[X-1,1],1)
	         @ Prow() + 2,000 PSAY Repl( "-", 220 )
		     @ Prow() +1 ,000 PSAY "SUB"
		     @ Prow()    ,005 PSAY nTotOPEX1 Picture "@E 9999"
		     // 1 TURNO
		     @ Prow()+1  ,000 PSAY "1º T"
		     @ Prow()    ,011 PSAY nTotKGEX1 Picture "@E 99,999,999.99"
		     @ Prow()    ,025 PSAY nTotMLEX1 Picture "@E 99,999,999.99"
		     @ Prow()    ,039 PSAY nTotAPEX1 Picture "@E 99,999,999.99"
		     @ Prow()    ,056 PSAY (nTotAPEX1 / ( nTotKGEX1 + nTotAPEX1 ) ) * 100 Picture "@E 999.99"
		     @ Prow()    ,064 PSAY ROUND((nTotQTEX1/nTotMTEX1)*100 ,2) Picture "@E 9,999.99"
		     @ Prow()    ,074 PSAY   nTotPAEX1  // parada
		     @ Prow()    ,088 PSAY   Round(Percent(nTotPAEX1,nTotDUEX1),2) Picture "@E 999.99"  // %
		    
		    // 2 TURNO  
		     @ Prow()+1  ,000 PSAY "2º T"
		     @ Prow()    ,011 PSAY nTotKGEX2 Picture "@E 99,999,999.99"
		     @ Prow()    ,025 PSAY nTotMLEX2 Picture "@E 99,999,999.99"
		     @ Prow()    ,039 PSAY nTotAPEX2 Picture "@E 99,999,999.99"
		     @ Prow()    ,056 PSAY (nTotAPEX2 / ( nTotKGEX2 + nTotAPEX2 ) ) * 100 Picture "@E 999.99"
             @ Prow()    ,064 PSAY ROUND((nTotQTEX2/nTotMTEX2)*100 ,2) Picture "@E 9,999.99"
             @ Prow()    ,074 PSAY   nTotPAEX2  // parada
             @ Prow()    ,088 PSAY   Round(Percent(nTotPAEX2,nTotDUEX2),2) Picture "@E 999.99"  // %
             
             // 3 TURNO
		     @ Prow()+1  ,000 PSAY "3º T"
		     @ Prow()    ,011 PSAY nTotKGEX3 Picture "@E 99,999,999.99"
		     @ Prow()    ,025 PSAY nTotMLEX3 Picture "@E 99,999,999.99"
		     @ Prow()    ,039 PSAY nTotAPEX3 Picture "@E 99,999,999.99"
		     @ Prow()    ,056 PSAY (nTotAPEX3 / ( nTotKGEX3 + nTotAPEX3 ) ) * 100 Picture "@E 999.99"
             @ Prow()    ,064 PSAY ROUND((nTotQTEX3/nTotMTEX3)*100 ,2) Picture "@E 9,999.99"
             @ Prow()    ,074 PSAY   nTotPAEX3  // parada
		     @ Prow()    ,088 PSAY   Round(Percent(nTotPAEX3,nTotDUEX3),2) Picture "@E 999.99"  // %
		                  
             // TOTAL HORIZONTAL 
		     @ Prow()+1  ,000 PSAY "--> "
		     @ Prow()    ,011 PSAY nTotKGEX1 + nTotKGEX2 + nTotKGEX3 Picture "@E 99,999,999.99"

             @ Prow()    ,025 PSAY nTotMLEX1 + nTotMLEX2 + nTotMLEX3 Picture "@E 99,999,999.99"

		     @ Prow()    ,039 PSAY nTotAPEX1 + nTotAPEX2 + nTotAPEX3 Picture "@E 99,999,999.99"

		     @ Prow()    ,056 PSAY ((nTotAPEX1 + nTotAPEX2 + nTotAPEX3) / (nTotKGEX1 + nTotKGEX2 + nTotKGEX3 + nTotAPEX1 + nTotAPEX2 + nTotAPEX3) ) * 100 Picture "@E 999.99"
	         
	         @ Prow()    ,064 PSAY ROUND(((nTotQTEX1+nTotQTEX2+nTotQTEX3)/(nTotMTEX1+nTotMTEX2+nTotMTEX3))*100,2)  Picture "@E 9,999.99"
	         
	          cSubPa:=AddHora(nTotPAEX1,nTotPAEX2)
	          cSubPa:=AddHora(cSubPa,nTotPAEX3)
	         
	         @ Prow()    ,074 PSAY   cSubPa  // parada
	         
	         cSubDu:=AddHora(nTotDUEX1,nTotDUEX2)
	         cSubDu:=AddHora(cSubDu,nTotDUEX3)
	         
	         @ Prow()    ,088 PSAY   Round(Percent(cSubPa,cSubDu),2) Picture "@E 999.99"  // %
	         
	         nTTotOPEX1 += nTotOPEX1 
		     nTTotKGEX1 += nTotKGEX1 
		     nTTotMLEX1 += nTotMLEX1 
		     nTTotAPEX1 += nTotAPEX1 
             nTTotQTEX1 += nTotQTEX1 
             nTTotMTEX1 += nTotMTEX1
             nTTotPAEX1:= AddHora(nTTotPAEX1,nTotPAEX1)              
		     nTTotDUEX1:= AddHora(nTTotDUEX1,nTotDUEX1)              
		     
		     nTTotKGEX2 += nTotKGEX2 
		     nTTotMLEX2 += nTotMLEX2 
		     nTTotAPEX2 += nTotAPEX2 
             nTTotQTEX2 += nTotQTEX2 
             nTTotMTEX2 += nTotMTEX2
             nTTotPAEX2:= AddHora(nTTotPAEX2,nTotPAEX2)              
		     nTTotDUEX2:= AddHora(nTTotDUEX2,nTotDUEX2)
		     
		     nTTotKGEX3 += nTotKGEX3 
		     nTTotMLEX3 += nTotMLEX3 
		     nTTotAPEX3 += nTotAPEX3 
             nTTotQTEX3 += nTotQTEX3
             nTTotMTEX3 += nTotMTEX3
             nTTotPAEX3:= AddHora(nTTotPAEX3,nTotPAEX3)              
             nTTotDUEX3:= AddHora(nTTotDUEX3,nTotDUEX3)

     	     
     	     nTotOPEX1 := nTotKGEX1 := nTotMLEX1 := nTotAPEX1 := nTotKGEX2 := nTotMLEX2 := nTotAPEX2 := nTotKGEX3 := nTotMLEX3 := nTotAPEX3 := 0
	         nTotQTEX1:=nTotQTEX2:=nTotQTEX3:=0
             nTotMTEX1:=nTotMTEX2:=nTotMTEX3:=0
             nTotPAEX1:=nTotPAEX2:=nTotPAEX3:='00:00:00'
   	         nTotDUEX1:=nTotDUEX2:=nTotDUEX3:='00:00:00'
	      
	      endIf
        endIf
	 	//
	 	@ Prow() + 2,000 PSAY Left( aResult[X,1], 3 )   // maquina 
	 	@ Prow()    ,005 PSAY aResult[X,2]     Picture "@E 9999"   // qtd. produzida
	 	// 1 TURNO
	 	@ Prow()+1  ,000 PSAY "1º T"
	 	@ Prow()    ,012 PSAY aResult[X,3] Picture "@E 9,999,999.99"  // kg
	 	@ Prow()    ,026 PSAY aResult[X,4] Picture "@E 9,999,999.99"  // MR
	 	@ Prow()    ,040 PSAY aResult[X,7] Picture "@E 9,999,999.99"  // apara(kg)
	 	@ Prow()    ,056 PSAY aResult[X,7] / ( aResult[X,3] + aResult[X,7] ) * 100 Picture "@E 999.99"  // apara(%)
	 	@ Prow()    ,064 PSAY aResult[X,22] Picture "@E 9,999.99"  // EFICIENCIA
        @ Prow()    ,074 PSAY iif(!empty(aResult[X,31]),aResult[X,31],)   // parada
        @ Prow()    ,088 PSAY iif(!empty(aResult[X,32]),Round(aResult[X,32],2),) Picture "@E 999.99" // %
   	 	
	 	// 2 TURNO
	 	@ Prow()+1  ,000 PSAY "2º T"
	 	@ Prow()    ,012 PSAY aResult[X,9] Picture "@E 9,999,999.99"
	 	@ Prow()    ,026 PSAY aResult[X,10] Picture "@E 9,999,999.99"
	 	@ Prow()    ,040 PSAY aResult[X,13] Picture "@E 9,999,999.99"
	 	@ Prow()    ,056 PSAY aResult[X,13] / ( aResult[X,9] + aResult[X,13] ) * 100 Picture "@E 999.99"
	 	@ Prow()    ,064 PSAY aResult[X,23] Picture "@E 9,999.99"  // EFICIENCIA
        @ Prow()    ,074 PSAY iif(!empty(aResult[X,33]),aResult[X,33],)   // parada
        @ Prow()    ,088 PSAY iif(!empty(aResult[X,34]),Round(aResult[X,34],2),) Picture "@E 999.99" // %
   	 	   	 	
	 	// 3 TURNO
	 	@ Prow()+1  ,000 PSAY "3º T"
	 	@ Prow()    ,012 PSAY aResult[X,15] Picture "@E 9,999,999.99"
	 	@ Prow()    ,026 PSAY aResult[X,16] Picture "@E 9,999,999.99"
	 	@ Prow()    ,040 PSAY aResult[X,19] Picture "@E 9,999,999.99"
	 	@ Prow()    ,056 PSAY aResult[X,19] / ( aResult[X,15] + aResult[X,19] ) * 100 Picture "@E 999.99"
	 	@ Prow()    ,064 PSAY aResult[X,24] Picture "@E 9,999.99"  // EFICIENCIA
        @ Prow()    ,074 PSAY iif(!empty(aResult[X,35]),aResult[X,35],)   // parada
        @ Prow()    ,088 PSAY iif(!empty(aResult[X,36]),Round(aResult[X,36],2),) Picture "@E 999.99"  // %
   	 	   	 	
	 	// TOTAL HORIZONTAL 
	 	@ Prow()+1  ,000 PSAY "T "+Left( aResult[X,1], 3 ) 
	 	@ Prow()    ,012 PSAY aResult[X,3] + aResult[X,9] + aResult[X,15] Picture "@E 9,999,999.99"
	 	@ Prow()    ,026 PSAY aResult[X,4] + aResult[X,10] + aResult[X,16] Picture "@E 9,999,999.99"
	 	@ Prow()    ,040 PSAY aResult[X,7] + aResult[X,13] + aResult[X,19] Picture "@E 9,999,999.99"
	 	@ Prow()    ,056 PSAY ( aResult[X,7] + aResult[X,13] + aResult[X,19] ) / ( aResult[X,3] + aResult[X,9] + aResult[X,15] + aResult[X,7] + aResult[X,13] + aResult[X,19] ) * 100 Picture "@E 999.99"
                                    // QTD1           QTD2            QTD3          META1         META2         META3
        @ Prow()    ,064 PSAY  ROUND(((aResult[X,25]+aResult[X,26]+aResult[X,27])/(aResult[X,28]+aResult[X,29]+aResult[X,30]))*100,2)   Picture "@E 9,999.99"  // EFICIENCIA
		
		if  !empty(aResult[X,31]) .AND.!empty(aResult[X,33]) .AND.!empty(aResult[X,35]) 
            cParada:=AddHora(aResult[X,31],aResult[X,33])
		    cParada:=AddHora(cParada,aResult[X,35])
		    
		    @ Prow()    ,074 PSAY   cParada       // parada
		    
		    nTotPAEX1 :=AddHora(nTotPAEX1,aResult[X,31])
   		    nTotPAEX2 :=AddHora(nTotPAEX2,aResult[X,33])
		    nTotPAEX3 :=AddHora(nTotPAEX3,aResult[X,35])
		endif
		
		if  !empty(aResult[X,37]) .AND.!empty(aResult[X,38]) .AND.!empty(aResult[X,39]) 
            cPerc:=AddHora(aResult[X,37],aResult[X,38])
		    cPerc:=AddHora(cPerc,aResult[X,39])		    
		    @ Prow()    ,088 PSAY   Round(Percent(cParada,cPerc),2) Picture "@E 999.99"  // %
		    
		    nTotDUEX1:=AddHora(nTotDUEX1,aResult[X,37])
		    nTotDUEX2:=AddHora(nTotDUEX2,aResult[X,38])
		    nTotDUEX3:=AddHora(nTotDUEX3,aResult[X,39])
		endif
		
		
		nTotOPEX1 := nTotOPEX1 + aResult[X,2]
		nTotKGEX1 := nTotKGEX1 + aResult[X,3]
		nTotMLEX1 := nTotMLEX1 + aResult[X,4]
		nTotAPEX1 := nTotAPEX1 + aResult[X,7]
        nTotQTEX1 := nTotQTEX1 + aResult[X,25]
        nTotMTEX1 := nTotMTEX1 + aResult[X,28]
			
		nTotKGEX2 := nTotKGEX2 + aResult[X,9]
		nTotMLEX2 := nTotMLEX2 + aResult[X,10]
		nTotAPEX2 := nTotAPEX2 + aResult[X,13]
        nTotQTEX2 := nTotQTEX2 + aResult[X,26]
        nTotMTEX2 := nTotMTEX2 + aResult[X,29]
  
		nTotKGEX3 := nTotKGEX3 + aResult[X,15]
		nTotMLEX3 := nTotMLEX3 + aResult[X,16]
		nTotAPEX3 := nTotAPEX3 + aResult[X,19]
        nTotQTEX3 := nTotQTEX3 + aResult[X,27]
        nTotMTEX3 := nTotMTEX3 + aResult[X,30]
		
	NEXT
	    
	    If Prow()  > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
           Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  // Impressao do cabecalho
           //Prow() + 2
        Endif	 	
	 	
	    //
	    @ Prow() + 2,000 PSAY Repl( "-", 220 )
		     @ Prow() +1 ,000 PSAY "SUB"
		     @ Prow()    ,005 PSAY nTotOPEX1 Picture "@E 9999"
		     // 1 TURNO
		     @ Prow()+1  ,000 PSAY "1º T"
		     @ Prow()    ,011 PSAY nTotKGEX1 Picture "@E 99,999,999.99"
		     @ Prow()    ,025 PSAY nTotMLEX1 Picture "@E 99,999,999.99"
		     @ Prow()    ,039 PSAY nTotAPEX1 Picture "@E 99,999,999.99"
		     @ Prow()    ,056 PSAY (nTotAPEX1 / ( nTotKGEX1 + nTotAPEX1 ) ) * 100 Picture "@E 999.99"
		     @ Prow()    ,064 PSAY ROUND((nTotQTEX1/nTotMTEX1)*100 ,2) Picture "@E 9,999.99"
		     @ Prow()    ,074 PSAY   nTotPAEX1  // parada
		     @ Prow()    ,088 PSAY   Round(Percent(nTotPAEX1,nTotDUEX1),2) Picture "@E 999.99"  // %
		    
		    // 2 TURNO  
		     @ Prow()+1  ,000 PSAY "2º T"
		     @ Prow()    ,011 PSAY nTotKGEX2 Picture "@E 99,999,999.99"
		     @ Prow()    ,025 PSAY nTotMLEX2 Picture "@E 99,999,999.99"
		     @ Prow()    ,039 PSAY nTotAPEX2 Picture "@E 99,999,999.99"
		     @ Prow()    ,056 PSAY (nTotAPEX2 / ( nTotKGEX2 + nTotAPEX2 ) ) * 100 Picture "@E 999.99"
             @ Prow()    ,064 PSAY ROUND((nTotQTEX2/nTotMTEX2)*100 ,2) Picture "@E 9,999.99"
             @ Prow()    ,074 PSAY   nTotPAEX2  // parada
             @ Prow()    ,088 PSAY   Round(Percent(nTotPAEX2,nTotDUEX2),2) Picture "@E 999.99"  // %
             
             // 3 TURNO
		     @ Prow()+1  ,000 PSAY "3º T"
		     @ Prow()    ,011 PSAY nTotKGEX3 Picture "@E 99,999,999.99"
		     @ Prow()    ,025 PSAY nTotMLEX3 Picture "@E 99,999,999.99"
		     @ Prow()    ,039 PSAY nTotAPEX3 Picture "@E 99,999,999.99"
		     @ Prow()    ,056 PSAY (nTotAPEX3 / ( nTotKGEX3 + nTotAPEX3 ) ) * 100 Picture "@E 999.99"
             @ Prow()    ,064 PSAY ROUND((nTotQTEX3/nTotMTEX3)*100 ,2) Picture "@E 9,999.99"
             @ Prow()    ,074 PSAY   nTotPAEX3  // parada
		     @ Prow()    ,088 PSAY   Round(Percent(nTotPAEX3,nTotDUEX3),2) Picture "@E 999.99"  // %
		                  
             // TOTAL HORIZONTAL 
		     @ Prow()+1  ,000 PSAY "--> "
		     @ Prow()    ,011 PSAY nTotKGEX1 + nTotKGEX2 + nTotKGEX3 Picture "@E 99,999,999.99"

             @ Prow()    ,025 PSAY nTotMLEX1 + nTotMLEX2 + nTotMLEX3 Picture "@E 99,999,999.99"

		     @ Prow()    ,039 PSAY nTotAPEX1 + nTotAPEX2 + nTotAPEX3 Picture "@E 99,999,999.99"

		     @ Prow()    ,056 PSAY ((nTotAPEX1 + nTotAPEX2 + nTotAPEX3) / (nTotKGEX1 + nTotKGEX2 + nTotKGEX3 + nTotAPEX1 + nTotAPEX2 + nTotAPEX3) ) * 100 Picture "@E 999.99"
	         
	         @ Prow()    ,064 PSAY ROUND(((nTotQTEX1+nTotQTEX2+nTotQTEX3)/(nTotMTEX1+nTotMTEX2+nTotMTEX3))*100,2)  Picture "@E 9,999.99"
	         
	          cSubPa:=AddHora(nTotPAEX1,nTotPAEX2)
	          cSubPa:=AddHora(cSubPa,nTotPAEX3)
	         
	         @ Prow()    ,074 PSAY   cSubPa  // parada
	         
	         cSubDu:=AddHora(nTotDUEX1,nTotDUEX2)
	         cSubDu:=AddHora(cSubDu,nTotDUEX3)
	         
	         @ Prow()    ,088 PSAY   Round(Percent(cSubPa,cSubDu),2) Picture "@E 999.99"  // %
	         
	         nTTotOPEX1 += nTotOPEX1 
		     nTTotKGEX1 += nTotKGEX1 
		     nTTotMLEX1 += nTotMLEX1 
		     nTTotAPEX1 += nTotAPEX1 
             nTTotQTEX1 += nTotQTEX1 
             nTTotMTEX1 += nTotMTEX1
             nTTotPAEX1:= AddHora(nTTotPAEX1,nTotPAEX1)              
		     nTTotDUEX1:= AddHora(nTTotDUEX1,nTotDUEX1)              
		     
		     nTTotKGEX2 += nTotKGEX2 
		     nTTotMLEX2 += nTotMLEX2 
		     nTTotAPEX2 += nTotAPEX2 
             nTTotQTEX2 += nTotQTEX2 
             nTTotMTEX2 += nTotMTEX2
             nTTotPAEX2:= AddHora(nTTotPAEX2,nTotPAEX2)              
		     nTTotDUEX2:= AddHora(nTTotDUEX2,nTotDUEX2)
		     
		     nTTotKGEX3 += nTotKGEX3 
		     nTTotMLEX3 += nTotMLEX3 
		     nTTotAPEX3 += nTotAPEX3 
             nTTotQTEX3 += nTotQTEX3
             nTTotMTEX3 += nTotMTEX3
             nTTotPAEX3:= AddHora(nTTotPAEX3,nTotPAEX3)              
             nTTotDUEX3:= AddHora(nTTotDUEX3,nTotDUEX3)
             
	    //                      
	    If Prow()  > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
           Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  // Impressao do cabecalho
           //Prow() + 2
        Endif	 	
	 	
	    @ Prow() + 2,000 PSAY Repl( "-", 220 )
	    @ Prow()  +1,000 PSAY "TOTAL"
        @ Prow()    ,005 PSAY nTTotOPEX1 Picture "@E 9999"
        // 1 TURNO
        @ Prow()+1  ,000 PSAY '1ª T'
		@ Prow()    ,011 PSAY nTTotKGEX1 Picture "@E 99,999,999.99"
		@ Prow()    ,025 PSAY nTTotMLEX1 Picture "@E 99,999,999.99"
		@ Prow()    ,039 PSAY nTTotAPEX1 Picture "@E 99,999,999.99"
		@ Prow()    ,056 PSAY (nTTotAPEX1 / ( nTTotKGEX1 + nTTotAPEX1 ) ) * 100 Picture "@E 999.99"
        @ Prow()    ,064 PSAY ROUND((nTTotQTEX1/nTTotMTEX1)*100 ,2) Picture "@E 9,999.99"
        @ Prow()    ,074 PSAY   nTTotPAEX1 // parada
	    @ Prow()    ,088 PSAY   Round(Percent(nTTotPAEX1,nTTotDUEX1),2) Picture "@E 999.99"  // %
	         
        // 2 TURNO
		@ Prow()+1  ,000 PSAY '2ª T'
		@ Prow()    ,011 PSAY nTTotKGEX2 Picture "@E 99,999,999.99"
		@ Prow()    ,025 PSAY nTTotMLEX2 Picture "@E 99,999,999.99"
		@ Prow()    ,039 PSAY nTTotAPEX2 Picture "@E 99,999,999.99"
		@ Prow()    ,056 PSAY (nTTotAPEX2 / ( nTTotKGEX2 + nTTotAPEX2 ) ) * 100 Picture "@E 999.99"
        @ Prow()    ,064 PSAY ROUND((nTTotQTEX2/nTTotMTEX2)*100 ,2) Picture "@E 9,999.99"
        @ Prow()    ,074 PSAY   nTTotPAEX2 // parada
	    @ Prow()    ,088 PSAY   Round(Percent(nTTotPAEX2,nTTotDUEX2),2) Picture "@E 999.99"  // %        

        // 3 TURNO 
		@ Prow()+1  ,000 PSAY '3ª T'
		@ Prow()    ,011 PSAY nTTotKGEX3 Picture "@E 99,999,999.99"
		@ Prow()    ,025 PSAY nTTotMLEX3 Picture "@E 99,999,999.99"
		@ Prow()    ,039 PSAY nTTotAPEX3 Picture "@E 99,999,999.99"
		@ Prow()    ,056 PSAY (nTTotAPEX3 / ( nTTotKGEX3 + nTTotAPEX3 ) ) * 100 Picture "@E 999.99"
        @ Prow()    ,064 PSAY ROUND((nTTotQTEX3/nTTotMTEX3)*100 ,2) Picture "@E 9,999.99"
        @ Prow()    ,074 PSAY   nTTotPAEX3 // parada
        @ Prow()    ,088 PSAY   Round(Percent(nTTotPAEX3,nTTotDUEX3),2) Picture "@E 999.99"  // %
        // TOTAL HORIZONTAL 
        @ Prow()+1  ,000 PSAY '-->'
		@ Prow()    ,011 PSAY nTTotKGEX1 + nTTotKGEX2 + nTTotKGEX3 Picture "@E 99,999,999.99"

		@ Prow()    ,025 PSAY nTTotMLEX1 + nTTotMLEX2 + nTTotMLEX3 Picture "@E 99,999,999.99"

		@ Prow()    ,039 PSAY nTTotAPEX1 + nTTotAPEX2 + nTTotAPEX3 Picture "@E 99,999,999.99"

		@ Prow()    ,056 PSAY ((nTTotAPEX1 + nTTotAPEX2 + nTTotAPEX3) / (nTTotKGEX1 + nTTotKGEX2 + nTTotKGEX3 + nTTotAPEX1 + nTTotAPEX2 + nTTotAPEX3) ) * 100 Picture "@E 999.99"
        
        @ Prow()    ,064 PSAY ROUND(((nTTotQTEX1+nTTotQTEX2+nTTotQTEX3)/(nTTotMTEX1+nTotMTEX3+nTTotMTEX3))*100 ,2) Picture "@E 9,999.99"
	    
	    cTotPa:=AddHora(nTTotPAEX1,nTTotPAEX2)
	    cTotPa:=AddHora(cTotPa,nTTotPAEX3)
	         
	    @ Prow()    ,074 PSAY   cTotPa  // parada
        
        cTotDu:=AddHora(nTTotDUEX1,nTTotDUEX2)
	    cTotDu:=AddHora(cTotDu,nTTotDUEX3)
	         
	    @ Prow()    ,088 PSAY   Round(Percent(cTotPa,cTotDu),2) Picture "@E 999.99"  // %
    
    //  
    If Len(aResult3) > 0
       
       Cabec1 := "     QUANT  /----------------- T U R N O   1 ----------------\  /----------------- T U R N O   2 ----------------\  /----------------- T U R N O   3 ----------------\  /------------------- T O T A L ------------------\"
       Cabec2 := "MAQ  PROD.          (KG)          (MR)     APARA(KG)  APARA(%)          (KG)          (MR)     APARA(KG)  APARA(%)          (KG)          (MR)     APARA(KG)  APARA(%)          (KG)          (MR)     APARA(KG)  APARA(%)"

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
       
       Cabec1 := "     QUANT  /----------------- T U R N O   1 ----------------\  /----------------- T U R N O   2 ----------------\  /----------------- T U R N O   3 ----------------\  /------------------- T O T A L ------------------\"
       Cabec2 := "MAQ  PROD.          (KG)          (MR)     APARA(KG)  APARA(%)          (KG)          (MR)     APARA(KG)  APARA(%)          (KG)          (MR)     APARA(KG)  APARA(%)          (KG)          (MR)     APARA(KG)  APARA(%)"

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
    
	EndIf
    //
	If Len(aResultPI) > 0
    
    Cabec1 := "     QUANT  /----------------- T U R N O   1 ----------------\  /----------------- T U R N O   2 ----------------\  /----------------- T U R N O   3 ----------------\  /------------------- T O T A L ------------------\"
    Cabec2 := "MAQ  PROD.          (KG)          (MR)     APARA(KG)  APARA(%)          (KG)          (MR)     APARA(KG)  APARA(%)          (KG)          (MR)     APARA(KG)  APARA(%)          (KG)          (MR)     APARA(KG)  APARA(%)"

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
EndIf
If Len(aResult2) > 0
	
	Cabec1 := "     QUANT  /----------------- T U R N O   1 ----------------\  /----------------- T U R N O   2 ----------------\  /----------------- T U R N O   3 ----------------\  /------------------- T O T A L ------------------\"
    Cabec2 := "MAQ  PROD.          (KG)          (MR)     APARA(KG)  APARA(%)          (KG)          (MR)     APARA(KG)  APARA(%)          (KG)          (MR)     APARA(KG)  APARA(%)          (KG)          (MR)     APARA(KG)  APARA(%)"

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

Static Function GetInterv(cTurnoAtual,cHoraI)

***************

Local aInterv    := {}
Local aRetI:={}


If 	cTurnoAtual = "1"
	aAdd(aInterv, "05:30 - 06:00")    //1
	aAdd(aInterv, "06:00 - 07:00")    //1
    aAdd(aInterv, "07:00 - 08:00")    //2
    aAdd(aInterv, "08:00 - 09:00")    //3
	aAdd(aInterv, "09:00 - 10:00")    //4
 	aAdd(aInterv, "10:00 - 11:00")    //5 Almoco
    aAdd(aInterv, "11:00 - 12:00")    //6 
 	aAdd(aInterv, "12:00 - 13:00")    //7
 	aAdd(aInterv, "13:00 - 13:50")    //8

Elseif cTurnoAtual = "2"

	aAdd(aInterv, "13:50 - 14:00")    //1
	aAdd(aInterv, "14:00 - 15:00")    //1
    aAdd(aInterv, "15:00 - 16:00")    //2
    aAdd(aInterv, "16:00 - 17:00")    //3
	aAdd(aInterv, "17:00 - 18:00")    //4
 	aAdd(aInterv, "18:00 - 19:00")    //5 Jantar
    aAdd(aInterv, "19:00 - 20:00")    //6
 	aAdd(aInterv, "20:00 - 21:00")    //7
 	aAdd(aInterv, "21:00 - 22:00")    //8

Elseif cTurnoAtual = "3"
	
	aAdd(aInterv, "22:01 - 23:00")     //1
	aAdd(aInterv, "23:00 - 24:00")     //2
	aAdd(aInterv, "00:00 - 01:00")     //3
	aAdd(aInterv, "01:00 - 02:00")     //4
	aAdd(aInterv, "02:00 - 03:00")     //5 Refeição
	aAdd(aInterv, "03:00 - 04:00")     //6
	aAdd(aInterv, "04:00 - 05:00")     //7
	aAdd(aInterv, "05:00 - 05:30")     //8
	
Endif

For _fr := 1 to Len(aInterv)		
   If cHoraI >= Substr(aInterv[_fr],1,5) .and. cHoraI <= Substr(aInterv[_fr],9,5)
      	aAdd(aRetI,_fr)
        aAdd(aRetI,TempInter( Substr(aInterv[_fr],9,5)+':00',Substr(aInterv[_fr],1,5)+':00' )  )
      EXIT
   ENDIF   
Next

 
 IF len(aRetI)=0
   ALERT('NAO ACHOU  '+cHoraI+' - '+cTurnoAtual +'- '+ cMaq)
 Endif
 

Return aRetI

**************

Static Function TempInter( _cHora1, _cHora2 )

**************

Local _nHr1,_nMi1,nSg1,_nHr2,_nMi2,nSg2
local _nRs1:=_nRs2:=_nRs3:=0
local _cRes:=''
local Hr,ResHr,Mi,Seg
local cHr:=''
local cRs4:='' 

_nHr1 := Val(  Subst(_cHora1,1,AT(":",_cHora1)-1 )  )*3600     
_nMi1 := Val(  Subst(_cHora1,AT(":",_cHora1)+1,2)  )*60
cRs4:=Subst(_cHora1,AT(":",_cHora1)+1,len(_cHora1))
_nSg1 := Val(  Subst(cRs4,AT(":",cRs4)+1,2 )  ) 

_nHr2 := Val(  Subst(_cHora2,1,AT(":",_cHora2)-1)  )*3600
_nMi2 := Val(  Subst(_cHora2,AT(":",_cHora2)+1,2)  )*60
cRs4:=Subst(_cHora2,AT(":",_cHora2)+1,len(_cHora2))
_nSg2 := Val(   Subst(cRs4,AT(":",cRs4)+1,2 )  )

_nRs1:=_nHr1+_nMi1+_nSg1
_nRs2:=_nHr2+_nMi2+_nSg2

_nRs3:=_nRs1 - _nRs2

if _nRs3<0
  //alert("Hora Desligada > Hora Ligada" )
  Return "########" 
Endif


Return(  _nRs3  )    
 

***************
User Function TemPara(cMaqui,cLadoA,cLadoB,cSta0,cSta1,dDataI,dDataF,lAuto)
***************


//Local nOrdem
Local cQry:=''
local aRet:={}
local cTURNO1:=cTURNO2:=cTURNO3:=''

default lAuto := .F.

if lAuto
   RPCSetType( 3 ) // Não consome licensa de uso
   RpcSetEnv('02','01',,,,GetEnvServer(),{"SF4"})  // atencao para esta linha.
endif   

nDias:= dDataI - dDataF
nDias+=1

cTURNO1   := GetMv( "MV_TURMAQ1" )
cTURNO2   := GetMv( "MV_TURMAQ2" )
cTURNO3   := GetMv( "MV_TURMAQ3" )

nDURACAO1:= valor(nDias,SubStr( cTURNO1, 7, 5)+":00",.F.,.T.)
nDURACAO2:= valor(nDias,SubStr( cTURNO2, 7, 5)+":00",.F.,.F.) 
nDURACAO3:= valor(nDias,SubStr( cTURNO3, 7, 5)+":00",.T.,.F.) 

nHORA1:=Left( cTURNO1, 5 )+ ":00"
nHORA2:=Left( cTURNO2, 5 )+ ":00"
nHORA3:=Left( cTURNO3, 5 )+ ":00"

cQry:="SELECT CAST(CAST(Z58_HORA AS DATETIME) AS FLOAT) Z58_DECIMAL,* "
cQry+="FROM Z58020 Z58 "
cQry+="WHERE  Z58.D_E_L_E_T_!='*' "
cQry+="AND Z58_DATA >= '" + Dtos( dDataI ) + "' AND Z58_DATA <= '" + Dtos( dDataF + 1 ) + "' "

if ! empty(cMaqui)
   cQry+="AND Z58_MAQ='" +cMaqui+ "'  "               	
endif

cQry+="AND Z58_CANAL between '" +cLadoA+ "' and '" +cLadoB+ "' "
cQry+="AND Z58_STATUS between '" +cSta0+ "' and '" +cSta1+ "' "

cQry+="ORDER BY Z58_MAQ,Z58_CANAL,Z58_DATA,Z58_HORA "		
TCQUERY cQry NEW ALIAS "Z58X"

TCSetField( 'Z58X', "Z58_DATA", "D" )

Z58X->( dbGoTop() )

While Z58X->( !EOF() ) 

    cMaq:=Z58X->Z58_MAQ
    cStaAnt:='0'    
    // VARIAVEIS PARA O LADO A 
    nTempLig1A:=nTempLig2A:=nTempLig3A:='00:00:00'//0 
    nTempDes1A:=nTempDes2A:=nTempDes3A:='00:00:00'//0
    // VARIAVEIS PARA O LADO B  
    nTempLig1B:=nTempLig2B:=nTempLig3B:='00:00:00'//0
    nTempDes1B:=nTempDes2B:=nTempDes3B:='00:00:00'//0
    // VARIAVEIS INICIAL DE CADA TURNO
     // Lado A                                               	
     cSI1A:=cSI2A:=cSI3A:=''
     nHI1A:=nHI2A:=nHI3A:='00:00:00'//0
    // Lado B
     cSI1B:=cSI2B:=cSI3B:=''
     nHI1B:=nHI2B:=nHI3B:='00:00:00' //0
     
    // VARIAVEIS FINAL DE CADA TURNO
     // Lado A
     cSF1A:=cSF2A:=cSF3A:=''
     nHF1A:=nHF2A:=nHF3A:='00:00:00' //0
     // Lado B
     cSF1B:=cSF2B:=cSF3B:=''
     nHF1B:=nHF2B:=nHF3B:='00:00:00' //0
     
     // TEMPO TOTAL LIGADO
     nTotTL1A:=nTotTL2A:=nTotTL3A:='00:00:00' //0 
     nTotTL1B:=nTotTL2B:=nTotTL3B:='00:00:00' //0 
     // % 
     nPer1A:=nPer2A:=nPer3A:=0
     nPer1B:=nPerB:=nPer3B:=0
     //variaveis logicas
     lOk1A:=lOk2A:=lOk3A:=.T.
     lOk1B:=lOk2B:=lOk3B:=.T.

    Do While Z58X->( !EOF() ) .AND. Z58X->Z58_MAQ=cMaq
		// 1ª Turno
		If Z58X->Z58_DATA <= dDataF .and. Z58X->Z58_HORA >= Left( cTURNO1, 5 )+ ":00" .and. Z58X->Z58_HORA <= U_Somahora( Left( cTURNO1, 5 ) + ":00", SubStr( cTURNO1, 7, 5 ) + ":00" )
		     
		    If Z58X->Z58_CANAL='0'  // LADO A 
		       If lOk1A
		          If Z58X->Z58_STATUS='0' 	             
		             nTotTL1A:=AddHora(nTotTL1A,TempoLig(Z58X->Z58_HORA,nHORA1))
		             cStaAnt:=Z58X->Z58_STATUS
		             Z58X->(dbSkip()) 
		          else                                          
		             cStaAnt:='0'    
		          endif              
		          lOk1A:=.F.
		       endif   
		       
		       If Z58X->Z58_STATUS='1'  .and.  cStaAnt!=Z58X->Z58_STATUS   // MAQUINA LIGADA
		          nTempLig1A:=Z58X->Z58_HORA
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip()) 
		       endif                           		
		       
		       If  cStaAnt=Z58X->Z58_STATUS 
		           cStaAnt:=Z58X->Z58_STATUS
		           Z58X->(dbSkip())    
		           loop
		       endif
		       
		       If Z58X->Z58_STATUS='0' .and.  cStaAnt!=Z58X->Z58_STATUS // MAQUINA DESLIGADA
		          If Z58X->Z58_HORA>=nHORA2
		             nTempDes1A:=nHORA2
		             nTotTL2A:=AddHora(nTotTL2A,TempoLig(Z58X->Z58_HORA,nHORA2))       
		          Else
		             nTempDes1A:=Z58X->Z58_HORA 
		          Endif
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip())
		       endif
		       
		       nTotTL1A:= AddHora(nTotTL1A,TempoLig(nTempDes1A,nTempLig1A))                     

		    
		    elseif Z58X->Z58_CANAL='1' // LADO B
		       If lOk1B
		          If Z58X->Z58_STATUS='0' 
		             nTotTL1B:= AddHora(nTotTL1B,TempoLig(Z58X->Z58_HORA,nHORA1))
		             cStaAnt:=Z58X->Z58_STATUS
		             Z58X->(dbSkip()) 
		          Else
		             cStaAnt:='0'
		          endif
		          lOk1B:=.F.
		       endif   
		       
		       If Z58X->Z58_STATUS='1' .AND. cStaAnt!=Z58X->Z58_STATUS // MAQUINA LIGADA
		          nTempLig1B:=Z58X->Z58_HORA
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip()) 
		       endif
		       
		       If  cStaAnt=Z58X->Z58_STATUS 
		           cStaAnt:=Z58X->Z58_STATUS
		           Z58X->(dbSkip())    
		           loop
		       endif
		       
		       If Z58X->Z58_STATUS='0' .AND. cStaAnt!=Z58X->Z58_STATUS // MAQUINA DESLIGADA
		          If Z58X->Z58_HORA>=nHORA2
		             nTempDes1B:=nHORA2
		             nTotTL2B:=AddHora(nTotTL2B,TempoLig(Z58X->Z58_HORA,nHORA2))       
		          Else
		             nTempDes1B:=Z58X->Z58_HORA 
		          Endif
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip())
		       endif
		       
		       nTotTL1B:= AddHora(nTotTL1B,TempoLig(nTempDes1B,nTempLig1B))                     
		       
		    Endif
		    		
		// 2ª truno
		
		elseIf Z58X->Z58_DATA <= dDataF .and. Z58X->Z58_HORA >= Left( cTURNO2, 5 )+ ":00"  .and. Z58X->Z58_HORA <= U_Somahora( Left( cTURNO2, 5 ) + ":00", SubStr( cTURNO2, 7, 5 ) + ":00" )
            

		    If Z58X->Z58_CANAL='0' // LADO A 
		    
		       If Z58X->Z58_STATUS='1' .AND. cStaAnt!=Z58X->Z58_STATUS // MAQUINA LIGADA
		          nTempLig2A:=Z58X->Z58_HORA
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip()) 
		       endif
		       
		       If  cStaAnt=Z58X->Z58_STATUS 
		           cStaAnt:=Z58X->Z58_STATUS
		           Z58X->(dbSkip())    
		           loop
		       endif
		       
		       If Z58X->Z58_STATUS='0' .AND. cStaAnt!=Z58X->Z58_STATUS // MAQUINA DESLIGADA
		          If Z58X->Z58_HORA>=nHORA3
		             nTempDes2A:=nHORA3
		             nTotTL3A:=AddHora(nTotTL3A,TempoLig(Z58X->Z58_HORA,nHORA3))       
		          Else
		             nTempDes2A:=Z58X->Z58_HORA 
		          Endif
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip())
		       endif
		       
		       nTotTL2A:= AddHora(nTotTL2A,TempoLig(nTempDes2A,nTempLig2A))                     
		       
		    elseif Z58X->Z58_CANAL='1' // LADO B
		       
		       
		       If Z58X->Z58_STATUS='1' .AND. cStaAnt!=Z58X->Z58_STATUS// MAQUINA LIGADA
		          nTempLig2B:=Z58X->Z58_HORA
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip()) 
		       endif
		       
		       If  cStaAnt=Z58X->Z58_STATUS 
		           cStaAnt:=Z58X->Z58_STATUS
		           Z58X->(dbSkip())    
		           loop
		       endif
		       
		       If Z58X->Z58_STATUS='0' .AND. cStaAnt!=Z58X->Z58_STATUS// MAQUINA DESLIGADA
		          If Z58X->Z58_HORA>=nHORA3
		             nTempDes2B:=nHORA3
		             nTotTL3B:=AddHora(nTotTL3B,TempoLig(Z58X->Z58_HORA,nHORA3))       
		          Else
		             nTempDes2B:=Z58X->Z58_HORA 
		          Endif
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip())
		       endif
		       
		       nTotTL2B:= AddHora(nTotTL2B,TempoLig(nTempDes2B,nTempLig2B))                     
    		    		    
		    Endif
		    		    
		// 3ª turno
		
		elseIf ( Z58X->Z58_DATA <= dDataF .and. Z58X->Z58_HORA >= Left( cTURNO3, 5 ) + ":00" ) .or. ;
		 			 ( Z58X->Z58_DATA >= dDataI + 1 .and. Z58X->Z58_HORA <=U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( cTURNO3, 7, 5 ) + ":00" ) )
            		    
		    If Z58X->Z58_CANAL='0' // LADO A 
		       	       
		       If Z58X->Z58_STATUS='1' .AND. cStaAnt!=Z58X->Z58_STATUS // MAQUINA LIGADA
		          cDtLig3A:=Z58X->Z58_DATA
		          nTempLig3A:=Z58X->Z58_HORA
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip()) 
		       endif
		       
		       If  cStaAnt=Z58X->Z58_STATUS 
		           cStaAnt:=Z58X->Z58_STATUS
		           Z58X->(dbSkip())    
		           loop
		       endif
		       
		       If Z58X->Z58_STATUS='0' .AND. cStaAnt!=Z58X->Z58_STATUS// MAQUINA DESLIGADA
		          cDtDesl3A:=Z58X->Z58_DATA
		          If Z58X->Z58_HORA>=nHORA1 .AND. cDtLig3A!=cDtDesl3A
		             nTempDes3A:=nHORA1      
		          Else
		             nTempDes3A:=Z58X->Z58_HORA 
		          Endif
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip())
		       endif
			   
			   If cDtLig3A!=cDtDesl3A
			      if cDtLig3A<cDtDesl3A
				     cRes24:=AddHora(TempoLig('23:59:59',nTempLig3A),TempoLig(nTempDes3A,'00:00:00'))
			         nTotTL3A:=AddHora(nTotTL3A,AddHora(cRes24,'00:00:01'))
	              Else	
	 			     cRes24:=AddHora(TempoLig('23:59:59',nTempDes3A),TempoLig(nTempLig3A,'00:00:00'))
			         nTotTL3A:= AddHora(nTotTL3A,AddHora(cRes24,'00:00:01'))
				  EndIf		       
				Else
			         nTotTL3A:= AddHora(nTotTL3A,TempoLig(nTempDes3A,nTempLig3A))
	            Endif
                  		       		       
		    elseif Z58X->Z58_CANAL='1' // LADO B
		       
		       If Z58X->Z58_STATUS='1' .AND. cStaAnt!=Z58X->Z58_STATUS// MAQUINA LIGADA
		          cDtLig3B:=Z58_DATA
		          nTempLig3B:=Z58X->Z58_HORA
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip()) 
		       endif
		       
		       If  cStaAnt=Z58X->Z58_STATUS 
		           cStaAnt:=Z58X->Z58_STATUS
		           Z58X->(dbSkip())    
		           loop
		       endif
		       
		       If Z58X->Z58_STATUS='0' .AND. cStaAnt!=Z58X->Z58_STATUS// MAQUINA DESLIGADA
		          cDtDesl3B:=Z58_DATA
		          If Z58X->Z58_HORA>=nHORA1 .AND. cDtLig3B!=cDtDesl3B
		             nTempDes3B:=nHORA1     
		          Else
		             nTempDes3B:=Z58X->Z58_HORA 
		          Endif
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip())
		       endif
		       
		       If cDtLig3B!=cDtDesl3B
			      if cDtLig3B<cDtDesl3B
				     cRes24:=AddHora(TempoLig('23:59:59',nTempLig3B),TempoLig(nTempDes3B,'00:00:00'))
			         nTotTL3B:= AddHora(nTotTL3B,AddHora(cRes24,'00:00:01'))                     
	               Else	
	 			     cRes24:=AddHora(TempoLig('23:59:59',nTempDes3B),TempoLig(nTempLig3B,'00:00:00'))
			         nTotTL3B:= AddHora(nTotTL3B,AddHora(cRes24,'00:00:01'))                     
				  EndIf		       
			   Else
			         nTotTL3B:= AddHora(nTotTL3B,TempoLig(nTempDes3B,nTempLig3B))                     		       		             		    
		       Endif
		    endif   	    
		else
	        Z58X->(dbSkip()) // Avanca o ponteiro do registro no arquivo
        endif    

    EndDo
    
   //Lado A                               
   //1º turno
   nPer1A:= Percent(nTotTL1A,nDURACAO1)
   //2º turno 
   nPer2A:=Percent(nTotTL2A,nDURACAO2)
   //3º turno  
   nPer3A:=Percent(nTotTL3A,nDURACAO3)
   
   //Lado B                                                              
   //1º turno 
   nPer1B:= Percent(nTotTL1B,nDURACAO1)
   //2º turno 
   nPer2B:=Percent(nTotTL2B,nDURACAO2)
   //3º turno   
   nPer3B:=Percent(nTotTL3B,nDURACAO3)
   
//--------------------------------------------------------  
// total 1 TURNO
   
   // DURACAO
   cTotHD1:=AddHora(nDURACAO1,iif(SUBSTR(cMaq,1,2)!='P0',nDURACAO1,"00:00:00"))  
   // TEMPO LIGADO
   cTotHL1:=AddHora(nTotTL1A,nTotTL1B)  
   // % ligado
   cTotHP1:=Percent(cTotHL1,cTotHD1)
   // desligada
   cDes1:=TempoLig(cTotHD1,cTotHL1)
   // % desligado
   cPdes1:=Percent(cDes1,cTotHD1)

// total 2 TURNO
   // DURACAO
   cTotHD2:=AddHora(nDURACAO2,iif(SUBSTR(cMaq,1,2)!='P0',nDURACAO2,"00:00:00"))  
   // LIGADA
   cTotHL2:=AddHora(nTotTL2A,nTotTL2B)  
   // % ligado
   cTotHP2:=Percent(cTotHL2,cTotHD2)
   // desligada
   cDes2:=TempoLig(cTotHD2,cTotHL2)
   // % desligado
   cPdes2:=Percent(cDes2,cTotHD2)

// total 3 TURNO
   // DURACAO
   cTotHD3:=AddHora(nDURACAO3,iif(SUBSTR(cMaq,1,2)!='P0',nDURACAO3,"00:00:00"))  
   // LIGADA
   cTotHL3:=AddHora(nTotTL3A,nTotTL3B)  
   // %
   cTotHP3:=Percent(cTotHL3,cTotHD3) 
   // desligada
   cDes3:=TempoLig(cTotHD3,cTotHL3)
   // % desligado
   cPdes3:=Percent(cDes3,cTotHD3)

 
 AADD(aRet,{nDURACAO1,nDURACAO2,nDURACAO3,nTotTL1A,nPer1A,nTotTL2A,nPer2A,nTotTL3A,nPer3A, ;
              nTotTL1B,nPer1B,nTotTL2B,nPer2B,nTotTL3B,nPer3B,cDes1,cPDes1,cDes2,cPDes2,cDes3,cPDes3,cTotHD1,cTotHD2,cTotHD3} )

 EndDo

Z58X->(DBCLOSEAREA())

if lAuto
   RpcClearEnv() // Libera o Environment
   DbCLoseAll()
endif   


Return aRet


**************

Static Function valor( nValor,_cHora,lTurno3,lTurno1 )

**************
Local _nHr1,_nMi1,nSg1,_nHr2,_nMi2,nSg2
local _nRs1:=_nRs2:=_nRs3:=0
local _cRes:=''
local Hr,ResHr,Mi,Seg
local cHr:=''
local cRs4:='' 

_nHr1 := Val(  Subst(_cHora,1,AT(":",_cHora)-1 )  )*3600  - 3600   
_nMi1 := Val(  Subst(_cHora,AT(":",_cHora)+1,2)  )*60 - IIF(lTurno3,10*60,0) -IIF(lTurno1,20*60,0)
cRs4:=Subst(_cHora,AT(":",_cHora)+1,len(_cHora))
_nSg1 := Val(  Subst(cRs4,AT(":",cRs4)+1,2 )  ) 


_nRs1:=_nHr1+_nMi1+_nSg1


_nRs3:=_nRs1*nValor 

Hr:=int(_nRs3/3600)
ResHr:=_nRs3%3600
Mi:=int(ResHr/60)
Seg:=ResHr%60

If Hr >99
cHr:=alltrim(str(Hr))
else
cHr:=StrZero(Hr,2)
EndIf


_cRes :=  cHr +":"+StrZero(Mi,2)+":"+StrZero(Seg,2)

/*
Local _nHr1,_nMi1,nSg1,_nRs1,_nRs2,_nRs3,_cRes

_nHr1 := Val(  Subst(_cHora,1,2)  )-1 
_nMi1 := Val(  Subst(_cHora,4,2)  )- IIF(lTurno3,10,0) -IIF(lTurno1,20,0)
_nSg1 := Val(  Subst(_cHora,7,2)  )

_nRs3 := _nSg1*nValor 
If _nRs3 >= 60
	_nRs3 := _nRs3 - 60
	_nMi1++
EndIf

_nRs2 := _nMi1*nValor 
If _nRs2 >= 60
	_nRs2 := _nRs2 - 60
	_nHr1++
EndIf

_nRs1 := _nHr1*nValor 
If _nRs1 >= 24
	_nRs1 := _nRs1 
EndIf
_cRes := StrZero(_nRs1,2)+":"+StrZero(_nRs2,2)+":"+StrZero(_nRs3,2)
*/
Return(  _cRes  )


**************

Static Function TempoLig( _cHora1, _cHora2 )

**************

Local _nHr1,_nMi1,nSg1,_nHr2,_nMi2,nSg2
local _nRs1:=_nRs2:=_nRs3:=0
local _cRes:=''
local Hr,ResHr,Mi,Seg
local cHr:=''
local cRs4:='' 

_nHr1 := Val(  Subst(_cHora1,1,AT(":",_cHora1)-1 )  )*3600     
_nMi1 := Val(  Subst(_cHora1,AT(":",_cHora1)+1,2)  )*60
cRs4:=Subst(_cHora1,AT(":",_cHora1)+1,len(_cHora1))
_nSg1 := Val(  Subst(cRs4,AT(":",cRs4)+1,2 )  ) 

_nHr2 := Val(  Subst(_cHora2,1,AT(":",_cHora2)-1)  )*3600
_nMi2 := Val(  Subst(_cHora2,AT(":",_cHora2)+1,2)  )*60
cRs4:=Subst(_cHora2,AT(":",_cHora2)+1,len(_cHora2))
_nSg2 := Val(   Subst(cRs4,AT(":",cRs4)+1,2 )  )

_nRs1:=_nHr1+_nMi1+_nSg1
_nRs2:=_nHr2+_nMi2+_nSg2

_nRs3:=_nRs1 - _nRs2

if _nRs3<0
  //alert("Hora Desligada > Hora Ligada" )
  Return "########" 
Endif


Hr:=int(_nRs3/3600)
ResHr:=_nRs3%3600
Mi:=int(ResHr/60)
Seg:=ResHr%60

If Hr >99
cHr:=alltrim(str(Hr)	)
else
cHr:=StrZero(Hr,2)
EndIf


_cRes :=  cHr +":"+StrZero(Mi,2)+":"+StrZero(Seg,2)

Return(  _cRes  )    


**************

Static Function AddHora( _cHora1, _cHora2 )

**************

Local _nHr1,_nMi1,nSg1,_nHr2,_nMi2,nSg2
local _nRs1:=_nRs2:=_nRs3:=0
local _cRes:=''
local Hr,ResHr,Mi,Seg
local cHr:=''
local cRs4:='' 

_nHr1 := Val(  Subst(_cHora1,1,AT(":",_cHora1)-1 )  )*3600     
_nMi1 := Val(  Subst(_cHora1,AT(":",_cHora1)+1,2)  )*60
cRs4:=Subst(_cHora1,AT(":",_cHora1)+1,len(_cHora1))
_nSg1 := Val(  Subst(cRs4,AT(":",cRs4)+1,2 )  ) 

_nHr2 := Val(  Subst(_cHora2,1,AT(":",_cHora2)-1)  )*3600
_nMi2 := Val(  Subst(_cHora2,AT(":",_cHora2)+1,2)  )*60
cRs4:=Subst(_cHora2,AT(":",_cHora2)+1,len(_cHora2))
_nSg2 := Val(   Subst(cRs4,AT(":",cRs4)+1,2 )  )

_nRs1:=_nHr1+_nMi1+_nSg1
_nRs2:=_nHr2+_nMi2+_nSg2

_nRs3:=_nRs1+_nRs2

Hr:=int(_nRs3/3600)
ResHr:=_nRs3%3600
Mi:=int(ResHr/60)
Seg:=ResHr%60

If Hr >99
cHr:=alltrim(str(Hr))
else
cHr:=StrZero(Hr,2)
EndIf


_cRes :=  cHr +":"+StrZero(Mi,2)+":"+StrZero(Seg,2)

Return(  _cRes  )


**************

Static Function Percent( _cHora1, _cHora2 )

**************

Local _nHr1,_nMi1,nSg1,_nHr2,_nMi2,nSg2,_nRs1,_nRs2,_cRes

local cRs4:='' 

_nHr1 := Val(  Subst(_cHora1,1,AT(":",_cHora1)-1 )  )*3600     
_nMi1 := Val(  Subst(_cHora1,AT(":",_cHora1)+1,2)  )*60
cRs4:=Subst(_cHora1,AT(":",_cHora1)+1,len(_cHora1))
_nSg1 := Val(  Subst(cRs4,AT(":",cRs4)+1,2 )  ) 

_nHr2 := Val(  Subst(_cHora2,1,AT(":",_cHora2)-1)  )*3600
_nMi2 := Val(  Subst(_cHora2,AT(":",_cHora2)+1,2)  )*60
cRs4:=Subst(_cHora2,AT(":",_cHora2)+1,len(_cHora2))
_nSg2 := Val(   Subst(cRs4,AT(":",cRs4)+1,2 )  )


_nRs1:=_nHr1+_nMi1+_nSg1
_nRs2:=_nHr2+_nMi2+_nSg2

_cRes:=(_nRs1/_nRs2)*100


Return(  _cRes  )
