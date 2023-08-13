#include "rwmake.ch"
#INCLUDE "Topconn.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTMKR009                               บ Data ณ  03/06/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relat๓rio de Ocorr๊ncias do Call Center                    บฑฑ
ฑฑบAutoria   ณ Flแvia Rocha                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LOGอSTICA                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
                                                                                                          							
User Function TMKR009()	


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "indentifica็ใo de problemas CallCenter LOGอSTICA"
Local cPict          := ""
Local titulo         := "Indentifica็ใo de Problemas CallCenter - DEPTO. LOGอSTICA"
Local nLin           := 80
                      //         10        20        30        40        50        60        70        80        90        100       110       120       130        140       150       160
                      //012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Local Cabec1         :=""        
//:= "Nivel 1                        Nivel 2                         Nivel 3                         Nivel 4                         Nivel 5                         OBS "
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "TMKR009" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "TMKR009" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

/*
MV_PAR01 - Responsแvel de:
MV_PAR02 - Responsแvel at้:
MV_PAR03 - Imprimir: Nใo resolvido / Resolvido / Todos
						  1				 2   	   3
MV_PAR04 - Dt. ocorr๊ncia de:
MV_PAR05 - Dt. ocorr๊ncia at้:
MV_PAR06 - Da UF
MV_PAR07- Ate UF 
MV_PAR08 - Ocorrencia de
MV_PAR09 - Ocorrencia at้
MV_PAR10 - NF de
MV_PAR11 - NF at้
*/

Pergunte("TMKR009",.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,"TMKR001",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
            //         10        20        30        40        50        60        70        80        90        100       110       120       130        140       150       160       170       180       190       200       210
            //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789

Cabec1 :=  "NF / Serie     Dt.Fat.  Responsavel    Resolv?  Ocorrencia  Tipo        Dt.Inclusao DtEnvio  HrEnvio  DtResp   HrResp Dt.Solu็ใo  PROBLEMA                             SOLUวรO                       Dt.Encerr  Hr.Encerr"	
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
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  09/04/10   บฑฑ
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
local cQry:=''
Local LF := CHR(13) + CHR(10) 
Local cOperado 	:= ""
Local cAtend	:= ""
Local cEst		:= ""
Local cSetor	:= ""
Local cNomeSetor:= ""



	cQry:=" SELECT UD_CODIGO, UD_ITEM, UD_OPERADO,UD_N1,UD_N2,UD_N3,UD_N4,UD_N5 "+LF
	cQry += " ,UD_RESOLVI, UD_OBS, UD_DTINCLU, UD_DTENVIO, UD_DATA, UD_JUSTIFI " + LF
	cQry += " , UD_DTRESOL,UD_HRRESOL,UD_OBSENC, UD_DTRESP, UD_HRENVIO,UD_HRRESP"+LF
	cQry += " ,UC_DATA, UC_CODIGO, UC_NFISCAL, UC_SERINF, UC_CHAVE, A1_COD,A1_LOJA, A1_NREDUZ, A1_EST "+LF
	cQry += " ,F2_EMISSAO " + LF
	
	cQry+=" FROM "
	cQry+= " "+RetSqlName("SUD") + " SUD, " + LF
	cQry+= " "+RetSqlName("SUC") + " SUC, " + LF
	cQry+= " "+RetSqlName("SF2") + " SF2, " + LF
	cQry+= " "+RetSqlName("SA1") + " SA1 " + LF 
	
	cQry+=" where RTRIM(UD_OPERADO) BETWEEN '" + Alltrim(MV_PAR01) + "' AND '" + Alltrim(MV_PAR02) + "' "+LF
	cQry+=" AND RTRIM(UD_N2) = '0002' "+LF		//SOMENTE LOGอSTICA
   
   	cQry+=" AND UD_DTINCLU BETWEEN '" + DTOS(MV_PAR04) + "' AND '" + DTOS(MV_PAR05) + "' "+LF
	cQry+=" AND RTRIM(UD_OPERADO) <> '' "+LF
	cQry+=" AND RTRIM(A1_EST) >= '" + Alltrim(MV_PAR06) + "' AND RTRIM(A1_EST) <= '" + Alltrim(MV_PAR07) + "' " + LF
	
	If mv_par03 = 1
		cQry += " AND RTRIM(UD_RESOLVI) <>  'S' " + LF
	Elseif mv_par03 = 2
		cQry += " AND RTRIM(UD_RESOLVI) =  'S' " + LF
	Endif
	
	cQry+= "AND UC_CODIGO = UD_CODIGO "+LF
	cQry+= "AND UC_FILIAL = UD_FILIAL "+LF
	cQry+= "AND UC_FILIAL = F2_FILIAL "+LF
	cQry+= "AND (UC_NFISCAL + UC_SERINF) = (F2_DOC + F2_SERIE) "+LF
	
	cQry += " AND RTRIM(UC_CHAVE) = RTRIM(A1_COD+A1_LOJA) "+LF
	
	cQry += " AND SA1.D_E_L_E_T_ = ''   "+LF	
	cQry += " AND SUD.D_E_L_E_T_ = ''   "+LF
	cQry += " AND SUC.D_E_L_E_T_ = ''   "+LF
	cQry += " AND SF2.D_E_L_E_T_ = ''   "+LF

	cQry += " ORDER BY UD_FILIAL, UD_CODIGO, UD_ITEM " + LF
	
	MemoWrite("C:\Temp\TMKR009.SQL",cQry)
	TCQUERY cQry NEW ALIAS "AUUX"
	
	TCSetField( "AUUX", "UD_DTINCLU", "D")
	TCSetField( "AUUX", "UD_DTENVIO", "D")
	TCSetField( "AUUX", "UD_DTRESP", "D")
	TCSetField( "AUUX", "UD_DATA", "D")
	TCSetField( "AUUX", "UD_DTRESOL", "D")
	TCSetField( "AUUX", "F2_EMISSAO", "D")
	

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

nConta := 1
AUUX->( dbGoTop() )

While AUUX->(!EOF())  

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
   Endif
     
  	 
	  While AUUX->(!EOF())  //.AND. AUUX->UD_CODIGO == cAtend
	    
			If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		      nLin := 8
		    Endif
	
		    TipoRel(Cabec1,Cabec2,Titulo,@nLin)
		          
		    IncRegua()
		    AUUX->(dbSkip()) // Avanca o ponteiro do registro no arquivo	       		     
	  ENDDO
  

EndDo

Roda( 0, "", TAMANHO )
AUUX->(DbCloseArea())

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

***************

Static Function wordWrap( cText, nRegua )

***************

Local aRet  := {}
Local cTemp := ''
Local i 	:= 1
cTemp := memoline( cText, nRegua, i, 4, .T. )
do while len( cTemp ) > 0
	aAdd(aRet, { alltrim(cTemp) } )
	i++
	cTemp := memoline( cText, nRegua, i, 4, .T. )
endDo

Return aRet   


***************

Static Function NomeOp( cOperado )

***************
PswOrder(1)
If PswSeek( cOperado, .T. )
   aUsuarios  := PSWRET() 					
   cNome := Alltrim(aUsuarios[1][2])     	// Nome do usuแrio
Endif 

return cNome

***************

Static Function TipoRel(Cabec1,Cabec2,Titulo,nLin)

***************

Local aDesc 	:= {}
Local aJustif 	:= {}
Local nTam		:= 0 
Local cNomeResp := ""
//Nota/Serie     It. Resolvido? Nivel 1         Nivel 2         Nivel 3                    Nivel 4                         Nivel 5          Dt Ocorr  Dt.Solucao  OBS do Atendto.           Resposta do Respons."
//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22       
//999999999/999 99/99/99 XXXXXXXXXXXXXXX SIM      999999      RECLAMAวรO  99/99/99    99/99/99 99:99    99/99/99 99:99  99/99/99    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99/99/99   99:99
//NF / Serie  Dt.Fat.    Responsavel     Resolv?  Ocorrencia  Tipo        Dt.Inclusao DtEnvio  HrEnvio  DtResp   HrResp Dt.Solu็ใo  Obs.Atend.                      Resposta                        Dt.Encerr  Hr.Encerr"	

	@nLin,000 PSAY ALLTRIM( AUUX->UC_NFISCAL ) + "/" + ALLTRIM(AUUX->UC_SERINF)
	@nLin,014 PSAY Dtoc(AUUX->F2_EMISSAO)
	cNomeResp := NomeOp(AUUX->UD_OPERADO)
	@nLin,023 PSAY Substr(cNomeResp,1,15)
	@nLin,039 PSAY IIF(Alltrim(AUUX->UD_RESOLVI) = "", "   ", IIF(Alltrim(AUUX->UD_RESOLVI) = "S", "Sim", "Nao"))
	@nLin,048 PSAY AUUX->UD_CODIGO
	//@nLin,064 PSAY AUUX->UD_ITEM
	@nLin,060 PSAY IIF(Alltrim(AUUX->UD_N1) = "0001", "RECLAMAวรO", IIF(Alltrim(AUUX->UD_N1) = "0060", "SUGESTรO", ""))

	@nLin,072 PSAY DTOC(AUUX->UD_DTINCLU)
	@nLin,084 PSAY DTOC(AUUX->UD_DTENVIO)
	@nLin,093 PSAY AUUX->UD_HRENVIO
	@nLin,102 PSAY DTOC(AUUX->UD_DTRESP)
	@nLin,111 PSAY AUUX->UD_HRRESP
	@nLin,118 PSAY DTOC(AUUX->UD_DATA)	
	
	
	//IMPRESSรO DAS LINHAS DO CPO UD_OBS...(OBSERVAวรO DO ATENDIMENTO INSERIDA PELO PำS-VENDAS)
	iif(len( alltrim(AUUX->UD_OBS))>=30,aDesc := wordWrap( ALLTRIM(AUUX->UD_OBS),30 ),aDesc := wordWrap( ALLTRIM(AUUX->UD_OBS), LEN(ALLTRIM(AUUX->UD_OBS)) ) )
	
	//IMPRESSรO DAS LINHAS DO CPO UD_JUSTIFI...(RESPOSTA DO RESP. PELO ATENDIMENTO)
	iif(len( alltrim(AUUX->UD_JUSTIFI))>=30,aJustif := wordWrap( ALLTRIM(AUUX->UD_JUSTIFI),30 ),aJustif := wordWrap( ALLTRIM(AUUX->UD_JUSTIFI), LEN(ALLTRIM(AUUX->UD_JUSTIFI)) ) )
	
	
	
	If Len(aDesc) > Len(aJustif)
	
	    nTam := 1
		For x:=1 to len(aDesc)
			
			If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			
			@nLin,130 PSAY aDesc[x][1]
			If Len(aJustif) > 0				
				If nTam <= Len(aJustif)
					@nLin,167 PSAY aJustif[x][1]
					nTam++
				Endif
			Elseif(x=1)
				@nLin,167 PSAY "Sem Resposta"
			Endif
			nLin++
		Next
		if len(adesc)=0
			nLin++
		endif
	Else
		nTam := 1
		For x:=1 to len(aJustif)
			
			If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			
			If Len(aDesc) > 0			
				If nTam <= Len(aDesc)
					@nLin,130 PSAY aDesc[x][1]
					nTam++
				Endif
			Endif
			@nLin,167 PSAY aJustif[x][1]
			nLin++
		Next
		if len(aJustif)=0
			nLin++
		endif
		
	Endif
	@nLin,199 PSAY DTOC(AUUX->UD_DTRESOL)		
	@nLin,210 PSAY AUUX->UD_HRRESOL
	nLin++		


Return