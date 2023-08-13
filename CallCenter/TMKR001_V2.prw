#include "rwmake.ch"
#INCLUDE "Topconn.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMKR001_V2                             º Data ³  20/09/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de Ocorrências do Call Center (histórico)        º±±
±±ºAutoria   ³ Flávia Rocha                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Pós-Vendas                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                                                                          							
User Function TMKR01V2()		//p/ ser usado pelo setor Pós Vendas


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "identificação de problemas SAC"
Local cPict          := ""
Local titulo         := "Identificação de Problemas SAC"
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
Private nomeprog     := "TMKR001V2" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "TMKR001V2" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

/*
MV_PAR01 - Responsável de:
MV_PAR02 - Responsável até:
MV_PAR03 - Setor de:
MV_PAR04 - Setor até:
MV_PAR05 - Imprimir: Não resolvido / Resolvido / Todos
						  1				 2   	   3
MV_PAR06 - Tipo de relatório: Sintético UF / Analítico / Sintético Setor
								  1			  2                3
MV_PAR07 - Dt. ocorrência de:
MV_PAR08 - Dt. ocorrência até:
MV_PAR09 - Da UF
MV_PAR10 - Ate UF
MV_PAR11 - Tipo ocorrência: Reclamação / Sugestão / Ambos
MV_PAR12 - Ocorrencia de:
MV_PAR13 - Ocorrencia ate:
MV_PAR14 - NF de:
MV_PAR15 - NF até:
*/

Pergunte("TMKR001",.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"TMKR001",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

/*
IF MV_PAR06==02
	Cabec1:= "Nivel 1                        Nivel 2                         Nivel 3                         Nivel 4                         Nivel 5                         OBS                                                  Dt Ocorr."
ELSE
	Cabec1:= "Nivel 1                        Nivel 2                         Nivel 3                         Nivel 4                         Nivel 5                         Quantidade "
    titulo         := "Identificação de Problemas CallCenter "+DTOc(MV_PAR07)+' ate '+DTOc(MV_PAR08)
ENDIF
*/   

            //         10        20        30        40        50        60        70        80        90        100       110       120       130        140       150       160       170       180       190       200       210
            //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
IF MV_PAR06==02
	Cabec1:= "Responsavel    Resolv?  Tipo      Setor           Assunto                    Detalhe Assunto                 Mais Detalhe             DtEnvio  HrEnvio  OBS Atendto.          DtResp  HrResp Dt.Solução  Resposta" //   Encerr?"
ELSE
	Cabec1:= "Resolvido?              Tipo           Setor             Assunto                            Detalhe Assunto                                   Quantidade "
    
ENDIF

titulo         := "Identificação de Problemas SAC - "+DTOc(MV_PAR07)+' ate '+DTOc(MV_PAR08)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  09/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
Local cResp		:= ""
Local cNomeResp := ""  

/*
CAMPOS EXISTENTES:
(Atendimento)
UD_DTINCLU - Data Inclusão item ocorrência
UD_DTENVIO - Data envio item
UD_NRENVIO - Número do último reenvio
UD_DTRESP  - Data que o responsável registrou sua resposta
UD_DATA    - Data que o responsável digitou para solução

(Histórico)
ZUD_DTENV  - Data envio
ZUD_DTSOL  - Data que o responsável digitou para solução (histórico)
ZUD_NRENV  - Número do reenvio

NOVOS CAMPOS:
(Atendimento)
UD_HRINCLU - Hora inclusão
UD_HRENVIO - Hora do Envio
UD_HRRESP  - Hora que o responsável registrou sua resposta

(Histórico)
ZUD_HRENV   - Hora do Envio
ZUD_HRRESP  - Hora que o responsável registrou sua resposta
*/

if MV_PAR06 = 2     //analítico

	cQry := " Select ZUD_DTRESO, ZUD_HRRESO, ZUD_CODIGO, UD_CODIGO, ZUD_ITEM, UD_ITEM, ZUD_PROBLE, ZUD_OBSATE, ZUD_OBSRES, UD_OBS, UD_JUSTIFI " + LF
	cQry += " ,ZUD_OBSENC, UD_OBSENC " + LF
	cQry += " ,UD_DTINCLU, UD_HRINCLU " +LF					//dados do atendimento (inclusão)
	cQry += " ,ZUD_DTENV, ZUD_HRENV, ZUD_NRENV, UD_DTENVIO, UD_HRENVIO " + LF      //dados do envio
	cQry += " ,ZUD_DTSOL, ZUD_DTRESP, ZUD_HRRESP, UD_DATA, UD_DTRESP, UD_HRRESP " + LF    //dados da resposta do responsável
	cQry += " ,UD_OPERADO,UD_N1,UD_N2,UD_N3,UD_N4,UD_N5, UD_RESOLVI, ZUD_RESOLV, UD_STATUS, UD_OBS  " + LF

 	cQry += " ,UC_DATA, UC_CODIGO, UC_NFISCAL, UC_SERINF, UC_CHAVE, A1_COD,A1_LOJA, A1_NREDUZ, A1_END, A1_MUN, A1_TEL, A1_EST "+LF
 	cQry+=" FROM "
 	cQry+= " "+RetSqlName("ZUD") + " ZUD, " + LF
	cQry+= " "+RetSqlName("SUD") + " SUD, " + LF
	cQry+= " "+RetSqlName("SUC") + " SUC, " + LF
	cQry+= " "+RetSqlName("SA1") + " SA1 " + LF 
	
	cQry+=" WHERE "                     
	cQry+= " UD_OPERADO <> '' " + LF
	
	If !Empty(MV_PAR02)
		cQry+= " AND UD_OPERADO BETWEEN '" + Alltrim(MV_PAR01) + "' AND '" + Alltrim(MV_PAR02) + "' "+LF
	Endif
	
	If !Empty(MV_PAR04)
		cQry+=" AND UD_N2 BETWEEN '" + Alltrim(MV_PAR03) + "' AND '" + Alltrim(MV_PAR04) + "' "+LF
	Endif
	
	If !Empty(MV_PAR08)
   		cQry+=" AND UD_DTINCLU BETWEEN '" + DTOS(MV_PAR07) + "' AND '" + DTOS(MV_PAR08) + "' "+LF
 	Endif
 	
	If !Empty(MV_PAR10)
		cQry+=" AND A1_EST >= '" + Alltrim(MV_PAR09) + "' AND A1_EST <= '" + Alltrim(MV_PAR10) + "' " + LF
	Endif
	
	If mv_par11 = 1
		cQry += " AND RTRIM(UD_N1) = '0001' " + LF
	Elseif mv_par11 = 2
		cQry += " AND RTRIM(UD_N1) = '0060' " + LF
	Endif
	
	//POR OCORRÊNCIA
	If !Empty(MV_PAR13)
		cQry+=" AND UC_CODIGO >= '" + Alltrim(MV_PAR12) + "' AND UC_CODIGO <= '" + Alltrim(MV_PAR13) + "' " + LF
	Endif
	
	//POR NF
	If !Empty(MV_PAR15)
		cQry+=" AND UC_NFISCAL >= '" + Alltrim(MV_PAR14) + "' AND UC_NFISCAL <= '" + Alltrim(MV_PAR15) + "' " + LF
	Endif
	
	//POR ASSUNTO N1:
	If !Empty(MV_PAR17)
		cQry+=" AND UD_N1 = '" + Alltrim(MV_PAR17) + "' " + LF
	Endif
	//POR ASSUNTO N2:
	If !Empty(MV_PAR18)
		cQry+=" AND UD_N2 = '" + Alltrim(MV_PAR18) + "' " + LF
	Endif
	//POR ASSUNTO N3:
	If !Empty(MV_PAR19)
		cQry+=" AND UD_N3 = '" + Alltrim(MV_PAR19) + "' " + LF
	Endif
	
	//POR ASSUNTO N4:
	If !Empty(MV_PAR20)
		cQry+=" AND UD_N4 = '" + Alltrim(MV_PAR20) + "' " + LF
	Endif 
	
	//POR ASSUNTO N5:
	If !Empty(MV_PAR21)
		cQry+=" AND UD_N5 = '" + Alltrim(MV_PAR21) + "' " + LF
	Endif
	
	cQry+= " AND UC_CODIGO = UD_CODIGO " +LF
	cQry+= " AND UC_CODIGO = ZUD_CODIGO " +LF
	cQry += " AND UD_CODIGO = ZUD_CODIGO " + LF
	cQry += " AND UD_ITEM = ZUD_ITEM " + LF
	cQry += " AND RTRIM(UC_CHAVE) = RTRIM(A1_COD+A1_LOJA) "+LF
	
	If mv_par05 = 1          //não resolvido
		cQry += " AND UD_RESOLVI <> 'S' " + LF
		
	Elseif mv_par05 = 2     //resolvido
		cQry += " AND UD_RESOLVI = 'S' " + LF
	Endif 
	
	If mv_par16 = 1          //abertos
		cQry += " AND UD_STATUS <> '2' " + LF
		
	Elseif mv_par16 = 2     //encerrados
		cQry += " AND UD_STATUS = '2' " + LF
	Endif
			
	cQry += " AND SA1.D_E_L_E_T_ = ''   "+LF
	cQry += " AND ZUD.D_E_L_E_T_ = ''   AND ZUD.ZUD_FILIAL = '" + xFilial("ZUD") + "' "+LF	
	cQry += " AND SUD.D_E_L_E_T_ = ''   AND SUD.UD_FILIAL = '" + xFilial("SUD") + "' "+LF	
	cQry += " AND SUC.D_E_L_E_T_ = ''   AND SUC.UC_FILIAL = '" + xFilial("SUC") + "' "+LF	

	cQry += " ORDER BY ZUD_CODIGO,ZUD_ITEM, ZUD.R_E_C_N_O_ , ZUD_DTENV, ZUD_NRENV " + LF
	MemoWrite("C:\Temp\TMKR001V2_ana.SQL",cQry)
	TCQUERY cQry NEW ALIAS "AUUX"
	
	TCSetField( "AUUX", "ZUD_DTENV", "D")
	TCSetField( "AUUX", "ZUD_DTSOL", "D")
	TCSetField( "AUUX", "ZUD_DTRESO", "D")
	TCSetField( "AUUX", "UD_DTINCLU", "D")
	TCSetField( "AUUX", "UD_DATA", "D")
	TCSetField( "AUUX", "UD_DTRESP", "D")
	TCSetField( "AUUX", "ZUD_DTRESP", "D")
	
Else    //resumido

	cQry:=" SELECT " + LF 
	cQry+= " CASE WHEN UD_RESOLVI = 'N' THEN '' ELSE UD_RESOLVI END UD_RESOLVI " + LF
	cQry+= " ,UD_N1+UD_N2+UD_N3+UD_N4+UD_N5 as NIVEL,COUNT(*) QTD "+LF
	
	If mv_par06 = 1            //sintético por Estado
		cQry+= " , A1_EST "	+LF
	Elseif mv_par06 = 3			//sintético por Setor
		cQry+= " , UD_N2 " + LF
	Elseif mv_par06 = 4			//sintético por Responsável
		cQry+= " , UD_OPERADO " + LF
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
	
	If mv_par05 = 1          //não resolvido
		cQry += " AND RTRIM(UD_RESOLVI) <> 'S' " + LF
		
	Elseif mv_par05 = 2     //resolvido
		cQry += " AND RTRIM(UD_RESOLVI) = 'S' " + LF
	Endif 
	
	//If mv_par16 = 1          //encerrados
	//	cQry += " AND RTRIM(UD_STATUS) = '2' " + LF
		
	//Elseif mv_par16 = 2     //em aberto
	//	cQry += " AND RTRIM(UD_STATUS) = '1' " + LF
	//Endif
	
	If mv_par11 = 1
		cQry += " AND RTRIM(UD_N1) = '0001' " + LF
	Elseif mv_par11 = 2
		cQry += " AND RTRIM(UD_N1) = '0060' " + LF
	Endif
	
	cQry+=" AND RTRIM(UC_CHAVE) = RTRIM(A1_COD+A1_LOJA) "+LF
	cQry+=" AND SA1.D_E_L_E_T_!='*'   "+LF
	
	
	cQry += " AND SA1.D_E_L_E_T_ = ''   "+LF
	cQry += " AND SUD.D_E_L_E_T_ = ''   AND SUD.UD_FILIAL = '" + xFilial("SUD") + "' "+LF	
	cQry += " AND SUC.D_E_L_E_T_ = ''   AND SUC.UC_FILIAL = '" + xFilial("SUC") + "' "+LF	

	
	cQry+=" GROUP BY " + LF 
	cQry+= " CASE WHEN UD_RESOLVI='N' THEN '' ELSE UD_RESOLVI END " + LF
	cQry+= " ,UD_N1+UD_N2+UD_N3+UD_N4+UD_N5 "+LF
	
	If mv_par06 = 1        //sintético por UF
		cQry+= " ,A1_EST "+LF
		cQry+=" ORDER BY A1_EST  "+LF
	Elseif mv_par06 = 3     //sintético por setor
		cQry+= " , UD_N2 " + LF
		cQry+= " ORDER BY UD_N2  "+LF
	Elseif mv_par06 = 4     //sintético por responsável
		cQry+= " , UD_OPERADO " + LF
		cQry+= " ORDER BY UD_OPERADO  "+LF
	Endif
	
	//cQry+="ORDER BY UD_OPERADO,UD_RESOLVI,NIVEL  "+LF
	
	MemoWrite("C:\Temp\TMKR001V2_res.SQL",cQry)

    TCQUERY cQry NEW ALIAS "AUUX"

EndIf
//MemoWrite("C:\Temp\TMKR001V2.SQL",cQry)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nConta := 1
AUUX->( dbGoTop() )

While AUUX->(!EOF())  

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
  //cOperado:=AUUX->UD_OPERADO
  
  
  
  If mv_par06 = 2
		cAtend := AUUX->UD_CODIGO 
		cItem  := AUUX->UD_ITEM   
	  	@nLin++,00 PSAY "Atendimento: "+ cAtend 
	  	nLin++
	  	@nLin,000 PSAY "Nota Fiscal / Serie: " + AUUX->UC_NFISCAL + " / " + AUUX->UC_SERINF
	  	nLin++
	  	@nLin,000 PSAY "Cliente: " + AUUX->A1_COD + "/" + AUUX->A1_LOJA + " - " + Alltrim(AUUX->A1_NREDUZ) + " - Endereço: " + Alltrim(AUUX->A1_END) +;
	  	" - Cidade: " + Alltrim(AUUX->A1_MUN) + " - Telefone: " + Alltrim(AUUX->A1_TEL) + " - UF: " + AUUX->A1_EST
	  	nLin++
	  	@nLin,000 PSAY replicate("_",160)
	  	nLin++
	    @nLin,000 PSAY "Ocorr: " + AUUX->UD_ITEM + " - Inclusão (Data/Hora): " + Dtoc(AUUX->UD_DTINCLU ) + " / " + AUUX->UD_HRINCLU
	    nLin++
	  While AUUX->(!EOF())  .AND. AUUX->UD_CODIGO == cAtend
	    
			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		      nLin := 8
		    Endif
		    
		    If Alltrim(AUUX->UD_ITEM) != Alltrim(cItem)
		    	nLin++
		 		@nLin,000 PSAY replicate('-',220)
		 		nLin++
		 		@nLin,000 PSAY "Ocorr: " + AUUX->UD_ITEM + " - Inclusão (Data/Hora): " + Dtoc(AUUX->UD_DTINCLU ) + " / " + AUUX->UD_HRINCLU
	    		nLin++
		 		cItem := AUUX->UD_ITEM
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
  	
  		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
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
  	
  		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		      nLin := 8
		Endif
  	   	TipoRel(Cabec1,Cabec2,Titulo,@nLin)
  	   	
  		IncRegua()
  		AUUX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
  	ENDDO
  
  ElseIF mv_par06 = 4
  	cResp	 := AUUX->UD_OPERADO
  	cNomeResp := NomeOp(cResp)
  	@nLin++,00 PSAY "Responsável: " + cResp + "-" + cNomeResp
	@nLin++,00 PSAY replicate("-",22)
  	While AUUX->(!EOF())  .AND. Alltrim(AUUX->UD_OPERADO) == Alltrim(cResp)
  	
  		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
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
Local cNome	:= ""

PswOrder(1)
If PswSeek( cOperado, .T. )
   aUsuarios  := PSWRET() 					
   cNome := Alltrim(aUsuarios[1][2])     	// Nome do usuário
Endif 

return cNome

***************

Static Function TipoRel(Cabec1,Cabec2,Titulo,nLin)

***************

Local aDesc 	:= {}
Local aJustif 	:= {}
Local aObsEncer := {}

Local nTam		:= 0 
Local cEncerrado:= ""
//Nota/Serie   Resolv?  Tipo       Setor            Assunto                    Detalhe Assunto                          Mais Detalhe      DtEnvio  HrEnvio Obs Atendto.         DtResp     HrResp DtSolução Resposta"
//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22       
//XXXXXXXXXX   Sim    XXXXXXXXXX   XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXX   99/99/99 99:99  XXXXXXXXXXXXXXXXXXXX    99/99/99 99:99 99/99/99  XXXXXXXXXXXXXXXXXXXX     
//responsavel         Reclamacao  Logistica                             
If MV_PAR06 = 2

    nLin++
	cResponsavel := Substr(NomeOp(AUUX->UD_OPERADO),1,10)	
	@nLin,000 PSAY Alltrim(cResponsavel) PICTURE "@!"
	cEncerrado := iif(AUUX->UD_STATUS = '2', "Sim", "Nao")
	
	//@nLin,013 PSAY IIF(Alltrim(AUUX->ZUD_RESOLV) = "", "", IIF(Alltrim(AUUX->ZUD_RESOLV) = "S", "Sim", "Nao"))
	//If Empty(Alltrim(AUUX->ZUD_RESOLV)) .and. !Empty(Alltrim(UD_RESOLVI))
		//@nLin,013 PSAY IIF(Alltrim(AUUX->UD_RESOLVI) = "", "", IIF(Alltrim(AUUX->UD_RESOLVI) = "S", "Sim", "Nao"))
	//Else
		@nLin,013 PSAY IIF(Alltrim(AUUX->ZUD_RESOLV) = "", "   ", IIF(Alltrim(AUUX->ZUD_RESOLV) = "S", "Sim", "Nao"))
	//Endif	
	
	
	@nLin,020 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+AUUX->UD_N1,"Z46_DESCRI"),1,15) 	//Tipo  - nivel 1 - max 15
	@nLin,033 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+AUUX->UD_N2,"Z46_DESCRI"),1,15)  //Setor - nivel 2 - max 15
	@nLin,049 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+AUUX->UD_N3,"Z46_DESCRI"),1,30) 	//Assunto - nivel 3 - max 25
	@nLin,076 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+AUUX->UD_N4,"Z46_DESCRI"),1,30) 	//Detalhe - nivel 4 - max 40
	@nLin,118 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+AUUX->UD_N5,"Z46_DESCRI"),1,15) 	//Mais detalhe - nivel 5 - 
	/*
	If Len(alltrim(AUUX->ZUD_OBSATE)) > 0 
		@nLin,136 PSAY DTOC(AUUX->ZUD_DTENV)
		@nLin,145 PSAY AUUX->ZUD_HRENV
	Else
		@nLin,136 PSAY DTOC(AUUX->UD_DTINCLU)
		@nLin,145 PSAY AUUX->UD_HRINCLU
	Endif
    */
	
	@nLin,136 PSAY DTOC(AUUX->ZUD_DTENV)
	@nLin,145 PSAY AUUX->ZUD_HRENV
	
	@nLin,176 PSAY DTOC(AUUX->ZUD_DTRESP)    //DATA Q RESPONDEU
	@nLin,185 PSAY AUUX->ZUD_HRRESP          //HORA Q RESPONDEU
	@nLin,192 PSAY DTOC(AUUX->ZUD_DTSOL)     //DATA DA SOLUÇÃO
	
	//IMPRESSÃO DAS LINHAS DO CPO UD_OBS...(OBSERVAÇÃO DO ATENDIMENTO INSERIDA PELO PÓS-VENDAS)
    If Len(alltrim(AUUX->ZUD_OBSATE)) > 0    
		iif(len( alltrim(AUUX->ZUD_OBSATE))>= 20,aDesc := wordWrap( ALLTRIM(AUUX->ZUD_OBSATE),20 ),aDesc := wordWrap( ALLTRIM(AUUX->ZUD_OBSATE), LEN(ALLTRIM(AUUX->ZUD_OBSATE)) ) )
	Else
		iif(len( alltrim(AUUX->UD_OBS))>= 20,aDesc := wordWrap( ALLTRIM(AUUX->UD_OBS),20 ),aDesc := wordWrap( ALLTRIM(AUUX->UD_OBS), LEN(ALLTRIM(AUUX->UD_OBS)) ) )
	Endif
	
	//IMPRESSÃO DAS LINHAS DO CPO UD_JUSTIFI...(RESPOSTA DO RESP. PELO ATENDIMENTO)
	If len(alltrim(AUUX->ZUD_OBSRES)) > 0
		iif(len( alltrim(AUUX->ZUD_OBSRES))>= 20,aJustif := wordWrap( ALLTRIM(AUUX->ZUD_OBSRES),20 ),aJustif := wordWrap( ALLTRIM(AUUX->ZUD_OBSRES), LEN(ALLTRIM(AUUX->ZUD_OBSRES)) ) )
	Else
		iif(len( alltrim(AUUX->UD_JUSTIFI))>= 20,aJustif := wordWrap( ALLTRIM(AUUX->UD_JUSTIFI),20 ),aJustif := wordWrap( ALLTRIM(AUUX->UD_JUSTIFI), LEN(ALLTRIM(AUUX->UD_JUSTIFI)) ) )
	Endif
	
	//IMPRESSÃO DAS LINHAS DO CPO ZUD_OBSENC (OBSERVAÇÃO DO ENCERRAMENTO)
	If len( alltrim(AUUX->ZUD_OBSENC)) > 0
		iif(len( alltrim(AUUX->ZUD_OBSENC))>= 20,aObsEncer := wordWrap( ALLTRIM(AUUX->ZUD_OBSENC),20 ),aObsEncer := wordWrap( ALLTRIM(AUUX->ZUD_OBSENC), LEN(ALLTRIM(AUUX->ZUD_OBSENC)) ) )
	Else
		iif(len( alltrim(AUUX->UD_OBSENC))>= 20,aObsEncer := wordWrap( ALLTRIM(AUUX->UD_OBSENC),20 ),aObsEncer := wordWrap( ALLTRIM(AUUX->UD_OBSENC), LEN(ALLTRIM(AUUX->UD_OBSENC)) ) )
	Endif
	
	If Len(aDesc) > Len(aJustif)
	
	    nTam := 1
		For x:=1 to len(aDesc)
			
			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			
			@nLin,152 PSAY Alltrim(aDesc[x][1])
			
			If Len(aJustif) > 0				
				If nTam <= Len(aJustif)
					@nLin,201 PSAY Alltrim(aJustif[x][1])
					nTam++
				Endif
			Elseif(x=1)
				@nLin,201 PSAY "Sem Resposta"
			Endif
			nLin++
		Next
		if len(adesc)=0
			nLin++
			//nLin++
		endif
	Else
		nTam := 1
		For x:=1 to len(aJustif)
			
			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			
			If Len(aDesc) > 0			
				If nTam <= Len(aDesc)
					@nLin,152 PSAY Alltrim(aDesc[x][1])
					nTam++
				Endif
			Endif
			@nLin,201 PSAY Alltrim(aJustif[x][1])
			nLin++
		Next
		if len(aJustif)=0
			nLin++ 
			//nLin++
		endif
		
	Endif
	
	If !Empty(AUUX->ZUD_DTRESO)
		@nLin,105 PSAY "OCORRÊNCIA ENCERRADA EM: "
	   	@nLin,136 PSAY DTOC(AUUX->ZUD_DTRESO)
		@nLin,145 PSAY AUUX->ZUD_HRRESO
		////REPETE A OBSERVAÇÃO DO ATENDTO. POIS O OPERADOR PODERÁ REGISTRAR NESTE CAMPO ALGO SOBRE O ENCERRAMENTO
		For x:=1 to len(aObsEncer)
			
			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			
			@nLin,152 PSAY Alltrim(aObsEncer[x][1])			
			nLin++
		Next
		
		nLin++
	Endif
	
		
ELSE 
    
	@nLin,000 PSAY IIF(Alltrim(AUUX->UD_RESOLVI) = "", "", IIF(Alltrim(AUUX->UD_RESOLVI) = "S", "Sim", "Nao"))
	@nLin,24 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+SUBSTR(AUUX->NIVEL,1,4),"Z46_DESCRI"),1,15)	//nivel 1
	@nLin,40 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+SUBSTR(AUUX->NIVEL,5,4),"Z46_DESCRI"),1,15)  	//nivel 2
	@nLin,60 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+SUBSTR(AUUX->NIVEL,9,4),"Z46_DESCRI"),1,30)  	//nivel 3
	@nLin,93 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+SUBSTR(AUUX->NIVEL,13,4),"Z46_DESCRI"),1,30) 	//nivel 4
	@nLin,115 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+SUBSTR(AUUX->NIVEL,17,4),"Z46_DESCRI"),1,30)	//nivel 5
	@nLin,152 PSAY AUUX->QTD
	nLin++
EndIf


Return