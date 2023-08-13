#include "rwmake.ch"
#include "topconn.ch"
#INCLUDE "PROTHEUS.CH"

#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

*************************
User Function FATR02V2() 
*************************
///FR -> TODA VEZ QUE SE FOR ALTERAR ESTE RELATÓRIO, LEMBRAR DE ALTERAR TAMBÉM O FATCONC ou avisar o Antonio
///

Local imprime      := .T.
Local aOrd := {}
 
SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("TAMANHO,LIMITE,CDESC1,CDESC2,CDESC3,ARETURN")
SetPrvt("NOMEPROG,CPERG,NLASTKEY,LCONTINUA,NLIN,WNREL")
SetPrvt("M_PAG,NTAMNF,CSTRING,TITULO,CABEC1,CABEC2")
SetPrvt("CINDSF2,CCHAVE,CFILTRO,AFRETE,AFRE_NF,NDNA")
SetPrvt("NTOT,NFRE,NTOTAL,NTOTFRET,NTOTFRICMS,NTOTICMS")
SetPrvt("NTOTDNA,NTOTRED,NDNAG,NTOTG,NFREG,NTOTGICMS")
SetPrvt("NDNACI,NTOTCI,NFRECI,NTOTCIICMS,CESTCI,X")
SetPrvt("CESTADO,CTRANSP,NVALDNA,NAD_VALOREN,NFRET_PES,NFRETE")
SetPrvt("NSUFRAMA,NTAXAFIXA,NFRETICMS,NPERC,NPEDAGIO")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Fatr02V2³ Autor ³   Silvano Araujo      ³ Data ³ 07/12/99 ³±±

// Alterado por : Flávia Rocha - por solicitação do chamado 001517
// Data         : 04/05/2010.
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Fretes por nota fiscal                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Rava                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        	// De Data                               ³
//³ mv_par02        	// Ate Data                              ³
//³ mv_par03        	// De Transportador                      ³
//³ mv_par04        	// Ate Transportador                     ³
//³ mv_par05        	// De Nota                               ³
//³ mv_par06        	// Ate Nota                              ³ 
//  mv_par07			// Lista notas (1-Normais, 2-bonificação,
//						 3-amostras, 4-Todas)
//  mv_par08 			// Pedido mínimo: 1-Abaixo, 2-Acima, 3-Todas
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

CbTxt		:=	""
CbCont		:=	""
nOrdem 		:=	0
Alfa 		:=  0
Z			:=	0
M			:=	0
//tamanho		:=	"G"
//limite		:=	254
limite           := 220
tamanho          := "G"
nTipo            := 18

cDesc1 		:=	PADC("Este programa ira Emitir relacao de fretes por nota fiscal",74)
cDesc2 		:=	""
cDesc3 		:=	""
aReturn 	:= { "Faturamento", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog	:=	"FATR02V2"
cPerg		:=	"FATR02"  
nLastKey	:= 0
lContinua 	:= .T.
nLin		:=	9
wnrel    	:= "FATR02V2"
M_PAG    	:= 1
nTamNf		:=	72
nValTitab := 0
nTotalAbat := 0

 lEnd         := .F.
 lAbortPrint  := .F.
 CbTxt        := ""
 limite           := 220
 tamanho          := "G"
 nTipo            := 18
 aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
 nLastKey        := 0
 cbtxt      := Space(10)
 cbcont     := 00
 CONTFL     := 01
 m_pag      := 01


Pergunte(cPerg,.F.)

cString		:=	"SF2"
titulo 		:=	PADC("NOVO - Relacao de Fretes por Nota Fiscal",74)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cbtxt    := SPACE(10)
cbcont   := 0
nLin     := 80
m_pag    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//			1		  2		    3	      4			5      	  6			7		  8			9		 10			11		  12        13 		  13	    14		  15		16		  17		18		  19        20
//012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
cabec1:= "N.F.   Ser     Valor N.F. Peso Brut  Fret Peso     Tx Fixa        Ad-Valorem    GRIS      ADM/Taxa       TDE    Pedagio    Suframa    Val Frete  Val c/Icm  UF  Perc    %ICMs   Frete Peso    Cubagem  Tit     Frete    %  "
cabec2:= "                                                Sec-At/Despacho                (% da NF)                                                                                        Cad.Localde.           Abi     Real     Real "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

pergunte("FATR02",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel		:=	"FATR02V2"            //Nome Default do relatorio em Disco
NomeProg    :=  "FATR02V2"
//wnrel		:=	SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)
wnrel       := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.) 
               
If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)
If nLastKey == 27
   Return
Endif
/*
#IFDEF WINDOWS
   RptStatus({|| RptDetail()})
   Return
   Static Function RptDetail()
#ENDIF
*/

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)


Return 

***************

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
 
***************

Local nCubagem := 0
Local nVlrCubagem := 0
Local nVlrCUBA4   := 0
Local nQTVOLUMES  := 0
Local LF	   := CHR(13) + CHR(10)

SD2->( dbSetOrder( 3 ) )

dbSelectArea("SF2")
SD2->( dbSetOrder( 1 ) )
/*
cIndSf2 := CriaTrab(nil,.f.)  // "SF2"+Substr( Time(), 4, 2 ) + Substr( Time(), 7, 2 )
cChave  := "F2_FILIAL + F2_TRANSP"
cFiltro := "F2_EMISSAO >= mv_par01 .and. F2_EMISSAO <= mv_par02"

IndRegua( "SF2", cIndSf2, cChave, , cFiltro,"Selecionando Notas.." )
dbSeek( xFilial( "SF2" )+mv_par03,.t. )
*/
SetRegua( Lastrec() )

aFrete := {}


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        	// De Data                               ³
//³ mv_par02        	// Ate Data                              ³
//³ mv_par03        	// De Transportador                      ³
//³ mv_par04        	// Ate Transportador                     ³
//³ mv_par05        	// De Nota                               ³
//³ mv_par06        	// Ate Nota                              ³ 
//  mv_par07			// Lista notas (1-Normais, 2-bonificação,
//						// 3-amostras, 4-Todas)
//  mv_par08 			// Pedido mínimo: 1-Abaixo, 2-Acima, 3-Todas
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//  Alterei a consulta pq o produto generico nao tem complemento e pode acontecer e um produto "normal" tb nao ter complemento por isso left join 
cQuery := "SELECT F2_DOC,F2_SERIE, F2_VALBRUT, F2_TRANSP, F2_REDESP, F2_LOCALIZ, F2_LOCRED, F2_EST, F2_VOLUME1 "+ LF
cQuery += ",D2_DOC, D2_SERIE, D2_PEDIDO, C5_NUM  "+ LF
//cQuery += ",CUBAGEM = ( SUM( (B5_COMPRI * B5_LARGURA * B5_ALTURA) * B5_VLRCUB ) ) "+ LF
cQuery += ",CUBAGEM = SUM( B5_COMPRI * B5_LARGURA * B5_ALTURA ) "+ LF

cQuery += "FROM SF2020 SF2 "+ LF
cQuery += "join SD2020 SD2 on F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA=D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA  "+ LF
cQuery += "AND SD2.D_E_L_E_T_ = '' "+ LF
cQuery += "LEFT join SB5010 SB5 on case when len(D2_COD) >= 8 then "+ LF
cQuery += "case when ( SUBSTRING( D2_COD, 4, 1 ) = 'R') or ( SUBSTRING( D2_COD, 5, 1 ) = 'R') "+ LF
cQuery += "then SUBSTRING( D2_COD, 1, 1) + SUBSTRING( D2_COD, 3, 4) + SUBSTRING( D2_COD, 8, 2) "+ LF
cQuery += "else SUBSTRING( D2_COD, 1, 1) + SUBSTRING( D2_COD, 3, 3) + SUBSTRING( D2_COD, 7, 2) end "+ LF
cQuery += "else D2_COD END = B5_COD  "+ LF
cQuery += "AND SB5.D_E_L_E_T_ = ''  "+ LF
cQuery += "join SC5020 SC5 on D2_PEDIDO = C5_NUM  " + LF //AND SC5.D_E_L_E_T_ = '' 
cQuery += "join SF4010 SF4 on D2_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = '' "+ LF
cQuery += " WHERE "+ LF
cQuery += "F2_TIPO  = 'N' "+ LF
If mv_par08 == 1
	cQuery += " and F2_VALBRUT <= 1000 " + LF    ////pedido mínimo é R$1.000,00 definido por Marcelo
Elseif mv_par08 == 2
	cQuery += " and F2_VALBRUT >= 1000 " + LF
Endif
cQuery += " AND F2_EMISSAO >= '" + Dtos(mv_par01) + "' AND F2_EMISSAO <= '" + Dtos(mv_par02) + "' " + LF
cQuery += " AND F2_TRANSP >= '" + mv_par03 + "' AND F2_TRANSP <= '" + mv_par04 + "' " + LF
cQuery += " AND F2_DOC >= '" + mv_par05 + "' AND F2_DOC <= '" + mv_par06 + "' "            + LF
cQuery += " AND RTRIM(F2_EST) >= '" + Alltrim(mv_par09) + "' AND RTRIM(F2_EST) <= '" + Alltrim(mv_par10) + "' " + LF

If mv_par11 = 2
	cQuery += " AND F2_FILIAL = '" + xFilial("SF2") + "' " + LF
EndIf

// TESTE (diferenca com relacao ao faturamento diario)
//cQuery += "AND D2_CF IN  ('5101','6101','5102','6102','5109','6109','5107','6107','5949','6949','7501')  "+ LF
//cQuery += "AND D2_TES NOT  IN ('514','515') "+ LF
//EM 20/07/2012 - Emanuel solicitou que liberasse todos os TES e CFOPs
//E bloqueasse apenas as notas cujo frete for FOB
cQuery += " AND SF2.F2_TPFRETE = 'C' " + LF //só vai mostrar quando for Cif, pois Fob é o cliente que paga
//cQuery += " AND SD2.D2_QTDEDEV = 0 " + LF         //não mostrar NFs em processo de devolução , TEM Q MOSTRAR, MAS COM O VALOR FRETE ZERADO
cQuery += " AND SF2.F2_CLIENTE NOT IN ('006543','007005') " + LF //teste


cQuery += "AND SF2.D_E_L_E_T_ = '' "+ LF
cQuery += "GROUP BY  F2_DOC,F2_SERIE,F2_VALBRUT  , F2_TRANSP, F2_REDESP, F2_LOCALIZ, F2_LOCRED, F2_EST, F2_VALBRUT, F2_VOLUME1  "+ LF
cQuery += ",D2_DOC, D2_SERIE, D2_PEDIDO, C5_NUM "+ LF
cQuery += "ORDER BY F2_DOC, F2_SERIE "+ LF
//


MemoWrite("C:\Temp\FATR02V2.SQL", cQuery )
If Select("FT02") > 0
	DbSelectArea("FT02")
	DbCloseArea()	
EndIf 

TCQUERY cQuery NEW ALIAS "FT02"  
FT02->( dbGoTop() )

While FT02->( !EOF())
  
    
	if !tipos( FT02->F2_DOC ) .and. mv_par07 != 4
      FT02->( dbSkip() )
      IncRegua()      
      Loop
   endIf
   
   
   // TESTE (diferenca com relacao ao faturamento diario)
   /*
   if FT02->F2_SERIE $ "   DNA DNS"
      FT02->( dbSkip() )
      IncRegua()      
      Loop
   endif
   */

   //SD2->( dbSeek( xFilial( "SD2" ) + SF2->F2_DOC + SF2->F2_SERIE, .T. ) )
   //SC5->( dbseek( xFilial( "SC5" ) + SD2->D2_PEDIDO, .T. ) )
   //MSGBOX('CUBAGEM: ' + STR(FT02->CUBAGEM) )
   
   SZZ->(Dbsetorder(1))
   if Empty( FT02->F2_REDESP )   		
   		SZZ->( dbSeek( xFilial( "SZZ" ) + FT02->F2_TRANSP + FT02->F2_LOCALIZ ) )
      	Aadd( aFrete, { FT02->F2_TRANSP, FT02->F2_DOC, FT02->F2_SERIE, FT02->F2_LOCALIZ, " ", FT02->F2_EST + SZZ->ZZ_TIPO,ALLTRIM(getReg(FT02->F2_EST)), FT02->CUBAGEM, FT02->F2_VOLUME1  } )
   //						1                 2              3                4           5        6                                 7                        8               9          
   else   
   		SZZ->( dbSeek( xFilial( "SZZ" ) + FT02->F2_REDESP + FT02->F2_LOCALIZ ) )
      	Aadd( aFrete, { FT02->F2_TRANSP, FT02->F2_DOC, FT02->F2_SERIE, FT02->F2_LOCRED, " ", FT02->F2_EST + SZZ->ZZ_TIPO,ALLTRIM(getReg(FT02->F2_EST)),FT02->CUBAGEM, FT02->F2_VOLUME1 } )
      	Aadd( aFrete, { FT02->F2_REDESP, FT02->F2_DOC, FT02->F2_SERIE, FT02->F2_LOCALIZ,"R", FT02->F2_EST + SZZ->ZZ_TIPO,ALLTRIM(getReg(FT02->F2_EST)),FT02->CUBAGEM, FT02->F2_VOLUME1 } )
      	//                     1			2				3				4			 5	    	6				                    7				     8               9
   endif
   FT02->( dbSkip() )
   IncRegua()

Enddo

aFre_nf  := Asort( aFrete,,, { |X,Y| X[7]+X[6]+X[1]+X[2]<Y[7]+Y[6]+Y[1]+Y[2] } )    //ZZ_TIPO+F2_EST+F2_TRANSP+F2_DOC
nTRe:= nTFrRe   :=nDna    := nTot  := nFre := nTotal := nTotFret := nTotFrIcms := nTotIcms := nTotDna :=nTotRed := nTotpes:= nTotPesoFrete :=nTtpes :=0
nTGFrRe  :=nDnaG   := nTotG := nFreG:= nTotGicms := nPesG:=0
nTCIFrRe :=nDnaCI   := nTotCI:= nFreCI:= nTotCIicms := nPesCI:=0


//REGIAO
nTotCE:=nTotNE:=nTotNO:=nTotSD:=nTotSL:=0
nPECE:=nPENE:=nPENO:=nPESD:=nPESL:=0
nTotCEicms :=nTotNEicms :=nTotNOicms :=nTotSDicms :=nTotSLicms := 0
nFreCE :=nFreNE :=nFreNO :=nFreSD :=nFreSL :=0
nDnaCE :=nDnaNE :=nDnaNO :=nDnaSD :=nDnaSL :=0
// frete real 
nTCEfreRe :=nTNEfreRe :=nTNOfreRe :=nTSDfreRe :=nTSLfreRe := 0

nCubagem := 0
nQTVOLUMES := 0
//
SetRegua( Len( aFre_nf ) )
if len(aFre_nf) > 0
	cEstCI  := Substr( aFre_nf[ 1, 6 ], 1, 2 )
endIf

For x := 1 to Len( aFre_nf )   
    cEstado := aFre_nf[ x, 6 ] 
    
    if nLin > 55
       //nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15 ) + 2
       cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo )
       nLin := 9
    endif
    SX5->(DBSETORDER(1))
    SX5->( dbSeek( xFilial( "SX5" ) + "12" + Substr( cEstado, 1, 2 ) ) )
    @ nLin,000   pSay "Estado.: " + Alltrim( SX5->X5_DESCRI ) + " " + Iif( Substr( cEstado, 3, 1 )=="C"," Capital",Iif( Substr( cEstado, 3, 1 )=="I"," Interior"," Outros" ) ) 
    nLin := nLin + 2
    While aFre_nf[ x, 6 ] == cEstado
    
    	If nLin > 55
        	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo )
            nLin := 9
     	EndIf
       
       cTransp := aFre_nf[ x, 1 ]
       nCubagem    := 0
       nVlrCubagem := 0
       nVlrCUBA4   := 0                   //VLR CUBAGEM CADASTRADO NO SA4
       nQTVOLUMES  := aFre_nf[x,9]        //QTDE DE VOLUMES NA NOTA FISCAL
               
       SA4->(DBSETORDER(1))
       If SA4->( dbSeek( xFilial( "SA4" ) + aFre_nf[ x, 1 ] ) )
       	@ nLin,000 pSay "Transportadora.: " + SA4->A4_NOME
       	nVlrCUBA4 := SA4->A4_VLRCUB     //VALOR DA CUBAGEM POR TRANSPORTADORA NO SA4
       Endif
       nLin := nLin + 1
		
		
			
       While aFre_nf[ x, 1 ] == cTransp .and. aFre_nf[ x, 6 ] == cEstado

          nAd_valoren := 0
          nFret_pes   := 0
          nTaxaFixa   := 0
          nADM		  := 0
          nPedagio	  := 0
          nSuframa	  := 0 
          nFretIcms	  := 0
          nFrete	  := 0
          nGRIS		  := 0
          nTDE		  := 0
          
          nCubagem:= aFre_nf[ x, 8 ]     //resultado da multiplicação (ALT X LARG X COMPRIMENTO)
           
          nVlrCubagem := (nCubagem * nVlrCUBA4 * nQTVOLUMES)   //valor a ser impresso no relatório
          
          SZZ->(DBSETORDER(1))
          SZZ->( dbSeek( xFilial( "SZZ" ) + aFre_nf[ x, 1 ] + aFre_nf[ x, 4 ] ) )   //F2_TRANSP + F2_LOCALIZ (ZZ_TRANSP + ZZ_LOCAL)
          SF2->(DBSETORDER(1))
          SF2->( dbSeek( xFilial( "SF2" ) + aFre_nf[ x, 2 ] + aFre_nf[ x, 3 ] ) )  //F2_DOC + F2_SERIE
          
          IF nLin > 55
                                                                         
             //nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15 ) + 2
             cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo )
             nLin := 9

             SX5->(DBSETORDER(1))
             SX5->( dbSeek( xFilial( "SX5" ) + "12" + Substr( cEstado, 1, 2 ) ) )
             @ nLin,000   pSay "Estado.: " + Alltrim( SX5->X5_DESCRI ) + " " + Iif( Substr( cEstado, 3, 1 )=="C"," Capital",Iif( Substr( cEstado, 3, 1 )=="I"," Interior"," Outros" ) ) 
             nLin := nLin + 2
             
             //@ nLin,000   pSay "Estado.: " + Alltrim( SX5->X5_DESCRI ) + " "+Iif( Substr( cEstado, 3, 1 )=="C"," Capital",Iif( Substr( cEstado, 3, 1 )=="I"," Interior"," Outros" ) )
             //@ nLin+2,000 pSay "Transportadora.: " + SA4->A4_NOME

             //nLin := nLin + 4

          EndIf

          nValDna := 0
          
          //nFret_pes := Round( iif(SF2->F2_PLIQUI>=SA4->A4_KG_MIN, SF2->F2_PLIQUI, SA4->A4_KG_MIN ) * SZZ->ZZ_FR_PESO, 2 )
          //Modificação feita através do Chamado 001517 - 04/05/2010
          //Fret Peso
          If SF2->F2_PLIQUI > 150
          	nFret_pes := (SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO)
            //SE O FRETE PESO CALCULADO FOR MENOR QUE O MÍNIMO, PEGA O MÍNIMO DO SA4
            If SZZ->ZZ_TIPO = 'C'    //CAPITAL
            	If nFret_pes < SA4->A4_FREMINC
            		nFret_pes := SA4->A4_FREMINC
            	Endif
            Elseif SZZ->ZZ_TIPO = 'I'   //INTERIOR
            	If nFret_pes < SA4->A4_FREMINI
            		nFret_pes := SA4->A4_FREMINI
            	Endif            
            Endif
            	
          ElseIf (SF2->F2_PLIQUI >= 101 .and. SF2->F2_PLIQUI <= 150)
          	If !Empty(SZZ->ZZ_101150K) 
          		nFret_pes := SZZ->ZZ_101150K
          	Else
          		nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          	Endif          	
          
          //FR - Flávia Rocha
          //chamado 002208:	Joao Emanuel
          //Para calculo de frete, quando a transportadora for cod 30
          // e o peso for até 10 KG, favor calcular só os valores abaixo:
          // Valor do campo de 1 a 10KG + Ad valorem (0,5%) sobre o valor da nota fiscal + Gris + Icms  
          ElseIf SF2->F2_PLIQUI <= 10
            	If !Empty(SZZ->ZZ_1A10KG) 
          			nFret_pes := SZZ->ZZ_1A10KG
          			If Alltrim( cTransp ) = "30"
          				nGRIS := ( SF2->F2_VALBRUT * SZZ->ZZ_GRIS) / 100	 //o Gris é o valor da nota vezes o Gris%
						//validação do Gris com o Gris mínimo (novo campo ZZ_GRISMIN)
						If !Empty(SZZ->ZZ_GRISMIN)
							If nGRIS <= SZZ->ZZ_GRISMIN
								nGRIS := SZZ->ZZ_GRISMIN
							Endif
						Endif
          				nFret_pes := SZZ->ZZ_1A10KG + ( SF2->F2_VALBRUT * 0.5 / 100 ) + nGRIS
          			Endif 
          		Else
          			nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          	
          Elseif SF2->F2_PLIQUI <= 20
          		If !Empty(SZZ->ZZ_11A20KG)
          			nFret_pes := SZZ->ZZ_11A20KG
          		Else
          			nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          		
          Elseif SF2->F2_PLIQUI <= 30
          		If !Empty(SZZ->ZZ_21A30KG)
          			nFret_pes := SZZ->ZZ_21A30KG
          		Else
          			nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          		
          Elseif SF2->F2_PLIQUI <= 40
          		If !Empty(SZZ->ZZ_31A40KG)
          			nFret_pes := SZZ->ZZ_31A40KG 
          		Else
          			nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          	
          Elseif SF2->F2_PLIQUI <= 50
          		If !Empty(SZZ->ZZ_41A50KG)
          			nFret_pes := SZZ->ZZ_41A50KG 
          		Else
          			nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          	
          Elseif SF2->F2_PLIQUI <= 60
          		If !Empty(SZZ->ZZ_51A60KG)
          			nFret_pes := SZZ->ZZ_51A60KG 
          		Else
          			nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          	
          Elseif SF2->F2_PLIQUI <= 70
          		If !Empty(SZZ->ZZ_61A70KG)
          			nFret_pes := SZZ->ZZ_61A70KG
          			Else
          			nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          	
          Elseif SF2->F2_PLIQUI <= 80
          		If !Empty(SZZ->ZZ_71A80KG)
          			nFret_pes := SZZ->ZZ_71A80KG
          		Else
          			nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          		
          Elseif SF2->F2_PLIQUI <= 90
          		If !Empty(SZZ->ZZ_81A90KG)
          			nFret_pes := SZZ->ZZ_81A90KG
          		Else
          			nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          		
          Else
          	If !Empty(SZZ->ZZ_91A100K)
          		nFret_pes := SZZ->ZZ_91A100K          	
          	Else
          		nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		
          	Endif          	
          
          Endif          
          
          //nFrete    := Round( iif(SF2->F2_PLIQUI >= SA4->A4_KG_MIN, SF2->F2_PLIQUI, SA4->A4_KG_MIN ) * SZZ->ZZ_FR_PESO, 2 )
          
           ///Modificação feita através do Chamado 001517 - 04/05/2010           
           	//TAXA FIXA
           	If !Empty(SZZ->ZZ_TXFIXA)
	     		nTaxaFixa := SZZ->ZZ_TXFIXA
	  		Endif
          	
          	//AD-VALOREM
          	If !Empty(SZZ->ZZ_ADVALOR)
	        	nAd_valoren := ( SF2->F2_VALBRUT * SZZ->ZZ_ADVALOR / 100 )	 
	        	         
			Elseif Alltrim( cTransp ) == "03" .and. Alltrim( SZZ->ZZ_LOCAL ) $ "07 09 20 59 94 46"
	      		nAd_valoren := ( SF2->F2_VALBRUT * 0.3 / 100 )
	      	Else
	      		nAd_valoren := 0
			Endif
			
			//GRIS
			nGRIS := ( SF2->F2_VALBRUT * SZZ->ZZ_GRIS) / 100	 //o Gris é o valor da nota vezes o Gris%
			//validação do Gris com o Gris mínimo (novo campo ZZ_GRISMIN)
			If !Empty(SZZ->ZZ_GRISMIN)
				If nGRIS <= SZZ->ZZ_GRISMIN
					nGRIS := SZZ->ZZ_GRISMIN
				Endif
			Endif
			
			//ADM
			If !Empty(SZZ->ZZ_ADM)
				nADM := SZZ->ZZ_ADM
			Endif   
            
            //TDE
          	nTDE := SZZ->ZZ_TDE  
          	
            //PEDAGIO E SUFRAMA
            If SF2->F2_PLIQUI >= 100
	            Do Case
	            	Case ( SF2->F2_PLIQUI >= 100 .And. SF2->F2_PLIQUI < 101)
			            If !Empty(SZZ->ZZ_PEDAGIO)
			            	nPedagio := SZZ->ZZ_PEDAGIO
			            Endif
			            
			            If !Empty(SZZ->ZZ_SUFRAMA)
			            	nSuframa := SZZ->ZZ_SUFRAMA
			            Endif
	   	       		
	   	       		Case (SF2->F2_PLIQUI >= 101 .And. SF2->F2_PLIQUI <= 200 )
	   	       			If !Empty(SZZ->ZZ_PEDAGIO)
	   	       				nPedagio := ( SZZ->ZZ_PEDAGIO * 2 )
	   	       			Endif
	   	       			
	   	       			If !Empty(SZZ->ZZ_SUFRAMA)
	   	       				nSuframa := ( SZZ->ZZ_SUFRAMA * 2 )
	   	       			Endif
		  			
		  			Case (SF2->F2_PLIQUI >= 201)
		  				If !Empty(SZZ->ZZ_PEDAGIO)
		  					nPedagio := ( SF2->F2_PLIQUI / 100) * SZZ->ZZ_PEDAGIO
		  				Endif
		  				
		  				If !Empty(SZZ->ZZ_SUFRAMA)
		  					nSuframa := ( SF2->F2_PLIQUI / 100) * SZZ->ZZ_SUFRAMA
		  				Endif
		  				
		  		Endcase
	  		            
	  		Endif
            
            
          	
            
            //SE A SOMA DAS TAXAS FOR MENOR QUE O VALOR DO FRETE MÍNIMO, ASSUME O FRETE MÍNIMO
	      	If SF2->F2_PLIQUI > 100
		      	If ( nFret_pes + nTaxaFixa + nAd_valoren + nGRIS + nADM + nPedagio + nSuframa + nTDE ) >= SA4->A4_FREMINI
	          		nFrete := ( nFret_pes + nTaxaFixa + nAd_valoren + nGRIS + nADM + nPedagio + nSuframa + nTDE ) 	
	          	Else
	          		nFrete := SA4->A4_FREMINI          	
	          	Endif
	        
	        ElseIf SF2->F2_PLIQUI <= 10
            	If !Empty(SZZ->ZZ_1A10KG) 
          			nFrete := (SZZ->ZZ_1A10KG + nPedagio)           		
          		Else
          			nFrete := SA4->A4_FREMINI
          		Endif
          	
          	Elseif SF2->F2_PLIQUI <= 20
          		If !Empty(SZZ->ZZ_11A20KG)
          			nFrete := (SZZ->ZZ_11A20KG + nPedagio)           		
          		Else
          			nFrete := SA4->A4_FREMINI
          		Endif
          		
          	Elseif SF2->F2_PLIQUI <= 30
          		If !Empty(SZZ->ZZ_21A30KG)
          			nFrete := (SZZ->ZZ_21A30KG + nPedagio)     		
          		Else
          			nFrete := SA4->A4_FREMINI
          		Endif
          		
          	Elseif SF2->F2_PLIQUI <= 40
          		If !Empty(SZZ->ZZ_31A40KG)
          			nFrete := (SZZ->ZZ_31A40KG + nPedagio)          		
          		Else
          			nFrete := SA4->A4_FREMINI
          		Endif
          	
          	Elseif SF2->F2_PLIQUI <= 50
          		If !Empty(SZZ->ZZ_41A50KG)
          			nFrete := (SZZ->ZZ_41A50KG + nPedagio)         		
          		Else
          			nFrete := SA4->A4_FREMINI
          		Endif
          	
          	Elseif SF2->F2_PLIQUI <= 60
          		If !Empty(SZZ->ZZ_51A60KG)
          			nFrete := (SZZ->ZZ_51A60KG + nPedagio)        		
          		Else
          			nFrete := SA4->A4_FREMINI
          		Endif
          	
          	Elseif SF2->F2_PLIQUI <= 70
          		If !Empty(SZZ->ZZ_61A70KG)
          			nFrete := (SZZ->ZZ_61A70KG + nPedagio)         		
          		Else
          			nFrete := SA4->A4_FREMINI
          		Endif
          	
          	Elseif SF2->F2_PLIQUI <= 80
          		If !Empty(SZZ->ZZ_71A80KG)
          			nFrete := (SZZ->ZZ_71A80KG + nPedagio)         		
          		Else
          			nFrete := SA4->A4_FREMINI
          		Endif
          		
          	Elseif SF2->F2_PLIQUI <= 90
          		If !Empty(SZZ->ZZ_81A90KG)
          			nFrete := (SZZ->ZZ_81A90KG + nPedagio)         		
          		Else
          			nFrete := SA4->A4_FREMINI
          		Endif
          		
          	Else
	          	If !Empty(SZZ->ZZ_91A100K)
	          		nFrete := (SZZ->ZZ_91A100K + nPedagio)          		
	          	Else
	          		nFrete := SA4->A4_FREMINI
	          	Endif          
          	Endif           
	      	
	      	If empty(SA4->A4_FREMINI) 	  	
	           nFrete := ( nFret_pes + nTaxaFixa + nAd_valoren + nGRIS + nADM + nPedagio + nSuframa + nTDE ) 	
            Endif
          
          ///FR - 20/08/13
          	//nFretIcms :=  ( nFrete / ( 1 - (SA4->A4_ICMS / 100) )  ) //COMENTADO, POIS AGORA É UMA NOVA REGRA:
          	
          	//TRANSPORTADORA AGAPE , SEMPRE ZERO
          	IF ALLTRIM(SF2->F2_TRANSP)!='80' // TRANSPORTADORA AGAPE E SEMPRE ZERO
            	nFretIcms :=  ( nFrete / ( 1 - (IIF(ALLTRIM(SA1->A1_TIPO)<> 'F' , SA4->A4_ICMS,17) / 100) )  )
			ELSE
	            nFretIcms :=  ( nFrete / ( 1 - (SA4->A4_ICMS / 100) )  ) //SE NO CADASTRO DELA ESTIVER 0, SERÁ ZERO.
	   		ENDIF
	
	        
          
          nValDna   := nValDna + SF2->F2_VALBRUT
          nPerc     := ( nFretIcms * 100 / nValDna ) 
          //nValTitab := fBuscAbat(aFre_nf[ x, 2 ] , SA4->A4_CODCLIE)
          //nValTitab := fBuscAbat(SF2->F2_DOC , SA4->A4_CODCLIE)
          
          
          //N.F.   Ser     Valor N.F. Peso Brut  Fret Peso     Tx Fixa        Ad-Valorem    GRIS      ADM/Taxa       TDE      Pedagio    Suframa    Val Frete  Val c/Icm  UF  Perc  %ICMs   Frete Peso"
          //                                                Sec-At/Despacho                                                                                                                 Cad.Local."

          //999999-XXX 999,999,999.99 99,999.99  99,999.99      999.99        999,999.99  99,999.99   99,999.99   99,999.99   99,999.99  99,999.99  99,999.99  99,999.99  XX  99.99   99.99   99,999.99
          //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
          //          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
          
          /*
          	18-10-2011
          	Eurivan Marques: Tem mais uma alteração para fazer no relatório de frete.
			(11:12 AM) Eurivan Marques: quando o valor da coluna "peso bruto" for menor que a coluna "cubagem", 
			           entao o valor da coluna "frete peso" será igual ao valor da coluna "cubagem" vezes o valor da coluna "frete cad.local"
			(11:12 AM) Eurivan Marques: caso contrário será do jeito que já é hoje
			(11:13 AM) Eurivan Marques: lembrando que essa alteração, só será aplicada se for na Fábrica de Caixas
			
          
          */
          ///////////////////////////////////////////////////////
	      ///SE FOR AMOSTRA/CORTESIA, OS VALORES SERÃO ZERADOS   
	      ///08/10/13 - FR -> SE FOR NOTA EM PROCESSO DE DEVOLUÇÃO,
	      ///OS VALORES SERÃO ZERADOS TAMBÉM
	      ///////////////////////////////////////////////////////
	      cD2TES := ""
	      cTESAM := GETMV("RV_TESAM")
          SD2->(Dbsetorder(3))
          If SD2->(Dbseek(xFilial("SD2") + aFre_nf[ x, 2 ] + aFre_nf[ x, 3 ] ) )
          	While SD2->(!EOF()) .and. SD2->D2_FILIAL == xFilial("SD2") .and. SD2->D2_DOC == aFre_nf[ x, 2 ] .and. SD2->D2_SERIE == aFre_nf[ x, 3 ]
          		cD2TES := SD2->D2_TES
          		//SF4->(Dbsetorder(1))
          		//SF4->(Dbseek(xFilial("SF4") + cD2TES ))
          		//If 'AMOSTRA/CORTESIA/GRATIS ' $ SF4->F4_TEXTO
          		If cD2TES $ cTESAM //'516'
          			nFret_pes := 0
          			nTaxaFixa := 0
          			nGRIS     := 0
          			nADM      := 0
          			nTDE      := 0
          			nPedagio  := 0
          			nSuframa  := 0
          			nFrete    := 0
          			nFretIcms := 0
          			nPerc     := 0
          		Endif
          		
          		If SD2->D2_QTDEDEV > 0  //NF em processo de devolução - VALORES FRETE ZERADOS
          			nFret_pes := 0
          			nTaxaFixa := 0
          			nGRIS     := 0
          			nADM      := 0
          			nTDE      := 0
          			nPedagio  := 0
          			nSuframa  := 0
          			nFrete    := 0
          			nFretIcms := 0
          			nPerc     := 0
          		Endif	
          			
          		SD2->(Dbskip())
          	Enddo
          Endif           
          
          ///FR - 02/08/13
          ///////////////////////////////////////////////////////////////////////////
          ///Verifica se existe título de abatimento para esta transportadora x nota 
          ///////////////////////////////////////////////////////////////////////////
          //exemplo: parâmetros que trouxeram resultado:
          //data: 01/01/12 a  31/12/13 , nf 000032900 - transportadora 47 
          //foi o único exemplo que consegui, pois ainda não teve títulos de abatimento em 2013 !!
          //nValTitab := fBuscAbat(aFre_nf[ x, 2 ] , SA4->A4_CODCLIE)     
       //   nValTitab := fBuscAbat(SF2->F2_DOC , SA4->A4_CODCLIE)
	      @ nLin,000 pSay SF2->F2_DOC +"-"+SF2->F2_SERIE//+" "+alltrim(aFre_nf[ x, 5 ]) // aFre_nf[ x, 5 ] = "R" ou "" (Redespacho)
	      nValTitab := fBuscAbat(SF2->F2_DOC , SA4->A4_CODCLIE)
	      
	      nTotalAbat += nValTitab
	      
	      @ nLin,011 pSay SF2->F2_VALBRUT   Picture "@E 999,999,999.99"
	      @ nLin,026 pSay SF2->F2_PLIQUI    Picture "@E 99,999.99"    //peso bruto
	          If xFilial("SF2") != '03'    //SE NÃO FOR FILIAL CAIXAS, SEGUE NORMAL
	          	@ nLin,037 pSay nFret_pes         Picture "@E 99,999.99"    ///campo 1 Fret Peso
	          Elseif xFilial("SF2") = '03' 
	          		If SF2->F2_PLIQUI > nVlrCubagem
		          		@ nLin,037 pSay nFret_pes         Picture "@E 99,999.99"    ///campo 1 Fret Peso
		          	Else
		          		@ nLin,037 pSay (nVlrCubagem * SZZ->ZZ_FR_PESO) Picture "@E 99,999.99"    ///campo 1 Fret Peso
		          	Endif
	          Endif
	       @ nLin,052 pSay nTaxaFixa        Picture "@E 999.99"
	       @ nLin,066 pSay nAd_valoren      Picture "@E 99,999,999.99"
	       @ nLin,078 pSay nGRIS			Picture "@E 99,999,999.99"
	       @ nLin,090 pSay nADM				Picture "@E 99,999,999.99"
	       @ nLin,102 pSay nTDE				Picture "@E 99,999,999.99"
	       @ nLin,114 pSay nPedagio		    Picture "@E 99,999,999.99"
	       @ nLin,125 pSay nSuframa         Picture "@E 99,999,999.99"
	       @ nLin,136 pSay nFrete           Picture "@E 99,999,999.99"
	       @ nLin,147 pSay nFretIcms        Picture "@E 99,999,999.99"  
	       @ nLin,158 pSay SF2->F2_EST                                //UF
	       @ nLin,162 pSay nPerc            Picture "@E 99.99"
	       @ nLin,170 pSay SA4->A4_ICMS     Picture "@E 99.99"       //ICMS
	       @ nLin,175 pSay SZZ->ZZ_FR_PESO  Picture "@E 99,999,999.99"   //frete peso cad. localidade
	       //@ nLin,189 pSay cEstado + "-" + SZZ->ZZ_LOCAL		Picture "@!" 
	                                                              
	       If SA1->A1_TIPO=='F'  .and.  nTotal >= Z48->Z48_SPFINA
	       //testa se pedido atingiu o valor mínimo para a sua localidade
	          @ nLin,140 pSay "X"
	       endIf
	          
	      @ nLin,188 pSay nVlrCubagem   Picture "@E 99,999,999.99"        //cubagem
          /*IF nValTitab > 0
          	ALERT("É maior que zero.")
          endif*/
          @ nLin,195 pSay nValTitab Picture "@E 99,999,999.99" //"0,00" 
          
          nFretRe:=fFretRe(SF2->F2_DOC)
          
          nPerRe := ( nFretRe * 100 / nValDna ) // Percentual frete Real
          
          @ nLin,206 pSay TRANSFORM(nFretRe,"@E 99,999,999.99") //FRETE REAL 
          @ nLin,217 pSay TRANSFORM(nPerRe ,"@E 999.99") //FRETE REAL 
          
          nTFrRe     :=nTFrRe      + nFretRe
          nTotFrIcms := nTotFrIcms + nFretIcms
          nTotal     := nTotal     + Iif( aFre_nf[ x, 5 ] == "R", 0, SF2->F2_VALBRUT )
  	      nTotpes    := nTotpes    + Iif( aFre_nf[ x, 5 ] == "R", 0, SF2->F2_PLIQUI)
          nTotPesoFrete := nTotPesoFrete + nFret_pes
          nTotFret   := nTotFret   + nFrete
          nTotDna    := nTotDna    + nValDna

          nTotCI     := nTotCI     + Iif( aFre_nf[ x, 5 ] == "R", 0, SF2->F2_VALBRUT )
          nPesCI     := nPesCI     + Iif( aFre_nf[ x, 5 ] == "R", 0, SF2->F2_PLIQUI)
          nTotCIicms := nTotCIicms + nFretIcms
          nFreCI     := nFreCI     + nFrete
          nDnaCI     := nDnaCI     + nValDna
          
          nTCIFrRe   := nTCIFrRe   + nFretRe
          
          //REGIAO
          if ALLTRIM(aFre_nf[ x, 7 ])=='CE'
             nTotCE     := nTotCE + Iif( aFre_nf[ x, 5 ] == "R", 0, SF2->F2_VALBRUT )             
             nPECE      := nPECE  + Iif( aFre_nf[ x, 5 ] == "R", 0, SF2->F2_PLIQUI)    
             nTotCEicms := nTotCEicms + nFretIcms
             nFreCE     := nFreCE     + nFrete
             nDnaCE     := nDnaCE     + nValDna
             nTCEfreRe  := nTCEfreRe  + nFretRe
          ElseIf ALLTRIM(aFre_nf[ x, 7 ])=='NE'
             nTotNE     := nTotNE + Iif( aFre_nf[ x, 5 ] == "R", 0, SF2->F2_VALBRUT )
             nPENE      := nPENE  + Iif( aFre_nf[ x, 5 ] == "R", 0, SF2->F2_PLIQUI)    
             nTotNEicms := nTotNEicms + nFretIcms
             nFreNE     := nFreNE     + nFrete
             nDnaNE     := nDnaNE     + nValDna
             nTNEfreRe  := nTNEfreRe  + nFretRe
          ElseIf ALLTRIM(aFre_nf[ x, 7 ])=='NO'
             nTotNO     := nTotNO + Iif( aFre_nf[ x, 5 ] == "R", 0, SF2->F2_VALBRUT )
             nPENO      := nPENO  + Iif( aFre_nf[ x, 5 ] == "R", 0, SF2->F2_PLIQUI)    
             nTotNOicms := nTotNOicms + nFretIcms
             nFreNO     := nFreNO     + nFrete
             nDnaNO     := nDnaNO     + nValDna
             nTNOfreRe  := nTNOfreRe  + nFretRe
          ElseIf ALLTRIM(aFre_nf[ x, 7 ])=='SD'
             nTotSD     := nTotSD + Iif( aFre_nf[ x, 5 ] == "R", 0, SF2->F2_VALBRUT )
             nPESD      := nPESD  + Iif( aFre_nf[ x, 5 ] == "R", 0, SF2->F2_PLIQUI)    
             nTotSDicms := nTotSDicms + nFretIcms
             nFreSD     := nFreSD     + nFrete
             nDnaSD     := nDnaSD     + nValDna
             nTSDfreRe  := nTSDfreRe  + nFretRe
          ElseIf ALLTRIM(aFre_nf[ x, 7 ])=='SL' 
             nTotSL     := nTotSL + Iif( aFre_nf[ x, 5 ] == "R", 0, SF2->F2_VALBRUT )
             nPESL      := nPESL  + Iif( aFre_nf[ x, 5 ] == "R", 0, SF2->F2_PLIQUI)    
             nTotSLicms := nTotSLicms + nFretIcms
             nFreSL     := nFreSL     + nFrete
             nDnaSL     := nDnaSL     + nValDna
             nTSLfreRe  := nTSLfreRe  + nFretRe
          Endif
          //
          nLin       := nLin       + 1
          x          := x          + 1

          if x > Len( aFre_nf )
             exit
          endif
          IncRegua()

       enddo

       if nTotal #0 .or. nTotFret # 0 .or. ntotFrIcms # 0

          nLin := nLin + 1

          IF nLin > 55
             //nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15 ) + 2
             cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo )
             nLin := 9

		    SX5->(DBSETORDER(1))
		    SX5->( dbSeek( xFilial( "SX5" ) + "12" + Substr( cEstado, 1, 2 ) ) )
		    @ nLin,000   pSay "Estado.: " + Alltrim( SX5->X5_DESCRI ) + " " + Iif( Substr( cEstado, 3, 1 )=="C"," Capital",Iif( Substr( cEstado, 3, 1 )=="I"," Interior"," Outros" ) ) 
		    nLin := nLin + 2             

             //SX5->( dbSeek( xFilial( "SX5" ) + "12"+ cEstado, .t. ) )
             //@ nLin,000   pSay "Estado.: " + Alltrim( SX5->X5_DESCRI ) + " "+Iif( Substr( cEstado, 3, 1 )=="C"," Capital",Iif( Substr( cEstado, 3, 1 )=="I"," Interior"," Outros" ) )
             //@ nLin+2,000 pSay "Transportadora.: " + SA4->A4_NOME                        
          EndIf

          nPerc     := ( nTotFrIcms*100/nTotDna )
          @ nLin,00 pSay "Total"
          @ nLin,11 pSay  nTotal     Picture "@E 999,999,999.99"
	      @ nLin,26 pSay  nTotpes    Picture "@E 99,999,999.99"
       // @ nLin,37 pSay  nTotPesoFrete Picture "@E 99,999.99"
          @ nLin,101 pSay nTotFret   Picture "@E 99,999,999.99"
          @ nLin,112 pSay nTotFrIcms Picture "@E 99,999,999.99"
          @ nLin,126 pSay nPerc      Picture "@E 999.99"
          // FRETE REAL 
          nPeRe:= ( nTFrRe*100/nTotDna )
          @ nLin,206 pSay nTFrRe     Picture "@E 99,999,999.99"
          @ nLin,217 pSay nPeRe      Picture "@E 999.99"


          nlin := nLin + 2

          nTot     := nTot     + nTotal
          nTtpes   := nTtpes   + nTotpes
          nTotIcms := nTotIcms + nTotFrIcms
          nFre     := nFre     + nTotFret
          nDna     := nDna     + nTotDna
          nTRe     := nTRe     + nTFrRe


          nTotal   := nTotPes := nTotFret := nTotFrIcms := nTotDna := nTFrRe:=0

       endif

       if x > Len( aFre_nf )
          exit
       endif
       IncRegua()

       if x <= Len( aFre_nf )
          cTransp := aFre_nf[ x, 1 ]
       endif

    Enddo

    if nTot #0 .or. nFre # 0 .or. nTotIcms # 0

       nLin := nLin + 1                             

       IF nLin > 55
          //nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15 ) + 2
          cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo )
          nLin := 9

		    SX5->(DBSETORDER(1))
		    SX5->( dbSeek( xFilial( "SX5" ) + "12" + Substr( cEstado, 1, 2 ) ) )
		    @ nLin,000   pSay "Estado.: " + Alltrim( SX5->X5_DESCRI ) + " " + Iif( Substr( cEstado, 3, 1 )=="C"," Capital",Iif( Substr( cEstado, 3, 1 )=="I"," Interior"," Outros" ) ) 
		    nLin := nLin + 2
		
           //SX5->( dbSeek( xFilial( "SX5" ) + "12"+ cEstado, .t. ) )
          //@ nLin,000   pSay "Estado.: " + Alltrim( SX5->X5_DESCRI )
          //@ nLin+2,000 pSay "Transportadora.: " + SA4->A4_NOME
       EndIf

       nPerc     := ( nTotIcms*100/nDna )

       @ nLin,00  pSay "Total "+Iif( Substr( cEstado, 3, 1 )=="C"," Capital",Iif( Substr( cEstado, 3, 1 )=="I"," Interior"," Outros" ) )
       @ nLin,17  pSay nTot      Picture "@E 999,999,999.99"
       @ nLin,37  pSay nTtpes   Picture "@E 99,999,999.99"      
       //@ nLin,37  pSay nTotPesoFrete Picture "@E 99,999.99"
       @ nLin,101 pSay nFre       Picture "@E 99,999,999.99"
       @ nLin,112 pSay nTotIcms   Picture "@E 99,999,999.99"
       @ nLin,126 pSay nPerc      Picture "@E 999.99"
       // frete real 
       nPeRe := ( nTRe*100/nDna )
       @ nLin,206 pSay nTRe       Picture "@E 99,999,999.99"
       @ nLin,217 pSay nPeRe      Picture "@E 999.99"



       nlin := nLin + 2
       nTotG     := nTotG     + nTot
       nPesG     := nPesG     + nTtpes
       nTotGIcms := nTotGIcms + nTotIcms
       nFreG     := nFreG     + nFre
       nDnaG     := nDnaG     + nDna
       nTGFrRe   := nTGFrRe   + nTRe
       
       nTot      := nFre := nTotIcms := nDna := nTRe:=nTotPesoFrete:=nTtpes:=0

      if Substr( cEstado, 3, 1 ) == "C"
       nLin += 1
         @ nLin,000 pSay PadC('-------------------------------------', 132 ) //Aqui
         nLin += 1
      endif

    endif

    if x > Len( aFre_nf ) .or. ( nTotCI #0 .or. nFreCI # 0 .or. nFreCI # 0 ) .and. cEstCI # Substr( aFre_nf[ x, 6 ], 1, 2 )

       nLin := nLin + 1

       IF nLin > 55
          //nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15 ) + 2
          cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo )
          nLin := 9

	    SX5->(DBSETORDER(1))
	    SX5->( dbSeek( xFilial( "SX5" ) + "12" + Substr( cEstado, 1, 2 ) ) )
	    @ nLin,000   pSay "Estado.: " + Alltrim( SX5->X5_DESCRI ) + " " + Iif( Substr( cEstado, 3, 1 )=="C"," Capital",Iif( Substr( cEstado, 3, 1 )=="I"," Interior"," Outros" ) ) 
	    nLin := nLin + 2
	
          //@ nLin,000   pSay "Estado.: " + Alltrim( SX5->X5_DESCRI )
          //@ nLin+2,000 pSay "Transportadora.: " + SA4->A4_NOME
       EndIf

       nPerc     := ( nTotCIicms*100/nDnaCI )
       @ nLin,000 pSay "Total do Estado"
       @ nLin,017 pSay nTotCI     Picture "@E 999,999,999.99"
       @ nLin,37  pSay nPesCI     Picture "@E 99,999,999.99"               
       @ nLin,101 pSay nFreCI     Picture "@E 99,999,999.99"
       @ nLin,112 pSay nTotCIicms Picture "@E 99,999,999.99"
       @ nLin,126 pSay nPerc      Picture "@E 999.99"
       // frete real 
       nPere:=( nTCIFrRe*100/nDnaCI )
       @ nLin,206 pSay nTCIFrRe   Picture "@E 99,999,999.99"
       @ nLin,217 pSay nPere      Picture "@E 999.99"

       nLin += 1
       @ nLin,000 pSay Replicate('-', 220 ) //Aqui
       nlin := nLin + 2
       nTotCI := nFreCI := nTotCIicms := nDnaCI := nTCIFrRe:=nPesCI:=0
       if x <= Len( aFre_nf )
          cEstCi  := Substr( aFre_nf[ x, 6 ], 1, 2 )
       endif
                          /**/
    endif

    if x <= Len( aFre_nf )
       cEstado := aFre_nf[ x, 6 ]
       ctransp := aFre_nf[ x, 1 ]
       cEstCi  := Substr( aFre_nf[ x, 6 ], 1, 2 )

       if nLin > 55
          //nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15 ) + 2
          cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo ) 
          nLin := 9
       endif
    endif 
 
    x := x - 1
    
Next

IF nLin > 55
   //nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
   cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
   nLin := 9
	 //if nLin == 7
	   //nLin += 1
	 //endif
EndIF
if len(aFre_nf) > 0

	@ nLin,00  pSay "Geral ==>"
	
	nPerc := ((nTotGIcms-nTotalAbat)*100/nDnaG )
	
	@ nLin,18  pSay nTotG     Picture "@E 9,999,999,999.99"
    @ nLin,37  pSay npesG	  Picture "@E 9,999,999,999.99"
	@ nLin,101 pSay nFreG     Picture "@E 9,999,999,999.99"
	@ nLin,113 pSay (nTotGIcms-nTotalAbat) Picture "@E 99,999,999.99"
	@ nLin,128 pSay nPerc     Picture "@E 9,999.99"
	@ nLin,194 pSay nTotalAbat Picture "@E 99,999,999.99"
    // frete real 
    nPere := ((nTGFrRe)*100/nDnaG )
	@ nLin,206 pSay (nTGFrRe) Picture "@E 999,999,999.99"
    @ nLin,217 pSay nPere     Picture "@E 999.99"

    nLin+=2
    @ nLin++,00 pSay "--Regiao--"+replicate("-",210)
    @ nLin,00  pSay "Centro-Oeste ==>"	
	nPercCE := ( nTotCEIcms*100/nDnaCE )
	@ nLin,18  pSay nTotCE     Picture "@E 999,999,999.99"
	@ nLin,37  pSay nPECE     Picture "@E 99,999,999.99"	
	@ nLin,101 pSay nFreCE     Picture "@E 99,999,999.99"
	@ nLin,113 pSay nTotCEIcms Picture "@E 99,999,999.99"  
	@ nLin,128 pSay nPercCE    Picture "@E 999.99"
    // FRETE REAL 
	nPercCE := ( nTCEfreRe*100/nDnaCE )
	@ nLin,206 pSay nTCEfreRe  Picture "@E 99,999,999.99"  
	@ nLin,217 pSay nPercCE    Picture "@E 999.99"
	nLin++
    @ nLin,00  pSay "Nordeste     ==>"	
	nPercNE := ( nTotNEIcms*100/nDnaNE )
	@ nLin,18  pSay nTotNE     Picture "@E 999,999,999.99"
	@ nLin,37  pSay nPENE     Picture "@E 99,999,999.99"	
	@ nLin,101 pSay nFreNE     Picture "@E 99,999,999.99"
	@ nLin,113 pSay nTotNEIcms Picture "@E 99,999,999.99" 
	@ nLin,128 pSay nPercNE     Picture "@E 999.99"
    // FRETE REAL 
	nPercNE := ( nTNEfreRe*100/nDnaNE )
	@ nLin,206 pSay nTNEfreRe  Picture "@E 99,999,999.99"  
	@ nLin,217 pSay nPercNE    Picture "@E 999.99"
	nLin++
    @ nLin,00  pSay "Norte        ==>"	
	nPercNO := ( nTotNOIcms*100/nDnaNO )
	@ nLin,18  pSay nTotNO     Picture "@E 999,999,999.99"
	@ nLin,37  pSay nPENO     Picture "@E 99,999,999.99"	
	@ nLin,101 pSay nFreNO     Picture "@E 99,999,999.99"
	@ nLin,113 pSay nTotNOIcms Picture "@E 99,999,999.99"
	@ nLin,128 pSay nPercNO     Picture "@E 999.99"
    // FRETE REAL 
	nPercNO := ( nTNOfreRe*100/nDnaNO )
	@ nLin,206 pSay nTNOfreRe  Picture "@E 99,999,999.99"  
	@ nLin,217 pSay nPercNO    Picture "@E 999.99"
	nLin++
    @ nLin,00  pSay "Sudeste      ==>"	
	nPercSD := ( nTotSDIcms*100/nDnaSD )
	@ nLin,18  pSay nTotSD     Picture "@E 999,999,999.99"
	@ nLin,37  pSay nPESD      Picture "@E 99,999,999.99"	
	@ nLin,101 pSay nFreSD     Picture "@E 99,999,999.99"
	@ nLin,113 pSay nTotSDIcms Picture "@E 99,999,999.99"
	@ nLin,128 pSay nPercSD     Picture "@E 999.99"
    // FRETE REAL 
	nPercSD := ( nTSDfreRe*100/nDnaSD )
	@ nLin,206 pSay nTSDfreRe  Picture "@E 99,999,999.99"  
	@ nLin,217 pSay nPercSD    Picture "@E 999.99"
	nLin++
    @ nLin,00  pSay "Sul          ==>"	
	nPercSL := ( nTotSLIcms*100/nDnaSL )
	@ nLin,18  pSay nTotSL     Picture "@E 99,999,999.99"
	@ nLin,37  pSay nPESL      Picture "@E 99,999,999.99"	
	@ nLin,101 pSay nFreSL     Picture "@E 99,999,999.99"
	@ nLin,113 pSay nTotSLIcms Picture "@E 99,999,999.99"
	@ nLin,128 pSay nPercSL    Picture "@E 999.99"
    // FRETE REAL 
	nPercSL := ( nTSLfreRe*100/nDnaSL )
	@ nLin,206 pSay nTSLfreRe  Picture "@E 99,999,999.99"  
	@ nLin++,217 pSay nPercSL    Picture "@E 999.99"
	@ nLin,00  pSay replicate("-",220)

endIf
//roda(cbcont,cbtxt,tamanho)

dbSelectArea("SF2")
/*
If aReturn[5] == 1
   dbCommitAll()
   ourspool(wnrel)
Endif
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

RetIndex( "SD2" )
Return(.T.)

***************

Static Function tipos(cNota)

***************
Local cQuery := ""
Local lValid := .F.
cQuery := " select count(*) TOTAL "
cQuery += " from  "+retSqlName("SF2")+" SF2, "+retSqlName("SD2")+" SD2, "+retSqlName("SF4")+" SF4 "
cQuery += " where F2_FILIAL = '"+xFilial("SF2")+"' "
cQuery += " and D2_FILIAL = '"+xFilial("SD2")+"' "
cQuery += " and F4_FILIAL = '"+xFilial("SF4")+"' "
cQuery += " and F2_DOC = '"+cNota+"' and F2_TIPO = 'N' "
cQuery += " and D2_DOC = F2_DOC and F4_CODIGO = D2_TES "
cQuery += " and F4_DUPLIC = '" + iif( mv_par07 == 1, 'S', 'N') + "' "
iif( mv_par07 == 3, cQuery += "and F4_CODIGO in ('507','516') ", )
cQuery += " and SF2.D_E_L_E_T_ <> '*' "
cQuery += " and SD2.D_E_L_E_T_ <> '*' "
cQuery += " and SF4.D_E_L_E_T_ <> '*' "
//MemoWrite("C:\TIPOSNF.SQL",cQuery )

TCQUERY cQuery NEW ALIAS "_TMPZ"  
_TMPZ->( dbGoTop() )
if _TMPZ->TOTAL > 0
   lValid := .T.
endIf
_TMPZ->( dbCloseArea() )
Return lValid    

***************

Static Function getReg(cUF)

***************

Local cRGNO := "AC AM AP PA RO RR TO"
Local cRGNE := "MA PI CE RN PB PE AL BA SE"
Local cRGCE := "GO MT MS DF"
Local cRGSD := "MG ES RJ SP"
Local cRGSL := "RS PR SC"

if cUF $ cRGNO
	return "NO"
elseIf cUF $ cRGNE
	return "NE"
elseIf cUF $ cRGCE
	return "CE"
elseIf cUF $ cRGSD
	return "SD"	
elseIf cUF $ cRGSL
	return "SL"				
endIf	
   
Return 

//Função Customizada para pegar Nota de abatimento - Romildo Júnior -
Static Function fBuscAbat( cNF , cCliTransp)  

Local cQuery := ""         
Local LF     := CHR(13) + CHR(10) 
Local nValTit:= 0

cQuery := "SELECT Z86_FILIAL, Z86_CONHEC, Z86_SERIE, Z86_FORNEC, Z86_LOJA, Z86_VALOR, Z86_FRETE, Z86.Z86_FRESIS, " + LF
cQuery += "Z86_GERATI, (Z86.Z86_FRETE - Z86.Z86_FRESIS) AS 'ABATIMENTO', Z87_NOTA " + LF
cQuery += "FROM Z86020 Z86, Z87020 Z87 " + LF 
//cQuery += "WHERE Z86.Z86_FILIAL = Z87.Z87_FILIAL AND Z86_CONHEC = Z87_CODCON AND " + LF
cQuery += "WHERE Z86_CONHEC = Z87_CODCON AND Z86.Z86_FILIAL = Z87.Z87_FILIAL AND Z87_NOTA = '" + Alltrim(cNf)+ "' AND " + LF
cQuery += "Z86.Z86_SERIE = Z87.Z87_SERIE AND Z87.Z87_FORNEC = Z86.Z86_FORNEC AND " + LF
cQuery += "Z86.Z86_LOJA = Z87.Z87_LOJA AND Z86.Z86_GERATI = 'S' AND Z86.D_E_L_E_T_ = '' AND Z87.D_E_L_E_T_ = '' AND " + LF
cQuery += "Z86.Z86_FILIAL = '" + xFilial("Z86")+ "' "  
//cQuery += "Z86.Z86_DATA >= '" + Dtos(mv_par01) + "' AND Z86.Z86_DATA <= '" + Dtos(mv_par02) + " '"
cQuery += "ORDER BY Z86_CONHEC "
MemoWrite("C:\TEMP\VALTITAB.SQL", cQuery)

If Select("TMX") > 0
	DbSelectArea("TMX")
	DbCloseArea()	
EndIf 

TCQUERY cQuery NEW ALIAS "TMX"
TMX->( DbGotop() )
Do While !TMX->( Eof() )
	nValTit := TMX->ABATIMENTO // fCont(nRet)
	TMX->(Dbskip())
Enddo               

Return(nValTit)

Static Function fCont(cCodCon, cSerie, cLoja, cFornec)

Local cQuery2 := ""
Local LF     := CHR(13) + CHR(10)
Local nRet := 1

cQuery2 := "SELECT COUNT(*) QTD	FROM Z87020 WHERE Z87_CODCON = '"+cCodCon+"' AND Z87_SERIE = '"+cSerie+ "' AND Z87_LOJA = '" +cLoja+ "' AND Z87_FORNEC = '"+cFornec+"' AND D_E_L_E_T_ <> '*' " + LF

TCQUERY cQuery2 NEW ALIAS "TMW"
TMW->( DbGotop() )

Do While !TMW->( Eof() )
	nRet := TMW->QTD
	TMW->(Dbskip())
Enddo 

TMW->( Dbclosearea() )

Return(nRet)  


***************

Static Function ffretRe(cDoc)

***************

local nRet:=0
local cQry:=" "


cQry:="SELECT "

cQry+="DISTINCT F1_STATUS ,Z86_CONHEC,Z86_SERIE,Z86_FORNEC,Z86_LOJA , "
cQry+="Z86_FRETE,Z86_FREPES,Z86_TXFIXA,Z86_ADVALO,Z86_GRIS,Z86_ADM,Z86_PEDAGI,Z86_SUFRAM,Z86_TDE,Z86_FRESIS,Z86_FLUVIA "

cQry+="FROM  "+retSqlName("Z86")+" Z86 ,"+retSqlName("SF1")+" SF1 ,"+retSqlName("Z87")+" Z87,"+retSqlName("SD2")+" SD2 "
cQry+="WHERE "

cQry+="Z86_FILIAL='"+xfilial('Z86')+"'    "
cQry+="AND Z86.D_E_L_E_T_ = '' " 
cQry+="AND Z86.Z86_FILIAL = SF1.F1_FILIAL  "
cQry+="AND Z86.Z86_CONHEC = SF1.F1_DOC "
cQry+="AND Z86.Z86_SERIE  = SF1.F1_SERIE "
cQry+="AND Z86.Z86_FORNEC = SF1.F1_FORNECE "
cQry+="AND Z86.Z86_LOJA   = SF1.F1_LOJA " 
cQry+="AND Z86.Z86_CONHEC = Z86.Z86_CONHEC "
cQry+="AND Z86.Z86_SERIE  = Z86.Z86_SERIE "
cQry+="AND Z86.Z86_FILIAL = Z87.Z87_FILIAL " 
cQry+="AND Z86.Z86_CONHEC = Z87.Z87_CODCON " 
cQry+="AND Z86.Z86_SERIE  = Z87.Z87_SERIE "
cQry+="AND Z86.Z86_FORNEC = Z87.Z87_FORNEC "
cQry+="AND Z86.Z86_LOJA   = Z87.Z87_LOJA "
cQry+="AND Z87_FILIAL=D2_FILIAL "
cQry+="AND Z87_NOTA = D2_DOC "

cQry+="AND D2_DOC='"+cDoc+"' "

cQry+="AND SD2.D_E_L_E_T_='' " 
cQry+="AND Z87.D_E_L_E_T_='' "
cQry+="AND SF1.D_E_L_E_T_='' "

If Select("FRA") > 0
	DbSelectArea("FRA")
	DbCloseArea()
EndIf

TCQUERY cQry NEW ALIAS "FRA"
FRA->( DbGotop() )


IF FRA->(!EOF())
   
   nRet:= FRA->Z86_FRETE/fCont(FRA->Z86_CONHEC,FRA->Z86_SERIE,FRA->Z86_LOJA,FRA->Z86_FORNEC)

ENDIF

FRA->(DBCLOSEAREA())

RETURN nRet

