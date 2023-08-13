#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"


//--------------------------------------------------------------------------
//Programa: FATR016
//Objetivo: Gerar relatório de todos os clientes RAVA que não efetuam compra
//			há mais de 6 meses.
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 01/06/2010
//--------------------------------------------------------------------------

User Function FATR016()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt( "NORDEM,TAMANHO,Titulo,CDESC1,CDESC2,CDESC3," )
SetPrvt( "ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA," )
SetPrvt( "NLIN,WNREL,M_PAG,CABEC1,CABEC2,MPAG," )

imprime        := .T.
aOrd := {}
lEnd         := .F.
lAbortPrint  := .F.
CbTxt        := ""

limite    := 220
tamanho   := "M"
Titulo    := "CLIENTES QUE NÃO COMPRAM HÁ MAIS DE SEIS MESES"

Cabec1 	  := "CLIENTE/LOJA    NOME                        CIDADE           UF   VENDEDOR              ULT.COMPRA   VLR.COMPRA  SEGMENTO"                                
/*

//          999999/99    XXXXXXXXXXXXXXXXXXXXXXXXX   XXXXXXXXXXXXXXXXXXXX  XX   XXXXXXXXXXXXXXXXXXXX  99/99/99     999,999,999.99   999999       
//          0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//          0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        	    


*/


Cabec2 	  := ""                                
Cabec3 	  := ""
cDesc1    := "Este programa ira emitir o relatorio "
cDesc2    := "dos clientes cadastrados que não compram "
cDesc3    := "há mais de seis meses."
cNatureza := ""
aReturn   := { "Producao", 1, "Administracao", 1, 2, 1, "", 1 }
nomeprog  := "FATR016"
cPerg     := "FTR016"
nLastKey  := 0
lContinua := .T.
nLin      := 9
wnrel     := "FATR016"
M_PAG     := 1
li		  := 80

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Habilitar somente para Schedule
//PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"

Pergunte( cPerg, .T. )               // Pergunta no SX1

cString := "SF2"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint( cString, wnrel, cPerg, @Titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho )

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

RptStatus({|| RptDetail(Cabec1,Cabec2,Titulo,nLin) },Titulo)   



//RptDetail(Cabec1,Cabec2,Titulo,nLin)

Return



//------------------------------
Static Function RptDetail(Cabec1,Cabec2,Titulo,nLin)     
//------------------------------


Local __aResult   := {}
Local LF      	:= CHR(13)+CHR(10)
Local chtm		:= ""
Local cDIRHTM	:= ""
Local cARQHTM	:= ""
Local nHandle	:= 0
Local nPag		:= 1
Local cNomredesp:= ""
Local dUltcom := Ctod("  /  /    ")
Local nVlrUcom:= 0




cQuery := " SELECT MAX(F2_EMISSAO) AS EMISSAO, F2_CLIENTE, F2_LOJA, F2_VEND1, A1_NOME, A1_SATIV1, A1_MUN, A1_EST, A1_VEND " + LF  
cQuery += " , A3_COD, A3_NREDUZ " +LF  	  
cQuery += " FROM " + RetSqlName("SF2") + " SF2, "+LF
cQuery += " " + RetSqlName("SA1") + " SA1, "+ LF
cQuery += " " + RetSqlName("SA3") + " SA3 "+ LF
cQuery += " WHERE " //SF2.F2_EMISSAO <= '" + Dtos(dDtApartir) + "' " + LF
//SEGMENTO
cQuery += " SA1.A1_SATIV1 >= '" + MV_PAR01 + "' AND SA1.A1_SATIV1 <= '" + MV_PAR02 + "'  "+LF	//segmento

//TIPO CLIENTE : R-Revendedor, F-Cons.Final, etc
//If !Empty(MV_PAR03)
//	cQuery += " RTRIM(SA1.A1_TIPO) = '" + Alltrim(MV_PAR03) + "' " + LF 
//Endif

//filtra UF
cQuery += " AND RTRIM(SA1.A1_EST) >= '" + Alltrim(MV_PAR03) + "' AND RTRIM(SA1.A1_EST) <= '" + Alltrim(MV_PAR04) + "' " + LF

//filtra Vendedor
cQuery += " AND RTRIM(SF2.F2_VEND1) >= '" + Alltrim(MV_PAR05) + "' AND RTRIM(SF2.F2_VEND1) <= '" + Alltrim(MV_PAR06) + "' " + LF

cQuery += " AND RTRIM (F2_CLIENTE + F2_LOJA)  = RTRIM(A1_COD + A1_LOJA) "+LF 

cQuery += " AND RTRIM(A1_VEND) = RTRIM(A3_COD) "+LF
cQuery += " AND RTRIM (F2_VEND1)  = RTRIM(A3_COD) "+LF  

cQuery += " AND SF2.D_E_L_E_T_ = '' "+ LF
cQuery += " AND SA1.D_E_L_E_T_ = '' "+LF
cQuery += " AND SA3.D_E_L_E_T_ = '' "+LF

cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ LF
cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"+ LF
cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "'"+ LF

cQuery += " AND F2_TIPO = 'N' "+LF
cQuery += " AND F2_SERIE <> '' "+LF

cQuery += " GROUP BY F2_CLIENTE, F2_LOJA, F2_VEND1, A1_NOME, A1_SATIV1, A1_MUN, A1_EST, A1_VEND " + LF  
cQuery += " , A3_COD, A3_NREDUZ " +LF  
cQuery += " ORDER BY F2_CLIENTE, F2_LOJA " + LF
//cQuery := ChangeQuery( cQuery )
//MemoWrite("C:\Temp\FATR016.sql", cQuery)

If Select("SSF2") > 0
	DbSelectArea("SSF2")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "SSF2"
TCSetField( 'SSF2', "EMISSAO", "D" )


SSF2->( DBGoTop() )
SetRegua(0)
//SetRegua( Lastrec() )
mPag := 1


_aResult 	:= {}


Do While !SSF2->( Eof() )
    If SSF2->EMISSAO <= (dDatabase - 181)
    
		cQuery := " SELECT TOP 1 F2_CLIENTE, F2_LOJA, F2_VALBRUT, F2_EMISSAO " + LF  
		cQuery += " FROM " + RetSqlName("SF2") + " SF2, "+LF
		cQuery += " " + RetSqlName("SA3") + " SA3 "+LF
		
		cQuery += " WHERE RTRIM(F2_CLIENTE + F2_LOJA)  = '" + RTRIM(SSF2->F2_CLIENTE + SSF2->F2_LOJA) + "' "+LF 
		
		cQuery += " AND RTRIM (F2_VEND1)  = RTRIM(A3_COD) "+LF  
		
		cQuery += " AND SF2.D_E_L_E_T_ = '' AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ LF
		cQuery += " AND SA3.D_E_L_E_T_ = '' AND SA3.A3_FILIAL = '" + xFilial("SA3") + "'"+ LF
		
		cQuery += " AND F2_TIPO = 'N' "+LF
		cQuery += " AND F2_SERIE <> '' "+LF
		
		cQuery += " ORDER BY F2_EMISSAO DESC " + LF
		//cQuery := ChangeQuery( cQuery )
		//MemoWrite("C:\Temp\FATR016A.sql", cQuery)
		
		If Select("SF2A") > 0
			DbSelectArea("SF2A")
			DbCloseArea()
		EndIf
		
		TCQUERY cQuery NEW ALIAS "SF2A"
		TCSetField( 'SF2A', "F2_EMISSAO", "D" )	
		SF2A->( DBGoTop() )
			
		
		Do While !SF2A->( Eof() )
			dUltcom := SF2A->F2_EMISSAO
			nVlrUcom:= SF2A->F2_VALBRUT
			SF2A->(DBSKIP())
		Enddo  
	
	  
   
 	
		Aadd (_aResult, {SSF2->F2_CLIENTE,;  //1
					SSF2->F2_LOJA,;		//2			  
	  				SSF2->A1_NOME,;		//3
	  				SSF2->A1_MUN,;      //4
	  				SSF2->A1_EST,;		//5
					SSF2->F2_VEND1,;    //6
					SSF2->A3_NREDUZ,;	//7
					dUltcom,;           //8
					nVlrUcom,;          //9
					SSF2->A1_SATIV1 } )	//10
  
  Endif
  Incregua()
  SSF2->( DbSkip() )

Enddo


If Len(_aResult) <= 0
	Alert("Não existem dados para os parâmetros informados, por favor, reveja os parâmetros !")
	DbselectArea("SSF2")
	DbcloseArea()
	Return
EndIF



Titulo    := "CLIENTES QUE NÃO COMPRAM HÁ MAIS DE SEIS MESES"
Cabec1 	  := "CLIENTE/LOJA    NOME                        CIDADE              UF   VENDEDOR              ULT.COMPRA   VLR.COMPRA  SEGMENTO"                                
Cabec2 	  := ""
Cabec3 	  := ""

If Len(_aResult) > 0

/*
Cabec1 	  := "CLIENTE/LOJA    NOME                        CIDADE            UF    VENDEDOR             ULT.COMPRA   VLR.ULT.COMPRA  SEGMENTO"                                
Cabec2 := ""                                
Cabec3 := ""

//            999999/99    XXXXXXXXXXXXXXXXXXXXXXXXX   XXXXXXXXXXXXXXXXXXXX  XX   XXXXXXXXXXXXXXXXXXXX  99/99/99  999,999,999.99    999999       
//            0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//            0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        	    


*/


	FOR X := 1 TO Len(_aResult)
			
			If lEnd
				@ li,000 PSAY "CANCELADO PELO OPERADOR"
				Exit
			EndIf
			
			
			If Li > 55
				Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  //Impressao do cabecalho
				li := 9
				li++
				nPag++				
			Endif
			
		@li,000 PSAY _aResult[X,1] + "/" + _aResult[X,2] 
		@li,013 PSAY Substr(_aResult[X,3],1,25) PICTURE "@!"
		@li,041 PSAY Substr(_aResult[X,4],1,20) PICTURE "@!"
		@li,063 PSAY _aResult[X,5] PICTURE "@!"
		@li,068 PSAY Substr(_aResult[X,7],1,20) PICTURE "@!"
		@li,090 PSAY _aResult[X,8] PICTURE "@D 99/99/99"
		@li,100 PSAY _aResult[X,9] PICTURE "@E 999,999,999.99"       
		@li,118 PSAY _aResult[X,10] PICTURE "@E 999999"
		li++
			
        
	NEXT

Endif
////if do _aResult > 0


SSF2->( DbCloseArea() )

Roda( 0, "", TAMANHO )


If aReturn[ 5 ] == 1
   Set Printer To
   Commit
   ourspool( wnrel ) //Chamada do Spool de Impressao - mostra na tela.
Endif

//_aResult := {}

//Msginfo("Processo finalizado")

// Habilitar somente para Schedule
//Reset environment


Return

