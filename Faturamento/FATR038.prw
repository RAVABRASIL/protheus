#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"     
#include "protheus.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FATR038  � Autoria � Fl�via Rocha      � Data �  21/08/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio Monitor SAC                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Faturamento                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*********************
User Function FATR038
*********************

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Pedidos com libera��o de Credito e Estoque"
Local cPict         := ""
Local titulo        := "Monitor SAC - NFs Sem Chegada Confirmada"
Local nLin          := 80

Local Cabec1        := ""
Local Cabec2        := ""
Local imprime       := .T.
Local aOrd          := {}

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 130
Private tamanho     := "M"
Private nomeprog    := "FATR038" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "FATR038" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString     := "SF2"
Private cPerg       := "FATR038"
Private Cab         := "No.   NF         Cliente                                     Transportadora   Expedida  Prev.Cheg  Dias    Localidade"
                      //9999 999999999  000000/00 - ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ  XXXXXXXXXXXXXXX  99/99/99  99/99/99   99999   XXXXXXXXXXXXXXXXXXXXXXXXX
                      //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
                      //          1         2         3         4         5         6         7         8		  9         100       110



//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������
//Pergunte(cPerg, .T.)
wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

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

RptStatus({|| RunReport(Titulo,nLin) },Titulo)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  21/06/07   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Titulo,nLin)

Local cQuery := ''
Local LF     := CHR(13) + CHR(10)  
Private nQtaNF := 1

/*
SC9->C9_DTBLEST := dDataBase        //data
SC9->C9_HRBLEST := cTempo           //hora
SC9->C9_USRLBES := Substr(cUsuario, 7 , 15 ) //usu�rio
"Pedido  Cliente                                  Transportadora     Valor         Peso     Qtd.Volume"
*/              
cQuery := " select DISTINCT F2_DOC NF, A1_COD CODCLI, A1_LOJA LOJACLI, A1_NOME AS CLIENTE, F2_DTEXP EXPEDIDA, F2_PREVCHG PREVISAO, F2_REALCHG CHEGADA, F2_TRANSP, A4_NREDUZ TRANSPORTADORA " + LF
cQuery += " ,DIAS = CAST(CAST( GETDATE() AS DATETIME) - CAST(F2_PREVCHG AS DATETIME)AS INTEGER) " + LF
cQuery += " ,ZZ_DESC LOCALIDADE " + LF
cQuery += " FROM " + LF
cQuery += " " + RetSqlName("SF2") + "  F2 " + LF
cQuery += ", "+ RetSqlName("SA4") + "  A4 " + LF
cQuery += ", "+ RetSqlName("SA1") + "  A1 " + LF
cQuery += ", "+ RetSqlName("SZZ") + "  ZZ " + LF
cQuery += " WHERE " + LF
cQuery += " F2_FILIAL = '" + xFilial("SF2") + "' " + LF
cQuery += " AND F2_TRANSP = A4_COD " + LF
cQuery += " AND F2_LOCALIZ = ZZ_LOCAL " + LF
cQuery += " AND F2_CLIENTE = A1_COD " + LF
cQuery += " AND F2_LOJA = A1_LOJA " + LF
cQuery += " AND F2.D_E_L_E_T_ = '' " + LF
cQuery += " AND A4.D_E_L_E_T_ = '' " + LF
cQuery += " AND F2_DTEXP <> '' " + LF
cQuery += " AND F2_REALCHG = '' " + LF
cQuery += " AND F2_PREVCHG >= '20130101' AND F2_PREVCHG <= '" + Dtos(dDatabase - 2) + "' " + LF
cQuery += " AND F2_PREVCHG <> '' " + LF
cQuery += " AND F2_TRANSP <> '024' " + LF
cQuery += " ORDER BY F2_DOC " + LF
MemoWrite("C:\TEMP\FATR038.SQL", cQuery )
TCQUERY cQUery NEW ALIAS "PRVX"
TCSetField( 'PRVX', 'PREVISAO', 'D' )
TCSetField( 'PRVX', 'EXPEDIDA', 'D' )
PRVX->( dbGoTop() )

While !PRVX->(EOF())

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

   If nLin > 55
      nLin := Cabec(Titulo,"","",NomeProg,Tamanho,nTipo)+1
      @nLin, 00 PSay Cab
      nLin++
      @nLin, 00 PSay Replicate("-",Limite)
      nLin++      
   Endif

   @nLin, 00 PSAY nQtaNF Picture "@E 9999"
   @nLin, 06 PSAY PRVX->NF
   @nLin, 16 PSAY PRVX->CODCLI+ "/" + PRVX->LOJACLI + " - "+SUBS(PRVX->CLIENTE,1,30) 
   @nLin, 63 PSAY SUBSTR(PRVX->TRANSPORTADORA,1,20)
   @nLin, 86 PSAY DTOC(PRVX->EXPEDIDA)
   @nLin, 96 PSAY DTOC(PRVX->PREVISAO)
   @nLin, 107 PSAY Transform(PRVX->DIAS, "@E 9999") 
   @nLin, 115 PSAY PRVX->LOCALIDADE
   
   	nLin ++
   	nQtaNF++

   	PRVX->(dbSkip())

EndDo

    

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������
//If MV_PAR03 = 1
	//Processa({|| geraArqExcel(titulo)},titulo,"Enviando dados ao Excel",.T.) 
//Endif

SET DEVICE TO SCREEN

Processa({|| geraArqExcel(titulo)},titulo,"Enviando dados ao Excel",.T.) 
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


///gera em Excel
*************************************
Static function geraArqExcel(titulo) 
*************************************


Local adadosexcel     := {}
Local acabexcel     := {}
Local cNF 			:= "" 

DbselectArea("PRVX")     
PRVX->(dbgotop())               
nQtaNF := 1     
If !PRVX->(eof())
     
	//aadd(adadosexcel,{Cabec1})
	Aadd(aCabexcel, {"MONITOR SAC"} )
	Aadd(aDadosexcel, { "Nro.    ",;
						"NF       ",;
						"Cod.Cliente  ",;
	                    "Cliente                       ",;
	                    "Transportadora  ",;
	                    "Expedida ",;
	                    "Prev.Cheg ",;
	                    "Dias  ",;
	                    "Localidade           "} )
    While !PRVX->(eof())
          
                                   
    	Incproc("Gerando EXCEL...: "+alltrim(PRVX->NF))                              
      
       //nTam:= Len(Alltrim(PRVX->NF))
	   //cNF := PRVX->NF
       Aadd(aDadosexcel, { Str(nQtaNF) ,;
       PRVX->NF,;
       (PRVX->CODCLI + '/' + PRVX->LOJACLI),;
	   PRVX->CLIENTE,;
	   PRVX->TRANSPORTADORA,;
	   DTOC(PRVX->EXPEDIDA),;
	   DTOC(PRVX->PREVISAO),;
	   Transform(PRVX->DIAS, "@E 9999"),;
	   PRVX->LOCALIDADE } )
	   
	   nQtaNF++
	   PRVX->(dbskip())
	Enddo
          
 	If !apoleclient("MSExcel")
		msgalert("N�o foi possivel enviar os dados, Microsoft Excel n�o instalado!")
    Else
        dlgtoexcel({{"ARRAY",titulo, acabexcel , adadosexcel }})          
    Endif     
	DbSelectArea("PRVX")
	DbCloseArea()
Endif                       

Return