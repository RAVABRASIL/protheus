#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "


//--------------------------------------------------------------------------------------------
//Programa: TMKR003
//Objetivo: Mostrar o fechamento do mês, qto ao de ligações que não foram efetuadas. 
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 28/05/2010
//--------------------------------------------------------------------------

User Function TMKR003()

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
titulo    := "Fechto. Mensal - % Eficacia SAC"
cDesc1    := "Este programa ira emitir o relatorio "
cDesc2    := "do histórico de ligações do Call Center não "
cDesc3    := "efetuados na data prevista."
cNatureza := ""
aReturn   := { "Producao", 1, "Administracao", 1, 2, 1, "", 1 }
nomeprog  := "TMKR003"
cPerg     := "TMKR03"
nLastKey  := 0
lContinua := .T.
nLin      := 9
wnrel     := "TMKR003"
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

//dData2 := ctod("31/01/2014") 
//dData1 := ctod("01/01/2014") 


RptDetail(Cabec1,Cabec2,Titulo,nLin)  

//RAVA CAIXAS
//PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03"


//dData2 := dDatabase
//dData1 := dData2 - 30


//RptDetail(Cabec1,Cabec2,Titulo,nLin)

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



//Parâmetros:
//--------------------------------
// mv_par01 - Data de
// mv_par02 - Data até
//---------------------------------

Cabec1 := ""
Cabec2 := ""
Cabec3 := "" 
/*
cQuery := " SELECT *  " + LF    	  
cQuery += " FROM " + RetSqlName("ZU8") + " ZU8 "+LF
cQuery += " WHERE ZU8_DATA >= '" + Dtos(dData1) + "' AND ZU8_DATA <= '" + Dtos(dData2) + "' " + LF
cQuery += " AND ZU8.D_E_L_E_T_ = ''"+LF
//cQuery += " AND ZU8.ZU8_FILIAL = '" + xFilial("ZU8") + "'"+ LF
cQuery += " ORDER BY ZU8_FILIAL, ZU8_DATA " + LF
//cQuery := ChangeQuery( cQuery )
MemoWrite("C:\Temp\TMKR003.sql", cQuery)
*/

cQuery := " SELECT U6_DATA, U6_CODOPER, "
cQuery += " SUM(CASE WHEN U6_STATUS = 3 THEN 1 ELSE 0 END) REALIZ,"
cQuery += " SUM(CASE WHEN U6_STATUS = 1 THEN 1 ELSE 0 END) NAOREAL"
cQuery += " FROM " + RetSqlName("SU6") + " SU6 "
cQuery += " WHERE U6_DATA BETWEEN '" + Dtos(dData1) + "' AND '" + Dtos(dData2) + "' " 
cQuery += " AND D_E_L_E_T_ <> '*'"
cQuery += " AND U6_CODOPER <> ''"
cQuery += " GROUP BY U6_DATA, U6_CODOPER"
cQuery += " ORDER BY U6_DATA, U6_CODOPER"


If Select("ZZU8") > 0
	DbSelectArea("ZZU8")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "ZZU8"
TCSetField( 'ZZU8', "U6_DATA", "D" )


ZZU8->( DBGoTop() )
//SetRegua( Lastrec() )
mPag := 1

//TITULO := AllTrim( TITULO ) + "  " + Dtoc( MV_PAR01 ) + " A " + Dtoc( MV_PAR02 )
/*
If li > 58
	Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  //Impressao do cabecalho
	li := 9 
	nLin++
Endif
*/
aResult 	:= {}
cTipoLig	:= ""

/*
Do While !ZZU8->( Eof() )  
    
  	
  	If ZZU8->ZU8_TIPO = "F"
  		cTipoLig := "FeedBack Cliente"
  	Elseif ZZU8->ZU8_TIPO = "L"
  		cTipoLig := "Entregas"
  	Elseif ZZU8->ZU8_TIPO = "B"
  		cTipoLig := "Clientes Brasil"
  	Endif
  	
  	cTipoLig := "FeedBack Cliente"
	Aadd (aResult, {cTipoLig,;		  			//1
					ZZU8->ZU8_DATA,;			//2			  
	  				ZZU8->ZU8_TOTDIA,;  		//3
					ZZU8->ZU8_NAOLIG,;      	//4
					ZZU8->ZU8_PORCEN,;			//5
					ZZU8->ZU8_FILIAL } )		//6
  
 
  ZZU8->( DbSkip() )

Enddo
*/
/*
If Len(aResult) <= 0
	Alert("Não existem dados para os parâmetros informados, por favor, reveja os parâmetros !")
	DbselectArea("TKR")
	DbcloseArea()
	Return
EndIF
*/


/////////////////
chtm	 := ""
cDirHTM  := "\Temp\"    
cArqHTM  := "Efic_SAC_Mes_" + Strzero(Month(dData1),2) + ".HTM"  
nHandle  := fCreate( cDirHTM + cArqHTM, 0 )
nPag     := 1 
   
If nHandle = -1
     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
     Return
Endif

//If Len(aResult) > 0

	
	//FOR X := 1 TO Len(aResult)
	Do While !ZZU8->( Eof() )
					
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
				chtm += '<td ><div align="center"><span class="style3"><b>NOME</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>DATA PROGRAMADA PARA LIGAR</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>TOTAL LIGACOES PREVISTAS</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>QTD. NAO REALIZADA</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>% NAO REALIZADAS</span></div></b></td>'+LF
				//chtm += '<td ><div align="center"><tr>'+LF
				
				//chtm += '<tr>' + LF 
				//chtm += '<td width="300" align="LEFT" colspan="5" ><span class="style3">01 - RAVA EMB</span></td>'+LF   //filial
				//chtm += '</tr>'+ LF
				nPag++
				
			Endif 
     /*   	 	
        If x = 1
        	If Alltrim(aResult[X,6]) = '01'
        		cNomeFil := "01 - RAVA EMB"
        	Elseif Alltrim(aResult[X,6]) = '03'
        		cNomeFil := "03 - RAVA CAIXAS"  
        	Endif
        	
        	chtm += '<tr>' + LF 
        	chtm += '<td width="300" align="LEFT" colspan="6" ><span class="style3">'+ cNomeFil + '</span></td>'+LF   //filial
        	chtm += '</tr>'+ LF
	        	
        Endif
       */
	        
        //If X > 1
	    /*
	        If Alltrim(aResult[X,6]) != Alltrim(aResult[X - 1,6])
	        	If Alltrim(aResult[X-1,6]) = '01'
	        		cNomeFil := "01 - RAVA EMB"
	        	Elseif Alltrim(aResult[X-1,6]) = '03'
	        		cNomeFil := "03 - RAVA CAIXAS"  
	        	Endif
	        	
	        	nPercDia := (nNaoLig / nTotDia) * 100
				//TOTAL FILIAL
				chtm += '<tr>' + LF
				chtm += '<td width="300" align="center" colspan="3"><span class="style3"><b>TOTAL FILIAL ' + cNomeFil + '</b></span></td>'+LF
			    
				chtm += '<td width="300" align="center"><span class="style3"><b>'+ Transform(nTotDia, "@E 9999")  + '</b></span></td>'+LF
				chtm += '<td width="300" align="center"><span class="style3"><b>'+ Transform(nNaoLig, "@E 9999")  + '</b></span></td>'+LF
				chtm += '<td width="300" align="center"><span class="style3"><b>'+ Transform(nPercDia, "@E 999.99") + '</b></span></td>'+LF
				chtm += '</tr>'+LF  //FECHA A LINHA
				nTotDia := 0
				nNaoLig := 0
	        	
	        	
	        	If Alltrim(aResult[X,6]) = '01'
	        		cNomeFil := "01 - RAVA EMB"
	        	Elseif Alltrim(aResult[X,6]) = '03'
	        		cNomeFil := "03 - RAVA CAIXAS"  
	        	Endif
	        	
	        	chtm += '<tr>' + LF 
	        	chtm += '<td width="300" align="LEFT" colspan="6" ><span class="style3">01 - RAVA EMB</span></td>'+LF   //filial
	        	chtm += '</tr>'+ LF
	         Endif
        */
        //Endif
        
        /*
        chtm += '<tr>' + LF
        chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,6] + '</span></td>'+LF   //filial
        chtm += '<td width="300" align="LEFT"><span class="style3">'+ aResult[X,1] + '</span></td>'+LF   //tipo ligação
		chtm += '<td width="300" align="center"><span class="style3">'+ Dtoc(aResult[X,2]) + '</span></td>'+LF     //data programada para ligar
		chtm += '<td width="300" align="RIGHT"><span class="style3">'+ Transform(aResult[X,3], "@E 9999")  + '</span></td>'+LF    //qtde ligações no dia
		chtm += '<td width="300" align="RIGHT"><span class="style3">'+ Transform(aResult[X,4], "@E 9999")  + '</span></td>'+LF    //qtde não realiz no dia
		chtm += '<td width="300" align="RIGHT"><span class="style3">'+ Transform(aResult[X,5], "@E 999.99") + '</span></td>'+LF   //% nao realiz. no dia
		chtm += '</tr>'+LF  //FECHA A LINHA
		*/
		IF ZZU8->U6_CODOPER == '000017'
			cNome	:= "PABLO"
		Else
			cNome	:= "JOAO EMANOEL"
		EndIf
		
        chtm += '<tr>' + LF
//        chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,6] + '</span></td>'+LF   //filial
        chtm += '<td width="300" align="LEFT"><span class="style3">'+ cNome + '</span></td>'+LF   //tipo ligação
		chtm += '<td width="300" align="center"><span class="style3">'+ Dtoc(ZZU8->U6_DATA) + '</span></td>'+LF     //data programada para ligar
		chtm += '<td width="300" align="RIGHT"><span class="style3">'+ Transform(ZZU8->REALIZ + ZZU8->NAOREAL, "@E 9999")  + '</span></td>'+LF    //qtde ligações no dia
		chtm += '<td width="300" align="RIGHT"><span class="style3">'+ Transform(ZZU8->NAOREAL, "@E 9999")  + '</span></td>'+LF    //qtde não realiz no dia
		chtm += '<td width="300" align="RIGHT"><span class="style3">'+ Transform((ZZU8->NAOREAL/(ZZU8->REALIZ + ZZU8->NAOREAL))*100, "@E 999.99") + '</span></td>'+LF   //% nao realiz. no dia
		chtm += '</tr>'+LF  //FECHA A LINHA
		
		nTotDia += ZZU8->REALIZ + ZZU8->NAOREAL//aResult[X,3]
		nNaoLig += ZZU8->NAOREAL//aResult[X,4]
		
		nTotGDia += ZZU8->REALIZ + ZZU8->NAOREAL //aResult[X,3]
		nNaoGLig += ZZU8->NAOREAL//aResult[X,4]
	
		//li++	
        
		ZZU8->( DbSkip() )

	Enddo
	//NEXT
	
	nPercDia := (nNaoLig / nTotDia) * 100
	//TOTAL FILIAL
	chtm += '<tr>' + LF
	chtm += '<td width="300" align="center" colspan="2"><span class="style3"><b>TOTAL FILIAL 01 - RAVA EMB</b></span></td>'+LF
		    
	chtm += '<td width="300" align="center"><span class="style3"><b>'+ Transform(nTotDia, "@E 9999")  + '</b></span></td>'+LF
	chtm += '<td width="300" align="center"><span class="style3"><b>'+ Transform(nNaoLig, "@E 9999")  + '</b></span></td>'+LF
	chtm += '<td width="300" align="center"><span class="style3"><b>'+ Transform(nPercDia, "@E 999.99") + '</b></span></td>'+LF
	chtm += '</tr>'+LF  //FECHA A LINHA
				 
	nPercDia := (nNaoGLig / nTotGDia) * 100
	//resumo
	chtm += '<tr>' + LF
	chtm += '<td width="300" align="center" colspan="2"><span class="style3"><b>TOTAL GERAL</b></span></td>'+LF
    
	chtm += '<td width="300" align="center"><span class="style3"><b>'+ Transform(nTotGDia, "@E 9999")  + '</b></span></td>'+LF
	chtm += '<td width="300" align="center"><span class="style3"><b>'+ Transform(nNaoGLig, "@E 9999")  + '</b></span></td>'+LF
	chtm += '<td width="300" align="center"><span class="style3"><b>'+ Transform(nPercDia, "@E 999.99") + '</b></span></td>'+LF
	chtm += '</tr>'+LF  //FECHA A LINHA
	/////FECHA A TABELA DO HTML
	chtm += '</table><br>'	
	
//Endif
////if do aresult > 0


//////FECHA O HTML PARA GRAVAÇÃO E ENVIO
chtm += '</body> '
chtm += '</html> '                     

//////GRAVA O HTML
Fwrite( nHandle, chtm, Len(chtm) )
FClose( nHandle )
nRet := 0
						
//////SELECIONA O EMAIL DESTINATÁRIO 
cMailTo := "vendas@ravaembalagens.com.br"
cMailTo += ";marcelo@ravaembalagens.com.br"
cMailTo += ";gustavo@ravaembalagens.com.br"

cCopia  := ""
cCorpo  := titulo
cAnexo  := cDirHTM + cArqHTM
cAssun  := titulo
//////ENVIA O HTML COMO ANEXO
U_SendFatr11( cMailTo, cCopia, cAssun, cCorpo, cAnexo ) 




ZZU8->( DbCloseArea() )

//Msginfo("TMKR003 - Processo finalizado")

// Habilitar somente para Schedule
Reset environment


Return



