#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"     
#include "protheus.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �COMR015  � Autoria � Fl�via Rocha      � Data �  21/08/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio STATUS DAS SOLICITA��ES COMPRA                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Faturamento                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*********************
User Function COMR015
*********************

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Status das SCs"
Local cPict         := ""
Local titulo        := "STATUS DAS SCs"
Local nLin          := 80

Local Cabec1        := ""
Local Cabec2        := ""
Local imprime       := .T.
Local aOrd          := {}

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "COMR015" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "COMR015" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString     := "SC1"
Private cPerg       := "COMR015"
Private Cab         := "SC     Status SC  Item  Produto          Descri��o                   QTD         Solict    Cota��o    Prc.Unit.    Total  Ped.Compra   Entrega  Comprador              Status PC"
                      //999999 BLOQUEADA  9999  XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXX 999,999.9999 XXXXXXXXXX  XXXXXX  999,999.9999  999,999.99 XXXXXX      99/99/99 XXXXXXXXXX XXXXXXXX
                      //012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
                      //          1         2         3         4         5         6         7         8		  9         100       110     120       130       140       150       160
                      //liberada
                      //bloqueada
                      //rejeitada
//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������
Pergunte(cPerg, .T.)
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

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

/*
SC9->C9_DTBLEST := dDataBase        //data
SC9->C9_HRBLEST := cTempo           //hora
SC9->C9_USRLBES := Substr(cUsuario, 7 , 15 ) //usu�rio
"Pedido  Cliente                                  Transportadora     Valor         Peso     Qtd.Volume"
*/              
cQuery := " select B1_DESC, C1_NUM, C1_APROV, C1_ITEM, C1_PRODUTO , B1_DESC , C1_QUANT , C1_SOLICIT, C1_COTACAO , C1_PEDIDO, C1_EMISSAO, C1_DATPRF " + LF
cQuery += " , C1_APROV, C1_SOLICIT " + LF + LF 

cQuery += " ,COTACAO = ( SELECT top 1 C8.C8_NUM FROM " + RetSqlName("SC8") + " C8 WHERE C8.C8_NUM = C1.C1_COTACAO " + LF 
cQuery += "             AND C8.C8_FILIAL = C1.C1_FILIAL " + LF
cQuery += "             AND C8.C8_PRODUTO = C1.C1_PRODUTO AND C8.C8_FILIAL = '" + xFilial("SC8") + "' AND C8.D_E_L_E_T_ = '' )" + LF + LF

cQuery += " ,C8PRECO = ( SELECT top 1 C8.C8_PRECO FROM " + RetSqlName("SC8") + " C8 WHERE C8.C8_NUM = C1.C1_COTACAO " + LF 
cQuery += "             AND C8.C8_FILIAL = C1.C1_FILIAL " + LF
cQuery += "             AND C8.C8_PRODUTO = C1.C1_PRODUTO AND C8.C8_FILIAL = '" + xFilial("SC8") + "' AND C8.D_E_L_E_T_ = '' )" + LF + LF

cQuery += " ,PEDIDO = ( SELECT top 1 C7.C7_NUM FROM " + RetSqlName("SC7") + " C7 WHERE C7.C7_NUM = C1.C1_PEDIDO " + LF 
cQuery += "             AND C7.C7_FILIAL = C1.C1_FILIAL " + LF
cQuery += "             AND C7.C7_PRODUTO = C1.C1_PRODUTO AND C7.C7_FILIAL = '" + xFilial("SC7") + "' AND C7.D_E_L_E_T_ = '' )" + LF + LF

cQuery += " ,COMPRADOR = ( SELECT top 1 C7.C7_USER FROM " + RetSqlName("SC7") + " C7 WHERE C7.C7_NUM = C1.C1_PEDIDO " + LF 
cQuery += "             AND C7.C7_FILIAL = C1.C1_FILIAL " + LF
cQuery += "             AND C7.C7_PRODUTO = C1.C1_PRODUTO AND C7.C7_FILIAL = '" + xFilial("SC7") + "' AND C7.D_E_L_E_T_ = '' )" + LF + LF

cQuery += " ,STATUSPC = ( SELECT top 1 C7.C7_CONAPRO FROM " + RetSqlName("SC7") + " C7 WHERE C7.C7_NUM = C1.C1_PEDIDO " + LF 
cQuery += "             AND C7.C7_FILIAL = C1.C1_FILIAL " + LF
cQuery += "             AND C7.C7_PRODUTO = C1.C1_PRODUTO AND C7.C7_FILIAL = '" + xFilial("SC7") + "' AND C7.D_E_L_E_T_ = '' )" + LF + LF

cQuery += " FROM " + LF
cQuery += " " + RetSqlName("SC1") + "  C1 " + LF
cQuery += " , " + RetSqlName("SB1") + "  B1 " + LF
cQuery += " WHERE " + LF
cQuery += " C1.C1_FILIAL = '" + xFilial("SC1") + "' " + LF
cQuery += " AND C1.C1_PRODUTO = B1.B1_COD " + LF
cQuery += " AND C1.D_E_L_E_T_ = '' " + LF
cQuery += " AND C1_EMISSAO >= '" + Dtos(MV_PAR01) + "' AND C1_EMISSAO <= '" + Dtos(MV_PAR02) + "' " + LF
cQuery += " AND C1.C1_NUM >= '" + Alltrim(MV_PAR03) + "' AND C1.C1_NUM <= '" + Alltrim(MV_PAR04) + "' " + LF
cQuery += " ORDER BY C1_NUM, C1_ITEM  " + LF
MemoWrite("C:\TEMP\COMR015.SQL", cQuery )

TCQUERY cQUery NEW ALIAS "C1X"
TCSetField( 'C1X', 'C1_EMISSAO', 'D' )
TCSetField( 'C1X', 'C1_DATPRF', 'D' )
C1X->( dbGoTop() )

While !C1X->(EOF())

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
   
//"SC     Status SC  Item  Produto          Descri��o            Qtde.        Solict.     Cota��o Prc.Unit      Total      Ped.Compra  Entrega  Comprador  Status PC"
//999999 BLOQUEADA  9999  XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXX 999,999.9999 XXXXXXXXXX  XXXXXX  999,999.9999  999,999.99 XXXXXX      99/99/99 XXXXXXXXXX XXXXXXXX
//012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//          1         2         3         4         5         6         7         8		  9         100       110     120       130       140       150       160

   cStatuSC := ""
   	If Alltrim(C1X->C1_APROV) = "B"
		cStatuSC := "BLOQUEADA"
	ElseIf Alltrim(C1X->C1_APROV) = "R"
		cStatuSC := "REJEITADA"
	ElseIf Alltrim(C1X->C1_APROV) = "L"
		cStatuSC := "LIBERADA"
	Endif       
	
	cStatuPC := ""
	If Alltrim(C1X->STATUSPC) = "B"
		cStatuPC := "BLOQUEADO"
	ElseIf Alltrim(C1X->STATUSPC) = "L"
		cStatuPC := "LIBERADO"
	Endif       
	

	@nLin,000 PSAY C1X->C1_NUM
   	@nLin,007 PSAY cStatuSC
   	@nLin,018 PSAY C1X->C1_ITEM 
    @nLin,024 PSAY C1X->C1_PRODUTO
    @nLin,041 PSAY SUBSTR(C1X->B1_DESC,1,20)
    @nLin,066 PSAY C1X->C1_QUANT Picture "@E 999,999.9999"
    @nLin,079 PSAY SUBSTR(C1X->C1_SOLICIT,1,15)
    @nLin,091 PSAY C1X->C1_COTACAO
    @nLin,099 PSAY C1X->C8PRECO Picture "@E  999,999.9999"
    @nLin,113 PSAY (C1X->C8PRECO * C1X->C1_QUANT) Picture "@E 999,999.99"
    @nLin,124 PSAY C1X->PEDIDO
    @nLin,136 PSAY Dtoc(C1X->C1_DATPRF)
    aUsu := {}
    cComprador := ""
    PswOrder(1)
	If PswSeek( C1X->COMPRADOR, .T. )											
	   aUsu   := PSWRET() 					
	   cComprador:= Alltrim( aUsu[1][2] )      
	   //eEmail := Alltrim( aUsu[1][14] )  ///e-mail do solicitante   
	Endif
    
    @nLin,145 PSAY cComprador
//    @nLin,159 PSAY cStatuPC
    @nLin,167 PSAY cStatuPC
   	nLin ++
 
   	C1X->(dbSkip())

EndDo

    

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������
//If MV_PAR03 = 1
	//Processa({|| geraArqExcel(titulo)},titulo,"Enviando dados ao Excel",.T.) 
//Endif

SET DEVICE TO SCREEN

//Processa({|| geraArqExcel(titulo)},titulo,"Enviando dados ao Excel",.T.) 
//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

//Processa({|| geraArqExcel(titulo)},titulo,"Enviando dados ao Excel",.T.) 

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