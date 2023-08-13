#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"     
#include "protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMKR013  º Autoria ³ Flávia Rocha      º Data ³  28/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio NFs Canceladas                                   º±±
±±º          ³ Solicitado no chamado:00000492-Daniela                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SAC                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*********************
User Function TMKR013
*********************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "NFs Canceladas por Período"
Local cPict         := ""
Local titulo        := "NOTAS FISCAIS CANCELADAS"
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
Private nomeprog    := "TMKR013" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "TMKR013" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString     := "SF2"
Private cPerg       := "TMKR013"
Private Cab         := "No.   NF         Cliente                                    Emissão   Representante   Coordenador      Dt.Cancel.  Hora   Motivo"
                      //9999 999999999  000000/00 - ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ  99/99/99  XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX  99/99/99    99:99  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                      //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
                      //          1         2         3         4         5         6         7         8		  9         100       110     120       130       140       150       160



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
titulo += " -> Periodo: " + DTOC(MV_PAR01) + " A " + DTOC(MV_PAR02)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  21/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Titulo,nLin)

Local cQuery := ''
Local LF     := CHR(13) + CHR(10)  
Private nQtaNF := 1

/*
SC9->C9_DTBLEST := dDataBase        //data
SC9->C9_HRBLEST := cTempo           //hora
SC9->C9_USRLBES := Substr(cUsuario, 7 , 15 ) //usuário
"Pedido  Cliente                                  Transportadora     Valor         Peso     Qtd.Volume"
*/              
cQuery := " select F2_CLIENTE,F2_LOJA, A1_NOME,Z75_DOC, Z75_EMISSA,Z75_DTCANC,Z75_HORA,Z75_JUSTCA,F2_VEND1,V1.A3_NREDUZ REPRES,S1.A3_NREDUZ SUPER " + LF
cQuery += " ,* FROM " + LF
cQuery += "   " + RetSqlname("Z75") + " ZZ " + LF
cQuery += " , " + RetSqlname("SF2") + " F2 " + LF
cQuery += " , " + RetSqlname("SA3") + " V1 " + LF  //ALIAS QUE TRAZ OS REPRESENTANTES
cQuery += " , " + RetSqlname("SA3") + " S1 " + LF  //ALIAS QUE TRAZ OS COORDENADORES RESPECTIVOS
cQuery += " , " + RetSqlname("SA1") + " A1 " + LF
cQuery += " WHERE " + LF

cQuery += " ZZ.Z75_DTCANC BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' " + LF


cQuery += " AND F2.F2_FILIAL = '" + xFilial("SF2") + "' " + LF
cQuery += " AND F2.F2_FILIAL = ZZ.Z75_FILIAL " + LF
cQuery += " AND ZZ.D_E_L_E_T_='' " + LF
cQuery += " AND F2.D_E_L_E_T_= '*' " + LF    //DELETADA PORQUE FOI CANCELADA
cQuery += " AND ZZ.Z75_DOC = F2.F2_DOC " + LF
cQuery += " AND V1.D_E_L_E_T_='' " + LF
cQuery += " AND S1.D_E_L_E_T_='' " + LF
cQuery += " AND ZZ.Z75_SERIE = F2.F2_SERIE " + LF
cQuery += " AND F2.F2_VEND1 = V1.A3_COD " + LF
cQuery += " AND V1.A3_SUPER = S1.A3_COD " + LF
cQuery += " AND F2.F2_CLIENTE = A1.A1_COD " + LF
cQuery += " AND F2.F2_LOJA = A1.A1_LOJA " + LF
cQuery += " ORDER BY F2.F2_DOC " + LF
MemoWrite("C:\TEMP\TMKR013.SQL", cQuery )
TCQUERY cQUery NEW ALIAS "CANC"
TCSetField( 'CANC', 'Z75_EMISSA', 'D' )
TCSetField( 'CANC', 'F2_EMISSAO', 'D' )
TCSetField( 'CANC', 'Z75_DTCANC', 'D' )

CANC->( dbGoTop() )
If !CANC->(EOF())
	While !CANC->(EOF())
	
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
	
	   If nLin > 55
	      nLin := Cabec(Titulo,"","",NomeProg,Tamanho,nTipo)+1
	      @nLin, 00 PSay Cab
	      nLin++
	      @nLin, 00 PSay Replicate("-",Limite)
	      nLin++      
	   Endif
	   
	//"No.   NF         Cliente                                    Emissão   Representante   Coordenador      Dt.Cancel.  Hora   Motivo"
	//9999 999999999  000000/00 - ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ  99/99/99  XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX  99/99/99    99:99  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//          1         2         3         4         5         6         7         8		  9         100       110       120       130       140       150       160
	
	
	   @nLin, 00 PSAY nQtaNF Picture "@E 9999"
	   @nLin, 05 PSAY CANC->F2_DOC
	   @nLin, 16 PSAY CANC->F2_CLIENTE+ "/" + CANC->F2_LOJA + " - "+SUBS(CANC->A1_NOME,1,30) 
	   @nLin, 60 PSAY DTOC(CANC->F2_EMISSAO)
	   @nLin, 70 PSAY CANC->REPRES
	   @nLin, 86 PSAY CANC->SUPER
	   @nLin, 103 PSAY DTOC(CANC->Z75_DTCANC) 
	   @nLin, 115 PSAY CANC->Z75_HORA
	   @nLin,122 PSAY CANC->Z75_JUSTCA
	   
	   	nLin ++
	   	nQtaNF++
	
	   	CANC->(dbSkip())
	
	EndDo


    

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a execucao do relatorio...                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If MV_PAR03 = 1
		Processa({|| geraArqExcel(titulo)},titulo,"Enviando dados ao Excel",.T.) 
	Endif
	
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
	
Else 
	MsgAlert("DADOS NÃO ENCONTRADOS...FAVOR REVER OS PARÂMETROS!")
Endif

Return


///gera em Excel
*************************************
Static function geraArqExcel(titulo) 
*************************************


Local adadosexcel     := {}
Local acabexcel     := {}
Local cNF 			:= "" 

DbselectArea("CANC")     
CANC->(dbgotop())               
nQtaNF := 1     
If !CANC->(eof())
     
	//aadd(adadosexcel,{Cabec1})
	Aadd(aCabexcel, {"NFS CANCELADAS"} )
	Aadd(aDadosexcel, { "No.   " ,;
						"NF    ",;
						"Cliente              ",;
						"Emissão  ",;
						"Representante     ",;
						"Coordenador       ",;
						"Dt.Cancel.   ",;
						"Hora   ",;
						"Motivo                      "} )
    While !CANC->(eof())
          
                                   
    	Incproc("Gerando EXCEL...: "+alltrim(CANC->F2_DOC))                              
      
       //nTam:= Len(Alltrim(PRVX->NF))
	   //cNF := PRVX->NF
       Aadd(aDadosexcel, { Str(nQtaNF) ,;
       CANC->F2_DOC,;
	   CANC->F2_CLIENTE+ "/" + CANC->F2_LOJA + " - "+SUBS(CANC->A1_NOME,1,30) ,;
	   DTOC(CANC->F2_EMISSAO),;
	   CANC->REPRES,;
	   CANC->SUPER,;
	   DTOC(CANC->Z75_DTCANC),;
	   CANC->Z75_HORA,;
	   CANC->Z75_JUSTCA } )
	   
	   nQtaNF++
	   CANC->(dbskip())
	Enddo
          
 	If !apoleclient("MSExcel")
		msgalert("Não foi possivel enviar os dados, Microsoft Excel não instalado!")
    Else
        dlgtoexcel({{"ARRAY",titulo, acabexcel , adadosexcel }})          
    Endif     
	DbSelectArea("CANC")
	DbCloseArea()
Endif                       

Return