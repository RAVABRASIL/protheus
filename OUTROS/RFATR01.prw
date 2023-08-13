#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#Include 'Topconn.ch'
#include "ap5mail.ch"

***********************
User Function RFATR01()
***********************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1 := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2 := "de acordo com os parametros informados pelo usuario."
Local cDesc3 := "Clientes com Taxas Extras no Frete "
Local cPict  := ""
Local titulo := cDesc3
Local nLin   := 80

Local Cabec1        := "----------- F A T U R A M E N T O -----------  ----------------- C O N H E C I M E N T O  D E  F R E T E -----------------"
Local Cabec2        := "Nota      Cliente                              Conhecim. Data            TDE Paletizacao        TRT        TDS   Agendam."
//                     "999999999 999999/99 XXXXXXXXXXXXXXXXXXXXXXXXX  999999999 99/99/99 999,999.99  999,999.99 999,999.99 999,999.99 999,999.99"
//                      01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                                1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22

Local imprime       := .T.
Local aOrd          := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 132
Private tamanho     := "M"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "RFATR01"
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RFATR01" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString     := ""

CriaSx1(cPerg)

if pergunte(cPerg,.T.)

   wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

   If nLastKey == 27
   	Return
   Endif

   SetDefault(aReturn,cString)

   If nLastKey == 27
      Return
   Endif

   nTipo := If(aReturn[4]==1,15,18)

   RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
   
endif

Return

****************************************************
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
****************************************************

Local cQuery 	 := ""
Local lContinua := .T.
Local _nX
Local cCliente
Local cTitulo
Local cSerie
Local cParc
Local cEmissao
Local nTotal     := nTotGer := 0
Local nRecebidos := nRecAtr := 0
Local nPrzVen    := nPrzRec := nPrzAtr  := 0
Local nQtd       := 0

SetRegua(0)

cQuery := "SELECT DISTINCT "
cQuery += "   CFRETE=Z86_CONHEC, EMISSAO=Z86_DATA, CODTRAN=Z86_FORNEC, LOJTRAN=Z86_LOJA, NOMTRAN=A2_NOME, NFISCAL=Z87_NOTA, "
cQuery += "   CODCLI=A1_COD, LOJCLI=A1_LOJA, NOMCLI=A1_NOME, TDE=Z86_TDE, PALET=Z86_PALETI, "
cQuery += "   TRT=Z86_TRT, TDS=Z86_TDS, AGENDA=Z86_AGENDA "
cQuery += "FROM "
cQuery += "   "+RetSqlname("Z86")+" Z86, "+RetSqlname("Z87")+" Z87, "
cQuery += "   "+RetSqlname("SF2")+" SF2, "+RetSqlname("SA1")+" SA1, "
cQuery += "   "+RetSqlname("SA2")+" SA2 "
cQuery += "WHERE "
cQuery += "   Z86_DATA BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' AND "
cQuery += "   Z86_FORNEC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
cQuery += "   A1_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND "
cQuery += "   A1_LOJA BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' AND "
cQuery += "   Z86_CONHEC = Z87_CODCON AND "
cQuery += "   ( Z86_TDE > 0 OR Z86_PALETI > 0 OR Z86_TRT > 0 OR "
cQuery += "     Z86_TDS > 0 OR Z86_AGENDA > 0 ) AND "
cQuery += "   Z86_FORNEC = A2_COD AND Z86_LOJA = A2_LOJA AND "
cQuery += "   SF2.F2_DOC = Z87.Z87_NOTA AND A1_COD = F2_CLIENTE AND "
cQuery += "   A1_LOJA = F2_LOJA AND "
cQuery += "   Z86.D_E_L_E_T_ <> '*' AND Z87.D_E_L_E_T_ <> '*' AND "
cQuery += "   SF2.D_E_L_E_T_ <> '*' AND SA1.D_E_L_E_T_ <> '*' AND "
cQuery += "   SA2.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY "
cQuery += "   Z86_FORNEC, Z86_DATA "

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

TCSetField('TMP','EMISSAO','D')

TMP->(DbGoTop())

while TMP->(!Eof())
   if lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      exit
   endif

   if nLin > 55
      nLin := Cabec(Titulo,Cabec1,Cabec2,wnRel,Tamanho,nTipo)+1
   endif

   cTransp := TMP->CODTRAN
   @nLin,00 PSAY TMP->(CODTRAN+" - "+NOMTRAN); nLin++   
   @nLin,00 PSAY Replicate("-", limite ); nLin++      

   while !TMP->(Eof()) .and. cTransp == TMP->CODTRAN

      if nLin > 55
         nLin := Cabec(Titulo,Cabec1,Cabec2,wnRel,Tamanho,nTipo)+1
         @nLin,00 PSAY TMP->(CODTRAN+" - "+NOMTRAN); nLin++   
         @nLin,00 PSAY Replicate("-", limite ); nLin++               
      endif
      
      @nLin,000 PSAY TMP->NFISCAL
      @nLin,010 PSAY Left(TMP->CODCLI+"/"+TMP->LOJCLI+" "+TMP->NOMCLI,35)
      @nLin,048 PSAY TMP->CFRETE
      @nLin,058 PSAY DtoC(TMP->EMISSAO)
      @nLin,067 PSAY Transform(TMP->TDE   , "@E 999,999.99" )
      @nLin,079 PSAY Transform(TMP->PALET , "@E 999,999.99" )
      @nLin,090 PSAY Transform(TMP->TRT   , "@E 999,999.99" )
      @nLin,101 PSAY Transform(TMP->TDS   , "@E 999,999.99" )
      @nLin,111 PSAY Transform(TMP->AGENDA, "@E 999,999.99" )                        
      nLin++         
      
      TMP->(DbSkip())          
      if cTransp <> TMP->CODTRAN
         nLin++; nLin++               
      endif
   end
end

TMP->(dbCloseArea())


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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


//+-----------------------------------------------------------------------------------------------+
//! Função para criação das perguntas (se não existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
******************************
static function criaSX1(cPerg)
******************************

putSx1(cPerg, '01', 'Data De       ?','','','mv_ch1', 'D', 8, 0, 0, 'G', '', '', '', '', 'mv_par01','','','','','','','','','','','','','','','','',{"Data inicial."},{},{})
putSx1(cPerg, '02', 'Data Ate      ?','','','mv_ch2', 'D', 8, 0, 0, 'G', '', '', '', '', 'mv_par02','','','','','','','','','','','','','','','','',{"Data final."},{},{})
putSx1(cPerg, '03', 'Transp. De    ?','','','mv_ch3', 'C', 6, 0, 0, 'G', '', '', '', '', 'mv_par03','','','','','','','','','','','','','','','','',{"Transp. Inicial"},{},{})
putSx1(cPerg, '04', 'Transp. Ate   ?','','','mv_ch4', 'C', 6, 0, 0, 'G', '', '', '', '', 'mv_par04','','','','','','','','','','','','','','','','',{"Transp. final."},{},{})
putSx1(cPerg, '05', 'Cliente De    ?','','','mv_ch5', 'C', 6, 0, 0, 'C', '', '', '', '', 'mv_par05','','','','','','','','','','','','','','','','',{"Cliente inicial."},{},{})
putSx1(cPerg, '06', 'Cliente Ate   ?','','','mv_ch6', 'C', 6, 0, 0, 'G', '', '', '', '', 'mv_par06','','','','','','','','','','','','','','','','',{"Cliente final."},{},{})
putSx1(cPerg, '07', 'Loja De       ?','','','mv_ch7', 'C', 2, 0, 0, 'G', '', '', '', '', 'mv_par07','','','','','','','','','','','','','','','','',{"Loja inicial."},{},{})
putSx1(cPerg, '08', 'Loja Ate      ?','','','mv_ch8', 'C', 2, 0, 0, 'G', '', '', '', '', 'mv_par08','','','','','','','','','','','','','','','','',{"Loja final."},{},{})

Return