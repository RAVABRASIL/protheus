#include "RWMAKE.ch"
#include "Font.ch"
#Include "HBUTTON.CH"
#include "Topconn.ch"
#include "Ap5mail.ch"
#include "xmlxfun.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TOPCONN.CH" 
#INCLUDE "TOTVS.CH"
#INCLUDE "XMLXFUN.CH"


************************
User Function fXmlIbiz()
************************


If Select( 'SX2' ) == 0
   //RAVA EMB
   RPCSetType( 3 )
   PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "fXmlIbiz" Tables "Z57"
   sleep( 5000 )
   conOut( "Programa fXmlIbiz na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
   Exec() 
Else
   conOut( "Programa fXmlIbiz sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
   Exec() 
EndIf

conOut( "Finalizando programa fXmlIbiz em " + Dtoc( DATE() ) + ' - ' + Time() )

Return 


**********************
Static Function Exec()
**********************

//local cCaminho := 'D:\Protheus11\Protheus_Data\system\ibiz\'  

local cStartPath := GetSrvProfString("Startpath","")
cCaminho :=cStartPath+"ibiz\"

aFiles := DIRECTORY(cCaminho+"*.xml")

if Len(aFiles)<=0
   aFiles := DIRECTORY(cCaminho+"*.xml.bin")
endif

BEGIN TRANSACTION

For nArq := 1 To Len(aFiles)
	NomeArq:=alltrim(strtran(aFiles[nArq,1],'.BIN',''))             
	cFile := AllTrim(cCaminho+aFiles[nArq,1])	
	if !jaLeu('IBIZ',NomeArq)
		cFile := AllTrim(cCaminho+aFiles[nArq,1])
		nHdl    := fOpen(cFile,0) 
		If nHdl <> -1	       
			nTamFile := fSeek(nHdl,0,2)
			fSeek(nHdl,0,0)
			cBuffer   := Space(nTamFile)                // Variavel para criacao da linha do registro para leitura
			original  := Space(nTamFile)                // Variavel para criacao da linha do registro para leitura
			nLidos    := fRead(nHdl,@cBuffer,nTamFile)  
		   cBuffer   := strtran(cBuffer,'iso8859-1','iso-8859-1')
		   cBuffer   := strtran(cBuffer,'iso88591' ,'iso-8859-1')
		   cBuffer   := strtran(cBuffer,'iso-88591','iso-8859-1')
		   @original := @cBuffer
			fClose(nHdl) 
         //XML 	
	      cAviso := ""
         cErro  := ""
	      oXml := XmlParser(cBuffer,"_",@cAviso,@cErro)           
         if !empty(cAviso) .Or. !empty(cErro)
            if Select( 'SX2' ) == 0 
               conOut("problema na leitura do xml ")            
            else
               alert("problema na leitura do xml ")                          
            endif   
            xfile:=Fcreate(cCaminho+'Erro\'+nomearq,2)
            fClose(xfile)	
            return 
         endif           
         //          
			xfile := Fcreate(cCaminho+'Salvo\'+nomearq,2)
         fClose(xfile)
         salvo := fopen(cCaminho+'Salvo\'+nomearq,2)
         FWRITE(salvo,@original,len(@original))      
         fClose(salvo)     
		 	if salvo > 0 
		      FERASE(cFile)
		      fsalva(NomeArq,'IBIZ')
			endif
		else
		   If Select( 'SX2' ) == 0 
		      conOut( "O arquivo de nome "+cFile+" nao pode ser aberto! " ) 
		   else
		      MsgAlert("O arquivo de nome "+cFile+" nao pode ser aberto! ","Atencao!") 
		   EndIf
		   xfile:=Fcreate(cCaminho+'Erro\'+nomearq,2)
         fClose(xfile)
		EndIf
	else
	   If Select( 'SX2' ) == 0 
		   conOut( "O arquivo de nome "+NomeArq+" Já Lido.") 
	   else
	      MsgAlert("O arquivo de nome "+NomeArq+" Já Lido.","Atencao!")
	   EndIf   
      FERASE(cFile)	    
   Endif
Next

END TRANSACTION

Return 

****************************************
Static function fsalva(NomeArq,cEmpresa)
****************************************

Local cWord := ""

/*  
estrututa do Xml da Ibiz, onde _x e a quntidade de licitacao dentro do xml 

oxml
    | _aviso_oportunidades_ibiz
                               |_licitacoes:_licitacao[_x]
                                                          |_dados_edital
                                                          |             |_edital:text (Z57_EDITAL)
                                                          |             |_edital_data_abertura:text (Z57_ABERTU -Posicao 1 a 10 ; Z57_HRABER -posicao 12 a 16)
                                                          |             |_edital_link_edital_original:text (Z57_LINK1 ; Z57_TIT1)
                                                          |             |_edital_link_licitacao_original:text (Z57_LINK2 ; Z57_TIT2)
                                                          |             |_edital_modalidade:text (Z57_MODALI)
                                                          |             |_edital_resumo:text (Z57_RESUMO)
                                                          |
                                                          |_dados_ibiz
                                                          |             |_ibiz_data_captura:text (Z57_CAPTUR -Posicao 1 a 10 ; Z57_HRCAP -posicao 12 a 16)
                                                          |             |_ibiz_id_licitacao:text (Z57_COD)
                                                          |             |_ibiz_link_itens_lotes  (Z57_LINK3 ; Z57_TIT3)
                                                          |             |_ibiz_trechos_encontrados
                                                          |                   |_ibiz_trecho_encontrado:text (Z57_DESCRI)
                                                          |
                                                          |_dados_licitador
                                                          |             |_licitador:text (Z57_LICITA)
                                                          |             |_licitador_end_cidade:text (Z57_CIDADE)
                                                          |             |_licitador_end_estado:text (Z57_UF)
*/                                                                      
if TYPE("oxml:_aviso_oportunidades_ibiz")<>'U'
   if TYPE("oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao[1]:_dados_ibiz:_ibiz_id_licitacao:text")<>'U' 
   	for _x:=1 to len(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao)
		   cWord := ""
		   RecLock("Z57",.T.)
		   Z57->Z57_FILIAL := xFilial("Z57")
	      Z57->Z57_ARQUIV := UPPER(Alltrim(NomeArq))
		   Z57->Z57_NOME   := Alltrim(cEmpresa)

	      //bloco da informacao do Edital
	      Z57->Z57_EDITAL := ALLTRIM(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao[_x]:_dados_edital:_edital:text)
	      Z57->Z57_ABERTU := CTOD(substr(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao[_x]:_dados_edital:_edital_data_abertura:text,1,10))       
	      Z57->Z57_HRABER := substr(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao[_x]:_dados_edital:_edital_data_abertura:text,12,5)       
	      Z57->Z57_LINK1  := ALLTRIM(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao[_x]:_dados_edital:_edital_link_edital_original:text)
	      Z57->Z57_TIT1   := ALLTRIM(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao[_x]:_dados_edital:_edital_link_edital_original:text)
	      Z57->Z57_LINK2  := ALLTRIM(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao[_x]:_dados_edital:_edital_link_licitacao_original:text)
	      Z57->Z57_TIT2   := ALLTRIM(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao[_x]:_dados_edital:_edital_link_licitacao_original:text)
	      Z57->Z57_MODALI := ALLTRIM(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao[_x]:_dados_edital:_edital_modalidade:text)

	      //bloco da informacao dos dados da Ibiz
	      Z57->Z57_CAPTUR := CTOD(substr(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao[_x]:_dados_ibiz:_ibiz_data_captura:text,1,10))
	      Z57->Z57_HRCAP  := substr(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao[_x]:_dados_ibiz:_ibiz_data_captura:text,12,5)
	      Z57->Z57_COD    := strzero(val(Alltrim(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao[_x]:_dados_ibiz:_ibiz_id_licitacao:text)),9)	
	      Z57->Z57_LINK3  := ALLTRIM(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao[_x]:_dados_ibiz:_ibiz_link_itens_lotes:text)
	      Z57->Z57_TIT3   := ALLTRIM(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao[_x]:_dados_ibiz:_ibiz_link_itens_lotes:text)

         //palavra encontradas
         if TYPE("oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao[_x]:_dados_ibiz:_ibiz_palavras_encontradas:_ibiz_palavra_encontrada")=='A' 
	         for _y := 1 to len(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao[_x]:_dados_ibiz:_ibiz_palavras_encontradas:_ibiz_palavra_encontrada)	         
	            cWord += ALLTRIM(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao[_x]:_dados_ibiz:_ibiz_palavras_encontradas:_ibiz_palavra_encontrada[_y]:text)+";"
   	      next _y 
   	   else
	         cWord := ALLTRIM(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao[_x]:_dados_ibiz:_ibiz_palavras_encontradas:_ibiz_palavra_encontrada:text)   	   
	      endif   
         Z57->Z57_PALAVR := cWord

	      //bloco da informacao dos dados do Licitante 
	      Z57->Z57_LICITA := ALLTRIM(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao[_x]:_dados_licitador:_licitador:text)
	      Z57->Z57_CIDADE := ALLTRIM(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao[_x]:_dados_licitador:_licitador_end_cidade:text)
	      Z57->Z57_UF     := ALLTRIM(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao[_x]:_dados_licitador:_licitador_end_estado:text)

	      //bloco da informacao do recebimento 
		   Z57->Z57_DTREC  := ddatabase
		   Z57->Z57_HRREC  := left(time(),5)
		   Z57->(MsUnlock())

		   //campos memos 
		   MSMM(,,,lower(ALLTRIM(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao[_x]:_dados_edital:_edital_resumo:text)),1,,,'Z57','Z57_RESUMO')           // bloco da informacao do Edital
		   MSMM(,,,lower(ALLTRIM(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao[_x]:_dados_ibiz:_ibiz_trechos_encontrados:_ibiz_trecho_encontrado:text)),1,,,'Z57','Z57_DESCRI')  // bloco da informacao dos dados da Ibiz	    
	   Next _x
   elseif TYPE("oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao")<>'U' 
	   //
	   RecLock("Z57",.T.) 
	   Z57->Z57_FILIAL := xFilial("Z57") 
	   Z57->Z57_ARQUIV := UPPER(Alltrim(NomeArq))
	   Z57->Z57_NOME   := Alltrim(cEmpresa)
	   //bloco da informacao do Edital
	   Z57->Z57_EDITAL := ALLTRIM(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao:_dados_edital:_edital:text)
	   Z57->Z57_ABERTU := CTOD(substr(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao:_dados_edital:_edital_data_abertura:text,1,10))       
	   Z57->Z57_HRABER := substr(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao:_dados_edital:_edital_data_abertura:text,12,5)       
	   Z57->Z57_LINK1  := ALLTRIM(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao:_dados_edital:_edital_link_edital_original:text)
	   Z57->Z57_TIT1   := ALLTRIM(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao:_dados_edital:_edital_link_edital_original:text)
	   Z57->Z57_LINK2  := ALLTRIM(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao:_dados_edital:_edital_link_licitacao_original:text)
	   Z57->Z57_TIT2   := ALLTRIM(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao:_dados_edital:_edital_link_licitacao_original:text)
	   Z57->Z57_MODALI := ALLTRIM(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao:_dados_edital:_edital_modalidade:text)
	   //bloco da informacao dos dados da Ibiz
	   Z57->Z57_CAPTUR := CTOD(substr(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao:_dados_ibiz:_ibiz_data_captura:text,1,10))
    	Z57->Z57_HRCAP  := substr(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao:_dados_ibiz:_ibiz_data_captura:text,12,5)
	   Z57->Z57_COD    := strzero(val(Alltrim(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao:_dados_ibiz:_ibiz_id_licitacao:text)),9)	
	   Z57->Z57_LINK3  := ALLTRIM(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao:_dados_ibiz:_ibiz_link_itens_lotes:text)
	   Z57->Z57_TIT3   := ALLTRIM(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao:_dados_ibiz:_ibiz_link_itens_lotes:text)

      //palavra encontradas
      if TYPE("oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao:_dados_ibiz:_ibiz_palavras_encontradas:_ibiz_palavra_encontrada")=='A' 
         for _y := 1 to len(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao:_dados_ibiz:_ibiz_palavras_encontradas:_ibiz_palavra_encontrada)
	         cWord += ALLTRIM(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao:_dados_ibiz:_ibiz_palavras_encontradas:_ibiz_palavra_encontrada[_y]:text)+";"
         next _y  
      else
	      cWord := ALLTRIM(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao:_dados_ibiz:_ibiz_palavras_encontradas:_ibiz_palavra_encontrada:text)   	   
	   endif   
      Z57->Z57_PALAVR := cWord
	
	   //bloco da informacao dos dados do Liitante 
	   Z57->Z57_LICITA := ALLTRIM(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao:_dados_licitador:_licitador:text)
	   Z57->Z57_CIDADE := ALLTRIM(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao:_dados_licitador:_licitador_end_cidade:text)
	   Z57->Z57_UF     := ALLTRIM(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao:_dados_licitador:_licitador_end_estado:text)
	   //bloco da informacao do recebimento 
	   Z57->Z57_DTREC  := ddatabase
	   Z57->Z57_HRREC  := left(time(),5)
	   Z57->(MsUnlock())
	   //campos memos 
	   MSMM(,,,lower(ALLTRIM(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao:_dados_edital:_edital_resumo:text)),1,,,'Z57','Z57_RESUMO') 
	   MSMM(,,,lower(ALLTRIM(oxml:_aviso_oportunidades_ibiz:_licitacoes:_licitacao:_dados_ibiz:_ibiz_trechos_encontrados:_ibiz_trecho_encontrado:text)),1,,,'Z57','Z57_DESCRI') 
	   //
   endif
elseif TYPE("oxml:_aviso_resultados_ibiz")<>'U'
   if TYPE("oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[1]:_dados_ibiz:_ibiz_id_licitacao:text")<>'U' 
	   for _x:=1 to len(oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao)
		   cWord := ""
   		RecLock("Z96",.T.)
		   Z96->Z96_FILIAL := xFilial("Z96")
	      Z96->Z96_ARQUIV := UPPER(Alltrim(NomeArq))
		   Z96->Z96_NOME   := Alltrim(cEmpresa)

	      //bloco da informacao do Edital
	      Z96->Z96_EDITAL := ALLTRIM(oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_dados_edital:_edital:text)
	      Z96->Z96_ABERTU := CTOD(substr(oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_dados_edital:_edital_data_abertura:text,1,10))       
	      Z96->Z96_HRABER := substr(oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_dados_edital:_edital_data_abertura:text,12,5)       

	      //bloco da informacao dos dados da Ibiz
	      Z96->Z96_CAPTUR := CTOD(substr(oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_dados_ibiz:_ibiz_data_captura:text,1,10))
	      Z96->Z96_HRCAP  := substr(oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_dados_ibiz:_ibiz_data_captura:text,12,5)
	      Z96->Z96_COD    := strzero(val(Alltrim(oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_dados_ibiz:_ibiz_id_licitacao:text)),9)	
	      Z96->Z96_ULTSIT := Alltrim(oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_dados_ibiz:_ibiz_ultima_situacao:text)
	      Z96->Z96_DTSTAT := CTOD(substr(oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_dados_ibiz:_ibiz_data_captura_ultima_situacao:text,1,10))

         //resultado Lotes
         DbSelectArea("Z97")
         DbSetOrder(1)
         if TYPE("oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote")=='A' 
	         for _y := 1 to len(oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote)	         
	            RecLock("Z97",.T.)
	            Z97->Z97_FILIAL := xFilial("Z97")
	            Z97->Z97_COD    := Z96->Z96_COD
	            Z97->Z97_ITEM   :=  oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote[_y]:_lote_numero:text
	            Z97->Z97_SITUAC :=  alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote[_y]:_lote_situacao:text )
	            Z97->Z97_GANHAD :=  alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote[_y]:_lote_ganhador:text )
	            Z97->Z97_DOCGAN := pictCNPJ( alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote[_y]:_lote_doc_ganhador:text ) )
	            Z97->Z97_CONTAT :=  alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote[_y]:_lote_contato:text )
	            Z97->Z97_TEL    :=  pictTEL( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote[_y]:_lote_contato_fone:text )
	            Z97->Z97_VLARRE :=      val( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote[_y]:_lote_valor_arrematado:text)
	            Z97->Z97_MARCA  :=  alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote[_y]:_lote_marca_produto:text )

               //resultados Lotes x Lances
               if TYPE("oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote[_y]:_lote_lances:_lote_lance")=='A' 
	               for _w := 1 to len(oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote[_y]:_lote_lances:_lote_lance )
	                  Reclock("Z98",.T.)
	                  Z98->Z98_FILIAL := xFilial("Z98")
	                  Z98->Z98_COD    := Z96->Z96_COD
	                  Z98->Z98_LOTE   := Z97->Z97_ITEM //Codigo do Lote
	                  Z98->Z98_ITEM   := StrZero(_w,3)
	                  Z98->Z98_PARTIC := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote[_y]:_lote_lances:_lote_lance[_w]:_lance_participante:text )
	                  Z98->Z98_VALOR  :=     val( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote[_y]:_lote_lances:_lote_lance[_w]:_lance_valor:text )
	                  Z98->Z98_SITUAC := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote[_y]:_lote_lances:_lote_lance[_w]:_lance_situacao:text )
	                  Z98->Z98_MARCA  := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote[_y]:_lote_lances:_lote_lance[_w]:_lance_marca:text )
	                  Z98->(MsUnLock())
	               next _w
	            else
	               Reclock("Z98",.T.)
	               Z98->Z98_FILIAL := xFilial("Z98")
	               Z98->Z98_COD    := Z96->Z96_COD
                  Z98->Z98_LOTE   := Z97->Z97_ITEM //Codigo do Lote
	               Z98->Z98_ITEM   := "001"
	               Z98->Z98_PARTIC := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote[_y]:_lote_lances:_lote_lance:_lance_participante:text )
	               Z98->Z98_VALOR  :=     val( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote[_y]:_lote_lances:_lote_lance:_lance_valor:text )
	               Z98->Z98_SITUAC := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote[_y]:_lote_lances:_lote_lance:_lance_situacao:text )
	               Z98->Z98_MARCA  := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote[_y]:_lote_lances:_lote_lance:_lance_marca:text )
	               Z98->(MsUnLock())	            
	            endif   

               Z97->(MsUnlock())
      		   //campos memos 
		         MSMM(,,,lower( alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote[_y]:_lote_descricao:text ) ),1,,,'Z97','Z97_DESCRI')               
   	      next _y 
   	   else
            RecLock("Z97",.T.)
            Z97->Z97_FILIAL := xFilial("Z97")
            Z97->Z97_COD    := Z96->Z96_COD
            Z97->Z97_ITEM   :=  oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote:_lote_numero:text
            Z97->Z97_SITUAC :=  alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote:_lote_situacao:text )
            Z97->Z97_GANHAD :=  alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote:_lote_ganhador:text )
            Z97->Z97_DOCGAN := pictCNPJ( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote:_lote_doc_ganhador:text ) 
            Z97->Z97_CONTAT :=  alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote:_lote_contato:text )
            Z97->Z97_TEL    :=  pictTEL( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote:_lote_contato_fone:text )
            Z97->Z97_VLARRE :=      val( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote:_lote_valor_arrematado:text)
            Z97->Z97_MARCA  :=  alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote:_lote_marca_produto:text )

            //resultados Lotes x Lances
            if TYPE("oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote:_lote_lances:_lote_lance")=='A' 
	            for _w := 1 to len(oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote:_lote_lances:_lote_lance )
	               Reclock("Z98",.T.)
	               Z98->Z98_FILIAL := xFilial("Z98")
	               Z98->Z98_COD    := Z96->Z96_COD
                  Z98->Z98_LOTE   := Z97->Z97_ITEM //Codigo do Lote
	               Z98->Z98_ITEM   := StrZero(_w,3)
	               Z98->Z98_PARTIC := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote:_lote_lances:_lote_lance[_w]:_lance_participante:text )
	               Z98->Z98_VALOR  := val( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote:_lote_lances:_lote_lance[_w]:_lance_valor:text )
	               Z98->Z98_SITUAC := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote:_lote_lances:_lote_lance[_w]:_lance_situacao:text )
	               Z98->Z98_MARCA  := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote:_lote_lances:_lote_lance[_w]:_lance_marca:text )
	               Z98->(MsUnLock())
	            next _w
	         else
	            Reclock("Z98",.T.)
	            Z98->Z98_FILIAL := xFilial("Z98")
	            Z98->Z98_COD    := Z96->Z96_COD
               Z98->Z98_LOTE   := Z97->Z97_ITEM //Codigo do Lote
	            Z98->Z98_ITEM   := "001"
	            Z98->Z98_PARTIC := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote:_lote_lances:_lote_lance:_lance_participante:text )
	            Z98->Z98_VALOR  := val( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote:_lote_lances:_lote_lance:_lance_valor:text )
	            Z98->Z98_SITUAC := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote:_lote_lances:_lote_lance:_lance_situacao:text )
	            Z98->Z98_MARCA  := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote:_lote_lances:_lote_lance:_lance_marca:text )
	            Z98->(MsUnLock())	            
	         endif   

            Z97->(MsUnlock())
	         MSMM(,,,lower( alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_resultados_lotes:_resultado_lote:_lote_descricao:text ) ),1,,,'Z97','Z97_DESCRI')                           
	      endif   
         
	      //bloco da informacao do recebimento 
		   Z96->Z96_DTREC  := ddatabase
		   Z96->Z96_HRREC  := left(time(),5)
		   Z96->(MsUnlock())

		   //campos memos 
		   MSMM(,,,lower(ALLTRIM(oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao[_x]:_dados_edital:_edital_resumo:text)),1,,,'Z96','Z96_RESUMO')
	   Next _x
   elseif TYPE("oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao")<>'U' 
	   RecLock("Z96",.T.) 
	   Z96->Z96_FILIAL := xFilial("Z96") 
	   Z96->Z96_ARQUIV := UPPER(Alltrim(NomeArq))
	   //bloco da informacao do Edital
	   Z96->Z96_EDITAL := ALLTRIM(oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_dados_edital:_edital:text)
	   Z96->Z96_ABERTU := CTOD(substr(oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_dados_edital:_edital_data_abertura:text,1,10))       
	   Z96->Z96_HRABER := substr(oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_dados_edital:_edital_data_abertura:text,12,5)       
	   //bloco da informacao dos dados da Ibiz
	   Z96->Z96_CAPTUR := CTOD(substr(oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_dados_ibiz:_ibiz_data_captura:text,1,10))
	   Z96->Z96_HRCAP  := substr(oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_dados_ibiz:_ibiz_data_captura:text,12,5)
	   Z96->Z96_COD    := strzero(val(Alltrim(oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_dados_ibiz:_ibiz_id_licitacao:text)),9)	
      Z96->Z96_ULTSIT := Alltrim(oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_dados_ibiz:_ibiz_ultima_situacao:text)
      Z96->Z96_DTSTAT := CTOD(substr(oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_dados_ibiz:_ibiz_data_captura_ultima_situacao:text,1,10))

      //resultado Lotes
      DbSelectArea("Z97")
      DbSetOrder(1)
      if TYPE("oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote")<>"U"  
         if TYPE("oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote")=='A'
            for _y := 1 to len(oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote)	         
   	         RecLock("Z97",.T.)
   	         Z97->Z97_FILIAL := xFilial("Z97")
   	         Z97->Z97_COD    := Z96->Z96_COD
   	         Z97->Z97_ITEM   := oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote[_y]:_lote_numero:text
   	         Z97->Z97_SITUAC := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote[_y]:_lote_situacao:text )
   	         Z97->Z97_GANHAD := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote[_y]:_lote_ganhador:text )
   	         Z97->Z97_DOCGAN := pictCNPJ( alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote[_y]:_lote_doc_ganhador:text ) )
   	         Z97->Z97_CONTAT := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote[_y]:_lote_contato:text )
   	         Z97->Z97_TEL    := pictTEL( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote[_y]:_lote_contato_fone:text )
   	         Z97->Z97_VLARRE := val(oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote[_y]:_lote_valor_arrematado:text)
   	         Z97->Z97_MARCA  := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote[_y]:_lote_marca_produto:text )
   
               //resultados Lotes x Lances
               if TYPE("oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote:_lote_lances:_lote_lance")<>'U'             
                  if TYPE("oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote[_y]:_lote_lances:_lote_lance")=='A' 
      	            for _w := 1 to len(oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote[_y]:_lote_lances:_lote_lance )
    	                  Reclock("Z98",.T.)
        	               Z98->Z98_FILIAL := xFilial("Z98")
      	               Z98->Z98_COD    := Z96->Z96_COD
                        Z98->Z98_LOTE   := Z97->Z97_ITEM //Codigo do Lote      	               
      	               Z98->Z98_ITEM   := StrZero(_w,3)
      	               Z98->Z98_PARTIC := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote[_y]:_lote_lances:_lote_lance[_w]:_lance_participante:text )
      	               Z98->Z98_VALOR  := val( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote[_y]:_lote_lances:_lote_lance[_w]:_lance_valor:text )
      	               Z98->Z98_SITUAC := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote[_y]:_lote_lances:_lote_lance[_w]:_lance_situacao:text )
      	               Z98->Z98_MARCA  := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote[_y]:_lote_lances:_lote_lance[_w]:_lance_marca:text )
      	               Z98->(MsUnLock())
      	            next _w
      	         else
      	            Reclock("Z98",.T.)
      	            Z98->Z98_FILIAL := xFilial("Z98")
      	            Z98->Z98_COD    := Z96->Z96_COD
                     Z98->Z98_LOTE   := Z97->Z97_ITEM //Codigo do Lote
      	            Z98->Z98_ITEM   := "001"
      	            Z98->Z98_PARTIC := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote[_y]:_lote_lances:_lote_lance:_lance_participante:text )
      	            Z98->Z98_VALOR  := val( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote[_y]:_lote_lances:_lote_lance:_lance_valor:text )
      	            Z98->Z98_SITUAC := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote[_y]:_lote_lances:_lote_lance:_lance_situacao:text )
      	            Z98->Z98_MARCA  := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote[_y]:_lote_lances:_lote_lance:_lance_marca:text )
      	            Z98->(MsUnLock())	            
      	         endif   
      	      endif   
   
               Z97->(MsUnlock())
         	   //campos memos 
   		      MSMM(,,,lower( alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote[_y]:_lote_descricao:text ) ),1,,,'Z97','Z97_DESCRI')               
      	   next _y 
      	else
            RecLock("Z97",.T.)
            Z97->Z97_FILIAL := xFilial("Z97")
            Z97->Z97_COD    := Z96->Z96_COD
            Z97->Z97_ITEM   := oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote:_lote_numero:text
            Z97->Z97_SITUAC := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote:_lote_situacao:text )
            Z97->Z97_GANHAD := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote:_lote_ganhador:text )
            Z97->Z97_DOCGAN := pictCNPJ( alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote:_lote_doc_ganhador:text ) )
            Z97->Z97_CONTAT := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote:_lote_contato:text )
            Z97->Z97_TEL    := pictTEL( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote:_lote_contato_fone:text )
            Z97->Z97_VLARRE := val(oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote:_lote_valor_arrematado:text)
            Z97->Z97_MARCA  := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote:_lote_marca_produto:text )
   
            //resultados Lotes x Lances
            if TYPE("oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote:_lote_lances:_lote_lance")<>'U'             
               if TYPE("oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote:_lote_lances:_lote_lance")=='A' 
                  for _w := 1 to len(oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote:_lote_lances:_lote_lance )
                     Reclock("Z98",.T.)
                     Z98->Z98_FILIAL := xFilial("Z98")
                     Z98->Z98_COD    := Z96->Z96_COD
                     Z98->Z98_LOTE   := Z97->Z97_ITEM //Codigo do Lote                     
                     Z98->Z98_ITEM   := StrZero(_w,3)
                     Z98->Z98_PARTIC := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote:_lote_lances:_lote_lance[_w]:_lance_participante:text )
                     Z98->Z98_VALOR  := val( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote:_lote_lances:_lote_lance[_w]:_lance_valor:text )
                     Z98->Z98_SITUAC := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote:_lote_lances:_lote_lance[_w]:_lance_situacao:text )
                     Z98->Z98_MARCA  := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote:_lote_lances:_lote_lance[_w]:_lance_marca:text )
                     Z98->(MsUnLock())
                  next _w
               else
                  Reclock("Z98",.T.)
                  Z98->Z98_FILIAL := xFilial("Z98")
                  Z98->Z98_COD    := Z96->Z96_COD
                  Z98->Z98_LOTE   := Z97->Z97_ITEM //Codigo do Lote                     
                  Z98->Z98_ITEM   := "001"
                  Z98->Z98_PARTIC := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote:_lote_lances:_lote_lance:_lance_participante:text )
                  Z98->Z98_VALOR  := val( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote:_lote_lances:_lote_lance:_lance_valor:text )
                  Z98->Z98_SITUAC := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote:_lote_lances:_lote_lance:_lance_situacao:text )
                  Z98->Z98_MARCA  := alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote:_lote_lances:_lote_lance:_lance_marca:text )
                  Z98->(MsUnLock())	            
               endif   
            endif
            Z97->(MsUnlock())
   	      MSMM(,,,lower( alltrim( oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_resultados_lotes:_resultado_lote:_lote_descricao:text ) ),1,,,'Z97','Z97_DESCRI')                           
   	   endif   
	   endif
	   //bloco da informacao do recebimento 
	   Z96->Z96_DTREC  := ddatabase
	   Z96->Z96_HRREC  := left(time(),5)
	   Z96->(MsUnlock())
	   //campos memos 
	   MSMM(,,,lower(ALLTRIM(oxml:_aviso_resultados_ibiz:_licitacoes:_licitacao:_dados_edital:_edital_resumo:text)),1,,,'Z96','Z96_RESUMO')           // bloco da informacao do Edital

   endif
endif

Return 

**************************************
Static Function jaLeu(empresa,nomearq)
**************************************

local cQry := ''
local lRet := .F.

If Select('AUX1') > 1
	AUX1->(dbCloseArea())
EndIf

cQry := "SELECT TOP 1 Z57_ARQUIV FROM "+RetSqlname("Z57")+" Z57 "
cQry += "WHERE Z57_NOME = '"+empresa+"' "
cQry += "AND Z57_ARQUIV = '"+nomearq+"' " 
cQry += "AND Z57.D_E_L_E_T_ <> '*' "
TCQUERY cQry NEW ALIAS 'AUX1'

if AUX1->(!EOF())
   lRet := .T.
EndIf

AUX1->(dbCloseArea())
	
Return lRet 

*********************************
static function pictCNPJ( cCNPJ )
*********************************
Local cRet

cRet := strtran( strtran( strtran( cCNPJ, ".", "" ), "/","" ), "-","" )

return cRet


*******************************
static function pictTEL( cTEL )
*******************************
Local cRet

cRet := strtran( strtran( strtran( strtran( strtran( cTEL, " ", "" ), "(","" ), ")","" ), "-","" ), ".","" )

return cRet