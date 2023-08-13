*-------------------------------------------------------------------------------------------------------*
*Descricao ³ Relatorio - vencidos recebidos por faixa de atraso         º±±
*-------------------------------------------------------------------------------------------------------*
*Uso       ³ Cobranca - Rava Embalagens                         		    º±±
*-------------------------------------------------------------------------------------------------------*
#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

User Function COBR08()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Titulos recebidos por faixa"
Local cPict        := ""
Local titulo       := "Titulos recebidos por faixa -  T E S T E"
Local nLin         := 80
Local cabec1       := "Faixa de atraso Tit.atrasados Tit.recebidos % Recuperado Tit.a Receber   Tit.Abertos % Inad.Real Abertos Período % Inad.Periodo"
Local cabec2       := ""                                                                               
//                     XXXXXXX         99,999,999.99 99,999,999.99       999.99 99,999,999.99 99,999,999.99      999.99   99,999,999.99         999.99
//                     0....+....1....+....2....+....3....+....4....+....5....+....6....+....7....+....8....+....9....+....0....+....1....+....2....+....3


Local imprime       := .T.
Local aOrd          := {}
//
Private CbTxt       := ""
Private limite      := 80
Private tamanho     := "M"
Private nomeprog    := "COBR08" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "COBR08"
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "COBR08" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString     := "SE1"
Private D_limite    := ctod("")
Private N_dialim    := 0

ValidPerg()             
pergunte( cPerg, .f. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint( cString, NomeProg, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F., aOrd, , Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault( aReturn, cString )

If nLastKey == 27
	Return
Endif

nTipo := If( aReturn[4] == 1, 15, 18 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus( {|| Run_Report( Cabec1, Cabec2, Titulo, nLin) },Titulo ) 
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  09/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Run_Report( Cabec1, Cabec2, Titulo, nLin )
Local nOrdem := aReturn[8]        


if Mv_par03 == 1
   D_limite := Mv_par01  
   N_dialim := 1
else
   D_limite := Mv_par02
   N_dialim := 0
endif      
/*
* -------------------------------------------------------------------------------*
* Titulos Recebidos
seleciona as baixas ocorridas entre as datas do parametro, cuja a data da baixa seja maior que o vencimento(pago com atraso)
e o vencimento seja maior que a data limite - 90 dias.
* -------------------------------------------------------------------------------*
*/
cCond := " SELECT E1_VENCREA,E5_VALOR,E5_RECPAG,SE5.E5_VLJUROS,SE5.E5_VLMULTA,SE5.E5_VLDESCO "
cCond += " FROM "+ RETSQLNAME( "SE5" ) + " SE5, "+RETSQLNAME( "SE1" ) + " SE1 " 
cCond += " WHERE SE5.E5_DATA BETWEEN '" + Dtos( MV_PAR01 ) + "' AND '" + Dtos( MV_PAR02 ) + "' "
cCond += " AND E5_TIPODOC IN ( 'VL','V2', 'BA', 'ES', 'CP' )  AND E5_SITUACA <> 'C' "
cCond += " AND SE5.E5_MOTBX <> 'LIQ' AND SE5.E5_MOTBX <> 'DAC' AND SE5.E5_MOTBX <> 'DEV' "
cCond += " AND E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO = E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO " 
cCond += " AND SE5.E5_DATA > SE1.E1_VENCREA AND SE1.E1_VENCREA >= '" + Dtos( D_limite - 90 ) + "' "
cCond += " AND SE1.E1_PREFIXO <> 'COM' AND SE1.E1_ORIGEM <> 'FINA460' "
cCond += " AND SE1.E1_TIPO IN ( 'NF', 'CH' ) AND E1_NATUREZ < '105' " //Mudar para natureza usada na Rava
cCond += " AND SE5.D_E_L_E_T_ = '' AND SE1.D_E_L_E_T_ = '' "
TCQUERY cCond ALIAS SE5X NEW

TCSetField( "SE5X", "E5_VALOR"  , "N", 12, 2 )
TCSetField( "SE5X", "E5_VLJUROS", "N", 12, 2 )
TCSetField( "SE5X", "E5_VLDESCO", "N", 12, 2 )
TCSetField( "SE5X", "E5_VLMULTA", "N", 12, 2 )
TCSetField( "SE5X", "E1_VENCREA", "D", 8, 0 )  

/*
* -------------------------------------------------------------------------------*
* Monta o saldo dos titulos das faixas até a data selecionada. 
seleciona titulos cujo o vencimento real esteja entre a data limite e data limite - 90 e
( não tenha baixa ou pago com atraso).
* -------------------------------------------------------------------------------*
*/

N_count := 0
For i:= 1 to 2

    if i == 1
      cQuery := "SELECT COUNT(*) AS TOTAL " 
    else            
      N_count := Temp1a->TOTAL
      Temp1a->(DbCloseArea())
      cQuery := " SELECT E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_NATUREZ,E1_CLIENTE,E1_LOJA,E1_EMISSAO,E1_FILIAL, "
      cQuery += " E1_MOEDA,E1_BAIXA,E1_VENCREA,E1_SALDO"     
    endif
      
    cQuery += " FROM "+RetSqlName('SE1')+" SE1 "
    cQuery += " WHERE E1_VENCREA BETWEEN '"+dtos(D_limite-90)+"' AND '"+dtos(D_limite-N_dialim)+"' "   
    cQuery += " AND (E1_BAIXA = '' OR E1_VENCREA < E1_BAIXA ) "
    cQuery += " AND E1_TIPO IN ('NF','CH')  "
    cQuery += " AND E1_PREFIXO <> 'COM' AND E1_PREFIXO <> 'CH ' " //Mudar prefixos
    cQuery += " AND SUBSTRING(E1_NATUREZ,4,2) <> '06' AND E1_ORIGEM <> 'FINA460' AND SE1.D_E_L_E_T_ <> '*' " //Mudar para naturezas usadas na Rava

    if i == 2
       cQuery += " ORDER BY E1_PREFIXO,E1_NUM,E1_PARCELA "
    endif
    TCQUERY cQuery ALIAS Temp1a NEW
NExt


Temp1a->(DbGoTop())      
SetRegua(N_Count)

nySaldo := Tysaldo := 0 
A_Val := {0,0,0,0,0}
A_DifTit := {}                      

// 
// Grava em vetor o saldo dos títulos até a data final selecionada. semparando por faixa
//
while Temp1a->(!eof())
      nySaldo :=  U_SldTitu(Temp1a->E1_PREFIXO, Temp1a->E1_NUM, Temp1a->E1_PARCELA,Temp1a->E1_TIPO, Temp1a->E1_NATUREZ, "R",;
  		            Temp1a->E1_CLIENTE, Temp1a->E1_MOEDA,MV_PAR02,MV_PAR02,Temp1a->e1_loja,Temp1a->e1_filial)                        
  		if nySaldo > 0  
    		If stod(Temp1a->E1_VENCREA)     >= D_limite - 7  .and. stod(Temp1a->E1_VENCREA) <= D_limite - N_dialim
	    	   A_val[1] += nySaldo
		   ElseIf stod(Temp1a->E1_VENCREA) >= D_limite - 15 .and. stod(Temp1a->E1_VENCREA) <= D_limite - 8
		      A_val[2] += nySaldo
		   ElseIf stod(Temp1a->E1_VENCREA) >= D_limite - 30 .and. stod(Temp1a->E1_VENCREA) <= D_limite - 16
		      A_val[3] += nySaldo
		   ElseIf stod(Temp1a->E1_VENCREA) >= D_limite - 60 .and. stod(Temp1a->E1_VENCREA) <= D_limite - 31
		      A_val[4] += nySaldo
		   ElseIf stod(Temp1a->E1_VENCREA) >= D_limite - 90 .and. stod(Temp1a->E1_VENCREA) <= D_limite - 61
		      A_val[5] += nySaldo
		   EndIf
      endif
    
      Temp1a->(DbSkip())
      IncRegua()
enddo            
Temp1a->(DbCloseArea())
SetRegua(20)         

/*
   aREL -> Vetor com 5 posições (Montagem dos valores por faixa)
   ----------------------------
   1. Atraso no período 
   2. Tit. Recebidos em atraso
   3. Valor Total que Vou receber no período 
   4. Tit. em aberto até hoje (somas os saldos dos títulos)
   5. Tit. Em aberto até a data final do período
*/        
//            1                    2      3                           4                      5
aREL :=;
     { { Tit_Atraso(N_dialim,07), 0, AReceber_Faixa(N_Dialim,07),Sld_atual_faixa(N_Dialim,07),A_Val[1] }, ;
       { Tit_Atraso(08,15),       0, AReceber_Faixa(08,15),      Sld_atual_faixa(08,15),      A_val[2] }, ;
       { Tit_Atraso(16,30),       0, AReceber_Faixa(16,30),      Sld_atual_faixa(16,30),      A_val[3] }, ;
       { Tit_Atraso(31,60),       0, AReceber_Faixa(31,60),      Sld_atual_faixa(31,60),      A_val[4] }, ;
       { Tit_Atraso(61,90),       0, AReceber_Faixa(61,90),      Sld_atual_faixa(61,90),      A_val[5] }}

* -------------------------------------------------------------------------------*
* Grava no Vetor os titulos recebidos separando por faixa.
* -------------------------------------------------------------------------------*
SE5X->( DbGotop() )
Do While SE5X->( ! Eof() )
   IF SE5X->E5_RECPAG == 'R'
 		If SE5X->E1_VENCREA >= D_limite - 7 .and. SE5X->E1_VENCREA <= D_limite - N_dialim
		   aREL[ 1, 2 ] += SE5X->E5_VALOR
		ElseIf SE5X->E1_VENCREA >= D_limite - 15 .and. SE5X->E1_VENCREA <= D_limite - 8
		   aREL[ 2, 2 ] += SE5X->E5_VALOR
		ElseIf SE5X->E1_VENCREA >= D_limite - 30 .and. SE5X->E1_VENCREA <= D_limite - 16
		   aREL[ 3, 2 ] += SE5X->E5_VALOR
		ElseIf SE5X->E1_VENCREA >= D_limite - 60 .and. SE5X->E1_VENCREA <= D_limite - 31
		   aREL[ 4, 2 ] += SE5X->E5_VALOR
		ElseIf SE5X->E1_VENCREA >= D_limite - 90 .and. SE5X->E1_VENCREA <= D_limite - 61
		   aREL[ 5, 2 ] += SE5X->E5_VALOR
		EndIf
   ELSE
		If SE5X->E1_VENCREA >= D_limite - 7 .and. SE5X->E1_VENCREA <= D_limite - N_dialim
		   aREL[ 1, 2 ] -= SE5X->E5_VALOR
		ElseIf SE5X->E1_VENCREA >= D_limite - 15 .and. SE5X->E1_VENCREA <= D_limite - 8
		   aREL[ 2, 2 ] -= SE5X->E5_VALOR
		ElseIf SE5X->E1_VENCREA >= D_limite - 30 .and. SE5X->E1_VENCREA <= D_limite - 16
		   aREL[ 3, 2 ] -= SE5X->E5_VALOR
		ElseIf SE5X->E1_VENCREA >= D_limite - 60 .and. SE5X->E1_VENCREA <= D_limite - 31
		   aREL[ 4, 2 ] -= SE5X->E5_VALOR
		ElseIf SE5X->E1_VENCREA >= D_limite - 90 .and. SE5X->E1_VENCREA <= D_limite - 61
		   aREL[ 5, 2 ] -= SE5X->E5_VALOR
		EndIf
	ENDIF 
	 
	SE5X->(DbSkip())
	IncRegua()
EndDo
SE5X->( DbCloseArea() )
Titulo := Titulo+" de  "+dtoc(Mv_par01)+" a "+dtoc(MV_par02)
Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo )
/*

Local cabec1       := "Faixa de atraso Tit.atrasados Tit.recebidos % Recuperado Tit.a Receber   Tit.Abertos % Inad.Real Abertos Período % Inad.Periodo"
Local cabec2       := ""                                                                               
//                     XXXXXXX         99,999,999.99 99,999,999.99       999.99 99,999,999.99 99,999,999.99      999.99   99,999,999.99         999.99
//                     0....+....1....+....2....+....3....+....4....+....5....+....6....+....7....+....8....+....9....+....0....+....1....+....2....+....3

*/

@ prow()+2, 000 pSay strzero(N_dialim,2)+" A 07 DIAS"            
@ prow()  , 016 pSay aREL[ 1, 1 ]                         Picture "@E 99,999,999.99"     // Tit. atrasados
@ prow()  , 030 pSay aREL[ 1, 2 ]                         Picture "@E 99,999,999.99"     // Tit. recebidos com atraso
@ prow()  , 050 pSay aREL[ 1, 2 ] / aREL[ 1, 1 ] * 100   Picture "@E 999.99"            
@ prow()  , 057 pSay aREL[ 1, 3 ]                         Picture "@E 99,999,999.99"     // Tit. a receber
@ prow()  , 071 Psay aREL[ 1, 4 ]                         Picture "@E 99,999,999.99"     // Tit Abertos
@ prow()  , 090 Psay (aREL[ 1, 4 ] / aREL[ 1, 3 ]) * 100 Picture "@E 999.99"    
@ prow()  , 099 Psay aREL[ 1, 5 ]                         Picture "@E 99,999,999.99"     // Abertos Período
@ prow()  , 121 Psay (aREL[ 1, 5 ] / aREL[ 1, 3 ]) * 100 Picture "@E 999.99"    

@ prow()+2, 000 pSay "08 A 15 DIAS"            
@ prow()  , 016 pSay aREL[ 2, 1 ]                         Picture "@E 99,999,999.99"
@ prow()  , 030 pSay aREL[ 2, 2 ]                         Picture "@E 99,999,999.99"
@ prow()  , 050 pSay aREL[ 2, 2 ] / aREL[ 2, 1 ] * 100   Picture "@E 999.99"
@ prow()  , 057 pSay aREL[ 2, 3 ]                         Picture "@E 99,999,999.99"
@ prow()  , 071 Psay aREL[ 2, 4 ]                         Picture "@E 99,999,999.99"
@ prow()  , 090 Psay (aREL[ 2, 4 ] / aREL[ 2, 3 ]) * 100 Picture "@E 999.99"  
@ prow()  , 099 Psay aREL[ 2, 5 ]                         Picture "@E 99,999,999.99"
@ prow()  , 121 Psay (aREL[ 2, 5 ] / aREL[ 2, 3 ]) * 100 Picture "@E 999.99"    

@ prow()+2, 000 pSay "16 A 30 DIAS"            
@ prow()  , 016 pSay aREL[ 3, 1 ]                         Picture "@E 99,999,999.99"
@ prow()  , 030 pSay aREL[ 3, 2 ]                         Picture "@E 99,999,999.99"
@ prow()  , 050 pSay aREL[ 3, 2 ] / aREL[ 3, 1 ] * 100   Picture "@E 999.99"
@ prow()  , 057 pSay aREL[ 3, 3 ]                         Picture "@E 99,999,999.99"
@ prow()  , 071 Psay aREL[ 3, 4 ]                         Picture "@E 99,999,999.99"
@ prow()  , 090 Psay (aREL[ 3, 4 ] / aREL[ 3, 3 ]) * 100 Picture "@E 999.99"  
@ prow()  , 099 Psay aREL[ 3, 5 ]                         Picture "@E 99,999,999.99"
@ prow()  , 121 Psay (aREL[ 3, 5 ] / aREL[ 3, 3 ]) * 100 Picture "@E 999.99"    

@ prow()+2, 000 pSay "31 A 60 DIAS"
@ prow()  , 016 pSay aREL[ 4, 1 ]                         Picture "@E 99,999,999.99"
@ prow()  , 030 pSay aREL[ 4, 2 ]                         Picture "@E 99,999,999.99"
@ prow()  , 050 pSay aREL[ 4, 2 ] / aREL[ 4, 1 ] * 100   Picture "@E 999.99"
@ prow()  , 057 pSay aREL[ 4, 3 ]                         Picture "@E 99,999,999.99"
@ prow()  , 071 Psay aREL[ 4, 4 ]                         Picture "@E 99,999,999.99"
@ prow()  , 090 Psay (aREL[ 4, 4 ] / aREL[ 4, 3 ]) * 100 Picture "@E 999.99"  
@ prow()  , 099 Psay aREL[ 4, 5 ]                         Picture "@E 99,999,999.99"
@ prow()  , 121 Psay (aREL[ 4, 5 ] / aREL[ 4, 3 ]) * 100 Picture "@E 999.99"    

@ prow()+2, 000 pSay "61 A 90 DIAS"
@ prow()  , 016 pSay aREL[ 5, 1 ]                         Picture "@E 99,999,999.99"
@ prow()  , 030 pSay aREL[ 5, 2 ]                         Picture "@E 99,999,999.99"
@ prow()  , 050 pSay aREL[ 5, 2 ] / aREL[ 5, 1 ] * 100   Picture "@E 999.99"
@ prow()  , 057 pSay aREL[ 5, 3 ]                         Picture "@E 99,999,999.99"
@ prow()  , 071 Psay aREL[ 5, 4 ]                         Picture "@E 99,999,999.99"
@ prow()  , 090 Psay (aREL[ 5, 4 ] / aREL[ 5, 3 ]) * 100 Picture "@E 999.99"  
@ prow()  , 099 Psay aREL[ 5, 5 ]                         Picture "@E 99,999,999.99"
@ prow()  , 121 Psay (aREL[ 5, 5 ] / aREL[ 5, 3 ]) * 100 Picture "@E 999.99"    

@ Prow()+5, 000 pSay "FAIXAS"
@ Prow()+1, 000 pSay "-------------------------------------------------------------------"
@ prow()+1, 000 pSay strzero(N_dialim,2)+" A 07 DIAS      "+dtoc(D_limite-07)+" --- "+dtoc(D_limite-N_dialim)
@ prow()+1, 000 pSay "08 A 15 DIAS      "+dtoc(D_limite-15)+" --- "+dtoc(D_limite-08)
@ prow()+1, 000 pSay "16 A 30 DIAS      "+dtoc(D_limite-30)+" --- "+dtoc(D_limite-16)
@ prow()+1, 000 pSay "31 A 60 DIAS      "+dtoc(d_limite-60)+" --- "+dtoc(D_limite-31)
@ prow()+1, 000 pSay "61 A 90 DIAS      "+dtoc(d_limite-90)+" --- "+dtoc(D_limite-61)

Roda( 0, "", Tamanho )
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
	OurSpool( wnrel )
Endif
MS_FLUSH()
Return NIL

*------------------------------------------------------------------------------------------*
* Validação da Pergunta
*------------------------------------------------------------------------------------------*
Static Function ValidPerg()

Local _sAlias  := Alias()
Local aRegs    := {}
Local i,j
dbSelectArea("SX1")
dbSetOrder(1)

AADD(aRegs,{cPerg,"01","Da Data            :","","","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate a Data         :","","","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Montar Faixas      :","","","mv_ch3","C",1,0,0,"C","","mv_par03","1.Inic. Periodo","","","","","2.Final Periodo","","","","","","","","","","","","","","","","","","","",""})

For i := 1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

DbSelectArea(_sAlias)
Return

* -------------------------------------------------------------------------------*
* Retorna o Valor total dos títulos a receber dentro da faixa
*
* Parametros : D1 --> quantidade de dias a decrementar da data inicial
*              D2 --> quantidade de dias a decrementar da data inicial
* Ex: a primeira data(Mv_par01) é 01/12, d1 = 1 e d2 = 7  
*
*                               logo : 01/12 - 1 = 30/11
*                                      01/12 - 7 = 24/11   ----> selecao dos titulos   24/11 a 30/11
* -------------------------------------------------------------------------------*
static function AReceber_Faixa(d1,d2)

cCond := " SELECT SUM( E1_VALOR ) VENCIDOS"
cCond += " FROM " + RetSqlname( "SE1" ) + " SE1"
cCond += " WHERE E1_VENCREA BETWEEN '" + Dtos( D_limite - d2 ) + "' AND '" + Dtos( D_limite - d1 ) + "' "
cCond += " AND E1_TIPO IN ('NF','CH') "
cCond += " AND E1_PREFIXO <> 'COM' AND E1_PREFIXO <> 'CH '" //Mudar prefixos
cCond += " AND SUBSTRING(E1_NATUREZ,4,2) <> '06' " //Mudar para naturezas usadas na Rava
cCond += " AND E1_ORIGEM <> 'FINA460' " //CHEQUES A RECEBER
cCond += " AND SE1.D_E_L_E_T_ = ' ' "
TCQUERY cCond ALIAS Temp1 NEW
TCSetField( "TEMP1", "VENCIDOS", "N", 12, 2 )

resulta := Temp1->vencidos
Temp1->(DbCloseArea())
IncRegua()
return(resulta)


* ----------------------------------------------------------------------------------------------*
* Soma os saldos dos titulos dentro da faixa
*
* Parametros : D1 --> quantidade de dias a decrementar da data inicial
*              D2 --> quantidade de dias a decrementar da data inicial
* Ex: a primeira data(Mv_par01) é 01/12, d1 = 1 e d2 = 7  
*
*                               logo : 01/12 - 1 = 30/11
*                                      01/12 - 7 = 24/11   ----> selecao dos titulos   24/11 a 30/11
* ----------------------------------------------------------------------------------------------*
Static Function Sld_atual_faixa(d1,d2)

cCond := " SELECT SUM(E1_SALDO) ABERTOS "
cCond += " FROM " + RetSqlname( "SE1" ) + " SE1"
cCond += " WHERE E1_VENCREA BETWEEN '" + Dtos( D_limite - D2 ) + "' AND '" + Dtos( D_limite - D1 ) + "'   "
ccond += " AND (E1_BAIXA='' OR E1_VENCREA < E1_BAIXA ) "
cCond += " AND E1_TIPO IN ('NF','CH') "
cCond += " AND E1_PREFIXO <> 'COM' AND E1_PREFIXO <> 'CH '" //Mudar prefixos
cCond += " AND SUBSTRING(E1_NATUREZ,4,2) <> '06' " //Mudar para naturezas usadas na Rava
cCond += " AND E1_ORIGEM <> 'FINA460' " //CHEQUES A RECEBER
cCond += " AND SE1.D_E_L_E_T_ = ' ' "
TCQUERY cCond ALIAS TEMP1 NEW
TCSetField( "TEMP1", "ABERTOS", "N", 12, 2 )

Resulta := Temp1->Abertos
Temp1->(DbCloseArea())
IncRegua()
Return(Resulta)


* ----------------------------------------------------------------------------------------------*
* Total dos titulos abertos ou em atraso dentro da faixa
*
* Parametros : D1 --> quantidade de dias a decrementar da data inicial
*              D2 --> quantidade de dias a decrementar da data inicial
* Ex: a primeira data(Mv_par01) é 01/12, d1 = 1 e d2 = 7  
*
*                               logo : 01/12 - 1 = 30/11
*                                      01/12 - 7 = 24/11   ----> selecao dos titulos   24/11 a 30/11
* ----------------------------------------------------------------------------------------------*
Static Function Tit_atraso(d1,d2)

cCond := " SELECT SUM( E1_VALOR ) VENCIDOS"
cCond += " FROM " + RetSqlname( "SE1" ) + " SE1"
cCond += " WHERE E1_VENCREA BETWEEN '" + Dtos( D_limite - D2 ) + "' AND '" + Dtos( D_limite - D1 ) + "' "
cCond += " AND ( E1_BAIXA = '' OR E1_BAIXA > E1_VENCREA ) "
cCond += " AND E1_TIPO IN ('NF','CH') "
cCond += " AND E1_PREFIXO <> 'COM' AND E1_PREFIXO <> 'CH '" //Mudar prefixo
cCond += " AND SUBSTRING(E1_NATUREZ,4,2) <> '06' " //Mudar para naturezas usadas na Rava
cCond += " AND E1_ORIGEM <> 'FINA460' " //CHEQUES A RECEBER
cCond += " AND SE1.D_E_L_E_T_ = ' ' "
TCQUERY cCond ALIAS Temp1 NEW     

TCSetField( "TEMP1", "VENCIDOS", "N", 12, 2 )

Resulta := Temp1->vencidos
Temp1->(DbCloseArea())
IncRegua()
Return(Resulta)
