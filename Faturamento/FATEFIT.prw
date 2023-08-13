#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO2     บ Autor ณ AP6 IDE            บ Data ณ  06/11/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function FATEFIT()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Efici๊ncia da produ็ใo com rela็ใo ao faturamento"
Local cPict          := ""
Local titulo         := ""
Local nLin           := 80
Local Cabec1         := "Periodo         Percentual%   N. Notas"
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "FATEFIT" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATEFIT" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := ""
Pergunte("FATEFI",.T.)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
titulo := "De:"+dtoc(mv_par01)+" Ate:"+dtoc(mv_par02)
wnrel := SetPrint(cString,NomeProg,"FATEFI",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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

Local aNotas := { {0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0} }
Local cQuery := ""
Local nTotal := nCount := nIdx   := nDias  := nDiasC := 0
Local aEntrg :={}

cQuery := "select distinct C9_NFISCAL, C5_ENTREG, F2_EMISSAO, F2_DTEXP, C9_DATALIB, C6_CROSSDO, "
cQuery += "DATALIB=ISNULL((SELECT TOP 1 ZB3_DATALI FROM ZB3020 ZB3 WHERE ZB3_PEDIDO = SC5.C5_NUM AND ZB3.D_E_L_E_T_ = '' ORDER BY ZB3_DATALI), C9_DATALIB) "
cQuery += "from  "+retSqlName("SF2")+" SF2, "+retSqlName("SD2")+" SD2, "+retSqlName("SF4")+" SF4, "+retSqlName("SC5")+" SC5, "+retSqlName("SC9")+" SC9, "+retSqlName("SC6")+" SC6 "
cQuery += "where F2_FILIAL = D2_FILIAL "
cQuery += "and C5_FILIAL = C9_FILIAL "
cQuery += "and F2_FILIAL = C9_FILIAL "
cQuery += "and F4_FILIAL = '"+xFilial('SF4')+"' "
cQuery += "and F2_EMISSAO between '"+dtos(mv_par01)+"' and '"+dtos(mv_par02)+"' " 
cQuery += "and D2_DOC = F2_DOC AND C5_NUM = C6_NUM " 
cQuery += "and F4_CODIGO = D2_TES AND F2_DTEXP <> '' AND C5_EMISSAO = C5_ENTREG "
cQuery += "and C9_NFISCAL =F2_DOC "
cQuery += "AND C5_NUM=C9_PEDIDO  "
cQuery += "and F4_DUPLIC = 'S' "
cQuery += "and F2_TIPO = 'N' "

If mv_par05 = 2 
	cQuery += " AND F2_FILIAL = '" + xFilial("SF2") + "' "
EndIf	

If !Empty(mv_par04) 
	cQuery += " AND F2_VEND1 = '" + mv_par04 + "' "
EndIf	

cQuery += "AND RTRIM(D2_COD) NOT IN ('187','188','189','190')  "
cQuery += "AND RTRIM(D2_CF) IN ( '511','5101','5107','611','6101','512','5102','612','6102','6109','6107','5949 ','6949' )  "
cQuery += "and SF2.D_E_L_E_T_ != '*' "
cQuery += "and SD2.D_E_L_E_T_ != '*' "
cQuery += "and SF4.D_E_L_E_T_ != '*' "
cQuery += "and SC5.D_E_L_E_T_ != '*' "
cQuery += "order by C9_NFISCAL "

TCQUERY cQuery NEW ALIAS "_TMPZ"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SetRegua(0)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Posicionamento do primeiro registro e loop principal. Pode-se criar ณ
//ณ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ณ
//ณ cessa enquanto a filial do registro for a filial corrente. Por exem ณ
//ณ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ณ
//ณ                                                                     ณ
//ณ dbSeek(xFilial())                                                   ณ
//ณ While !EOF() .And. xFilial() == A1_FILIAL                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_TMPZ->( dbGoTop() )
Do While _TMPZ->( !EOF() )

**************************************************
//Parte Modificada
***************************************************	
	IF (_TMPZ->C6_CROSSDO) = 'S'
	  	nDiasC++ //:= stod(_TMPZ->C9_DATALIB) - stod(_TMPZ->C5_ENTREG)
	ELSE
		IF MV_PAR03 = 1
			nDias := stod(_TMPZ->F2_DTEXP) - stod(_TMPZ->C5_ENTREG)
	    Else
	    	nDias := stod(_TMPZ->F2_DTEXP) - stod(_TMPZ->DATALIB)
	    Endif
	    Do Case
		    Case nDias < 0
		   		nIdx:=  1
		   	Case nDias >= 0 .and. nDias <= 2//nDias == 0  .or. nDias == 2
		    	nIdx := 2
		   	Case nDias >= 3 .and. nDias <= 4//nDias == 3  .or. nDias == 4
		    	nIdx := 3
		   	Case nDias >= 5 .and. nDias <= 10//nDias == 5  .or. nDias == 10
		    	nIdx := 4
		   	Case nDias >= 11 .and. nDias <= 15//nDias == 11 .or. nDias == 15
		    	nIdx := 5
		   	Case nDias >= 16 .and. nDias <= 25//nDias == 16 .or. nDias == 25
		    	nIdx := 6
		   	Case nDias >= 26 .and. nDias <= 45//nDias == 26 .or. nDias == 45
		    	nIdx := 7
		   	Case nDias >= 46 .and. nDias <= 60//nDias == 46 .or. nDias == 60
		      	nIdx := 8   	
		   	
		   	//Colocado em 17/11/2008 a pedido de Marcelo 
		   	Case nDias > 60 
		      	nIdx := 9
		   	//		   
		EndCase		   
	
	ENDIF
	
		if nIdx > 0
				aNotas[nIdx][1]++
				nCount++
		endIf
			nIdx := -1
			_TMPZ->( dbSkip() )
			incRegua()
			
	
endDo
_TMPZ->( dbCloseArea() )
setRegua( len(aNotas) * 2 )
for _k := 1 to len(aNotas)
	aNotas[_k][2] := (aNotas[_k][1]/nCount) * 100
	incRegua()
next
for _z := 1 to len(aNotas)

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

   If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
	   	If !Empty(mv_par04) 
	   		@nLin,05 PSAY Posicione("SA3",1,xFilial("SA3") + mv_par04, "A3_NREDUZ" )
	   		nLin := nLin + 1
	   	EndIf	
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   @nLin,00 PSAY iif(_z==1,"Antecipado",;
                 iif(_z==2,"De 0  a 2  dias",;
                 iif(_z==3,"De 3  a 4  dias",;
                 iif(_z==4,"De 5  a 10 dias",;
                 iif(_z==5,"De 11 a 15 dias",;
                 iif(_z==6,"De 16 a 25 dias",;
                 iif(_z==7,"De 26 a 45 dias",;
                 iif(_z==8,"De 46 a 60 dias",">= 61 Dias" ) ) ) ) ) ) ) )   
   @nLin,23 PSAY transform( aNotas[_z][2], "@E 999" )+" %"
   @nLin,31 PSAY transform( aNotas[_z][1], "@E 999,999" )
   nTotal += aNotas[_z][1]
   nLin := nLin + 1

   incRegua()
Next

@nLin,00 PSAY replicate("-",38)
nLin++
@nLin,25 PSAY "Total:"+transform( nTotal, "@E 999,999" )
nLin++
@nLin,25 PSAY "Cross:"+transform( nDiasC, "@E 999,999" )
nLin++

IF MV_PAR03 = 1
	@nLin,25 PSAY "PELA PREVISรO DE FATURAMENTO"
ELSE
	@nLin,25 PSAY "APำS LIBERAวรO CREDITO"
ENDIF

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
