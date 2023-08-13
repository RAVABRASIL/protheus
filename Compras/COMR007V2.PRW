#include "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"
#include "font.ch"
#include "colors.ch"
#include "Ap5mail.ch"


User Function COMR007V2()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relação de Solicitações e Pedidos de Compra em andamento"
Local cPict          := ""
Local titulo         := "Analise de Compras"//+ PERIODO...
Local nLin           := 80
//                                                                                                                          1         1         1         1         1         1         1         1         1
//         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0
//         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |
//123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local Cabec1         := "                                                                              |         Valor         |Valor( % )|      Prazo Medio      | Prazo( % )|       Lead Time       |Ld.Time( %)|         Data          |
Local Cabec2         := "Codigo    | Produto                                                           |  Anterior |   Atual   |          |  Anterior |   Atual   |           |  Anterior |   Atual   |           | Anterior |   Atual    |
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 130 //220
Private tamanho      := "G" //"G"
Private nomeprog     := "COMR007" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "COMR007" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""
Private cPerg	:= "COMR007"
Public extende:= 40

Pergunte( cPerg ,.F. )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  10/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

local cQuery:=''

SetRegua(0)
cQuery := ""
cQuery += " SELECT F1_DOC DOC1 ,D1_COD COD1 ,D1_VUNIT VALUNIT1 ,D1_DTDIGIT DT1 ,E4_PRZMED  PRAZO1 ,                 " + chr(10)
cQuery += " case when C7_DATPRF >C7_EMISSAO THEN                                                                    " + chr(10)
cQuery += "  CAST(CONVERT(datetime  , D1_DTDIGIT , 112 ) -  CONVERT( datetime , C7_DATPRF , 112 ) AS INT )          " + chr(10)
cQuery += "  ELSE                                                                                                   " + chr(10)
cQuery += "  CAST(CONVERT(datetime  , D1_DTDIGIT , 112 ) -  CONVERT( datetime , C1_EMISSAO , 112 ) AS INT )         " + chr(10)
cQuery += " END LDTIME1                                                                                             " + chr(10)

//cQuery += " case when CAST(CONVERT(datetime  , D1_DTDIGIT , 112 ) -  CONVERT( datetime , C1_EMISSAO , 112 ) AS INT ) LDTIME1 " + chr(10)
cQuery += " FROM                   " + chr(10)
cQuery += " SD1020 SD1 ,           " + chr(10)
cQuery += " SF1020 SF1 ,           " + chr(10)
cQuery += " SE4010 SE4 ,           " + chr(10)
cQuery += " SC7020 SC7 ,           " + chr(10)
cQuery += " SC1020 SC1 ,           " + chr(10)
cQuery += " SB1010 SB1             " + chr(10)
cQuery += " WHERE                             " + chr(10)
cQuery += "    F1_DOC         = D1_DOC        " + chr(10)
cQuery += "  AND F1_SERIE       = D1_SERIE    " + chr(10)
cQuery += "  AND F1_FORNECE     = D1_FORNECE  " + chr(10)
cQuery += "  AND F1_LOJA        = D1_LOJA     " + chr(10)
cQuery += "  AND F1_COND        = E4_CODIGO   " + chr(10)
cQuery += "  and C7_NUM         = D1_PEDIDO   " + chr(10)
cQuery += "  and C7_NUMSC       = C1_NUM      " + chr(10)
cQuery += "  and C7_PRODUTO     = C1_PRODUTO  " + chr(10)
cQuery += "  and D1_COD         = B1_COD      " + chr(10)
cQuery += "  and C7_ITEM         = D1_ITEMPC      " + chr(10)
cQuery += " AND D1_DTDIGIT BETWEEN "            + chr(10)
cQuery +=       valtosql(MV_PAR01)+" AND      " + chr(10)
cQuery +=       valtosql(MV_PAR02)              + chr(10)
cComp:=''
IF !empty(MV_PAR03 )
	// cQuery += " AND Y1_COD         ="          +valtosql(MV_PAR03)
	IF     MV_PAR03=='001'
		cQuery += " AND B1_GRUPO IN('0010','0011')"+ chr(10)
		cComp:='Bruno'
	ELSEIF MV_PAR03=='002'
		cQuery += " AND B1_GRUPO ='0012'"          + chr(10)
		cComp:='Adalberto'
	ELSE
		cQuery += " AND B1_GRUPO ='0013' "         + chr(10)
		cComp:='Alexandre'
	ENDIF
ENDIF
cQuery += "    AND SC1.D_E_L_E_T_ = ''      " + chr(10)
cQuery += "    AND SC7.D_E_L_E_T_ = ''      " + chr(10)
cQuery += "    AND SD1.D_E_L_E_T_ = ''      " + chr(10)
cQuery += "    AND SE4.D_E_L_E_T_ = ''      " + chr(10)
cQuery += "    AND SF1.D_E_L_E_T_ = ''      " + chr(10)
cQuery += "    AND SB1.D_E_L_E_T_ = ''      " + chr(10)
cQuery += "GROUP BY                                                                                         " + chr(10)
cQuery += " F1_DOC  ,D1_COD  ,D1_VUNIT  ,D1_DTDIGIT  ,E4_PRZMED   ,                                  " + chr(10)
cQuery += " case when C7_DATPRF >C7_EMISSAO THEN                                                            " + chr(10)
cQuery += "   CAST(CONVERT(datetime  , D1_DTDIGIT , 112 ) -  CONVERT( datetime , C7_DATPRF , 112 ) AS INT ) " + chr(10)
cQuery += "   ELSE                                                                                          " + chr(10)
cQuery += "   CAST(CONVERT(datetime  , D1_DTDIGIT , 112 ) -  CONVERT( datetime , C1_EMISSAO , 112 ) AS INT )" + chr(10)
cQuery += "  END                                                                                            " + chr(10)
cQuery += " ORDER BY D1_DTDIGIT DESC "

TCQUERY cQuery NEW ALIAS "TMP1"
Titulo:=ALLTRIM(Titulo)+iif(!empty(cComp),"   ( "+cComp+" )","")+"    De: "+dtoc(MV_PAR01)+"       Ate: "+dtoc(MV_PAR02)
TMP1->( DbGoTop() )
aVetor:={}
nCnt:=1
While TMP1->( !EOF() )
	incregua()
	if len(aVetor)>1
		if COD1==aVetor[nCnt-1][1] .and.;
			iif(LDTIME1<0,0,LDTIME1) > aVetor[nCnt-1][5]
			aVetor[nCnt-1][5]:=iif(LDTIME1<0,0,LDTIME1)
			TMP1->(DbSkip())
			loop
		endif
	endif
	
	if len(aVetor)>1
		nDupli:=0
		for x:=1 to len(aVetor)
			if COD1==aVetor[x][1]
				nDupli:=1
			endif
		next x
		if nDupli==1
			TMP1->(DbSkip())
			loop
		endif
	endif
	
	aadd(aVetor,{;
	COD1,;
	VALUNIT1,;
	DT1,;
	PRAZO1,;
	iif(LDTIME1<0,0,LDTIME1);
	};
	)
	
	TMP1->(DbSkip())
	nCnt++
EndDo

TMP1->(DbCloseArea())
If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo ,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
	nLin++
Endif
@nLin++ ,000  PSAY ""//replicate("_",154+extende+15)
nDesp:=0
nVal1:=nVal2:=;
nPrz1:=nPrz2:=;
nLd1 :=nLd2:=0
for nCont:=1 to len(aVetor)
	incregua()
	cQuery := ""
	cQuery += " SELECT top 1 F1_DOC DOC2 ,D1_COD COD2 ,D1_VUNIT VALUNIT2 ,D1_DTDIGIT DT2 ,E4_PRZMED PRAZO2 ,  " + chr(10)
	cQuery += " case when C7_DATPRF > C7_EMISSAO THEN                                                           " + chr(10)
	cQuery += "  CAST(CONVERT(datetime  , D1_DTDIGIT , 112 ) -  CONVERT( datetime , C7_DATPRF , 112 ) AS INT )   " + chr(10)
	cQuery += "  ELSE                                                                                            " + chr(10)
	cQuery += "  CAST(CONVERT(datetime  , D1_DTDIGIT , 112 ) -  CONVERT( datetime , C1_EMISSAO , 112 ) AS INT )  " + chr(10)
	cQuery += " END  LEADTIME                                                                                    " + chr(10)
	//cQuery += " CAST(CONVERT(datetime  , D1_DTDIGIT , 112 ) -  CONVERT( datetime , C1_EMISSAO , 112 ) AS INT ) LEADTIME " + chr(10)
	cQuery += " FROM SD1020 SD1 ,                                             " + chr(10)
	cQuery += "      SF1020 SF1 ,                                             " + chr(10)
	cQuery += "      SE4010 SE4 ,                                             " + chr(10)
	cQuery += "      SC7020 SC7 ,                                             " + chr(10)
	cQuery += "      SC1020 SC1 ,                                             " + chr(10)
	cQuery += "      SB1010 SB1                                              " + chr(10)
	//cQuery += "      SY1010 SY1                                               " + chr(10)
	cQuery += "WHERE                                                          " + chr(10)
	cQuery += "        F1_DOC         = D1_DOC                                " + chr(10)
	cQuery += "    AND F1_SERIE       = D1_SERIE                              " + chr(10)
	cQuery += "    AND F1_FORNECE     = D1_FORNECE                            " + chr(10)
	cQuery += "    AND F1_LOJA        = D1_LOJA                               " + chr(10)
	cQuery += "    AND F1_COND        = E4_CODIGO                             " + chr(10)
	cQuery += "    AND D1_COD         = "+ValtoSql(aVetor[nCont,1])             + chr(10)
	cQuery += "    and C7_NUMSC       = C1_NUM                                " + chr(10)
	cQuery += "    and C7_NUM         = D1_PEDIDO                             " + chr(10)
	cQuery += "    and C7_PRODUTO     = D1_COD  " + chr(10)
	cQuery += "    and C7_ITEM        = D1_ITEMPC  " + chr(10)
	
	
	IF !empty(MV_PAR03 )
		// cQuery += " AND Y1_COD         ="          +valtosql(MV_PAR03)
		IF     MV_PAR03=='001'
			cQuery += " AND B1_GRUPO IN('0010','0011')"+ chr(10)
			cComp:='Bruno'
		ELSEIF MV_PAR03=='002'
			cQuery += " AND B1_GRUPO ='0012'"          + chr(10)
			cComp:='Adalberto'
		ELSE
			cQuery += " AND B1_GRUPO ='0013' "         + chr(10)
			cComp:='Alexandre'
		ENDIF
	ENDIF
	cQuery += "    AND D1_DTDIGIT     = (                                     " + chr(10)
	cQuery += "						 SELECT  max(D1_DTDIGIT )            " + chr(10)
	cQuery += "						 FROM SD1020 SD1 ,                        " + chr(10)
	cQuery += "                           SF1020 SF1                          " + chr(10)
	/*
	cQuery += "                           SF1020 SF1 ,                        " + chr(10)
	cQuery += "                           SE4010 SE4 ,                        " + chr(10)
	cQuery += "                           SB1010 SB1 ,                        " + chr(10)
	cQuery += "                           SY1010 SY1                          " + chr(10)
	*/
	cQuery += "						 WHERE                                    " + chr(10)
	cQuery += "								  SD1.D_E_L_E_T_ = ''             " + chr(10)
	cQuery += "							  AND SF1.D_E_L_E_T_ = ''             " + chr(10)
	cQuery += "							  AND F1_DOC         = D1_DOC         " + chr(10)
	//cQuery += "							  AND F1_SERIE       = D1_SERIE       " + chr(10)
	//cQuery += "							  AND F1_FORNECE     = D1_FORNECE     " + chr(10)
	//cQuery += "							  AND F1_LOJA        = D1_LOJA        " + chr(10)
	//cQuery += "							  AND F1_COND        = E4_CODIGO      " + chr(10)
	//cQuery += "                           and D1_COD         = B1_COD         " + chr(10)
	//cQuery += "                           and C7_ITEM        = D1_ITEMPC      " + chr(10)
	cQuery += "							  AND D1_COD         = "+ValtoSql(aVetor[nCont,1]) + chr(10)
	/*
	IF !empty(MV_PAR03 )
	cQuery += " AND Y1_COD         ="          +valtosql(MV_PAR03)
	IF     MV_PAR03=='001'
	cQuery += " AND B1_GRUPO IN('0010','0011')"+ chr(10)
	cComp:='Bruno'
	ELSEIF MV_PAR03=='002'
	cQuery += " AND B1_GRUPO ='0012'"          + chr(10)
	cComp:='Adalberto'
	ELSE
	cQuery += " AND B1_GRUPO ='0013' "         + chr(10)
	cComp:='Alexandre'
	ENDIF
	ENDIF
	*/
	cQuery += " 						  and D1_DTDIGIT  < "+ValtoSql(aVetor[nCont,3]) + chr(10)
	//cQuery += "						      group by D1_DTDIGIT
	//cQuery += " 						  having D1_DTDIGIT  < "+ValtoSql(aVetor[nCont,3]) + chr(10)
	//cQuery += " 						  ORDER BY D1_DTDIGIT DESC" + chr(10)
	cQuery += "					     )                                        " + chr(10)
	
	
	cQuery += "    AND SC1.D_E_L_E_T_ = ''      " + chr(10)
	cQuery += "    AND SC7.D_E_L_E_T_ = ''      " + chr(10)
	cQuery += "    AND SD1.D_E_L_E_T_ = ''      " + chr(10)
	cQuery += "    AND SE4.D_E_L_E_T_ = ''      " + chr(10)
	cQuery += "    AND SF1.D_E_L_E_T_ = ''      " + chr(10)
	cQuery += "    AND SB1.D_E_L_E_T_ = ''      " + chr(10)
	cQuery += "GROUP BY                                                                                         " + chr(10)
	cQuery += "F1_DOC  ,D1_COD  ,D1_VUNIT  ,D1_DTDIGIT  ,E4_PRZMED   ,                                  " + chr(10)
	cQuery += " case when C7_DATPRF >C7_EMISSAO THEN                                                            " + chr(10)
	cQuery += "   CAST(CONVERT(datetime  , D1_DTDIGIT , 112 ) -  CONVERT( datetime , C7_DATPRF , 112 ) AS INT ) " + chr(10)
	cQuery += "   ELSE                                                                                          " + chr(10)
	cQuery += "   CAST(CONVERT(datetime  , D1_DTDIGIT , 112 ) -  CONVERT( datetime , C1_EMISSAO , 112 ) AS INT )" + chr(10)
	cQuery += "  END                                                                                            " + chr(10)
	
	
	TCQUERY cQuery NEW ALIAS "TMP2"
	TMP2->( DbGoTop() )
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
		nLin++
	Endif
	
	if  TMP2->VALUNIT2 == 0
		@nLin  ,000  PSAY ""//replicate("-",130)
		TMP2->(DbCloseArea())
		nDesp++
		loop
	endif
   //	@nLin  ,000 PSAY "          |                           "+space(extende)+"|           |           |          |           |           |           |           |           |           |          |            |"
	@nLin  ,00  PSAY aVetor[nCont,1]
	@nLin  ,000+15  PSAY substr(Posicione('SB1',1,'01'+aVetor[nCont,1],"B1_DESC"),1,22+extende)
	@nLin  ,026+extende-2+15  PSAY  transform(iif(TMP2->VALUNIT2<0,0,TMP2->VALUNIT2) ,"@E 999,999.99"   )
	@nLin  ,038+extende-2+15  PSAY  transform(aVetor[nCont,2],"@E 999,999.99"   )
	@nLin  ,049+extende-2+15  PSAY  transform(     ((   aVetor[nCont,2] - TMP2->VALUNIT2 )*100)/TMP2->VALUNIT2,"@E 999,999.99" )
	nVal1+= TMP2->VALUNIT2
	nVal2+=aVetor[nCont,2]
	
	@nLin  ,060+extende-1+15  PSAY transform(TMP2->PRAZO2   ,"@E 999,999"   )
	@nLin  ,072+extende-1+15  PSAY transform(aVetor[nCont,4],"@E 999,999"   )
	//(   (atual - anterior)*100   )/anterior
	@nLin  ,083+extende+15    PSAY transform(     ((aVetor[nCont,4] - TMP2->PRAZO2  )*100)/TMP2->PRAZO2,"@E 999,999.99"   )
	nPrz1+= TMP2->PRAZO2
	nPrz2+=aVetor[nCont,4]
	
	
	@nLin  ,99+extende-1+15   PSAY transform(iif(LEADTIME<0,0,TMP2->LEADTIME),"@E 999,999"   )
	@nLin  ,112+extende-3+15  PSAY transform(iif(aVetor[nCont,5]<0,0,aVetor[nCont,5]),"@E 999,999"   )
	if LEADTIME>0 .and. aVetor[nCont,5] >0
		@nLin  ,123+extende-4+15  PSAY transform(     ((aVetor[nCont,5] - TMP2->LEADTIME  )*100)/TMP2->LEADTIME,"@E 999,999.99"   )
		nLd1 +=val(alltrim(str(LEADTIME))       )
		nLd2 +=val(alltrim(str(aVetor[nCont,5])))
	else
		@nLin  ,123+extende-4+15  PSAY '    N/D'
		
	endif
	
	
	@nLin  ,133+extende-1+15  PSAY dtoc(stod(TMP2->DT2      ))
	@nLin  ,144+extende+15  PSAY dtoc(stod(aVetor[nCont,3]))
	
	
   	@nLin++ ,000  PSAY ""//replicate("_",154+extende+15)
	// TMP2->(DbSkip())
	
	TMP2->(DbCloseArea())
	
	
next nCont

If nLin > 50 // Salto de Página. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
	nLin++
Endif

@nLin++ ,000  PSAY ""//replicate("_",154+extende+15)
//@nLin  ,000 PSAY "          |                           "+space(extende)+"|           |           |          |           |           |           |           |           |           |                        "
@nLin  ,000  PSAY "total"
@nLin  ,026+extende-2+15  PSAY  transform(nVal1,"@E 999,999.99" )
@nLin  ,038+extende-2+15  PSAY  transform(nVal2,"@E 999,999.99" )
@nLin  ,044+extende+3+15  PSAY  transform(  ( (  nVal2 - nVal1 ) *100)/nVal1,"@E 999,999.99" )


@nLin  ,060+extende+15  PSAY  transform(nPrz1,"@E 999,999"   )
@nLin  ,072+extende+15  PSAY  transform(nPrz2,"@E 999,999"   )
@nLin  ,084+extende-1+15  PSAY  transform(   (   (nPrz2 - nPrz1  )*100)/nPrz1,"@E 999,999.99" )


@nLin  ,100+extende-3+15  PSAY   transform(nLd1,"@E 999,999"   )
@nLin  ,112+extende-3+15  PSAY   transform(nLd2,"@E 999,999"   )
@nLin  ,123+extende-4+15  PSAY  transform(    (  (nLd2 - nLd1  )*100)/nLd1,"@E 999,999.99"   )


@nLin++ ,000  PSAY ""//replicate("_",154+extende+15)





@nLin++ ,000  PSAY ""//replicate("_",154+extende+15)
@nLin++ ,000  PSAY "Resumo: "
@nLin   ,000  PSAY ""//replicate("_",154+extende+15)
@nLin++ ,000  PSAY "Quantidade de itens na primeira compra :"+alltrim(str(nDesp))




/*
Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin := 8
for nCnt:=0 to 255
@nLin++ ,000  PSAY alltrim(str(nCnt)) +' = '
@nLin   ,005  PSAY chr(nCnt)

next
*/





SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

