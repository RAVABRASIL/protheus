#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"
#include "topconn.ch"
#include "Ap5Mail.ch"

User Function PCPR028()

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio Produ��o Por Linha"
Local cPict          := ""
Local titulo         :=" " //"Relatorio Produ��o Por Linha da data" +  mv_par01 + " at� " + mv_par02
Local nLin           := 80


Local Cabec1       := "       C�digo    |      Descri��o                                |   Consumo     |  "
Local Cabec2       := "                 |                                               |               |  "
Local imprime      := .T.
Local aOrd := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt      := ""
Private limite     := 80
Private tamanho    := "P"
Private nomeprog   := "PCPR028" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "PCPR028" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

Private cTURNO1   := GetMv("MV_TURNO1")
Private cTURNO2   := GetMv("MV_TURNO2")
Private cTURNO3   := GetMv("MV_TURNO3")



hora1:=Left(cTURNO1,5)
hora2:=Left(cTURNO2,5)
hora3:=Left(cTURNO3,5)


//dbSelectArea("")
//dbSetOrder(1)

Pergunte("PCPR028",.F.)
//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"PCPR028",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

titulo         := "Percentual Reciclado de " +  dtoc(mv_par01) + " � " + dtoc(mv_par02)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  16/07/13   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cQuery := ''
LOCAL nTOTAL := 0
//Local cCabe1 := "       Linha     |     C�digo      |   Peso   |        Percentual          |"
//Local cCabe2 := "                 |                 |          |                            |"
//Titulo := "Relat�rio Mensal"

//SIM=1 NAO=2 - Pergunta no par�metro MV_PAR05(Recuperado Rava? Produtos do natal�cio)
//
IF MV_PAR05 == 2 
	cQuery := "SELECT D3_FILIAL, D3_COD, B1_DESC, SUM(D3_QUANT) AS 'CONSUMO' FROM SD3020 D3, SB1010 B1 " 
	cQuery += "WHERE D3.D3_COD = B1.B1_COD AND "
	cQuery += "D3_EMISSAO BETWEEN '" + Dtos( mv_par01 )+ "' AND '"+ Dtos( mv_par02 ) +"' "
	cQuery += "AND D3_LOCAL = '" +  xFilial("SD3")  + "' AND D3.D_E_L_E_T_ = '' AND D3_TM >= '500' AND D3_FILIAL = '01' " 
	cQuery += "AND B1_DESC LIKE '%RECICLAD%' AND B1_ATIVO <> 'N' "
	cQuery += "GROUP BY D3_COD, D3_FILIAL, B1_DESC "
	cQuery += "ORDER BY D3_COD "
ELSEIF MV_PAR05 == 1
	cQuery := "SELECT D3_FILIAL, D3_COD, B1_DESC, SUM(D3_QUANT) AS 'CONSUMO' FROM SD3020 D3, SB1010 B1 " 
	cQuery += "WHERE D3.D3_COD = B1.B1_COD AND "
	cQuery += "D3_EMISSAO BETWEEN '" + Dtos( mv_par01 )+ "' AND '"+ Dtos( mv_par02 ) +"' "
	cQuery += "AND D3_LOCAL = '" +  xFilial("SD3")  + "' AND D3.D_E_L_E_T_ = '' AND D3_TM >= '500' AND D3_FILIAL = '01' " 
	cQuery += "AND B1_COD IN ('MP0796','MP0795') AND B1_ATIVO <> 'N' "
	cQuery += "GROUP BY D3_COD, D3_FILIAL, B1_DESC "
	cQuery += "ORDER BY D3_COD "
ENDIF

//dbSelectArea(cString)
//dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

//SetRegua(RecCount())
  SetRegua(0)

//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������

//dbGoTop()
//While !EOF()

TCQUERY cQuery NEW ALIAS "TMP"

TMP->(DbGoTop())

IF TMP->(EOF())

If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9
Endif

@nLin,08 PSAY "VOLUME PRODUZIDO"
	nLin++
	nLin++
	nInsti := fVolume(1) //Institucional
	nGeral := fVolume(2) //Extrusora
	
	//SE PARAMETRO RECUPERADO FOR IGUAL A SIM ENT�O TRAZ AS INFOR DO N�O INSTITUCIONAL
	//SE PARAMETRO RECUPERADO FOR IGUAL A N�O ENT�O TRAZ A LINHA INSTITU
	IF MV_PAR05 == 1
		//@nLin,08 PSAY "Linha Institucional ->" + transform(nInsti, '@E 999,999,999.99') + "Kg"
		@nLin,08 PSAY "Linha N�o Instituci ->" + transform((nGeral - nInsti), '@E 999,999,999.99') + "Kg"
		nLin++
		@nLin,08 PSAY "Produ��o Extrus�o   ->" + transform(nGeral, '@E 999,999,999.99') + "Kg
	ELSE
		@nLin,08 PSAY "Linha Institucional ->" + transform(nInsti, '@E 999,999,999.99') + "Kg"
		nLin++
		@nLin,08 PSAY "Produ��o Extrus�o   ->" + transform(nGeral, '@E 999,999,999.99') +  "Kg"
	ENDIF
	
	
	//AQUI TRAZEMOS OS PERCENTUAL DA MESMA FORMA.
	//PARAMETRO RECUPERADO IGUAL A N�O ELE TRAZ A LINHA INSTITUCIONAL+GERAL
	//PARAMETRO RECUPERADO IGUAL A SIM ELE TRAZ AS INFORMA��ES DO N�O INSTITUCIONAL
	nLin++
	nLin++
	IF MV_PAR05 <> 1
		@nLin,08 PSAY "Perce Linha Institucional->" + transform(nTotal/(nGeral - nInsti)*100, '@E 999.99') + " %"
	else
		@nLin,08 PSAY "Perce Linha N�o Instituci->" + transform(1/nInsti*100, '@E 999.99') + " %"
	ENDIF
	nLin++
	@nLin,08 PSAY "Perce Produ��o Extrus�o  ->" + transform(1/nGeral*100, '@E 999.99')  + " %"
	nLin++
	nLin++
	@nLin,08 PSAY "Saldo Inicial do M�s     ->" + transform(MV_PAR04, '@E 999,999,999.99')
	
	nLin+= 9
	
	if !EMPTY(MV_PAR03)
		@nLin,08 PSAY "Estoque em Processo:    " + transform(MV_PAR03, '@E 999,999,999.99') + "Kg"
	else
		@nLin,08 PSAY "N�o Foi Considerada Nenhuma Quantidade em Processo"
	ENDIF

ENDIF
 
While TMP->(!EOF())

   //���������������������������������������������������������������������Ŀ
   //� Verifica o cancelamento pelo usuario...                             �
   //�����������������������������������������������������������������������

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������

   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:

// Grupo
   
/* 0004	Eletronicos                   		
   0005	Pneumaticos                   		
   0007	Produto de Venda              		
   0008	OUTROS                        		
   0010	DESPESAS GERAIS               		
   0011	MATERIA PRIMA                 		
   0012	SERVICOS E MANUTENCAO         		
   0013	LOGISTICA                     		
   A	INSTITUCIONAL A GRANEL        		
   B	ABNT A GRANEL                 		
   C	HOSPITALAR                    		
   D	DONA LIMPEZA                  		
   E	BRASILEIRINHO                 		
   F	ALIMENTICIO                   		
   G	SACOLA LISA                   		
   H	SACOLA IMPRESSA               		
   I	SACO IMPRESSO                 		
   J	PIA                           		
   K	BOBINA                        		
   L	REVENDA                       		
   ME  	MATERIAL PARA EMBALAGEM  */     		
   
   @nLin,08 PSAY TMP->D3_COD 
   @nLin,21 PSAY TMP->B1_DESC
   @nLin,65 PSAY  transform(TMP->CONSUMO, "@E 999,999,999.99") 
    
   nTOTAL += TMP->CONSUMO
     
   nLin := nLin + 1 

incregua()

   TMP->(DbSkip()) 
EndDo

	nTotal := nTotal + MV_PAR04

	if !EMPTY(MV_PAR03)
		nTotal := (nTotal - MV_PAR03)
	ENDIF 
    
    nLin++
    nLin++
	@nLin,08 PSAY "VOLUME PRODUZIDO"
	nLin++
	nLin++
	nInsti := fVolume(1) //Institucional
	nGeral := fVolume(2) //Extrusora
	
	//SE PARAMETRO RECUPERADO FOR IGUAL A SIM ENT�O TRAZ AS INFOR DO N�O INSTITUCIONAL
	//SE PARAMETRO RECUPERADO FOR IGUAL A N�O ENT�O TRAZ A LINHA INSTITU
	IF MV_PAR05 == 1
		//@nLin,08 PSAY "Linha Institucional ->" + transform(nInsti, '@E 999,999,999.99') + "Kg"
		@nLin,08 PSAY "Linha N�o Instituci ->" + transform((nGeral - nInsti), '@E 999,999,999.99') + "Kg"
		nLin++
		@nLin,08 PSAY "Produ��o Extrus�o   ->" + transform(nGeral, '@E 999,999,999.99') + "Kg
	ELSE
		@nLin,08 PSAY "Linha Institucional ->" + transform(nInsti, '@E 999,999,999.99') + "Kg"
		nLin++
		@nLin,08 PSAY "Produ��o Extrus�o   ->" + transform(nGeral, '@E 999,999,999.99') +  "Kg"
	ENDIF
	
	
	//AQUI TRAZEMOS OS PERCENTUAL DA MESMA FORMA.
	//PARAMETRO RECUPERADO IGUAL A N�O ELE TRAZ A LINHA INSTITUCIONAL+GERAL
	//PARAMETRO RECUPERADO IGUAL A SIM ELE TRAZ AS INFORMA��ES DO N�O INSTITUCIONAL
	nLin++
	nLin++
	IF MV_PAR05 <> 1
		@nLin,08 PSAY "Perce Linha Institucional->" + transform(nTotal/nInsti*100, '@E 999.99') + " %"		
	else
		@nLin,08 PSAY "Perce Linha N�o Instituci->" + transform(nTotal/(nGeral - nInsti)*100, '@E 999.99') + " %"
	ENDIF
	nLin++
	@nLin,08 PSAY "Perce Produ��o Extrus�o  ->" + transform(nTotal/nGeral*100, '@E 999.99')  + " %"
	nLin++
	nLin++
	@nLin,08 PSAY "Saldo Inicial do M�s     ->" + transform(MV_PAR04, '@E 999,999,999.99')
	
	nLin+= 9
	
	if !EMPTY(MV_PAR03)
		@nLin,08 PSAY "Foi Considerada a Seguinte Quantidade em Processo:    " + transform(MV_PAR03, '@E 999,999,999.99') + "Kg"
		nLin++
		nLin++
    	@nLin,08 PSAY "Consumo do Per�odo ---------------------------------->" + transform(nTOTAL, "@E 999,999,999.99") + "Kg"
	else
		@nLin,08 PSAY "N�o Foi Considerada Nenhuma Quantidade em Processo"
	ENDIF
		
//@nLin+1,48 PSAY "TOTAL ->"
//@nLin+1,58 PSAY transform((nTOTAL), "@E 999,999,999.99") 

TMP->(DbCloseArea())
//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return


Static function fVolume(nTipo)

Local cQueryA := ''
Local nRet := 0

IF MV_PAR05 == 2

cQueryA := "SELECT ISNULL ( SUM(Z00.Z00_PESO+Z00_PESCAP),0) AS PESO " 
cQueryA += "FROM Z00020 Z00 WITH (NOLOCK) " 
cQueryA += ",SC2020 SC2 WITH (NOLOCK) " 
cQueryA += ",SB1010 SB1 WITH (NOLOCK) " 
cQueryA += "WHERE Z00_FILIAL= ' ' AND Z00.Z00_DATHOR BETWEEN '" + Dtos( mv_par06 )+ "05:20' AND '"  + Dtos( mv_par07 + 1)+ "05:19' " 
IF nTipo = 1
	cQueryA += "AND B1_GRUPO IN('A','B','G') "
	cQueryA += "AND SUBSTRING(Z00.Z00_MAQ,1,2) IN ('C0','C1','P0','S0' ) "
ELSEIF nTipo = 2	
	cQueryA += "AND SUBSTRING(Z00.Z00_MAQ,1,2) IN ('E0','E1') " 
EndIf
cQueryA += "AND Z00.Z00_APARA = ' ' AND Z00.D_E_L_E_T_ = ' ' " 
cQueryA += "AND Z00_OP=C2_NUM+C2_ITEM+C2_SEQUEN " 
cQueryA += "AND C2_PRODUTO=B1_COD " 
cQueryA += "AND SC2.D_E_L_E_T_ = ' ' " 
cQueryA += "AND SB1.D_E_L_E_T_ = ' ' " 

ELSEIF MV_PAR05 == 1

cQueryA := "SELECT ISNULL ( SUM(Z00.Z00_PESO+Z00_PESCAP),0) AS PESO " 
cQueryA += "FROM Z00020 Z00 WITH (NOLOCK) " 
cQueryA += ",SC2020 SC2 WITH (NOLOCK) " 
cQueryA += ",SB1010 SB1 WITH (NOLOCK) " 
//cQueryA += "WHERE Z00_FILIAL= ' ' AND Z00.Z00_DATHOR BETWEEN '" + Dtos( mv_par06 )+ "05:20' AND '"  + Dtos( mv_par07 + 1)+ "05:19' " 
cQueryA += "WHERE Z00_FILIAL= ' ' AND Z00.Z00_DATHOR >= '" + Dtos( mv_par06 )+hoara1+"' AND Z00.Z00_DATHOR < '" + Dtos( mv_par07+1 )+hoara1+"' " 

IF nTipo = 1
	cQueryA += "AND B1_GRUPO NOT IN('A','B','G') "
	cQueryA += "AND SUBSTRING(Z00.Z00_MAQ,1,2) IN ('C0','C1','P0','S0' ) "
ELSEIF nTipo = 2	
	cQueryA += "AND SUBSTRING(Z00.Z00_MAQ,1,2) IN ('E0','E1') " 
EndIf
cQueryA += "AND Z00.Z00_APARA = ' ' AND Z00.D_E_L_E_T_ = ' ' " 
cQueryA += "AND Z00_OP=C2_NUM+C2_ITEM+C2_SEQUEN " 
cQueryA += "AND C2_PRODUTO=B1_COD " 
cQueryA += "AND SC2.D_E_L_E_T_ = ' ' " 
cQueryA += "AND SB1.D_E_L_E_T_ = ' ' " 

ENDIF

TCQUERY cQueryA NEW ALIAS "TMX"

if TMX->(!EOF())

    nRet :=TMX->PESO

ENDIF

TMX->(DbCloseArea())

Return nRet
