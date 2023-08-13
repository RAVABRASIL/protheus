#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//*****************************************************************************************************
//PROGRAMA: MA030TOK - PONTO DE ENTRADA NA CONFIRMA��O DO CADASTRO DO CLIENTE (INCLUS�O / ALTERA��O)
//ALTERADO POR: FL�VIA ROCHA
//DATA: 02/12/13
//*****************************************************************************************************

************************
User Function MA030TOK()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
************************

local cMsg
local cMailTo := "" 
local aIsentos := {}
 
local lRET := .T. 

Aadd(aIsentos , {"MANAUS",;
				 "RIO PRETO DA EVA" ,;
				 "PRESIDENTE FIGUEIREDO",;
				 "MACAPA", ;
		   		 "SANTANA", ;
			     "BONFIM", ;
			     "PACARAIMA", ;
			     "GUAJARAMIRIM", ;
			     "TABATINGA", ;
			     "CRUZEIRO DO SUL", ;
			     "BRASILEIA",;
			     "EPITACIOLANDIA" } )

	If M->A1_EST $ "AM*RO*AP*RR" .and. Empty( M->A1_SUFRAMA )     //FR - 02/12/13 - INCLU�DO O ESTADO RR (RORAIMA)		 	
		If Empty(M->A1_TEMSUF) .or.  M->A1_TEMSUF = "S" 
			Alert( "Informe o C�digo SUFRAMA do Cliente, " + chr(13) + chr(10);
		      + "Caso REALMENTE N�o Tenha, Deixe Vazio, e Preencha o Campo 'TEM SUFRAMA' = N�o " )
		 	lRET := .F.
		Elseif M->A1_TEMSUF = "N"
			lRET := .T.
		Endif
	
	EndIf
	If M->A1_EST $ "AM*RO*AP*RR" .and. Empty( M->A1_CODMUN )		//FR - 02/12/13 - INCLU�DO O ESTADO RR (RORAIMA)
		 //SOMENTE AS CIDADES ABAIXO, EST�O LIVRES DO C�DIGO MUNIC�PIO ZONA FRANCA, POIS S�O �REAS DE LIVRE COM�RCIO
		 /*
		 If ALLTRIM(UPPER(M->A1_MUN)) != "MACAPA" ;
		   .and. ALLTRIM(UPPER(M->A1_MUN)) !="SANTANA" ;
		   .and. ALLTRIM(UPPER(M->A1_MUN)) !="BONFIM" ;
		   .and. ALLTRIM(UPPER(M->A1_MUN)) !="PACARAIMA" ;
		   .and. ALLTRIM(UPPER(M->A1_MUN)) !="GUAJARAMIRIM" ;
		   .and. ALLTRIM(UPPER(M->A1_MUN)) !="TABATINGA" ;
		   .and. ALLTRIM(UPPER(M->A1_MUN)) !="CRUZEIRO DO SUL" ;
		   .and. ALLTRIM(UPPER(M->A1_MUN)) != "BRASILEIA"
		   */
		   nPos := 0
		   nPos := Ascan(aIsentos , UPPER(ALLTRIM(M->A1_MUN)) )
		   If nPos = 1          //se nPos = 0, � porque o munic�pio digitado, n�o faz parte da lista de isentos
		 		Alert( "Informe o C�digo de Munic�pio Zona Franca do Cliente" )
		 		lRET := .F.
		 		
		   Endif
	EndIf
	

/*
Quanto ao ICMS

    As sa�das de mercadorias para Zona Franca de Manaus e �reas de Livre Com�rcio s�o isentas do ICMS somente quando os produtos forem destinados aos Munic�pios indicados nos arts. 5� e 84 do Anexo I do RICMS/00.
    Logo, se os produtos se destinarem a qualquer outro Munic�pio que n�o esteja indicado nos arts. 5� e 84 do Anexo I do RICMS/00, n�o ser� aplicada a isen��o, mesmo que os destinat�rios estejam devidamente cadastrados na SUFRAMA.
    Observe que para o ICMS, conforme indicado nos artigos mencionados:

    a) a Zona Franca de Manaus compreende os Munic�pios de Manaus, Rio Preto da Eva e Presidente Figueiredo;
    b) as �reas de Livre Com�rcio compreendem os Munic�pios de Macap� e Santana, 
    no Estado do Amap�, Bonfim e Pacaraima, 
    no Estado de Roraima, Guajaramirim, 
    no Estado de Rond�nia, Tabatinga, 
    no Estado do Amazonas, e Cruzeiro do Sul e Brasil�ia, 
    com extens�o para o Munic�pio de Epitaciol�ndia, no Estado do Acre.

    Em resumo, a isen��o do ICMS somente poder� ser aplicada quando as mercadorias forem destinadas a contribuintes 
    localizados nas �reas mencionadas anteriormente, devendo o destinat�rio obrigatoriamente estar cadastrado na SUFRAMA.

    Quanto ao IPI

    A Zona Franca de Manaus compreende apenas o Munic�pio de Manaus, cujas remessas de mercadorias destinadas a tal �rea
    est�o acobertadas pela suspens�o do IPI (IPI suspenso, art. 71 do RIPI/02).
    As �reas de Livre Com�rcio compreendem os Munic�pios de:

    a) Macap� e Santana, no Estado do Amap� (suspens�o do IPI, art. 101 do RIPI/02);
    b) Bonfim e Pacaraima, no Estado de Roraima (suspens�o do IPI, art. 98 do RIPI/02);
    c) Guajaramirim, no Estado de Rond�nia, (suspens�o do IPI, art. 95 do RIPI/02);
    d) Tabatinga, no Estado do Amazonas, (suspens�o do IPI, art. 92 do RIPI/02);
    e) Cruzeiro do Sul e Brasil�ia no Estado do Acre (suspens�o do IPI, art. 104 do RIPI/02). 
*/

/*
�����������������������������������������������������������������������������
���Programa  �MA030TOK  �Autor  �Eurivan Marques     � Data �  30/03/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada na Inclusao de Clientes. Enviar� e-mail par���
���          �a respons�vel do Setor de Pos-vendas.                       ���
�������������������������������������������������������������������������͹��
���Uso       � Faturamento                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
if Inclui .and. lRet

   cMsg := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
   cMsg += '<html xmlns="http://www.w3.org/1999/xhtml">'
   cMsg += '<head>'
   cMsg += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />'
   cMsg += '<title>Cliente Novo</title>'
   cMsg += '<style type="text/css">'
   cMsg += '<!--'
   cMsg += '.style1 {'
   cMsg += '	font-family: Arial, Helvetica, sans-serif;'
   cMsg += '	font-size: 13px;'
   cMsg += '	font-weight: bold;'
   cMsg += '}'
   cMsg += '.style13 {font-family: Arial, Helvetica, sans-serif; color: #FFFFFF; font-weight: bold; font-size: 12px; }'
   cMsg += '.style15 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; }'
   cMsg += '-->'
   cMsg += '</style>'
   cMsg += '</head>'
   cMsg += '<body>'
   cMsg += '<p class="style15">O sistema identificou a inclus&atilde;o de um novo cliente.</p>'
   cMsg += '<p class="style15">Favor proceder com as atualiza&ccedil;&otilde;es dos Contatos: T&eacute;cnico e Estrat&eacute;gico.</p>'
   cMsg += '<table width="828" border="1">'
   cMsg += '  <tr>'
   cMsg += '    <td width="58" bgcolor="#009933"><span class="style13">C&oacute;digo</span></td>'
   cMsg += '    <td width="45" bgcolor="#009933"><span class="style13">Loja</span></td>'
   cMsg += '    <td width="371" bgcolor="#009933"><span class="style13">Cliente</span></td>'
   cMsg += '    <td width="158" bgcolor="#009933"><span class="style13">Data Inclus&atilde;o </span></td>'
   cMsg += '    <td width="162" bgcolor="#009933"><span class="style13">Usu&aacute;rio</span></td>'
   cMsg += '  </tr>'
   cMsg += '  <tr>'
   cMsg += '    <td><span class="style15">'+M->A1_COD+'</span></td>'
   cMsg += '    <td><span class="style15">'+M->A1_LOJA+'</span></td>'
   cMsg += '    <td><span class="style15">'+M->A1_NOME+'</span></td>'
   cMsg += '    <td><span class="style15">'+DtoC(dDataBase)+'</span></td>'
   cMsg += '    <td><span class="style15">'+AllTrim(Substr(cUsuario,7,15))+'</span></td>'
   cMsg += '  </tr>'
   cMsg += '</table>'
   cMsg += '<p class="style1">Rava Embalagens Ind. e Com. Ltda. </p>'
   cMsg += '</body>'
   cMsg += '</html>'
   cMailTo := "eurivan@ravaembalagens.com.br"
   //cMailTo += ";flavia.rocha@ravaembalagens.com.br"
   U_EnviaMail( cMailTo,'INCLUS�O DE CLIENTE NOVO',cMsg )   
endif


//MSMM(,,,M->A1_PRDTECV,1,,,'SA1',"A1_RPRDTEC")


Return lRET