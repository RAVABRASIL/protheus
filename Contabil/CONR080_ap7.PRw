#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 15/04/03
#IFNDEF WINDOWS
   #DEFINE PSAY SAY
#ENDIF

User Function CONR080()        // incluido pelo assistente de conversao do AP5 IDE em 15/04/03

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,LEXTERNO,WNRELEXT")
SetPrvt("ARETURN,NOMEPROG,ALINHA,NLASTKEY,CPERG,TAMANHO")
SetPrvt("WNREL,TITULO,CABEC1,CABEC2,CCANCEL,CTRANSP")
SetPrvt("CTRAN,CTOTDIA,CTOTMES,CTOTGER,CDIARIO,CFOLHA")
SetPrvt("CABRE,CENCERRA,LEND,NQUEBRA,NTOTDIAD,NTOTDIAC")
SetPrvt("NTOTMESD,NTOTMESC,NTOTDEB,NTOTCRED,LTERMO,CSI2EMPFIL")
SetPrvt("DSI2DATA,CSI2NUM,NSI2REG,LCOMPLHIST,CDIGVER,LIMITE")
SetPrvt("ADRIVER,NDRIVER,CBTXT,CBCONT,LI,M_PAG")
SetPrvt("CMESATU17,LIMPLIVRO,LIMPTERMOS,CARQABERT,CARQENCER,AVARIAVEIS")
SetPrvt("I,_CX1VAR01,ASAVSET,NMES,NDIA,DDATA1")
SetPrvt("DDATA2,NLIN,NLARGURA,NTAMANHO,_XDRV,CALIAS")
SetPrvt("APERG,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
굇旼컴컴컴컫컴컴컴쩡컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커굇
굇� DATA   � BOPS 쿛rogram.쿌LTERACAO                                      낢�
굇쳐컴컴컴컵컴컴컴탠컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇�23.04.98퀈xxxxx쿛ilar   쿔ncluido parametro MV_DIGVER p/ imprimir o digi낢�
굇�        �      �        퀃o de controle ou nao junto � conta contabil   낢�
굇쳐컴컴컴컨컴컴컴탠컴컴컴컵컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴컴컴컴컴캑굇
굇� RdMake 2/4.07 쿌utor   � Cristiano G Cunha  � Data �     21/01/00      낢�
굇읕컴컴컴컴컴컴컴좔컴컴컴컨컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴켸굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽
/*/

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 15/04/03 ==>    #DEFINE PSAY SAY
#ENDIF


/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � Conr080  � Autor � Wagner Xavier         � Data � 30.11.92 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Diario Geral                                               낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   � Conr080(void)                                              낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Generico                                                   낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

cString  := "SI2"
cDesc1   :=  "Este programa ir� imprimir o Di쟲io Geral, de acordo"
cDesc2   :=  "com os par긩etros sugeridos pelo usuario."
cDesc3   :=  ""
lExterno :=  .F.
wnRelExt :=  ""
aReturn  :=  { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
NomeProg := "CONR080"
aLinha   :=  { }
nLastKey :=  0
cPerg    := "COR080"
Tamanho  := "M"
wnrel    := "CONR080"

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Verifica as perguntas selecionadas                           �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
AjustaSX1()
pergunte("COR080",.F.)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis utilizadas para parametros                         �
//� mv_par01  	      	// da data                               �
//� mv_par02            // ate a data                            �
//� mv_par03            // Pagina Inicial                        �
//� mv_par04            // Pagina Final                          �
//� mv_par05            // So Livro/Livro e Termos/So Termos     �
//� mv_par06            // Imprime Balancete Mensal              �
//� mv_par07            // Imprime Balancete Trimestral          �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Pergunte("COR080",.T.)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Verifica as perguntas dos relatorios externos                �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If mv_par06 == 1 
	lExterno := .T.
   Pergunte( "CON040", .T. )
ElseIf mv_par07 == 1	
	lExterno := .T.
   Pergunte( "COR350", .T. )
EndIf

// Restaura as perguntas do relatorio
Pergunte("COR080",.f.)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis utilizadas no arquivo SIGACONR.INI �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Titulo  := "Emissao do Diario Geral"
Cabec1  := "  DATA   DEBITO      CREDITO      H I S T O R I C O                        NUMERO LINHA                   V   A   L   O   R"
Cabec2  := "                                                                           LANCTO                   DEBITO                 CREDITO"
cCancel := "***** CANCELADO PELO OPERADOR *****"
cTransp := "A Transportar =======>"
cTran   := "De Transporte =======>"
cTotDia := "Totais deste dia =======>"
cTotMes := "Totais deste mes =======>"
cTotGer := "Total Geral ============>"
cDiario := "D I A R I O    G E R A L"
cFolha  := "Folha:    "

cAbre   := "TERMO DE ABERTURA"
cEncerra:= "TERMO DE ENCERRAMENTO"

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Envia controle para a funcao SETPRINT                        �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If lExterno
	wnrelext := wnrel
EndIf

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

lEnd := .F.
#IFDEF WINDOWS
     RptStatus({|| Cr080Imp()},titulo)// Substituido pelo assistente de conversao do AP5 IDE em 15/04/03 ==>      RptStatus({|| Execute(Cr080Imp)},titulo)
     Return
// Substituido pelo assistente de conversao do AP5 IDE em 15/04/03 ==>      Function Cr080Imp
Static Function Cr080Imp()
#ENDIF

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
굇旼컴컴컴컴컴쩡컴컴컴컴컫컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴쩡컴컴컴컴커굇
굇� Fun뇚o    � Cr080Imp � Autor � Wagner Xavier         � Data � 05/11/93 낢�
굇쳐컴컴컴컴컴탠컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴좔컴컴컴컴캑굇
굇� Descri뇚o � Impressao do Diario Geral                                  낢�
굇쳐컴컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇� Sintaxe   � Cr080Imp(lEnd,wnRel,cString)                               낢�
굇쳐컴컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇� Uso       � SIGACON                                                    낢�
굇쳐컴컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇쿛arametros � lEnd    - A눯o do Codeblock                                낢�
굇�           � wnRel   - T죜ulo do relat줿io                              낢�
굇�           � cString - Mensagem                                         낢�
굇읕컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽
/*/

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Define Variaveis                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

nQuebra    := 0
nTotDiad   := 0
nTotDiac   := 0
nTotMesd   := 0
nTotMesc   := 0
nTotDeb    := 0
nTotCred   := 0
lTermo     := .T.
cSI2EmpFil := ""
dSI2Data   := Ctod("")
cSI2Num    := ""
nSI2Reg    := 0
lComplHist := .T.
cDigVer    := GetMv("MV_DIGVER")
Limite     := 132
aDriver    := {}
nDriver    := 0

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
cbtxt     := SPACE(10)
cbcont    := 0
Li        := 80
m_pag     := 1
cMesAtu17 := ""

aDriver   := ReadDriver()

If Tamanho == 'P' .AND. aReturn[4] == 1
   nDriver := 1
ElseIf Tamanho == 'P' .AND. aReturn[4] == 2
   nDriver := 2
ElseIf Tamanho == 'M' .AND. aReturn[4] == 1
   nDriver := 3
ElseIf Tamanho == 'M' .AND. aReturn[4] == 2
   nDriver := 4
ElseIf Tamanho == 'G' .AND. aReturn[4] == 1
   nDriver := 5
ElseIf Tamanho == 'G' .AND. aReturn[4] == 2
   nDriver := 6
Endif

If ! DataMoeda(1, @cMesAtu17, mv_par01) .or. !DataMoeda(1, @cMesAtu17, mv_par02)
	#IFNDEF WINDOWS
		Set Device To Screen
	#ENDIF	
   Help(" ",1,"MESINVALID")
	Set Filter To
	Return
End

m_Pag := mv_par03

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Impressao de Termo / Livro                                   �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

Do Case
   Case mv_par05==1 ; LimpLivro:=.t. ; LimpTermos:=.f.
   Case mv_par05==2 ; LimpLivro:=.t. ; LimpTermos:=.t.
   Case mv_par05==3 ; LimpLivro:=.f. ; LimpTermos:=.t.
EndCase		

If LimpTermos                                                   // Impressao dos Termos

   cArqAbert := GetMv("MV_LDIARAB")
   cArqEncer := GetMv("MV_LDIAREN")

	dbSelectArea("SM0")
   aVariaveis := {}

   For i := 1 to FCount() 
      If FieldName(i) == "M0_CGC"
			AADD(aVariaveis,{FieldName(i),Transform(FieldGet(i),"@R 99.999.999/9999-99")})
		Else
         If FieldName(i)=="M0_NOME"
            Loop
         EndIf
			AADD(aVariaveis,{FieldName(i),FieldGet(i)})
		Endif
	Next

	dbSelectArea("SX1")
	dbSeek("COR080"+"01")

   While SX1->X1_GRUPO == "COR080"
         _cX1Var01 := &X1_VAR01
         AADD(aVariaveis,{Rtrim(Upper(X1_VAR01)),_cX1Var01})
         dbSkip()
	End

	If !File(cArqAbert)
		aSavSet:=__SetSets()
      cArqAbert:=CFGX024(," Diario Geral.") // Editor de Termos de Livros
		__SetSets(aSavSet)
		Set(24,Set(24),.t.)
	Endif

	If !File(cArqEncer)
		aSavSet:=__SetSets()
      cArqEncer:=CFGX024(," Diario Geral.") // Editor de Termos de Livros
		__SetSets(aSavSet)
		Set(24,Set(24),.t.)
	Endif

	If cArqAbert#NIL
      ImpTerm(cArqAbert,aVariaveis,AvalImp(Limite))
	Endif

	If cArqEncer#NIL
                ImpTerm(cArqEncer,aVariaveis,AvalImp(Limite))
	Endif	 
	Eject
Endif

@ 0,0 PSAY AvalImp(Limite)

If LimpLivro // Impressao dos Livros

	SetRegua(Reccount())

	dbSelectArea("SI2")
	dbSetOrder(3)
	Set SoftSeek On

   dbSeek(xFilial("SI2")+dtos(mv_par01))

	Set SoftSeek Off


   While !Eof() .and. I2_DATA <= mv_par02 .and. I2_FILIAL==xFilial("SI2")


		#IFNDEF WINDOWS
			Inkey()
         If Lastkey() == 286
				lEnd := .T.
			EndIf	
		#ENDIF

		IF lEnd
         @Prow()+1, 0 PSAY cCancel 
			Exit
		EndIF

                IF I2_VALOR == 0 .or. Substr(I2_MOEDAS,1,1) != "S"
			dbSkip()
			Loop
		EndIF

		nMes:=Month(I2_data)
	
      While nMes==Month(I2_DATA).and.!Eof().and.I2_DATA<=mv_par02 .and.xFilial("SI2")==I2_FILIAL

         IF I2_VALOR == 0 .or. Substr(I2_MOEDAS,1,1) != "S"
				dbSkip()
				Loop
			EndIF

			nDia :=Day(I2_DATA)
		
			While nMes==Month(I2_DATA).and.!Eof().and.I2_DATA<=mv_par02 .and.;
            xFilial("SI2")==I2_FILIAL .and.nDia==Day(I2_DATA)
				#IFNDEF WINDOWS
					Inkey()
               If Lastkey() == 286
						lEnd := .T.
					EndIf	
				#ENDIF

				IF lEnd
               @Prow()+1, 0 PSAY cCancel 
					Exit
				EndIF

				IncRegua()

            IF I2_VALOR == 0 .or. Substr(I2_MOEDAS,1,1) != "S"
					dbSkip()
					Loop
				EndIF
		
            IF Li > 58
               Li := Li + 1
					IF nQuebra > 0 .And. ( nTotDiaD #0 .or. nTotDiaC # 0 )
                  @Li,055 PSAY cTransp
						If nTotDiaD #0
                     @Li,090 PSAY nTotDiaD   Picture "@E 999,999,999,999.99"
						EndIf
						If nTotDiaC #0
                     @Li,114 PSAY nTotDiaC   Picture "@E 999,999,999,999.99"
						EndIf
					EndIF
					IF m_pag==mv_par04
						m_pag:=2
					EndIF
               Li := Li + 1
               dData1 := mv_par01
               dData2 := mv_par02
               cr080Cabec()
					IF nQuebra > 0 .And. ( nTotDiaD #0 .or. nTotDiaC # 0 )
                  @Li,055 PSAY cTran
						If nTotDiaD #0
                     @Li,090 PSAY nTotDiaD   Picture "@E 999,999,999,999.99"
						End
						If nTotDiaC #0
                     @Li,114 PSAY nTotDiaC   Picture "@E 999,999,999,999.99"
						End
                  Li := Li + 1
					EndIF
					nQuebra:=1
				EndIF   

				*** "X" - Debito e Credito       ***
				*** "D" - Debito                 ***
				*** "C" - Credito                ***
				*** "-" - Historico Complementar ***
   
				IF I2_DC != "-"
               @Li, 0 PSAY I2_DATA
					If cDigVer == "S"
						If !Empty(I2_DEBITO)
                     @Li, 9 PSAY AllTrim(I2_DEBITO)+SI2->I2_DCD
						EndiF
						If !Empty(I2_CREDITO)	
                     @Li,21 PSAY allTrim(I2_CREDITO)+SI2->I2_DCC
						EndIf	
					Else
						If !Empty(I2_DEBITO)
                     @Li, 9 PSAY AllTrim(I2_DEBITO)
						EndIf	
						If !Empty(I2_CREDITO)	
                     @Li,21 PSAY allTrim(I2_CREDITO)
						EndIf	
					EndIf	
               @Li,34 PSAY I2_HIST
               @Li,75 PSAY I2_NUM+I2_LINHA
				EndIF
      
				IF I2_DC $ "DX"
               @Li,090 PSAY I2_VALOR   Picture "@E 999,999,999,999.99"
               nTotDeb  := nTotDeb  + I2_VALOR
               nTotDiad := nTotDiad + I2_VALOR
               nTotMesD := nTotMesD + I2_VALOR
            EndIF
      
				IF I2_DC $ "CX"
               @Li,114 PSAY I2_VALOR Picture "@E 999,999,999,999.99"
               nTotCred := nTotCred + I2_VALOR
               nTotdiac := nTotdiac + I2_VALOR
               nTotMesc := nTotMesc + I2_VALOR
				EndIF
				//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
				//� Complemento de Historico - Tratamento                    �
				//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
				lComplHist := .T.
				dSI2Data   := SI2->I2_DATA
				cSI2Num    := SI2->I2_NUM
				cSI2EmpFil := SI2->I2_EMPORIG+SI2->I2_FILORIG
				nSI2Reg    := RecNo()
				dbSkip()
				While ( !Eof()						.And.;
						SI2->I2_DATA == dSI2Data	.And.;
						SI2->I2_NUM  == cSI2Num		.And.;
						lComplHist )
					If ( SI2->I2_EMPORIG+SI2->I2_FILORIG  == cSI2EmpFil )
						If ( SI2->I2_DC == "-" )
                     Li := Li + 1
                     IF Li > 58
								IF m_pag==mv_par04
									m_pag:=2
								EndIf
								If ( m_pag < mv_par04 .And. ;
									( nTotDiaD #0 .or. nTotDiaC # 0 ) )      /* alterado de > para < */
                           @Li,055 PSAY cTransp
									If nTotDiaD #0
                              @Li,90 PSAY nTotDiad Picture "@E 999,999,999,999.99"
									EndIf
									If nTotDiaC #0
                              @Li,114 PSAY nTotDiac Picture "@E 999,999,999,999.99"
									EndIf
								EndIF
                        Li := Li + 1
                        dData1 := mv_par01
                        dData2 := mv_par02
                        cr080Cabec()
								If (nTotDiaD #0 .or. nTotDiaC # 0 )
                           @Li,055  PSAY cTran
									If nTotDiaD #0
                              @Li,090  PSAY  nTotDiad  Picture "@E 999,999,999,999.99"
									EndIf
									If nTotDiaC #0
                              @Li,114  PSAY  nTotDiac  Picture "@E 999,999,999,999.99"
									EndIf
								EndIf
                        Li := Li + 1                /* incluido */
							EndIf
                     @Li,34 PSAY I2_HIST
						Else
							lComplHist := .F.
						EndIf
					EndIf
					dbSelectArea("SI2")
					dbSkip()
				End
				dbSelectArea("SI2")
				dbGoto(nSI2Reg)
				dbSkip()
				//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
				//� Se for Complemente de Historico Salta                    �
				//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
				While ( !Eof() .And. SI2->I2_DC=="-" )
					dbSelectArea("SI2")
					dbSkip()
				End	

            Li := Li + 1
            IF Li > 58
					IF m_pag==mv_par04
						m_pag:=2
					End
					If (nTotDiaD #0 .or. nTotDiaC # 0 )
                  @Li,055  PSAY cTransp
                  If nTotDiaD #0
                     @Li,090  PSAY  nTotDiad Picture "@E 999,999,999,999.99"
						EndIf
						If nTotDiaC #0
                     @Li,114  PSAY  nTotDiac  Picture "@E 999,999,999,999.99"
						EndIf
					EndIf
               Li := Li + 1
               dData1 := mv_par01
               dData2 := mv_par02
               cr080Cabec()
					If (nTotDiaD #0 .or. nTotDiaC # 0 )
                  @Li,055  PSAY cTran
						If nTotDiaD #0
                     @Li,090  PSAY  nTotDiad Picture "@E 999,999,999,999.99"
                  EndIf
						If nTotDiaC #0
                     @Li,114  PSAY  nTotDiac Picture "@E 999,999,999,999.99"
						EndIf
					EndIf
               Li := Li + 1
				EndIF
			EndDO
			If lEnd
				Exit
			Endif	
			IF (nTotDiad+nTotDiac)>0
            Li := Li + 1
            @Li,055 PSAY cTotDia 
            @Li,090 PSAY nTotDiad Picture  "@E 999,999,999,999.99"
            @Li,114 PSAY nTotDiac Picture  "@E 999,999,999,999.99"
				nTotDiad:=0
				nTotDiac:=0
            Li := Li + 2
			EndIF
		EndDO
		If lEnd
			Exit
		End	
		IF (nTotMesd+nTotMesc)>0
         @Li,055 PSAY cTotMes
         @Li,090 PSAY nTotMesd Picture "@E 999,999,999,999.99"
         @Li,114 PSAY nTotMesc Picture "@E 999,999,999,999.99"
			nTotMesD:=0
			nTotMesC:=0
         Li := Li + 2
		EndIF
	EndDO

	IF (nTotDiad+nTotDiac)>0 .And. !lEnd
      Li := Li + 1
      @Li,055 PSAY cTotDia
      @Li,090 PSAY nTotDiad Picture "@E 999,999,999,999.99"
      @Li,114 PSAY nTotDiac Picture "@E 999,999,999,999.99"
      Li := Li + 1

      @Li,055 PSAY cTotMes
      @Li,090 PSAY nTotMesd Picture "@E 999,999,999,999.99"
      @Li,114 PSAY nTotMesc Picture "@E 999,999,999,999.99"
      Li := Li + 1
	EndIF

	IF (nTotDeb+nTotCred)>0 .And. !lEnd
      @Li,055 PSAY cTotGer 
      @Li,090 PSAY nTotDeb  Picture "@E 999,999,999,999.99"
      @Li,114 PSAY nTotCred Picture "@E 999,999,999,999.99"
	EndIF

	dbSelectarea("SI2")
	dbSetOrder(1)
	Set Filter To
End

If mv_par06 == 1
	Conr040(lExterno,wnRel)
EndIf

Pergunte( "COR080", .F. )
If mv_par07 == 1
	Conr350(lExterno,wnRel)
EndIf		

#IFNDEF WINDOWS
	Set Device To Screen
#ENDIF	
If aReturn[5] == 1
	Set Printer To
	Commit
	Ourspool(wnrel)
End
MS_FLUSH()

Return

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    쿬r080Cabec� Autor � Pilar S. Albaladejo   � Data � 22.03.95 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Rotina de impressao do cabecalho do balanco geral          낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe e � cr080cabec(dData1,dData2)                                  낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛arametros�                                                            낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Generico                                                   낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

// Substituido pelo assistente de conversao do AP5 IDE em 15/04/03 ==> Function cr080cabec
Static Function cr080cabec()

nLin     := 1
nlargura := 132
nTamanho := "M"

#IFDEF PROTHEUS                 // Para Protheus
  _xDrv := aDriver[nDriver]
  @ 0,00 PSAY &_xDrv
#ELSE
  @ 0,00 PSAY &aDriver[nDriver]
#ENDIF

@ nLin, 00 PSAY Replicate("*",nlargura)
nLin := nLin + 1
@ nLin, 00 PSAY "*" 
@ nLin, Int((nlargura - (Len(Trim(SM0->M0_NOMECOM))))/2) PSAY SM0->M0_NOMECOM
@ nLin, nlargura-18 PSAY cFolha + Transform(m_pag,'99999')+"  *"
nLin := nLin + 1
@ nLin, 00 PSAY "*"
@ nLin, Int((nlargura - 18)/2) PSAY Transform(Alltrim(SM0->M0_CGC),"@R 99.999.999/9999-99")
@ nLin, nLargura-1 PSAY "*"
nLin := nLin + 1
@ nLin, 00 PSAY "*"
@ nLin, Int((nLargura - 26)/2) PSAY cDiario
@ nLin, nLargura - 1 PSAY "*"
nLin := nLin + 1
@ nLin, 00 PSAY "*"
@ nLin, Int((nLargura - 19)/2) PSAY dtoc(dData1) + " - " + dtoc(dData2)
@ nLin, nLargura - 1 PSAY "*"
nLin := nLin + 1
@ nLin, 00 PSAY RepLicate("*",nlargura)
nLin := nLin + 1
@ nLin, 00 PSAY cabec1
nLin := nLin + 1
@ nLin, 00 PSAY cabec2
nLin := nLin + 1
@ nLin, 00 PSAY RepLicate("*",nlargura)
Li := 11
m_pag := m_pag + 1

Return


// Substituido pelo assistente de conversao do AP5 IDE em 15/04/03 ==> Function AjustaSX1
Static Function AjustaSX1()

cAlias := Alias()
aPerg  := {}
cPerg  := "COR080"

Aadd(aPerg,{"Impr Balanc Mensal ?","N",01} )
Aadd(aPerg,{"Impr Balanc Trimest?","N",01} )

dbSelectArea("SX1")
If !dbSeek(cPerg+"06")
	RecLock("SX1",.T.)
	Replace X1_GRUPO   	with cPerg
	Replace X1_ORDEM   	with "06"
	Replace X1_PERGUNT 	with aPerg[1][1]
	Replace X1_VARIAVL 	with "mv_ch6"
	Replace X1_TIPO	 	with aPerg[1][2]
	Replace X1_TAMANHO 	with aPerg[1][3]
	Replace X1_PRESEL  	with 2
	Replace X1_GSC	   	with "C"
	Replace X1_VAR01   	with "mv_par06"
	Replace X1_DEF01   	with "Sim"
	Replace X1_CNT01     with ""
	Replace X1_DEF02   	with "Nao"
EndIf
dbSelectArea("SX1")
If !dbSeek(cPerg+"07")
	RecLock("SX1",.T.)
	Replace X1_GRUPO   	with cPerg
	Replace X1_ORDEM   	with "07"
	Replace X1_PERGUNT 	with aPerg[2][1]
	Replace X1_VARIAVL 	with "mv_ch7"
	Replace X1_TIPO	 	with aPerg[2][2]
	Replace X1_TAMANHO 	with aPerg[2][3]
	Replace X1_PRESEL  	with 2
	Replace X1_GSC	   	with "C"
	Replace X1_VAR01   	with "mv_par07"
	Replace X1_DEF01   	with "Sim"
	Replace X1_CNT01     with ""	
	Replace X1_DEF02   	with "Nao"
EndIf

dbSelectArea(cAlias)
Return

