#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "


//--------------------------------------------------------------------------
//Programa: FATR015
//Objetivo: Gerar relatório das notas do cliente ATACADÃO que chegam no DIA
//			e enviar por email a João Emanuel.
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 25/05/2010
//--------------------------------------------------------------------------

User Function FATR015()

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
titulo    := "NOTAS FISCAIS ATACADAO COM CHEGADA HOJE "
cDesc1    := "Este programa ira emitir o relatorio "
cDesc2    := "das notas do cliente Atacadao "
cDesc3    := "com prev. chegada no dia."
cNatureza := ""
aReturn   := { "Producao", 1, "Administracao", 1, 2, 1, "", 1 }
nomeprog  := "FATR015"
cPerg     := "FTR015"
nLastKey  := 0
lContinua := .T.
nLin      := 9
wnrel     := "FATR015"
M_PAG     := 1
li		  := 80

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Habilitar somente para Schedule
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"

//Pergunte( cPerg, .F. )               // Pergunta no SX1
/*
cString := "SU6"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint( cString, wnrel, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se teclar ESC, sair³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLastKey == 27
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Posicao do Formulario na Impressora                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetDefault( aReturn, cString )

If nLastKey == 27
   Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento do Relatorio                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RptDetail()})  // Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
*/


RptDetail(Cabec1,Cabec2,Titulo,nLin)

Return



//------------------------------
Static Function RptDetail(Cabec1,Cabec2,Titulo,nLin)     
//------------------------------


Local aResult   := {}
Local LF      	:= CHR(13)+CHR(10)
Local chtm		:= ""
Local cDIRHTM	:= ""
Local cARQHTM	:= ""
Local nHandle	:= 0
Local nPag		:= 1
Local cNomredesp:= ""	




///seleciona somente as notas do cliente Atacadão = cnpj -> 75.315.333
cQuery := " SELECT F2_CLIENTE, F2_LOJA, A1_COD, A1_LOJA, A1_CGC, A1_NOME, F2_DOC, F2_SERIE, F2_EMISSAO,F2_PREVCHG, F2_DTEXP, F2_REALCHG, F2_TRANSP, F2_REDESP, " + LF    	  
cQuery += " A4_COD, A4_NREDUZ, ZZ_LOCAL, ZZ_DESC "+LF
cQuery += " FROM " + RetSqlName("SF2") + " SF2, "+LF
cQuery += " " + RetSqlName("SA1") + " SA1, "+ LF
cQuery += " " + RetSqlName("SA4") + " SA4, "+ LF
cQuery += " " + RetSqlName("SZZ") + " SZZ "+ LF
cQuery += " WHERE SF2.F2_PREVCHG = '" + Dtos(dDatabase) + "' " + LF
//cQuery += " WHERE SF2.F2_PREVCHG = '20100605' " + LF
cQuery += " AND RTRIM(F2_CLIENTE + F2_LOJA) = RTRIM(A1_COD + A1_LOJA) "+LF 
cQuery += " AND RTRIM(F2_TRANSP) = RTRIM(ZZ_TRANSP) "+LF 
cQuery += " AND RTRIM(F2_LOCALIZ) = RTRIM(ZZ_LOCAL) "+LF 
cQuery += " AND RTRIM(LEFT( A1_CGC,8 ) ) = '75315333' "+LF     //filtra pela raiz do cnpj do Atacadão
cQuery += " AND RTRIM(F2_TRANSP) = RTRIM(A4_COD) "+LF
cQuery += " AND SF2.D_E_L_E_T_ = ''"+ LF
cQuery += " AND SA4.D_E_L_E_T_ = ''"+ LF
cQuery += " AND SA1.D_E_L_E_T_ = ''"+LF
cQuery += " AND SZZ.D_E_L_E_T_ = ''"+ LF
cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ LF
cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"+ LF
//
cQuery += " AND SZZ.ZZ_FILIAL = '" + xFilial("SZZ") + "'"+ LF
//
cQuery += " AND F2_TIPO = 'N' "+LF
cQuery += " AND F2_SERIE <> '' "+LF
cQuery += " ORDER BY F2_DOC, F2_SERIE, F2_PREVCHG, F2_EMISSAO " + LF
cQuery := ChangeQuery( cQuery )
//MemoWrite("\TempQry\FATR015.sql", cQuery)

If Select("ATAC") > 0
	DbSelectArea("ATAC")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "ATAC"
TCSetField( 'ATAC', "F2_EMISSAO", "D" )
TCSetField( 'ATAC', "F2_PREVCHG", "D" )

ATAC->( DBGoTop() )
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


Do While !ATAC->( Eof() )  
    
 	cNomredesp := ""
 	If !Empty(ATAC->F2_REDESP)
 		SA4->(Dbsertorder(1))
 		SA4->(Dbseek(xFilial("SA4") + ATAC->F2_REDESP ))
 		cNomredesp := SA4->A4_NREDUZ
 	Endif
 		
	Aadd (aResult, {ATAC->F2_DOC,;  		//1
					ATAC->F2_SERIE,;		//2			  
	  				ATAC->F2_CLIENTE,;		//3
	  				ATAC->F2_LOJA,;         //4
	  				ATAC->A1_NOME  ,;		//5
					ATAC->F2_EMISSAO ,;    	//6
					ATAC->F2_PREVCHG,; 		//7
					ATAC->A4_NREDUZ,;     	//8
					cNomredesp,;			//9
					ATAC->ZZ_DESC } )		//10
  
 
  ATAC->( DbSkip() )

Enddo


If Len(aResult) <= 0
	//Alert("Não existem dados para os parâmetros informados, por favor, reveja os parâmetros !")
	DbselectArea("ATAC")
	DbcloseArea()
	Return
EndIF


/*
Cabec1 := "LISTA  DT.PREV    CODIGO    NOME CLIENTE                             OCORRÊNCIA"                                
Cabec2 := "       LIGAÇÃO   CLIENTE"
Cabec3 := ""

//         999999  99/99/99  999999/99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXX              
//         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//         0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        	    


*/

/////////////////
cDirHTM  := "\Temp\"    
cArqHTM  := "FATR015-" + Dtos(dDatabase) + ".HTM"    //relatório P/ Gerentes
nHandle  := fCreate( cDirHTM + cArqHTM, 0 )
nPag     := 1 
   
If nHandle = -1
     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
     Return
Endif

If Len(aResult) > 0

	/*
		cDirHTM  := "\Temp\"    
		cArqHTM  := "TMKR002F" + Dtos(dDatabase) + ".HTM"    //relatório P/ Gerentes
		nHandle  := fCreate( cDirHTM + cArqHTM, 0 )
		nPag     := 1    
		If nHandle = -1
		     MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
		     Return
		Endif
		
	*/	    

	FOR X := 1 TO Len(aResult)
			/*
			If lEnd
				@ li,000 PSAY "CANCELADO PELO OPERADOR"
				Exit
			EndIf
			*/
			
			If Li > 35
				//Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  //Impressao do cabecalho
				li := 9
				li++
				
				///prepara o html
				chtm := '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+LF
				chtm += '<html><head>'                                                         +LF 
				chtm += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+LF
				chtm += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+LF
				chtm += '<tr>    <td>'+LF
				chtm += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:12px;font-family:Verdana">'+LF
				chtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>RAVA EMBALAGENS INDUSTRIA COM. LTDA.</td>  <td></td>'+LF
				chtm += '<td align="right">Folha..:' + Str(nPag) + '</td></tr>'+LF
				chtm += '<tr>        <td>SIGA /FATR015/v.P10</td>'+LF
				chtm += '<td>'+titulo+'</td>'+LF
				chtm += '<td align="right">DT.Ref.:'+ Dtoc(dDatabase)+'</td>        </tr>        <tr>'+LF
				chtm += '<td>Hora...: '+ Time() + '</td>          <td></td>'+LF
				chtm += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr></table></head>'+LF
				chtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>'+LF
				chtm += '</table></head>'+LF
				
				chtm += '<table width="1100" border="1" style="font-size:12px;font-family:Verdana"><strong>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>NOTA</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>SERIE</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>CLIENTE</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>NOME</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>EMISSAO</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>PREV.CHEGADA</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>TRANSPORTADORA</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>REDESPACHO</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>LOCALIDADE</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><tr>'+LF
				
				nPag++
				
			Endif         
				
                
        chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,1] + '</span></td>'+LF
		chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,2] + '</span></td>'+LF
		chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,3] + "/" + aResult[X,4] + '</span></td>'+LF
		chtm += '<td width="900" align="center"><span class="style3">'+ aResult[X,5]  + '</span></td>'+LF
		chtm += '<td width="300" align="center"><span class="style3">'+ Dtoc(aResult[X,6])  + '</span></td>'+LF
		chtm += '<td width="300" align="center"><span class="style3">'+ Dtoc(aResult[X,7])  + '</span></td>'+LF
		chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,8] + '</span></td>'+LF
		chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,9] + '</span></td>'+LF
		chtm += '<td width="500" align="center"><span class="style3">'+ aResult[X,10] + '</span></td>'+LF
		chtm += '</tr>'+LF  //FECHA A LINHA 
		
		li++
			
        
	NEXT
	/////FECHA A TABELA DO HTML
	chtm += '</table><br>'	
	
Else
	
	///prepara o html
	chtm := '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+LF
	chtm += '<html><head>'                                                         +LF 
	chtm += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+LF
	chtm += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+LF
	chtm += '<tr>    <td>'+LF
	chtm += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:12px;font-family:Verdana">'+LF
	chtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>RAVA EMBALAGENS INDUSTRIA COM. LTDA.</td>  <td></td>'+LF
	chtm += '<td align="right">Folha..:' + Str(nPag) + '</td></tr>'+LF
	chtm += '<tr>        <td>SIGA /FATR015/v.P10</td>'+LF
	chtm += '<td>'+titulo+'</td>'+LF
	chtm += '<td align="right">DT.Ref.:'+ Dtoc(dDatabase)+'</td>        </tr>        <tr>'+LF
	chtm += '<td>Hora...: '+ Time() + '</td>          <td></td>'+LF
	chtm += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr></table></head>'+LF
	chtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>'+LF
	chtm += '</table></head>'+LF
			
	chtm += '<table width="1100" border="1" style="font-size:12px;font-family:Verdana"><strong>'+LF
	chtm += '<td ><div align="center"><span class="style3"><b>NOTA</span></div></b></td>'+LF
	chtm += '<td ><div align="center"><span class="style3"><b>SERIE</span></div></b></td>'+LF
	chtm += '<td ><div align="center"><span class="style3"><b>CLIENTE</span></div></b></td>'+LF
	chtm += '<td ><div align="center"><span class="style3"><b>NOME</span></div></b></td>'+LF
	chtm += '<td ><div align="center"><span class="style3"><b>EMISSAO</span></div></b></td>'+LF
	chtm += '<td ><div align="center"><span class="style3"><b>PREV.CHEGADA</span></div></b></td>'+LF
	chtm += '<td ><div align="center"><span class="style3"><b>TRANSPORTADORA</span></div></b></td>'+LF
	chtm += '<td ><div align="center"><span class="style3"><b>REDESPACHO</span></div></b></td>'+LF
	chtm += '<td ><div align="center"><span class="style3"><b>LOCALIDADE</span></div></b></td>'+LF
	chtm += '<td ><div align="center"><tr>'+LF
    chtm += '</table><br>'+LF
    
	chtm += "Não existem notas do Atacadão com chegada prevista para HOJE."+LF
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
cMailTo := "joao.emanuel@ravaembalagens.com.br"
//cMailTo := "flavia.rocha@ravaembalagens.com.br" 
//cCopia  := "flavia.rocha@ravaembalagens.com.br"
cCopia  := ""
cCorpo  := titulo
cAnexo  := cDirHTM + cArqHTM
cAssun  := titulo
//////ENVIA O HTML COMO ANEXO
U_SendFatr11( cMailTo, cCopia, cAssun, cCorpo, cAnexo ) 

ATAC->( DbCloseArea() )

//Roda( 0, "", TAMANHO )

/*
If aReturn[ 5 ] == 1
   Set Printer To
   Commit
   ourspool( wnrel ) //Chamada do Spool de Impressao - mostra na tela.
Endif
*/

//Msginfo("Processo finalizado")

// Habilitar somente para Schedule
Reset environment


Return NIL

