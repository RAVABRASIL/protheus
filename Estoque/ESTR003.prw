#include "rwmake.ch"  
#include "topconn.ch" 
#include "protheus.ch"

//--------------------------------------------------------------------------
//Programa: ESTR003
//Objetivo: Mostrar a qtde de notas devolvidas por motivo dentro do período
//          especificado pelo usuário
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 08/03/10
//--------------------------------------------------------------------------

User Function ESTR003()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt( "NORDEM,TAMANHO,TITULO,CDESC1,CDESC2,CDESC3," )
SetPrvt( "ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA," )
SetPrvt( "NLIN,WNREL,M_PAG,CABEC1,CABEC2,MPAG," )

tamanho   := "P"
titulo    := PADC("QTDE. NOTAS DEVOLVIDAS x MOTIVO" , 74 )
cDesc1    := "Este programa ira emitir o relatorio "
cDesc2    := "de qtde notas devolvidas por motivo. "
cDesc3    := ""
cNatureza := ""
aReturn   := { "Producao", 1, "Administracao", 1, 2, 1, "", 1 }
nomeprog  := "ESTR003"
cPerg     := "ESTR03"
nLastKey  := 0
lContinua := .T.
nLin      := 9
wnrel     := "ESTR003"
M_PAG     := 1
li		  := 80

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte( cPerg, .F. )               // Pergunta no SX1
//titulo := AllTrim( titulo ) + "  " + Dtoc( MV_PAR01 ) + " A " + Dtoc( MV_PAR02 )

cString := "SF1"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint( cString, wnrel, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se teclar ESC, sair³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

Local  cCodMoti    := ""
Local  cDescMoti   := ""
Local  nQtd		   := 0
Local aResult   := {}


//////////////////////////
// Exemplo:             //
// Motivo1 - 10 nf's    //
// Motivo2 - 3 nf's     //
//////////////////////////

//Parâmetros:
//--------------------------------
// mv_par01 - Emissao de
// mv_par02 - Emissao até
// mv_par03 - NF De
// mv_par04 - NF Até
// mv_par05 - Serie de
// mv_par06 - Serie até
// mv_par07 - Cliente de
// mv_par08 - Cliente até
// mv_par09 - Transportadora De
// mv_par10 - Transportadora Até
//---------------------------------



Cabec1 := PADC("PERIODO: " + Dtoc( MV_PAR01 ) + " A " + Dtoc( MV_PAR02 ) , 74 )
Cabec2 := "MOTIVO    DESCRICAO                                         QTD NOTAS "
Cabec3 := ""
//         999999    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX     9,999   NOTAS
//         01234567890123456789012345678901234567890123456789012345678901234567890
//         0         1         2         3         4         5         6         7


cQuery := " SELECT COUNT(F1_CODMOTI) AS QTMOTIV, F1_CODMOTI "
cQuery += " FROM " + RetSqlName("SF1") + " SF1 "
cQuery += " WHERE F1_TIPO = 'D' " 
cQuery += " AND F1_CODMOTI <> '' "
cQuery += " AND F1_EMISSAO       >= '"  + DtoS(mv_par01) + "' AND F1_EMISSAO <= '" + DtoS(mv_par02) + "' "
cQuery += " AND SF1.D_E_L_E_T_ = ''
cQuery += " AND F1_FILIAL  = '" + xFilial("SF1") + "' "
cQuery += " GROUP BY F1_CODMOTI " 
cQuery += " ORDER BY F1_CODMOTI "

cQuery := ChangeQuery( cQuery )
//MemoWrite("C:\ESTR003.sql", cQuery)

If Select("ESTR03") > 0
	DbSelectArea("ESTR03")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "ESTR03"
TCSetField( 'ESTR03', "F1_EMISSAO", "D" )


ESTR03->( DBGoTop() )
SetRegua( Lastrec() )
mPag := 1


aResult 	:= {}

Do While !ESTR03->( Eof() )  
    
    cCodMoti    := ESTR03->F1_CODMOTI
    nQtd		:= ESTR03->QTMOTIV
    
    DbselectArea("SX5")
    Dbsetorder(1)
    SX5->(Dbseek(xFilial("SX5") + 'MO' + cCodMoti ))
    cDescMoti   := Alltrim(SX5->X5_DESCRI)
//						1			2		3    
	Aadd (aResult, {cCodMoti ,	cDescMoti, nQtd  } )  
	Dbselectarea("ESTR03")
	ESTR03->( DbSkip() )

Enddo


If Len(aResult) <= 0
	Alert("Não existem dados para os parâmetros informados, por favor, reveja os parâmetros !")
	DbselectArea("ESTR03")
	DbcloseArea()
	Return
EndIF



If Len(aResult) > 0    

	FOR X := 1 TO Len(aResult)
			
		If lEnd
			@ li,000 PSAY "CANCELADO PELO OPERADOR"
			Exit
		EndIf
			
		If Li > 58
			Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  //Impressao do cabecalho
			li := 9
		Endif
		/*
		//						1			2		3    
			Aadd (aResult, {cCodMoti ,	cDescMoti, nQtd  } )  
		
		*/			 
		/*
		Cabec1 := "MOTIVO    DESCRICAO                                        QUANTIDADE "
		Cabec2 := ""
		Cabec3 := ""
		//         999999    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX     9,999   NOTAS
		//         01234567890123456789012345678901234567890123456789012345678901234567890
		//         0         1         2         3         4         5         6         7
		*/
        	 	
	   /*@ li    ,000 PSAY aResult[X,1]                           					//COD. MOTIVO
	 	@ li    ,010 PSAY Substr(aResult[X,2],1,40)		Picture "@!"            	//DESCRIÇÃO MOTIVO
	 	@ li    ,056 PSAY aResult[X,3]					Picture "@9,999"			//QTDE NFS POR MOTIVO
	 	@ li    ,064 PSAY "NOTAS"
       */
        @ li    ,000 PSAY aResult[X,1]                           					//COD. MOTIVO
	 	@ li    ,010 PSAY aResult[X,2]		Picture "@!"            	//DESCRIÇÃO MOTIVO
	 	@ li    ,068 PSAY aResult[X,3]	Picture "@999"			//QTDE NFS POR MOTIVO
	   //	@ li    ,072 PSAY "NOTAS"
        
        li++
	
	NEXT

EndIF


ESTR03->( DbCloseArea() )
Roda( 0, "", TAMANHO )

If aReturn[ 5 ] == 1
   Set Printer To
   Commit
   ourspool( wnrel ) //Chamada do Spool de Impressao
Endif


Return NIL
