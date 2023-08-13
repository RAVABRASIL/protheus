#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     º Autor ³ AP6 IDE            º Data ³  05/03/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
*************

User Function ESTQMOV()

*************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       	:= ""
Local nLin         	:= 80
Local Cabec1       	:= ""
Local Cabec2       	:= ""
Local imprime      	:= .T.
Local aOrd 				:= {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "ESTQMOV" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "ESTQMOV" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 		:= ""
Pergunte( "ESTQMO", .T. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := "Consulta de movimentações no intervalo de "+dtoc(mv_par01)+" até "+dtoc(mv_par02)+". "
wnrel := SetPrint(cString,NomeProg,"ESTQMO",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  05/03/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

***************

Static Function RunReport( Cabec1, Cabec2, Titulo, nLin )

***************

Local nOrdem
Local cCod := cQuery := ''
Local aQry := {}
//Cabec1       	:= "Consulta de movimentações no intervalo de "+dtoc(mv_par01)+" até "+dtoc(mv_par02)+". "
Cabec1       	:= "Codigo do Produto  |  Descrição do Produto "
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(3)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ QUERIES -> TODAS AS QUERIES NAS TABELAS SD1, SD2 e SD3              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                               
cQuery := "select  distinct ( case when len(D1_COD) >= 8 then "
cQuery += "		case when ( SUBSTRING( D1_COD, 4, 1 ) = 'R') or ( SUBSTRING( D1_COD, 5, 1 ) = 'R') "
cQuery += "			then SUBSTRING( D1_COD, 1, 1) + SUBSTRING( D1_COD, 3, 4) + SUBSTRING( D1_COD, 8, 2) "
cQuery += "			else SUBSTRING( D1_COD, 1, 1) + SUBSTRING( D1_COD, 3, 3) + SUBSTRING( D1_COD, 7, 2) end "
cQuery += "		else D1_COD END ) as D1_COD, B1_DESC  "
cQuery += "from   " + retSqlName('SD1') + " SD1, " + retSqlName('SF4') + " SF4, " + retSqlName('SB1') +" SB1 "
cQuery += "where  SD1.D1_FILIAL = '"+xFilial('SD1')+"' and SF4.F4_FILIAL = '"+xFilial('SF4')+"' and SB1.B1_FILIAL = '"+xFilial('SB1')+"' "
cQuery += "       and SD1.D1_TES = SF4.F4_CODIGO and SD1.D1_COD = SB1.B1_COD "
cQuery += "       and SF4.F4_ESTOQUE = 'S' and SD1.D1_DTDIGIT between '"+dtos(mv_par01)+"' and '"+dtos(mv_par02)+"' "
cQuery += "       and SB1.B1_TIPO = '"+MV_PAR03+"' "
cQuery += "       and SD1.D_E_L_E_T_ != '*' and SF4.D_E_L_E_T_ != '*' and SB1.D_E_L_E_T_ != '*' "
cQuery += "order by D1_COD asc "
TCQUERY cQuery NEW ALIAS 'TMPA'
TMPA->( dbGoTop() )
do while ! TMPA->( EoF() )
	if aScan(aQry, { |x| x[1] == TMPA->D1_COD } ) == 0
		aAdd(aQry,  { TMPA->D1_COD, TMPA->B1_DESC } )
	endIf
	TMPA->( dbSkip() )
	cCod := ''
endDo
incRegua()

cQuery := "select  distinct ( case when len(D2_COD) >= 8 then "
cQuery += "		case when ( SUBSTRING( D2_COD, 4, 1 ) = 'R') or ( SUBSTRING( D2_COD, 5, 1 ) = 'R') "
cQuery += "			then SUBSTRING( D2_COD, 1, 1) + SUBSTRING( D2_COD, 3, 4) + SUBSTRING( D2_COD, 8, 2) "
cQuery += "			else SUBSTRING( D2_COD, 1, 1) + SUBSTRING( D2_COD, 3, 3) + SUBSTRING( D2_COD, 7, 2) end "
cQuery += "		else D2_COD END ) as D2_COD, B1_DESC  "
cQuery += "from   " + retSqlName('SD2') + " SD2, " + retSqlName('SF4') + " SF4, " + retSqlName('SB1') + " SB1 "
cQuery += "where  SD2.D2_FILIAL = '"+xFilial('SD2')+"' and SF4.F4_FILIAL = '"+xFilial('SF4')+"' and SB1.B1_FILIAL = '"+xFilial('SB1')+"' "
cQuery += "       and SD2.D2_TES = SF4.F4_CODIGO and SD2.D2_COD = SB1.B1_COD "
cQuery += "       and SF4.F4_ESTOQUE = 'S' and SD2.D2_EMISSAO between '"+dtos(mv_par01)+"' and '"+dtos(mv_par02)+"' "
cQuery += "       and SB1.B1_TIPO = '"+MV_PAR03+"' "
cQuery += "       and SD2.D_E_L_E_T_ != '*' and SF4.D_E_L_E_T_ != '*' and SB1.D_E_L_E_T_ != '*' "
cQuery += "order by D2_COD asc "
TCQUERY cQuery NEW ALIAS 'TMPB'
TMPB->( dbGoTop() )
do while ! TMPB->( EoF() )
	if aScan(aQry, { |x| x[1] == TMPB->D2_COD } ) == 0
		aAdd( aQry, { TMPB->D2_COD, TMPB->B1_DESC } )
	endIf
	TMPB->( dbSkip() )
	cCod := ''
endDo
incRegua()

cQuery := "select  distinct ( case when len(D3_COD) >= 8 then "
cQuery += "		case when ( SUBSTRING( D3_COD, 4, 1 ) = 'R') or ( SUBSTRING( D3_COD, 5, 1 ) = 'R') "
cQuery += "			then SUBSTRING( D3_COD, 1, 1) + SUBSTRING( D3_COD, 3, 4) + SUBSTRING( D3_COD, 8, 2) "
cQuery += "			else SUBSTRING( D3_COD, 1, 1) + SUBSTRING( D3_COD, 3, 3) + SUBSTRING( D3_COD, 7, 2) end "
cQuery += "		else D3_COD END ) as D3_COD, B1_DESC  "
cQuery += "from   " + retSqlName('SD3') + " SD3, " + retSqlName('SB1') + " SB1 "
cQuery += "where  SD3.D3_FILIAL = '"+xFilial('SD3')+"' and SB1.B1_FILIAL = '"+xFilial('SB1')+"' "
cQuery += "       and SD3.D3_COD = SB1.B1_COD and SD3.D3_EMISSAO between '"+dtos(mv_par01)+"' and '"+dtos(mv_par02)+"' and SB1.B1_TIPO = '"+MV_PAR03+"' "
cQuery += "       and SD3.D_E_L_E_T_ != '*' and SB1.D_E_L_E_T_ != '*' "
cQuery += "order by D3_COD asc "
TCQUERY cQuery NEW ALIAS 'TMPC'
TMPC->( dbGoTop() )
do while ! TMPC->( EoF() )
	if aScan(aQry, { |x| x[1] == TMPC->D3_COD } ) == 0
		aAdd( aQry, { TMPC->D3_COD, TMPC->B1_DESC } )
	endIf
	TMPC->( dbSkip() )
	cCod := ''
endDo

TMPA->( dbCloseArea() )
TMPB->( dbCloseArea() )
TMPC->( dbCloseArea() )

incRegua()
aSort( aQry,,, { |x,y| x[1] < y[1] } )
SetRegua( len( aQry ) )

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin := 8

For k := 1 to len( aQry )

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

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   @nLin,00 PSAY aQry[k][1]
   @nLin,22 PSAY aQry[k][2]

   nLin := nLin + 1 // Avanca a linha de impressao
Next

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