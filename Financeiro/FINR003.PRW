#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
 

User Function FINR003()
 
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
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "FINR003" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "FINR003" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "Z62"
Private cPerg     := "FINR003"

Pergunte(cPerg,.F.)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  30/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cQuery:=" "
Local nCont:=nTotal:=0
Local LF   := CHR(13) + CHR(10)

cQuery:=""
cQuery+=" Select "                          +LF
cQuery+="   Z62_CODIGO COD    , "           +LF
cQuery+="   Z62_FATURA FATURA , "           +LF
cQuery+="   Z62_BILHET BILHET , "           +LF
cQuery+="   Z62_DTVIAG DTVIAG , "           +LF
cQuery+="   Z62_DTVOLT DTVOLT , "           +LF
cQuery+="   Z62_COMP   COMP   , "           +LF
cQuery+="   Z62_MATRIC MATRICULA , "        +LF
cQuery+="   Z62_PRETSV PRESTADOR, "         +LF
cQuery += " MATRIC = ( CASE WHEN Z62_MATRIC <> '' THEN Z62_MATRIC " + LF
cQuery += "            ELSE Z62_PRETSV END ), " + LF
cQuery+="   Z62_TRECHO TRECHO , "           +LF
cQuery+="   Z62_VALOR  VALOR  , "           +LF
cQuery+="   Z62_MULTA  MULTA  , "           +LF
cQuery+="   Z62_MILHAS MILHAS , "           +LF
cQuery+="   Z62_CODUTI CODUTI , "           +LF
cQuery+="   Z62_CANCEL CANCEL , "           +LF
cQuery+="   Z62_REMARC REMARC , "           +LF
cQuery+="   Z62_DTFAT  DTFAT    "           +LF
cQuery+=" From "+RetSqlName('Z62')+" Z62  " +LF
cQuery+=" where                           " +LF
cQuery+="   D_E_L_E_T_='' and   "           +LF
cQuery+="   Z62_DTFAT between   "           +LF
cQuery+=valtoSql(dtos(MV_PAR01))+"  and   " +LF
cQuery+=valtoSql(dtos(MV_PAR02))            +LF
IF MV_PAR03==1 
    cQuery+="  ORDER BY Z62_COMP  , "  +LF
    cQuery += "  ( CASE WHEN Z62_MATRIC <> '' THEN Z62_MATRIC " + LF
	cQuery += "            ELSE Z62_PRETSV END ), Z62_COMP " + LF
ELSE
	//cQuery+="  ORDER BY Z62_MATRIC,Z62_COMP  "  +LF	
	cQuery += " ORDER BY ( CASE WHEN Z62_MATRIC <> '' THEN Z62_MATRIC " + LF
	cQuery += "            ELSE Z62_PRETSV END ), Z62_COMP " + LF
ENDIF
MemoWrite("C:\Temp\viagens.sql",cQuery)
TCQUERY cQuery NEW ALIAS 'AUUX'
AUUX->(DBGOTOP())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

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
	
	If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...    
	                     //         0         0         0         0         0         0         0         0         0         1         1         1         1         1         1         1         1         1         1         2         3         4
	                     //         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2
	                     //1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		Cabec1         := "Fatura   | Bilhete         |                Data                  | Companhia aerea                       |   Passageiro    |  Trecho                                  | Passagem  + Extras  | Ml acumuladas |     "
		Cabec2         := "         |                 |    Ida     |   Volta    | Fatura     |                                       |                 |                                          |                     |               |     "
		Cabec3         := "         |                 |            |            |            |                                       |                 |                                          |                     |               |     "
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
		
	Endif

	IF MV_PAR03==1
		cGrupo:=AUUX->COMP	
	ELSE 
		cGrupo:=AUUX->MATRIC
	//ELSEIF Empty(AUUX->MATRIC)
	//	cGrupo := AUUX->PRESTSV		
	ENDIF
	
	nValor:=0
	nMilhasAc:=0
	nBilhete:=0
	@nLin++ ,000  PSAY replicate("_",220)
	While cGrupo == iif(MV_PAR03==1,AUUX->COMP,AUUX->MATRIC)

		//@nLin  ,000  PSAY Cabec3
		@nLin  ,000  PSAY replicate("_",220)
		@nLin  ,000  PSAY AUUX->FATURA
		@nLin  ,012  PSAY AUUX->BILHET
		@nLin  ,030  PSAY dtoc(stod(AUUX->DTVIAG))
		@nLin  ,043  PSAY dtoc(stod(AUUX->DTVOLT))
		@nLin  ,043+13  PSAY dtoc(stod(AUUX->DTFAT))
		
		cComp:=Posicione('SX5',1,xFilial("SX5")+'Z7'+ALLTRIM(AUUX->COMP),"X5_DESCRI")
		@nLin  ,042+13+13  PSAY cComp
		
		
		If !Empty(AUUX->MATRICULA)
			cNome:=U_Usu_Cod2Nome(AUUX->MATRIC) //AUUX->MATRIC
		Else
			cNome := SUBSTR(AUUX->PRESTADOR,1,18)
		Endif
		//PswOrder(1)
		//If PswSeek( cNome, .T. )
		//	aUsuarios  := PSWRET()
		//	cNome := Alltrim(aUsuarios[1][2])
		//Endif
		      if empty(cNome)
		      cNome:=" "
		      endif
		@nLin  ,108  PSAY cNome 
		@nLin  ,126  PSAY substr(alltrim(AUUX->TRECHO),1,40)
		@nLin  ,169  PSAY transform(AUUX->VALOR  , "@E 999,999.99") 
		
		cSubQry:=" SELECT sum(Z72_VALOR) EXT      " +LF
		cSubQry+=" FROM "+RetSqlName('Z72')+" Z72 " +LF
		cSubQry+=" where                          " +LF
		cSubQry+=" Z72_COD="+ValToSql(AUUX->COD)    +LF
		cSubQry+=" and D_E_L_E_T_=' '             " +LF
		TCQUERY cSubQry NEW ALIAS 'SUB'
		
		IF SUB->(!EOF())
		@nLin  ,(123+33+13+10)  PSAY " + "+transform(SUB->EXT  , "@E 9,999.99")
		ENDIF
		@nLin  ,(138+33+13+10)  PSAY transform(AUUX->MILHAS , "@E 999,999.99") + F_status()
		
	
	    if alltrim(AUUX->CANCEL)=="" .and.  alltrim(AUUX->REMARC)==""

		  nValor+=AUUX->VALOR+AUUX->MULTA
	    IF SUB->(!EOF())
		nValor+=SUB->EXT
		ENDIF

			if  alltrim(AUUX->CODUTI)==""   
		    nMilhasAc+=AUUX->MILHAS 
		    endif
		ENDIF
		SUB-> (dbcloseArea()) 
		nLin++
		IncRegua()
		AUUX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
		nBilhete++
	Enddo 
	//if AUUX->( EOF())
	//exit
	//endif
	@nLin,000 PSAY 'Nช de bilhetes para '+alltrim(iif(MV_PAR03==1,cComp,cNome))+' = '+alltrim(str(nBilhete))
	
	@nLin  ,(160)  	PSAY "Total  |"+transform(nValor , "@E 999,999.99")+"           |"
	@nLin++  ,(137+33+10+13)  PSAY transform(nMilhasAc, "@E 999,999.99")
   
	nML+=nMilhasAc
	nSaldo+=nValor
	nTotal+=nBilhete
	nLin++
	
EndDo
@nLin++,000  PSAY replicate("_",220)
@nLin++ ,000  PSAY replicate("_",220)
@nLin++,000 PSAY 'Total de bilhetes  = '+alltrim(str(nTotal))

    @nLin  ,(160) PSAY "Total  |"+transform(nSaldo , "@E 999,999.99")+"           |"
@nLin++  ,(137+33+13+10)  PSAY transform(nML, "@E 999,999.99")
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
 
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
return "     Cancelado"
endif 

if !EMPTY(AUUX->REMARC) 
return "     Remarcado"
endif 
 
if !EMPTY(AUUX->CODUTI) 
return "     Utilizado"
endif 

return ""
 