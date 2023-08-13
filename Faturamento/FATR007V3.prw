#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
#include  "Tbiconn.ch "

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} doLoadData
Programa para imprimir as etiquetas do fardão.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     22/04/2015
/*/
//------------------------------------------------------------------------------------------
User Function FATR07V3()

Local _cPorta	:= 'LPT1'//'COM1:9600,8,N,1' //'LPT1'
Local nQuant	:= 1
Local nVolume	:= 1
Local cOP		:= ""
Local cCodBar	:= ""
Local cProd		:= ""
Local cCodProd	:= ""
Local cAdj		:= ""
Local cCapac	:= ""
Local nQFardinho	:= 0
Local nQFardo		:= 0
Local cNotaAnt	:= ""

PRIVATE cPerg   :="R710ZB"
Private _nQuant	:= 0
Private _cMaq	:= ""
Private nOPC

//criaSx1(cPerg)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg, .T.)

MSCBPRINTER("ZEBRA",_cPorta,NIL,,.F.,,,,,,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Acesso nota fiscal informada pelo usuario                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SD2")
dbSetOrder(3)
dbSeek(xFilial()+mv_par02+mv_par01,.T.)

While xFilial("SD2") == SD2->D2_FILIAL .And. SD2->D2_DOC <= mv_par03

	If SD2->D2_SERIE != mv_par01
		dbskip()
		Loop
	EndIf

	dbSelectArea("SF2")
	dbSetOrder(1)
	dbSeek(xFilial()+SD2->D2_DOC+SD2->D2_SERIE)

	If IsRemito(1,"SF2->F2_TIPODOC")
		dbSkip()
		Loop
	Endif

	If SD2->D2_TIPO $"DB"
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial()+SF2->F2_CLIENTE+SF2->F2_LOJA)
	Else
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial()+SF2->F2_CLIENTE+SF2->F2_LOJA)
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se mesmo mudando a Nota fiscal o pedido e' o mesmo  ³
	//³ imprime apenas uma vez a etiqueta de volume                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par04 == 1
		If cPedi == SD2->D2_PEDIDO
			dbSelectArea("SD2")
			SD2->(dbSkip())
			Loop
		Endif
	EndIf

	cPedi := SD2->D2_PEDIDO
	
	If cNotaAnt <> SD2->D2_DOC
		nVolume 	:= 1
	EndIf
	
	nVolumex 	:= (SF2->F2_VOLUME1)

	/*
	if MV_PAR05 != 0
		if MV_PAR05 <= nVolume
			nVolume := ( nVolumex - MV_PAR05 ) + 1
		endif   
	endif   
	*/
	dbSelectArea("SB1")
	dbSetOrder(1)
   //	dbSeek(xFilial("SB1")+ IIF(Len(Alltrim(SD2->D2_COD)) > 7 ,SubStr(SD2->D2_COD,1,1) + SubStr(SD2->D2_COD,3,3) + SubStr(SD2->D2_COD,7,2),SD2->D2_COD))
    dbSeek(xFilial("SB1")+ U_transgen(SD2->D2_COD) )
    
	dbSelectArea("SB5")
	dbSetOrder(1)
   //	dbSeek(xFilial("SB5")+ IIF(Len(Alltrim(SD2->D2_COD)) > 7 ,SubStr(SD2->D2_COD,1,1) + SubStr(SD2->D2_COD,3,3) + SubStr(SD2->D2_COD,7,2),SD2->D2_COD))
    dbSeek(xFilial("SB5")+U_transgen(SD2->D2_COD) )
	
	If MV_PAR05 > 0
		nFardos := MV_PAR05 
		_x		:= MV_PAR05
		nQuant	:= MV_PAR05
		
	Else
		nFardos	:= Round((SD2->D2_QUANT  * SB1->B1_QE) + 0.49,0)
		_x		:= 1
		nQuant	:= 1
	Endif   
	

/*	If SD2->D2_UM == "FD"
		If SD2->D2_QUANT < 1
			nFardos	:= 1an
		Else
			nFardos	:= Round(((SD2->D2_QUANT  * SB1->B1_QE)) + 0.5,0)
			//nFardos	:= SD2->D2_QUANT
		EndIf
	Else
		If SD2->D2_QUANT < 1
			nFardos	:= 1
		Else
			nFardos	:= Round((SD2->D2_QUANT / (SB5->B5_QTDFIM / SB5->B5_QTDEN)) + 0.5,0)
		EndIf
	EndIf
*/	


//	For _x := nQuant To nFardos
	While _x <= nFardos

		Conout("Inicio Etiqueta " + AllTrim(STRzero(nVolume,4)))

		MSCBBEGIN(1,2)                             
	
		MSCBBOX(04,04,97,50,8) //Box Geral
		MSCBBOX(04,04,33,20,100) //Box Rava

		Do Case
			Case FWCodFil() == "06"  
	
				MSCBSAY(07,07,"NOVA","N","0","80",.T.)	// Horizontal
				MSCBSAY(08,15,"INDUSTRIAL","N","C","14",.T.)	// Horizontal
				
			Case FWCodFil() == "07"  
			
				MSCBSAY(07,07,"TOTAL","N","0","80",.T.)	// Horizontal
				MSCBSAY(08,15,"EMBALAGENS","N","C","14",.T.)	// Horizontal
				
			Otherwise
			
				MSCBSAY(07,07,"RAVA","N","0","80",.T.)	// Horizontal
				MSCBSAY(08,15,"EMBALAGENS","N","C","14",.T.)	// Horizontal
				
		End Case
		
		MSCBSAY(53,06,"NOTA FISCAL / SERIE","N","0","22")	// Horizontal
		MSCBSAY(39,10,SF2->F2_DOC + "/" + mv_par01,"N","0","80",.T.)	// Horizontal

		MSCBLineH(04,20,97,4) //LInha abaixo  rava
		//Litragem
		MSCBBOX(04,20,33,28,54) // Box Volume
		MSCBSAY(14,22,"VOLUME:","N","0","40",.T.)	// Horizontal
		MSCBSAY(42,22,AllTrim(STRzero(nVolume,4)),"N","0","44",.T.)
		MSCBSAY(62,22,'/',"N","0","44",.T.)
		MSCBSAY(73,22,AllTrim(STRzero(nVolumeX,4)) ,"N","0","44",.T.)
	
		MSCBLineH(04,28,97,4)//Linha abaixo volume
	
		MSCBSAY(07,30,"CODIGO / DESCRIÇÃO ","N","0","35",.T.)	// Horizontal
		MSCBBOX(50,28,76,32,50) // Box especie
		MSCBSAY(55,30,"ESPECIE:","N","0","35",.T.)	// Horizontal
		MSCBLineH(04,34,97,4) //Linha  abaixo codigo
		MSCBSAY(80,30,"SC / CX","N","0","35",.T.)	// Horizontal
	
		MSCBSAY(07,35,Alltrim(SD2->D2_COD) + " - " + SubStr(SB1->B1_DESC,1,30) ,"N","0","32",.T.)	// Horizontal
		MSCBSAY(07,39,SubStr(SB1->B1_DESC,31,30),"N","0","32",.T.)	// Horizontal
	
		MSCBLineH(04,43,97,4)
		MSCBBOX(04,43,33,47,50) //Box destino
		MSCBSAY(14,45,"DESTINO:","N","0","35",.T.)	// Horizontal
	
		If SD2->D2_TIPO $"DB"
			MSCBSAY(36,45,AllTrim(SA2->A2_MUN)+"-"+SA2->A2_EST,"N","0","35",.T.)	// Horizontal
		ELSE
			MSCBSAY(36,45,AllTrim(SA1->A1_MUN)+"-"+SA1->A1_EST,"N","0","35",.T.)	// Horizontal
		ENDIF   
	
		MSCBEND() 
		Conout("Fim Etiqueta " + AllTrim(STRzero(nVolume,4)))
		
		nVolume := nVolume + 1
		_x		:= _x + 1
	//Next
	EndDO
	
	cNotaAnt := SD2->D2_DOC
	dbSelectArea("SD2")
	SD2->(dbSkip())

EndDo

MSCBCLOSEPRINTER() 

Return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação das perguntas (se não existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
static function criaSX1(cPerg)

	putSx1(cPerg, '01', 'Da Nota?'   	  	, '', '', 'mv_ch1', 'C', 9                     	, 0, 0, 'G', '', 'SF2'   , '', '', 'mv_par01','','','','','','','','','','','','','','','','',{"Nota inicial"},{},{})
	putSx1(cPerg, '02', 'Até Nota?'  		, '', '', 'mv_ch2', 'C', 9                     	, 0, 0, 'G', '', 'SF2'   , '', '', 'mv_par02','','','','','','','','','','','','','','','','',{"Nota final"},{},{})
	//putSx1(cPerg, '04', 'Meta Mês?'   		, '', '', 'mv_ch4', 'N', 12                     	, 2, 0, 'G', '', ''	 , '', '', 'mv_par04','','','','','','','','','','','','','','','','',{"Informe o valor da meta mês."},{},{})
	//putSx1(cPerg, '03', 'Do Recurso?'     	, '', '', 'mv_ch3', 'C', 9                     	, 0, 0, 'G', '', 'SH1', '', '', 'mv_par03','','','','','','','','','','','','','','','','',{"Recurso inicial"},{},{})
	//putSx1(cPerg, '04', 'Até Recurso?'    	, '', '', 'mv_ch4', 'C', 9                     	, 0, 0, 'G', '', 'SH1', '', '', 'mv_par04','','','','','','','','','','','','','','','','',{"Recurso final"},{},{})

return  


User Function FATR007X()

Local nQuant	:= 1
Local nVolume	:= 1
Local cOP		:= ""
Local cCodBar	:= ""
Local cProd		:= ""
Local cCodProd	:= ""
Local cAdj		:= ""
Local cDestino	:= ""
Local nQFardinho	:= 0
Local nQFardo		:= 0
Local cNotaAnt	:= ""
Local aDados	:= {}

PRIVATE cPerg   :="R710ZB"

//criaSx1(cPerg)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg, .T.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Acesso nota fiscal informada pelo usuario                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SD2")
dbSetOrder(3)
dbSeek(xFilial()+mv_par02+mv_par01,.T.)

While xFilial("SD2") == SD2->D2_FILIAL .And. SD2->D2_DOC <= mv_par03

	If SD2->D2_SERIE != mv_par01
		dbskip()
		Loop
	EndIf

	dbSelectArea("SF2")
	dbSetOrder(1)
	dbSeek(xFilial()+SD2->D2_DOC+SD2->D2_SERIE)

	If IsRemito(1,"SF2->F2_TIPODOC")
		dbSkip()
		Loop
	Endif

	If SD2->D2_TIPO $"DB"
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial()+SF2->F2_CLIENTE+SF2->F2_LOJA)
		cDestino := AllTrim(SA2->A2_MUN)+"-"+SA2->A2_EST
	Else
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial()+SF2->F2_CLIENTE+SF2->F2_LOJA)
		cDestino := AllTrim(SA1->A1_MUN)+"-"+SA1->A1_EST
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se mesmo mudando a Nota fiscal o pedido e' o mesmo  ³
	//³ imprime apenas uma vez a etiqueta de volume                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par04 == 1
		If cPedi == SD2->D2_PEDIDO
			dbSelectArea("SD2")
			SD2->(dbSkip())
			Loop
		Endif
	EndIf

	cPedi 		:= SD2->D2_PEDIDO
	nVolumex 	:= (SF2->F2_VOLUME1)

	dbSelectArea("SB1")
	dbSetOrder(1)
    dbSeek(xFilial("SB1")+ U_transgen(SD2->D2_COD) )

    nFardos		:= Round((SD2->D2_QUANT  * SB1->B1_QE) + 0.49,0)	
    
    For i := 1 To nFardos
    
	    AADD(aDados, { 	AllTrim(STRzero(nVolume,4)),;					//aDados[1]
	    				AllTrim(STRzero(nVolumeX,4)),;					//aDados[2]
	    				SF2->F2_DOC,;									//aDados[3]
	    				Round((SD2->D2_QUANT  * SB1->B1_QE) + 0.49,0),;	//aDados[4]
	    				Alltrim(SD2->D2_COD) ,;							//aDados[5]
	    				Alltrim(SB1->B1_DESC) ,;						//aDados[6]
	    				cDestino })										//aDados[7]
	    				
		nVolume 	:= nVolume + 1
	
	Next i
	
	cNotaAnt 	:= SD2->D2_DOC
	dbSelectArea("SD2")
	SD2->(dbSkip())

	If cNotaAnt <> SD2->D2_DOC
	
		//Imprime a etiqueta
		If Len(aDados) > 0
			Processa({ || U_fPrintEt(aDados, mv_par05) }, "Imprimindo...", "NF N ... " + cNotaAnt,.F.)
		Else
			MsgAlert("Nota nao encontrada entre " + mv_par02 + " e " + mv_par03)
		EndIf
		
		nVolume 	:= 1
		aDados		:= {}
		
	EndIf

EndDo

Return





User Function fPrintEt(aDados,nEtiqueta)

Local _cPorta	:= 'LPT1'//'COM1:9600,8,N,1' //'LPT1'
Local _aDados	:= aDados
Local _x		:= 1

MSCBPRINTER("ZEBRA",_cPorta,NIL,,.F.,,,,,,.T.)

If nEtiqueta > 0

		//MsgAlert("Inicio Etiqueta " + _aDados[nEtiqueta][1])
		Conout("Inicio Etiqueta " + _aDados[nEtiqueta][1])

		MSCBBEGIN(1,1)                             
	
		MSCBBOX(04,04,97,50,8) //Box Geral
		MSCBBOX(04,04,33,20,100) //Box Rava

		Do Case
			Case FWCodFil() == "06"  
	
				MSCBSAY(07,07,"NOVA","N","0","80",.T.)	// Horizontal
				MSCBSAY(08,15,"INDUSTRIAL","N","C","14",.T.)	// Horizontal
				
			Case FWCodFil() == "07"  
			
				MSCBSAY(07,07,"TOTAL","N","0","80",.T.)	// Horizontal
				MSCBSAY(08,15,"EMBALAGENS","N","C","14",.T.)	// Horizontal
				
			Otherwise
			
				MSCBSAY(07,07,"RAVA","N","0","80",.T.)	// Horizontal
				MSCBSAY(08,15,"EMBALAGENS","N","C","14",.T.)	// Horizontal
				
		End Case
		
		MSCBSAY(53,06,"NOTA FISCAL / SERIE","N","0","22")	// Horizontal
		MSCBSAY(39,10,_aDados[nEtiqueta][3] + "/" + mv_par01,"N","0","80",.T.)	// Horizontal

		MSCBLineH(04,20,97,4) //LInha abaixo  rava
		//Litragem
		MSCBBOX(04,20,33,28,54) // Box Volume
		MSCBSAY(14,22,"VOLUME:","N","0","40",.T.)	// Horizontal
		MSCBSAY(42,22,_aDados[nEtiqueta][1],"N","0","44",.T.)
		MSCBSAY(62,22,'/',"N","0","44",.T.)
		MSCBSAY(73,22,_aDados[nEtiqueta][2] ,"N","0","44",.T.)
	
		MSCBLineH(04,28,97,4)//Linha abaixo volume
	
		MSCBSAY(07,30,"CODIGO / DESCRIÇÃO ","N","0","35",.T.)	// Horizontal
		MSCBBOX(50,28,76,32,50) // Box especie
		MSCBSAY(55,30,"ESPECIE:","N","0","35",.T.)	// Horizontal
		MSCBLineH(04,34,97,4) //Linha  abaixo codigo
		MSCBSAY(80,30,"SC / CX","N","0","35",.T.)	// Horizontal
	
		MSCBSAY(07,35,_aDados[nEtiqueta][5] + " - " + SubStr(_aDados[nEtiqueta][6],1,30) ,"N","0","32",.T.)	// Horizontal
		MSCBSAY(07,39,SubStr(_aDados[nEtiqueta][6],31,30),"N","0","32",.T.)	// Horizontal
	
		MSCBLineH(04,43,97,4)
		MSCBBOX(04,43,33,47,50) //Box destino
		MSCBSAY(14,45,"DESTINO:","N","0","35",.T.)	// Horizontal
		MSCBSAY(36,45,_aDados[nEtiqueta][7],"N","0","35",.T.)	// Horizontal
	
		MSCBEND() 
		Conout("Fim Etiqueta " + _aDados[nEtiqueta][1])

Else
	
	While _x <= Len(_aDados)

		Conout("Inicio Etiqueta " + _aDados[_x][1])

		MSCBBEGIN(1,1)                             
	
		MSCBBOX(04,04,97,50,8) //Box Geral
		MSCBBOX(04,04,33,20,100) //Box Rava

		Do Case
			Case FWCodFil() == "06"  
	
				MSCBSAY(07,07,"NOVA","N","0","80",.T.)	// Horizontal
				MSCBSAY(08,15,"INDUSTRIAL","N","C","14",.T.)	// Horizontal
				
			Case FWCodFil() == "07"  
			
				MSCBSAY(07,07,"TOTAL","N","0","80",.T.)	// Horizontal
				MSCBSAY(08,15,"EMBALAGENS","N","C","14",.T.)	// Horizontal
				
			Otherwise
			
				MSCBSAY(07,07,"RAVA","N","0","80",.T.)	// Horizontal
				MSCBSAY(08,15,"EMBALAGENS","N","C","14",.T.)	// Horizontal
				
		End Case
		
		MSCBSAY(53,06,"NOTA FISCAL / SERIE","N","0","22")	// Horizontal
		MSCBSAY(39,10,_aDados[_x][3] + "/" + mv_par01,"N","0","80",.T.)	// Horizontal

		MSCBLineH(04,20,97,4) //LInha abaixo  rava
		//Litragem
		MSCBBOX(04,20,33,28,54) // Box Volume
		MSCBSAY(14,22,"VOLUME:","N","0","40",.T.)	// Horizontal
		MSCBSAY(42,22,_aDados[_x][1],"N","0","44",.T.)
		MSCBSAY(62,22,'/',"N","0","44",.T.)
		MSCBSAY(73,22,_aDados[_x][2] ,"N","0","44",.T.)
	
		MSCBLineH(04,28,97,4)//Linha abaixo volume
	
		MSCBSAY(07,30,"CODIGO / DESCRIÇÃO ","N","0","35",.T.)	// Horizontal
		MSCBBOX(50,28,76,32,50) // Box especie
		MSCBSAY(55,30,"ESPECIE:","N","0","35",.T.)	// Horizontal
		MSCBLineH(04,34,97,4) //Linha  abaixo codigo
		MSCBSAY(80,30,"SC / CX","N","0","35",.T.)	// Horizontal
	
		MSCBSAY(07,35,_aDados[_x][5] + " - " + SubStr(_aDados[_x][6],1,30) ,"N","0","32",.T.)	// Horizontal
		MSCBSAY(07,39,SubStr(_aDados[_x][6],31,30),"N","0","32",.T.)	// Horizontal
	
		MSCBLineH(04,43,97,4)
		MSCBBOX(04,43,33,47,50) //Box destino
		MSCBSAY(14,45,"DESTINO:","N","0","35",.T.)	// Horizontal
		MSCBSAY(36,45,_aDados[_x][7],"N","0","35",.T.)	// Horizontal
	
		MSCBEND() 
		Conout("Fim Etiqueta " + _aDados[_x][1])
		
		_x		:= _x + 1

	EndDO

EndIf

MSCBCLOSEPRINTER() 

Return