#INCLUDE "TOPCONN.CH"
#include 'Ap5Mail.ch'
#include "rwmake.ch"
/*
///////////////////////////////////////////////////////////////////////////////////
PONTO.......: SD1140I           PROGRAMA....: MATA140
DESCRIÇÄO...: APOS GRAVACAO DO SD1
UTILIZAÇÄO..: Executado apos gravacao da pré-nota, será enviado um email avisando 
              sobre a inclusão da mesma.
PARAMETROS..: Nenhum
RETORNO.....: Nenhum
Autoria.....: Flávia Rocha
Data........: 11/08/2010
////////////////////////////////////////////////////////////////////////////////////
*/ 

****************************
User Function SD1140I() 
****************************

cArea    := GetArea()         // salva área do arquio atual
cAreaSD1 := SD1->(GetArea())  // salva área do arquivo SD1
cAreaSF1 := SF1->(GetArea())  // salva área do arquivo SF1

SF1->(RestArea(cAreaSF1))  // restaura área do arquivo SF1
SD1->(RestArea(cAreaSD1))  // restaura área do arquivo SD1


If Inclui
	//U_MailPrenota(SD1->D1_DOC, SD1->D1_SERIE, SD1->D1_TIPO)	
Endif

RestArea(cArea)            // restaura área do arquivo atual

Return

******************************************************
User Function MAILPRENOTA( cNota, cSerie, cTipo )
******************************************************

Local aPrenota 	:= {}
Local dEmissao	:= Ctod("  /  /    ")
Local _nX    	:= 0
Local cQuery 	:= ""
Local aUsu		:= {} 
Local eEmail	:= ""
Local nTotGer	:= 0
Local cCodUser  := ""	//código do usuário que está logado
Local cUserMail := ""   //irá armazenar o email do usuário logado
Local cNomeCliFor:= ""
Local LF      	:= CHR(13)+CHR(10) 
Local cCliFor	:= ""
Local cLojaCliFor:= ""
Local cTipoCliFor:= ""
Local nTotIPI	:= 0  
Local cDesc		:= ""




Local cCodUser := ""

////Informações do usuário que está logado...
cCodUser := __CUSERID

PswOrder(1)
If PswSeek( cCoduser, .T. )
   aUsu := PSWRET() 						// Retorna vetor com informações do usuário
   //cCodUser  := Alltrim(aUsua[1][1])  	//código do usuário no arq. senhas
   //cNomeuser := Alltrim(aUsua[1][2])		// Nome do usuário
   cUserMail := Alltrim( aUsu[1][14] )     
Endif


//SetPrvt("OHTML,OPROCESS")

//MSGBOX(cNota + "/" + cSerie + "-"+ cTipo)

////CRIA O PROCESSO WORKFLOW
oProcess:=TWFProcess():New("PRE-NOTA","PRE-NOTA")
oProcess:NewTask('Inclusao PRE-Nota',"\workflow\http\oficial\PRENOTA.html")
oHtml := oProcess:oHtml


oHtml:ValByName("cPrenf", cNota )
oHtml:ValByName("cSerie"  , cSerie )
oHtml:ValByName("cTipoNF"  , iif(cTipo = "D", "Devolução de Venda", "Normal")  )


//conout(Replicate("*",60))
//conout("AVISO PRE-NOTA - " + Dtoc(Date()) + "-" + Time() + " INICIO")
//conout(Replicate("*",60))

oProcess:cSubject:= "Aviso de Inclusão - Pré-Nota"
SD1->(Dbsetorder(1))
If SD1->(DBSeek(xFilial("SD1") + cNota + cSerie ))
	While SD1->(!EOF())  .AND. SD1->D1_FILIAL == xFilial("SD1") .AND. SD1->D1_DOC == cNota .and. SD1->D1_SERIE == cSerie
	
			
			aPrenota		:= {}
			dEmissao	:= SD1->D1_EMISSAO
			cCliFor		:= SD1->D1_FORNECE
			cLojaCliFor := SD1->D1_LOJA
			If SD1->D1_TIPO = "D"
				SA1->(DBSETORDER(1))
				SA1->(DBSEEK(xFilial("SA1") + cCliFor + cLojaCliFor ))
				
				cNomeCliFor	:= Alltrim(SA1->A1_NOME)
				cTipoCliFor := "Cliente: "
			Else
				SA2->(DBSETORDER(1))
				SA2->(DBSEEK(xFilial("SA2") + cCliFor + cLojaCliFor ))
				cNomeCliFor := Alltrim(SA2->A2_NOME)
				cTipoCliFor := "Fornecedor: "
			Endif
			
		
			nTotGer += SD1->D1_TOTAL
			nTotIPI += SD1->D1_VALIPI
			
			SB1->(Dbsetorder(1))
			SB1->(Dbseek(xFilial("SB1") + SD1->D1_COD ))
			cDesc := Alltrim(SB1->B1_DESC)
			
			aadd( aPrenota, { SD1->D1_ITEM,;		//1
			      			 SD1->D1_COD,;		//2
			       			 cDesc,;   	//3
			   			     SD1->D1_QUANT,;  	//4
			   			     SD1->D1_VUNIT,;    	//5
			   			     SD1->D1_TOTAL,;      //6
			   			     SD1->D1_TES,;        //7
			   			     SD1->D1_CF,;			//8
			   			     SD1->D1_IPI,;        //9
			   			     SD1->D1_PICM,;       //10
			   			     SD1->D1_VALIPI  } ) 	//11
					
					
		
			DbselectArea("SD1")
			SD1->(DBSKIP())
			
		Enddo 
//Else
	//Msgbox("não gravou SD1")
Endif  
	
For _nX := 1 to len(aPrenota)
		      
		      aadd( oHtml:ValByName("it.cItem")  , aPrenota[_nX,1] )        										//ITEM
		      aadd( oHtml:ValByName("it.cProd")  , aPrenota[_nX,2] )      										//COD. PRODUTO
		      aadd( oHtml:ValByName("it.cDesc")  , aPrenota[_nX,3] )       										//DESCRIÇÃO PRODUTO
		      aadd( oHtml:ValByName("it.nQtde") , aPrenota[_nX,4] )     											//QTDE
		      aadd( oHtml:ValByName("it.nValUni"), Transform(aPrenota[_nX,5], "@E 999,999.9999") )         		//VALOR UNITÁRIO
		      aadd( oHtml:ValByName("it.nValTot"), Transform(aPrenota[_nX,6], "@E 999,999.99") )	       			//VALOR TOTAL
		      //aadd( oHtml:ValByName("it.cTES") , aPrenota[_nX,7] )     											//TES
		      //aadd( oHtml:ValByName("it.cCFOP") , aPrenota[_nX,8] )     											//CFOP
		      //aadd( oHtml:ValByName("it.nIPI") , Transform(aPrenota[_nX,9], "@E 99.99") )     					//ALIQ. IPI
		      //aadd( oHtml:ValByName("it.nICM") , Transform(aPrenota[_nX,10], "@E 99.99") )     					//ALIQ. ICM
		      //aadd( oHtml:ValByName("it.nValIPI"), Transform(aPrenota[_nX,11], "@E 999,999.9999") )         		//VALOR IPI
		      
		      
Next _nX	

oHtml:ValByName("cTipoCliFor", cTipoCliFor )      //Irá sair "Cliente: " ou "Fornecedor: "
oHtml:ValByName("cCliFor", cCliFor )                //codigo do cliente ou fornecedor
oHtml:ValByName("cLojaCliFor", cLoja )                  //loja
oHtml:ValByName("cNomeCliFor", cNomeCliFor )        //razão social

oHtml:ValByName("dEmissao", Dtoc(dEmissao) )  

oProcess:cTo:= cUserMail
//oProcess:cCC:= "flavia.rocha@ravaembalagens.com.br"  
oProcess:cCC:= "cintia.araujo@ravaembalagens.com.br"  
oProcess:cBCC:= ""
oHtml:ValByName("nTotGer", Transform(nTotGer,"@E 999,999.99") )
oHtml:ValByName("nTotGerIPI", Transform( (nTotGer + nTotIPI),"@E 999,999.99") )

oProcess:Start()
WfSendMail()


Return
