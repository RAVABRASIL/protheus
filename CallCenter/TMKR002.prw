#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "


//--------------------------------------------------------------------------
//Programa: TMKR002
//Objetivo: Mostrar a % de ligações que não foram efetuadas na data. 
//          (Somente feedbacks)
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 03/05/2010
//--------------------------------------------------------------------------

User Function TMKR002F()

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
titulo    := "FEEDBACKS - % Eficacia Diaria - Rava/Emb"
cDesc1    := "Este programa ira emitir o relatorio "
cDesc2    := "de % de feedbacks do Call Center não "
cDesc3    := "efetuados na data prevista."
cNatureza := ""
aReturn   := { "Producao", 1, "Administracao", 1, 2, 1, "", 1 }
nomeprog  := "TMKR002"
cPerg     := "TMKR02"
nLastKey  := 0
lContinua := .T.
nLin      := 9
wnrel     := "TMKR002"
M_PAG     := 1

//O schedule está agendado para executar as 03:00h - diariamente

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Habilitar somente para Schedule
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"



RptDetail(Cabec1,Cabec2,Titulo,nLin)

Return



//------------------------------
Static Function RptDetail(Cabec1,Cabec2,Titulo,nLin)     
//------------------------------


Local aResult   := {}
Local LF      	:= CHR(13)+CHR(10)
Local cU8Status := ""
Local dData1 := CtoD("  /  /    ")
Local dData2 := CtoD("  /  /    ") 

Local nTotLig := 0
Local nNaoRealiz := 0

Local chtm		:= ""
Local cDIRHTM	:= ""
Local cARQHTM	:= ""
Local nHandle	:= 0
Local nPag		:= 1	

Local nOcupado
Local nErro
Local nFalha 
Local nSemLin
Local nRealiz
Local li := 80

dData1 := (dDatabase - 1 )

//Parâmetros:
//--------------------------------
// mv_par01 - Data de
// mv_par02 - Data até
//---------------------------------

Cabec1 := "LISTA  DT.PREV    CODIGO    NOME CLIENTE                             OCORRÊNCIA"                                
Cabec2 := "       LIGAÇÃO   CLIENTE"
Cabec3 := ""

//         999999  99/99/99  999999/99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXX              
//         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//         0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        	    

////SELECIONA TODAS AS LIGAÇÕES DO SU6
/////ligações somente de feedback (U6_ORIGEM = '3')

cQuery := " SELECT COUNT(*) AS TOTAL_LIG " + LF    	  
cQuery += " FROM " + LF
cQuery += " " + RetSqlName("SU4") + " SU4, "+LF
cQuery += " " + RetSqlName("SU6") + " SU6, "+LF
cQuery += " " + RetSqlName("SF2") + " SF2, "+ LF
cQuery += " " + RetSqlName("SA1") + " SA1 "+ LF

cQuery += " WHERE " //U6_DATA = '" + Dtos(dData1) + "' " + LF
cQuery += " U4_DATA = '" + Dtos(dData1) + "'  " + LF
cQuery += " AND SU6.U6_LISTA = SU4.U4_LISTA " + LF
cQuery += " AND SU6.U6_FILIAL = SU4.U4_FILIAL " + LF

cQuery += " AND SU4.D_E_L_E_T_ = ''"+ LF
cQuery += " AND SU6.D_E_L_E_T_ = ''"+ LF
cQuery += " AND SA1.D_E_L_E_T_ = ''"+LF
cQuery += " AND SF2.D_E_L_E_T_ = ''"+LF

cQuery += " AND SU4.U4_FILIAL = '" + xFilial("SU4") + "'"+ LF
cQuery += " AND SU6.U6_FILIAL = '" + xFilial("SU6") + "'"+ LF
cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ LF
cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"+ LF
cQuery += " AND U6_CODENT = (A1_COD + A1_LOJA) "+LF

cQuery += " AND U6_ORIGEM = '3'"+LF	//SOMENTE FEEDBACK

cQuery += " AND U6_NFISCAL = F2_DOC " + LF
cQuery += " AND U6_SERINF = F2_SERIE " + LF
cQuery += " AND U6_TIPO = '5'"+LF

//cQuery += " AND U6_STATUS = '1'"+LF   //SE A LIGAÇÃO É DE ONTEM E O STATUS É = '1' É PORQUE NÃO FOI REALIZADA

cQuery += " AND U6_NFISCAL <> ''"+LF
//ESTAS PODEM ENTRAR NO TOTAL
//cQuery += " AND U6_LIGPROB <> 'S'  "+LF
//cQuery += " AND U6_RETENC <> 'S'  "+LF         //QUE NÃO SEJAM DE NOTAS COM RETENÇÃO
//cQuery += " AND U6_DTAGCLI = '' "+LF           //QUE NÃO SEJAM DE NOTAS COM AGENDAMENTO 


MemoWrite("C:\Temp\TOT_LIG.sql", cQuery) 

If Select("TOT") > 0
	DbSelectArea("TOT")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TOT"

TOT->( DBGoTop() )

/*
Local nOcupado
Local nErro
Local nFalha 
Local nSemLin
Local nRealiz
Local nTotLig
Local nNaoRealiz

*/


Do While !TOT->( Eof() )
	nTotLig := TOT->TOTAL_LIG
	TOT->(Dbskip())
Enddo

DbSelectArea("TOT")
DbCloseArea()

//já tenho o total de ligações 
//agora preciso capturar deste total, o que não foi realizado, 
//e dentro do que não foi realizado, se foi por motivo normal (operador) ou fora do que o operador pudesse
//realizar, ex.: ocupado (não entra na contagem)
cQuery := " SELECT Count(*) AS NAOREALIZ " + LF //U6_LISTA , U6_DATA, U6_CODENT, U6_NFISCAL, A1_NOME " + LF    	  
cQuery += " FROM " + LF
cQuery += " " + RetSqlName("SU4") + " SU4, "+LF
cQuery += " " + RetSqlName("SU6") + " SU6, "+LF
cQuery += " " + RetSqlName("SF2") + " SF2, "+ LF
cQuery += " " + RetSqlName("SUC") + " SUC, "+ LF
cQuery += " " + RetSqlName("SA1") + " SA1 "+ LF

cQuery += " WHERE " //U6_DATA = '" + Dtos(dData1) + "' " + LF
cQuery += " U4_DATA = '" + Dtos(dData1) + "' " + LF
cQuery += " AND SU6.U6_LISTA = SU4.U4_LISTA " + LF
cQuery += " AND SU6.U6_FILIAL = SU4.U4_FILIAL " + LF
cQuery += " AND SU6.U6_NFISCAL = SUC.UC_NFISCAL " + LF
cQuery += " AND SU6.U6_FILIAL = SUC.UC_FILIAL " + LF


cQuery += " AND SU4.D_E_L_E_T_ = ''"+ LF
cQuery += " AND SU6.D_E_L_E_T_ = ''"+ LF
cQuery += " AND SA1.D_E_L_E_T_ = ''"+LF
cQuery += " AND SF2.D_E_L_E_T_ = ''"+LF
cQuery += " AND SUC.D_E_L_E_T_ = ''"+LF

cQuery += " AND SU4.U4_FILIAL = '" + xFilial("SU4") + "'"+ LF
cQuery += " AND SU6.U6_FILIAL = '" + xFilial("SU6") + "'"+ LF
cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ LF
cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"+ LF
cQuery += " AND SUC.UC_FILIAL = '" + xFilial("SUC") + "'"+ LF

cQuery += " AND U6_CODENT = (A1_COD + A1_LOJA) "+LF

cQuery += " AND U6_ORIGEM = '3'"+LF	//SOMENTE FEEDBACK

cQuery += " AND U6_NFISCAL = F2_DOC " + LF
cQuery += " AND U6_SERINF = F2_SERIE " + LF
cQuery += " AND U6_TIPO = '5'"+LF

cQuery += " AND U6_STATUS = '1'"+LF   //SE A LIGAÇÃO É DE ONTEM E O STATUS É = '1' É PORQUE NÃO FOI REALIZADA
cQuery += " AND U4_STATUS = '1'"+LF   //SE A LIGAÇÃO É DE ONTEM E O STATUS É = '1' É PORQUE NÃO FOI REALIZADA

cQuery += " AND U6_NFISCAL <> ''"+LF
cQuery += " AND U6_LIGPROB <> 'S'  "+LF
cQuery += " AND U6_RETENC <> 'S'  "+LF
cQuery += " AND U6_DTAGCLI = '' "+LF
cQuery += " AND F2_RETENC <> 'S'  "+LF
cQuery += " AND F2_DTAGCLI = '' "+LF
cQuery += " AND SUC.UC_REATIVA <> 'S' " + LF
//cQuery += " ORDER BY U6_LISTA, U6_DATA " + LF
MemoWrite("C:\Temp\NAO_LIG.sql", cQuery) 

If Select("NAOREA") > 0
	DbSelectArea("NAOREA")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "NAOREA"
//TCSetField( 'TKR', "U6_DATA", "D" )
//TCSetField( 'TKR', "U8_DATA", "D" )

NAOREA->( DBGoTop() )

nNaoRealiz := 0 

Do While !NAOREA->( Eof() )        

	nNaoRealiz := NAOREA->NAOREALIZ
	NAOREA->(Dbskip())	 	  
Enddo 
DbSelectArea("NAOREA")
DbCloseArea()	
 	
/////capturar as ligações que tenham link com a SU8 - onde fica registrado o motivo da não realização

cQuery := " SELECT U6_STATUS,U8_STATUS, " + LF  
cQuery += " CASE WHEN U8_STATUS ='1' THEN 'OCUPADO'  " + LF  
cQuery += " ELSE   " + LF  
cQuery += " CASE WHEN U8_STATUS ='2' THEN 'ERRO' " + LF  
cQuery += " ELSE  " + LF  
cQuery += " CASE WHEN U8_STATUS = '3' THEN 'FALHA' " + LF  
cQuery += " ELSE  " + LF  
cQuery += " CASE WHEN U8_STATUS = '4' THEN 'SEM LINHA' " + LF  
cQuery += " ELSE " + LF  
cQuery += " CASE WHEN U8_STATUS = '5' THEN 'EXECUTADO' " + LF  
cQuery += " ELSE " + LF  
cQuery += " 'NAO REALIZADO' " + LF  
cQuery += " END " + LF  
cQuery += " END " + LF  
cQuery += " END " + LF  
cQuery += " END " + LF  
cQuery += " END AS MOTIVO " + LF 
 
cQuery += " ,U6_LISTA, U6_DATA, U6_NFISCAL, U8_CRONUM, U8_DATA, U8_STATUS, U6_CODENT, A1_NOME " + LF    	  
cQuery += " FROM " + LF 
cQuery += " " + RetSqlName("SF2") + " SF2, "+LF
cQuery += " " + RetSqlName("SA1") + " SA1, "+ LF
cQuery += " " + RetSqlName("SU4") + " SU4, "+ LF
cQuery += " " + RetSqlName("SUC") + " SUC, "+ LF
cQuery += " " + RetSqlName("SU6") + " SU6 "+LF

cQuery += " LEFT JOIN " + RetSqlName("SU8") + " SU8 " + LF
cQuery += " ON SU6.U6_LISTA = SU8.U8_CRONUM AND SU8.D_E_L_E_T_ = '' AND SU8.U8_FILIAL = '" + xFilial("SU8") + "' " + LF
cQuery += " AND U6_CODIGO = U8_CONTATO"+LF

cQuery += " WHERE " //U6_DATA = '" + Dtos(dData1) + "' " + LF
cQuery += " U4_DATA = '" + Dtos(dData1) + "' " + LF
cQuery += " AND SU6.U6_LISTA = SU4.U4_LISTA " + LF  
cQuery += " AND SU6.U6_FILIAL = SU4.U4_FILIAL " + LF
cQuery += " AND SU6.U6_NFISCAL = SUC.UC_NFISCAL " + LF  
cQuery += " AND SU6.U6_FILIAL = SUC.UC_FILIAL " + LF

cQuery += " AND SU4.D_E_L_E_T_ = ''"+ LF
cQuery += " AND SU6.D_E_L_E_T_ = ''"+ LF
cQuery += " AND SF2.D_E_L_E_T_ = ''"+LF
cQuery += " AND SA1.D_E_L_E_T_ = ''"+LF
cQuery += " AND SUC.D_E_L_E_T_ = ''"+LF

cQuery += " AND SU4.U4_FILIAL = '" + xFilial("SU4") + "'"+ LF
cQuery += " AND SU6.U6_FILIAL = '" + xFilial("SU6") + "'"+ LF
cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ LF
cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"+ LF
cQuery += " AND SUC.UC_FILIAL = '" + xFilial("SUC") + "'"+ LF

cQuery += " AND U6_NFISCAL = F2_DOC"+LF
cQuery += " AND U6_SERINF = F2_SERIE"+LF
cQuery += " AND U6_CODENT = (A1_COD + A1_LOJA) "+LF
cQuery += " AND U6_ORIGEM = '3'"+LF
cQuery += " AND U6_STATUS = '1'"+LF
cQuery += " AND U6_TIPO = '5'"+LF
cQuery += " AND U6_NFISCAL <> ''"+LF
cQuery += " AND U6_LIGPROB <> 'S'  "+LF
cQuery += " AND U6_RETENC <> 'S'  "+LF
cQuery += " AND U6_DTAGCLI = '' "+LF
cQuery += " AND F2_RETENC <> 'S'  "+LF
cQuery += " AND F2_DTAGCLI = '' "+LF
//cQuery += " AND U8_STATUS <> '1'"+LF
//cQuery += " AND U8_STATUS <> '2'"+LF
//cQuery += " AND U8_STATUS <> '3'"+LF
//cQuery += " AND U8_STATUS <> '4'"+LF
//cQuery += " AND U8_STATUS <> '5'"+LF
cQuery += " AND SUC.UC_REATIVA <> 'S' " + LF

cQuery += " ORDER BY U6_LISTA, U6_DATA " + LF
MemoWrite("C:\Temp\SU8_MOTIV.sql", cQuery) 
If Select("SU8XX") > 0
	DbSelectArea("SU8XX")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "SU8XX"
TCSetField( 'SU8XX', "U6_DATA", "D" )
TCSetField( 'SU8XX', "U8_DATA", "D" )

SU8XX->( DBGoTop() )

nOcupado:= 0
nErro   := 0
nFalha  := 0
nSemLin := 0


Do While !SU8XX->( Eof() )  	
 	
 	If SU8XX->U8_STATUS = '1'
 		cU8Status := "Ocupado"
 		nOcupado++
 	Elseif SU8XX->U8_STATUS = '2'
 		cU8Status := "Erro"
 		nErro++
 	Elseif SU8XX->U8_STATUS = '3'
 		cU8Status := "Falha"
 		nFalha++
 	Elseif SU8XX->U8_STATUS = '4'
 		cU8Status := "Sem Linha"
 		nSemLin++
 	//Case SU8XX->U8_STATUS = '5'
 		//cU8Status := "Executado"
 		//nRealiz++
 	//Elseif SU8XX->U8_STATUS = '6'
 	//	cU8Status := "Excluido"
 	//Elseif SU8XX->U8_STATUS = '7'
 	//	cU8Status := "Enviado"
 	//Elseif SU8XX->U8_STATUS = '8'
 	//	cU8Status := "Impresso"
 	Else
 		cU8Status := "Nao Realizado"
 	Endif
 	
 	
	Aadd (aResult, {SU8XX->U6_LISTA,;  														//1
					SU8XX->U6_DATA,;	  													//2			  
	  				cU8Status  ,;      														//3
					Substr(SU8XX->U6_CODENT,1,6) + "/" + Substr(SU8XX->U6_CODENT,7,2)  ,;   //4
					Alltrim(SU8XX->A1_NOME),;                                               //5
					SU8XX->U6_NFISCAL	  } )												//6
  
    
  SU8XX->( DbSkip() )

Enddo
DbSelectArea("SU8XX")
DbCloseArea()

nNaoRealiz := nNaoRealiz - (nOcupado + nErro + nSemLin)

mPag := 1

//CRIA O HTML
//A PRIMEIRA PARTE MOSTRA AS LIGAÇÕES NÃO REALIZADAS UMA POR UMA E SEUS MOTIVOS
/////////////////
chtm	 := ""
cDirHTM  := "\Temp\"    
cArqHTM  := "FB_" + Dtos(dData1) + ".HTM"    
nHandle  := fCreate( cDirHTM + cArqHTM, 0 )
nPag     := 1 
   
If nHandle = -1
     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
     Return
Endif

chtm := ""
Li := 80


		
		/*
		Aadd (aResult, {SU8XX->U6_LISTA,;  														//1
					SU8XX->U6_DATA,;	  													//2			  
	  				cU8Status  ,;      														//3
					Substr(SU8XX->U6_CODENT,1,6) + "/" + Substr(SU8XX->U6_CODENT,7,2)  ,;   //4
					Alltrim(SU8XX->A1_NOME),;                                               //5
					SU8XX->U6_NFISCAL	  } )												//6
  
		
		*/      
		
If Len(aResult) > 0
	chtm := ""
	FOR X := 1 TO Len(aResult)
	
		If Li > 58
			Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  //Impressao do cabecalho
			li := 9
		
			///prepara o html
			chtm += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+LF
			chtm += '<html><head>'                                                         +LF 
			chtm += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+LF
			chtm += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+LF
			chtm += '<tr>    <td>'+LF
			chtm += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:12px;font-family:Verdana">'+LF
			chtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>RAVA EMBALAGENS INDUSTRIA COM. LTDA.</td>  <td></td>'+LF
			chtm += '<td align="right">Folha..:' + Str(nPag) + '</td></tr>'+LF
			chtm += '<tr>        <td>SIGA /TMKR002F/v.P10</td>'+LF
			chtm += '<td>'+titulo+'</td>'+LF
			chtm += '<td align="right">DT.Ref.:'+ Dtoc(dData1)+'</td>        </tr>        <tr>'+LF
			chtm += '<td>Hora...: '+ Time() + '</td>          <td></td>'+LF
			chtm += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr></table></head>'+LF
			chtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>'+LF
			chtm += '</table></head>'+LF
						
			chtm += '<table width="1100" border="1" style="font-size:12px;font-family:Verdana"><strong>'+LF
			chtm += '<td ><div align="center"><span class="style3"><b>LISTA</span></div></b></td>'+LF
			chtm += '<td ><div align="center"><span class="style3"><b>DATA PROGRAMADA PARA LIGAR</span></div></b></td>'+LF
			chtm += '<td ><div align="center"><span class="style3"><b>NOTA FISCAL</span></div></b></td>'+LF
			chtm += '<td ><div align="center"><span class="style3"><b>COD.CLIENTE</span></div></b></td>'+LF
			chtm += '<td ><div align="center"><span class="style3"><b>NOME CLIENTE</span></div></b></td>'+LF
			chtm += '<td ><div align="center"><span class="style3"><b>STATUS/OCORRENCIA</span></div></b></td>'+LF
			chtm += '<td ><div align="center"></tr>'+LF
					
			nPag++
						
		Endif 
        
		If nNaoRealiz > 0
	        chtm += '<tr>' + LF      
	        chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,1] + '</span></td>'+LF
			chtm += '<td width="300" align="center"><span class="style3">'+ Dtoc(aResult[X,2]) + '</span></td>'+LF
			chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,6]  + '</span></td>'+LF
			chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,4]  + '</span></td>'+LF
			chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,5]  + '</span></td>'+LF
			chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,3] + '</span></td>'+LF
			chtm += '</tr>'+LF  //FECHA A LINHA
			li++
		Endif	
        
	NEXT
	/////FECHA A TABELA DO HTML
	//chtm += '</table><br>'
	
	Fwrite( nHandle, chtm, Len(chtm) )
	chtm := ""	
	
Endif

If Li > 58
	Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  //Impressao do cabecalho
	li := 9

	///prepara o html
	chtm += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+LF
	chtm += '<html><head>'                                                         +LF 
	chtm += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+LF
	chtm += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+LF
	chtm += '<tr>    <td>'+LF
	chtm += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:12px;font-family:Verdana">'+LF
	chtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>RAVA EMBALAGENS INDUSTRIA COM. LTDA.</td>  <td></td>'+LF
	chtm += '<td align="right">Folha..:' + Str(nPag) + '</td></tr>'+LF
	chtm += '<tr>        <td>SIGA /TMKR002F/v.P10</td>'+LF
	chtm += '<td>'+titulo+'</td>'+LF
	chtm += '<td align="right">DT.Ref.:'+ Dtoc(dData1)+'</td>        </tr>        <tr>'+LF
	chtm += '<td>Hora...: '+ Time() + '</td>          <td></td>'+LF
	chtm += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr></table></head>'+LF
	chtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>'+LF
	chtm += '</table></head>'+LF
	
				
	nPag++
				
Endif 


/////FECHA A TABELA DO HTML
chtm += '</table><br>'

///resumo total no fim do relatório 
//O RESUMO MOSTRA O TOTAL DE LIGAÇÕES, O TOTAL NÃO REALIZADO E A %CUMPRIMENTO

chtm += '<br>' + LF
///GRAVA O RESUMO NO HTML	
chtm += '<table width="300" border="1" style="font-size:12px;font-family:Verdana"><strong>'+LF
chtm += '<td colspan="2"><div align="center"><span class="style3"><b>RESUMO do DIA: '+ Dtoc(dData1)+'</span></div></b></td></tr>'+LF
chtm += '<td ><div align="center"><span class="style3"><b>TOTAL PREVISTO:</span></div></b></td>'+LF
chtm += '<td ><div align="center"><span class="style3"><b>'+ Transform(nTotLig, "@E 9,999")+'</span></div></b></td></tr>'+LF
chtm += '<td ><div align="center"><span class="style3"><b>NAO REALIZADO</span></div></b></td>'+LF
chtm += '<td ><div align="center"><span class="style3"><b>'+ Transform(nNaoRealiz, "@E 9,999") +'</span></div></b></td></tr>'+LF
chtm += '<td ><div align="center"><span class="style3"><b>PORCENTAGEM nao Realiz:</span></div></b></td>'+LF
chtm += '<td ><div align="center"><span class="style3"><b>'+ Transform( ( (nNaoRealiz / nTotLig) * 100), "@E 999.99") +'</span></div></b></td></tr>'+LF
chtm += '<td ><div align="center"><tr>'+LF
		
/////FECHA A TABELA DO HTML
chtm += '</table><br>'
		
//////FECHA O HTML PARA GRAVAÇÃO E ENVIO
chtm += '</body> '
chtm += '</html> '
//////GRAVA O HTML
Fwrite( nHandle, chtm, Len(chtm) )
FClose( nHandle )
//nRet := 0
						
//////SELECIONA O EMAIL DESTINATÁRIO 
//cMailTo := "posvendas@ravaembalagens.com.br" 
cMailTo := "daniela@ravaembalagens.com.br"  //solicitado em 13/06/11, por Daniela, o envio apenas para o email dela
//cMailTo := "flavia.rocha@ravaembalagens.com.br"
cCopia  := ""  //"flavia.rocha@ravaembalagens.com.br" 
cCorpo  := titulo
cAnexo  := cDirHTM + cArqHTM
cAssun  := titulo
//////ENVIA O HTML COMO ANEXO
U_SendFatr11( cMailTo, cCopia, cAssun, cCorpo, cAnexo ) 

//Roda( 0, "", TAMANHO )


//Msginfo("Processo finalizado")

// Habilitar somente para Schedule
Reset environment


Return NIL

*****************************
User Function TMKR002L()
*****************************

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
titulo    := "LISTA POS-VENDAS - % Eficacia Diaria - Rava/Emb"
cDesc1    := "Este programa ira emitir o relatorio "
cDesc2    := "de % de ligações da lista do Call Center não "
cDesc3    := "efetuados na data prevista."
cNatureza := ""
aReturn   := { "Producao", 1, "Administracao", 1, 2, 1, "", 1 }
nomeprog  := "TMKR002L"
cPerg     := "TMKR02"
nLastKey  := 0
lContinua := .T.
nLin      := 9
wnrel     := "TMKR002L"
M_PAG     := 1



//Habilitar somente para Schedule
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"


fRptDetail(Cabec1,Cabec2,Titulo,nLin)

Return



//------------------------------
Static Function fRptDetail(Cabec1,Cabec2,Titulo,nLin)     
//------------------------------


Local aResult   := {}
Local LF      	:= CHR(13)+CHR(10)
Local cU8Status := ""
Local dDataum := CtoD("  /  /    ")
Local dDatadois := CtoD("  /  /    ") 

Local nTotLig := 0
Local nNaoRealiz := 0

Local chtm		:= ""
Local cDIRHTM	:= ""
Local cARQHTM	:= ""
Local nHandle	:= 0
Local nPag		:= 1	

Local nOcupado
Local nErro
Local nFalha 
Local nSemLin
Local nRealiz
Local li		  := 80

dDataum := (dDatabase - 1 )
//dDataum := Ctod("02/07/2012")


//Parâmetros:
//--------------------------------
// mv_par01 - Data de
// mv_par02 - Data até
//---------------------------------

Cabec1 := "LISTA  DT.PREV    CODIGO    NOME CLIENTE                             OCORRÊNCIA"                                
Cabec2 := "       LIGAÇÃO   CLIENTE"
Cabec3 := ""

//         999999  99/99/99  999999/99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXX              
//         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//         0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        	    

////SELECIONA TODAS AS LIGAÇÕES DO SU6
/////ligações somente de LISTA (U6_ORIGEM = '1')

cQuery := " SELECT COUNT(*) AS TOTAL_LIG " + LF    	  
cQuery += " FROM " + LF
cQuery += " " + RetSqlName("SU4") + " SU4, "+LF
cQuery += " " + RetSqlName("SU6") + " SU6, "+LF
cQuery += " " + RetSqlName("SF2") + " SF2, "+ LF
cQuery += " " + RetSqlName("SA1") + " SA1 "+ LF

cQuery += " WHERE " + LF
//cQuery += " U6_DATA = '" + Dtos(dDataum) + "' " + LF
cQuery += " U4_DATA = '" + Dtos(dDataum) + "' " + LF
cQuery += " AND SU6.U6_LISTA = SU4.U4_LISTA " + LF
cQuery += " AND SU6.U6_FILIAL = SU4.U4_FILIAL " + LF

cQuery += " AND SU4.D_E_L_E_T_ = ''"+ LF
cQuery += " AND SU6.D_E_L_E_T_ = ''"+ LF
cQuery += " AND SA1.D_E_L_E_T_ = ''"+LF
cQuery += " AND SF2.D_E_L_E_T_ = ''"+LF

cQuery += " AND SU6.U6_FILIAL = '" + xFilial("SU6") + "'"+ LF
cQuery += " AND SU4.U4_FILIAL = '" + xFilial("SU4") + "'"+ LF
cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ LF
cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"+ LF

cQuery += " AND U6_CODENT = (A1_COD + A1_LOJA) "+LF

cQuery += " AND U6_ORIGEM = '1'"+LF	//SOMENTE LISTA

cQuery += " AND U6_NFISCAL = F2_DOC " + LF
cQuery += " AND U6_SERINF = F2_SERIE " + LF
cQuery += " AND U6_TIPO = '1' "+LF

//cQuery += " AND U6_STATUS = '1'"+LF   //SE A LIGAÇÃO É DE ONTEM E O STATUS É = '1' É PORQUE NÃO FOI REALIZADA

cQuery += " AND U6_NFISCAL <> ''"+LF 
//estas PODEM ENTRAR NO TOTAL
//cQuery += " AND U6_LIGPROB <> 'S'  "+LF
//cQuery += " AND U6_RETENC <> 'S'  "+LF         //QUE NÃO SEJAM DE NOTAS COM RETENÇÃO
//cQuery += " AND U6_DTAGCLI = '' "+LF           //QUE NÃO SEJAM DE NOTAS COM AGENDAMENTO 


MemoWrite("C:\Temp\TOT_LIG.sql", cQuery) 

If Select("TOT") > 0
	DbSelectArea("TOT")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TOT"

TOT->( DBGoTop() )

/*
Local nOcupado
Local nErro
Local nFalha 
Local nSemLin
Local nRealiz
Local nTotLig
Local nNaoRealiz

*/              

nOcupado	:= 0
nErro		:= 0
nFalha 		:= 0
nSemLin		:= 0
nRealiz		:= 0


Do While !TOT->( Eof() )
	nTotLig := TOT->TOTAL_LIG
	TOT->(Dbskip())
Enddo

DbSelectArea("TOT")
DbCloseArea()

//já tenho o total de ligações 
//agora preciso capturar deste total, o que não foi realizado, 
//e dentro do que não foi realizado, se foi por motivo normal (operador) ou fora do que o operador pudesse
//realizar, ex.: ocupado (não entra na contagem)
cQuery := " SELECT Count(*) AS NAOREALIZ " + LF //U6_LISTA , U6_DATA, U6_CODENT, U6_NFISCAL, A1_NOME " + LF    	  
cQuery += " FROM " + LF
cQuery += " " + RetSqlName("SU4") + " SU4, "+LF
cQuery += " " + RetSqlName("SU6") + " SU6, "+LF
cQuery += " " + RetSqlName("SF2") + " SF2, "+ LF
cQuery += " " + RetSqlName("SA1") + " SA1 "+ LF

cQuery += " WHERE " + LF
//cQuery += " U6_DATA = '" + Dtos(dDataum) + "' " + LF
cQuery += " U4_DATA = '" + Dtos(dDataum) + "' " + LF
cQuery += " AND SU6.U6_LISTA = SU4.U4_LISTA " + LF 
cQuery += " AND SU6.U6_FILIAL = SU4.U4_FILIAL " + LF

cQuery += " AND SU4.D_E_L_E_T_ = ''"+ LF
cQuery += " AND SU6.D_E_L_E_T_ = ''"+ LF
cQuery += " AND SA1.D_E_L_E_T_ = ''"+LF
cQuery += " AND SF2.D_E_L_E_T_ = ''"+LF

cQuery += " AND SU4.U4_FILIAL = '" + xFilial("SU4") + "'"+ LF
cQuery += " AND SU6.U6_FILIAL = '" + xFilial("SU6") + "'"+ LF
cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ LF
cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"+ LF

cQuery += " AND U6_CODENT = (A1_COD + A1_LOJA) "+LF

cQuery += " AND U6_ORIGEM = '1'"+LF	//SOMENTE FEEDBACK

cQuery += " AND U6_NFISCAL = F2_DOC " + LF
cQuery += " AND U6_SERINF = F2_SERIE " + LF
cQuery += " AND U6_TIPO = '1'"+LF		//TIPO 1 = MARKETING / TIPO = 5 = FEEDBACK

cQuery += " AND U6_STATUS = '1'"+LF   //SE A LIGAÇÃO É DE ONTEM E O STATUS É = '1' É PORQUE NÃO FOI REALIZADA
cQuery += " AND U4_STATUS = '1'"+LF   //SE A LIGAÇÃO É DE ONTEM E O STATUS É = '1' É PORQUE NÃO FOI REALIZADA

cQuery += " AND U6_NFISCAL <> ''"+LF
cQuery += " AND U6_LIGPROB <> 'S'  "+LF
cQuery += " AND U6_RETENC <> 'S'  "+LF
cQuery += " AND U6_DTAGCLI = '' "+LF
MemoWrite("C:\Temp\1nao_realiz.sql", cQuery) 
If Select("NAOREA") > 0
	DbSelectArea("NAOREA")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "NAOREA"
//TCSetField( 'TKR', "U6_DATA", "D" )
//TCSetField( 'TKR', "U8_DATA", "D" )

NAOREA->( DBGoTop() )

nNaoRealiz := 0 

Do While !NAOREA->( Eof() )        

	nNaoRealiz := NAOREA->NAOREALIZ
	NAOREA->(Dbskip())	 	  
Enddo 
DbSelectArea("NAOREA")
DbCloseArea()	
 	
/////capturar as ligações que tenham link com a SU8 - onde fica registrado o motivo da não realização

cQuery := " SELECT U6_STATUS,U8_STATUS, " + LF  
cQuery += " CASE WHEN U8_STATUS ='1' THEN 'OCUPADO'  " + LF  
cQuery += " ELSE   " + LF  
cQuery += " CASE WHEN U8_STATUS ='2' THEN 'ERRO' " + LF  
cQuery += " ELSE  " + LF  
cQuery += " CASE WHEN U8_STATUS = '3' THEN 'FALHA' " + LF  
cQuery += " ELSE  " + LF  
cQuery += " CASE WHEN U8_STATUS = '4' THEN 'SEM LINHA' " + LF  
cQuery += " ELSE " + LF  
cQuery += " CASE WHEN U8_STATUS = '5' THEN 'EXECUTADO' " + LF  
cQuery += " ELSE " + LF  
cQuery += " 'NAO REALIZADO' " + LF  
cQuery += " END " + LF  
cQuery += " END " + LF  
cQuery += " END " + LF  
cQuery += " END " + LF  
cQuery += " END AS MOTIVO " + LF 
 
cQuery += " ,U6_LISTA, U6_DATA, U6_NFISCAL, U8_CRONUM, U8_DATA, U8_STATUS, U6_CODENT, A1_NOME " + LF    	  
cQuery += " FROM " + LF 
cQuery += " " + RetSqlName("SF2") + " SF2, "+LF
cQuery += " " + RetSqlName("SA1") + " SA1, "+ LF
cQuery += " " + RetSqlName("SU4") + " SU4, "+ LF
cQuery += " " + RetSqlName("SU6") + " SU6 "+LF

cQuery += " LEFT JOIN " + RetSqlName("SU8") + " SU8 " + LF
cQuery += " ON SU6.U6_LISTA = SU8.U8_CRONUM AND SU8.D_E_L_E_T_ = '' AND SU8.U8_FILIAL = '" + xFilial("SU8") + "' " + LF
cQuery += " AND U6_CODIGO = U8_CONTATO"+LF

cQuery += " WHERE " + LF
//cQuery += " U6_DATA = '" + Dtos(dDataum) + "' " + LF
cQuery += " U4_DATA = '" + Dtos(dDataum) + "' " + LF
cQuery += " AND SU6.U6_LISTA = SU4.U4_LISTA " + LF
cQuery += " AND SU6.U6_FILIAL = SU4.U4_FILIAL " + LF

cQuery += " AND SU4.D_E_L_E_T_ = ''"+ LF
cQuery += " AND SU6.D_E_L_E_T_ = ''"+ LF
cQuery += " AND SF2.D_E_L_E_T_ = ''"+LF
cQuery += " AND SA1.D_E_L_E_T_ = ''"+LF

cQuery += " AND SU4.U4_FILIAL = '" + xFilial("SU4") + "'"+ LF
cQuery += " AND SU6.U6_FILIAL = '" + xFilial("SU6") + "'"+ LF
cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ LF
cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"+ LF


cQuery += " AND U6_NFISCAL = F2_DOC"+LF
cQuery += " AND U6_SERINF = F2_SERIE"+LF
cQuery += " AND (U6_CODENT) = (A1_COD + A1_LOJA) "+LF

cQuery += " AND U6_ORIGEM = '1'"+LF //ORIGEM = 1 -> LISTA
cQuery += " AND U6_TIPO = '1'"+LF  	//TIPO = 1 -> LISTA

cQuery += " AND U6_STATUS = '1'"+LF
cQuery += " AND U4_STATUS = '1'"+LF

cQuery += " AND U6_NFISCAL <> ''"+LF
cQuery += " AND U6_LIGPROB <> 'S'  "+LF
cQuery += " AND U6_RETENC <> 'S'  "+LF
cQuery += " AND U6_DTAGCLI = '' "+LF
cQuery += " AND F2_RETENC <> 'S'  "+LF
cQuery += " AND F2_DTAGCLI = '' "+LF
//cQuery += " AND U8_STATUS <> '1'"+LF
//cQuery += " AND U8_STATUS <> '2'"+LF
//cQuery += " AND U8_STATUS <> '3'"+LF
//cQuery += " AND U8_STATUS <> '4'"+LF
//cQuery += " AND U8_STATUS <> '5'"+LF

cQuery += " ORDER BY U6_LISTA, U6_DATA " + LF
MemoWrite("C:\Temp\2nao_realiz.sql", cQuery) 
If Select("SU8XX") > 0
	DbSelectArea("SU8XX")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "SU8XX"
TCSetField( 'SU8XX', "U6_DATA", "D" )
TCSetField( 'SU8XX', "U8_DATA", "D" )

SU8XX->( DBGoTop() )

nOcupado:= 0
nErro   := 0
nFalha  := 0
nSemLin := 0


Do While !SU8XX->( Eof() )  	
 	
 	If SU8XX->U8_STATUS = '1'
 		cU8Status := "Ocupado"
 		nOcupado++
 	Elseif SU8XX->U8_STATUS = '2'
 		cU8Status := "Erro"
 		nErro++
 	Elseif SU8XX->U8_STATUS = '3'
 		cU8Status := "Falha"
 		nFalha++
 	Elseif SU8XX->U8_STATUS = '4'
 		cU8Status := "Sem Linha"
 		nSemLin++
 	//Case SU8XX->U8_STATUS = '5'
 		//cU8Status := "Executado"
 		//nRealiz++
 	//Elseif SU8XX->U8_STATUS = '6'
 	//	cU8Status := "Excluido"
 	//Elseif SU8XX->U8_STATUS = '7'
 	//	cU8Status := "Enviado"
 	//Elseif SU8XX->U8_STATUS = '8'
 	//	cU8Status := "Impresso"
 	Else
 		cU8Status := "Nao Realizado"
 	Endif
 	
 	
	Aadd (aResult, {SU8XX->U6_LISTA,;  														//1
					SU8XX->U6_DATA,;	  													//2			  
	  				cU8Status  ,;      														//3
					Substr(SU8XX->U6_CODENT,1,6) + "/" + Substr(SU8XX->U6_CODENT,7,2)  ,;   //4
					Alltrim(SU8XX->A1_NOME),;                                               //5
					SU8XX->U6_NFISCAL	  } )												//6
  
    
  SU8XX->( DbSkip() )

Enddo
DbSelectArea("SU8XX")
DbCloseArea()

nNaoRealiz := nNaoRealiz - (nOcupado + nErro + nSemLin)

mPag := 1

//CRIA O HTML
//A PRIMEIRA PARTE MOSTRA AS LIGAÇÕES NÃO REALIZADAS UMA POR UMA E SEUS MOTIVOS
/////////////////
chtm	 := ""
cDirHTM  := "\Temp\"    
cArqHTM  := "LISTA_" + Dtos(dDataum) + ".HTM"    
nHandle  := fCreate( cDirHTM + cArqHTM, 0 )
nPag     := 1 
   
If nHandle = -1
     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
     Return
Endif


If Len(aResult) > 0


	FOR X := 1 TO Len(aResult)
			
			
			If Li > 58
				Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  //Impressao do cabecalho
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
				chtm += '<tr>        <td>SIGA /TMKR002L/v.P10</td>'+LF
				chtm += '<td>'+titulo+'</td>'+LF
				chtm += '<td align="right">DT.Ref.:'+ Dtoc(dDataum)+'</td>        </tr>        <tr>'+LF
				chtm += '<td>Hora...: '+ Time() + '</td>          <td></td>'+LF
				chtm += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr></table></head>'+LF
				chtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>'+LF
				chtm += '</table></head>'+LF
				
				chtm += '<table width="1100" border="1" style="font-size:12px;font-family:Verdana"><strong>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>LISTA</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>DATA PROGRAMADA PARA LIGAR</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>NOTA FISCAL</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>COD.CLIENTE</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>NOME CLIENTE</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>STATUS/OCORRENCIA</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><tr>'+LF
				
				nPag++
				
			Endif
			
			If nNaoRealiz > 0 
               
		        chtm += '<tr>' + LF
		        chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,1] + '</span></td>'+LF
				chtm += '<td width="300" align="center"><span class="style3">'+ Dtoc(aResult[X,2]) + '</span></td>'+LF
				chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,6]  + '</span></td>'+LF
				chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,4]  + '</span></td>'+LF
				chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,5]  + '</span></td>'+LF
				chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,3] + '</span></td>'+LF
				chtm += '</tr>'+LF  //FECHA A LINHA
				li++	     
			Endif
        
	NEXT
	/////FECHA A TABELA DO HTML
	chtm += '</table><br>'
	Fwrite( nHandle, chtm, Len(chtm) )
	chtm := ""	
	
Endif


///resumo total no fim do relatório 
//O RESUMO MOSTRA O TOTAL DE LIGAÇÕES, O TOTAL NÃO REALIZADO E A %CUMPRIMENTO
If Li > 58
	Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  //Impressao do cabecalho
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
	chtm += '<td align="right">Folha..:'+ Str(nPag) +'</td></tr>'+LF
	chtm += '<tr>        <td>SIGA /TMKR002L/v.P10</td>'+LF
	chtm += '<td>'+titulo+'</td>'+LF
	chtm += '<td align="right">DT.Ref.:'+ Dtoc(dDataum)+'</td>        </tr>        <tr>'+LF
	chtm += '<td>Hora...: '+ Time() + '</td>          <td></td>'+LF
	chtm += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr></table></head>'+LF
	chtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>'+LF
	chtm += '</table></head>'+LF
		
	nPag++
Endif

chtm += '<br>' + LF		
///GRAVA O RESUMO NO HTML	
chtm += '<table width="300" border="1" style="font-size:12px;font-family:Verdana"><strong>'+LF
chtm += '<td colspan="2"><div align="center"><span class="style3"><b>RESUMO do DIA: '+ Dtoc(dDataum)+'</span></div></b></td></tr>'+LF
chtm += '<td ><div align="center"><span class="style3"><b>TOTAL PREVISTO:</span></div></b></td>'+LF
chtm += '<td ><div align="center"><span class="style3"><b>'+ Transform(nTotLig, "@E 9,999")+'</span></div></b></td></tr>'+LF
chtm += '<td ><div align="center"><span class="style3"><b>NAO REALIZADO</span></div></b></td>'+LF
chtm += '<td ><div align="center"><span class="style3"><b>'+ Transform(nNaoRealiz, "@E 9,999") +'</span></div></b></td></tr>'+LF
chtm += '<td ><div align="center"><span class="style3"><b>PORCENTAGEM nao Realiz</span></div></b></td>'+LF
chtm += '<td ><div align="center"><span class="style3"><b>'+ Transform( ( (nNaoRealiz / nTotLig) * 100), "@E 999.99") +'</span></div></b></td></tr>'+LF
chtm += '<td ><div align="center"><tr>'+LF
		
/////FECHA A TABELA DO HTML
chtm += '</table><br>'
		
//////FECHA O HTML PARA GRAVAÇÃO E ENVIO
chtm += '</body> '
chtm += '</html> '
//////GRAVA O HTML
Fwrite( nHandle, chtm, Len(chtm) )
FClose( nHandle )
//nRet := 0
						
//////SELECIONA O EMAIL DESTINATÁRIO 
//cMailTo := "posvendas@ravaembalagens.com.br" 
cMailTo := "daniela@ravaembalagens.com.br"  //solicitado em 13/06/11, por Daniela, o envio apenas para o email dela
//cMailTo := "flavia.rocha@ravaembalagens.com.br"
cCopia  := ""  //"flavia.rocha@ravaembalagens.com.br" 
cCorpo  := titulo
cAnexo  := cDirHTM + cArqHTM
cAssun  := titulo
//////ENVIA O HTML COMO ANEXO
U_SendFatr11( cMailTo, cCopia, cAssun, cCorpo, cAnexo ) 

//Roda( 0, "", TAMANHO )


//Msginfo("Processo finalizado")

// Habilitar somente para Schedule
Reset environment


Return NIL


/////gera relatório para as ligações da filial RAVA/CAIXAS
******************************
User Function TMKR02XF()  
******************************

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
titulo    := "FEEDBACKS - % Eficacia Diaria - Rava/Caixas"
cDesc1    := "Este programa ira emitir o relatorio "
cDesc2    := "de % de feedbacks do Call Center não "
cDesc3    := "efetuados na data prevista."
cNatureza := ""
aReturn   := { "Producao", 1, "Administracao", 1, 2, 1, "", 1 }
nomeprog  := "TMKR02XF"
cPerg     := "TMKR02"
nLastKey  := 0
lContinua := .T.
nLin      := 9
wnrel     := "TMKR002"
M_PAG     := 1
Cabec1 	:= ""
Cabec2	:= ""
nomeprog	:= "TMKR002XF"


//O schedule está agendado para executar as 03:00h - diariamente

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Habilitar somente para Schedule
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03"



XRptDetail(Cabec1, Cabec2, Titulo,nLin)

Return



//------------------------------
Static Function XRptDetail(Cabec1, Cabec2, Titulo,nLin)     
//------------------------------


Local aResult   := {}
Local LF      	:= CHR(13)+CHR(10)
Local cU8Status := ""
Local dData1 := CtoD("  /  /    ")
Local dData2 := CtoD("  /  /    ") 

Local nTotLig := 0
Local nNaoRealiz := 0

Local chtm		:= ""
Local cDIRHTM	:= ""
Local cARQHTM	:= ""
Local nHandle	:= 0
Local nPag		:= 1	

Local nOcupado
Local nErro
Local nFalha 
Local nSemLin
Local nRealiz
Local li := 80


dData1 := (dDatabase -1 )

//Parâmetros:
//--------------------------------
// mv_par01 - Data de
// mv_par02 - Data até
//---------------------------------

Cabec1 := "LISTA  DT.PREV    CODIGO    NOME CLIENTE                             OCORRÊNCIA"                                
Cabec2 := "       LIGAÇÃO   CLIENTE"
Cabec3 := ""

//         999999  99/99/99  999999/99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXX              
//         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//         0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        	    

////SELECIONA TODAS AS LIGAÇÕES DO SU6
/////ligações somente de feedback (U6_ORIGEM = '3')

cQuery := " SELECT COUNT(*) AS TOTAL_LIG " + LF    	  
cQuery += " FROM " + LF
cQuery += " " + RetSqlName("SU4") + " SU4, "+LF
cQuery += " " + RetSqlName("SU6") + " SU6, "+LF
cQuery += " " + RetSqlName("SUC") + " SUC, "+LF
cQuery += " " + RetSqlName("SF2") + " SF2, "+ LF
cQuery += " " + RetSqlName("SA1") + " SA1 "+ LF

cQuery += " WHERE " //U6_DATA = '" + Dtos(dData1) + "' " + LF
cQuery += " U4_DATA = '" + Dtos(dData1) + "'  " + LF
cQuery += " AND SU6.U6_LISTA = SU4.U4_LISTA " + LF 
cQuery += " AND SU6.U6_FILIAL = SU4.U4_FILIAL " + LF
cQuery += " AND SU6.U6_NFISCAL = SUC.UC_NFISCAL " + LF 
cQuery += " AND SU6.U6_FILIAL = SUC.UC_FILIAL " + LF

cQuery += " AND SU4.D_E_L_E_T_ = ''"+ LF
cQuery += " AND SU6.D_E_L_E_T_ = ''"+ LF
cQuery += " AND SUC.D_E_L_E_T_ = ''"+ LF
cQuery += " AND SA1.D_E_L_E_T_ = ''"+LF
cQuery += " AND SF2.D_E_L_E_T_ = ''"+LF

cQuery += " AND SU4.U4_FILIAL = '" + xFilial("SU4") + "'"+ LF
cQuery += " AND SU6.U6_FILIAL = '" + xFilial("SU6") + "'"+ LF
cQuery += " AND SUC.UC_FILIAL = '" + xFilial("SUC") + "'"+ LF
cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ LF
cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"+ LF
cQuery += " AND U6_CODENT = (A1_COD + A1_LOJA) "+LF

cQuery += " AND U6_ORIGEM = '3'"+LF	//SOMENTE FEEDBACK

cQuery += " AND U6_NFISCAL = F2_DOC " + LF
cQuery += " AND U6_SERINF = F2_SERIE " + LF
cQuery += " AND U6_TIPO = '5'"+LF

//cQuery += " AND U6_STATUS = '1'"+LF   //SE A LIGAÇÃO É DE ONTEM E O STATUS É = '1' É PORQUE NÃO FOI REALIZADA

cQuery += " AND U6_NFISCAL <> ''"+LF
//ESTAS PODEM ENTRAR NO TOTAL
//cQuery += " AND U6_LIGPROB <> 'S'  "+LF
//cQuery += " AND U6_RETENC <> 'S'  "+LF         //QUE NÃO SEJAM DE NOTAS COM RETENÇÃO
//cQuery += " AND U6_DTAGCLI = '' "+LF           //QUE NÃO SEJAM DE NOTAS COM AGENDAMENTO 
cQuery += " AND SUC.UC_REATIVA <> 'S' " + LF     //NÃO CONSIDERA LIGAÇÕES REATIVADAS



//MemoWrite("C:\Temp\TOT_LIG.sql", cQuery) 

If Select("TOT") > 0
	DbSelectArea("TOT")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TOT"

TOT->( DBGoTop() )

/*
Local nOcupado
Local nErro
Local nFalha 
Local nSemLin
Local nRealiz
Local nTotLig
Local nNaoRealiz

*/


Do While !TOT->( Eof() )
	nTotLig := TOT->TOTAL_LIG
	TOT->(Dbskip())
Enddo

DbSelectArea("TOT")
DbCloseArea()

//já tenho o total de ligações 
//agora preciso capturar deste total, o que não foi realizado, 
//e dentro do que não foi realizado, se foi por motivo normal (operador) ou fora do que o operador pudesse
//realizar, ex.: ocupado (não entra na contagem)
cQuery := " SELECT Count(*) AS NAOREALIZ " + LF //U6_LISTA , U6_DATA, U6_CODENT, U6_NFISCAL, A1_NOME " + LF    	  
cQuery += " FROM " + LF
cQuery += " " + RetSqlName("SU4") + " SU4, "+LF
cQuery += " " + RetSqlName("SU6") + " SU6, "+LF
cQuery += " " + RetSqlName("SUC") + " SUC, "+LF
cQuery += " " + RetSqlName("SF2") + " SF2, "+ LF
cQuery += " " + RetSqlName("SA1") + " SA1 "+ LF

cQuery += " WHERE " //U6_DATA = '" + Dtos(dData1) + "' " + LF
cQuery += " U4_DATA = '" + Dtos(dData1) + "' " + LF
cQuery += " AND SU6.U6_LISTA = SU4.U4_LISTA " + LF 
cQuery += " AND SU6.U6_FILIAL = SU4.U4_FILIAL " + LF
cQuery += " AND SU6.U6_NFISCAL = SUC.UC_NFISCAL " + LF 
cQuery += " AND SU6.U6_FILIAL = SUC.UC_FILIAL " + LF

cQuery += " AND SU4.D_E_L_E_T_ = ''"+ LF
cQuery += " AND SU6.D_E_L_E_T_ = ''"+ LF
cQuery += " AND SUC.D_E_L_E_T_ = ''"+ LF
cQuery += " AND SA1.D_E_L_E_T_ = ''"+LF
cQuery += " AND SF2.D_E_L_E_T_ = ''"+LF

cQuery += " AND SU4.U4_FILIAL = '" + xFilial("SU4") + "'"+ LF
cQuery += " AND SU6.U6_FILIAL = '" + xFilial("SU6") + "'"+ LF
cQuery += " AND SUC.UC_FILIAL = '" + xFilial("SUC") + "'"+ LF
cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ LF
cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"+ LF

cQuery += " AND (U6_CODENT) = (A1_COD + A1_LOJA) "+LF

cQuery += " AND U6_ORIGEM = '3'"+LF	//SOMENTE FEEDBACK

cQuery += " AND U6_NFISCAL = F2_DOC " + LF
cQuery += " AND U6_SERINF = F2_SERIE " + LF
cQuery += " AND U6_TIPO = '5'"+LF

cQuery += " AND U6_STATUS = '1'"+LF   //SE A LIGAÇÃO É DE ONTEM E O STATUS É = '1' É PORQUE NÃO FOI REALIZADA
cQuery += " AND U4_STATUS = '1'"+LF   //SE A LIGAÇÃO É DE ONTEM E O STATUS É = '1' É PORQUE NÃO FOI REALIZADA

cQuery += " AND U6_NFISCAL <> ''"+LF
cQuery += " AND U6_LIGPROB <> 'S'  "+LF
cQuery += " AND (U6_RETENC) <> 'S'  "+LF
cQuery += " AND (U6_DTAGCLI) = '' "+LF
cQuery += " AND (F2_RETENC) <> 'S'  "+LF
cQuery += " AND (F2_DTAGCLI) = '' "+LF  
cQuery += " AND SUC.UC_REATIVA <> 'S' "+ LF

//cQuery += " ORDER BY U6_LISTA, U6_DATA " + LF
MemoWrite("C:\Temp\NAO_LIG.sql", cQuery) 

If Select("NAOREA") > 0
	DbSelectArea("NAOREA")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "NAOREA"
//TCSetField( 'TKR', "U6_DATA", "D" )
//TCSetField( 'TKR', "U8_DATA", "D" )

NAOREA->( DBGoTop() )

nNaoRealiz := 0 

Do While !NAOREA->( Eof() )        

	nNaoRealiz := NAOREA->NAOREALIZ
	NAOREA->(Dbskip())	 	  
Enddo 
DbSelectArea("NAOREA")
DbCloseArea()	
 	
/////capturar as ligações que tenham link com a SU8 - onde fica registrado o motivo da não realização

cQuery := " SELECT U6_STATUS,U8_STATUS, " + LF  
cQuery += " CASE WHEN U8_STATUS ='1' THEN 'OCUPADO'  " + LF  
cQuery += " ELSE   " + LF  
cQuery += " CASE WHEN U8_STATUS ='2' THEN 'ERRO' " + LF  
cQuery += " ELSE  " + LF  
cQuery += " CASE WHEN U8_STATUS = '3' THEN 'FALHA' " + LF  
cQuery += " ELSE  " + LF  
cQuery += " CASE WHEN U8_STATUS = '4' THEN 'SEM LINHA' " + LF  
cQuery += " ELSE " + LF  
cQuery += " CASE WHEN U8_STATUS = '5' THEN 'EXECUTADO' " + LF  
cQuery += " ELSE " + LF  
cQuery += " 'NAO REALIZADO' " + LF  
cQuery += " END " + LF  
cQuery += " END " + LF  
cQuery += " END " + LF  
cQuery += " END " + LF  
cQuery += " END AS MOTIVO " + LF 
 
cQuery += " ,U6_LISTA, U6_DATA, U6_NFISCAL, U8_CRONUM, U8_DATA, U8_STATUS, U6_CODENT, A1_NOME " + LF    	  
cQuery += " FROM " + LF 
cQuery += " " + RetSqlName("SF2") + " SF2, "+LF
cQuery += " " + RetSqlName("SA1") + " SA1, "+ LF
cQuery += " " + RetSqlName("SU4") + " SU4, "+ LF
cQuery += " " + RetSqlName("SU6") + " SU6 "+LF

cQuery += " LEFT JOIN " + RetSqlName("SU8") + " SU8 " + LF
cQuery += " ON SU6.U6_LISTA = SU8.U8_CRONUM AND SU8.D_E_L_E_T_ = '' AND SU8.U8_FILIAL = '" + xFilial("SU8") + "' " + LF
cQuery += " AND U6_CODIGO = U8_CONTATO"+LF

cQuery += " WHERE " //U6_DATA = '" + Dtos(dData1) + "' " + LF
cQuery += " U4_DATA = '" + Dtos(dData1) + "' " + LF
cQuery += " AND SU6.U6_LISTA = SU4.U4_LISTA " + LF  
cQuery += " AND SU6.U6_FILIAL = SU4.U4_FILIAL " + LF

cQuery += " AND SU4.D_E_L_E_T_ = ''"+ LF
cQuery += " AND SU6.D_E_L_E_T_ = ''"+ LF
cQuery += " AND SF2.D_E_L_E_T_ = ''"+LF
cQuery += " AND SA1.D_E_L_E_T_ = ''"+LF

cQuery += " AND SU4.U4_FILIAL = '" + xFilial("SU4") + "'"+ LF
cQuery += " AND SU6.U6_FILIAL = '" + xFilial("SU6") + "'"+ LF
cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ LF
cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"+ LF

cQuery += " AND U6_NFISCAL = F2_DOC"+LF
cQuery += " AND U6_SERINF = F2_SERIE"+LF
cQuery += " AND U6_CODENT = (A1_COD + A1_LOJA) "+LF
cQuery += " AND U6_ORIGEM = '3'"+LF
cQuery += " AND U6_STATUS = '1'"+LF
cQuery += " AND U6_TIPO = '5'"+LF
cQuery += " AND U6_NFISCAL <> ''"+LF
cQuery += " AND U6_LIGPROB <> 'S'  "+LF
cQuery += " AND U6_RETENC <> 'S'  "+LF
cQuery += " AND U6_DTAGCLI = '' "+LF
cQuery += " AND F2_RETENC <> 'S'  "+LF
cQuery += " AND F2_DTAGCLI = '' "+LF
//cQuery += " AND U8_STATUS <> '1'"+LF
//cQuery += " AND U8_STATUS <> '2'"+LF
//cQuery += " AND U8_STATUS <> '3'"+LF
//cQuery += " AND U8_STATUS <> '4'"+LF
//cQuery += " AND U8_STATUS <> '5'"+LF

cQuery += " ORDER BY U6_LISTA, U6_DATA " + LF
MemoWrite("C:\Temp\SU8_MOTIV.sql", cQuery) 
If Select("SU8XX") > 0
	DbSelectArea("SU8XX")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "SU8XX"
TCSetField( 'SU8XX', "U6_DATA", "D" )
TCSetField( 'SU8XX', "U8_DATA", "D" )

SU8XX->( DBGoTop() )

nOcupado:= 0
nErro   := 0
nFalha  := 0
nSemLin := 0


Do While !SU8XX->( Eof() )  	
 	
 	If SU8XX->U8_STATUS = '1'
 		cU8Status := "Ocupado"
 		nOcupado++
 	Elseif SU8XX->U8_STATUS = '2'
 		cU8Status := "Erro"
 		nErro++
 	Elseif SU8XX->U8_STATUS = '3'
 		cU8Status := "Falha"
 		nFalha++
 	Elseif SU8XX->U8_STATUS = '4'
 		cU8Status := "Sem Linha"
 		nSemLin++
 	//Case SU8XX->U8_STATUS = '5'
 		//cU8Status := "Executado"
 		//nRealiz++
 	//Elseif SU8XX->U8_STATUS = '6'
 	//	cU8Status := "Excluido"
 	//Elseif SU8XX->U8_STATUS = '7'
 	//	cU8Status := "Enviado"
 	//Elseif SU8XX->U8_STATUS = '8'
 	//	cU8Status := "Impresso"
 	Else
 		cU8Status := "Nao Realizado"
 	Endif
 	
 	
	Aadd (aResult, {SU8XX->U6_LISTA,;  														//1
					SU8XX->U6_DATA,;	  													//2			  
	  				cU8Status  ,;      														//3
					Substr(SU8XX->U6_CODENT,1,6) + "/" + Substr(SU8XX->U6_CODENT,7,2)  ,;   //4
					Alltrim(SU8XX->A1_NOME),;                                               //5
					SU8XX->U6_NFISCAL	  } )												//6
  
    
  SU8XX->( DbSkip() )

Enddo
DbSelectArea("SU8XX")
DbCloseArea()

nNaoRealiz := nNaoRealiz - (nOcupado + nErro + nSemLin)

mPag := 1

//CRIA O HTML
//A PRIMEIRA PARTE MOSTRA AS LIGAÇÕES NÃO REALIZADAS UMA POR UMA E SEUS MOTIVOS
/////////////////
chtm	 := ""
cDirHTM  := "\Temp\"    
cArqHTM  := "FB_" + Dtos(dData1) + ".HTM"    
nHandle  := fCreate( cDirHTM + cArqHTM, 0 )
nPag     := 1 
   
If nHandle = -1
     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
     Return
Endif

chtm := ""
Li := 80


		
		/*
		Aadd (aResult, {SU8XX->U6_LISTA,;  														//1
					SU8XX->U6_DATA,;	  													//2			  
	  				cU8Status  ,;      														//3
					Substr(SU8XX->U6_CODENT,1,6) + "/" + Substr(SU8XX->U6_CODENT,7,2)  ,;   //4
					Alltrim(SU8XX->A1_NOME),;                                               //5
					SU8XX->U6_NFISCAL	  } )												//6
  
		
		*/      
		
If Len(aResult) > 0
	FOR X := 1 TO Len(aResult)
	
		If Li > 58
			Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  //Impressao do cabecalho
			li := 9
		
			///prepara o html
			chtm += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+LF
			chtm += '<html><head>'                                                         +LF 
			chtm += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+LF
			chtm += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+LF
			chtm += '<tr>    <td>'+LF
			chtm += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:12px;font-family:Verdana">'+LF
			chtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>RAVA EMBALAGENS INDUSTRIA COM. LTDA.</td>  <td></td>'+LF
			chtm += '<td align="right">Folha..:' + Str(nPag) + '</td></tr>'+LF
			chtm += '<tr>        <td>SIGA /TMKR002XF/v.P10</td>'+LF
			chtm += '<td>'+titulo+'</td>'+LF
			chtm += '<td align="right">DT.Ref.:'+ Dtoc(dData1)+'</td>        </tr>        <tr>'+LF
			chtm += '<td>Hora...: '+ Time() + '</td>          <td></td>'+LF
			chtm += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr></table></head>'+LF
			chtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>'+LF
			chtm += '</table></head>'+LF
						
			chtm += '<table width="1100" border="1" style="font-size:12px;font-family:Verdana"><strong>'+LF
			chtm += '<td ><div align="center"><span class="style3"><b>LISTA</span></div></b></td>'+LF
			chtm += '<td ><div align="center"><span class="style3"><b>DATA PROGRAMADA PARA LIGAR</span></div></b></td>'+LF
			chtm += '<td ><div align="center"><span class="style3"><b>NOTA FISCAL</span></div></b></td>'+LF
			chtm += '<td ><div align="center"><span class="style3"><b>COD.CLIENTE</span></div></b></td>'+LF
			chtm += '<td ><div align="center"><span class="style3"><b>NOME CLIENTE</span></div></b></td>'+LF
			chtm += '<td ><div align="center"><span class="style3"><b>STATUS/OCORRENCIA</span></div></b></td>'+LF
			chtm += '<td ><div align="center"></tr>'+LF
					
			nPag++
						
		Endif 
		
		If nNaoRealiz > 0

	        chtm += '<tr>' + LF      
	        chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,1] + '</span></td>'+LF
			chtm += '<td width="300" align="center"><span class="style3">'+ Dtoc(aResult[X,2]) + '</span></td>'+LF
			chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,6]  + '</span></td>'+LF
			chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,4]  + '</span></td>'+LF
			chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,5]  + '</span></td>'+LF
			chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,3] + '</span></td>'+LF
			chtm += '</tr>'+LF  //FECHA A LINHA
			li++
		Endif	
        
	NEXT
	/////FECHA A TABELA DO HTML
	//chtm += '</table><br>'
	
	Fwrite( nHandle, chtm, Len(chtm) )
	chtm := ""	
	
Endif

If Li > 58
	Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  //Impressao do cabecalho
	li := 9

	///prepara o html
	chtm += '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+LF
	chtm += '<html><head>'                                                         +LF 
	chtm += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+LF
	chtm += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+LF
	chtm += '<tr>    <td>'+LF
	chtm += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:12px;font-family:Verdana">'+LF
	chtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>RAVA EMBALAGENS INDUSTRIA COM. LTDA.</td>  <td></td>'+LF
	chtm += '<td align="right">Folha..:' + Str(nPag) + '</td></tr>'+LF
	chtm += '<tr>        <td>SIGA /TMKR002XF/v.P10</td>'+LF
	chtm += '<td>'+titulo+'</td>'+LF
	chtm += '<td align="right">DT.Ref.:'+ Dtoc(dData1)+'</td>        </tr>        <tr>'+LF
	chtm += '<td>Hora...: '+ Time() + '</td>          <td></td>'+LF
	chtm += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr></table></head>'+LF
	chtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>'+LF
	chtm += '</table></head>'+LF
	
				
	nPag++
				
Endif 


/////FECHA A TABELA DO HTML
chtm += '</table><br>'

///resumo total no fim do relatório 
//O RESUMO MOSTRA O TOTAL DE LIGAÇÕES, O TOTAL NÃO REALIZADO E A %CUMPRIMENTO

chtm += '<br>' + LF
///GRAVA O RESUMO NO HTML	
chtm += '<table width="300" border="1" style="font-size:12px;font-family:Verdana"><strong>'+LF
chtm += '<td colspan="2"><div align="center"><span class="style3"><b>RESUMO do DIA: '+ Dtoc(dData1)+'</span></div></b></td></tr>'+LF
chtm += '<td ><div align="center"><span class="style3"><b>TOTAL PREVISTO:</span></div></b></td>'+LF
chtm += '<td ><div align="center"><span class="style3"><b>'+ Transform(nTotLig, "@E 9,999")+'</span></div></b></td></tr>'+LF
chtm += '<td ><div align="center"><span class="style3"><b>NAO REALIZADO</span></div></b></td>'+LF
chtm += '<td ><div align="center"><span class="style3"><b>'+ Transform(nNaoRealiz, "@E 9,999") +'</span></div></b></td></tr>'+LF
chtm += '<td ><div align="center"><span class="style3"><b>PORCENTAGEM nao Realiz:</span></div></b></td>'+LF
chtm += '<td ><div align="center"><span class="style3"><b>'+ Transform( ( (nNaoRealiz / nTotLig) * 100), "@E 999.99") +'</span></div></b></td></tr>'+LF
chtm += '<td ><div align="center"><tr>'+LF
		
/////FECHA A TABELA DO HTML
chtm += '</table><br>'
		
//////FECHA O HTML PARA GRAVAÇÃO E ENVIO
chtm += '</body> '
chtm += '</html> '
//////GRAVA O HTML
Fwrite( nHandle, chtm, Len(chtm) )
FClose( nHandle )
//nRet := 0
						
//////SELECIONA O EMAIL DESTINATÁRIO 
//cMailTo := "posvendas@ravaembalagens.com.br" 
cMailTo := "daniela@ravaembalagens.com.br"  //solicitado em 13/06/11, por Daniela, o envio apenas para o email dela
//cMailTo := "flavia.rocha@ravaembalagens.com.br"
cCopia  := ""  //"flavia.rocha@ravaembalagens.com.br" 
cCorpo  := titulo
cAnexo  := cDirHTM + cArqHTM
cAssun  := titulo
//////ENVIA O HTML COMO ANEXO
U_SendFatr11( cMailTo, cCopia, cAssun, cCorpo, cAnexo ) 

//Roda( 0, "", TAMANHO )


//Msginfo("Processo finalizado")

// Habilitar somente para Schedule
Reset environment


Return NIL
********************************************************************************



*****************************
User Function TMKR02XL()
*****************************

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
titulo    := "LISTA POS-VENDAS - % Eficacia Diaria - Rava/Caixas"
cDesc1    := "Este programa ira emitir o relatorio "
cDesc2    := "de % de ligações da lista do Call Center não "
cDesc3    := "efetuados na data prevista."
cNatureza := ""
aReturn   := { "Producao", 1, "Administracao", 1, 2, 1, "", 1 }
nomeprog  := "TMKR02XL"
cPerg     := "TMKR02"
nLastKey  := 0
lContinua := .T.
nLin      := 9
wnrel     := "TMKR002L"
M_PAG     := 1



//Habilitar somente para Schedule
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03"


fLptDetail(Cabec1,Cabec2,Titulo,nLin)

Return



//------------------------------
Static Function fLptDetail(Cabec1,Cabec2,Titulo,nLin)     
//------------------------------


Local aResult   := {}
Local LF      	:= CHR(13)+CHR(10)
Local cU8Status := ""
Local dDataum := CtoD("  /  /    ")
Local dDatadois := CtoD("  /  /    ") 

Local nTotLig := 0
Local nNaoRealiz := 0

Local chtm		:= ""
Local cDIRHTM	:= ""
Local cARQHTM	:= ""
Local nHandle	:= 0
Local nPag		:= 1	

Local nOcupado
Local nErro
Local nFalha 
Local nSemLin
Local nRealiz
Local li		  := 80

dDataum := (dDatabase -1 )
//dDataum := dDatabase
//dDatadois := dDataum

//Parâmetros:
//--------------------------------
// mv_par01 - Data de
// mv_par02 - Data até
//---------------------------------

Cabec1 := "LISTA  DT.PREV    CODIGO    NOME CLIENTE                             OCORRÊNCIA"                                
Cabec2 := "       LIGAÇÃO   CLIENTE"
Cabec3 := ""

//         999999  99/99/99  999999/99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXX              
//         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//         0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        	    

////SELECIONA TODAS AS LIGAÇÕES DO SU6
/////ligações somente de LISTA (U6_ORIGEM = '1')

cQuery := " SELECT COUNT(*) AS TOTAL_LIG " + LF    	  
cQuery += " FROM " + LF
cQuery += " " + RetSqlName("SU4") + " SU4, "+LF
cQuery += " " + RetSqlName("SU6") + " SU6, "+LF
cQuery += " " + RetSqlName("SF2") + " SF2, "+ LF
cQuery += " " + RetSqlName("SA1") + " SA1 "+ LF

cQuery += " WHERE " //U6_DATA = '" + Dtos(dDataum) + "' " + LF
cQuery += " U4_DATA = '" + Dtos(dDataum) + "' " + LF
cQuery += " AND SU6.U6_LISTA = SU4.U4_LISTA " + LF  
cQuery += " AND SU6.U6_FILIAL = SU4.U4_FILIAL " + LF

cQuery += " AND SU4.D_E_L_E_T_ = ''"+ LF
cQuery += " AND SU6.D_E_L_E_T_ = ''"+ LF
cQuery += " AND SA1.D_E_L_E_T_ = ''"+LF
cQuery += " AND SF2.D_E_L_E_T_ = ''"+LF

cQuery += " AND SU6.U6_FILIAL = '" + xFilial("SU6") + "'"+ LF
cQuery += " AND SU4.U4_FILIAL = '" + xFilial("SU4") + "'"+ LF
cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ LF
cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"+ LF

cQuery += " AND U6_CODENT = (A1_COD + A1_LOJA) "+LF

cQuery += " AND U6_ORIGEM = '1'"+LF	//SOMENTE LISTA

cQuery += " AND U6_NFISCAL = F2_DOC " + LF
cQuery += " AND U6_SERINF = F2_SERIE " + LF
cQuery += " AND U6_TIPO = '1' "+LF

//cQuery += " AND U6_STATUS = '1'"+LF   //SE A LIGAÇÃO É DE ONTEM E O STATUS É = '1' É PORQUE NÃO FOI REALIZADA

cQuery += " AND U6_NFISCAL <> ''"+LF
//cQuery += " AND U6_LIGPROB <> 'S'  "+LF
//cQuery += " AND U6_RETENC <> 'S'  "+LF         //QUE NÃO SEJAM DE NOTAS COM RETENÇÃO
//cQuery += " AND U6_DTAGCLI = '' "+LF           //QUE NÃO SEJAM DE NOTAS COM AGENDAMENTO 


//MemoWrite("C:\Temp\TOT_LIG.sql", cQuery) 

If Select("TOT") > 0
	DbSelectArea("TOT")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TOT"

TOT->( DBGoTop() )

/*
Local nOcupado
Local nErro
Local nFalha 
Local nSemLin
Local nRealiz
Local nTotLig
Local nNaoRealiz

*/              

nOcupado	:= 0
nErro		:= 0
nFalha 		:= 0
nSemLin		:= 0
nRealiz		:= 0


Do While !TOT->( Eof() )
	nTotLig := TOT->TOTAL_LIG
	TOT->(Dbskip())
Enddo

DbSelectArea("TOT")
DbCloseArea()

//já tenho o total de ligações 
//agora preciso capturar deste total, o que não foi realizado, 
//e dentro do que não foi realizado, se foi por motivo normal (operador) ou fora do que o operador pudesse
//realizar, ex.: ocupado (não entra na contagem)
cQuery := " SELECT Count(*) AS NAOREALIZ " + LF //U6_LISTA , U6_DATA, U6_CODENT, U6_NFISCAL, A1_NOME " + LF    	  
cQuery += " FROM " + LF
cQuery += " " + RetSqlName("SU4") + " SU4, "+LF
cQuery += " " + RetSqlName("SU6") + " SU6, "+LF
cQuery += " " + RetSqlName("SF2") + " SF2, "+ LF
cQuery += " " + RetSqlName("SA1") + " SA1 "+ LF

cQuery += " WHERE " //U6_DATA = '" + Dtos(dDataum) + "' " + LF
cQuery += " U4_DATA = '" + Dtos(dDataum) + "' " + LF
cQuery += " AND SU6.U6_LISTA = SU4.U4_LISTA " + LF   
cQuery += " AND SU6.U6_FILIAL = SU4.U4_FILIAL " + LF

cQuery += " AND SU4.D_E_L_E_T_ = ''"+ LF
cQuery += " AND SU6.D_E_L_E_T_ = ''"+ LF
cQuery += " AND SA1.D_E_L_E_T_ = ''"+LF
cQuery += " AND SF2.D_E_L_E_T_ = ''"+LF

cQuery += " AND SU4.U4_FILIAL = '" + xFilial("SU4") + "'"+ LF
cQuery += " AND SU6.U6_FILIAL = '" + xFilial("SU6") + "'"+ LF
cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ LF
cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"+ LF

cQuery += " AND U6_CODENT = (A1_COD + A1_LOJA) "+LF

cQuery += " AND U6_ORIGEM = '1'"+LF	//SOMENTE FEEDBACK

cQuery += " AND U6_NFISCAL = F2_DOC " + LF
cQuery += " AND U6_SERINF = F2_SERIE " + LF
cQuery += " AND U6_TIPO = '1'"+LF		//TIPO 1 = MARKETING / TIPO = 5 = FEEDBACK

cQuery += " AND U6_STATUS = '1'"+LF   //SE A LIGAÇÃO É DE ONTEM E O STATUS É = '1' É PORQUE NÃO FOI REALIZADA
cQuery += " AND U4_STATUS = '1'"+LF   //SE A LIGAÇÃO É DE ONTEM E O STATUS É = '1' É PORQUE NÃO FOI REALIZADA

cQuery += " AND U6_NFISCAL <> ''"+LF
cQuery += " AND U6_LIGPROB <> 'S'  "+LF
cQuery += " AND U6_RETENC <> 'S'  "+LF
cQuery += " AND U6_DTAGCLI = '' "+LF 
cQuery += " AND F2_RETENC <> 'S'  "+LF
cQuery += " AND F2_DTAGCLI = '' "+LF

If Select("NAOREA") > 0
	DbSelectArea("NAOREA")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "NAOREA"
//TCSetField( 'TKR', "U6_DATA", "D" )
//TCSetField( 'TKR', "U8_DATA", "D" )

NAOREA->( DBGoTop() )

nNaoRealiz := 0 

Do While !NAOREA->( Eof() )        

	nNaoRealiz := NAOREA->NAOREALIZ
	NAOREA->(Dbskip())	 	  
Enddo 
DbSelectArea("NAOREA")
DbCloseArea()	
 	
/////capturar as ligações que tenham link com a SU8 - onde fica registrado o motivo da não realização

cQuery := " SELECT U6_STATUS,U8_STATUS, " + LF  
cQuery += " CASE WHEN U8_STATUS ='1' THEN 'OCUPADO'  " + LF  
cQuery += " ELSE   " + LF  
cQuery += " CASE WHEN U8_STATUS ='2' THEN 'ERRO' " + LF  
cQuery += " ELSE  " + LF  
cQuery += " CASE WHEN U8_STATUS = '3' THEN 'FALHA' " + LF  
cQuery += " ELSE  " + LF  
cQuery += " CASE WHEN U8_STATUS = '4' THEN 'SEM LINHA' " + LF  
cQuery += " ELSE " + LF  
cQuery += " CASE WHEN U8_STATUS = '5' THEN 'EXECUTADO' " + LF  
cQuery += " ELSE " + LF  
cQuery += " 'NAO REALIZADO' " + LF  
cQuery += " END " + LF  
cQuery += " END " + LF  
cQuery += " END " + LF  
cQuery += " END " + LF  
cQuery += " END AS MOTIVO " + LF 
 
cQuery += " ,U6_LISTA, U6_DATA, U6_NFISCAL, U8_CRONUM, U8_DATA, U8_STATUS, U6_CODENT, A1_NOME " + LF    	  
cQuery += " FROM " + LF 
cQuery += " " + RetSqlName("SF2") + " SF2, "+LF
cQuery += " " + RetSqlName("SA1") + " SA1, "+ LF
cQuery += " " + RetSqlName("SU4") + " SU4, "+ LF
cQuery += " " + RetSqlName("SU6") + " SU6 "+LF

cQuery += " LEFT JOIN " + RetSqlName("SU8") + " SU8 " + LF
cQuery += " ON SU6.U6_LISTA = SU8.U8_CRONUM AND SU8.D_E_L_E_T_ = '' AND SU8.U8_FILIAL = '" + xFilial("SU8") + "' " + LF
cQuery += " AND U6_CODIGO = U8_CONTATO"+LF

cQuery += " WHERE " //U6_DATA = '" + Dtos(dDataum) + "' " + LF
cQuery += " U4_DATA = '" + Dtos(dDataum) + "' " + LF
cQuery += " AND SU6.U6_LISTA = SU4.U4_LISTA " + LF 
cQuery += " AND SU6.U6_FILIAL = SU4.U4_FILIAL " + LF

cQuery += " AND SU4.D_E_L_E_T_ = ''"+ LF
cQuery += " AND SU6.D_E_L_E_T_ = ''"+ LF
cQuery += " AND SF2.D_E_L_E_T_ = ''"+LF
cQuery += " AND SA1.D_E_L_E_T_ = ''"+LF

cQuery += " AND SU4.U4_FILIAL = '" + xFilial("SU4") + "'"+ LF
cQuery += " AND SU6.U6_FILIAL = '" + xFilial("SU6") + "'"+ LF
cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ LF
cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"+ LF


cQuery += " AND U6_NFISCAL = F2_DOC"+LF
cQuery += " AND U6_SERINF = F2_SERIE"+LF
cQuery += " AND (U6_CODENT) = (A1_COD + A1_LOJA) "+LF

cQuery += " AND U6_ORIGEM = '1'"+LF //ORIGEM = 1 -> LISTA
cQuery += " AND U6_TIPO = '1'"+LF  	//TIPO = 1 -> LISTA

cQuery += " AND U6_STATUS = '1'"+LF
cQuery += " AND U4_STATUS = '1'"+LF

cQuery += " AND U6_NFISCAL <> ''"+LF
cQuery += " AND U6_LIGPROB <> 'S'  "+LF
cQuery += " AND U6_RETENC <> 'S'  "+LF
cQuery += " AND U6_DTAGCLI = '' "+LF
cQuery += " AND F2_RETENC <> 'S'  "+LF
cQuery += " AND F2_DTAGCLI = '' "+LF
//cQuery += " AND U8_STATUS <> '1'"+LF
//cQuery += " AND U8_STATUS <> '2'"+LF
//cQuery += " AND U8_STATUS <> '3'"+LF
//cQuery += " AND U8_STATUS <> '4'"+LF
//cQuery += " AND U8_STATUS <> '5'"+LF

cQuery += " ORDER BY U6_LISTA, U6_DATA " + LF

If Select("SU8XX") > 0
	DbSelectArea("SU8XX")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "SU8XX"
TCSetField( 'SU8XX', "U6_DATA", "D" )
TCSetField( 'SU8XX', "U8_DATA", "D" )

SU8XX->( DBGoTop() )

nOcupado:= 0
nErro   := 0
nFalha  := 0
nSemLin := 0


Do While !SU8XX->( Eof() )  	
 	
 	If SU8XX->U8_STATUS = '1'
 		cU8Status := "Ocupado"
 		nOcupado++
 	Elseif SU8XX->U8_STATUS = '2'
 		cU8Status := "Erro"
 		nErro++
 	Elseif SU8XX->U8_STATUS = '3'
 		cU8Status := "Falha"
 		nFalha++
 	Elseif SU8XX->U8_STATUS = '4'
 		cU8Status := "Sem Linha"
 		nSemLin++
 	//Case SU8XX->U8_STATUS = '5'
 		//cU8Status := "Executado"
 		//nRealiz++
 	//Elseif SU8XX->U8_STATUS = '6'
 	//	cU8Status := "Excluido"
 	//Elseif SU8XX->U8_STATUS = '7'
 	//	cU8Status := "Enviado"
 	//Elseif SU8XX->U8_STATUS = '8'
 	//	cU8Status := "Impresso"
 	Else
 		cU8Status := "Nao Realizado"
 	Endif
 	
 	
	Aadd (aResult, {SU8XX->U6_LISTA,;  														//1
					SU8XX->U6_DATA,;	  													//2			  
	  				cU8Status  ,;      														//3
					Substr(SU8XX->U6_CODENT,1,6) + "/" + Substr(SU8XX->U6_CODENT,7,2)  ,;   //4
					Alltrim(SU8XX->A1_NOME),;                                               //5
					SU8XX->U6_NFISCAL	  } )												//6
  
    
  SU8XX->( DbSkip() )

Enddo
DbSelectArea("SU8XX")
DbCloseArea()

nNaoRealiz := nNaoRealiz - (nOcupado + nErro + nSemLin)

mPag := 1

//CRIA O HTML
//A PRIMEIRA PARTE MOSTRA AS LIGAÇÕES NÃO REALIZADAS UMA POR UMA E SEUS MOTIVOS
/////////////////
chtm	 := ""
cDirHTM  := "\Temp\"    
cArqHTM  := "LISTA_" + Dtos(dDataum) + ".HTM"    
nHandle  := fCreate( cDirHTM + cArqHTM, 0 )
nPag     := 1 
   
If nHandle = -1
     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
     Return
Endif


If Len(aResult) > 0


	FOR X := 1 TO Len(aResult)
			
			
			If Li > 58
				Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  //Impressao do cabecalho
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
				chtm += '<tr>        <td>SIGA /TMKR002LX/v.P10</td>'+LF
				chtm += '<td>'+titulo+'</td>'+LF
				chtm += '<td align="right">DT.Ref.:'+ Dtoc(dDataum)+'</td>        </tr>        <tr>'+LF
				chtm += '<td>Hora...: '+ Time() + '</td>          <td></td>'+LF
				chtm += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr></table></head>'+LF
				chtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>'+LF
				chtm += '</table></head>'+LF
				
				chtm += '<table width="1100" border="1" style="font-size:12px;font-family:Verdana"><strong>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>LISTA</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>DATA PROGRAMADA PARA LIGAR</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>NOTA FISCAL</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>COD.CLIENTE</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>NOME CLIENTE</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>STATUS/OCORRENCIA</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><tr>'+LF
				
				nPag++
				
			Endif
			
			If nNaoRealiz > 0 
               
		        chtm += '<tr>' + LF
		        chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,1] + '</span></td>'+LF
				chtm += '<td width="300" align="center"><span class="style3">'+ Dtoc(aResult[X,2]) + '</span></td>'+LF
				chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,6]  + '</span></td>'+LF
				chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,4]  + '</span></td>'+LF
				chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,5]  + '</span></td>'+LF
				chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,3] + '</span></td>'+LF
				chtm += '</tr>'+LF  //FECHA A LINHA
				li++
			Endif	
        
	NEXT
	/////FECHA A TABELA DO HTML
	chtm += '</table><br>'
	Fwrite( nHandle, chtm, Len(chtm) )
	chtm := ""	
	
Endif


///resumo total no fim do relatório 
//O RESUMO MOSTRA O TOTAL DE LIGAÇÕES, O TOTAL NÃO REALIZADO E A %CUMPRIMENTO
If Li > 58
	Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  //Impressao do cabecalho
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
	chtm += '<td align="right">Folha..:'+ Str(nPag) +'</td></tr>'+LF
	chtm += '<tr>        <td>SIGA /TMKR002LX/v.P10</td>'+LF
	chtm += '<td>'+titulo+'</td>'+LF
	chtm += '<td align="right">DT.Ref.:'+ Dtoc(dDataum)+'</td>        </tr>        <tr>'+LF
	chtm += '<td>Hora...: '+ Time() + '</td>          <td></td>'+LF
	chtm += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr></table></head>'+LF
	chtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>'+LF
	chtm += '</table></head>'+LF
		
	nPag++
Endif

chtm += '<br>' + LF		
///GRAVA O RESUMO NO HTML	
chtm += '<table width="300" border="1" style="font-size:12px;font-family:Verdana"><strong>'+LF
chtm += '<td colspan="2"><div align="center"><span class="style3"><b>RESUMO do DIA: '+ Dtoc(dDataum)+'</span></div></b></td></tr>'+LF
chtm += '<td ><div align="center"><span class="style3"><b>TOTAL PREVISTO:</span></div></b></td>'+LF
chtm += '<td ><div align="center"><span class="style3"><b>'+ Transform(nTotLig, "@E 9,999")+'</span></div></b></td></tr>'+LF
chtm += '<td ><div align="center"><span class="style3"><b>NAO REALIZADO</span></div></b></td>'+LF
chtm += '<td ><div align="center"><span class="style3"><b>'+ Transform(nNaoRealiz, "@E 9,999") +'</span></div></b></td></tr>'+LF
chtm += '<td ><div align="center"><span class="style3"><b>PORCENTAGEM nao Realiz</span></div></b></td>'+LF
chtm += '<td ><div align="center"><span class="style3"><b>'+ Transform( ( (nNaoRealiz / nTotLig) * 100), "@E 999.99") +'</span></div></b></td></tr>'+LF
chtm += '<td ><div align="center"><tr>'+LF
		
/////FECHA A TABELA DO HTML
chtm += '</table><br>'
		
//////FECHA O HTML PARA GRAVAÇÃO E ENVIO
chtm += '</body> '
chtm += '</html> '
//////GRAVA O HTML
Fwrite( nHandle, chtm, Len(chtm) )
FClose( nHandle )
//nRet := 0
						
//////SELECIONA O EMAIL DESTINATÁRIO 
//cMailTo := "posvendas@ravaembalagens.com.br" 
cMailTo := "daniela@ravaembalagens.com.br" //solicitado em 13/06/11, por Daniela, o envio apenas para o email dela
//cMailTo := "flavia.rocha@ravaembalagens.com.br"
cCopia  := "" //"flavia.rocha@ravaembalagens.com.br" 
cCorpo  := titulo
cAnexo  := cDirHTM + cArqHTM
cAssun  := titulo
//////ENVIA O HTML COMO ANEXO
U_SendFatr11( cMailTo, cCopia, cAssun, cCorpo, cAnexo ) 

//Roda( 0, "", TAMANHO )


//Msginfo("Processo finalizado")

// Habilitar somente para Schedule
Reset environment
