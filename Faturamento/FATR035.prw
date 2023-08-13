#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch" 
#include "TbiConn.ch"
#include "PROTHEUS.CH"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATR035  º Autor ³ Flávia Rocha        º Data ³  16/11/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Pedidos REJEITADOS no Crédito.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATR035()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Pedidos REJEITADOS no CREDITO"
Local cPict         := ""
Local titulo        := "Pedidos REJEITADOS no CRÉDITO"
Local nLin          := 80

Local Cabec1        := ""
Local Cabec2        := ""
Local imprime       := .T.
Local aOrd          := {}

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 90
Private tamanho     := "M"
Private nomeprog    := "FATR035" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "FATR035" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString     := "SC9"
Private cPerg       := "FATR034"

//Private Cab         := "Pedido  Dt.Program  Cliente                                  Dias             Valor"
                      //999999    99/99/99  000000 - ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ  9999
                      //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
                      //          1         2         3         4         5         6         7         8			9
                      
Private Cab         := "Pedido  Dt.Program  Cliente                                                         Valor"
                      //999999    99/99/99  000000 - ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ  99/99/99
                      //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
                      //          1         2         3         4         5         6         7         8			9
                      



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)               // Pergunta no SX1
//wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

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
Local aAntec := {}
Local total  := 0  
Local LF     := CHR(13) + CHR(10)

cQuery := "SELECT C9_FILIAL, C9_PEDIDO ,C5_ENTREG, C5_CONDPAG, A1_COD, A1_NOME, C9_BLCRED, sum( C9_QTDLIB * C9_PRCVEN ) TOTAL " + LF
cQuery += " , C9_DATALIB " + LF
cQuery += "FROM "+RetSqlName("SC9")+" SC9 " + LF
cQuery += " , "+RetSqlName("SA1")+" SA1 " + LF
cQuery += " , "+RetSqlName("SC5")+" SC5 " + LF
cQuery += " , "+RetSqlName("SA3")+" SA3 " + LF
cQuery += " WHERE " + LF //C9_FILIAL = '"+xFilial("SC9")+"' " + LF
cQuery += " C9_BLCRED = '09'  " + LF  //REJEITADO CRÉDITO
If !Empty(MV_PAR01)
	cQuery += " and SC9.C9_DATALIB >= '" + Dtos(MV_PAR01) + "' " + LF  //somente os liberados EM DATABASE - 120
Else
	cQuery += " and SC9.C9_DATALIB >= '" + Dtos(dDatabase - 120) + "' " + LF  //somente os liberados EM DATABASE - 120
Endif

If !Empty(MV_PAR02)
	cQuery += " and SC9.C9_DATALIB <= '" + Dtos(MV_PAR02) + "' " + LF  //somente os liberados EM DATABASE - 120
Endif

cQuery += " and SC9.C9_NFISCAL = '' " + LF
cQuery += " AND A1_COD+A1_LOJA = C9_CLIENTE+C9_LOJA " + LF
cQuery += " AND C5_FILIAL = C9_FILIAL " + LF
cQuery += " AND C5_NUM = C9_PEDIDO " + LF
cQuery += " AND C5_VEND1 = A3_COD " + LF
cQuery += " AND SC9.D_E_L_E_T_ = '' " + LF
cQuery += " AND SA1.D_E_L_E_T_ = '' " + LF
cQuery += " AND SC5.D_E_L_E_T_ = '' " + LF
cQuery += " AND SA3.A3_SUPER IN ('0315', '0316' , '0320' ) " + LF //só coordenadores associados a Flavia Viana

cQuery += "GROUP BY C9_FILIAL, C9_PEDIDO, C5_ENTREG, C5_CONDPAG, A1_COD, A1_NOME, C9_BLCRED, C9_DATALIB " + LF
cQuery += " ORDER BY C9_FILIAL, C5_ENTREG, C9_PEDIDO " + LF
MemoWrite("C:\TEMP\FATR035.SQL", cQuery)
TCQUERY cQUery NEW ALIAS "PEDX"
TCSetField( 'PEDX', 'C5_ENTREG', 'D' )
TCSetField( 'PEDX', 'C9_DATALIB', 'D' )
PEDX->( dbGoTop() )

While !PEDX->(EOF())

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
   if PEDX->C5_CONDPAG = '001'
      Aadd( aAntec, {PEDX->C9_PEDIDO,PEDX->C5_ENTREG,PEDX->C5_CONDPAG,PEDX->A1_COD,PEDX->A1_NOME,PEDX->C9_BLCRED, PEDX->C9_DATALIB, PEDX->TOTAL } )
   endif   

   If nLin > 55
      nLin := Cabec(Titulo,"","",NomeProg,Tamanho,nTipo)+1
      @nLin, 00 PSay Cab
      nLin++
      @nLin, 00 PSay Replicate("-",Limite)
      nLin++      
   Endif

   @nLin, 00 PSAY PEDX->C9_PEDIDO
   @nLin, 08 PSAY DTOC( PEDX->C5_ENTREG )
   @nLin, 20 PSAY PEDX->A1_COD+" - "+SUBS(PEDX->A1_NOME,1,30)
   //@nLin, 61 PSAY PEDX->C9_BLCRED 
   //@nLin, 64 PSAY iif( PEDX->C9_BLCRED = '09', 'REJEIT. CREDITO', Transform( dDataBase - PEDX->C5_ENTREG, "@E 9999" ) )
   //@nLin,061 PSAY DTOC(PEDX->C9_DATALIB)   
   @nLin,077 PSAY Transform(PEDX->TOTAL, "@E 9,999,999.99")
	total += PEDX->TOTAL

   nLin ++

   PEDX->(dbSkip())
EndDo

PEDX->(DbCloseArea())
     
nLin++
@nLin, 70 PSAY "Total: " + Transform( total, "@E 99,999,999.99")

nLin++
@nLin, 00 PSAY Replicate("-",Limite)
nLin++
@nLin, 00 PSAY PadC("Pedidos Antecipados", limite)
nLin++
@nLin, 00 PSAY Replicate("-",Limite)
nLin++
@nLin, 00 PSAY Cab
nLin++
@nLin, 00 PSAY Replicate("-",Limite)
nLin++
nLin++

for nX := 1 to len( aAntec )
   if nLin > 55
      nLin := Cabec(Titulo,"","",NomeProg,Tamanho,nTipo)
      @nLin, 00 PSay Cab
      nLin++
      @nLin, 00 PSay Replicate("-",Limite)
      nLin++      
   endif

   @nLin, 00 PSAY aAntec[nX,1]
   @nLin, 08 PSAY DTOC( aAntec[nX,2] )
   @nLin, 20 PSAY aAntec[nX,4]+" - "+SUBS(aAntec[nX,5],1,30)
   //@nLin, 61 PSAY aAntec[nX,6]		//PEDX->C9_BLCRED 
   //@nLin, 61 PSAY DTOC( aAntec[nX,7] )		//PEDX->C9_BLCRED 
   //@nLin, 64 PSAY iif( aAntec[nX,6] = '09', 'REJEIT. CREDITO', Transform( dDataBase - aAntec[nX,2], "@E 9999" ) )
	@nLin,077 PSAY Transform( aAntec[nX,8], "@E 9,999,999.99")
   nLin++
next nX


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Roda( 0, "", TAMANHO )
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

//ENVIA HTML POR EMAIL 
****************************
User Function FATR035X()    
****************************

Local cQuery := ''
Local aAntec := {}
Local total  := 0  
Local LF     := CHR(13) + CHR(10)
Local aDados1 := {}
Local aDados2 := {}
Local x       := 0
Local cVend   := ""
Local cNomeVend:= ""
Local cVendMail := ""
Local cSupMail  := ""
Local cSuper    := ""
Local cNomeSuper:= ""
Local eEmail    := ""
Local subj		:= ""
Local nTotHtm1  := 0
Local nTotHtm2  := 0 
Local cEmpresa  := ""

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"
  cEmpresa := "Rava Emb"
  fExecuta(cEmpresa)
  Reset Environment
  
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03"
  cEmpresa := "Rava Caixas"
  fExecuta(cEmpresa)  
  Reset Environment
  
Endif

Return

************************************
Static Function fExecuta(cEmpresa)  
************************************

Local cQuery := ''
Local aAntec := {}
Local total  := 0  
Local LF     := CHR(13) + CHR(10)
Local aDados1 := {}
Local aDados2 := {}
Local x       := 0
Local cVend   := ""
Local cNomeVend:= ""
Local cVendMail := ""
Local cSupMail  := ""
Local cSuper    := ""
Local cNomeSuper:= ""
Local eEmail    := ""
Local subj		:= ""
Local nTotHtm1  := 0
Local nTotHtm2  := 0 



	cQuery := "SELECT C9_PEDIDO ,C5_ENTREG, C5_CONDPAG, A1_COD, A1_NOME, C9_BLCRED, sum( C9_QTDLIB * C9_PRCVEN ) TOTAL " + LF
	cQuery += " , C9_DATALIB " + LF
	cQuery += " , A3_COD, A3_EMAIL, A3_SUPER " + LF
	
	cQuery += "FROM "+RetSqlName("SC9")+" SC9 " + LF
	cQuery += " , "+RetSqlName("SA1")+" SA1 " + LF
	cQuery += " , "+RetSqlName("SC5")+" SC5 " + LF
	cQuery += " , "+RetSqlName("SA3")+" SA3 " + LF 
	
	cQuery += " WHERE C9_FILIAL = '"+xFilial("SC9")+"' " + LF
	cQuery += " and SC9.C9_NFISCAL = '' " + LF
	cQuery += " AND C5_FILIAL = C9_FILIAL " + LF
	cQuery += " AND C9_BLCRED = '09'  " + LF  //REJEITADO CRÉDITO
	
	cQuery += " and SC9.C9_DATALIB >= '" + Dtos(dDatabase - 20) + "' " + LF  //somente os liberados EM DATABASE - 20
	
	cQuery += " AND A1_COD+A1_LOJA = C9_CLIENTE+C9_LOJA " + LF
	cQuery += " AND C5_FILIAL = C9_FILIAL
	cQuery += " AND C5_NUM = C9_PEDIDO " + LF
	cQuery += " AND C5_VEND1 = A3_COD " + LF
	cQuery += " AND SC9.D_E_L_E_T_ = '' " + LF
	cQuery += " AND SA1.D_E_L_E_T_ = '' " + LF
	cQuery += " AND SC5.D_E_L_E_T_ = '' " + LF
	cQuery += " AND SA3.D_E_L_E_T_ = '' " + LF
	
	cQuery += " AND SA3.A3_SUPER IN ('0315', '0316' , '0320' ) " + LF //só coordenadores associados a Flavia Viana
	//cQuery += " AND SA3.A3_COD IN ('0331' ) " + LF //só coordenadores associados a Flavia Viana
	//cQuery += " AND SA3.A3_SUPER IN ('0316' ) " + LF //só coordenadores associados a Flavia Viana
	cQuery += " GROUP BY C9_PEDIDO ,C5_ENTREG, C5_CONDPAG, A1_COD, A1_NOME, C9_BLCRED " + LF
	cQuery += " , C9_DATALIB " + LF
	cQuery += " , A3_COD, A3_EMAIL, A3_SUPER " + LF
	cQuery += " ORDER BY A3_SUPER, A3_COD, C5_ENTREG, C5_CONDPAG " + LF
	MemoWrite("C:\TEMP\FATR035X.SQL", cQuery)
	
	TCQUERY cQUery NEW ALIAS "PEDX"
	TCSetField( 'PEDX', 'C5_ENTREG', 'D' )
	TCSetField( 'PEDX', 'C9_DATALIB', 'D' )
	PEDX->( dbGoTop() )
	
	While !PEDX->(EOF())
	
	  Aadd( aDados1, {PEDX->C9_PEDIDO,;  //1
	                  PEDX->C5_ENTREG,;  //2
                      PEDX->A1_COD,;     //3
                      PEDX->A1_NOME,;    //4
                      PEDX->C9_DATALIB,; //5
                      PEDX->TOTAL,;      //6
                      PEDX->A3_COD,;     //7
                      PEDX->A3_EMAIL,;   //8
                      PEDX->A3_SUPER,;   //9
                      PEDX->C5_CONDPAG } ) //10
	  PEDX->(dbSkip())
	EndDo
	PEDX->(DbCloseArea())



	nTotHtm1 := 0
	nTotHtm2 := 0
	lEnvia   := .F.
	cVend    := ""
	y        := 0
	
	oProcess:=TWFProcess():New("FATR035","FATR035")
	oProcess:NewTask('Inicio',"\workflow\http\oficial\FATR035.htm")
	oHtml   := oProcess:oHtml

	If Len(aDados1) > 0
		//aDados1 := Asort( aDados1,,, { |X,Y| X[9] + X[7] + DTOC(X[2]) + X[10]  <  Y[9] + Y[7] + DTOC(Y[2]) + Y[10]  } )    //por VENDEDOR + COND PAG
		x := 1
		For x := 1 to Len(aDados1)
					
			If x = 1
				cVend     := aDados1[x,7]
				cVendMail := Lower(aDados1[x,8])
				SA3->(DBSETORDER(1))
				If SA3->(DBSEEK(xFilial("SA3") + cVend )) 
					cNomeVend := SA3->A3_NOME
				Endif
				cSuper    := aDados1[x,9] 
				
				cSupMail  := ""
				SA3->(DBSETORDER(1))
				If SA3->(DBSEEK(xFilial("SA3") + cSuper ))
					cSupMail := SA3->A3_EMAIL
					cNomeSuper := SA3->A3_NOME
				Endif
				nTotHtm1 := 0
				nTotHtm2 := 0
			Endif
			
				If x > 1
					If Alltrim(aDados1[x,7]) != Alltrim(aDados1[x - 1,7])
					
						cVend     := aDados1[x -1,7]
						cVendMail := Lower(aDados1[x - 1,8])
						If SA3->(DBSEEK(xFilial("SA3") + cVend )) 
							cNomeVend := SA3->A3_NOME
						Endif
						cSuper    := aDados1[x - 1,9] 
						
						cSupMail  := ""
						SA3->(DBSETORDER(1))
						If SA3->(DBSEEK(xFilial("SA3") + cSuper ))
							cSupMail := SA3->A3_EMAIL 
							cNomeSuper := SA3->A3_NOME
						Endif
				
						oHtml:ValByName("cVend" , iif(!Empty(cVend), cVend + '-'+ cNomeVend, "" ) )
					    oHtml:ValByName("cSuper" , iif(!Empty(cSuper), cSuper + '-' + cNomeSuper, "" ) )
					    oHtml:ValByName("nTot1" , iif(!Empty(nTotHtm1), Transform(nTotHtm1 , "@E 99,999,999.99" ), "" ) )   //muda o vendedor, totaliza
					    oHtml:ValByName("nTot2" , iif(!Empty(nTotHtm2), Transform(nTotHtm2 , "@E 99,999,999.99" ), "" ) )   //muda o vendedor, totaliza
					    lEnvia := .T.
						If lEnvia
							_user := Subs(cUsuario,7,15)
							 oProcess:ClientName(_user)
							 eEmail := ""	 
							 eEmail += cVendMail        //email do representante
							 eEmail += ";" + cSupMail   //email do coordenador
							 If Alltrim(cSuper) = '0315'
 							 	eEmail += ";" + "vendas.sp@ravaembalagens.com.br" 
 							 Endif
 							 
 							 If Alltrim(cSuper) = '0320'
 							 	eEmail += ";" + "josenildo@ravaembalagens.com.br"
 							 Endif
							 
							 	 
							 //eEmail := ""  //retirar
							 oProcess:cTo := eEmail
							 //oProcess:cBcc:= "flavia.rocha@ravaembalagens.com.br"
							 subj	:= cVend + " - PEDIDOS REJEITADOS CREDITO - " + cEmpresa
							 oProcess:cSubject  := subj
							 oProcess:Start()
							 WfSendMail()
						Endif
						nTotHtm1 := 0
						nTotHtm2 := 0
					                 
						oProcess:=TWFProcess():New("FATR035","FATR035")
						oProcess:NewTask('Inicio',"\workflow\http\oficial\FATR035.htm")
						oHtml     := oProcess:oHtml 
			
					Endif
				Endif
			   
			   aadd( oHtml:ValByName("it.cPed1") , iif( !Empty(aDados1[x,1]), aDados1[x,1] , "" ) )                        
			   aadd( oHtml:ValByName("it.cTipo1") , iif( Alltrim(aDados1[x,10]) = '001', "Antecipado" , "Programado" ) )                        
			   aadd( oHtml:ValByName("it.dDTPrg1") , iif(!Empty(aDados1[x,2]), Dtoc(aDados1[x,2]), "" )    )     
			   aadd( oHtml:ValByName("it.cCli1") , iif(!Empty(aDados1[x,3]) , aDados1[x,3] + "-" + aDados1[x,4], "" )  )
			   aadd( oHtml:ValByName("it.dLib1") , iif(!Empty(aDados1[x,5]), Dtoc(aDados1[x,5]) , "" )  ) 
			   aadd( oHtml:ValByName("it.nVal1") , iif(!Empty(aDados1[x,6]) , Transform(aDados1[x,6], "@E 99,999,999.99") , "" )  )   
			   nTotHtm1 += aDados1[x,6]
			
		Next
		cVend     := aDados1[x -1,7]
		cVendMail := Lower(aDados1[x - 1,8])
		If SA3->(DBSEEK(xFilial("SA3") + cVend )) 
			cNomeVend := SA3->A3_NOME
		Endif
		cSuper    := aDados1[x - 1,9] 
						
		cSupMail  := ""
		SA3->(DBSETORDER(1))
		If SA3->(DBSEEK(xFilial("SA3") + cSuper ))
			cSupMail := SA3->A3_EMAIL
			cNomeSuper:= SA3->A3_NOME
		Endif
				
		oHtml:ValByName("cVend" , iif(!Empty(cVend), cVend + '-'+cNomeVend, "" ) )
	    oHtml:ValByName("cSuper" , iif(!Empty(cSuper), cSuper + '-' + cNomeSuper, "" ) )
	    oHtml:ValByName("nTot1" , iif(!Empty(nTotHtm1), Transform(nTotHtm1 , "@E 99,999,999.99" ), "" ) )   //muda o vendedor, totaliza
	    //oHtml:ValByName("nTot2" , iif(!Empty(nTotHtm2), Transform(nTotHtm2 , "@E 99,999,999.99" ), "" ) )   //muda o vendedor, totaliza
	    lEnvia := .T.
		If lEnvia
			_user := Subs(cUsuario,7,15)
			 oProcess:ClientName(_user)
			 eEmail := ""	 
			 eEmail += cVendMail
			 eEmail += ";" + cSupMail
			 If Alltrim(cSuper) = '0315'
 			 	eEmail += ";" + "vendas.sp@ravaembalagens.com.br" 
 			 Endif
 							 
 			 If Alltrim(cSuper) = '0320'
 			 	eEmail += ";" + "josenildo@ravaembalagens.com.br"
 			 Endif
							 	 
			 //eEmail := ""  //retirar
			 oProcess:cTo := eEmail
			 //oProcess:cBcc:= "flavia.rocha@ravaembalagens.com.br"
			 subj	:= cVend + " - PEDIDOS REJEITADOS CREDITO - " + cEmpresa
			 oProcess:cSubject  := subj
			 oProcess:Start()
			 WfSendMail()
		Endif
		nTotHtm1 := 0
		//nTotHtm2 := 0
	
		
	Endif                       
	//Reset Environment

//ENDIF
//FIM DO HTML
Return
         


