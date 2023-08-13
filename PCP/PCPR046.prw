#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPCPR046   บ Autor ณ AP6 IDE            บ Data ณ  01/07/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
***********************
User Function PCPR046()
***********************

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Analise de Sobrepeso"
Local cPict          := ""
Local titulo         := "Analise de Sobrepeso"
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "PCPR046" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PCPR046" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg        := "PCPR46"
Private cString      := ""

Private cTURNO1   := GetMv("MV_TURNO1")
Private cTURNO2   := GetMv("MV_TURNO2")
Private cTURNO3   := GetMv("MV_TURNO3")

Private _aExcel:={}
Private _aCab:={"LINHA","SUBLINHA","CODIGO","PESO REAL","PESO PADRAO","% Dif"}


hora1:=Left(cTURNO1,5)
hora2:=Left(cTURNO2,5)
hora3:=Left(cTURNO3,5)



oPerg1()

Pergunte(cPerg,.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

titulo += " - "+MesExtenso(MV_PAR01)+" de "+Alltrim(Str(MV_PAR02))

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  01/07/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
****************************************************
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
****************************************************

Local cQuery
Local cIni
Local cFim
Local nTotP := nTotR := 0

_cDtDia:=" "

for _nX := 1 to 2
	If Select("Z00X") > 0
		Z00X->(dbCloseArea())
	EndIf
	
	if _nX = 1
      if LastDay(Ctod("01/"+StrZero(MV_PAR01,2)+"/"+Str(MV_PAR02))) < dDataBase
         cIni  := DtoS(LastDay(Ctod("01/"+StrZero(MV_PAR01,2)+"/"+Str(MV_PAR02))))         
         cFim  := DtoS(LastDay(Ctod("01/"+StrZero(MV_PAR01,2)+"/"+Str(MV_PAR02)))+1)         
      else
         cIni  := DtoS(dDataBase-1)
         cFim  := DtoS(dDataBase)
      endif     
   else
      cIni  := DtoS(CtoD("01/"+StrZero(MV_PAR01,2)+"/"+Str(MV_PAR02)))
      cFim  := DtoS(LastDay(Ctod("01/"+StrZero(MV_PAR01,2)+"/"+Str(MV_PAR02)))+1)
   endif

   nTotP := nTotR := 0
	
	cQuery := "SELECT "
    If MV_PAR03=2
       cQuery += "   CODIGO, "
    Endif
	cQuery += "   LINHA, "
	cQuery += "   SUBLINHA, "
	cQuery += "   PESOR, "
	cQuery += "   PESOP, "
	cQuery += "   PDIF=((PESOR-PESOP)/PESOP)*100 "
	cQuery += "FROM "
	cQuery += "( "
	cQuery += "SELECT  "
    If MV_PAR03=2
       cQuery += "   B1_COD CODIGO, "
    Endif	
	cQuery += " LINHA =CASE "
	cQuery += "  WHEN B1_GRUPO IN('D','E')     THEN '2-DOMESTICA' "
	cQuery += "  WHEN B1_GRUPO IN('A','B','G') THEN '1-INSTITUCIONAL' "
	cQuery += "  WHEN B1_GRUPO IN('C')         THEN '3-HOSPITALAR' "
	cQuery += "  ELSE BM_DESC "
	cQuery += "END, "
	cQuery += "SUBLINHA = "
	cQuery += "  CASE "
	cQuery += "     WHEN B1_SETOR IN ('05','37','40') THEN 'Hamper Fita' "
	cQuery += "     WHEN B1_SETOR IN ('56')           THEN 'Hamper Cordใo' "
	cQuery += "     WHEN B1_SETOR IN ('08','09','10','11','12','13','14','30','34','35','36','41','55') THEN 'Infectantes' "
	cQuery += "     WHEN B1_SETOR IN ('06','54','98') THEN 'Obitos' "
	cQuery += "     WHEN B1_SETOR IN ('23','26')      THEN 'Pacote' "
	cQuery += "     WHEN B1_SETOR IN ('24','25','27','28') THEN 'Rolo' "
	cQuery += "     ELSE 'Institucional' "
	cQuery += "END, "
	cQuery += "PESOR = ISNULL(SUM(Z00.Z00_PESO+Z00_PESCAP),0), "
	cQuery += "PESOP = ISNULL(SUM((Z00.Z00_QUANT/SB5.B5_QE2)*B1_PESO),0), "
	cQuery += "QUANT = ISNULL(SUM(Z00.Z00_QUANT/SB5.B5_QE2),0) "
	cQuery += "FROM "+RetSqlName("Z00")+" Z00, "+RetSqlName("SB1")+" SB1, "+RetSqlName("SBM")+" SBM, "+RetSqlName("SB5")+" SB5 "
	cQuery += "WHERE Z00_FILIAL = '"+xFilial("Z00")+"' AND B1_COD = Z00_CODIGO AND SB1.B1_GRUPO = SBM.BM_GRUPO AND SBM.BM_FILIAL = '01' AND "
	cQuery += "SBM.BM_GRUPO <= 'G' AND "//Somente Grupos dos PAs
//	cQuery += "Z00_DATHOR BETWEEN '"+cIni+"05:35' AND '"+cFim+"05:34' AND "
	cQuery += "Z00_DATHOR >= '"+cIni+hora1+"' AND Z00_DATHOR < '"+cFim+hora1+"'  AND "
	cQuery += "SUBSTRING(Z00.Z00_MAQ,1,2) IN ('C0','C1','P0','S0') AND B5_COD = B1_COD AND "
	cQuery += " Z00.Z00_APARA = ' ' AND Z00.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*' AND SBM.D_E_L_E_T_ <> '*' AND SB5.D_E_L_E_T_ <> '*' "
	cQuery += "GROUP BY "
    If MV_PAR03=2
       cQuery += "   B1_COD, "
    Endif	
	cQuery += "CASE "
	cQuery += "   WHEN B1_GRUPO IN('D','E')     THEN '2-DOMESTICA' "
	cQuery += "   WHEN B1_GRUPO IN('A','B','G') THEN '1-INSTITUCIONAL' "
	cQuery += "   WHEN B1_GRUPO IN('C')         THEN '3-HOSPITALAR' "
	cQuery += "   ELSE BM_DESC  "
	cQuery += "END, "
	cQuery += "CASE "
	cQuery += "   WHEN B1_SETOR IN ('05','37','40') THEN 'Hamper Fita' "
	cQuery += "   WHEN B1_SETOR IN ('56')           THEN 'Hamper Cordใo' "
	cQuery += "   WHEN B1_SETOR IN ('08','09','10','11','12','13','14','30','34','35','36','41','55') THEN 'Infectantes' "
	cQuery += "   WHEN B1_SETOR IN ('06','54','98') THEN 'Obitos' "
	cQuery += "   WHEN B1_SETOR IN ('23','26')      THEN 'Pacote' "
	cQuery += "   WHEN B1_SETOR IN ('24','25','27','28') THEN 'Rolo' "
	cQuery += "   ELSE 'Institucional' "
	cQuery += "END "
	cQuery += ") AS PESAGEM "
	cQuery += "ORDER BY LINHA,SUBLINHA "
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"Z00X",.T.,.T.)
	
	SetRegua(RecCount())
		
	if _nX = 1
	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   	nLin := 6
	   @nLin,00 PSAY "                         Dia: "+DtoC(StoD(cIni))             ; nLin++   		
	   _cDtDia:=cIni
	else
	   nLin++;nLin++;nLin++
	   @nLin,00 PSAY "------------------------------------------------------------"; nLin++
	   @nLin,00 PSAY "                      Acumulado no M๊s"                      ; nLin++
	   AADD(_aExcel,{"","","","","","" })
	   AADD(_aExcel,{"Acumulado do Mes","","","","","" })
	   AADD(_aExcel,{"","","","","","" })	
	   AADD(_aExcel,{"LINHA","SUBLINHA","CODIGO","PESO REAL","PESO PADRAO","% Dif"})
	endif
	@nLin,00 PSAY "------------------------------------------------------------"; nLin++
	@nLin,00 PSAY "Linha          SubLinha       Peso Real  Peso Padrao  % Dif."; nLin++
	@nLin,00 PSAY "------------------------------------------------------------"; nLin++
	
	while !Z00X->(EOF())
		cLinha := Z00X->LINHA
		@nLin,00 PSAY SUBSTR(Z00X->LINHA,3,13)
		
		while !Z00X->(EOF()) .AND. cLinha == Z00X->LINHA
			@nLin,16 PSAY Z00X->SUBLINHA
			@nLin,31 PSAY Transform( Z00X->PESOR,"@E 999,999.99")
			@nLin,43 PSAY Transform( Z00X->PESOP,"@E 999,999.99")
			@nLin,55 PSAY Transform( Z00X->PDIF, "@E 99.99" )
			nTotR += Z00X->PESOR
			nTotP += Z00X->PESOP
			nLin++
			If MV_PAR03=2 //If _nX = 1  .AND. MV_PAR03=2
			    AADD(_aExcel,{Z00X->LINHA,Z00X->SUBLINHA,Z00X->CODIGO,Transform( Z00X->PESOR,"@E 999,999.99"),Transform( Z00X->PESOP,"@E 999,999.99"),Transform( Z00X->PDIF, "@E 9999.99" ) })
			Endif
			Z00X->(dbSkip())
		enddo
	enddo
	
	if ( nTotR + nTotP ) > 0
		@nLin,00 PSAY "------------------------------------------------------------"; nLin++
		@nLin,31 PSAY Transform( nTotR,"@E 999,999.99")
		@nLin,43 PSAY Transform( nTotP,"@E 999,999.99")
		@nLin,55 PSAY Transform( ((nTotR-nTotP)/nTotP)*100, "@E 99.99" )
		If MV_PAR03=2 //If _nX = 1.AND. MV_PAR03=2
		    AADD(_aExcel,{"","","",Transform( nTotR,"@E 999,999.99"),Transform( nTotP,"@E 999,999.99"),Transform( ((nTotR-nTotP)/nTotP)*100, "@E 9999.99" ) })		    
		Endif

	endif
	
	if Select("Z00X") > 0
		Z00X->(dbCloseArea())
	endif
next _nX

If MV_PAR03=2
	MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({{"ARRAY","Dia: "+DtoC(StoD(_cDtDia)), _aCab , _aExcel}})})
	If !ApOleClient("MSExcel")
	    MsgAlert("Microsoft Excel nใo instalado!")
		Return()
	EndIf
EndIf


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If MV_PAR03<>2
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
Endif

MS_FLUSH()

Return


/*ฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
Function  ณ oPerg1() - Cria grupo de Perguntas.
ฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
Static Function oPerg1()

Local aHelpPor := {}

PutSx1( cPerg,'01','M๊s (MM)  ?','','','mv_ch1','N',2,0,0,'G','','','','','mv_par01','','','','','','','','','','','','','','','','',aHelpPor,{},{} )
PutSx1( cPerg,'02','Ano (AAAA)?','','','mv_ch2','N',4,0,0,'G','','','','','mv_par02','','','','','','','','','','','','','','','','',aHelpPor,{},{} )

Return

***************************
Static Function Scheddef() 
***************************
Local aParam
Local aOrd     := {}

aParam := { "R",;      // Tipo R para relatorio P para processo   
            "PCPR46",; // Pergunte do relatorio, caso nao use passar ParamDef            
            "",;       // Alias            
            aOrd,;     // Array de ordens   
            "PCPR046 SchedDef"}    
Return aParam