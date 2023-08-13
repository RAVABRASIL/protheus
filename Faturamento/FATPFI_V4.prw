#include "rwmake.ch"
#INCLUDE "Topconn.CH"
#INCLUDE "fivewin.CH"
#INCLUDE "PROTHEUS.CH"
************************
User Function FATPFIV4()
************************

SetPrvt("CALIASANT,CDESC1,CDESC2,CDESC3,ARETURN,CARQUIVO")
SetPrvt("AORD,CNOMREL,CTITULO,NLASTKEY,NMIDIA,AMES"      )
SetPrvt("NI,CANO,NREG,ADIA,NDIA,NDIASSAC,NVALORT,NPRZMDT")
SetPrvt("NPESOT,NDIAST,NDIAXVLT,NNOTAST,DDATA,NTOTZC"    )
SetPrvt("NVALZIP,NVALCUR,NVALOR,NPESO,NDIAS,NDIAXVL"     )
SetPrvt("NNOTAS,NQTDKG,NREGTOT,AADEDS,CTAMANHO,CCARACTER")
SetPrvt("M_PAG,NVALACUM,NLIN,NCONTI,NPATING,NTENDEN"     )
SetPrvt("NVAL,NIDEAL,NFATOR,NMARGEM,NPRZMED,NFATDIA"     )
SetPrvt("CTEXTO,NDIATOT,nCartKG,nCartRS,nTot,nTotTot,nTotPeso,nTotVal,nAcCar")
SetPrvt("dDatMax,nAcctr,aArct,nPRZMT,nCartPR,nCartIM,nAcePR,nAceIM,nCartPRK,nCartIMK,nBonific")
SetPrvt("nTp,cCodigo" )

      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Ana B. Alencar                           ³ Data ³ 15/06/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Posicao Vendas                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Uso   ³ Comercial                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*
Diretoria
Gerencia
Coordenador
Representante
nTipo: 1=Diretor; 2=Gerente; 3=Coordenador; 4=Representante
cCod: Codigo do Gerente, Coordenador ou Representnate, se deixado em branco gera p/ diretor
*/

cALIASANT := alias()
cDESC1    := ""
cDESC2    := ""
cDESC3    := ""
aRETURN   := { "Zebrado", 1, "DECOM", 2, 2, 1, "", 1 }
cARQUIVO  := "SF2"
aORD      := { "Por Data" }
cNOMREL   := "FATPFIV4"
//cTITULO   := "Posicao Vendas v4.0 - "
cTITULO   := "Posicao Vendas v4.0 "
nLASTKEY  := 0
nBonific  := 0

Pergunte('FAPFV4', .T.)


cNOMREL := setprint( cARQUIVO, cNOMREL, "FAPFV4", @cTITULO, cDESC1, cDESC2, cDESC3, .f., aORD )

If nLastKey == 27
	Return
Endif

setdefault( aRETURN, cARQUIVO )

If nLastKey == 27
	Return
Endif

nMIDIA := aRETURN[ 5 ]

RptStatus({|| RptDetail()})

Return


***************************
Static Function RptDetail()
***************************

Local lExt := .F.
Local cQuery := ""
Local LF      	:= CHR(13)+CHR(10)
Local dDataIni := Ctod("  /  /    ") 
Local nDiaspass:= 0
Local Cabec1         := Space(40)
Local Cabec2         := ""

PRIVATE dDataIni
PRIVATE dDataFim  
Private dTExec
 

/*
/////////////////////////////////////////////////////////////////////////////////////////////////////
// Parâmetros:                                                                                     //
//MV_PAR01 - Mês da posição                                                                        //
//MV_PAR02 - Vlr. da Meta                                                                          //
//MV_PAR03 - No. de dias úteis                                                                     //
//MV_PAR04 - Tipo (1 - R$ / 2 - KG)                                                                //
//MV_PAR05 - Valor da MP                                                                           //
//MV_PAR06 - Notas com apara (S=Sim / N=Não)                                                       //
//MV_PAR07 - Considerar ( 1-Linha hospital / 2-Linha doméstica / 3-Linha institut. / 4-Todos       //
//MV_PAR08 - UF                                                                                    //
//MV_PAR09 - Excluir UF                                                                            //
//MV_PAR10 - Relats.Específicos (1-Inst.Dom(BR) / 2-Hospitalar SP / 3-Hosp Brasil (SP) / 4-Normal  //
//MV_PAR11 - Representante                                                                         //
//MV_PAR12 - Coordenador                                                                           //
//MV_PAR13 - Gerente                                                                               //
//MV_PAR14 - Agendamento/Siga? (1-Agendado / 2-Menu Siga)                                          //
////////////////////////////////////////////////////////////////////////////////////////////////////
*/

//If  Select( 'SX2' ) == 0
	DBSelectArea("SX5")
	DbSetOrder(1)
	If SX5->(Dbseek(xFilial("SX5") + "Z3" + Alltrim( Substr(Dtos(dDatabase),1,6))  ))  
		mv_par05 := 4.23 //Val( Alltrim(SX5->X5_DESCRI) )
	Endif
//Endif

aMES := { 'Janeiro', 'Fevereiro', 'Marco', 'Abril', 'Maio', 'Junho',;
          'Julho', 'Agosto', 'Setembro', 'Outubro','Novembro', 'Dezembro' }

for nI := 1 to 12
	cANO := StrZero( Year( dDATABASE ), 4 )
	aMES[nI] := aMES[nI] + "/" + cANO
next

//cTITULO := cTITULO + aMES[Val(MV_PAR01)]
//cTITULO := cTITULO + iif( MV_PAR04 == 1, ' - Em R$ - ', ' - Em Kg - ' )

dbselectarea( 'SD2' )
SD2->( dbsetorder( 3 ) )

dbselectarea( 'SB1' )
SB1->( dbsetorder( 1 ) )

dbselectarea( 'SE4' )
SE4->( dbsetorder( 1 ) )

dbselectarea( 'SA3' )
SA3->( dbsetorder( 1 ) )

dbselectarea( 'SF2' )
SF2->( dbsetorder( 9 ) )



////verificação para o cabeçalho em caso de schedule
//If MV_PAR14 = 1

	if MV_PAR07 = 1 .and. mv_par10 == 4
	   Cabec1 := Cabec1 +" Linha Hospitalar - "
	
	elseif MV_PAR07 = 2 .and. mv_par10 == 4
	   Cabec1 := Cabec1 +" Linha Domestica  - "
	
	elseif MV_PAR07 = 3 .and. mv_par10 == 4
	   Cabec1 := Cabec1 +" Linha Institucio.- "
	
	elseif MV_PAR07 = 4 .and. mv_par10 == 4
	   Cabec1 := Cabec1 +" Todas as Linhas - "
	
	elseif mv_par10 == 1
	   Cabec1 := Cabec1 +" Inst/Dom.-Brasil.- "
	   MV_PAR07 = 5
	   mv_par08 := ""
	   mv_par09 := ""
	
	elseif mv_par10 == 2
	   Cabec1 := Cabec1 +" Hospitalar só SP - "
	   MV_PAR07 = 1
	   mv_par08 := "SP"//só SP
	   mv_par09 := ""
	
	elseif mv_par10 == 3
	   Cabec1 := Cabec1 +" Hosp/Brasil Sem SP - "
	   MV_PAR07 = 1
	   mv_par08 := ""
	   mv_par09 := "SP"   //tudo, menos SP
	endif
	
	Cabec1 := Cabec1 + aMES[Val(MV_PAR01)] + " - "
	Cabec1 := Cabec1 + iif( MV_PAR04 == 1, ' Em R$ - ', ' Em Kg - ' ) 
	
	if !empty(MV_PAR08) .and. empty(MV_PAR09)
	   Set Filter To SF2->F2_FILIAL = xFilial("SF2") .AND. SF2->F2_EST  = MV_PAR08
	   Cabec1 += "So a UF: "+MV_PAR08+" - "
	
	elseIf empty(MV_PAR08) .and. !empty(MV_PAR09)
	   Set Filter To SF2->F2_FILIAL = xFilial("SF2") .AND. SF2->F2_EST != MV_PAR09
	   Cabec1 += "Menos a UF: "+MV_PAR09+" - "
	
	elseIf !empty(MV_PAR08) .and. !empty(MV_PAR09)
		Set Filter To SF2->F2_FILIAL = xFilial("SF2") .AND. SF2->F2_EST  = MV_PAR08 .AND. SF2->F2_EST != MV_PAR09
	endIf
	
	if !empty(MV_PAR11) //Representante
	   SA3->(Dbsetorder(1))
       SA3->( dbSeek( xFilial( "SA3" ) + mv_par11 ) )
        
	   Cabec1 +=alltrim(MV_PAR11)+" - " + SA3->A3_NREDUZ //+posicione("SA3",1,xFilial('SA3') + MV_PAR11,"A3_NREDUZ") 
	   Set Filter To SF2->F2_FILIAL = xFilial("SF2") .AND. ALLTRIM(SF2->F2_VEND1) $ ALLTRIM(MV_PAR11)+"/"+ALLTRIM(MV_PAR11)+"VD" 
	   lExt := .T.
	
	elseif !empty(MV_PAR12) //Coordenador
	   SA3->(Dbsetorder(1))
       SA3->( dbSeek( xFilial( "SA3" ) + mv_par12 ) ) 
       
	   Cabec1 +="Coordenador - " + SA3->A3_NREDUZ //+ posicione("SA3",1,xFilial('SA3') + MV_PAR12,"A3_NREDUZ") 
	elseif !empty(MV_PAR13)  //Gerente
	   SA3->(Dbsetorder(1))
       SA3->( dbSeek( xFilial( "SA3" ) + mv_par13 ) )
        
	   Cabec1 +="Gerente - " + SA3->A3_NREDUZ //+ posicione("SA3",1,xFilial('SA3') + MV_PAR13,"A3_NREDUZ") 
	else
	   Cabec1 +="Diretoria"
	endif
    
//Endif


/*
SF2->( DbSeeK( xFILIAL('SF2') + DtoS( CtoD( '01/'+MV_PAR01+'/'+Right(StrZero(Year(dDATABASE),4),2) ) ), .T. ) )
nREG := SF2->( RecNo() )
Count To nREGTOT While StrZero( Month( SF2->F2_EMISSAO ), 2 ) == MV_PAR01
SF2->( DbGoTo( nREG ) )
SetRegua( nREGTOT )
*/

//dDataIni := CtoD( '01/'+MV_PAR01+'/'+Right(StrZero(Year(dDATABASE),4),2) ) no dia 1o. não há faturamento
dTExec := Dtoc(dDatabase)
nMesExec := 0
If Substr(dTExec,1,2) = '01'  //se a execução for num dia 1o., retrocede ao mês anterior para capturar o mês cheio


	nMesExec := Month(dDatabase) - 1 
	MV_PAR01 := Strzero(nMesExec,2)
	
Endif

dDataIni := CtoD( '02/'+MV_PAR01+'/'+Right(StrZero(Year(dDATABASE),4),2) )
dDataFim := Ultimodia( dDataIni, Month(dDataIni) )


////count para o nREGTOT
cQuery := " SELECT COUNT(*) AS QTREGS FROM " + LF
cQuery += " " + RetSqlName("SF2") + " SF2, "+LF
cQuery += " " + RetSqlName("SA3") + " SA3 "+LF

cQuery += " WHERE F2_EMISSAO >= '" + DtoS( CtoD( '01/'+MV_PAR01+'/'+Right(StrZero(Year(dDATABASE),4),2) ) ) + "' "+LF
cQuery += " AND F2_EMISSAO <= '" + DtoS( dDataFim ) + "' "+LF
cQuery += " AND F2_DUPL <> '' "+LF
cQuery += " AND RTRIM(F2_VEND1) = RTRIM(A3_COD) "+LF
If !Empty(MV_PAR11)
	cQuery += " AND RTRIM(A3_COD) LIKE ('"+ Alltrim(MV_PAR11) + "%' )"+LF

elseif !Empty(MV_PAR12)//Coordenador
	//cQuery += " AND RTRIM(A3_SUPER) LIKE ('" + ALLTRIM(MV_PAR12) + "%' )"+LF 
    cQuery += " AND ( RTRIM(A3_SUPER) LIKE ('" + ALLTRIM(MV_PAR12) + "%')  OR RTRIM(F2_VEND1) LIKE ('" + Alltrim(MV_PAR12) + "%') )"+LF 
elseif !Empty(MV_PAR13) //Gerente	
	cQuery += " AND ( A3_SUPER IN ( SELECT A3_COD FROM "+RetSqlName("SA3")+" SA3 WHERE RTRIM(A3_GEREN) LIKE ('" + ALLTRIM(MV_PAR13) + "%' )  and SA3.D_E_L_E_T_ != '*' ) "+LF
	cQuery += " OR A3_GEREN LIKE ( '" + ALLTRIM(MV_PAR13) + "%' ) ) "+LF
endif

cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "' AND SF2.D_E_L_E_T_ = '' "+LF
cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = '' "+LF
//cQuery += " ORDER BY F2_EMISSAO "
//MemoWrite("C:\Temp\fatpfiv4.sql" , cQuery )
If Select("FATP") > 0
	DbSelectArea("FATP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "FATP"

FATP->( DbGoTop() )
While FATP->(!EOF())
	nREGTOT := FATP->QTREGS
	FATP->(Dbskip())
Enddo

DbSelectArea("FATP")
DbCloseArea()

SetRegua( nREGTOT )
/////fim do count

cQuery := " SELECT * FROM " + RetSqlName("SF2") + " SF2, "+LF
cQuery += " " + RetSqlName("SA3") + " SA3 "
cQuery += " WHERE F2_EMISSAO >= '" + DtoS( CtoD( '01/'+MV_PAR01+'/'+Right(StrZero(Year(dDATABASE),4),2) ) ) + "' "+LF
cQuery += " AND F2_EMISSAO <= '" + DtoS( dDataFim ) + "' "+LF
cQuery += " AND F2_DUPL <> '' "+LF
cQuery += " AND RTRIM(F2_VEND1) = RTRIM(A3_COD) "+LF

If !Empty(MV_PAR11)
	cQuery += " AND RTRIM(A3_COD) LIKE ('"+ Alltrim(MV_PAR11) + "%' )"+LF

elseif !Empty(MV_PAR12)//Coordenador
	cQuery += " AND ( RTRIM(A3_SUPER) LIKE ('" + ALLTRIM(MV_PAR12) + "%')  OR RTRIM(F2_VEND1) LIKE ('" + Alltrim(MV_PAR12) + "%') )"+LF 

elseif !Empty(MV_PAR13) //Gerente	
	cQuery += " AND ( A3_SUPER IN ( SELECT A3_COD FROM "+RetSqlName("SA3")+" SA3 WHERE RTRIM(A3_GEREN) LIKE ('" + ALLTRIM(MV_PAR13) + "%' )  and SA3.D_E_L_E_T_ != '*' ) "+LF
	cQuery += " OR A3_GEREN LIKE ( '" + ALLTRIM(MV_PAR13) + "%' ) ) "+LF
endif


cQuery += " AND SF2.F2_FILIAL = '" + xFilial("SF2") + "' AND SF2.D_E_L_E_T_ = '' "+LF
cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = '' "+LF
cQuery += " ORDER BY F2_EMISSAO, F2_VEND1 "+LF
MemoWrite("C:\Temp\FATPFIV4.sql", cQuery )
If Select("FATP") > 0
	DbSelectArea("FATP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "FATP"

TCSetField( "FATP", "F2_EMISSAO", "D")

////inicializa as variáveis
aDIA := {}   
aADEDS := {}
nDIASSAC := nDIA := 0
nPRZMDT := nVALORT := nPESOT := nDIAST := nDIAXVLT := nNOTAST := 0
nTotTot := nCartIMR :=  nAceIM := nCartIMK := 0
nVALACUM  := 0


FATP->( DbGoTop() )
While FATP->( !EOF() )
	dDATA  := FATP->F2_EMISSAO
	nPRZMD := nTOTACE := nVALOR := nPESO := nDIAS := nDIAXVL := nNOTAS :=nTOTDES:= 0
	Do While ! FATP->( eof() ) .And. FATP->F2_EMISSAO == dDATA .And. StrZero( Month( FATP->F2_EMISSAO ), 2 ) == MV_PAR01
		If ( ! Empty( FATP->F2_DUPL ) )
			nTTSD2 := 0 
			nQtdKg := 0
			_nTOTA := nVALZIP := nVALCUR := nVALABR1 := nVALABR2 := nVALABRA3 := nVALETQ := nVALFEC := 0
            lConta := .F.
		    
			SA3->(Dbsetorder(1))
            /*
            SA3->( dbSeek( xFilial( "SA3" ) + FATP->F2_VEND1 ) )                   			
            if !Empty(MV_PAR12)//Coordenador
               if !Alltrim(SA3->A3_SUPER) $ ALLTRIM(MV_PAR12)+"/"+ALLTRIM(MV_PAR12)+"VD" 
                  FATP->( dbSkip() )	
                  Loop
               endif               			
            elseif !Empty(MV_PAR13) //Gerente
               SA3->( dbSeek( xFilial( "SA3" ) + SA3->A3_SUPER ) )                   			
               if !Alltrim(SA3->A3_GEREN) $ ALLTRIM(MV_PAR13)+"/"+ALLTRIM(MV_PAR13)+"VD" 
                  FATP->( dbSkip() )	
                  Loop
               endif   
	        endif             
			*/
			//desconto
			nTOTDES+= Descon( FATP->F2_DOC) 
			SD2->( dbSeek( xFilial( "SD2" ) + FATP->F2_DOC + FATP->F2_SERIE, .T. ) )
		  	
			//If (SD2->D2_CF $ "511  /5101 /5107 /611  /6101 /512 /5102 /612  /6102 /6109 /6107 /5949 /6949 / 5922 / 6922 / 5116 / 6116 ") 
			//FR - 07/04/2011 - incluídos os CFOPs: 5922 e 6922
			//FR - 29/04/2011 - Incluídos os CFOPs: 5116 e 6116
                                                                                                                //Remessa MIXKIT,AMOSTRA
				Do while SD2->D2_DOC + SD2->D2_SERIE == FATP->F2_DOC + FATP->F2_SERIE .and. SD2->( !eof() ) //.and. !ALLTRIM(SD2->D2_TES) $ '540/516'
                    //Remessa MIXKIT,AMOSTRA
                   IF ALLTRIM(SD2->D2_TES) $ '540/516'
                      SD2->( dbSkip() )	
               		  Loop
                   Endif
   
                   If ! ALLTRIM(SD2->D2_CF) $ "511/5101/5107/611/6101/512/5102/612/6102/6109/6107/5949/6949/5922/6922/5116/6116" 
                      SD2->( dbSkip() )	
               		  Loop
                   ENDIF
                   
                   // tira o que e CAIXA 
		           SB1->( dbSeek( xFilial( "SB1" ) + SD2->D2_COD ) )
	               If SB1->B1_SETOR=='39' //CAIXA 
               	      SD2->( dbSkip() )	
               		  Loop
	               Endif             
                   
                   if MV_PAR07 = 1
                       //Senao for do Grupo Hospitalar
      			        if !Alltrim(SD2->D2_GRUPO) $ "C"
   	     		           SD2->(DbSkip())
      			           Loop
     			        endif
				   elseif MV_PAR07 = 2
                       //Senao for do Grupo Linha Domestica
     			        if !Alltrim(SD2->D2_GRUPO) $ "D/E"
   	    		           SD2->(DbSkip())
   		    	           Loop
   			            endif
				   elseif MV_PAR07 = 3
                      //Se não for do Grupo Linha Institucional, Lanche e Sacola
     			      if !Alltrim(SD2->D2_GRUPO) $ "A/B/F/G"
   	    		         SD2->(DbSkip())
   		    	         Loop
   			          endif
   				   elseif MV_PAR07 = 5
   					  //Institucional, Lanche, Sacola e Doméstica 05/03/09
   					  if !Alltrim(SD2->D2_GRUPO) $ "A/B/D/E/F/G"
   	    		         SD2->(DbSkip())
   		    	         Loop
   			          endif   					 
   			       endif
				   If MV_PAR06 == 1 .AND. substr(SD2->D2_COD,1,1) != 'M' //INCLUINDO AS APARAS MV_PAR06
						nVALOR := nVALOR + SD2->D2_TOTAL
						SB1->( dbSeek( xFilial( "SB1" ) + SD2->D2_COD ) )
						//nQtdKg := nQtdKg + IIf( Empty( SD2->D2_SERIE ) .and. !'VD' $ FATP->F2_VEND1, 0, ( SD2->D2_QUANT * SB1->B1_PESOR ) )
                        nQtdKg := nQtdKg + IIf( Empty( SD2->D2_SERIE ) .and. !'VD' $ FATP->F2_VEND1, 0, ( SD2->D2_QUANT * SD2->D2_PESO ) )
                        nAC := 0
						If ((substring(AllTrim( SD2->D2_COD ),1,1) == 'E') .or. (substring(AllTrim( SD2->D2_COD ),1,1) == 'D'))// .and. MV_PAR07 == 1
							nAcess  := limpBras( SD2->D2_COD )
							nTOTACE += nAcess * SD2->D2_QUANT
							nAC     := nAcess * SD2->D2_QUANT
							nTTSD2  += SD2->D2_TOTAL - nAC
						ElseIf substring(AllTrim( SD2->D2_COD ),1,1) == 'C' //acessorios hospitalares
							nAC := calcAcs(SD2->D2_COD) * SD2->D2_QUANT
							nTOTACE += nAC
							nTTSD2 += SD2->D2_TOTAL - nAC
						Else //sem acessorios
							nTTSD2 += SD2->D2_TOTAL
						EndIf
						If SD2->D2_TES == "541"
							nTOTACE += 0.23 * SD2->D2_TOTAL
							nAC     := 0.23 * SD2->D2_TOTAL
						endIf
						SD2->( dbSkip() ) //SKIP AQUI!
				   ElseIf (MV_PAR06 == 2) .AND. SD2->D2_TP != "AP" .AND. substr(SD2->D2_COD,1,1) != 'M' //EXCLUINDO AS APARAS MV_PAR06
					    if !lConta
                           lConta := .T.
                        endif
						nVALOR := nVALOR + SD2->D2_TOTAL
						SB1->( dbSeek( xFilial( "SB1" ) + SD2->D2_COD ) )
						//nQtdKg := nQtdKg + IIf( Empty( SD2->D2_SERIE ) .and. !'VD' $ FATP->F2_VEND1, 0, ( SD2->D2_QUANT * SB1->B1_PESOR ) ) //retirado para checagem do erro da media de peso dia 28/12/06
                        nQtdKg := nQtdKg + IIf( Empty( SD2->D2_SERIE ) .and. !'VD' $ FATP->F2_VEND1, 0, ( SD2->D2_QUANT * SD2->D2_PESO) )
                        nAC := 0
						If ((substring(AllTrim( SD2->D2_COD ),1,1) == 'E') .or. (substring(AllTrim( SD2->D2_COD ),1,1) == 'D'))//  .and. MV_PAR07 == 1
                            nAcess  := limpBras( SD2->D2_COD )
							nTOTACE += nAcess * SD2->D2_QUANT
							nAC     := nAcess * SD2->D2_QUANT
							nTTSD2  += SD2->D2_TOTAL - nAC
						ElseIf substring(AllTrim( SD2->D2_COD ),1,1) == 'C' //acessorios hospitalares
							nAC := calcAcs(SD2->D2_COD) * SD2->D2_QUANT
							nTOTACE += nAC
							nTTSD2 += SD2->D2_TOTAL - nAC
						Else //sem acessorios
							nTTSD2 += SD2->D2_TOTAL
						EndIf
						If SD2->D2_TES == "541"
							nTOTACE += 0.23 * SD2->D2_TOTAL
							nAC     := 0.23 * SD2->D2_TOTAL
						endIf

						SD2->( dbSkip() ) //SKIP AQUI
				   Else//nunca sera executado
						SD2->( dbSkip() )//SKIP AQUI!
				   EndIf//fim dos ifs (hospitalar/limpeza ou brasileirinho/sem acessorio, nesta ordem)
				Enddo
                if lConta
     			   nPESO   += nQtdKg
    			   nDIAS   += FATP->F2_VALMERC //Variavel obsoleta
    			   nNOTAS += IIf(FATP->F2_SERIE $ "UNI/0  ".OR.(Empty(FATP->F2_SERIE).and.'VD' $ FATP->F2_VEND1),1,0)					 //e todos os prazos, segundo a formula. somat(prazo * valor da nota)
                   nPRZMD += IIf(FATP->F2_SERIE $ "UNI/0  ".OR.(Empty(FATP->F2_SERIE).and.'VD' $ FATP->F2_VEND1),GetPrzM(),0)
                endif
			//Endif
		EndIf

		FATP->( DbSkip() )
		IncRegua()
	EndDo

	If ! Empty( nVALOR )
		nVALOR := nVALOR - nTOTACE - nTOTDES //Valor total das notas sem acessorios (cada nota) E com desconto
		nDIA     := nDIA + 1
		nDiaspass := DiasUteis( dDataIni, dDATA ) //dDATA - dDataIni
	
	
		/////////////  		1				2		3	   4	  5		  6		  7		   8		9	  10		11		
		Aadd( aDIA, { StrZero( nDIA, 2 ), dDATA, nVALOR, nPESO, nDIAS, nDIAXVL, nNOTAS, nTOTACE, nPRZMD,nTOTDES, nDiaspass } )//nPRZMD inserido em 09/10/06
		nVALORT  := nVALORT  + nVALOR  //valor total do dia por item do SD2 sem acessorios, sem uso
		nPESOT   := nPESOT   + nPESO	 //nao influenciado por mudancas
		nNOTAST  := nNOTAST  + nNOTAS  //nao influenciado por mudancas
	EndIf
EndDo

nLIN := cabec( cTITULO, Cabec1, Cabec2, cNOMREL, cTAMANHO, cCARACTER )

if ! Empty( aDIA )
	nREGTOT := Len( aDIA )
    nPRZMT  := 0
	SetRegua( nREGTOT )

	AADEDS    := Asort( aDIA,,, { | x, y | x[ 1 ] < y[ 1 ] } )
	cTAMANHO  := "M"
	cCARACTER := 15
	m_pag     := 1

	nVALACUM  := 0
	nVALAC2   := 0 

	//nLIN := cabec( cTITULO, Cabec1, Cabec2, cNOMREL, cTAMANHO, cCARACTER )
	
	
	@ PRow()+1, 00     pSay Repl( "*", 132 )
    if !lExt		///só faz este cabeçalho em caso de gerente ou coordenador (esta variável lógica só fica verdadeira se for Representante - MV_PAR11 não vazio)
	   @ PRow()+1, 00     pSay "N§   --Data--   Fatur. Dia  Desp.Aces   Abatimento  Fatur.Acum.    %Ating.    Ideal_Acum.    Tenden.    Fator    Margem   Pz.Md."//  Dias"
	   //@ PRow()+1, 00     pSay "                                                                                                                                 Uteis"
	                      //    99   99/99/99   999.999,99  99.999,99   9999.999,99     999,99    9999.999,99     999.99   99,999    999,99      99         99     99
	                      //    12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	                      //             1         2         3         4         5         6         7         8         9        10        11        12        13        14 
	else
	   @ PRow()+1, 00     pSay "N§   --Data--   Fatur. Dia  Desp.Aces   Abatimento  Fatur.Acum.    %Ating.    Ideal_Acum.    Tenden.  Pz.Md."
	                      //    99   99/99/99   999.999,99  99.999,99   9999.999,99 9999.999,99     999.99    9999.999,99     999.99     99  
	                      //    12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	                      //             1         2         3         4         5         6         7         8         9        10        11        12        13        14  
	endif
	
	
	@ PRow()+1, 00     pSay Repl( "*", 132 )

    nTotMG	:= 0
    
    //dUltimodia := Ultimodia( dDataIni, Month(dDatabase))  ///captura o último dia do mês
    dUltimodia := Ultimodia( dDataIni, Month(dDataIni))  ///captura o último dia do mês
    
    //Fiz esta solução pois o "fórmula" tá fixado 22 dias, e qdo o mês tiver menos dias úteis o cálculo ficará incorreto
    mv_par03 := DiasUteis(dDataIni, dUltimodia )
    //msgbox("Dias uteis: " + str(mv_par03) )
    
    
    
	For nCONTI := 1 To Len( aADEDS )
		nPESO   := aADEDS[nCONTI,4]
		nVALOR  := aADEDS[nCONTI,3]

		If MV_PAR04 == 1        ////R$
			nVALACUM := nVALACUM + aADEDS[nCONTI,3] //totaliza valacum com todos os nDias
			
			If !Empty(MV_PAR02) ///Meta
			
				nPATING  := Round( (nVALACUM/MV_PAR02)*100, 2 )           
				nTENDEN  := Round( (((nVALACUM/Val(aADEDS[nCONTI,1]))* MV_PAR03)/MV_PAR02)*100, 2 ) 
			ElseIF !Empty(MV_PAR11) 
				                    
				nPATING  := Round( (nVALACUM / meta(MV_PAR11) )*100, 2 )           
				nTENDEN  := Round( (((nVALACUM / aADEDS[nCONTI,11] ) * MV_PAR03) / meta(MV_PAR11) )*100, 2 )   //MV_PAR11 - qtde dias decorridos
			
			ElseIF !Empty(MV_PAR12)  ///é coordenador
			
				nPATING := Round(  (nVALACUM / metaC(MV_PAR12) ) *100, 2 )
				nTENDEN  := Round( (((nVALACUM / aADEDS[nCONTI,11] ) * MV_PAR03) / metaC(MV_PAR12) )*100, 2 ) 
			
			ElseIF !Empty(MV_PAR13)  ///é gerente
			
				nPATING := Round( (nVALACUM / metaG(MV_PAR13) ) *100, 2 )
				nTENDEN  := Round( (((nVALACUM / aADEDS[nCONTI,11] ) * MV_PAR03) / metaG(MV_PAR13) )*100, 2 ) 
			Else			
				nPATING  := Round( (nVALACUM / metaG('0249') )*100, 2 )           							//MV_PAR02 - no Vlr. Meta
				nTENDEN  := Round( (((nVALACUM / aADEDS[nCONTI,11] ) * MV_PAR03) / metaG('0249') )*100, 2 ) ///MV_PAR03 - no. dias úteis no mês
			
			Endif			
			
			nVAL     := nVALOR
			
		Else		////KG
			nVALACUM := nVALACUM + aADEDS[nCONTI,4]   ///PESO
			nVALAC2  += aADEDS[nCONTI,3]
			nVAL     := nPESO
			
			If !Empty(MV_PAR02)	///Meta
				nPATING  := Round( (nVALACUM/MV_PAR02)*100, 2 )           
				nTENDEN  := Round( (((nVALACUM/Val(aADEDS[nCONTI,1]))*MV_PAR03)/MV_PAR02)*100, 2 ) 
			
			ElseIF !Empty(MV_PAR11)	//é representante    
				
				nPATING  := Round( (nVALACUM / meta(MV_PAR11) )*100, 2 )           
				nTENDEN  := Round( (((nVALACUM / aADEDS[nCONTI,11] ) * MV_PAR03) / meta(MV_PAR11) )*100, 2 ) 
			
			ElseIF !Empty(MV_PAR12) //é coordenador 
				
				nPATING := Round(  (nVALACUM / metaC(MV_PAR12) ) *100, 2 )
				nTENDEN  := Round( (((nVALACUM / aADEDS[nCONTI,11 ] ) * MV_PAR03) / metaC(MV_PAR12) )*100, 2 ) 
			
			ElseIF !Empty(MV_PAR13) //é gerente 
				
				nPATING := Round( (nVALACUM / metaG(MV_PAR13) ) *100, 2 )
				nTENDEN  := Round( (((nVALACUM / aADEDS[nCONTI,11] ) * MV_PAR03) / metaG(MV_PAR13) )*100, 2 ) 
			Else				
				nPATING := Round( (nVALACUM / metaG('0249') ) *100, 2 )
					nTENDEN  := Round( (((nVALACUM / aADEDS[nCONTI,11] ) * MV_PAR03) / metaG('0249') )*100, 2 ) 
				
			Endif
			
		EndIf

		If !Empty(MV_PAR02)
			nIDEAL  := Round( (MV_PAR02/ MV_PAR03 ) * Val(aADEDS[nCONTI,1]), 2 )
		    // Ideal       = (Meta    / total dias úteis mês - 1o dia que não tem faturamento) x qtde dias úteis decorridos
		Elseif !Empty(MV_PAR11)		///é representante
			
			nIDEAL  := Round( ( meta(MV_PAR11) / MV_PAR03 )* aADEDS[nCONTI,11], 2 ) //nova fórmula
		
		Elseif !Empty(MV_PAR12)		///é coordenador
		
			nIDEAL  := Round( (metaC(MV_PAR12) / MV_PAR03 ) * aADEDS[nCONTI,11], 2 ) 
		
		Elseif !Empty(MV_PAR13)		///é gerente
			nIDEAL  := Round( (metaG(MV_PAR13) / MV_PAR03 )*Val(aADEDS[nCONTI,1]), 2 )   //para gerente continua a mesma fórmula
		Else
			//nIDEAL  := Round( (MV_PAR02/MV_PAR03)*Val(aADEDS[nCONTI,1]), 2 )     //fórmula anterior
			nIDEAL  := Round( (metaG('0249') / MV_PAR03 )*Val(aADEDS[nCONTI,1]), 2 )   //para gerente continua a mesma fórmula
		Endif                                   
		
		nFATOR  := Round( nVALOR/nPESO, 3 )
		nMARGEM := Round( (nFATOR *100 / MV_PAR05) - 100, 2 )

		nPRZMED := Round( aADEDS[nCONTI,9]/aADEDS[nCONTI,7], 0)
		nPRZMT  += nPRZMED
		nTotMG  += nVal*nMargem

		@ PRow()+1,00       pSay aADEDS[nCONTI,1]
		@ PRow()  ,PCol()+3 pSay aADEDS[nCONTI,2]
		@ PRow()  ,PCol()+3 pSay nVAL              Picture "@E 999,999.99"
		If mv_par04 == 1
			@ PRow()  ,PCol()+2 pSay aADEDS[nCONTI,8]  Picture "@E 99,999.99"  // Incluido por Eurivan
			@ PRow()  ,PCol()+2 pSay aADEDS[nCONTI,10]  Picture "@E 99,999.99" // Desconto
		Else
			@ PRow()  ,PCol()+2 pSay " --- "
		    @ PRow()  ,PCol()+2 pSay space(7)+" --- "
		EndIf
		@ PRow()  ,PCol()+3 pSay nVALACUM          Picture "@E 9,999,999.99"
		@ PRow()  ,PCol()+5 pSay nPATING           Picture "@E 999.99"
		@ PRow()  ,PCol()+4 pSay nIDEAL            Picture "@E 9,999,999.99"
		@ PRow()  ,PCol()+5 pSay nTENDEN           Picture "@E 999.99"
		if !lExt
		   @ PRow()  ,PCol()+4 pSay nFATOR            Picture "@E 999.999"
		   @ PRow()  ,PCol()+4 pSay nMARGEM           Picture "@E 999.99"
		endif   
	   @ PRow()  ,PCol()+4 pSay nPRZMED           Picture "@E 99"
	   //@ PRow()  ,PCol()+2 pSay aADEDS[nCONTI,11] Picture "@E 99"
		IncRegua()
	Next

	nCONTI := Len( aADEDS )
	nVAL   := nFATDIA := 0

	If aADEDS[nCONTI,1] == StrZero( MV_PAR03, 2 )
		If nVALACUM < MV_PAR02
			cTEXTO := "A Menor "
			nVAL   := MV_PAR02 - nVALACUM
		ElseIf nVALACUM > MV_PAR02
			cTEXTO := "A Maior "
			nVAL   := nVALACUM - MV_PAR02
		Else
			cTEXTO := "100% Ok "
		EndIf
	ElseIf aADEDS[nCONTI,1] < StrZero( MV_PAR03, 2 )
		cTEXTO := "100%    "
		nVAL   := nIDEAL - nVALACUM
		nFATDIA:= IIf( nVALACUM < MV_PAR02,Round( ( MV_PAR02-nVALACUM )/( MV_PAR03-Val( aADEDS[nCONTI,1] ) ), 2 ), 0 )
	Else
		cTEXTO := "ERROR   "
	EndIf
	nPREV 	:= nVAL
	nTot		:= nVAL
	@ PRow()+2,00       pSay cTEXTO+space(6) + IIf( ! Empty( nVAL ), TransForm( nVAL, '@E 9,999,999.99' ), Space(10) )
	nVAL := Round( nVALACUM/Val( aADEDS[nCONTI,1]), 2 )
	@ PRow()  ,PCol()+4 pSay "Fat.Med  " +space(9) +TransForm( nVAL, '@E 9,999,999.99' )
	@ PRow()  ,PCol()+4 pSay StrZero(Val(aADEDS[nCONTI,1])+1, 2 ) + "§ Dia"
	nVAL := Round( ( MV_PAR02 - nVALACUM ) / ( MV_PAR03 - Val(aADEDS[nCONTI,1]) ), 2 )
	@ PRow()  ,PCol()+4 pSay space(3)+"Fat.Dia  " + TransForm( nVAL, "@E 9,999,999.99" )
	nVAL := Round( nVALORT/nPESOT, 2 )//fator
	
   	if !lExt
   	   @ PRow()  ,104      pSay TransForm( nVAL, "@E 99.999" )
   	   If mv_par05 > 0
       		@ PRow()  ,114      pSay TransForm( ( ( nVAL/mv_par05 ) * 100 ) - 100, "@E 999.99" )
       Else
       		@ PRow()  ,114      pSay "Valor MP nao Cadastrado"
       Endif
	endif
	
	nVal := nTotMG  += nVal*nMargem
	nVAL := Round(nVAL/nVALORT, 2 )//margem
	nPZTot := 0

   nPRZMT := NoRound((nPRZMT/Len(aADEDS)),0)


    @ PRow()  ,if(!lExt,124,103) pSay TransForm( nPRZMT, "@E 999" )

Else
	@ Prow() + 2 , 000 pSay "Nenhum Faturamento ate o Momento." 
	@ Prow() + 1 , 000 pSay Replicate('_' , 132) 
    /*
	If !Empty(MV_PAR11)
    	@ Prow() , 000 pSay "Ainda nao houve faturamento para este Representante" 

	elseif !Empty(MV_PAR12)//Coordenador
		@ Prow() , 000 pSay "Ainda nao houve faturamento para este Coordenador" 

	elseif !Empty(MV_PAR13) //Gerente	
		@ Prow() , 000 pSay "Ainda nao houve faturamento para este Gerente" 
	endif
    */
	
	
EndIf

Carteira(.F.,1)
nCartPRR := nCartRS
nCartPRK := nCartKG

nAcCar := acsCart(.F.,1)
nAcePR := nAcCar
@ PRow() + 3 ,046 pSay "CARTEIRA PROGRAM.  " + IiF( mv_par04 == 1, "RS " + TransForm( nCartPRR - nAcePR, '@E 9,999,999.99' ), TransForm( nCartPRK, '@E 9,999,999.99' ) + " KG" )

iif(nCartKG  > 0,nFatCart := (nCartRS - nAcCar)/nCartKG, nFatCart := 0 )

iif(nFatCart > 0,nMarCart := Round( (nFatCart*100/MV_PAR05) - 100, 2 ),nMarCart := 0 )

if !lExt       //só imprime se for coordenador / gerente 
	@ PRow() ,091 pSay  TransForm( nFatCart, '@E 999.999' )
	@ PRow() ,102 pSay  TransForm( nMarCart, '@E 999.99' )
Endif

Carteira(.F.,2)
nCartIMR := nCartRS
nCartIMK := nCartKG

nAcCar := acsCart(.F.,2)
nAceIM := nAcCar
@ PRow() + 2,046 pSay "CARTEIRA IMEDIATA  " + IiF( mv_par04 == 1, "RS " + TransForm( nCartIMR - nAceIM, '@E 9,999,999.99' ), TransForm( nCartIMK, '@E 9,999,999.99' ) + " KG" )

nFatCart := (nCartRS - nAcCar)/nCartKG

nMarCart := Round( (nFatCart*100/MV_PAR05) - 100, 2 )
if !lExt		//só imprime se for coordenador / gerente
	@ PRow() ,091 pSay  TransForm( nFatCart, '@E 999.999' )
	@ PRow() ,102 pSay  TransForm( nMarCart, '@E 9,999.99' )
endif

if mv_par04 == 1
   @ Prow() + 2 ,046 PSay "ACESSOR. CARTEIRA  " +"RS " + transform( nAcePR+nAceIM, '@E 9,999,999.99' )
endIf

nCart2 := nFatCt2 := nMarCt2 := nAcctr := 0
aArct := PediDia()		//só considera o q foi liberado
if aArct[1][1] > 0 .and. aArct[1][2] > 0
   nAcctr  := acsPDia()	//só considera o q foi liberado
   nFatCt2 := (aArct[1][2] - nAcctr)/aArct[1][1]
   nMarCt2 := Round( (nFatCt2*100/MV_PAR05) - 100, 2 )
   nCart2  := iif( mv_par04 == 1, aArct[1][2] - nAcctr, aArct[1][1] )
endIf//MV_PAR04
@ PRow() + 2 ,046 pSay "PEDIDOS DE HOJE    " + iif(mv_par04 == 1 , "RS ", "KG ") + TransForm( nCart2+FatMes(2), '@E 9,999,999.99' )
@ PRow()     ,091 pSay  TransForm( nFatCt2, '@E 999.999' )
@ PRow()     ,102 pSay  TransForm( nMarCt2, '@E 999.99'  )
if mv_par04 == 1
   @ Prow() + 2 ,046 PSay "ACESSO. PEDI. HOJE RS " + transform( nAcctr, '@E 9,999,999.99' )
endIf

if mv_par04 == 1
   nTotTot := nVALACUM + (nCartIMR - nAceIM)
else
   nTotTot := nVALACUM + nCartIMK
endif   
                                                                                                                                     
nTotPeso := 0
nTotVal  := 0

for X := 1 to len( aADEDS )
	nTotPeso += aADEDS[X,4]
	nTotVal	 += aADEDS[X,3]
next

nFatTot  := ( nTotVal + ((nCartIMR) - (nAceIM)) ) / ( nTotPeso + nCartIMK )

nBonific := iif(mv_par04 == 1,bonifica()[1],bonifica()[2] )
@ Prow() + 2 ,046 PSay "BONIFICAÇÕES       " + iif(mv_par04 == 1, "RS ", "KG " ) +;
				  transform( nBonific, '@E 9,999,999.99' ) + "     " + transform( ( nBonific / nTotTot ) * 100, '@E 9,999,999.99' )+"%"
@ PRow() + 2 ,046 pSay "TOTAL GERAL        " + IiF( mv_par04 == 1, "RS " + TransForm( nTotTot, '@E 9,999,999.99' ), TransForm( nTotTot, '@E 9,999,999.99' ) + " KG"  )

nMarTot := Round( (nFatTot*100/MV_PAR05) - 100, 2 )

if !lExt //só imprime se for coordenador / gerente
	@ PRow() ,091 pSay  TransForm( nFatTot, '@E 999.999' )
	@ PRow() ,102 pSay  TransForm( nMarTot, '@E 999.99' )
Endif

///27/05/10 - A pedido de Marcílio, voltei a exibição no final do relatório, da meta do representante.
If !empty(MV_PAR11)  //Representante
	If Empty(mv_par02)	//se o parâmetro estiver vazio, calcula
   		@ PRow() + 2 ,046 pSay "META NO MÊS   " + IiF( mv_par04 == 1, "RS  ", "KG  "  ) + TransForm( meta(MV_PAR11), "@E 999,999,999.99" ) 
 	Else
 		@ PRow() + 2 ,046 pSay "META NO MÊS   " + IiF( mv_par04 == 1, "RS  ", "KG  "  ) + TransForm( MV_PAR02, "@E 999,999,999.99" ) 
 	Endif

elseif !empty(MV_PAR12)//Coordenador
	If Empty(mv_par02)		//se o parâmetro estiver vazio, calcula
   		@ PRow() + 2 ,046 pSay "META NO MÊS   " + IiF( mv_par04 == 1, "RS  ", "KG  "  ) + TransForm( metaC(MV_PAR12), "@E 999,999,999.99" ) 
 	Else
 		@ PRow() + 2 ,046 pSay "META NO MÊS   " + IiF( mv_par04 == 1, "RS  ", "KG  "  ) + TransForm( MV_PAR02, "@E 999,999,999.99" ) 
 	Endif
 	
elseif !empty(MV_PAR13)//Gerente
	If Empty(mv_par02)
   		@ PRow() + 2 ,046 pSay "META NO MÊS   " + IiF( mv_par04 == 1, "RS  ", "KG  "  ) + TransForm( metaG(MV_PAR13), "@E 999,999,999.99" ) 
 	Else
 		@ PRow() + 2 ,046 pSay "META NO MÊS   " + IiF( mv_par04 == 1, "RS  ", "KG  "  ) + TransForm( MV_PAR02, "@E 999,999,999.99" ) 
 	Endif
 	
else
   
   If Empty(mv_par02)
   		@ PRow() + 2 ,046 pSay "META NO MÊS   " + IiF( mv_par04 == 1, "RS  ", "KG  "  ) + TransForm( metaG('0249'), "@E 999,999,999.99" )
   Else
   		@ PRow() + 2 ,046 pSay "META NO MÊS   " + IiF( mv_par04 == 1, "RS  ", "KG  "  ) + TransForm( MV_PAR02, "@E 999,999,999.99" )
   Endif
Endif

//Com a ajuste o calculo fica Carteira imediata+carteira programada+ faturamento= vendas do mês.
@ PRow() + 2 ,046 pSay "VENDIDO NO MÊS     " + IiF( mv_par04 == 1, "RS ", "KG "  ) + TransForm( pddMes(dDataIni,dDataFim)+FatMes(1), "@E 999,999,999.99" )
// Função q traz o Vendido no Mês....só CONSIDERA O QUE FOI LIBERADO 
@ Prow() + 2,046 PSAY "MEDIA DE DIAS PEDIDOS EM CARTEIRA " + transform( media(), '@E 999.99')
//Função q traz a média também só considera o que foi liberado
@ Prow() + 2,046 PSAY "N. DIAS DO PEDIDO COM MAIS TEMPO EM CARTEIRA: " + iif( !empty(dDatMax),alltrim(str(dDataBase - dDatMax)), "0") + " dias"
@ Prow() + 2,046 PSAY "N. de NF: "+TransForm( nNOTAST, "@E 9999" )
@ Prow() + 2,046 PSAY "ESTOQUE DE SACOS: "+TransForm( estsaco(), "@E 9,999,999.99" )+" Kg"

SetRegua( nREGTOT )
cTAMANHO  := "M"
cCARACTER := 15
m_pag     := 1 
Prow() + 1

Roda(0,"","M")

If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(cNomRel) //Chamada do Spool de Impressao
Endif

MS_FLUSH() //Libera fila de relatorios em spool

retindex( "SF2" )
retindex( "SD2" )
retindex( "SB1" )

Return


***************************************
Static Function Carteira( lDia, nTipo )
***************************************

//nTipo = 1 Carteira Programada
//nTipo = 2 Carteira Pronta para Faturar
Local aArret := {}
Default nTipo := 0

//cCart := "SELECT SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) / SB1.B1_CONV) AS CARTEIRA_KG, SUM((SC6.C6_QTDVEN - SC6.C6_QTDENT) * SC6.C6_PRUNIT) AS CARTEIRA_RS, min(SC5.C5_ENTREG) AS DAT "
cCart := "SELECT SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) * SB1.B1_PESO) AS CARTEIRA_KG, SUM((SC6.C6_QTDVEN - SC6.C6_QTDENT) * SC6.C6_PRUNIT) AS CARTEIRA_RS, min(SC5.C5_ENTREG) AS DAT "
cCart += "FROM " + RetSqlName( "SB1" ) + " SB1, " + RetSqlName( "SC5" ) + " SC5, " + RetSqlName( "SC6" )+ " SC6, " + RetSqlName( "SC9" )+ " SC9, "
//cCart += "" + RetSqlName( "SA1" ) + " SA1 "
cCart += "" + RetSqlName( "SA1" ) + " SA1 " //+ RetSqlName( "SF4" ) + " SF4 " "
cCart += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cCart += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
cCart += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
//cCart += "SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND "
// NOVA LIBERACAO DE CRETIDO
cCart += "SC9.C9_BLCRED IN( '  ','04') and SC9.C9_BLEST != '10' AND "
//cCart += "SC9.C9_NFISCAL = '' AND "
cCart += "SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
cCart += "SC6.C6_TES NOT IN( '540','516') AND "//Remessa MIXKIT, AMOSTRA
cCart += "SB1.B1_SETOR!= '39' AND "//Diferente Caixa
//cCart += " C6_TES = F4_CODIGO "
//cCart += " F4_DUPLIC = 'S'   AND "
If !empty(MV_PAR11)  	//Representante
    cCart += "SC5.C5_VEND1 in ('"+MV_PAR11+"','"+alltrim(MV_PAR11) +"VD'"+") AND "

elseif !empty(MV_PAR12)	//Coordenador
   cCart += " EXISTS( SELECT A3_SUPER "
   cCart += "          FROM "+RetSqlName("SA3")+" "
   cCart += "          WHERE A3_COD = SC5.C5_VEND1 AND ( A3_SUPER = '"+MV_PAR12+"' OR SC5.C5_VEND1 = '"+MV_PAR12+"' ) AND D_E_L_E_T_ = '' ) AND "

elseif !empty(MV_PAR13)	//Gerente
   cCart += "SC5.C5_VEND1 in (SELECT A3_COD FROM SA3010 SA3 "
   cCart += "WHERE A3_SUPER IN ( SELECT A3_COD FROM SA3010 SA3 WHERE A3_GEREN ='"+MV_PAR13+"'  and SA3.D_E_L_E_T_ != '*' )  "
   cCart += "and SA3.D_E_L_E_T_ != '*' ) AND "
Endif

if MV_PAR07 = 1 //Linha Hospitalar
   cCart += "SB1.B1_GRUPO IN ('C') AND "
elseif MV_PAR07 = 2 //Linha Dom
   cCart += "SB1.B1_GRUPO IN ('D','E') AND "
elseif MV_PAR07 = 3
   cCart += "SB1.B1_GRUPO IN ('A','B','F','G') AND "
elseif MV_PAR07 = 5
   cCart += "SB1.B1_GRUPO IN ('A','B','D','E','F','G') AND "   
endif
if !empty(MV_PAR08) .and. empty(MV_PAR09)
	cCart += "SA1.A1_EST = '"+MV_PAR08+"' AND "
elseIf empty(MV_PAR08) .and. !empty(MV_PAR09)
	cCart += "SA1.A1_EST != '"+MV_PAR09+"' AND "
elseIf !empty(MV_PAR08) .and. !empty(MV_PAR09)
	cCart += "SA1.A1_EST = '"+MV_PAR08+"' AND SA1.A1_EST != '"+MV_PAR09+"' AND "
endIf
if nTipo = 1
  cCart += "SC5.C5_ENTREG > '"+ dtos( lastday( dDataBase ) + 1 ) + "' and "
elseif nTipo = 2     
  cCart += "SC5.C5_ENTREG <= '"+ dtos( lastday( dDataBase ) ) + "' and "
endif
if lDia
  cCart += "SC5.C5_EMISSAO = '"+dtos(dDataBase)+"' and "
endIf
cCart += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' AND "
cCart += "SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' AND SC5.D_E_L_E_T_ = ' ' AND "
cCart += "SC6.C6_FILIAL = '" + xFilial( "SC6" ) + "' AND SC6.D_E_L_E_T_ = ' ' AND "
cCart += "SC9.C9_FILIAL = '" + xFilial( "SC9" ) + "' AND SC9.D_E_L_E_T_ = ' ' AND "
cCart += "SA1.A1_FILIAL = '" + xFilial( "SA1" ) + "' AND SA1.D_E_L_E_T_ = ' ' "
//cCart += "SF4.F4_FILIAL = '" + xFilial( "SF4" ) + "' AND SF4.D_E_L_E_T_ = ' ' 
cCart := ChangeQuery( cCart ) 
//MemoWrite("C:\Temp\carteira.sql",cCart)
TCQUERY cCart NEW ALIAS "CARX"
TCSetField('CARX',"DAT","D")



CARX->( DbGoTop() )
While CARX->(!EOF())
	if lDia
	  aAdd( aArret, { CARX->CARTEIRA_KG, CARX->CARTEIRA_RS } )
	else
	  //So pego a Data do pedido mais antigo se for para carteira imediata
	  if nTipo = 2
	     dDatMax := CARX->DAT
	  endif   
	  nCartKG := CARX->CARTEIRA_KG
	  nCartRS := CARX->CARTEIRA_RS
	endIf
	CARX->(Dbskip())
Enddo

DbSelectArea("CARX")
DbCloseArea()


Return iif(lDia,aArret,)


*****************************
Static Function calcAcs(cCod)
*****************************

Local cQuery := ''          //M.O.D.
nTotal := 0
If substring(cCod,1,1) == 'C'
	If Len( AllTrim( cCod ) ) >= 8
		cCod := U_transgen(cCod)
	EndIf

	cQuery := "select	SG1.G1_COD,SG1.G1_COMP,SG1.G1_QUANT, SB1.B1_UPRC, "
	cQuery += "(select	top 1 SD1.D1_VUNIT "
	cQuery += " from	" + RetSqlName('SD1') + " SD1 "
	                                                                      //Desprezar notas de Beneficiamento
	cQuery += " where	SG1.G1_COMP = SD1.D1_COD and SD1.D1_TIPO = 'N' and SD1.D1_CF NOT IN ('1919','2919') AND SD1.D_E_L_E_T_ != '*' "
	cQuery += "	order by SD1.D1_DTDIGIT desc) as D1_VUNIT "
	cQuery += "from " + RetSqlName("SG1") + " SG1, " + RetSqlName("SB1") + " SB1 "
	cQuery += "where SG1.G1_COD = '" + alltrim(cCod) + "' and "      //fita hamper ME0807,  CAAA003, CAE003,  CAF003,  CAD003
	cQuery += "(substring(SG1.G1_COMP,1,2) in ('AC','MH','ST') or SG1.G1_COMP in ('ME0106','ME0104','ME0212','ME0213','ME0807')) "
	cQuery += "and SB1.B1_COD = SG1.G1_COMP and SB1.B1_ATIVO = 'S' "
	cQuery += "and SB1.B1_SETOR != '39' " // Diferente Caixa 
	cQuery += "and SG1.G1_FILIAL = '" + xFilial("SG1") + "' and SG1.D_E_L_E_T_ != '*' "
	cQuery += "and SB1.B1_FILIAL = '" + xFilial("SB1") + "' and SB1.D_E_L_E_T_ != '*' "
	cQuery := ChangeQUery(cQuery)
	TCQUERY cQUery NEW ALIAS "TMP"
	TMP->( DbGoTop() )
	
	Do while ! TMP->( EoF() )
  	   if TMP->G1_COD <> 'CTG011' .and. TMP->G1_COMP <> 'AC0003'
	 	      nTotal += TMP->G1_QUANT * TMP->D1_VUNIT 
	   endIf
      TMP->( dbSkip() )
	EndDo
Else
	Alert("Produto nao e hospitalar.")
	return Nil
EndIf

TMP->( DbCloseArea() )

return nTotal


************************
Static Function  media()
************************

local cQuery := ''
Local nDias := nDif := nCount := 0

cQuery := "SELECT distinct SC5.C5_NUM, SC5.C5_ENTREG "
cQuery += "FROM " + RetSqlName( "SB1" ) + " SB1, " + RetSqlName( "SC5" ) + " SC5, " + RetSqlName( "SC6" )+ " SC6, " + RetSqlName( "SC9" )+ " SC9, "
cQuery += " " + RetSqlName( "SA1" )+ " SA1 "
cQuery += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
cQuery += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "

// SO CONSIDERAR O QUE FOI LIBERADO 
//cQuery += "SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND "
// NOVA LIBERACAO DE CRETIDO
cQuery += "SC9.C9_BLCRED IN( '  ','04') and SC9.C9_BLEST != '10' AND "

cQuery += "SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
cQuery += "SC6.C6_TES NOT IN( '540','516') AND "//Remessa MIXKIT,AMOSTRA
cQuery += "SB1.B1_SETOR != '39' AND " // Diferente Caixa 
If !empty(MV_PAR11)
    cQuery += "SC5.C5_VEND1 in ('"+MV_PAR11+"','"+alltrim(MV_PAR11) +"VD'"+") AND "
elseif !empty(MV_PAR12)//Coordenador
   cQuery += " EXISTS( SELECT A3_SUPER "
   cQuery += "          FROM "+RetSqlName("SA3")+" "
   cQuery += "          WHERE A3_COD = SC5.C5_VEND1 AND A3_SUPER = '"+MV_PAR12+"' AND D_E_L_E_T_ = '' ) AND "
elseif !empty(MV_PAR13)//Gerente
   cQuery += "SC5.C5_VEND1 in (SELECT A3_COD FROM SA3010 SA3 "
   cQuery += "WHERE A3_SUPER IN ( SELECT A3_COD FROM SA3010 SA3 WHERE A3_GEREN ='"+MV_PAR13+"'  and SA3.D_E_L_E_T_ != '*' )  "
   cQuery += "and SA3.D_E_L_E_T_ != '*' ) AND "
Endif
if MV_PAR07 = 1 //Linha Hospitalar
   cQuery += "SB1.B1_GRUPO IN ('C') AND "
elseif MV_PAR07 = 2 //Linha Dom/Inst
   cQuery += "SB1.B1_GRUPO IN ('D','E') AND "
elseif MV_PAR07 = 3
   cQuery += "SB1.B1_GRUPO IN ('A','B','F','G') AND "
elseif MV_PAR07 = 5
   cQuery += "SB1.B1_GRUPO IN ('A','B','D','E','F','G') AND "      
endif
if !empty(MV_PAR08) .and. empty(MV_PAR09)
	cQuery += "SA1.A1_EST = '"+MV_PAR08+"' AND "
elseIf empty(MV_PAR08) .and. !empty(MV_PAR09)
	cQuery += "SA1.A1_EST != '"+MV_PAR09+"' AND "
elseIf !empty(MV_PAR08) .and. !empty(MV_PAR09)
	cQuery += "SA1.A1_EST = '"+MV_PAR08+"' AND SA1.A1_EST != '"+MV_PAR09+"' AND "
endIf
cQuery += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' AND "
cQuery += "SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' AND SC5.D_E_L_E_T_ = ' ' AND "
cQuery += "SC6.C6_FILIAL = '" + xFilial( "SC6" ) + "' AND SC6.D_E_L_E_T_ = ' ' AND "
cQuery += "SC9.C9_FILIAL = '" + xFilial( "SC9" ) + "' AND SC9.D_E_L_E_T_ = ' ' AND "
cQuery += "SA1.A1_FILIAL = '" + xFilial( "SA1" ) + "' AND SA1.D_E_L_E_T_ = ' ' "
cQuery += "order by SC5.C5_NUM "
TCQUERY cQuery NEW ALIAS 'TMP'
TCSetField( 'TMP', 'C5_ENTREG', 'D' )
TMP->( dbGoTop() )

do while  ! TMP->( EoF() )
	nDias := dDataBase - TMP->C5_ENTREG	
	if nDias >= 0
	   	nDif += nDias
	   	nCount++
	endIf
	TMP->( dbSkip() )
endDo                                                          	

TMP->( dbCloseArea() )

return iif( nCount == 0, 0, nDif/nCount )

*********************************
Static Function  limpBras( cCod )
*********************************
// se o produto for dona limpeza ou brasileirinho, incluir sacos-capa como acessorios!
Local cQuery
Local nTotal := 0
Local cAlias
Local aArea := getArea()
cAlias := iif( substr( alias(), 1, 4 ) == 'TMPX', soma1(alias()), 'TMPX1')

If Len( AllTrim( cCod ) ) >= 8
	cCod := U_transgen(cCod)
EndIf
cQuery := "select	SG1.G1_COD,SG1.G1_COMP,SG1.G1_QUANT, SB1.B1_UPRC, "
cQuery += " (select	top 1 SD1.D1_VUNIT "
cQuery += " from	" + RetSqlName('SD1') + " SD1 "
cQuery += " where	SG1.G1_COMP = SD1.D1_COD and SD1.D1_TIPO = 'N' and SD1.D_E_L_E_T_ != '*' "
cQuery += " order by SD1.D1_DTDIGIT desc) as D1_VUNIT "
cQuery += "from " + RetSqlName("SG1") + " SG1, " + RetSqlName("SB1") + " SB1 "
cQuery += "where 	SG1.G1_COD = '" + alltrim(cCod) + "' "
if substr(cCod,1,1) $ 'E /D'
  cQuery += "and substring(SG1.G1_COMP,1,2) in ('ME') "  //apenas sacos-capa
endIf
cQuery += "and  SB1.B1_COD = SG1.G1_COMP and SB1.B1_ATIVO = 'S' "
cQuery += "and SB1.B1_SETOR != '39' " // Diferente Caixa 
cQuery += "and SG1.G1_FILIAL = '" + xFilial("SG1") + "' and SG1.D_E_L_E_T_ != '*' "
cQuery += "and SB1.B1_FILIAL = '" + xFilial("SB1") + "' and SB1.D_E_L_E_T_ != '*' "
cQuery := ChangeQUery(cQuery)
TCQUERY cQUery NEW ALIAS (cAlias)
(cAlias)->( DbGoTop() )

Do while ! (cAlias)->( EoF() )
  if (cAlias)->G1_COMP >= 'ME0700' .and. (cAlias)->G1_COMP <= 'ME0799' //ME comprado, não é fabricado internamente
    nTotal += (cAlias)->G1_QUANT * (cAlias)->D1_VUNIT
  elseIf substr(alltrim( (cAlias)->G1_COMP ),1,2 ) == 'MP'
    nTotal += (cAlias)->G1_QUANT * (cAlias)->D1_VUNIT
  elseIf substr(alltrim( (cAlias)->G1_COMP ),1,2 ) == 'PI'
  	 nTotal += (cAlias)->G1_QUANT * limpBras( (cAlias)->G1_COMP ) / 100
  elseIf substr(alltrim( (cAlias)->G1_COMP ),1,2 ) == 'ME'
  	 nTotal += (cAlias)->G1_QUANT * limpBras( (cAlias)->G1_COMP )
  endIf
  (cAlias)->( DbSkip() )
EndDo

(cAlias)->( DbCloseArea() )
restArea( aArea )

Return nTotal


**************************************
Static Function acsCart( lDia, nTipo )
**************************************

//nTipo = 1 Carteira Programada
//nTipo = 2 Carteira Pronta para Faturar

Local cQuery  := ''
Local nTot := 0

Default nTipo := 0

cQuery += "SELECT C5_NUM, B1_COD, ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) AS QTDVEN "
cQuery += "FROM "+retSqlName('SB1')+" SB1, "+retSqlName('SC5')+" SC5, "+retSqlName('SC6')+" SC6, "+retSqlName('SC9')+" SC9, "
cQuery += " "+retSqlName('SA1')+" SA1 "
cQuery += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
cQuery += "SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
cQuery += "SC6.C6_TES NOT IN( '540','516') AND "//Remessa MIXKIT,AMOSTRA
cQuery += "SB1.B1_SETOR != '39'AND " // Diferente Caixa 
If !empty(MV_PAR11)
    cQuery += "SC5.C5_VEND1 in ('"+MV_PAR11+"','"+alltrim(MV_PAR11) +"VD'"+") AND "
elseif !empty(MV_PAR12)//Coordenador
   cQuery += " EXISTS( SELECT A3_SUPER "
   cQuery += "          FROM "+RetSqlName("SA3")+" "
   cQuery += "          WHERE A3_COD = SC5.C5_VEND1 AND A3_SUPER = '"+MV_PAR12+"' AND D_E_L_E_T_ = '' ) AND "
elseif !empty(MV_PAR13)//Gerente
   cQuery += "SC5.C5_VEND1 in (SELECT A3_COD FROM SA3010 SA3 "
   cQuery += "WHERE A3_SUPER IN ( SELECT A3_COD FROM SA3010 SA3 WHERE A3_GEREN ='"+MV_PAR13+"'  and SA3.D_E_L_E_T_ != '*' )  "
   cQuery += "and SA3.D_E_L_E_T_ != '*' ) AND "
Endif
if lDia
  cQuery += "SC5.C5_EMISSAO = '"+dtos(dDataBase)+"' and "
endIf
if MV_PAR07 = 1 //Linha Hospitalar
   cQuery += "SB1.B1_GRUPO IN ('C') AND "
elseif MV_PAR07 = 2 //Linha Dom/Inst
   cQuery += "SB1.B1_GRUPO IN ('D','E') AND "
elseif MV_PAR07 = 3
   cQuery += "SB1.B1_GRUPO IN ('A','B','F','G') AND "
elseif MV_PAR07 = 5
   cQuery += "SB1.B1_GRUPO IN ('A','B','D','E','F','G') AND "         
endif   
if !empty(MV_PAR08) .and. empty(MV_PAR09)
	cQuery += "SA1.A1_EST = '"+MV_PAR08+"' AND "
elseIf empty(MV_PAR08) .and. !empty(MV_PAR09)
	cQuery += "SA1.A1_EST != '"+MV_PAR09+"' AND "
elseIf !empty(MV_PAR08) .and. !empty(MV_PAR09)
	cQuery += "SA1.A1_EST = '"+MV_PAR08+"' AND SA1.A1_EST != '"+MV_PAR09+"' AND "
endIf
if nTipo = 1
  cQuery += "SC5.C5_ENTREG > '"+ dtos( lastday( dDataBase ) + 1 ) + "' and "
elseif nTipo = 2
  cQuery += "SC5.C5_ENTREG <= '"+ dtos( lastday( dDataBase ) ) + "' and "
endif
cQuery += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
//cQuery += "SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND substring(B1_COD, 1, 1) in ('C','D','E') AND "
// NOVA LIBERACAO DE CRETIDO
cQuery += "SC9.C9_BLCRED IN( '  ','04') and SC9.C9_BLEST != '10' AND substring(B1_COD, 1, 1) in ('C','D','E') AND "
cQuery += "SB1.D_E_L_E_T_ = ' ' AND SC5.D_E_L_E_T_ = ' ' AND SC6.D_E_L_E_T_ = ' ' AND SC9.D_E_L_E_T_ = ' ' AND SA1.D_E_L_E_T_ = ' ' "
cQuery += "order by C5_NUM "
cQuery := ChangeQuery(cQuery)

TCQUERY cQuery NEW ALIAS 'TMPX'
TMPX->( dbGoTop() )

do while ! TMPX->( EoF() )
   if substr( TMPX->B1_COD, 1, 1) $ "C"
      nTot += calcAcs( TMPX->B1_COD ) * TMPX->QTDVEN
   else
      nTot += limpBras( TMPX->B1_COD )	* TMPX->QTDVEN
   endIf
   TMPX->( dbSkip() )
endDo

TMPX->( dbCloseArea() )

Return nTot


*************************
Static Function PediDia()
*************************
//Atualizado para filtrar estados
local cQuery := ''
local aArret := {}

cQuery += "select sum(C6_QTDVEN * C6_PRUNIT) CARTEIRA_RS, SUM( ( SC6.C6_QTDVEN ) / SB1.B1_CONV ) AS CARTEIRA_KG "
cQuery += "from   "+retSqlName('SC5')+" SC5, "+retSqlName('SC6')+" SC6, "+RetSqlName("SB1")+" SB1, "+RetSqlName("SA1")+" SA1, "+RetSqlName("SC9")+" SC9  "
//cQuery += "from   "+retSqlName('SC5')+" SC5, "+retSqlName('SC6')+" SC6, "+RetSqlName("SB1")+" SB1, "+RetSqlName("SA1")+" SA1 "
cQuery += "where  C5_FILIAL = '"+xFilial('SC5')+"' AND C6_FILIAL = '"+xFilial('SC6')+"' AND A1_FILIAL = '"+xFilial('SA1')+"' AND C9_FILIAL = '"+xFilial('SC9')+"' AND "
//cQuery += "where  C5_FILIAL = '"+xFilial('SC5')+"' AND C6_FILIAL = '"+xFilial('SC6')+"' AND A1_FILIAL = '"+xFilial('SA1')+"' AND  "
cQuery += "SC5.C5_EMISSAO = '"+dtos(dDataBase)+"' AND SC5.C5_NUM = SC6.C6_NUM AND SC6.C6_PRODUTO = SB1.B1_COD AND "
cQuery += "SB1.B1_TIPO = 'PA' AND "
cQuery += "SC6.C6_TES NOT IN( '540','516') AND "//Remessa MIXKIT,AMOSTRA
cQuery += "SB1.B1_SETOR != '39' AND " // Diferente Caixa 
cQuery += "SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "

// SO CONSIDERAR O QUE FOI LIBERADO 

cQuery += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND " 
//cQuery += "SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND " 
// NOVA LIBERACAO DE CREDITO
cQuery += "SC9.C9_BLCRED IN( '  ','04') and SC9.C9_BLEST != '10' AND " 

If !empty(MV_PAR11)
    cQuery += "SC5.C5_VEND1 in ('"+MV_PAR11+"','"+alltrim(MV_PAR11) +"VD'"+") AND "
elseif !empty(MV_PAR12)//Coordenador
   cQuery += " EXISTS( SELECT A3_SUPER "
   cQuery += "          FROM "+RetSqlName("SA3")+" "
   cQuery += "          WHERE A3_COD = SC5.C5_VEND1 AND A3_SUPER = '"+MV_PAR12+"' AND D_E_L_E_T_ = '' ) AND "
elseif !empty(MV_PAR13)//Gerente
   cQuery += "SC5.C5_VEND1 in (SELECT A3_COD FROM SA3010 SA3 "
   cQuery += "WHERE A3_SUPER IN ( SELECT A3_COD FROM SA3010 SA3 WHERE A3_GEREN ='"+MV_PAR13+"'  and SA3.D_E_L_E_T_ != '*' )  "
   cQuery += "and SA3.D_E_L_E_T_ != '*' ) AND "
Endif
if MV_PAR07 = 1 //Linha Hospitalar
   cQuery += "SB1.B1_GRUPO IN ('C') AND "
elseif MV_PAR07 = 2 //Linha Dom/Inst
   cQuery += "SB1.B1_GRUPO IN ('D','E') AND "
elseif MV_PAR07 = 3
   cQuery += "SB1.B1_GRUPO IN ('A','B','F','G') AND "
elseif MV_PAR07 = 5
   cQuery += "SB1.B1_GRUPO IN ('A','B','D','E','F','G') AND "         
endif   
if !empty(MV_PAR08) .and. empty(MV_PAR09)
	cQuery += "SA1.A1_EST = '"+MV_PAR08+"' AND "
elseIf empty(MV_PAR08) .and. !empty(MV_PAR09)
	cQuery += "SA1.A1_EST != '"+MV_PAR09+"' AND "
elseIf !empty(MV_PAR08) .and. !empty(MV_PAR09)
	cQuery += "SA1.A1_EST = '"+MV_PAR08+"' AND SA1.A1_EST != '"+MV_PAR09+"' AND "
endIf

cQuery += "SC5.D_E_L_E_T_ != '*' and	SC6.D_E_L_E_T_ != '*' and	SB1.D_E_L_E_T_ != '*' and SA1.D_E_L_E_T_ != '*' and  SC9.D_E_L_E_T_ != '*'  "
//cQuery += "SC5.D_E_L_E_T_ != '*' and	SC6.D_E_L_E_T_ != '*' and	SB1.D_E_L_E_T_ != '*' and SA1.D_E_L_E_T_ != '*'   "
TCQUERY cQuery NEW ALIAS 'TMPP'
TMPP->( dbGoTop() )

if ! TMPP->( EoF() )
	aAdd( aArret, { TMPP->CARTEIRA_KG, TMPP->CARTEIRA_RS } )
endIf
TMPP->( dbCloseArea() )

Return aArret

**************************
Static Function acsPDia( )
**************************
//Atualizado para filtrar estados
Local cQuery  := ''
Local nTot := 0

cQuery += "select C6_PRODUTO "
cQuery += "from   "+retSqlName('SC5')+" SC5, "+retSqlName('SC6')+" SC6, "+RetSqlName("SB1")+" SB1, "+RetSqlName("SA1")+" SA1, "+RetSqlName("SC9")+" SC9 "
//cQuery += "from   "+retSqlName('SC5')+" SC5, "+retSqlName('SC6')+" SC6, "+RetSqlName("SB1")+" SB1, "+RetSqlName("SA1")+" SA1 "
cQuery += "where  C5_FILIAL = '"+xFilial('SC5')+"' AND C6_FILIAL = '"+xFilial('SC6')+"' AND A1_FILIAL = '"+xFilial('SA1')+"' AND C9_FILIAL = '"+xFilial('SC9')+"' AND "
//cQuery += "where  C5_FILIAL = '"+xFilial('SC5')+"' AND C6_FILIAL = '"+xFilial('SC6')+"' AND A1_FILIAL = '"+xFilial('SA1')+"' AND  "
cQuery += "C5_EMISSAO = '"+dtos(dDataBase)+"' AND SC5.C5_NUM = SC6.C6_NUM AND C5_TIPO = 'N' AND "
cquery += "SC6.C6_PRODUTO = SB1.B1_COD AND "
cQuery += "SC6.C6_TES NOT IN( '540','516') AND "//Remessa MIXKIT,AMOSTRA
cQuery += "SB1.B1_SETOR != '39' AND " // Diferente Caixa 

// SO CONSIDERAR O QUE FOI LIBERADO 

cQuery += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND " 
//cQuery += "SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND " 
// NOVA LIBERACAO DE CRETIDO
cQuery += "SC9.C9_BLCRED IN( '  ','04') and SC9.C9_BLEST != '10' AND " 
If !empty(MV_PAR11)
    cQuery += "SC5.C5_VEND1 in ('"+MV_PAR11+"','"+alltrim(MV_PAR11) +"VD'"+") AND "
elseif !empty(MV_PAR12)//Coordenador
   cQuery += " EXISTS( SELECT A3_SUPER "
   cQuery += "          FROM "+RetSqlName("SA3")+" "
   cQuery += "          WHERE A3_COD = SC5.C5_VEND1 AND A3_SUPER = '"+MV_PAR12+"' AND D_E_L_E_T_ = '' ) AND "
elseif !empty(MV_PAR13)//Gerente
   cQuery += "SC5.C5_VEND1 in (SELECT A3_COD FROM SA3010 SA3 "
   cQuery += "WHERE A3_SUPER IN ( SELECT A3_COD FROM SA3010 SA3 WHERE A3_GEREN ='"+MV_PAR13+"'  and SA3.D_E_L_E_T_ != '*' )  "
   cQuery += "and SA3.D_E_L_E_T_ != '*' ) AND "
Endif
cQuery += "substring(C6_PRODUTO, 1, 1) in ('C','D','E') AND "
cQuery += "SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
if MV_PAR07 = 1 //Linha Hospitalar
   cQuery += "SB1.B1_GRUPO IN ('C') AND "
elseif MV_PAR07 = 2 //Linha Dom/Inst
   cQuery += "SB1.B1_GRUPO IN ('D','E') AND "
elseif MV_PAR07 = 3
   cQuery += "SB1.B1_GRUPO IN ('A','B','F','G') AND "
elseif MV_PAR07 = 5
   cQuery += "SB1.B1_GRUPO IN ('A','B','D','E','F','G') AND "         
endif   
if !empty(MV_PAR08) .and. empty(MV_PAR09)
	cQuery += "SA1.A1_EST = '"+MV_PAR08+"' AND "
elseIf empty(MV_PAR08) .and. !empty(MV_PAR09)
	cQuery += "SA1.A1_EST != '"+MV_PAR09+"' AND "
elseIf !empty(MV_PAR08) .and. !empty(MV_PAR09)
	cQuery += "SA1.A1_EST = '"+MV_PAR08+"' AND SA1.A1_EST != '"+MV_PAR09+"' AND "
endIf
cQuery += "SC5.D_E_L_E_T_ != '*' and	SC6.D_E_L_E_T_ != '*' and	SB1.D_E_L_E_T_ != '*' and SA1.D_E_L_E_T_ != '*' and SC9.D_E_L_E_T_ != '*' "
//cQuery += "SC5.D_E_L_E_T_ != '*' and	SC6.D_E_L_E_T_ != '*' and	SB1.D_E_L_E_T_ != '*' and SA1.D_E_L_E_T_ != '*'  "
TCQUERY cQuery NEW ALIAS 'TMPX'
TMPX->( dbGoTop() )

do while ! TMPX->( EoF() )
	if substr( TMPX->C6_PRODUTO, 1, 1) $ "C"
	  nTot += calcAcs( TMPX->C6_PRODUTO )	
	else
	  nTot += limpBras( TMPX->C6_PRODUTO )	
	endIf
	TMPX->( dbSkip() )
endDo

TMPX->( dbCloseArea() )

Return nTot

***********************
Static function GetPrzM()
***********************
local nPrz := 0
local cVal := ""
local nVal := 0
Local nPar := 1

DbSelectArea("SE4")
DbSetOrder(1)
SE4->(DbSeek(xFilial("SE4")+FATP->F2_COND))
/*
for nX := 1 to Len(Alltrim(SE4->E4_COND))
   if Substr(Alltrim(SE4->E4_COND),nX,1)==","
      nVal += Val(cVal)
      cVal := ""
      nPar ++    
   else
      cVal += Substr(Alltrim(SE4->E4_COND),nX,1)
   endif
next nX
if cVal <> ""
   nVal += Val(cVal)
endif
nPrz := NoRound((nVal/nPar),0)
*/
nPrz := NoRound(SE4->E4_PRZMED,0)
return nPrz

**************************
Static Function bonifica()
**************************
Local cQuery := ""
Local aRet   := {0,0}
cQuery += "select sum(D2_TOTAL) TOTAL_RS, sum(D2_QUANT * D2_PESO) TOTAL_KG "
cQuery += "from "+retSqlName('SD2')+" SD2, "+retSqlName('SB1')+" SB1, "+retSqlName('SA1')+" SA1, "+retSqlName('SC5')+" SC5 "
cQuery += "where SD2.D2_TES = '514' and month(D2_EMISSAO) = '"+strZero(month(dDataBase),2)+"' and year(D2_EMISSAO) = '"+strZero(year(dDataBase),4)+"' "
cQuery += "and SD2.D2_COD = SB1.B1_COD and D2_PEDIDO = C5_NUM AND "
cQuery += "SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
cQuery += "D2_FILIAL = '"+xFilial('SD2')+"' and B1_FILIAL = '"+xFilial('SB1')+"' and C5_FILIAL = '"+xFilial('SC5')+"' and A1_FILIAL = '"+xFilial('SA1')+"' and "
cQuery += "SB1.B1_SETOR != '39' AND " // Diferente Caixa 
If !empty(MV_PAR11)
    cQuery += "SC5.C5_VEND1 in ('"+MV_PAR11+"','"+alltrim(MV_PAR11) +"VD'"+") AND "
elseif !empty(MV_PAR12)//Coordenador
   cQuery += " EXISTS( SELECT A3_SUPER "
   cQuery += "          FROM "+RetSqlName("SA3")+" "
   cQuery += "          WHERE A3_COD = SC5.C5_VEND1 AND A3_SUPER = '"+MV_PAR12+"' AND D_E_L_E_T_ = '' ) AND "
elseif !empty(MV_PAR13)//Gerente
   cQuery += "SC5.C5_VEND1 in (SELECT A3_COD FROM SA3010 SA3 "
   cQuery += "WHERE A3_SUPER IN ( SELECT A3_COD FROM SA3010 SA3 WHERE A3_GEREN ='"+MV_PAR13+"'  and SA3.D_E_L_E_T_ != '*' )  "
   cQuery += "and SA3.D_E_L_E_T_ != '*' ) AND "
Endif
if MV_PAR07 = 1 //Linha Hospitalar
	cQuery += "SB1.B1_GRUPO IN ('C') AND "
elseif MV_PAR07 = 2 //Linha Dom/Inst
	cQuery += "SB1.B1_GRUPO IN ('D','E') AND "
elseif MV_PAR07 = 3
	cQuery += "SB1.B1_GRUPO IN ('A','B','F','G') AND "
elseif MV_PAR07 = 5
	cQuery += "SB1.B1_GRUPO IN ('A','B','D','E','F','G') AND "
endif
if !empty(MV_PAR08) .and. empty(MV_PAR09)
	cQuery += "SA1.A1_EST = '"+MV_PAR08+"' AND "
elseIf empty(MV_PAR08) .and. !empty(MV_PAR09)
	cQuery += "SA1.A1_EST != '"+MV_PAR09+"' AND "
elseIf !empty(MV_PAR08) .and. !empty(MV_PAR09)
	cQuery += "SA1.A1_EST = '"+MV_PAR08+"' AND SA1.A1_EST != '"+MV_PAR09+"' AND "
endIf
cQuery += "SD2.D_E_L_E_T_ != '*' and SB1.D_E_L_E_T_ != '*' and SC5.D_E_L_E_T_ != '*' and SA1.D_E_L_E_T_ != '*' "
TCQUERY cQuery NEW ALIAS "_TMPK"
_TMPK->( dbGoTop() )
if _TMPK->( !EoF() )
	aRet[1]+= _TMPK->TOTAL_RS
	aRet[2]+= _TMPK->TOTAL_KG
endIf
_TMPK->( dbCloseArea() )
Return aRet

************************
Static Function pddMes( dDataIni, dDataFim )
************************

Local cQuery := ""
Local nVal := 0   
Local LF := CHR(13) + CHR(10)
Local nMesExec := 0
Local dVend1
Local dVend2
Local dExecucao

//cQuery += "select ROUND(sum(C6_VALOR),2) TOTALRS, ROUND(sum(C6_QTDVEN * B1_PESOR),2) TOTALKG " + LF
cQuery += "select ROUND(sum(C6_VALOR),2) TOTALRS, ROUND(sum(C6_QTDVEN * B1_PESO),2) TOTALKG " + LF
cQuery += "from "+retSqlName('SC6')+" SC6, " + LF
cQuery += "" +retSqlName('SC5')+" SC5, " + LF
cQuery += "" +retSqlName('SB1')+" SB1, " + LF
cQuery += "" +retSqlName('SA1')+" SA1, "  + LF
cQuery += "" +retSqlName('SF4')+" SF4,  " + LF
cQuery += "" +retSqlName('SA3')+" SA3,  " + LF
cQuery += "" +retSqlName('SC9')+" SC9  " + LF

dExecucao := Ctod(dTExec)
nMesExec := Month(dExecucao)

If Substr(dTExec,1,2) = '01'  //se a execução for num dia 1o., retrocede ao mês anterior para capturar o mês cheio
	dVend1   := CtoD( '01/' + str((nMesExec - 1)) +'/'+Right(StrZero(Year(dDATABASE),4),2) )
	dVend2   := LastDay(dVend1) 
	
	cQuery += "where C5_EMISSAO between '" + dtos(dVend1)+"' and '" + dtos(dVend2)+ "' "
Else
	cQuery += "where C5_EMISSAO between '"+dtos(FirstDay(dDatabase))+"' and '"+dtos(LastDay(dDataBase))+"' " + LF
Endif



cQuery += "and C6_PRODUTO = B1_COD and C6_NUM = C5_NUM and C5_TIPO = 'N' " + LF
cQuery += "AND B1_TIPO != 'AP' "  + LF //Despreza Apara
cQuery += "and F4_DUPLIC = 'S' and C6_TES = F4_CODIGO " + LF
cQuery += "and SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND " + LF
cQuery += "SB1.B1_SETOR != '39' AND "  + LF // Diferente Caixa 
// SO CONSIDERAR O QUE FOI LIBERADO 

cQuery += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND " + LF
//cQuery += "SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND " + LF
// NOVA LIBERACAO DE CRETIDO
cQuery += "SC9.C9_BLCRED IN( '  ','04') and SC9.C9_BLEST != '10' AND " + LF

cQuery += " SC5.C5_VEND1 = SA3.A3_COD AND " + LF
//
If !empty(MV_PAR11)     //Representante
	//cQuery += " SC5.C5_VEND1 = SA3.A3_COD AND " + LF
    cQuery += "SC5.C5_VEND1 in ('"+ Alltrim(MV_PAR11) +"','"+alltrim(MV_PAR11) +"VD'"+") and " + LF

elseif !empty(MV_PAR12)//Coordenador
 
   //cQuery += "SA3.A3_COD = SC5.C5_VEND1  AND " + LF
   cQuery += "( A3_SUPER LIKE ('" + ALLTRIM(MV_PAR12) + "%' )  OR C5_VEND1 in ('"+ Alltrim(MV_PAR12)+"','"+ alltrim(MV_PAR12) +"VD'"+") ) AND " + LF

elseif !empty(MV_PAR13)//Gerente
	//cQuery += " SC5.C5_VEND1 = SA3.A3_COD and " + LF
    cQuery += " ( A3_SUPER IN ( SELECT A3_COD FROM "+RetSqlName("SA3")+" SA3 WHERE RTRIM(A3_GEREN) LIKE ('" + ALLTRIM(MV_PAR13) + "%' )  and SA3.D_E_L_E_T_ != '*' ) "+LF
	cQuery += " OR A3_GEREN LIKE ( '" + ALLTRIM(MV_PAR13) + "%' ) ) AND "+LF
Endif



if MV_PAR07 = 1 //Linha Hospitalar
	cQuery += "SB1.B1_GRUPO IN ('C') AND " + LF
elseif MV_PAR07 = 2 //Linha Dom/Inst
	cQuery += "SB1.B1_GRUPO IN ('D','E') AND " + LF
elseif MV_PAR07 = 3
	cQuery += "SB1.B1_GRUPO IN ('A','B','F','G') AND " + LF
elseif MV_PAR07 = 5
	cQuery += "SB1.B1_GRUPO IN ('A','B','D','E','F','G') AND " + LF
endif

if !empty(MV_PAR08) .and. empty(MV_PAR09)
	cQuery += "SA1.A1_EST = '"+MV_PAR08+"' AND " + LF

elseIf empty(MV_PAR08) .and. !empty(MV_PAR09)
	cQuery += "SA1.A1_EST != '"+MV_PAR09+"' AND " + LF

elseIf !empty(MV_PAR08) .and. !empty(MV_PAR09)
	cQuery += "SA1.A1_EST = '"+MV_PAR08+"' AND SA1.A1_EST != '"+MV_PAR09+"' and " + LF
endIf
cQuery += " C5_FILIAL = '"+xFilial('SC5')+"' " + LF
cQuery += " and C6_FILIAL = '"+xFilial('SC6')+"' " + LF
cQuery += " and B1_FILIAL = '"+xFilial('SB1')+"' " + LF
cQuery += " and A1_FILIAL = '"+xFilial('SA1')+"' " + LF
cQuery += " and C9_FILIAL = '"+xFilial('SC9')+"' " + LF
cQuery += " and SC6.D_E_L_E_T_ != '*' " + LF
cQuery += " and SC5.D_E_L_E_T_ != '*' " + LF
cQuery += " and SB1.D_E_L_E_T_ != '*' " + LF
cQuery += " and SF4.D_E_L_E_T_ != '*' " + LF
cQuery += " and SA1.D_E_L_E_T_ != '*' " + LF
cQuery += " and SA3.D_E_L_E_T_ != '*' " + LF
cQuery += " and SC9.D_E_L_E_T_ != '*' " + LF

MemoWrite("C:\Temp\Vendido.sql",cQuery)

TCQUERY cQuery NEW ALIAS '_TMPZA'
_TMPZA->( dbGoTop() )
do while !_TMPZA->(EoF())
	nVal := iif( mv_par04 == 1, _TMPZA->TOTALRS, _TMPZA->TOTALKG )
	_TMPZA->( dbSkip() )
endDo
_TMPZA->( dbCloseArea() )

Return nVal


***************************
Static Function meta(cVend)
***************************
Local nRet   := 0
Local cQuery := '' 
Local LF      	:= CHR(13)+CHR(10) 


cQuery :="select  SUM(Z7_VALOR) Z7_VALOR,SUM(Z7_KILO) Z7_KILO "+LF  
cQuery +=" from "+retSqlName("SZ7")+" SZ7 ,"+retSqlName("SA3")+" SA3 "+LF
cQuery +=" where A3_COD = Z7_REPRESE  "+LF
cQuery +=" and RTRIM(Z7_REPRESE) = '" + Alltrim(cVend) + "'  "+LF
cQuery +=" and SZ7.D_E_L_E_T_ != '*' "+LF
cQuery +=" and Z7_TIPO ='SC' "+LF
cQuery +=" and SA3.D_E_L_E_T_ != '*' "+LF
cQuery +=" and substring(Z7_MESANO,1,2) = '"+MV_PAR01+"' "+LF
cQuery +=" and substring(Z7_MESANO,3,4) = '"+ StrZero(Year(dDATABASE),4)+"'  "+LF
//MemoWrite("\TempQry\METAR.SQL",cQuery)

TCQUERY cQuery NEW ALIAS '_TMPY'
_TMPY->( dbGoTop() )
if _TMPY->( !EoF() )
   If mv_par04 == 1  // Real
      nRet :=  _TMPY->Z7_VALOR 
   else
      nRet :=  _TMPY->Z7_KILO 
   endif
endIf
_TMPY->( dbCloseArea() )
Return nRet

     
****************************
Static Function Descon(cDoc)
****************************

Local nRet   := 0
Local cQuery := " "

cQuery := "SELECT SUM(E1_VALOR) E1_VALOR " 
cQuery += "FROM "+retSqlName("SF2")+" SF2,"+retSqlName("SE1")+" SE1 "
cQuery += "WHERE F2_DOC='"+cDoc+"' "
cQuery += "AND F2_FILIAL='"+xFilial('SF2')+"'  "
cQuery += "AND E1_FILIAL='"+xFilial('SE1')+"' "
cQuery += "AND F2_DOC=E1_NUM "
cQuery += "AND F2_SERIE=E1_PREFIXO "
cQuery += "AND F2_CLIENTE=E1_CLIENTE "
cQuery += "AND F2_LOJA=E1_LOJA  "
cQuery += "AND E1_TIPO='AB-' "
cQuery += "AND SF2.D_E_L_E_T_!='*'  "
cQuery += "AND SE1.D_E_L_E_T_!='*' 	"
TCQUERY cQuery NEW ALIAS '_AUUX'

_AUUX->( dbGoTop() )

if _AUUX->( !EoF() )
   nRet :=  _AUUX->E1_VALOR 
endIf

_AUUX->( dbCloseArea() )

Return nRet                                              


*************************
static function estsaco()
*************************

local cQuery 
local nEst

cQuery := "SELECT ISNULL(SUM(SB2.B2_QATU / SB1.B1_CONV),0) AS ESTOQUE "
cQuery += "FROM "+RetSqlName("SB2")+" SB2 WITH (NOLOCK), "
cQuery += RetSqlName("SB1")+" SB1 WITH (NOLOCK) "
cQuery += "WHERE SB2.B2_COD = SB1.B1_COD AND SB2.B2_LOCAL = '01'"
cQuery += "AND SB1.B1_ATIVO = 'S' AND SB1.B1_TIPO = 'PA' "
cQuery += "AND LEN(SB1.B1_COD) <= 7 "
cQuery += "AND SB1.B1_SETOR != '39' "
cQuery += "AND SB2.B2_FILIAL = "+ValToSql(xFilial("SB2"))+" AND SB2.D_E_L_E_T_ = '' "
cQuery += "AND SB1.B1_FILIAL = "+ValToSql(xFilial("SB1"))+" AND SB1.D_E_L_E_T_ = '' "

TCQUERY cQuery NEW ALIAS "B2X"

nEst := B2X->ESTOQUE

B2X->(DbCloseArea())

return nEst


***************

Static Function metaC(cSuper)

***************
Local nRet   := 0
Local cQuery := ""
Local LF      	:= CHR(13)+CHR(10) 

cQuery :="select  SUM(Z7_VALOR) Z7_VALOR,SUM(Z7_KILO) Z7_KILO "+LF  
cQuery +=" from "+retSqlName("SZ7")+" SZ7 ,"+retSqlName("SA3")+" SA3 "+LF
cQuery +=" where A3_COD = Z7_REPRESE  "+LF
cQuery +=" and RTRIM(Z7_REPRESE) = '" + Alltrim(cSuper) + "'  "+LF
//cQuery +="where RTRIM(A3_SUPER) = '" + Alltrim(cSuper) + "' "
cQuery +=" and SZ7.D_E_L_E_T_ != '*' "+LF
cQuery +=" and Z7_TIPO = 'SC' "+LF
cQuery +=" and SA3.D_E_L_E_T_ != '*' "+LF
cQuery +=" and substring(Z7_MESANO,1,2) = '" + MV_PAR01 + "' "+LF     //Mês
cQuery +=" and substring(Z7_MESANO,3,4) = '"+ StrZero(Year(dDATABASE),4)+"'  "+LF
//MemoWrite("C:\Temp\METAC.SQL",cQuery)
TCQUERY cQuery NEW ALIAS '_TMPY'

_TMPY->( dbGoTop() )
if ! EMPTY(_TMPY->Z7_VALOR)
   If mv_par04 == 1  // Real
      nRet :=  _TMPY->Z7_VALOR 
   else
      nRet :=  _TMPY->Z7_KILO 
   endif
endIf
_TMPY->( dbCloseArea() )

Return nRet


***************

Static Function metaG(cGeren)

***************
Local nRet   := 0
Local cQuery := "" 
Local LF      	:= CHR(13)+CHR(10) 

cQuery :="select SUM(Z7_VALOR) Z7_VALOR,SUM(Z7_KILO) Z7_KILO "+LF
cQuery +="from "+retSqlName("SZ7")+" SZ7 "+LF
cQuery +="where Z7_REPRESE IN ( SELECT A3_COD FROM SA3010 SA3 WHERE A3_GEREN ='"+cGeren+"'  and SA3.D_E_L_E_T_ != '*' ) "+LF
cQuery +="and SZ7.D_E_L_E_T_ != '*' "+LF
cQuery +="and Z7_TIPO ='SC' "+LF
cQuery +="and substring(Z7_MESANO,1,2) = '"+MV_PAR01+"' "+LF
cQuery +="and substring(Z7_MESANO,3,4) = '"+ StrZero(Year(dDATABASE),4)+"'  "+LF

//MemoWrite("\TempQry\METAG.SQL",cQuery)
TCQUERY cQuery NEW ALIAS '_TMPY'

_TMPY->( dbGoTop() )
if ! EMPTY(_TMPY->Z7_VALOR)
   If mv_par04 == 1  // Real
      nRet :=  _TMPY->Z7_VALOR 
   else
      nRet :=  _TMPY->Z7_KILO 
   endif
endIf
_TMPY->( dbCloseArea() )

Return nRet 

////Função para Cálculo de dias úteis dentro de um período
*********************************
Static Function DiasUteis( dDtIni, dDtFim )
*********************************

Local nDUtil := 0
Local dDtMov := dDtIni
Local dValida:= Ctod("  /  /    ") 

While dDtMov <= dDtFim
	
	If DataValida(dDtMov) = dDtMov
		nDUtil := nDUtil + 1
	Endif
		dDtMov := dDtMov + 1
EndDo
                  

Return(nDUtil) 


*********************************
Static Function Ultimodia( dDataIni, nMes )
*********************************

Local dDtFim := dDataIni
Local nDias  := 0

While Month(dDtFim) = nMes
	If Month(dDtFim) = nMes
		dDtFim := dDtFim + 1
	Endif
	//msgbox("Data fim: " + dtoc(dDtFim) )

EndDo

While Month(dDtFim) != nMes
		dDtFim := dDtFim - 1
Enddo
//msgbox("2o. Loop Data fim: " + dtoc(dDtFim) )                  

Return(dDtFim)

***************

Static Function FatMes(nOpc)

***************
local cQry:=''
Local nMesExec := 0
Local dVend1
Local dVend2
Local dExecucao
Local nRet:=0

cQry:="SELECT "
cQry+="FAT_KG=SUM(CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN 0  "
cQry+="ELSE D2_QUANT*D2_PESO END), "
cQry+="FAT_RS=SUM(D2_TOTAL) "
cQry+="FROM "+retSqlName("SD2")+" SD2 WITH (NOLOCK), "+retSqlName("SB1")+" SB1 WITH (NOLOCK), "+retSqlName("SF2")+" SF2 WITH (NOLOCK) "
cQry+=", "+retSqlName("SC5")+" SC5 WITH (NOLOCK),"+retSqlName("SA3")+" SA3,"+retSqlName("SA1")+" SA1, "+retSqlName("SF4")+" SF4 "
cQry+="WHERE "
cQry+="C5_FILIAL='"+XFILIAL('SC5')+"' "
cQry+="AND F2_FILIAL='"+XFILIAL('SF2')+"' "
cQry+="AND D2_FILIAL='"+XFILIAL('SD2')+"' "
cQry+="AND B1_FILIAL='"+XFILIAL('SB1')+"'  "
cQry+="AND A3_FILIAL='"+XFILIAL('SA3')+"' "
cQry+="AND A1_FILIAL='"+XFILIAL('SA1')+"' "
cQry+="AND F4_FILIAL='"+XFILIAL('SF4')+"' "
cQry+="AND D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA = F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA   "
cQry+="AND SA3.A3_COD = SC5.C5_VEND1  "
cQry+="AND D2_PEDIDO=C5_NUM "
cQry+="AND D2_COD = B1_COD  "
cQry+="and SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA "
cQry+="and D2_TES = F4_CODIGO and F4_DUPLIC = 'S' "

dExecucao := Ctod(dTExec)
nMesExec := Month(dExecucao)

If nOpc=1 // Faturado no Mes

	If Substr(dTExec,1,2) = '01'  //se a execução for num dia 1o., retrocede ao mês anterior para capturar o mês cheio
		dVend1   := CtoD( '01/' + str((nMesExec - 1)) +'/'+Right(StrZero(Year(dDATABASE),4),2) )
		dVend2   := LastDay(dVend1) 	
		cQry+="and C5_EMISSAO between '" + dtos(dVend1)+"' and '" + dtos(dVend2)+ "' "
	Else
	    cQry+="and C5_EMISSAO between '"+dtos(FirstDay(dDatabase))+"' and '"+dtos(LastDay(dDataBase))+"' " 
	Endif
	
ElseIf nOpc=2 // Faturado no Dia 
    cQry+="and C5_EMISSAO='"+dtos(dDatabase)+"' " 
EndIf

	cQry+="and SC5.C5_VEND1 = SA3.A3_COD "

If !empty(MV_PAR11)     //Representante
	//cQry+="and SC5.C5_VEND1 = SA3.A3_COD " 
    cQry+="and SC5.C5_VEND1 in ('"+ Alltrim(MV_PAR11) +"','"+alltrim(MV_PAR11) +"VD'"+") " 
elseif !empty(MV_PAR12)//Coordenador 
   //cQry+="and SA3.A3_COD = SC5.C5_VEND1  " 
   cQry+="and ( A3_SUPER LIKE ('" + ALLTRIM(MV_PAR12) + "%' )  OR C5_VEND1 in ('"+ Alltrim(MV_PAR12)+"','"+ alltrim(MV_PAR12) +"VD'"+") )  " 
elseif !empty(MV_PAR13)//Gerente
	//cQry+="and SC5.C5_VEND1 = SA3.A3_COD  " 
    cQry += " AND ( A3_SUPER IN ( SELECT A3_COD FROM "+RetSqlName("SA3")+" SA3 WHERE RTRIM(A3_GEREN) LIKE ('" + ALLTRIM(MV_PAR13) + "%' )  and SA3.D_E_L_E_T_ != '*' ) "
	cQry += " OR A3_GEREN LIKE ( '" + ALLTRIM(MV_PAR13) + "%' ) ) "
Endif

if MV_PAR07 = 1 //Linha Hospitalar
	cQry+="and SB1.B1_GRUPO IN ('C')  " 
elseif MV_PAR07 = 2 //Linha Dom/Inst
	cQry+="and SB1.B1_GRUPO IN ('D','E')  " 
elseif MV_PAR07 = 3
	cQry+="and SB1.B1_GRUPO IN ('A','B','F','G')  "
elseif MV_PAR07 = 5
	cQry+="and SB1.B1_GRUPO IN ('A','B','D','E','F','G')  " 
endif

if !empty(MV_PAR08) .and. empty(MV_PAR09)
	cQry+="and SA1.A1_EST = '"+MV_PAR08+"'  " 
elseIf empty(MV_PAR08) .and. !empty(MV_PAR09)
	cQry+="and SA1.A1_EST != '"+MV_PAR09+"' " 
elseIf !empty(MV_PAR08) .and. !empty(MV_PAR09)
	cQry+="and SA1.A1_EST = '"+MV_PAR08+"' AND SA1.A1_EST != '"+MV_PAR09+"'  " 
endIf

cQry+="AND F2_DUPL <> ' ' "
cQry+="AND B1_SETOR!='39' "
cQry+="AND B1_TIPO != 'AP' " 
cQry+="AND D2_TIPO = 'N'  "
cQry+="AND C5_TIPO='N' "
cQry+="AND D2_TP != 'AP' "
cQry+="AND B1_TIPO != 'AP'  "
cQry+="AND RTRIM(D2_CF) IN ('511','5101','5107','611','6101','512','5102','612','6102','6109','6107','5949','6949','5922','6922','5116','6116' )"
cQry+="AND SD2.D_E_L_E_T_ = '' "
cQry+="AND SB1.D_E_L_E_T_ = '' "
cQry+="AND SF2.D_E_L_E_T_ = '' "
cQry+="AND SC5.D_E_L_E_T_ = '' "
cQry+="AND SA3.D_E_L_E_T_ = '' "
cQry+="AND SA1.D_E_L_E_T_ = '' "
cQry+="AND SF4.D_E_L_E_T_ = '' "
MemoWrite("C:\Temp\fatmes.sql", cQry)
TCQUERY cQry NEW ALIAS 'FATMES'

FATMES->( dbGoTop() )
If !FATMES->(EoF())
	nRet := iif( mv_par04 == 1, FATMES->FAT_RS, FATMES->FAT_KG )
EndIf
FATMES->( dbCloseArea() )


Return nRet




