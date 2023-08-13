#INCLUDE "RWMAKE.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  BOL001  ³ Autor ³                       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO BB   COM CODIGO DE BARRAS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function BOLETOG(cPrf,cTit,cPar,cCli,cLoj,dVen,dEmi)

LOCAL   aCampos := {{"E1_NOMCLI","Cliente","@!"},{"E1_PREFIXO","Prefixo","@!"},{"E1_NUM","Titulo","@!"},;
{"E1_PARCELA","Parcela","@!"},{"E1_VALOR","Valor","@E 9,999,999.99"},{"E1_VENCTO","Vencimento"}}
LOCAL   nOpc := 0
LOCAL   aMarked := {}
LOCAL   aDesc := {"Este programa imprime os boletos de","cobranca bancaria de acordo com","os parametros informados"}

Local  cPrf1
Local  cPrf2
Local  cTit1
Local  cTit2
Local  cPar1
Local  cPar2
Local  cCli1
Local  cCli2
Local  cLoj1
Local  cLoj2
Local  dVen1
Local  dVen2
Local  dEmi1
Local  dEmi2

PRIVATE Exec    := .F.
PRIVATE cIndexName := ''
PRIVATE cIndexKey  := ''
PRIVATE cFilter    := ''
public cConvenio := GetMV("MV_CONVBB") //"152586"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Private padrao de todos os relatorios         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLastKey := 0

dbSelectArea("SE1")

cPerg     :="BOLETO"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if cPrf # Nil .and. cTit # nil .and. cPar # nil .and. cCli # nil .and. cLoj # nil .and. dVen # nil  .and. dEmi # nil  
   cPerg := ""
   cPrf1 := cPrf
   cPrf2 := cPrf
   cTit1 := cTit
   cTit2 := cTit
   cPar1 := cPar
   cPar2 := cPar
   cCli1 := cCli
   cCli2 := cCli
   cLoj1 := cLoj
   cLoj2 := cLoj
   dVen1 := dVen
   dVen2 := dVen
   dEmi1 := dEmi
   dEmi2 := dEmi
else
   ValidPerg()

   Pergunte (cPerg,.F.)
   cPrf1 := MV_PAR01
   cPrf2 := MV_PAR02
   cTit1 := MV_PAR03
   cTit2 := MV_PAR04
   cPar1 := MV_PAR05
   cPar2 := MV_PAR06
   cCli1 := MV_PAR07
   cCli2 := MV_PAR08
   cLoj1 := MV_PAR09
   cLoj2 := MV_PAR10
   dVen1 := MV_PAR11
   dVen2 := MV_PAR12
   dEmi1 := MV_PAR13
   dEmi2 := MV_PAR14

   Tamanho  := "M"
   titulo   := "Impressao de Boleto Laser"
   cDesc1   := "Este programa destina-se a impressao do Boleto Laser."
   cDesc2   := ""
   cDesc3   := ""
   cString  := "SE1"
   wnrel    := "BOLETO"
   lEnd     := .F.

   aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }   //"Zebrado"###"Administracao"

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Envia controle para a funcao SETPRINT                        ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   Wnrel := SetPrint(cString,Wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,)

   If nLastKey == 27
     	Set Filter to
    	Return
   Endif

   SetDefault(aReturn,cString)
endif


cIndexName := Criatrab(Nil,.F.)
cIndexKey  :=  "E1_PORTADO+E1_CLIENTE+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)"
cFilter    :=  "E1_PREFIXO >= '" + cPrf1 + "' .And. E1_PREFIXO <= '" + cPrf2 + "' .And. " + ;
"E1_NUM     >= '" + cTit1 + "' .And. E1_NUM     <= '" + cTit2 + "' .And. " + ;
"E1_PARCELA >= '" + cPar1 + "' .And. E1_PARCELA <= '" + cPar2 + "' .And. " + ;
"E1_CLIENTE >= '" + cCli1 + "' .And. E1_CLIENTE <= '" + cCli2 + "' .And. " + ;
"E1_EMISSAO >= CTOD('" + DTOC(dEmi1) + "') .And. E1_EMISSAO <= CTOD('" + DTOC(dEmi2) + "') .And. " + ;
"E1_VENCTO  >= CTOD('" + DTOC(dVen1) + "') .And. E1_VENCTO <= CTOD('" + DTOC(dVen2) + "') .And. "+ ;
"E1_LOJA    >= '"+cLoj1+"' .And. E1_LOJA <= '"+cLoj2+"' .And. "+;
"E1_FILIAL   = '"+xFilial("SE1")+"' .And. E1_SALDO > 0 .And. " + ;
"SubsTring(E1_TIPO,3,1) != '-' .And. "+;
"( ( Empty(E1_NUMBCO) .and. E1_PORTADO # '001' ) .Or. Substr(E1_NUMBCO,1,6 ) = cConvenio ) "

IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
DbSelectArea("SE1")
#IFNDEF TOP
	DbSetIndex(cIndexName + OrdBagExt())
#ENDIF
SE1->(dbGoTop())
@ 001,001 TO 400,700 DIALOG oDlg TITLE "Selecao de Titulos"
@ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK"
@ 180,310 BMPBUTTON TYPE 01 ACTION (Exec := .T.,Close(oDlg))
@ 180,280 BMPBUTTON TYPE 02 ACTION (Exec := .F.,Close(oDlg))
ACTIVATE DIALOG oDlg CENTERED

If Exec
	SE1->(dbGoTop())
	Do While !SE1->(Eof())
		If Marked("E1_OK")
			AADD(aMarked,.T.)
		Else
			AADD(aMarked,.F.)
		EndIf
		SE1->(dbSkip())
	EndDo
	SE1->(dbGoTop())
	Processa({|lEnd|MontaRel(aMarked)})
Endif

RetIndex("SE1")
fErase(cIndexName+OrdBagExt())

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  BOL001  ³ Autor ³                       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO BB   COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MontaRel(aMarked)
LOCAL oPrint
LOCAL n := 0
LOCAL aDadosEmp    := {SM0->M0_NOMECOM                                    ,; //[1]Nome da Empresa
SM0->M0_ENDCOB                                                            ,; //[2]Endereço
AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
"C.N.P.J.: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+Subs(SM0->M0_CGC,13,2) ,; //[6]CGC
"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3) }  //[7]I.E

LOCAL aDadosTit
LOCAL aDadosBanco
LOCAL aDatSacado
LOCAL aBolText
LOCAL i         := 1
LOCAL CB_RN_NN  := {}
LOCAL nRec      := 0
LOCAL _nVlrAbat := 0
LOCAL _nTotEnc  := 0
Local nVlAtraso := 0
Private _cNossoNum := ""
Private aBitmap      := {"\logo\BB.bmp"}  //Logo do Banco

oPrint:= TMSPrinter():New( "Boleto Laser" )

oPrint:SetPage(9)

oPrint:SetPortrait() // ou SetLandscape()

oPrint:StartPage()   // Inicia uma nova página
SE1->(dbGoTop())
Do While !SE1->(EOF())
	nRec += 1
	SE1->(dbSkip())
EndDo
SE1->(dbGoTop())
ProcRegua(nRec)
Do While !SE1->(EOF())
	
	//Posiciona o SA1 (Cliente)
	DbSelectArea("SA1")
	DbSetOrder(1)
	SA1->(DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.))
	if SA1->A1_SATIV1 == "000009"
		SE1->( dbSkip() )
		Loop
	/*Esse trecho pula a geração de boleto para Orgãos Públicos*/
	endIf
	
	//Posiciona o SA6 (Bancos)
	DbSelectArea("SA6")
	DbSetOrder(1)
//	DbSeek(xFilial("SA6")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA),.T.)
	SA6->(DbSeek(xFilial("SA6")+"001"+"43621"+"5356-2"))
	
	//Posiciona na Arq de Parametros CNAB
	DbSelectArea("SEE")
	DbSetOrder(1)
//	DbSeek(xFilial("SEE")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA),.T.)
	SEE->(DbSeek(xFilial("SEE")+"001"+"43621"+"5356-2"))
	If aMarked[i]
		/*
		If AllTrim(SE1->E1_NUMBCO)=="10906"
		RecLock("SE1",.F.)
		SE1->E1_NUMBCO := ""
		MsUnLock()
		Endif
		*/
		If Empty(SE1->E1_NUMBCO)
			_cNossoNum := Soma1(Alltrim(SEE->EE_FAXATU)) //StrZero(Val(Alltrim(SEE->EE_FAXATU))+1,5)
			RecLock("SEE",.f.)
			SEE->EE_FAXATU := _cNossoNum
			MsUnlock()
		Else
			_cNossoNum := Substr(SE1->E1_NUMBCO,7,5)
		Endif
	Endif
	
	//Posiciona o SA1 (Cliente)
	/*DbSelectArea("SA1")
	DbSetOrder(1)
	SA1->(DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.))*/
	
	DbSelectArea("SE1")
	
	if At("-",SA6->A6_NUMCON) > 0
		cConta := SUBSTR(SA6->A6_NUMCON,1,At("-",SA6->A6_NUMCON)-1)
		cDVCC  := SUBSTR(SA6->A6_NUMCON,At("-",SA6->A6_NUMCON)+1,1)
	else
		cConta := SUBSTR(SA6->A6_NUMCON,1,Len(SA6->A6_NUMCON)-1)
		cDVCC  := SUBSTR(SA6->A6_NUMCON,Len(SA6->A6_NUMCON)-1,1)
	endif
	
	aDadosBanco  := {"001-9"                         ,; // [1]Numero do Banco
	""                                               ,; // [2]Nome do Banco
	SUBSTR(SA6->A6_AGENCIA, 1, 4)                    ,; // [3]Agência
	cConta                                           ,; // [4]Conta Corrente
	cDVCC                                            ,; // [5]Dígito da conta corrente
	"17"                                          ,; // [6]Codigo da Carteira
	SUBSTR(SA6->A6_AGENCIA, 5, 1)                     } // [7]Digito da Agência
	
	If Empty(SA1->A1_ENDCOB)
		aDatSacado   := {AllTrim(SA1->A1_NOME)            ,;      // [1]Razão Social
		AllTrim(SA1->A1_COD)+"-"+SA1->A1_LOJA             ,;      // [2]Código
		AllTrim(SA1->A1_END) +"-"+AllTrim(SA1->A1_BAIRRO) ,;      // [3]Endereço
		AllTrim(SA1->A1_MUN)                              ,;      // [4]Cidade
		SA1->A1_EST                                       ,;      // [5]Estado
		SA1->A1_CEP                                       ,;      // [6]CEP
		SA1->A1_CGC,;                                      //[7] CGC
		SA1->A1_PESSOA                              }      // [8]PESSOA
	Else
		aDatSacado   := {AllTrim(SA1->A1_NOME)              ,;    // [1]Razão Social
		AllTrim(SA1->A1_COD )+" - "+SA1->A1_LOJA              ,;    // [2]Código
		AllTrim(SA1->A1_ENDCOB)+" - "+AllTrim(SA1->A1_BAIRROC),;    // [3]Endereço
		AllTrim(SA1->A1_MUNC)                              ,;    // [4]Cidade
		SA1->A1_ESTC                                          ,;    // [5]Estado
		SA1->A1_CEPC                                        ,;    // [6]CEP
		SA1->A1_CGC,;                                             //[7]CGC
		SA1->A1_PESSOA                              }      // [8]PESSOA
	Endif
	
	_nTotEnc :=    SE1->(E1_IRRF+E1_INSS+E1_PIS+E1_COFINS+E1_CSLL)
	_nVlrAbat   :=    _nTotEnc
	
	//                         Codigo Banco           Agencia         C.Corrente     Digito C/C
	CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3),aDadosBanco[3],aDadosBanco[4],;
                          	  aDadosBanco[5],aDadosBanco[6],_cNossoNum,(E1_VALOR-_nVlrAbat) )
	
	aDadosTit    := {" "+AllTrim(SE1->E1_NUM)+" "+AllTrim(SE1->E1_PARCELA),;  // [1] Número do título
	SE1->E1_EMISSAO                                            ,;  // [2] Data da emissão do título
	Date()                                                ,;  // [3] Data da emissão do boleto
	SE1->E1_VENCREA                                      ,;  // [4] Data do vencimento
	SE1->E1_SALDO                                           ,;  // [5] Valor do título
	CB_RN_NN[3]                                     ,;  // [6] Nosso número (Ver fórmula para calculo)
	SE1->E1_PREFIXO                                            ,;  // [7] Prefixo da NF
	SE1->E1_TIPO                                                  ,;  // [8] Tipo do Titulo
	SE1->E1_IRRF                                                  ,;  // [9] IRRF
	SE1->E1_ISS                                                ,;  // [10] ISS
	SE1->E1_INSS                                               ,;  // [11] INSS
	SE1->E1_PIS                                                ,;  // [12] PIS
	SE1->E1_COFINS                                             ,;  // [13] COFINS
	SE1->E1_CSLL                                               ,;  // [14] CSLL
	_nVlrAbat                                             }   // [15] Abatimentos
	
	nVlAtraso := Str(((aDadosTit[5] * 0.07)/30),7,2)
	
	// Alterado em 22/09/08 PROTESTAR APÓS 05 DIAS ÚTEIS DO VENCIMENTO
	aBolText :=    {""                                                            ,;//[1]
	" PROTESTAR APÓS 05 DIAS CORRIDOS DO VENCIMENTO "                             ,;//[2]
	" JUROS POR CADA DIA DE ATRASO R$ "+Alltrim(nVlAtraso) ,;//[3]
	"" ,;//[4]
	"" ,;//[5]
	"" ,;//[6]
	"" ,;//[7]
	"" ,; //[8]
	""  } //[9]
	
	If aMarked[i]
		Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)
		n += 1
	EndIf
	SE1->(dbSkip())
	IncProc()
	i += 1
EndDo
oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir
//oPrinter:Print()   // Imprime direto na impressora default do APx
Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  BOL001  ³ Autor ³                       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER BANCO BB   COM CODIGO DE BARRAS  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)
LOCAL oFont8
LOCAL oFont10
LOCAL oFont16
LOCAL oFont16n
LOCAL oFont24
LOCAL i := 0
LOCAL aCoords1 := {0150,1900,0550,2300}
LOCAL aCoords2 := {0450,1050,0550,1900}
LOCAL aCoords3 := {0710,1900,0810,2300}
LOCAL aCoords4 := {0980,1900,1050,2300}
LOCAL aCoords5 := {1330,1900,1400,2300}
LOCAL aCoords6 := {2000,1900,2100,2300}
LOCAL aCoords7 := {2270,1900,2340,2300}
LOCAL aCoords8 := {2620,1900,2690,2300}
LOCAL oBrush
LOCAL cCGC := ""

//Parâmetros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10 := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.) //modificado de 16 para 12 JCNS
oFont16n:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.) //modificado de 16 para 14 JCNS
oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

//oBrush := TBrush():New("",4)

oPrint:StartPage()   // Inicia uma nova página

/*
oPrint:FillRect(aCoords1,oBrush)
oPrint:FillRect(aCoords2,oBrush)
oPrint:FillRect(aCoords3,oBrush)
oPrint:FillRect(aCoords4,oBrush)
oPrint:FillRect(aCoords5,oBrush)
oPrint:FillRect(aCoords6,oBrush)
oPrint:FillRect(aCoords7,oBrush)
oPrint:FillRect(aCoords8,oBrush)
*/
// Inicia aqui a alteracao para novo layout - RAI

oPrint:Line (0150,550,0050, 550)
oPrint:Line (0150,800,0050, 800)
oPrint:SayBitmap( 0050,100,aBitMap[1],450,100 )
oPrint:Say  (0062,100,aDadosBanco[2],oFont24 )  // [2]Nome do Banco
oPrint:Say  (0062,567,aDadosBanco[1],oFont24 )  // [1]Numero do Banco
oPrint:Say  (0084,1900,"Comprovante de Entrega",oFont10)
oPrint:Line (0150,100,0150,2300)
oPrint:Say  (0150,100 ,"Cedente"                                        ,oFont8)
oPrint:Say  (0200,100 ,aDadosEmp[1]                                  ,oFont10) //Nome + CNPJ
oPrint:Say  (0150,1060,"Agência/Código Cedente"                         ,oFont8)
oPrint:Say  (0200,1060,aDadosBanco[3]+"-"+aDadosBanco[7]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
oPrint:Say  (0150,1510,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (0200,1510,aDadosTit[7]+aDadosTit[1]                  ,oFont10) //Prefixo +Numero+Parcela
oPrint:Say  (0250,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (0300,100 ,SubsTr(aDatSacado[1],1,40)                 ,oFont10) //Nome + Codigo
oPrint:Say  (0250,1060,"Vencimento"                                     ,oFont8)
oPrint:Say  (0300,1060,If(Dtoc(aDadosTit[4])=="11/11/11","C/Apresentação",DTOC(aDadosTit[4])),oFont10)
oPrint:Say  (0250,1510,"Valor do Documento"                             ,oFont8)
oPrint:Say  (0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)
oPrint:Say  (0400,0100,"Recebi(emos) o bloqueto/título"                 ,oFont10)
oPrint:Say  (0450,0100,"com as características acima."                  ,oFont10)
oPrint:Say  (0350,1060,"Data"                                           ,oFont8)
oPrint:Say  (0350,1410,"Assinatura"                                  ,oFont8)
oPrint:Say  (0450,1060,"Data"                                           ,oFont8)
oPrint:Say  (0450,1410,"Entregador"                                  ,oFont8)

oPrint:Line (0250, 100,0250,1900 )
oPrint:Line (0350, 100,0350,1900 )
oPrint:Line (0450,1050,0450,1900 ) //---
oPrint:Line (0550, 100,0550,2300 )

oPrint:Line (0550,1050,0150,1050 )
oPrint:Line (0550,1400,0350,1400 )
oPrint:Line (0350,1500,0150,1500 ) //--
oPrint:Line (0550,1900,0150,1900 )

oPrint:Say  (0160,1910,"(  )Mudou-se"                                   ,oFont8)
oPrint:Say  (0200,1910,"(  )Ausente"                                    ,oFont8)
oPrint:Say  (0240,1910,"(  )Não existe nº indicado"                     ,oFont8)
oPrint:Say  (0280,1910,"(  )Recusado"                                   ,oFont8)
oPrint:Say  (0320,1910,"(  )Não procurado"                              ,oFont8)
oPrint:Say  (0360,1910,"(  )Endereço insuficiente"                   ,oFont8)
oPrint:Say  (0400,1910,"(  )Desconhecido"                               ,oFont8)
oPrint:Say  (0440,1910,"(  )Falecido"                                   ,oFont8)
oPrint:Say  (0480,1910,"(  )Outros(anotar no verso)"                    ,oFont8)

For i := 100 to 2300 step 50
	oPrint:Line( 0600, i, 0600, i+30)
Next i

oPrint:Line (0710,100,0710,2300)
oPrint:Line (0710,550,0610, 550)
oPrint:Line (0710,800,0610, 800)
oPrint:SayBitmap( 0610,100,aBitMap[1],450,100 )
oPrint:Say  (0622,100,aDadosBanco[2],oFont24 )  // [2]Nome do Banco
oPrint:Say  (0622,567,aDadosBanco[1],oFont24 )  // [1]Numero do Banco
oPrint:Say  (0644,1900,"Recibo do Sacado",oFont10)
oPrint:Line (0810,100,0810,2300 )
oPrint:Line (0910,100,0910,2300 )
oPrint:Line (0980,100,0980,2300 )
oPrint:Line (1050,100,1050,2300 )

oPrint:Line (0910,500,1050,500)
oPrint:Line (0980,750,1050,750)
oPrint:Line (0910,1000,1050,1000)
oPrint:Line (0910,1350,0980,1350)
oPrint:Line (0910,1550,1050,1550)

oPrint:Say  (0710,100 ,"Local de Pagamento"                             ,oFont8)
oPrint:Say  (0730,400 ,"PAGAVEL EM QUALQUER BANCO  ATÉ O VENCIMENTO"        ,oFont10)
//oPrint:Say  (0760,400 ,"APOS O VENCIMENTO, SOMENTE NO ITAU OU BANERJ"        ,oFont10)

oPrint:Say  (0710,1910,"Vencimento"                                     ,oFont8)
oPrint:Say  (0750,2010,If(Dtoc(aDadosTit[4])=="11/11/11","C/Apresentação",DTOC(aDadosTit[4])),oFont10)

oPrint:Say  (0810,100 ,"Cedente"                                        ,oFont8)
oPrint:Say  (0850,100 ,aDadosEmp[1]+"                    "+aDadosEmp[6] ,oFont10) //Nome + CNPJ

oPrint:Say  (0810,1910,"Agência/Código Cedente"                         ,oFont8)
oPrint:Say  (0850,1980,aDadosBanco[3]+"-"+aDadosBanco[7]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)

oPrint:Say  (0910,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say  (0940,100 ,DTOC(aDadosTit[2])                               ,oFont10) // Emissao do Titulo (E1_EMISSAO)

oPrint:Say  (0910,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (0940,605 ,aDadosTit[7]+aDadosTit[1]                  ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (0910,1005,"Espécie Doc."                                   ,oFont8)
oPrint:Say  (0940,1050,"DM"                                          ,oFont10) //Tipo do Titulo
//oPrint:Say  (0940,1050,If(aDadosTit[8]$"NF |NFF","DM",aDadosTit[8])      ,oFont10) //Tipo do Titulo

oPrint:Say  (0910,1355,"Aceite"                                         ,oFont8)
oPrint:Say  (0940,1455,"Não"                                             ,oFont10)

oPrint:Say  (0910,1555,"Data do Processamento"                          ,oFont8)
oPrint:Say  (0940,1655,DTOC(aDadosTit[3])                               ,oFont10) // Data impressao

oPrint:Say  (0910,1910,"Nosso Número"                                   ,oFont8)
oPrint:Say  (0940,2010,Transform(aDadosTit[6],"@R 99999999999-9"),oFont10)
//oPrint:Say  (0940,2010,SubsTr(aDadosTit[6],1,3)+"/"+SubsTr(aDadosTit[6],4,8)+"-"+SubsTr(aDadosTit[6],12,1),oFont10)

oPrint:Say  (0980,100 ,"Uso do Banco"                                   ,oFont8)

oPrint:Say  (0980,505 ,"Carteira"                                       ,oFont8)
oPrint:Say  (1010,555 ,"17-027"                                ,oFont10)

oPrint:Say  (0980,755 ,"Espécie"                                        ,oFont8)
oPrint:Say  (1010,805 ,"R$"                                             ,oFont10)

oPrint:Say  (0980,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (0980,1555,"Valor"                                          ,oFont8)

oPrint:Say  (0980,1910,"Valor do Documento"                             ,oFont8)
oPrint:Say  (1010,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say  (1050,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
oPrint:Say  (1100,100 ,aBolText[1]                                      ,oFont10)
oPrint:Say  (1150,100 ,aBolText[2]                                      ,oFont10)
oPrint:Say  (1200,100 ,aBolText[3]                                      ,oFont10)
oPrint:Say  (1250,100 ,aBolText[4]                                      ,oFont10)
oPrint:Say  (1300,100 ,aBolText[5]                                      ,oFont10)
oPrint:Say  (1200,1000,aBolText[6]                                      ,oFont10)
oPrint:Say  (1250,1000,aBolText[7]                                      ,oFont10)
oPrint:Say  (1300,1000,aBolText[8]                                      ,oFont10)
oPrint:Say  (1350,100 ,aBolText[9]                                      ,oFont10)

oPrint:Say  (1050,1910,"(-)Desconto/Abatimento"                         ,oFont8)
If aDadosTit[15] > 0
	oPrint:Say  (1080,2010,AllTrim(Transform(aDadosTit[15],"@E 999,999,999.99")),oFont10)
Endif
oPrint:Say  (1120,1910,"(-)Outras Deduções"                             ,oFont8)
oPrint:Say  (1190,1910,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (1260,1910,"(+)Outros Acréscimos"                           ,oFont8)
oPrint:Say  (1330,1910,"(=)Valor Cobrado"                               ,oFont8)

If Len(AllTrim(aDatSacado[7]))==11
	cCGC := cCGC + SubsTr(AllTrim(aDatSacado[7]),1,3)+"."
	cCGC := cCGC + SubsTr(AllTrim(aDatSacado[7]),4,3)+"."
	cCGC := cCGC + SubsTr(AllTrim(aDatSacado[7]),7,3)+"-"
	cCGC := cCGC + SubsTr(AllTrim(aDatSacado[7]),10,2)
Elseif Len(AllTrim(aDatSacado[7]))==14
	cCGC := cCGC + SubsTr(AllTrim(aDatSacado[7]),1,2)+"."
	cCGC := cCGC + SubsTr(AllTrim(aDatSacado[7]),3,3)+"."
	cCGC := cCGC + SubsTr(AllTrim(aDatSacado[7]),6,3)+"/"
	cCGC := cCGC + SubsTr(AllTrim(aDatSacado[7]),9,4)+"-"
	cCGC := cCGC + SubsTr(AllTrim(aDatSacado[7]),13,2)
Endif

oPrint:Say  (1400,100 ,"Sacado"                                         ,oFont8)
//Alterei esta linha Eurivan Candido 01/06/06
oPrint:Say  (1430,100 ,AllTrim(aDatSacado[1])+" ("+aDatSacado[2]+") "+iif(aDatSacado[8]="F","CPF: ","CNPJ: ")+cCGC  ,oFont10)
oPrint:Say  (1483,100 ,AllTrim(aDatSacado[3])                                    ,oFont10)
oPrint:Say  (1536,100 ,AllTrim(aDatSacado[6])+" "+AllTrim(aDatSacado[4])+" - "+AllTrim(aDatSacado[5]),oFont10) // CEP+Cidade+Estado
//oPrint:SayBitmap( 1420,1870,aBitMap[1],400,200 )
oPrint:Say  (1605,100 ,"Sacador/Avalista"                         ,oFont8)
oPrint:Say  (1605,505 ,""                                        ,oFont8)
oPrint:Say  (1645,1500,"Autenticação Mecânica -"                      ,oFont8)

oPrint:Line (0710,1900,1400,1900 )
oPrint:Line (1120,1900,1120,2300 )
oPrint:Line (1190,1900,1190,2300 )
oPrint:Line (1260,1900,1260,2300 )
oPrint:Line (1330,1900,1330,2300 )
oPrint:Line (1400,100 ,1400,2300 )
oPrint:Line (1640,100 ,1640,2300 )

For i := 100 to 2300 step 50
	oPrint:Line( 1850, i, 1850, i+30)
Next i

// Encerra aqui a alteracao para o novo layout - RAI

oPrint:Line (2000,100,2000,2300)
oPrint:Line (2000,550,1900, 550)
oPrint:Line (2000,800,1900, 800)
oPrint:SayBitmap( 1900,100,aBitMap[1],450,100 )
oPrint:Say  (1912,100,aDadosBanco[2],oFont24 )  // [2]Nome do Banco
oPrint:Say  (1912,567,aDadosBanco[1],oFont24 )  // [1]Numero do Banco
oPrint:Say  (1934,820,CB_RN_NN[2],oFont16n)     //Linha Digitavel do Codigo de Barras

oPrint:Line (2100,100,2100,2300 )
oPrint:Line (2200,100,2200,2300 )
oPrint:Line (2270,100,2270,2300 )
oPrint:Line (2340,100,2340,2300 )

oPrint:Line (2200,500,2340,500)
oPrint:Line (2270,750,2340,750)
oPrint:Line (2200,1000,2340,1000)
oPrint:Line (2200,1350,2270,1350)
oPrint:Line (2200,1550,2340,1550)

oPrint:Say  (2000,100 ,"Local de Pagamento"                             ,oFont8)
oPrint:Say  (2020,400 ,"PAGAVEL EM QUALQUER BANCO ATÉ O VENCIMENTO",oFont10)
//oPrint:Say  (2050,400 ,"APOS O VENCIMENTO, SOMENTE NO ITAU OU BANERJ"        ,oFont10)

oPrint:Say  (2000,1910,"Vencimento"                                     ,oFont8)
oPrint:Say  (2040,2010,If(Dtoc(aDadosTit[4])=="11/11/11","C/Apresentação",DTOC(aDadosTit[4])),oFont10)

oPrint:Say  (2100,100 ,"Cedente"                                       ,oFont8)
oPrint:Say  (2140,100 ,aDadosEmp[1]+"                    "+aDadosEmp[6] ,oFont10) //Nome + CNPJ

oPrint:Say  (2100,1910,"Agência/Código Cedente"                         ,oFont8)
oPrint:Say  (2140,1980,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)

oPrint:Say  (2200,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say  (2230,100 ,DTOC(aDadosTit[2])                               ,oFont10) // Emissao do Titulo (E1_EMISSAO)

oPrint:Say  (2200,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (2230,605 ,aDadosTit[7]+aDadosTit[1]                  ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (2200,1005,"Espécie Doc."                                   ,oFont8)
oPrint:Say  (2230,1050,"DM"                                          ,oFont10) //Tipo do Titulo
//oPrint:Say  (2230,1050,If(aDadosTit[8]$"NF |NFF","DM",aDadosTit[8])      ,oFont10) //Tipo do Titulo

oPrint:Say  (2200,1355,"Aceite"                                         ,oFont8)
oPrint:Say  (2230,1455,"Não"                                             ,oFont10)

oPrint:Say  (2200,1555,"Data do Processamento"                          ,oFont8)
oPrint:Say  (2230,1655,DTOC(aDadosTit[3])                               ,oFont10) // Data impressao

oPrint:Say  (2200,1910,"Nosso Número"                                   ,oFont8)
oPrint:Say  (2230,2010,Transform(aDadosTit[6],"@R 99999999999-9"),oFont10)
//oPrint:Say  (2230,2010,SubsTr(aDadosTit[6],1,3)+"/"+SubsTr(aDadosTit[6],4,8)+"-"+SubsTr(aDadosTit[6],12,1),oFont10)

oPrint:Say  (2270,100 ,"Uso do Banco"                                   ,oFont8)

oPrint:Say  (2270,505 ,"Carteira"                                       ,oFont8)
oPrint:Say  (2300,555 ,"17-027"                                ,oFont10)

oPrint:Say  (2270,755 ,"Espécie"                                        ,oFont8)
oPrint:Say  (2300,805 ,"R$"                                             ,oFont10)

oPrint:Say  (2270,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (2270,1555,"Valor"                                          ,oFont8)

oPrint:Say  (2270,1910,"Valor do Documento"                             ,oFont8)
oPrint:Say  (2300,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say  (2340,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
oPrint:Say  (2390,100 ,aBolText[1]                                      ,oFont10)
oPrint:Say  (2440,100 ,aBolText[2]                             ,oFont10)
oPrint:Say  (2490,100 ,aBolText[3]                                      ,oFont10)
oPrint:Say  (2540,100 ,aBolText[4]                                      ,oFont10)
oPrint:Say  (2590,100 ,aBolText[5]                                      ,oFont10)
oPrint:Say  (2490,1400,aBolText[6]                                      ,oFont10)
oPrint:Say  (2540,1400,aBolText[7]                                      ,oFont10)
oPrint:Say  (2590,1400,aBolText[8]                                      ,oFont10)
oPrint:Say  (2640,100 ,aBolText[9]                                      ,oFont10)

oPrint:Say  (2340,1910,"(-)Desconto/Abatimento"                         ,oFont8)
If aDadosTit[15] > 0
	oPrint:Say  (2370,2010,AllTrim(Transform(aDadosTit[15],"@E 999,999,999.99")),oFont10)
Endif
oPrint:Say  (2410,1910,"(-)Outras Deduções"                             ,oFont8)
oPrint:Say  (2480,1910,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (2550,1910,"(+)Outros Acréscimos"                           ,oFont8)
oPrint:Say  (2620,1910,"(=)Valor Cobrado"                               ,oFont8)

oPrint:Say  (2690,100 ,"Sacado"                                         ,oFont8)
//Alterei esta linha Eurivan Candido 01/06/06
oPrint:Say  (2720,100 ,AllTrim(aDatSacado[1])+" ("+aDatSacado[2]+") "+iif( aDatSacado[8] = "F","CPF: ","CNPJ:")+cCGC  ,oFont10)
oPrint:Say  (2773,100 ,Alltrim(aDatSacado[3])                                    ,oFont10)
oPrint:Say  (2826,100 ,Alltrim(aDatSacado[6])+" "+AllTrim(aDatSacado[4])+" - "+Alltrim(aDatSacado[5]),oFont10) // CEP+Cidade+Estado
//oPrint:SayBitmap( 2720,1870,aBitMap[1],400,200 )
oPrint:Say  (2895,100 ,"Sacador/Avalista"                               ,oFont8)
oPrint:Say  (2895,505 ,""                                        ,oFont8)
oPrint:Say  (2935,1500,"Autenticação Mecânica -"                        ,oFont8)
oPrint:Say  (2935,1850,"Ficha de Compensação"                           ,oFont10)
oPrint:Line (2000,1900,2690,1900 )
oPrint:Line (2410,1900,2410,2300 )
oPrint:Line (2480,1900,2480,2300 )
oPrint:Line (2550,1900,2550,2300 )
oPrint:Line (2620,1900,2620,2300 )
oPrint:Line (2690,100 ,2690,2300 )
oPrint:Line (2940,100,2940,2300  )

//Alterei Eurivan Marques Candido 07/06/06


//MSBAR("INT25",26,1,CB_RN_NN[1],oPrint,.F.,,,0.035,1,,,,.F.)

//If mv_par19 = 1 //impressora lexmark
//   MSBAR("INT25",26,1,CB_RN_NN[1],oPrint,.F.,,,0.035,1,,,,.F.)
//Else
MSBAR("INT25",13,1,CB_RN_NN[1],oPrint,.F.,,,0.015,0.7,,,,.F.)
//EndIf
//MSBAR("INT25",26,1.5,CB_RN_NN[1],oPrint,.F.,,,,1.3,,,,.F.)
//MSBAR("INT25",14,1,CB_RN_NN[1],oPrint,.F.,,,0.013,0.8,,,,.F.)
//MSBAR("INT25", 27.8,2.3,CB_RN_NN[1],oPrint,NIL,NIL,.t.,0.025,1.3,.t.,oFont13,NIL) //0.012
// Ao montar o Bordero, o sistema já grava o Nosso Numero - Apenas na Lunabel

DbSelectArea("SE1")
if Empty(SE1->E1_NUMBCO)
   RecLock("SE1",.f.)
   SE1->E1_NUMBCO  := CB_RN_NN[3]
   MsUnlock()
endif   

oPrint:EndPage() // Finaliza a página

Return Nil


********************************
static function Modulo10(cValor)
********************************
local Somatoria := 0
local P
local Resto
local Peso := 2
local _i
local cResult

for _i := Len(cValor) to 1 step -1
   P := Val(Substr(cValor,_i,1)) * Peso
   if P > 9 
      Somatoria += (P - 9)
   else
      Somatoria += P
   endif  

   if Peso = 2
      Peso := 1
   else
      Peso := 2
   endif
next _i   

Resto := Mod(Somatoria,10)

if Resto = 0
   cResult := '0'
else
   cResult := Alltrim(Str(10 - Resto))
endif

return cResult


*********************************************
static function Modulo11(cValor,nBase,nResto)
*********************************************

local Somatoria := 0
local P
local Peso := 2
local _i
local cResult

for _i := Len(cValor) to 1 step -1
   P := Val(Substr(cValor,_i,1)) * Peso
   Somatoria += P
   if Peso < nBase 
      Peso += 1
   else
      Peso := 2
   endif   
next _i

Resto := Mod(Somatoria,11)

if Resto = 0
   cResult := '0'
else
   cResult := Str(11 - Resto)
endif

return cResult

*******************************
static function DVCBar(cBarras)
*******************************
local Somatoria := 0
local P
local Peso := 2
local _i
local Resto
local cResult

for _i := Len(cBarras) to 1 step -1 
   if _i <> 5  // Pula a quinta casa, pois eh a propria casa do digito verificador
      P := Val(Substr(cBarras,_i,1)) * Peso
      Somatoria += P
      if Peso < 9
         Peso += 1
      else
         Peso := 2
      endif  
   endif
next _i

Resto := 11 - Mod(Somatoria,11)

/*
  if (Resto = 0) .or. (Resto = 1) .or. (Resto > 9)
    cResult := '1'
  else
    cResult := chr(48 + Resto); // CHR(48) = '0', CHR(49) = '1', etc...
*/    

cResult := Alltrim(Str(Resto))

return cResult

*****************************************
static function Modulo11BB(cValor, nbase)
*****************************************
local digito
local resto
local cResto
local cResult

digito := Modulo11(cValor, nBase, resto)
if resto = 10
    cResult := 'X'
  else
    cResult := digito
endif

return cResult

*******************************
static function DvNN(cConv,cNN)
*******************************
local x
local cResult

x := PadL(cConv, 6, '0') + PadL(cNN, 5, '0')
cResult := Modulo11BB(x,9);

return cResult



//Retorna os strings para inpressão do Boleto
//CB = String para o cód.barras, RN = String com o número digitável
//Cobrança não identificada, número do boleto = Título + Parcela
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  BOL399  ³ Autor ³                       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER BANCO HSBC COM CODIGO DE BARRAS  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cCarteira,cNroDoc,nValor)

LOCAL bldocnufinal := AllTrim(_cNossoNum)
LOCAL blvalorfinal := strzero(nValor*100,10)
LOCAL dvnn         := 0
LOCAL dvcb         := 0
LOCAL dv           := 0
LOCAL NN           := ''
LOCAL LD           := ''
LOCAL CB           := ''
LOCAL s            := ''
Local dDtBase      := ctod("07/10/1997")
Local cFatorVencto := ""
Local Campo1 := Campo2 := Campo3 := Campo4 := Campo5 := ""

//Calculo do Fator de Vencimento do Titulo
cFatorVencto := Str(SE1->E1_VENCREA - dDtBase,4)

//Montagem no NOSSO NUMERO
snn  := cConvenio+bldocnufinal  // Carteira + Nosso Número
dvnn := DvNN(cConvenio,bldocnufinal)
//Conclusao
NN   := snn+AllTrim(dvnn)


//MONTAGEM DOS DADOS PARA O CODIGO DE BARRAS
dvcb := ' '                                                 //Nosso Numero
scb  := cBanco + "9" + dvcb + cFatorVencto + blvalorfinal + snn + cAgencia + StrZero( Val(cConta),8) + cCarteira
dvcb := DVCBar(scb)
//Conclusao
CB   := cBanco + "9" + dvcb + cFatorVencto + blvalorfinal + snn + cAgencia + StrZero( Val(cConta),8) + cCarteira

//MONTAGEM DA LINHA DIGITAVEL
Campo1 := cBanco+"9" + Substr(CB,20,5)
dv := modulo10(Campo1)
Campo1 += dv
Campo1 := Substr(Campo1,1,5)+'.'+Substr(Campo1,6,5)

Campo2 := Substr(CB,25,10)
dv := modulo10(Campo2)
Campo2 += dv
Campo2 := Substr(Campo2,1,5)+'.'+Substr(Campo2,6,6)

Campo3 := Substr(CB,35,10)
dv := modulo10(Campo3)
Campo3 += dv
Campo3 := Substr(Campo3,1,5)+'.'+Substr(Campo3,6,6)

Campo4 := dvcb

Campo5 := cFatorVencto + blvalorFinal
//Conclusao
LD := Campo1+" "+Campo2+" "+Campo3+" "+Campo4+" "+Campo5

Return({CB,LD,NN})



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³VALIDPERG ³ Autor ³ RAIMUNDO PEREIRA      ³ Data ³ 01/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER BANCO HSBC COM CODIGO DE BARRAS  ³±±
±±³          ³ Verifica as perguntas inclu¡ndo-as caso n„o existam        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ValidPerg()
PutSx1( "BOLETO", '01', 'Do Prefixo           ?', '', '', 'mv_ch1', 'C', 3, 0, 0, 'G', '', ''   , '', '', 'mv_par01', '', '', '',;
        '' , '', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( "BOLETO", '02', 'Ate o Prefixo        ?', '', '', 'mv_ch2', 'C', 3, 0, 0, 'G', '', ''   , '', '', 'mv_par02', '', '', '',;
        '' , '', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( "BOLETO", '03', 'Do Titulo            ?', '', '', 'mv_ch3', 'C', 6, 0, 0, 'G', '', ''   , '', '', 'mv_par03', '', '', '',;
        '' , '', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( "BOLETO", '04', 'Ate o Titulo         ?', '', '', 'mv_ch4', 'C', 6, 0, 0, 'G', '', ''   , '', '', 'mv_par04', '', '', '',;
        '' , '', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( "BOLETO", '05', 'Da Parcela           ?', '', '', 'mv_ch5', 'C', 1, 0, 0, 'G', '', ''   , '', '', 'mv_par05', '', '', '',;
        '' , '', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( "BOLETO", '06', 'Ate a Parcela        ?', '', '', 'mv_ch6', 'C', 1, 0, 0, 'G', '', ''   , '', '', 'mv_par06', '', '', '',;
        '' , '', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( "BOLETO", '07', 'Do Cliente           ?', '', '', 'mv_ch7', 'C', 6, 0, 0, 'G', '', ''   , '', '', 'mv_par07', '', '', '',;
        '' , '', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( "BOLETO", '08', 'Ate o Cliente        ?', '', '', 'mv_ch8', 'C', 6, 0, 0, 'G', '', ''   , '', '', 'mv_par08', '', '', '',;
        '' , '', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( "BOLETO", '09', 'Da Loja              ?', '', '', 'mv_ch9', 'C', 2, 0, 0, 'G', '', ''   , '', '', 'mv_par09', '', '', '',;
        '' , '', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( "BOLETO", '10', 'Ate a Loja           ?', '', '', 'mv_chA', 'C', 2, 0, 0, 'G', '', ''   , '', '', 'mv_par10', '', '', '',;
        '' , '', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( "BOLETO", '11', 'Do Vencimento        ?', '', '', 'mv_chB', 'D', 8, 0, 0, 'G', '', ''   , '', '', 'mv_par11', '', '', '',;
        '' , '', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( "BOLETO", '12', 'Ate o Vencimento     ?', '', '', 'mv_chN', 'D', 8, 0, 0, 'G', '', ''   , '', '', 'mv_par12', '', '', '',;
        '' , '', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( "BOLETO", '13', 'Da Emissao           ?', '', '', 'mv_chD', 'D', 8, 0, 0, 'G', '', ''   , '', '', 'mv_par13', '', '', '',;
        '' , '', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( "BOLETO", '14', 'Ate a Emissao        ?', '', '', 'mv_chE', 'D', 8, 0, 0, 'G', '', ''   , '', '', 'mv_par14', '', '', '',;
        '' , '', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )                                                
/*_sAlias := Alias()
DBSelectArea("SX1")
DBSetOrder(1)
cPerg := PADR(cPerg,6)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
Aadd(aRegs,{cPerg,"01","Do Prefixo           ?","","","mv_ch1","C", 3,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Ate o Prefixo        ?","","","mv_ch2","C", 3,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Do Titulo            ?","","","mv_ch3","C", 6,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate o Titulo         ?","","","mv_ch4","C", 6,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Da Parcela           ?","","","mv_ch5","C", 1,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Ate a Parcela        ?","","","mv_ch6","C", 1,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Do Cliente           ?","","","mv_ch7","C", 6,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Ate o Cliente        ?","","","mv_ch8","C", 6,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Da Loja              ?","","","mv_ch9","C", 2,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","Ate a Loja           ?","","","mv_chA","C", 2,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"11","Do Vencimento        ?","","","mv_chB","D", 8,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"12","Ate o Vencimento     ?","","","mv_chN","D", 8,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"13","Da Emissao           ?","","","mv_chD","D", 8,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"14","Ate a Emissao        ?","","","mv_chE","D", 8,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If ! DBSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to Max(39, Len(aRegs[i])) //fCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
	Endif
Next

DBSkip()

do while x1_grupo == cPerg
	RecLock("SX1", .F.)
	DBDelete()
	DBSkip()
Enddo

DBSelectArea(_sAlias)*/

Return
