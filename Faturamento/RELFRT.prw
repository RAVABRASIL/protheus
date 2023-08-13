#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO3     บ Autor ณ AP6 IDE            บ Data ณ  19/02/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RELFRT


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relacao Frete por NF"
Local cPict          := ""
Local titulo       	:= "Relacao Frete por NF"
Local nLin         	:= 80
Local Cabec1       	:= "   N.F.   / Serie  -  Transportadora"
Local Cabec2       	:= "   Valor N.F. | Peso Bruto | Frete Peso | Tx Fixa | Ad-Valorem | ADM  | Pedagio | Suframa | Valor Frete | Valor c/Icm | UF | Perc"
Local imprime      	:= .T.
Local aOrd 				:= {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "RELFRT" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "RELFRT" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 		:= ""
Private cQuery 		:= ""

//dbSelectArea("")
//dbSetOrder(1)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

pergunte( "RELFRT", .T. )
wnrel := SetPrint(cString,NomeProg,"RELFRT",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
//                       10        20        30        40        50        60        70        80        90        100       110       120       130       140
//         		 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  19/02/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

Local peso_calc	:= 0
Local peso_fin		:= 0
Local tx_fix		:= 0  
Local valorem		:= 0
Local pedagio		:= 0
Local suframa		:= 0
Local valicm		:= 0
Local total			:= 0
Local total_fin	:= 0
Local v_cod			:= { 07, 09, 20, 59, 94, 46}
Local suf_city    := { "AC", "AP", "AM", "RO", "RR"}

//dbSelectArea(cString)
//dbSetOrder(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetRegua(RecCount())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Posicionamento do primeiro registro e loop principal. Pode-se criar ณ
//ณ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ณ
//ณ cessa enquanto a filial do registro for a filial corrente. Por exem ณ
//ณ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ณ
//ณ                                                                     ณ
//ณ dbSeek(xFilial())                                                   ณ
//ณ While !EOF() .And. xFilial() == A1_FILIAL                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

dbGoTop()
While !EOF()

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Verifica o cancelamento pelo usuario...                             ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Impressao do cabecalho do relatorio. . .                            ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   // @nLin,00 PSAY SA1->A1_COD

   nLin := nLin + 1 // Avanca a linha de impressao
  
	if ( alltrim( MV_PAR01 ) != "" )
		cQuery := "SELECT F2.F2_TRANSP, F2.F2_DOC, F2.F2_SERIE, F2.F2_VALBRUT, F2.F2_PBRUTO, F2.F2_PLIQUI, F2.F2_LOCALIZ, F2.F2_EST "
		cQuery += "from " + RetSqlName( "SF2" ) + " F2 " 
		cQuery += "where F2_DOC = '" + alltrim( MV_PAR01 ) + "' ORDER BY F2.F2_DOC"
	elseif (( alltrim(dtos(MV_PAR02)) != "" ) .and. ( alltrim(dtos(MV_PAR03)) != "" ) .and. ( alltrim(MV_PAR04) != "" ))
		cQuery := "SELECT F2.F2_TRANSP, F2.F2_DOC, F2.F2_SERIE, F2.F2_VALBRUT, F2.F2_PBRUTO, F2.F2_PLIQUI, F2.F2_LOCALIZ, F2.F2_EST "
		cQuery += "from " + RetSqlName( "SF2" ) + " F2 " 
		cQuery += "where F2_EMISSAO >= '" + dtos( MV_PAR02 ) + "' and F2_EMISSAO <= '" + dtos( MV_PAR03 ) + "' and F2_TRANSP = '" + alltrim( MV_PAR04 ) + "' ORDER BY F2.F2_DOC"
	elseif (( alltrim(MV_PAR04) != "" ) .and. ( alltrim(MV_PAR05) != "" ) .and. ( alltrim(MV_PAR06) != "" ))
		cQuery := "SELECT F2.F2_TRANSP, F2.F2_DOC, F2.F2_SERIE, F2.F2_VALBRUT, F2.F2_PBRUTO, F2.F2_PLIQUI, F2.F2_LOCALIZ, F2.F2_EST "
		cQuery += "from " + RetSqlName( "SF2" ) + " F2 " 
		cQuery += "where F2_DOC >= '" + alltrim( MV_PAR05 ) + "' and F2_DOC <= '" + alltrim( MV_PAR06 ) + "' and F2_TRANSP = '" + alltrim( MV_PAR04 ) + "' ORDER BY F2.F2_DOC"
	endif
	TCQUERY cQuery NEW ALIAS "F2X"
 	
 	While (F2X->( !eof() ))
	
		If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
   	   nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
	   Endif
	
		cQuery := "SELECT A4.A4_KG_MIN, A4.A4_FREMINC, A4.A4_TXFIXA, A4.A4_VOLTXF2, A4.A4_TXFIXA2, A4.A4_TXFIXAI, A4.A4_COD, A4.A4_ICMS, A4.A4_NOME, A4.A4_FREMINC, A4.A4_FREMINI "
	 	cQuery += "FROM " + RetSqlName( "SA4" ) + " A4 "
	 	cQuery += "WHERE A4_COD = '" + alltrim(F2X->F2_TRANSP) + "'"
	 	TCQUERY cQuery NEW ALIAS "A4X"
	 	
		cQuery := "SELECT TOP 1 ZZ.ZZ_ADM, ZZ.ZZ_PEDAGIO, ZZ.ZZ_SUFRAMA, ZZ.ZZ_TIPO, ZZ.ZZ_LOCAL, ZZ.ZZ_ADVALOR, ZZ.ZZ_FR_PESO "
		cQuery += "FROM " + RetSqlName( "SZZ" ) + " ZZ "
		cQuery += "WHERE ZZ_FILIAL='"+XFILIAL('SZZ')+"' AND ZZ_TRANSP = '" + alltrim(F2X->F2_TRANSP) + "' AND ZZ_LOCAL = '" + alltrim(F2X->F2_LOCALIZ) + "' ORDER BY ZZ_PEDAGIO DESC"	
		TCQUERY cQuery NEW ALIAS "ZZX"
	
	 	peso_calc := peso_fin := tx_fix := valorem := pedagio	:= suframa := valicm	:= total	:= total_fin := 0
	 	
		//Peso Calc
		if ( F2X->F2_PLIQUI >= A4X->A4_KG_MIN ) 
		   peso_calc := F2X->F2_PLIQUI
		else     
			peso_calc  := A4X->A4_KG_MIN
		endIf
		
		//Peso Frete 	
		peso_fin := peso_calc * ZZX->ZZ_FR_PESO
		
		//Tx Fixa
		If ( alltrim(ZZX->ZZ_TIPO) == "C")
			if ( alltrim(ZZX->ZZ_LOCAL) == "07" .and. alltrim(A4X->A4_COD) == "03" .or. alltrim(F2X->F2_EST) == "SP" .and. alltrim(A4X->A4_COD) == "20" )
				tx_fixa := A4X->A4_TXFIXA2
			else
				if ( alltrim(A4X->A4_VOLTXF2) != "" .and. alltrim(F2X->F2_VOLUME1) >= alltrim(A4X->A4_VOLTXF2) )
					tx_fixa := A4X->A4_TXFIXA2
				else
					tx_fixa := A4X->A4_TXFIXA
				endIf
			endif
		else
			if ascan(v_cod, alltrim(ZZX->ZZ_LOCAL) )!= 0 .and. alltrim(A4X->A4_COD) == "3" .or. alltrim(F2X->F2_EST) == "SP" .and. alltrim(A4X->A4_COD) == "20"
				tx_fixa := A4X->A4_TXFIXA2
			else
				tx_fixa := A4X->A4_TXFIXA		
			endIf
		endIf
		 	                
		//Ad-Valorem 
		If ( alltrim(A4X->A4_COD) == "03" .and. ascan( v_cod, alltrim(ZZX->ZZ_LOCAL) ))
			valorem := ( F2X->F2_VALBRUT * 0,3 ) / 100
		else
			valorem := ( F2X->F2_VALBRUT * ZZX->ZZ_ADVALOR ) / 100
		endIf
		
		//Pedagio
		pedagio := F2X->F2_PLIQUI / 100
		pedagio := pedagio + 0.5
		pedagio := pedagio * ZZX->ZZ_PEDAGIO
		
		//Suframa
		If (ascan( suf_city, alltrim(F2X->F2_EST)) != 0)
			suframa = F2X->F2_VALBRUT * ZZX->ZZ_SUFRAMA
			suframa = suframa / 100
		else
			suframa = ZZX->ZZ_SUFRAMA
		endIf 
	
		//Val Frete    
		total_fin = round( peso_fin, 2 ) + round( tx_fixa, 2 ) + valorem + round( ZZX->ZZ_ADM, 2 ) + (( round(( F2X->F2_PLIQUI + 0.5 ), 0 ) / 100 )*ZZX->ZZ_PEDAGIO ) + suframa
		if ( ZZX->ZZ_TIPO == "C" )
			if ( A4X->A4_FREMINC > total )
				total := A4_FREMINC
			else
				total := total_fin
			endIf
		else
			if ( A4X->A4_FREMINI > total)
				total := A4X->A4_FREMINI
			else
				total := total_fin
			endIf
		endIf
		
		//Val c/Icm
		valicm = ( 100 - A4X->A4_ICMS )/100
		valicm = total_fin / valicm;
	   
		//Impressao       "   008473 / UNI    -  OPA
  		@nLin++,00 PSAY   "   " + F2X->F2_DOC + " / " + alltrim( F2X->F2_SERIE ) + "    -  " + A4X->A4_NOME
			//                       10        20        30        40        50        60        70        80        90        100       110       120       130       140
			//         		 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
							  //   999,999.99 | 999,999.99 | 999,999.99 | 99999,9 | 999.999,99 | 9.99 | 9999.99 | 9999.99 | 9999,999.99 | 9999,999.99 | 99 | 99.99
		@nLin,00 PSAY     "   " + Transform( F2X->F2_VALBRUT,"@E 999,999.99" ) + "   " + Transform( F2X->F2_PBRUTO,"@E 999,999.99" ) + "   " + Transform( peso_fin, "@E 999,999.99" ) + "   " + Transform( tx_fixa,"@E 99999.9" ) + "   " + Transform( valorem,"@E 999,999.99" ) + "   " + Transform( ZZX->ZZ_ADM,"@E 9.99" ) + "   " + Transform( pedagio, "@E 9999.99" ) + "   " + Transform( suframa, "@E 9999.99" ) + "   " + Transform( total, "@E 9999,999.99" ) + "   " + Transform( valicm, "@E 9999,999.99" ) + "   " + alltrim( F2X->F2_EST ) + "   " + Transform((valicm * 100) / F2X->F2_VALBRUT, "@E 99.99")
		nLin := nLin + 2	
  
		F2X->( DBSkip() )
		ZZX->( DbCloseArea() )
		A4X->( DbCloseArea() )
	endDo
	F2X->( DbCloseArea() )
   //dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

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