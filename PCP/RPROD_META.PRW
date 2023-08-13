#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#include "topconn.ch"       // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#include "protheus.ch"

//----------------------------------------------------------------
//Programa: RPRODMT
//Objetivo: Emitir relatório do que foi produzido x meta
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 15/09/09
//-----------------------------------------------------------------

User Function RPRODMT()

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
titulo    := "PRODUCAO x META"
cDesc1    := "Este programa ira emitir o relatorio "
cDesc2    := "de producao em relacao a meta, "
cDesc3    := "por maquina e turno."
cNatureza := ""
aReturn   := { "Producao", 1, "Administracao", 1, 2, 1, "", 1 }
nomeprog  := "RPRODMT"
cPerg     := "RPRODMT"
nLastKey  := 0
lContinua := .T.
nLin      := 9
wnrel     := "RPRODMT"
M_PAG     := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Validperg()
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

RptStatus({|| RptDetail()})  // Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
Return



//------------------------------
Static Function RptDetail()     
//------------------------------

Local dDIA := ""

//Parâmetros:
//--------------------------
// mv_par01 - Data de
// mv_par02 - Data até
//--------------------------

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa  de variaveis                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//cTurnoAtu := GetTurno()          //FR: Obtém o turno atual que será usado para mostrar os apontamentos

cTURNO1   := GetMv( "MV_TURNO1" )
cTURNO2   := GetMv( "MV_TURNO2" )
cTURNO3   := GetMv( "MV_TURNO3" )
cTURNO1_A := Left( U_Somahora( Left( cTURNO1, 5 ) + ":00", "00:15:00" ), 5 ) + "," + SubStr( cTURNO1, 7, 5 )  // Soma 15 minutos p/ apara
cTURNO2_A := Left( U_Somahora( Left( cTURNO2, 5 ) + ":00", "00:15:00" ), 5 ) + "," + SubStr( cTURNO2, 7, 5 )
cTURNO3_A := Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", "00:15:00" ), 5 ) + "," + SubStr( cTURNO3, 7, 5 )

dDIA := If( Time() < Left( cTURNO1, 5 ) + ":00", Date() - 1, Date() )

//novo: ESTIMADO(MR) REAL(MR) DIFERENCA(MR) APARA(%)

Cabec1 := "     QUANT  /----------------- T U R N O   1 -----------------------\/----------------- T U R N O   2 ------------------------\ /----------------- T U R N O   3 ----------------------\ "
Cabec2 := "MAQ  PROD.    ESTIMADO(MR)      REAL(MR)   DIFERENÇA(MR)    APARA(%)   ESTIMADO(MR)       REAL(MR)   DIFERENÇA(MR)    APARA(%)    ESTIMADO(MR)     REAL(MR)  DIFERENÇA(MR)     APARA(%)  " 
Cabec3 := "     PROD.    ESTIMADO(MR)      REAL(MR)   DIFERENÇA(MR)    APARA(%)   ESTIMADO(MR)       REAL(MR)   DIFERENÇA(MR)    APARA(%)    ESTIMADO(MR)     REAL(MR)  DIFERENÇA(MR)     APARA(%)  "

//         XXX  9999   99,999,999.99  99,999,999.99  99,999,999.99     999.99    99,999,999.99  99,999,999.99  99,999,999.99      999.99  99,999,999.99  99,999,999.99  99,999,999.99      999.99  
//         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//         0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        	    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa  regua de impressao                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQuery := "SELECT Z00.Z00_CODIGO,Z00.Z00_OP,Z00.Z00_MAQ,Z00.Z00_PESO " 
cQuery += " ,Z00_APARA,Z00.Z00_DATA,Z00.Z00_HORA,Z00.Z00_QUANT " 
cQuery += " ,Z00.Z00_PESCAP,Z00.Z00_PESDIF " 
cQuery += " FROM " + RetSqlName( "Z00" ) + " Z00 " 
cQuery += " WHERE Z00.Z00_DATA >= '" + Dtos( mv_par01 ) + "' AND Z00.Z00_DATA <= '" + Dtos( mv_par02 + 1 ) + "' " 
cQuery += " AND Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' " 
cQuery += " AND Z00.D_E_L_E_T_ !='*' " 
cQuery += " AND Z00.Z00_MAQ!='XXX' "  
cQuery += " AND Z00.Z00_OP != '' "
cQuery += " AND Z00.Z00_CODIGO != '' "
//cQuery += " AND Z00.Z00_MAQ IN ('C06') "  
cQuery += " ORDER BY Z00.Z00_MAQ,Z00.Z00_OP,Z00.Z00_DATA,Z00.Z00_HORA "  

cQuery := ChangeQuery( cQuery )
//MemoWrite("C:\RPROD1.sql", cQuery)

If Select("Z00X") > 0
	DbSelectArea("Z00X")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "Z00X"
TCSetField( 'Z00X', "Z00_DATA", "D" )



nTQTDMR1   := nTQTDMR2   := nTQTDMR3   := 0
nTAPARA1   := nTAPARA2   := nTAPARA3   := 0
nTQTDMR1_2 := nTQTDMR2_2 := nTQTDMR3_2 := 0
nTAPARA1_2 := nTAPARA2_2 := nTAPARA3_2 := 0

nMeta1	   := nMeta2     := nMeta3     := 0
nTotMeta1  := nTotMeta2  := nTotMeta3  := 0
cOPZB0     := ""
lExistZB0  := .F.
cFrase1:= "Turno 1 - Não existe registro de operação - tabela ZB0"
cFrase2:= "Turno 2 - Não existe registro de operação - tabela ZB0"
cFrase3:= "Turno 3 - Não existe registro de operação - tabela ZB0"
		 

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
 	aOPa    := {}
 	nOP     := 0
	ntop	:= 0

	nMeta1	   	:= nMeta2    := nMeta3   := 0
	cHoraIni1  	:= cHoraIni2 := cHoraIni3 := ""
	cHoraFim1   := cHoraFim2 := cHoraFim3 := ""
	nB5HORA1  	:= nB5HORA2 := nB5HORA3 := 0 
    cOPZB0    	:= ""
    lExistZB0 	:= .F.
    nTempoOper1 := nTempoOper2 := nTempoOper3 := 0
    
 	Do While ! Z00X->( Eof() ) .and. Z00X->Z00_MAQ == cMAQ 
 		
 		lOP := .F.
 		cOPZB0 := Substr(Z00X->Z00_OP,1,6)
 		lExistZB0 := .F. 		
 	
	 		DbselectArea("Z00X")
	 		If Z00X->Z00_APARA == " " //se nao produzir apara
	 			If      ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) >= ( DtoS(mv_par01) + Left( cTURNO1, 5 ) ) ;
	 			  .and. ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) <= ( DtoS(mv_par02) + "13:55:00" )
	                
	                lExistZB0 := fExistZB0( cMAQ, cOPZB0, "1")
	 			 	If lExistZB0
	 			 		nQTDMR1  += Z00X->Z00_QUANT / 1000 		//REAL(MR) 			 				 	
	 					lOP := .T.
	 			    Endif	 			    
	 			
	 			ElseIf  ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) >= ( DtoS(mv_par01) + Left( cTURNO2, 5 ) ) ;
	 			  .and. ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) <= ( DtoS(mv_par02) + "22:00:00" )
	 			 	
	 			 	lExistZB0 := fExistZB0( cMAQ, cOPZB0, "2")
	 			 	If lExistZB0
	 			 		nQTDMR2  += Z00X->Z00_QUANT / 1000 	  //REAL(MR)		 	
	 					lOP := .T.
	 				Endif	 				
	 			
	 			ElseIf  ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) >=  ( DtoS(mv_par01) + Left( cTURNO3, 5 ) ) ;
	 			  .and. ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) <=  ( DtoS(mv_par02 + 1) + "05:30:00" )
	 			 	
	 			 	lExistZB0 := fExistZB0( cMAQ, cOPZB0, "3")
	 			 	If lExistZB0
	 			 		nQTDMR3  += Z00X->Z00_QUANT / 1000 	//REAL(MR)			 
	 					lOP := .T.
	 				Endif
	 				
	 			EndIf		
	 				
	 			
	        ElseIf Alltrim(Z00X->Z00_APARA) # "" //"12" //checa se apara possui 1 ou 2, caso produza refugo	 			
	 			If      ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) >= ( DtoS(mv_par01) + Left( cTURNO1, 5 )) ;
	 			  .and. ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) <= ( DtoS(mv_par02) + "13:55:00" )
	 				nAPARA1  += Z00X->Z00_PESO
	 				nTAPARA1 += Z00X->Z00_PESO
	 			
	 			ElseIf ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) >= ( DtoS(mv_par01) + Left( cTURNO2, 5 ) ) ;
	 			 .and. ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) <= ( DtoS(mv_par02) + "22:00:00" )
	 				nAPARA2  += Z00X->Z00_PESO
	 				nTAPARA2 += Z00X->Z00_PESO
	 		
	 			ElseIf  ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) >= ( DtoS(mv_par01) + Left( cTURNO3, 5 ) ) ;
	 			  .and. ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) <= ( DtoS(mv_par02 + 1 ) + "05:30:00" )
	 				nAPARA3  += Z00X->Z00_PESO
	 				nTAPARA3 += Z00X->Z00_PESO
	 			EndIf
	 		EndIf
 		
 			If lOP .and. Ascan( aOP, Z00X->Z00_OP ) == 0   //caso nao haja correspondencia no array
 		 		Aadd( aOP, Z00X->Z00_OP )	
 		 		Aadd( aOPa, { Z00X->Z00_MAQ, Z00X->Z00_OP, Z00X->Z00_DATA, Z00X->Z00_HORA, Z00X->Z00_CODIGO } )
 		 		nTOP++
				nOP++
 			EndIf  		
 		
 		Dbselectarea("Z00X")
 		Z00X->( DbSkip() )
 	 	IncRegua()
 	EndDo
    

	For fr := 1 to Len(aOPa)
		//CALCULA O TEMPO DE OPERAÇÃO DA MÁQUINA E O ESTIMADO(MR)			
		DbselectArea("SB5")
 		SB5->( Dbsetorder(1) )
 		SB5->( Dbseek( xFilial( "SB5" ) + aOPa[fr,5] ) )
 		
					 	
		 	nB5HORA1   := ( SB5->B5_PRDHORA * 2)
		 	cHoraIni1  := fPegaHoraI(cMAQ,"1",Substr(aOPa[fr,2],1,6) )   //MAQUINA, TURNO , OP		 		
		 	cHoraFim1   := fPegaHoraF(cMAQ,"1",Substr(aOPa[fr,2],1,6) )
		 	
		 	If ( cHoraIni1 != "X" .and. cHoraFim1 != "X" )
		 		nTempoOper1 := fDifData( mv_par01,mv_par02,cHoraIni1,cHoraFim1) 			 	
		 		nMeta1      += (nB5HORA1 * nTempoOper1)		 			
		 	Else
		 		nMeta1		+= nMeta1
		 	Endif
		    //------------
		    
		    nB5HORA2     := ( SB5->B5_PRDHORA * 2)	
		   	cHoraIni2    := fPegaHoraI(cMAQ,"2",Substr(aOPa[fr,2],1,6) )	//MAQUINA , TURNO , OP		 	
		 	cHoraFim2    := fPegaHoraF(cMAQ,"2",Substr(aOPa[fr,2],1,6) )
		 	
		 	If ( cHoraIni2 != "X" .and. cHoraFim2 != "X" )
		 		nTempoOper2  := fDifData( mv_par01,mv_par02,cHoraIni2,cHoraFim2) 			 	
		 		nMeta2       += (nB5HORA2 * nTempoOper2)		 		
		 	Else
		 		nMeta2 		+= nMeta2
		 	Endif
		    //-------------
		 			 
			nB5HORA3    := ( SB5->B5_PRDHORA * 2)
			cHoraIni3   := fPegaHoraI(cMAQ,"3",Substr(aOPa[fr,2],1,6) )		 	
			cHoraFim3   := fPegaHoraF(cMAQ,"3",Substr(aOPa[fr,2],1,6) )
			
			If ( cHoraIni3 != "X" .and. cHoraFim3 != "X" )
				nTempoOper3 := fDifData( mv_par01,mv_par02,cHoraIni3,cHoraFim3) 			 	
				nMeta3      += (nB5HORA3 * nTempoOper3 )				
			Else
				nMeta3		+= nMeta3
			Endif
		 	
		 	//------------		 

    Next fr
 
 	
	IF Alltrim(cMAQ) $ "E01/E02/E03/E04 "
											  
		Aadd (aResultPI, {cMAQ,;  		//1
						  nOP,;		  	//2			  
		  				  nQTDMR1,;      //3
		  				  nAPARA1,;      //4
		  				  nQTDMR2,;      //5
						  nAPARA2,;      //6
						  nQTDMR3,;      //7
						  nAPARA3,;      //8
						  nTOP,;         //9
						  nMeta1,;       //10
						  nMeta2,;       //11
						  nMeta3} )     //12
						   																				  
	ElseIF Alltrim(cMAQ) $ "I01/I02"
			
		Aadd (aResult3, {cMAQ,;  			//1
					 nOP,;		 	 	//2			  
		  			 nQTDMR1,;      	//3
		  		     nAPARA1,;      	//4
		  			 nQTDMR2,;      	//5
					 nAPARA2,;      	//6
					 nQTDMR3,;     		//7
					 nAPARA3,;      	//8
					 nTOP,;         	//9
					 nMeta1,;       	//10
					 nMeta2,;       	//11
					 nMeta3} )     		//12
						  											
	ElseIF Alltrim(cMAQ) $ "CX/ICVR/MONT/CVP/PLAST "
	    		
		Aadd (aResult4, {cMAQ,;  		//1
						 nOP,;		  	//2			  
		  				 nQTDMR1,;      //3
		  				 nAPARA1,;      //4
		  				 nQTDMR2,;      //5
						 nAPARA2,;      //6
						 nQTDMR3,;      //7
						 nAPARA3,;      //8
						 nTOP,;         //9
						 nMeta1,;       //10
						 nMeta2,;       //11
						 nMeta3} ) 	    //12
	Else

		Aadd (aResult, {cMAQ,;  		//1
						nOP,;		  	//2			  
		  				nQTDMR1,;    	//3
		  				nAPARA1,;      	//4
		  				nQTDMR2,;      	//5
						nAPARA2,;      	//6
						nQTDMR3,;      	//7
						nAPARA3,;      	//8
						nTOP,;         	//9
						nMeta1,;       	//10
						nMeta2,;       	//11
						nMeta3} )     	//12
	Endif

/*Novo a partir daqui*/

 ElseIf !EMPTY(Z00X->Z00_MAQ) .AND. (alltrim(Z00X->Z00_MAQ) $ 'EXT/COST')
  	
  
  	cMaq_2    := Z00X->Z00_MAQ 	
 	nQTDMR1_2 := nQTDMR2_2 := nQTDMR3_2 := 0
 	nAPARA1_2 := nAPARA2_2 := nAPARA3_2 := 0
 	aOP_2     := {}
 	aOPb      := {}
 	nOP_2     := 0
	ntop_2	  := 0
	
	nMeta1_2    := nMeta2_2    := nMeta3_2      := 0
	cHoraIni1   := cHoraIni2   := cHoraIni3     := ""
	cHoraFim1   := cHoraFim2   := cHoraIni3     := ""
	nTempoOper1 := nTempoOper2 := nTempoOper3   := 0
	cOPZB0      := ""
	
	nB5HORA1a := nB5HORA2a := nB5HORA3a := 0
	lExistZB0 := .F.

 	Do While ! Z00X->( Eof() ) .and. Z00X->Z00_MAQ == cMaq_2
 	
 		cOPZB0 := Substr(Z00X->Z00_OP,1,6) 		
 		lExistZB0 := .F.
 						
 			DbselectArea("Z00X")
	 		lOP := .F.
	 		If Z00X->Z00_APARA == " " //se nao produzir apara	 			
	 			If      ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) >= ( DtoS(mv_par01) + Left( cTURNO1, 5 ) ) ;
	 			  .and. ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) <= ( DtoS(mv_par02) + "13:55:00" ) 
	
	 			 	lExistZB0 := fExistZB0( cMAQ, cOPZB0, "1")
	 			 	If lExistZB0
	 			 		nQTDMR1_2  += Z00X->Z00_QUANT / 1000		//REAL(MR) 			 				 	
	 					lOP := .T.                         
	 				Endif	 				
	 			
	 			ElseIf  ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) >= ( DtoS(mv_par01) + Left( cTURNO2, 5 ) ) ;
	 			  .and. ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) <= ( DtoS(mv_par02) + "22:00:00" )
	 			 	
	 			 	lExistZB0 := fExistZB0( cMAQ, cOPZB0, "2")
	 			 	If lExistZB0
	 			 		nQTDMR2_2  += Z00X->Z00_QUANT  / 1000 		//REAL(MR)			 	 			 				 	
	 					lOP := .T.                         
	 				Endif	 				
	 		
	 			ElseIf  ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) >= ( DtoS(mv_par01) + Left( cTURNO3, 5 ) );
	 			  .and. ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) <= ( DtoS(mv_par02 + 1 ) + "05:30:00" )
	 			 	
	 			 	lExistZB0 := fExistZB0( cMAQ, cOPZB0, "3")
	 			 	If lExistZB0
	 			 		nQTDMR3_2  += Z00X->Z00_QUANT  / 1000 		//REAL(MR)			 				 	
	 					lOP := .T.                         
	 				Endif
	 				
	 			EndIf
	        ElseIf Alltrim(Z00X->Z00_APARA) # "" //"12" //checa se apara possui 1 ou 2, caso produza refugo	 			
	 			If     ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) >= ( DtoS(mv_par01) + Left( cTURNO1_A, 5 ) );
	 			 .and. ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) <= ( DtoS(mv_par02) + "13:55:00" )
	 				nAPARA1_2  += Z00X->Z00_PESO 	 			
	 		
	 			ElseIf ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) >= ( DtoS(mv_par01) + Left( cTURNO2_A, 5 ) ) ;
	 			 .and. ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) <= ( DtoS(mv_par02) + "22:00:00" )
	 				nAPARA2_2  += Z00X->Z00_PESO 	 			
	 		
	 			ElseIf ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) >= ( DtoS(mv_par01) + Left( cTURNO3_A, 5 ) ) ;
	 			 .and. ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) <= ( DtoS(mv_par02 + 1 ) + "05:30:00" )
	 				nAPARA3_2  += Z00X->Z00_PESO 				
	 			
	 			EndIf
	 		EndIf
	 		If lOP .and. Ascan( aOP_2, Z00X->Z00_OP ) == 0   //caso nao haja correspondeica no array
	 		 	Aadd( aOP_2, Z00X->Z00_OP )	
	 		 	Aadd( aOPb, { Z00X->Z00_MAQ, Z00X->Z00_OP, Z00X->Z00_DATA, Z00X->Z00_HORA, Z00X->Z00_CODIGO } ) 		 				 	
	 		 	ntop_2++
				nOP_2++
	 		EndIf	 		
 	
 		Dbselectarea("Z00X")
 		Z00X->( DbSkip() )
 	 	IncRegua()
 	EndDo
 	
 	For fl := 1 to Len(aOPb)
		//CALCULA O TEMPO DE OPERAÇÃO DA MÁQUINA E O ESTIMADO(MR)			
		SB5->( Dbsetorder(1) )
 		SB5->( Dbseek( xFilial( "SB5" ) + aOPb[fl,5] ) )   //procura o código do produto
 		
					 	
		 	nB5HORA1a   := ( SB5->B5_PRDHORA * 2) 
		 	cHoraIni1   := fPegaHoraI(cMAQ,"1",Substr(aOPb[fl,2],1,6) )		 		 	
		 	cHoraFim1   := fPegaHoraF(cMAQ,"1",Substr(aOPb[fl,2],1,6) )
		 	
		 	If ( cHoraIni1 != "X" .and. cHoraFim1 != "X" )		 	
		 		nTempoOper1    := fDifData( mv_par01,mv_par02,cHoraIni1,cHoraFim1) 			 	
		 		nMeta1_2       += (nB5HORA1a * nTempoOper1 )
		 	Else
		 		nMeta1_2	   += nMeta1_2
		 	Endif			 	
		    //----------------
		    	
		   	nB5HORA2a   := ( SB5->B5_PRDHORA * 2) 
		   	cHoraIni2   := fPegaHoraI(cMAQ,"2",Substr(aOPb[fl,2],1,6) )		 			 	 	
		 	cHoraFim2    := fPegaHoraF(cMAQ,"2",Substr(aOPb[fl,2],1,6) )
		 	
		 	If ( cHoraIni2 != "X" .and. cHoraFim2 != "X" )		 	
		 		nTempoOper2     := fDifData( mv_par01,mv_par02,cHoraIni2,cHorafim2) 			 	
		 		nMeta2_2        += (nB5HORA2a * nTempoOper2 )
		 	Else
		 		nMeta2_2	    += nMeta2_2
		 	Endif
		    //-----------------
		 			 
			nB5HORA3a  := ( SB5->B5_PRDHORA * 2) 
			cHoraIni3   := fPegaHoraI(cMAQ,"3",Substr(aOPb[fl,2],1,6) )		 	
			cHoraFim3   := fPegaHoraF(cMAQ,"3",Substr(aOPb[fl,2],1,6) )
			
			If ( cHoraIni3 != "X" .and. cHoraFim3 != "X" )		 	
				nTempoOper3  := fDifData( mv_par01,mv_par02,cHoraIni3,cHorafim3) 			 	
				nMeta3_2     += (nB5HORA3a * nTempoOper3 )
			Else
				nMeta3_2     += nMeta3_2
			Endif
		 	//----------------		 

    Next fl

  

	Aadd (aResult2, {cMaq_2   ,;		//1
				     nOP_2    ,;		//2
				     nQTDMR1_2,;        //3  //1 turno
				     nAPARA1_2,;        //4  //1 turno
	                 nQTDMR2_2,;        //5  //2 turno
	                 nAPARA2_2,;        //6  //2 turno
					 nQTDMR3_2,;        //7  //3 turno
					 nAPARA3_2,;		//8	 //3 turno
					 ntop_2   ,;        //9
					 nMeta1_2 ,;        //10
					 nMeta2_2 ,;        //11
					 nMeta3_2 } ) 		//12							    


/*Novo até aqui*/
 Else	
   Z00X->( DbSkip() )
 Endif
Enddo


If Len(aResult2) <= 0 .and. Len(aResult) <= 0
	alert("Sem qualquer produção no momento!")
	//Quit
	DbselectArea("Z00X")
	DbcloseArea()
	Return
EndIF

If Len(aResult) > 0
    //
    
	nTTotOPEX1 := nTTotKGEX1 := nTTotMLEX1 := nTTotAPEX1 := 0
	nTTotKGEX2 := nTTotMLEX2 := nTTotAPEX2 := nTTotKGEX3 := 0
	nTTotMLEX3 := nTTotAPEX3 := 0
	nTTotMeta1 := nTTotMeta2 := nTTotMeta3 := 0
	//
	nTotOPEX1 := nTotKGEX1 := nTotMLEX1 := nTotAPEX1 := 0
	nTotKGEX2 := nTotMLEX2 := nTotAPEX2 := nTotKGEX3 := 0
	nTotMLEX3 := nTotAPEX3 := 0
	nTotMeta1 := nTotMeta2 := nTotMeta3 := 0
    
	FOR X := 1 TO Len(aResult)     //array dos dados de produção por turno
	 	
	 	
	 	If X > 1
	      If Left(aResult[X,1],1) != Left(aResult[X-1,1],1)
	         @ Prow() + 2,000 PSAY Repl( "-", 220 )
		     @ Prow() +1 ,000 PSAY "SUB"
		     
		     //1o. turno
		     @ Prow()    ,005 PSAY nTotOPEX1 Picture "@E 9999"   							//OP		     
		     If nTotMeta1 > 0
			     @ Prow()    ,015 PSAY nTotMeta1 Picture "@E 99,999,999.99"      			//ESTIMADO(MR) - (META)
			     @ Prow()    ,030 PSAY nTotMLEX1 Picture "@E 99,999,999.99"         		//REAL(MR) - PRODUZIDO                                   
			     
			     If nTotMeta1 > ntotMLEX1
			     	@ Prow()	 ,045 PSAY ( nTotMeta1 - nTotMLEX1 ) Picture "@E 99,999,999.99"	//DIFERENÇA
			     Else
			     	@ Prow()	 ,045 PSAY ( nTotMLEX1 - nTotMeta1 ) Picture "@E 99,999,999.99"	//DIFERENÇA
			     Endif
			     @ Prow()    ,063 PSAY (nTotAPEX1 / ( nTotMLEX1 + nTotAPEX1 ) ) * 100 Picture "@E 999.99"   //APARA %		     		     
		     
		     Else
		     	 @ Prow()    ,015 PSAY cFrase1 Picture "@X"      			//ESTIMADO(MR) - (META)			     
		     Endif
		     
		     //2o. turno
		     If nTotMeta2 > 0
			     @ Prow()    ,073 PSAY nTotMeta2 Picture "@E 99,999,999.99" 				//ESTIMADO(MR) - (META)
			     @ Prow()    ,088 PSAY nTotMLEX2 Picture "@E 99,999,999.99"         		//REAL(MR) - PRODUZIDO
			     
			     If nTotMeta2 > nTotMLEx2
			     	@ Prow()	 ,103 PSAY ( nTotMeta2 - nTotMLEX2 ) Picture "@E 99,999,999.99"	//DIFERENÇA
			     Else
			     	@ Prow()	 ,103 PSAY ( nTotMLEX2 - nTotMeta2 ) Picture "@E 99,999,999.99"	//DIFERENÇA
			     Endif
			     @ Prow()    ,122 PSAY (nTotAPEX2 / ( nTotMLEX2 + nTotAPEX2 ) ) * 100 Picture "@E 999.99"	//APARA %
		     
		     Else 
		     	@ Prow()     ,073 PSAY cFrase2 Picture "@X" 				//ESTIMADO(MR) - (META)		     
		     Endif             
			 
			 //3o. turno		     
		     If nTotMeta3 > 0
			     @ Prow()    ,130 PSAY nTotMeta3 Picture "@E 99,999,999.99"      			//ESTIMADO(MR) - (META)      
			     @ Prow()    ,145 PSAY nTotMLEX3 Picture "@E 99,999,999.99"         		//REAL(MR) - PRODUZIDO
			     
			     If nTotMeta3 > nTotMLEX3
			     	@ Prow()	 ,160 PSAY ( nTotMeta3 - nTotMLEX3 ) Picture "@E 99,999,999.99"	//DIFERENÇA
			     Else
			     	@ Prow()	 ,160 PSAY ( nTotMLEX3 - nTotMeta3 ) Picture "@E 99,999,999.99"	//DIFERENÇA
			     Endif
			     @ Prow()    ,179 PSAY (nTotAPEX3 / ( nTotKGEX3 + nTotAPEX3 ) ) * 100 Picture "@E 999.99"	//APARA %                   
             
             Else 
             	@ Prow()     ,130 PSAY cFrase3 Picture "@X"      			//ESTIMADO(MR) - (META)      		     
             Endif
	         
	         nTTotOPEX1 += nTotOPEX1 
		     nTTotKGEX1 += nTotKGEX1 
		     nTTotMLEX1 += nTotMLEX1 
		     nTTotAPEX1 += nTotAPEX1
		     nTTotMeta1 += nTotMeta1 

		     nTTotKGEX2 += nTotKGEX2 
		     nTTotMLEX2 += nTotMLEX2 
		     nTTotAPEX2 += nTotAPEX2
		     nTTotMeta2 += nTotMeta2

		     nTTotKGEX3 += nTotKGEX3 
		     nTTotMLEX3 += nTotMLEX3 
		     nTTotAPEX3 += nTotAPEX3
		     nTTotMeta3 += nTotMeta3
     
     	     nTotOPEX1 := nTotKGEX1 := nTotMLEX1 := nTotAPEX1 := nTotKGEX2 := nTotMLEX2 := 0
     	     nTotAPEX2 := nTotKGEX3 := nTotMLEX3 := nTotAPEX3 := 0
     	     nTotMeta1 := nTotMeta2 := nTotMeta3 := 0
	 
	      EndIf
        EndIf         

        
	 	//1o. turno	 	
	 	@ Prow() + 2,000 PSAY Left( aResult[X,1], 3 )                           			//MAQ
	 	@ Prow()    ,005 PSAY aResult[X,2]  Picture "@E 9999"               	    		//OP
	 	If aResult[X,10] > 0
	 		@ Prow()    ,015 PSAY aResult[X,10] Picture "@E 9,999,999.99"					//ESTIMADO(MR) - META	 	
	 		@ Prow()    ,030 PSAY aResult[X,3]  Picture "@E 9,999,999.99"						//REAL(MR) - PRODUZIDO	 	 		
	 		
	 		If aResult[X,10] > aResult[X,3]
		 		@ Prow()	,045 PSAY ( aResult[X,10] - aResult[X,3] ) Picture "@E 9,999,999.99" 	//DIFERENÇA (ESTIMADO - REAL)	 	
		 	Else
		 		@ Prow()	,045 PSAY ( aResult[X,3]  - aResult[X,10] ) Picture "@E 9,999,999.99" 	//DIFERENÇA (ESTIMADO - REAL)	 	
		 	Endif
	 	
	 	Else
	 		@ Prow()    ,030 PSAY aResult[X,3]  Picture "@E 9,999,999.99"						//REAL(MR) - PRODUZIDO	 	 		
	 		@ Prow()    ,063 PSAY aResult[X,4] / ( aResult[X,3] + aResult[X,4] ) * 100 Picture "@E 999.99"   	//APARA %	 
	 	
	 	Endif
	 	
	 	
	 	//2o. turno	 
	 	If aResult[X,11] > 0
	 		@ Prow(),073 PSAY aResult[X,11] Picture "@E 9,999,999.99"	 		//ESTIMADO(MR) - META	 	 	
	 		@ Prow()    ,088 PSAY aResult[X,5]  Picture "@E 9,999,999.99"               //REAL(MR) - PRODUZIDO	 		
	 		
	 		If aResult[X,11] > aResult[X,5]
	 			@ Prow()	,103 PSAY ( aResult[X,11] - aResult[X,5] ) Picture "@E 9,999,999.99" 	//DIFERENÇA (ESTIMADO - REAL)	   
	 		Else
	 			@ Prow()	,103 PSAY ( aResult[X,5] - aResult[X,11] ) Picture "@E 9,999,999.99" 	//DIFERENÇA (ESTIMADO - REAL)	   
	 		Endif
	 		@ Prow()    ,122 PSAY aResult[X,6] / ( aResult[X,5] + aResult[X,6] ) * 100 Picture "@E 999.99"	//APARA %	 	
	 	
	 	Else
	 		@ Prow()    ,088 PSAY aResult[X,5]  Picture "@E 9,999,999.99"               //REAL(MR) - PRODUZIDO	 		
	 		@ Prow()    ,122 PSAY aResult[X,6] / ( aResult[X,5] + aResult[X,6] ) * 100 Picture "@E 999.99"	//APARA %	 	
	 	
	 	Endif	 	
	 	
	 	
	 	//3o. turno	 
	 	If aResult[X,12] > 0
	 		@ Prow(),130 PSAY aResult[X,12] Picture "@E 9,999,999.99"		//ESTIMADO(MR) - META	 		 	
	 		@ Prow()    ,145 PSAY aResult[X,7] Picture "@E 9,999,999.99"            //REAL(MR) - PRODUZIDO	 	
	 	
	 		If aResult[X,12] > aResult[X,7] 
	 			@ Prow()	,160 PSAY ( aResult[X,12] - aResult[X,7] ) Picture "@E 9,999,999.99" 	//DIFERENÇA (ESTIMADO - REAL)	 	
	 		Else
	 			@ Prow()	,160 PSAY ( aResult[X,7] - aResult[X,12] ) Picture "@E 9,999,999.99" 	//DIFERENÇA (ESTIMADO - REAL)	 	
	 		Endif
	 		@ Prow()    ,179 PSAY aResult[X,8] / ( aResult[X,7] + aResult[X,8] ) * 100 Picture "@E 999.99"	//APARA % 		 	
	 	
	 	Else
	 		@ Prow()    ,145 PSAY aResult[X,7] Picture "@E 9,999,999.99"            //REAL(MR) - PRODUZIDO	 	
	 		@ Prow()    ,179 PSAY aResult[X,8] / ( aResult[X,7] + aResult[X,8] ) * 100 Picture "@E 999.99"	//APARA % 		 	
	 	Endif
	 	

        
		nTotOPEX1 := nTotOPEX1 + aResult[X,2]
		nTotMLEX1 := nTotMLEX1 + aResult[X,3]
		nTotAPEX1 := nTotAPEX1 + aResult[X,4]
		nTotMeta1 := nTotMeta1 + aResult[X,10]

		nTotMLEX2 := nTotMLEX2 + aResult[X,5]
		nTotAPEX2 := nTotAPEX2 + aResult[X,6]
		nTotMeta2 := nTotMeta2 + aResult[X,11]

		nTotMLEX3 := nTotMLEX3 + aResult[X,7]
		nTotAPEX3 := nTotAPEX3 + aResult[X,8]
		nTotMeta3 := nTotMeta3 + aResult[X,12]
        
	NEXT

	    
	    //1o. turno	    
	    @ Prow() + 2,000 PSAY Repl( "-", 220 )
		@ Prow() + 1,000 PSAY "SUB "
		@ Prow()    ,005 PSAY nTotOPEX1 Picture "@E 9999"               					//OP
		If nTotMeta1 > 0
			@ Prow()    ,015 PSAY nTotMeta1 Picture "@E 9,999,999.99"						//ESTIMADO(MR)		
			@ Prow()    ,030 PSAY nTotMLEX1 Picture "@E 99,999,999.99"      					//REAL(MR)			
			If nTotMeta1 > nTotMLEX1
				@ Prow()	,045 PSAY ( nTotMeta1 - nTotMLEX1 )	Picture "@E 99,999,999.99"		//DIFERENÇA
			Else
				@ Prow()	,045 PSAY ( nTotMLEX1 - nTotMeta1 )	Picture "@E 99,999,999.99"		//DIFERENÇA
			Endif			
			@ Prow()    ,063 PSAY (nTotAPEX1 / ( nTotMLEX1 + nTotAPEX1 ) ) * 100 Picture "@E 999.99"	//APARA %
		
		Else
			@ Prow()    ,015 PSAY cFrase1 Picture "@X"	//Se não houve registro na ZB0, não tem meta, então, só mostra msg	
		Endif		
		 
		//2o. turno   
		If nTotMeta2 > 0
			@ Prow()    ,073 PSAY nTotMeta2 Picture "@E 9,999,999.99"						//ESTIMADO
			@ Prow()    ,088 PSAY nTotMLEX2 Picture "@E 99,999,999.99"      				//REAL(MR)
			
			If nTotMeta2 > nTotMLEX2
				@ Prow(),103 PSAY ( nTotMeta2 - nTotMLEX2 ) Picture "@E 99,999,999.99"		//DIFERENÇA
			Else
				@ Prow(),103 PSAY ( nTotMLEX2 - nTotMeta2 ) Picture "@E 99,999,999.99"		//DIFERENÇA
			Endif			
			@ Prow()    ,122 PSAY (nTotAPEX2 / ( nTotMLEX2 + nTotAPEX2 ) ) * 100 Picture "@E 999.99"	//APARA %
		
		Else			
			@ Prow()    ,073 PSAY cFrase2 Picture "@X" //Se não houve registro na ZB0, não tem meta, então, só mostra msg	
		Endif
        
		//3o. turno
		If nTotMeta3 > 0
			@ Prow()    ,130 PSAY nTotMeta3 Picture "@E 9,999,999.99"  						//ESTIMADO
			@ Prow()    ,145 PSAY nTotMLEX3 Picture "@E 99,999,999.99"      				//REAL(MR)
			
			If nTotMeta3 > nTotMLEX3
				@ Prow()	,160 PSAY ( nTotMeta3 - nTotMLEX3 ) Picture "@E 99,999,999.99"		//DIFERENÇA
			Else 
				@ Prow()	,160 PSAY ( nTotMLEX3 - nTotMeta3 ) Picture "@E 99,999,999.99"		//DIFERENÇA
			Endif
			@ Prow()    ,179 PSAY ( nTotAPEX3 / ( nTotMLEX3 + nTotAPEX3 ) ) * 100 Picture "@E 999.99"	//APARA %
        Else
        	@ Prow()    ,130 PSAY cFrase3 Picture "@X" //Se não houve registro na ZB0, não tem meta, então, só mostra msg	        
        Endif
	         
	    nTTotOPEX1 += nTotOPEX1 
		nTTotMLEX1 += nTotMLEX1 
		nTTotAPEX1 += nTotAPEX1
		nTTotMeta1 += nTotMeta1  

		nTTotMLEX2 += nTotMLEX2 
		nTTotAPEX2 += nTotAPEX2
		nTTotMeta2 += nTotMeta2 

		nTTotMLEX3 += nTotMLEX3 
		nTTotAPEX3 += nTotAPEX3
		nTTotMeta3 += nTotMeta3
	    
	    //1o. turno
	    @ Prow() + 2,000 PSAY Repl( "-", 220 )
	    @ Prow() +1 ,000 PSAY "TOTAL"
        @ Prow()    ,005 PSAY nTTotOPEX1 Picture "@E 9999"     					//OP
		If nTTotMeta1 > 0
			@ Prow()	,015 PSAY nTTotMeta1 Picture "@E 99,999,999.99"			//ESTIMADO(MR)
			@ Prow()    ,030 PSAY nTTotMLEX1 Picture "@E 99,999,999.99"       	//REAL(MR)
			
			If nTTotMeta1 > nTTotMLEX1
				@ Prow(),045 PSAY ( nTTotMeta1 - nTTotMLEX1 ) Picture "@E 99,999,999.99"       	//DIFERENÇA (ESTIMADO - REAL)		
			Else
				@ Prow(),045 PSAY ( nTTotMLEX1 - nTTotMeta1 ) Picture "@E 99,999,999.99"       	//DIFERENÇA (ESTIMADO - REAL)		
			Endif
			@ Prow()    ,063 PSAY ( nTTotAPEX1 / ( nTTotMLEX1 + nTTotAPEX1 ) ) * 100 Picture "@E 999.99"	//APARA %
		
		Else
			@ Prow()	,015 PSAY cFrase1 Picture "@X"	//Se não houve registro na ZB0, não tem meta, então, só mostra msg	
		Endif		
        
		//2o. turno		
		If nTTotMeta2 > 0
			@ Prow()	,073 PSAY nTTotMeta2 Picture "@E 99,999,999.99"			//ESTIMADO(MR)
			@ Prow()    ,088 PSAY nTTotMLEX2 Picture "@E 99,999,999.99"       	//REAL(MR)
			
			If nTTotMeta2 > nTTotMLEX2
				@ Prow(),103 PSAY ( nTTotMeta2 - nTTotMLEX2 ) Picture "@E 99,999,999.99"       	//DIFERENÇA (ESTIMADO - REAL)		
			Else
				@ Prow(),103 PSAY ( nTTotMLEX2 - nTTotMeta2 ) Picture "@E 99,999,999.99"       	//DIFERENÇA (ESTIMADO - REAL)		
			Endif			
			@ Prow()    ,122 PSAY ( nTTotAPEX2 / ( nTTotMLEX2 + nTTotAPEX2 ) ) * 100 Picture "@E 999.99"	//APARA %
        
        Else
        	@ Prow()	,073 PSAY cFrase2 Picture "@X"	//Se não houve registro na ZB0, não tem meta, então, só mostra msg		
        Endif
		
		//3o. turno
		If nTTotMeta3 > 0
			@ Prow()	,130 PSAY nTTotMeta3 Picture "@E 99,999,999.99"			//ESTIMADO(MR)
			@ Prow()    ,145 PSAY nTTotMLEX3 Picture "@E 99,999,999.99"       	//REAL(MR)
			
			If nTTotMeta3 > nTTotMLEX3
				@ Prow(),160 PSAY ( nTTotMeta3 - nTTotMLEX3 ) Picture "@E 99,999,999.99"       	//DIFERENÇA (ESTIMADO - REAL)		
			Else
				@ Prow(),160 PSAY ( nTTotMLEX3 - nTTotMeta3 ) Picture "@E 99,999,999.99"       	//DIFERENÇA (ESTIMADO - REAL)		
			Endif
			@ Prow()    ,179 PSAY ( nTTotAPEX3 / ( nTTotMLEX3 + nTTotAPEX3 ) ) * 100 Picture "@E 999.99"	//APARA %
		
		Else
			@ Prow()	,130 PSAY cFrase3 Picture "@X"	//Se não houve registro na ZB0, não tem meta, então, só mostra msg	
		Endif

    
    If Len(aResult3) > 0
       
       nTotOPEX1 := nTotKGEX1 := nTotMLEX1 := nTotAPEX1 := 0
       nTotKGEX2 := nTotMLEX2 := nTotAPEX2 := 0
       nTotKGEX3 := nTotMLEX3 := nTotAPEX3 := 0
       nTotMeta1 := nTotMeta2 := nTotMeta3 := 0
       
	   Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  // Impressao do cabecalho
	   
		FOR X := 1 TO Len(aResult3)
		
			//1o. turno	 	
		 	@ Prow() + 2,000 PSAY Left( aResult3[X,1], 3 )                          	//MAQ
		 	@ Prow()    ,005 PSAY aResult3[X,2] Picture "@E 9999"  						//OP
		 	
		 	If aResult3[X,10] > 0
		 		@ Prow(),015 PSAY aResult3[X,10] Picture "@E 9,999,999.99"			//ESTIMADO(MR)        	 	 			 			 	
		 		@ Prow(),030 PSAY aResult3[X,3] Picture "@E 9,999,999.99"           	//REAL(MR)		 	
		 		
		 		If aResult3[X,10] > aResult3[X,3]
		 			@ Prow(),045 PSAY ( aResult3[X,10] - aResult3[X,3] ) Picture "@E 9,999,999.99"         //DIFERENÇA (ESTIMADO - REAL)
		 		Else
		 			@ Prow(),045 PSAY ( aResult3[X,3] - aResult3[X,10] ) Picture "@E 9,999,999.99"         //DIFERENÇA (ESTIMADO - REAL)
		 		Endif
		 		@ Prow(),063 PSAY aResult3[X,4] / ( aResult3[X,3] + aResult3[X,4] ) * 100 Picture "@E 999.99" //APARA %
		 	Else
		 		@ Prow(),030 PSAY aResult3[X,3] Picture "@E 9,999,999.99"           	//REAL(MR)		 	
		 		@ Prow(),063 PSAY aResult3[X,4] / ( aResult3[X,3] + aResult3[X,4] ) * 100 Picture "@E 999.99" //APARA %
		 	
		 	Endif		 	

			//2o. turno
		 	If aResult3[X,11] > 0
		 		@ Prow(),073 PSAY aResult3[X,11] Picture "@E 9,999,999.99"			//ESTIMADO(MR)        	 	 			 			 	
		 		@ Prow(),088 PSAY aResult3[X,5] Picture "@E 9,999,999.99"           	//REAL(MR)		 	
		 		
		 		If aResult3[X,11] > aResult3[X,5]
		 			@ Prow(),103 PSAY ( aResult3[X,11] - aResult3[X,5] ) Picture "@E 9,999,999.99"    //DIFERENÇA (ESTIMADO - REAL)
		 		Else
		 			@ Prow(),103 PSAY ( aResult3[X,5] - aResult3[X,11] ) Picture "@E 9,999,999.99"    //DIFERENÇA (ESTIMADO - REAL)
		 		Endif
		 		@ Prow()    ,122 PSAY aResult3[X,6] / ( aResult3[X,5] + aResult3[X,6] ) * 100 Picture "@E 999.99" //APARA %
		 	Else
		 		@ Prow()    ,088 PSAY aResult3[X,5] Picture "@E 9,999,999.99"           	//REAL(MR)		 	
		 		@ Prow()    ,122 PSAY aResult3[X,6] / ( aResult3[X,5] + aResult3[X,6] ) * 100 Picture "@E 999.99" //APARA %
		 	Endif 		 	
		 	
            //3o. turno
		 	If aResult3[X,12] > 0
		 		@ Prow(),130 PSAY aResult3[X,12] Picture "@E 9,999,999.99"			//ESTIMADO(MR)        	 	 			 			 	
		 		@ Prow(),145 PSAY aResult3[X,7] Picture "@E 9,999,999.99"          	//REAL(MR)		 
		 		
		 		If aResult3[X,12] > aResult3[X,7] 
		 			@ Prow(),160 PSAY ( aResult3[X,12] - aResult3[X,7] ) Picture "@E 9,999,999.99"           //DIFERENÇA (ESTIMADO - REAL)
		 		Else
		 			@ Prow(),160 PSAY ( aResult3[X,7] - aResult3[X,12] ) Picture "@E 9,999,999.99"           //DIFERENÇA (ESTIMADO - REAL)
		 		Endif
		 		@ Prow(),179 PSAY aResult3[X,8] / ( aResult3[X,7] + aResult3[X,8] ) * 100 Picture "@E 999.99" //APARA %
		 	Else
		 		@ Prow(),145 PSAY aResult3[X,7] Picture "@E 9,999,999.99"          	//REAL(MR)		 
		 		@ Prow(),179 PSAY aResult3[X,8] / ( aResult3[X,7] + aResult3[X,8] ) * 100 Picture "@E 999.99" //APARA %
		 	Endif		 	

		NEXT

		@ Prow() + 2,000 PSAY Repl( "-", 220 )

		For Y := 1 To Len(aResult3) //da pra otmizar, basta colocar no for do x
			nTotOPEX1 := nTotOPEX1 + aResult3[Y,2]
			nTotMLEX1 := nTotMLEX1 + aResult3[Y,3]
			nTotAPEX1 := nTotAPEX1 + aResult3[Y,4]
			nTotMeta1 := nTotMeta1 + aResult3[Y,10]

			nTotMLEX2 := nTotMLEX2 + aResult3[Y,5]
			nTotAPEX2 := nTotAPEX2 + aResult3[Y,6]
			nTotMeta2 := nTotMeta2 + aResult3[Y,11]

			nTotMLEX3 := nTotMLEX3 + aResult3[Y,7]
			nTotAPEX3 := nTotAPEX3 + aResult3[Y,8]
			nTotMeta3 := nTotMeta3 + aResult3[Y,12]
			
		Next
        
		//totais
		//1o. turno
		@ Prow() + 1,005 PSAY nTotOPEX1 Picture "@E 9999"				    			//OP
		If nTotMeta1 > 0
			@ Prow()    ,015 PSAY nTotMeta1 Picture "@E 99,999,999.99"					//ESTIMADO(MR) - META         	 	 			
			@ Prow()    ,030 PSAY nTotMLEX1 Picture "@E 99,999,999.99"          		//REAL(MR)
			
			If nTotMeta1 > nTotMLEX1
				@ Prow()	,045 PSAY (nTotMeta1 - nTotMLEX1) Picture "@E 99,999,999.99"	//DIFERENÇA (ESTIMADO - REAL)						//APARA KG
			Else
				@ Prow()	,045 PSAY (nTotMLEX1 - nTotMeta1) Picture "@E 99,999,999.99"	//DIFERENÇA (ESTIMADO - REAL)						//APARA KG
			Endif
			
			@ Prow()    ,054 PSAY (nTotAPEX1 / ( nTotMLEX1 + nTotAPEX1 ) ) * 100 Picture "@E 999.99"	//APARA %
		
		Else
			@ Prow()    ,015 PSAY cFrase1 Picture "@X"		
		Endif
        
		//2o. turno		
		If nTotMeta2 > 0
			@ Prow(),073 PSAY nTotMeta2 Picture "@E 99,999,999.99"					//ESTIMADO(MR) - META         	 	 			
			@ Prow(),088 PSAY nTotMLEX2 Picture "@E 99,999,999.99"          		//REAL(MR)
			
			If nTotMeta2 > nTotMLEX2
				@ Prow(),103 PSAY (nTotMeta2 - nTotMLEX2) Picture "@E 99,999,999.99"	//DIFERENÇA (ESTIMADO - REAL)						//APARA KG
			Else 
				@ Prow(),103 PSAY (nTotMLEX2 - nTotMeta2) Picture "@E 99,999,999.99"	//DIFERENÇA (ESTIMADO - REAL)						//APARA KG
			Endif			
			@ Prow(),122 PSAY (nTotAPEX2 / ( nTotMLEX2 + nTotAPEX2 ) ) * 100 Picture "@E 999.99"	//APARA %
		
		Else
			@ Prow(),073 PSAY cFrase2 Picture "@X"		
		Endif
		
		//3o. turno
		If nTotMeta3 > 0
			@ Prow(),130 PSAY nTotMeta3 Picture "@E 99,999,999.99"					//ESTIMADO(MR) - META         	 	 			
			@ Prow(),145 PSAY nTotMLEX3 Picture "@E 99,999,999.99"          		//REAL(MR)
			
			If nTotMeta3 > nTotMLEX3
				@ Prow(),160 PSAY (nTotMeta3 - nTotMLEX3) Picture "@E 99,999,999.99"	//DIFERENÇA (ESTIMADO - REAL)						//APARA KG
			Else 
				@ Prow(),160 PSAY (nTotMLEX3 - nTotMeta3) Picture "@E 99,999,999.99"	//DIFERENÇA (ESTIMADO - REAL)						//APARA KG
			Endif			
			@ Prow(),179 PSAY (nTotAPEX3 / ( nTotMLEX2 + nTotAPEX2 ) ) * 100 Picture "@E 999.99"	//APARA %
        
        Else
        	@ Prow(),130 PSAY cFrase3 Picture "@X"        	
        Endif
	EndIf
	
    //
     
    If Len(aResult4) > 0
       //
	   nTTotOPEX1 := nTTotMLEX1 := nTTotAPEX1 := 0
	   nTTotMLEX2 := nTTotAPEX2 := 0
	   nTTotMLEX3 := nTTotAPEX3 := 0
	   nTTotMeta1 := nTTotMeta2 := nTTotMeta3 := 0
	   //
	   nTotOPEX1 := nTotMLEX1 := nTotAPEX1 := 0
	   nTotMLEX2 := nTotAPEX2 := 0
	   nTotMLEX3 := nTotAPEX3 := 0
	   nTotMeta1 := nTotMeta2 := nTotMeta3 := 0
       Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  // Impressao do cabecalho
	   
	   FOR X := 1 TO Len(aResult4)
	 	//
	 	If X > 1
	      If Left(aResult4[X,1],2) != Left(aResult4[X-1,1],2)
	      	         
	         //1o.turno
	         @ Prow() + 2,000 PSAY Repl( "-", 220 )
		     @ Prow() +1 ,000 PSAY "SUB"
		     @ Prow()    ,005 PSAY nTotOPEX1 Picture "@E 9999"							//OP
		     If nTotMeta1 > 0			     
			     @ Prow(),015 PSAY nTotMeta1 Picture "@E 9,999,999.99"					//ESTIMADO(MR)         	 	 	
			     @ Prow(),030 PSAY nTotMLEX1 Picture "@E 99,999,999.99"     			//REAL(MR)
			     
			     If nTotMeta1 > nTotMLEX1
			     	@ Prow(),045 PSAY ( nTotMeta1 - nTotMLEX1) Picture "@E 99,999,999.99"  //DIFERENÇA (ESTIMADO - REAL)
			     Else 
			     	@ Prow(),045 PSAY ( nTotMLEX1 - nTotMeta1) Picture "@E 99,999,999.99"  //DIFERENÇA (ESTIMADO - REAL)
			     Endif
			     @ Prow()	,054 PSAY (nTotAPEX1 / ( nTotMLEX1 + nTotAPEX1 ) ) * 100 Picture "@E 999.99"	//APARA %
		     
		     Else
		     	 @ Prow()	,015 PSAY cFrase1 Picture "@X"			     			
		     Endif
		     
		     //2o. turno		     
		     If nTotMeta2 > 0
			     @ Prow()    ,073 PSAY nTotMeta2 Picture "@E 9,999,999.99"					//ESTIMADO(MR)         	 	 	
			     @ Prow()    ,088 PSAY nTotMLEX2 Picture "@E 99,999,999.99"     			//REAL(MR)
			     
			     If nTotMeta2 > nTotMLEX2
			     	@ Prow()    ,103 PSAY ( nTotMeta2 - nTotMLEX2) Picture "@E 99,999,999.99"  //DIFERENÇA (ESTIMADO - REAL)
			     Else 
			     	@ Prow()    ,103 PSAY ( nTotMLEX2 - nTotMeta2) Picture "@E 99,999,999.99"  //DIFERENÇA (ESTIMADO - REAL)
			     Endif
			     @ Prow()    ,122 PSAY (nTotAPEX2 / ( nTotMLEX2 + nTotAPEX2 ) ) * 100 Picture "@E 999.99"	//APARA %
		     
		     Else
		     	 @ Prow()    ,073 PSAY cFrase2 Picture "@X"	
		     Endif
             
             //3o. turno
		     If nTotMeta3 > 0
			     @ Prow()    ,130 PSAY nTotMeta3 Picture "@E 9,999,999.99"					//ESTIMADO(MR)         	 	 	
			     @ Prow()    ,145 PSAY nTotMLEX3 Picture "@E 99,999,999.99"     			//REAL(MR)
			     
			     If nTotMeta3 > nTotMLEX3
			     	@ Prow()    ,160 PSAY ( nTotMeta3 - nTotMLEX3) Picture "@E 99,999,999.99"  //DIFERENÇA (ESTIMADO - REAL)
			     Else 
			     	@ Prow()    ,160 PSAY ( nTotMLEX3 - nTotMeta3) Picture "@E 99,999,999.99"  //DIFERENÇA (ESTIMADO - REAL)
			     Endif
			     @ Prow()    ,179 PSAY (nTotAPEX3 / ( nTotMLEX3 + nTotAPEX3 ) ) * 100 Picture "@E 999.99"	//APARA %
             
             Else
             	 @ Prow()    ,130 PSAY cFrase3 Picture "@X"	
             Endif
	         
	         nTTotOPEX1 += nTotOPEX1		     
		     nTTotMLEX1 += nTotMLEX1 
		     nTTotAPEX1 += nTotAPEX1
		     nTTotMeta1 += nTotMeta1 

		     nTTotMLEX2 += nTotMLEX2 
		     nTTotAPEX2 += nTotAPEX2
		     nTTotMeta2 += nTotMeta2 

		     nTTotMLEX3 += nTotMLEX3 
		     nTTotAPEX3 += nTotAPEX3
		     nTTotMeta3 += nTotMeta3 
     
     	     nTotOPEX1 := nTotMLEX1 := nTotAPEX1 := 0
     	     nTotMLEX2 := nTotAPEX2 := 0
     	     nTotMLEX3 := nTotAPEX3 := 0
     	     nTotMeta1 := nTotMeta2 := nTotMeta3 := 0
	 
	      EndIf
        EndIf
	 		 	
	 	//
	 	//1o. turno
	 	@ Prow() + 2,000 PSAY Left( aResult4[X,1], 5 ) 							//MAQ
	 	@ Prow()    ,005 PSAY aResult4[X,2]     Picture "@E 9999"           	//OP
	 	If aResult4[X,10] > 0
	 		@ Prow()    ,015 PSAY aResult4[X,10] Picture "@E 9,999,999.99"		//ESTIMADO(MR)	 		 	 	
	 		@ Prow()    ,030 PSAY aResult4[X,3] Picture "@E 9,999,999.99"       //REAL(MR)	 
	 		
	 		If aResult4[X,10] > aResult4[X,3]
	 			@ Prow()    ,045 PSAY ( aResult4[X,10] - aResult4[X,3] ) Picture "@E 9,999,999.99"   //DIFERENÇA (ESTIMADO - REAL)
	 		Else 
	 			@ Prow()    ,045 PSAY ( aResult4[X,3] - aResult4[X,10] ) Picture "@E 9,999,999.99"   //DIFERENÇA (ESTIMADO - REAL)
	 		Endif
	 		@ Prow()	,063 PSAY aResult4[X,4] / ( aResult4[X,3] + aResult4[X,4] ) * 100 Picture "@E 999.99"	//APARA %	 	
	 	
	 	Else
	 		@ Prow()    ,030 PSAY aResult4[X,3] Picture "@E 9,999,999.99"       	//REAL(MR)	 
	 		@ Prow()	,063 PSAY aResult4[X,4] / ( aResult4[X,3] + aResult4[X,4] ) * 100 Picture "@E 999.99"	//APARA %	 	
	 	Endif
	 	
	 	         	 	 	
	 	//2o. turno
	 	If aResult4[X,11] > 0
	 		@ Prow(),073 PSAY aResult4[X,11] Picture "@E 9,999,999.99"		//ESTIMADO(MR)	 		 		 	
	 		@ Prow()    ,088 PSAY aResult4[X,5] Picture "@E 9,999,999.99"       	//REAL(MR)	 
	 		
	 		If aResult4[X,11] > aResult4[X,5]
	 			@ Prow(),103 PSAY ( aResult4[X,11] - aResult4[X,5] ) Picture "@E 9,999,999.99"       //DIFERENÇA (ESTIMADO - REAL)
	 		Else 
	 			@ Prow(),103 PSAY ( aResult4[X,5] - aResult4[X,11] ) Picture "@E 9,999,999.99"       //DIFERENÇA (ESTIMADO - REAL)
	 		Endif
	 	    @ Prow()    ,122 PSAY aResult4[X,6] / ( aResult4[X,5] + aResult4[X,6] ) * 100 Picture "@E 999.99"	//APARA %
	 	Else
	 		@ Prow()    ,088 PSAY aResult4[X,5] Picture "@E 9,999,999.99"       	//REAL(MR)	 
	 		@ Prow()    ,122 PSAY aResult4[X,6] / ( aResult4[X,5] + aResult4[X,6] ) * 100 Picture "@E 999.99"	//APARA %
	 	Endif
	 	
	 	
	 	//3o. turno
	 	If aResult4[X,12] > 0
	 		@ Prow(),130 PSAY aResult4[X,12] Picture "@E 9,999,999.99"		//ESTIMADO(MR)	 		 	
	 		@ Prow()    ,145 PSAY aResult4[X,7] Picture "@E 9,999,999.99"       	//REAL(MR)	 
	 		
	 		If aResult4[X,12] > aResult4[X,7]
	 			@ Prow(),160 PSAY ( aResult4[X,12] - aResult4[X,7] ) Picture "@E 9,999,999.99"       //DIFERENÇA (ESTIMADO - REAL)
	 		Else
	 			@ Prow(),160 PSAY ( aResult4[X,7] - aResult4[X,12] ) Picture "@E 9,999,999.99"       //DIFERENÇA (ESTIMADO - REAL)
	 		Endif
	 	    @ Prow()    ,179 PSAY aResult4[X,8] / ( aResult4[X,7] + aResult4[X,8] ) * 100 Picture "@E 999.99"	//APARA %	 	
	 	Else
	 		@ Prow()    ,145 PSAY aResult4[X,7] Picture "@E 9,999,999.99"       	//REAL(MR)	 
	 		@ Prow()    ,179 PSAY aResult4[X,8] / ( aResult4[X,7] + aResult4[X,8] ) * 100 Picture "@E 999.99"	//APARA %	 	
	 	Endif
	 	

		nTotOPEX1 := nTotOPEX1 + aResult4[X,2]
		nTotMLEX1 := nTotMLEX1 + aResult4[X,3]
		nTotAPEX1 := nTotAPEX1 + aResult4[X,4]
		nTotMeta1 := nTotMeta1 + aResult4[X,10]

		nTotMLEX2 := nTotMLEX2 + aResult4[X,5]
		nTotAPEX2 := nTotAPEX2 + aResult4[X,6]
		nTotMeta2 := nTotMeta2 + aResult4[X,11]

		nTotMLEX3 := nTotMLEX3 + aResult4[X,7]
		nTotAPEX3 := nTotAPEX3 + aResult4[X,8]
		nTotMeta3 := nTotMeta3 + aResult4[X,12]

	NEXT
	    //sub-totais
	    //1o. turno
	    @ Prow() + 2,000 PSAY Repl( "-", 220 )
		@ Prow() + 1,000 PSAY "SUB "
		@ Prow()    ,005 PSAY nTotOPEX1 Picture "@E 9999"			   						//OP
		If nTotMeta1 > 0
			@ Prow()    ,015 PSAY nTotMeta1 Picture "@E 99,999,999.99"						//ESTIMADO(MR)         	 	 	
			@ Prow()    ,030 PSAY nTotMLEX1 Picture "@E 99,999,999.99"      				//REAL(MR)
			If nTotMeta1 > nTotMLEX1
				@ Prow(),045 PSAY ( nTotMeta1 - nTotMLEX1 ) Picture "@E 99,999,999.99"      //DIFERENÇA (ESTIMADO - REAL)
			Else 
				@ Prow(),045 PSAY ( nTotMLEX1 - nTotMeta1 ) Picture "@E 99,999,999.99"      //DIFERENÇA (ESTIMADO - REAL)
			Endif
			
			@ Prow()    ,063 PSAY (nTotAPEX1 / ( nTotMLEX1 + nTotAPEX1 ) ) * 100 Picture "@E 999.99"	//APARA %
		
		Else
			@ Prow()    ,015 PSAY cFrase1 Picture "@X"	
		Endif
		
		//2o. turno   		
		If nTotMeta2 > 0
			@ Prow()    ,073 PSAY nTotMeta2 Picture "@E 99,999,999.99"						//ESTIMADO(MR)         	 	 	
			@ Prow()    ,088 PSAY nTotMLEX2 Picture "@E 99,999,999.99"      				//REAL(MR)
			
			If nTotMeta2 > nTotMLEX2
				@ Prow()    ,103 PSAY ( nTotMeta2 - nTotMLEX2 ) Picture "@E 99,999,999.99"      //DIFERENÇA (ESTIMADO - REAL)
			Else 
				@ Prow()    ,103 PSAY ( nTotMLEX2 - nTotMeta2 ) Picture "@E 99,999,999.99"      //DIFERENÇA (ESTIMADO - REAL)
			Endif
			@ Prow()    ,122 PSAY (nTotAPEX2 / ( nTotMLEX2 + nTotAPEX2 ) ) * 100 Picture "@E 999.99"	//APARA %
        
        Else
        	@ Prow()    ,073 PSAY cFrase2 Picture "@X"	
        Endif
		
		//3o. turno
		If nTotMeta3 > 0
			@ Prow()    ,130 PSAY nTotMeta3 Picture "@E 99,999,999.99"						//ESTIMADO(MR)         	 	 	
			@ Prow()    ,145 PSAY nTotMLEX3 Picture "@E 99,999,999.99"      				//REAL(MR)
			
			If nTotMeta3 > nTotMLEX3
				@ Prow()    ,160 PSAY ( nTotMeta3 - nTotMLEX3 ) Picture "@E 99,999,999.99"      //DIFERENÇA (ESTIMADO - REAL)
			Else 
				@ Prow()    ,160 PSAY ( nTotMLEX3 - nTotMeta3 ) Picture "@E 99,999,999.99"      //DIFERENÇA (ESTIMADO - REAL)
			Endif
			
			@ Prow()    ,179 PSAY (nTotAPEX3 / ( nTotMLEX3 + nTotAPEX3 ) ) * 100 Picture "@E 999.99"	//APARA %
	    
	    Else 
	    	@ Prow()    ,130 PSAY cFrase3 Picture "@X"	
	    Endif     
	    nTTotOPEX1 += nTotOPEX1 
		nTTotMLEX1 += nTotMLEX1 
		nTTotAPEX1 += nTotAPEX1
		nTTotMeta1 += nTotMeta1 

		nTTotMLEX2 += nTotMLEX2 
		nTTotAPEX2 += nTotAPEX2 
		nTTotMeta2 += nTotMeta2

		nTTotMLEX3 += nTotMLEX3 
		nTTotAPEX3 += nTotAPEX3
		nTTotMeta3 += nTotMeta3	                     
	    
	    
	    //1o. turno
	    @ Prow() + 2,000 PSAY Repl( "-", 220 )
	    @ Prow() +1 ,000 PSAY "TOTAL"
        @ Prow()    ,005 PSAY nTTotOPEX1 Picture "@E 9999"					//OP
		If nTTotMeta1 > 0
			@ Prow()    ,015 PSAY nTTotMeta1 Picture "@E 99,999,999.99"		//ESTIMADO(MR)        	 	 	
			@ Prow()    ,030 PSAY nTTotMLEX1 Picture "@E 99,999,999.99"     //REAL(MR)
			
			If nTTotMeta1 > nTTotMLEX1
				@ Prow()    ,045 PSAY ( nTTotMeta1 - nTTotMLEX1 ) Picture "@E 99,999,999.99"     //DIFERENÇA (ESTIMADO - REAL)
			Else
				@ Prow()    ,045 PSAY ( nTTotMLEX1 - nTTotMeta1 ) Picture "@E 99,999,999.99"     //DIFERENÇA (ESTIMADO - REAL)
			Endif
			@ Prow()    ,063 PSAY (nTTotAPEX1 / ( nTTotMLEX1 + nTTotAPEX1 ) ) * 100 Picture "@E 999.99"	//APARA %
		
		Else
			@ Prow()    ,015 PSAY cFrase1 Picture "@X"	
		Endif
        
        //2o. turno
		If nTTotMeta2 > 0
			@ Prow()    ,073 PSAY nTTotMeta2 Picture "@E 99,999,999.99"		//ESTIMADO(MR)        	 	 	
			@ Prow()    ,088 PSAY nTTotMLEX2 Picture "@E 99,999,999.99"     //REAL(MR)
			
			If nTTotMeta2 > nTTotMLEX2
				@ Prow()    ,103 PSAY ( nTTotMeta2 - nTTotMLEX2 ) Picture "@E 99,999,999.99"     //DIFERENÇA (ESTIMADO - REAL)
			Else 
				@ Prow()    ,103 PSAY ( nTTotMLEX2 - nTTotMeta2 ) Picture "@E 99,999,999.99"     //DIFERENÇA (ESTIMADO - REAL)
			Endif
			@ Prow()    ,122 PSAY (nTTotAPEX2 / ( nTTotMLEX2 + nTTotAPEX2 ) ) * 100 Picture "@E 999.99"	//APARA %
		
		Else
			@ Prow()    ,073 PSAY cFrase2 Picture "@X"			
		Endif
        
        //3o. turno
		If nTTotMeta3 > 0
			@ Prow()    ,130 PSAY nTTotMeta3 Picture "@E 99,999,999.99"		//ESTIMADO(MR)        	 	 	
			@ Prow()    ,145 PSAY nTTotMLEX3 Picture "@E 99,999,999.99"     //REAL(MR)
			
			If nTTotMeta3 > nTTotMLEX3
				@ Prow()    ,160 PSAY ( nTTotMeta3 - nTTotMLEX3 ) Picture "@E 99,999,999.99"     //DIFERENÇA (ESTIMADO - REAL)
			Else 
				@ Prow()    ,160 PSAY ( nTTotMLEX3 - nTTotMeta3 ) Picture "@E 99,999,999.99"     //DIFERENÇA (ESTIMADO - REAL)
			Endif
			@ Prow()    ,179 PSAY (nTTotAPEX3 / ( nTTotMLEX3 + nTTotAPEX3 ) ) * 100 Picture "@E 999.99"	//APARA %
		
		Else
			@ Prow()    ,130 PSAY cFrase3 Picture "@X"	
		Endif
    
	EndIf
    //
    
	If Len(aResultPI) > 0	

       
       nTotOPEX1 := nTotMLEX1 := nTotAPEX1 := 0
       nTotMLEX2 := nTotAPEX2 := 0
       nTotMLEX3 := nTotAPEX3 := 0
       nTotMeta1 := nTotMeta2 := nTotMeta3 := 0
       
	   Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  // Impressao do cabecalho
	   
		FOR X := 1 TO Len(aResultPI)
            //TURNO 1
		 	@ Prow() + 2,000 PSAY Left( aResultPI[X,1], 3 )         				//MAQ
		 	@ Prow()    ,005 PSAY aResultPI[X,2] Picture "@E 9999"    	        	//OP
		 	If aResultPI[X,10] > 0
		 		@ Prow(),015 PSAY aResultPI[X,10] Picture "@E 9,999,999.99"  	    //ESTIMADO(MR)		 		 	
		 		@ Prow()    ,030 PSAY aResultPI[X,3] Picture "@E 9,999,999.99"    	//REAL(MR)		 
		 		
		 		If aResultPI[X,10] > aResultPI[X,3]
		 			@ Prow()    ,045 PSAY (aResultPI[X,10] - aResultPI[X,3] ) Picture "@E 9,999,999.99"      //DIFERENÇA (ESTIMADO - REAL)
		 		Else 
		 			@ Prow()    ,045 PSAY (aResultPI[X,3] - aResultPI[X,3] ) Picture "@E 9,999,999.99"      //DIFERENÇA (ESTIMADO - REAL)
		 		Endif
		 		@ Prow()    ,063 PSAY (aResultPI[X,4] / ( aResultPI[X,3] + aResultPI[X,4] )) * 100 Picture "@E 999.99" 	//APARA %		 	
		 	Else
		 		@ Prow()    ,030 PSAY aResultPI[X,3] Picture "@E 9,999,999.99"      		//REAL(MR)		 
		 		@ Prow()    ,063 PSAY (aResultPI[X,4] / ( aResultPI[X,3] + aResultPI[X,4] )) * 100 Picture "@E 999.99" 	//APARA %		 	
		 	Endif		 	
		 	
            //TURNO 2
		 	If aResultPI[X,11] > 0
		 		@ Prow(),073 PSAY aResultPI[X,11] Picture "@E 9,999,999.99"  	    //ESTIMADO(MR)		 		 		
		 		@ Prow()    ,088 PSAY aResultPI[X,5] Picture "@E 9,999,999.99" 		//REAL(MR)		 
		 		
		 		If aResultPI[X,11] > aResultPI[X,5]
		 			@ Prow()    ,103 PSAY ( aResultPI[X,11] - aResultPI[X,5] ) Picture "@E 9,999,999.99"      //DIFERENÇA (ESTIMADO - REAL)
		 		Else 
		 			@ Prow()    ,103 PSAY ( aResultPI[X,5] - aResultPI[X,11] ) Picture "@E 9,999,999.99"      //DIFERENÇA (ESTIMADO - REAL)
		 		Endif
		 		@ Prow()    ,122 PSAY (aResultPI[X,6] / ( aResultPI[X,5] + aResultPI[X,6] )) * 100 Picture "@E 999.99" 	//APARA %		 	
		 	Else
		 		@ Prow()    ,088 PSAY aResultPI[X,5] Picture "@E 9,999,999.99"      		//REAL(MR)		 
		 		@ Prow()    ,122 PSAY (aResultPI[X,6] / ( aResultPI[X,5] + aResultPI[X,6] )) * 100 Picture "@E 999.99" 	//APARA %		 	
		 	Endif		 	
            
			//TURNO 3
		 	If aResultPI[X,12] > 0
		 		@ Prow(),130 PSAY aResultPI[X,12] Picture "@E 9,999,999.99"  	    //ESTIMADO(MR)		 	 	
		 		@ Prow()    ,145 PSAY aResultPI[X,7] Picture "@E 9,999,999.99"     	//REAL(MR)		 			 
		 		
		 		If aResultPI[X,12] > aResultPI[X,7]
		 			@ Prow()    ,160 PSAY (aResultPI[X,12] - aResultPI[X,7] ) Picture "@E 9,999,999.99"      //DIFERENÇA (ESTIMADO - REAL)
		 		Else 
		 			@ Prow()    ,160 PSAY (aResultPI[X,7] - aResultPI[X,12] ) Picture "@E 9,999,999.99"      //DIFERENÇA (ESTIMADO - REAL)
		 		Endif
		 		@ Prow()    ,179 PSAY (aResultPI[X,8] / ( aResultPI[X,7] + aResultPI[X,8] )) * 100 Picture "@E 999.99" 	//APARA %		 	
		 	Else
		 		@ Prow()    ,145 PSAY aResultPI[X,7] Picture "@E 9,999,999.99"     	//REAL(MR)		 			 
		 		@ Prow()    ,179 PSAY (aResultPI[X,8] / ( aResultPI[X,7] + aResultPI[X,8] )) * 100 Picture "@E 999.99" 	//APARA %		 	
		 	
		 	Endif
		 	

		NEXT

		@ Prow() + 2,000 PSAY Repl( "-", 220 )

		For Y := 1 To Len(aResultPI) //da pra otmizar, basta colocar no for do x
			nTotOPEX1 := nTotOPEX1 + aResultPI[Y,2]
			nTotMLEX1 := nTotMLEX1 + aResultPI[Y,3]
			nTotAPEX1 := nTotAPEX1 + aResultPI[Y,4]
			nTotMeta1 := nTotMeta1 + aResultPI[Y,10]

			nTotMLEX2 := nTotMLEX2 + aResultPI[Y,5]
			nTotAPEX2 := nTotAPEX2 + aResultPI[Y,6]
			nTotMeta2 := nTotMeta2 + aResultPI[Y,11]

			nTotMLEX3 := nTotMLEX3 + aResultPI[Y,7]
			nTotAPEX3 := nTotAPEX3 + aResultPI[Y,8]
			nTotMeta3 := nTotMeta3 + aResultPI[Y,12]
		Next
        //TOTAIS 
        //1o. turno
		@ Prow() + 1,005 PSAY nTotOPEX1 Picture "@E 9999"							//OP
		If nTotMeta1 > 0
			@ Prow()    ,015 PSAY nTotMeta1 Picture "@E 99,999,999.99"					//ESTIMADO(MR)
			@ Prow()    ,030 PSAY nTotMLEX1 Picture "@E 99,999,999.99"					//REAL(MR)
			
			If nTotMeta1 > nTotMLEX1
				@ Prow()	,045 PSAY ( nTotMeta1 - nTotMLEX1 ) Picture "@E 99,999,999.99"  //DIFERENÇA (ESTIMADO - REAL)
			Else
				@ Prow()	,045 PSAY ( nTotMLEX1 - nTotMeta1 ) Picture "@E 99,999,999.99"  //DIFERENÇA (ESTIMADO - REAL)
			Endif
			@ Prow()    ,063 PSAY (nTotAPEX1 / ( nTotMLEX1 + nTotAPEX1 ) ) * 100 Picture "@E 999.99"	//APARA %		
        
        Else
        	@ Prow()    ,015 PSAY cFrase1 Picture "@X"	
        Endif
        
		//2o. turno
		If nTotMeta2 > 0
			@ Prow()    ,073 PSAY nTotMeta2 Picture "@E 99,999,999.99"					//ESTIMADO(MR)
			@ Prow()    ,088 PSAY nTotMLEX2 Picture "@E 99,999,999.99"					//REAL(MR)
			
			If nTotMeta2 > nTotMLEX2
				@ Prow()	,103 PSAY ( nTotMeta2 - nTotMLEX2 ) Picture "@E 99,999,999.99"  //DIFERENÇA (ESTIMADO - REAL)
			Else 
				@ Prow()	,103 PSAY ( nTotMLEX2 - nTotMeta2 ) Picture "@E 99,999,999.99"  //DIFERENÇA (ESTIMADO - REAL)
			Endif
			@ Prow()    ,122 PSAY (nTotAPEX2 / ( nTotMLEX2 + nTotAPEX2 ) ) * 100 Picture "@E 999.99"	//APARA %		
        
        Else 
        	@ Prow()    ,073 PSAY cFrase2 Picture "@X"	
        Endif
		
		//3o. turno
		If nTotMeta3 > 0
			@ Prow()    ,130 PSAY nTotMeta3 Picture "@E 99,999,999.99"					//ESTIMADO(MR)
			@ Prow()    ,145 PSAY nTotMLEX3 Picture "@E 99,999,999.99"					//REAL(MR)
			
			If nTotMeta3 > nTotMLEX3
				@ Prow()	,160 PSAY ( nTotMeta3 - nTotMLEX3 ) Picture "@E 99,999,999.99"  //DIFERENÇA (ESTIMADO - REAL)
			Else 
				@ Prow()	,160 PSAY ( nTotMLEX3 - nTotMeta3 ) Picture "@E 99,999,999.99"  //DIFERENÇA (ESTIMADO - REAL)
			Endif
			@ Prow()    ,179 PSAY (nTotAPEX3 / ( nTotMLEX3 + nTotAPEX3 ) ) * 100 Picture "@E 999.99"	//APARA %		
        
        Else 
        	@ Prow()    ,130 PSAY cFrase3 Picture "@X"	
        Endif
        
	EndIf
EndIf

If Len(aResult2) > 0
	nTotOPEX1 := nTotMLEX1 := nTotAPEX1 := 0
	nTotMLEX2 := nTotAPEX2 := 0
	nTotMLEX3 := nTotAPEX3 := 0
	
	Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  // Impressao do cabecalho
	
	FOR X := 1 TO Len(aResult2)
	    //1o. turno
	 	@ Prow() + 2,000 PSAY Left( aResult2[X,1], 3 )                      	//MAQ
	 	@ Prow()    ,005 PSAY aResult2[X,2]  Picture "@E 9999"					//OP
	 	If aResult2[X,10] > 0
	 		@ Prow(),015 PSAY aResult2[X,10] Picture "@E 9,999,999.99"		//ESTIMADO(MR)	 	
	 		@ Prow()    ,030 PSAY aResult2[X,3]  Picture "@E 9,999,999.99"  //REAL(MR)
	 	 	
	 	 	If aResult2[X,10] > aResult2[X,3]
	 	 		@ Prow(),045 PSAY ( aResult2[X,10] - aResult2[X,3] )  Picture "@E 9,999,999.99"      //DIFERENÇA (ESTIMADO - REAL)
	 	 	Else 
	 	 		@ Prow(),045 PSAY ( aResult2[X,3] - aResult2[X,10] )  Picture "@E 9,999,999.99"      //DIFERENÇA (ESTIMADO - REAL)
	 	 	Endif
	 		@ Prow()    ,063 PSAY aResult2[X,4] / ( aResult2[X,3] + aResult2[X,4] ) * 100    Picture "@E 999.99"	//APARA %
	 	Else
	 		@ Prow()    ,030 PSAY aResult2[X,3]  Picture "@E 9,999,999.99"      	//REAL(MR)
	 		@ Prow()    ,063 PSAY aResult2[X,4] / ( aResult2[X,3] + aResult2[X,4] ) * 100    Picture "@E 999.99"	//APARA %	 	
	 	Endif
	 	
	 	//2o. turno
	 	If aResult2[X,11] > 0
	 		@ Prow(),073 PSAY aResult2[X,11] Picture "@E 9,999,999.99"		//ESTIMADO(MR)	 	 	
	 		@ Prow()    ,088 PSAY aResult2[X,5]  Picture "@E 9,999,999.99" 	//REAL(MR)
	 		If aResult2[11] > aResult[5]
	 			@ Prow(),103 PSAY ( aResult2[X,11] - aResult2[X,5] )  Picture "@E 9,999,999.99"      //DIFERENÇA (ESTIMADO - REAL)
	 		Else
	 			@ Prow(),103 PSAY ( aResult2[X,5] - aResult2[X,11] )  Picture "@E 9,999,999.99"      //DIFERENÇA (ESTIMADO - REAL)
	 		Endif
	 		@ Prow()    ,122 PSAY aResult2[X,6] / ( aResult2[X,5] + aResult2[X,6] ) * 100    Picture "@E 999.99"	//APARA %
	 	Else
	 		@ Prow()    ,088 PSAY aResult2[X,5]  Picture "@E 9,999,999.99"     		//REAL(MR) 
	 		@ Prow()    ,122 PSAY aResult2[X,6] / ( aResult2[X,5] + aResult2[X,6] ) * 100    Picture "@E 999.99"	//APARA %
	 	Endif
	 	
	 	//3o. turno
	 	If aResult2[X,12] > 0
	 		@ Prow(),130 PSAY aResult2[X,12] Picture "@E 9,999,999.99"		//ESTIMADO(MR)	 	 	
	 		@ Prow()    ,145 PSAY aResult2[X,7]  Picture "@E 9,999,999.99"      //REAL(MR)
	 		If aResult2[X,12] > aResult2[X,7]
	 			@ Prow()    ,160 PSAY ( aResult2[X,12] - aResult2[X,7] )  Picture "@E 9,999,999.99"      //DIFERENÇA (ESTIMADO - REAL)
	 		Else
	 			@ Prow()    ,160 PSAY ( aResult2[X,7] - aResult2[X,12] )  Picture "@E 9,999,999.99"      //DIFERENÇA (ESTIMADO - REAL)
	 		Endif
	 		
	 		@ Prow()    ,179 PSAY aResult2[X,8] / ( aResult2[X,7] + aResult2[X,8] ) * 100    Picture "@E 999.99"	//APARA %
        Else
        	@ Prow()    ,145 PSAY aResult2[X,7]  Picture "@E 9,999,999.99"      //REAL(MR)
        	@ Prow()    ,179 PSAY aResult2[X,8] / ( aResult2[X,7] + aResult2[X,8] ) * 100    Picture "@E 999.99"	//APARA %
        Endif

		nTotOPEX1 := nTotOPEX1 + aResult2[X,2 ]
		nTotMLEX1 := nTotMLEX1 + aResult2[X,3 ]
		nTotAPEX1 := nTotAPEX1 + aResult2[X,4 ]
		nTotMeta1 := nTotMeta1 + aResult2[X,10]

		nTotMLEX2 := nTotMLEX2 + aResult2[X,5]
		nTotAPEX2 := nTotAPEX2 + aResult2[X,6]
		nTotMeta2 := nTotMeta2 + aResult2[X,11]

		nTotMLEX3 := nTotMLEX3 + aResult2[X,7]
		nTotAPEX3 := nTotAPEX3 + aResult2[X,8]
		nTotMeta3 := nTotMeta3 + aResult2[X,12]

	NEXT
	    @ Prow() + 2,000 PSAY Repl( "-", 220 )
		@ Prow() + 1,005 PSAY nTotOPEX1  Picture "@E 9999" 					//OP
		If nTotMeta1 > 0
			@ Prow()    ,015 PSAY nTotMeta1  Picture "@E 99,999,999.99"     //ESTIMADO(MR)
			@ Prow()    ,030 PSAY nTotMLEX1  Picture "@E 99,999,999.99"     //REAL(MR)
			If nTotMeta1 > nTotMLEX1
				@ Prow()    ,045 PSAY ( nTotMeta1 - nTotMLEX1 )  Picture "@E 99,999,999.99"	//DIFERENÇA (ESTIMADO - REAL)
			Else
				@ Prow()    ,045 PSAY ( nTotMLEX1 - nTotMeta1 )  Picture "@E 99,999,999.99"	//DIFERENÇA (ESTIMADO - REAL)
			Endif
			@ Prow()	,063 PSAY (nTotAPEX1 / (nTotMLEX1 + nTotAPEX1 ))  * 100 Picture "@E 999.99"		//APARA %
        
        Else
        	@ Prow()    ,015 PSAY cFrase1  Picture "@X"     			//ESTIMADO(MR)	
		Endif
		
		If nTotMeta2 > 0
			@ Prow()    ,073 PSAY nTotMeta2  Picture "@E 99,999,999.99"     //ESTIMADO(MR)
			@ Prow()    ,088 PSAY nTotMLEX2 Picture "@E 99,999,999.99"      //REAL(MR)
			If nTotmeta2 > nTotMLEX2
				@ Prow()    ,103 PSAY (nTotMeta2 - nTotMLEX2 )  Picture "@E 99,999,999.99"	//DIFERENÇA (ESTIMADO - REAL)
			Else
				@ Prow()    ,103 PSAY (nTotMLEX2 - nTotMeta2 )  Picture "@E 99,999,999.99"	//DIFERENÇA (ESTIMADO - REAL)
			Endif
			@ Prow()	,122 PSAY (nTotAPEX1 / (nTotMLEX1 + nTotAPEX1)) * 100 Picture "@E 999.99"		//APARA %
        
        Else
        	@ Prow()    ,073 PSAY cFrase2  Picture "@X"   			  //ESTIMADO(MR)		
        Endif
        
		If nTotMeta3 > 0
			@ Prow()    ,130 PSAY nTotMeta3  Picture "@E 99,999,999.99"     //ESTIMADO(MR)
			@ Prow()    ,145 PSAY nTotMLEX3 Picture "@E 99,999,999.99"      //REAL(MR)
			If nTotMeta3 > nTotMLEX3
				@ Prow()    ,160 PSAY (nTotMeta3 - nTotMLEX3 )  Picture "@E 99,999,999.99"	//DIFERENÇA (ESTIMADO - REAL)
			Else
				@ Prow()    ,160 PSAY (nTotMLEX3 - nTotMeta3 )  Picture "@E 99,999,999.99"	//DIFERENÇA (ESTIMADO - REAL)
			Endif
			@ Prow()	,179 PSAY (nTotAPEX3 / (nTotMLEX3 + nTotAPEX3)) * 100 Picture "@E 999.99"		//APARA %
		
		Else
			@ Prow()    ,130 PSAY cFrase3  Picture "@X" 			    //ESTIMADO(MR)		
		Endif

EndIF

Z00X->( DbCloseArea() )
Roda( 0, "", TAMANHO )

If aReturn[ 5 ] == 1
   Set Printer To
   Commit
   ourspool( wnrel ) //Chamada do Spool de Impressao
Endif


Return NIL





********************************************
Static Function fPegaHoraI(cMAQ,cTurno,cOP)
********************************************

Local cQueryf := ""          
Local cHoraI  := ""


//REGISTRO INÍCIO DE OPERAÇÃO
cQueryf := " SELECT TOP 1 ZB0_FILIAL,ZB0_MAQ,ZB0_OP,ZB0_DATA,ZB0_HORA,ZB0_TIPO "    //Vai capturar o primeiro registro
cQueryf += " FROM ZB0020 ZB0" 	
cQueryf += " WHERE ZB0.ZB0_MAQ =  '" + Alltrim(cMAQ) + "' " 
cQueryf += " AND ZB0.ZB0_OP = '" + Alltrim(cOP) + "' "

If cTurno = "1"
	cQueryf += " AND ( ZB0_DATA + ZB0_HORA ) BETWEEN '" + Dtos(mv_par01) + "05:35:00'" + " AND '" + DtoS( mv_par02 ) + "13:55:00'"

Elseif cTurno = "2" 
	cQueryf += " AND ( ZB0_DATA + ZB0_HORA ) BETWEEN '" + Dtos(mv_par01) + "13:56:00'" + " AND '" + DtoS( mv_par02 ) + "22:00:00'"

Elseif cTurno = "3"
	cQueryf += " AND ( ZB0_DATA + ZB0_HORA ) BETWEEN '" + Dtos(mv_par01) + "22:01:00'" + " AND '" + DtoS( mv_par02 + 1 ) + "05:30:00'"
Endif
cQueryf += " AND ZB0_FILIAL = '" + xFilial( "ZB0" ) + "' AND D_E_L_E_T_ = ' ' "
cQueryf += " AND ZB0_TIPO = '0' "		//ZB0_TIPO = 0 Significa que é o registro de entrada, início da operação
cQueryf += " ORDER BY ZB0_DATA,ZB0_HORA "		
cQueryf := ChangeQuery( cQueryf )

//MemoWrite("C:\HORAI.sql",cQueryf)

cHoraI := ""

If Select("HORAI") > 0
	DbSelectArea("HORAI")
	DbCloseArea()
EndIf

TCQUERY cQueryf NEW ALIAS "HORAI" 

HORAI->( DbGoTop() )

Do While !HORAI->( Eof() )

	cHoraI := (HORAI->ZB0_HORA)	
	HORAI->(DBSKIP())
	
Enddo

If Empty(cHoraI)
	cHoraI := "X"
ElseIf Len(cHoraI) <= 5
	cHoraI := cHoraI + ":00"
Endif



DbSelectArea("HORAI")
DbCloseArea()

Return(cHoraI)


********************************************
Static Function fPegaHoraF(cMAQ,cTurno,cOP)
********************************************

Local cQueryg := ""
Local cHoraF  := ""

//REGISTRO FIM DE OPERAÇÃO
cQueryg := " SELECT TOP 1 ZB0_FILIAL,ZB0_MAQ,ZB0_OP,ZB0_DATA,ZB0_HORA,ZB0_TIPO "    //Vai capturar o primeiro registro
cQueryg += " FROM  ZB0020 ZB0"  // + RetSqlname("ZB0") + " ZB0 "
cQueryg += " WHERE ZB0.ZB0_MAQ = '" + Alltrim(cMAQ) + "' " 
cQueryg += " AND ZB0.ZB0_OP = '" + Alltrim(cOP) + "' "

If cTurno = "1"
	cQueryg += " AND ( ZB0_DATA + ZB0_HORA ) BETWEEN '" + Dtos(mv_par01) + "05:35:00'" + " AND '" + DtoS( mv_par02 ) + "13:55:00'"

Elseif cTurno = "2" 
	cQueryg += " AND ( ZB0_DATA + ZB0_HORA ) BETWEEN '" + Dtos(mv_par01) + "13:56:00'" + " AND '" + DtoS( mv_par02 ) + "22:00:00'"

Elseif cTurno = "3"
	cQueryg += " AND ( ZB0_DATA + ZB0_HORA ) BETWEEN '" + Dtos(mv_par01) + "22:01:00'" + " AND '" + DtoS( mv_par02 + 1 ) + "05:30:00'"
Endif
cQueryg += " AND ZB0_FILIAL = '" + xFilial( "ZB0" ) + "' AND D_E_L_E_T_ = ' ' "
cQueryg += " AND ZB0_TIPO = '1' "		//ZB0_TIPO = 0 Significa que é o registro de entrada, início da operação
cQueryg += " ORDER BY ZB0_DATA,ZB0_HORA DESC "
cQueryg := ChangeQuery( cQueryg )

//MemoWrite("C:\HORAF.sql",cQueryg)


cHoraF := ""

If Select("HORAF") > 0
	DbSelectArea("HORAF")
	DbCloseArea()
EndIf

TCQUERY cQueryg NEW ALIAS "HORAF" 

HORAF->( DbGoTop() )

Do While !HORAF->( Eof() )

	cHoraF := (HORAF->ZB0_HORA)
	
	HORAF->(DBSKIP())
Enddo 


If Empty(cHoraF)
	//cHoraF := "X"
	cHoraF := fMaxHoraF( cMAQ,cTurno,cOP )
ElseIf Len(cHoraF) <= 5
	cHoraF := cHoraF + ":00"
Endif

If Empty(cHoraF)
	cHoraF := "X"
Endif

DbSelectArea("HORAF")
DbCloseArea()

Return(cHoraF)


***************************************************************
Static Function fDifData(cDataIni,cDataFim,cHoraIni,cHorafim )
***************************************************************


Local dDataI
Local dDataF
Local cHoraIn
Local cHoraFn 
Local nDifdia := 0
Local nDifhora:= 0
Local cElap1
Local cElap2
Local cHoraspassou := ""
Local nHoraspassou := 0
Local cMeiaNoite
Local cDozeHoras
Local cElap
Local cH
Local nHorastotal  := 0
Local fa := 0

set date brit

dDataI := cDataIni
dDataF := cDataFim
cHoraIn := cHoraIni
cHoraFn := cHoraFim

cMeiaNoite := "24:00:00"
cDozeHoras := "12:00:00"
cElap := ""
cH    := ""


nDifdia := (dDataF - dDataI)


If nDifdia = 0
	cElap1 := ElapTime( cHoraIn, cHoraFn ) // Resultado: "01:15:15"
	nHoraspassou := 0

Elseif nDifdia >= 1
	
	For fa := 1 to nDifdia
		cH     := cHoraI
		cElap  := ElapTime(cH,cMeiaNoite) 
		cHoraspassou := cElap
		nHoraspassou += Val(cHoraspassou)
		cHoraI := cDozeHoras	
		
	Next
	
	cElap1 := Elaptime(cHoraI,cHoraF)

Endif

nHorastotal := Val(cElap1) + nHoraspassou



Return(nHorastotal)
//----------------------------------------
               

****************************************************
Static Function fExistZB0( cMAQUINA, cOPE, cTurno )
****************************************************

Local lExiste := .F.
Local cQry	  := ""


cQry := " SELECT ZB0_MAQ,ZB0_OP,ZB0_DATA,ZB0_HORA "    
cQry += " FROM  ZB0020 ZB0 "  
cQry += " WHERE ZB0.ZB0_MAQ = '" + Alltrim(cMAQUINA) + "' " 
cQry += " AND ZB0.ZB0_OP = '" + Alltrim(cOPE) + "' "
If cTurno = "1"
	cQry += " AND ( ZB0_DATA + ZB0_HORA ) BETWEEN '" + Dtos(mv_par01) + "05:35:00'" + " AND '" + DtoS( mv_par02 ) + "13:55:00'"

Elseif cTurno = "2" 
	cQry += " AND ( ZB0_DATA + ZB0_HORA ) BETWEEN '" + Dtos(mv_par01) + "13:56:00'" + " AND '" + DtoS( mv_par02 ) + "22:00:00'"

Elseif cTurno = "3"
	cQry += " AND ( ZB0_DATA + ZB0_HORA ) BETWEEN '" + Dtos(mv_par01) + "22:01:00'" + " AND '" + DtoS( mv_par02 + 1 ) + "05:30:00'"
Endif
cQry += " AND D_E_L_E_T_ <> '*' "
cQry := ChangeQuery( cQry )

//MemoWrite("C:\EXISTZB0.sql",cQry)


If Select("EXTZB0") > 0
	DbSelectArea("EXTZB0")
	DbCloseArea()
EndIf

TCQUERY cQry NEW ALIAS "EXTZB0" 

EXTZB0->( DbGoTop() )

Do While !EXTZB0->( Eof() )
	If Select("EXTZB0") > 0
		lExiste := .T.
    Endif
	EXTZB0->( DbSkip() )

Enddo

DbSelectArea("EXTZB0")
DbCloseArea()


Return(lExiste)

***************************************************
Static Function fMaxHoraF( cMaquina, cTurno, cOP )
***************************************************

Local cQuery    := ""
Local cMaxHoraF := ""

cQf := " SELECT MAX(ZB0_HORA) AS ZB0_HORA "   
cQf += " FROM  ZB0020 ZB0 " 
cQf += " WHERE ZB0.ZB0_MAQ = '" + Alltrim(cMaquina) + "' " 
cQf += " AND ZB0.ZB0_OP = '" + Alltrim(cOP) + "' "

If cTurno = "1"
	cQf += " AND ( ZB0_DATA + ZB0_HORA ) BETWEEN '" + Dtos(mv_par01) + "05:35:00'" + " AND '" + DtoS( mv_par02 ) + "13:55:00'"

Elseif cTurno = "2" 
	cQf += " AND ( ZB0_DATA + ZB0_HORA ) BETWEEN '" + Dtos(mv_par01) + "13:56:00'" + " AND '" + DtoS( mv_par02 ) + "22:00:00'"

Elseif cTurno = "3"
	cQf += " AND ( ZB0_DATA + ZB0_HORA ) BETWEEN '" + Dtos(mv_par01) + "22:01:00'" + " AND '" + DtoS( mv_par02 + 1 ) + "05:30:00'"
Endif
cQf += " AND ZB0_FILIAL = '" + xFilial( "ZB0" ) + "' AND D_E_L_E_T_ = ' ' "
cQf := ChangeQuery( cQf )
//MemoWrite( "C:\MAXHF.sql",cQf )

If Select("MAXHF") > 0
	DbSelectArea("MAXHF")
	DbCloseArea()
EndIf

TCQUERY cQf NEW ALIAS "MAXHF" 

MAXHF->( DbGoTop() )

Do While !MAXHF->( Eof() )
	
	If Select("MAXHF") > 0
		cMaxHoraF := MAXHF->ZB0_HORA
	Endif
	MAXHF->(DBSKIP())
Enddo  

Return(cMaxHoraF)