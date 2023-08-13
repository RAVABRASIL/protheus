#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATPDV     º Autor ³ Manel AP6 IDE     º Data ³  10/04/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de pedidos de venda consolidados.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/     

/*
MV_PAR01 = Pedido inical
MV_PAR02 = Pedido final
*/

*************

User Function FATPDV()

*************


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "PEDIDO DE VENDA"
Local cPict          := ""
Local titulo       	:= "PEDIDO DE VENDA"
Local nLin         	:= 80

Local Cabec1       	:= ""
Local Cabec2       	:= ""
Local imprime      	:= .T.
Local aOrd 				:= {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "FATPDV" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "FATPDV" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString 		:= ""

//
if alltrim(upper(FunName())) == "MATA410"  // Browse do Pedido de Venda  
   dbSelectArea( "SX1" )
   dbSetOrder( 1 )
   for x:=1 to 2
	   cOrdem:=StrZero( x, 2 )
	   If dbSeek( "FATPDV    "+cOrdem ) 
	      RecLock( "SX1", .F. )  
	      X1_CNT01:=SC5->C5_NUM
	      MsUnlock()
	   Endif  
   next
endif
//

pergunte('FATPDV', .T.)	

if empty(mv_par02)
	mv_par02 := mv_par01
endIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  10/04/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
*************

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

*************

Local cQuery := ""
Local nOrdem
Local aArret := {}
Local nX  	 := 1, nJump:= nTotal := 0
Local aObs   := {}

cQuery := "select	SC5.C5_NUM, SC5.C5_VEND1, SA3.A3_NREDUZ, SC5.C5_COMIS1, SE4.E4_DESCRI, SC5.C5_TPFRETE, "
cQuery += "SA1.A1_NREDUZ, SA1.A1_CONTATO, SA1.A1_COD, SA1.A1_END, SA1.A1_BAIRRO, SA1.A1_MUN, SC5.C5_EMISSAO, "
cQuery += "SA1.A1_EST, SA1.A1_CEP, SA1.A1_TEL, SA1.A1_CELULAR, SA1.A1_FAX, SA1.A1_EMAIL, SC5.C5_OBSFIN, "
cQuery += "SA1.A1_CGC, SA1.A1_INSCR, SC5.C5_OBS,SA1.A1_LOJA "
cQuery += "from 	" + retSqlName('SA1') + " SA1, " + retSqlName('SA3') + " SA3, " + retSqlName('SC5') + " SC5, "
cQuery += " "+ retSqlName('SE4') + " SE4 "
cQuery += "where	SC5.C5_VEND1 = SA3.A3_COD and SC5.C5_CLIENTE+SC5.C5_LOJACLI = SA1.A1_COD+SA1.A1_LOJA and SE4.E4_CODIGO = SC5.C5_CONDPAG and "
cQuery += "SC5.C5_NUM between '"+mv_par01+"' and '"+mv_par02+"' AND "
//cQuery += "SC5.C5_VEND1 = '0240' AND "
cQuery += "SC5.C5_FILIAL = '"+xFilial('SC5')+"' and SC5.D_E_L_E_T_ != '*' and "
cQuery += "SA1.A1_FILIAL = '"+xFilial('SA1')+"' and SA1.D_E_L_E_T_ != '*' and "
cQuery += "SA3.A3_FILIAL = '"+xFilial('SA3')+"' and SA3.D_E_L_E_T_ != '*' "
cQuery := changeQuery( cQuery )
TCQUERY cQuery NEW ALIAS 'TMP'
TMP->( dbGoTop() )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(10)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

do While TMP->( !EoF() )

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

   If nLin > 55//55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      //nLin := 8
   Endif
			            //        10        20        30        40        50        60        70        80        90       100       110       120        130
                     //12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
   @Prow()+1,000 PSAY "****************************************** Informacoes sobre a venda nº:"+alltrim(TMP->C5_NUM)+" *****************************************************"
   @Prow()+1,000 PSAY "*Data:          Vend/Cod.:                                     Comissao:                      Cond. Pag.:               Frete:     *"
   /**/
   @Prow()	,007 PSAY stod( TMP->C5_EMISSAO )
   @Prow()  ,028 PSAY substr( TMP->C5_VEND1,  1, 6 ) + "/" + substr(TMP->A3_NREDUZ,1,25)
   @Prow()	,073 PSAY transform(TMP->C5_COMIS1, "@E 999,999.99" )//substr( alltrim( str(TMP->C5_COMIS1) ), 1, 2 )
   @Prow()	,106 PSAY alltrim( TMP->E4_DESCRI )
   @Prow()	,128 PSAY iif( alltrim( TMP->C5_TPFRETE ) == 'C', 'CIF', 'FOB')
   /**/
   @Prow()+1,000 PSAY "************************************************* Informacoes sobre o cliente ******************************************************"
   //@Prow()+1,000 PSAY "*Nome:                                            Contato:                        Codigo:                                          *"
     @Prow()+1,000 PSAY "*Nome:                                            Contato:                        Codigo:         Loja:                            *"
   /**/
	@Prow()	,007 PSAY alltrim( TMP->A1_NREDUZ )
	@Prow()	,059 PSAY alltrim( TMP->A1_CONTATO )
	@Prow()	,090 PSAY alltrim( TMP->A1_COD )
	@Prow()	,104 PSAY alltrim( TMP->A1_LOJA )
	/**/
   @Prow()+1,000 PSAY "*End.:                                                Bairro:                     Cidade:                               U.F.:      *"
   /**/
   @Prow()	,007 PSAY substr( alltrim( TMP->A1_END ), 1, 47 )
   @Prow()	,062 PSAY alltrim( TMP->A1_BAIRRO 	)
   @Prow()	,090 PSAY alltrim( TMP->A1_MUN 		)
	@Prow()	,126 PSAY alltrim( TMP->A1_EST 		)
	/**/
			            //        10        20        30        40        50        60        70        80        90       100       110       120        130
                     //12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
   @Prow()+1,000 PSAY "*CEP.:          Fone:                          Celular:                    Fax:                    E-Mail:                         *"
   /**/
   @Prow()	,007 PSAY alltrim( TMP->A1_CEP 		)
   @Prow()	,022 PSAY alltrim( TMP->A1_TEL 		)
   @Prow()	,056 PSAY alltrim( TMP->A1_CELULAR 	)
   @Prow()	,061 PSAY substr(alltrim( TMP->A1_FAX 		),1,19)
   @Prow()	,107 PSAY substr(alltrim( TMP->A1_EMAIL	),1,25)
   /**/
   @Prow()+1,000 PSAY "*CNPJ:                                         Insc. Est.:                                                                         *"
   /**/
   @Prow()	,007 PSAY alltrim( TMP->A1_CGC   	)
   @Prow()	,059 PSAY alltrim( TMP->A1_INSCR 	)
   /**/
	aArret := secQuery( TMP->C5_NUM )
			            //        10        20        30        40        50        60        70        80        90       100       110       120        130
                     //12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
   @Prow()+1,000 PSAY "************************************************* Informacoes sobre os produtos ****************************************************"
   @Prow()+1,000 PSAY "*It |   Cod.    | Quant    |Uni|               Produtos               |    Cor     |  Larg.  |  Altu.  | Preco Unit.  |   Total    *"
   @Prow()+1,000 PSAY "************************************************************************************************************************************"
   @Prow()+1,000 PSAY "*01 |           |          |   |                                      |            |         |         |              |            *"
   //aAdd( aRet, {alltrim(TMP2->C6_PRODUTO), alltrim(str(TMP2->C6_QTDVEN)), alltrim(TMP2->C6_UM), alltrim(TMP2->B1_DESC),;
   //				 alltrim(cCor), alltrim(str(nLArg)), alltrim(str(nAltu)), TMP2->C6_PRUNIT } )
   if len(aArret) >= 1 .AND. len(aArret) >= nJump + 1
 		@Prow(),007 PSAY aArret[1+nJump][1]
 		@Prow(),018 PSAY transform(val(aArret[1+nJump][2]), '@E 999999.999')
 		@Prow(),029 PSAY aArret[1+nJump][3]
 		@Prow(),033 PSAY substr(aArret[1+nJump][4],1,37)
 		@Prow(),072 PSAY aArret[1+nJump][5]
 		@Prow(),088 PSAY aArret[1+nJump][6]
 		@Prow(),098 PSAY transform(val(aArret[1+nJump][7]), '@E 999' )
 		@Prow(),105 PSAY transform(aArret[1+nJump][8], '@E 999,999.99')
 		nTotal += aArret[1+nJump][8] * val(aArret[1+nJump][2])
 		@Prow(),119 PSAY transform(aArret[1+nJump][8] * val(aArret[1+nJump][2]), '@E 999,999,999.99')
   endIf
   @Prow()+1,000 PSAY "*02 |           |          |   |                                      |            |         |         |              |            *"
   if len(aArret) >= 2 .AND. len(aArret) >= nJump + 2
 		@Prow(),007 PSAY aArret[2+nJump][1]
 		//@Prow(),018 PSAY transform(val(aArret[1+nJump][2]), '@E 999999.999')
 		@Prow(),018 PSAY transform(val(aArret[2+nJump][2]), '@E 999999.999')
 		@Prow(),029 PSAY aArret[2+nJump][3]
 		@Prow(),033 PSAY substr(aArret[2+nJump][4],1,37)
 		@Prow(),072 PSAY aArret[2+nJump][5]
 		@Prow(),088 PSAY aArret[2+nJump][6]
 		@Prow(),098 PSAY transform(val(aArret[2+nJump][7]), '@E 999' )
 		@Prow(),105 PSAY transform(aArret[2+nJump][8], '@E 999,999.99')
 		nTotal += aArret[2+nJump][8] * val(aArret[2+nJump][2])
 		@Prow(),119 PSAY transform(aArret[2+nJump][8] * val(aArret[2+nJump][2]), '@E 999,999,999.99')
   endIf
   @Prow()+1,000 PSAY "*03 |           |          |   |                                      |            |         |         |              |            *"
   if len(aArret) >= 3 .AND. len(aArret) >= nJump + 3
 		@Prow(),007 PSAY aArret[3+nJump][1]
 		//@Prow(),018 PSAY transform(val(aArret[1+nJump][2]), '@E 999999.999')
 		@Prow(),018 PSAY transform(val(aArret[3+nJump][2]), '@E 999999.999')
 		@Prow(),029 PSAY aArret[3+nJump][3]
 		@Prow(),033 PSAY substr(aArret[3+nJump][4],1,37)
 		@Prow(),072 PSAY aArret[3+nJump][5]
 		@Prow(),088 PSAY aArret[3+nJump][6]
 		@Prow(),098 PSAY transform(val(aArret[3+nJump][7]), '@E 999' )
 		@Prow(),105 PSAY transform(aArret[3+nJump][8], '@E 999,999.99')
 		nTotal += aArret[3+nJump][8] * val(aArret[3+nJump][2])
 		@Prow(),119 PSAY transform(aArret[3+nJump][8] * val(aArret[3+nJump][2]), '@E 999,999,999.99')
   endIf
   @Prow()+1,000 PSAY "*04 |           |          |   |                                      |            |         |         |              |            *"
   if len(aArret) >= 4 .AND. len(aArret) >= nJump + 4
 		@Prow(),007 PSAY aArret[4+nJump][1]
 		//@Prow(),018 PSAY transform(val(aArret[1+nJump][2]), '@E 999999.999')
 		@Prow(),018 PSAY transform(val(aArret[4+nJump][2]), '@E 999999.999')
 		@Prow(),029 PSAY aArret[4+nJump][3]
 		@Prow(),033 PSAY substr(aArret[4+nJump][4],1,37)
 		@Prow(),072 PSAY aArret[4+nJump][5]
 		@Prow(),088 PSAY aArret[4+nJump][6]
 		@Prow(),098 PSAY transform(val(aArret[4+nJump][7]), '@E 999')
 		@Prow(),105 PSAY transform(aArret[4+nJump][8], '@E 999,999.99')
 		nTotal += aArret[4+nJump][8] * val(aArret[4+nJump][2])
 		@Prow(),119 PSAY transform( aArret[4+nJump][8] * val(aArret[4+nJump][2]), '@E 999,999,999.99')
   endIf
   @Prow()+1,000 PSAY "*05 |           |          |   |                                      |            |         |         |              |            *"
   if len(aArret) >= 5 .AND. len(aArret) >= nJump + 5
 		@Prow(),007 PSAY aArret[5+nJump][1]
 		//@Prow(),018 PSAY transform(val(aArret[1+nJump][2]), '@E 999999.999')
 		@Prow(),018 PSAY transform(val(aArret[5+nJump][2]), '@E 999999.999')
 		@Prow(),029 PSAY aArret[5+nJump][3]
 		@Prow(),033 PSAY substr(aArret[5+nJump][4],1,37)
 		@Prow(),072 PSAY aArret[5+nJump][5]
 		@Prow(),088 PSAY aArret[5+nJump][6]
 		@Prow(),098 PSAY transform(val(aArret[5+nJump][7]), '@E 999')
 		@Prow(),105 PSAY transform(aArret[5+nJump][8], '@E 999,999.99')
 		nTotal += aArret[5+nJump][8] * val(aArret[5+nJump][2])
 		@Prow(),119 PSAY transform( aArret[5+nJump][8] * val(aArret[5+nJump][2]), '@E 999,999,999.99')
   endIf
   @Prow()+1,000 PSAY "*06 |           |          |   |                                      |            |         |         |              |            *"
   if len(aArret) >= 6 .AND. len(aArret) >= nJump + 6
 		@Prow(),007 PSAY aArret[6+nJump][1]
 		//@Prow(),018 PSAY transform(val(aArret[1+nJump][2]), '@E 999999.999')
 		@Prow(),018 PSAY transform(val(aArret[6+nJump][2]), '@E 999999.999')
 		@Prow(),029 PSAY aArret[6+nJump][3]
 		@Prow(),033 PSAY substr(aArret[6+nJump][4],1,37)
 		@Prow(),072 PSAY aArret[6+nJump][5]
 		@Prow(),088 PSAY aArret[6+nJump][6]
 		@Prow(),098 PSAY transform(val(aArret[6+nJump][7]), '@E 999')
 		@Prow(),105 PSAY transform(aArret[6+nJump][8], '@E 999,999.99')
 		nTotal += aArret[6+nJump][8] * val(aArret[6+nJump][2])
 		@Prow(),119 PSAY transform(aArret[6+nJump][8] * val(aArret[6+nJump][2]), '@E 999,999,999.99')
   endIf
   @Prow()+1,000 PSAY "*07 |           |          |   |                                      |            |         |         |              |            *"
   if len(aArret) >= 7 .AND. len(aArret) >= nJump + 7
 		@Prow(),007 PSAY aArret[7+nJump][1]
 		//@Prow(),018 PSAY transform(val(aArret[1+nJump][2]), '@E 999999.999')
 		@Prow(),018 PSAY transform(val(aArret[7+nJump][2]), '@E 999999.999')
 		@Prow(),029 PSAY aArret[7+nJump][3]
 		@Prow(),033 PSAY substr(aArret[7+nJump][4],1,37)
 		@Prow(),072 PSAY aArret[7+nJump][5]
 		@Prow(),088 PSAY aArret[7+nJump][6]
 		@Prow(),098 PSAY transform(val(aArret[7+nJump][7]), '@E 999')
 		@Prow(),105 PSAY transform(aArret[7][8], '@E 999,999.99')
 		nTotal += aArret[7+nJump][8] * val(aArret[7+nJump][2])
 		@Prow(),119 PSAY transform( aArret[7+nJump][8] * val(aArret[7+nJump][2]), '@E 999,999,999.99')
   endIf
   @Prow()+1,000 PSAY "*08 |           |          |   |                                      |            |         |         |              |            *"
   if len(aArret) >= 8 .AND. len(aArret) >= nJump + 8
 		@Prow(),007 PSAY aArret[8+nJump][1]
 		//@Prow(),018 PSAY transform(val(aArret[1+nJump][2]), '@E 99999.999')
 		@Prow(),018 PSAY transform(val(aArret[8+nJump][2]), '@E 999999.999')
 		@Prow(),029 PSAY aArret[8+nJump][3]
 		@Prow(),033 PSAY substr(aArret[8+nJump][4],1,37)
 		@Prow(),072 PSAY aArret[8+nJump][5]
 		@Prow(),088 PSAY aArret[8+nJump][6]
 		@Prow(),098 PSAY transform(val(aArret[8+nJump][7]), '@E 999')
 		@Prow(),105 PSAY transform(aArret[8+nJump][8], '@E 999,999.99')
 		nTotal += aArret[8+nJump][8] * val(aArret[8+nJump][2])
 		@Prow(),119 PSAY transform(aArret[8+nJump][8] * val(aArret[8+nJump][2]), '@E 999,999,999.99')
   endIf
   @Prow()+1,000 PSAY "*09 |           |          |   |                                      |            |         |         |              |            *"
   if len(aArret) >= 9 .AND. len(aArret) >= nJump + 9
 		@Prow(),007 PSAY aArret[9+nJump][1]
 		//@Prow(),018 PSAY transform(val(aArret[1+nJump][2]), '@E 999999.999')
 		@Prow(),018 PSAY transform(val(aArret[9+nJump][2]), '@E 999999.999')
 		@Prow(),029 PSAY aArret[9+nJump][3]
 		@Prow(),033 PSAY substr(aArret[9+nJump][4],1,37)
 		@Prow(),072 PSAY aArret[9+nJump][5]
 		@Prow(),088 PSAY aArret[9+nJump][6]
 		@Prow(),098 PSAY transform(val(aArret[9+nJump][7]), '@E 999')
 		@Prow(),105 PSAY transform(aArret[9+nJump][8], '@E 999,999.99')
 		nTotal += aArret[9+nJump][8] * val(aArret[9+nJump][2])
 		@Prow(),119 PSAY transform(aArret[9+nJump][8] * val(aArret[9+nJump][2]), '@E 999,999,999.99')
   endIf
   @Prow()+1,000 PSAY "*10 |           |          |   |                                      |            |         |         |              |            *"
   if len(aArret) >= 10 .AND. len(aArret) >= nJump + 10
 		@Prow(),007 PSAY aArret[10+nJump][1]
 		//@Prow(),018 PSAY transform(val(aArret[1+nJump][2]), '@E 999999.999')
 		@Prow(),018 PSAY transform(val(aArret[10+nJump][2]), '@E 999999.999')
 		@Prow(),029 PSAY aArret[10+nJump][3]
 		@Prow(),033 PSAY substr(aArret[10+nJump][4],1,37)
 		@Prow(),072 PSAY aArret[10+nJump][5]
 		@Prow(),088 PSAY aArret[10+nJump][6]
 		@Prow(),098 PSAY transform(val(aArret[10+nJump][7]), '@E 999')
 		@Prow(),105 PSAY transform(aArret[10+nJump][8], "@E 999,999.99")
 		nTotal += aArret[10+nJump][8] * val(aArret[10+nJump][2])
 		@Prow(),119 PSAY transform(aArret[10+nJump][8] * val(aArret[10+nJump][2]), '@E 999,999,999.99')
   endIf
   @Prow()+1,000 PSAY "*11 |           |          |   |                                      |            |         |         |              |            *"
   if len(aArret) >= 11 .AND. len(aArret) >= nJump + 11
 		@Prow(),007 PSAY aArret[11+nJump][1]
 		//@Prow(),018 PSAY transform(val(aArret[1+nJump][2]), '@E 999999.999')
 		@Prow(),018 PSAY transform(val(aArret[11+nJump][2]), '@E 999999.999')
 		@Prow(),029 PSAY aArret[11+nJump][3]
 		@Prow(),033 PSAY substr(aArret[11+nJump][4],1,37)
 		@Prow(),072 PSAY aArret[11+nJump][5]
 		@Prow(),088 PSAY aArret[11+nJump][6]
 		@Prow(),098 PSAY transform(val(aArret[11+nJump][7]), '@E 999')
 		@Prow(),105 PSAY transform(aArret[11+nJump][8], '@E 999,999.99')
 		nTotal += aArret[11+nJump][8] * val(aArret[11+nJump][2])
 		@Prow(),119 PSAY transform(aArret[11+nJump][8] * val(aArret[11+nJump][2]), '@E 999,999,999.99')
   endIf
   @Prow()+1,000 PSAY "*12 |           |          |   |                                      |            |         |         |              |            *"
   if len(aArret) >= 12 .AND. len(aArret) >= nJump + 12
 		@Prow(),007 PSAY aArret[12+nJump][1]
 		//@Prow(),018 PSAY transform(val(aArret[1+nJump][2]), '@E 999999.999')
 		@Prow(),018 PSAY transform(val(aArret[12+nJump][2]), '@E 999999.999')
 		@Prow(),029 PSAY aArret[12+nJump][3]
 		@Prow(),033 PSAY substr(aArret[12+nJump][4],1,37)
 		@Prow(),072 PSAY aArret[12+nJump][5]
 		@Prow(),088 PSAY aArret[12+nJump][6]
 		@Prow(),098 PSAY transform(val(aArret[12+nJump][7]), '@E 999')
 		@Prow(),105 PSAY transform(aArret[12+nJump][8], '@E 999,999.99')
 		nTotal += aArret[12+nJump][8] * val(aArret[12+nJump][2])
 		@Prow(),119 PSAY transform( aArret[12+nJump][8] * val(aArret[12+nJump][2]), '@E 999,999,999.99')
   endIf
			            //        10        20        30        40        50        60        70        80        90       100       110       120        130
                     //12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
   @Prow()+1,000 PSAY "************************************************************************************************************************************"
   @Prow()+1,000 PSAY "*       Aprovacao Financeiro       |     Tabela      |     Total Mercadorias    |      IPI - 15%     |         Total Pedido        *"
   @Prow()+1,000 PSAY "*                                  |                 |                          |                    |                             *"
  	@Prow(),060 PSAY iif(nJump + 12 <= len(aArret), '***', transform(nTotal, '@E 999,999.99') )
	@Prow(),087 PSAY iif(nJump + 12 <= len(aArret), '***', transform(nTotal * 0.15, '@E 999,999.99') )
	@Prow(),111 PSAY iif(nJump + 12 <= len(aArret), '***', transform(nTotal + (nTotal * 0.15), '@E 999,999.99') )
   @Prow()+1,000 PSAY "************************************************** Informacoes sobre o Faturamento *************************************************"
   @Prow()+1,000 PSAY "*It |                         1a Remessa                            |                         2a Remessa                           *"
   @Prow()+1,000 PSAY "*   |     Quant.    |     N.F.     |    Data Fat.   |     Saldo     |      Quant.    |     N.F.     |    Data Fat.   |     Saldo   *"
   @Prow()+1,000 PSAY "************************************************************************************************************************************"
   @Prow()+1,000 PSAY "*01 |_______________|______________|________________|_______________|________________|______________|________________|_____________*"
   @Prow()+1,000 PSAY "*02 |_______________|______________|________________|_______________|________________|______________|________________|_____________*"
   @Prow()+1,000 PSAY "*03 |_______________|______________|________________|_______________|________________|______________|________________|_____________*"
   @Prow()+1,000 PSAY "*04 |_______________|______________|________________|_______________|________________|______________|________________|_____________*"
   @Prow()+1,000 PSAY "*05 |_______________|______________|________________|_______________|________________|______________|________________|_____________*"
   @Prow()+1,000 PSAY "*06 |_______________|______________|________________|_______________|________________|______________|________________|_____________*"
   @Prow()+1,000 PSAY "*07 |_______________|______________|________________|_______________|________________|______________|________________|_____________*"
   @Prow()+1,000 PSAY "*08 |_______________|______________|________________|_______________|________________|______________|________________|_____________*"
   @Prow()+1,000 PSAY "*09 |_______________|______________|________________|_______________|________________|______________|________________|_____________*"
   @Prow()+1,000 PSAY "*10 |_______________|______________|________________|_______________|________________|______________|________________|_____________*"
   @Prow()+1,000 PSAY "*11 |_______________|______________|________________|_______________|________________|______________|________________|_____________*"
   @Prow()+1,000 PSAY "*12 |_______________|______________|________________|_______________|________________|______________|________________|_____________*"
   @Prow()+1,000 PSAY "*It |                         3a Remessa                            |                         Obs.:                                *"
   @Prow()+1,000 PSAY "*   |     Quant.    |     N.F.     |    Data Fat.   |     Saldo     |                                                              *"
   @Prow()+1,000 PSAY "************************************************************************************************************************************"   
   aObs := quebra( TMP->C5_OBS + TMP->C5_OBSFIN, 62 )
   @Prow()+1,000 PSAY "*   |_______________|______________|________________|_______________|" + iif( len(aObs) > 0, aObs[1][1], padr('',62) ) + "*"
   @Prow()+1,000 PSAY "*   |_______________|______________|________________|_______________|" + iif( len(aObs) > 1, aObs[2][1], padr('',62) ) + "*"
   @Prow()+1,000 PSAY "*   |_______________|______________|________________|_______________|" + iif( len(aObs) > 2, aObs[3][1], padr('',62) ) + "*"
   @Prow()+1,000 PSAY "*   |_______________|______________|________________|_______________|" + iif( len(aObs) > 3, aObs[4][1], padr('',62) ) + "*"
   @Prow()+1,000 PSAY "*   |_______________|______________|________________|_______________|" + iif( len(aObs) > 4, aObs[5][1], padr('',62) ) + "*"
   @Prow()+1,000 PSAY "*   |_______________|______________|________________|_______________|" + iif( len(aObs) > 5, aObs[6][1], padr('',62) ) + "*"
   @Prow()+1,000 PSAY "*   |_______________|______________|________________|_______________|" + iif( len(aObs) > 6, aObs[7][1], padr('',62) ) + "*"
   @Prow()+1,000 PSAY "*   |_______________|______________|________________|_______________|                                                              *"
   @Prow()+1,000 PSAY "*   |_______________|______________|________________|_______________|                                                              *"
   @Prow()+1,000 PSAY "*   |_______________|______________|________________|_______________|______________________________________________________________*"

	If nJump + 12 > len(aArret)
		nTotal := nJump := 0
		lBreak := .F.
		TMP->( dbSkip() )		
	   incRegua()
   elseIf len(aArret) > 12
		nJump += 12	   
	endIf
EndDo
TMP->( dbCloseArea() )
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
Static Function secQuery( cPedid )
***************

Local cQuery
Local aRet := {}

cQuery := "select	SC6.C6_PRODUTO, SC6.C6_QTDVEN, SC6.C6_UM, SB1.B1_DESC, SC6.C6_PRUNIT " //SC6.C6_PRCVEN "
cQuery += "from	SC6020 SC6 inner join SB1010 SB1 on SC6.C6_PRODUTO = SB1.B1_COD "
cQuery += "where	SC6.C6_NUM = '"+alltrim(cPedid)+"' "
cQuery += "and SC6.D_E_L_E_T_ != '*' and SB1.D_E_L_E_T_ != '*' "
cQuery += "order by SC6.C6_NUM, SC6.C6_QTDVEN desc "
cQuery := changeQuery( cQuery )
TCQUERY cQuery NEW ALIAS 'TMP2'
TMP2->( dbGoTop() )
dbSelectArea('SB5')
SB5->( dbSetOrder( 1 ) )
dbSelectArea('SX5')
SX5->( dbSetOrder( 1 ) )

do while TMP2->( !EoF() )

	if SB5->( dbSeek( xFilial('SB5') + iif( len(TMP2->C6_PRODUTO) > 7, U_transgen(TMP2->C6_PRODUTO), TMP2->C6_PRODUTO ), .T. ) )
		nLarg := SB5->B5_LARG2
		nAltu := SB5->B5_COMPR2
		SX5->( dbSeek( xFilial('SX5') + '70' + SB5->B5_COR ), .T. )
		cCor	:= SX5->X5_DESCRI
	else
		nAltu := nLarg := 0
		cCor := ''
	endIf

   aAdd( aRet, {alltrim(TMP2->C6_PRODUTO), alltrim(str(TMP2->C6_QTDVEN)), alltrim(TMP2->C6_UM), alltrim(TMP2->B1_DESC),;
   				 alltrim(cCor), alltrim(str(nLArg)), alltrim(str(nAltu)), TMP2->C6_PRUNIT } )
	TMP2->( dbSkip() )
endDo
TMP2->( dbCloseArea() )
SX5->( dbCloseArea() )
SB5->( dbCloseArea() )
Return aRet

***************

Static Function quebra( cMem, nTot )

***************

Local aRet 	 := {}
Local x 		 := 1
Local nIni	 := 1
Local nFim := nTot
cMem := strtran( cMem, chr(13), ' ')
cMem := strtran( cMem, chr(10), ' ')
cMem := alltrim( cMem )
if len(cMem) > nTot
	for x := 1 to len(cMem)
		aAdd( aRet, { padr( substr(cMem, x, nFim), nTot ) } )
		x += ( nFim - 1 )
	next
else
	aAdd( aRet, { padr( substr( cMem, nIni, nFim ), nTot ) } )
endIf

return aRet