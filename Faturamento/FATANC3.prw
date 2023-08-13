#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATANC3   º Autor ³ AP6 IDE            º Data ³  29/10/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relação de aniversariantes, gerador de etiquetas e mala-di-º±±
±±º          ³ reta.                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

*************
User Function FATANC3()
*************

Private lDentroSiga := .F.

/////////////////////////////////////////////////////////////////////////////////////
////verifica se o relatório está sendo chamado pelo Schedule ou dentro do menu Siga
/////////////////////////////////////////////////////////////////////////////////////

If Select( 'SX2' ) == 0
  	RPCSetType( 3 )
   	//Habilitar somente para Schedule
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"
  	sleep( 5000 )
  
  	fCarta()
  	//Reset environment
 
Else
 
  	lDentroSiga := .T.
	pergunte("FATANC", .T.)
	fCarta()
 
  
EndIf
  

Return

**************************
Static Function fCarta()
**************************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo         := "Relacao de Aniversariantes"
Local nLin           := 80
Local Cabec1         := "Código Lj Cliente                                   Responsavel                     Telefone                   Data de Aniversario"
Local Cabec2         := "Código Lj Cliente                                   Responsavel                     Telefone                   1ªCompra  Tempo       Nr. Compras  Prz.Med.Comp"
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "G"
Private nomeprog     := "FATANC3" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATANC3" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := ""
Private aABC         := {}
Private cCliVip      := cVIPS:= ""
//pergunte("FATANC", .F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lDentroSiga
	wnrel := SetPrint(cString,NomeProg,"FATANC",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Else
	RunReport(Cabec1,Cabec2,Titulo,nLin)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ



Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  29/10/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

***************

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

***************

Local cVendNm := cVendor := cQuery := cQuery1 := ''
Local aMes := { 'Janeiro', 'Fevereiro', 'Marco', 'Abril', 'Maio', 'Junho', 'Julho',;
                'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro' }
Local aClien := {}                
Local cMes := ""  //aMES[ Val( mv_par01 ) ]
Local nCLI := 0
Local nLin := 8
Local aPar := {}
Local LF   := CHR(13) + CHR(10) 
Local nMesAtual := Month(dDatabase)
Local cDataExtenso := alltrim( str( day( dDataBase ) ) ) +" de "+mesextenso()+" de "+alltrim( str( year(dDataBase ) ) )
Local cMailCli     := "" 
Local nHandle      := 0
Local cDirHTM      := ""
Local cArqHTM      := ""
Local cCarta       := ""
Local cMailTo      := ""
Local cCopia       := ""
Local cAssun       := ""
Local cCorpo       := ""
Local cAnexo       := ""

SetPrvt("OHTML,OPROCESS")

dbSelectArea('SA1')
ABC500(aABC, cCliVip)

If lDentroSiga
	cMes := aMES[ Val( mv_par01 ) ]
	cQuery := "select	SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_NMRESPO, SA1.A1_TEL, SA1.A1_DTNASC, SA1.A1_VEND, " + LF
	cQuery += "SA3.A3_COD, SA3.A3_NREDUZ "+ LF
	cQuery += "from	" + retSqlName('SA1') + " SA1 left outer join " + retSqlName('SA3') + " SA3 on SA1.A1_VEND = SA3.A3_COD "+ LF
	If lDentroSiga
		cQuery += "where SA1.A1_COD between '"+ mv_par02 +"' and '"+ mv_par03 +"' " + LF 
		cQuery += " and month(SA1.A1_DTNASC) = '"+ mv_par01 +"' "+ LF
		if ! empty( mv_par04 )
		  cQuery += "and A1_ULTCOM >= '" + dtos(mv_par04) + "'  "  + LF
		endIf
	Else        //via schedule
		cQuery += " and month(SA1.A1_DTNASC) = '"+ Str( nMesAtual + 1) +"' "+ LF
		if ! empty( mv_par04 )
		  cQuery += "and A1_ULTCOM >= '" + dtos(dDatabase - 180) + "'  "  + LF
		endIf
	Endif
	
	
	cQuery += "and SA1.A1_DTNASC != '' "+ LF
	
	/**/
	cQuery += "and SA1.A1_COD in ("+cVIPS+") "+ LF
	/**/
	cQuery += "and SA1.A1_FILIAL = '" + xFilial("SA1") + "' and SA1.D_E_L_E_T_ != '*' "+ LF
	cQuery += "and SA3.A3_FILIAL = '" + xFilial("SA3") + "' and SA3.D_E_L_E_T_ != '*' "+ LF
	cQuery += "order by SA3.A3_COD, SA1.A1_DTNASC "+ LF
	MemoWrite("C:\Temp\nivercompra.sql", cQuery )
	
	cQuery := changeQuery( cQuery )
	TCQUERY cQuery NEW ALIAS 'SA1X'
	SA1X->( dbGoTop() )
	Cabec("Relacao de Aniversariantes - " + cMES,Cabec1,"",NomeProg,Tamanho,nTipo)
	SetRegua(0)
		
	While ! SA1X->( EOF() )
	   If lAbortPrint
	      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	      Exit
	   Endif
	   cVendor := SA1X->A3_COD  
	   cVendNm := SA1X->A3_NREDUZ
	   do while (cVendor == SA1X->A3_COD) .and. SA1X->( !Eof() )
	     if nLin > 55
	      Cabec("Relacao de Aniversariantes - " + cMES,Cabec1,"",NomeProg,Tamanho,nTipo)
	      nLin := 8
	     endif
	     Aadd(aPar, SA1X->A1_COD)
	     
	   
		 @ nLin, 000 pSay SA1X->A1_COD
		 @ nLin, 007 pSay SA1X->A1_LOJA
		 @ nLin, 010 pSay SA1X->A1_NOME
		 @ nLin, 052 pSay SA1X->A1_NMRESPO
		 @ nLin, 084 pSay SA1X->A1_TEL
		 @ nLin, 114 pSay substr(SA1X->A1_DTNASC,7,2) + " de " + cMES//StrZero( Day( ctod( SA1->A1_DTNASC ) ), 2 ) + " de " + cMES
		 nCLI := nCLI + 1   
		 nLin := nLin + 1
		 if mv_par05 == 1
		   if SA1->( dbSeek( xFilial('SA1') + SA1X->A1_COD + SA1X->A1_LOJA , .F.) )
		     if SA1->( recLock('SA1',.F.) )
		       SA1->A1_IMPETQ := 'S'  
		       SA1->( msUnlock() )
		     else
		       msgAlert("Não foi possível marcar a etiqueta de " + alltrim(SA1X->A1_NOME) )
		     endIf
		   else
		     msgAlert("Não foi possível marcar a etiqueta de " + alltrim(SA1X->A1_NOME) )
		   endIf
		 endIf
		 SA1X->( dbSkip() )
		 IncRegua()    
	  endDo
	  @ nLin, 000	PSAY "Pertence(m) ao vendedor: " + alltrim(cVendNm) + " Codigo: " + alltrim(cVendor)
	  nLin += 2
	  if nLin > 55
	    Cabec("Relacao de Aniversario de 1ª Compra - " + cMES,Cabec1,"",NomeProg,Tamanho,nTipo)
	    nLin := 8
	  endif
	  
	EndDo
	@ nLin, 000 pSay Replicate( "-", 132 )
	nLin := nLin + 1
	@ nLin,000 pSay "Total de Aniversariantes no Periodo ==>"
	@ nLin,055 pSay nCLI Picture "@E 999999"
	SA1X->( dbCloseArea() ) 
Endif

///query para aniversariantes da 1a. compra
If lDentroSiga
	SetRegua( 0 )
Endif
cQuery1 := "select  " + LF
cQuery1 += " SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_NREDUZ, SA1.A1_NMRESPO, SA1.A1_TEL, SA3.A3_COD, SA3.A3_NREDUZ, SA1.A1_EMAIL, " + LF
cQuery1 += "SA1.A1_PRICOM, SA1.A1_NROCOM, (Year( getdate() )- Year( SA1.A1_PRICOM )) as NIVER " + LF
cQuery1 += "from  " + retSqlName('SA1') + " SA1 left outer join " + retSqlName('SA3') + " SA3 on SA1.A1_VEND = SA3.A3_COD " + LF
cQuery1 += "where " + LF

If lDentroSiga
	cQuery1 += " SA1.A1_COD between '"+ mv_par02 +"' and '"+ mv_par03 +"' " + LF
	cQuery1 += " and month(SA1.A1_PRICOM) = '"+ MV_PAR01 +"' and SA1.A1_NROCOM > 0 " + LF
Else
	cQuery1 += " month(SA1.A1_PRICOM) = "+ Alltrim(Str( nMesAtual + 1)) +" "+ LF
    cQuery1 += " and SA1.A1_NROCOM > 0 " + LF
Endif
cQuery1 += " and (Year( getdate() )- Year( SA1.A1_PRICOM )) >= 1 " + LF

if ! empty( mv_par04 )
  cQuery1 += " and A1_ULTCOM >= '" + dtos(mv_par04) + "'  "   + LF
endIf

cQuery1 += "and SA1.A1_COD in ("+cVIPS+") " + LF
cQuery1 += "and SA1.A1_FILIAL = '" + xFilial("SA1") + "' and SA1.D_E_L_E_T_ != '*' " + LF
cQuery1 += "and SA3.A3_FILIAL = '" + xFilial("SA3") + "' and SA3.D_E_L_E_T_ != '*' " + LF
cQuery1 += "order by SA3.A3_COD, SA1.A1_PRICOM " + LF 
MemoWrite("C:\Temp\nivercompra.sql", cQuery1 )
cQuery1 := changeQuery( cQuery1 )
TCQUERY cQuery1 NEW ALIAS 'SA1Y'
SA1Y->( dbGoTop() )
nLin := Cabec("Relacao de Aniversario de 1ª Compra - " + cMES,Cabec2,"",NomeProg,Tamanho,nTipo) + 1
If !SA1Y->(EOF())
	
	While ! SA1Y->( EOF() )
	   cVendor := SA1Y->A3_COD  
	   cVendNm := SA1Y->A3_NREDUZ
	   If lDentroSiga
		   If lAbortPrint
		      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		      Exit
		   Endif
	   Endif
	   
	   do while (cVendor == SA1Y->A3_COD) .and. SA1Y->( !Eof() )
	   
		     If lDentroSiga
			     if nLin > 55
			       Cabec("Relacao de Aniversario de 1ª Compra - " + cMES,Cabec2,"",NomeProg,Tamanho,nTipo)
			       nLin := 8
			     endif 
		     Endif
			Aadd(aPar, SA1Y->A1_COD)
				
  	    
	   		If lDentroSiga
			     @ nLin, 000 pSay SA1Y->A1_COD
			     @ nLin, 007 pSay SA1Y->A1_LOJA
			     @ nLin, 010 pSay SA1Y->A1_NOME
			     @ nLin, 052 pSay SA1Y->A1_NMRESPO
			     @ nLin, 084 pSay alltrim(SA1Y->A1_TEL)
			     @ nLin, 111 pSay STOD( SA1Y->A1_PRICOM )
			     @ nLin, 121 pSay alltrim(Str( Year( Date() ) - Year( STOD( SA1Y->A1_PRICOM ) ),4 )) + " Ano(s)"
			     @ nLin, 133 pSay Transform( SA1Y->A1_NROCOM, "@E 999999" )
			     @ nLin, 146 pSay Transform( Round( ( Date() - STOD(SA1Y->A1_PRICOM) ) / SA1Y->A1_NROCOM, 0 ), "@E 9999" ) + " Dias(s)"
		    Else
		    	oProcess:=TWFProcess():New("FAT","Aviso - aniversario")
				oProcess:NewTask('Aviso Aniversario',"\workflow\http\oficial\1aCompra.html")
				oHtml := oProcess:oHtml
				cDataExtenso := alltrim( str( day( dDataBase ) ) ) +" de "+mesextenso()+" de "+alltrim( str( year(dDataBase ) ) )
				
				oHtml:ValByName("dataExtenso", cDataExtenso )
		   		oHtml:ValByName("cNomeCli", SA1Y->A1_NOME ) 
		   		oHtml:ValByName("cMailCli", SA1Y->A1_EMAIL ) 
		   		oHtml:ValByName("nNimo", Transform( SA1Y->NIVER, "@E 999999" ) ) 
		   		//msgbox("passou variáveis")  
		   		
		   		//////////////////
				/////CRIA O HTML
				/////////////////
				cDirHTM  := "\Temp\"    
				cArqHTM  := "Carta_"+ ALLTRIM(SA1Y->A1_COD) + ".HTM"    //relatório P/ Gerentes
				nHandle  := fCreate( cDirHTM + cArqHTM, 0 )
				If nHandle = -1
				     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
				     Return
				Endif
				cCarta := fGeraCarta(cDataExtenso, SA1Y->A1_NOME, SA1Y->A1_EMAIL, SA1Y->NIVER ) 
				Fwrite( nHandle, cCarta, Len(cCarta) )
				FClose( nHandle )
		    Endif
		     nCLI := nCLI + 1   
		     nLin := nLin + 1
		     //iif( SA1Y->A1_NROCOM == 1, aAdd(aClien, { SA1Y->A1_COD, SA1Y->A1_NOME, SA1Y->NMRESPO } ), )
		   	 If lDentroSiga
			   	 if mv_par05 == 1
				   if SA1->( dbSeek( xFilial('SA1') + SA1Y->A1_COD + SA1Y->A1_LOJA , .F.) )
				     if SA1->( recLock('SA1',.F.) )
				       SA1->A1_IMPETQ := 'S'  
				       SA1->( msUnlock() )
				     else
				       msgAlert("Não foi possível marcar a etiqueta de " + alltrim(SA1X->A1_NOME) )
				     endIf
				   else
				     msgAlert("Não foi possível marcar a etiqueta de " + alltrim(SA1X->A1_NOME) )
				   endIf
				 endIf
			 Endif
		 
		 	// Informe a função que deverá ser executada quando as respostas chegarem ao Workflow.
			If !lDentroSiga
				oProcess:cTo      := cMailCli
				//oProcess:cTo      := "flavia.rocha@ravaembalagens.com.br"
				//oProcess:cBCC	  := "flavia.rocha@ravaembalagens.com.br"
				oProcess:cSubject := "Carta - Aniversário 1a. Compra - " + cMailCli
				// Neste ponto, o processo será criado e será enviada uma mensagem para a lista
				// de destinatários.
				//oProcess:Start()				
				//WfSendMail()
				
				cMailTo := SA1Y->A1_EMAIL                       				
				cMailTo += ";aline.farias@ravaembalagens.com.br"
				//cMailTo += ";flavia.rocha@ravaembalagens.com.br"
				cCopia  := ""
				cCorpo  := "Para: " + SA1Y->A1_EMAIL + CHR(13) + CHR(10)
				cCorpo  += "Carta - Aniversário 1a. Compra" + CHR(13) + CHR(10)
				cCorpo  += " Favor Baixar o arquivo pelo navegador Mozilla Firefox."
				
				cAnexo  := cDirHTM + cArqHTM
				cAssun  := "Carta - Aniversário 1a. Compra - " + SA1Y->A1_NREDUZ
				//cMailTo := ""
				//////ENVIA O HTML COMO ANEXO			
				U_SendFatr11( cMailTo, cCopia, cAssun, cCorpo, cAnexo )
			
	        Endif
	
	     	SA1Y->( dbSkip() )
	     	If lDentroSiga
	     		IncRegua()    
	     	Endif
	   endDo
	   
	   If lDentroSiga
	   		@ nLin, 000	PSAY "Pertence(m) ao vendedor: " + alltrim(cVendNm) + " Codigo: " + alltrim(cVendor)     
	   
		   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		      Cabec("Relacao de Aniversario de 1ª Compra - " + cMES,Cabec2,"",NomeProg,Tamanho,nTipo)
		      nLin := 8
		   Endif
	   		nLin += 2
	   Endif 
	   
	EndDo
	
	If lDentroSiga
		@ nLin, 000 pSay Replicate( "-", 160 )
		nLin := nLin + 1
		@ nLin,000 pSay "Total de Aniversariantes de 1ª Compra no Periodo ==>"
		@ nLin,055 pSay nCLI Picture "@E 999999" 
	Endif
	SA1Y->( dbCloseArea() )
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lDentroSiga
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
	If MsgYesNo("Deseja gerar a Carta para estes Clientes ? " , "Gerar Carta")
		U_FATMADI( .T., aPar )
	Endif
Else
	Reset Environment
Endif


Return

***************

static function ABC500(aABC, cCliVip)

***************

Local nSeq
aABC    := {}
cCliVip := ""

//Curva ABC 300 Primeiros Clientes nos ultimos 12 meses
cQuery := "SELECT DISTINCT TOP 300  CLIENTE=D2_CLIENTE,NOME=A1_NOME, "
cQuery += "       QUANT=CASE WHEN D2_SERIE = '' AND F2_VEND1 NOT LIKE '%VD%' THEN 0 "
cQuery += "                ELSE SUM(D2_QUANT) END, "
cQuery += "       PESO=CASE WHEN D2_SERIE = '' AND F2_VEND1 NOT LIKE '%VD%' THEN CAST(0 AS FLOAT) "
cQuery += "                ELSE SUM(D2_QUANT*B1_PESOR) END, "
cQuery += "       CUSTO=SUM(D2_TOTAL/D2_QUANT), "
cQuery += "       VALOR=SUM(D2_TOTAL) "
cQuery += "FROM   "+RetSqlName("SD2")+" SD2 WITH (NOLOCK), "+RetSqlName("SB1")+" SB1 WITH (NOLOCK), "+RetSqlName("SA1")+" SA1 WITH (NOLOCK), "+RetSqlName("SA3")+" "
cQuery += "SA3 WITH (NOLOCK), "+RetSqlName("SF2")+" SF2 WITH (NOLOCK), "+RetSQlName("SBM")+" SBM WITH (NOLOCK) "
cQuery += "WHERE  D2_EMISSAO BETWEEN "+ dtos(lastday(stod(alltrim( str( year( dDataBase ) ) + mv_par01 + "01" ))) - 360) +" AND "+DtoS(dDataBase)+" AND D2_FILIAL = '01' AND D2_TIPO = 'N' "
cQuery += "AND RTRIM(D2_COD) NOT IN ('187','188','189','190') "
cQuery += "AND RTRIM(D2_CF) IN ( '511','5101','611','6101','512','5102','612','6102','6109','6107','5949 ','6949' ) "
cQuery += "AND SD2.D_E_L_E_T_ = '' AND D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = '' AND D2_COD = B1_COD "
cQuery += "AND SB1.D_E_L_E_T_ = '' AND D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA = F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA AND F2_DUPL <> '' "
cQuery += "AND SF2.D_E_L_E_T_ = '' AND F2_VEND1 = A3_COD AND SA3.D_E_L_E_T_ = '' AND SB1.B1_GRUPO = SBM.BM_GRUPO "
cQuery += "GROUP BY D2_CLIENTE,A1_NOME,A1_COD,D2_SERIE,F2_VEND1 "
cQuery += "ORDER BY PESO DESC "
TCQUERY cQuery NEW ALIAS "ABCX"

nSeq := 1
while !ABCX->(EOF())
   Aadd( aABC, { nSeq, ABCX->CLIENTE } )
   cCliVip += "'"+ABCX->CLIENTE+"'"
   nSeq++
   ABCX->(DbSkip())
   if !ABCX->(EOF())
      cCliVip += ","
   endif
end
ABCX->( DbCloseArea() )
aSort( aABC,,,{|x,y| x[2] < y[2]} ) 
cVIPS := cCliVip
return nil

****************************
Static Function fGeraCarta(dataExtenso, cNomeCli, cMailCli, nNimo )
****************************

Local cWeb := ""

cWeb := '<html>' + CHR(13) + CHR(10)
cWeb += '<title>RAVA Embalagens</title>' + CHR(13) + CHR(10)
cWeb += '<body>' + CHR(13) + CHR(10)
cWeb += '<img src="Escritório-Flavia/Diversos/Logo_Rava2.jpg" width="679" height="108" border="0">' + CHR(13) + CHR(10)
cWeb += '<BR>' + CHR(13) + CHR(10)
cWeb += '<p>Cabedelo/PB, ' + dataExtenso + '.</p>' + CHR(13) + CHR(10)
cWeb += '<BR>' + CHR(13) + CHR(10)
cWeb += '<BR>' + CHR(13) + CHR(10)
//cWeb += '<p>' + cNomeCli + ' - ' + cMailCli + '</p>' + CHR(13) + CHR(10)
cWeb += '<p>' + cNomeCli + '</p>' + CHR(13) + CHR(10)
cWeb += '<BR>' + CHR(13) + CHR(10)
cWeb += '<p>Prezado(a) Senhor(a),</p>' + CHR(13) + CHR(10)
cWeb += '<BR>' + CHR(13) + CHR(10)
cWeb += '<p>Acolhemos calorosamente nossos novos amigos, sem esquecer os velhos amigos nos negócios.<BR>' + CHR(13) + CHR(10)
cWeb += 'Portanto, viemos aqui lembra-lo(a) e parabenilza-lo(a) pelo seu ' + Transform( nNimo, "@E 999999" ) + 'o.  aniversário de 1a. compra em nossa empresa.</p>' + CHR(13) + CHR(10)

cWeb += '<p>Queremos que saiba que a RAVA estará sempre pronta para servi-lo(a).</p>' + CHR(13) + CHR(10)

cWeb += '<p>Aproveitamos para informar que podemos disponibilizar amostras de qualquer outro produto que ainda não seja conhecido por sua empresa.</p>' + CHR(13) + CHR(10)

cWeb += '<p>Confira nossos produtos em nosso site: <a href="www.ravaembalagens.com.br">www.ravaembalagens.com.br</a> e faça sua solicitação através do nosso Representante.</p>' + CHR(13) + CHR(10)

cWeb += '<p><u><b>Colocamo-nos a disposição, procurando estar sempre à altura de suas exigências</b></u></p>' + CHR(13) + CHR(10)
cWeb += '<BR>' + CHR(13) + CHR(10)
cWeb += '<p align="center">Atenciosamente,</p>' + CHR(13) + CHR(10)
cWeb += '<BR>' + CHR(13) + CHR(10)
//cWeb += '<p align="center">Raimundo Viana<BR>' + CHR(13) + CHR(10)
cWeb += '<p align="center">Rava Embalagens<BR>' + CHR(13) + CHR(10)
//cWeb += 'Diretor Presidente</p>' + CHR(13) + CHR(10)
cWeb += '<BR>' + CHR(13) + CHR(10)
cWeb += '<BR>' + CHR(13) + CHR(10)
cWeb += '<BR>' + CHR(13) + CHR(10)
cWeb += '<p align="center">Rua José Gerônimo da Silva Filho (Dedé), 66 - Bairro: Renascer - Cabedelo - PB - CEP: 58310-000 / Contato: (83) 3048-1315<BR>' + CHR(13) + CHR(10)
cWeb += 'E-mail: <a href="sac@ravaembalagens.com.br">sac@ravaembalagens.com.br</a> / Atendimento ao Cliente: 0800 014 2345</p>' + CHR(13) + CHR(10)
//cWeb += 'E-mail: <a href="sac@ravaembalagens.com.br">sac@ravaembalagens.com.br</a> / Atendimento ao Cliente: 0800 727 1915</p>' + CHR(13) + CHR(10)
cWeb += '</body>' + CHR(13) + CHR(10)
cWeb += '</html>' + CHR(13) + CHR(10)

Return(cWeb)