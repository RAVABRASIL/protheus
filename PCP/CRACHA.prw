#include "protheus.ch"
#include "topconn.ch"

*************

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} CRACHAOP
Imprime o cracha dos funcionarios para pesagem.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     18/03/2014
/*/
//------------------------------------------------------------------------------------------

User Function CRACHAOP()

*************
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Declaracao de variaveis utilizadas no pro§grama atraves da funcao   ³
³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
³ identificando as variaveis publicas do sistema utilizadas no codigo ³
³ Incluido pelo assistente de conversao do AP5 IDE                    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
Local cPerg	:= "CRACHA"
Private oFont01, oFont02, oFont03, oFont04, oFont05, oFont06, oFont07, oPrint

SetPrvt("CALIASANT,CDESC1,CDESC2,CDESC3,ARETURN,CARQUIVO")
SetPrvt("AORD,CNOMREL,CTITULO,NLASTKEY,NREG,NPVAROP")
SetPrvt("CCODETIQ,CPRODUTO,NOP,AMAT,NQUANT,CMAT")
SetPrvt("NCONT,NDENSIDA,LFLAG,CNUMPI,DEMISPI,CMAQPI")
SetPrvt("NQTDPI,CPRODPI,CCEMEPI,NBOBLGPI,NLFILPI,NESPPI")
SetPrvt("CSANLAMPI,CTRATAMPI,CSLITEXPI,NPTNEVEPI,CMATRIZPI,NLIN")
SetPrvt("NNUMETQ,I,CGILETE,NCTRL, cImpressao,")

criaSx1(cPerg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Objeto que controla o tipo de Fonte        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oFont01 	:= TFont():New('Courier New',22,22,.F.,.T.,5,.T.,5,.F.,.F.)
oFont02 	:= TFont():New('Courier New',20,20,.F.,.F.,5,.T.,5,.F.,.F.)
oFont03 	:= TFont():New('Courier New',18,18,.F.,.T.,5,.T.,5,.F.,.F.)
oFont04 	:= TFont():New('Courier New',18,18,.F.,.F.,5,.T.,5,.F.,.F.)
oFont05 	:= TFont():New('Courier New',14,14,.F.,.T.,5,.T.,5,.F.,.F.)
oFont06 	:= TFont():New('Courier New',16,16,.F.,.F.,5,.T.,5,.F.,.F.)
oFont07 	:= TFont():New('Courier New',16,16,.F.,.T.,5,.T.,5,.F.,.F.)
oFont08 	:= TFont():New('Courier New',14,14,.F.,.F.,5,.T.,5,.F.,.F.)
oFont10   	:= TFont():New( "Calibri",0,-18,,.T.,0,,700,.F.,.F.,,,,,, )
oFont11   	:= TFont():New( "Calibri",0,-14,,.T.,0,,700,.F.,.F.,,,,,, )
oFont12   	:= TFont():New( "Calibri",0,-10,,.T.,0,,700,.F.,.F.,,,,,, )

If Pergunte(cPerg,.T.)
   MsAguarde( { || runReport() }, "Aguarde. . .", "Impressao de Crachas . . ." )
endif

return



***************

Static Function runReport()

***************
Local cQuery
Local cCodigo
Local nLin 		:=100
Local nCol 		:=100
Local nQtd			:= 3 //mv_par03
Local nLinCD		:= 2.5
Local nX,Ny		:= 30
Local nZ			:= 500

cQuery := " SELECT RA_MAT, RA_NOME, RA_CC FROM " + RetSqlName("SRA") + " SRA "
cQuery += " WHERE SRA.D_E_L_E_T_ <> '*' "
cQuery += " AND RA_SITFOLH = '' "
cQuery += " AND RA_FILIAL = '" + xFilial("SRA") + "'"

If !Empty(mv_par01)
	cQuery += " AND RA_MAT = '" + mv_par01 + "' "
EndIf

If !Empty(mv_par02)
	cQuery += " AND RA_CC = '" + mv_par02 + "' "
EndIf

MemoWrite("C:\TEMP\CRACHA.SQL", cQuery )
TCQUERY cQuery NEW ALIAS "TMP"

dbselectArea("TMP")
dbGoTop("TMP")

oPrt := TMSPrinter():new("Lista de Crachas") 
oPrt:SetPortrait() 

oPrt:StartPage()

While TMP->(!EOF()) 

	For i:=1 to nQtd

		oPrt:Box(nX, Ny ,nZ, nCol+650,)
		oPrt:Say(nLin,nCol,"RAVA Embalagens",oFont03, 300, , , 0 )
		nLin+=60
		oPrt:Say(nLin,nCol, + SubStr(TMP->RA_NOME,1,16),oFont06, 300, , , 0 )
		nLin+=40
		oPrt:Say(nLin,nCol,SubStr(TMP->RA_NOME,17,25),oFont06, 300, , , 0 )
		cCodigo	:= SubStr(TMP->RA_NOME,1,1) + TMP->RA_MAT
		
		nLin-=100
		nCol+=760                        
	Next

	MSBAR("CODE128",nLinCD,1.8,cCodigo,oPrt,.F.,,.T.,0.025,1.1,NIL,NIL,NIL,.F.)
	MSBAR("CODE128",nLinCD,7.8,cCodigo,oPrt,.F.,,.T.,0.025,1.1,NIL,NIL,NIL,.F.)
	MSBAR("CODE128",nLinCD,14.8,cCodigo,oPrt,.F.,,.T.,0.025,1.1,NIL,NIL,NIL,.F.)
	TMP->(dbSkip())

	nCol	-= 2280
	nLinCD	+= 4.3
	nLin 	+= 500
	nZ		+= 500
	
	If nLin > 3000
		oPrt:EndPage()
		oPrt:StartPage()
		nLin 		:=100
		nCol 		:=100
		nLinCD		:= 2.5
		nX			:= 30
		Ny			:= 30
		nZ			:= 500
	EndIf
	
EndDo

oPrt:EndPage()
oPrt:Preview()

return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação das perguntas (se não existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
static function criaSX1(cPerg)

putSx1(cPerg, '01', 'Matricula?'     	, '', '', 'mv_ch1', 'C', 6     	, 0, 0, 'G', '', ''   , '', '', 'mv_par01','','','','','','','','','','','','','','','','',{"Codigo do funcionario. Em branco para todos."},{},{})
putSx1(cPerg, '02', 'C. Custo?'  		, '', '', 'mv_ch2', 'C', 11    	, 0, 0, 'G', '', ''   , '', '', 'mv_par02','','','','','','','','','','','','','','','','',{"Centro de Custo. Em branco para todos."},{},{})
putSx1(cPerg, '03', 'Quantidade?'     	, '', '', 'mv_ch3', 'N', 2     	, 0, 0, 'G', '', ''   , '', '', 'mv_par03','','','','','','','','','','','','','','','','',{"Quantidade de cracha por funcionario."},{},{})

return  
