#include "rwmake.ch"
#include "topconn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO10    º Autor ³ AP6 IDE            º Data ³  12/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PCPR013()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Controle de Parada de Maquina "
Local cPict          := ""
Local titulo         := "Problemas Check List Extrusoras "
Local nLin           := 80

Local Cabec1         := " "
Local Cabec2         := " "
Local imprime        := .T.
Local aOrd           := {}


public    nInc:=14
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "P"
Private nomeprog     := "PCPR013" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PCPR013" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

if !Pergunte("PCPR013",.T.) 
return
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"PCPR013",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
//------------------------------------------------
Cabec(Titulo,"Extrusora      Problema               Quantidade"," ",NomeProg,Tamanho,nTipo)
nLin :=10 

IF MV_PAR03==1
cQry:=" SELECT Z60_EXTRUS EXT ,Z60_ITEMD IT ,COUNT(*)QNT      "+ CHR(10)
cQry+=" FROM "+ RetSqlName( "Z60" ) +" Z60 "          + CHR(10)
cQry+=" WHERE                                        "+ CHR(10)
cQry+=" Z60_PENDEN='S'                               "+ CHR(10)
cQry+=" or                                           "+ CHR(10)
cQry+=" Z60_OBS!=' '                                 "+ CHR(10)
cQry+=" AND                                          "+ CHR(10)
cQry+=" Z60_DATAI BETWEEN "+DTOS(MV_PAR01)+" AND "+DTOS(MV_PAR02)+"  "+ CHR(10) 
cQry+=" AND  D_E_L_E_T_=''                           "+ CHR(10)
cQry+=" GROUP BY Z60_EXTRUS,Z60_ITEMD                "+ CHR(10)
cQry+=" ORDER BY Z60_EXTRUS ,COUNT(*) desc           "+ CHR(10)
else
cQry:="SELECT Z60_OPERA EXT ,Z60_ITEMD IT ,COUNT(*)QNT                   " + CHR(10)
cQry+=" FROM "+ RetSqlName( "Z60" ) +" Z60                           " + CHR(10)
cQry+="WHERE                                                         " + CHR(10)
cQry+="( Z60_PENDEN='S' or  Z60_OBS!=' ')AND                         " + CHR(10)
cQry+=" Z60_DATAI BETWEEN "+DTOS(MV_PAR01)+" AND "+DTOS(MV_PAR02)+"  " + CHR(10)
cQry+=" AND Z60_OPERA IN('00132','00006','00362','00298','00578')     " + CHR(10)
cQry+=" AND  D_E_L_E_T_=''                           "+ CHR(10)
cQry+=" GROUP BY Z60_OPERA,Z60_ITEMD                "+ CHR(10)
cQry+=" ORDER BY Z60_OPERA ,COUNT(*) desc           "+ CHR(10)
endif




TCQUERY cQry NEW ALIAS "AUX1"

While AUX1->( !EOF() )
	
	cExt:=AUX1->EXT
	nCont:=1
	while cExt	== AUX1->EXT
		if nCont ==1  
		   IF MV_PAR03==1
			@nLin,00 PSAY  alltrim("Extrusora "+substr(AUX1->EXT,3,1))
			ELSE
			@nLin,00 PSAY   alltrim(posicione("SRA",1,xFilial("SRA")+AUX1->EXT ,"SRA->RA_NOME")) 
			ENDIF 
			nCont++
		endif
		@nLin,15+iif(MV_PAR03==1,0,10)  PSAY  alltrim(capital(AUX1->IT))
		@nLin,40+iif(MV_PAR03==1,0,10)  PSAY  alltrim(str(AUX1->QNT ))
		nLin++
		AUX1->(dbskip())
	EndDo
	@nLin,0 PSAY 	replicate("_",50)
	nLin++
ENDDO
AUX1->(DBCLOSEAREA())

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return


 
