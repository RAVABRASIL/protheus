#include "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"
#include "font.ch"
#include "colors.ch"
#include "Ap5mail.ch"
 
                /*
                continuar  no Sy1  query   
                */

User Function PCPR011()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relação de Solicitações e Pedidos de Compra em andamento"
Local cPict          := ""
Local titulo         := "Analise de Inspeções"//+ PERIODO...
Local nLin           := 80
//                                                                                                                          1         1         1         1         1         1         1         1         1
                       //         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0
                       //         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |
                       //123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
  Local Cabec1       :=   "     Produto       |     Item           |   Data   |Turno | Observação                                                                                                                                  |"
//Local Cabec1         := "         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |"
//Local Cabec2         := "123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"
  Local Cabec2       :=   "                   |                    |          |      |                                                                                                                                             |"         
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 130 //220
Private tamanho      := "G" //"G"
Private nomeprog     := "PCPR011" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PCPR011" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""
Private cPerg	:= "PCPR011"
Public extende:= 40
 
 Pergunte( cPerg ,.F. )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  10/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
 */

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

local cQuery:=''  
Titulo:=ALLTRIM(Titulo) +"    De: "+dtoc(MV_PAR01)+"       Ate: "+dtoc(MV_PAR02) 

SetRegua(0)
/*
cQuery := ""
cQuery += " select        "  +chr(10)
cQuery += "    Z60_EXTRUS EXT   ,  " +chr(10)
cQuery += "    Z60_PRODUT PROD  ,  "  +chr(10)
cQuery += "    Z60_ITEMD  DESCRI,  "  +chr(10)
cQuery += "    Z60_DATAI  DAT   ,  "  +chr(10)
cQuery += "    UPPER(RTRIM(LTRIM(Z60_OBS)))OBS ,"+chr(10)
cQuery += " case when CAST(SUBSTRING(Z60_HORAI,1,2) AS INT )<13 "+chr(10)
cQuery += " THEN 'A' ELSE 'B'  END TURNO                        "+chr(10)
cQuery += " from "+RetSqlName("Z60")+"                          "+chr(10)
cQuery += " WHERE D_E_L_E_T_=''                                 "+chr(10)
cQuery += "    AND Z60_OBS!=''                                     "+chr(10)
cQuery += "    AND Z60_DATAI BETWEEN "+valtosql(MV_PAR01)+ " AND " +valtosql(MV_PAR01) +chr(10)
cQuery += "    OR Z60_PENDEN='S'                                   "+chr(10)
cQuery += "    AND Z60_DATAI BETWEEN "+valtosql(MV_PAR02)+ " AND " +valtosql(MV_PAR01) +chr(10)
cQuery += " ORDER BY Z60_EXTRUS,TURNO                           "+chr(10)
*/


cQuery := "SELECT Z60_EXTRUS EXT   , Z60_PRODUT PROD  , Z60_ITEMD  DESCRI, Z60_DATAI  DAT   , UPPER(RTRIM(LTRIM(Z60_OBS)))OBS ,Z60_HORAI HORA, " + CHR(13) + CHR(10)
/*
cQuery += "CASE WHEN Z60.Z60_DATAI+Z60.Z60_HORAI >= '"+Dtos(MV_PAR01)+"05:50' AND Z60.Z60_DATAI+Z60.Z60_HORAI <= '"+Dtos(MV_PAR01)+"13:54' THEN '1' ELSE "
cQuery += "CASE WHEN Z60.Z60_DATAI+Z60.Z60_HORAI >= '"+Dtos(MV_PAR01)+"13:55' AND Z60.Z60_DATAI+Z60.Z60_HORAI <= '"+Dtos(MV_PAR01)+"21:59' THEN '2' ELSE "
cQuery += "CASE WHEN Z60.Z60_DATAI+Z60.Z60_HORAI >= '"+Dtos(MV_PAR01)+"22:00' AND Z60.Z60_DATAI+Z60.Z60_HORAI <= '"+Dtos(MV_PAR02+1)+"05:49' THEN '3'  "
cQuery += "ELSE 'ERRO' END END END AS TURNO "
*/
cQuery += "CASE WHEN Z60.Z60_HORAI >= '05:50' AND Z60.Z60_HORAI <= '13:54' THEN '1'  " + CHR(13) + CHR(10)
cQuery += "ELSE CASE WHEN Z60.Z60_HORAI >= '13:55' AND Z60.Z60_HORAI <= '21:59' THEN '2'  " + CHR(13) + CHR(10)
cQuery += "ELSE CASE WHEN ((Z60.Z60_HORAI >= '22:00' AND Z60.Z60_HORAI <= '24:00' ) OR( Z60.Z60_HORAI >= '00:00' AND Z60.Z60_HORAI <= '05:49')) THEN '3' " + CHR(13) + CHR(10)
cQuery += "ELSE 'ERRO' END END END AS TURNO  " + CHR(13) + CHR(10)

cQuery += "FROM " + RetSqlName("Z60") + "  Z60 "  + CHR(13) + CHR(10)
cQuery += "WHERE " + CHR(13) + CHR(10)
cQuery += "Z60.D_E_L_E_T_='' " + CHR(13) + CHR(10)
//FR - 22/05/13 - Solicitado por Renata, Chamado 397:
cQuery += " AND Z60_ITEMD NOT LIKE 'MAQUINA PARADA?' " + CHR(13) + CHR(10)

cQuery += "AND ( Z60.Z60_OBS!='' OR Z60.Z60_PENDEN='S' ) " + CHR(13) + CHR(10)
cQuery += "AND Z60.Z60_DATAI+Z60.Z60_HORAI  >= '"+Dtos(MV_PAR01)+"05:50' AND Z60.Z60_DATAI+Z60.Z60_HORAI <= '"+Dtos(MV_PAR02+1)+"05:49' " + CHR(13) + CHR(10)
cQuery += "AND Z60.Z60_PRODUT >= '"+ALLTRIM(MV_PAR03)+"' AND Z60.Z60_PRODUT <= '"+ALLTRIM(MV_PAR04)+"' " + CHR(13) + CHR(10)
cQuery += "GROUP BY Z60_EXTRUS, Z60_ITEMD , Z60_PRODUT  , Z60_DATAI , UPPER(RTRIM(LTRIM(Z60_OBS))) ,Z60_HORAI, " + CHR(13) + CHR(10)
/*
cQuery += "CASE WHEN Z60.Z60_DATAI+Z60.Z60_HORAI >= '"+Dtos(MV_PAR01)+"05:50' AND Z60.Z60_DATAI+Z60.Z60_HORAI <= '"+Dtos(MV_PAR01)+"13:54' THEN '1' ELSE "
cQuery += "CASE WHEN Z60.Z60_DATAI+Z60.Z60_HORAI >= '"+Dtos(MV_PAR01)+"13:55' AND Z60.Z60_DATAI+Z60.Z60_HORAI <= '"+Dtos(MV_PAR01)+"21:59' THEN '2' ELSE "
cQuery += "CASE WHEN Z60.Z60_DATAI+Z60.Z60_HORAI >= '"+Dtos(MV_PAR01)+"22:00' AND Z60.Z60_DATAI+Z60.Z60_HORAI <= '"+Dtos(MV_PAR02+1)+"05:49' THEN '3'  "
cQuery += "ELSE 'ERRO' END END END "
*/ 
cQuery += "CASE WHEN Z60.Z60_HORAI >= '05:50' AND Z60.Z60_HORAI <= '13:54' THEN '1'  " + CHR(13) + CHR(10)
cQuery += "ELSE CASE WHEN Z60.Z60_HORAI >= '13:55' AND Z60.Z60_HORAI <= '21:59' THEN '2'  " + CHR(13) + CHR(10)
cQuery += "ELSE CASE WHEN ((Z60.Z60_HORAI >= '22:00' AND Z60.Z60_HORAI <= '24:00' ) OR( Z60.Z60_HORAI >= '00:00' AND Z60.Z60_HORAI <= '05:49')) THEN '3' " + CHR(13) + CHR(10)
cQuery += "ELSE 'ERRO' END END END " + CHR(13) + CHR(10)
cQuery += "ORDER BY Z60_EXTRUS, Z60_ITEMD, Z60_DATAI, Z60_HORAI "
MemoWrite("C:\TEMP\PCPR011.SQL" , cQuery )

TCQUERY cQuery NEW ALIAS "TMP1"
TMP1->( DbGoTop() )
aVetor:={}
While TMP1->( !EOF() ) 
   if nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      nLin := Cabec(Titulo ,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 2
   Endif
   cExt:= TMP1->EXT
   @nLin++,000 psay cExt  
   while TMP1->( !EOF() ) .AND. cExt== TMP1->EXT  
      incregua()
      if nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
         nLin := Cabec(Titulo ,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 2
      endif
      @nLin ,000    PSAY Cabec2
      @nLin ,000    PSAY replicate("_",160+extende)
      @nLin ,000+6  PSAY PROD
      @nLin ,015+6  PSAY DESCRI 
      @nLin ,037+6  PSAY dtoc(stod(DAT)) 
      @nLin ,048+6  PSAY TURNO   
      @nLin ,055+6  PSAY OBS 
      nLin++
      TMP1->(DbSkip())
  EndDo
EndDo
TMP1->(DbCloseArea()) 
 

	  
	 
	      
	           


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