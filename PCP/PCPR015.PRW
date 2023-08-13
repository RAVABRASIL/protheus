#include "rwmake.ch"  
#include "topconn.ch" 
#include "protheus.ch"

//----------------------------------------------------------------
//Programa: ESTRZB1 - NOVO PCPR015
//Objetivo: Emitir relatório do que foi produzido x meta
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 31/10/09
//-----------------------------------------------------------------

User Function PCPR015()

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
nomeprog  := "PCPR015"
cPerg     := "PCPR015"
nLastKey  := 0
lContinua := .T.
nLin      := 9
wnrel     := "PCPR015"
M_PAG     := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Validperg()
Pergunte( cPerg, .T. )               // Pergunta no SX1

	
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


Local cElap1 := "" 
Local cHorAgora := ""     
Local cQuery := ""
Local nIntervalo := 1

Local nMeta1 := nMeta2 := nMeta3 := 0
/////////////
Local nTAPARA1   := nTAPARA2   := nTAPARA3   := 0
Local cMAQ    := ""
Local cLADO	  := ""
Local fr	  := 0
	
 	
Local nREAL1_A := nREAL2_A := nREAL3_A := 0
Local nREAL1_B := nREAL2_B := nREAL3_B := 0
Local nREAL1_U := nREAL2_U := nREAL3_U := 0
 	
Local nAPARA1 := nAPARA2 := nAPARA3 := 0
 	
Local nMetaZB1 := 0

Private cTurnoAtual := ""

Private nMeta1_A  := nMeta2_A   := nMeta3_A   := 0
Private nMeta1_B  := nMeta2_B   := nMeta3_B   := 0
Private nMeta1_U  := nMeta2_U   := nMeta3_U   := 0

Private nTTMeta1A  := 0
Private nTTMeta2A  := 0
Private nTTMeta3A  := 0

Private nTTMeta1B  := 0
Private nTTMeta2B  := 0
Private nTTMeta3B  := 0

Private nTTMeta1U := 0
Private nTTMeta2U := 0
Private nTTMeta3U := 0		     		     

Private nTotMeta1A  := 0
Private nTotMeta2A  := 0
Private nTotMeta3A  := 0

Private nTotMeta1B  := 0
Private nTotMeta2B  := 0
Private nTotMeta3B  := 0

Private nTotMeta1U  := 0
Private nTotMeta2U  := 0
Private nTotMeta3U  := 0


Private nTTMLEX1A := 0
Private nTTMLEX1B := 0

Private nTTMLEX2A := 0
Private nTTMLEX2B := 0

Private nTTMLEX3A := 0
Private nTTMLEX3B := 0

Private nTotMLEX1A := 0
Private nTotMLEX1B := 0

Private nTotMLEX2A := 0
Private nTotMLEX2B := 0

Private nTotMLEX3A := 0
Private nTotMLEX3B := 0

Private nTTMLEX1U := 0 
Private nTTMLEX2U := 0 
Private nTTMLEX3U := 0 

Private nTotMLEX1U := 0
Private nTotMLEX2U := 0            
Private nTotMLEX3U := 0

Private nTTAPEX1 := 0
Private	nTTAPEX2 := 0
Private	nTTAPEX3 := 0

Private nTotAPEX1 := 0
Private	nTotAPEX2 := 0
Private	nTotAPEX3 := 0
Private LF := CHR(13) + CHR(10)
Private aMetas	:= {} 

//Parâmetros:
//--------------------------
// mv_par01 - Data 
// mv_par02 - Máquina
// mv_par03 - Produto de
// mv_par04 - Produto até
//--------------------------

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa  de variaveis                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTurnoAtu := GetTurno()          //FR: Obtém o turno atual que será usado para mostrar os apontamentos

Private cTURNO1   := GetMv( "MV_TURNO1" )
Private cTURNO2   := GetMv( "MV_TURNO2" )
Private cTURNO3   := GetMv( "MV_TURNO3" )
Private cTURNO1_A := Left( U_Somahora( Left( cTURNO1, 5 ) + ":00", "00:15:00" ), 5 ) + "," + SubStr( cTURNO1, 7, 5 )  // Soma 15 minutos p/ apara
Private cTURNO2_A := Left( U_Somahora( Left( cTURNO2, 5 ) + ":00", "00:15:00" ), 5 ) + "," + SubStr( cTURNO2, 7, 5 )
Private cTURNO3_A := Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", "00:15:00" ), 5 ) + "," + SubStr( cTURNO3, 7, 5 )

Private dDIA := mv_par01 //If( Time() < Left( cTURNO1, 5 ) + ":00", Date() - 1, Date() ) 
Private lDiaCompleto := iif(dDatabase - dDIA = 1, .T., .F.) 
//SE A Diferença entre a DATA DO RELATÓRIO - O PARÂMETRO DATA INICIAL = 1 Dia, é porque já temos 3 turnos completos


Private aResult 	:= {}
Private aResult2	:= {}
Private aResultPI 	:= {}
Private aResult3 	:= {}
Private aResult4 	:= {}
Private aResultTT	:= {}

Private nPerDif1 := 0
Private nPerDif2 := 0
Private nPerDif3 := 0

Private nLados	 := 0

Private cHoraIni1   := "05:50:00" 
Private cHoraFim1   := "13:55:00" 
Private cHoraIni2   := "13:56:00" 
Private cHoraFim2   := "22:00:00" 
Private cHoraIni3   := "22:00:00" 
Private cHoraFim3   := "05:30:00"


Cabec1 := "     /-------------------T U R N O 1 ---------------------\/----------------------- T U R N O 2 -----------------\ /------------------------ T U R N O 3 -----------------\ "
Cabec2 := "MAQ     META          REAL      DIF.(MR)  DIF.(%) APARA(%)    META          REAL      DIF.(MR)    DIF(%)  APARA(%)     META         REAL      DIF.(MR)    DIF(%)  APARA(%)
Cabec3 := ""      
//         XXX 999,999.99  999,999.99  999,999.99  999.99  999.99   999,999.99   999,999.99  999,999.99    999.99   999.99   999,999.99   999,999.99  999,999.99   999.99  999.99
//         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//         0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        	        22        23        24        25


//cTurnoAtual := GetTurno()          //FR: Obtém o turno atual que será usado para mostrar os apontamentos
//MSGBOX("turno atual: " + cTurnoAtual)


cQuery := "SELECT Z00.Z00_LADO, Z00.Z00_CODIGO, Z00.Z00_OP , Z00.Z00_MAQ , Z00.Z00_PESO "  + LF
cQuery += " ,Z00_APARA , Z00.Z00_DATA , Z00.Z00_HORA , Z00.Z00_QUANT "   + LF
cQuery += " ,Z00.Z00_PESCAP , Z00.Z00_PESDIF, ZB1.ZB1_META, ZB1.ZB1_MAQ, ZB1.ZB1_LADO  "   + LF

///as subqueries abaixo me ajudarão a obter a data e hora inicial, e data e hora final que o produto passou pela máquina
/*
//dt inicial
cQuery += " ,DTi = (SELECT TOP 1 LEFT((Z1.Z00_DATA + Z1.Z00_HORA),8) "   + LF
cQuery += " 			FROM " + RetSqlName( "Z00" ) + " Z1 "   + LF 
cQuery += " 			WHERE Z1.Z00_CODIGO = Z00.Z00_CODIGO  "   + LF
cQuery += " 			AND Z1.Z00_MAQ = Z00.Z00_MAQ  "   + LF
cQuery += " 			AND (Z1.Z00_DATA + Z1.Z00_HORA)  >= ( '" + Dtos( mv_par01 ) + "' + '05:35:00' ) " + LF
cQuery += " 			AND Z1.D_E_L_E_T_ = '' "   + LF
cQuery += " 			ORDER BY (Z1.Z00_DATA + Z1.Z00_HORA) ) "   + LF

//hora inicial
cQuery += " ,HORAi = (SELECT TOP 1 RIGHT((Z2.Z00_DATA + Z2.Z00_HORA),5) + Z2.Z00_LADO"   + LF
cQuery += " 			FROM Z00020 Z2 "   + LF
cQuery += " 			WHERE Z2.Z00_CODIGO = Z00.Z00_CODIGO  "   + LF
cQuery += " 			AND Z2.Z00_MAQ = Z00.Z00_MAQ  "   + LF
cQuery += " 			AND (Z2.Z00_DATA + Z2.Z00_HORA)  >= ( '" + Dtos( mv_par01 ) + "' + '05:35:00' ) " + LF
cQuery += " 			AND Z2.D_E_L_E_T_ = '' "   + LF
cQuery += " 			ORDER BY (Z2.Z00_DATA + Z2.Z00_HORA) ) "   + LF

//dt final
cQuery += " ,DTf = (SELECT TOP 1 LEFT((Z3.Z00_DATA + Z3.Z00_HORA),8) "   + LF
cQuery += " 			FROM " + RetSqlName( "Z00" ) + " Z3 "   + LF 
cQuery += " 			WHERE Z3.Z00_CODIGO = Z00.Z00_CODIGO  "   + LF
cQuery += " 			AND Z3.Z00_MAQ = Z00.Z00_MAQ  "   + LF
cQuery += " 			AND (Z3.Z00_DATA + Z3.Z00_HORA)  >= ( '" + Dtos( mv_par01 ) + "' + '05:35:00' ) " + LF
cQuery += " 			AND Z3.D_E_L_E_T_ = '' "   + LF
cQuery += " 			ORDER BY (Z3.Z00_DATA + Z3.Z00_HORA) DESC ) "   + LF

//hora final
cQuery += " ,HORAf = (SELECT TOP 1 RIGHT((Z4.Z00_DATA + Z4.Z00_HORA),5) + Z4.Z00_LADO "   + LF
cQuery += " 			FROM Z00020 Z4 "   + LF
cQuery += " 			WHERE Z4.Z00_CODIGO = Z00.Z00_CODIGO  "   + LF
cQuery += " 			AND Z4.Z00_MAQ = Z00.Z00_MAQ  "   + LF
cQuery += " 			AND (Z4.Z00_DATA + Z4.Z00_HORA)  >= ( '" + Dtos( mv_par01 ) + "' + '05:35:00' ) " + LF
cQuery += " 			AND Z4.D_E_L_E_T_ = '' "   + LF
cQuery += " 			ORDER BY (Z4.Z00_DATA + Z4.Z00_HORA) DESC ) "   + LF
*/

cQuery += " FROM " + LF
cQuery += " " + RetSqlName( "Z00" ) + " Z00, "   + LF
cQuery += " " + RetSqlName( "ZB1" ) + " ZB1 "   + LF

cQuery += " WHERE " + LF 

cQuery += " (Z00.Z00_DATA )  >= ( '" + Dtos( mv_par01 ) + "'  ) " + LF
cQuery += " AND ( Z00.Z00_DATA + Z00.Z00_HORA)  <= ( '" + Dtos( mv_par01 + 1 ) + "' + '05:30:00' ) " + LF

///voltar
If !Empty(mv_par02)
	cQuery += " AND Z00.Z00_MAQ = '" + Alltrim(mv_par02) + "' " + LF
Endif

//cQuery += " AND Z00.Z00_MAQ IN ('C01','C02','C03' ) " + LF		//testes

//If !Empty(mv_par04) .and. !Empty(mv_par05)
	cQuery += " AND Z00.Z00_CODIGO >= '" + Alltrim(mv_par03) + "' AND Z00.Z00_CODIGO <= '" + Alltrim(mv_par04) + "' " + LF
//Endif

//cQuery += " AND Z00.Z00_CODIGO IN ( 'EGA037' , 'EGC038' ) " + LF //TESTE

If !Empty(mv_par05)
	cQuery += " AND Z00.Z00_LADO = '" + Alltrim(mv_par05) + "' " + LF

Endif

cQuery += " AND ZB1.ZB1_PROD = Z00.Z00_CODIGO " + LF
cQuery += " AND ZB1.ZB1_LADO = Z00.Z00_LADO " + LF
cQuery += " AND ZB1.ZB1_MAQ = Z00.Z00_MAQ " + LF

cQuery += " AND Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' "   + LF

cQuery += " AND Z00.D_E_L_E_T_ = '' "   + LF
cQuery += " AND Z00.D_E_L_E_T_ = '' "   + LF

//cQuery += " AND Z00.Z00_MAQ <> 'XXX' "    + LF
cQuery += "AND Z00.Z00_MAQ NOT IN ('XXX','MONT','CX','ICVR','MONT','CVP','PLAST','DOB','LA01','FC01','SEL','CVFEVA') "
cQuery += " AND Z00.Z00_OP <> '' "  + LF
cQuery += " AND Z00.Z00_CODIGO <> '' "  + LF
//cQuery += " ORDER BY Z00.Z00_MAQ,Z00.Z00_CODIGO,Z00.Z00_DATA,Z00.Z00_HORA, Z00.Z00_LADO "    + LF
cQuery += " ORDER BY Z00.Z00_MAQ,Z00.Z00_DATA,Z00.Z00_HORA, Z00.Z00_CODIGO "    + LF

MemoWrite("C:\Temp\PCPR015.sql", cQuery)

If Select("Z00X") > 0
	DbSelectArea("Z00X")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "Z00X"
TCSetField( 'Z00X', "Z00_DATA", "D" )
TCSetField( 'Z00X', "DTi", "D" )
TCSetField( 'Z00X', "DTf", "D" )

nTAPARA1   := nTAPARA2   := nTAPARA3   := 0
nTQTDMR1_2 := nTQTDMR2_2 := nTQTDMR3_2 := 0
nTAPARA1_2 := nTAPARA2_2 := nTAPARA3_2 := 0

nMeta1_A   := nMeta2_A   := nMeta3_A   := 0
nMeta1_B   := nMeta2_B   := nMeta3_B   := 0
nMeta1_U   := nMeta2_U   := nMeta3_U   := 0

cLado		:= ""

//a tabela ZB0 não será mais utilizada.
//lExistZB0  := .F.
//cFrase1:= "Turno 1 - Não existe registro de operação - tabela ZB0"
//cFrase2:= "Turno 2 - Não existe registro de operação - tabela ZB0"
//cFrase3:= "Turno 3 - Não existe registro de operação - tabela ZB0"
		 

Z00X->( DBGoTop() )
SetRegua( Lastrec() )
mPag := 1

//tmp:=0
TITULO := AllTrim( TITULO ) + " - " + Dtoc( MV_PAR01 )  

If !Empty(MV_PAR05)
	titulo    += " - LADO: " + mv_par05
Endif

Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  //Impressao do cabecalho

@Prow()+1,000 PSAY Cabec3
@Prow() + 1,000 PSAY REPLICATE("_",220)

aResult 	:= {}
aResult2	:= {}
aResultPI 	:= {}
aResult3 	:= {}
aResult4 	:= {}
aResultTT	:= {} 
aProdutos   := {}
aProdutos1 := {}
aProdutos2 := {}
aProdutos3 := {}
aDataHoras := {}


Do While ! Z00X->( Eof() )  

 If !EMPTY(Z00X->Z00_MAQ) .AND. !(alltrim(Z00X->Z00_MAQ) $ 'EXT/COST')

 	cMAQ    := Z00X->Z00_MAQ
 	cLADO	:= Z00X->Z00_LADO
 	 	
 	nQTDMR1 := nQTDMR2 := nQTDMR3 := 0
 	
 	nREAL1_A := nREAL2_A := nREAL3_A := 0
 	nREAL1_B := nREAL2_B := nREAL3_B := 0
 	nREAL1_U := nREAL2_U := nREAL3_U := 0
 	
 	nAPARA1 := nAPARA2 := nAPARA3 := 0
 	
       
 	Do While !Z00X->( Eof() ) .and. Z00X->Z00_MAQ == cMAQ 

 		//nLados := TrazLados(cMAQ)
 	    
 		//cProdu	 := Z00X->Z00_CODIGO
 		nMetaZB1 := 0
 		
	 		DbselectArea("Z00X")
	 		If Z00X->Z00_APARA == " " //se nao produzir apara
	 		
	 			If      ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) >= ( DtoS(mv_par01) + "05:35:00" ) ;
	 			  .and. ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) <= ( DtoS(mv_par01) + "13:55:00" )
	                
	               	//nQTDMR1  += Z00X->Z00_QUANT / 1000 		//REAL(MR)
	                          
		               	If Alltrim(Z00X->Z00_LADO) = "A"
		               		nREAL1_A += Z00X->Z00_QUANT / 1000
		               		
		               	Elseif Alltrim(Z00X->Z00_LADO) = "B"
		               	
		               	    nREAL1_B += Z00X->Z00_QUANT / 1000
		               			
	               		Elseif Alltrim(Z00X->Z00_LADO) = ""
	               		
	               			nREAL1_U += Z00X->Z00_QUANT / 1000   //se não tem lado registrado soma no LADO A (supõe-se uma máquina de lado único)
	               		Endif
	 			
	 			ElseIf  ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) >= ( DtoS(mv_par01) + "13:56:00" ) ;
	 			  .and. ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) <= ( DtoS(mv_par01) + "22:00:00" )
	 			 	
	 				//nQTDMR2  += Z00X->Z00_QUANT / 1000 	  //REAL(MR)		 	
	 			
		 				If Alltrim(Z00X->Z00_LADO) = "A"
		               		nREAL2_A += Z00X->Z00_QUANT / 1000
		               		
		               	Elseif Alltrim(Z00X->Z00_LADO) = "B"
		               	
		               	    nREAL2_B += Z00X->Z00_QUANT / 1000
		               	 
	               		Elseif Alltrim(Z00X->Z00_LADO) = ""
	               			nREAL2_U += Z00X->Z00_QUANT / 1000		
	               		Endif
	 			
	 			ElseIf  ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) >=  ( DtoS(mv_par01) + "22:01:00" ) ;
	 			  .and. ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) <=  ( DtoS(mv_par01 + 1) + "05:30:00" )
	 			 	
	 				//nQTDMR3  += Z00X->Z00_QUANT / 1000 	//REAL(MR)
	 			
		 				If Alltrim(Z00X->Z00_LADO) = "A"
		               		nREAL3_A += Z00X->Z00_QUANT / 1000
		               		
		               	Elseif Alltrim(Z00X->Z00_LADO) = "B"
		               	
		               	    nREAL3_B += Z00X->Z00_QUANT / 1000
		               	
	               		Elseif Alltrim(Z00X->Z00_LADO) = ""
	               		
	               			nREAL3_U += Z00X->Z00_QUANT / 1000		
	               		Endif			 
	 			
	 			Endif	
	 			
	 				
	 		
	        ElseIf Alltrim(Z00X->Z00_APARA) # "" //"12" //checa se apara possui 1 ou 2, caso produza refugo	 			
	 			
	 			If      ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) >= ( DtoS(mv_par01) + "05:35:00") ;
	 			  .and. ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) <= ( DtoS(mv_par01) + "13:55:00" )
	 				nAPARA1  += Z00X->Z00_PESO
	 				nTAPARA1 += Z00X->Z00_PESO
	 			
	 			ElseIf ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) >= ( DtoS(mv_par01) + "13:56:00" ) ;
	 			 .and. ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) <= ( DtoS(mv_par01) + "22:00:00" )
	 				nAPARA2  += Z00X->Z00_PESO
	 				nTAPARA2 += Z00X->Z00_PESO
	 		
	 			ElseIf  ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) >= ( DtoS(mv_par01) + "22:01:00" ) ;
	 			  .and. ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) <= ( DtoS(mv_par01 + 1 ) + "05:30:00" )
	 				nAPARA3  += Z00X->Z00_PESO
	 				nTAPARA3 += Z00X->Z00_PESO
	 			EndIf
	 			
	 		EndIf
 		Dbselectarea("Z00X")
 		Z00X->( DbSkip() )
 	 	IncRegua()
 	EndDo
 	
   
    nMeta1_A   := nMeta2_A   := nMeta3_A   := 0
	nMeta1_B   := nMeta2_B   := nMeta3_B   := 0
	nMeta1_U   := nMeta2_U   := nMeta3_U   := 0
	
       
   	        
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
						  nMeta3,; 			//12
						  nREAL1_A,;		//13
						  nREAL1_B,;        //14
						  nREAL2_A,;        //15
						  nREAL2_B,;        //16
						  nREAL3_A,;        //17
						  nREAL3_B,;        //18
						  nMeta1_A,;        //19
						  nMeta1_B,;        //20
						  nMeta2_A,;        //21
						  nMeta2_B,;        //22
						  nMeta3_A,;        //23
						  nMeta3_B,;        //24
						  nMeta1_U,;        //25
						  nMeta2_U,;        //26
						  nMeta3_U,;        //27
						  nREAL1_U,;        //28
						  nREAL2_U,;        //29
						  nREAL3_U  } )     //30
						   																				  
	ElseIF Alltrim(cMAQ) $ "I01/I02"
			
		Aadd (aResult3, {cMAQ,;  		//1
					 nAPARA1,;      	//2
		  			 nAPARA2,;      	//3
					 nAPARA3,;      	//4
					 nREAL1_A,;			//5
					 nREAL1_B,;        //6
					 nREAL2_A,;        //7
					 nREAL2_B,;        //8
					 nREAL3_A,;        //9
					 nREAL3_B,;        //10
					 nREAL1_U,;        //11
					 nREAL2_U,;        //12
					 nREAL3_U  } )     //13	 
					  
						  											
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
						 nMeta3,; 	    //12
						 nREAL1_A,;		//13
						  nREAL1_B,;        //14
						  nREAL2_A,;        //15
						  nREAL2_B,;        //16
						  nREAL3_A,;        //17
						  nREAL3_B,;        //18
						  nMeta1_A,;        //19
						  nMeta1_B,;        //20
						  nMeta2_A,;        //21
						  nMeta2_B,;        //22
						  nMeta3_A,;        //23
						  nMeta3_B,;        //24
						  nMeta1_U,;        //25
						  nMeta2_U,;        //26
						  nMeta3_U,;        //27
						  nREAL1_U,;        //28
						  nREAL2_U,;        //29
						  nREAL3_U  } )     //30	  
	Else

		Aadd (aResult, {cMAQ,;  		//1
						nAPARA1,;      	//2
		  				nAPARA2,;      	//3
						nAPARA3,;      	//4
						nREAL1_A,;		//5
						nREAL1_B,;      //6
						nREAL2_A,;      //7
						nREAL2_B,;      //8
						nREAL3_A,;      //9
						nREAL3_B,;      //10
						nREAL1_U,;      //11
						nREAL2_U,;      //12
						nREAL3_U  } )   //13	  } )    
	Endif               
	
	

 ElseIf !EMPTY(Z00X->Z00_MAQ) .AND. (alltrim(Z00X->Z00_MAQ) $ 'EXT/COST')
  	
  	dData		:= ("  /  /    ")
	cHora		:= ""
  	cMaq_2    := Z00X->Z00_MAQ 	
 	nQTDMR1_2 := nQTDMR2_2 := nQTDMR3_2 := 0
 	
 	nREAL11_A := nREAL22_A := nREAL33_A := 0
 	nREAL11_B := nREAL22_B := nREAL33_B := 0
 	nREAL11_U := nREAL22_U := nREAL33_U := 0
 	
 	nAPARA1_2 := nAPARA2_2 := nAPARA3_2 := 0
 	aOP_2     := {}
 	aOPb      := {}
 	
 	aOPAA	  := {}
 	aOPBB     := {}
 	aOPUU     := {}
 	
 	nOP_2     := 0
	ntop_2	  := 0
	
	
	nMeta1_2    := nMeta2_2    := nMeta3_2      := 0
	
	nMeta11A    := nMeta22A    := nMeta33A      := 0
	nMeta11B    := nMeta22B    := nMeta33B      := 0
	nMeta11U    := nMeta22U    := nMeta33U      := 0
	
	cHoraIni1   := cHoraIni2   := cHoraIni3     := ""
	cHoraFim1   := cHoraFim2   := cHoraIni3     := ""
	nTempoOper1 := nTempoOper2 := nTempoOper3   := 0
	cOPZB0      := ""
	
	nMetaZB1 := 0
	
	nMeta11_A := nMeta22_A := nMeta33_A := 0
	nMeta11_B := nMeta22_B := nMeta33_B := 0
	nMeta11_U := nMeta22_U := nMeta33_U := 0

	
 	Do While !Z00X->( Eof() ) .and. Z00X->Z00_MAQ == cMaq_2
 	
 			
 	 						
 			DbselectArea("Z00X")
	
	 		If Z00X->Z00_APARA == " " //se nao produzir apara	 			
	 			If      ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) >= ( DtoS(mv_par01) + "05:35:00" ) ;
	 			  .and. ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) <= ( DtoS(mv_par01) + "13:55:00" ) 
	
			 		//nQTDMR1_2  += Z00X->Z00_QUANT / 1000		//REAL(MR)
			 		//If nLados > 1
				 		If Alltrim(Z00X->Z00_LADO) = "A"
		               		nREAL11_A += Z00X->Z00_QUANT / 1000
		               		
		               	Elseif Alltrim(Z00X->Z00_LADO) = "B"
		               	
		               	    nREAL11_B += Z00X->Z00_QUANT / 1000
		               			
	               		Elseif Alltrim(Z00X->Z00_LADO) = "" 
	               			nREAL11_U += Z00X->Z00_QUANT / 1000	
	               		Endif 					
	
	 			
	 			ElseIf  ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) >= ( DtoS(mv_par01) + "13:56:00" ) ;
	 			  .and. ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) <= ( DtoS(mv_par01) + "22:00:00" )
	 			 	
	
			 		//nQTDMR2_2  += Z00X->Z00_QUANT  / 1000 		//REAL(MR)			 	 			 				 	
					//If nLados > 1
						If Alltrim(Z00X->Z00_LADO) = "A"
		               		nREAL22_A += Z00X->Z00_QUANT / 1000
		               		
		               	Elseif Alltrim(Z00X->Z00_LADO) = "B"
		               	
		               	    nREAL22_B += Z00X->Z00_QUANT / 1000
		               			
	               		Elseif Alltrim(Z00X->Z00_LADO) = "" 
	               			nREAL22_U += Z00X->Z00_QUANT / 1000
	               		Endif 
		 		
	 			ElseIf  ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) >= ( DtoS(mv_par01) + "22:00:00" );
	 			  .and. ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) <= ( DtoS(mv_par01 + 1 ) + "05:30:00" )
	 			 	
	
			 		//nQTDMR3_2  += Z00X->Z00_QUANT  / 1000 		//REAL(MR)
			 		//If nLados > 1			 				 	
						If Alltrim(Z00X->Z00_LADO) = "A"
		               		nREAL33_A += Z00X->Z00_QUANT / 1000
		               		
		               	Elseif Alltrim(Z00X->Z00_LADO) = "B"
		               	
		               	    nREAL33_B += Z00X->Z00_QUANT / 1000
		               			
	               		Elseif Alltrim(Z00X->Z00_LADO) = "" 
	               			nREAL33_U += Z00X->Z00_QUANT / 1000
	               		Endif 
	 		 				
	 			EndIf
	        
	        ElseIf Alltrim(Z00X->Z00_APARA) # "" //"12" //checa se apara possui 1 ou 2, caso produza refugo	 			
	 			If     ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) >= ( DtoS(mv_par01) + "05:35:00" );
	 			 .and. ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) <= ( DtoS(mv_par01) + "13:55:00" )
	 				
	 				nAPARA1_2  += Z00X->Z00_PESO 	 			
	 		
	 			ElseIf ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) >= ( DtoS(mv_par01) + "13:56:00" ) ;
	 			 .and. ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) <= ( DtoS(mv_par01) + "22:00:00" )
	 				
	 				nAPARA2_2  += Z00X->Z00_PESO 	 			
	 		
	 			ElseIf ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) >= ( DtoS(mv_par01) + Left( cTURNO3_A, 5 ) ) ;
	 			 .and. ( DtoS(Z00X->Z00_DATA) + Z00X->Z00_HORA ) <= ( DtoS(mv_par01 + 1 ) + "05:30:00" )
	 				
	 				nAPARA3_2  += Z00X->Z00_PESO 				
	 			
	 			EndIf
	 			
	 		EndIf
	 		
 		Dbselectarea("Z00X")
 		Z00X->( DbSkip() )
 	 	IncRegua()
 	EndDo
 	
 
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
					 nMeta3_2,; 		//12							    
					 nREAL11_A,;		//13
					 nREAL11_B,;		//14
					 nREAL22_A,;		//15
					 nREAL22_B,;		//16
					 nREAL33_A,;		//17
					 nREAL33_B,;		//18
					 nMeta11_A,;		//19
					 nMeta11_B,;		//20
					 nMeta22_A,;		//21
					 nMeta22_B,;		//22
					 nMeta33_A,;		//23
					 nMeta33_B,;        //24
					 nMeta11_U,;        //25
					 nMeta22_U,;        //26
					 nMeta33_U,;        //27
					 nREAL11_U,;        //28
					 nREAL22_U,;        //29
					 nREAL33_U } )		//30



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
	//MSGBOX("ARESULT")
    //
    
	nTotAPEX1 := 0
	nTotAPEX2 := 0
	nTotAPEX3 := 0
	
	nTTAPEX1 := 0
	nTTAPEX2 := 0
	nTTAPEX3 := 0
	
	nTotMLEX1A := 0
	nTotMLEX2A := 0
	nTotMLEX3A := 0
	
	nTotMLEX1B := 0
	nTotMLEX2B := 0
	nTotMLEX3B := 0
	
	nTotMLEX1U := 0
	nTotMLEX2U := 0
	nTotMLEX3U := 0
	
	nTTMLEX1A := 0
	nTTMLEX2A := 0
	nTTMLEX3A := 0
	
	nTTMLEX1B := 0
	nTTMLEX2B := 0
	nTTMLEX3B := 0  
	
	nTTMLEX1U := 0
	nTTMLEX2U := 0
	nTTMLEX3U := 0
	
	nTotMeta1A := 0
	nTotMeta2A := 0
	nTotMeta3A := 0
	                                                                     
	nTotMeta1B := 0
	nTotMeta2B := 0
	nTotMeta3B := 0
	
	nTotMeta1U := 0
	nTotMeta2U := 0
	nTotMeta3U := 0
	
	nTTMeta1A := 0
	nTTMeta2A := 0
	nTTMeta3A := 0
	
	nTTMeta1B := 0
	nTTMeta2B := 0
	nTTMeta3B := 0
	
	nTTMeta1U := 0
	nTTMeta2U := 0
	nTTMeta3U := 0
	//



nPerDif1 := 0    
nPerDif2 := 0    
nPerDif3 := 0

nMeta1_A   := nMeta2_A   := nMeta3_A   := 0
nMeta1_B   := nMeta2_B   := nMeta3_B   := 0
nMeta1_U   := nMeta2_U   := nMeta3_U   := 0
aMetasA	   := {}
aMetasB	   := {}
aMetasU    := {}

aMetas		:= {}
nPosiMaq	:= 0
nPosiLado	:= 0
cMaq	    := ""

aMetas  := U_PCPC017(MV_PAR01, MV_PAR02 ,MV_PAR03 , MV_PAR04 , MV_PAR05 )    //calcula meta da máquina no lado A
//retorna vetor: maq, lado, meta T1, meta T2, meta T3                                                                  
//                1     2     3        4         5
//MSGBOX("LEN AMETAS: " + STR(Len(aMetas) ) ) 

//MSGBOX("LEN aResult: " + str(Len(aResult) ) )

	 
   
	FOR X := 1 TO Len(aResult)     //array dos dados de produção por turno
	 	
	 	nLados := 0
	 	nLados := TrazLados( Alltrim(aResult[X,1]) )
	 	
	 	@ Prow() + 2,000 PSAY Left( aResult[X,1], 3 )                           			//MAQ
	 	
	 
	 	cMaq := Alltrim(aResult[X,1])
	 	If nLados > 1
	 	
	 		//User Function PCPC017(MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR05)
	 					//             data     maq   prod de, prod ate,  lado
	 	
	 			
	 		If Alltrim(mv_par05) = "A" .or. Empty(mv_par05)

	 		   	//nPosiMaq := ASCAN( aMetas, {|x| x[1]+x[2] == Alltrim(aResult[X,1] + "A")  } )
	 		   		 		   	
	 		   	//nPosiMaq := ASCAN( aMetas, {|x| x[1]+x[2] == cMaq + "A"  } )
	 		   	/*     
	 		   	If nPosiMaq > 0	 								
	 		   	
		 			nMeta1_A := aMetas[ nPosiMaq, 3 ]	 			
		 			nMeta2_A := aMetas[ nPosiMaq, 4 ]	 			
		 			nMeta3_A := aMetas[ nPosiMaq, 5 ]	 			
		 		Else
		 			nMeta1_A := 0
		 			nMeta2_A := 0
		 			nMeta3_A := 0
		 		
		 		Endif
		 		*/
		 		
		 		//nPosiMaq := ASCAN(aMetas, (cMaq+"A") )
		 		nMeta1_A := 0
		 		nMeta2_A := 0
		 		nMeta3_A := 0 
		 		fr := 1
		 		nPosiMaq := 0	 		   
	 		   	While fr <= Len(aMetas)
	 		   		If Alltrim(aMetas[fr,1]) = Alltrim(cMaq+"A")
	 		   			nPosiMaq := fr
	 		   			nMeta1_A += aMetas[ nPosiMaq, 3 ]	 
	 		   			nMeta2_A += aMetas[ nPosiMaq, 4 ]
	 		   			nMeta3_A += aMetas[ nPosiMaq, 5 ]	 			
	 		   			//Exit
	 		   			 			
	 		   		Endif
	 		   		fr++
	 		   	Enddo	 		   	
			
		 		@ Prow()    ,004 PSAY "A"
		 		///1o. turno
		 		@ Prow()    ,007 PSAY nMeta1_A Picture "@E 999,999.99"					//ESTIMADO(MR) - A
		 		@ Prow()    ,018 PSAY aResult[X,5] Picture "@E 999,999.99"					//REAL(MR) - A
		 			 	    
		 	    If ( nMeta1_A  )  >  (aResult[X,5] )     //META > PRODUZIDO
			 		@ Prow(),030  PSAY ( nMeta1_A   - aResult[X,5] ) Picture "@E 999,999.99" 	//DIFERENÇA 	 	
			 		nPerDif1 := ( aResult[X,5] / nMeta1_A ) * 100
			 	Else
			 		@ Prow(),030  PSAY ( aResult[X,5]   - nMeta1_A ) Picture "@E 999,999.99" 	//DIFERENÇA 	 	
			 		nPerDif1 := ( nMeta1_A / aResult[X,5] ) * 100
			 	Endif
		 	    
		  		@ Prow(),042 PSAY nPerDif1 Picture "@E 999.99"	  //DIF %
		 		@ Prow(),050 PSAY aResult[X,2] / ( aResult[X,5]   + aResult[X,2] ) * 100 Picture "@E 999.99"   	//APARA %
		 		
		 		
		 		//2o. turno
		 		@ Prow(),059 PSAY nMeta2_A Picture "@E 999,999.99"	 		//ESTIMADO(MR) - META A
		 		@ Prow(),072 PSAY aResult[X,7] Picture "@E 999,999.99"         //REAL(MR) - PRODUZIDO A
		 	                                                                                                            
		 		 		
		 		If ( nMeta2_A   >  aResult[X,7] )		 		
		 			@ Prow(),084  PSAY ( nMeta2_A  -  aResult[X,7] ) Picture "@E 999,999.99" 	//DIFERENÇA META - REAL
		 			nPerDif2 := ( aResult[X,7]   / nMeta2_A ) * 100	   
		 		
		 		Else		 			
		 			@ Prow(),084 PSAY ( aResult[X,7]  - nMeta2_A ) Picture "@E 999,999.99" 	//DIFERENÇA REAL - META
		 			nPerDif2 := ( nMeta2_A / aResult[X,7] ) * 100	   
		 		Endif
		 		
		 		@ Prow()    ,098 PSAY nPerDif2 Picture "@E 999.99"	//DIF%	 		 	
		 		@ Prow()    ,107 PSAY aResult[X,3] / ( aResult[X,7] + aResult[X,3] ) * 100 Picture "@E 999.99"	//APARA %	 	
	 	
	 	 	  	 	      
		 		//3o. turno		 						 		
		 		@ Prow(),116 PSAY nMeta3_A Picture "@E 999,999.99"		//ESTIMADO(MR) - META A
		 		@ Prow(),129 PSAY aResult[X,9] Picture "@E 999,999.99"     //REAL(MR) - PRODUZIDO	A	 		
		 	 	
		 		If ( nMeta3_A  >  aResult[X,9] )
		 			@ Prow(),141 PSAY ( nMeta3_A  -  aResult[X,9] ) Picture "@E 999,999.99" 	//DIFERENÇA (ESTIMADO - REAL)
		 			nPerDif3 := (  aResult[X,9]  / nMeta3_A  ) * 100	   	 	
		 		Else
		 			@ Prow(),141 PSAY ( aResult[X,9] - nMeta3_A ) Picture "@E 999,999.99" 	
		 			nPerDif3 := ( nMeta3_A /  aResult[X,9] ) * 100
		 		Endif
			 	
		 		@ Prow(),154 PSAY nPerDif3 Picture "@E 999.99"            //DIF %	 	
		 		@ Prow(),163 PSAY aResult[X,4] / ( aResult[X,9] + aResult[X,4] ) * 100 Picture "@E 999.99"	//APARA %
		 		
		 		nTotMLEX1A := nTotMLEX1A + aResult[X,5]
				nTotMLEX2A := nTotMLEX2A + aResult[X,7]
				nTotMLEX3A := nTotMLEX3A + aResult[X,9] 
				
				nTotMeta1A := nTotMeta1A + nMeta1_A //aResult[X,19]
				nTotMeta2A := nTotMeta2A + nMeta2_A //aResult[X,21]
				nTotMeta3A := nTotMeta3A + nMeta3_A //aResult[X,23]
				 	
	 		
	 		Endif
	 		//NA PRÓX. LINHA IMPRIME AS INFORMAÇÕES DO OUTRO LADO DA MÁQUINA
	 		
	 		
	 		nPosiMaq := 0
	 		If Alltrim(mv_par05) = "B" .or. Empty(mv_par05)
	 			
	 			//nPosiMaq := ASCAN(aMetas, {|x| x[1]+x[2] == ( aResult[X,1] + "B")  } )     
	 			/*
	 			nPosiMaq := ASCAN(aMetas, {|x| x[1]+x[2] == cMaq + "B"  } )     
	 		   	If nPosiMaq > 0	 									 								
		 			nMeta1_B := aMetas[ nPosiMaq, 3 ]	 			
		 			nMeta2_B := aMetas[ nPosiMaq, 4 ]	 			
		 			nMeta3_B := aMetas[ nPosiMaq, 5 ]
		 		Else
		 			nMeta1_B := 0
		 			nMeta2_B := 0
		 			nMeta3_B := 0
		 			 			
	 			Endif
	 			*/
	 			nMeta1_B := 0
		 		nMeta2_B := 0
		 		nMeta3_B := 0 
		 		fr := 1
		 		nPosiMaq := 0	 		   
	 		   	While fr <= Len(aMetas)
	 		   		If Alltrim(aMetas[fr,1]) = Alltrim(cMaq+"B")
	 		   			nPosiMaq := fr
	 		   			nMeta1_B += aMetas[ nPosiMaq, 3 ]	 
	 		   			nMeta2_B += aMetas[ nPosiMaq, 4 ]
	 		   			nMeta3_B += aMetas[ nPosiMaq, 5 ]	 			
	 		   			//Exit
	 		   			 			
	 		   		Endif
	 		   		fr++
	 		   	Enddo	 		   	
		 		//1o. turno
	
		 		@ Prow()+1 ,004 PSAY "B"		 		
		 		@ Prow(),007 PSAY nMeta1_B Picture "@E 999,999.99"					//ESTIMADO(MR) - B
		 		@ Prow(),018 PSAY aResult[X,6] Picture "@E 999,999.99"					//REAL(MR) - B
		 		 		 	    
		 	    If ( nMeta1_B  )  >  (aResult[X,6] )     //META > PRODUZIDO
			 		@ Prow(),030  PSAY ( nMeta1_B   - aResult[X,6] ) Picture "@E 999,999.99" 	//DIFERENÇA 	 	
			 		nPerDif1 := ( aResult[X,6] / nMeta1_B ) * 100
			 	Else
			 		@ Prow(),030  PSAY ( aResult[X,6]   - nMeta1_B ) Picture "@E 999,999.99" 	//DIFERENÇA 	 	
			 		nPerDif1 := ( nMeta1_B / aResult[X,6] ) * 100
			 	Endif
		 	    
		  		@ Prow(),042 PSAY nPerDif1 Picture "@E 999.99"	  //DIF %
		 		@ Prow(),050 PSAY aResult[X,2] / ( aResult[X,6]   + aResult[X,2] ) * 100 Picture "@E 999.99"   	//APARA %	 
	 		

		 		//2o. turno		 			 
		 		@ Prow(),059 PSAY nMeta2_B Picture "@E 999,999.99"	 		//ESTIMADO(MR) - META B
		 		@ Prow(),072 PSAY aResult[X,8] Picture "@E 999,999.99"         //REAL(MR) - PRODUZIDO B	 	                                                                                                            
		 		 		
		 		If ( nMeta2_B   >  aResult[X,8] )
		 		
		 			@ Prow(),084  PSAY ( nMeta2_B   -  aResult[X,8] ) Picture "@E 999,999.99" 	//DIFERENÇA META - REAL
		 			nPerDif2 := ( aResult[X,8]   / nMeta2_B  ) * 100	   
		 		
		 		Else
		 			
		 			@ Prow(),084 PSAY ( aResult[X,8]  - nMeta2_B  ) Picture "@E 999,999.99" 	//DIFERENÇA REAL - META
		 			nPerDif2 := ( nMeta2_B  / aResult[X,8] ) * 100	   
		 		Endif
		 		
		 		@ Prow()    ,098 PSAY nPerDif2 Picture "@E 999.99"	//DIF%	 		 	
		 		@ Prow()    ,107 PSAY aResult[X,3] / ( aResult[X,8] + aResult[X,3] ) * 100 Picture "@E 999.99"	//APARA %	 	
	 	
	 	 	        
		 		//3o. turno	 				
		 		@ Prow(),116 PSAY nMeta3_B Picture "@E 999,999.99"		//ESTIMADO(MR) - META B
		 		@ Prow(),129 PSAY aResult[X,10] Picture "@E 999,999.99"     //REAL(MR) - PRODUZIDO	A	 		
		 	 	
		 		If (nMeta3_B  >  aResult[X,10] )
		 			@ Prow(),141 PSAY ( nMeta3_B  -  aResult[X,10] ) Picture "@E 999,999.99" 	//DIFERENÇA (ESTIMADO - REAL)
		 			nPerDif3 := (  aResult[X,10]  / nMeta3_B  ) * 100	   	 	
		 		Else
		 			@ Prow(),141 PSAY ( aResult[X,10] - nMeta3_B ) Picture "@E 999,999.99" 	//DIFERENÇA (ESTIMADO - REAL)	 	
		 			nPerDif3 := ( nMeta3_B /  aResult[X,10] ) * 100
		 		Endif
			 	
		 		@ Prow(),154 PSAY nPerDif3 Picture "@E 999.99"            //DIF %	 	
		 		@ Prow(),163 PSAY aResult[X,8] / ( aResult[X,10] + aResult[X,8] ) * 100 Picture "@E 999.99"	//APARA % 		 	
		 		
		 					
				nTotMLEX1B := nTotMLEX1B + aResult[X,6]
				nTotMLEX2B := nTotMLEX2B + aResult[X,8]
				nTotMLEX3B := nTotMLEX3B + aResult[X,10]				
					
				nTotMeta1B := nTotMeta1B + nMeta1_B
				nTotMeta2B := nTotMeta2B + nMeta2_B //aResult[X,22]
				nTotMeta3B := nTotMeta3B + nMeta3_B //aResult[X,24]
		
	 		Endif
	 	
	 	
	 	Else    //se a máquina não possui lados
                /*
	 			nPosiMaq := 0
	 			//nPosiMaq := ASCAN(aMetas, {|x| x[1]+x[2] == ( aResult[X,1] + "")  } )     
	 			nPosiMaq := ASCAN(aMetas, {|x| x[1]+x[2] ==  cMaq + ""  } )     
	 		   	If nPosiMaq > 0	 									 								
		 			nMeta1_U := aMetas[ nPosiMaq, 3 ]	 			
		 			nMeta2_U := aMetas[ nPosiMaq, 4 ]	 			
		 			nMeta3_U := aMetas[ nPosiMaq, 5 ]	 			 
		 		Else
		 			nMeta1_U := 0
		 			nMeta2_U := 0
		 			nMeta3_U := 0
		 		
	 		 	Endif
	 		 	*/
	 		 	nMeta1_U := 0
		 		nMeta2_U := 0
		 		nMeta3_U := 0 
		 		fr := 1	 		   
	 		   	While fr <= Len(aMetas)
	 		   		If Alltrim(aMetas[fr,1]) = Alltrim(cMaq+"")
	 		   			nPosiMaq := fr
	 		   			nMeta1_U += aMetas[ nPosiMaq, 3 ]	 
	 		   			nMeta2_U += aMetas[ nPosiMaq, 4 ]
	 		   			nMeta3_U += aMetas[ nPosiMaq, 5 ]	 			
	 		   			//Exit
	 		   			 			
	 		   		Endif
	 		   		fr++
	 		   	Enddo	 		   	
	 		//1o. turno 	 			 		
	 		@ Prow()    ,007 PSAY nMeta1_U  Picture "@E 999,999.99"					//ESTIMADO(MR) - META A	+ B
	 		@ Prow()    ,018 PSAY aResult[X,11] Picture "@E 999,999.99"					//REAL(MR) - A+B+U
	 		 		 	    
	 	    If nMeta1_U   >  aResult[X,11]     //META > PRODUZIDO
		 		@ Prow(),030  PSAY ( nMeta1_U - aResult[X,11] ) Picture "@E 999,999.99" 	//DIFERENÇA 	 	
		 		nPerDif1 := ( aResult[X,11] / nMeta1_U ) * 100
		 	Else
		 		@ Prow(),030  PSAY ( aResult[X,11] - nMeta1_U ) Picture "@E 999,999.99" 	//DIFERENÇA 	 	
		 		nPerDif1 := ( nMeta1_U / aResult[X,11] ) * 100
		 	Endif
	 	    
	  		@ Prow(),042 PSAY nPerDif1 Picture "@E 999.99"	  //DIF %
	 		@ Prow(),050 PSAY aResult[X,2] / ( aResult[X,11] + aResult[X,2] ) * 100 Picture "@E 999.99"   	//APARA %	 
	 	
	   	 
	 		//2o. turno	 
	 		@ Prow(),059 PSAY nMeta2_U Picture "@E 999,999.99"	 		//ESTIMADO(MR) - META	 	 	
	 		@ Prow(),072 PSAY aResult[X,12]   Picture "@E 999,999.99"               //REAL(MR) - PRODUZIDO	 		
	 		                                                                                                            
	 		 		
	 		If nMeta2_U  >  aResult[X,12]	 		
	 			@ Prow(),084  PSAY ( nMeta2_U - aResult[X,12] ) Picture "@E 999,999.99" 	//DIFERENÇA 
	 			nPerDif2 := ( aResult[X,12]  / nMeta2_U ) * 100	   
	 		
	 		Else	 			
	 			@ Prow(),084 PSAY ( aResult[X,12] - nMeta2_U ) Picture "@E 999,999.99" 	//DIFERENÇA 	   
	 			nPerDif2 := ( nMeta2_U / aResult[X,12] ) * 100	   
	 		Endif
	 		
	 		@ Prow()    ,098 PSAY nPerDif2 Picture "@E 999.99"	//DIF%	 		 	
	 		@ Prow()    ,107 PSAY aResult[X,3] / ( aResult[X,12] + aResult[X,3] ) * 100 Picture "@E 999.99"	//APARA %	 	
	 	
	 	 	        
	 		//3o. turno	 			
	 		@ Prow(),116 PSAY nMeta3_U Picture "@E 999,999.99"		//ESTIMADO(MR) - META	 		 	
	 		@ Prow(),129 PSAY aResult[X,13] Picture "@E 999,999.99"            //REAL(MR) - PRODUZIDO	 	
	 		
	 		If nMeta3_U  > aResult[X,13]
	 			@ Prow(),141 PSAY ( nMeta3_U - aResult[X,13] ) Picture "@E 999,999.99" 	//DIFERENÇA (ESTIMADO - REAL)
	 			nPerDif3 := ( aResult[X,13] / nMeta3_U ) * 100	   	 	
	 		Else
	 			@ Prow(),141 PSAY ( aResult[X,13] - nMeta3_U ) Picture "@E 999,999.99" 	//DIFERENÇA (ESTIMADO - REAL)	 	
	 			nPerDif3 := ( nMeta3_U / aResult[X,13] ) * 100
	 		Endif
		 	
	 		@ Prow(),154 PSAY nPerDif3 Picture "@E 999.99"            //DIF %	 	
	 		@ Prow(),163 PSAY aResult[X,4] / ( aResult[X,13]+ aResult[X,4] ) * 100 Picture "@E 999.99"	//APARA % 		 	
	 			 					
			nTotMLEX1U := nTotMLEX1U + aResult[X,11]
			nTotMLEX2U := nTotMLEX2U + aResult[X,12]
			nTotMLEX3U := nTotMLEX3U + aResult[X,13]		
		
			nTotMeta1U := nTotMeta1U + nMeta1_U //aResult[X,25]
			nTotMeta2U := nTotMeta2U + nMeta2_U //aResult[X,26]
			nTotMeta3U := nTotMeta3U + nMeta3_U //aResult[X,27]
		
		Endif    
		
		nTotAPEX1 := nTotAPEX1 + aResult[X,2]
		nTotAPEX2 := nTotAPEX2 + aResult[X,3]
		nTotAPEX3 := nTotAPEX3 + aResult[X,4]
		
	
				
        
	NEXT


	    nPerDif1 := 0    
        nPerDif2 := 0    
        nPerDif3 := 0    
        
		    //1o. turno	    
		    @ Prow() + 2,000 PSAY Repl( "-", 220 )
			@ Prow() + 1,000 PSAY "SUB "
			//@ Prow()    ,005 PSAY nTotOPEX1 Picture "@E 9999"               					//OP
	
			@ Prow()    ,007 PSAY (nTotMeta1A + nTotMeta1B + nTotMeta1U) Picture "@E 999,999.99"						//ESTIMADO(MR)		
			@ Prow()    ,018 PSAY (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) Picture "@E 999,999.99"      					//REAL(MR)			
			
			
		   	If (nTotMeta1A + nTotMeta1B + nTotMeta1U) > (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U)
				@ Prow()	,030 PSAY ( (nTotMeta1A + nTotMeta1B + nTotMeta1U) - (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) )	Picture "@E 999,999.99"		//DIFERENÇA
				nPerDif1 := ( (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) / (nTotMeta1A + nTotMeta1B + nTotMeta1U) ) * 100
			Else
				@ Prow()	,030 PSAY ( (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) - (nTotMeta1A + nTotMeta1B + nTotMeta1U) )	Picture "@E 999,999.99"		//DIFERENÇA
				nPerDif1 := ( (nTotMeta1A + nTotMeta1B + nTotMeta1U) / (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) ) * 100
			Endif
		   	
		   	@ Prow()    ,042 PSAY nPerDif1 Picture "@E 999.99"	//DIF %				
			@ Prow()    ,050 PSAY (nTotAPEX1 / ( (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) + nTotAPEX1 ) ) * 100 Picture "@E 999.99"	//APARA %
		
		 
			//2o. turno   
	
			@ Prow()    ,059 PSAY (nTotMeta2A + nTotMeta2B + nTotMeta2U) Picture "@E 999,999.99"						//ESTIMADO
			@ Prow()    ,072 PSAY (nTotMLEX2A + nTotMLEX2B + nTotMLEX2U) Picture "@E 999,999.99"      				//REAL(MR)
			
			If (nTotMeta2A + nTotMeta2B + nTotMeta2U) > (nTotMLEX2A + nTotMLEX2B + nTotMLEX2U)
				@ Prow(),084 PSAY ( (nTotMeta2A + nTotMeta2B + nTotMeta2U) - (nTotMLEX2A + nTotMLEX2B + nTotMLEX2U) ) Picture "@E 999,999.99"		//DIFERENÇA
				nPerDif2 := ( (nTotMLEX2A + nTotMLEX2B + nTotMLEX2U) / (nTotMeta2A + nTotMeta2B + nTotMeta2U) ) * 100
			Else
				@ Prow(),084 PSAY ( (nTotMLEX2A + nTotMLEX2B + nTotMLEX2U) - (nTotMeta2A + nTotMeta2B + nTotMeta2U) ) Picture "@E 999,999.99"		//DIFERENÇA
				nPerDif2 := ( (nTotMeta2A + nTotMeta2B + nTotMeta2U) / (nTotMLEX2A + nTotMLEX2B + nTotMLEX2U) ) * 100
			Endif			
			
			@ Prow(),098 PSAY nPerDif2 Picture "@E 999.99"  //DIF %
			@ Prow(),107 PSAY (nTotAPEX2 / ( (nTotMLEX2A + nTotMLEX2B + nTotMLEX2U) + nTotAPEX2 ) ) * 100 Picture "@E 999.99"	//APARA %
		
	    
			//3o. turno
	
			@ Prow()    ,116 PSAY (nTotMeta3A + nTotMeta3B + nTotMeta3U) Picture "@E 999,999.99"  						//ESTIMADO
			@ Prow()    ,129 PSAY (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) Picture "@E 999,999.99"      				//REAL(MR)
			
			If (nTotMeta3A + nTotMeta3B + nTotMeta3U) > (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U)
				@ Prow(),141 PSAY ( (nTotMeta3A + nTotMeta3B + nTotMeta3U) - (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) ) Picture "@E 999,999.99"		//DIFERENÇA  
				nPerDif3 := ( (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) / (nTotMeta3A + nTotMeta3B + nTotMeta3U) ) * 100
			Else 
				@ Prow(),141 PSAY ( (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) - (nTotMeta3A + nTotMeta3B + nTotMeta3U) ) Picture "@E 999,999.99"		//DIFERENÇA 
				nPerDif3 := ( (nTotMeta3A + nTotMeta3B + nTotMeta3U) / (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) ) * 100
			Endif
			
			@ Prow(),154 PSAY nPerDif3 Picture "@E 999.99"	//DIF %
			@ Prow(),163 PSAY ( nTotAPEX3 / ( (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) + nTotAPEX3 ) ) * 100 Picture "@E 999.99"	//APARA %        
            
	    		
			nTTMLEX1A += nTotMLEX1A 
			nTTMLEX1B += nTotMLEX1B
			     
			nTTMLEX2A += nTotMLEX2A
			nTTMLEX2B += nTotMLEX2B
			
			nTTMLEX3A += nTotMLEX3A
			nTTMLEX3B += nTotMLEX3B
					
			nTTMLEX1U += nTotMLEX1U		     
			nTTMLEX2U += nTotMLEX2U		
			nTTMLEX3U += nTotMLEX3U
			
							     
			nTTMeta1A += nTotMeta1A 
			nTTMeta1B += nTotMeta1B
			     
			nTTMeta2A += nTotMeta2A
		    nTTMeta2B += nTotMeta2B
		      	 
		    nTTMeta3A += nTotMeta3A
		    nTTMeta3B += nTotMeta3B
		    	    
		    nTTMeta1U += nTotMeta1U
			nTTMeta2U += nTotMeta2U
		    nTTMeta3U += nTotMeta3U
			
			nTTAPEX1 += nTotAPEX1
			nTTAPEX2 += nTotAPEX2
			nTTAPEX3 += nTotAPEX3
			
			nTotMLEX1A := 0
	     	nTotMLEX2A := 0
	     	nTotMLEX3A := 0
	     	     
	     	nTotMLEX1B := 0
	     	nTotMLEX2B := 0
	     	nTotMLEX3B := 0 
	     	
	     	nTotMLEX1U := 0
	     	nTotMLEX2U := 0
	     	nTotMLEX3U := 0
	     	     
	     	nTotAPEX1 := 0
	     	nTotAPEX2 := 0     	     
	     	nTotAPEX3 := 0
	     	     
	     	nTotMeta1A:= nTotMeta2A := nTotMeta3A := 0
	     	nTotMeta1B:= nTotMeta2B := nTotMeta3B := 0
	     	nTotMeta1U:= nTotMeta2U := nTotMeta3U := 0
	     	     
	     	nPerDif1 := 0    
	     	nPerDif2 := 0    
	     	nPerDif3 := 0    
     	
     				
	    //1o. turno
	    @ Prow() + 2,000 PSAY Repl( "-", 220 )
	    @ Prow() +1 ,000 PSAY "TOTAL"
        //@ Prow()    ,005 PSAY nTTotOPEX1 Picture "@E 9999"     					//OP
	
			@ Prow()	,007 PSAY (nTTMeta1A + nTTMeta1B + nTTMeta1U) Picture "@E 999,999.99"			//ESTIMADO(MR)
			@ Prow()    ,018 PSAY (nTTMLEX1A + nTTMLEX1B + nTTMLEX1U) Picture "@E 999,999.99"       	//REAL(MR)
			
			If (nTTMeta1A + nTTMeta1B + nTTMeta1U)  > (nTTMLEX1A + nTTMLEX1B + nTTMLEX1U)
				@ Prow(),030 PSAY ( (nTTMeta1A + nTTMeta1B + nTTMeta1U) - (nTTMLEX1A + nTTMLEX1B + nTTMLEX1U) ) Picture "@E 999,999.99"       	//DIFERENÇA
				nPerDif1 := ( (nTTMLEX1A + nTTMLEX1B + nTTMLEX1U) / (nTTMeta1A + nTTMeta1B + nTTMeta1U) ) * 100		
			Else
				@ Prow(),030 PSAY ( (nTTMLEX1A + nTTMLEX1B + nTTMLEX1U) - (nTTMeta1A + nTTMeta1B + nTTMeta1U) ) Picture "@E 999,999.99"       	//DIFERENÇA 		
				nPerDif1 := ( (nTTMeta1A + nTTMeta1B + nTTMeta1U)/ (nTTMLEX1A + nTTMLEX1B + nTTMLEX1U)  ) * 100
			Endif
			@ Prow()    ,042 PSAY nPerDif1 Picture "@E 999.99"	//DIF %
			@ Prow()    ,050 PSAY ( nTTAPEX1 / ( (nTTMLEX1A + nTTMLEX1B + nTTMLEX1U) + nTTAPEX1 ) ) * 100 Picture "@E 999.99"	//APARA %
		
	    
		//2o. turno		
	
			@ Prow()	,059 PSAY (nTTMeta2A + nTTMeta2B + nTTMeta2U) Picture "@E 999,999.99"			//ESTIMADO(MR)
			@ Prow()    ,072 PSAY (nTTMLEX2A + nTTMLEX2B + nTTMLEX2U) Picture "@E 999,999.99"       	//REAL(MR)
			
			
			If (nTTMeta2A + nTTMeta2B + nTTMeta2U) > (nTTMLEX2A + nTTMLEX2B + nTTMLEX2U)
				@ Prow(),084 PSAY ( (nTTMeta2A + nTTMeta2B + nTTMeta2U) - (nTTMLEX2A + nTTMLEX2B + nTTMLEX2U) ) Picture "@E 999,999.99"       	//DIFERENÇA		
				nPerDif2 := ( (nTTMLEX2A + nTTMLEX2B + nTTMLEX2U) / (nTTMeta2A + nTTMeta2B + nTTMeta2U) ) * 100		
			Else
				@ Prow(),084 PSAY ( (nTTMLEX2A + nTTMLEX2B + nTTMLEX2U) - (nTTMeta2A + nTTMeta2B + nTTMeta2U) ) Picture "@E 999,999.99"       	//DIFERENÇA		
				nPerDif2 := ( (nTTMeta2A + nTTMeta2B + nTTMeta2U) / (nTTMLEX2A + nTTMLEX2B + nTTMLEX2U)  ) * 100
			Endif
			@ Prow()    ,098 PSAY nPerDif2 Picture "@E 999.99"	//DIF %			
			@ Prow()    ,107 PSAY ( nTTAPEX2 / ( (nTTMLEX2A + nTTMLEX2B + nTTMLEX2U) + nTTAPEX2 ) ) * 100 Picture "@E 999.99"	//APARA %
        
    	
		//3o. turno
		
			@ Prow()	,116 PSAY (nTTMeta3A + nTTMeta3B + nTTMeta3U) Picture "@E 999,999.99"			//ESTIMADO(MR)
			@ Prow()    ,129 PSAY (nTTMLEX3A + nTTMLEX3B + nTTMLEX3U) Picture "@E 999,999.99"       	//REAL(MR)
			
			If (nTTMeta3A + nTTMeta3B + nTTMeta3U) > (nTTMLEX3A + nTTMLEX3B + nTTMLEX3U)
				@ Prow(),141 PSAY ( (nTTMeta3A + nTTMeta3B + nTTMeta3U) - (nTTMLEX3A + nTTMLEX3B + nTTMLEX3U) ) Picture "@E 999,999.99"       	//DIFERENÇA		
				nPerDif3 := ( (nTTMLEX3A + nTTMLEX3B + nTTMLEX3U) / (nTTMeta3A + nTTMeta3B + nTTMeta3U) ) * 100
			Else
				@ Prow(),141 PSAY ( (nTTMLEX3A + nTTMLEX3B + nTTMLEX3U) - (nTTMeta3A + nTTMeta3B + nTTMeta3U) ) Picture "@E 999,999.99"       	//DIFERENÇA		
				nPerDif3 := ( (nTTMeta3A + nTTMeta3B + nTTMeta3U) / (nTTMLEX3A + nTTMLEX3B + nTTMLEX3U)  ) * 100
			Endif
			@ Prow()    ,154 PSAY nPerDif3 Picture "@E 999.99"	//DIF %			
			@ Prow()    ,163 PSAY ( nTTAPEX3 / ( (nTTMLEX3A + nTTMLEX3B + nTTMLEX3U) + nTTAPEX3 ) ) * 100 Picture "@E 999.99"	//APARA %
			
			
			
Endif		
		
    
If Len(aResult3) > 0
      	//MSGBOX("ARESULT 3") 
              
       nTotMLEX1A := 0
       nTotMLEX2A := 0
       nTotMLEX3A := 0
       
       nTotMLEX1B := 0
       nTotMLEX2B := 0
       nTotMLEX3B := 0
       
       nTotMLEX1U := 0
       nTotMLEX2U := 0
       nTotMLEX3U := 0
       
       nTotAPEX1 := 0
       nTotAPEX2 := 0
       nTotAPEX3 := 0
       
       nTotMeta1A := nTotMeta2A := nTotMeta3A := 0
       nTotMeta1B := nTotMeta2B := nTotMeta3B := 0
       nTotMeta1U := nTotMeta2U := nTotMeta3U := 0
       
       nPerDif1 := 0
	   nPerDif2 := 0
       nPerDif3 := 0
       
	   Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  // Impressao do cabecalho
	   	@Prow()+1, 000 PSAY Cabec3
		@Prow() + 1,000 PSAY REPLICATE("_",220)
	    
	    nMeta1_A := 0
	    nMeta2_A := 0
	    nMeta3_A := 0
	    
	    nMeta1_B := 0
	    nMeta2_B := 0
	    nMeta3_B := 0
	    
	    nMeta1_U := 0
	    nMeta2_U := 0
	    nMeta3_U := 0
	    
	    aMetasA  := {}
	    aMetasB  := {}
	    aMetasU  := {}
	    
	    nLados := 0
	    nPosiMaq := 0
	    cMaq	:= ""
		FOR X := 1 TO Len(aResult3)
		
			cMaq   := Alltrim(aResult3[X,1])
			nLados := TrazLados( Alltrim(aResult3[X,1]) )
		 				
		 	@ Prow() + 2,000 PSAY Left( aResult3[X,1], 3 )                           			//MAQ
		 	
		 	If nLados > 1
		 		If Alltrim(mv_par05) = "A" .or. Empty(mv_par05) 
		 			
			 		nMeta1_A := 0
			 		nMeta2_A := 0
			 		nMeta3_A := 0 
			 		fr := 1
			 		nPosiMaq := 0	 		   
		 		   	While fr <= Len(aMetas)
		 		   		If Alltrim(aMetas[fr,1]) = Alltrim(cMaq+"A")
		 		   			nPosiMaq := fr
		 		   			nMeta1_A += aMetas[ nPosiMaq, 3 ]	 
		 		   			nMeta2_A += aMetas[ nPosiMaq, 4 ]
		 		   			nMeta3_A += aMetas[ nPosiMaq, 5 ]	 			
		 		   			//Exit
		 		   			 			
		 		   		Endif
		 		   		fr++
		 		   	Enddo	 		   	
			 		///1o. turno 
			 		@ Prow()    ,004 PSAY "A"
			 		@ Prow()    ,007 PSAY nMeta1_A  Picture "@E 999,999.99"					//ESTIMADO(MR) - A
			 		@ Prow()    ,018 PSAY aResult3[X,5] Picture "@E 999,999.99"					//REAL(MR) - A
			 		 		 	    
			 	    If  nMeta1_A > aResult3[X,5]     //META > PRODUZIDO
				 		@ Prow(),030  PSAY ( nMeta1_A   - aResult3[X,5] ) Picture "@E 999,999.99" 	//DIFERENÇA 	 	
				 		nPerDif1 := ( aResult3[X,5] / nMeta1_A ) * 100
				 	Else
				 		@ Prow(),030  PSAY ( aResult3[X,5]   - nMeta1_A ) Picture "@E 999,999.99" 	//DIFERENÇA 	 	
				 		nPerDif1 := ( nMeta1_A / aResult3[X,5] ) * 100
				 	Endif
			 	    
			  		@ Prow(),042 PSAY nPerDif1 Picture "@E 999.99"	  //DIF %
			 		@ Prow(),050 PSAY aResult3[X,2] / ( aResult3[X,5]   + aResult3[X,2] ) * 100 Picture "@E 999.99"   	//APARA %	 
			 		
			 		//2o. turno	 			        
			 		@ Prow(),059 PSAY nMeta2_A Picture "@E 999,999.99"	 		//ESTIMADO(MR) - META A
			 		@ Prow(),072 PSAY aResult3[X,7] Picture "@E 999,999.99"         //REAL(MR) - PRODUZIDO A			 	                                                                                                            
			 		 		
			 		If (nMeta2_A   >  aResult3[X,7] )			 		
			 			@ Prow(),084  PSAY ( nMeta2_A  -  aResult3[X,7] ) Picture "@E 999,999.99" 	//DIFERENÇA META - REAL
			 			nPerDif2 := ( aResult3[X,7]   / nMeta2_A ) * 100	   
			 		
			 		Else			 			
			 			@ Prow(),084 PSAY ( aResult3[X,7]  - nMeta2_A ) Picture "@E 999,999.99" 	//DIFERENÇA REAL - META
			 			nPerDif2 := ( nMeta2_A / aResult3[X,7] ) * 100	   
			 		Endif
			 		
			 		@ Prow()    ,098 PSAY nPerDif2 Picture "@E 999.99"	//DIF%	 		 	
			 		@ Prow()    ,107 PSAY aResult3[X,3] / ( aResult3[X,7] + aResult3[X,3] ) * 100 Picture "@E 999.99"	//APARA %	 	
		 			 	 	        
			 		//3o. turno	 					
			 		@ Prow(),116 PSAY nMeta3_A Picture "@E 999,999.99"		//ESTIMADO(MR) - META A
			 		@ Prow(),129 PSAY aResult3[X,9] Picture "@E 999,999.99"     //REAL(MR) - PRODUZIDO	A	 		
			 	 	
			 		If (nMeta3_A  >  aResult3[X,9] )
			 			@ Prow(),141 PSAY ( nMeta3_A  -  aResult3[X,9] ) Picture "@E 999,999.99" 	//DIFERENÇA (ESTIMADO - REAL)
			 			nPerDif3 := (  aResult3[X,9]  / nMeta3_A  ) * 100	   	 	
			 		Else
			 			@ Prow(),141 PSAY ( aResult3[X,9] - nMeta3_A ) Picture "@E 999,999.99" 	//DIFERENÇA (ESTIMADO - REAL)	 	
			 			nPerDif3 := ( nMeta3_A /  aResult3[X,9] ) * 100
			 		Endif
				 	
			 		@ Prow(),154 PSAY nPerDif3 Picture "@E 999.99"            //DIF %	 	
			 		@ Prow(),163 PSAY aResult3[X,4] / ( aResult3[X,9] + aResult3[X,4] ) * 100 Picture "@E 999.99"	//APARA % 		 	
			 		
			 		nTotMLEX1A := nTotMLEX1A + aResult3[X,5]
					nTotMLEX2A := nTotMLEX2A + aResult3[X,7]
					nTotMLEX3A := nTotMLEX3A + aResult3[X,9] 
					
					nTotMeta1A := nTotMeta1A + nMeta1_A
					nTotMeta2A := nTotMeta2A + nMeta2_A
					nTotMeta3A := nTotMeta3A + nMeta3_A
					
		 		Endif
		 		
		 		//NA PRÓX. LINHA IMPRIME AS INFORMAÇÕES DO OUTRO LADO DA MÁQUINA
		 		If Alltrim(mv_par05) = "B" .or. Empty(mv_par05)
		 		    nMeta1_B := 0
			 		nMeta2_B := 0
			 		nMeta3_B := 0 
			 		fr := 1
			 		nPosiMaq := 0	 		   
		 		   	While fr <= Len(aMetas)
		 		   		If Alltrim(aMetas[fr,1]) = Alltrim(cMaq+"B")
		 		   			nPosiMaq := fr
		 		   			nMeta1_B += aMetas[ nPosiMaq, 3 ]	 
		 		   			nMeta2_B += aMetas[ nPosiMaq, 4 ]
		 		   			nMeta3_B += aMetas[ nPosiMaq, 5 ]	 			
		 		   			//Exit
		 		   			 			
		 		   		Endif
		 		   		fr++
		 		   	Enddo	 		   	
		 			
			 		//1o. turno
			 		@ Prow()+1  ,004 PSAY "B"
			 		@ Prow()    ,007 PSAY nMeta1_B Picture "@E 999,999.99"					//ESTIMADO(MR) - B
			 		@ Prow()    ,018 PSAY aResult3[X,6] Picture "@E 999,999.99"					//REAL(MR) - B
			 		 		 	    
			 	    If ( nMeta1_B  )  >  (aResult3[X,6] )     //META > PRODUZIDO
				 		@ Prow(),030  PSAY ( nMeta1_B   - aResult3[X,6] ) Picture "@E 999,999.99" 	//DIFERENÇA 	 	
				 		nPerDif1 := ( aResult3[X,6] / nMeta1_B ) * 100
				 	Else
				 		@ Prow(),030  PSAY ( aResult3[X,6]   - nMeta1_B ) Picture "@E 999,999.99" 	//DIFERENÇA 	 	
				 		nPerDif1 := ( nMeta1_B / aResult3[X,6] ) * 100
				 	Endif
			 	    
			  		@ Prow(),042 PSAY nPerDif1 Picture "@E 999.99"	  //DIF %
			 		@ Prow(),050 PSAY aResult3[X,2] / ( aResult3[X,6]   + aResult3[X,2] ) * 100 Picture "@E 999.99"   	//APARA %	 
			 		
			 		//2o. turno
			 		@ Prow(),059 PSAY nMeta2_B Picture "@E 999,999.99"	 		//ESTIMADO(MR) - META B
			 		@ Prow(),072 PSAY aResult3[X,8] Picture "@E 999,999.99"         //REAL(MR) - PRODUZIDO B	 	                                                                                                            
			 		 		
			 		If (nMeta2_B   >  aResult3[X,8] )
			 		
			 			@ Prow(),084  PSAY ( nMeta2_B  -  aResult3[X,8] ) Picture "@E 999,999.99" 	//DIFERENÇA META - REAL
			 			nPerDif2 := ( aResult3[X,8]   / nMeta2_B ) * 100	   
			 		
			 		Else
			 			
			 			@ Prow(),084 PSAY ( aResult3[X,8]  - nMeta2_B ) Picture "@E 999,999.99" 	//DIFERENÇA REAL - META
			 			nPerDif2 := ( nMeta2_B / aResult3[X,8] ) * 100	   
			 		Endif
			 		
			 		@ Prow()    ,098 PSAY nPerDif2 Picture "@E 999.99"	//DIF%	 		 	
			 		@ Prow()    ,107 PSAY aResult3[X,3] / ( aResult3[X,8] + aResult3[X,3] ) * 100 Picture "@E 999.99"	//APARA %	 	
		 	
		 	 	        
			 		//3o. turno	 				
			 		@ Prow(),116 PSAY nMeta3_B Picture "@E 999,999.99"		//ESTIMADO(MR) - META B
			 		@ Prow(),129 PSAY aResult3[X,10] Picture "@E 999,999.99"     //REAL(MR) - PRODUZIDO	A	 		
			 	 	
			 		If (nMeta3_B  >  aResult3[X,10] )
			 			@ Prow(),141 PSAY ( nMeta3_B  -  aResult3[X,10] ) Picture "@E 999,999.99" 	//DIFERENÇA (ESTIMADO - REAL)
			 			nPerDif3 := (  aResult3[X,10]  / nMeta3_B  ) * 100	   	 	
			 		Else
			 			@ Prow(),141 PSAY ( aResult3[X,10] - nMeta3_B ) Picture "@E 999,999.99" 	//DIFERENÇA	 	
			 			nPerDif3 := ( nMeta3_B /  aResult3[X,10] ) * 100
			 		Endif
				 	
			 		@ Prow(),154 PSAY nPerDif3 Picture "@E 999.99"            //DIF %	 	
			 		@ Prow(),163 PSAY aResult3[X,4] / ( aResult3[X,10] + aResult3[X,4] ) * 100 Picture "@E 999.99"	//APARA % 		 			
			 		
			 		nTotMLEX1B := nTotMLEX1B + aResult3[X,6]
					nTotMLEX2B := nTotMLEX2B + aResult3[X,8]
					nTotMLEX3B := nTotMLEX3B + aResult3[X,10]
					
					nTotMeta1B := nTotMeta1B + nMeta1_B
					nTotMeta2B := nTotMeta2B + nMeta2_B
					nTotMeta3B := nTotMeta3B + nMeta3_B
				
	            Endif
	            
	        Else		//se a máquina não possuir mais de um lado, imprime da forma abaixo:
		        nMeta1_U := 0
			 	nMeta2_U := 0
			 	nMeta3_U := 0 
			 	fr := 1
			 	nPosiMaq := 0	 		   
		 		While fr <= Len(aMetas)
		 			If Alltrim(aMetas[fr,1]) = Alltrim(cMaq+"")
		 		   		nPosiMaq := fr
		 		   		nMeta1_U += aMetas[ nPosiMaq, 3 ]	 
		 		   		nMeta2_U += aMetas[ nPosiMaq, 4 ]
		 		   		nMeta3_U += aMetas[ nPosiMaq, 5 ]	 			
		 		   	Endif
		 		   		fr++
		 		 Enddo	 		   	
				//1o. turno	 	
			 	@ Prow() + 2,000 PSAY Left( aResult3[X,1], 3 )                          	//MAQ
			 		 
		 		@ Prow(),007 PSAY nMeta1_U Picture "@E 999,999.99"			//ESTIMADO(MR)        	 	 			 			 	
		 		@ Prow(),018 PSAY aResult3[X,11] Picture "@E 999,999.99"           	//REAL(MR)		 	
		 			 	
		 		If nMeta1_U  > aResult3[X,11]
		 			@ Prow(),030 PSAY ( nMeta1_U - aResult3[X,11] ) Picture "@E 999,999.99"         //DIFERENÇA 
		 			nPerDif1 := ( aResult3[X,11] / nMeta1_U ) * 100
		 		Else
		 			@ Prow(),030 PSAY ( aResult3[X,11] - nMeta1_U ) Picture "@E 999,999.99"         //DIFERENÇA
		 			nPerDif1 := ( nMeta1_U / aResult3[X,11] ) * 100
		 		Endif
		 		
		 		@ Prow(),042 PSAY nPerDif1 Picture "@E 999.99" //DIF %		 
		 		@ Prow(),050 PSAY aResult3[X,2] / ( aResult3[X,11] + aResult3[X,2] ) * 100 Picture "@E 999.99" //APARA %
		 		 
                        
				//2o. turno
		 		@ Prow(),059 PSAY nMeta2_U Picture "@E 999,999.99"			//ESTIMADO(MR)        	 	 			 			 	
		 		@ Prow(),072 PSAY aResult3[X,12] Picture "@E 999,999.99"           	//REAL(MR)		 	
		 		
		 		If (  nMeta2_U > aResult3[X,12] )
		 			@ Prow(),084 PSAY ( nMeta2_U -  aResult3[X,12] ) Picture "@E 999,999.99"    //DIFERENÇA 
		 			nPerDif2 := ( aResult3[X,12] / nMeta2_U ) * 100
		 		Else
		 			@ Prow(),084 PSAY ( aResult3[X,12] - nMeta2_U ) Picture "@E 999,999.99"    //DIFERENÇA 
		 			nPerDif2 := ( nMeta2_U / aResult3[X,12] ) * 100
		 		Endif
		 		
		 		@ Prow()    ,098 PSAY nPerDif2 Picture "@E 999.99" //DIF %		 
		 		@ Prow()    ,107 PSAY aResult3[X,3] / ( aResult3[X,12] + aResult3[X,3] ) * 100 Picture "@E 999.99" //APARA %
		 		 	                       
         	   
		 		//3o. turno		 		
		 		@ Prow(),116 PSAY nMeta3_U  Picture "@E 999,999.99"			//ESTIMADO(MR)        	 	 			 			 	
		 		@ Prow(),129 PSAY aResult3[X,13] Picture "@E 999,999.99"          	//REAL(MR)		 
		 		
		 	
		 		If ( nMeta3_U   >  aResult3[X,13] ) 
		 			@ Prow(),141 PSAY ( nMeta3_U  - aResult3[X,13]  ) Picture "@E 999,999.99"           //DIFERENÇA 
		 			nPerDif3 := ( aResult3[X,13] / nMeta3_U ) * 100
		 		Else
		 			@ Prow(),141 PSAY ( aResult3[X,13]  - nMeta3_U ) Picture "@E 999,999.99"           //DIFERENÇA
		 			nPerDif3 := ( nMeta3_U  / aResult3[X,13] ) * 100
		 		Endif
		 		
		 		@ Prow(),154 PSAY nPerDif3 Picture "@E 999.99" //DIF %		 
		 		@ Prow(),163 PSAY aResult3[X,4] / ( aResult3[X,13] + aResult3[X,4] ) * 100 Picture "@E 999.99" //APARA %
		 		
		 		nTotMLEX1U := nTotMLEX1U + aResult3[X,11]
				nTotMLEX2U := nTotMLEX2U + aResult3[X,12]
				nTotMLEX3U := nTotMLEX3U + aResult3[X,13]
				
				nTotMeta1U := nTotMeta1U + nMeta1_U //aResult3[X,25]
				nTotMeta2U := nTotMeta2U + nMeta2_U //aResult3[X,26]
				nTotMeta3U := nTotMeta3U + nMeta3_U //aResult3[X,27]
		        	        
		 	Endif
		 	
		 
				nTotAPEX1 := nTotAPEX1 + aResult3[X,2]
				nTotAPEX2 := nTotAPEX2 + aResult3[X,3]
				nTotAPEX3 := nTotAPEX3 + aResult3[X,4]				
					 	
				nPerDif1 := nPerDif2 := nPerDif3 := 0

		NEXT

		@ Prow() + 2,000 PSAY Repl( "-", 220 )
                
        
		//totais
		//1o. turno
		//@ Prow() + 1,005 PSAY nTotOPEX1 Picture "@E 9999"				    			//OP
	
			@ Prow()    ,007 PSAY (nTotMeta1A + nTotMeta1B + nTotMeta1U) Picture "@E 999,999.99"					//ESTIMADO(MR) - META         	 	 			
			@ Prow()    ,018 PSAY (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) Picture "@E 999,999.99"          		//REAL(MR)
			
			If (nTotMeta1A + nTotMeta1B + nTotMeta1U) > (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U)
				@ Prow()	,030 PSAY ( (nTotMeta1A + nTotMeta1B + nTotMeta1U) - (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) ) Picture "@E 999,999.99"	//DIFERENÇA 						
				nPerDif1:= ( (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) / (nTotMeta1A + nTotMeta1B + nTotMeta1U) ) * 100
			Else
				@ Prow()	,030 PSAY ((nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) - (nTotMeta1A + nTotMeta1B + nTotMeta1U) ) Picture "@E 999,999.99"	//DIFERENÇA 
				nPerDif1:= ( (nTotMeta1A + nTotMeta1B + nTotMeta1U) / (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) ) * 100
			Endif
			@ Prow()    ,042 PSAY nPerDif1 Picture "@E 999.99"	//DIF %			
			@ Prow()    ,050 PSAY (nTotAPEX1 / ( (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) + nTotAPEX1 ) ) * 100 Picture "@E 999.99"	//APARA %
		
        
		//2o. turno		
	
			@ Prow(),059 PSAY (nTotMeta2A + nTotMeta2B + nTotMeta2U) Picture "@E 999,999.99"					//ESTIMADO(MR) - META         	 	 			
			@ Prow(),072 PSAY (nTotMLEX2A + nTotMLEX2B + nTotMLEX2U) Picture "@E 999,999.99"          		//REAL(MR)
			
		
			If (nTotMeta2A + nTotMeta2B + nTotMeta2U ) > (nTotMLEX2A + nTotMLEX2B + nTotMLEX2U)
				@ Prow(),084 PSAY ( (nTotMeta2A + nTotMeta2B + nTotMeta2U) - (nTotMLEX2A + nTotMLEX2B+ nTotMLEX2U) ) Picture "@E 999,999.99"	//DIFERENÇA
				nPerDif2:= ( (nTotMLEX2A + nTotMLEX2B + nTotMLEX2U) / (nTotMeta2A + nTotMeta2B + nTotMeta2U) ) * 100
			Else 
				@ Prow(),084 PSAY ( (nTotMLEX2A + nTotMLEX2B + nTotMLEX2U) - (nTotMeta2A + nTotMeta2B + nTotMeta2U) ) Picture "@E 999,999.99"	//DIFERENÇA
				nPerDif2:= ( (nTotMeta2A + nTotMeta2B + nTotMeta2U) / (nTotMLEX2A + nTotMLEX2B + nTotMLEX2U) ) * 100
			Endif 
			@ Prow(),098 PSAY nPerDif2 Picture "@E 999.99"	//DIF %						
			@ Prow(),107 PSAY (nTotAPEX2 / ( (nTotMLEX2A + nTotMLEX2B + nTotMLEX2U) + nTotAPEX2 ) ) * 100 Picture "@E 999.99"	//APARA %
		
		
		
		//3o. turno
		
			@ Prow(),116 PSAY (nTotMeta3A + nTotMeta3B + nTotMeta3U) Picture "@E 999,999.99"					//ESTIMADO(MR) - META         	 	 			
			@ Prow(),129 PSAY (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) Picture "@E 999,999.99"          		//REAL(MR)
					
			If (nTotMeta3A + nTotMeta3B + nTotMeta3U) > (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U)
				@ Prow(),141 /*214*/ PSAY ((nTotMeta3A + nTotMeta3B + nTotMeta3U) - (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U)) Picture "@E 999,999.99"	//DIFERENÇA
				nPerDif3:= ( (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) / (nTotMeta3A + nTotMeta3B + nTotMeta3U) ) * 100
			Else 
				@ Prow(),141 /*214*/ PSAY ((nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) - (nTotMeta3A + nTotMeta3B + nTotMeta3U) ) Picture "@E 999,999.99"	//DIFERENÇA
				nPerDif3:= ( (nTotMeta3A + nTotMeta3B + nTotMeta3U) / (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) ) * 100
			Endif 
			@ Prow(),154 PSAY nPerDif3 Picture "@E 999.99"	//DIF %									
			@ Prow(),163 PSAY (nTotAPEX3 / ( (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) + nTotAPEX3 ) ) * 100 Picture "@E 999.99"	//APARA %
			
			
	        nTTMLEX1A += nTotMLEX1A 
			nTTMLEX1B += nTotMLEX1B
			     
			nTTMLEX2A += nTotMLEX2A
			nTTMLEX2B += nTotMLEX2B
			
			nTTMLEX3A += nTotMLEX3A
			nTTMLEX3B += nTotMLEX3B
				
			nTTMLEX1U += nTotMLEX1U 
			nTTMLEX2U += nTotMLEX2U					
			nTTMLEX3U += nTotMLEX3U
							     
			nTTMeta1A += nTotMeta1A 
			nTTMeta1B += nTotMeta1B
			     
			nTTMeta2A += nTotMeta2A
		    nTTMeta2B += nTotMeta2B
		      	 
		    nTTMeta3A += nTotMeta3A
		    nTTMeta3B += nTotMeta3B
		    
		    nTTMeta1U += nTotMeta1U 
		    nTTMeta2U += nTotMeta2U
		    nTTMeta3U += nTotMeta3U
			     
			nTTAPEX1 += nTotAPEX1
			nTTAPEX2 += nTotAPEX2
			nTTAPEX3 += nTotAPEX3
			
			nTotMLEX1A := 0
	       	nTotMLEX2A := 0
	       	nTotMLEX3A := 0
	       
	       	nTotMLEX1B := 0
	       	nTotMLEX2B := 0
	       	nTotMLEX3B := 0
	       	
	       	nTotMLEX1U := 0
	       	nTotMLEX2U := 0
	       	nTotMLEX3U := 0
	       
	       	nTotAPEX1 := 0
	       	nTotAPEX2 := 0
	       	nTotAPEX3 := 0
	       
	       	nTotMeta1A := nTotMeta2A := nTotMeta3A := 0
	       	nTotMeta1B := nTotMeta2B := nTotMeta3B := 0
	       	nTotMeta1U := nTotMeta2U := nTotMeta3U := 0
	       
	       	nPerDif1 := 0
		   	nPerDif2 := 0
	       	nPerDif3 := 0
       
        
EndIf
	
    //
     
If Len(aResult4) > 0
       	
       	//MSGBOX("ARESULT4")
       
	   nTotAPEX1 := 0
	   nTotAPEX2 := 0 
	   nTotAPEX3 := 0
	   
	   	   
	   nTotMLEX1A := 0
	   nTotMLEX2A := 0
	   nTotMLEX3A := 0
	   
	   nTotMLEX1B := 0
	   nTotMLEX2B := 0
	   nTotMLEX3B := 0
	   
	   nTotMLEX1U := 0
	   nTotMLEX2U := 0
	   nTotMLEX3U := 0   
	   
	   	      
	   nTotMeta1A := 0
	   nTotMeta2A := 0
	   nTotMeta3A := 0
	   
	   nTotMeta1B := 0
	   nTotMeta2B := 0
	   nTotMeta3B := 0
	   
	   nTotMeta1U := 0
	   nTotMeta2U := 0
	   nTotMeta3U := 0
	   
	   	nMeta1_A := 0
		nMeta2_A := 0
	    nMeta3_A := 0
	    
	    nMeta1_B := 0
	    nMeta2_B := 0
	    nMeta3_B := 0
	    
	    nMeta1_U := 0
	    nMeta2_U := 0
	    nMeta3_U := 0
	    
	    aMetasA  := {}
	    aMetasB  := {}
	    aMetasU  := {}
	    cMaq	 := ""
	   
	   nPerDif1 := nPerDif2 := nPerDif3 := 0
       Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  // Impressao do cabecalho
	   	@Prow()+1, 000 PSAY Cabec3
		@Prow() + 1,000 PSAY REPLICATE("_",220)
	   
	   FOR X := 1 TO Len(aResult4)
	   
			cMaq := Alltrim(aResult4[X,1])
			
		 	If X > 1
		      If Left(aResult4[X,1],2) != Left(aResult4[X-1,1],2)
		      	      		
		      	         
		         //1o.turno
		         @ Prow() + 2,000 PSAY Repl( "-", 220 )
			     @ Prow() +1 ,000 PSAY "SUB"
			     //@ Prow()    ,005 PSAY nTotOPEX1 Picture "@E 9999"							//OP
			  	     
				     @ Prow(),007 PSAY (nTotMeta1A + nTotMeta1B + nTotMeta1U) Picture "@E 999,999.99"					//ESTIMADO(MR)         	 	 	
				     @ Prow(),018 PSAY (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) Picture "@E 999,999.99"     			//REAL(MR)
				    			     
				     If (nTotMeta1A + nTotMeta1B + nTotMeta1U) > (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U)
				     	@ Prow(),030 PSAY ( (nTotMeta1A + nTotMeta1B + nTotMeta1U) - (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) ) Picture "@E 999,999.99"  //DIFERENÇA
				     	nPerDif1:= ( (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) / (nTotMeta1A + nTotMeta1B + nTotMeta1U) ) * 100
				     Else 
				     	@ Prow(),030 PSAY ( (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) - (nTotMeta1A + nTotMeta1B + nTotMeta1U)) Picture "@E 999,999.99"  //DIFERENÇA
				     	nPerDif1:= ( (nTotMeta1A + nTotMeta1B + nTotMeta1U)/ (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) ) * 100
				     Endif
				     
				     @ Prow()	,042 PSAY nPerDif1 Picture "@E 999.99"	//DIF %
				     @ Prow()	,050 /*073*/ PSAY (nTotAPEX1 / ( (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) + nTotAPEX1 ) ) * 100 Picture "@E 999.99"	//APARA %
			     
			     
			     
			     //2o. turno		     
			  
				     @ Prow()    ,059 PSAY (nTotMeta2A + nTotMeta2B + nTotMeta2U) Picture "@E 999,999.99"					//ESTIMADO(MR)         	 	 	
				     @ Prow()    ,072 PSAY (nTotMLEX2A + nTotMLEX2B + nTotMLEX2U) Picture "@E 999,999.99"     			//REAL(MR)
				    			     
				     If (nTotMeta2A + nTotMeta2B  + nTotMeta2U) > (nTotMLEX2A + nTotMLEX2B  + nTotMLEX2U)
				     	@ Prow()    ,084 PSAY ( (nTotMeta2A + nTotMeta2B  + nTotMeta2U) - (nTotMLEX2A + nTotMLEX2B  + nTotMLEX2U)) Picture "@E 999,999.99"  //DIFERENÇA
				     	nPerDif2:= ( (nTotMLEX2A + nTotMLEX2B  + nTotMLEX2U) / (nTotMeta2A + nTotMeta2B  + nTotMeta2U)) * 100
				     Else 
				     	@ Prow()    ,084 PSAY ( (nTotMLEX2A + nTotMLEX2B) - (nTotMeta2A + nTotMeta2B  + nTotMeta2U)) Picture "@E 999,999.99"  //DIFERENÇA
				     	nPerDif2:= ( (nTotMeta2A + nTotMeta2B  + nTotMeta2U) / (nTotMLEX2A + nTotMLEX2B  + nTotMLEX2U) ) * 100
				     Endif 
				     @ Prow(),098 PSAY nPerDif2 Picture "@E 999.99"	//DIF %
				     @ Prow(),107 PSAY (nTotAPEX2 / ( (nTotMLEX2A + nTotMLEX2B + nTotMLEX2U) + nTotAPEX2 ) ) * 100 Picture "@E 999.99"	//APARA %
			     
			    
	             
	             //3o. turno
			    
				     @ Prow()    ,116 PSAY (nTotMeta3A + nTotMeta3B + nTotMeta3U) Picture "@E 999,999.99"					//ESTIMADO(MR)         	 	 	
				     @ Prow()    ,129 PSAY (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) Picture "@E 999,999.99"     			//REAL(MR)
				    			    		     
				     If (nTotMeta3A + nTotMeta3B + nTotMeta3U) > (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U)
				     	@ Prow()    ,141 PSAY ( (nTotMeta3A + nTotMeta3B + nTotMeta3U) - (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U)) Picture "@E 999,999.99"  //DIFERENÇA
				     	nPerDif3:= ( (nTotMLEX3A + nTotMLEX3B + nTotMeta3U) / (nTotMeta3A + nTotMeta3B + nTotMLEX3U) ) * 100
				     Else 
				     	@ Prow()    ,141 PSAY ( (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) - (nTotMeta3A + nTotMeta3B + nTotMeta3U)) Picture "@E 999,999.99"  //DIFERENÇA
				     	nPerDif3:= ( (nTotMeta3A + nTotMeta3B + nTotMeta3U) / (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) ) * 100
				     Endif
				     @ Prow(),154 PSAY nPerDif3 Picture "@E 999.99"	//DIF %
				     @ Prow(),163  PSAY (nTotAPEX3 / ( (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) + nTotAPEX3 ) ) * 100 Picture "@E 999.99"	//APARA %         
	             
		             nTotAPEX1 := 0
					 nTotAPEX2 := 0 
					 nTotAPEX3 := 0
					   
					 nTotMLEX1A := 0
					 nTotMLEX2A := 0
					 nTotMLEX3A := 0
					   
					 nTotMLEX1B := 0
					 nTotMLEX2B := 0
					 nTotMLEX3B := 0 
					 
					 nTotMLEX1U := 0
					 nTotMLEX2U := 0
					 nTotMLEX3U := 0
					   	   
					 nTotMeta1A := 0
					 nTotMeta2A := 0
					 nTotMeta3A := 0
					 
					 nTotMeta1B := 0
					 nTotMeta2B := 0
					 nTotMeta3B := 0 
					 
					 nTotMeta1U := 0
					 nTotMeta2U := 0
					 nTotMeta3U := 0
				   
					 nPerDif1 := nPerDif2 := nPerDif3 := 0
	             
	     	     	 
		      EndIf
	        EndIf			
	 
	 	
	 		nLados := 0
		 	nLados := TrazLados( Alltrim(aResult4[X,1]) )
			
		 	@ Prow() + 2,000 PSAY Left( aResult4[X,1], 3 )                           			//MAQ
		 	
		 	If nLados > 1
		 		If Alltrim(mv_par05) = "A" .or. Empty(mv_par05) 
		 		    nMeta1_A := 0
			 		nMeta2_A := 0
			 		nMeta3_A := 0 
			 		fr := 1
			 		nPosiMaq := 0	 		   
		 		   	While fr <= Len(aMetas)
		 		   		If Alltrim(aMetas[fr,1]) = Alltrim(cMaq+"A")
		 		   			nPosiMaq := fr
		 		   			nMeta1_A += aMetas[ nPosiMaq, 3 ]	 
		 		   			nMeta2_A += aMetas[ nPosiMaq, 4 ]
		 		   			nMeta3_A += aMetas[ nPosiMaq, 5 ]	 			
		 		   		Endif
		 		   		fr++
		 		   	Enddo	 		   	
			 		///1o. turno 
			 		@ Prow()    ,004 PSAY "A"
			 		@ Prow()    ,007 PSAY  nMeta1_A Picture "@E 999,999.99"					//ESTIMADO(MR) - A
			 		@ Prow()    ,018 PSAY aResult4[X,5] Picture "@E 999,999.99"					//REAL(MR) - A
			 		 		 	    
			 	    If ( nMeta1_A  )  >  (aResult4[X,5] )     //META > PRODUZIDO
				 		@ Prow(),030  PSAY ( nMeta1_A   - aResult4[X,5] ) Picture "@E 999,999.99" 	//DIFERENÇA 	 	
				 		nPerDif1 := ( aResult4[X,5] / nMeta1_A ) * 100
				 	Else
				 		@ Prow(),030  PSAY ( aResult4[X,5]   - nMeta1_A ) Picture "@E 999,999.99" 	//DIFERENÇA 	 	
				 		nPerDif1 := ( nMeta1_A / aResult4[X,5] ) * 100
				 	Endif
			 	    
			  		@ Prow(),042 PSAY nPerDif1 Picture "@E 999.99"	  //DIF %
			 		@ Prow(),050 PSAY aResult4[X,2] / ( aResult4[X,5]   + aResult4[X,2] ) * 100 Picture "@E 999.99"   	//APARA %	 
		 		
			 		//2o. turno	 				
			 		@ Prow(),059 PSAY nMeta2_A Picture "@E 999,999.99"	 		//ESTIMADO(MR) - META A
			 		@ Prow(),072 PSAY aResult4[X,7] Picture "@E 999,999.99"         //REAL(MR) - PRODUZIDO A
			 	                                                                                                            
			 		 		
			 		If (nMeta2_A   >  aResult4[X,7] )			 		
			 			@ Prow(),084  PSAY ( nMeta2_A  -  aResult4[X,7] ) Picture "@E 999,999.99" 	//DIFERENÇA META - REAL
			 			nPerDif2 := ( aResult4[X,7]   / nMeta2_A ) * 100	   
			 		
			 		Else			 			
			 			@ Prow(),084 PSAY ( aResult4[X,7]  - nMeta2_A ) Picture "@E 999,999.99" 	//DIFERENÇA
			 			nPerDif2 := ( nMeta2_A / aResult4[X,7] ) * 100	   
			 		Endif
			 		
			 		@ Prow()    ,098 PSAY nPerDif2 Picture "@E 999.99"	//DIF%	 		 	
			 		@ Prow()    ,107 PSAY aResult4[X,3] / ( aResult4[X,7] + aResult4[X,3] ) * 100 Picture "@E 999.99"	//APARA %	 	
		 			 	 	        
			 		//3o. turno	 
			 		@ Prow(),116 PSAY nMeta3_A Picture "@E 999,999.99"		//ESTIMADO(MR) - META A
			 		@ Prow(),129 PSAY aResult4[X,9] Picture "@E 999,999.99"     //REAL(MR) - PRODUZIDO	A	 		
			 	 	
			 		If (nMeta3_A  >  aResult4[X,9] )
			 			@ Prow(),141 PSAY ( nMeta3_A  -  aResult4[X,9] ) Picture "@E 999,999.99" 	//DIFERENÇA (ESTIMADO - REAL)
			 			nPerDif3 := (  aResult4[X,9]  / nMeta3_A  ) * 100	   	 	
			 		Else
			 			@ Prow(),141 PSAY ( aResult4[X,9] - nMeta3_A ) Picture "@E 999,999.99" 	//DIFERENÇA 	 	
			 			nPerDif3 := ( nMeta3_A /  aResult4[X,9] ) * 100
			 		Endif
				 	
			 		@ Prow(),154 PSAY nPerDif3 Picture "@E 999.99"            //DIF %	 	
			 		@ Prow(),163 PSAY aResult4[X,4] / ( aResult4[X,9] + aResult4[X,4] ) * 100 Picture "@E 999.99"	//APARA % 		 	
			 		
			 		nTotMLEX1A := nTotMLEX1A + aResult4[X,5]
					nTotMLEX2A := nTotMLEX2A + aResult4[X,7]
					nTotMLEX3A := nTotMLEX3A + aResult4[X,9] 
					
					nTotMeta1A := nTotMeta1A + nMeta1_A		
					nTotMeta2A := nTotMeta2A + nMeta2_A		
					nTotMeta3A := nTotMeta3A + nMeta3_A
							
		 		Endif
		 		
		 		//NA PRÓX. LINHA IMPRIME AS INFORMAÇÕES DO OUTRO LADO DA MÁQUINA
		 		If Alltrim(mv_par05) = "B" .or. Empty(mv_par05)
		 			nMeta1_B := 0
			 		nMeta2_B := 0
			 		nMeta3_B := 0 
			 		fr := 1
			 		nPosiMaq := 0	 		   
		 		   	While fr <= Len(aMetas)
		 		   		If Alltrim(aMetas[fr,1]) = Alltrim(cMaq+"B")
		 		   			nPosiMaq := fr
		 		   			nMeta1_B += aMetas[ nPosiMaq, 3 ]	 
		 		   			nMeta2_B += aMetas[ nPosiMaq, 4 ]
		 		   			nMeta3_B += aMetas[ nPosiMaq, 5 ]	 			
		 		   			//Exit
		 		   			 			
		 		   		Endif
		 		   		fr++
		 		   	Enddo	 		   	
			 		//1o. turno
			 		@ Prow()+1  ,004 PSAY "B"
			 		@ Prow()    ,007 PSAY nMeta1_B  Picture "@E 999,999.99"					//ESTIMADO(MR) - B
			 		@ Prow()    ,018 PSAY aResult4[X,6] Picture "@E 999,999.99"					//REAL(MR) - B
			 		 		 	    
			 	    If nMeta1_B  >  aResult4[X,6]     //META > PRODUZIDO
				 		@ Prow(),030  PSAY ( nMeta1_B   - aResult4[X,6] ) Picture "@E 999,999.99" 	//DIFERENÇA 	 	
				 		nPerDif1 := ( aResult4[X,6] / nMeta1_B ) * 100
				 	Else
				 		@ Prow(),030  PSAY ( aResult4[X,6]   - nMeta1_B ) Picture "@E 999,999.99" 	//DIFERENÇA 	 	
				 		nPerDif1 := ( nMeta1_B / aResult4[X,6] ) * 100
				 	Endif
			 	    
			  		@ Prow(),042 PSAY nPerDif1 Picture "@E 999.99"	  //DIF %
			 		@ Prow(),050 PSAY aResult4[X,2] / ( aResult4[X,6]   + aResult4[X,2] ) * 100 Picture "@E 999.99"   	//APARA %	 
		 		
			 		//2o. turno			 				 		
			 		@ Prow(),059 PSAY nMeta2_B Picture "@E 999,999.99"	 		//ESTIMADO(MR) - META B
			 		@ Prow(),072 PSAY aResult4[X,8] Picture "@E 999,999.99"         //REAL(MR) - PRODUZIDO B	 	                                                                                                            
			 		 		
			 		If (nMeta2_B   >  aResult4[X,8] )
			 		
			 			@ Prow(),084  PSAY ( nMeta2_B  -  aResult4[X,8] ) Picture "@E 999,999.99" 	//DIFERENÇA META - REAL
			 			nPerDif2 := ( aResult4[X,8]   / nMeta2_B ) * 100	   
			 		
			 		Else
			 			
			 			@ Prow(),084 PSAY ( aResult4[X,8]  - nMeta2_B ) Picture "@E 999,999.99" 	//DIFERENÇA
			 			nPerDif2 := ( nMeta2_B / aResult4[X,8] ) * 100	   
			 		Endif
			 		
			 		@ Prow()    ,098 PSAY nPerDif2 Picture "@E 999.99"	//DIF%	 		 	
			 		@ Prow()    ,107 PSAY aResult4[X,3] / ( aResult4[X,8] + aResult4[X,3] ) * 100 Picture "@E 999.99"	//APARA %	 	
			 			 	 	        
			 		//3o. turno
			 		@ Prow(),116 PSAY nMeta3_B Picture "@E 999,999.99"		//ESTIMADO(MR) - META B
			 		@ Prow(),129 PSAY aResult4[X,10] Picture "@E 999,999.99"     //REAL(MR) - PRODUZIDO	A	 		
			 	 	
			 		If (nMeta3_B  >  aResult4[X,10] )
			 			@ Prow(),141 PSAY ( nMeta3_B  -  aResult4[X,10] ) Picture "@E 999,999.99" 	//DIFERENÇA (ESTIMADO - REAL)
			 			nPerDif3 := (  aResult4[X,10]  / nMeta3_B  ) * 100	   	 	
			 		Else
			 			@ Prow(),141 PSAY ( aResult4[X,10] - nMeta3_B ) Picture "@E 999,999.99" 	//DIFERENÇA
			 			nPerDif3 := ( nMeta3_B /  aResult4[X,10] ) * 100
			 		Endif
				 	
			 		@ Prow(),154 PSAY nPerDif3 Picture "@E 999.99"            //DIF %	 	
			 		@ Prow(),163 PSAY aResult4[X,4] / ( aResult4[X,10] + aResult4[X,4] ) * 100 Picture "@E 999.99"	//APARA % 		 			
			 		
			 					
					nTotMLEX1B := nTotMLEX1B + aResult4[X,6]
					nTotMLEX2B := nTotMLEX2B + aResult4[X,8]
					nTotMLEX3B := nTotMLEX3B + aResult4[X,10]					
									
					nTotMeta1B := nTotMeta1B + nMeta1_B		
					nTotMeta2B := nTotMeta2B + nMeta2_B		
					nTotMeta3B := nTotMeta3B + nMeta3_B
					
	            Endif
	            
	        Else		//se a máquina não possuir mais de um lado, imprime da forma abaixo:
		
		 		//1o. turno
		 		nMeta1_U := 0
			 	nMeta2_U := 0
			 	nMeta3_U := 0 
			 	fr := 1
			 	nPosiMaq := 0	 		   
		 		While fr <= Len(aMetas)
		 			If Alltrim(aMetas[fr,1]) = Alltrim(cMaq+"")
		 				nPosiMaq := fr
		 				nMeta1_U += aMetas[ nPosiMaq, 3 ]	 
		 				nMeta2_U += aMetas[ nPosiMaq, 4 ]
		 		   		nMeta3_U += aMetas[ nPosiMaq, 5 ]	 			
		 		   	Endif
		 		   	fr++
		 		Enddo	 		   	
		 		
		 		@ Prow() + 2,000 PSAY Left( aResult4[X,1], 5 ) 							//MAQ
		 				 
		 		@ Prow()    ,007 PSAY nMeta1_U Picture "@E 999,999.99"		//ESTIMADO(MR)	 		 	 	
		 		@ Prow()    ,018 PSAY aResult4[X,11] Picture "@E 999,999.99"       //REAL(MR)	 
		 				 		
		 		If nMeta1_U > aResult4[X,11]
		 			@ Prow()    ,030 PSAY ( nMeta1_U - aResult4[X,11] ) Picture "@E 999,999.99"   //DIFERENÇA
		 			nPerDif1:= ( aResult4[X,11] / nMeta1_U ) * 100
		 		Else 
		 			@ Prow()    ,030 PSAY ( aResult4[X,11] - nMeta1_U ) Picture "@E 999,999.99"   //DIFERENÇA
		 			nPerDif1:= ( nMeta1_U / aResult4[X,11] ) * 100
		 		Endif
		 		
		 		@ Prow(),042 PSAY nPerDif1 Picture "@E 999.99"	//DIF %
		 		@ Prow(),050 PSAY aResult4[X,2] / ( aResult4[X,11] + aResult4[X,2] ) * 100 Picture "@E 999.99"	//APARA %	 	
		 	 		
		 	 	 	 	
		 		//2o. turno			
		 		@ Prow(),059 PSAY nMeta2_U Picture "@E 999,999.99"		//ESTIMADO(MR)	 		 		 	
		 		@ Prow(),072 PSAY aResult4[X,12] Picture "@E 999,999.99"       	//REAL(MR)	 
		 				 			 		
		 		If nMeta2_U > aResult4[X,12]
		 			@ Prow(),084 PSAY ( nMeta2_U  - aResult4[X,12] ) Picture "@E 999,999.99"       //DIFERENÇA
		 			nPerDif2:= ( aResult4[X,12] / nMeta2_U ) * 100
		 		Else 
		 			@ Prow(),084 PSAY ( aResult4[X,12] - nMeta2_U ) Picture "@E 999,999.99"       //DIFERENÇA
		 			nPerDif2:= ( nMeta2_U  / aResult4[X,12] ) * 100
		 		Endif
		 		
		 		@ Prow(),098 PSAY nPerDif2 Picture "@E 999.99"	//DIF %
		 	    @ Prow(),107 PSAY aResult4[X,3] / ( aResult4[X,12] + aResult4[X,3] ) * 100 Picture "@E 999.99"	//APARA %
		 
		 	 	 	
		 		//3o. turno
		 		@ Prow(),116 PSAY nMeta3_U Picture "@E 999,999.99"		//ESTIMADO(MR)	 		 	
		 		@ Prow(),129 PSAY aResult4[X,13] Picture "@E 999,999.99"       	//REAL(MR)	 
		 		
		 		If nMeta3_U  > aResult4[X,13]
		 			@ Prow(),141 PSAY ( nMeta3_U - aResult4[X,13] ) Picture "@E 999,999.99"       //DIFERENÇA
		 			nPerDif3:= ( aResult4[X,13] / nMeta3_U ) * 100
		 		Else
		 			@ Prow(),141 PSAY ( aResult4[X,13] - nMeta3_U ) Picture "@E 999,999.99"       //DIFERENÇA
		 			nPerDif3:= ( nMeta3_U / aResult4[X,13] ) * 100
		 		Endif 
		 		
		 		@ Prow(),154 PSAY nPerDif3 Picture "@E 999.99"	//DIF %
		 	    @ Prow(),163 PSAY aResult4[X,4] / ( aResult4[X,13] + aResult4[X,4] ) * 100 Picture "@E 999.99"	//APARA %	 	
		 	    
		 	    nTotMLEX1U := nTotMLEX1U + aResult4[X,11]
				nTotMLEX2U := nTotMLEX2U + aResult4[X,12]
				nTotMLEX3U := nTotMLEX3U + aResult4[X,13]
							
				nTotMeta1U := nTotMeta1U + nMeta1_U //aResult4[X,25]		
				nTotMeta2U := nTotMeta2U + nMeta2_U //aResult4[X,26]		
				nTotMeta3U := nTotMeta3U + nMeta3_U //aResult4[X,27]
	 
		    Endif
	
		
		nTotAPEX1 := nTotAPEX1 + aResult4[X,2]
		nTotAPEX2 := nTotAPEX2 + aResult4[X,3]
		nTotAPEX3 := nTotAPEX3 + aResult4[X,4]
		
	NEXT
	    //sub-totais
	    //1o. turno
	    @ Prow() + 2,000 PSAY Repl( "-", 220 )
		@ Prow() + 1,000 PSAY "SUB "
		//@ Prow()    ,005 PSAY nTotOPEX1 Picture "@E 9999"			   						//OP
	
		@ Prow()    ,007 PSAY (nTotMeta1A + nTotMeta1B + nTotMeta1U) Picture "@E 999,999.99"						//ESTIMADO(MR)         	 	 	
		@ Prow()    ,018 PSAY (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) Picture "@E 999,999.99"      				//REAL(MR)
			
		If (nTotMeta1A + nTotMeta1B + nTotMeta1U) > (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U)
			@ Prow(),030 PSAY ( (nTotMeta1A + nTotMeta1B + nTotMeta1U) - (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) ) Picture "@E 999,999.99"      //DIFERENÇA
			nPerDif1:= ( (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) / (nTotMeta1A + nTotMeta1B + nTotMeta1U) ) * 100
		Else 
			@ Prow(),030 PSAY ( (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) - (nTotMeta1A + nTotMeta1B + nTotMeta1U) ) Picture "@E 999,999.99"      //DIFERENÇA
			nPerDif1:= ( (nTotMeta1A + nTotMeta1B + nTotMeta1U) / (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) ) * 100
		Endif
		@ Prow(),042 PSAY nPerDif1 Picture "@E 999.99"	//DIF %
		@ Prow(),050 PSAY (nTotAPEX1 / ( (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) + nTotAPEX1 ) ) * 100 Picture "@E 999.99"	//APARA %
		
			
		//2o. turno   		
	
		@ Prow()    ,059 PSAY (nTotMeta2A + nTotMeta2B + nTotMeta2U) Picture "@E 999,999.99"						//ESTIMADO(MR)         	 	 	
		@ Prow()    ,072 PSAY (nTotMLEX2A + nTotMLEX2B + nTotMLEX2U) Picture "@E 999,999.99"      				//REAL(MR)
	
				
		If (nTotMeta2A + nTotMeta2B + nTotMeta2U)  > (nTotMLEX2A + nTotMLEX2B + nTotMLEX2U)
			@ Prow(),084 PSAY ( (nTotMeta2A + nTotMeta2B + nTotMeta2U) - (nTotMLEX2A + nTotMLEX2B + nTotMLEX2U) ) Picture "@E 999,999.99"      //DIFERENÇA
			nPerDif2:= ( (nTotMLEX2A + nTotMLEX2B + nTotMLEX2U) / (nTotMeta2A + nTotMeta2B + nTotMeta2U) ) * 100
		Else 
			@ Prow(),084 PSAY ( (nTotMLEX2A + nTotMLEX2B + nTotMLEX2U) - (nTotMeta2A + nTotMeta2B + nTotMeta2U) ) Picture "@E 999,999.99"      //DIFERENÇA
			nPerDif2:= ( (nTotMeta2A + nTotMeta2B + nTotMeta2U) / (nTotMLEX2A + nTotMLEX2B + nTotMLEX2U) ) * 100
		Endif 
		@ Prow(),098 PSAY nPerDif2 Picture "@E 999.99"	//DIF %
		@ Prow(),107 PSAY (nTotAPEX2 / ( (nTotMLEX2A + nTotMLEX2B + nTotMLEX2U) + nTotAPEX2 ) ) * 100 Picture "@E 999.99"	//APARA %
        
       
		//3o. turno
	
		@ Prow()    ,116 PSAY (nTotMeta3A + nTotMeta3B + nTotMeta3U) Picture "@E 999,999.99"						//ESTIMADO(MR)         	 	 	
		@ Prow()    ,129 PSAY (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) Picture "@E 999,999.99"      				//REAL(MR)
				
		If (nTotMeta3A + nTotMeta3B + nTotMeta3U) > (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U)
			@ Prow()    ,141 PSAY ( (nTotMeta3A + nTotMeta3B + nTotMeta3U) - (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) ) Picture "@E 999,999.99"      //DIFERENÇA
			nPerDif3:= ( (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) / (nTotMeta3A + nTotMeta3B + nTotMeta3U) ) * 100
		Else 
			@ Prow()    ,141 PSAY ( (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) - (nTotMeta3A + nTotMeta3B + nTotMeta3U) ) Picture "@E 999,999.99"      //DIFERENÇA
			nPerDif3:= ( (nTotMeta3A + nTotMeta3B + nTotMeta3U) / (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) ) * 100
		Endif
		@ Prow(),154 PSAY nPerDif3 Picture "@E 999.99"	//DIF %
		@ Prow(),163 PSAY (nTotAPEX3 / ( (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) + nTotAPEX3 ) ) * 100 Picture "@E 999.99"	//APARA %
			
		nTTMLEX1A += nTotMLEX1A
	    nTTMLEX2A += nTotMLEX2A 
	    nTTMLEX3A += nTotMLEX3A 
		    
	    nTTMLEX1B += nTotMLEX1B
	    nTTMLEX2B += nTotMLEX2B 
	    nTTMLEX3B += nTotMLEX3B 
		    
	    nTTMLEX1U += nTotMLEX1U
	    nTTMLEX2U += nTotMLEX2U 
	    nTTMLEX3U += nTotMLEX3U 
			      
	    nTTAPEX1 += nTotAPEX1
	    nTTAPEX2 += nTotAPEX2
	    nTTAPEX3 += nTotAPEX3
			     
	    nTTMeta1A += nTotMeta1A 
		nTTMeta2A += nTotMeta2A
		nTTMeta3A += nTotMeta3A		     
				 
		nTTMeta1B += nTotMeta1B 
		nTTMeta2B += nTotMeta2B
		nTTMeta3B += nTotMeta3B		     
			
		nTTMeta1U += nTotMeta1U
		nTTMeta2U += nTotMeta2U
		nTTMeta3U += nTotMeta3U		     
			
		nTotAPEX1 := 0
		nTotAPEX2 := 0 
		nTotAPEX3 := 0
				   
		nTotMLEX1A := 0
		nTotMLEX2A := 0
		nTotMLEX3A := 0
			   
		nTotMLEX1B := 0
		nTotMLEX2B := 0
		nTotMLEX3B := 0
			
		nTotMLEX1U := 0
		nTotMLEX2U := 0
		nTotMLEX3U := 0
				   	   
		nTotMeta1A := 0
		nTotMeta2A := 0
		nTotMeta3A := 0
				 
		nTotMeta1B := 0
		nTotMeta2B := 0
		nTotMeta3B := 0
			
		nTotMeta1U := 0
		nTotMeta2U := 0
		nTotMeta3U := 0
			   
		nPerDif1 := nPerDif2 := nPerDif3 := 0	    

	    //1o. turno
	    @ Prow() + 2,000 PSAY Repl( "-", 220 )
	    @ Prow() +1 ,000 PSAY "TOTAL"
        //@ Prow()    ,005 PSAY nTTOPEX1 Picture "@E 9999"					//OP
	
		@ Prow()    ,007 PSAY (nTTMeta1A + nTTMeta1B + nTTMeta1U) Picture "@E 999,999.99"		//ESTIMADO(MR)        	 	 	
		@ Prow()    ,018 PSAY (nTTMLEX1A + nTTMLEX1B + nTTMLEX1U) Picture "@E 999,999.99"     //REAL(MR)
			
		If (nTTMeta1A + nTTMeta1B + nTTMeta1U) > (nTTMLEX1A + nTTMLEX1B + nTTMLEX1U)
			@ Prow()    ,030 PSAY ( (nTTMeta1A + nTTMeta1B + nTTMeta1U) - (nTTMLEX1A + nTTMLEX1B + nTTMLEX1U) ) Picture "@E 999,999.99"     //DIFERENÇA
			nPerDif1:= ( (nTTMLEX1A + nTTMLEX1B + nTTMLEX1U) / (nTTMeta1A + nTTMeta1B + nTTMeta1U) ) * 100
		Else
			@ Prow()    ,030 PSAY ( (nTTMLEX1A + nTTMLEX1B + nTTMLEX1U) - (nTTMeta1A + nTTMeta1B + nTTMeta1U) ) Picture "@E 999,999.99"     //DIFERENÇA
			nPerDif1:= ( (nTTMeta1A + nTTMeta1B + nTTMeta1U) / (nTTMLEX1A + nTTMLEX1B + nTTMLEX1U) ) * 100
		Endif
		@ Prow(),042 PSAY nPerDif1 Picture "@E 999.99"	//DIF %
		@ Prow(),050 PSAY (nTTAPEX1 / ( (nTTMLEX1A + nTTMLEX1B + nTTMLEX1U) + nTTAPEX1 ) ) * 100 Picture "@E 999.99"	//APARA %
		
        //2o. turno
	
		@ Prow()    ,059 PSAY (nTTMeta2A + nTTMeta2B + nTTMeta2U) Picture "@E 999,999.99"		//ESTIMADO(MR)        	 	 	
		@ Prow()    ,072 PSAY (nTTMLEX2A + nTTMLEX2B + nTTMLEX2U) Picture "@E 999,999.99"     //REAL(MR) 
					
		If (nTTMeta2A + nTTMeta2B + nTTMeta2U) > (nTTMLEX2A + nTTMLEX2B + nTTMLEX2U)
			@ Prow()    ,084 PSAY ( (nTTMeta2A + nTTMeta2B + nTTMeta2U) - (nTTMLEX2A + nTTMLEX2B + nTTMLEX2U) ) Picture "@E 999,999.99"     //DIFERENÇA
			nPerDif2:= ( (nTTMLEX2A + nTTMLEX2B + nTTMLEX2U) / (nTTMeta2A + nTTMeta2B + nTTMeta2U) ) * 100
		Else 
			@ Prow()    ,084 PSAY ( (nTTMLEX2A + nTTMLEX2B + nTTMLEX2U) - (nTTMeta2A + nTTMeta2B + nTTMeta2U) ) Picture "@E 999,999.99"     //DIFERENÇA
			nPerDif2:= ( (nTTMeta2A + nTTMeta2B + nTTMeta2U) / (nTTMLEX2A + nTTMLEX2B + nTTMLEX2U) ) * 100
		Endif
		@ Prow(),098 PSAY nPerDif2 Picture "@E 999.99"	//DIF %
		@ Prow(),107 PSAY (nTTAPEX2 / ( (nTTMLEX2A + nTTMLEX2B + nTTMLEX2U) + nTTAPEX2 ) ) * 100 Picture "@E 999.99"	//APARA %
	        
        //3o. turno
	
		@ Prow()    ,116 PSAY (nTTMeta3A + nTTMeta3B + nTTMeta3U) Picture "@E 999,999.99"		//ESTIMADO(MR)        	 	 	
		@ Prow()    ,129 PSAY (nTTMLEX3A + nTTMLEX3B + nTTMLEX3U) Picture "@E 999,999.99"     //REAL(MR)
				
		If (nTTMeta3A + nTTMeta3B + nTTMeta3U) > (nTTMLEX3A + nTTMLEX3B + nTTMLEX3U)
			@ Prow()    ,141 PSAY ( (nTTMeta3A + nTTMeta3B + nTTMeta3U) - (nTTMLEX3A + nTTMLEX3B + nTTMLEX3U) ) Picture "@E 999,999.99"     //DIFERENÇA
			nPerDif3:= ( (nTTMLEX3A + nTTMLEX3B + nTTMLEX3U) / (nTTMeta3A + nTTMeta3B + nTTMeta3U) ) * 100
		Else 
			@ Prow()    ,141 PSAY ( (nTTMLEX3A + nTTMLEX3B + nTTMLEX3U) - (nTTMeta3A + nTTMeta3B + nTTMeta3U) ) Picture "@E 999,999.99"     //DIFERENÇA
			nPerDif3:= ( (nTTMeta3A + nTTMeta3B + nTTMeta3U) / (nTTMLEX3A + nTTMLEX3B + nTTMLEX3U) ) * 100
		Endif
		@ Prow(),154 PSAY nPerDif3 Picture "@E 999.99"	//DIF %
		@ Prow(),163 PSAY (nTTAPEX3 / ( (nTTMLEX3A + nTTMLEX3B + nTTMLEX3U) + nTTAPEX3 ) ) * 100 Picture "@E 999.99"	//APARA %
		
	
    
EndIf
    //
    
If Len(aResultPI) > 0	

      	//MSGBOX("ARESULT PI") 
      	
       nTotMLEX1A := 0
       nTotMLEX2A := 0
       nTotMLEX3A := 0 
       
       nTotMLEX1B := 0
       nTotMLEX2B := 0
       nTotMLEX3B := 0 
       
       nTotMLEX1U := 0
       nTotMLEX2U := 0
       nTotMLEX3U := 0 
       
       nTotAPEX1 := 0       
       nTotAPEX2 := 0       
       nTotAPEX3 := 0
       
       nTotMeta1A := 0
       nTotMeta2A := 0
       nTotMeta3A := 0
       
       nTotMeta1B := 0
       nTotMeta2B := 0
       nTotMeta3B := 0
       
       nTotMeta1U := 0
       nTotMeta2U := 0
       nTotMeta3U := 0
       
       	nMeta1_A := 0
		nMeta2_A := 0
	    nMeta3_A := 0
	    
	    nMeta1_B := 0
	    nMeta2_B := 0
	    nMeta3_B := 0
	    
	    nMeta1_U := 0
	    nMeta2_U := 0
	    nMeta3_U := 0
	    
	    aMetasA  := {}
	    aMetasB  := {}
	    aMetasU  := {}
        
       	cMaq	 := ""
       	
       	nPerDif1 := nPerDif2 := nPerDif3 := 0
       
	   	Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  // Impressao do cabecalho
	   	@Prow()+1, 000 PSAY Cabec3
		@Prow() + 1,000 PSAY REPLICATE("_",220)
	   
		FOR X := 1 TO Len(aResultPI)
		
		    cMaq   := Alltrim(aResultPI[X,1])
		    
			nLados := 0
			nLados := TrazLados( Alltrim(aResultPI[X,1]) )		 
			
		 	@ Prow() + 2,000 PSAY Left( aResultPI[X,1], 3 )                           			//MAQ
		 	
		 	If nLados > 1
		 		If Alltrim(mv_par05) = "A" .or. Empty(mv_par05)
		 			nMeta1_A := 0
			 		nMeta2_A := 0
			 		nMeta3_A := 0 
			 		fr := 1
			 		nPosiMaq := 0	 		   
		 		   	While fr <= Len(aMetas)
		 		   		If Alltrim(aMetas[fr,1]) = Alltrim(cMaq+"A")
		 		   			nPosiMaq := fr
		 		   			nMeta1_A += aMetas[ nPosiMaq, 3 ]	 
		 		   			nMeta2_A += aMetas[ nPosiMaq, 4 ]
		 		   			nMeta3_A += aMetas[ nPosiMaq, 5 ]	 			
		 		   		Endif
		 		   		fr++
		 		   	Enddo	 		   	
			 		///1o. turno 
			 		@ Prow()    ,004 PSAY "A"
			 		@ Prow()    ,007 PSAY nMeta1_A Picture "@E 999,999.99"					//ESTIMADO(MR) - A
			 		@ Prow()    ,018 PSAY aResultPI[X,5] Picture "@E 999,999.99"					//REAL(MR) - A
			 		 		 	    
			 	    If  nMeta1_A  >  aResultPI[X,5]     //META > PRODUZIDO
				 		@ Prow(),030  PSAY ( nMeta1_A   - aResultPI[X,5] ) Picture "@E 999,999.99" 	//DIFERENÇA 	 	
				 		nPerDif1 := ( aResultPI[X,5] / nMeta1_A ) * 100
				 	Else
				 		@ Prow(),030  PSAY ( aResultPI[X,5]   - nMeta1_A ) Picture "@E 999,999.99" 	//DIFERENÇA 	 	
				 		nPerDif1 := ( nMeta1_A / aResultPI[X,5] ) * 100
				 	Endif
			 	    
			  		@ Prow(),042 PSAY nPerDif1 Picture "@E 999.99"	  //DIF %
			 		@ Prow(),050 PSAY aResultPI[X,2] / ( aResultPI[X,5]   + aResultPI[X,2] ) * 100 Picture "@E 999.99"   	//APARA %	 
		 		
			 		//2o. turno	 			 		
			 		@ Prow(),059 PSAY nMeta2_A Picture "@E 999,999.99"	 		//ESTIMADO(MR) - META A
			 		@ Prow(),072 PSAY aResultPI[X,7] Picture "@E 999,999.99"         //REAL(MR) - PRODUZIDO A
			 	                                                                                                            
			 		 		
			 		If nMeta2_A   >  aResultPI[X,7]			 		
			 			@ Prow(),084  PSAY ( nMeta2_A  -  aResultPI[X,7] ) Picture "@E 999,999.99" 	//DIFERENÇA META - REAL
			 			nPerDif2 := ( aResultPI[X,7]   / nMeta2_A ) * 100	   
			 		
			 		Else			 			
			 			@ Prow(),084 PSAY ( aResultPI[X,7]  - nMeta2_A ) Picture "@E 999,999.99" 	//DIFERENÇA
			 			nPerDif2 := ( nMeta2_A / aResultPI[X,7] ) * 100	   
			 		Endif
			 		
			 		@ Prow()    ,098 PSAY nPerDif2 Picture "@E 999.99"	//DIF%	 		 	
			 		@ Prow()    ,107 PSAY aResultPI[X,3] / ( aResultPI[X,7] + aResultPI[X,3] ) * 100 Picture "@E 999.99"	//APARA %	 	
		 	
		 	 	        
			 		//3o. turno
			 		@ Prow(),116 PSAY nMeta3_A Picture "@E 999,999.99"		//ESTIMADO(MR) - META A
			 		@ Prow(),129 PSAY aResultPI[X,9] Picture "@E 999,999.99"     //REAL(MR) - PRODUZIDO	A	 		
			 	 	
			 		If nMeta3_A  >  aResultPI[X,9]
			 			@ Prow(),141 PSAY ( nMeta3_A  -  aResultPI[X,9] ) Picture "@E 999,999.99" 	//DIFERENÇA (ESTIMADO - REAL)
			 			nPerDif3 := (  aResultPI[X,9]  / nMeta3_A  ) * 100	   	 	
			 		Else
			 			@ Prow(),141 PSAY ( aResultPI[X,9] - nMeta3_A ) Picture "@E 999,999.99" 	//DIFERENÇA 
			 			nPerDif3 := ( nMeta3_A /  aResultPI[X,9] ) * 100
			 		Endif
				 	
			 		@ Prow(),154 PSAY nPerDif3 Picture "@E 999.99"            //DIF %	 	
			 		@ Prow(),163 PSAY aResultPI[X,4] / ( aResultPI[X,9] + aResultPI[X,4] ) * 100 Picture "@E 999.99"	//APARA % 		 	
			 		
			 		nTotMLEX1A := nTotMLEX1A + aResultPI[X,5]
					nTotMLEX2A := nTotMLEX2A + aResultPI[X,7]
					nTotMLEX3A := nTotMLEX3A + aResultPI[X,9] 
										
					nTotMeta1A := nTotMeta1A + nMeta1_A			
					nTotMeta2A := nTotMeta2A + nMeta2_A			
					nTotMeta3A := nTotMeta3A + nMeta3_A
								
		 		Endif
		 		
		 		//NA PRÓX. LINHA IMPRIME AS INFORMAÇÕES DO OUTRO LADO DA MÁQUINA
		 		If Alltrim(mv_par05) = "B" .or. Empty(mv_par05)
		 		   	nMeta1_B := 0
			 		nMeta2_B := 0
			 		nMeta3_B := 0 
			 		fr := 1
			 		nPosiMaq := 0	 		   
		 		   	While fr <= Len(aMetas)
		 		   		If Alltrim(aMetas[fr,1]) = Alltrim(cMaq+"B")
		 		   			nPosiMaq := fr
		 		   			nMeta1_B += aMetas[ nPosiMaq, 3 ]	 
		 		   			nMeta2_B += aMetas[ nPosiMaq, 4 ]
		 		   			nMeta3_B += aMetas[ nPosiMaq, 5 ]	 			
		 		   			//Exit
		 		   			 			
		 		   		Endif
		 		   		fr++
		 		   	Enddo	 		   	
			 		//1o. turno
			 		@ Prow()+1  ,004 PSAY "B"
			 		@ Prow()    ,007 PSAY nMeta1_B Picture "@E 999,999.99"					//ESTIMADO(MR) - B
			 		@ Prow()    ,018 PSAY aResultPI[X,6] Picture "@E 999,999.99"					//REAL(MR) - B
			 		 		 	    
			 	    If nMeta1_B >  aResultPI[X,6]     //META > PRODUZIDO
				 		@ Prow(),030  PSAY ( nMeta1_B  - aResultPI[X,6] ) Picture "@E 999,999.99" 	//DIFERENÇA 	 	
				 		nPerDif1 := ( aResultPI[X,6] / nMeta1_B) * 100
				 	Else
				 		@ Prow(),030  PSAY ( aResultPI[X,6]   - nMeta1_B) Picture "@E 999,999.99" 	//DIFERENÇA 	 	
				 		nPerDif1 := ( nMeta1_B / aResultPI[X,6] ) * 100
				 	Endif
			 	    
			  		@ Prow(),042 PSAY nPerDif1 Picture "@E 999.99"	  //DIF %
			 		@ Prow(),050 PSAY aResultPI[X,2] / ( aResultPI[X,6]   + aResultPI[X,2] ) * 100 Picture "@E 999.99"   	//APARA %	 
		 		
			 		//2o. turno
			 		@ Prow(),059 PSAY nMeta2_B Picture "@E 999,999.99"	 		//ESTIMADO(MR) - META B
			 		@ Prow(),072 PSAY aResultPI[X,8] Picture "@E 999,999.99"         //REAL(MR) - PRODUZIDO B	 	                                                                                                            
			 		 		
			 		If nMeta2_B   >  aResultPI[X,8] 			 		
			 			@ Prow(),084  PSAY ( nMeta2_B  -  aResultPI[X,8] ) Picture "@E 999,999.99" 	//DIFERENÇA META - REAL
			 			nPerDif2 := ( aResultPI[X,8]   / nMeta2_B ) * 100	   
			 		
			 		Else			 			
			 			@ Prow(),084 PSAY ( aResultPI[X,8]  - nMeta2_B ) Picture "@E 999,999.99" 	//DIFERENÇA
			 			nPerDif2 := ( nMeta2_B / aResultPI[X,8] ) * 100	   
			 		Endif
			 		
			 		@ Prow()    ,098 PSAY nPerDif2 Picture "@E 999.99"	//DIF%	 		 	
			 		@ Prow()    ,107 PSAY aResultPI[X,3] / ( aResultPI[X,8] + aResultPI[X,3] ) * 100 Picture "@E 999.99"	//APARA %	 	
		 	
		 	 	        
			 		//3o. turno					 	
			 		@ Prow(),116 PSAY nMeta3_B Picture "@E 999,999.99"		//ESTIMADO(MR) - META B
			 		@ Prow(),129 PSAY aResultPI[X,10] Picture "@E 999,999.99"     //REAL(MR) - PRODUZIDO	A	 		
			 	 	
			 		If (nMeta3_B  >  aResultPI[X,10] )
			 			@ Prow(),141 PSAY ( nMeta3_B  -  aResultPI[X,10] ) Picture "@E 999,999.99" 	//DIFERENÇA (ESTIMADO - REAL)
			 			nPerDif3 := (  aResultPI[X,10]  / nMeta3_B  ) * 100	   	 	
			 		Else
			 			@ Prow(),141 PSAY ( aResultPI[X,10] - nMeta3_B ) Picture "@E 999,999.99" 	//DIFERENÇA
			 			nPerDif3 := ( nMeta3_B /  aResultPI[X,10] ) * 100
			 		Endif
				 	
			 		@ Prow(),154 PSAY nPerDif3 Picture "@E 999.99"            //DIF %	 	
			 		@ Prow(),163 PSAY aResultPI[X,4] / ( aResultPI[X,10] + aResultPI[X,4] ) * 100 Picture "@E 999.99"	//APARA % 		 			
			 		
			 		nTotMLEX1B := nTotMLEX1B + aResultPI[X,6]
					nTotMLEX2B := nTotMLEX2B + aResultPI[X,8]
					nTotMLEX3B := nTotMLEX3B + aResultPI[X,10]
					
					nTotMeta1B := nTotMeta1B + nMeta1_B 
					nTotMeta2B := nTotMeta2B + nMeta2_B			
					nTotMeta3B := nTotMeta3B + nMeta3_B
					
				Endif
	       
	        Else		//se a máquina não possuir mais de um lado, imprime da forma abaixo:
            		
	            //TURNO 1
	            nMeta1_U := 0
			 	nMeta2_U := 0
			 	nMeta3_U := 0 
			 	fr := 1
			 	nPosiMaq := 0	 		   
		 		While fr <= Len(aMetas)
		 			If Alltrim(aMetas[fr,1]) = Alltrim(cMaq+"")
		 				nPosiMaq := fr
		 				nMeta1_U += aMetas[ nPosiMaq, 3 ]	 
		 				nMeta2_U += aMetas[ nPosiMaq, 4 ]
		 				nMeta3_U += aMetas[ nPosiMaq, 5 ]	 			
		 			Endif
		 			fr++
		 		Enddo	 		
		 		   	
			   	@ Prow() + 2,000 PSAY Left( aResultPI[X,1], 3 )         				//MAQ
			 	//@ Prow()    ,005 PSAY aResultPI[X,2] Picture "@E 9999"    	        	//OP
			 	
			 	@ Prow(),007 PSAY nMeta1_U  Picture "@E 999,999.99"  	    //ESTIMADO(MR)		 		 			 	 	
			 	@ Prow(),018 PSAY aResultPI[X,11] Picture "@E 9,999,999.99"    	//REAL(MR)		 
			 		 		 		
			 	If  nMeta1_U > aResultPI[X,11]
			 		@ Prow(),030 PSAY ( nMeta1_U - aResultPI[X,11] ) Picture "@E 999,999.99"      //DIFERENÇA
			 		nPerDif1:= ( aResultPI[X,11] / nMeta1_U ) * 100
			 	Else 
			 		@ Prow(),030 PSAY ( aResultPI[X,11] - nMeta1_U ) Picture "@E 999,999.99"      //DIFERENÇA
			 		nPerDif1:= ( nMeta1_U / aResultPI[X,11] ) * 100
			 	Endif
			 	@ Prow(),042 PSAY nPerDif1 Picture "@E 999.99" 	//DIF %		 			 	
			 	@ Prow(),050 PSAY ( aResultPI[X,2] / ( aResultPI[X,11] + aResultPI[X,2] )) * 100 Picture "@E 999.99" 	//APARA %		 	
			 	
			 	
	            //TURNO 2 	           
			 	@ Prow(),059 PSAY nMeta2_U Picture "@E 999,999.99"  	    //ESTIMADO(MR)		 		 		
			 	@ Prow(),072 PSAY aResultPI[X,12] Picture "@E 999,999.99" 		//REAL(MR)		 
			 		 		 		
			 	If  nMeta2_U > aResultPI[X,12]
			 		@ Prow(),084 PSAY ( nMeta2_U - aResultPI[X,12] ) Picture "@E 999,999.99"      //DIFERENÇA
			 		nPerDif2:= ( aResultPI[X,12] / nMeta2_U ) * 100
			 	Else 
			 		@ Prow(),084 PSAY ( aResultPI[X,12] - nMeta2_U ) Picture "@E 999,999.99"      //DIFERENÇA
			 		nPerDif2:= ( nMeta2_U / aResultPI[X,12] ) * 100
			 	Endif
			 	@ Prow(),098 PSAY nPerDif2 Picture "@E 999.99" 	//DIF %		 			 	
			 	@ Prow(),107 PSAY aResultPI[X,3] / ( aResultPI[X,12] + aResultPI[X,3] ) * 100 Picture "@E 999.99" 	//APARA %		 	
			 	
	            
				//TURNO 3			
			 	@ Prow(),116 PSAY nMeta3_U Picture "@E 999,999.99"  	    //ESTIMADO(MR)		 	 	
			 	@ Prow(),129 PSAY aResultPI[X,13] Picture "@E 999,999.99"     	//REAL(MR)		 			 
			 		 		
			 	If nMeta3_U > aResultPI[X,13]
			 		@ Prow(),141 PSAY ( nMeta3_U - aResultPI[X,13] ) Picture "@E 999,999.99"      //DIFERENÇA
			 		nPerDif3:= ( aResultPI[X,13] / nMeta3_U ) * 100
			 	Else 
			 		@ Prow(),141 PSAY ( aResultPI[X,13] - nMeta3_U ) Picture "@E 999,999.99"      //DIFERENÇA
			 		nPerDif3:= ( nMeta3_U / aResultPI[X,13] ) * 100
			    Endif
			    @ Prow(),154 PSAY nPerDif3 Picture "@E 999.99" 	//DIF %		 			 	
			 	@ Prow(),163 PSAY aResultPI[X,4] / ( aResultPI[X,13] + aResultPI[X,4] ) * 100 Picture "@E 999.99" 	//APARA %		 	
			 				 			
				nTotMLEX1U := nTotMLEX1U + aResultPI[X,11]
				nTotMLEX2U := nTotMLEX2U + aResultPI[X,12]
				nTotMLEX3U := nTotMLEX3U + aResultPI[X,13]
				
				nTotMeta1U := nTotMeta1U + nMeta1_U //aResultPI[X,25]			
				nTotMeta2U := nTotMeta2U + nMeta2_U //aResultPI[X,26]			
				nTotMeta3U := nTotMeta3U + nMeta3_U //aResultPI[X,27]
		 		 	
			Endif
		
			
			nTotAPEX1 := nTotAPEX1 + aResultPI[X,2]
			nTotAPEX2 := nTotAPEX2 + aResultPI[X,3]
			nTotAPEX3 := nTotAPEX3 + aResultPI[X,4]
			
			
		NEXT

		@ Prow() + 2,000 PSAY Repl( "-", 220 )
        
        
        //TOTAIS 
        //1o. turno
		//@ Prow() + 1,005 PSAY nTotOPEX1 Picture "@E 9999"							//OP
		
		@ Prow(),007 PSAY (nTotMeta1A + nTotMeta1B + nTotMeta1U) Picture "@E 999,999.99"					//ESTIMADO(MR)
		@ Prow(),018 PSAY (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) Picture "@E 999,999.99"					//REAL(MR)
				
		If (nTotMeta1A + nTotMeta1B + nTotMeta1U) > (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U)
			@ Prow(),030 PSAY ( (nTotMeta1A + nTotMeta1B + nTotMeta1U) - (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) ) Picture "@E 999,999.99"  //DIFERENÇA
			nPerDif1:= ( (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) / (nTotMeta1A + nTotMeta1B + nTotMeta1U) ) * 100
		Else
			@ Prow(),030 PSAY ( (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) - (nTotMeta1A + nTotMeta1B + nTotMeta1U)) Picture "@E 999,999.99"  //DIFERENÇA
			nPerDif1:= ( (nTotMeta1A + nTotMeta1B + nTotMeta1U) / (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) ) * 100
		Endif
		@ Prow(),042 PSAY nPerDif1 Picture "@E 999.99" 	//DIF %		 			 	
		@ Prow(),050 PSAY (nTotAPEX1 / ( (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) + nTotAPEX1 ) ) * 100 Picture "@E 999.99"	//APARA %		
        
        
		//2o. turno

			@ Prow()    ,059 PSAY (nTotMeta2A + nTotMeta2B + nTotMeta2U) Picture "@E 999,999.99"					//ESTIMADO(MR)
			@ Prow()    ,072 PSAY (nTotMLEX2A + nTotMLEX2B + nTotMLEX2U) Picture "@E 999,999.99"					//REAL(MR)
			
			If (nTotMeta2A + nTotMeta2B  + nTotMeta2U) > (nTotMLEX2A + nTotMLEX2B  + nTotMLEX2U)
				@ Prow(),084 PSAY ( (nTotMeta2A + nTotMeta2B  + nTotMeta2U) - (nTotMLEX2A + nTotMLEX2B  + nTotMLEX2U) ) Picture "@E 999,999.99"  //DIFERENÇA
				nPerDif2:= ( (nTotMLEX2A + nTotMLEX2B  + nTotMLEX2U) / (nTotMeta2A + nTotMeta2B  + nTotMeta2U) ) * 100
			Else 
				@ Prow(),084 PSAY ( (nTotMLEX2A + nTotMLEX2B  + nTotMLEX2U) - (nTotMeta2A + nTotMeta2B  + nTotMeta2U) ) Picture "@E 999,999.99"  //DIFERENÇA
				nPerDif2:= ( (nTotMeta2A + nTotMeta2B  + nTotMeta2U) / (nTotMLEX2A + nTotMLEX2B  + nTotMLEX2U)) * 100
			Endif
			@ Prow(),098 PSAY nPerDif2 Picture "@E 999.99" 	//DIF %		 			 	
			@ Prow(),107 PSAY (nTotAPEX2 / ( (nTotMLEX2A + nTotMLEX2B  + nTotMLEX2U)+ nTotAPEX2 ) ) * 100 Picture "@E 999.99"	//APARA %		
        
        		
		//3o. turno
	
			@ Prow(),116 PSAY (nTotMeta3A + nTotMeta3B + nTotMeta3U) Picture "@E 999,999.99"					//ESTIMADO(MR)
			@ Prow(),129 PSAY (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) Picture "@E 999,999.99"					//REAL(MR)
			
			If (nTotMeta3A + nTotMeta3B + nTotMeta3U) > (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U)
				@ Prow(),141 PSAY ( (nTotMeta3A + nTotMeta3B + nTotMeta3U) - (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) ) Picture "@E 999,999.99"  //DIFERENÇA
				nPerDif3:= ( (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) / (nTotMeta3A + nTotMeta3B + nTotMeta3U) ) * 100
			Else 
				@ Prow(),141 PSAY ( (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) - (nTotMeta3A + nTotMeta3B + nTotMeta3U) ) Picture "@E 999,999.99"  //DIFERENÇA
				nPerDif3:= ( (nTotMeta3A + nTotMeta3B + nTotMeta3U) / (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) ) * 100
			Endif
			@ Prow(),154 PSAY nPerDif3 Picture "@E 999.99" 	//DIF %		 			 	
			@ Prow(),163 PSAY (nTotAPEX3 / ( (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) + nTotAPEX3 ) ) * 100 Picture "@E 999.99"	//APARA %		
			
			nTTMLEX1A += nTotMLEX1A
		    nTTMLEX2A += nTotMLEX2A 
		    nTTMLEX3A += nTotMLEX3A 
		    
		    nTTMLEX1B += nTotMLEX1B
		    nTTMLEX2B += nTotMLEX2B 
		    nTTMLEX3B += nTotMLEX3B
		    
		    nTTMLEX1U += nTotMLEX1U
		    nTTMLEX2U += nTotMLEX2U 
		    nTTMLEX3U += nTotMLEX3U
		      
		    nTTAPEX1 += nTotAPEX1
		    nTTAPEX2 += nTotAPEX2
		    nTTAPEX3 += nTotAPEX3
		     
		    nTTMeta1A += nTotMeta1A 
			nTTMeta2A += nTotMeta2A
			nTTMeta3A += nTotMeta3A		     
			 
			nTTMeta1B += nTotMeta1B 
			nTTMeta2B += nTotMeta2B
			nTTMeta3B += nTotMeta3B
			
			nTTMeta1U += nTotMeta1U
			nTTMeta2U += nTotMeta2U
			nTTMeta3U += nTotMeta3U		     		     
			
			nTotMLEX1A := 0
	       	nTotMLEX2A := 0
	       	nTotMLEX3A := 0 
	       
	       	nTotMLEX1B := 0
	       	nTotMLEX2B := 0
	       	nTotMLEX3B := 0 
	       	
	       	nTotMLEX1U := 0
	       	nTotMLEX2U := 0
	       	nTotMLEX3U := 0 
	       
	       	nTotAPEX1 := 0       
	       	nTotAPEX2 := 0       
	       	nTotAPEX3 := 0
	       
	       	nTotMeta1A := 0
	       	nTotMeta2A := 0
	       	nTotMeta3A := 0
	       
	       	nTotMeta1B := 0
	       	nTotMeta2B := 0
	       	nTotMeta3B := 0
	       	
	       	nTotMeta1U := 0
	       	nTotMeta2U := 0
	       	nTotMeta3U := 0
	       
	       	nPerDif1 := nPerDif2 := nPerDif3 := 0
        
             
EndIf
	

If Len(aResult2) > 0

		//MSGBOX("ARESULT 2")

	nTotMLEX1A := 0
	nTotMLEX2A := 0
	nTotMLEX3A := 0
	
	nTotMLEX1B := 0
	nTotMLEX2B := 0
	nTotMLEX3B := 0
	
	nTotMLEX1U := 0
	nTotMLEX2U := 0
	nTotMLEX3U := 0
	
	nTotAPEX1 := 0
	nTotAPEX2 := 0
	nTotAPEX3 := 0 
	
	nTotMeta1A := 0
   	nTotMeta2A := 0
   	nTotMeta3A := 0
	       
   	nTotMeta1B := 0
   	nTotMeta2B := 0
   	nTotMeta3B := 0
   	
   	nTotMeta1U := 0
   	nTotMeta2U := 0
   	nTotMeta3U := 0
   	
   	nMeta1_A := 0
	nMeta2_A := 0
    nMeta3_A := 0
	    
    nMeta1_B := 0
    nMeta2_B := 0
    nMeta3_B := 0
	    
    nMeta1_U := 0
    nMeta2_U := 0
    nMeta3_U := 0
	    
    aMetasA  := {}
    aMetasB  := {}
    aMetasU  := {}  
	cMaq	 := ""
	nPerDif1 := nPerDif2 := nPerDif3 := 0
	
	Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  // Impressao do cabecalho
	@Prow()+1, 000 PSAY Cabec3
	@Prow() + 1,000 PSAY REPLICATE("_",220)
		
	FOR X := 1 TO Len(aResult2)         
	
	    cMaq   := Alltrim(aResult2[X,1])
		nLados := 0
		nLados := TrazLados( Alltrim(aResult2[X,1]) )	 
			
	 	@ Prow() + 2,000 PSAY Left( aResult2[X,1], 3 )                           			//MAQ
		 	
		 	If nLados > 1
		 		If Alltrim(mv_par05) = "A" .or. Empty(mv_par05)
		 		    nMeta1_A := 0
			 		nMeta2_A := 0
			 		nMeta3_A := 0 
			 		fr := 1
			 		nPosiMaq := 0	 		   
		 		   	While fr <= Len(aMetas)
		 		   		If Alltrim(aMetas[fr,1]) = Alltrim(cMaq+"A")
		 		   			nPosiMaq := fr
		 		   			nMeta1_A += aMetas[ nPosiMaq, 3 ]	 
		 		   			nMeta2_A += aMetas[ nPosiMaq, 4 ]
		 		   			nMeta3_A += aMetas[ nPosiMaq, 5 ]	 			
		 		   		Endif
		 		   		fr++
		 		   	Enddo
		 		   		 		   	
			 		///1o. turno 
			 		@ Prow()    ,004 PSAY "A"
			 		@ Prow()    ,007 PSAY nMeta1_A Picture "@E 999,999.99"					//ESTIMADO(MR) - A
			 		@ Prow()    ,018 PSAY aResult2[X,5] Picture "@E 999,999.99"					//REAL(MR) - A
			 		 		 	    
			 	    If nMeta1_A  >  aResult2[X,5]     //META > PRODUZIDO
				 		@ Prow(),030  PSAY ( nMeta1_A  - aResult2[X,5] ) Picture "@E 999,999.99" 	//DIFERENÇA 	 	
				 		nPerDif1 := ( aResult2[X,5] / nMeta1_A) * 100
				 	Else
				 		@ Prow(),030  PSAY ( aResult2[X,5]   - nMeta1_A) Picture "@E 999,999.99" 	//DIFERENÇA 	 	
				 		nPerDif1 := ( nMeta1_A / aResult2[X,5] ) * 100
				 	Endif
			 	    
			  		@ Prow(),042 PSAY nPerDif1 Picture "@E 999.99"	  //DIF %
			 		@ Prow(),050 PSAY aResult2[X,2] / ( aResult2[X,5]   + aResult2[X,2] ) * 100 Picture "@E 999.99"   	//APARA %	 
		 		
			 		//2o. turno
			 		@ Prow(),059 PSAY nMeta2_A Picture "@E 999,999.99"	 		//ESTIMADO(MR) - META A
			 		@ Prow(),072 PSAY aResult2[X,7] Picture "@E 999,999.99"         //REAL(MR) - PRODUZIDO A
			 		 		
			 		If nMeta2_A  >  aResult2[X,7]			 		
			 			@ Prow(),084  PSAY ( nMeta2_A - aResult2[X,7] ) Picture "@E 999,999.99" 	//DIFERENÇA META - REAL
			 			nPerDif2 := ( aResult2[X,7]   / nMeta2_A ) * 100	   
			 		
			 		Else			 			
			 			@ Prow(),084 PSAY ( aResult2[X,7]  - nMeta2_A ) Picture "@E 999,999.99" 	//DIFERENÇA
			 			nPerDif2 := ( nMeta2_A / aResult2[X,7] ) * 100	   
			 		Endif
			 		
			 		@ Prow()    ,098 PSAY nPerDif2 Picture "@E 999.99"	//DIF%	 		 	
			 		@ Prow()    ,107 PSAY aResult2[X,3] / ( aResult2[X,7] + aResult2[X,3] ) * 100 Picture "@E 999.99"	//APARA %	 		
		 	 	        
			 		//3o. turno			 	
			 		@ Prow(),116 PSAY nMeta3_A Picture "@E 999,999.99"		//ESTIMADO(MR) - META A
			 		@ Prow(),129 PSAY aResult2[X,9] Picture "@E 999,999.99"     //REAL(MR) - PRODUZIDO	A	 		
			 	 	
			 		If (nMeta3_A  >  aResult2[X,9] )
			 			@ Prow(),141 PSAY ( nMeta3_A  -  aResult2[X,9] ) Picture "@E 999,999.99" 	//DIFERENÇA (ESTIMADO - REAL)
			 			nPerDif3 := (  aResult2[X,9]  / nMeta3_A  ) * 100	   	 	
			 		Else
			 			@ Prow(),141 PSAY ( aResult2[X,9] - nMeta3_A ) Picture "@E 999,999.99" 	//DIFERENÇA
			 			nPerDif3 := ( nMeta3_A /  aResult2[X,9] ) * 100
			 		Endif
				 	
			 		@ Prow(),154 PSAY nPerDif3 Picture "@E 999.99"            //DIF %	 	
			 		@ Prow(),163 PSAY aResult2[X,4] / ( aResult2[X,9] + aResult2[X,4] ) * 100 Picture "@E 999.99"	//APARA % 		 	
			 		
			 		nTotMLEX1A := nTotMLEX1A + aResult2[X,5]
					nTotMLEX2A := nTotMLEX2A + aResult2[X,7]
					nTotMLEX3A := nTotMLEX3A + aResult2[X,9]														
				
					nTotMeta1A := nTotMeta1A + nMeta1_A //aResult2[X,19]		
					nTotMeta2A := nTotMeta2A + nMeta2_A //aResult2[X,7]	
					nTotMeta3A := nTotMeta3A + nMeta3_A					
				
		
		 		Endif
		 		
		 		//NA PRÓX. LINHA IMPRIME AS INFORMAÇÕES DO OUTRO LADO DA MÁQUINA
		 		If Alltrim(mv_par05) = "B" .or. Empty(mv_par05)
		 			nMeta1_B := 0
			 		nMeta2_B := 0
			 		nMeta3_B := 0 
			 		fr := 1
			 		nPosiMaq := 0	 		   
		 		   	While fr <= Len(aMetas)
		 		   		If Alltrim(aMetas[fr,1]) = Alltrim(cMaq+"B")
		 		   			nPosiMaq := fr
		 		   			nMeta1_B += aMetas[ nPosiMaq, 3 ]	 
		 		   			nMeta2_B += aMetas[ nPosiMaq, 4 ]
		 		   			nMeta3_B += aMetas[ nPosiMaq, 5 ]	 			
		 		   			//Exit
		 		   			 			
		 		   		Endif
		 		   		fr++
		 		   	Enddo	 		   	
			 		//1o. turno
			 		@ Prow()+1  ,004 PSAY "B"
			 		@ Prow()    ,007 PSAY nMeta1_B Picture "@E 999,999.99"					//ESTIMADO(MR) - B
			 		@ Prow()    ,018 PSAY aResult2[X,6] Picture "@E 999,999.99"					//REAL(MR) - B
			 		 		 	    
			 	    If nMeta1_B  >  aResult2[X,6]     //META > PRODUZIDO
				 		@ Prow(),030  PSAY ( nMeta1_B - aResult2[X,6] ) Picture "@E 999,999.99" 	//DIFERENÇA 	 	
				 		nPerDif1 := ( aResult2[X,6] / nMeta1_B ) * 100
				 	Else
				 		@ Prow(),030  PSAY ( aResult2[X,6] - nMeta1_B ) Picture "@E 999,999.99" 	//DIFERENÇA 	 	
				 		nPerDif1 := ( nMeta1_B / aResult2[X,6] ) * 100
				 	Endif
			 	    
			  		@ Prow(),042 PSAY nPerDif1 Picture "@E 999.99"	  //DIF %
			 		@ Prow(),050 PSAY aResult2[X,2] / ( aResult2[X,6]   + aResult2[X,2] ) * 100 Picture "@E 999.99"   	//APARA %	 
		 		
			 		//2o. turno			 		 		
			 		@ Prow(),059 PSAY nMeta2_B Picture "@E 999,999.99"	 		//ESTIMADO(MR) - META B
			 		@ Prow(),072 PSAY aResult2[X,8] Picture "@E 999,999.99"         //REAL(MR) - PRODUZIDO B	 	                                                                                                            
			 		 		
			 		If nMeta2_B   >  aResult2[X,8]			 		
			 			@ Prow(),084  PSAY ( nMeta2_B  -  aResult2[X,8] ) Picture "@E 999,999.99" 	//DIFERENÇA META - REAL
			 			nPerDif2 := ( aResult2[X,8]  / nMeta2_B ) * 100	   
			 		
			 		Else			 			
			 			@ Prow(),084 PSAY ( aResult2[X,8] - nMeta2_B ) Picture "@E 999,999.99" 	//DIFERENÇA
			 			nPerDif2 := ( nMeta2_B / aResult2[X,8] ) * 100	   
			 		Endif
			 		
			 		@ Prow()    ,098 PSAY nPerDif2 Picture "@E 999.99"	//DIF%	 		 	
			 		@ Prow()    ,107 PSAY aResult2[X,3] / ( aResult2[X,8] + aResult2[X,3] ) * 100 Picture "@E 999.99"	//APARA %	 	
		 	
		 	 	        
			 		//3o. turno
			 		@ Prow(),116 PSAY nMeta3_B Picture "@E 999,999.99"		//ESTIMADO(MR) - META B
			 		@ Prow(),129 PSAY aResult2[X,10] Picture "@E 999,999.99"     //REAL(MR) - PRODUZIDO	A	 		
			 	 	
			 		If nMeta3_B  >  aResult2[X,10]
			 			@ Prow(),141 PSAY ( nMeta3_B  -  aResult2[X,10] ) Picture "@E 999,999.99" 	//DIFERENÇA (ESTIMADO - REAL)
			 			nPerDif3 := (  aResult2[X,10]  / nMeta3_B  ) * 100	   	 	
			 		Else
			 			@ Prow(),141 PSAY ( aResult2[X,10] - nMeta3_B ) Picture "@E 999,999.99" 	//DIFERENÇA
			 			nPerDif3 := ( nMeta3_B /  aResult2[X,10] ) * 100
			 		Endif
				 	
			 		@ Prow(),154 PSAY nPerDif3 Picture "@E 999.99"            //DIF %	 	
			 		@ Prow(),163 PSAY aResult2[X,4] / ( aResult2[X,10] + aResult2[X,4] ) * 100 Picture "@E 999.99"	//APARA % 		 			
			 		
			 		nTotMLEX1B := nTotMLEX1B + aResult2[X,6]
					nTotMLEX2B := nTotMLEX2B + aResult2[X,8]
					nTotMLEX3B := nTotMLEX3B + aResult2[X,10]						
					
					nTotMeta1B := nTotMeta1B + nMeta1_B		
					nTotMeta2B := nTotMeta2B + nMeta2_B	
					nTotMeta3B := nTotMeta3B + nMeta3_B
		
	            Endif
	            
	        Else		//se a máquina não possuir mais de um lado, imprime da forma abaixo: 
	
	
	    		//1o. turno
	    		nMeta1_U := 0
			 	nMeta2_U := 0
			 	nMeta3_U := 0 
			 	fr := 1
			 	nPosiMaq := 0	 		   
		 		While fr <= Len(aMetas)
		 			If Alltrim(aMetas[fr,1]) = Alltrim(cMaq+"")
		 				nPosiMaq := fr
		 				nMeta1_U += aMetas[ nPosiMaq, 3 ]	 
		 				nMeta2_U += aMetas[ nPosiMaq, 4 ]
		 				nMeta3_U += aMetas[ nPosiMaq, 5 ]	 			
		 			Endif
		 			fr++
		 		Enddo	 		   	
	    		@ Prow() + 2,000 PSAY Left( aResult2[X,1], 3 )                           			//MAQ
	 	 	 			 		
		 		@ Prow()    ,007 PSAY nMeta1_U  Picture "@E 999,999.99"					//ESTIMADO(MR) - META A	+ B + U	 	
		 		@ Prow()    ,018 PSAY aResult2[X,11] Picture "@E 999,999.99"					//REAL(MR) - A+B+U	 	
		 		 	    
		 	    If nMeta1_U > aResult2[X,11]     //META > PRODUZIDO
			 		@ Prow(),030  PSAY ( nMeta1_U - aResult2[X,11] ) Picture "@E 999,999.99" 	//DIFERENÇA 	 	
			 		nPerDif1 := ( aResult2[X,11] / nMeta1_U ) * 100
			 	Else
			 		@ Prow(),030  PSAY ( aResult2[X,11] - nMeta1_U ) Picture "@E 999,999.99" 	//DIFERENÇA 	 	
			 		nPerDif1 := ( nMeta1_U / aResult2[X,11] ) * 100
			 	Endif
		 	    
		  		@ Prow(),042 PSAY nPerDif1 Picture "@E 999.99"	  //DIF %
		 		@ Prow(),050 PSAY aResult2[X,2] / ( aResult2[X,11] + aResult2[X,2] ) * 100 Picture "@E 999.99"   	//APARA %	 
		 	
		   	 
		 		//2o. turno	 		 	
		 		@ Prow(),059 PSAY nMeta2_U Picture "@E 999,999.99"	 		//ESTIMADO(MR) - META	 	 	
		 		@ Prow(),072 PSAY aResult2[X,12] Picture "@E 999,999.99"               //REAL(MR) - PRODUZIDO	 		
		 				 		
		 		If nMeta2_U > aResult2[X,12]		 		
		 			@ Prow(),084  PSAY ( nMeta2_U  - aResult2[X,12] ) Picture "@E 999,999.99" 	//DIFERENÇA 
		 			nPerDif2 := ( aResult2[X,12] / nMeta2_U ) * 100	   
		 		
		 		Else		 			
		 			@ Prow(),084 PSAY ( aResult2[X,12] - nMeta2_U ) Picture "@E 999,999.99" 	//DIFERENÇA 	   
		 			nPerDif2 := ( nMeta2_U / aResult2[X,12] ) * 100	   
		 		Endif
		 		
		 		@ Prow()    ,098 PSAY nPerDif2 Picture "@E 999.99"	//DIF%	 		 	
		 		@ Prow()    ,107 PSAY aResult2[X,3] / ( aResult2[X,12] + aResult2[X,3] ) * 100 Picture "@E 999.99"	//APARA %	 	
		 			 	 	        
		 		//3o. turno	 		      
		 		@ Prow(),116 PSAY nMeta3_U Picture "@E 999,999.99"		//ESTIMADO(MR) - META	 		 	
		 		@ Prow(),129 PSAY aResult2[X,13] Picture "@E 999,999.99"            //REAL(MR) - PRODUZIDO	 	
		 			 	
		 		If nMeta3_U > aResult2[X,13]
		 			@ Prow(),141 PSAY ( nMeta3_U - aResult2[X,13] ) Picture "@E 999,999.99" 	//DIFERENÇA (ESTIMADO - REAL)
		 			nPerDif3 := ( aResult2[X,13] / nMeta3_U ) * 100	   	 	
		 		Else
		 			@ Prow(),141 PSAY ( aResult2[X,13] - nMeta3_U ) Picture "@E 999,999.99" 	//DIFERENÇA	 	
		 			nPerDif3 := ( nMeta3_U / aResult2[X,13] ) * 100
		 		Endif
			 	
		 		@ Prow(),154 PSAY nPerDif3 Picture "@E 999.99"            //DIF %	 	
		 		@ Prow(),163 PSAY aResult2[X,4] / ( aResult2[X,13] + aResult2[X,4] ) * 100 Picture "@E 999.99"	//APARA % 		 	
		 		
		 				
				nTotMLEX1U := nTotMLEX1U + aResult2[X,11]
				nTotMLEX2U := nTotMLEX2U + aResult2[X,12]
				nTotMLEX3U := nTotMLEX3U + aResult2[X,13]		
				
				nTotMeta1U := nTotMeta1U + nMeta1_U //aResult2[X,25]		
				nTotMeta2U := nTotMeta2U + nMeta2_U //aResult2[X,26]	
				nTotMeta3U := nTotMeta3U + nMeta3_U //aResult2[X,27]
				        
            Endif
       		
			nTotAPEX1 := nTotAPEX1 + aResult2[X,2]
			nTotAPEX2 := nTotAPEX2 + aResult2[X,3]
			nTotAPEX3 := nTotAPEX3 + aResult2[X,4]
		
	
	NEXT
	
		//1o. turno
		//@ Prow() + 1,005 PSAY nTotOPEX1 Picture "@E 9999"							//OP
		
		@ Prow(),007 PSAY (nTotMeta1A + nTotMeta1B + nTotMeta1U) Picture "@E 999,999.99"					//ESTIMADO(MR)
		@ Prow(),018 PSAY (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) Picture "@E 999,999.99"					//REAL(MR)
		
		//@ Prow(),005 PSAY nTotMeta1A Picture "@E 999,999.99"					//ESTIMADO(MR) A
		//@ Prow(),017 PSAY nTotMeta1B Picture "@E 999,999.99"					//ESTIMADO(MR) B
		//@ Prow(),029 PSAY nTotMLEX1A Picture "@E 999,999.99"					//REAL(MR)     A
		//@ Prow(),041 PSAY nTotMLEX1B Picture "@E 999,999.99"					//REAL(MR)     B
			
		If (nTotMeta1A + nTotMeta1B + nTotMeta1U) > (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U)
			@ Prow(),030 PSAY ( (nTotMeta1A + nTotMeta1B + nTotMeta1U) - (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) ) Picture "@E 999,999.99"  //DIFERENÇA
			nPerDif1:= ( (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) / (nTotMeta1A + nTotMeta1B + nTotMeta1U) ) * 100
		Else
			@ Prow(),030 PSAY ( (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) - (nTotMeta1A + nTotMeta1B + nTotMeta1U)) Picture "@E 999,999.99"  //DIFERENÇA
			nPerDif1:= ( (nTotMeta1A + nTotMeta1B + nTotMeta1U) / (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) ) * 100
		Endif
		@ Prow(),042 PSAY nPerDif1 Picture "@E 999.99" 	//DIF %		 			 	
		@ Prow(),050 PSAY (nTotAPEX1 / ( (nTotMLEX1A + nTotMLEX1B + nTotMLEX1U) + nTotAPEX1 ) ) * 100 Picture "@E 999.99"	//APARA %		
        
        
		//2o. turno

		@ Prow()    ,059 PSAY (nTotMeta2A + nTotMeta2B + nTotMeta2U) Picture "@E 999,999.99"					//ESTIMADO(MR)
		@ Prow()    ,072 PSAY (nTotMLEX2A + nTotMLEX2B + nTotMLEX2U) Picture "@E 999,999.99"					//REAL(MR)
		
		If (nTotMeta2A + nTotMeta2B  + nTotMeta2U) > (nTotMLEX2A + nTotMLEX2B  + nTotMLEX2U)
			@ Prow(),084 PSAY ( (nTotMeta2A + nTotMeta2B  + nTotMeta2U) - (nTotMLEX2A + nTotMLEX2B  + nTotMLEX2U) ) Picture "@E 999,999.99"  //DIFERENÇA
			nPerDif2:= ( (nTotMLEX2A + nTotMLEX2B  + nTotMLEX2U) / (nTotMeta2A + nTotMeta2B  + nTotMeta2U) ) * 100
		Else 
			@ Prow(),084 PSAY ( (nTotMLEX2A + nTotMLEX2B  + nTotMLEX2U) - (nTotMeta2A + nTotMeta2B  + nTotMeta2U) ) Picture "@E 999,999.99"  //DIFERENÇA
			nPerDif2:= ( (nTotMeta2A + nTotMeta2B  + nTotMeta2U) / (nTotMLEX2A + nTotMLEX2B  + nTotMLEX2U)) * 100
		Endif
		@ Prow(),098 PSAY nPerDif2 Picture "@E 999.99" 	//DIF %		 			 	
		@ Prow(),107 PSAY (nTotAPEX2 / ( (nTotMLEX2A + nTotMLEX2B  + nTotMLEX2U)+ nTotAPEX2 ) ) * 100 Picture "@E 999.99"	//APARA %		
        
        		
		//3o. turno
	
		@ Prow(),116 PSAY (nTotMeta3A + nTotMeta3B + nTotMeta3U) Picture "@E 999,999.99"					//ESTIMADO(MR)
		@ Prow(),129 PSAY (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) Picture "@E 999,999.99"					//REAL(MR)
			
		//@ Prow(),146 /*165*/ PSAY nTotMeta3A Picture "@E 999,999.99"					//ESTIMADO(MR) A
		//@ Prow(),158 /*178*/ PSAY nTotMeta3B Picture "@E 999,999.99"					//ESTIMADO(MR) B
		//@ Prow(),170 /*190*/ PSAY nTotMLEX3A Picture "@E 999,999.99"					//REAL(MR)     A
		//@ Prow(),182 /*202*/ PSAY nTotMLEX3B Picture "@E 999,999.99"					//REAL(MR)     B
			
		If (nTotMeta3A + nTotMeta3B + nTotMeta3U) > (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U)
			@ Prow(),141 PSAY ( (nTotMeta3A + nTotMeta3B + nTotMeta3U) - (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) ) Picture "@E 999,999.99"  //DIFERENÇA
			nPerDif3:= ( (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) / (nTotMeta3A + nTotMeta3B + nTotMeta3U) ) * 100
		Else 
			@ Prow(),141 PSAY ( (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) - (nTotMeta3A + nTotMeta3B + nTotMeta3U) ) Picture "@E 999,999.99"  //DIFERENÇA
			nPerDif3:= ( (nTotMeta3A + nTotMeta3B + nTotMeta3U) / (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) ) * 100
		Endif
		@ Prow(),154 PSAY nPerDif3 Picture "@E 999.99" 	//DIF %		 			 	
		@ Prow(),163 PSAY (nTotAPEX3 / ( (nTotMLEX3A + nTotMLEX3B + nTotMLEX3U) + nTotAPEX3 ) ) * 100 Picture "@E 999.99"	//APARA %		
		
		nTTMLEX1A += nTotMLEX1A
		nTTMLEX2A += nTotMLEX2A 
		nTTMLEX3A += nTotMLEX3A 
		    
		nTTMLEX1B += nTotMLEX1B
		nTTMLEX2B += nTotMLEX2B 
		nTTMLEX3B += nTotMLEX3B
		
		nTTMLEX1U += nTotMLEX1U
		nTTMLEX2U += nTotMLEX2U
		nTTMLEX3U += nTotMLEX3U
		      
		nTTAPEX1 += nTotAPEX1
		nTTAPEX2 += nTotAPEX2
		nTTAPEX3 += nTotAPEX3
		     
		nTTMeta1A += nTotMeta1A 
		nTTMeta2A += nTotMeta2A
		nTTMeta3A += nTotMeta3A		     
			 
		nTTMeta1B += nTotMeta1B 
		nTTMeta2B += nTotMeta2B
		nTTMeta3B += nTotMeta3B
		
		nTTMeta1U += nTotMeta1U 
		nTTMeta2U += nTotMeta2U
		nTTMeta3U += nTotMeta3U		     		     
		
		nTotMLEX1A := 0
		nTotMLEX2A := 0
		nTotMLEX3A := 0
		
		nTotMLEX1B := 0
		nTotMLEX2B := 0
		nTotMLEX3B := 0
		
		nTotMLEX1U := 0
		nTotMLEX2U := 0
		nTotMLEX3U := 0
		
		nTotAPEX1 := 0
		nTotAPEX2 := 0
		nTotAPEX3 := 0 
		
		nTotMeta1A := 0
	   	nTotMeta2A := 0
	   	nTotMeta3A := 0
		       
	   	nTotMeta1B := 0
	   	nTotMeta2B := 0
	   	nTotMeta3B := 0 
	   	
	   	nTotMeta1U := 0
	   	nTotMeta2U := 0
	   	nTotMeta3U := 0 
		
		nPerDif1 := nPerDif2 := nPerDif3 := 0
		
		
EndIF



Z00X->( DbCloseArea() )
Roda( 0, "", TAMANHO )

If aReturn[ 5 ] == 1
   Set Printer To
   Commit
   ourspool( wnrel ) //Chamada do Spool de Impressao
Endif


Return NIL







***************************************************************
Static Function fDifData(dDataIni,dDataFim,cHoraIni,cHorafim )
***************************************************************

//ex: após a meia noite: fDifData( mv_par01,(mv_par01 + 1),cHoraIni3,cHoraFim3)     //ex: (17/03/11 , 18/03/11, "22:00:00", 03:00:00")
//ex: antes da meia noite: fDifData( mv_par01,(mv_par01 + 1),cHoraIni3,cHoraFim3)     //ex: (17/03/11 , 17/03/11, "22:00:00", 23:00:00")
Local nDifdia := 0
Local cMeiaNoite := "00:00:00"
Local cElap1
Local cHoraspassou := ""
Local nHoraspassou := 0
Local nHorastotal  := 0
Local lSemHrFIM    := .F.
Local lSemHrINI	   := .F.


set date brit

If !Empty(cHoraIni)
	If Len(cHoraIni) <= 5
		cHoraIni := cHoraIni + ":00"
	Endif
Else
	lSemHrINI := .T.
Endif	

If !Empty(cHoraFim)
	If Len(cHoraFim) <= 5
		cHoraFim := cHoraFim + ":00"
	Endif
Else
	lSemHrFIM := .T.
Endif	

nDifdia := (dDataFim - dDataIni)

If !lSemHrFIM .AND. !lSemHrINI
	If nDifdia = 0
	
		cElap1 := ElapTime( cHoraIni, cHoraFim ) // Resultado: "01:00:00"
		cHoraspassou := cElap1
		//msgbox("cElap1 = 0 : " + cHoraspassou)
		nHoraspassou := Val(Substr(cHoraspassou,1,2))
		nHoraspassou += Val(Substr(cHoraspassou,4,2) ) / 60
	
	Else
	
	
		cElap1 := ElapTime(cHoraIni,cMeiaNoite)
		cHoraspassou := cElap1
		//msgbox("cElap1: " + cHoraspassou)
		
		nHoraspassou := Val(Substr(cHoraspassou,1,2) )
		nHoraspassou += Val(Substr(cHoraspassou,4,2) ) / 60
		
		//msgbox("nHoras passou: " + str(nHoraspassou) )
		
		cElap1 := ElapTime(cMeiaNoite,cHoraFim) 
		//msgbox("cElap2: " + cElap1)
		cHorasPassou := cElap1
		nHoraspassou += Val(Substr(cHoraspassou,1,2) )
		nHoraspassou += Val(Substr(cHoraspassou,4,2) )  / 60
		//msgbox("nHoras passou: " + str(nHoraspassou) )
		
	Endif
Endif

/*
//carga horária já passada para hora/60:
T1: 7,08
T2: 7,08
T3: 6,5
*/
	
nHorastotal := nHoraspassou
//msgbox("horas passadas: " + str(nHorastotal) )


Return(nHorastotal)
//----------------------------------------
               




**************************************************
Static Function GetTurno()
**************************************************

Local cTurno := ""


//Local dDIAA := If( Time() < Left( cTURNO1, 5 ) + ":00", Date() - 1, Date() )


//Ex.: hoje é 20/08/09, 
//se dDIA for = 19/08/09 o turno é o 3
//se dDIA for = 20/08/09, ver a hora
//se a hora for <= 13:55 ==> turno 1
//se a hora for >= 13:56 ==> turno 2
//se a hora for >= 22:00 ==> turno 3 


//If dDIAA < dDatabase
//	cTurno := "3"	
If Time() <= "05:30:00" .or. Time() >= "22:01:00"
	cTurno := "3"		
Elseif Time() >= "05:50:00" .and. Time() <= "13:55:00"
	cTurno := "1"
Elseif Time() >= "13:55:00" .and. Time() <= "22:00:00"
	cTurno := "2"

Endif


Return(cTurno)


**********************************
Static Function TrazLados(cMaq)
**********************************
///esta função traz qtos lados a máquina possui

Local cQuery := ""
Local nLados := 0
Local LF	 := CHR(13) + CHR(10)
	 	
cQuery := " Select DISTINCT ZB1_MAQ,ZB1_LADO " + LF
cQuery += " From " + RetSqlName("ZB1") + " ZB1 "  + LF
cQuery += " WHERE ZB1_MAQ = '" + Alltrim(cMAQ) + "' " + LF
cQuery += " AND D_E_L_E_T_ = '' " + LF
cQuery += " ORDER BY ZB1_MAQ "  + LF
MemoWrite("C:\Temp\VERLADOS.sql", cQuery)
If Select("LADOX") > 0
	DbSelectArea("LADOX")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "LADOX"
Do While ! LADOX->( Eof() )  
	nLados++			
	LADOX->(DBSKIP())		
Enddo 		

Return(nLados)




