#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PCPR029  º Autor ³ AP6 IDE            º Data ³  10/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PCPR029()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local aFab           := {'Saco','Caixa'}
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Informativo PCP"
Local cPict          := ""

Local nLin           := 80
Local LF      	:= CHR(13)+CHR(10)
                     //            10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       200                 210
                     //  01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Local Cabec1         := "Linha          SubLinha       Estoque        Carteira       Carteira       Faturamento    Producao                                                                                                                                                                "
Local Cabec2         := "                                             Imediata       Programada                                                                                                                                                                                   "
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "PCPR029" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PCPR029" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

Private cTURNO1   := GetMv("MV_TURNO1")
Private cTURNO2   := GetMv("MV_TURNO2")
Private cTURNO3   := GetMv("MV_TURNO3")



hora1:=Left(cTURNO1,5)
hora2:=Left(cTURNO2,5)
hora3:=Left(cTURNO3,5)


titulo         := "Informativo PCP"


Pergunte('PCPR029',.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"PCPR029",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

titulo         := "Informativo PCP   "+aFab[MV_PAR02]+'  '+Dtoc(MV_PAR01)

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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  10/01/14   º±±
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
Local cQry:=''
Local cTipo:='S' // Saco 
Local nCol:=0
Local cLinha:=''
// total ´por linha
Local nTotLEst:=0
Local nTotLCarI:=0
Local nTotLCarP:=0
Local nTotLFat:=0
Local nTotLProd:=0
// total greal
Local nTotGEst:=0
Local nTotGCarI:=0
Local nTotGCarP:=0
Local nTotGFat:=0
Local nTotGProd:=0
Local LF      	:= CHR(13)+CHR(10)

if MV_PAR02=2 // Caixa
   cTipo:='C'
EndIF

if Select("TMPX") > 0
	DbSelectArea("TMPX")
	TMPX->(DbCloseArea())
endif



cQry:="SELECT "
cQry+="LINHA, "
cQry+="SUBLINHA, "
cQry+="isnull(dbo.sc_Est_linha(LINHA,SUBLINHA,'"+cTipo+"'),0) AS ESTOQUE,  "
cQry+="isnull(dbo.sc_Cart_linha(LINHA,SUBLINHA,'"+Dtos( mv_par01)+"','"+cTipo+"','I',''),0) AS CARTEIRA_IMEDIATA, "
cQry+="isnull(dbo.sc_Cart_linha(LINHA,SUBLINHA,'"+Dtos( mv_par01)+"','"+cTipo+"','P','"+dtos( Lastday( mv_par01 ) )+"'),0) AS CARTEIRA_PROGRAMADA, "
cQry+="isnull(dbo.sc_Fat_linha(LINHA,SUBLINHA,'"+cTipo+"','"+dtos( Firstday( mv_par01 ) )+"','"+Dtos( mv_par01)+"'),0) AS FATURAMENTO, "
cQry+="isnull(dbo.sc_Prod_linha(LINHA,SUBLINHA,'"+dtos( Firstday( mv_par01 ) )+"','"+cTipo+"','"+Dtos( mv_par01+1 )+"'),0) AS PRODUCAO "
cQry+="FROM ( "
cQry+="SELECT "
cQry+=" LINHA=  CASE   "
cQry+="           WHEN B1_GRUPO IN('D','E') THEN 'DOMESTICA' "
cQry+="           WHEN B1_GRUPO IN('A','B','G') THEN 'INSTITUCIONAL'  "
cQry+="           WHEN B1_GRUPO IN('C') THEN 'HOSPITALAR' "            
cQry+="           ELSE B1_GRUPO  "
cQry+="         END, "
cQry+="   SUBLINHA=CASE  "
cQry+="              WHEN B1_SETOR IN ('05','37','40') THEN 'Hamper Fita' "
cQry+="              WHEN B1_SETOR IN ('56') THEN 'Hamper Cordão' "   
cQry+="              WHEN B1_SETOR IN ('08','09','10','11','12','13','14','30','34','35','36','41','55') THEN 'Infectantes' "
cQry+="              WHEN B1_SETOR IN ('06','54','98') THEN 'Obitos' "             
cQry+="              WHEN B1_SETOR IN ('23') THEN 'D. Limpeza' "                    
cQry+="              WHEN B1_SETOR IN ('24','25') THEN 'D. Limpeza Rolo' "                                      
cQry+="              WHEN B1_SETOR IN ('26','27','28') THEN 'Brasileirinho'  "                   
cQry+="              WHEN B1_SETOR IN ('31','32') THEN 'Pacote'  "
cQry+="              WHEN B1_SETOR IN ('33') THEN 'Rolo' "                 
cQry+="              ELSE 'Outros' "
cQry+="             END  "
             
cQry+="FROM SB1010 SB1 WITH (NOLOCK) "
cQry+="WHERE   "
if MV_PAR02=02 // caixa
   cQry+="B1_GRUPO IN('A','B','G','D','E','C','ME','0008') "
else
   cQry+="B1_GRUPO IN('A','B','G','D','E','C','ME') "
Endif

cQry+="AND B1_TIPO IN ('PA','ME') "
cQry+="AND B1_ATIVO='S' "
cQry+="AND SB1.D_E_L_E_T_='' "
cQry+=")AS TABX  "
cQry+="group by LINHA,SUBLINHA  "
cQry+="order by LINHA,SUBLINHA "


TCQUERY cQry NEW ALIAS "TMPX"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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

TMPX->(dbGoTop())
While TMPX->(!EOF())

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
      nLin := 9
   Endif
    
   cLinha:=TMPX->LINHA
   // total ´por linha
   nTotLEst:=0
   nTotLCarI:=0
   nTotLCarP:=0
   nTotLFat:=0
   nTotLProd:=0

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   While TMPX->(!EOF()) .AND. TMPX->LINHA==cLinha
	    nCol:=00
	    @nLin,nCol PSAY TMPX->LINHA
	    nCol+=15
	    @nLin,nCol PSAY TMPX->SUBLINHA
	    nCol+=15
	    @nLin,nCol PSAY transform( TMPX->ESTOQUE,"@E 99,999,999.99")
	    nCol+=15
	    @nLin,nCol PSAY transform( TMPX->CARTEIRA_IMEDIATA,"@E 99,999,999.99")
	    nCol+=15
	    @nLin,nCol PSAY transform( TMPX->CARTEIRA_PROGRAMADA,"@E 99,999,999.99")
	    nCol+=15
	    @nLin,nCol PSAY transform( TMPX->FATURAMENTO,"@E 99,999,999.99")        
	    nCol+=15
	    @nLin++,nCol PSAY transform( TMPX->PRODUCAO,"@E 99,999,999.99")        
	    // total ´por linha
	    nTotLEst+= TMPX->ESTOQUE
	    nTotLCarI+= TMPX->CARTEIRA_IMEDIATA
	    nTotLCarP+= TMPX->CARTEIRA_PRGRAMADA
	    nTotLFat+= TMPX->FATURAMENTO	    
	    nTotLProd+= TMPX->PRODUCAO	    
	    // total greal 
	    nTotGEst+= TMPX->ESTOQUE
	    nTotGCarI+= TMPX->CARTEIRA_IMEDIATA
	    nTotGCarP+= TMPX->CARTEIRA_PRGRAMADA
	    nTotGFat+= TMPX->FATURAMENTO	    
	    nTotGProd+= TMPX->PRODUCAO	    
	    IncRegua()
	   TMPX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
   EndDo
	    nCol:=00
	    @nLin,nCol PSAY cLinha
	    nCol:=15	    
	    @nLin,nCol PSAY 'Total'	    
	    nCol+=15
	    @nLin,nCol PSAY transform( nTotLEst,"@E 99,999,999.99")
	    nCol+=15
	    @nLin,nCol PSAY transform( nTotLCarI,"@E 99,999,999.99")
	    nCol+=15
	    @nLin,nCol PSAY transform( nTotLCarP,"@E 99,999,999.99")
	    nCol+=15
	    @nLin,nCol PSAY transform( nTotLFat,"@E 99,999,999.99")        
	    nCol+=15
	    @nLin,nCol PSAY transform( nTotLProd,"@E 99,999,999.99")                
        @nLin++,00 PSAY replicate('_',103)
EndDo
TMPX->(DbCloseArea())
@nLin,00 PSAY 'Total'
nCol:=15	    
@nLin,nCol PSAY 'Geral'
nCol+=15
@nLin,nCol PSAY transform( nTotGEst,"@E 99,999,999.99")
nCol+=15
@nLin,nCol PSAY transform( nTotGCarI,"@E 99,999,999.99")
nCol+=15
@nLin,nCol PSAY transform( nTotGCarP,"@E 99,999,999.99")
nCol+=15
@nLin,nCol PSAY transform( nTotGFat,"@E 99,999,999.99")
nCol+=15
@nLin++,nCol PSAY transform( nTotGProd,"@E 99,999,999.99")
@nLin++
@nLin++
// informacao detalhada pelo produto
if MV_PAR02=2 // CAIXA
   fInfoProd(@nLin)
   @nLin++
   @nLin++
Endif
// legenda 
@nLin++,00 PSAY 'Estoque Atual'
@nLin++,00 PSAY 'Carteira Imediata ate '+Dtoc(MV_PAR01)
IF mv_par01=Lastday( mv_par01 )
   @nLin++,00 PSAY 'Carteira Programada de '+Dtoc(Lastday( mv_par01 ))+' Ate '+ dtoc( Lastday( mv_par01 ) )
ELSE
   @nLin++,00 PSAY 'Carteira Programada de '+Dtoc(MV_PAR01+1)+' Ate '+ dtoc( Lastday( mv_par01 ) )
ENDIF

@nLin++,00 PSAY 'Faturamento De '+dtoc(Firstday( mv_par01 ))+' Ate '+ dtoc(mv_par01)
@nLin++,00 PSAY 'Producao De '+dtoc(Firstday(mv_par01 ))+' Ate '+ dtoc( mv_par01)


cQry:=" SELECT C6_NUM, A1_NOME, " + LF
cQry+="  LINHA=CASE  " + LF
cQry+="            WHEN B1_GRUPO IN('D','E') THEN 'DOMESTICA' " + LF 
cQry+="            WHEN B1_GRUPO IN('A','B','G') THEN 'INSTITUCIONAL' " + LF 
cQry+="            WHEN B1_GRUPO IN('C') THEN 'HOSPITALAR' " + LF           
cQry+="            ELSE B1_GRUPO  " + LF
cQry+="          END, " + LF
cQry+="    SUBLINHA=CASE " + LF 
cQry+="               WHEN B1_SETOR IN ('05','37','40') THEN 'Hamper Fita' " + LF 
cQry+="               WHEN B1_SETOR IN ('56') THEN 'Hamper Cordão'  " + LF   
cQry+="               WHEN B1_SETOR IN ('08','09','10','11','12','13','14','30','34','35','36','41','55') THEN 'Infectantes'  " + LF
cQry+="               WHEN B1_SETOR IN ('06','54','98') THEN 'Obitos'  " + LF             
cQry+="               WHEN B1_SETOR IN ('23') THEN 'D. Limpeza' " + LF                     
cQry+="               WHEN B1_SETOR IN ('24','25') THEN 'D. Limpeza Rolo'  " + LF                                      
cQry+="               WHEN B1_SETOR IN ('26','27','28') THEN 'Brasileirinho'  " + LF                    
cQry+="               WHEN B1_SETOR IN ('31','32') THEN 'Pacote' " + LF
cQry+="               WHEN B1_SETOR IN ('33') THEN 'Rolo'  " + LF                 
cQry+="               ELSE 'Outros'  " + LF
cQry+="              END,  " + LF      
cQry+=" SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) /(CASE WHEN 'S' = 'S' THEN SB1.B1_CONV ELSE 1 END ) ) AS CARTEIRA_KG " + LF
cQry+=" FROM SB1010 SB1 WITH (NOLOCK), SC5020 SC5 WITH (NOLOCK), SC6020 SC6 WITH (NOLOCK), SC9020 SC9 WITH (NOLOCK), SA1010 SA1 WITH (NOLOCK)  " + LF
cQry+=" WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND  " + LF
cQry+=" SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND  " + LF
cQry+=" SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND " + LF 
cQry+=" SC9.C9_BLCRED IN( ' ','04') and SC9.C9_BLEST != '10' AND  " + LF
cQry+=" SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND " + LF
cQry+=" ( ( 'S' = 'S' AND SB1.B1_SETOR <> '39' ) OR ( 'S' = 'C' AND SB1.B1_SETOR = '39' ) ) AND " + LF
cQry+=" ( ( 'I' = 'I' AND SC5.C5_ENTREG <='20180425' ) OR ( 'I' = 'P' AND SC5.C5_ENTREG > '20180401' AND SC5.C5_ENTREG <= '20180425' ) ) AND " + LF  
cQry+=" SC6.C6_TES != '540' AND  " + LF
cQry+=" SC5.C5_FILIAL = SC6.C6_FILIAL AND " + LF
cQry+=" SC6.C6_FILIAL = SC9.C9_FILIAL AND " + LF
cQry+=" SC6.C6_CLI NOT IN ('031732','031733') AND  " + LF
cQry+=" SB1.B1_FILIAL = ' ' AND SB1.D_E_L_E_T_ = '' AND  " + LF
cQry+=" SC5.D_E_L_E_T_ = '' AND  " + LF
cQry+=" SC6.D_E_L_E_T_ = '' AND  " + LF
cQry+=" SC9.D_E_L_E_T_ = '' AND  " + LF
cQry+=" SA1.A1_FILIAL = ' ' AND SA1.D_E_L_E_T_ = ''  " + LF
cQry+=" group by  C6_NUM, A1_NOME, " + LF
cQry+=" 		CASE  " + LF
cQry+="            WHEN B1_GRUPO IN('D','E') THEN 'DOMESTICA'  " + LF
cQry+="            WHEN B1_GRUPO IN('A','B','G') THEN 'INSTITUCIONAL'  " + LF
cQry+="            WHEN B1_GRUPO IN('C') THEN 'HOSPITALAR'  " + LF          
cQry+="            ELSE B1_GRUPO  " + LF
cQry+="           END, " + LF
cQry+="           CASE  " + LF
cQry+="               WHEN B1_SETOR IN ('05','37','40') THEN 'Hamper Fita'  " + LF
cQry+="               WHEN B1_SETOR IN ('56') THEN 'Hamper Cordão' " + LF    
cQry+="               WHEN B1_SETOR IN ('08','09','10','11','12','13','14','30','34','35','36','41','55') THEN 'Infectantes'  " + LF
cQry+="               WHEN B1_SETOR IN ('06','54','98') THEN 'Obitos'   " + LF            
cQry+="               WHEN B1_SETOR IN ('23') THEN 'D. Limpeza'     " + LF                 
cQry+="               WHEN B1_SETOR IN ('24','25') THEN 'D. Limpeza Rolo'   " + LF                                     
cQry+="               WHEN B1_SETOR IN ('26','27','28') THEN 'Brasileirinho'   " + LF                   
cQry+="               WHEN B1_SETOR IN ('31','32') THEN 'Pacote' " + LF
cQry+="               WHEN B1_SETOR IN ('33') THEN 'Rolo'    " + LF               
cQry+="               ELSE 'Outros' " + LF 
cQry+="           END " + LF
cQry+=" ORDER BY C6_NUM "


MemoWrite("C:\TEMP\detped.SQL", cQry)

TCQUERY cQry NEW ALIAS "TMP5"   


Do While  TMP5->(!EOF())
   
   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9
   Endif	
	
	nCol:=0
	@nLin,00 PSAY TMPY->PRODUTO
	nCol+=30
	@nLin,nCol PSAY transform( TMP5->ESTOQUE,"@E 99,999,999.99")
	nCol+=15
	@nLin,nCol PSAY transform( TMP5->CARTEIRA_IMEDIATA,"@E 99,999,999.99")
	nCol+=15
	@nLin,nCol PSAY transform( TMP5->CARTEIRA_PROGRAMADA,"@E 99,999,999.99")
	nCol+=15
	@nLin,nCol PSAY transform( TMP5->FATURAMENTO,"@E 99,999,999.99")
	nCol+=15
	@nLin++,nCol PSAY transform( TMP5->PRODUCAO,"@E 99,999,999.99")
	// total greal
	nTotGEst+=TMP5->ESTOQUE
	nTotGCarI+=TMP5->CARTEIRA_IMEDIATA
	nTotGCarP+=TMP5->CARTEIRA_PROGRAMADA
	nTotGFat+=TMP5->FATURAMENTO
	nTotGProd+= TMP5->PRODUCAO	
	TMP5->(Dbskip())
EndDo

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

Static Function fInfoProd(nLin)

***************
Local cQry:=''
// total greal
Local nTotGEst:=0
Local nTotGCarI:=0
Local nTotGCarP:=0
Local nTotGFat:=0
Local nTotGProd:=0 
Local LF := CHR(13) + CHR(10)

if Select("TMPY") > 0
	DbSelectArea("TMPY")
	TMPY->(DbCloseArea())
endif

// consulta 
cQry:=" SELECT  " + LF
cQry+=" PRODUTO,  "  + LF
cQry+=" SUM(ESTOQUE) AS ESTOQUE, " + LF
cQry+=" SUM(CARTEIRA_IMEDIATA) AS CARTEIRA_IMEDIATA, " + LF
cQry+=" SUM(CARTEIRA_PROGRAMADA) AS CARTEIRA_PROGRAMADA, " + LF
cQry+=" SUM(FATURAMENTO) AS FATURAMENTO, " + LF
cQry+=" SUM(PESO) AS PRODUCAO " + LF
cQry+=" FROM ( " + LF
cQry+=" SELECT  " + LF
cQry+=" isnull(ltrim(rtrim(( CASE WHEN LEN(B1_COD)>=8 THEN   " + LF
cQry+=" CASE when (Substring( B1_COD, 4, 1 ) = 'R') or  (Substring( B1_COD, 5, 1 ) = 'R')  " + LF
cQry+=" then SUBSTRING(B1_COD,1,1)+SUBSTRING(B1_COD,3,4)+SUBSTRING(B1_COD,8,2)   " + LF
cQry+=" else SUBSTRING(B1_COD,1,1)+SUBSTRING(B1_COD,3,3)+SUBSTRING(B1_COD,7,2) end  " + LF
cQry+=" ELSE B1_COD END ))) ,'') AS PRODUTO, " + LF
cQry+=" ISNULL(SUM(SB2.B2_QATU ),0) AS ESTOQUE, " + LF
cQry+="'0' AS CARTEIRA_IMEDIATA, " + LF
cQry+="'0' AS CARTEIRA_PROGRAMADA, " + LF
cQry+="'0' AS FATURAMENTO, " + LF
cQry+="'0' AS PESO " + LF

cQry+=" FROM " + RetSqlname("SB2") + " SB2 WITH (NOLOCK), SB1010 SB1 WITH (NOLOCK)  " + LF

cQry+=" WHERE SB2.B2_COD = SB1.B1_COD AND SB2.B2_LOCAL = '01'  " + LF
cQry+=" AND SB1.B1_ATIVO = 'S' AND SB1.B1_TIPO = 'PA'  " + LF
cQry+=" AND LEN(SB1.B1_COD) <= 7  " + LF
cQry+=" AND SB1.B1_SETOR = '39'  " + LF
cQry+=" AND SB2.D_E_L_E_T_ = ''  " + LF 
///FILIAL
cQry+=" AND SB2.B2_FILIAL = '03' " + LF //FR

cQry+=" and SB1.B1_GRUPO <> 'F' " + LF
cQry+=" AND SB1.B1_COD <> 'CXPAD' " + LF
cQry+=" AND SB1.B1_FILIAL = '  ' AND SB1.D_E_L_E_T_ = ''  " + LF
cQry+=" GROUP BY ISNULL(ltrim(rtrim(( CASE WHEN LEN(B1_COD)>=8 THEN   " + LF
cQry+=" CASE when (Substring( B1_COD, 4, 1 ) = 'R') or  (Substring( B1_COD, 5, 1 ) = 'R')  " + LF
cQry+=" then SUBSTRING(B1_COD,1,1)+SUBSTRING(B1_COD,3,4)+SUBSTRING(B1_COD,8,2)  "  + LF
cQry+=" else SUBSTRING(B1_COD,1,1)+SUBSTRING(B1_COD,3,3)+SUBSTRING(B1_COD,7,2) end  " + LF
cQry+=" ELSE B1_COD END ))) ,'') " + LF
cQry+=" UNION  " + LF
cQry+=" SELECT  " + LF
cQry+=" isnull(ltrim(rtrim(( CASE WHEN LEN(B1_COD)>=8 THEN   " + LF
cQry+=" CASE when (Substring( B1_COD, 4, 1 ) = 'R') or  (Substring( B1_COD, 5, 1 ) = 'R')  " + LF
cQry+=" then SUBSTRING(B1_COD,1,1)+SUBSTRING(B1_COD,3,4)+SUBSTRING(B1_COD,8,2) "   + LF
cQry+=" else SUBSTRING(B1_COD,1,1)+SUBSTRING(B1_COD,3,3)+SUBSTRING(B1_COD,7,2) end  " + LF
cQry+=" ELSE B1_COD END ))) ,'') AS PRODUTO, " + LF
cQry+=" '0' AS ESTOQUE, " + LF
cQry+=" SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) ) AS CARTEIRA_IMEDIATA, " + LF
cQry+=" '0' AS CARTEIRA_PROGRAMADA, " + LF
cQry+=" '0' AS FATURAMENTO, " + LF
cQry+=" '0' AS PESO " + LF
cQry+=" FROM SB1010 SB1 WITH (NOLOCK), " + Retsqlname("SC5") + " SC5 WITH (NOLOCK), "  + LF
cQry+=" " + Retsqlname("SC6") + "  SC6 WITH (NOLOCK), " + Retsqlname("SC9") + "  SC9 WITH (NOLOCK), SA1010 SA1 WITH (NOLOCK)  " + LF
cQry+=" WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND  " + LF
cQry+=" SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND  " + LF
cQry+=" SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND  " + LF
cQry+=" SC5.C5_FILIAL = SC6.C6_FILIAL AND " + LF //FR
cQry+=" SC9.C9_FILIAL = SC6.C6_FILIAL AND " + LF //FR
//filial
cQry+=" SC5.C5_FILIAL = '03' AND " + LF //FR 

cQry+=" SC9.C9_BLCRED IN( ' ','04') and SC9.C9_BLEST != '10' AND  " + LF
cQry+=" SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND " + LF
cQry+=" SB1.B1_SETOR = '39' AND  " + LF
cQry+=" SC5.C5_ENTREG <='"+dtos(mv_par01)+"' AND  " + LF
cQry+=" SC6.C6_TES != '540' AND  " + LF
cQry+=" SC6.C6_CLI NOT IN ('031732','031733') AND  " + LF
cQry+=" SB1.B1_FILIAL = ' ' AND SB1.D_E_L_E_T_ = '' AND " + LF 
cQry+=" SC5.D_E_L_E_T_ = '' AND  " + LF
cQry+=" SC6.D_E_L_E_T_ = '' AND  " + LF
cQry+=" SC9.D_E_L_E_T_ = '' AND  " + LF
cQry+=" SA1.A1_FILIAL = ' ' AND SA1.D_E_L_E_T_ = ''  " + LF
cQry+=" GROUP BY isnull(ltrim(rtrim(( CASE WHEN LEN(B1_COD)>=8 THEN   " + LF
cQry+=" CASE when (Substring( B1_COD, 4, 1 ) = 'R') or  (Substring( B1_COD, 5, 1 ) = 'R')  " + LF
cQry+=" then SUBSTRING(B1_COD,1,1)+SUBSTRING(B1_COD,3,4)+SUBSTRING(B1_COD,8,2)  "  + LF
cQry+=" else SUBSTRING(B1_COD,1,1)+SUBSTRING(B1_COD,3,3)+SUBSTRING(B1_COD,7,2) end  " + LF
cQry+=" ELSE B1_COD END ))) ,'')   " + LF
cQry+=" UNION "  + LF
cQry+=" SELECT  " + LF
cQry+=" isnull(ltrim(rtrim(( CASE WHEN LEN(B1_COD)>=8 THEN   " + LF
cQry+=" CASE when (Substring( B1_COD, 4, 1 ) = 'R') or  (Substring( B1_COD, 5, 1 ) = 'R')  " + LF
cQry+=" then SUBSTRING(B1_COD,1,1)+SUBSTRING(B1_COD,3,4)+SUBSTRING(B1_COD,8,2)   " + LF
cQry+=" else SUBSTRING(B1_COD,1,1)+SUBSTRING(B1_COD,3,3)+SUBSTRING(B1_COD,7,2) end  " + LF
cQry+=" ELSE B1_COD END ))),'') AS PRODUTO,  " + LF
cQry+=" '0' AS ESTOQUE,  " + LF
cQry+=" '0' AS CARTEIRA_IMEDIATA, " + LF
cQry+=" SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) ) AS CARTEIRA_PROGRAMADA, " + LF
cQry+=" '0' AS FATURAMENTO, " + LF
cQry+=" '0' AS PESO " + LF
cQry+=" FROM SB1010 SB1 WITH (NOLOCK), " + RetSqlname("SC5") + " SC5 WITH (NOLOCK), "  + LF
cQry+=" " + Retsqlname("SC6") + "  SC6 WITH (NOLOCK), " + Retsqlname("SC9") + "  SC9 WITH (NOLOCK), SA1010 SA1 WITH (NOLOCK)  " + LF
cQry+=" WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND  " + LF
cQry+=" SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND  " + LF
cQry+=" SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND  " + LF
cQry+=" SC5.C5_FILIAL = SC6.C6_FILIAL AND " + LF //FR
cQry+=" SC9.C9_FILIAL = SC6.C6_FILIAL AND " + LF //FR
//filial
cQry+=" SC5.C5_FILIAL = '03' AND " + LF //FR 

cQry+=" SC9.C9_BLCRED IN( ' ','04') and SC9.C9_BLEST != '10' AND  " + LF
cQry+=" SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND " + LF
cQry+=" SB1.B1_SETOR = '39' AND  " + LF
cQry+=" SC5.C5_ENTREG BETWEEN '"+dtos(mv_par01+1)+"' AND '"+dtos( Lastday( mv_par01 ) )+"' AND   " + LF
cQry+=" SC6.C6_TES != '540' AND  " + LF
cQry+=" SC6.C6_CLI NOT IN ('031732','031733') AND  " + LF
cQry+=" SB1.B1_FILIAL = ' ' AND SB1.D_E_L_E_T_ = '' AND  " + LF
cQry+=" SC5.D_E_L_E_T_ = '' AND  " + LF
cQry+=" SC6.D_E_L_E_T_ = '' AND  " + LF
cQry+=" SC9.D_E_L_E_T_ = '' AND  " + LF
cQry+=" SA1.A1_FILIAL = ' ' AND SA1.D_E_L_E_T_ = ''  " + LF
cQry+=" GROUP BY isnull(ltrim(rtrim(( CASE WHEN LEN(B1_COD)>=8 THEN   " + LF
cQry+=" CASE when (Substring( B1_COD, 4, 1 ) = 'R') or  (Substring( B1_COD, 5, 1 ) = 'R')  " + LF
cQry+=" then SUBSTRING(B1_COD,1,1)+SUBSTRING(B1_COD,3,4)+SUBSTRING(B1_COD,8,2) "   + LF
cQry+=" else SUBSTRING(B1_COD,1,1)+SUBSTRING(B1_COD,3,3)+SUBSTRING(B1_COD,7,2) end  " + LF
cQry+=" ELSE B1_COD END ))),'')   " + LF
cQry+=" UNION  " + LF
cQry+=" SELECT  " + LF
cQry+=" isnull(ltrim(rtrim(( CASE WHEN LEN(B1_COD)>=8 THEN   " + LF
cQry+=" CASE when (Substring( B1_COD, 4, 1 ) = 'R') or  (Substring( B1_COD, 5, 1 ) = 'R')  " + LF
cQry+=" then SUBSTRING(B1_COD,1,1)+SUBSTRING(B1_COD,3,4)+SUBSTRING(B1_COD,8,2)  "  + LF
cQry+=" else SUBSTRING(B1_COD,1,1)+SUBSTRING(B1_COD,3,3)+SUBSTRING(B1_COD,7,2) end  " + LF
cQry+=" ELSE B1_COD END ))) ,'') AS PRODUTO,   " + LF
cQry+=" '0' AS ESTOQUE, " + LF
cQry+=" '0' AS CARTEIRA_IMEDIATA, " + LF
cQry+=" '0' AS CARTEIRA_PROGRAMADA, " + LF
//FR - 29/05/14 - GLENNYSON PEDIU QUE CONSIDERASSE OS VD's, então coloquei por parâmetro, o usuário escolhe Sim / Não Considera
If MV_PAR03 = 2  //NÃO CONSIDERA VD
	cQry+=" FATURAMENTO= SUM(CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN (0) ELSE ((D2_QUANT-D2_QTDEDEV)) END), " + LF
Else
	cQry+=" FATURAMENTO = SUM( (D2_QUANT-D2_QTDEDEV) ), " + LF
Endif
cQry+=" '0' AS PESO  " + LF
cQry+=" FROM " + RetSqlname("SD2") + "  SD2 WITH (NOLOCK), SB1010 SB1 WITH (NOLOCK), " + Retsqlname("SF2") + "  SF2 WITH (NOLOCK)  " + LF
cQry+=" WHERE D2_EMISSAO BETWEEN '"+dtos( Firstday( mv_par01 ) )+"' and '"+dtos(mv_par01)+"'  " + LF
cQry+=" AND D2_TIPO = 'N'  " + LF
cQry+=" AND D2_TP != 'AP'  " + LF
cQry+=" and B1_SETOR = '39' " + LF
cQry+=" AND RTRIM(D2_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','6118','6923' )  " + LF
cQry+=" AND D2_CLIENTE NOT IN ('031732','031733') " + LF
cQry+=" AND SD2.D_E_L_E_T_ = '' AND D2_COD = B1_COD "  + LF
cQry+=" AND SB1.D_E_L_E_T_ = ''  " + LF
cQry+=" AND D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA = F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA  " + LF
//filial
cQry+=" AND SD2.D2_FILIAL = SF2.F2_FILIAL " + LF
cQry+=" AND SD2.D2_FILIAL = '03' " + LF //FR 

//cQry+=" AND F2_DUPL <> ' '  " + LF //FR - em 29/05/14 GLENNYSON PEDIU QUE MOSTRASSE AS NOTAS DE VENDA CTA E ORDEM (NÃO GERA DUPLICATA)

cQry+=" AND SF2.D_E_L_E_T_ = ''  " + LF
cQry+=" GROUP BY isnull(ltrim(rtrim(( CASE WHEN LEN(B1_COD)>=8 THEN   " + LF
cQry+=" CASE when (Substring( B1_COD, 4, 1 ) = 'R') or  (Substring( B1_COD, 5, 1 ) = 'R')  " + LF
cQry+=" then SUBSTRING(B1_COD,1,1)+SUBSTRING(B1_COD,3,4)+SUBSTRING(B1_COD,8,2)   " + LF
cQry+=" else SUBSTRING(B1_COD,1,1)+SUBSTRING(B1_COD,3,3)+SUBSTRING(B1_COD,7,2) end  " + LF
cQry+=" ELSE B1_COD END ))),'')   " + LF
cQry+=" UNION  " + LF
cQry+=" SELECT " + LF
cQry+=" isnull(ltrim(rtrim(( CASE WHEN LEN(B1_COD)>=8 THEN   " + LF
cQry+=" CASE when (Substring( B1_COD, 4, 1 ) = 'R') or  (Substring( B1_COD, 5, 1 ) = 'R')  " + LF
cQry+=" then SUBSTRING(B1_COD,1,1)+SUBSTRING(B1_COD,3,4)+SUBSTRING(B1_COD,8,2)   " + LF
cQry+=" else SUBSTRING(B1_COD,1,1)+SUBSTRING(B1_COD,3,3)+SUBSTRING(B1_COD,7,2) end  " + LF
cQry+=" ELSE B1_COD END ))) ,'') AS PRODUTO,   " + LF
cQry+=" '0' AS ESTOQUE, " + LF
cQry+=" '0' AS CARTEIRA_IMEDIATA, " + LF
cQry+=" '0' AS CARTEIRA_PROGRAMADA, " + LF
cQry+=" '0' AS FATURAMENTO,  " + LF
cQry+=" ISNULL(SUM(Z00.Z00_QUANT),0) AS PESO " + LF
cQry+=" FROM " + Retsqlname("Z00") + "  Z00 WITH (NOLOCK), " + Retsqlname("SC2") + "  SC2 WITH (NOLOCK),  SB1010 SB1 WITH (NOLOCK) " + LF
cQry+=" WHERE Z00_FILIAL = '' "  + LF
cQry+=" AND C2_PRODUTO=B1_COD  " + LF
cQry+=" AND Z00_OP=C2_NUM+C2_ITEM+C2_SEQUEN  " + LF
cQry+=" AND Z00.Z00_DATHOR >=  '"+dtos( Firstday( mv_par01 ) )+hora1+"' AND Z00.Z00_DATHOR < '"+dtos(mv_par01+1)+hora1+"' " + LF
cQry+=" AND Z00.Z00_MAQ  IN ('MONT')  "                                               + LF
cQry+=" AND Z00.Z00_APARA = '' AND Z00.D_E_L_E_T_ = '' " + LF
cQry+=" AND SB1.D_E_L_E_T_='' " + LF
cQry+=" AND SC2.D_E_L_E_T_='' " + LF
cQry+=" GROUP BY ISNULL(ltrim(rtrim(( CASE WHEN LEN(B1_COD)>=8 THEN "  + LF
cQry+=" CASE when (Substring( B1_COD, 4, 1 ) = 'R') or  (Substring( B1_COD, 5, 1 ) = 'R') " + LF
cQry+=" then SUBSTRING(B1_COD,1,1)+SUBSTRING(B1_COD,3,4)+SUBSTRING(B1_COD,8,2) "  + LF
cQry+=" else SUBSTRING(B1_COD,1,1)+SUBSTRING(B1_COD,3,3)+SUBSTRING(B1_COD,7,2) end " + LF
cQry+=" ELSE B1_COD END ))) ,  '') " + LF
cQry+=" ) AS TABX  " + LF
cQry+=" GROUP  BY PRODUTO " + LF
cQry+=" ORDER  BY PRODUTO " + LF
MemoWrite("C:\TEMP\FINFOPROD.SQL", cQry)

TCQUERY cQry NEW ALIAS "TMPY"   


Do While  TMPY->(!EOF())
   
   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9
   Endif	
	
	nCol:=0
	@nLin,00 PSAY TMPY->PRODUTO
	nCol+=30
	@nLin,nCol PSAY transform( TMPY->ESTOQUE,"@E 99,999,999.99")
	nCol+=15
	@nLin,nCol PSAY transform( TMPY->CARTEIRA_IMEDIATA,"@E 99,999,999.99")
	nCol+=15
	@nLin,nCol PSAY transform( TMPY->CARTEIRA_PROGRAMADA,"@E 99,999,999.99")
	nCol+=15
	@nLin,nCol PSAY transform( TMPY->FATURAMENTO,"@E 99,999,999.99")
	nCol+=15
	@nLin++,nCol PSAY transform( TMPY->PRODUCAO,"@E 99,999,999.99")
	// total greal
	nTotGEst+=TMPY->ESTOQUE
	nTotGCarI+=TMPY->CARTEIRA_IMEDIATA
	nTotGCarP+=TMPY->CARTEIRA_PROGRAMADA
	nTotGFat+=TMPY->FATURAMENTO
	nTotGProd+= TMPY->PRODUCAO	
	TMPY->(Dbskip())
EndDo
nCol:=0
@nLin,00 PSAY "Total: "
nCol+=30
@nLin,nCol PSAY transform( nTotGEst,"@E 99,999,999.99")
nCol+=15
@nLin,nCol PSAY transform( nTotGCarI,"@E 99,999,999.99")
nCol+=15
@nLin,nCol PSAY transform( nTotGCarP,"@E 99,999,999.99")
nCol+=15
@nLin,nCol PSAY transform( nTotGFat,"@E 99,999,999.99")
nCol+=15
@nLin++,nCol PSAY transform( nTotGProd,"@E 99,999,999.99")
TMPY->(DbCloseArea())

Return 