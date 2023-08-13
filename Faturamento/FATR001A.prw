#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO17    º Autor ³ AP6 IDE            º Data ³  26/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATR001()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Previsao de entrega Transportadora "
Local cPict          := ""
Local titulo         := "Previsao de entrega Transportadora "
Local nLin           := 80

Local Cabec1         := "N Danfe    Valor           QTD Volumes      Peso            Localidade                   UF Emissao  Prev. Entrega   Segmento                                    Cliente"
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "FATR001" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATR001" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

Pergunte("FATR001",.F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"FATR001",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  26/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local CQry:=''
Local nQTD:=0
Local nTotV:=nTotQ:=nTotP:=0  
Local nTotGV := 0
Local nTotGQ := 0
Local nTotGP := 0
Local dPrevisao := CtoD("  /  /    ")

///modificado por Flávia Rocha para adequar o relatório a nova sistemática de pós-vendas (Call Center)
CQry:=" SELECT A1_SATIV1,SF2.F2_TRANSP, SA4.A4_NOME, SA4.A4_EMAIL, F2_EMISSAO,SF2.F2_DOC,SF2.F2_SERIE, "
CQry+=" SA1.A1_MUN, SF2.F2_EST, SF2.F2_PBRUTO, SF2.F2_VALBRUT, SF2.F2_DTEXP, SF2.F2_REDESP, SF2.F2_LOCALIZ, "
//CQry+="A4_DIATRAB,ZZ_PRZENT,Z04_DATSAI,A1_NOME  "
CQry+=" A4_DIATRAB,ZZ_PRZENT,F2_DTEXP ,A1_NOME  "

CQry+=" FROM " + RetSqlName('SF2') + " SF2 "
CQry+=" JOIN " + RetSqlName('SA4') + " SA4 ON SF2.F2_TRANSP = SA4.A4_COD  "
CQry+=" AND SA4.A4_FILIAL = '" + xFilial( "SA4" ) + "'  "
CQry+=" AND SA4.D_E_L_E_T_ = ' ' "

CQry+=" JOIN " + RetSqlName('SA1') + " SA1 ON  SF2.F2_CLIENTE = SA1.A1_COD "
CQry+=" AND SF2.F2_LOJA = SA1.A1_LOJA "
CQry+=" AND SA1.A1_FILIAL = '" + xFilial( "SA1" ) + "'  "
CQry+=" AND SA1.A1_SATIV1 >= '" + MV_PAR05 + "' AND A1_SATIV1 <=  '" + MV_PAR06 + "' "
CQry+=" AND SA1.D_E_L_E_T_ = ' ' "

CQry+=" JOIN " + RetSqlName('SZZ') + " SZZ ON SF2.F2_TRANSP = SZZ.ZZ_TRANSP " 
CQry+=" AND SZZ.ZZ_LOCAL = SF2.F2_LOCALIZ   "
CQry+=" AND SZZ.ZZ_FILIAL = '" + xFilial( "SZZ" ) + "'  "
CQry+=" AND SZZ.D_E_L_E_T_ = ' ' "

//CQry+="LEFT JOIN " + RetSqlName('Z04') + " Z04 ON Z04_DOC=F2_DOC  "
//CQry+="AND Z04.Z04_FILIAL = '" + xFilial( "Z04" ) + "'  "
//CQry+="AND Z04.D_E_L_E_T_ = ' '  "

CQry+=" WHERE F2_SERIE <> '' "
CQry+=" AND SF2.F2_EMISSAO >= '" + DTOS(MV_PAR01) + "' AND F2_EMISSAO <=  '" + DTOS(MV_PAR02) + "' "
CQry+=" AND SF2.F2_TRANSP  >= '" + MV_PAR03 + "' AND F2_TRANSP <=  '" + MV_PAR04 + "' " 
CQry+=" AND SF2.F2_FILIAL = '" + xFilial( "SF2" ) + "' " 
CQry+=" AND SF2.D_E_L_E_T_ = ' '  "
CQry+=" GROUP BY A1_SATIV1,SF2.F2_TRANSP, SA4.A4_NOME, SA4.A4_EMAIL, F2_EMISSAO,SF2.F2_DOC,SF2.F2_SERIE, SA1.A1_MUN, "
CQry+=" SF2.F2_EST, SF2.F2_PBRUTO, SF2.F2_VALBRUT, SF2.F2_DTEXP, SF2.F2_REDESP, SF2.F2_LOCALIZ, A4_DIATRAB, "
CQry+=" ZZ_PRZENT,F2_DTEXP ,A1_NOME "
CQry+=" ORDER BY F2_TRANSP,F2_REDESP, F2_DOC " 
MemoWrite("\Temp\fatr001.sql", CQry )

TCQUERY CQry NEW ALIAS "TRAX"

TCSetField( "TRAX", "F2_EMISSAO", "D")
TCSetField( "TRAX", "F2_DTEXP"  , "D")

TRAX->( DbGoTop() )

SetRegua(0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("SX5")
DbSetOrder(1)


While TRAX->( !EOF() )

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

   If Empty( TRAX->F2_REDESP )
   		cNum  := TRAX->F2_TRANSP
   		cNome := Alltrim( TRAX->A4_NOME )
   Else
       DbselectArea("SA4")
       SA4->(Dbsetorder(1))
       If SA4->(Dbseek(xFilial("SA4") + TRAX->F2_REDESP ))
       		cNum := TRAX->F2_REDESP
       		cNome:= "*" + SA4->A4_NOME
       Endif
       	
   Endif
   nTotV := nTotQ:=nTotP:=0
  
   @nLin++,00 PSAY cNome

   Do While ! TRAX->( EoF() ) .AND. ( iif( Empty(TRAX->F2_REDESP), TRAX->F2_TRANSP == cNum, TRAX->F2_REDESP == cNum) )
     If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	      nLin := 8
	   Endif
     dPrevisao := CtoD("  /  /    ")
     dPrevisao := U_fGetPrazo( TRAX->F2_DOC, TRAX->F2_SERIE, TRAX->F2_TRANSP, TRAX->F2_REDESP, TRAX->F2_LOCALIZ)
     //Msgbox("dprevisao-->" + dtoc(dPrevisao) )
     
     SX5->(DbSeek(xFilial("SX5")+'T3'+TRAX->A1_SATIV1  ) )
     nQTD:=QTDVOL(TRAX->F2_DOC,TRAX->F2_SERIE)
     @nLin,00 PSAY TRAX->F2_DOC +space(1)+TRANSFORM(TRAX->F2_VALBRUT,"@E 999,999,999.9999")+space(1)+;
              TRANSFORM(nQTD,"@E 999,999,999.9999")+space(1)+; 
              TRANSFORM(TRAX->F2_PBRUTO,"@E 999,999,999.9999")+space(1)+;
              TRAX->A1_MUN+" - "+ALLTRIM(TRAX->F2_EST)+space(1)+;  
              DtoC(TRAX->F2_EMISSAO)+space(1)+; 
              IIF( !EMPTY( dPrevisao),;
              DtoC( dPrevisao ),'**/**/**')+space(9)+;         
              SUBSTR(SX5->X5_DESCRI,1,41)+space(2)+;
              TRAX->A1_NOME
              
              //U_CalPrv(dDatsai, cDiatrab, nPrzent)
              //U_DadosAdc2( cNF, cSerie, cTransp, cRedesp )  
              
     nTotV+=TRAX->F2_VALBRUT
     nTotQ+=nQTD
     nTotP+=TRAX->F2_PBRUTO
     
   	 nTotGV += TRAX->F2_VALBRUT //totalizador geral de Valor Bruto da NF
   	 nTotGQ += nQTD //totalizador geral de Qtde de Produtos na NF
   	 nTotGP += TRAX->F2_PBRUTO //totalizador geral  de Peso Bruto
   	 
     nLin := nLin + 1 // Avanca a linha de impressao
     TRAX->( dbSkip() ) // Avanca o ponteiro do registro no arquivo
  
   EndDo
   @nLin++,00 PSAY space(10)+Replicate("-",16)+space(1)+Replicate("-",16)+space(1)+Replicate("-",16)
   @nLin++,00 PSAY "Total:    "+TRANSFORM( nTotV,"@E 999,999,999.9999")+space(1)+TRANSFORM( nTotQ,"@E 999,999,999.9999")+space(1)+TRANSFORM( nTotP,"@E 999,999,999.9999") 
   @nLin++
EndDo
//TOTAL GERAL 
//FLAVIA ROCHA - solicitado no chamado 00000266 - 20/05/13
nLin++
nLin++
@nLin,000 Psay Replicate("-",limite)
nLin++
@nLin++,00    PSAY "Total Geral:"+TRANSFORM( nTotGV,"@E 999,999,999.9999")+space(1)+TRANSFORM( nTotGQ,"@E 999,999,999.9999")+space(1)+TRANSFORM( nTotGP,"@E 999,999,999.9999") 
nLin++
Roda(0, "" , Tamanho)
TRAX->( DbCloseArea() )

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

Return


***************

Static Function CalcPrv(dDatsai, cDiatrab, nPrzent)

**************

  Local x := 1
  Local dData := dDatsai

  IF cDiatrab == alltrim(str(3))
    dData += nPrzent + 1  // a pedido de alexandre 001370 em 16/10/2009
  Else
    while( x <= nPrzent )

      IF (dData == DataValida(dData) )
        dData++
        x++
      ElseIF DataValida(dData) - dData >= 2
        DO CASE
          CASE cDiatrab == alltrim(str(1)) //seg ate sexta
            dData := DataValida(dData)
            IF x == 1 //dayanne colocando saídas aos sábados de empresas que trabalham em 1
              x++
            ENDIF
          CASE cDiatrab == alltrim(str(2)) //seg ate sabado
            dData++
            x++
            /*Modificado*/
            IF (x > nPrzent) .AND. (dow(dData) == 1)
              dData++
            ENDIF
            /*Aqui*/
        ENDCASE
      Else
        dData := DataValida(dData)
      ENDIF
    EndDo
  Endif

  //dData++ 
  //o dData++ foi Retirado a pedido de Daniela em 10/10/08, chamado 591
  //o dData++ foi recolocado a pedido de Alexandre em 09/01/09, chamado 790
  x := 1

  while (x <= 2) .AND. (dData != DataValida(dData))

  //IF dData != DataValida(dData)
    DO CASE
      CASE cDiatrab == alltrim(str(1))
        IF dow(dData) == 1
          dData := DataValida(dData) + 1
        else
          dData := DataValida(dData)
        EndIf
      CASE cDiatrab == alltrim(str(2))
        IF dow(dData) != 7 //diferente de sábado
          dData := DataValida(dData)
        /*Else //talvez isso dê erro, pois a entrega pode ser feita no sábado.
          dData++*/
        ENDIF
    EndCase

  //ENDIF
  x++
  EndDo

Return dData


***************

Static Function QTDVOL(cDoc,cSerie)

***************

Local cQry:=''
Local nTotQt := 0
Local cProd:=''

CQry+="SELECT D2_DOC,D2_SERIE,D2_COD,D2_QUANT FROM  " + RetSqlName('SD2') + " SD2 "
CQry+="WHERE D2_DOC='" +cDoc+ "' "
CQry+="AND D2_SERIE='" +cSerie+ "' "
CQry+="AND D2_FILIAL ='" + xFilial( "SD2" ) + "' "
CQry+="AND SD2.D_E_L_E_T_!='*' "
TCQUERY CQry NEW ALIAS "AUUX"

AUUX->( DbGoTop() )       

Do While ! AUUX->( EoF() )

	If Len( Alltrim( AUUX->D2_COD ) ) <= 7
		cProd := AUUX->D2_COD
	Else
		If Subs( AUUX->D2_COD, 5, 1 ) == "R"
			cProd := Padr( Subs( AUUX->D2_COD, 1, 1 ) + Subs( AUUX->D2_COD, 3, 4 ) + Subs( AUUX->D2_COD, 8, 2 ), 15 )
		Else
			cProd := Padr( Subs( AUUX->D2_COD, 1, 1 ) + Subs( AUUX->D2_COD, 3, 3 ) + Subs( AUUX->D2_COD, 7, 2 ), 15 )
		EndIf
	EndIf
	
	dbselectarea( 'SB5' )
	SB5->( dbsetorder( 1 ) )
	SB5->( DbSeek( xFilial('SB5') + cProd ) )
	
	nTotQt += AUUX->D2_QUANT/(SB5->B5_QTDFIM/SB5->B5_QE2)
	
	AUUX->( DbSkip() )

EndDo
AUUX->( DbCloseArea() ) 

return nTotQt


***************************************************

User Function fGetPrazo( cNF, cSerie, cTransp, cRedesp, cLocaliz )

***************************************************

Local dPrev 	:= CtoD("  /  /    ")
Local lTemSZZ 	:= .F.                               
Local cLocaHum 	:= ""
Local cTransphum:= ""
Local cDiatrab	:= ""
Local nZZprazo	:= 0
Local cQuery	:= ""

If !Empty( cRedesp)
   
    cQuery := " select SZZ.ZZ_FILIAL, SZZ.ZZ_TRANSP, SZZ.ZZ_LOCAL "
	cQuery += " from " + RetSqlName("SZZ") +" SZZ "
	cQuery += " where "
	cQuery += " SZZ.ZZ_TRANSP = '" + cRedesp + "' "
	cQuery += " and SZZ.ZZ_LOCAL = '" + cLocaliz + "' "
	cQuery += " and SZZ.D_E_L_E_T_ = ' '  "
	cQuery += " and SZZ.ZZ_FILIAL = '"  + xFilial("SZZ") + "'  "
//	MemoWrite("\Temp\fGetSZZ.SQL",cQuery)
	cQuery := ChangeQuery( cQuery )
	If Select("SZZXX") > 0
		DbSelectArea("SZZXX")
		DbCloseArea()	
	EndIf 

	TCQUERY cQuery NEW ALIAS "SZZXX"
	SZZXX->( DbGotop() )
	If !SZZXX->( Eof() )
      	lTemSZZ := .T.
	Endif
Endif

//DbSelectArea("SZZXX")
//DbCloseArea()	


///////

If Empty( cRedesp )
	cQuery := " select SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_EMISSAO, SF2.F2_DTEXP, SZZ.ZZ_PRZENT, SA4.A4_COD, SA4.A4_DIATRAB "
	cQuery += " from " + RetSqlName("SF2") +" SF2, " + RetSqlName("SA4") + " SA4, " + RetSqlName("SZZ") + " SZZ "
	cQuery += " where "
	cQuery += " SF2.F2_TRANSP = SA4.A4_COD "
	cQuery += " and SF2.F2_TRANSP = SZZ.ZZ_TRANSP "
	cQuery += " and SF2.F2_TIPO = 'N' "
	cQuery += " and SZZ.ZZ_LOCAL = SF2.F2_LOCALIZ "
	cQuery += " and SF2.F2_DOC = '" + cNF + "' "
	cQuery += " and SF2.F2_SERIE = '" + cSerie + "' "
	cQuery += " and SF2.F2_TRANSP = '" + cTransp + "' "
	cQuery += " and SF2.F2_SERIE != ' '   "
	cQuery += " and SF2.D_E_L_E_T_ = ' '  "
	cQuery += " and SA4.D_E_L_E_T_  = ' ' "
	cQuery += " and SZZ.D_E_L_E_T_ = ' '  "
	cQuery += " and SF2.F2_FILIAL  = '" + xFilial("SF2") + "' "
	cQuery += " and SA4.A4_FILIAL = '"  + xFilial("SA4")  + "' "
	cQuery += " and SZZ.ZZ_FILIAL = '"  + xFilial("SZZ") + "'  "
	cQuery += " Group by SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_EMISSAO, SF2.F2_DTEXP, SZZ.ZZ_PRZENT, SA4.A4_COD, SA4.A4_DIATRAB "
	cQuery += "order by SF2.F2_DOC, SF2.F2_SERIE"
Else
	cQuery := " select SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_EMISSAO, SF2.F2_DTEXP, SZZ.ZZ_PRZENT, SA4.A4_COD, SA4.A4_DIATRAB "
	cQuery += " from " + RetSqlName("SF2") +" SF2, " + RetSqlName("SA4") + " SA4, " + RetSqlName("SZZ") + " SZZ "
	cQuery += " where "
	cQuery += " SF2.F2_REDESP = SA4.A4_COD "
	cQuery += " and SF2.F2_REDESP = SZZ.ZZ_TRANSP "
	cQuery += " and SF2.F2_TIPO = 'N' "
	cQuery += " and SZZ.ZZ_LOCAL = SF2.F2_LOCALIZ "
	cQuery += " and SF2.F2_DOC = '" + cNF + "' "
	cQuery += " and SF2.F2_SERIE = '" + cSerie + "' "
	cQuery += " and SF2.F2_REDESP = '" + cRedesp + "' "
	cQuery += " and SF2.F2_SERIE != ' '   "
	cQuery += " and SF2.D_E_L_E_T_ = ' '  "
	cQuery += " and SA4.D_E_L_E_T_  = ' ' "
	cQuery += " and SZZ.D_E_L_E_T_ = ' '  "
	cQuery += " and SF2.F2_FILIAL  = '" + xFilial("SF2") + "' "
	cQuery += " and SA4.A4_FILIAL = '"  + xFilial("SA4")  + "' "
	cQuery += " and SZZ.ZZ_FILIAL = '"  + xFilial("SZZ") + "'  "
	cQuery += " Group by SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_EMISSAO, SF2.F2_DTEXP, SZZ.ZZ_PRZENT, SA4.A4_COD, SA4.A4_DIATRAB "
	cQuery += "order by SF2.F2_DOC, SF2.F2_SERIE"

Endif
//MemoWrite("\Temp\fGetPrazo.SQL",cQuery)
cQuery := ChangeQuery( cQuery )
If Select("SF2A") > 0
	DbSelectArea("SF2A")
	DbCloseArea()	
EndIf 

TCQUERY cQuery NEW ALIAS "SF2A"
TCSetField( 'SF2A', "F2_EMISSAO", "D")
TCSetField( 'SF2A', "F2_DTEXP", "D")

SF2A->( DbGotop() )

dPrev := CtoD("  /  /    ")
cA4Diatrab := ""

Do While ! SF2A->( Eof() )

	If !Empty( SF2A->F2_DTEXP )
		If !Empty( cRedesp ) 			
						
				cLocahum		:= "07"			//Se for redespacho, irá assumir o local Recife como primeiro cálculo de prazo   	
		     	cTransphum		:= "47    "		//Irá pegar o prazo da ALD para o redespacho para Recife
		     	DbselectArea("SA4")
		     	Dbsetorder(1)
		     	SA4->(Dbseek(xFilial("SA4") + cTransphum ))
		     	cDiatrab := SA4->A4_DIATRAB
		     	
		     	DbselectArea("SZZ")
		     	SZZ->(Dbsetorder(1))
		       	SZZ->(Dbseek(xFilial("SZZ") + cTransphum + cLocahum ))       		
		       		nZZprazo := SZZ->ZZ_PRZENT + SF2A->ZZ_PRZENT         		//soma o prazo da primeira transportadora mais o da segunda.
		       		dPrev := U_CalPrv( SF2A->F2_DTEXP, cDiatrab, nZZprazo )  	//caso não encontre o cadastro da 2a. transp. no SZZ, irá assumir
																				//o prazo da primeira. 		
	    Else
	    	dPrev := U_CalPrv( SF2A->F2_DTEXP, SF2A->A4_DIATRAB, SF2A->ZZ_PRZENT )  //caso não encontre o cadastro da 2a. transp. no SZZ, irá assumir
																							//o prazo da primeira.
	    Endif
	    
	Else	
		dPrev := CtoD("  /  /    ")		
	Endif
    
	SF2A->(DBSKIP())
Enddo

//DbselectArea("SF2A")
//DbcloseArea()

Return( dPrev )
