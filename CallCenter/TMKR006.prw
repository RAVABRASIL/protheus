#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ1
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO3     º Autor ³ AP6 IDE            º Data ³  30/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TMKR006()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := ""
Local cPict         := ""
Local titulo        := ""
Local nLin          := 80

Local Cabec1        := ""
Local Cabec2        := ""
Local imprime       := .T.
Local aOrd := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 160
Private tamanho     := "G"
Private nomeprog    := "Main" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "Main" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "Z62"
Private cPerg     := "TMKR006"

Pergunte(cPerg,.F.)


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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  30/10/09   º±±
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

Local nOrdem
Local cQuery:=" "
Local nCont:=nTotal:=0
cQuery:=""
cQuery+=" Select "                          +chr(10)
cQuery+="   Z62_FATURA FATURA , "           +chr(10)
cQuery+="   Z62_BILHET BILHET , "           +chr(10)
cQuery+="   Z62_DTVIAG DTVIAG , "           +chr(10)
cQuery+="   Z62_DTVIAG DTVIAG , "           +chr(10)
cQuery+="   Z62_DTVOLT DTVOLT , "           +chr(10)
cQuery+="   Z62_COMP   COMP   , "           +chr(10)
cQuery+="   Z62_MATRIC MATRIC , "           +chr(10)
cQuery+="   Z62_TRECHO TRECHO , "           +chr(10)
cQuery+="   Z62_VALOR  VALOR  , "           +chr(10)
cQuery+="   Z62_MULTA  MULTA  , "           +chr(10)
cQuery+="   Z62_MILHAS MILHAS , "           +chr(10)
cQuery+="   Z62_CODUTI CODUTI , "           +chr(10)
cQuery+="   Z62_CANCEL CANCEL , "           +chr(10)
cQuery+="   Z62_REMARC REMARC   "           +chr(10)
cQuery+=" From "+RetSqlName('Z62')+" Z62  " +chr(10)
cQuery+=" where  "                          +chr(10)
cQuery+="   D_E_L_E_T_='' and   "           +chr(10)
cQuery+="   Z62_DTVIAG between  "           +chr(10)
cQuery+=valtoSql(dtos(MV_PAR01))+" and "    +chr(10)
cQuery+=valtoSql(dtos(MV_PAR02))            +chr(10)
IF MV_PAR03==1
	cQuery+="  ORDER BY Z62_MATRIC,Z62_COMP  "  +chr(10)
ELSE
	cQuery+="  ORDER BY Z62_COMP  ,Z62_MATRIC"  +chr(10)
ENDIF
TCQUERY cQuery NEW ALIAS 'AUUX'
AUUX->(DBGOTOP())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())
nTotal:=0
nSaldo:=0
nML:=0
While AUUX->(!EOF())
	//  cUF:=AUUX->Z15_UF
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...    
	                     //         0         0         0         0         0         0         0         0         0         1         1         1         1         1         1         1         1         1         1         2
	                     //         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0
	                     //12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		Cabec1         := "Fatura   | Bilhete         |        Data             | Companhia aerea                       |   Passageiro    |  Trecho                                  |   Valor     |   Milhas acumuladas"
		Cabec2         := "         |                 |    Ida     |   Volta    |                                       |                 |                                          |             |                    "
		Cabec3         := "         |                 |            |            |                                       |                 |                                          |             |                    "
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
		
	Endif

	IF MV_PAR03==1
		cGrupo:=AUUX->MATRIC
	ELSE
		cGrupo:=AUUX->COMP
	ENDIF
	
	nValor:=0
	nMilhasAc:=0
	nBilhete:=0
	@nLin++ ,000  PSAY replicate("_",190)
	While cGrupo == iif(MV_PAR03==1,AUUX->MATRIC,AUUX->COMP)
		@nLin  ,000  PSAY Cabec3
		@nLin  ,000  PSAY replicate("_",190)
		@nLin  ,000  PSAY AUUX->FATURA
		@nLin  ,012  PSAY AUUX->BILHET
		@nLin  ,030  PSAY dtoc(stod(AUUX->DTVIAG))
		@nLin  ,043  PSAY dtoc(stod(AUUX->DTVOLT))
		
		cComp:=Posicione('SX5',1,xFilial("SX5")+'Z7'+ALLTRIM(AUUX->COMP),"X5_DESCRI")
		@nLin  ,042+13  PSAY cComp
		
		
		cNome:=U_Usu_Cod2Nome(AUUX->MATRIC) //AUUX->MATRIC
		//PswOrder(1)
		//If PswSeek( cNome, .T. )
		//	aUsuarios  := PSWRET()
		//	cNome := Alltrim(aUsuarios[1][2])
		//Endif
		
		@nLin  ,(062+33)  PSAY cNome
		@nLin  ,(080+33)  PSAY AUUX->TRECHO
		@nLin  ,(123+33)  PSAY transform(AUUX->VALOR  , "@R 999,999.99") 
		@nLin  ,(138+33)  PSAY transform(AUUX->MILHAS , "@R 999,999.99") + F_status()
		
	
	    if alltrim(AUUX->CANCEL)=="" .and.  alltrim(AUUX->REMARC)==""

		  nValor+=AUUX->VALOR+AUUX->MULTA
			if  alltrim(AUUX->CODUTI)==""   
		    nMilhasAc+=AUUX->MILHAS 
		    endif
		ENDIF
		
		nLin++
		IncRegua()
		AUUX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
		nBilhete++
	Enddo
	@nLin,000 PSAY 'Nª de bilhetes para '+alltrim(iif(MV_PAR03==1,cNome,cComp))+' = '+alltrim(str(nBilhete))
	
	@nLin  ,(124+33)- len( transform(nValor       , "@R 999,999.99"));
	PSAY "Total  |"+transform(nValor       , "@R 999,999.99")+"   |"
	@nLin++  ,(137+33)  PSAY transform(nMilhasAc, "@R 999,999.99")
	nML+=nMilhasAc
	nSaldo+=nValor
	nTotal+=nBilhete
	nLin++
EndDo
@nLin++,000  PSAY replicate("_",190)
@nLin  ,000  PSAY replicate("_",190)
@nLin,000 PSAY 'Total de bilhetes  = '+alltrim(str(nTotal))

@nLin  ,(124+33)- len(            transform(nSaldo , "@R 999,999.99"));
                  PSAY "Total  |"+transform(nSaldo , "@R 999,999.99")+"   |"
@nLin++  ,(137+33)  PSAY transform(nML, "@R 999,999.99")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//  _
// /_\
//<| |>
// \¯/
//  ¯
AUUX-> (dbcloseArea()) 
nLin++
 //@nLin++  ,000 PSAY  __PrtThinLine()
SET DEVICE TO SCREEN


If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return   

static function Func_Nome(cNomeCod)
 
		PswOrder(1)
		If PswSeek( cNomeCod, .T. )
			aUsuarios  := PSWRET()
			cNomeCod := Alltrim(aUsuarios[1][2])
		Endif
return cNomeCod           




static function F_status()

if !EMPTY(AUUX->CANCEL) 
return " Cancelado"
endif 

if !EMPTY(AUUX->REMARC) 
return " Remarcado"
endif 
 
if !EMPTY(AUUX->CODUTI) 
return " Utilizado"
endif 

return ""
 