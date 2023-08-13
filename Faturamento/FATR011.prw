#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#include "font.ch"
#include "colors.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO23    º Autor ³ AP6 IDE            º Data ³  07/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATR011()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Pedidos Liberados "
Local cPict          := ""
Local titulo         := "Pedidos Liberados "
Local nLin           := 80
                       //         10        20        30        40        50        60        70        80        90        100       110       120       130     140
                      //012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Local Cabec1         := "Pedido Cliente                                   Transportadora                                   Valor           Peso              Volume     Observacoes"
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "FATR011" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATR011" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

Pergunte("FATR011",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"FATR011",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  07/04/10   º±±
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
LOCAL cQry:=''
LOCAL cUF:=''
local nVol:=0
LOCAL LF  := CHR(13) + CHR(10)
Local cC5OBSERVA 
Local cObs       
/*
cQry:=" SELECT C5_NUM PEDIDO,A1_NOME CLIENTE, A4_NOME TRANSP,ZZ_DESC LOCALIZ,                              " + CHR(10)
cQry+=" A1_EST UF,ZZ_TIPO,SUM(C6_VALOR) VALOR, SUM(C6_QTDVEN*B1_PESO) PESO,SUM(C6_QTDVEN*B1_QE) QDTVOLUME  " + CHR(10)
cQry+=" FROM SC5020 SC5 ,SC6020 SC6,SA4010 SA4,SZZ010 SZZ,SB1010 SB1 ,SA1010 SA1,SC9020 SC9                " + CHR(10)
cQry+=" WHERE C5_NUM=C6_NUM    " + CHR(10)
cQry+=" AND C9_PEDIDO = C6_NUM " + CHR(10)
cQry+=" and C9_ITEM = C6_ITEM  " + CHR(10)
cQry+=" AND C9_BLCRED=''       " + CHR(10)
cQry+=" AND C9_BLEST=''AND A4_COD=C5_TRANSP  " + CHR(10)
cQry+=" AND ZZ_TRANSP=C5_TRANSP   " + CHR(10)
cQry+=" AND ZZ_LOCAL=C5_LOCALIZ   " + CHR(10)
cQry+=" AND A1_COD=C5_CLIENTE     " + CHR(10)
cQry+=" AND A1_LOJA=C5_LOJACLI    " + CHR(10)
cQry+=" AND B1_COD=C6_PRODUTO     " + CHR(10)
cQry+=" AND C5_TIPO='N'           " + CHR(10)
cQry+=" AND A1_EST BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'  " + CHR(10)
cQry+=" AND SC5.D_E_L_E_T_!='*'  " + CHR(10)
cQry+=" AND SC5.D_E_L_E_T_!='*'  " + CHR(10)
cQry+=" AND SC9.D_E_L_E_T_!='*'  " + CHR(10)
cQry+=" AND SA4.D_E_L_E_T_!='*'  " + CHR(10)
cQry+=" AND SZZ.D_E_L_E_T_!='*'  " + CHR(10)
cQry+=" AND SB1.D_E_L_E_T_!='*'  " + CHR(10)
cQry+=" GROUP BY C5_NUM ,A1_NOME , A4_NOME ,ZZ_DESC ,A1_EST ,ZZ_TIPO " + CHR(10)
cQry+=" ORDER BY A1_EST,ZZ_TIPO,LOCALIZ,PEDIDO                       " + CHR(10)
*/

cQry+="SELECT   "   + LF
cQry+="C5_NUM PEDIDO,A1_NOME CLIENTE, A4_NOME TRANSP,C5_TRANSP, " + LF
cQry+="isnull(ZZ_DESC,'')  LOCALIZ,"                              + LF
cQry+="A1_EST UF, " + LF
cQry+="isnull(ZZ_TIPO,'C') ZZ_TIPO, " + LF
cQry+="SUM(C6_VALOR) VALOR, SUM(C6_QTDVEN*B1_PESO) PESO,SUM(C6_QTDVEN*B1_QE) QDTVOLUME   " + LF
cQry+=", SUM(C6_VALOR + (C6_VALOR * (C5_DESC1 / 100) ) )VALORCHEIO " + LF
cQry+=", C5_DESC1 " + LF
cQry+="FROM SC5020 SC5  " + LF
cQry+="join SC6020 SC6 on C5_NUM=C6_NUM  " + LF
cQry+="AND SC6.D_E_L_E_T_!='*' "  + LF
cQry+="join SA4010 SA4 on  A4_COD=C5_TRANSP   " + LF
cQry+="AND SA4.D_E_L_E_T_!='*'  " + LF
cQry+="left join SZZ010 SZZ on  ZZ_TRANSP=C5_TRANSP  AND ZZ_LOCAL=C5_LOCALIZ  " + LF
cQry+="AND ZZ_FILIAL='"+XFILIAL('SZZ')+"'  AND SZZ.D_E_L_E_T_!='*'  " + LF
cQry+="join SB1010 SB1 on  B1_COD=C6_PRODUTO  " + LF
cQry+="AND SB1.D_E_L_E_T_!='*' "  + LF
cQry+="join SA1010 SA1 on A1_COD=C5_CLIENTE AND A1_LOJA=C5_LOJACLI    " + LF
cQry+="AND SA1.D_E_L_E_T_!='*' "  + LF
cQry+="join SC9020 SC9  on C9_PEDIDO = C6_NUM and C9_ITEM = C6_ITEM   " + LF
cQry+="AND SC9.D_E_L_E_T_!='*' "                                             + LF
cQry+="WHERE  "   + LF
cQry+="C5_TIPO='N'  "  + LF         
cQry+="AND C9_BLCRED=''  AND C9_BLEST=''  " 
// NOVA LIBERACAO DE CREDITO
cQry+="AND C9_BLCRED IN('','04')  AND C9_BLEST= '' "  + LF

//cQry+= " and C5_NUM in ( '078830' , '078558' ) " + LF   //teste

cQry+="AND A1_EST BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'  " + LF
cQry+="AND C5_FILIAL='"+XFILIAL('SC5')+"'  " + LF
cQry+="AND C6_FILIAL='"+XFILIAL('SC6')+"'  " + LF
cQry+="AND C9_FILIAL='"+XFILIAL('SC9')+"'  " + LF
cQry+="AND B1_FILIAL='"+XFILIAL('SB1')+"'  " + LF
cQry+="AND A1_FILIAL='"+XFILIAL('SA1')+"'  " + LF
cQry+="AND A4_FILIAL='"+XFILIAL('SA4')+"'  " + LF


cQry+="AND SC5.D_E_L_E_T_!='*'    " + LF
cQry+="AND SC6.D_E_L_E_T_!='*'    " + LF
cQry+="AND SA4.D_E_L_E_T_!='*'    " + LF
cQry+="AND SB1.D_E_L_E_T_!='*'    " + LF
cQry+="AND SA1.D_E_L_E_T_!='*'    " + LF
cQry+="AND SC9.D_E_L_E_T_!='*'    " + LF
cQry+="GROUP BY C5_NUM ,A1_NOME , A4_NOME ,ZZ_DESC ,A1_EST ,ZZ_TIPO,C5_TRANSP, C5_DESC1  " + LF
cQry+="ORDER BY A1_EST,ZZ_TIPO,LOCALIZ,PEDIDO  " + LF
MemoWrite("C:\TEMP\FATR011.SQL",cQry)
TCQUERY cQry NEW ALIAS "TMPZ"

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
//³ While !EOF() .And. xFilial() 	== A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

TMPZ->(dbGoTop())
While TMPZ->(!EOF() )

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
   
   
   cUF:=TMPZ->UF
   ntotVuf:=0
   ntotPuf:=0
   ntotVouf:=0
   @nLin++,00 PSAY  "Estado: "+TMPZ->UF 
   Do While TMPZ->(!EOF() ) .AND. TMPZ->UF==cUF   
      
       If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
         Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
         nLin := 8
       Endif
      cTipo:=TMPZ->ZZ_TIPO
      if TMPZ->ZZ_TIPO=='C'
	      @nLin++,00 PSAY  "Capital: "+IIF(ALLTRIM(TMPZ->C5_TRANSP)!='024',TMPZ->LOCALIZ,LOCALIZ(TMPZ->UF ) ) 
	      ntotVC:=0
          ntotPC:=0
          ntotVoC:=0
	      Do While TMPZ->(!EOF() ) .AND. TMPZ->UF==cUF  .AND.  UPPER(TMPZ->ZZ_TIPO)=='C'
	      		//cC5OBSERVA := ""
	      		
	      		SC5->(DBSetorder(1))
	      		If SC5->(Dbseek(xFilial("SC5") + TMPZ->PEDIDO ))
		      		cObs := SC5->C5_OBSERVA
		      		cC5OBSERVA := cObs //storeObs( cObs )
		      	Endif 
		      	
		      If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	            Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	            nLin := 8
	         Endif
	      
		      nVol := TMPZ->QDTVOLUME
			  If ( nVol - Int( nVol ) ) > .00999
				 nVol := Int( nVol ) + 1
			  endif
		      
		      @nLin,00    PSAY  TMPZ->PEDIDO 
		      @nLin,08    PSAY  TMPZ->CLIENTE 
		      @nLin,50    PSAY  TMPZ->TRANSP   
		      //@nLin,92    PSAY  transform(TMPZ->VALOR,"@E 999,999,999.99") 
		      @nLin,92    PSAY  transform(TMPZ->VALORCHEIO,"@E 999,999,999.99") 
		      @nLin,108   PSAY  transform(TMPZ->PESO,"@E 999,999,999.9999" )
		      //@nLin++,126 PSAY  transform(nVol,"@E 999,999,999") 
		      @nLin,126 PSAY  transform(nVol,"@E 999,999,999") 
		      @nLin, 144  PSAY  cC5OBSERVA
		      nLin++
		      
		      //ntotVC+= TMPZ->VALOR
		      ntotVC+= TMPZ->VALORCHEIO
              ntotPC+= TMPZ->PESO
              ntotVoC+=nVol
		      //-----------------
		      //ntotVuf+=TMPZ->VALOR
		      ntotVuf+=TMPZ->VALORCHEIO
              ntotPuf+=TMPZ->PESO
              ntotVouf+=nVol
		      
		      INCREGUA()
		      TMPZ->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	      EndDo
          @nLin++,00 PSAY  REPLICATE("*",137)
          @nLin,50    PSAY  "Capital "+cUF   
		  @nLin,92    PSAY  transform(ntotVC,"@E 999,999,999.99") 
		  @nLin,108   PSAY  transform(ntotPC,"@E 999,999,999.9999" )
		  @nLin++,126 PSAY  transform(ntotVoC,"@E 999,999,999") 			      
      elseif TMPZ->ZZ_TIPO=='I'
	      @nLin++,00 PSAY  "Interior " 
	      ntotVI:=0
          ntotPI:=0
          ntotVoI:=0
	      Do While TMPZ->(!EOF() ) .AND. TMPZ->UF==cUF  .AND.  UPPER(TMPZ->ZZ_TIPO)=='I'
		      cLocaliz:=TMPZ->LOCALIZ
		      @nLin++,00 PSAY  "Localidade: "+TMPZ->LOCALIZ 
		      Do While TMPZ->(!EOF() ) .AND. TMPZ->UF==cUF  .AND.  TMPZ->ZZ_TIPO=='I' .AND.  TMPZ->LOCALIZ==cLocaliz
			      //cC5OBSERVA := ""
	      		
	      		SC5->(DBSetorder(1))
	      		If SC5->(Dbseek(xFilial("SC5") + TMPZ->PEDIDO ))
		      		cObs := SC5->C5_OBSERVA
		      		cC5OBSERVA := cObs //storeObs( cObs )
		      	Endif
			      If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		            Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		            nLin := 8
		         Endif
		      
			      nVol := TMPZ->QDTVOLUME
				  If ( nVol - Int( nVol ) ) > .00999
					 nVol := Int( nVol ) + 1
				  endif
			      
			      @nLin,00    PSAY  TMPZ->PEDIDO 
			      @nLin,08    PSAY  TMPZ->CLIENTE 
			      @nLin,50    PSAY  TMPZ->TRANSP   
			      //@nLin,92    PSAY  transform(TMPZ->VALOR,"@E 999,999,999.99") 
			      @nLin,92    PSAY  transform(TMPZ->VALORCHEIO,"@E 999,999,999.99") 
			      @nLin,108   PSAY  transform(TMPZ->PESO,"@E 999,999,999.9999" )
			      //@nLin++,126 PSAY  transform(nVol,"@E 999,999,999") 
			      @nLin,126 PSAY  transform(nVol,"@E 999,999,999") 
			      @nLin, 144  PSAY  cC5OBSERVA
			      nLin++
			      //ntotVI+=TMPZ->VALOR
			      ntotVI+=TMPZ->VALORCHEIO
                  ntotPI+=TMPZ->PESO
                  ntotVoI+=nVol
			      //-----------------
			      //ntotVuf+=TMPZ->VALOR
			      ntotVuf+=TMPZ->VALORCHEIO
                  ntotPuf+=TMPZ->PESO
                  ntotVouf+=nVol
			      
			      INCREGUA()
			      TMPZ->(dbSkip()) // Avanca o ponteiro do registro no arquivo
		      EndDo
          Enddo
          @nLin++,00 PSAY  REPLICATE("*",137)
          @nLin,50    PSAY  "Interior "+cUF   
		  @nLin,92    PSAY  transform(ntotVI,"@E 999,999,999.99") 
		  @nLin,108   PSAY  transform(ntotPI,"@E 999,999,999.9999" )
		  @nLin++,126 PSAY  transform(ntotVoI,"@E 999,999,999") 			      
      endif
   EndDo
   @nLin++,00 PSAY  REPLICATE("*",220)
   @nLin,50    PSAY  "Estado "+cUF   
   @nLin,92    PSAY  transform(ntotVUf,"@E 999,999,999.99") 
   @nLin,108   PSAY  transform(ntotPUf,"@E 999,999,999.9999" )
   @nLin++,126 PSAY  transform(ntotVoUf,"@E 999,999,999") 			      
EndDo

TMPZ->(DBCLOSEAREA())

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

Static Function LOCALIZ(cUF)

***************
local cQury:=''
local cret:=''

cQry:="SELECT SUBSTRING( ZZ_DESC,PATINDEX ( '%(%' , ZZ_DESC )+1,2) ZZ_UF,ZZ_TIPO,ZZ_DESC   "
cQry+="FROM SZZ010 SZZ "
cQry+="WHERE  "
cQry+="ZZ_FILIAL='"+XFILIAL('SZZ')+"'  "
cQry+="AND ZZ_TIPO='C'  "
cQry+="AND SUBSTRING( ZZ_DESC,PATINDEX ( '%(%' , ZZ_DESC )+1,2)='"+ALLTRIM(cUF)+"'   "
cQry+="AND SZZ.D_E_L_E_T_!='*'  "     
cQry+="GROUP BY SUBSTRING( ZZ_DESC,PATINDEX ( '%(%' , ZZ_DESC )+1,2) ,ZZ_TIPO,ZZ_DESC   "
TCQUERY cQry NEW ALIAS "TMPX"


TMPX->(dbGoTop())
IF TMPX->(!EOF() )
   cret:=TMPX->ZZ_DESC
ENDIF

TMPX->(DBCLOSEAREA()) 
Return  cRet
            

***************
Static Function storeObs( cObs )
***************

recLock("SC5", .F.)
SC5->C5_OBSERVA := cObs
SC5->( msUnlock() )

return