#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ERCLT01 º Autor ³ Eurivan Marques     º Data ³  14/05/07   º ±±
±±º                   º                                                  º ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório para Auditoria da Conferencia de Saida de Notas  º±±
±±º          ³ feitas pelo coletor de Dados.                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CUSTO/ESTOQUE                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ERCLT01()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        	// De Emissao                            ³
//³ mv_par02        	// Ate Emissao                           ³
//³ mv_par03        	// Do Cliente                            ³
//³ mv_par04        	// Ate Cliente                           ³
//³ mv_par05        	// Considera  Todos/Com Diverg./Sem Diverg.
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//                     999999999999 99.999,99 99.999,99 99.999,99 xx/xx/xx - xx:xx:xx
//                     01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                               1         2         3         4         5         6         7         8         9        10        11        12        13
private Cabec1     := "Produto          Qtd. NF. Descricao"
private Cabec2     := "  Cod. Barras   Qtd Conf. Diferença Data/Hora           Status                                 Observacao                   "

private limite    := 132
Private tamanho   := "M"
Private titulo    := PADC("Relatorio de Auditoria de Notas Fiscais" ,limite)
Private cDesc1    := "Este relatório dará a relação de Notas conferidas"
Private cDesc2    := " atraves do coletor de Dados."
Private cDesc3    := " "
Private aReturn   := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}

Private nomeprog  := "ERCLT01"
Private cPerg     := "ECLT01"
Private nLastKey  := 0
Private lContinua := .T.
Private nLin      := 80
Private wnrel     := "ERCLT01"
Private M_PAG     := 1
Private aStatus   := {}
Private aResul    := { }
//Private aResul    := { {{ , , , , , ,{{ , , }},{{ , , , , , }}, }} }
//Private aResul    := {{{}},{{}},{{}},{}}
Private _nQuant   := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ValidPerg( cPerg )

Pergunte( cPerg, .T. )               // Pergunta no SX1

cString := "SF2"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint( cString, wnrel, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F.,,, Tamanho )

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

#IFDEF WINDOWS
	RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
	Return
	// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Function RptDetail
	Static Function RptDetail()
#ENDIF


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ DESENVOLVIMENTO DO PROGRAMA          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQuery := "SELECT * FROM "+RetSqlName("Z06")+" "
cQuery += "WHERE Z06_DTCONF BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
cQuery += "AND D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY Z06_DATANF, Z06_DOC, Z06_SERIE, Z06_PRODUT, Z06_STATUS, Z06_DTCONF, Z06_HRCONF "

TCQUERY cQuery NEW ALIAS "Z06X"

TCSetField( 'Z06X', "Z06_DATANF", "D" )
TCSetField( 'Z06X', "Z06_QUANT" , "N", 14, 2 )
TCSetField( 'Z06X', "Z06_DTCONF", "D" )

Z06X->( DbGoTop() )
count to nREGTOT while ! Z06X->( EoF() )
SetRegua( nREGTOT )
Z06X->( DBGoTop() )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ DADOS IMPRESSOS NO RELATORIO    					         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*
STATUS = 0 "O Produto lido não se encontra na Nota Fiscal informada, ou faz parte de uma OP muito antiga."
STATUS = 1 "Produto existe."
STATUS = 2 "Produto aceito."
STATUS = 3 "Etiqueta lida anteriormente."
STATUS = 4 "Produto conferido na sua totalidade."
STATUS = 5 "Quantidade Conferida ultrapassou a quantidade da Nota Fiscal."
*/
Aadd( aStatus, "Produto lido não se encontra na NF." )
Aadd( aStatus, "Produto existe." )
Aadd( aStatus, "Produto conferido com sucesso." )
Aadd( aStatus, "Produto lido anteriormente." )
Aadd( aStatus, "Produto já confer. na sua totalidade." )
Aadd( aStatus, "Quantid. confer. ultrapassou a da NF." )

DbSelectArea("SF2")
SF2->(DbSetOrder(1))
DbSelectArea("SD2")
SA1->(DbSetOrder(1))
DbSelectArea("SD3")
SD3->(DbSetOrder(12))
DbSelectArea("SB1")
SB1->(DbSetOrder(1))
//  EURIVAN
/*while ! Z06X-> ( EOF() )
	
   //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL
	SF2->(DbSeek(xFilial("SF2")+Z06X->Z06_DOC+Z06X->Z06_SERIE,.T.))
	SA1->(DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
	
	if nLin > 58
		nLin := Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 ) + 1//Impressao do cabecalho
	endIf

	dEmissao := Z06X->Z06_DATANF
	cDoc     := Z06X->Z06_DOC
	cSerie   := Z06X->Z06_SERIE
	
   @nLin, 00 PSAY "NF     : "+Z06X->Z06_DOC + "-" +Z06X->Z06_SERIE
   nLin += 1
   @nLin, 00 PSAY "EMISSAO: "+DTOC(Z06X->Z06_DATANF)
   nLin += 1
   @nLin, 00 PSAY "CLIENTE: "+SA1->A1_COD+"/"+SA1->A1_LOJA+" - "+SA1->A1_NOME
   nLin+=1
   @nLin, 00 PSAY Replicate( "-", Limite )	
   nLin+=1
   
   while ! Z06X-> ( EOF() ) .AND. dEmissao = Z06X->Z06_DATANF .AND. ;
   	  cDoc = Z06X->Z06_DOC .AND. cSerie = Z06X->Z06_SERIE
   	  
   	if nLin > 58
	   	nLin := Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 ) + 1 //Impressao do cabecalho
   	endIf
      
     	cProduto := Z06X->Z06_PRODUT
      SB1->(DbSeek(xFilial("SB1")+cProduto) )
      _nQuant  := GetQtdNF()
      nDif := _nQuant
      lUm := .T.
      @nLin, 00 PSAY Alltrim( cProduto )
      @nLin, 15 PSAY Transform( _nQuant, "@E 99,999.99" )
      @nLin, 26 PSAY SB1->B1_DESC
      nLin += 1
      @nLin, 00 PSAY Replicate( "=", limite )	
      nLin +=1
      while ! Z06X-> ( EOF() ) .AND. dEmissao = Z06X->Z06_DATANF .AND. ;
      	  cDoc = Z06X->Z06_DOC .AND. cSerie = Z06X->Z06_SERIE .AND.;
      	      cProduto = Z06X->Z06_PRODUT
   	  
      	if nLin > 58
   	   	nLin := Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 ) + 1 //Impressao do cabecalho
      	endIf
      
         @nLin, 02 PSAY AllTrim(Z06X->Z06_CODBAR)
         if Z06X->Z06_STATUS # "3"
            nDif -= Z06X->Z06_QUANT
         endif   
         @nLin, 15 PSAY Transform( Z06X->Z06_QUANT, "@E 99,999.99" )
         @nLin, 25 PSAY Transform( nDif, "@E 99,999.99" )
         @nLin, 36 PSAY DTOC(Z06X->Z06_DTCONF)+" - "+Z06X->Z06_HRCONF
         @nLin, 56 PSAY aStatus[ Val( Z06X->Z06_STATUS )+1 ]
         @nLin, 95 PSAY SUBSTR(Z06X->Z06_OBS,1,29)
         nLin += 1      
   	   Z06X->( dbskip() )
      	IncRegua()	   
      end
      if nDif # 0
         @nLin, 00 PSAY PADC("<<<<< ITEM COM DIVERGENCIA >>>>>",Limite)
         nLin += 1
      endif      
      @nLin, 00 PSAY Replicate( "-", Limite )
      nLin+=1
   end   
   @nLin, 00 PSAY Replicate( "*", Limite )
   nLin+=2
end*/

//

SF2->(DbSeek(xFilial("SF2")+Z06X->Z06_DOC+Z06X->Z06_SERIE,.T.))
SA1->(DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
	
cProduto:=Z06X->Z06_PRODUT
SB1->(DbSeek(xFilial("SB1")+cProduto) )
_nQuant  := GetQtdNF()
nDif := _nQuant
             

aResul := { {Z06X->Z06_DOC,Z06X->Z06_SERIE,(Z06X->Z06_DATANF),SA1->A1_COD,SA1->A1_LOJA,SA1->A1_NOME,;
            {{Z06X->Z06_PRODUT,_nQuant,SB1->B1_DESC,{},{ {Z06X->Z06_CODBAR,Z06X->Z06_QUANT,nDif,(Z06X->Z06_DTCONF),;
            Z06X->Z06_HRCONF,aStatus[ Val( Z06X->Z06_STATUS )+1 ],SUBSTR(Z06X->Z06_OBS,1,29)}}}}} }
cntDoc:=1
cnt:=1
while ! Z06X-> ( EOF() )
   SF2->(DbSeek(xFilial("SF2")+Z06X->Z06_DOC+Z06X->Z06_SERIE,.T.))
   SA1->(DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
  
   nIdx := aScan( aResul, {|x| x[1]==Z06X->Z06_DOC } )
	
   if  nIdx <= 0
      	//
      if (nDif # 0) 
         Aadd(aResul[cntDoc][7][cnt][4],"COM DIVERGENCIA")
      endif
      if (nDif = 0) 
         Aadd(aResul[cntDoc][7][cnt][4],"SEM DIVERGENCIA")
      endif
		 //
      cntDoc+=1
      cnt:=1
      SF2->(DbSeek(xFilial("SF2")+Z06X->Z06_DOC+Z06X->Z06_SERIE,.T.))
	  SA1->(DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
	
      cProduto:=Z06X->Z06_PRODUT
      SB1->(DbSeek(xFilial("SB1")+cProduto) )
      _nQuant  := GetQtdNF()
      nDif := _nQuant
	         
	  if Z06X->Z06_STATUS # "3"
         nDif -= Z06X->Z06_QUANT
      endif
	 
      Aadd(aResul,{Z06X->Z06_DOC,Z06X->Z06_SERIE,(Z06X->Z06_DATANF),SA1->A1_COD,SA1->A1_LOJA,SA1->A1_NOME,;
                  {{Z06X->Z06_PRODUT,_nQuant,SB1->B1_DESC,{},{ {Z06X->Z06_CODBAR,Z06X->Z06_QUANT,nDif,(Z06X->Z06_DTCONF),;
                  Z06X->Z06_HRCONF,aStatus[ Val( Z06X->Z06_STATUS )+1 ],SUBSTR(Z06X->Z06_OBS,1,29)}}}}  } )
	
   else
		
      nIdx2 := aScan( aResul[cntDoc][7], { |t| t[1]==Z06X->Z06_PRODUT  } )
      if nIdx2 <= 0
         cnt+=1
		//
         if (nDif # 0) 
            Aadd(aResul[cntDoc][7][cnt-1][4],"COM DIVERGENCIA")
         endif
         if (nDif = 0) 
            Aadd(aResul[cntDoc][7][cnt-1][4],"SEM DIVERGENCIA")
         endif
		 //
			
		 cProduto:=Z06X->Z06_PRODUT
		 SB1->(DbSeek(xFilial("SB1")+cProduto) )
         _nQuant  := GetQtdNF()
         nDif := _nQuant
		     
		 if Z06X->Z06_STATUS # "3"
            nDif -= Z06X->Z06_QUANT
         endif
			
         Aadd(aResul[cntDoc][7],{Z06X->Z06_PRODUT,_nQuant,SB1->B1_DESC,{},{ {Z06X->Z06_CODBAR,Z06X->Z06_QUANT,nDif,(Z06X->Z06_DTCONF),;
                                     Z06X->Z06_HRCONF,aStatus[ Val( Z06X->Z06_STATUS )+1 ],SUBSTR(Z06X->Z06_OBS,1,29)}}  } )
           
	       //
		   
		   
		
   else
		 
      if Z06X->Z06_STATUS # "3"
         nDif -= Z06X->Z06_QUANT
      endif
         
		 
      nIdx3 := aScan( aResul[cntDoc][7][cnt][5], { |t| t[1]==Z06X->Z06_CODBAR  } )
		 
      if nIdx3<=0
         Aadd(aResul[cntDoc][7][cnt][5],{ Z06X->Z06_CODBAR,Z06X->Z06_QUANT,nDif,(Z06X->Z06_DTCONF),Z06X->Z06_HRCONF,aStatus[ Val( Z06X->Z06_STATUS )+1 ],SUBSTR(Z06X->Z06_OBS,1,29) })
      else   
         if cnt=1
		    aResul[cntDoc][7][cnt][5][1][3]:=nDif
         else
            Aadd(aResul[cntDoc][7][cnt][5],{ Z06X->Z06_CODBAR,Z06X->Z06_QUANT,nDif,(Z06X->Z06_DTCONF),Z06X->Z06_HRCONF,aStatus[ Val( Z06X->Z06_STATUS )+1 ],SUBSTR(Z06X->Z06_OBS,1,29) })
         endif
      endif	
				
      endIf
   endIf

   Z06X->( dbskip() )
Enddo

//
if (nDif # 0) 
   Aadd(aResul[cntDoc][7][cnt][4],"COM DIVERGENCIA")
endif
if (nDif = 0) 
   Aadd(aResul[cntDoc][7][cnt][4],"SEM DIVERGENCIA")
endif
//

cntNF:=1
for x := 1 to len(aResul)
   if MV_PAR03=1    
      for z := 1 to Len(aResul[x][7])   // Sem  Divergencia 
         if aResul[x][7][z][4][1]="SEM DIVERGENCIA"
            if cntNF=1
               cntNF+=1

               If lAbortPrint
                  @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
                  Exit
               Endif
                              
               if nLin > 58
                  nLin := Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 ) + 1//Impressao do cabecalho
               endIf
  
               @nLin, 00 PSAY "NF     : "+aResul[x][1] + "-" +aResul[x][2]
               nLin += 1
               @nLin, 00 PSAY "EMISSAO: "+dtoc(aResul[x][3])
               nLin += 1                   
               @nLin, 00 PSAY "CLIENTE: "+aResul[x][4]+"/"+aResul[x][5]+" - "+aResul[x][6]
               nLin+=1
               @nLin, 00 PSAY Replicate( "-", Limite )	
               nLin+=1  
            endIF
  
            if nLin > 58
		       nLin := Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 ) + 1//Impressao do cabecalho
            endIf
   
            @nLin, 00 PSAY Alltrim( aResul[x][7][z][1] )
            @nLin, 15 PSAY Transform( aResul[x][7][z][2], "@E 99,999.99" )
            @nLin, 26 PSAY aResul[x][7][z][3]
            nLin += 1
            @nLin, 00 PSAY Replicate( "=", limite )	
            nLin +=1
   
            For w:=1 to Len(aResul[x][7][z][5])  // Leitura
    
               if nLin > 58
   		          nLin := Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 ) + 1//Impressao do cabecalho
   	           endIf
    
               @nLin, 02 PSAY AllTrim(aResul[x][7][z][5][w][1])
               @nLin, 15 PSAY Transform( aResul[x][7][z][5][w][2], "@E 99,999.99" )
               @nLin, 25 PSAY Transform( aResul[x][7][z][5][w][3], "@E 99,999.99" )
               @nLin, 36 PSAY dtoc(aResul[x][7][z][5][w][4])+" - "+aResul[x][7][z][5][w][5]
               @nLin, 56 PSAY aResul[x][7][z][5][w][6]
               @nLin, 95 PSAY aResul[x][7][z][5][w][7]
               nLin += 1
               incRegua()
            Next w   // Fim do laco Leitura
      
            @nLin, 00 PSAY PADC("<<<<< ITEM SEM DIVERGENCIA >>>>>",Limite)  
            nLin+=1
            incRegua()
    
            @nLin, 00 PSAY Replicate( "-", Limite )
            nLin+=1
            incRegua()
   
        else
           loop
        EndIF

        incRegua()
     Next // Fim do laco  Sem Divergencia
     
     if cntNF>1
        @nLin, 00 PSAY Replicate( "*", Limite )
        nLin+=2
     endif
     cntNF:=1
   Endif
//
if MV_PAR03=2    
For z:=1 to Len(aResul[x][7])   //  Com Divergencia 
if aResul[x][7][z][4][1]="COM DIVERGENCIA"
 
 if cntNF=1
    cntNF+=1
  If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif
                              
  if nLin > 58
		nLin := Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 ) + 1//Impressao do cabecalho
	endIf
  
   @nLin, 00 PSAY "NF     : "+aResul[x][1] + "-" +aResul[x][2]
   nLin += 1
   @nLin, 00 PSAY "EMISSAO: "+dtoc(aResul[x][3])
   nLin += 1                   
   @nLin, 00 PSAY "CLIENTE: "+aResul[x][4]+"/"+aResul[x][5]+" - "+aResul[x][6]
   nLin+=1
   @nLin, 00 PSAY Replicate( "-", Limite )	
   nLin+=1  
 endIF
   
   if nLin > 58
		nLin := Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 ) + 1//Impressao do cabecalho
	endIf
   
      @nLin, 00 PSAY Alltrim( aResul[x][7][z][1] )
      @nLin, 15 PSAY Transform( aResul[x][7][z][2], "@E 99,999.99" )
      @nLin, 26 PSAY aResul[x][7][z][3]
      nLin += 1
      @nLin, 00 PSAY Replicate( "=", limite )	
      nLin +=1
      
   
   
   For w:=1 to Len(aResul[x][7][z][5])  // Leitura
    
    if nLin > 58
		nLin := Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 ) + 1//Impressao do cabecalho
	endIf
    
      @nLin, 02 PSAY AllTrim(aResul[x][7][z][5][w][1])
     @nLin, 15 PSAY Transform( aResul[x][7][z][5][w][2], "@E 99,999.99" )
     @nLin, 25 PSAY Transform( aResul[x][7][z][5][w][3], "@E 99,999.99" )
     @nLin, 36 PSAY dtoc(aResul[x][7][z][5][w][4])+" - "+aResul[x][7][z][5][w][5]
     @nLin, 56 PSAY aResul[x][7][z][5][w][6]
     @nLin, 95 PSAY aResul[x][7][z][5][w][7]
     nLin += 1
     incRegua()
   Next    // Fim do laco Leitura
    
    @nLin, 00 PSAY PADC("<<<<< ITEM COM DIVERGENCIA >>>>>",Limite)  
    nLin+=1
   incRegua()
    
   @nLin, 00 PSAY Replicate( "-", Limite )
   nLin+=1
incRegua()

else

loop
EndIF

incRegua()
Next // Fim do laco Com  Divergencia
if cntNF>1
@nLin, 00 PSAY Replicate( "*", Limite )
nLin+=2
endif
cntNF:=1
Endif
//
//
if MV_PAR03=3    
 
  If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif
                              
  if nLin > 58
		nLin := Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 ) + 1//Impressao do cabecalho
  endIf
  
   @nLin, 00 PSAY "NF     : "+aResul[x][1] + "-" +aResul[x][2]
   nLin += 1
   @nLin, 00 PSAY "EMISSAO: "+dtoc(aResul[x][3])
   nLin += 1                   
   @nLin, 00 PSAY "CLIENTE: "+aResul[x][4]+"/"+aResul[x][5]+" - "+aResul[x][6]
   nLin+=1
   @nLin, 00 PSAY Replicate( "-", Limite )	
   nLin+=1  
 
   For z:=1 to len(aResul[x][7])   // Produto
   
  
   if nLin > 58
		nLin := Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 ) + 1//Impressao do cabecalho
	endIf
   
      @nLin, 00 PSAY Alltrim( aResul[x][7][z][1] )
      @nLin, 15 PSAY Transform( aResul[x][7][z][2], "@E 99,999.99" )
      @nLin, 26 PSAY aResul[x][7][z][3]
      nLin += 1
      @nLin, 00 PSAY Replicate( "=", limite )	
      nLin +=1
      
   
   
   For w:=1 to Len(aResul[x][7][z][5])  // Leitura
    
    if nLin > 58
		nLin := Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 ) + 1//Impressao do cabecalho
	endIf
    
      @nLin, 02 PSAY AllTrim(aResul[x][7][z][5][w][1])
     @nLin, 15 PSAY Transform( aResul[x][7][z][5][w][2], "@E 99,999.99" )
     @nLin, 25 PSAY Transform( aResul[x][7][z][5][w][3], "@E 99,999.99" )
     @nLin, 36 PSAY dtoc(aResul[x][7][z][5][w][4])+" - "+aResul[x][7][z][5][w][5]
     @nLin, 56 PSAY aResul[x][7][z][5][w][6]
     @nLin, 95 PSAY aResul[x][7][z][5][w][7]
     nLin += 1
     incRegua()
   Next    // Fim do laco Leitura
   
   
   For v:=1 to Len(aResul[x][7][z][4])   // Sem ou Com Divergencia
    
    if nLin > 58
		nLin := Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 ) + 1//Impressao do cabecalho
	endIf
     
    @nLin, 00 PSAY PADC(iif(aResul[x][7][z][4][v]="SEM DIVERGENCIA","<<<<< ITEM SEM DIVERGENCIA >>>>>","<<<<< ITEM COM DIVERGENCIA >>>>>"),Limite)  
    nLin+=1
   incRegua()
   next 
   
   @nLin, 00 PSAY Replicate( "-", Limite )
   nLin+=1
incRegua()
Next // Fim do laco Produto   

incRegua()

@nLin, 00 PSAY Replicate( "*", Limite )
nLin+=2
Endif
//
Next // Fim do laco 

if empty(aResul[1][1])
msgbox("Relatorio Vazio","Relatorio de Auditoria de Notas Fiscais","INFO")
else
if aReturn[5] == 1
	Set Printer To
	Commit
	ourspool( wnrel ) //Chamada do Spool de Impressao
endif
MS_FLUSH()  
Endif
return nil

static Function GetQtdNF

local cQuery
local nQuant

cQuery := "SELECT D2_QUANT FROM "+RetSqlName("SD2")+" "
cQuery += "WHERE D2_DOC+D2_SERIE+D2_COD = '"+Z06X->Z06_DOC+Z06X->Z06_SERIE+Z06X->Z06_PRODUT+"' AND "
cQuery += "D_E_L_E_T_ = '' "
TCQUERY cQuery NEW ALIAS "SD2X"

TCSetField( 'SD2X', "D2_QUANT", "N", 14, 2 )
nQuant := SD2X->D2_QUANT

SD2X->(DbCloseArea())

return nQuant


***************
Static Function ValidPerg(cPerg)
***************

PutSx1( cPerg, '01', 'Emissao De         ?', '', '', 'mv_ch1', 'D', 08, 0, 0, 'G', '', ''   , '', '', 'mv_par01', '' , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
PutSx1( cPerg, '02', 'Emissao Ate        ?', '', '', 'mv_ch2', 'D', 08, 0, 0, 'G', '', ''   , '', '', 'mv_par02', '' , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
//PutSx1( cPerg, '03', 'Cliente De         ?', '', '', 'mv_ch3', 'C', 06, 0, 0, 'G', '', 'SA1', '', '', 'mv_par03', '' , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
//PutSx1( cPerg, '04', 'Cliente Ate        ?', '', '', 'mv_ch4', 'C', 06, 0, 0, 'G', '', 'SA1', '', '', 'mv_par04', '' , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
//PutSx1( cperg, '05', 'Considera          ?', '', '', 'mv_ch5', 'N', 01, 0, 1, 'C', '', ''   , '', '', 'mv_par05', 'Todos'       , '', '', '' , 'Com Diverg.'             , '', '', 'Sem Diverg.'               , '', '', ''               , '', '', '', '', '', {}, {}, {} )

Return NIL