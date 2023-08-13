#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch" 
#include "Ap5mail.ch" 
  

User Function FINR005()
   

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := ""
Local cPict         := ""
Local titulo        := ""
Local nLin          := 80

Local Cabec1        := ""
Local Cabec2        := ""
Local imprime       := .T.
Local aOrd := {}           

public n7:=n30:=n365:=0

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "P"
Private nomeprog    := "FINR005" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "FINR003" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""
Private cPerg     := "FINR005"



if !Pergunte(cPerg,.T.)
    return
endif      
if MV_PAR01 > MV_PAR02 .and. !empty(MV_PAR02)
alert('Data inicial deve ser menor que a final')
return
endif

if MV_PAR02 < MV_PAR01 .and. !empty(MV_PAR01)
alert('Data final deve ser maior que a inicial')
return
endif
 

nDias:= MV_PAR02-MV_PAR01
if nDias<=0
     nDias++
endif
alert(alltrim(str(nDias)))
n7  :=(nDias/7  ) +iif( nDias%7    !=0,1,0 )
n30 :=(nDias/30 ) +iif( nDias%30   !=0,1,0 )
n365:=(nDias/365) +iif( nDias%365  !=0,1,0 )
 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  30/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cQuery:=" "



cQuery+=" select                                             " +chr(10)
cQuery+=" Z74_GESTOR          GESTOR  ,                      " +chr(10) 
cQuery+=" Z74_TPROD           TIPO_PRODUTO ,                 " +chr(10)
cQuery+=" Z74_LIMITE          META,                          " +chr(10)
cQuery+=" Z74_PRAZO          PRAZO,                          " +chr(10)

cQuery+=" ISNULL((SELECT SUM((C7_QUANT- C7_QUJE)* C7_PRECO)   SALDO FROM SC7020 SC7,SB1010 SB1 " +chr(10)
cQuery+=" WHERE  B1_COD=C7_PRODUTO                           " +chr(10)
cQuery+=" and C7_FILIAL="+valtosql(xFilial('SC7'))                       +chr(10) 
cQuery+=" and B1_FILIAL="+valtosql(xFilial('SB1'))                       +chr(10) 
cQuery+=" AND B1_TIPO=Z74_TPROD                              " +chr(10)
cQuery+=" AND B1_ATIVO='S'                                   " +chr(10)
cQuery+=" AND C7_QUANT- C7_QUJE >0 AND C7_RESIDUO !='S'      " +chr(10)
cQuery+=" AND C7_EMISSAO BETWEEN "+DTOS(MV_PAR01)+" AND "+DTOS(MV_PAR02)+"  " +chr(10)
cQuery+=" AND SB1.D_E_L_E_T_!='*'                            " +chr(10)
cQuery+=" AND SC7.D_E_L_E_T_!='*'                            " +chr(10)
cQuery+=" ),0)  SALDO_PEDIDO,                                " +chr(10)
                                                             
cQuery+=" ISNULL((SELECT SUM(D1_TOTAL)                       " +chr(10)
cQuery+=" From "+RetSqlName('SD1')+" SD1                     " +chr(10)
cQuery+=" WHERE                                              " +chr(10)
cQuery+=" D1_FILIAL="+valtosql(xFilial('SD1'))+"             " +chr(10)
cQuery+=" AND D1_EMISSAO BETWEEN "+DTOS(MV_PAR01)+" AND "+DTOS(MV_PAR02)+"  " +chr(10)
cQuery+=" AND D1_TP=Z74_TPROD                                " +chr(10)
cQuery+=" AND SD1.D_E_L_E_T_!='*'                            " +chr(10)
cQuery+=" ),0) TOTAL_NFE                                     " +chr(10)
                                                             
cQuery+=" From "+RetSqlName('Z74')+" Z74                     " +chr(10)         
cQuery+=" WHERE                                              " +chr(10)
cQuery+=" Z74_FILIAL="+valtosql(xFilial('Z74'))+"            " +chr(10)
cQuery+=" AND Z74.D_E_L_E_T_!='*'                            " +chr(10)
cQuery+=" GROUP BY Z74_GESTOR ,                              " +chr(10)
cQuery+=" Z74_TPROD ,                                        " +chr(10)
cQuery+=" Z74_LIMITE,Z74_PRAZO                                         " +chr(10)
                                                             

TCQUERY cQuery NEW ALIAS 'AUUX'
AUUX->(DBGOTOP())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  

 
SetRegua(RecCount())

While AUUX->(!EOF())
	//  cUF:=AUUX->Z15_UF
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...    
	                     //         0         0         0         0         0         0         0         0         0         1         1         1         1         1         1         1         1         1         1         2         3         4
	                     //         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2
	                     //1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		Cabec1         := "Gestor             tipo             Meta           Consumido       saldo da meta"                               
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
		
	Endif
 
	cGrupo:=AUUX->GESTOR
  	nTMeta   :=0
	nTConsumo:=0
	nTSaldo  :=0
  
	@nLin  ,000  PSAY U_cod2Nome(AUUX->GESTOR)
	While cGrupo ==  AUUX->GESTOR
        
         if (MV_PAR03 == 2)
		  @nLin  ,20  PSAY  AUUX->TIPO_PRODUTO 
		 endif
		 
		IF     AUUX->PRAZO=='S'
		nMeta:=AUUX->META*n7
		ELSEIF AUUX->PRAZO=='M'
		nMeta:=AUUX->META*n30
		ELSE   
		nMeta:=AUUX->META*n365
		ENDIF       
		 if (MV_PAR03 == 2)
		    @nLin  ,30-4  PSAY  transform(nMeta        ,"@E 999,999,999.99")
	    	@nLin  ,50-4  PSAY  transform(AUUX->SALDO_PEDIDO+AUUX->TOTAL_NFE,"@E 999,999,999.99")
		    @nLin  ,70-4  PSAY  transform(nMeta - (AUUX->SALDO_PEDIDO+AUUX->TOTAL_NFE)   ,"@E 999,999,999.99")
		endif
		nTMeta   +=nMeta
		nTConsumo+=AUUX->SALDO_PEDIDO+AUUX->TOTAL_NFE	 
		nTSaldo  +=nMeta - (AUUX->SALDO_PEDIDO+AUUX->TOTAL_NFE) 	 
		
		IncRegua()
		AUUX->(dbSkip()) // Avanca o ponteiro do registro no arquivo 
		if (MV_PAR03 == 2)
          nLin++
	    endif
EndDo     
        if (MV_PAR03 == 2)
           nLin++ 
           @nLin  ,00  PSAY  "Total " 
        endif
        @nLin  ,30-4  PSAY  transform(nTMeta   ,"@E 999,999,999.99")
		@nLin  ,50-4  PSAY  transform(nTConsumo,"@E 999,999,999.99")
		@nLin  ,70-4  PSAY  transform(nTSaldo  ,"@E 999,999,999.99")
		nLin++
		@nLin  ,00  PSAY  replicate("_",84-4)  
		nLin++
EndDo
 
AUUX-> (dbcloseArea()) 
 
SET DEVICE TO SCREEN


If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return   

static function Func_Nome(cNomeCod)
 
		PswOrder(1)
		If PswSeek( cNomeCod, .T. )
			aUsuarios  := PSWRET()
			cNomeCod := Alltrim(aUsuarios[1][2])
		Endif
return cNomeCod           


 