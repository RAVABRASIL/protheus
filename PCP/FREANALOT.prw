#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'

/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁNOVO4     ╨ Autor Ё AP6 IDE            ╨ Data Ё  27/11/15   ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descricao Ё Codigo gerado pelo AP6 IDE.                                ╨╠╠
╠╠╨          Ё                                                            ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё AP6 IDE                                                    ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/


*************

User Function FREANALOT()

*************

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de Variaveis                                             Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Analise do Lote "
Local cPict          := ""
Local titulo         := "Analise do Lote "
Local nLin           := 80

Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "FREANALOT" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FREANALOT" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString      := ""


oPerg1("FREANALOT")


If !Pergunte("FREANALOT",.T.)

   Return 

EndIf

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta a interface padrao com o usuario...                           Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

wnrel := SetPrint(cString,NomeProg,"FREANALOT",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

titulo:="Analise do Lote "+alltrim(MV_PAR01)


If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Processamento. RPTSTATUS monta janela com a regua de processamento. Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Fun┤└o    ЁRUNREPORT ╨ Autor Ё AP6 IDE            ╨ Data Ё  27/11/15   ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descri┤└o Ё Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ╨╠╠
╠╠╨          Ё monta a janela com a regua de processamento.               ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё Programa principal                                         ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cQry:=''
Local _cStatus:=" "
LOCAL _lAjuste:=.F. 
Local aUsua := {} 						// Retorna vetor com informaГУes do usuАrio
lOCAL cNomeOpe := ""
Local cLoteAnt	:= ""
Local cDataLote	:= ""
			
DbSelectArea("ZZB")
ZZB->(DbSetOrder(1))

IF ZZB->(DbSeek(XFILIAL('ZZB')+MV_PAR01 ))
   _cStatus:=ZZB->ZZB_STATUS
   _lAjuste:=iif(EMPTY(ZZB->ZZB_AJUSTE),.F.,.T.)
ENDIF


// informacao da contagem dos Produtos do lote  

cQry:="SELECT B1_TITORIG,ZZD_PROD,ZZD_QTDFI FROM "+RetSqlName("ZZD")+" ZZD ,"+RetSqlName("SB1")+" SB1 "
cQry+="WHERE ZZD_LOTE='"+MV_PAR01+"' "
cQry+="AND ZZD_PROD=B1_COD "
cQry+="AND SB1.D_E_L_E_T_='' "
cQry+="AND ZZD.D_E_L_E_T_='' "
cQry+="ORDER BY ZZD_PROD "


If Select("TMPX") > 0
	DbSelectArea("TMPX")
	TMPX->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS 'TMPX'    

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё SETREGUA -> Indica quantos registros serao processados para a regua Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

SetRegua(0)

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Posicionamento do primeiro registro e loop principal. Pode-se criar Ё
//Ё a logica da seguinte maneira: Posiciona-se na filial corrente e pro Ё
//Ё cessa enquanto a filial do registro for a filial corrente. Por exem Ё
//Ё plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    Ё
//Ё                                                                     Ё
//Ё dbSeek(xFilial())                                                   Ё
//Ё While !EOF() .And. xFilial() == A1_FILIAL                           Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

TMPX->(dbGoTop())
IF TMPX->(!EOF())

   If nLin > 55 // Salto de PАgina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif
   
   @nLin,00 PSAY 'Status.: '+iif(ALLTRIM(_cStatus)='F','Lote Finalizado '+IIF(_lAjuste,'Com','Sem')+' Ajuste', iif(ALLTRIM(_cStatus)='E','Lote Encerrado a Contagem','Lote em Aberto'))
   @nLin++

   // CABEгALHO 
   @nLin++,00 PSAY REPLICATE('_',95+IIF(_lAjuste,22,0) )
   @nLin,00 PSAY 'MP'
   @nLin,17 PSAY 'DESCRITIVO'   
   @nLin,49 PSAY 'QTD_FISICO'
   @nLin,61 PSAY SPACE(6)+'ESTOQUE '+SUBSTR(MV_PAR01,7,2)
   @nLin,79 PSAY SPACE(6)+'QTD_AJUSTE'

   if _lAjuste
      
      @nLin,97 PSAY 'Informacao do Ajuste'
      aInfAju:=fInfAju()
   
   endif
   
   @nLin++,00 PSAY REPLICATE('_',95+IIF(_lAjuste,22,0) )	



	While TMPX->(!EOF())
	
	   //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	   //Ё Verifica o cancelamento pelo usuario...                             Ё
	   //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	
	   If lAbortPrint
	      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	      Exit
	   Endif
	
	   //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	   //Ё Impressao do cabecalho do relatorio. . .                            Ё
	   //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	
	   If nLin > 55 // Salto de PАgina. Neste caso o formulario tem 55 linhas...
	      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	      nLin := 8
	   Endif
	
	   // Coloque aqui a logica da impressao do seu programa...
	   // Utilize PSAY para saida na impressora. Por exemplo:
	   @nLin,00 PSAY TMPX->ZZD_PROD
	   @nLin,17 PSAY substr(TMPX->B1_TITORIG,1,30)
   	   @nLin,49 PSAY Transform(TMPX->ZZD_QTDFI,"@E 999,999.99")
	   
	   nEstoque:=fEsto(TMPX->ZZD_PROD,SUBSTR(MV_PAR01,7,2))
	   
	   @nLin,61 PSAY Transform(nEstoque,"@E 999,999,999.9999")
       @nLin,79 PSAY Transform(TMPX->ZZD_QTDFI - nEstoque,"@E 999,999,999.9999")	   
	   
	   if _lAjuste
    
	      nInd  := aScan(aInfAju,{|x| x[1] == TMPX->ZZD_PROD })
	      
	      If nInd >0
	         @nLin,97 PSAY 	Transform(aInfAju[nInd][2],"@E 999,999,999.9999")	   
          else
             @nLin,97 PSAY 	" "                 
          Endif
	   
	   endif
	
	   nLin := nLin + 1 // Avanca a linha de impressao
	
	   TMPX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	   IncRegua()    
	   
	EndDo

EndIf


// informacao das OPs do lote 

cQry:=" "
cQry:="SELECT "

cQry+="ZZC_OP OP,ZZC_PRODPA COD_PA,ZZC_QTDUM QTD,ZZC_UM UNIDADE,ZZC_QTDSUM QTD_SEG,ZZC_SEGUM  SEG_UNIDADE, "
cQry+="PESO_KG,APARA,PERC_APARA=(APARA/CASE WHEN (APARA+PESO_KG)=0 THEN 1 ELSE (APARA+PESO_KG) END)*100 "

cQry+="FROM ( "

cQry+="SELECT ZZC_OP,ZZC_PRODPA,ZZC_QTDUM,ZZC_UM,ZZC_QTDSUM,ZZC_SEGUM, "
cQry+="PESO_KG=ISNULL(sum(CASE WHEN Z00_APARA IN ('') THEN Z00.Z00_PESO+Z00.Z00_PESCAP ELSE 0 END ),0) "
cQry+=",APARA=ISNULL(sum(CASE WHEN Z00_APARA NOT IN ('','W') THEN Z00.Z00_PESO+Z00.Z00_PESCAP ELSE 0 END ),0) "
cQry+="FROM  "
cQry+=""+RetSqlName("ZZC")+" ZZC WITH (NOLOCK) "
cQry+="LEFT JOIN "+RetSqlName("Z00")+" Z00 WITH (NOLOCK) ON Z00_FILIAL='"+XFILIAL('Z00')+"' AND Z00_MAQ LIKE '[E][0123456789]%' AND LEFT(Z00_OP,6)=ZZC_OP  AND Z00.D_E_L_E_T_ = ' '  "
cQry+="WHERE "
cQry+="ZZC_LOTE='"+MV_PAR01+"' "
cQry+="AND ZZC.D_E_L_E_T_ = ' ' "
cQry+="GROUP BY ZZC_OP,ZZC_PRODPA,ZZC_QTDUM,ZZC_UM,ZZC_QTDSUM,ZZC_SEGUM "

cQry+=")AS TABX  "


If Select("TMPX") > 0
	DbSelectArea("TMPX")
	TMPX->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS 'TMPX'    

TMPX->(dbGoTop())

IF TMPX->(!EOF())

   If nLin > 55 // Salto de PАgina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

     // CABEгALHO 
    @nLin++
	@nLin,00 PSAY 'Realizado em ExtrusЦo'
	@nLin++,00 PSAY REPLICATE('_',125)
	@nLin,00 PSAY 'OP'
	@nLin,08 PSAY 'COD_PA'
	@nLin,25 PSAY 'QTD'
	@nLin,37 PSAY ' ' //'UM'
	@nLin,46 PSAY 'PROGRAMADO' //'QTD_SEG'
	@nLin,58 PSAY ' ' //'UM_SEG'
	@nLin,67 PSAY 'REALIZADO'
	@nLin,79 PSAY '  %'
	@nLin,87 PSAY 'APARA'
	@nLin,99 PSAY '  %' 
	@nLin,107 PSAY '  TOTAL OP'
	@nLin,119 PSAY '    %'

	
	@nLin++,00 PSAY REPLICATE('_',125)
	
	While TMPX->(!EOF())
	
	   //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	   //Ё Verifica o cancelamento pelo usuario...                             Ё
	   //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	
	   If lAbortPrint
	      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	      Exit
	   Endif
	
	   //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	   //Ё Impressao do cabecalho do relatorio. . .                            Ё
	   //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	
	   If nLin > 55 // Salto de PАgina. Neste caso o formulario tem 55 linhas...
	      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	      nLin := 8
	      
	           // CABEгALHO 
	        @nLin++
	        @nLin,00 PSAY 'Realizado em ExtrusЦo'
			@nLin++,00 PSAY REPLICATE('_',125)
			@nLin,00 PSAY 'OP'
			@nLin,08 PSAY 'COD_PA'
			@nLin,25 PSAY 'QTD'
			@nLin,37 PSAY ' ' //'UM'
			@nLin,46 PSAY 'PROGRAMADO' //'QTD_SEG'
			@nLin,58 PSAY ' ' //'UM_SEG'
			@nLin,67 PSAY 'REALIZADO'
			@nLin,79 PSAY '  %'
			@nLin,87 PSAY 'APARA'
			@nLin,99 PSAY '  %' 
	        @nLin,107 PSAY '  TOTAL OP'
	        @nLin,119 PSAY '    %'
			
			@nLin++,00 PSAY REPLICATE('_',125)
		
	   Endif
	
	   // Coloque aqui a logica da impressao do seu programa...
	   // Utilize PSAY para saida na impressora. Por exemplo:
		   
		   @nLin,00 PSAY TMPX->OP
		   @nLin,08 PSAY TMPX->COD_PA
		   @nLin,25 PSAY Transform(TMPX->QTD,"@E 999,999.99")
		   @nLin,37 PSAY TMPX->UNIDADE
		   @nLin,46 PSAY Transform(TMPX->QTD_SEG,"@E 999,999.99")
		   @nLin,58 PSAY TMPX->SEG_UNIDADE
	       @nLin,67 PSAY Transform(TMPX->PESO_KG,"@E 999,999.99")
	       @nLin,79 PSAY Transform(TMPX->PESO_KG/TMPX->QTD_SEG*100,"@E 999.99")
	       @nLin,87 PSAY Transform(TMPX->APARA,"@E 999,999.99")
	       @nLin,99 PSAY transform( TMPX->PERC_APARA,"@E 999.99")	       
		   @nLin,107 PSAY Transform(TMPX->PESO_KG+TMPX->APARA,"@E 999,999.99")
	       @nLin,119 PSAY transform((TMPX->PESO_KG+TMPX->APARA)/TMPX->QTD_SEG*100,"@E 999.99")	       

		   nLin := nLin + 1 // Avanca a linha de impressao	   	   
	   
	       TMPX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	      IncRegua()    
	      
	EndDo


EndIf


TMPX->(DBCLOSEAREA())


// informacao das APARA POR OPERADOR 

cQry:=" SELECT Z00_OPERAD, SUM(Z00.Z00_PESO+Z00.Z00_PESCAP) APARA FROM " + RetSqlName("Z00") + " Z00 WITH (NOLOCK) "
cQry+="INNER JOIN " + RetSqlName("ZZC") + " ZZC WITH (NOLOCK) "
cQry+="ON LEFT(Z00_OP,6)=ZZC_OP "
cQry+="WHERE Z00_APARA NOT IN ('','W') "
cQry+="AND Z00_MAQ LIKE '[E][0123456789]%' "  
cQry+="AND ZZC_LOTE='"+MV_PAR01+"' "
cQry+="AND Z00.D_E_L_E_T_ <> '*' "
cQry+="GROUP BY Z00_OPERAD "
cQry+="ORDER BY APARA DESC "

If Select("TMPY") > 0
	DbSelectArea("TMPY")
	TMPY->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS 'TMPY'    

TMPY->(dbGoTop())

IF TMPY->(!EOF())

   If nLin > 55 // Salto de PАgina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

     // CABEгALHO 
    @nLin++
	@nLin,00 PSAY 'Detalhe APARAS'
	@nLin++,00 PSAY REPLICATE('_',125)
	//@nLin,00 PSAY 'OP'
	@nLin,08 PSAY 'OPERADOR'
	@nLin,25 PSAY 'NOME'
	@nLin,37 PSAY ' ' //'UM'
	@nLin,64 PSAY 'APARA' //'QTD_SEG'
	@nLin,58 PSAY ' ' //'UM_SEG'
	//@nLin,67 PSAY 'REALIZADO'
	//@nLin,79 PSAY '  %'
	//@nLin,87 PSAY 'APARA'
	//@nLin,99 PSAY '  %' 
	//@nLin,107 PSAY '  TOTAL OP'
	//@nLin,119 PSAY '    %'

	
	@nLin++,00 PSAY REPLICATE('_',125)
	
	While TMPY->(!EOF())
	
	   //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	   //Ё Verifica o cancelamento pelo usuario...                             Ё
	   //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	
	   If lAbortPrint
	      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	      Exit
	   Endif
	
	   //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	   //Ё Impressao do cabecalho do relatorio. . .                            Ё
	   //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	
	   If nLin > 55 // Salto de PАgina. Neste caso o formulario tem 55 linhas...
	      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	      nLin := 8
	      
	           // CABEгALHO 
		    @nLin++
			@nLin,00 PSAY 'Detalhe APARAS'
			@nLin++,00 PSAY REPLICATE('_',125)
			//@nLin,00 PSAY 'OP'
			@nLin,08 PSAY 'OPERADOR'
			@nLin,20 PSAY 'NOME'
			@nLin,37 PSAY ' ' //'UM'
			//@nLin,46 PSAY 'APARA' //'QTD_SEG'
			@nLin,64 PSAY 'APARA' //'UM_SEG'
			//@nLin,67 PSAY 'REALIZADO'
			//@nLin,79 PSAY '  %'
			//@nLin,87 PSAY 'APARA'
			//@nLin,99 PSAY '  %' 
			//@nLin,107 PSAY '  TOTAL OP'
			//@nLin,119 PSAY '    %'
			
			@nLin++,00 PSAY REPLICATE('_',125)
		
	   Endif
	
	   // Coloque aqui a logica da impressao do seu programa...
	   // Utilize PSAY para saida na impressora. Por exemplo:
	   	dbSelectArea("SRA")
	   	dbSetOrder(1)
		If dbSeek( xFilial("SRA") + TMPY->Z00_OPERAD)
			cNomeOpe := SUBSTR(Alltrim(SRA->RA_NOME),1,25)		// Nome do usuАrio
		Else
			cNomeOpe := SPACE(25)
		Endif
		
		   //@nLin,00 PSAY TMPY->ZZC_OP
		   @nLin,08 PSAY TMPY->Z00_OPERAD
		   @nLin,20 PSAY cNomeOpe
		   //@nLin,37 PSAY TMPX->UNIDADE
		   //@nLin,46 PSAY Transform(TMPY->APARA,"@E 999,999.99")
		   @nLin,58 PSAY Transform(TMPY->APARA,"@E 999,999.99")
	       //@nLin,67 PSAY Transform(TMPX->PESO_KG,"@E 999,999.99")
	       //@nLin,79 PSAY Transform(TMPX->PESO_KG/TMPX->QTD_SEG*100,"@E 999.99")
	       //@nLin,87 PSAY Transform(TMPX->APARA,"@E 999,999.99")
	       //@nLin,99 PSAY transform( TMPX->PERC_APARA,"@E 999.99")	       
		   //@nLin,107 PSAY Transform(TMPX->PESO_KG+TMPX->APARA,"@E 999,999.99")
	       //@nLin,119 PSAY transform((TMPX->PESO_KG+TMPX->APARA)/TMPX->QTD_SEG*100,"@E 999.99")	       

		   nLin := nLin + 1 // Avanca a linha de impressao	   	   
	   
	       TMPY->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	      IncRegua()    
	      
	EndDo


EndIf


TMPY->(DBCLOSEAREA())

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Cria tabela temporАria...                                           Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
oTbl1()

cQry:=" SELECT B1_TITORIG,ZZD_PROD,ZZD_QTDFI, ZZD_DATAEN FROM ZZD020 ZZD , " + RetSqlName("SB1") + " SB1 " 
cQry+=" WHERE ZZD_LOTE = '" + MV_PAR01 + "' " 
cQry+=" AND ZZD_PROD=B1_COD  "
cQry+=" AND SB1.D_E_L_E_T_='' " 
cQry+=" AND ZZD.D_E_L_E_T_='' " 
cQry+=" ORDER BY ZZD_PROD "

TCQUERY cQry NEW ALIAS  "TMP1"

dbSelectArea("TMP1")
TMP1->(dbGoTop())

While TMP1->(!EOF())

	cDataLote	:= TMP1->ZZD_DATAEN
	
	RecLock("XFRT", .T.)
	
	XFRT->PROD		:= TMP1->ZZD_PROD
	XFRT->NOME		:= TMP1->B1_TITORIG
	XFRT->QTDLOTE	:= TMP1->ZZD_QTDFI
	XFRT->ENTRADA	:= 0 
	XFRT->SALDOINI	:= 0
	
	XFRT->(MsUnLock())
		
	TMP1->(dbSkip())
	
EndDo

TMP1->(dbclosearea())

cQry:=" SELECT D3_COD, SUM(D3_QUANT) D3_QUANT FROM  " + RetSqlName("SD3") + " SD3 " 
cQry+=" WHERE D3_DOC = '" + MV_PAR01 + "' "
cQry+=" AND D3_LOCAL = '" + SUBSTR(MV_PAR01, LEN(ALLTRIM(MV_PAR01))-1,2) + "' "
cQry+=" AND D_E_L_E_T_ = '' "
cQry+=" GROUP BY D3_COD "
cQry+=" ORDER BY D3_COD "

TCQUERY cQry NEW ALIAS  "TMP1"

dbSelectArea("TMP1")
TMP1->(dbGoTop())

While TMP1->(!EOF())

	If XFRT->(dbSeek(TMP1->D3_COD))
		RecLock("XFRT", .F.)
		
		XFRT->ENTRADA	:= TMP1->D3_QUANT 
		
		XFRT->(MsUnLock())
	Else
		RecLock("XFRT", .T.)
		
		XFRT->PROD		:= TMP1->D3_COD
		XFRT->NOME		:= ""
		XFRT->QTDLOTE	:= 0
		XFRT->ENTRADA	:= TMP1->D3_QUANT 
		XFRT->SALDOINI	:= 0
		
		XFRT->(MsUnLock())
	EndIf	
	
	TMP1->(dbSkip())
	
EndDo

TMP1->(dbclosearea())

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё pega o numero do lote anterior que И o saldo inicial...             Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

cQry:=" SELECT TOP 1 * FROM ZZD020 "
cQry+=" WHERE ZZD_DATAEN <  '" + cDataLote + "' "
cQry+=" AND SUBSTRING(ZZD_LOTE, LEN(LTRIM(RTRIM(ZZD_LOTE)))-1,2) = '" + SUBSTR(MV_PAR01, LEN(ALLTRIM(MV_PAR01))-1,2) + "' "
cQry+=" ORDER BY R_E_C_N_O_ DESC "

TCQUERY cQry NEW ALIAS  "TMP1"

dbSelectArea("TMP1")
TMP1->(dbGoTop())

While TMP1->(!EOF())

	cLoteAnt	:= TMP1->ZZD_LOTE
		
	TMP1->(dbSkip())
	
EndDo

TMP1->(dbclosearea())

cQry:=" SELECT B1_TITORIG,ZZD_PROD,ZZD_QTDFI, ZZD_DATAEN FROM ZZD020 ZZD , " + RetSqlName("SB1") + " SB1 " 
cQry+=" WHERE ZZD_LOTE = '" + cLoteAnt + "' " 
cQry+=" AND ZZD_PROD=B1_COD  "
cQry+=" AND SB1.D_E_L_E_T_='' " 
cQry+=" AND ZZD.D_E_L_E_T_='' " 
cQry+=" ORDER BY ZZD_PROD "

MemoWrite("C:\Temp\sldini.txt",cQry)

TCQUERY cQry NEW ALIAS  "TMP1"

dbSelectArea("TMP1")
TMP1->(dbGoTop())

While TMP1->(!EOF())

	If XFRT->(dbSeek(TMP1->ZZD_PROD))
		RecLock("XFRT", .F.)
		
		XFRT->SALDOINI	:= TMP1->ZZD_QTDFI 
		
		XFRT->(MsUnLock())
	Else
		RecLock("XFRT", .T.)
		
		XFRT->PROD		:= TMP1->ZZD_PROD
		XFRT->NOME		:= TMP1->B1_TITORIG
		XFRT->QTDLOTE	:= 0
		XFRT->ENTRADA	:= 0 
		XFRT->SALDOINI	:= TMP1->ZZD_QTDFI
		
		XFRT->(MsUnLock())
	EndIf	
	
	TMP1->(dbSkip())
	
EndDo

TMP1->(dbclosearea())

cQry:=" SELECT D4_COD, SUM(D4_QTDEORI) TEORIOCO FROM ( "
cQry+=" SELECT D4_COD, D4_QTDEORI FROM SD4020 "
cQry+=" WHERE D_E_L_E_T_ = '' "
cQry+=" AND D4_OP IN ( "
cQry+=" SELECT DISTINCT ZZC_OPPI  FROM ZZC020 ZZC WITH (NOLOCK) " 
cQry+=" WHERE ZZC_LOTE='" + MV_PAR01 + "' " 
cQry+=" AND ZZC.D_E_L_E_T_ = ' ' " 
cQry+=" AND SUBSTRING(ZZC_PRODPI,1,3) <> 'PII' ) "
cQry+=" UNION "
cQry+=" SELECT D4_COD, D4_QTDEORI FROM SD4020 "
cQry+=" WHERE D_E_L_E_T_ = '' "
cQry+=" AND D4_OP IN ( "
cQry+=" SELECT DISTINCT C2_NUM + C2_ITEM + C2_SEQUEN OP FROM SC2020 "
cQry+=" WHERE C2_NUM + C2_ITEM + C2_SEQPAI IN( "
cQry+=" SELECT DISTINCT ZZC_OPPI FROM ZZC020 ZZC WITH (NOLOCK)  "
cQry+=" WHERE ZZC_LOTE='" + MV_PAR01 + "' " 
cQry+=" AND ZZC.D_E_L_E_T_ = ' ' " 
cQry+=" AND SUBSTRING(ZZC_PRODPI,1,3) = 'PII' ) "
cQry+=" AND D_E_L_E_T_ = '' "
cQry+=" ) ) AS TAB "
cQry+=" GROUP BY D4_COD "
cQry+=" ORDER BY D4_COD "

TCQUERY cQry NEW ALIAS  "TMP1"

dbSelectArea("TMP1")
TMP1->(dbGoTop())

While TMP1->(!EOF())

	If XFRT->(dbSeek(TMP1->D4_COD))
		RecLock("XFRT", .F.)
		
		XFRT->TEORICO	:= TMP1->TEORIOCO 
		
		XFRT->(MsUnLock())
	Else
		RecLock("XFRT", .T.)
		
		XFRT->PROD		:= TMP1->D4_COD
		XFRT->NOME		:= ""
		XFRT->QTDLOTE	:= 0
		XFRT->ENTRADA	:= 0 
		XFRT->TEORICO	:= TMP1->TEORIOCO
		
		XFRT->(MsUnLock())
	EndIf	
	
	TMP1->(dbSkip())
	
EndDo

TMP1->(dbclosearea())

XFRT->(dbGoTop())

IF XFRT->(!EOF())

   If nLin > 55 // Salto de PАgina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

     // CABEгALHO 
    @nLin++
	@nLin,00 PSAY 'Consumo REAL'
	@nLin++,00 PSAY REPLICATE('_',125)
	@nLin,08 PSAY 'MP'
	@nLin,25 PSAY 'DESCRITIVO'
	@nLin,37 PSAY ' ' //'UM'
	@nLin,44 PSAY 'SALDO INI' //'QTD_SEG'
	@nLin,60 PSAY 'ENTRADAS' //'UM_SEG'
	@nLin,76 PSAY 'SALDO FIM'
	@nLin,92 PSAY 'CONSUMO REAL'
	@nLin,108 PSAY 'CONSUMO TEORICO'
	
	@nLin++,00 PSAY REPLICATE('_',125)
	
	While XFRT->(!EOF())
	
	   //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	   //Ё Verifica o cancelamento pelo usuario...                             Ё
	   //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	
	   If lAbortPrint
	      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	      Exit
	   Endif
	
	   //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	   //Ё Impressao do cabecalho do relatorio. . .                            Ё
	   //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	
	   If nLin > 55 // Salto de PАgina. Neste caso o formulario tem 55 linhas...
	      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	      nLin := 8
	      
	           // CABEгALHO 
		    @nLin++
			@nLin,00 PSAY 'Consumo REAL'
			@nLin++,00 PSAY REPLICATE('_',125)
			//@nLin,00 PSAY 'OP'
			@nLin,08 PSAY 'MP'
			@nLin,25 PSAY 'DESCRITIVO'
			@nLin,37 PSAY ' ' //'UM'
			@nLin,44 PSAY 'SALDO INI' //'QTD_SEG'
			@nLin,60 PSAY 'ENTRADAS' //'UM_SEG'
			@nLin,76 PSAY 'SALDO FIM'
			@nLin,92 PSAY 'CONSUMO REAL'
			@nLin,108 PSAY 'CONSUMO TEORICO'
			
			@nLin++,00 PSAY REPLICATE('_',125)
		
	   Endif
	
		   @nLin,08 PSAY XFRT->PROD
		   @nLin,20 PSAY XFRT->NOME
		   @nLin,44 PSAY Transform(XFRT->SALDOINI,"@E 999,999.99")
	       @nLin,60 PSAY Transform(XFRT->ENTRADA,"@E 999,999.99")
	       @nLin,76 PSAY Transform(XFRT->QTDLOTE,"@E 999,999.99")
	       @nLin,92 PSAY Transform(XFRT->SALDOINI + XFRT->ENTRADA - XFRT->QTDLOTE,"@E 999,999.99")
	       @nLin,108 PSAY Transform(XFRT->TEORICO,"@E 999,999.99")

		   nLin := nLin + 1 // Avanca a linha de impressao	   	   
	   
		   dbSelectArea("ZZH")
		   
		   If !ZZH->(dbSeek(xFilial("ZZH") + MV_PAR01 + XFRT->PROD ))

		   		RecLock("ZZH", .T.)
		   		
		   		ZZH->ZZH_FILIAL 	:= xFilial("ZZD")
		   		ZZH->ZZH_PROD 		:= XFRT->PROD
		   		ZZH->ZZH_LOTE 		:= MV_PAR01
		   		ZZH->ZZH_QTDINI 	:= XFRT->SALDOINI
		   		ZZH->ZZH_QTDENT 	:= XFRT->ENTRADA
		   		ZZH->ZZH_QTDLOT 	:= XFRT->QTDLOTE
		   		ZZH->ZZH_QTDFI 		:= XFRT->SALDOINI + XFRT->ENTRADA - XFRT->QTDLOTE
		   		ZZH->ZZH_QTDTEO		:= XFRT->TEORICO
		   		ZZH->ZZH_DATAEN		:= StoD(cDataLote)
		   		
		   		ZZH->(MsUnLock())
		   
		   EndIf

	       XFRT->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	      IncRegua()    
	      
	EndDo


EndIf


XFRT->(DBCLOSEAREA())

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Finaliza a execucao do relatorio...                                 Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

SET DEVICE TO SCREEN

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Se impressao em disco, chama o gerenciador de impressao...          Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

***************

Static Function oPerg1(cPerg)

***************

Local aHelpPor := {}

PutSx1( cPerg,'01','Lote          ?','','','mv_ch1','C',8,0,0,'G','','ZZB','','','mv_par01','','','','','','','','','','','','','','','','',aHelpPor,{},{} )

Return


***************

Static Function fEsto(cCod,cLocal)

***************

local cQry:=''
local nRet:=0

cQry:="SELECT B2_COD,B2_LOCAL,B2_QATU FROM "+RetSqlName("SB2")+" SB2  "
cQry+="WHERE "
cQry+="B2_FILIAL='01' "
cQry+="AND B2_COD='"+cCod+"' "
cQry+="AND B2_LOCAL='"+cLocal+"' "
cQry+="AND SB2.D_E_L_E_T_='' "

If Select("AUUX") > 0
	DbSelectArea("AUUX")
	AUUX->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS 'AUUX'    

IF AUUX->(!EOF())

   nRet:= AUUX->B2_QATU  

ENDIF

AUUX->(DbCloseArea())

Return nRet



***************

Static Function fInfAju()

***************

local cQry:=''
local ARet:={}


cQry:="SELECT  "
cQry+="D3_COD PROD, "
cQry+="QTD=CASE WHEN D3_TM>500 THEN D3_QUANT*-1 ELSE D3_QUANT END "
cQry+="FROM "+RetSqlName("SD3")+" SD3,"+RetSqlName("ZZB")+" ZZB "
cQry+="WHERE D3_FILIAL='"+XFILIAL('SD3')+"' " 
cQry+="AND ZZB_LOTE='"+MV_PAR01+"' "
cQry+="AND ZZB_LOTE=SUBSTRING(D3_OBS,6,8) "
cQry+="AND D3_EMISSAO=ZZB_DTFINA "
cQry+="AND ZZB.D_E_L_E_T_='' "
cQry+="AND SD3.D_E_L_E_T_='' "

If Select("AUIX") > 0
	DbSelectArea("AUIX")
	AUIX->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS 'AUIX'    

IF AUIX->(!EOF())

	WHILE  AUIX->(!EOF())
	
	   	Aadd( aRet, { AUIX->PROD,AUIX->QTD  } )
	    AUIX->(DBSKIP())
	    
	ENDDO

ELSE

	Aadd( aRet, { '', 0 } )

ENDIF

AUIX->(DbCloseArea())

Return aRet



/*ддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбддддддддддддддддддд
Function  Ё oTbl1() - Cria temporario para o Alias: XFRT
ддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддаддддддддддддддд*/
Static Function oTbl1()

Local aFds := {}

Aadd( aFds , {"PROD" 	,"C",015,000} )
Aadd( aFds , {"NOME" 	,"C",025,000} )
Aadd( aFds , {"QTDLOTE"	,"N",014,002} )
Aadd( aFds , {"ENTRADA"	,"N",014,002} )
Aadd( aFds , {"SALDOINI","N",014,002} )
Aadd( aFds , {"TEORICO" ,"N",014,002} )

If Select("XFRT") > 0
	DbSelectArea("XFRT")
	XFRT->(DbCloseArea())	
EndIf

coTbl5 := CriaTrab( aFds, .T. )
Use (coTbl5) Alias XFRT New Exclusive
Index On PROD To ( coTbl5 )

Return 
