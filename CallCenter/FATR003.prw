#include "rwmake.ch"  
#include "topconn.ch" 
#include "protheus.ch"

//--------------------------------------------------------------------------
//Programa: FATR003
//Objetivo: Mostrar a rela��o de todas as notas faturadas com as datas 
//          de faturamento e previs�o de entrega
//Autoria : Fl�via Rocha
//Empresa : RAVA
//Data    : 26/11/09
//--------------------------------------------------------------------------

User Function FATR003()

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt( "NORDEM,TAMANHO,TITULO,CDESC1,CDESC2,CDESC3," )
SetPrvt( "ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA," )
SetPrvt( "NLIN,WNREL,M_PAG,CABEC1,CABEC2,MPAG," )

tamanho   := "G"
titulo    := "FATURAMENTO  x PREVISAO DE CHEGADA - Faturados de: "
cDesc1    := "Este programa ira emitir o relatorio "
cDesc2    := "de notas faturadas e sua previsao "
cDesc3    := "de chegada."
cNatureza := ""
aReturn   := { "Producao", 1, "Administracao", 1, 2, 1, "", 1 }
nomeprog  := "FATR003"
cPerg     := "FTR003"
nLastKey  := 0
lContinua := .T.
nLin      := 9
wnrel     := "FATR003"
M_PAG     := 1
li		  := 80
Private lEnd        := .F.

//�������������������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas
//���������������������������������������������������������������������������

Pergunte( cPerg, .T. )               // Pergunta no SX1

cString := "SF2"

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������

wnrel := SetPrint( cString, wnrel, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho )

//���������������������
//�Se teclar ESC, sair�
//���������������������
If nLastKey == 27
	Return
Endif

//��������������������������������������������������������������Ŀ
//� Verifica Posicao do Formulario na Impressora                 �
//����������������������������������������������������������������
SetDefault( aReturn, cString )

If nLastKey == 27
   Return
Endif

//��������������������������������������������������������������Ŀ
//� Inicio do Processamento do Relatorio                         �
//����������������������������������������������������������������

RptStatus({|| RptDetail()})  // Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
Return



//------------------------------
Static Function RptDetail()     
//------------------------------

Local cDoc      := ""
Local cSerie    := ""
Local cPedido	:= ""
Local dDtPed    := Ctod("  /  /    ")
Local dEmissao  := CtoD("  /  /    ")
Local cCliente  := ""
Local cLoja	    := ""
Local cTransp   := ""
Local cTelTransp:= ""
Local dPrevCheg := CtoD("  /  /    ") 
Local dRealCheg := CtoD("  /  /    ") 
Local aResult   := {}
Local cMun		:= ""
Local cPrazo 	:= ""
Local cA4Cod    := ""
Local cA4DiaTrab:= ""
Local nZZPrazo  := 0
Local cRedesp   := ""
Local cNomeRed  := ""
Local cLocal	:= ""
Local cTransp1	:= ""
Local LF      	:= CHR(13)+CHR(10) 



//Par�metros:
//--------------------------------
// mv_par01 - Emissao de
// mv_par02 - Emissao at�
// mv_par03 - NF De
// mv_par04 - NF At�
// mv_par05 - Serie de
// mv_par06 - Serie at�
// mv_par07 - Cliente de
// mv_par08 - Cliente at�
// mv_par09 - Transportadora De
// mv_par10 - Transportadora At�
//---------------------------------

Cabec1 := "PEDIDO  DT.PEDIDO  DOCUMENTO  SERIE DT FATUR  DT EXPE      CLIENTE                                  MUNICIPIO                  TRANSPORTADORA        TRANSP.REDESPACHO     TRANS.T  TELEFONE      PRV.CHEGADA  DT.CHEGADA"                                
Cabec2 := ""
Cabec3 := ""

//         999999  99/99/99   999999999  XXX   99/99/99  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX     XXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXX   XX   999999999999999   99/99/99    99/99/99   99/99/99              
//         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//         0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        	    


cQuery := " SELECT F2_TRANSP, F2_REDESP, F2_DOC, F2_SERIE, F2_EMISSAO, F2_CLIENTE, F2_LOJA, F2_TIPO, F2_LOCALIZ, F2_PREVCHG, F2_REALCHG, "+LF
cQuery += " F2_DTEXP, A4_COD, A4_NREDUZ, A4_TEL, ZZ_PRZENT, A4_DIATRAB, A4_CODCLIE, " +LF
cQuery += " A1_NOME, A1_MUN, A1_EST "+LF
cQuery += " FROM " + RetSqlName("SF2") + " SF2, " +LF
cQuery += " "  + RetSqlName("SA4") + " SA4, "+LF
cQuery += " "  + RetSqlName("SA1") + " SA1, "+LF
cQuery += " "  + RetSqlName("SZZ") + " SZZ "+LF
cQuery += " WHERE "+LF
cQuery += " F2_CLIENTE = A1_COD "+LF
cQuery += " AND F2_LOJA = A1_LOJA "+LF
cQuery += " AND F2_TRANSP = A4_COD "+LF
cQuery += " AND F2_TRANSP = ZZ_TRANSP "+LF
cQuery += " AND ZZ_LOCAL = F2_LOCALIZ "+LF
cQuery += " AND F2_TIPO = 'N' "+LF
cQuery += " AND F2_DTEXP >= '20091117' "+LF

If mv_par05 = 1		//Em aberto
	cQuery += " AND F2_REALCHG = '' " + LF
Endif

cQuery += " AND F2_EMISSAO       >= '"  + DtoS(mv_par01) + "' AND F2_EMISSAO <= '" + DtoS(mv_par02) + "' "+LF
cQuery += " AND F2_DOC  >= '"  + Alltrim(mv_par03) + "' "+LF
cQuery += " AND F2_DOC  <= '"  + Alltrim(mv_par04) + "' "+LF
//cQuery += " AND F2_CLIENTE       >= '"  + mv_par07 + "' AND F2_CLIENTE <= '" + mv_par08 + "' "+LF
//cQuery += " AND RTRIM(F2_TRANSP) <> '024' "+LF
//cQuery += " AND RTRIM(F2_TRANSP) >= '"  + mv_par09 + "' AND RTRIM(F2_TRANSP) <= '" + mv_par10 + "' "+LF
cQuery += " AND SF2.F2_SERIE   != ' ' "+LF
cQuery += " AND SF2.D_E_L_E_T_  = ' ' "+LF
cQuery += " AND SA4.D_E_L_E_T_  = ' ' "+LF
cQuery += " AND SA1.D_E_L_E_T_  = ' ' "+LF
cQuery += " AND SZZ.D_E_L_E_T_  = ' ' "+LF
cQuery += " AND F2_FILIAL  = '" + xFilial("SF2") + "' "+LF
cQuery += " AND A4_FILIAL = '"  + xFilial("SA4") + "' "+LF
cQuery += " AND ZZ_FILIAL = '"  + xFilial("SZZ") + "' "+LF
cQuery += " GROUP BY F2_TRANSP, F2_REDESP, F2_DOC, F2_SERIE, F2_EMISSAO, F2_CLIENTE, F2_LOJA, F2_TIPO, F2_LOCALIZ,F2_PREVCHG, F2_REALCHG, "+LF
cQuery += " F2_DTEXP, A4_COD, A4_TEL, A4_NREDUZ, ZZ_PRZENT, A4_DIATRAB, A4_CODCLIE, A1_NOME, A1_MUN, A1_EST "+LF
cQuery += " ORDER BY F2_DOC, F2_SERIE, F2_EMISSAO "+LF

cQuery := ChangeQuery( cQuery )
MemoWrite("C:\FATR003.sql", cQuery)

If Select("FATR03") > 0
	DbSelectArea("FATR03")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "FATR03"
TCSetField( 'FATR03', "F2_EMISSAO", "D" )
TCSetField( 'FATR03', "F2_DTEXP", "D" )
TCSetField( 'FATR03', "F2_PREVCHG", "D" )
TCSetField( 'FATR03', "F2_REALCHG", "D" )

FATR03->( DBGoTop() )
SetRegua( Lastrec() )
mPag := 1

TITULO := AllTrim( TITULO ) + "  " + Dtoc( MV_PAR01 ) + " A " + Dtoc( MV_PAR02 )
If li > 58
	Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  //Impressao do cabecalho
	li := 9 
	nLin++
Endif

aResult 	:= {}


Do While !FATR03->( Eof() )  
    
    cNomeRed    := ""
    cTransp     := ""
    cPedido		:= ""
    dDtPed		:= Ctod("  /  /    ")
    
    If Empty( FATR03->F2_REDESP )
	 	cNomeCli  := ""
	 	cDoc      := FATR03->F2_DOC
	 	cSerie    := FATR03->F2_SERIE
	 	dEmissao  := FATR03->F2_EMISSAO
	 	dDtExp	  := FATR03->F2_DTEXP
	 	cCliente  := FATR03->F2_CLIENTE
	 	cLoja	  := FATR03->F2_LOJA
	 	cMun	  := Alltrim( FATR03->A1_MUN )
	 	nZZPrazo  := FATR03->ZZ_PRZENT
	 	cNomeCli  := FATR03->A1_NOME
	 	cTransp   := Alltrim( FATR03->A4_NREDUZ )
	 	cNomeRed  := Space(20) 
	 	cTelTransp:= Alltrim(FATR03->A4_TEL)
	 	//dPrevCheg := U_CalPrv( FATR03->F2_DTEXP, FATR03->A4_DIATRAB, FATR03->ZZ_PRZENT)
	 	dPrevCheg := FATR03->F2_PREVCHG
	 	dRealCheg := FATR03->F2_REALCHG 
 	Else
 	
 		cRedesp		:= FATR03->F2_REDESP
 		cNomeCli  := ""
	 	cDoc      := FATR03->F2_DOC
	 	cSerie    := FATR03->F2_SERIE
	 	dEmissao  := FATR03->F2_EMISSAO
	 	dDtExp	  := FATR03->F2_DTEXP
	 	cCliente  := FATR03->F2_CLIENTE
	 	cLoja	  := FATR03->F2_LOJA
	 	cMun	  := Alltrim( FATR03->A1_MUN )
	 	cNomeCli  := FATR03->A1_NOME
	 	cTransp   := Alltrim( FATR03->A4_NREDUZ )
	 	
	 	
	  	cLocal		:= "07"			//Se for redespacho, ir� assumir o local Recife como primeiro c�lculo de prazo   	
     	cTransp1	:= "47    "		//Ir� pegar o prazo da ALD para o redespacho para Recife
     	SZZ->(Dbsetorder(1))
       	If SZZ->(Dbseek(xFilial("SZZ") + cTransp1 + cLocal ))
       		nZZPrazo := SZZ->ZZ_PRZENT       	
       	Endif
       	       	       	
       	If SZZ->(Dbseek(xFilial("SZZ") + cRedesp + FATR03->F2_LOCALIZ ))       	
       		nZZPrazo += SZZ->ZZ_PRZENT        		      	
       	Else

	   		Aviso(	"N�o cadastrado no SZZ",;
			"A Transportadora / Local n�o cadastrados no SZZ aparecer�o no relat�rio com um asterisco (*) " ,;
			{"&Continua"},,;
			"C�digo Transp./Local-> " + cRedesp + " / " + FATR03->F2_LOCALIZ )
       		cNomeRed := '*'
       	Endif	
	 	
	 	If SA4->(Dbseek(xFilial("SA4") + cRedesp ))	 	     
	 	     cA4DiaTrab := SA4->A4_DIATRAB
	 	     cNomeRed   += Alltrim( SA4->A4_NREDUZ )
	 	     cTelTransp := Alltrim(SA4->A4_TEL)  
	 	Endif
	 		    
    	//dPrevCheg := U_Calprv( FATR03->F2_DTEXP , cA4DiaTrab, nZZPrazo )
        dPrevCheg := FATR03->F2_PREVCHG
        dRealCheg := FATR03->F2_REALCHG
 	
 	Endif
 	
 	DbselectArea("SD2")
 	SD2->(Dbsetorder(3)) //D2_DOC + D2_SERIE
 	If SD2->(Dbseek(xFilial("SD2") + cDoc + cSerie ))
 		cPedido := SD2->D2_PEDIDO
 	Endif
 	
 	DbselectArea("SC5")
 	SC5->(Dbsetorder(1))
 	If SC5->(Dbseek(xFilial("SC5") + cPedido ))
 		dDtPed := SC5->C5_EMISSAO
 	Endif 
 	 	
	Aadd (aResult, {cDoc      ,;  		//1
					cSerie    ,;	  	//2			  
	  				dEmissao  ,;      	//3
					cNomeCli  ,;      	//4
					cMun	  ,;		//5	
					cTransp   ,;      	//6
					cNomeRed  ,;		//7
					nZZPrazo  ,;		//8
					cTelTransp,;        //9
					dDtExp    ,;		//10
					dPrevCheg ,;  		//11
    	            cPedido   ,;        //12
    	            dDtPed    ,;        //13
    	           dRealCheg } )		//14
  
 
  FATR03->( DbSkip() )

Enddo


If Len(aResult) <= 0
	Alert("N�o existem dados para os par�metros informados, por favor, reveja os par�metros !")
	DbselectArea("FATR03")
	DbcloseArea()
	Return
EndIF

/*
Cabec1 := "PEDIDO  DT.PEDIDO  DOCUMENTO  SERIE  EMISSAO   CLIENTE                                     MUNICIPIO                  TRANSPORTADORA        TRANSP.REDESPACHO     PRAZO    TELEFONE      DATA EXP.  PRV.CHEGADA  DT.CHEGADA"                                
Cabec2 := ""
Cabec3 := ""

//         999999  99/99/99   999999999  XXX   99/99/99  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX     XXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXX   XX   999999999999999   99/99/99    99/99/99   99/99/99              
//         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//         0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        	    

*/

If Len(aResult) > 0    

	FOR X := 1 TO Len(aResult)
			
			If lEnd
				@ li,000 PSAY "CANCELADO PELO OPERADOR"
				Exit
			EndIf
			
			If Li > 58
				Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  //Impressao do cabecalho
				li := 9
				nLin++
			Endif 
        	 	
		@ li    ,000 PSAY aResult[X,12]                           					//PEDIDO
		@ li    ,008 PSAY aResult[X,13]					Picture "@D 99/99/99" 		//DT.PEDIDO
		@ li    ,019 PSAY aResult[X,1]                           					//NF
	 	@ li    ,030 PSAY aResult[X,2]         			Picture "@X"            	//SERIE
	 	@ li    ,036 PSAY ( aResult[X,3] ) 			Picture "@D 99/99/99"		//DT FATURAMENTO
	 	
	 	@ li	,046 PSAY ( aResult[X,10] ) 		Picture "@D 99/99/99" 	    //DATA EXPEDI��O
	 	
	 	@ li    ,056 PSAY aResult[X,4]         			Picture "@!"				//NOME CLIENTE
	 	@ li	,101 PSAY aResult[X,5]					Picture "@!"             	//MUNICIPIO
	 	@ li	,128 PSAY aResult[X,6]         			Picture "@!"             	//TRANSPORTADORA
	 	@ li    ,150 PSAY aResult[X,7]			   		Picture "@!"				//TRANSP.REDESPACHO
	 	@ li	,173 PSAY aResult[X,8]        			Picture "@E 99"            	//PRAZO
	 	If !Empty( aResult[X,9] )
	 		@ li	,178 PSAY aResult[X,9]     			Picture "@X"             	//TEL. TRANSP.
	 	Else 
	 		@ li    ,178 PSAY Space(15)
	 	Endif
		@ li	,198 PSAY ( aResult[X,11] ) 		Picture "@D 99/99/99" 	    //PREVIS�O DE CHEGADA
		@ li	,209 PSAY ( aResult[X,14] ) 		Picture "@D 99/99/99" 	    //DT. REAL DE CHEGADA
        
        li++
	NEXT

EndIF


FATR03->( DbCloseArea() )
Roda( 0, "", TAMANHO )

If aReturn[ 5 ] == 1
   Set Printer To
   Commit
   ourspool( wnrel ) //Chamada do Spool de Impressao - mostra na tela.
Endif


Return NIL
