#include "rwmake.ch"
#include "TbiConn.ch"
#include "topconn.ch"
#include "fivewin.ch"
#include "protheus.ch"
#INCLUDE "AP5MAIL.CH"

/*
//////////////////////////////////////////////////////////////////
//Programa: COMC005.PRW - GERASC para a Filial Rava/Caixas (03)
//Autoria : Flávia Rocha
//Data    : 10/05/2011
//////////////////////////////////////////////////////////////////

*/

***********************
User Function COMC005() 
***********************




if Select( 'SX2' ) == 0

   	RPCSetType( 3 ) // Não consome licensa de uso   
   	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03" //FUNNAME "COMC005" Tables "SB1", "SB2", "SC1", "SC2"   
   	Sleep( 5000 ) // aguarda 5 segundos para que as jobs IPC subam.

	//ALERT( "Iniciando programa COMC005 - Gera SC/OP Automatica - Rava/Caixas - " + Dtoc( Date() ) + ' - ' + Time() ) 
	CONOUT( "Iniciando programa COMC005 - Gera SC/OP Automatica - Rava/Caixas - " + Dtoc( Date() ) + ' - ' + Time() ) 
	fGeraSC()
	fGeraOP()
	fGerOPAM()
	
	//alert( "Finalizando programa COMC005 - Gera SC/OP Automatica - Rava/Caixas - " + Dtoc( DATE() ) + ' - ' + Time() )
	CONOUT( "Finalizando programa COMC005 - Gera SC/OP Automatica - Rava/Caixas - " + Dtoc( DATE() ) + ' - ' + Time() )
    
    Reset Environment



Else

	//ALERT( "MENU - Iniciando programa COMC005 - Gera SC/OP Automatica - Rava/Caixas - " + Dtoc( Date() ) + ' - ' + Time() ) 
	fGeraSC()
	fGeraOP()
	fGerOPAM()
	
	//alert( "Finalizando programa COMC005 - Gera SC/OP Automatica - Rava/Caixas - " + Dtoc( DATE() ) + ' - ' + Time() )

endif


Return


*************************
Static Function fGeraSC()
*************************

Static cUser

/*
Gestores responsáveis por TIPO de Produto:

000119-Nilton  AC/ME
000008-Jorge   CL/MH/MQ
000112-Michele ML/RM
000188-Regineide  GG/MC/MA
000003-Alexandre WFGERASC
*/

local aTamSX3
local nTamUser
local aCab     := { }
local aItem    := { }
local nItem    :=  1
local lSc      := .F.
local nPrazo   :=  0
local nSaveSX8
local aOps     := { }
local aSCs     := { }
local aOpsAm   := { }

local cOP      := ""
local nPos     := 0
Local LF	   := CHR(13)+CHR(10) 
Local cCodGestor	:= ""
Local cMailGestor	:= ""
Local cNomeGestor	:= ""
Local aGestores		:= {}
Local aGestores2	:= {}
Local aUsu			:= {}
Local cMailTo		:= ""
Local cCopia		:= ""
Local cAssun		:= ""
Local cBody			:= ""
Local cBody2		:= ""
Local cAnexo		:= ""  
Local lEnviou		:= .f.
Local cCCAnt		:= ""
Local cTipo		:= ""

Set Date Brit

DbSelectArea("SX3") 
aTamSX3  := TamSX3("C1_SOLICIT")
nTamUser := IIF(aTamSX3[1]<=15,aTamSX3[1],15)
cUser    := IF(cUser == NIL,RetCodUsr(),cUser)
nSaveSX8 := GetSX8Len()

//Produtos Comprados - Gera SC
cQuery := "SELECT B1_COD,B1_UM,B1_SEGUM,B1_CONTA,B1_CC, B1_DESC, B1_ESTSEG, B1_EMIN, B1_EMINCX, B1_ESTSEGX, B1_TIPO," +LF
cQuery += "ISNULL(B2_QATU,0) AS B2_QATU, B1_UM, B1_LOCPAD " +LF
cQuery += "FROM " + LF
cQuery += " " +retSqlName('SB1')+ " SB1 " + LF 
cQuery += " LEFT JOIN " + retSqlName('SB2')+ " SB2 " +LF
cQuery += " ON B1_COD = B2_COD AND B2_LOCAL = '01' AND SB2.D_E_L_E_T_ = ' '  " +LF
cQuery += " AND B2_FILIAL = '" + xFilial( "SB2" ) + "' " +LF

cQuery += "WHERE B1_ATIVO = 'S' " +LF
cQuery += "AND B1_OPAUTOM <> 'S' " +LF
cQuery += "AND B2_QATU <= SB1.B1_ESTSEGX " +LF		//novo campo no SB1 - ESTOQUE SEGURANÇA CAIXAS - B1_ESTSEGX
cQuery += "AND B1_EMINCX > 0 " +LF	                //novo campo no SB1 - PTO PEDIDO CAIXAS - B1_EMINCX
cQuery += "AND LEN(B1_COD) <= 7 " +LF 
cQuery += " AND B1_TIPO NOT IN ('PA','PI') 

//cQuery += "and B1_COD = 'MP0684' " + LF     	////TESTE

cQuery += "AND B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' " +LF
cQuery += "ORDER BY B1_CC, B1_TIPO, B1_COD " +LF
//cQuery := ChangeQuery( cQuery )
Memowrite("C:\Temp\GERASC.SQL", cQuery)
TCQUERY cQuery NEW ALIAS "SB1X1" 

SB1X1->( DbGoTop() )
/*
cSC  := GetSxENum("SC1","C1_NUM")
while SC1->( DbSeek( xFilial( "SC1" ) + cSC ) )
   ConfirmSX8()
   cSC := GetSxeNum("SC1","C1_NUM")
enddo
*/	
while ! SB1X1->( EOF() )
   if !TemSC( SB1X1->B1_COD ) .and. !TemPC( SB1X1->B1_COD ) //VERIFICA SE JÁ TEM SC OU PC, SE NÃO TIVER, GERA SC
	//    nPrazo := CalcPrazo(SB1X1->B1_COD, SB1X1->B1_EMIN )     
	
			//alert("CRIA SC")
			If cCCAnt <> SB1X1->B1_CC .OR. cTipo <> SB1X1->B1_TIPO
				cSC  := GetSxENum("SC1","C1_NUM")
				while SC1->( DbSeek( xFilial( "SC1" ) + cSC ) )
				   ConfirmSX8()
				   cSC := GetSxeNum("SC1","C1_NUM")
				enddo
				ConfirmSX8()
			EndIf
			
	      RecLock("SC1",.T.)
	      SC1->C1_FILIAL  := xFilial("SC1")
	      SC1->C1_FILENT  := xFilEnt(C1_FILIAL)
	   	  SC1->C1_NUM     := cSC
	      SC1->C1_ITEM    := StrZero( nItem, 4 )
	  	  SC1->C1_EMISSAO := dDataBase
	      SC1->C1_PRODUTO := SB1X1->B1_COD
	      SC1->C1_LOCAL   := RetFldProd( SB1X1->B1_COD, "B1_LOCPAD", "SB1X1" )
	      SC1->C1_UM      := SB1X1->B1_UM
	      SC1->C1_SEGUM   := SB1X1->B1_SEGUM
	      SC1->C1_DESCRI  := SB1X1->B1_DESC
	      SC1->C1_QUANT   := SB1X1->B1_EMINCX
	      SC1->C1_CONTA   := SB1X1->B1_CONTA
	      SC1->C1_CC      := SB1X1->B1_CC
	      SC1->C1_QTSEGUM := ConvUm(SB1X1->B1_COD,SB1X1->B1_EMINCX,0,2)
	      SC1->C1_USER    := "000000"
	      SC1->C1_SOLICIT := "Administra"
	      SC1->C1_ORIGEM  := "GERASCX"
	      SC1->C1_DATPRF  := dDataBase//SomaPrazo(dDataBase, nPrazo)
	      SC1->C1_OBS     := "Solicit.Ponto Pedido "+Time()
	      //SC1->C1_APROV   := "B"
	      SC1->C1_TPPROD  := SB1X1->B1_TIPO
	      lSC := .T.
	      nItem ++
	      SC1->(MsUnlock())
	      
	      ///////////////////////////////////////////////////////////////
	      ////Procura no SX5 o responsável pelo tipo do Produto... 
	      ///////////////////////////////////////////////////////////////
	      /*
			Gestores responsáveis por TIPO de Produto:
			
			000119-Nilton  AC/ME
			000008-Jorge   CL/MH/MQ
			000112-Michele ML/RM
			000188-Regineide  GG/MC/MA
			000003-Alexandre WFGERASC
			*/
	      DbselectArea("SX5")
			SX5->(Dbseek(xFilial("SX5") + 'Z6' )) 
			While !SX5->(EOF()) .AND. SX5->X5_FILIAL == xFilial("SX5") .AND. SX5->X5_TABELA == 'Z6'
				If Alltrim(SC1->C1_TPPROD) $ Alltrim(SX5->X5_DESCRI)
					cCodGestor := SX5->X5_CHAVE
				Elseif ( Alltrim(SC1->C1_TPPROD) != "AC" .and. Alltrim(SC1->C1_TPPROD) != "ME" .and. Alltrim(SC1->C1_TPPROD) != "CL" ;
				.and. Alltrim(SC1->C1_TPPROD) != "MH" .and. Alltrim(SC1->C1_TPPROD) != "MQ" .and. Alltrim(SC1->C1_TPPROD) != "ML";
				.and. Alltrim(SC1->C1_TPPROD) != "RM" .and. Alltrim(SC1->C1_TPPROD) != "GG" .and. Alltrim(SC1->C1_TPPROD) != "MC";
				.and. Alltrim(SC1->C1_TPPROD) != "MA" )  //se for diferente de qq um destes, o gestor é Alexandre										
					cCodGestor := "000003"
				Endif
				SX5->(Dbskip())
			Enddo
			
						
			PswOrder(1)
			If PswSeek( cCodGestor, .T. )
			   aUsu := PSWRET() 						// Retorna vetor com informações do usuário
			   //cCodUser  := Alltrim(aUsua[1][1])  	//código do usuário no arq. senhas
			   cNomeGestor := Alltrim(aUsu[1][2])		// Nome do usuário
			   cMailGestor := Alltrim( aUsu[1][14] )     
			Endif
			
				
			aAdd( aGestores2, { SC1->C1_NUM,;		//1
							 SC1->C1_ITEM,;	   		//2
			      			 SC1->C1_PRODUTO,;		//3
			      			 SC1->C1_TPPROD,;		//4
			       			 SC1->C1_DESCRI,;   	//5
			   			     SC1->C1_QUANT,;	  	//6
			   			     SC1->C1_OBS,;    		//7
			   			     SC1->C1_DATPRF,;		//8
			   			     cMailGestor ,;			//9
			   			     cNomeGestor,;			//10
			   			     SC1->C1_SOLICIT,;		//11
			   			     cCodGestor,;			//12
			   			     SC1->C1_EMISSAO })		//13
	      
	      ///
	      Aadd( aSCs, { SC1->C1_FILIAL,;      	//1
					      SC1->C1_FILENT,;      //2
					   	  SC1->C1_NUM,;         //3
					      SC1->C1_ITEM,;        //4
					  	  SC1->C1_EMISSAO,;     //5
					      SC1->C1_PRODUTO,;     //6
					      SC1->C1_LOCAL,;       //7
					      SC1->C1_UM,;          //8
					      SC1->C1_SEGUM,;       //9
					      SC1->C1_DESCRI,;      //10
					      SC1->C1_QUANT,;       //11
					      SC1->C1_CONTA,;       //12
					      SC1->C1_CC,;
					      SC1->C1_QTSEGUM,;
					      SC1->C1_USER,;
					      SC1->C1_SOLICIT,;
					      SC1->C1_ORIGEM,;
					      SC1->C1_DATPRF,;
					      SC1->C1_OBS,;
					      SC1->C1_APROV } )
		
			     //alert("aSC: " + str(len(aSCs)) )
		
	      
   		cCCAnt := SB1X1->B1_CC
   		cTipo 	:= SB1X1->B1_TIPO
   endif   
	SB1X1->( DbSkip() )
Enddo
	
////Ordena o array por ordem de Gestor + SC + item
aGestores := Asort( aGestores2,,, { |X,Y| X[12] + X[3] + X[4] <  Y[12] + Y[3] + Y[4] } ) 
/*	
DbSelectArea("SC1")
if lSC
   ConfirmSX8()
else
   RollBackSX8() 
endif
*/	
DbSelectArea("SB2")
DbSetOrder(1)
		
if lSC
	conOut( "Foi gerada a SC: "+cSC )      
	//alert( "Foi gerada a SC: "+cSC )      
else
	conOut( "Não existem solicitações de compras para serem geradas" )      
	//alert( "Não existem solicitações de compras para serem geradas" )      
endIf
	
if len(aSCs) > 0
   conOut( "Foi(ram) gerada(s) Solicitação(ões) de Compra" )
   //alert( "Foi(ram) gerada(s) Solicitação(ões) de Compra" )
	   
   fEnviaSC(aGestores)
   //alert("ENVIOU EMAIL SC")
	   
Else
	   
   conOut( "Nao existe(m) produto(s) em estoque minimo para gerar SC." )      
   //alert( "Nao existe(m) produto(s) em estoque minimo para gerar SC." )      
	
Endif 

	
SB1X1->( DbCloseArea() )
	
	
return





**************************
Static Function fGeraOP()
************************** 

local aTamSX3
local nTamUser
local aCab     := { }
local aItem    := { }
local nItem    :=  1
local lSc      := .F.
local nPrazo   :=  0
local nSaveSX8
local aOps     := { }
local aSCs     := { }
local aOpsAm   := { }

local cOP      := ""
local nPos     := 0
Local LF	   := CHR(13)+CHR(10) 
Local cCodGestor	:= ""
Local cMailGestor	:= ""
Local cNomeGestor	:= ""
Local aGestores		:= {}
Local aGestores2	:= {}
Local aUsu			:= {}
Local cMailTo		:= ""
Local cCopia		:= ""
Local cAssun		:= ""
Local cBody			:= ""
Local cBody2		:= ""
Local cAnexo		:= ""  
Local lEnviou		:= .f.
Set Date Brit


//Produtos Fabricados - Gera OP
cQuery := "SELECT B1_COD,B1_UM,B1_SEGUM,B1_CONTA,B1_CC, B1_DESC, B1_ESTSEG, B1_EMIN,B1_EMINCX,B1_ESTSEGX " +LF
cQuery += "FROM " + LF
cQuery += " " + RetSqlName("SB1")+" SB1 " +LF

cQuery += "WHERE B1_ATIVO = 'S' " +LF
cQuery += "AND B1_OPAUTOM = 'S' " +LF
cQuery += "AND B1_EMINCX > 0 " +LF     	//novo campo no SB1 - PTO PEDIDO CAIXAS - B1_EMINCX
cQuery += "AND LEN(B1_COD) <= 7 " +LF 
cQuery += " AND B1_TIPO NOT IN ('AC','CI','CL','EP','GG','MA','MH','ML','MP','MQ','MR','MS','MV','SG','ST') 
                               //AC ,CI  ,CL  ,EP  ,GG  , MA  ,ME,MH,ML, MP , MQ , MR , MS , MV ,PA,PI,SG,ST
                               //TIPOS QUE A QUERY RETORNA SE NÃO ESPECIFICAR NO NOT IN

//cQuery += " and B1_COD = 'BGA180' " + LF    ////TESTE

cQuery += "AND B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' " +LF
cQuery += "ORDER BY B1_COD " +LF

MemoWrite("C:\Temp\GeraOp.sql", cQuery)
TCQUERY cQuery NEW ALIAS "SB1X2" 


SB1X2->( DbGoTop() )
	
DbSelectArea("SB2")
DbSetOrder(1)
	
aOps   := {}
nQtd  := 0
nMult := 1

	
while ! SB1X2->( EOF() ) 
	   
   aCart := Carteira( SB1X2->B1_COD )  
   SB2->(DbSeek(xFilial("SB2")+SB1X2->B1_COD+"01"  ) )
   nQtd := ( aCart[1] - SB2->B2_QTSEGUM )
	   
   if nQtd > SB1X2->B1_EMINCX
      nResto := Mod( nQtd, SB1X2->B1_EMINCX )
      if nResto != 0 
	       
         nMult := Int( nQtd / SB1X2->B1_EMINCX ) + 1
         nQtd  := nMult * SB1X2->B1_EMINCX
	         
      endif   
   else
	   
      nQtd  := SB1X2->B1_EMINCX     
	   
   endif
	   
   if !TemOPBB( SB1X2->B1_COD ) //Testo se nao tem Saldo OP ou Bobina
	     //alert("entrou no array aOP")
		      	      
	      DbSelectArea("SC2")
	      aMATRIZ     := {}
		  lMsErroAuto := .F.
		  aMATRIZ     := { { "C2_PRODUTO", SB1X2->B1_COD                 , NIL },;
	                  	   { "C2_QTSEGUM", nQtd                          , NIL },;
	                  	   { "C2_PRIOR"  , "500"                         , NIL },;
	                   	   { "C2_DESTINA", "E"                           , NIL },;
	                   	   { "C2_TPOP"   , "F"                           , NIL },;
	                   	   { "C2_OPVIP"  , "S"                           , NIL },;
	                   	   { "C2_OBS"    , "Gerada por Ponto de Producao", NIL },;                   	                     		
	                   	   { "AUTEXPLODE", "S"                           , NIL } }
				
		  MSExecAuto( { |x,y| MATA650(x,y) }, aMATRIZ, 3 )      
	      Aadd( aOps, { SC2->C2_NUM, SB1X2->B1_COD, SB1X2->B1_EMINCX } ) 
		      
	      //alert("aOps: " + str(len(aOps)) )    
   endif
	    
   SB1X2->( DbSkip() )
enddo
	

if len(aOps) > 0
   conOut( "Foi(ram) gerada(s) Ordem(s) de Producao" )
   //alert( "Foi(ram) gerada(s) Ordem(s) de Producao" )
	   
   cBody := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> '
   cBody += '<html xmlns="http://www.w3.org/1999/xhtml"> '
   cBody += '<head> '
   cBody += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /> '
   cBody += '<title>Untitled Document</title> '
   cBody += '</head> '
   cBody += '<body> '
   cBody += '<p>Caro respons&aacute;vel pelo setor de Produ&ccedil;&atilde;o,</p> '
   cBody += '<p>A seguir veja todas as Ordens de Produ&ccedil;&atilde;o que foram criadas automaticamente, na Filial: Rava/Caixas.</p> '
   cBody += '<table width="471" border="1"> '
   cBody += '  <tr> '
   cBody += '    <th bgcolor="#33CC33" width="145" scope="col">N&uacute;mero da OP </th> '
   cBody += '    <th bgcolor="#33CC33" width="147" scope="col">C&oacute;digo do Produto </th> '
   cBody += '    <th bgcolor="#33CC33" width="157" scope="col">Quantidade</th> '
   cBody += '  </tr> '
   //Aadd( aOps, { SC2->C2_NUM, SB1X3->B1_COD, SB1X3->B1_PTPRODA } )     
   for _nX := 1 to Len(aOps)        
      //cBody += aOps[_nx,1]+' - '+aOps[_nx,2]+"<br> <br>"  
		cBody += "<tr>"
		cBody += "  <td>"+alltrim(aOps[_nx,1])+"</td> "
		cBody += "  <td>"+alltrim(aOps[_nx,2])+"</td> "
		cBody += "  <td align='right'>"+transform(aOps[_nx,3],"@E 999,999,999.99")+"</td> "
   		cBody += "</tr>"
   next _nX     
   cBody += '</table> '
   cBody += '<p>&nbsp;</p> '
   cBody += '</body> '
   cBody += '</html> '
   cMailTo := 'rodrigo.pereira@ravaembalagens.com.br'
   //cMailTo := "flah.rocha@gmail.com"
   cCopia  := ""  //"flavia.rocha@ravaembalagens.com.br"
   cAssun  := "OP por Ponto de Produção"
   cAnexo  := ""
   
   //U_EnviaMail('rodrigo.pereira@ravaembalagens.com.br', 'OP por Ponto de Produção', cBody)     
   //U_EnviaMail('flavia.rocha@ravaembalagens.com.br', 'OP por Ponto de Produção', cBody)     
   //solicitado em 03/05/2010 retirar o email de José Nilton e incluir o de Rodrigo
   U_SendMailSC(cMailTo, cCopia, cAssun, cBody, cAnexo )
   
	   
else
   conOut( "Nao existe(m) produto(s) em estoque minimo para gerar SC/OP." )      
   //alert( "Nao existe(m) produto(s) em estoque minimo para gerar OP." )      
	   
endif
	
	
SB1X2->( DbCloseArea() )
	
		
return



**************************
Static Function fGerOPAM()
**************************



local aTamSX3
local nTamUser
local aCab     := { }
local aItem    := { }
local nItem    :=  1
local lSc      := .F.
local nPrazo   :=  0
local nSaveSX8

local aOpsAm   := { }

local cOP      := ""
local nPos     := 0
Local LF	   := CHR(13)+CHR(10) 
Local aUsu			:= {}
Local cMailTo		:= ""
Local cCopia		:= ""
Local cAssun		:= ""
Local cBody			:= ""
Local cBody2		:= ""
Local cAnexo		:= ""  
Local lEnviou		:= .f.
Set Date Brit

//alert("GERA OP AMOSTRA")

//Produtos Fabricados - Gera OP para amostras  Estoque de Segurança e ponto de produção das amostras
cQuery := "SELECT B1_COD, B1_ESTSEGA, B1_PTPRODA " +LF
cQuery += "FROM "+RetSqlName("SB1")+" SB1 " +LF
cQuery += "WHERE B1_ATIVO = 'S' " +LF
cQuery += "AND B1_OPAUTOM = 'S' " +LF
cQuery += "AND B1_ESTSEGA > 0 "//Estoque de segurança de amostras
cQuery += "AND LEN(B1_COD) <= 7 " +LF

//cQuery += " and B1_COD = 'CTG010' " + LF    ////TESTE

cQuery += "AND B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' " +LF
cQuery += "ORDER BY B1_COD " +LF   
MemoWrite("C:\Temp\GeraOpAM.sql", cQuery)

TCQUERY cQuery NEW ALIAS "SB1X3"

SB1X3->( DbGoTop() )

DbSelectArea("SB2")
DbSetOrder(1)
	
aOpsAm := {}

	
If !SB1X3->( EOF() )
	While !SB1X3->( EOF() )
	 	//alert("ENTROU NO OP AMOSTRA")
	 	
		SB2->(DbsetOrder(1))	   
	   	if ! SB2->( DbSeek(xFilial("SB2") + SB1X3->B1_COD + "03", .F. ) )
		  CriaSB2(SB1X3->B1_COD,"03")
	   	  
	   	endIf	   
	   
	   	if SB1X3->B1_ESTSEGA < SB2->B2_QATU      
	        SB1X3->( DbSkip() )
			Loop
	   	endif   
	   
	   	if TemOPLIC(SB1X3->B1_COD) >= SB1X3->B1_ESTSEGA
	        SB1X3->( DbSkip() )
	   		Loop
	   	endIf
	   
	   	   
	   DbSelectArea("SC2")
	   aMATRIZ     := {}
	   lMsErroAuto := .F.
	   aMATRIZ     := { { "C2_PRODUTO", SB1X3->B1_COD                , NIL },;
	                	{ "C2_QUANT"  , SB1X3->B1_PTPRODA            , NIL },;
	               	    { "C2_PRIOR"  , "500"                        , NIL },;
	                   	{ "C2_DESTINA", "E"                          , NIL },;
	                   	{ "C2_TPOP"   , "F"                          , NIL },;
	                   	{ "C2_OPVIP"  , "S"                          , NIL },;
	                   	{ "C2_OBS"    , "Gerada por Pto.Prod.Amostra", NIL },;
	                   	{ "C2_OPLIC"  , "S"                          , NIL },;
	                   	{ "AUTEXPLODE", "S"                          , NIL } }	
	   MSExecAuto( { |x,y| MATA650(x,y) }, aMATRIZ, 3 )
	   //alert("CRIOU OP AMOSTRA")
	   
	   cOP := SC2->C2_NUM
	   if lMsErroAuto         	  
	   //   return	   
	   	//alert("lMsErro Auto")
	   	
	   endIf
	   
	   nPos := SC2->( Recno() )
	   SC2->(Dbgoto(nPos))
	   do While cOP == SC2->C2_NUM .and. SC2->( !EoF() )
	   	  Reclock("SC2",.F.)
	      SC2->C2_OPLIC = "S"
	      SC2->( msUnlock() )
	      SC2->( dbSkip() )
	   endDo
	   //alert("GRAVOU SC2")	   
	   Aadd( aOpsAm, { cOP, SB1X3->B1_COD, SB1X3->B1_PTPRODA } )     
	   //alert("aOPAM: " + str(len(aOpsAm)) )

	   
	   SB1X3->( DbSkip() )
	Enddo
	 
//Else
 	//alert("SB1X3->VAZIO")
Endif



if len(aOpsAm) > 0
   conOut( "Foi(ram) gerada(s) Ordem(s) de Producao de Amostra" )
	   
   //alert( "Foi(ram) gerada(s) Ordem(s) de Producao de Amostra" )
   
   cBody2 := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> '
   cBody2 += '<html xmlns="http://www.w3.org/1999/xhtml"> '
   cBody2 += '<head> '
   cBody2 += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /> '
   cBody2 += '<title>Untitled Document</title> '
   cBody2 += '</head> '
   cBody2 += '<body> '
   cBody2 += '<p>Caro respons&aacute;vel pelo setor de Produ&ccedil;&atilde;o,</p> '
   cBody2 += '<p>A seguir veja todas as Ordens de Produ&ccedil;&atilde;o de Amostra que foram criadas automaticamente, na Filial: Rava/Caixas.</p> '
   cBody2 += '<table width="471" border="1"> '
   cBody2 += '  <tr> '
   cBody2 += '    <th bgcolor="#33CC33" width="145" scope="col">N&uacute;mero da OP </th> '
   cBody2 += '    <th bgcolor="#33CC33" width="147" scope="col">C&oacute;digo do Produto </th> '
   cBody2 += '    <th bgcolor="#33CC33" width="157" scope="col">Quantidade</th> '
   cBody2 += '  </tr> '
   
   for _nX := 1 to Len(aOpsAm)        
   
		cBody2 += "<tr>"
		cBody2 += "  <td>"+alltrim(aOpsAm[_nx,1])+"</td> "
		cBody2 += "  <td>"+alltrim(aOpsAm[_nx,2])+"</td> "
		cBody2 += "  <td align='right'>"+transform(aOpsAm[_nx,3],"@E 999,999,999.99")+"</td> "
   		cBody2 += "</tr>"
   next _nX     
   cBody2 += '</table> '
   cBody2 += '<p>&nbsp;</p> '
   cBody2 += '</body> '
   cBody2 += '</html> '
   
   cMailTo := 'rodrigo.pereira@ravaembalagens.com.br;alexandre@ravaembalagens.com.br'
   //cMailTo := "flah.rocha@gmail.com"
   cCopia  := ""  //"flavia.rocha@ravaembalagens.com.br"
   cAssun  := "OP de Amostra por Ponto de Produção"
   cAnexo  := ""
   
   //U_EnviaMail('rodrigo.pereira@ravaembalagens.com.br;alexandre@ravaembalagens.com.br', 'OP de Amostra por Ponto de Produção', cBody)     
   //U_EnviaMail('flavia.rocha@ravaembalagens.com.br', 'OP de Amostra por Ponto de Produção', cBody)
   U_SendMailSC(cMailTo, cCopia, cAssun, cBody2, cAnexo )
   
	   
else
	//alert( "Nao existe(m) produto(s) em estoque minimo para gerar OP AMOSTRA." )      
	conout( "Nao existe(m) produto(s) em estoque minimo para gerar OP AMOSTRA." )      
endif
	
SB1X3->( DbCloseArea() )
	
	
	
return


***********************************
Static Function fEnviaSC(aGestores)
***********************************

Local _nX := 1
Local LF  := CHR(13)+CHR(10)
Local cCodGestor := ""
Local cNomeGestor:= ""
Local cMailGestor:= "" 

	   			     

If Len(aGestores) > 0
	
	While _nX  <= Len(aGestores)
	
		////CRIA O PROCESSO WORKFLOW
		oProcess:=TWFProcess():New("MAIL SC","NOVA SC")
		oProcess:NewTask('Inclusao SC',"\workflow\http\oficial\GERASC_Aviso.html")
		oHtml := oProcess:oHtml
		
		oHtml:ValByName("cNumSC", aGestores[_nX,1] )
		oHtml:ValByName("dEmissao"  , Dtoc(aGestores[_nX,13])  ) 		
			
		oProcess:cSubject:= "SC Automática"		
		
		cCodGestor := aGestores[_nX,12]
		
		Do while _nX <= Len(aGestores) .and. Alltrim(aGestores[_nX,12]) == Alltrim(cCodGestor)	
				      
			aadd( oHtml:ValByName("it.cItem")  , aGestores[_nX,2] )  					//ITEM
			aadd( oHtml:ValByName("it.cProd")  , aGestores[_nX,3] )  					//COD. PRODUTO
			aadd( oHtml:ValByName("it.cTipoProd")  , aGestores[_nX,4]) 					//TIPO PRODUTO
			aadd( oHtml:ValByName("it.cDesc")  , aGestores[_nX,5] )       				//DESCRIÇÃO PRODUTO
			aadd( oHtml:ValByName("it.nQtde") , aGestores[_nX,6] )     					//QTDE
			aadd( oHtml:ValByName("it.cObs"), aGestores[_nX,7] )         				//OBSERVAÇÃO
			//aadd( oHtml:ValByName("it.dDatprf"), Dtoc( aGestores[_nX,8]) )	       		//NECESSIDADE
			cMailGestor		:= aGestores[_nX,9]	      
			cNomeGestor 	:= aGestores[_nX,10]
				      
			_nX++
				      
		Enddo
		oHtml:ValByName("cNomeGestor", cNomeGestor )      //Nome do Gestor
		oHtml:ValByName("cMailGestor", cMailGestor )      //Nome do Gestor


		oProcess:cTo:= cMailGestor 
		//oProcess:cTo:= "flah.rocha@gmail.com"
		//oProcess:cCC:= "flavia.rocha@ravaembalagens.com.br" 
		oProcess:cBCC:= ""
		oProcess:Start()
		WfSendMail()
		//alert("enviou email SC")
					
	Enddo		
Endif


Return

//Verifica se tem sol.compras
//para o produto informado
*******************************
static function TemSC( cProd )
*******************************

local cQuery
local lTem

cQuery := "SELECT TOP 1 C1_QUANT  "
cQuery += "FROM "+RetSqlname("SC1")+" " 
cQuery += "WHERE C1_PRODUTO = '"+cProd+"' AND "
cQuery += "C1_EMISSAO >= '20080401' AND C1_PEDIDO = '' AND C1_RESIDUO <> 'S' AND C1_APROV <> 'R' "
cQuery += "AND D_E_L_E_T_ = ''  "
//MemoWrite("C:\Temp\TEMSC.SQL",cQuery)
TCQUERY cQuery NEW ALIAS "TMP1"
lTem := !TMP1->(EOF())
TMP1->(DbCloseArea())

return lTem

//Verifica se tem Pedido de Compra
//Para o produto informado
****************************
Static Function TemPC(cProd)
****************************

local cQuery
local lTem
cQuery := "SELECT TOP 1 C7_NUM "
cQuery += "FROM "+ RetSqlName("SC7") + " "
cQuery += "WHERE  C7_PRODUTO = '" + alltrim(cProd) + "' "
cQuery += "AND (C7_QUANT - C7_QUJE > 0 AND C7_RESIDUO <> 'S' ) "
cQuery += "AND C7_FILIAL = '" + xFilial("SC7") + "' AND D_E_L_E_T_ != '*' "
TCQUERY cQuery NEW ALIAS "TMP1"
lTem := !TMP1->(EOF())
TMP1->(DbCloseArea())

return lTem


//Verifica o Saldo de OP em aberto e
//de Bobinas 
******************************
static function TemOPBB(cProd)
******************************

local cQuery
local nPESBOB := nPESOP := 0

cQuery := "SELECT SC2.C2_NUM, SC2.C2_QUJE, SC2.C2_QTSEGUM, SC2.C2_QUANT - SC2.C2_QUJE AS QUANT, ( SC2.C2_QUANT - SC2.C2_QUJE ) / SB1.B1_CONV AS PESO "
cQuery += "FROM " + RetSqlName( "SC2" ) + " SC2, " + RetSqlName( "SB1" ) + " SB1 "
cQuery += "WHERE SC2.C2_PRODUTO = '" + cProd + "' AND SC2.C2_DATRF = '        ' AND "
cQuery += "SB1.B1_CONV > 0 AND "
cQuery += "SC2.C2_PRODUTO = SB1.B1_COD AND "
cQuery += "SC2.C2_FILIAL = '" + xFilial( "SC2" ) + "' AND SC2.D_E_L_E_T_ = ' ' AND "
cQuery += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' "
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "SC2X"
	
/*
cQuery := "SELECT SG1.G1_COMP "  // Codigo do PI (bobina)
cQuery += "FROM " + RetSqlName( "SG1" ) + " SG1 "
cQuery += "WHERE SG1.G1_COD = '" + cProd + "' AND LEFT( SG1.G1_COMP, 2 ) = 'PI' AND "
cQuery += "SG1.G1_FILIAL = '" + xFilial( "SG1" ) + "' AND SG1.D_E_L_E_T_ = ' ' "
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "SG1X"
*/	
While ! SC2X->( Eof() )
	/*
	cQuery := "SELECT SC2.C2_QUANT,SC2.C2_QUJE "  // Query de estoque do PI (bobina)
	cQuery += "FROM " + RetSqlName( "SC2" ) + " SC2 "
	cQuery += "WHERE SC2.C2_NUM = '" + SC2X->C2_NUM + "' AND SC2.C2_PRODUTO = '" + SG1X->G1_COMP + "' AND "
	cQuery += "SC2.C2_FILIAL = '" + xFilial( "SC2" ) + "' AND SC2.D_E_L_E_T_ = ' ' "
	cQuery := ChangeQuery( cQuery )
	TCQUERY cQuery NEW ALIAS "SC2Y"
	*/
	nPESOP += SC2X->PESO
//	If Empty( SC2X->C2_QUJE )  // OP nao foi iniciada
//		nPESBOB += SC2Y->C2_QUJE
//	ElseIf SC2Y->C2_QUJE - ( SC2X->C2_QTSEGUM / SC2X->C2_QUJE * SC2X->C2_QUJE ) > 0  // OP ja iniciada
//		nPESBOB += SC2Y->C2_QUJE - ( SC2X->C2_QTSEGUM / SC2X->C2_QUJE * SC2X->C2_QUJE )
//	EndIf
//	SC2Y->( DbCloseArea() )
	SC2X->( DbSkip() )
End
SC2X->( DbCloseArea() )
//SG1X->( DbCloseArea() )

return ( nPESOP + nPESBOB ) > 0



****************************************
Static Function Carteira( cProd, nTipo )
****************************************

//nTipo = 1: Carteira Programada
//nTipo = 2: Carteira Pronta para Faturar (Imediata)

Local aArret := {}

Default nTipo := 0

cCart := "SELECT SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) / SB1.B1_CONV) AS CARTEIRA_KG, SUM((SC6.C6_QTDVEN - SC6.C6_QTDENT) * SC6.C6_PRUNIT) AS CARTEIRA_RS, min(SC5.C5_ENTREG) AS DAT "
cCart += "FROM " + RetSqlName( "SB1" ) + " SB1, " + RetSqlName( "SC5" ) + " SC5, " + RetSqlName( "SC6" )+ " SC6, " + RetSqlName( "SC9" )+ " SC9 "
cCart += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cCart += "SC6.C6_PRODUTO = '"+cProd+"' AND "
cCart += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
cCart += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
//cCart += "SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND "
// NOVA LIBERACAO DE CRETIDO
cCart += "SC9.C9_BLCRED IN( '  ','04') and SC9.C9_BLEST != '10' AND "

if nTipo = 1
  cCart += "SC5.C5_ENTREG > '"+ dtos( lastday( dDataBase ) + 1 ) + "' and "
elseif nTipo = 2
  cCart += "SC5.C5_ENTREG <= '"+ dtos( lastday( dDataBase ) ) + "' and "
endif

cCart += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' AND "
cCart += "SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' AND SC5.D_E_L_E_T_ = ' ' AND "
cCart += "SC6.C6_FILIAL = '" + xFilial( "SC6" ) + "' AND SC6.D_E_L_E_T_ = ' ' AND "
cCart += "SC9.C9_FILIAL = '" + xFilial( "SC9" ) + "' AND SC9.D_E_L_E_T_ = ' ' " 
//MemoWrite("C:\Temp\carteira.sql",cCart)
cCart := ChangeQuery( cCart )
TCQUERY cCart NEW ALIAS "CARX"
TCSetField('CARX',"DAT","D")

Aadd( aArret, CARX->CARTEIRA_KG )
Aadd( aArret, CARX->CARTEIRA_RS )

CARX->( DbCloseArea() )

Return aArret

***************

static function TemOPLIC(cProd)

***************

local cQuery
local nPESOP := 0

cQuery := "SELECT SC2.C2_NUM, SC2.C2_QUJE, SC2.C2_QTSEGUM, SC2.C2_QUANT - SC2.C2_QUJE AS QUANT, "
cQuery += "( SC2.C2_QUANT - SC2.C2_QUJE ) / SB1.B1_CONV AS PESO "
cQuery += "FROM " + RetSqlName( "SC2" ) + " SC2, " + RetSqlName( "SB1" ) + " SB1 "
cQuery += "WHERE SC2.C2_PRODUTO = '" + cProd + "' AND SC2.C2_DATRF = '        ' AND "
cQuery += "SC2.C2_PRODUTO = SB1.B1_COD AND SC2.C2_OPLIC = 'S' AND "
cQuery += "SC2.C2_FILIAL = '" + xFilial( "SC2" ) + "' AND SC2.D_E_L_E_T_ = ' ' AND "
cQuery += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' "
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "SC2X"
	
While ! SC2X->( Eof() )
	nPESOP += SC2X->PESO
	SC2X->( DbSkip() )
End
SC2X->( DbCloseArea() )

return nPESOP


******************************************************************
User Function SendMailSC(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
******************************************************************

Local cEmailCc  := cCopia
Local lResult   := .F. 
Local lEnviado  := .F.
Local cError    := ""

Local cAccount	:= GetMV( "MV_RELACNT" )
Local cPassword := GetMV( "MV_RELPSW"  )
Local cServer	:= GetMV( "MV_RELSERV" )
Local cAttach 	:= cAnexo
Local cFrom		:= "" //GetMV( "MV_RELACNT" )
cFrom  := "rava@siga.ravaembalagens.com.br"

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

if lResult
	
	MailAuth( GetMV( "MV_RELACNT" ), GetMV( "MV_RELPSW"  ) ) //realiza a autenticacao no servidor de e-mail.

	SEND MAIL FROM cFrom;
	TO cMailTo;
	CC cCopia;
	SUBJECT cAssun;
	BODY cCorpo;
	ATTACHMENT cAnexo RESULT lEnviado
	
	if !lEnviado
		//Erro no envio do email
		GET MAIL ERROR cError
		Help(" ",1,"ATENCAO",,cError,4,5)
		//alert("E-mail não enviado...")
		
		conout("E-mail nao enviado")
		
		conout(Replicate("*",60))
	//else
		//MsgInfo("E-mail Enviado com Sucesso!")
	endIf
	
	DISCONNECT SMTP SERVER
	
else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,"ATENCAO",,cError,4,5)
endif

Return(lResult .And. lEnviado )


