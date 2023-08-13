#INCLUDE "FIVEWIN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FATR007  ³ Autor ³ Eurivan Marques       ³ Data ³ 13.06.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Etiquetas para os volumes                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Faturamento                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FATR007()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL titulo := "Etiquetas para embalagens"
LOCAL cDesc1 := "Este programa ira emitir as etiquetas"
LOCAL cDesc2 := "para as embalagens a serem despachadas."
LOCAL cDesc3 := ""
LOCAL wnrel
LOCAL tamanho:= "G"
LOCAL cString:= "SF2"
LOCAL aOrd      := {}
LOCAL aImp      := 0

PRIVATE aReturn := { "Etiqueta", 1,"Producao", 2, 2, 1, "",1 }
PRIVATE nomeprog:="FATR007"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   :="R710ZB"
//PRIVATE cPerg   :="MTR710"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        	// Qual Serie De Nota Fiscal             ³
//³ mv_par02        	// Nota Fiscal de                        ³
//³ mv_par03        	// Nota Fiscal ate                       ³
//³ mv_par04        	// Emite por   Pedido   Nota Fiscal      ³
//³ mv_par05        	// Inicia em qual volume                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="R710ZB"             //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,tamanho)


If nLastKey == 27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C710Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C710IMP  ³ Autor ³ Rosane Luciane Chene  ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR550			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C710Imp(lEnd,WnRel,cString)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL CbTxt
LOCAL titulo := "Etiquetas para embalagens"
LOCAL cDesc1 := "Este programa ira emitir as etiquetas"
LOCAL cDesc2 := "para as embalagens a serem despachadas."
LOCAL cDesc3 := ""
LOCAL nTipo, nOrdem
LOCAL CbCont,cabec1,cabec2
LOCAL tamanho:= "P"
LOCAL limite := 80
LOCAL lContinua := .T.
LOCAL nVolume := 0
LOCAL nVolumex:= 0
LOCAL aEtiq := {}
LOCAL nEtiqueta := 1
LOCAL G := 1
LOCAL I := 1
LOCAL J := 1
LOCAL aOrd      := {}
LOCAL aImp      := 0
LOCAL nEstaOk   := 0
LOCAL nContCol  := 1
LOCAL cPedi     := ""
Local cX
Local cIndex
Local lRet      := .F.
Local cCadastro := "Etiquetas de Volume"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao do cabecalho e tipo de impressao do relatorio      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 0
col      := 0
m_pag    := 1

titulo := "ETIQUETAS PARA EMBALAGENS"
cabec1 := ""
cabec2 := ""

nTipo  := 18

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Analisa o parametro mv_par04                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SD2")
If mv_par04 == 1
	cIndex := CriaTrab(nil,.f.)
	IndRegua("SD2",cIndex,"D2_FILIAL+D2_DOC+D2_SERIE+D2_ITEM",,,"Selecionando Registros...")
Else
	dbSetOrder(3)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Acesso nota fiscal informada pelo usuario                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF2")
dbSeek(xFilial()+mv_par02+mv_par01,.T.)

SetRegua(RecCount())		// Total de Elementos da regua

While !eof() .and. lContinua .And. xFilial()==F2_FILIAL .And. F2_DOC <= mv_par03
	
	IncRegua()
	
	If F2_SERIE != mv_par01
		dbskip()
		Loop
	EndIf

	If IsRemito(1,"SF2->F2_TIPODOC")
		dbSkip()
		Loop
	Endif
			
	IF lEnd
		@PROW()+1,001 Psay "CANCELADO PELO OPERADOR"
		lContinua := .F.
		EXIT
	Endif
	
	dbSelectArea("SD2")
	If mv_par04 == 2
		dbSetOrder(3)
	EndIf
	dbSeek(xFilial()+SF2->F2_DOC+SF2->F2_SERIE)
	
    If SD2->D2_TIPO $"DB"
	    dbSelectArea("SA2")
    	dbSetOrder(1)
    	dbSeek(xFilial()+SF2->F2_CLIENTE+SF2->F2_LOJA)
    Else
	    dbSelectArea("SA1")
    	dbSetOrder(1)
    	dbSeek(xFilial()+SF2->F2_CLIENTE+SF2->F2_LOJA)
	Endif
	
	dbSelectArea("SA4")
	dbSetOrder(1)                                         
	dbSeek(xFilial()+SF2->F2_TRANSP)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se mesmo mudando a Nota fiscal o pedido e' o mesmo  ³
	//³ imprime apenas uma vez a etiqueta de volume                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par04 == 1
		If cPedi == SD2->D2_PEDIDO
			dbSelectArea("SF2")
			dbSkip()
			Loop
		Endif
	EndIf
	
	cPedi := SD2->D2_PEDIDO
	
	nVolume := nVolumex := (SF2->F2_VOLUME1)
	if MV_PAR05 != 0
	   if MV_PAR05 <= nVolume
	      nVolume := ( nVolumex - MV_PAR05 ) + 1
	   endif   
	endif   
	aPos:={025,080 ,130,180,287,387,277,323,404,404,475,530,530,570,610,650,570,610,650}
	While nVolume != -1
		 	   
       Aadd(aEtiq,'Q799,019')
       Aadd(aEtiq,'q831')
       Aadd(aEtiq,'rN')
       Aadd(aEtiq,'S1')
       Aadd(aEtiq,'D7')
       Aadd(aEtiq,'ZT')
       Aadd(aEtiq,'JB')
       Aadd(aEtiq,'OD')
       Aadd(aEtiq,'R88,0')
       Aadd(aEtiq,'N')
       
       /* INICIO  MODELO ANTIGO
       
       
       Aadd(aEtiq,'A030,025,0,5,1,1,N,"RAVA"')
       Aadd(aEtiq,'A030,080,0,3,1,1,N,"Embalagens"')
            
       Aadd(aEtiq,'A206,130,0,2,1,2,N,"Nota Fiscal/Serie"')
       Aadd(aEtiq,'A011,180,0,3,4,4,N,"'+SF2->F2_DOC+"/"+mv_par01+'"')

       Aadd(aEtiq,'A032,287,0,5,3,2,N,"PB"')
       Aadd(aEtiq,'A032,387,0,2,3,3,N,"Origem"')

       Aadd(aEtiq,'A270,277,0,2,2,2,R,"Volume:"')
       Aadd(aEtiq,'A295,323,0,3,3,4,N,"'+AllTrim(STRzero((nVolumex-nVolume)+1,3))+'/'+AllTrim(STRzero(nVolumex,3))+'"')

       Aadd(aEtiq,'A270,404,0,2,2,2,R,"Especie:"')
       Aadd(aEtiq,'A470,404,0,2,2,2,N,"'+SUBS(SF2->F2_ESPECI1,1,6)+'"')
       Aadd(aEtiq,'A020,475,0,2,2,2,R,"Destino:"')
       Aadd(aEtiq,'A020,530,0,2,1,2,N,"'+IIF(SD2->D2_TIPO $"DB","Fornecedor: ","Cliente: ")+SD2->D2_CLIENTE+'/'+SD2->D2_LOJA+'"')
       Aadd(aEtiq,'A420,530,0,2,1,2,N,"Pedido: '+SD2->D2_PEDIDO+'"')
       if SD2->D2_TIPO $"DB"
           Aadd(aEtiq,'A020,570,0,2,1,2,N,"'+Alltrim(SA2->A2_NOME)+'"')
           Aadd(aEtiq,'A020,610,0,2,1,2,N,"'+Subs(SA2->A2_END,1,49)+'"')
           Aadd(aEtiq,'A020,650,0,2,1,2,N,"'+"Cep: "+Trans(SA2->A2_CEP,"@R 99999-999")+" "+AllTrim(SA2->A2_MUN)+" - "+SA2->A2_EST+'"')    
       else
           Aadd(aEtiq,'A020,570,0,2,1,2,N,"'+Alltrim(SA1->A1_NOME)+'"')
           Aadd(aEtiq,'A020,610,0,2,1,2,N,"'+IIF(!empty(SA1->A1_ENDENT),Subs(SA1->A1_ENDENT,1,49),Subs(SA1->A1_END,1,49))+'"')
           Aadd(aEtiq,'A020,650,0,2,1,2,N,"'+'Cep: '+Trans(SA1->A1_CEP,"@R 99999-999")+' '+Trim(SA1->A1_MUN)+' - '+SA1->A1_EST+'"')    
       endif  
       Aadd(aEtiq,'A020,690,0,2,1,2,N,"Transportadora:"')
       Aadd(aEtiq,'A020,730,0,2,1,2,N,"'+Alltrim(SA4->A4_NOME)+'"')
      
       
       Aadd(aEtiq,'X002,459,008,630,521')
       Aadd(aEtiq,'X002,459,008,630,768')
       Aadd(aEtiq,'X002,118,008,630,257')
       Aadd(aEtiq,'X002,261,008,630,454')
       Aadd(aEtiq,'LE02,010,622,099')
        
       
       //Retangulo na palavra PB ORIGEM
//     Aadd(aEtiq,'LE19,275,241,163')
       
       
       
       
       // FIM MODELO ANTGO */
                               
          
      //INICIO MODELO NOVO  
        
      	If FWCodFil() == "06"  
	       Aadd(aEtiq,'A720,'+alltrim(str(aPos[3]+90))+',1,5,1,1,N,"NOVA "')//220
	       Aadd(aEtiq,'A670,'+alltrim(str(aPos[3]+90))+',1,4,1,1,N,"Industrial"')   
       Else                                       
	       Aadd(aEtiq,'A720,'+alltrim(str(aPos[3]+90))+',1,5,1,1,N,"RAVA "')//220
	       Aadd(aEtiq,'A670,'+alltrim(str(aPos[3]+90))+',1,4,1,1,N,"Embalagens"')   
	   EndIf
       Aadd(aEtiq,'A250,'+alltrim(str(aPos[1]))  +',0,2,1,2,N,"Nota Fiscal/Serie"')//025
       Aadd(aEtiq,'A027,'+alltrim(str(aPos[2]-10))+',0,3,4,4,N,"'+SF2->F2_DOC+"/"+mv_par01+'"')//70

       Aadd(aEtiq,'A035,'+alltrim(str(aPos[3]+40))+',0,5,3,2,N,"PB"')//170
       Aadd(aEtiq,'A035,'+alltrim(str(aPos[5]))+',0,2,3,3,N,"Origem"')  //287     

       Aadd(aEtiq,'A280,'+alltrim(str(aPos[3]+40))+',0,2,2,2,R,"Volume:"')//170
    // Aadd(aEtiq,'A290,'+alltrim(str(aPos[3]+80)) +',0,3,3,4,N,"'+AllTrim(STRzero((nVolumex-nVolume)+1,4))+'/'+AllTrim(STRzero(nVolumex,4))+'"')//210
       Aadd(aEtiq,'A290,'+alltrim(str(aPos[3]+100))+',0,2,3,3,N,"'+AllTrim(STRzero((nVolumex-nVolume)+1,4))+'/'+AllTrim(STRzero(nVolumex,4))+'"')//210

       Aadd(aEtiq,'A280,'+alltrim(str(aPos[7]+20))+',0,2,2,2,R,"Especie:"') //290
    // Aadd(aEtiq,'A490,'+alltrim(str(aPos[7]+20))+',0,2,2,2,N,"'+SUBS(SF2->F2_ESPECI1,1,6)+'"')//290
       Aadd(aEtiq,'A490,'+alltrim(str(aPos[7]+25))+',0,2,2,2,N,"SC/CX "')//290
       Aadd(aEtiq,'A030,'+alltrim(str(aPos[9]-40))+',0,2,2,2,R,"Destino:"')//364
       Aadd(aEtiq,'A030,'+alltrim(str(aPos[9]+15))+',0,2,1,2,N,"'+IIF(SD2->D2_TIPO $"DB","Fornecedor: ","Cliente: ")+SD2->D2_CLIENTE+'/'+SD2->D2_LOJA+'"')//419
       
 
       Aadd(aEtiq,'A450,'+alltrim(str(aPos[9]+15))+',0,2,1,2,N,"Pedido: '+SD2->D2_PEDIDO+'"')//419
       if SD2->D2_TIPO $"DB"
           Aadd(aEtiq,'A030,'+alltrim(str(aPos[9]+50)) +',0,2,1,2,N,"'+Alltrim(SA2->A2_NOME)+'"')//454
           Aadd(aEtiq,'A030,'+alltrim(str(aPos[9]+85)) +',0,2,1,2,N,"'+Subs(SA2->A2_END,1,49)+'"')//485
           Aadd(aEtiq,'A030,'+alltrim(str(aPos[9]+120))+',0,2,1,2,N,"'+"Cep: "+Trans(SA2->A2_CEP,"@R 99999-999")+" "+AllTrim(SA2->A2_MUN)+" - "+SA2->A2_EST+'"')//524    
       else        
           Aadd(aEtiq,'A030,'+alltrim(str(aPos[9]+50)) +',0,2,1,2,N,"'+Alltrim(SA1->A1_NOME)+'"') //454
           Aadd(aEtiq,'A030,'+alltrim(str(aPos[9]+85)) +',0,2,1,2,N,"'+IIF(!empty(SA1->A1_ENDENT),Subs(SA1->A1_ENDENT,1,49),Subs(SA1->A1_END,1,49))+'"') //485
           Aadd(aEtiq,'A030,'+alltrim(str(aPos[9]+120))+',0,2,1,2,N,"'+'Cep: '+Trans(SA1->A1_CEP,"@R 99999-999")+' '+Trim(SA1->A1_MUN)+' - '+SA1->A1_EST+'"')  //524  
       endif  
       Aadd(aEtiq,'A030,'+alltrim(str(aPos[9]+165))+',0,2,1,2,N,"Transportadora:"')//569
       Aadd(aEtiq,'A030,'+alltrim(str(aPos[9]+200))+',0,2,1,2,N,"'+Alltrim(SA4->A4_NOME)+'"')//604
                     
       Aadd(aEtiq,'X18,349,8,639,410')
       Aadd(aEtiq,'X17,349,8,641,658')
       Aadd(aEtiq,'X17,8,8,643,146')
       Aadd(aEtiq,'X16,150,8,642,344')

       //Retangulo na palavra PB ORIGEM
       Aadd(aEtiq,'LE27,165,240,170')   
       
      //FIM MODELO NOVO  

       Aadd(aEtiq,'P1') //Numero de etiquetas					
                            
	   For I:= 1 TO Len(aEtiq)
	 	  @ Prow()+1,000 PSAY aEtiq[I]
	   Next I

	   nVolume--	   
	   aEtiq := {}
				    
	End
	dbSelectArea("SD2")
	dbSkip()
	
	dbSelectArea("SF2")
	dbSkip()
End

dbSelectArea("SD2")
RetIndex("SD2")
dbSetOrder(1)

dbSelectArea("SF2")

If mv_par04==1
	RetIndex("SD2")
	#IFNDEF TOP
		cIndex+=OrdBagExt()
		Ferase(cIndex)
	#ENDIF
Endif

dbSelectArea("SF2")
dbClearFilter()
dbSetOrder(1)

If aReturn[5] == 1
	dbCommitAll()
	ourspool(wnrel)
Endif

Return .T.