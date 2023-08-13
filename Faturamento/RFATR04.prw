#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"

***********************
User Function RFATR04()
***********************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1 := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2 := "de acordo com os parametros informados pelo usuario."
Local cDesc3 := "Ligacoes efetuadas por Gerente "
Local cPict  := ""
Local titulo := "Lig. Gerente: "
Local nLin   := 80

Local Cabec1        := "Representante"
Local Cabec2        := "Data      Hora      Duracao   Telefone      "
//                     "99/99/99  99:99:99  99:99:99  (99)99999-9999"
//                      01234567890123456789012345678901234567890123
//                                1         2         3         4  

Local imprime       := .T.
Local aOrd          := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 80
Private tamanho     := "P"
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "RFATR04"
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RFATR04" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString     := ""

CriaSx1(cPerg)

if pergunte(cPerg,.T.)
   cGeren := Alltrim(Posicione("SA3",1,xFilial("SA3")+MV_PAR01,"A3_NOME"))
   titulo += Left(cGeren, if(at(" ",cGeren )=0,len(cGeren),at(" ",cGeren )-1 ))+" - "+DtoC(MV_PAR02)+" a "+DtoC(MV_PAR03)
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

cQuery := "SELECT "
cQuery += "   GERENT=A3_SUPER, REPRES=A3_COD, NOME=A3_NOME, DATA=ISNULL(Z53_DATA,''), "
cQuery += "   HORA=ISNULL(Z53_HORA,''), DURACAO=ISNULL(Z53_DURACA,''), TELEFONE=ISNULL(Z53_TEL,''), "
cQuery += "   UF=A3_EST "
cQuery += "FROM "
cQuery += "   "+RetSqlName("SA3")+" SA3 "
cQuery += "   LEFT JOIN "+RetSqlName("Z53")+" Z53 ON "
cQuery += "   A3_SUPER = Z53_GERENT AND "
cQuery += "   ( A3_TEL = Z53_TEL OR A3_TELCEL = Z53_TEL OR A3_CEL = Z53_TEL ) AND "
cQuery += "   Z53_DATA BETWEEN '"+DtoS(MV_PAR02)+"' AND '"+DtoS(MV_PAR03)+"' AND "
cQuery += "   Z53.D_E_L_E_T_ = ' ' "
cQuery += "WHERE "
cQuery += "   SA3.A3_SUPER = '"+MV_PAR01+"' AND "
cQuery += "   SA3.A3_ATIVO <> 'N' AND LEN(RTRIM(SA3.A3_COD)) = 4 AND "
cQuery += "   SA3.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY
cQuery += "   A3_SUPER, A3_COD, Z53_DATA, Z53_HORA   

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

TCSetField('TMP','DATA','D')

TMP->(DbGoTop())

while TMP->(!Eof())
   if lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      exit
   endif

   if nLin > 55
      nLin := Cabec(Titulo,Cabec1,Cabec2,wnRel,Tamanho,nTipo)+1
   endif

   cRep := TMP->REPRES
   @nLin,00 PSAY TMP->(REPRES+" - "+Alltrim(NOME)+" - "+NomeUF(UF)); nLin++   
   while !TMP->(Eof()) .and. cRep == TMP->REPRES

      if nLin > 55
         nLin := Cabec(Titulo,Cabec1,Cabec2,wnRel,Tamanho,nTipo)+1
         @nLin,00 PSAY Replicate("-", limite ); nLin++               
         @nLin,00 PSAY TMP->(REPRES+" - "+Alltrim(NOME)); nLin++   
      endif
    
      if !Empty(TMP->DATA)
         @nLin,000 PSAY DtoC(TMP->DATA)
         @nLin,010 PSAY TMP->HORA
         @nLin,020 PSAY TMP->DURACAO
         @nLin,030 PSAY Transform(TMP->TELEFONE, "@R (99)99999-9999")
      else
         @nLin,000 PSAY "Sem ligacoes no periodo"      
      endif
      nLin++         
      
      TMP->(DbSkip())          
      if cRep <> TMP->REPRES
         @nLin,00 PSAY Replicate("-", limite ); nLin++                     
         nLin++
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
Static Function CriaSX1(cPerg)
******************************

PutSx1( cPerg, '01', 'Gerente  ?', '', '', 'mv_ch1', 'C', 06, 0, 0, 'G', '', 'SA3', '', '', 'mv_par01', '' , '', '', '' ,'', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cPerg, '02', 'Data de  ?', '', '', 'mv_ch2', 'D', 08, 0, 0, 'G', '', ''   , '', '', 'mv_par02', '' , '', '', '' ,'', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cPerg, '03', 'Data ate ?', '', '', 'mv_ch3', 'D', 08, 0, 0, 'G', '', ''   , '', '', 'mv_par03', '' , '', '', '' ,'', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )

Return NIL


***************************
static function NomeUF(cUF)
***************************
if cUF == "AC"
   cUF += " (Acre)"
elseif cUF == "AL"
   cUF += " (Alagoas)"
elseif cUF == "AM"
   cUF += " (Amazonas)"
elseif cUF == "AP"
   cUF += " (Amapa)"
elseif cUF == "BA"
   cUF += " (Bahia)"
elseif cUF == "CE"
   cUF += " (Ceara)"
elseif cUF == "DF"
   cUF += " (Distrito Federal)"
elseif cUF == "ES"
   cUF += " (Espirito Santo)"
elseif cUF == "GO"
   cUF += " (Goias)"
elseif cUF == "MA"
   cUF += " (Maranhao)"
elseif cUF == "MG"
   cUF += " (Minas Gerais)"
elseif cUF == "MS"
   cUF += " (Mato Grosso do Sul)"
elseif cUF == "MT"
   cUF += " (Mato Grosso)"
elseif cUF == "PA"
   cUF += " (Para)"
elseif cUF == "PB"
   cUF += " (Paraiba)"
elseif cUF == "PE"
   cUF += " (Pernambuco)"
elseif cUF == "PI"
   cUF += " (Piaui)"
elseif cUF == "PR"
   cUF += " (Parana)"
elseif cUF == "RJ"
   cUF += " (Rio de Janeiro)"
elseif cUF == "RN"
   cUF += " (Rio Grande do Norte)"
elseif cUF == "RO"
   cUF += " (Rondonia)"
elseif cUF == "RR"
   cUF += " (Roraima)"
elseif cUF == "RS"
   cUF += " (Rio Grande do Sul)"
elseif cUF == "SC"
   cUF += " (Santa Catarina)"
elseif cUF == "SE"
   cUF += " (Sergipe)"
elseif cUF == "SP"
   cUF += " (Sao Paulo)"
elseif cUF == "TO"
   cUF += " (Tocantins)"
endif

return cUF