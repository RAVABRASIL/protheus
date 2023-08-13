#include "protheus.ch"
#include "topconn.ch"

*************

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} Canhoto
Imprime os canhotos das notas fiscais.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     18/03/2014
/*/
//------------------------------------------------------------------------------------------

User Function Canhoto()

*************
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Declaracao de variaveis utilizadas no pro§grama atraves da funcao   ³
³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
³ identificando as variaveis publicas do sistema utilizadas no codigo ³
³ Incluido pelo assistente de conversao do AP5 IDE                    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
Local cPerg	:= "CANHOT"
Private oFont01, oFont02, oFont03, oFont04, oFont05, oFont06, oFont07, oPrint

criaSx1(cPerg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Objeto que controla o tipo de Fonte        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oFont01 	:= TFont():New('Courier New',22,22,.F.,.T.,5,.T.,5,.F.,.F.)
oFont02 	:= TFont():New('Courier New',20,20,.F.,.F.,5,.T.,5,.F.,.F.)
oFont03 	:= TFont():New('Courier New',18,18,.F.,.T.,5,.T.,5,.F.,.F.)
oFont04 	:= TFont():New('Courier New',18,18,.F.,.F.,5,.T.,5,.F.,.F.)
oFont05 	:= TFont():New('Courier New',10,10,.F.,.T.,5,.T.,5,.F.,.F.)
oFont06 	:= TFont():New('Courier New',12,12,.F.,.F.,5,.T.,5,.F.,.F.)
oFont07    	:= TFont():New("Times New Roman",14,14,.F.,.F.,5,.T.,5,.F.,.F.)
oFont08    	:= TFont():New("Times New Roman",16,16,.F.,.F.,5,.T.,5,.F.,.F.)
oFont10   	:= TFont():New( "Calibri",0,-18,,.T.,0,,700,.F.,.F.,,,,,, )
oFont11   	:= TFont():New( "Calibri",0,-14,,.T.,0,,700,.F.,.F.,,,,,, )
oFont12   	:= TFont():New( "Calibri",0,-10,,.T.,0,,700,.F.,.F.,,,,,, )

If Pergunte(cPerg,.T.)
   MsAguarde( { || runReport() }, "Aguarde. . .", "Impressao dos Canhotos . . ." )
endif

return



***************

Static Function runReport()

***************
Local cCodigo
Local nLin 		:=110
Local nCol 		:=010
//Local nQtd			:= 3 //mv_par03
Local nLinCD		:= 2.5
Local nX,Ny		:= 30
Local nZ			:= 500
Local cEmpresa	:= AllTrim(SM0->M0_NOMECOM)
Local lCabec	:= .T.

dbselectArea("SF2")
dbSeek(xFilial("SF2") + mv_par01)

oPrt := TMSPrinter():new("Canhotos") 
oPrt:SetPortrait() 

oPrt:StartPage()

While SF2->(!EOF()) .AND. SF2->F2_DOC <= mv_par02 

	If lCabec
		oPrt:Say(nLin + 25,nCol + 500, "CANHOTO REFERENTE AS NOTAS FISCAIS DE EXPEDIÇÃO", oFont07, 300, , , 0 )
		oPrt:Say(nLin + 75,nCol + 500, "Da NF-e " + mv_par01 + " Até a NF-e " + mv_par02 , oFont07, 300, , , 0 )
		oPrt:Line(nLin + 180,nCol,nLin + 180,2250) //Divisa
		nLin 	+= 200
	EndIf
	
	oPrt:Box(nLin      ,nCol      ,nLin + 250,2250) //Geral
	oPrt:Say(nLin + 015,nCol + 010, "RECEBEMOS DE " + cEmpresa + " OS PRODUTOS CONSTANTES DA NOTA FISCAL INDICADA AO LADO", oFont05, 300, , , 0 )

	oPrt:Box(nLin + 060,nCol      ,nLin + 60,1900)
	oPrt:Box(nLin + 060,nCol      ,nLin + 250,500)
	oPrt:Say(nLin + 070,nCol + 010, "DATA DE RECEBIMENTO", oFont05, 300, , , 0 )

	oPrt:Box(nLin      ,nCol + 1900,nLin + 250,2250)
	oPrt:Say(nLin + 070,nCol + 510, "IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR", oFont05, 300, , , 0 )

	oPrt:Box(nLin + 120,nCol + 1700,nLin + 120,1900)
	oPrt:Say(nLin + 110,nCol + 1710, "REEBIMENTO", oFont05, 300, , , 0 )
	oPrt:Box(nLin + 130,nCol + 1600,nLin + 180,1650)
	oPrt:Say(nLin + 150,nCol + 1750, "NF-e ", oFont05, 300, , , 0 )
	oPrt:Box(nLin + 190,nCol + 1600,nLin + 240,1650)
	oPrt:Say(nLin + 190,nCol + 1750, "FATURA", oFont05, 300, , , 0 )

	oPrt:Box(nLin + 120,nCol      ,nLin + 120,1900)
	oPrt:Say(nLin + 015,nCol + 2050, "NF-e", oFont06, 300, , , 0 )
	oPrt:Say(nLin + 100,nCol + 2000, "N. "+SF2->F2_DOC, oFont06, 300, , , 0 )
	oPrt:Say(nLin + 150,nCol + 2000, "SÉRIE "+SF2->F2_SERIE, oFont06, 300, , , 0 )

	SF2->(dbSkip())

	nLin 	+= 300
	lCabec	:= .F.
	
	If nLin > 3000
		oPrt:EndPage()
		oPrt:StartPage()
		nLin 		:=110
		nCol 		:=010
		lCabec	:= .T.
	EndIf
	
EndDo

oPrt:EndPage()
oPrt:Preview()

return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação das perguntas (se não existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
static function criaSX1(cPerg)

putSx1(cPerg, '01', 'Da Nota?'     	, '', '', 'mv_ch1', 'C', 9     	, 0, 0, 'G', '', ''   , '', '', 'mv_par01','','','','','','','','','','','','','','','','',{"Número inicial da NF."},{},{})
putSx1(cPerg, '02', 'Até Nota?' 	, '', '', 'mv_ch2', 'C', 9    	, 0, 0, 'G', '', ''   , '', '', 'mv_par02','','','','','','','','','','','','','','','','',{"Número final da NF."},{},{})
//putSx1(cPerg, '02', 'Até Nota?' 	, '', '', 'mv_ch2', 'C', 9    	, 0, 0, 'G', '', ''   , '', '', 'mv_par02','','','','','','','','','','','','','','','','',{"Número final da NF."},{},{})

return  
