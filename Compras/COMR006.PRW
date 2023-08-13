#include "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"
#include "font.ch"
#include "colors.ch"
#include "Ap5mail.ch"

/*/
//---------------------------------------------------------------------------------------------------------------
//Programa: COMR006  
//Objetivo:  - Chamado 001771 - Relatório de Consulta para o Solicitante
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 29/09/2010
//---------------------------------------------------------------------------------------------------------------
/*/

User Function COMR006()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relação de Solicitações e Pedidos de Compra em andamento"
Local cPict          := ""
Local titulo         := "Relatório de Acompanhamento das SCs"
Local nLin           := 80

//Nº SOLICITAÇÃO |   SOLICITANTE  |  DATA DA SOLICTAÇÃO  Item  |  Produto  |  Quantidade  |  Dt. Liberação  |  Dt.Prevista  |  Comprador  | Saldo

Local Cabec1         := "No.SOLICITAÇÃO   SOLICITANTE            DT.SOLICITAÇÃO"
Local Cabec2         := "Item  Produto          Descricao                     Quant  UM    Dt.Lib.  Cheg.Prev.  Comprador               Saldo"
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 130 //220
Private tamanho      := "M" //"G"
Private nomeprog     := "COMR006" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "COMR006" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""
Private cPerg	:= "COMR006"
 
Pergunte( cPerg ,.T. )
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

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  10/03/10   º±±
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
local cQuery:='' 
Local LF := CHR(13) + CHR(10)
Local aUsu := {}
Local cUsu := ""

//Local Cabec1         := "No.SOLICITAÇÃO   SOLICITANTE   DT.SOLICITAÇÃO"
//Local Cabec2         := "Item  Produto  Quantidade  Dt. Liberação  Dt.Prevista  Comprador  Saldo"

cQuery := "SELECT C1_NUM, C1_EMISSAO, C1_SOLICIT " +LF
cQuery += " ,C1_ITEM, C1_PRODUTO, C1_DESCRI, C1_QUANT, C1_UM, C1_DTAPROV, C7_PREVCHG, C7_USER, (C1_QUANT-C1_QUJE) AS SALDO " + LF

cQuery += "FROM " + RetSqlName("SC1") + " SC1, "
cQuery += " " + RetSqlName("SC7") + " SC7 "
cQuery += "WHERE " + LF
//cQuery += " C1_QUANT-C1_QUJE > 0 AND "

cQuery += " C1_EMISSAO >= '" + Dtos(MV_PAR01) + "' AND C1_EMISSAO <= '" + Dtos(MV_PAR02) + "' " + LF
cQuery += " AND RTRIM(C1_NUM) >= '" +   Alltrim(MV_PAR03) + "' AND RTRIM(C1_NUM) <= '" + Alltrim(MV_PAR04) + "' " + LF
cQuery += " AND RTRIM(C1_USER) >= '" + Alltrim(MV_PAR05) + "' AND RTRIM(C1_USER) <= '" + Alltrim(MV_PAR06) + "' " + LF

cQuery += " AND C1_PEDIDO = C7_NUM " + LF
cQuery += " AND C1_ITEMPED = C7_ITEM  " + LF

cQuery += "AND SC1.D_E_L_E_T_ = '' "
cQuery += "AND SC7.D_E_L_E_T_ = '' "
cQuery += "AND C1_SOLICIT <> '' "

cQuery += "ORDER BY C1_EMISSAO "
//MemoWrite("C:\Temp\COMR006.SQL",cQuery )

TCQUERY cQuery NEW ALIAS "TMP1"

TCSetField( "TMP1", "C1_EMISSAO", "D")
TCSetField( "TMP1", "C1_DTAPROV", "D")
TCSetField( "TMP1", "C7_PREVCHG", "D")

TMP1->( DbGoTop() )


SetRegua(RecCount())      

While TMP1->( !EOF() )

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
      nLin++
   Endif

//No.SOLICITAÇÃO   SOLICITANTE   DT.SOLICITAÇÃO"
//Item  Produto                                 Quant         UM   Dt.Lib  Cheg.Prevista  Comprador     Saldo"

//SC               SOLICIT               Dt.Solicitação
//XXXXXX           XXXXXXXXXXXXXXXXXXXX  99/99/99
//Item
//9999  XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXX   9,999,999.99  XX   99/99/99  99/99/99     XXXXXXXXXXXXXXX   9,999,999.99
//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
    cSC			:= TMP1->C1_NUM
    cSolicit	:= iif( Alltrim(TMP1->C1_SOLICIT) == "Administra", "Automatica",(TMP1->C1_SOLICIT) )
    dEmiSC		:= TMP1->C1_EMISSAO
    
    @nLin,000 PSAY cSC
    @nLin,017 PSAY Substr(cSolicit,1,20) PICTURE "@!"
    @nLin,040 PSAY Dtoc(dEmiSC) PICTURE "@D"	 
    nLin++
    nLin++
    
    While !TMP1->(EOF()) .AND. cSC == TMP1->C1_NUM		   
	      
	    If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
        	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
            nLin := 8
		Endif
          
        @nLin,000 PSAY TMP1->C1_ITEM 
        @nLin,006 PSAY TMP1->C1_PRODUTO PICTURE "@!" 
        @nLin,023 PSAY Substr(TMP1->C1_DESCRI,1,20) PICTURE "@!"
        @nLin,046 PSAY TMP1->C1_QUANT 	PICTURE "@E 9,999,999.99"
        @nLin,060 PSAY TMP1->C1_UM		PICTURE "@!"
        @nLin,065 PSAY TMP1->C1_DTAPROV	PICTURE "@D"
        @nLin,075 PSAY TMP1->C7_PREVCHG	PICTURE "@D"
          
        //captura dados do usuário comprador:
        PswOrder(1)
        If PswSeek( TMP1->C7_USER , .T. )         
			   
		   aUsu   := PSWRET() 					// Retorna vetor com informações do usuário
		   //cUsu   := Alltrim( aUsu[1][2] )    //Nome do usuário 
		   cUsu   := Alltrim( aUsu[1][4] )      //Nome (COMPLETO) do usuário
		   //eEmail := Alltrim( aUsu[1][14] )     // Definição de e-mail padrão
		Endif
		
        @nLin,088 PSAY Substr(cUsu  ,1,15)	       //NOME DO COMPRADOR
        @nLin,106 PSAY TMP1->SALDO	PICTURE "@E 9,999,999.99"    
	    
	    nLin++
	           
		TMP1->(DbSkip())		      
		
    EndDo
    
    nLin++
    @nLin,000 PSAY Replicate("-",limite)
    nLin++	
    
    TMP1->( Incregua())
    
EndDo
Roda( 0, "", TAMANHO )

TMP1->(DbCloseArea())

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



//--------------------------------------------------------------------------
//Programa: COMR006A
//Objetivo: Gerar relatório das SCs que possuem data prevista de chegada para
//			o dia seguinte e enviar por email.
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 05/10/2010
//--------------------------------------------------------------------------

User Function COMR006A()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt( "NORDEM,TAMANHO,TITULO,CDESC1,CDESC2,CDESC3," )
SetPrvt( "ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA," )
SetPrvt( "NLIN,WNREL,M_PAG,CABEC1,CABEC2,MPAG," )


tamanho   := "P"
titulo    := "SCs COM ENTREGA PREVISTA PARA O DIA SEGUINTE "
cDesc1    := "Este programa ira emitir o relatorio "
cDesc2    := "das SCs previstas para o dia seguinte. "
cDesc3    := ""
cNatureza := ""
aReturn   := { "Producao", 1, "Administracao", 1, 2, 1, "", 1 }
nomeprog  := "COMR006A"
cPerg     := "COMR006"
nLastKey  := 0
lContinua := .T.
wnrel     := "COMR006A"
M_PAG     := 1
li		  := 80

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Habilitar somente para Schedule
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"


RptDetail(Cabec1,Cabec2,Titulo,Li)

Return



//------------------------------
Static Function RptDetail(Cabec1,Cabec2,Titulo,Li)     
//------------------------------


Local aResult   := {}
Local LF      	:= CHR(13)+CHR(10)
Local chtm		:= ""
Local cDIRHTM	:= ""
Local cARQHTM	:= ""
Local nHandle	:= 0
Local nPag		:= 1
Local cNomredesp:= ""	

cQuery := "SELECT C1_NUM, C1_EMISSAO, C1_SOLICIT " +LF
cQuery += " ,C1_ITEM, C1_PRODUTO, C1_DESCRI, C1_QUANT, C1_UM, C1_DTAPROV, C7_PREVCHG, C7_USER, (C1_QUANT-C1_QUJE) AS SALDO " + LF

cQuery += "FROM " + RetSqlName("SC1") + " SC1, "
cQuery += " " + RetSqlName("SC7") + " SC7 "
cQuery += "WHERE " + LF

//cQuery += " C7_PREVCHG = '" + Dtos(dDatabase + 1) + "' " + LF
cQuery += " C1_EMISSAO >= '20101001' AND C1_EMISSAO <= '20101231' " + LF

cQuery += " AND C1_PEDIDO = C7_NUM " + LF
cQuery += " AND C1_ITEMPED = C7_ITEM  " + LF

cQuery += "AND SC1.D_E_L_E_T_ = '' "
cQuery += "AND SC7.D_E_L_E_T_ = '' "
cQuery += "AND C1_SOLICIT <> '' "

cQuery += "ORDER BY C1_EMISSAO "
//MemoWrite("C:\Temp\COMR006A.SQL",cQuery )

If Select("TMP2") > 0
	DbSelectArea("TMP2")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP2"
TCSetField( 'TMP2', "C1_EMISSAO", "D" )
TCSetField( 'TMP2', "C1_DTAPROV", "D" )
TCSetField( 'TMP2', "C7_PREVCHG", "D" )

TMP2->( DBGoTop() )

mPag := 1


cDirHTM  := ""    
cArqHTM  := ""
chtm	 := ""

If !TMP2->(Eof())
	nCta := 1
	/////////////////
	cDirHTM  := "\Temp\"    
	cArqHTM  := "COMR006A-" + Dtos(dDatabase) + ".HTM"    
	nHandle  := fCreate( cDirHTM + cArqHTM, 0 )
	nPag     := 1 
	   
	If nHandle = -1
	     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
	     Return
	Endif
	
	chtm += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+ LF
   	////div para quebrar página automaticamente
	chtm += '<style type="text/css">'+LF
	chtm += '.quebra_pagina {'+LF
	chtm += 'page-break-after:always;'+LF
	chtm += 'font-size:10px;'+LF
	chtm += 'font-style:italic;'+LF
	chtm += '	color:#F00;'+LF
	chtm += '	padding:5px 0;'+LF
	chtm += '	text-align:center;'+LF
	chtm += '}'+LF
	chtm += 'p {text-align:right;'+LF
	chtm += '}'+LF
	chtm += '</style>'+LF
	

	Do While !TMP2->( Eof() )
	
		cSC			:= TMP2->C1_NUM
	    cSolicit	:= iif( Alltrim(TMP2->C1_SOLICIT) == "Administra", "Automatica",(TMP2->C1_SOLICIT) )
	    dEmiSC		:= TMP2->C1_EMISSAO
	    
	    If Li > 34
	    
	    	If nCta > 1
				chtm += '<div class="quebra_pagina">A pagina quebra neste PONTO->' + str(Li) +'</div>'+LF
				//chtm += '<div class="quebra_pagina"> </div>'+LF
				//nPag++
			Endif
				
												
			///prepara o html
			//chtm += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+LF
			chtm += '<html><head>'                                                         +LF 
			chtm += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+LF
			chtm += '<table width="1100" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+LF
			chtm += '<tr>    <td>'+LF
			chtm += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:12px;font-family:Arial">'+LF
			chtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>RAVA EMBALAGENS INDUSTRIA COM. LTDA.</td>  <td></td>'+LF
			chtm += '<td align="right">Folha..:' + Str(nPag) + '</td></tr>'+LF
			chtm += '<tr>        <td>SIGA /COMR006A/v.P10</td>'+LF
			chtm += '<td>'+titulo+'</td>'+LF
			chtm += '<td align="right">DT.Ref.:'+ Dtoc(dDatabase)+'</td>        </tr>        <tr>'+LF
			chtm += '<td>Hora...: '+ Time() + '</td>          <td></td>'+LF
			chtm += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr></table></head>'+LF
			chtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>'+LF
			chtm += '</table></head>'+LF 
			nPag++
			
			Li := 5
							
		Endif 					        
	    	       
	    
			chtm += '<br>'+ LF			                                                                                  
			Li++
		
	    	chtm += '<table width="500" border="0" style="font-size:12px;font-family:Arial"><strong>'+LF
	    	chtm += '<tr>'+LF
			chtm += '<td ><div align="center"><span class="style3"><b>SOLICITACAO: </b>'+ cSC + '</span></div></td>'+LF
			chtm += '<td ><div align="center"><span class="style3"><b>SOLICITANTE: </b>'+ Substr(cSolicit,1,20) + '</span></div></td>'+LF
			chtm += '<td ><div align="center"><span class="style3"><b>DT.SOLICITACAO: </b>'+ Dtoc(dEmiSC) + '</span></div></td>'+LF
			chtm += '</tr>'+LF  //FECHA A LINHA 
			/////FECHA A TABELA DO HTML
			chtm += '</table>'
			Li++
			
			chtm += '<table width="1100" border="1" style="font-size:12px;font-family:Arial"><strong>'+LF
			chtm += '<td ><div align="center"><span class="style3"><b>ITEM</span></div></b></td>'+LF
			chtm += '<td ><div align="center"><span class="style3"><b>PRODUTO</span></div></b></td>'+LF
			chtm += '<td ><div align="center"><span class="style3"><b>DESCRICAO</span></div></b></td>'+LF
			chtm += '<td ><div align="center"><span class="style3"><b>QTDE</span></div></b></td>'+LF
			chtm += '<td ><div align="center"><span class="style3"><b>UM</span></div></b></td>'+LF
			chtm += '<td ><div align="center"><span class="style3"><b>DT.LIBERACAO</span></div></b></td>'+LF
			chtm += '<td ><div align="center"><span class="style3"><b>CHEG.PREVISTA</span></div></b></td>'+LF
			chtm += '<td ><div align="center"><span class="style3"><b>COMPRADOR</span></div></b></td>'+LF
			chtm += '<td ><div align="center"><span class="style3"><b>SALDO</span></div></b></td>'+LF
			chtm += '</tr>'+LF
			Li++
			//Li++    
	    
	    
	    	    
        
        While !TMP2->(EOF()) .AND. cSC == TMP2->C1_NUM
        
        	If Li > 34
				
				chtm += '<div class="quebra_pagina">A pagina quebra neste ponto->' + str(Li) +'</div>'+LF
				//chtm += '<div class="quebra_pagina"> </div>'+LF
								
				Li := 5
									
				///prepara o html
				chtm += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+LF
				chtm += '<html><head>'                                                         +LF 
				chtm += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+LF
				chtm += '<table width="1100" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+LF
				chtm += '<tr>    <td>'+LF
				chtm += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:12px;font-family:Arial">'+LF
				chtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>RAVA EMBALAGENS INDUSTRIA COM. LTDA.</td>  <td></td>'+LF
				chtm += '<td align="right">Folha..:' + Str(nPag) + '</td></tr>'+LF
				chtm += '<tr>        <td>SIGA /COMR006A/v.P10</td>'+LF
				chtm += '<td>'+titulo+'</td>'+LF
				chtm += '<td align="right">DT.Ref.:'+ Dtoc(dDatabase)+'</td>        </tr>        <tr>'+LF
				chtm += '<td>Hora...: '+ Time() + '</td>          <td></td>'+LF
				chtm += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr></table></head>'+LF
				chtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>'+LF
				chtm += '</table></head>'+LF 			
				
			
				chtm += '<table width="1100" border="1" style="font-size:12px;font-family:Arial"><strong>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>ITEM</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>PRODUTO</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>DESCRICAO</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>QTDE</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>UM</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>DT.LIBERACAO</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>CHEG.PREVISTA</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>COMPRADOR</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>SALDO</span></div></b></td>'+LF
				chtm += '</tr>'+LF
				Li++
				//Li++
					
				nPag++
				
			Endif 					        
        
        
	        chtm += '<td width="300" align="center"><span class="style3">'+ TMP2->C1_ITEM + '</span></td>'+LF
			chtm += '<td width="300" align="left"><span class="style3">'+ TMP2->C1_PRODUTO + '</span></td>'+LF
			chtm += '<td width="900" align="left"><span class="style3">'+ Substr(TMP2->C1_DESCRI,1,20) + '</span></td>'+LF
			chtm += '<td width="300" align="right"><span class="style3">'+ Transform(TMP2->C1_QUANT,"@E 9,999,999.99")  + '</span></td>'+LF
			chtm += '<td width="300" align="center"><span class="style3">'+ TMP2->C1_UM  + '</span></td>'+LF
			chtm += '<td width="300" align="center"><span class="style3">'+ Dtoc(TMP2->C1_DTAPROV)  + '</span></td>'+LF
			chtm += '<td width="300" align="center"><span class="style3">'+ Dtoc(TMP2->C7_PREVCHG) + '</span></td>'+LF
			
			//captura dados do usuário comprador:
		    PswOrder(1)
		    If PswSeek( TMP2->C7_USER , .T. )         
					   
				aUsu   := PSWRET() 					// Retorna vetor com informações do usuário
				//cUsu   := Alltrim( aUsu[1][2] )    //Nome do usuário 
				cUsu   := Alltrim( aUsu[1][4] )      //Nome (COMPLETO) do usuário
				//eEmail := Alltrim( aUsu[1][14] )     // Definição de e-mail padrão
			Endif
				
			chtm += '<td width="300" align="left"><span class="style3">'+ Substr(cUsu,1,15) + '</span></td>'+LF
			chtm += '<td width="500" align="right"><span class="style3">'+ Transform(TMP2->SALDO,"@E 9,999,999.99") + '</span></td>'+LF
			
			chtm += '</tr>'+LF  //FECHA A LINHA 
						
			Li++
			nCta++
				
	        TMP2->(DBSKIP())
    	Enddo
    	
    	
    	
    	/////FECHA A TABELA DO HTML
		chtm += '</table>'
    	////linha em branco
		
    	
    Enddo
	/////FECHA A TABELA DO HTML
	chtm += '</table>'
	
	chtm += '<br>' + LF
	///faz o rodapé
	chtm += '<table border="0" cellspacing="0" cellpadding="0" width="100%" bgcolor="#FFFFFF" style="FONT-SIZE: 9px; FONT-FAMILY: Arial">'+LF
    chtm += '    <tr>'+LF
    chtm += '      <td id="colArial" colspan="3"><hr color="#000000" noshade size="2"></td>'+LF
    chtm += '    </tr>'+LF
    chtm += '    <tr>'+LF
    chtm += '      <td id="colArial">Microsiga&nbsp;Software&nbsp;S/A</td>'+LF
    chtm += '      <td id="colArial">&nbsp;</td>'+LF
    chtm += '      <td id="colArial" align="right">-&nbsp;Hora&nbsp;Termino:&nbsp;' + Time() + '</td>'+LF
    chtm += '    </tr>'+LF
    chtm += '    <tr>'+LF
    chtm += '      <td id="colArial" colspan="3"><hr color="#000000" noshade size="2"></td>'+LF
    chtm += '    </tr>'+LF
    chtm += '  </table>'+LF
    
	//////FECHA O HTML PARA GRAVAÇÃO E ENVIO
	chtm += '</body> '
	chtm += '</html> '
	//////GRAVA O HTML
	Fwrite( nHandle, chtm, Len(chtm) )
	FClose( nHandle )
	nRet := 0
							
	//////SELECIONA O EMAIL DESTINATÁRIO 
	cMailTo := "joao.emanuel@ravaembalagens.com.br"
	//cMailTo := "flavia.rocha@ravaembalagens.com.br" 
	//cCopia  := "flavia.rocha@ravaembalagens.com.br"
	cCorpo  := titulo
	cAnexo  := cDirHTM + cArqHTM
	cAssun  := titulo
	//////ENVIA O HTML COMO ANEXO
	U_SendFatr11( cMailTo, cCopia, cAssun, cCorpo, cAnexo ) 
 
	
Else
	
	///prepara o html
	chtm += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+LF
	chtm += '<html><head>'                                                         +LF 
	chtm += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+LF
	chtm += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+LF
	chtm += '<tr>    <td>'+LF
	chtm += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:12px;font-family:Arial">'+LF
	chtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>RAVA EMBALAGENS INDUSTRIA COM. LTDA.</td>  <td></td>'+LF
	chtm += '<td align="right">Folha..:' + Str(nPag) + '</td></tr>'+LF
	chtm += '<tr>        <td>SIGA /COMR006A/v.P10</td>'+LF
	chtm += '<td>'+titulo+'</td>'+LF
	chtm += '<td align="right">DT.Ref.:'+ Dtoc(dDatabase)+'</td>        </tr>        <tr>'+LF
	chtm += '<td>Hora...: '+ Time() + '</td>          <td></td>'+LF
	chtm += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr></table></head>'+LF
	chtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>'+LF
	chtm += '</table></head>'+LF 
			
	chtm += '<table width="1100" border="1" style="font-size:12px;font-family:Arial"><strong>'+LF
	chtm += '<td ><div align="center"><span class="style3"><b>ITEM</span></div></b></td>'+LF
	chtm += '<td ><div align="center"><span class="style3"><b>PRODUTO</span></div></b></td>'+LF
	chtm += '<td ><div align="center"><span class="style3"><b>DESCRICAO</span></div></b></td>'+LF
	chtm += '<td ><div align="center"><span class="style3"><b>QTDE</span></div></b></td>'+LF
	chtm += '<td ><div align="center"><span class="style3"><b>UM</span></div></b></td>'+LF
	chtm += '<td ><div align="center"><span class="style3"><b>DT.LIBERACAO</span></div></b></td>'+LF
	chtm += '<td ><div align="center"><span class="style3"><b>CHEG.PREVISTA</span></div></b></td>'+LF
	chtm += '<td ><div align="center"><span class="style3"><b>COMPRADOR</span></div></b></td>'+LF
	chtm += '<td ><div align="center"><span class="style3"><b>SALDO</span></div></b></td>'+LF
	chtm += '<td ><div align="center"><tr>'+LF
    
	chtm += "Não existem SCs com chegada prevista para " + Dtoc(dDatabase + 1) + "."+LF
	
	/////FECHA A TABELA DO HTML
	chtm += '</table><br>'	
	
	chtm += Roda( 0, "", TAMANHO )
	//////FECHA O HTML PARA GRAVAÇÃO E ENVIO
	chtm += '</body> '
	chtm += '</html> '
	//////GRAVA O HTML
	Fwrite( nHandle, chtm, Len(chtm) )
	FClose( nHandle )
	nRet := 0
							
	//////SELECIONA O EMAIL DESTINATÁRIO 
	cMailTo := "joao.emanuel@ravaembalagens.com.br"
	//cMailTo := "flavia.rocha@ravaembalagens.com.br" 
	//cCopia  := "flavia.rocha@ravaembalagens.com.br"
	cCorpo  := titulo
	cAnexo  := cDirHTM + cArqHTM
	cAssun  := titulo
	//////ENVIA O HTML COMO ANEXO
	U_SendFatr11( cMailTo, cCopia, cAssun, cCorpo, cAnexo ) 

Endif

TMP2->( DbCloseArea() )

//Msginfo("COMR006A - Processo finalizado")

// Habilitar somente para Schedule
Reset environment


Return NIL

