#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ1
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO3     บ Autor ณ AP6 IDE            บ Data ณ  30/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
 */
 
User Function TMKR007()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "teste"
Local cPict          := ""
Local titulo         := "teste"
Local nLin           := 80

Local Cabec1         := "Fatura   | Bilhete         |   Data    | Companhia aerea                       |   Passageiro    |  Trecho                                  |   Valor     |   Milhas "
Local Cabec2         := "         |                 |           |                                       |                 |                                          |             |          "
Local imprime        := .T.
Local aOrd := {}                                
Private lEnd         := .F.                                                                          
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 160
Private tamanho          := "G"
Private nomeprog         := "Main" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "Main" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "Z62"
Private cPerg     := "TMKR006"

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
cQuery:="" 
cQuery+=" Select "                          +chr(10)
cQuery+="  Z62_FATURA FATURA , "            +chr(10)
cQuery+="  Z62_BILHET BILHET , "            +chr(10)
cQuery+="  Z62_DTVIAG DTVIAG , "            +chr(10)
cQuery+="  Z62_COMP   COMP   , "            +chr(10)
cQuery+="  Z62_MATRIC MATRIC , "            +chr(10)
cQuery+="  Z62_TRECHO TRECHO , "            +chr(10)
cQuery+="  Z62_VALOR  VALOR  , "            +chr(10)
cQuery+="  Z62_MILHAS MILHAS , "            +chr(10)
cQuery+="  Z62_CODUTI CODUTI   "            +chr(10)
 

cQuery+=" From "+RetSqlName('Z62')+" Z62  " +chr(10) 
cQuery+=" where  "                          +chr(10)
cQuery+="  D_E_L_E_T_='' and   "            +chr(10)
cQuery+="  Z62_DTVIAG between  "            +chr(10)
cQuery+=valtoSql(dtos(MV_PAR01))+" and "    +chr(10)
cQuery+=valtoSql(dtos(MV_PAR02))            +chr(10)
IF MV_PAR03==1
cQuery+="  ORDER BY Z62_MATRIC,Z62_COMP  "  +chr(10)
ELSE
cQuery+="  ORDER BY Z62_COMP  ,Z62_MATRIC"  +chr(10)
ENDIF

TCQUERY cQuery NEW ALIAS 'AUUX'
AUUX->(DBGOTOP())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetRegua(RecCount())
 nTotal:=0 
 nSaldo:=0           
//cUF:=AUUX->Z15_UF
 While AUUX->(!EOF())
 //  cUF:=AUUX->Z15_UF    
 
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif
 
   If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas... 
   Cabec1         := "Fatura   | Bilhete         |   Data    | Companhia aerea                       |   Passageiro    |  Trecho                                  |   Valor     |   Milhas "
   Cabec2         := "         |                 |           |                                       |                 |                                          |             |          "

      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9 
      
   Endif

        
	    //@nLin++  ,000  PSAY replicate("_",149)
        //@nLin  ,000  PSAY cNome
        //nLin++
        IF MV_PAR03==1
        cGrupo:=AUUX->MATRIC
        ELSE
        cGrupo:=AUUX->COMP
        ENDIF
        
        nValor:=0
        nMilhasAc:=0
        @nLin++ ,000  PSAY replicate("_",177)
        While cGrupo == iif(MV_PAR03==1,AUUX->MATRIC,AUUX->COMP)
         @nLin  ,000  PSAY Cabec2
         @nLin  ,000  PSAY replicate("_",177)
         @nLin  ,000  PSAY AUUX->FATURA 
         @nLin  ,012  PSAY AUUX->BILHET   
 		 @nLin  ,030  PSAY dtoc(stod(AUUX->DTVIAG))
 		  
 		 cComp:=Posicione('SX5',1,xFilial("SX5")+'Z7'+ALLTRIM(AUUX->COMP),"X5_DESCRI")    
   		 @nLin  ,042  PSAY cComp   
   		                        
   		 
   	    cNome:=AUUX->MATRIC
    	PswOrder(1)
	    If PswSeek( cNome, .T. )
		  aUsuarios  := PSWRET()
		  cNome := Alltrim(aUsuarios[1][2])
	    Endif
	    
   		 @nLin  ,(062+20)  PSAY cNome
 		 @nLin  ,(080+20)  PSAY AUUX->TRECHO 
 		 @nLin  ,(123+20)  PSAY transform(AUUX->VALOR  , "@R 999,999.99")   
 		 @nLin  ,(138+20)  PSAY transform(AUUX->MILHAS, "@R 999,999.99") + iif(EMPTY(AUUX->CODUTI),""," Utilizado") 
 		 nMilhasAc+=iif(EMPTY(AUUX->CODUTI),AUUX->MILHAS,0 )
 		 nValor+=AUUX->VALOR 
         nLin++
        IncRegua()
        AUUX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
        Enddo 
        
        @nLin  ,(124+20)- len( transform(nValor       , "@R 999,999.99"));
         PSAY "Total | "+transform(nValor       , "@R 999,999.99")
        @nLin++  ,(137+20)  PSAY transform(nMilhasAc, "@R 999,999.99") 
         
                
        //@nLin++,000 PSAY 'Milhas disponํveis para '+alltrim(iif(MV_PAR03==1,cNome,cComp))+' = '+alltrim(str(nMilhasAc))
        nTotal+=nMilhasAc 
        nSaldo+=nValor
        nLin++
EndDo 
@nLin++,000  PSAY replicate("_",177)
@nLin  ,000  PSAY replicate("_",177)
//@nLin++,000 PSAY 'Total de Milhas acumuladas  = '+alltrim(transform(nTotal, "@R 999,999.99")) //  alltrim(str(nTotal))
//@nLin  ,000  PSAY replicate("_",177)

//@nLin,000 PSAY 'Saldo Total  = '+alltrim(transform(nSaldo, "@R 999,999.99")) //alltrim(str(nSaldo)) 
//nLin++
@nLin  ,(125+20)- len( transform(nSaldo       , "@R 999,999.99"));
PSAY "Total | "+transform(nSaldo       , "@R 999,999.99")
@nLin++  ,(138+20)  PSAY transform(nTotal, "@R 999,999.99") 




//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
AUUX-> (dbcloseArea())
SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
