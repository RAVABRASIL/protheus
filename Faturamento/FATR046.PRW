#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

***********************
User Function FATR046()
***********************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local   cDesc1      := "Este programa tem como objetivo imprimir relatorio "
Local   cDesc2      := "de acordo com os parametros informados pelo usuario."
Local   cDesc3      := "Performance de Representantes"
Local   cPict       := ""
Local   imprime     := .T.
Local   aOrd        := {}
Local   cPerg       := "FATR46"
Local   cAnoMes

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "FATR046" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "FATR046" // Coloque aqui o nome do arquivo usado para impressao em disco
Private nLin        := 999
Private titulo      := "Performance de Representantes até: "

oPerg1(cPerg)

if !Pergunte(cPerg,.T.)
   return
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint("",NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

titulo := Alltrim(titulo)+MesExtenso(MV_PAR01)+" de "+Alltrim(Str(MV_PAR02))

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,"")

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)
cAnoMes := Alltrim(Str(MV_PAR02))+StrZero(MV_PAR01,2)

RptStatus( {|| xFATR46( cAnoMes ) },Titulo )

return


********************************
static function xFATR46(cAnoMes)
********************************

Local _nX
Local cQuery
Local cAM
Local aVals  := {}
Local aTots  := {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
Local nMedia := 0
Local Cabec1 := "Gerente                                                   -------------------------------------------------------------------  VOLUME EM KG  ------------------------------------------------------------------"
Local Cabec2 := "Representante                                  UF  Linha  "
//               9999-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XX  INST   99.999  99.999  99.999  99.999  99.999  99.999  99.999  99.999  99.999  99.999  99.999  99.999  99.999  99.999  999.99
//               12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//                        1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17     
if Select("Z51X") > 0
   Z51X->(dbCloseArea())
endif

cQuery := "SELECT "
cQuery += "   Z51_COORD , COORD =(SELECT RTRIM(A3_NOME) FROM "+RetSqlName("SA3")+" WHERE A3_COD = Z51_COORD  AND D_E_L_E_T_ <> '*' ), "
cQuery += "   Z51_REPRES, REPRES=(SELECT RTRIM(A3_NOME) FROM "+RetSqlName("SA3")+" WHERE A3_COD = Z51_REPRES AND D_E_L_E_T_ <> '*' ), "
cQuery += "   Z51_UF, Z51_LINHA, META=SUM(Z51_MVALOR)/12, "

for nX_ := 11 to 0 STEP -1
   //Subtraio nX_ meses do param cAnoMes
   cAM := Left(DtoS(MonthSub( StoD(cAnoMes+"01"), nX_ )),6)     
   cQuery += "AM"+cAM+"=ISNULL((SELECT "
   cQuery += "                     SUM(VENDIDO_KG) "
   cQuery += "                  FROM "
   cQuery += "                     VENDAS_COOR_REPR "
   cQuery += "                  WHERE "
   cQuery += "                     ANOMES = '"+cAM+"' AND COORD = Z51_COORD AND REPRES = Z51_REPRES AND UF = Z51_UF AND LINHA = Z51_LINHA),0) "
   //Monto o cabecalho de acordo com os parametros selecionados
   Cabec2 += Left(MesExtenso(Right(cAM,2)),3)+"/"+Right(Left(cAM,4),2)+"     "
   if nX_ > 0
      cQuery += ", "
   endif
next _nX

cQuery += "FROM "
cQuery += "   "+RetSqlName("Z51")+ " Z51 "
cQuery += "WHERE "
cQuery += "   Z51_ANO = '"+Left(cAnoMes,4)+"' AND "
if !Empty(MV_PAR03)
   cQuery += "   Z51_COORD = '"+MV_PAR03+"' AND "
endif   
if !Empty(MV_PAR04)
   cQuery += "   Z51_REPRES = '"+MV_PAR04+"' AND "
endif   
cQuery += "   D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY "
cQuery += "   Z51_COORD, Z51_REPRES, Z51_UF, Z51_LINHA "
cQuery += "ORDER BY "
cQuery += "   Z51_COORD, Z51_UF, Z51_REPRES, Z51_LINHA  "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"Z51X",.T.,.T.)

//Ultimas colunas do Relatorio
Cabec2 += " META       MEDIA      PERC"

while !Z51X->(Eof())  
   if nLin > 55
      nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)+1
   endif   
   cCoor := Z51X->Z51_COORD
   @nLin,00 PSAY "GERENTE: "+Alltrim(Z51X->COORD);nLin++
   @nLin,00 PSAY Replicate("-",limite);nLin++
   while !Z51X->(Eof()) .and. cCoor == Z51X->Z51_COORD
      if nLin > 55
         nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)+1
         @nLin,00 PSAY "GERENTE: "+Alltrim(Z51X->COORD)+" (Continua...)";nLin++
         @nLin,00 PSAY Replicate("-",limite);nLin++         
      endif   
      cRepr := Z51X->Z51_REPRES
      @nLin,00 PSAY Alltrim(Z51X->Z51_REPRES)+"-"+Alltrim(LEFT(Z51X->REPRES,40))
      while !Z51X->(Eof()) .and. cCoor == Z51X->Z51_COORD .AND. cRepr == Z51X->Z51_REPRES
         cEst := Z51X->Z51_UF
         @nLin,47 PSAY Z51X->Z51_UF
         while !Z51X->(Eof()) .and. cCoor == Z51X->Z51_COORD .AND. cRepr == Z51X->Z51_REPRES .AND. cEst == Z51X->Z51_UF         
            if nLin > 55
               nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)+1
               @nLin,00 PSAY "GERENTE: "+Alltrim(Z51X->COORD)+" (Continua...)";nLin++
               @nLin,00 PSAY Replicate("-",limite);nLin++                     
               @nLin,00 PSAY Alltrim(Z51X->Z51_REPRES)+"-"+Alltrim(LEFT(Z51X->REPRES,40))
            endif   
            @nLin,51 PSAY Z51X->Z51_LINHA   
   
            nCol := 58
            for nX_ := 11 to 0 STEP -1
               //Subtraio nX_ meses do param cAnoMes
               cAM := Left(DtoS(MonthSub( StoD(cAnoMes+"01"), nX_ )),6)     
               Aadd( aVals, Z51X->(FieldGet(FieldPos( "AM"+cAM ))) )      
               @nLin,nCol PSAY Transform( Z51X->(FieldGet(FieldPos("AM"+cAM))), "@E 99,999" )
               aTots[nX_+1] += Z51X->(FieldGet(FieldPos("AM"+cAM)))
               nCol += 11
            next nX_   
   
            //Calculo a média somente para valores maiores que ZERO
            nMedia := MediaSe( aVals,{|x|x>0} )
            @nLin,nCol+00 PSAY Transform(Z51X->META, "@E 99,999")
            @nLin,nCol+11 PSAY Transform(nMedia, "@E 99,999")   
            @nLin,nCol+22 PSAY Transform(if(Z51X->META>0,(nMedia/Z51X->META)*100,0), "@E 999.99")      
            aTots[13] += Z51X->META
            aTots[14] += nMedia
            aVals := {}
            nLin++
            Z51X->(DbSkip())
         end
      end
      @nLin,00 PSAY Replicate("-",limite);nLin++      
   end
end

//Imprime TOTAIS
@nLin,48 PSAY "TOTAL"
nCol := 57
for nX_ := 12 to 1 STEP -1
   @nLin,nCol PSAY Transform( aTots[nX_], "@E 999,999" )
   nCol += 11
next nX_         
@nLin,nCol+00 PSAY Transform( aTots[13], "@E 999,999" )
@nLin,nCol+11 PSAY Transform( aTots[14], "@E 999,999" )

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

return
 
/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oPerg1() - Cria grupo de Perguntas.
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oPerg1(cPerg)

Local aHelpPor := {}

PutSx1( cPerg,'01','Mês (MM)  ?','','','mv_ch1','N',02,0,0,'G','',''   ,'','','mv_par01','','','','','','','','','','','','','','','','',aHelpPor,{},{} )
PutSx1( cPerg,'02','Ano (AAAA)?','','','mv_ch2','N',04,0,0,'G','',''   ,'','','mv_par02','','','','','','','','','','','','','','','','',aHelpPor,{},{} )
PutSx1( cPerg,'03','Coord.    ?','','','mv_ch3','C',06,0,0,'G','','SA3','','','mv_par03','','','','','','','','','','','','','','','','',aHelpPor,{},{} )
PutSx1( cPerg,'04','Repre.    ?','','','mv_ch4','C',06,0,0,'G','','SA3','','','mv_par04','','','','','','','','','','','','','','','','',aHelpPor,{},{} )

Return

//Funcao que calcula a media dos valores do vetor
//de acordo com a condicao passada em bCond
************************************
static function MediaSe(aVals,bCond)
************************************

Local nSoma := 0
Local nItem := 0
Local bSoma := { |nValor,nPos| if(bCond<>nil,if( Eval( bCond, nValor ),(nSoma += nValor, nItem++),),(nSoma += nValor, nItem++)) }
aEval(aVals,bSoma)
//MsgInfo(nSoma/nItem,"Media Calculada")
return (nSoma/nItem)


**************************
Static Function Scheddef() 
**************************
Local aParam
Local aOrd     := {}

aParam := { "R",;      // Tipo R para relatorio P para processo   
            "FATR46",; // Pergunte do relatorio, caso nao use passar ParamDef            
            "",;       // Alias            
            aOrd,;     // Array de ordens   
            "FATR046 SchedDef"}    
Return aParam