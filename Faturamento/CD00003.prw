#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CD00001   º Autor ³ Eurivan Marques    º Data ³  16/03/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gera arquivo par EDI com CD - São Paulo                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CD00003()

Private cPerg   := "CD00001"
Private oGeraTxt
Private cString := "SA1"

dbSelectArea("SA1")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Gera‡„o de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira gerar um arquivo texto, conforme os parame- "
@ 18,018 Say " tros definidos  pelo usuario,  com os registros do arquivo de "
@ 26,018 Say "                                                               "

@ 65,095 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 65,125 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 65,155 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
Pergunte(cPerg,.T.)
Activate Dialog oGeraTxt Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ OKGERATXTº Autor ³ AP5 IDE            º Data ³  16/03/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a geracao do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function OkGeraTxt

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o arquivo texto                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private nSequen := getMV("MV_SEQADE")
//Private cArqTxt := "C:\R"+substr(dtos(dDataBase),3,2) + substr(dtos(dDataBase),5,2) + substr(dtos(dDataBase),7,2)+alltrim(str(nSequen))+".TXT"
Private cArqTxt := "C:\PRINCIPAL.TXT"
Private nHdl    := fCreate(cArqTxt)

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
    Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Processa({|| RunCont() },"Processando...")
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ RUNCONT  º Autor ³ AP5 IDE            º Data ³  16/03/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunCont
Local nContR1 := nContR2 := nContR3 := nContR4 := 0
Local nTamLin, cLin, cCpo, cQuery
Local cDoc := cCgc := ""
//Dados do remetente
nTamLin := 226
cLin    := Space(nTamLin)+cEOL

cCpo := PADR("1",01)//Constante - Registro
cLin := Stuff(cLin,01,01,cCpo)

cCpo := PADR(SM0->M0_CGC,15)//Cnpj do remetente
cLin := Stuff(cLin,02,15,cCpo)

cCpo := PADR(SM0->M0_NOMECOM,60)//Razão social do remetente
cLin := Stuff(cLin,17,60,cCpo)

cCpo := PADR(SM0->M0_INSC,20)//Inscrição estadual do remetente
cLin := Stuff(cLin,77,20,cCpo)

cCpo := PADR(SM0->M0_CEPENT,8)//Cep do remetente
cLin := Stuff(cLin,97,8,cCpo)

cCpo := PADR(SM0->M0_ENDCOB,70)//Endereço do remetente
cLin := Stuff(cLin,105,70,cCpo)

cCpo := PADR(SM0->M0_BAIRCOB,25)//Bairro do remetente
cLin := Stuff(cLin,175,25,cCpo)

cCpo := PADR(SM0->M0_CIDENT,25)//Cidade do remetente
cLin := Stuff(cLin,200,25,cCpo)

cCpo := PADR(SM0->M0_ESTENT,2)//UF do remetente
cLin := Stuff(cLin,225,2,cCpo)
nContR1++//Quantidade de registro 1
if fWrite(nHdl,cLin,len(cLin)) != len(cLin)
    if !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
        return
    endif
endif

cQuery := "SELECT '0' AS CPO1, 'I' AS CPO2, '1' AS CPO3, F2_DOC, A1_CGC, '' AS CGC_RAVA, F2_EMISSAO, F2_HORA, F2_PBRUTO, F2_VOLUME1, "
cQuery += "F2_SERIE, '   ' AS SUBSERIE, F2_VALBRUT, '   ' AS SERENT, '   ' AS SSERENT, 'NF' AS DIVDOC, '0' AS TPDOC, "
cQuery += "A1_EST, A1_MUN, A1_END, A1_BAIRRO, A1_CEP, A1_NOME, A1_NREDUZ, A1_INSCR "
cQuery += "FROM "+RetSqlName("SF2")+" SF2, "+RetSqlName("SA1")+" SA1 "
cQuery += "WHERE F2_EMISSAO between '"+dtos(MV_PAR09)+"' and '"+dtos(MV_PAR10)+"' AND F2_SERIE between '"+MV_PAR01+"' and '"+MV_PAR02+"' AND "
cQuery += "F2_DOC between '"+MV_PAR03+"' and '"+MV_PAR04+"' AND F2_LOJA between '"+MV_PAR05+"' and '"+MV_PAR06+"' AND "
cQuery += "F2_CLIENTE between '"+MV_PAR07+"' and '"+MV_PAR08+"' AND F2_SERIE <> '' AND SF2.F2_TIPO = 'N' "
cQuery += "AND A1_COD+A1_LOJA = F2_CLIENTE+F2_LOJA "
cQuery += "AND SA1.A1_FILIAL = '"+xFilial("SA1")+"' and SF2.F2_FILIAL = '"+xFilial("SF2")+"' "
cQuery += "AND SA1.D_E_L_E_T_ = ' ' and SF2.D_E_L_E_T_ = ' ' "
cQuery += "order by A1_CGC "
TCQUERY cQuery NEW ALIAS "XF2"

DbSelectArea("XF2")
ProcRegua(0) 
cCgc := XF2->A1_CGC
cDoc := XF2->F2_DOC
nContR2 := nContR3 := 1
//Dados do destinatário
while !XF2->(EOF())
    IncProc()

    nTamLin := 407
    cLin    := Space(nTamLin)+cEOL

    cCpo := PADR("2",01)//Registro - Constante
    cLin := Stuff(cLin,01,01,cCpo)

    cCpo := PADR(XF2->A1_CGC,15)//Cnpj  do destinatário
    cLin := Stuff(cLin,02,15,cCpo)

    cCpo := PADR(XF2->A1_NREDUZ,25)//Nome fantasia do destinatário
    cLin := Stuff(cLin,17,25,cCpo)

    cCpo := PADR(XF2->A1_NOME, 60)//Razão social do destinatário
    cLin := Stuff(cLin,42,60,cCpo)

    cCpo := PADR(XF2->A1_INSCR,20)//Inscrição estadual do destinatário
    cLin := Stuff(cLin,102,20,cCpo)

    cCpo := PADR(XF2->A1_CEP,8)//Cep do destinatário
    cLin := Stuff(cLin,122,8,cCpo)

    cCpo := PADR(XF2->A1_END,70)//Endereço do destinatário
    cLin := Stuff(cLin,130,70,cCpo)

    cCpo := PADR(XF2->A1_BAIRRO,25)//Bairro do destinatário
    cLin := Stuff(cLin,200,25,cCpo)

    cCpo := PADR(XF2->A1_MUN,25)//Cidade do destinatário
    cLin := Stuff(cLin,225,25,cCpo)

    cCpo := PADR(XF2->A1_EST,2)//UF do destinatário
    cLin := Stuff(cLin,250,2,cCpo)

    cCpo := PADR(XF2->A1_EST,2)//UF do destinatário
    cLin := Stuff(cLin,250,2,cCpo)

    cCpo := PADR("TD   ",5)//Tipo de venda - Constante
    cLin := Stuff(cLin,252,5,cCpo)
    
    cCpo := Space(150)//Observações
    cLin := Stuff(cLin,257,150,cCpo)
    
    cCpo := PADR("N",1)//RI (?)
    cLin := Stuff(cLin,407,1,cCpo)    

    if fWrite(nHdl,cLin,len(cLin)) != len(cLin)
        if !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
            exit
        endif
    endif

    //Dados das vendas
    nTamLin := 187
    cLin := Space(nTamLin)+cEOL

    cCpo := PADR("3",01)//Indicador
    cLin := Stuff(cLin,01,01,cCpo)

    cCpo := PADR(XF2->F2_DOC,10)//Nº Venda
    cLin := Stuff(cLin,02,10,cCpo)

    cCpo := substr(XF2->F2_EMISSAO,7,2) + substr(XF2->F2_EMISSAO,5,2) + substr(XF2->F2_EMISSAO,1,4)//Data de emissão
    cLin := Stuff(cLin,12,8,cCpo)

   	cCpo := PADR("BOL", 3)//Forma de pagamento
    cLin := Stuff(cLin,20,3,cCpo)

    cCpo := PADR(XF2->A1_CGC,15)//Cnpj  do destinatário
    cLin := Stuff(cLin,23,15,cCpo)
    
    cCpo := Space(150)//Observações
    cLin := Stuff(cLin,38,150,cCpo)

    if fWrite(nHdl,cLin,len(cLin)) != len(cLin)
        if !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
            exit
        endif
    endif

    //Dados das Notas Fiscais
    nTamLin := 60
    cLin := Space(nTamLin)+cEOL

    cCpo := PADR("4",01)//Contante
    cLin := Stuff(cLin,01,01,cCpo)
    
    cCpo := Space(11)//Nº Venda
    cLin := Stuff(cLin,02,10,cCpo)
    
    cCpo := PADR(XF2->F2_DOC,8)//Nº Nota Fiscal
    cLin := Stuff(cLin,12,08,cCpo)
    
    cCpo := substr(XF2->F2_EMISSAO,7,2) + substr(XF2->F2_EMISSAO,5,2) + substr(XF2->F2_EMISSAO,1,4)//Data de emissão
    cLin := Stuff(cLin,20,8,cCpo)
    
    cCpo := PADR(XF2->F2_VOLUME1,6)//Volumes
    cLin := Stuff(cLin,28,06,cCpo)
    
    cCpo := strZero(Round(XF2->F2_PBRUTO, 3) * 1000, 10)//Peso em KG
    cLin := Stuff(cLin,34,10,cCpo)
    
    cCpo := strZero(Round( 0, 3) * 1000, 7)//Cubagem
    cLin := Stuff(cLin,44,07,cCpo)
    
    cCpo := strZero( Round(XF2->F2_VALBRUT,2) * 100, 10 )//Valor total da NF
    cLin := Stuff(cLin,51,10,cCpo)

    if fWrite(nHdl,cLin,len(cLin)) != len(cLin)
        if !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
            exit
        endif
    endif    
   	XF2->(DbSkip())   	
   	//Contadores
	if XF2->A1_CGC != cCgc// .and. XF2->( !EoF() )
	    nTamLin := 25
	    cLin := Space(nTamLin)+cEOL
	
	    cCpo := PADR("5",01)//Início do registro totalizador
	    cLin := Stuff(cLin,01,01,cCpo)
	    
   	    cCpo := PADR("1",01)//Quantidade de remetentes, só um RAVA EMBALAGENS
	    cLin := Stuff(cLin,02,01,cCpo)
	    
   	    cCpo := PADR( alltrim(str(nContR2)), 06 )//Quantidade de destinatários, nContR2
	    cLin := Stuff(cLin,03,06,cCpo)
	    
   	    cCpo := PADR( alltrim(str(nContR3)), 06 )//Quantidade de dados de vendas
	    cLin := Stuff(cLin,09,06,cCpo)
	    
   	    cCpo := PADR( alltrim(str(nContR3)), 06 )//Quantidade de notas fiscais
	    cLin := Stuff(cLin,15,06,cCpo)
	    
	    if fWrite(nHdl,cLin,len(cLin)) != len(cLin)
        	if !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
        		exit
        	endif
    	endif
    	if XF2->( !EoF() )
			nContR2 := 0
			cCgc := XF2->A1_CGC
		endIf
	endIf
   	if XF2->F2_DOC != cDoc .and. XF2->( !EoF() )
		cDoc := SF2->F2_DOC		
		nContR3 := 0
	endIf
	nContR2++
	nContR3++
end

XF2->(DbCloseArea())

fClose(nHdl)
Close(oGeraTxt)
putMV( "MV_SEQADE", ++nSequen )

return