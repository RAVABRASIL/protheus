#include "rwmake.ch"
#INCLUDE "Topconn.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTMKR001A                               บ Data ณ  06/09/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relat๓rio de Ocorr๊ncias do Call Center                    บฑฑ
ฑฑบAutoria   ณ Flแvia Rocha                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P๓s-Vendas                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
                                                                                                          							
User Function TMKR001A()		//p/ ser usado pelo setor P๓s Vendas


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "indentifica็ใo de problemas CallCenter"
Local cPict          := ""
Local titulo         := "Indentifica็ใo de Problemas CallCenter"
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
Private nomeprog     := "TMKR001A" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "TMKR001A" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

/*
MV_PAR01 - Responsแvel de:
MV_PAR02 - Responsแvel at้:
MV_PAR03 - Setor de:
MV_PAR04 - Setor at้:
MV_PAR05 - Imprimir: Nใo resolvido / Resolvido / Todos
						  1				 2   	   3
MV_PAR06 - Tipo de relat๓rio: Sint้tico UF / Analํtico / Sint้tico Setor
								  1			  2                3
MV_PAR07 - Dt. ocorr๊ncia de:
MV_PAR08 - Dt. ocorr๊ncia at้:
MV_PAR09 - Da UF
MV_PAR10 - Ate UF
*/

Pergunte("TMKR001",.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,"TMKR001",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
            //         10        20        30        40        50        60        70        80        90        100       110       120       130        140       150       160       170       180       190       200       210
            //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
/*
IF MV_PAR06==02
	Cabec1:= "Nivel 1                        Nivel 2                         Nivel 3                         Nivel 4                         Nivel 5                         OBS                                                  Dt Ocorr."
ELSE
	Cabec1:= "Nivel 1                        Nivel 2                         Nivel 3                         Nivel 4                         Nivel 5                         Quantidade "
    titulo         := "Indentifica็ใo de Problemas CallCenter "+DTOc(MV_PAR07)+' ate '+DTOc(MV_PAR08)
ENDIF
*/   

IF MV_PAR06==02
	Cabec1:= "Nota/Serie     It. Resolvido? Tipo            Setor           Assunto                    Detalhe Assunto                 Mais Detalhe    Dt Ocorr  Dt.Solucao   OBS do Atendto.              Resposta do Respons."
ELSE
	Cabec1:= "Resolvido?              Tipo            Setor           Assunto                   Detalhe Assunto                  Mais Detalhe                     Quantidade "
    titulo         := "Indentifica็ใo de Problemas CallCenter - "+DTOc(MV_PAR07)+' ate '+DTOc(MV_PAR08)
ENDIF

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

if MV_PAR06 = 2

	cQry:=" SELECT UD_CODIGO, UD_ITEM, UD_OPERADO,UD_N1,UD_N2,UD_N3,UD_N4,UD_N5 "+LF
	//cQry += ",CASE WHEN UD_RESOLVI='N' THEN '' ELSE UD_RESOLVI END UD_RESOLVI " + LF
	cQry += " ,UD_RESOLVI, UD_OBS, UD_DTINCLU, UD_DATA, UD_JUSTIFI "+LF
	cQry += " ,UC_DATA, UC_CODIGO, UC_NFISCAL, UC_SERINF, UC_CHAVE, A1_COD,A1_LOJA, A1_NREDUZ, A1_EST "+LF
	
	cQry+=" FROM "
	cQry+= " "+RetSqlName("SUD") + " SUD, " + LF
	cQry+= " "+RetSqlName("SUC") + " SUC, " + LF
	cQry+= " "+RetSqlName("SA1") + " SA1 " + LF 
	
	cQry+=" where RTRIM(UD_OPERADO) BETWEEN '" + Alltrim(MV_PAR01) + "' AND '" + Alltrim(MV_PAR02) + "' "+LF
	cQry+=" AND RTRIM(UD_N2) BETWEEN '" + Alltrim(MV_PAR03) + "' AND '" + Alltrim(MV_PAR04) + "' "+LF
   	//cQry+="AND UC_DATA BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
   	cQry+=" AND UD_DTINCLU BETWEEN '" + DTOS(MV_PAR07) + "' AND '" + DTOS(MV_PAR08) + "' "+LF
	cQry+=" AND RTRIM(UD_OPERADO) <> '' "+LF
	cQry+=" AND RTRIM(A1_EST) >= '" + Alltrim(MV_PAR09) + "' AND RTRIM(A1_EST) <= '" + Alltrim(MV_PAR10) + "' " + LF
	
	If mv_par05 = 1
		cQry += " AND RTRIM(UD_RESOLVI) <> = 'S' " + LF
	Endif
	cQry+= "AND UC_CODIGO = UD_CODIGO "+LF
	
	cQry += " AND RTRIM(UC_CHAVE) = RTRIM(A1_COD+A1_LOJA) "+LF
	cQry += " AND SA1.D_E_L_E_T_ = ''   "+LF
	
	cQry += " AND SUD.D_E_L_E_T_ = ''   "+LF
	cQry += " AND SUC.D_E_L_E_T_ = ''   "+LF
	//cQry+="ORDER BY UD_OPERADO,UD_RESOLVI,UC_DATA "
	//cQry+="ORDER BY UD_OPERADO,UD_RESOLVI,UD_DTINCLU "+LF	//ALTERADO POR FLมVIA POIS NรO HAVIA CAMPO NO ITEM QUE INDICASSE A DATA DE SUA INCLUSรO
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////28/04/2010 - O CAMPO UC_DATA ษ A DATA QUE FOI ABERTO O ATENDIMENTO, MAS NEM SEMPRE SรO INCLUอDOS ITENS NO DIA EM QUE SE ABRE O ATENDIMENTO,
	////PODE OCORRER DO OPERADOR DO CALL CENTER INCLUIR ITENS DIA(S) APำS A ABERTURA DO ATENDIMENTO, ENTรO CRIEI O CAMPO UD_DTINCLU
	////QUE ษ A DATA DE INCLUSรO DO ITEM, INICIALIZADO AUTOMATICAMENTE PELA dDATABASE DO SISTEMA.
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	cQry += " ORDER BY UD_CODIGO, UD_ITEM " + LF
	//MemoWrite("C:\Temp\TMKR001A.SQL",cQry)
	TCQUERY cQry NEW ALIAS "AUUX"
	
Else

	cQry:=" SELECT " + LF 
	cQry+= " CASE WHEN UD_RESOLVI = 'N' THEN '' ELSE UD_RESOLVI END UD_RESOLVI " + LF
	cQry+= " ,UD_N1+UD_N2+UD_N3+UD_N4+UD_N5 as NIVEL,COUNT(*) QTD "+LF
	
	If mv_par06 = 1            //sint้tico por Estado
		cQry+= " , A1_EST "	+LF
	Elseif mv_par06 = 3			//sint้tico por Setor
		cQry+= " , UD_N2 " + LF
	Endif 
	
	cQry+=" FROM "
	cQry+= " "+RetSqlName("SUD") + " SUD, " + LF
	cQry+= " "+RetSqlName("SUC") + " SUC, " + LF
	cQry+= " "+RetSqlName("SA1") + " SA1 " + LF 	
	
	cQry+=" where RTRIM(UD_OPERADO) BETWEEN '" + Alltrim(MV_PAR01) + "' AND '" + Alltrim(MV_PAR02) + "' "+LF
	cQry+=" AND RTRIM(UD_N2) BETWEEN '" + Alltrim(MV_PAR03) + "' AND '" + Alltrim(MV_PAR04) + "' "+LF
    cQry+=" AND UD_DTINCLU BETWEEN '" + DTOS(MV_PAR07) + "' AND '" + DTOS(MV_PAR08) + "' "+LF
	cQry+=" AND UC_CODIGO = UD_CODIGO "+LF
	cQry+=" AND RTRIM(UD_OPERADO) <> '' "+LF
	cQry+=" AND RTRIM(A1_EST) >= '" + Alltrim(MV_PAR09) + "' AND RTRIM(A1_EST) <= '" + Alltrim(MV_PAR10) + "' " + LF
	
	If mv_par05 = 1
		cQry += " AND RTRIM(UD_RESOLVI) <> 'S' " + LF
	Endif
	
	cQry+=" AND RTRIM(UC_CHAVE) = RTRIM(A1_COD+A1_LOJA) "+LF
	cQry+=" AND SA1.D_E_L_E_T_!='*'   "+LF
	
	cQry+=" AND SUD.D_E_L_E_T_!='*'   "+LF
	cQry+=" AND SUC.D_E_L_E_T_!='*'   "+LF
	cQry+=" GROUP BY " + LF 
	cQry+= " CASE WHEN UD_RESOLVI='N' THEN '' ELSE UD_RESOLVI END " + LF
	cQry+= " ,UD_N1+UD_N2+UD_N3+UD_N4+UD_N5 "+LF
	
	If mv_par06 = 1
		cQry+= " ,A1_EST "+LF
		cQry+=" ORDER BY A1_EST  "+LF
	Elseif mv_par06 = 3
		cQry+= " , UD_N2 " + LF
		cQry+= " ORDER BY UD_N2  "+LF
	Endif
	
	//cQry+="ORDER BY UD_OPERADO,UD_RESOLVI,NIVEL  "+LF
	
//	MemoWrite("C:\Temp\TMKR001A.SQL",cQry)

    TCQUERY cQry NEW ALIAS "AUUX"

EndIf

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

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
  //cOperado:=AUUX->UD_OPERADO
  
  
  
  If mv_par06 = 2
		cAtend := AUUX->UD_CODIGO    
	  	@nLin++,00 PSAY "Atendimento: "+ cAtend + " - Cliente: " + AUUX->A1_COD + "/" + AUUX->A1_LOJA + "-" + AUUX->A1_NREDUZ + " - UF: " + AUUX->A1_EST
	  	@nLin++,00 PSAY replicate("-",70)
	 
	  While AUUX->(!EOF())  .AND. AUUX->UD_CODIGO == cAtend
	    
			If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		      nLin := 8
		    Endif
	
		    TipoRel(Cabec1,Cabec2,Titulo,@nLin)
		          
		    IncRegua()
		    AUUX->(dbSkip()) // Avanca o ponteiro do registro no arquivo	       		     
	  ENDDO
	  
  ElseIF mv_par06 = 1
  	cEst	 := AUUX->A1_EST
  	@nLin++,00 PSAY "Estado: " + cEst 
	@nLin++,00 PSAY replicate("-",20)
  	While AUUX->(!EOF())  .AND. Alltrim(AUUX->A1_EST) == Alltrim(cEst)
  	
  		If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		      nLin := 8
		Endif
  	   	TipoRel(Cabec1,Cabec2,Titulo,@nLin)
  	   	
  		IncRegua()
  		AUUX->(dbSkip()) // Avanca o ponteiro do registro no arquivo	   	
  	ENDDO
  	
  ElseIF mv_par06 = 3
  	cSetor	 := AUUX->UD_N2
  	cNomeSetor := POSICIONE("Z46",1,XFILIAL("Z46")+AUUX->UD_N2,"Z46_DESCRI")
  	@nLin++,00 PSAY "Setor: " + cSetor + "-" + cNomeSetor
	@nLin++,00 PSAY replicate("-",22)
  	While AUUX->(!EOF())  .AND. Alltrim(AUUX->UD_N2) == Alltrim(cSetor)
  	
  		If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		      nLin := 8
		Endif
  	   	TipoRel(Cabec1,Cabec2,Titulo,@nLin)
  	   	
  		IncRegua()
  		AUUX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
  	ENDDO	  
  		
  Endif
  @nLin++,00 PSAY replicate("=",220)
      

EndDo

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
//Nota/Serie     It. Resolvido? Nivel 1         Nivel 2         Nivel 3                    Nivel 4                         Nivel 5          Dt Ocorr  Dt.Solucao  OBS do Atendto.           Resposta do Respons."
//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22       
//999999999/XXX  001  X         XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXX  99/99/99  99/99/99  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX     
//NOTA/SERIE                    NIVEL1          NIVEL2           NIVEL 3                   NIVEL 4                         NIVEL 5
If MV_PAR06 = 2

	
	@nLin,000 PSAY ALLTRIM( AUUX->UC_NFISCAL ) + "/" + ALLTRIM(AUUX->UC_SERINF)
	@nLin,015 PSAY AUUX->UD_ITEM
	@nLin,020 PSAY IIF(Alltrim(AUUX->UD_RESOLVI) = "", "", IIF(Alltrim(AUUX->UD_RESOLVI) = "S", "Sim", "Nao"))
	
	@nLin,030 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+AUUX->UD_N1,"Z46_DESCRI"),1,15) 	//nivel 1 - max 15
	@nLin,046 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+AUUX->UD_N2,"Z46_DESCRI"),1,15)  	//nivel 2 - max 15
	@nLin,062 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+AUUX->UD_N3,"Z46_DESCRI"),1,30) 	//nivel 3 - max 25
	@nLin,089 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+AUUX->UD_N4,"Z46_DESCRI"),1,30) 	//nivel 4 - max 40
	@nLin,121 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+AUUX->UD_N5,"Z46_DESCRI"),1,15) 	//nivel 5 - 
	@nLin,138 PSAY DTOC(STOD(AUUX->UD_DTINCLU))
	@nLin,148 PSAY DTOC(STOD(AUUX->UD_DATA))
	
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
			
			@nLin,157 PSAY aDesc[x][1]
			If Len(aJustif) > 0				
				If nTam <= Len(aJustif)
					@nLin,190 PSAY aJustif[x][1]
					nTam++
				Endif
			Elseif(x=1)
				@nLin,195 PSAY "Sem Resposta"
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
					@nLin,157 PSAY aDesc[x][1]
					nTam++
				Endif
			Endif
			@nLin,190 PSAY aJustif[x][1]
			nLin++
		Next
		if len(aJustif)=0
			nLin++
		endif
		
	Endif
		
ELSE
    
	@nLin,000 PSAY IIF(Alltrim(AUUX->UD_RESOLVI) = "", "", IIF(Alltrim(AUUX->UD_RESOLVI) = "S", "Sim", "Nao"))
	@nLin,24 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+SUBSTR(AUUX->NIVEL,1,4),"Z46_DESCRI"),1,15)	//nivel 1
	@nLin,40 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+SUBSTR(AUUX->NIVEL,5,4),"Z46_DESCRI"),1,15)  	//nivel 2
	@nLin,56 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+SUBSTR(AUUX->NIVEL,9,4),"Z46_DESCRI"),1,30)  	//nivel 3
	@nLin,83 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+SUBSTR(AUUX->NIVEL,13,4),"Z46_DESCRI"),1,30) 	//nivel 4
	@nLin,115 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+SUBSTR(AUUX->NIVEL,17,4),"Z46_DESCRI"),1,30)	//nivel 5
	@nLin,152 PSAY AUUX->QTD
	nLin++
EndIf


Return