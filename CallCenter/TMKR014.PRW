#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "


//--------------------------------------------------------------------------------------------
//Programa: TMKR014
//Objetivo: Mostrar o fechamento do mês, qtd acoes nao respondidas. 
//Autoria : Gustavo Costa
//Empresa : RAVA
//Data    : 28/05/2017
//--------------------------------------------------------------------------

User Function TMKR014()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt( "NORDEM,TAMANHO,TITULO,CDESC1,CDESC2,CDESC3," )
SetPrvt( "ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA," )
SetPrvt( "NLIN,WNREL,M_PAG,CABEC1,CABEC2,MPAG," )
Private dData1
Private dData2

tamanho   := "P"
titulo    := "Fechto. Mensal - % Respostas de Atendimento"
cDesc1    := "Este programa ira emitir o relatorio "
cDesc2    := "do histórico de ligações do Call Center não "
cDesc3    := "efetuados na data prevista."
cNatureza := ""
aReturn   := { "Producao", 1, "Administracao", 1, 2, 1, "", 1 }
nomeprog  := "TMKR014"
cPerg     := "TMKR14"
nLastKey  := 0
lContinua := .T.
nLin      := 9
wnrel     := "TMKR014"
M_PAG     := 1
li		  := 80

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Habilitar somente para Schedule
//RAVA EMB
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"


dData2 := dDatabase
dData1 := dData2 - 30

RptDetail(Cabec1,Cabec2,Titulo,nLin)  

Return



//------------------------------
Static Function RptDetail(Cabec1,Cabec2,Titulo,nLin)     
//------------------------------


Local LF      	:= CHR(13)+CHR(10)
Local chtm		:= ""
Local cDIRHTM	:= ""
Local cARQHTM	:= ""
Local nHandle	:= 0
Local nPag		:= 1	
Local nTotDia := 0
Local nTotGDia:= 0
Local nNaoLig := 0
Local nNaoGLig:= 0
Local nPercDia := 0
Local cNomeFil := ""
Local aUsua := {}
Local cNomeuser := ""
Local dLastDate := dDatabase

//Parâmetros:
//--------------------------------
// mv_par01 - Data de
// mv_par02 - Data até
//---------------------------------

Cabec1 := ""
Cabec2 := ""
Cabec3 := "" 

cQuery := " SELECT UD_DTENVIO, UD_OPERADO, "
cQuery += " SUM(CASE WHEN UD_DTENVIO <> '' THEN 1 ELSE 0 END) ENVIADAS, "
cQuery += " SUM(CASE WHEN UD_DTRESP <> '' THEN 1 ELSE 0 END) RESPONDIDAS "
cQuery += " FROM " + RetSqlName("SUD") 
cQuery += " WHERE UD_DTENVIO BETWEEN '" + Dtos(dData1) + "' AND '" + Dtos(dData2) + "' "
cQuery += " AND D_E_L_E_T_ <> '*' "
cQuery += " GROUP BY UD_DTENVIO, UD_OPERADO "
cQuery += " ORDER BY UD_DTENVIO, UD_OPERADO "

MemoWrite("C:\Temp\TMKR014.sql", cQuery)

If Select("XUD") > 0
	DbSelectArea("XUD")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "XUD"
TCSetField( 'XUD', "UD_DTENVIO", "D" )


XUD->( DBGoTop() )
//SetRegua( Lastrec() )
mPag := 1

aResult 	:= {}
cTipoLig	:= ""


Do While !XUD->( Eof() )  
    
	Aadd (aResult, {XUD->UD_DTENVIO,;		//1			  
	  				XUD->ENVIADAS,;  		//2
					XUD->RESPONDIDAS,;		//3
					XUD->UD_OPERADO } )		//4
  
 
  XUD->( DbSkip() )

Enddo


/////////////////
chtm	 := ""
cDirHTM  := "\Temp\"    
cArqHTM  := "Aten_SAC_Mes_" + Strzero(Month(dData1),2) + ".HTM"  
nHandle  := fCreate( cDirHTM + cArqHTM, 0 )
nPag     := 1 
   
If nHandle = -1
     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
     Return
Endif

If Len(aResult) > 0


	FOR X := 1 TO Len(aResult)
					
			If Li > 58
				//Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  //Impressao do cabecalho
				li := 9
				li++
				
				///prepara o html
				chtm += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+LF
				chtm += '<html><head>'                                                         +LF 
				chtm += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+LF
				chtm += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+LF
				chtm += '<tr>    <td>'+LF
				chtm += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:12px;font-family:Verdana">'+LF
				chtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>RAVA EMBALAGENS INDUSTRIA COM. LTDA.</td>  <td></td>'+LF
				chtm += '<td align="right">Folha..:' + Str(nPag) + '</td></tr>'+LF
				chtm += '<tr>        <td>SIGA /'+ nomeprog + '/v.P10</td>'+LF
				chtm += '<td>'+titulo+'</td>'+LF
				chtm += '<td align="right">DT.Ref.:'+ Dtoc(dData1)+'</td>        </tr>        <tr>'+LF
				chtm += '<td>Hora...: '+ Time() + '</td>          <td></td>'+LF
				chtm += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr></table></head>'+LF
				chtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>'+LF
				chtm += '</table></head>'+LF
				
				chtm += '<table width="1100" border="1" style="font-size:12px;font-family:Verdana"><strong>'+LF 
				//chtm += '<td ><div align="center"><span class="style3"><b>FILIAL</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>DATA ATENDIMENTO</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>OPERADOR</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>TOTAL ATENDIMENTOS</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>TOTAL RESPOSTAS</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>% RESPONDIDO</span></div></b></td>'+LF
				//chtm += '<td ><div align="center"><tr>'+LF
				
				nPag++
				
			Endif 
        
        PswOrder(1)
		If PswSeek( aResult[X,4], .T. )
		   aUsua := PSWRET() 						// Retorna vetor com informações do usuário
		   cNomeuser := Alltrim(aUsua[1][4])		// Nome do usuário
		Endif
		
		If Val(SubStr(Dtoc(aResult[X,1]),1,2)) % 2 > 0
			cColor := "#CCCCCC"
        Else 
        	cColor := "#FFFFFF"
		EndIf
		
        chtm += '<tr>' + LF
        //chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,6] + '</span></td>'+LF   //filial
		chtm += '<td width="300" align="center" bgcolor="'+ cColor +'"><span class="style3">'+ Dtoc(aResult[X,1]) + '</span></td>'+LF     //data programada para ligar
        chtm += '<td width="300" align="center" bgcolor="'+ cColor +'"><span class="style3">'+ cNomeuser + '</span></td>'+LF   //tipo ligação
		chtm += '<td width="300" align="RIGHT" bgcolor="'+ cColor +'"><span class="style3">'+ Transform(aResult[X,2], "@E 9999")  + '</span></td>'+LF    //qtde ligações no dia
		chtm += '<td width="300" align="RIGHT" bgcolor="'+ cColor +'"><span class="style3">'+ Transform(aResult[X,3], "@E 9999")  + '</span></td>'+LF    //qtde não realiz no dia
		chtm += '<td width="300" align="RIGHT" bgcolor="'+ cColor +'"><span class="style3">'+ Transform( (aResult[X,3]/aResult[X,2]) * 100, "@E 999.99") + '</span></td>'+LF   //% nao realiz. no dia
		chtm += '</tr>'+LF  //FECHA A LINHA
		
		//nTotDia += aResult[X,2]
		//nNaoLig += aResult[X,3]
		
		nTotGDia += aResult[X,2]
		nNaoGLig += aResult[X,3]
	
		li++	
        
	NEXT
	
	//nPercDia := (nNaoLig / nTotDia) * 100
	//TOTAL FILIAL
	/*
	chtm += '<tr>' + LF
	chtm += '<td width="300" align="center" colspan="3"><span class="style3"><b>TOTAL FILIAL ' + cNomeFil + '</b></span></td>'+LF
		    
	chtm += '<td width="300" align="center"><span class="style3"><b>'+ Transform(nTotDia, "@E 9999")  + '</b></span></td>'+LF
	chtm += '<td width="300" align="center"><span class="style3"><b>'+ Transform(nNaoLig, "@E 9999")  + '</b></span></td>'+LF
	chtm += '<td width="300" align="center"><span class="style3"><b>'+ Transform(nPercDia, "@E 999.99") + '</b></span></td>'+LF
	chtm += '</tr>'+LF  //FECHA A LINHA
	*/			 
	nPercDia := (nNaoGLig / nTotGDia) * 100
	//resumo
	chtm += '<tr>' + LF
	chtm += '<td width="300" align="center" colspan="2" ><span class="style3"><b>TOTAL GERAL</b></span></td>'+LF
    
	chtm += '<td width="300" align="center"><span class="style3"><b>'+ Transform(nTotGDia, "@E 9999")  + '</b></span></td>'+LF
	chtm += '<td width="300" align="center"><span class="style3"><b>'+ Transform(nNaoGLig, "@E 9999")  + '</b></span></td>'+LF
	chtm += '<td width="300" align="center"><span class="style3"><b>'+ Transform(nPercDia, "@E 999.99") + '</b></span></td>'+LF
	chtm += '</tr>'+LF  //FECHA A LINHA
	/////FECHA A TABELA DO HTML
	chtm += '</table><br>'	
	
Endif
////if do aresult > 0


//////FECHA O HTML PARA GRAVAÇÃO E ENVIO
chtm += '</body> '
chtm += '</html> '                     

//////GRAVA O HTML
Fwrite( nHandle, chtm, Len(chtm) )
FClose( nHandle )
nRet := 0
						
//////SELECIONA O EMAIL DESTINATÁRIO 
cMailTo := "marcelo@ravabrasil.com.br"     //RETIRAR                  
cCopia  := ""
cCorpo  := titulo
cAnexo  := cDirHTM + cArqHTM
cAssun  := titulo
//////ENVIA O HTML COMO ANEXO
//U_SendFatr11( cMailTo, cCopia, cAssun, cCorpo, cAnexo ) 
U_SendMailSC(cMailTo ,cCopia , cAssun, cCorpo,cAnexo )

XUD->( DbCloseArea() )

Reset environment

Return



