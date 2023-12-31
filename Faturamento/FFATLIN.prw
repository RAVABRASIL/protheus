#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE "TOPCONN.CH"

*************

User Function  FFATLIN()

*************


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de Variaveis                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Faturamento Diario "
Local cPict          := ""
Local titulo         := "Faturamento Diario "
Local nLin           := 80

Local Cabec1         := "Linha               SubLinha                 Faturamento Kg"
Local Cabec2         := "                   "
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "FFATLIN" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FFATLIN" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

Pergunte('FFATLIN',.F.)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Monta a interface padrao com o usuario...                           �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

wnrel  := SetPrint(cString,NomeProg,"FFATLIN",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)


titulo := "Faturamento De.: "+DTOC(MV_PAR01)+" Ate.:"+DTOC(MV_PAR02) 


If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튔un뇙o    쿝UNREPORT � Autor � AP6 IDE            � Data �  07/03/16   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒escri뇙o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS 볍�
굇�          � monta a janela com a regua de processamento.               볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � Programa principal                                         볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cQuery:=""


cQuery:= "SELECT "
cQuery+= "LINHA=CASE "
cQuery+= "      WHEN B1_GRUPO IN('D','E') THEN '2-DOMESTICA' "
cQuery+= "      WHEN B1_GRUPO IN('A','B','G') THEN '1-INSTITUCIONAL' "
cQuery+= "      WHEN B1_GRUPO IN('C') THEN '3-HOSPITALAR' "          
cQuery+= "      ELSE B1_GRUPO "
cQuery+= "      END, "
cQuery+= "   SUBLINHA=CASE "
cQuery+= "              WHEN B1_SETOR IN ('05','37','40') THEN 'Hamper Fita' "
cQuery+= "              WHEN B1_SETOR IN ('56') THEN 'Hamper Cord�o' "   
cQuery+= "              WHEN B1_SETOR IN ('08','09','10','11','12','13','14','30','34','35','36','41','55') THEN 'Infectantes' "
cQuery+= "              WHEN B1_SETOR IN ('06','54','98') THEN 'Obitos' "             
cQuery+= "              WHEN B1_SETOR IN ('23') THEN 'D. Limpeza' "                    
cQuery+= "              WHEN B1_SETOR IN ('24','25') THEN 'D. Limpeza Rolo'  "                                     
cQuery+= "              WHEN B1_SETOR IN ('26','27','28') THEN 'Brasileirinho'  "                   
cQuery+= "              WHEN B1_SETOR IN ('31','32') THEN 'Pacote'  "
cQuery+= "              WHEN B1_SETOR IN ('33') THEN 'Rolo'   "               
cQuery+= "              ELSE 'Outros' "
cQuery+= "             END,   "

cQuery+= "SUM(CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN (0) ELSE ((D2_QUANT-D2_QTDEDEV)*(D2_PESO )) END) AS FATKG "
cQuery+= "FROM "+RetSqlName("SD2")+" SD2 WITH (NOLOCK), "+RetSqlName("SB1")+" SB1 WITH (NOLOCK), "+RetSqlName("SF2")+" SF2 WITH (NOLOCK) "
cQuery+= "WHERE D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' and '"+DTOS(MV_PAR02)+"' "
cQuery+= "AND D2_TIPO = 'N' "
cQuery+= "AND D2_TP != 'AP' "
cQuery+= "and SB1.B1_SETOR <> '39' "
cQuery+= "AND RTRIM(D2_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) "
cQuery+= "AND D2_CLIENTE NOT IN ('031732','031733') "
cQuery+= "AND SD2.D_E_L_E_T_ = '' AND D2_COD = B1_COD "
cQuery+= "AND SB1.D_E_L_E_T_ = '' "
cQuery+= "AND D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA = F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA "
cQuery+= "AND F2_DUPL <> ' ' "
cQuery+= "AND SF2.D_E_L_E_T_ = '' "
cQuery+= "GROUP BY CASE  "
cQuery+= "           WHEN B1_GRUPO IN('D','E') THEN '2-DOMESTICA' "
cQuery+= "           WHEN B1_GRUPO IN('A','B','G') THEN '1-INSTITUCIONAL' "
cQuery+= "           WHEN B1_GRUPO IN('C') THEN '3-HOSPITALAR' "          
cQuery+= "           ELSE B1_GRUPO "
cQuery+= "         END, "
cQuery+= "         CASE  "
cQuery+= "              WHEN B1_SETOR IN ('05','37','40') THEN 'Hamper Fita' "
cQuery+= "              WHEN B1_SETOR IN ('56') THEN 'Hamper Cord�o' "   
cQuery+= "              WHEN B1_SETOR IN ('08','09','10','11','12','13','14','30','34','35','36','41','55') THEN 'Infectantes' "
cQuery+= "              WHEN B1_SETOR IN ('06','54','98') THEN 'Obitos' "             
cQuery+= "              WHEN B1_SETOR IN ('23') THEN 'D. Limpeza' "                    
cQuery+= "              WHEN B1_SETOR IN ('24','25') THEN 'D. Limpeza Rolo' "                                      
cQuery+= "              WHEN B1_SETOR IN ('26','27','28') THEN 'Brasileirinho'  "                   
cQuery+= "              WHEN B1_SETOR IN ('31','32') THEN 'Pacote' "
cQuery+= "              WHEN B1_SETOR IN ('33') THEN 'Rolo' "                 
cQuery+= "              ELSE 'Outros'  "
cQuery+= "         END   "
cQuery+= "ORDER BY LINHA,SUBLINHA  "       



If Select("TABX") > 0
	DbSelectArea("TABX")
	TABX->(DbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS 'TABX'                      

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetRegua(RecCount())

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

nTotKg:=0
nGeralKg:=0
TABX->(dbGoTop())
While TABX->(!EOF()) 
   
	  If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	     Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	     nLin := 8
	  Endif


   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
   //� Verifica o cancelamento pelo usuario...                             �
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
   //� Impressao do cabecalho do relatorio. . .                            �
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
   cLinha:=TABX->LINHA
   nTotKg:=0
   cnt:=0
   @nLin,00 PSAY cLinha

   Do While TABX->(!EOF()) .AND. TABX->LINHA==cLinha
   
	   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	      nLin := 8
	   Endif
	
	   // Coloque aqui a logica da impressao do seu programa...
	   // Utilize PSAY para saida na impressora. Por exemplo:

	   @nLin,20 PSAY TABX->SUBLINHA
	   @nLin,42 PSAY Transform(TABX->FATKG,"@E 999,999,999.99" )
  	   nTotKg+=TABX->FATKG
	   nGeralKg+=TABX->FATKG
	   cnt+=1
	   nLin := nLin + 1 // Avanca a linha de impressao
	   IncRegua()
	   TABX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	

   EndDo
       
       If cnt>1  // TOTAL POR LINHA . SO IMPRIME SE TIVER MAS DE UMA SUBLINHA 
	      @nLin,20 PSAY 'Total.:'
	      @nLin++,42 PSAY Transform( nTotKg,"@E 999,999,999.99" )
       endif
       nLin+=1   
       
EndDo
// TOTAL GERAL 
@nLin,20 PSAY 'Geral.:'
@nLin,42 PSAY Transform( nGeralKg,"@E 999,999,999.99" )



TABX->(DBCLOSEAREA())

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Finaliza a execucao do relatorio...                                 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SET DEVICE TO SCREEN

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Se impressao em disco, chama o gerenciador de impressao...          �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
