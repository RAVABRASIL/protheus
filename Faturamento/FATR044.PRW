#include "rwmake.ch"
#INCLUDE "Topconn.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FATR044 Autoria: Flávia Rocha         º Data ³  04/04/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de Avarias nos Transportes                       º±±
±±ºAutoria   ³ Flávia Rocha                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Logística - chamado: 00000630                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                                                                          							
User Function FATR044()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "TODAS AS MERCADORIAS AVARIADAS x TODAS AS MERCADORIAS FATURADAS"
Local cDesc2         := ""
Local cDesc3         := ""
Local cPict          := ""
Local titulo         := "MERCADORIAS AVARIADAS x MERCADORIAS FATURADAS"
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
Private nomeprog     := "FATR044" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATR044" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""
Private cPerg   := "FATR044"

/*
MV_PAR01 - Tipo de relatório: Sintético UF / Analítico / Sintético Setor
MV_PAR02 - NF de:
MV_PAR03 - NF até:
*/

Pergunte( cPerg,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

/*
IF MV_PAR06==02
	Cabec1:= "Nivel 1                        Nivel 2                         Nivel 3                         Nivel 4                         Nivel 5                         OBS                                                  Dt Ocorr."
ELSE
	Cabec1:= "Nivel 1                        Nivel 2                         Nivel 3                         Nivel 4                         Nivel 5                         Quantidade "
    titulo         := "Indentificação de Problemas CallCenter "+DTOc(MV_PAR07)+' ate '+DTOc(MV_PAR08)
ENDIF
*/   

            //         10        20        30        40        50        60        70        80        90        100       110       120       130        140       150       160       170       180       190       200       210
            //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Cabec1:= "Qtd.   NF/Série           Cliente                          Vlr.Bruto  Cidade              UF       Emissão  Dt.Exped.  Prev.Cheg.  Real.Cheg.  Transportadora                    Redespacho            Regiao"         
IF MV_PAR01 == 02
	//Cabec2:= "Responsavel    Resolv?  Tipo      Setor           Assunto                    Detalhe Assunto                 Mais Detalhe             DtEnvio  HrEnvio  OBS Atendto.          DtResp  HrResp Dt.Solução  Resposta" //   Encerr?"
	Cabec2:= "Responsavel    Resolv?  Detalhes Ocorrência                                                                                           DtEnvio  HrEnvio  OBS Atendto.          DtResp  HrResp Dt.Solução  Resposta" //   Encerr?"
ELSE
	//Cabec1:= "Resolvido?              Tipo           Setor             Assunto                            Detalhe Assunto                                   Quantidade "
	Cabec2 := ""
    
ENDIF

titulo         := "MERCADORIAS AVARIADAS x MERCADORIAS FATURADAS"  //+DTOc(MV_PAR07)+' ate '+DTOc(MV_PAR08)

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
Local cRegiao   := "" 

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


	cQry := " Select ZUD_DTRESO, ZUD_HRRESO, ZUD_CODIGO, UD_CODIGO, ZUD_ITEM, UD_ITEM, ZUD_PROBLE, ZUD_OBSATE, ZUD_OBSRES, UD_OBS, UD_JUSTIFI " + LF
	cQry += " ,ZUD_OBSENC, UD_OBSENC " + LF
	cQry += " ,UD_DTINCLU, UD_HRINCLU " +LF					//dados do atendimento (inclusão)
	cQry += " ,ZUD_DTENV, ZUD_HRENV, ZUD_NRENV, UD_DTENVIO, UD_HRENVIO " + LF      //dados do envio
	cQry += " ,ZUD_DTSOL, ZUD_DTRESP, ZUD_HRRESP, UD_DATA, UD_DTRESP, UD_HRRESP " + LF    //dados da resposta do responsável
	cQry += " ,UD_OPERADO,UD_N1,UD_N2,UD_N3,UD_N4,UD_N5, UD_RESOLVI, ZUD_RESOLV, UD_STATUS " + LF

 	cQry += " ,UC_DATA, UC_CODIGO, UC_NFISCAL, UC_SERINF, UC_CHAVE, A1_COD,A1_LOJA, A1_NREDUZ, A1_END, A1_MUN, A1_TEL, A1_EST "+LF
 	cQry += " ,F2_DOC, F2_SERIE, F2_EMISSAO, F2_DTEXP, F2_PREVCHG, F2_REALCHG ,F2_VALBRUT , F2_TRANSP, F2_REDESP, F2_EST " + LF
 	cQry+=" FROM "
 	cQry+= " "+RetSqlName("ZUD") + " ZUD, " + LF
	cQry+= " "+RetSqlName("SUD") + " SUD, " + LF
	cQry+= " "+RetSqlName("SUC") + " SUC, " + LF
	cQry+= " "+RetSqlName("SF2") + " SF2, " + LF
	cQry+= " "+RetSqlName("SA1") + " SA1 " + LF 
	
	cQry+=" WHERE 
	cQry+=" UD_OPERADO <> '' "+LF
	//cQry+=" AND RTRIM(A1_EST) >= '" + Alltrim(MV_PAR09) + "' AND RTRIM(A1_EST) <= '" + Alltrim(MV_PAR10) + "' " + LF
	
	cQry += " AND SF2.F2_SERIE = '0' " + LF
	cQry += " AND UD_N1 = '0001' " + LF
	
	//POR NF
	If !EMPTY(MV_PAR03)
		cQry+=" AND UC_NFISCAL >= '" + Alltrim(MV_PAR02) + "' AND UC_NFISCAL <= '" + Alltrim(MV_PAR03) + "' " + LF
	Endif
	
	//POR EMISSÃO
	If !EMPTY(MV_PAR05)
		cQry+=" AND F2_EMISSAO >= '" + DTOS(MV_PAR04) + "' AND F2_EMISSAO <= '" + DTOS(MV_PAR05) + "' " + LF
	Endif 
	
	//POR TRANSPORTADORA
	If !EMPTY(MV_PAR07)
		cQry+=" AND F2_TRANSP >= '" + (MV_PAR06) + "' AND F2_TRANSP <= '" + (MV_PAR07) + "' " + LF
	Endif
	
	//MV_PAR08 - FILTRA REGIÃO?  //SE O FILTRO ESTIVER COMO "SIM" , IRÁ FILTRAR PELA REGIÃO ESCOLHIDA NO PARÂMETRO MV_PAR09
	If MV_PAR08 = 1   //filtra = Sim
		If MV_PAR09 = 1 //SUDESTE
			cQry+=" AND F2_EST IN ('MG', 'ES', 'RJ', 'SP')  " + LF
			//cRegiao := "Sudeste"
		ElseIf MV_PAR09 = 2 //NORTE
			cQry+=" AND F2_EST IN ('AC','AM','AP','PA','RO','RR','TO')  " + LF
			//cRegiao := "Norte"
		ElseIf MV_PAR09 = 3 //SUL
			cQry+=" AND F2_EST IN ('RS', 'PR', 'SC')  " + LF
			//cRegiao := "Sul"
		ElseIf MV_PAR09 = 4 //CENTRO-OESTE
			cQry+=" AND F2_EST IN ('GO', 'MT', 'MS', 'DF')  " + LF
			//cRegiao := "Centro-Oeste"
		ElseIf MV_PAR09 = 5 //NORDESTE
			cQry+=" AND F2_EST IN ('MA', 'PI', 'CE', 'RN', 'PB', 'PE', 'AL', 'BA', 'SE')  " + LF
			//cRegiao := "Nordeste"
		Endif
	Endif
	
	//POR ASSUNTO N1:  (reclamação ou sugestão) , fixei em reclamação
	//cQry += " AND Z46_N1 = '0001' " + LF
	cQry += " AND UD_N1 = '0001' " + LF

	
	//POR ASSUNTO N2: (setor)
	cQry+=" AND UD_N2 = '0002' " + LF    //LOGISTICA
	//cQry += " AND Z46_N2 <> '' " + LF 

	//Endif
	//POR ASSUNTO N3: (itens do setor)
		//cQry+=" AND UD_N3 = '" + Alltrim(MV_PAR19) + "' " + LF
		//cQry += " Z46_N3 <> '' " + LF
	//Endif
	
	//POR ASSUNTO N4:
	cQry+=" AND UD_N4 = '0095' " + LF //AVARIA
	//cQry += " AND ( UD_N4 <> '' AND Z46_DESCRI LIKE 'AVARIA%' ) " + LF
	
	//POR ASSUNTO N5:
	//If !Empty(MV_PAR21)
	//	cQry+=" AND UD_N5 = '" + Alltrim(MV_PAR21) + "' " + LF
	//Endif
	
	cQry+= " AND UC_FILIAL = UD_FILIAL " + LF
	cQry+= " AND UC_FILIAL = ZUD_FILIAL " + LF
	cQry+= " AND UD_FILIAL = ZUD_FILIAL " + LF
	cQry+= " AND UC_CODIGO = UD_CODIGO " +LF
	cQry+= " AND UC_CODIGO = ZUD_CODIGO " +LF
	cQry+= " AND UD_CODIGO = ZUD_CODIGO " + LF
	cQry+= " AND UD_ITEM = ZUD_ITEM " + LF
	cQry+= " AND UC_CHAVE = (A1_COD+A1_LOJA) "+LF
	cQry+= " AND UC_FILIAL = F2_FILIAL " + LF
	cQry+= " AND UC_NFISCAL = F2_DOC " + LF
	cQry+= " AND UC_SERINF = F2_SERIE " + LF
	
	//If mv_par16 = 1          //encerrados
	//	cQry += " AND RTRIM(UD_STATUS) = '2' " + LF
		
	//Elseif mv_par16 = 2     //em aberto
	//	cQry += " AND RTRIM(UD_STATUS) = '1' " + LF
	//Endif
			
	cQry += " AND SA1.D_E_L_E_T_ = ''   "+LF
	cQry += " AND ZUD.D_E_L_E_T_ = ''   AND ZUD.ZUD_FILIAL = '" + xFilial("ZUD") + "' "+LF	
	cQry += " AND SUD.D_E_L_E_T_ = ''   AND SUD.UD_FILIAL = '" + xFilial("SUD") + "' "+LF	
	cQry += " AND SUC.D_E_L_E_T_ = ''   AND SUC.UC_FILIAL = '" + xFilial("SUC") + "' "+LF	
	cQry += " AND SF2.D_E_L_E_T_ = ''   AND SF2.F2_FILIAL = '" + xFilial("SF2") + "' "+LF	

	cQry += " ORDER BY ZUD_CODIGO,ZUD_ITEM, ZUD.R_E_C_N_O_ , ZUD_DTENV, ZUD_NRENV " + LF
	//MemoWrite("C:\Temp\TMKR001V2.SQL",cQry)
	TCQUERY cQry NEW ALIAS "AUUX"
	
	TCSetField( "AUUX", "ZUD_DTENV", "D")
	TCSetField( "AUUX", "ZUD_DTSOL", "D")
	TCSetField( "AUUX", "ZUD_DTRESO", "D")
	TCSetField( "AUUX", "UD_DTINCLU", "D")
	TCSetField( "AUUX", "UD_DATA", "D")
	TCSetField( "AUUX", "UD_DTRESP", "D")
	TCSetField( "AUUX", "ZUD_DTRESP", "D")
	TCSetField( "AUUX", "F2_EMISSAO", "D")
	TCSetField( "AUUX", "F2_DTEXP", "D")
	TCSetField( "AUUX", "F2_PREVCHG", "D")
	TCSetField( "AUUX", "F2_REALCHG", "D")
	

MemoWrite("C:\Temp\FATR044.SQL",cQry)
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

nConta := 0
nTotNF := 0
AUUX->( dbGoTop() )
nCont := 0
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
      nLin := 9
   Endif
  
  		nCont++
	  	@nLin,000 PSAY Transform(nCont , "@E 99999") //contador de notas
	  	@nLin,008 PSAY AUUX->UC_NFISCAL + "/" + AUUX->UC_SERINF
	  
	  	@nLin,023 PSAY AUUX->A1_COD + "/" + AUUX->A1_LOJA + " - " + SUBSTR(Alltrim(AUUX->A1_NREDUZ),1,20)
	    @nLin,053 PSAY Transform(AUUX->F2_VALBRUT , "@E 999,999,999.99")
 		@nLin, 069 PSAY SUBSTR(AUUX->A1_MUN,1,20) + ' ' + AUUX->A1_EST
 		@nLin, 099 PSAY DTOC(AUUX->F2_EMISSAO)
 		@nLin, 109 PSAY DTOC(AUUX->F2_DTEXP)
 		@nLin, 119 PSAY DTOC(AUUX->F2_PREVCHG)
 		@nLin, 129 PSAY DTOC(AUUX->F2_REALCHG)
 		@nLin, 143 PSAY POSICIONE("SA4",1,XFILIAL("SA4")+ AUUX->F2_TRANSP,"A4_NREDUZ")
 		@nLin, 167 PSAY POSICIONE("SA4",1,XFILIAL("SA4")+ AUUX->F2_REDESP,"A4_NREDUZ")
 		
 			//If MV_PAR08 = 1   //filtra = Sim
				Do Case
				//If MV_PAR09 = 1 //SUDESTE
					Case AUUX->F2_EST $ 'MG/ES/RJ/SP'
						cRegiao := "Sudeste"
				//ElseIf MV_PAR09 = 2 //NORTE
				Case AUUX->F2_EST $ 'AC/AM/AP/PA/RO/RR/TO'
					cRegiao := "Norte"
				//ElseIf MV_PAR09 = 3 //SUL
				Case AUUX->F2_EST $ 'RS/PR/SC'
					cRegiao := "Sul"
				//ElseIf MV_PAR09 = 4 //CENTRO-OESTE
				Case AUUX->F2_EST $ 'GO/MT/MS/DF'
					cRegiao := "Centro-Oeste"
				//ElseIf MV_PAR09 = 5 //NORDESTE
				Case AUUX->F2_EST $ 'MA/PI/CE/RN/PB/PE/AL/BA/SE'
					cRegiao := "Nordeste"
				//Endif
				Endcase
			//Endif
 		@nLin, 200 PSAY cRegiao
   		nLin++
	    nTotNf += AUUX->F2_VALBRUT  
	    If MV_PAR01 = 2 //ANALITICO
	    	TipoRel(Cabec1,Cabec2,Titulo,@nLin)
	    	@nLin++,00 PSAY replicate("=",220)
	    Endif
	    IncRegua()
     	nLin++
 	    AUUX->(dbSkip()) // Avanca o ponteiro do registro no arquivo	       		     
EndDo 
@nLin,000 PSAY REPLICATE('.' , limite)
nLin++
@nLin,000 PSAY "TOTAL DE NFs : " + Alltrim(Str(nCont))
@nLin,040 PSAY "TOTAL VALOR: " 
@nLin,053 PSAY Transform(nTotNF , "@E 999,999,999.99")

nLin++
@nLin,000 PSAY REPLICATE('.' , limite)
nLin++
Roda(0 , "" , TAMANHO)

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
If MV_PAR01 = 2

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
	
	@nLin,136 PSAY DTOC(AUUX->ZUD_DTENV)
	@nLin,145 PSAY AUUX->ZUD_HRENV

	
	@nLin,176 PSAY DTOC(AUUX->ZUD_DTRESP)    //DATA Q RESPONDEU
	@nLin,185 PSAY AUUX->ZUD_HRRESP          //HORA Q RESPONDEU
	@nLin,192 PSAY DTOC(AUUX->ZUD_DTSOL)     //DATA DA SOLUÇÃO
	
	//IMPRESSÃO DAS LINHAS DO CPO UD_OBS...(OBSERVAÇÃO DO ATENDIMENTO INSERIDA PELO PÓS-VENDAS)

	iif(len( alltrim(AUUX->ZUD_OBSATE))>= 20,aDesc := wordWrap( ALLTRIM(AUUX->ZUD_OBSATE),20 ),aDesc := wordWrap( ALLTRIM(AUUX->ZUD_OBSATE), LEN(ALLTRIM(AUUX->ZUD_OBSATE)) ) )
	
	//IMPRESSÃO DAS LINHAS DO CPO UD_JUSTIFI...(RESPOSTA DO RESP. PELO ATENDIMENTO)
	iif(len( alltrim(AUUX->ZUD_OBSRES))>= 20,aJustif := wordWrap( ALLTRIM(AUUX->ZUD_OBSRES),20 ),aJustif := wordWrap( ALLTRIM(AUUX->ZUD_OBSRES), LEN(ALLTRIM(AUUX->ZUD_OBSRES)) ) )
	
	//IMPRESSÃO DAS LINHAS DO CPO ZUD_OBSENC (OBSERVAÇÃO DO ENCERRAMENTO)
	iif(len( alltrim(AUUX->ZUD_OBSENC))>= 20,aObsEncer := wordWrap( ALLTRIM(AUUX->ZUD_OBSENC),20 ),aObsEncer := wordWrap( ALLTRIM(AUUX->ZUD_OBSENC), LEN(ALLTRIM(AUUX->ZUD_OBSENC)) ) )
	
	If Len(aDesc) > Len(aJustif)
	
	    nTam := 1
		For x:=1 to len(aDesc)
			
			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
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
				nLin := 9
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
				nLin := 9
			Endif
			
			@nLin,152 PSAY Alltrim(aObsEncer[x][1])			
			nLin++
		Next
		
		nLin++
	Endif
	
/*		
ELSE 
    
	@nLin,000 PSAY IIF(Alltrim(AUUX->UD_RESOLVI) = "", "", IIF(Alltrim(AUUX->UD_RESOLVI) = "S", "Sim", "Nao"))
	@nLin,24 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+SUBSTR(AUUX->NIVEL,1,4),"Z46_DESCRI"),1,15)	//nivel 1
	@nLin,40 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+SUBSTR(AUUX->NIVEL,5,4),"Z46_DESCRI"),1,15)  	//nivel 2
	@nLin,60 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+SUBSTR(AUUX->NIVEL,9,4),"Z46_DESCRI"),1,30)  	//nivel 3
	@nLin,93 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+SUBSTR(AUUX->NIVEL,13,4),"Z46_DESCRI"),1,30) 	//nivel 4
	@nLin,115 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+SUBSTR(AUUX->NIVEL,17,4),"Z46_DESCRI"),1,30)	//nivel 5
	@nLin,152 PSAY AUUX->QTD
	nLin++
*/	
EndIf


Return