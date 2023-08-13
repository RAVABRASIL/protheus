#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH' 
#INCLUDE 'TOPCONN.CH'

User Function COMR011()

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio de Viagens Rava Embalagens"
Local cPict          := ""
Local titulo         := "Relatorio de Viagens"
Local nLin           := 80
Local Cabec1       :=   "Filial/Codigo| Fatura    |   Dt Viagem    |    Colaborador   |     Bilhete     |    Companhia    |    Val Viagem    |     Val Adianta    | Val Hotel |     Origem     |      Destino     |   Cartใo Credito  |  Economia   |"
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Public extende       := 36
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "COMR011" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "COMR011" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := ""
Private nTotalVia := 0
Private nTotalAdi := 0
Private nTotalHot := 0
Private nTotalEco := 0

 
Pergunte("COMR011",.T.)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//titulo := "De:'"+dtoc(mv_par01)+"' Ate:'"+dtoc(mv_par02)+"'"
wnrel := SetPrint(cString,NomeProg,"COMR011",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  06/11/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
***************

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local cQuery := ""
Local LF     := CHR(13) + CHR(10)
Local cEmpresa := ""


	

IF (MV_PAR03 = 2)   //filtrar pela dt. viagem

	cQuery := " SELECT Z62_FILIAL, Z62_CODIGO CODIGO, Z62_FATURA FATURA, Z62_DTVIAG DTVIAGEM, Z62_DTFAT DTFAT, Z62_DTFAT2 DTFAT2, Z62_DTFAT3 DTFAT3, Z62_DTVOLT DTVOLTA, " + LF
	cQuery += " Z62_MATRIC MATRICULA, Z62_BILHET BILHETE, Z62_COMP COMPANHIA, Z62_VALOR VALVIAGEM, " + LF
	cQuery += " Z62_VALDES ADIANTAMENTO, Z62_VALHOT HOTEL, Z62_VALLOC LOCOMOCAO, Z62_MUNORI MUNICIO, Z62_MUNDES MUNICID, " + LF 
	cQuery += " Z62_CARTAO CARTAOCRE, Z62_VALECO ECONOMIA "  + LF 
	cQuery += " FROM " + RetSqlName("Z62") + "  Z62   WHERE Z62_DTVIAG BETWEEN '" +dtos(mv_par01)+ "' AND '"+dtos(mv_par02)+ "' AND D_E_L_E_T_ = '' "  + LF
	If !Empty(MV_PAR05)
		cQuery += " and Z62_FILIAL BETWEEN '" + mv_par04 + "' AND '" + mv_par05 + "' " + LF
		titulo         := "Relatorio de Viagens - " + Dtoc(MV_PAR01) + " A " + DTOC(MV_PAR02)  //+ " -> Todas as Filiais "
	Else
		cQuery += " and Z62_FILIAL = '" + xFilial("Z62") + "' " + LF
		DBSelectArea("SM0")
		SM0->(Dbseek( SM0->M0_CODIGO + xFilial("Z62") ))
		cEmpresa := SM0->M0_FILIAL
		
		titulo         := "Relatorio de Viagens - " + Dtoc(MV_PAR01) + " A " + DTOC(MV_PAR02) + " -> " + cEmpresa
	Endif
	If !Empty(MV_PAR06)
		cQuery += " and Z62_MATRIC = '" + Alltrim(MV_PAR06) + "' " + LF
	Endif
	cQuery += " ORDER BY Z62_FILIAL, Z62_DTVIAG "

ELSE    //filtar pela data fatura

	cQuery := " SELECT Z62_FILIAL, Z62_CODIGO CODIGO, Z62_FATURA FATURA, Z62_DTVIAG DTVIAGEM, Z62_DTFAT DTFAT, Z62_DTFAT2 DTFAT2, Z62_DTFAT3 DTFAT3, Z62_DTVOLT DTVOLTA, " + LF
	cQuery += " Z62_MATRIC MATRICULA, Z62_BILHET BILHETE, Z62_COMP COMPANHIA, Z62_VALOR VALVIAGEM, " + LF
	cQuery += " Z62_VALDES ADIANTAMENTO, Z62_VALHOT HOTEL, Z62_VALLOC LOCOMOCAO, Z62_MUNORI MUNICIO, Z62_MUNDES MUNICID, "  + LF
	cQuery += " Z62_CARTAO CARTAOCRE, Z62_VALECO ECONOMIA "   + LF
	cQuery += " FROM " + RetSqlName("Z62") + " Z62 WHERE Z62_DTFAT BETWEEN '" +dtos(mv_par01)+ "' AND '"+dtos(mv_par02)+ "' AND D_E_L_E_T_ = '' " + LF
	If !Empty(MV_PAR05)
		cQuery += " and Z62_FILIAL BETWEEN '" + mv_par04 + "' AND '" + mv_par05 + "' " + LF
		titulo         := "Relatorio de Viagens - " + Dtoc(MV_PAR01) + " A " + DTOC(MV_PAR02)  //+ " -> Todas as Filiais "
	Else
		cQuery += " and Z62_FILIAL = '" + xFilial("Z62") + "' " + LF
		cQuery += " and Z62_FILIAL = '" + xFilial("Z62") + "' " + LF
		DBSelectArea("SM0")
		SM0->(Dbseek( SM0->M0_CODIGO + xFilial("Z62") ))
		cEmpresa := SM0->M0_FILIAL
		titulo         := "Relatorio de Viagens - " + Dtoc(MV_PAR01) + " A " + DTOC(MV_PAR02) + " -> " + cEmpresa
	Endif
	If !Empty(MV_PAR06)
		cQuery += " and Z62_MATRIC = '" + Alltrim(MV_PAR06) + "' " + LF
	Endif
	
	cQuery += " ORDER BY Z62_FILIAL, Z62_DTVIAG "
	
ENDIF
MemoWrite("C:\TEMP\COMR011.SQL" , cQuery )
TCQUERY cQuery NEW ALIAS "TMP1"
TcSetField("TMP1" , "DTVIAGEM" , "D")
TMP1->(DbGoTop())




While TMP1->( !EOF() ) 
   if nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
      nLin := Cabec(Titulo ,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 2
   Endif
  
      @nLin ,000  PSAY Z62_FILIAL
      @nLin ,003  PSAY CODIGO
      @nLin ,016  PSAY FATURA
      @nLin ,030  PSAY DTVIAGEM    
      @nLin ,043  PSAY fnome(MATRICULA)
      @nLin ,068  PSAY BILHETE
      @nLin ,085  PSAY COMPANHIA
      @nLin ,097  PSAY Transform(VALVIAGEM, "@E 99,999,999.99")
      @nLin ,118  PSAY Transform (ADIANTAMENTO, "@E 99,999,999.99")
      @nLin ,135  PSAY Transform (HOTEL, "@E 99,999,999.99")
      @nLin ,151  PSAY MUNICIO
      @nLin ,167  PSAY MUNICID
      @nLin ,195  PSAY IIF(CARTAOCRE='1','SIM','NAO')
     // @nLin ,195  PSAY CARTAOCRE
      @nLin ,200  PSAY Transform(ECONOMIA, "@E 99,999,999.99") 	 
      nLin++
   
	  
	  nTotalVia := VALVIAGEM + nTotalVia
	  nTotalAdi := ADIANTAMENTO + nTotalAdi
	  nTotalHot := HOTEL + nTotalHot
	  nTotalEco := ECONOMIA + nTotalEco
      
      TMP1->(DbSkip())     
EndDo
      nLin++
      nLin++
      @nLin,000 PSAY REPLICATE('.' , LIMITE)
	  nLin++
	  @nLin ,070  PSAY 'TOTAL  ->'
	  @nLin ,097  PSAY Transform(nTotalVia, "@E 99,999,999.99") 
	  @nLin ,118  PSAY Transform(nTotalAdi, "@E 99,999,999.99")
	  @nLin ,135  PSAY Transform(nTotalHot, "@E 99,999,999.99")
	  @nLin ,200  PSAY Transform(nTotalEco, "@E 99,999,999.99")
	 
TMP1->(DbCloseArea()) 


Roda(0 , "" , Tamanho)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function fnome(mat)

Local cNomeMat  := ''
Local cAuxiliar := ''

PswOrder(1)
If PswSeek(mat,.T.)
	aSolic := PswRet()
	cNomeMat := aSolic[1,4]
endif

cAuxiliar  := Rtrim(Substr(cNomeMat,1,17))

return cAuxiliar
