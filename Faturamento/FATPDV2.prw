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

User Function FATPDV2()

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
Private nomeprog     := "FATPDV2" // Coloque aqui o nome do programa para impressao no cabecalho
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
	      SX1->(MsUnlock())
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

wnrel := SetPrint(cString,NomeProg,"FATPDV",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
Local nX  	 := 1, nTotal := 0
Local nTotIPI := 0
local nJump:=0
Local aObs   := {}
Private cFinaliTES := ""
// COLOQUEI PQ TAVA DANDO PROBLEMA COM O ALIAS 
If Select("TMP") > 0  
  DbSelectArea("TMP")
  TMP->(DbCloseArea())
EndIf

cQuery := "select	SC5.C5_NUM, SC5.C5_VEND1, SA3.A3_NREDUZ, SC5.C5_COMIS1, SE4.E4_DESCRI, SC5.C5_TPFRETE, "
cQuery += "SA1.A1_NREDUZ, SA1.A1_CONTATO, SA1.A1_COD, SA1.A1_END, SA1.A1_BAIRRO, SA1.A1_MUN, SC5.C5_EMISSAO, "
cQuery += "SA1.A1_EST, SA1.A1_CEP, SA1.A1_TEL, SA1.A1_CELULAR, SA1.A1_FAX, SA1.A1_EMAIL, SC5.C5_OBSFIN, "
cQuery += "SA1.A1_CGC, SA1.A1_INSCR, SC5.C5_OBS,SA1.A1_LOJA,C5_NUMEMP "
cQuery += "from 	" + retSqlName('SA1') + " SA1, " + retSqlName('SA3') + " SA3, " + retSqlName('SC5') + " SC5, "
cQuery += " "+ retSqlName('SE4') + " SE4 "
cQuery += "where	SC5.C5_VEND1 = SA3.A3_COD and SC5.C5_CLIENTE+SC5.C5_LOJACLI = SA1.A1_COD+SA1.A1_LOJA and SE4.E4_CODIGO = SC5.C5_CONDPAG and "
cQuery += "SC5.C5_NUM between '"+mv_par01+"' and '"+mv_par02+"' AND "
cQuery += "SC5.C5_FILIAL = '"+xFilial('SC5')+"' and SC5.D_E_L_E_T_ != '*' and "
cQuery += "SA1.A1_FILIAL = '"+xFilial('SA1')+"' and SA1.D_E_L_E_T_ != '*' and "
cQuery += "SA3.A3_FILIAL = '"+xFilial('SA3')+"' and SA3.D_E_L_E_T_ != '*' and SE4.D_E_L_E_T_ != '*' "
MemoWrite("C:\TEMP\FATPDV2.SQL", cQuery )
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
      nLin := 8
   Endif
			            //        10        20        30        40        50        60        70        80        90       100       110       120        130
                     //12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
   @nLin++,000 PSAY "****************************************** Informacoes sobre a venda nº:"+alltrim(TMP->C5_NUM)+" *****************************************************"
   /**/
   @nLin,000 PSAY   '* Data:'+Dtoc(stod( TMP->C5_EMISSAO ))+;
                    '  Vend/Cod.:'+substr( TMP->C5_VEND1,  1, 6 ) + "/" + substr(TMP->A3_NREDUZ,1,25)+;
                    '  Comissao:'+transform(TMP->C5_COMIS1, "@E 9999.99" )+;
                    '  Cond. Pag.:'+alltrim( TMP->E4_DESCRI )+;
                    '  Frete:'+iif( alltrim( TMP->C5_TPFRETE ) == 'C', 'CIF', iif(alltrim( TMP->C5_TPFRETE ) ='F','FOB',''))
   @nLin++	,131 PSAY "*"
   /**/
   @nLin++,000 PSAY "************************************************* Informacoes sobre o cliente ******************************************************"
   /**/
	@nLin	,000 PSAY '* Nome:'+alltrim( TMP->A1_NREDUZ )+;
                      '  Contato:'+alltrim( TMP->A1_CONTATO )+;
                      '  Codigo:'+ alltrim( TMP->A1_COD )+;
                      '  Loja:'+alltrim( TMP->A1_LOJA )
    @nLin++	,131 PSAY "*"
	/**/
   //@nLin,000 PSAY "*End.:                                                Bairro:                     Cidade:                               U.F.:      *"
   /**/
   @nLin,000 PSAY '* End.:'+substr( alltrim( TMP->A1_END ), 1, 47 )+;
                    '  Bairro:'+alltrim( TMP->A1_BAIRRO 	)+; 
                    '  Cidade:'+alltrim( TMP->A1_MUN 		)+;
                    '  U.F.:'+alltrim( TMP->A1_EST 		)
   @nLin++	,131 PSAY "*"	
	/**/
			            //        10        20        30        40        50        60        70        80        90       100       110       120        130
                     //12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
   //@nLin,000 PSAY "*CEP.:          Fone:                          Celular:                    Fax:                    E-Mail:                         *"
   /**/
   @nLin	,000 PSAY "* CEP.:"+alltrim( TMP->A1_CEP 		)+;
                      "  Fone:"+alltrim( TMP->A1_TEL 		)+;
                      "  Celular:"+alltrim( TMP->A1_CELULAR)+;
                      "  Fax:"+ substr(alltrim( TMP->A1_FAX 		),1,19)+;
                      "  E-Mail:"+substr(alltrim( TMP->A1_EMAIL	),1,25)
   @nLin++	,131 PSAY "*"
   /**/
   @nLin	,000 PSAY '* CNPJ:'+alltrim( TMP->A1_CGC   	)+;
                      '  Insc. Est.:'+alltrim( TMP->A1_INSCR 	)
   @nLin++	,131 PSAY "*"
   /**/
	aArret := secQuery( TMP->C5_NUM )
	
	If len(aArret) > 0
		SF4->(Dbsetorder(1))
		SF4->(Dbseek(xFilial("SF4") + aArret[1,10]))
		cFinaliTES := SF4->F4_FINALID
	Endif
	
	                  //        10        20        30        40        50        60        70        80        90       100       110       120        130
                    //12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
   @nLin++,000 PSAY "************************************************* Informacoes sobre os produtos ****************************************************"
   @nLin++,000 PSAY "*It |   Cod.    | Quant     | Uni |               Produtos               | Preco Unit.  |   %IPI   |       TOTAL                   *"
   @nLin++,000 PSAY "************************************************************************************************************************************"   
   @nLin,000 PSAY "*"+StrZero(nJump+1,2)
    if len(aArret) >= 1 .AND. len(aArret) >= nJump +1
 		@nLin,004 PSAY "|"
 		@nLin,007 PSAY aArret[nJump+1][1]
 		@nLin,016 PSAY "|"
 		@nLin,018 PSAY transform(val(aArret[nJump+1][2]), '@E 999999.999' )
 		@nLin,028 PSAY "|"
 		@nLin,030 PSAY aArret[nJump+1][3]
 		@nLin,034 PSAY "|"
 		@nLin,036 PSAY substr(aArret[nJump+1][4],1,37)
 		@nLin,073 PSAY "|"
 		@nLin,075 PSAY transform(aArret[nJump+1][8], '@E 999,999.99')
 		nTotal += aArret[nJump+1][8] * val(aArret[nJump+1][2])
 		nTotIPI+= (aArret[nJump+1][8] * val(aArret[nJump+1][2]) ) * (aArret[nJump+1][9] / 100)
 		
 		@nLin,088 PSAY "|"
 		@nLin,090 PSAY transform(aArret[nJump+1][9] , '@E 999.99') //% IPI
 		@nLin,099 PSAY "|"
 		//@nLin,090 PSAY transform(aArret[nJump+1][8] * val(aArret[nJump+1][2]), '@E 999,999.99')
 		@nLin,103 PSAY transform(aArret[nJump+1][8] * val(aArret[nJump+1][2]), '@E 999,999.99')  //total
        @nLin++,131 PSAY"*"
    else
        @nLin,004 PSAY "|"
 		@nLin,016 PSAY "|"
 		@nLin,028 PSAY "|"
 		@nLin,034 PSAY "|"
 		@nLin,073 PSAY "|"
 		@nLin,088 PSAY "|"
 		@nLin,099 PSAY "|"
 		@nLin++,131 PSAY"*"
    endif
   @nLin,000 PSAY "*"+StrZero(nJump+2,2)
   if len(aArret) >= 2 .AND. len(aArret) >= nJump +2
 		//@nLin,000 PSAY "*"+StrZero(nJump+2,2)
 		@nLin,004 PSAY "|"
 		@nLin,007 PSAY aArret[nJump+2][1]
 		@nLin,016 PSAY "|"
 		@nLin,018 PSAY transform(val(aArret[nJump+2][2]), '@E 999999.999' )
 		@nLin,028 PSAY "|"
 		@nLin,030 PSAY aArret[nJump+2][3]
 		@nLin,034 PSAY "|"
 		@nLin,036 PSAY substr(aArret[nJump+2][4],1,37)
 		@nLin,073 PSAY "|"
 		@nLin,075 PSAY transform(aArret[nJump+2][8], '@E 999,999.99')
 		nTotal += aArret[nJump+2][8] * val(aArret[nJump+2][2])
 		nTotIPI+= (aArret[nJump+2][8] * val(aArret[nJump+2][2]) ) * (aArret[nJump+2][9] / 100)
 		@nLin,088 PSAY "|"
 		@nLin,090 PSAY transform(aArret[nJump+2][9] , '@E 999.99') //% IPI
 		@nLin,099 PSAY "|"
 		@nLin,103 PSAY transform(aArret[nJump+2][8] * val(aArret[nJump+2][2]), '@E 999,999.99')  //total
        @nLin++,131 PSAY"*"
    else
        @nLin,004 PSAY "|"
 		@nLin,016 PSAY "|"
 		@nLin,028 PSAY "|"
 		@nLin,034 PSAY "|"
 		@nLin,073 PSAY "|"
 		@nLin,088 PSAY "|"
 		@nLin,099 PSAY "|"
 		@nLin++,131 PSAY"*"
    endif
   @nLin,000 PSAY "*"+StrZero(nJump+3,2)
   if len(aArret) >= 3 .AND. len(aArret) >= nJump +3
 		//@nLin,000 PSAY "*"+StrZero(nJump+3,2)
 		@nLin,004 PSAY "|"
 		@nLin,007 PSAY aArret[nJump+3][1]
 		@nLin,016 PSAY "|"
 		@nLin,018 PSAY transform(val(aArret[nJump+3][2]), '@E 999999.999' )
 		@nLin,028 PSAY "|"
 		@nLin,030 PSAY aArret[nJump+3][3]
 		@nLin,034 PSAY "|"
 		@nLin,036 PSAY substr(aArret[nJump+3][4],1,37)
 		@nLin,073 PSAY "|"
 		@nLin,075 PSAY transform(aArret[nJump+3][8], '@E 999,999.99')
 		nTotal += aArret[nJump+3][8] * val(aArret[nJump+3][2])
 		nTotIPI+= (aArret[nJump+3][8] * val(aArret[nJump+3][2]) ) * (aArret[nJump+3][9] / 100)
 		@nLin,088 PSAY "|"
 		@nLin,090 PSAY transform(aArret[nJump+3][9] , '@E 999.99') //% IPI
 		@nLin,099 PSAY "|"
 		@nLin,103 PSAY transform(aArret[nJump+3][8] * val(aArret[nJump+3][2]), '@E 999,999.99')  //total
        @nLin++,131 PSAY"*"
   else
        @nLin,004 PSAY "|"
 		@nLin,016 PSAY "|"
 		@nLin,028 PSAY "|"
 		@nLin,034 PSAY "|"
 		@nLin,073 PSAY "|"
 		@nLin,088 PSAY "|"
 		@nLin,099 PSAY "|"
 		@nLin++,131 PSAY"*"
    endif
   @nLin,000 PSAY "*"+StrZero(nJump+4,2)
   if len(aArret) >= 4 .AND. len(aArret) >= nJump +4
 		//@nLin,000 PSAY "*"+StrZero(nJump+4,2)
 		@nLin,004 PSAY "|"
 		@nLin,007 PSAY aArret[nJump+4][1]
 		@nLin,016 PSAY "|"
 		@nLin,018 PSAY transform(val(aArret[nJump+4][2]), '@E 999999.999' )
 		@nLin,028 PSAY "|"
 		@nLin,030 PSAY aArret[nJump+4][3]
 		@nLin,034 PSAY "|"
 		@nLin,036 PSAY substr(aArret[nJump+4][4],1,37)
 		@nLin,073 PSAY "|"
 		@nLin,075 PSAY transform(aArret[nJump+4][8], '@E 999,999.99')
 		nTotal += aArret[nJump+4][8] * val(aArret[nJump+4][2])
 		nTotIPI+= (aArret[nJump+4][8] * val(aArret[nJump+4][2]) ) * (aArret[nJump+4][9] / 100)
 		@nLin,088 PSAY "|"
 		@nLin,090 PSAY transform(aArret[nJump+4][9] , '@E 999.99') //% IPI
 		@nLin,099 PSAY "|"
 		@nLin,103 PSAY transform(aArret[nJump+4][8] * val(aArret[nJump+4][2]), '@E 999,999.99')  //total
        @nLin++,131 PSAY"*"
    else
        @nLin,004 PSAY "|"
 		@nLin,016 PSAY "|"
 		@nLin,028 PSAY "|"
 		@nLin,034 PSAY "|"
 		@nLin,073 PSAY "|"
 		@nLin,088 PSAY "|"
 		@nLin,099 PSAY "|"
 		@nLin++,131 PSAY"*"
    endif
   @nLin,000 PSAY "*"+StrZero(nJump+5,2)
   if len(aArret) >= 5 .AND. len(aArret) >= nJump +5
 		//@nLin,000 PSAY "*"+StrZero(nJump+5,2)
 		@nLin,004 PSAY "|"
 		@nLin,007 PSAY aArret[nJump+5][1]
 		@nLin,016 PSAY "|"
 		@nLin,018 PSAY transform(val(aArret[nJump+5][2]), '@E 999999.999' )
 		@nLin,028 PSAY "|"
 		@nLin,030 PSAY aArret[nJump+5][3]
 		@nLin,034 PSAY "|"
 		@nLin,036 PSAY substr(aArret[nJump+5][4],1,37)
 		@nLin,073 PSAY "|"
 		@nLin,075 PSAY transform(aArret[nJump+5][8], '@E 999,999.99')
 		nTotal += aArret[nJump+5][8] * val(aArret[nJump+5][2])
 		nTotIPI+= (aArret[nJump+5][8] * val(aArret[nJump+5][2]) ) * (aArret[nJump+5][9] / 100)
 		@nLin,088 PSAY "|"
 		@nLin,090 PSAY transform(aArret[nJump+5][9] , '@E 999.99') //% IPI
 		@nLin,099 PSAY "|"
 		@nLin,103 PSAY transform(aArret[nJump+5][8] * val(aArret[nJump+5][2]), '@E 999,999.99')  //total
        @nLin++,131 PSAY"*"
   else
        @nLin,004 PSAY "|"
 		@nLin,016 PSAY "|"
 		@nLin,028 PSAY "|"
 		@nLin,034 PSAY "|"
 		@nLin,073 PSAY "|"
 		@nLin,088 PSAY "|"
 		@nLin,099 PSAY "|"
 		@nLin++,131 PSAY"*"
    endif
   @nLin,000 PSAY "*"+StrZero(nJump+6,2)
   if len(aArret) >= 6 .AND. len(aArret) >= nJump +6
 		//@nLin,000 PSAY "*"+StrZero(nJump+6,2)
 		@nLin,004 PSAY "|"
 		@nLin,007 PSAY aArret[nJump+6][1]
 		@nLin,016 PSAY "|"
 		@nLin,018 PSAY transform(val(aArret[nJump+6][2]), '@E 999999.999' )
 		@nLin,028 PSAY "|"
 		@nLin,030 PSAY aArret[nJump+6][3]
 		@nLin,034 PSAY "|"
 		@nLin,036 PSAY substr(aArret[nJump+6][4],1,37)
 		@nLin,073 PSAY "|"
 		@nLin,075 PSAY transform(aArret[nJump+6][8], '@E 999,999.99')
 		nTotal += aArret[nJump+6][8] * val(aArret[nJump+6][2]) 
 		nTotIPI+= (aArret[nJump+6][8] * val(aArret[nJump+6][2]) ) * (aArret[nJump+6][9] / 100)
 		@nLin,088 PSAY "|"
 		@nLin,090 PSAY transform(aArret[nJump+6][9] , '@E 999.99') //% IPI
 		@nLin,099 PSAY "|"
 		@nLin,103 PSAY transform(aArret[nJump+6][8] * val(aArret[nJump+6][2]), '@E 999,999.99')  //total
        @nLin++,131 PSAY"*"
    else
        @nLin,004 PSAY "|"
 		@nLin,016 PSAY "|"
 		@nLin,028 PSAY "|"
 		@nLin,034 PSAY "|"
 		@nLin,073 PSAY "|"
 		@nLin,088 PSAY "|"
 		@nLin,099 PSAY "|"
 		@nLin++,131 PSAY"*"
    endif
   @nLin,000 PSAY "*"+StrZero(nJump+7,2)
   if len(aArret) >= 7 .AND. len(aArret) >= nJump +7
 		//@nLin,000 PSAY "*"+StrZero(nJump+7,2)
 		@nLin,004 PSAY "|"
 		@nLin,007 PSAY aArret[nJump+7][1]
 		@nLin,016 PSAY "|"
 		@nLin,018 PSAY transform(val(aArret[nJump+7][2]), '@E 999999.999' )
 		@nLin,028 PSAY "|"
 		@nLin,030 PSAY aArret[nJump+7][3]
 		@nLin,034 PSAY "|"
 		@nLin,036 PSAY substr(aArret[nJump+7][4],1,37)
 		@nLin,073 PSAY "|"
 		@nLin,075 PSAY transform(aArret[nJump+7][8], '@E 999,999.99')
 		nTotal += aArret[nJump+7][8] * val(aArret[nJump+7][2]) 
 		nTotIPI+= (aArret[nJump+7][8] * val(aArret[nJump+7][2]) ) * (aArret[nJump+7][9] / 100)
 		@nLin,088 PSAY "|"
 		@nLin,090 PSAY transform(aArret[nJump+7][9] , '@E 999.99') //% IPI
 		@nLin,099 PSAY "|"
 		@nLin,103 PSAY transform(aArret[nJump+7][8] * val(aArret[nJump+7][2]), '@E 999,999.99')  //total
        @nLin++,131 PSAY"*"
   else
        @nLin,004 PSAY "|"
 		@nLin,016 PSAY "|"
 		@nLin,028 PSAY "|"
 		@nLin,034 PSAY "|"
 		@nLin,073 PSAY "|"
 		@nLin,088 PSAY "|"
 		@nLin,099 PSAY "|"
 		@nLin++,131 PSAY"*"
    endif
   @nLin,000 PSAY "*"+StrZero(nJump+8,2)
   if len(aArret) >= 8 .AND. len(aArret) >= nJump +8
 		//@nLin,000 PSAY "*"+StrZero(nJump+8,2)
 		@nLin,004 PSAY "|"
 		@nLin,007 PSAY aArret[nJump+8][1]
 		@nLin,016 PSAY "|"
 		@nLin,018 PSAY transform(val(aArret[nJump+8][2]), '@E 999999.999' )
 		@nLin,028 PSAY "|"
 		@nLin,030 PSAY aArret[nJump+8][3]
 		@nLin,034 PSAY "|"
 		@nLin,036 PSAY substr(aArret[nJump+8][4],1,37)
 		@nLin,073 PSAY "|"
 		@nLin,075 PSAY transform(aArret[nJump+8][8], '@E 999,999.99')
 		nTotal += aArret[nJump+8][8] * val(aArret[nJump+8][2])
 		nTotIPI+= (aArret[nJump+8][8] * val(aArret[nJump+8][2]) ) * (aArret[nJump+8][9] / 100)
 		@nLin,088 PSAY "|"
 		@nLin,090 PSAY transform(aArret[nJump+8][9] , '@E 999.99') //% IPI
 		@nLin,099 PSAY "|"
 		@nLin,103 PSAY transform(aArret[nJump+8][8] * val(aArret[nJump+8][2]), '@E 999,999.99')  //total
        @nLin++,131 PSAY"*"
    else
        @nLin,004 PSAY "|"
 		@nLin,016 PSAY "|"
 		@nLin,028 PSAY "|"
 		@nLin,034 PSAY "|"
 		@nLin,073 PSAY "|"
 		@nLin,088 PSAY "|"
 		@nLin,099 PSAY "|"
 		@nLin++,131 PSAY"*"
    endif
   @nLin,000 PSAY "*"+StrZero(nJump+9,2)
   if len(aArret) >= 9 .AND. len(aArret) >= nJump +9
 		//@nLin,000 PSAY "*"+StrZero(nJump+9,2)
 		@nLin,004 PSAY "|"
 		@nLin,007 PSAY aArret[nJump+9][1]
 		@nLin,016 PSAY "|"
 		@nLin,018 PSAY transform(val(aArret[nJump+9][2]), '@E 999999.999' )
 		@nLin,028 PSAY "|"
 		@nLin,030 PSAY aArret[nJump+9][3]
 		@nLin,034 PSAY "|"
 		@nLin,036 PSAY substr(aArret[nJump+9][4],1,37)
 		@nLin,073 PSAY "|"
 		@nLin,075 PSAY transform(aArret[nJump+9][8], '@E 999,999.99')
 		nTotal += aArret[nJump+9][8] * val(aArret[nJump+9][2]) 
 		nTotIPI+= (aArret[nJump+9][8] * val(aArret[nJump+9][2]) ) * (aArret[nJump+9][9] / 100)
 		@nLin,088 PSAY "|"
 		@nLin,090 PSAY transform(aArret[nJump+9][9] , '@E 999.99') //% IPI
 		@nLin,099 PSAY "|"
 		@nLin,103 PSAY transform(aArret[nJump+9][8] * val(aArret[nJump+9][2]), '@E 999,999.99')  //total
        @nLin++,131 PSAY"*"
    else
        @nLin,004 PSAY "|"
 		@nLin,016 PSAY "|"
 		@nLin,028 PSAY "|"
 		@nLin,034 PSAY "|"
 		@nLin,073 PSAY "|"
 		@nLin,088 PSAY "|"
 		@nLin,099 PSAY "|"
 		@nLin++,131 PSAY"*"
    endif
   @nLin,000 PSAY "*"+StrZero(nJump+10,2)
   if len(aArret) >= 10 .AND. len(aArret) >= nJump +10
 		//@nLin,000 PSAY "*"+StrZero(nJump+10,2)
 		@nLin,004 PSAY "|"
 		@nLin,007 PSAY aArret[nJump+10][1]
 		@nLin,016 PSAY "|"
 		@nLin,018 PSAY transform(val(aArret[nJump+10][2]), '@E 999999.999' )
 		@nLin,028 PSAY "|"
 		@nLin,030 PSAY aArret[nJump+10][3]
 		@nLin,034 PSAY "|"
 		@nLin,036 PSAY substr(aArret[nJump+10][4],1,37)
 		@nLin,073 PSAY "|"
 		@nLin,075 PSAY transform(aArret[nJump+10][8], '@E 999,999.99')
 		nTotal += aArret[nJump+10][8] * val(aArret[nJump+10][2]) 
 		nTotIPI+= (aArret[nJump+10][8] * val(aArret[nJump+10][2]) ) * (aArret[nJump+10][9] / 100)
 		@nLin,088 PSAY "|"
 		@nLin,090 PSAY transform(aArret[nJump+10][9] , '@E 999.99') //% IPI
 		@nLin,099 PSAY "|"
 		@nLin,103 PSAY transform(aArret[nJump+10][8] * val(aArret[nJump+10][2]), '@E 999,999.99')  //total
        @nLin++,131 PSAY"*"
    else
        @nLin,004 PSAY "|"
 		@nLin,016 PSAY "|"
 		@nLin,028 PSAY "|"
 		@nLin,034 PSAY "|"
 		@nLin,073 PSAY "|"
 		@nLin,088 PSAY "|"
 		@nLin,099 PSAY "|"
 		@nLin++,131 PSAY"*"
    endif
   @nLin,000 PSAY "*"+StrZero(nJump+11,2)
   if len(aArret) >= 11 .AND. len(aArret) >= nJump +11
// 		@nLin,000 PSAY "*"+StrZero(nJump+11,2)
 		@nLin,004 PSAY "|"
 		@nLin,007 PSAY aArret[nJump+11][1]
 		@nLin,016 PSAY "|"
 		@nLin,018 PSAY transform(val(aArret[nJump+11][2]), '@E 999999.999' )
 		@nLin,028 PSAY "|"
 		@nLin,030 PSAY aArret[nJump+11][3]
 		@nLin,034 PSAY "|"
 		@nLin,036 PSAY substr(aArret[nJump+11][4],1,37)
 		@nLin,073 PSAY "|"
 		@nLin,075 PSAY transform(aArret[nJump+11][8], '@E 999,999.99')
 		nTotal += aArret[nJump+11][8] * val(aArret[nJump+11][2])  
 		nTotIPI+= (aArret[nJump+11][8] * val(aArret[nJump+11][2]) ) * (aArret[nJump+11][9] / 100)
 		@nLin,088 PSAY "|"
 		@nLin,090 PSAY transform(aArret[nJump+11][9] , '@E 999.99') //% IPI
 		@nLin,099 PSAY "|"
 		@nLin,103 PSAY transform(aArret[nJump+11][8] * val(aArret[nJump+11][2]), '@E 999,999.99')  //total
        @nLin++,131 PSAY"*"
    else
        @nLin,004 PSAY "|"
 		@nLin,016 PSAY "|"
 		@nLin,028 PSAY "|"
 		@nLin,034 PSAY "|"
 		@nLin,073 PSAY "|"
 		@nLin,088 PSAY "|"
 		@nLin,099 PSAY "|"
 		@nLin++,131 PSAY"*"
    endif
  @nLin,000 PSAY "*"+StrZero(nJump+12,2)
   if len(aArret) >= 12 .AND. len(aArret) >= nJump +12
 		//@nLin,000 PSAY "*"+StrZero(nJump+12,2)
 		@nLin,004 PSAY "|"
 		@nLin,007 PSAY aArret[nJump+12][1]
 		@nLin,016 PSAY "|"
 		@nLin,018 PSAY transform(val(aArret[nJump+12][2]), '@E 999999.999' )
 		@nLin,028 PSAY "|"
 		@nLin,030 PSAY aArret[nJump+12][3]
 		@nLin,034 PSAY "|"
 		@nLin,036 PSAY substr(aArret[nJump+12][4],1,37)
 		@nLin,073 PSAY "|"
 		@nLin,075 PSAY transform(aArret[nJump+12][8], '@E 999,999.99')
 		nTotal += aArret[nJump+12][8] * val(aArret[nJump+12][2])  
 		nTotIPI+= (aArret[nJump+12][8] * val(aArret[nJump+12][2]) ) * (aArret[nJump+12][9] / 100)
 		@nLin,088 PSAY "|"
 		@nLin,090 PSAY transform(aArret[nJump+12][9] , '@E 999.99') //% IPI
 		@nLin,099 PSAY "|"
 		@nLin,103 PSAY transform(aArret[nJump+12][8] * val(aArret[nJump+12][2]), '@E 999,999.99')  //total
        @nLin++,131 PSAY"*"
    else
        @nLin,004 PSAY "|"
 		@nLin,016 PSAY "|"
 		@nLin,028 PSAY "|"
 		@nLin,034 PSAY "|"
 		@nLin,073 PSAY "|"
 		@nLin,088 PSAY "|"
 		@nLin,099 PSAY "|"
 		@nLin++,131 PSAY"*"
    endif
   
                     //        10        20        30        40        50        60        70        80        90       100       110       120        130
                     //12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
   @nLin++,000 PSAY "************************************************************************************************************************************"
   @nLin++,000 PSAY "*       Aprovacao Financeiro       |     Tabela      |     Total Mercadorias    |     Valor IPI      |         Total Pedido        *"
  	@nLin,000 PSAY "*"
  	@nLin,035 PSAY "|"
  	@nLin,053 PSAY "|"
  	@nLin,060 PSAY  iif(nJump + 12 < len(aArret), '***', transform(nTotal, '@E 999,999.99') ) //transform(nTotal, '@E 999,999.99') 
	@nLin,080 PSAY "|"
	//@nLin,087 PSAY iif(nJump + 12 < len(aArret), '***', transform(nTotal * 0.15, '@E 999,999.99') ) //transform(nTotal * 0.15, '@E 999,999.99') 
	@nLin,087 PSAY iif(nJump + 12 < len(aArret), '***', Transform(nTotIPI, '@E 999,999.99') )   //transform(nTotal * 0.15, '@E 999,999.99') 
	@nLin,101 PSAY "|"
	@nLin,111 PSAY  iif(nJump + 12 < len(aArret), '***', transform( (nTotal + nTotIPI), '@E 999,999.99') ) //transform(nTotal + (nTotal * 0.15), '@E 999,999.99')
    @nLin++,131 PSAY "*"
   
    
                   //        10        20        30        40        50        60        70        80        90       100       110       120        130
                   //12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
   @nLin++,000 PSAY "************************************************************************************************************************************"
   @nLin++,000 PSAY "*                                                                   |                         Obs.:                                *"
   @nLin++,000 PSAY "************************************************************************************************************************************"   
   aObs := quebra( alltrim(TMP->C5_OBS) +' '+ alltrim(TMP->C5_OBSFIN), 62 )
   nSobra := 62 - Len(Alltrim(cFinaliTES))
   @nLin++,000 PSAY "*                                                                   |" + Alltrim(cFinaliTES) + Space(nSobra)           + "*"
   @nLin++,000 PSAY "*    *******************        *******************                 |" + iif( len(aObs) > 0, aObs[1][1], padr('',62) ) + "*"
   @nLin++,000 PSAY "*    * Uso interno Rava *       * Uso interno Rava *                |" + iif( len(aObs) > 1, aObs[2][1], padr('',62) ) + "*"
   @nLin++,000 PSAY "*    ********************       ********************                |" + iif( len(aObs) > 2, aObs[3][1], padr('',62) ) + "*"
   @nLin++,000 PSAY "*    * Data Lançamento  *       * Data Lançamento  *                |" + iif( len(aObs) > 3, aObs[4][1], padr('',62) ) + "*"
   @nLin++,000 PSAY "*    *                  *       *                  *                |" + iif( len(aObs) > 4, aObs[5][1], padr('',62) ) + "*"
   @nLin++,000 PSAY "*    * ____/____/______ *       * ____/____/______ *                |" + iif( len(aObs) > 5, aObs[6][1], padr('',62) ) + "*"
   @nLin++,000 PSAY "*    ********************       ********************                |" + iif( len(aObs) > 6, aObs[7][1], padr('',62) ) + "*"
   @nLin++,000 PSAY "*    *      Hora        *       *      Nº NF       *                |                                                              *"
   @nLin++,000 PSAY "*    *                  *       *                  *                |" + iif( !EMPTY(TMP->C5_NUMEMP), "Empenho:"+ALLTRIM(TMP->C5_NUMEMP)+space(42), padr('',62) ) + "*"
   @nLin++,000 PSAY "*    ********************       ********************                |______________________________________________________________*"
   @nLin,000 PSAY "*                                                                    Pré-Pedido:" +ALLTRIM(Posicione("SC6",1,xFilial('SC6') +TMP->C5_NUM,"C6_PREPED" ) )                                               
   @nLin++,131 PSAY "*" 	
   
   If nJump + 12 > len(aArret)
		nTotal := nJump := 0
		nTotIPI:= 0
		lBreak := .F.
		TMP->( dbSkip() )		
	   incRegua()
   elseIf len(aArret) >= 12
		nJump += 12	
	    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
        nLin := 8   
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
Local LF   := CHR(13) + CHR(10)

If Select("TMP2") > 0  
  DbSelectArea("TMP2")
  TMP2->(DbCloseArea())
EndIf


cQuery := " Select	SC6.C6_PRODUTO, SC6.C6_QTDVEN, SC6.C6_UM, SB1.B1_DESC, SB1.B1_IPI, SC6.C6_PRUNIT, SC6.C6_TES " + LF
cQuery += " from	"  + LF
cQuery += " " + RetSqlName("SC6") + " SC6 " + LF
cQuery += " inner join " + RetSqlName("SB1") + "  SB1 on SC6.C6_PRODUTO = SB1.B1_COD " + LF
cQuery += " where	SC6.C6_NUM = '"+alltrim(cPedid)+"' " + LF
cQuery += " and SC6.D_E_L_E_T_ != '*' " + LF
cQuery += " and SC6.C6_FILIAL = '" + xFilial("SC6") + "' " + LF
cQuery += " and SB1.D_E_L_E_T_ != '*' " + LF
cQuery += " order by SC6.C6_NUM, SC6.C6_QTDVEN desc " + LF 
MemoWrite("C:\TEMP\itFATPDV2.SQL" , cQuery )
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
   				 alltrim(cCor), alltrim(str(nLArg)), alltrim(str(nAltu)), TMP2->C6_PRUNIT , TMP2->B1_IPI , TMP2->C6_TES} )
   
   
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