#include "rwmake.ch"  
#include "topconn.ch" 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO45    º Autor ³ AP6 IDE            º Data ³  12/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function fGraApa()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Motivo Apara"
Local cPict          := ""
Local titulo         := "Motivo Apara"
Local nLin           := 80

Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "fGraApa" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "fGraApa" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString := ""

CPESO:=0
CPESOAPARA:=0

Pergunte('FGRAAPA',.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"FGRAAPA",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

titulo := "Motivo Apara De: "+dtoc(MV_PAR01)+" Ate: "+ dtoc(MV_PAR02) 

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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  12/06/14   º±±
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
local cQry:=''
Local nOrdem

dataI:= dtos(MV_PAR01)      
dataF:=dtos(MV_PAR02+1)     
Hora1:=SUBSTR(GetMv( "MV_TURNO1" ),1,5) //'05:20'
Hora2:=SUBSTR(GetMv( "MV_TURNO2" ),1,5) //'13:40'
Hora3:=SUBSTR(GetMv( "MV_TURNO3" ),1,5) //'22:00'

if MV_PAR03=01 // MAQUINA
   fMaq(Cabec1,Cabec2,Titulo,@nLin)
ELSE  // motivo 
          //         10        20        30        40        50        60        70        80        90        100       110
          //123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
   Cabec1:="Grupo                        Motivo                                            Turno  Peso_Kg   Apara_Kg           %"
   fMotivo(Cabec1,Cabec2,Titulo,@nLin)
ENDIF

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

Static Function fMotApa(cMaq,cTurno)

***************
local cQry:=''
LOCAL aRet:={}

cQry:="SELECT "
cQry+="Z00_MAQ,Z00_MAPAR,TURNO,PESO_KG,PESO_APARA, "
cQry+="MOTIVO=CASE  "
// CORTE E SOLDA  E DEMAIS 
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('02') THEN 'Problema na homogeneização' "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('03') THEN 'Variação de espessura' "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('04') THEN 'Largura menor' "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('05') THEN 'Emendas' "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('06') THEN 'Bobina rasgada(manuseio' "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('07') THEN 'Defeito de tonalidade' "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('08') THEN 'Falha do sleet' "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('09') THEN 'Planicidade'  "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('10') THEN 'Falha de impressão'  "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('11') THEN 'Falha no tratamento'  "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('12') THEN 'Excesso de fita durex no tubete' "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('13') THEN 'Aba'  "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('14') THEN 'Ajuste Operacional' "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('15') THEN 'Setup' "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('16') THEN 'Centralização de furo' "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('17') THEN 'Ajuste fotocélula' "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('18') THEN 'Refile' "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('19') THEN 'Ajuste de manutenção' "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('20') THEN 'Testes'  "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('21') THEN 'Falta de Energia' "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('22') THEN 'Apara de Extrusão' "
// EXTRUSORAS 
cQry+="WHEN  Z00_MAQ LIKE '[E][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('02') THEN 'Teste' "
cQry+="WHEN  Z00_MAQ LIKE '[E][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('03') THEN 'Setup'  "
cQry+="WHEN  Z00_MAQ LIKE '[E][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('04') THEN 'Furo de Balao'  "
cQry+="WHEN  Z00_MAQ LIKE '[E][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('05') THEN 'Troca de Tela' "
cQry+="WHEN  Z00_MAQ LIKE '[E][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('06') THEN 'Falta/Queda de Energia' "
// ATUALIZADO 19/10/15
cQry+="WHEN  Z00_MAQ LIKE '[E][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('07') THEN 'Problema mecanico' "
cQry+="WHEN  Z00_MAQ LIKE '[E][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('08') THEN 'Problema eletrico' "
cQry+="WHEN  Z00_MAQ LIKE '[E][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('09') THEN 'Problema Operacional' "
cQry+="WHEN  Z00_MAQ LIKE '[E][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('10') THEN 'Ma qualidade da materia prima' "
cQry+="ELSE '' "
cQry+="END  "
cQry+="FROM(SELECT "
cQry+="Z00_MAQ=Z00_MAQ, "
cQry+="Z00_MAPAR=Z00_MAPAR, "
cQry+="TURNO=CASE WHEN Z00_HORA>= '"+Hora1+"' AND Z00_HORA<'"+Hora2+"'   THEN '1' "
cQry+="ELSE CASE WHEN Z00_HORA>='"+Hora2+"' AND Z00_HORA<'"+Hora3+"' THEN '2'  "
cQry+="ELSE CASE WHEN (Z00_HORA>='"+Hora3+"' OR Z00_HORA<'24:00' )AND (Z00_HORA>='00:00' OR Z00_HORA < '"+Hora1+"'  )THEN '3' "
cQry+="ELSE 'XXXX' END END END "
cQry+=",PESO_KG=ISNULL(sum(case when Z00.Z00_APARA='' then Z00.Z00_PESO+Z00.Z00_PESCAP else 0 end),0) "
cQry+=",PESO_APARA=ISNULL(sum(case when Z00.Z00_APARA NOT IN('','W') then Z00.Z00_PESO+Z00.Z00_PESCAP else 0 end),0) "
cQry+="FROM Z00020 Z00  "
cQry+="WHERE Z00.Z00_DATHOR >= '"+DataI+Hora1+"' AND Z00.Z00_DATHOR  < '"+dataF+Hora1+"' AND  "
cQry+="Z00.Z00_FILIAL = '' "
cQry+="AND Z00.D_E_L_E_T_ = ' '  "
cQry+="AND Z00.Z00_MAQ ='"+cMaq+"' "
//cQry+="AND Z00.Z00_MAPAR<>'' "
cQry+="GROUP BY Z00.Z00_MAQ,  "
cQry+="CASE WHEN Z00_HORA>= '"+Hora1+"' AND Z00_HORA<'"+Hora2+"'   THEN '1' "
cQry+="ELSE CASE WHEN Z00_HORA>='"+Hora2+"' AND Z00_HORA<'"+Hora3+"' THEN '2'  "
cQry+="ELSE CASE WHEN (Z00_HORA>='"+Hora3+"' OR Z00_HORA<'24:00' )AND (Z00_HORA>='00:00' OR Z00_HORA < '"+Hora1+"'  )THEN '3' "
cQry+="ELSE 'XXXX' END END END "
cQry+=",Z00_MAPAR) AS TABX  "
cQry+="WHERE TURNO='"+cTurno+"'  "
cQry+="ORDER BY PESO_APARA DESC "

TCQUERY cQry NEW ALIAS "TMPY"

If TMPY->(!EOF())   
	Do While TMPY->(!EOF())   
	   Aadd( aRet, {TMPY->Z00_MAQ,TMPY->PESO_APARA,TMPY->MOTIVO } )
	   TMPY->(DBSKIP())
	Enddo
Else
//   Aadd( aRet, {" ",0,"Sem Motivo" } )
EndIf

TMPY->(DBCLOSEAREA())

Return aRet 

***************

Static Function fCabecM(nLin)

***************
@nLin++
@nLin,00 PSAY "Motivos"
@nLin,50 PSAY "Peso_Apara"
@nLin,62 PSAY "   %    "   
@nLin++,00 PSAY replicate('_',72)
return 


***************

Static Function fCabec(nLin)

***************
@nLin++
@nLin,00 PSAY "Maquina"
@nLin,09 PSAY "Turno"
@nLin,16 PSAY "Peso_Kg"
@nLin,28 PSAY "Peso_Apara"   
@nLin,40 PSAY "   %    "   
@nLin++,00 PSAY replicate('_',52)
return 

***************

Static Function fMaq(Cabec1,Cabec2,Titulo,nLin)

***************
local cQry:=''

cQry:="SELECT "
cQry+="MAQ=Z00_MAQ "
cQry+=",TURNO=CASE WHEN Z00_HORA>= '"+Hora1+"' AND Z00_HORA<'"+Hora2+"'   THEN '1' "
cQry+="ELSE CASE WHEN Z00_HORA>='"+Hora2+"' AND Z00_HORA<'"+Hora3+"' THEN '2' "
cQry+="ELSE CASE WHEN (Z00_HORA>='"+Hora3+"' OR Z00_HORA<'24:00' )AND (Z00_HORA>='00:00' OR Z00_HORA < '"+Hora1+"'  )THEN '3' "
cQry+="ELSE 'XXXX' END END END "
cQry+=",PESO_KG=ISNULL(sum(case when Z00.Z00_APARA='' then Z00.Z00_PESO+Z00.Z00_PESCAP else 0 end),0) "
cQry+=",PESO_APARA=ISNULL(sum(case when Z00.Z00_APARA NOT IN('','W')  then Z00.Z00_PESO+Z00.Z00_PESCAP else 0 end),0) "
cQry+="FROM Z00020 Z00  "
cQry+="WHERE Z00.Z00_DATHOR >= '"+DataI+Hora1+"' AND Z00.Z00_DATHOR  < '"+dataF+Hora1+"' AND  "
cQry+="Z00.Z00_FILIAL = ''  "
cQry+="AND Z00.D_E_L_E_T_ = ' '  "
cQry+="AND Z00.Z00_MAQ LIKE '[CPSEI][0123456789]%'  "
cQry+="GROUP BY Z00.Z00_MAQ "
cQry+=",CASE WHEN Z00_HORA>= '"+Hora1+"' AND Z00_HORA<'"+Hora2+"'   THEN '1' "
cQry+="ELSE CASE WHEN Z00_HORA>='"+Hora2+"' AND Z00_HORA<'"+Hora3+"' THEN '2' "
cQry+="ELSE CASE WHEN (Z00_HORA>='"+Hora3+"' OR Z00_HORA<'24:00' )AND (Z00_HORA>='00:00' OR Z00_HORA < '"+Hora1+"'  )THEN '3' "
cQry+="ELSE 'XXXX' END END END "
cQry+="order by MAQ,TURNO "

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
      nLin := 8
   Endif
   
   cMaq:= TMPX->MAQ
   nTKg:=0
   nTApa:=0
   
   Do While TMPX->(!EOF()) .AND. TMPX->MAQ==cMaq
         If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
           Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
           nLin := 8
         Endif
      cTurno:= TMPX->TURNO      
      Do While TMPX->(!EOF()) .AND. TMPX->MAQ==cMaq .AND. TMPX->TURNO==cTurno

	      If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
             Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
              nLin := 8
          Endif

	   // Coloque aqui a logica da impressao do seu programa...
	   // Utilize PSAY para saida na impressora. Por exemplo:
	    fCabec(@nLin)
	    @nLin,00 PSAY TMPX-> MAQ
	    @nLin,12 PSAY TMPX-> TURNO
	    @nLin,16 PSAY TRANSFORM(TMPX-> PESO_KG,"@E 999,999.99")
	    @nLin,28 PSAY TRANSFORM(TMPX-> PESO_APARA,"@E 999,999.99")    
	    @nLin++,40 PSAY TRANSFORM((TMPX-> PESO_APARA/(TMPX-> PESO_KG+TMPX-> PESO_APARA))*100,"@E 999,999.99")    	   
	    aMotApa:=fMotApa(TMPX->MAQ,TMPX->TURNO)
	    If len(aMotApa)>0
		    fCabecM(@nLin)
		    For _x:=1 to len(aMotApa)
	           @nLin,00 PSAY iif(empty(aMotApa[_x][3]),"Motivo ",aMotApa[_x][3])
	           @nLin,50 PSAY TRANSFORM(aMotApa[_x][2],"@E 999,999.99") 
	           @nLin++,62 PSAY TRANSFORM((aMotApa[_x][2]/(aMotApa[_x][2]+TMPX-> PESO_KG))*100,"@E 999,999.99")
		    Next	    
		    @nLin++
        endif
	    // variaveis para Totalizar 
	    nTKg+=TMPX-> PESO_KG
	    nTApa+=TMPX-> PESO_APARA
	    
	    Incregua()
	    TMPX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	  Enddo
   Enddo
        fCabec(@nLin)
	    @nLin,00 PSAY CMaq
	    @nLin,09 PSAY "Total  "
	    @nLin,16 PSAY TRANSFORM(nTKg,"@E 999,999.99")
	    @nLin,28 PSAY TRANSFORM(nTApa,"@E 999,999.99")    
	    @nLin++,40 PSAY TRANSFORM((nTApa/(nTApa+nTKg))*100,"@E 999,999.99")    	           
EndDo

TMPX->(DbCloseArea())

Return 

***************

Static Function fMotivo(Cabec1,Cabec2,Titulo,nLin)

***************
local cQry:=''
local lok:=.T.

cQry:="SELECT GRUPO,TURNO, "
cQry+="PESO_KG=SUM(PESO_KG) , "
cQry+="PESO_APARA=CASE WHEN MOTIVO =' ' THEN 999999 ELSE SUM(PESO_APARA) END , "
cQry+="MOTIVO "
cQry+="FROM ( "
cQry+="SELECT "
cQry+="Z00_APARA,GRUPO,TURNO,PESO_KG=SUM(PESO_KG) "
cQry+=",PESO_APARA=CASE WHEN MOTIVO =' ' THEN 999999 ELSE SUM(PESO_APARA) END "
cQry+=",MOTIVO "
cQry+="FROM ( "
cQry+="SELECT  "
cQry+="Z00_APARA,GRUPO=SUBSTRING(Z00_MAQ,1,1), "
cQry+="TURNO,(PESO_KG),(PESO_APARA),  "
cQry+="MOTIVO=CASE  "
// CORTE E SOLDA E DIVERSAS
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('') and Z00_APARA<>'' THEN 'Motivo' "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('02') THEN 'Problema na homogeneização' "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('03') THEN 'Variação de espessura' "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('04') THEN 'Largura menor' "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('05') THEN 'Emendas' "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('06') THEN 'Bobina rasgada(manuseio' "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('07') THEN 'Defeito de tonalidade' "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('08') THEN 'Falha do sleet' "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('09') THEN 'Planicidade'  "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('10') THEN 'Falha de impressão'  "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('11') THEN 'Falha no tratamento'  "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('12') THEN 'Excesso de fita durex no tubete' "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('13') THEN 'Aba'  "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('14') THEN 'Ajuste Operacional' "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('15') THEN 'Setup' "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('16') THEN 'Centralização de furo' "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('17') THEN 'Ajuste fotocélula' "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('18') THEN 'Refile' "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('19') THEN 'Ajuste de manutenção' "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('20') THEN 'Testes'  "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('21') THEN 'Falta de Energia' "
cQry+="WHEN  Z00_MAQ LIKE '[CPSI][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('22') THEN 'Apara de Extrusão' "
// EXTRUSORAS 
cQry+="WHEN  Z00_MAQ LIKE '[E][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('') and Z00_APARA<>'' THEN 'Motivo' "
cQry+="WHEN  Z00_MAQ LIKE '[E][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('02') THEN 'Teste' "
cQry+="WHEN  Z00_MAQ LIKE '[E][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('03') THEN 'Setup' "
cQry+="WHEN  Z00_MAQ LIKE '[E][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('04') THEN 'Furo de Balao' "
cQry+="WHEN  Z00_MAQ LIKE '[E][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('05') THEN 'Troca de Tela' "
cQry+="WHEN  Z00_MAQ LIKE '[E][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('06') THEN 'Falta/Queda de Energia' "
// ATUALIZADO 19/10/15
cQry+="WHEN  Z00_MAQ LIKE '[E][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('07') THEN 'Problema mecanico' "
cQry+="WHEN  Z00_MAQ LIKE '[E][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('08') THEN 'Problema eletrico' "
cQry+="WHEN  Z00_MAQ LIKE '[E][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('09') THEN 'Problema Operacional' "
cQry+="WHEN  Z00_MAQ LIKE '[E][0123456789]%' AND SUBSTRING(Z00_MAPAR,3,2) IN('10') THEN 'Ma qualidade da materia prima' "
cQry+="ELSE '' "
cQry+="END  "
cQry+="FROM( "
cQry+="SELECT   "
cQry+="Z00_APARA,Z00_MAQ,  "
cQry+="Z00_MAPAR=Z00_MAPAR, "
cQry+="TURNO=CASE WHEN Z00_HORA>= '"+Hora1+"' AND Z00_HORA<'"+Hora2+"'   THEN '1' "
cQry+="ELSE CASE WHEN Z00_HORA>='"+Hora2+"' AND Z00_HORA<'"+Hora3+"' THEN '2' "
cQry+="ELSE CASE WHEN (Z00_HORA>='"+Hora3+"' OR Z00_HORA<'24:00' )AND (Z00_HORA>='00:00' OR Z00_HORA < '"+Hora1+"'  )THEN '3' "
cQry+="ELSE 'XXXX' END END END "
cQry+=",PESO_KG=ISNULL(sum(case when Z00.Z00_APARA='' then Z00.Z00_PESO+Z00.Z00_PESCAP else 0 end),0) "
cQry+=",PESO_APARA=ISNULL(sum(case when Z00.Z00_APARA NOT IN('','W') then Z00.Z00_PESO+Z00.Z00_PESCAP else 0 end),0) "
cQry+="FROM Z00020 Z00  "
cQry+="WHERE Z00.Z00_DATHOR >= '"+DataI+Hora1+"' AND Z00.Z00_DATHOR  < '"+dataF+Hora1+"' AND  "
cQry+="Z00.Z00_FILIAL = ''  "
cQry+="AND Z00.D_E_L_E_T_ = ' '  "
cQry+="AND Z00.Z00_MAQ LIKE '[CPSEI][0123456789]%'  "
cQry+="GROUP BY Z00_APARA,Z00.Z00_MAQ "
cQry+=",CASE WHEN Z00_HORA>= '"+Hora1+"' AND Z00_HORA<'"+Hora2+"'   THEN '1' "
cQry+="ELSE CASE WHEN Z00_HORA>='"+Hora2+"' AND Z00_HORA<'"+Hora3+"' THEN '2' "
cQry+="ELSE CASE WHEN (Z00_HORA>='"+Hora3+"' OR Z00_HORA<'24:00' )AND (Z00_HORA>='00:00' OR Z00_HORA < '"+Hora1+"'  )THEN '3' "
cQry+="ELSE 'XXXX' END END END "
cQry+=",Z00_MAPAR "
cQry+=") AS TABX "
cQry+=") AS TABY "
cQry+="GROUP BY "
cQry+="Z00_APARA,GRUPO,TURNO,MOTIVO "
cQry+=") AS TABZ "
cQry+="GROUP BY "
cQry+="GRUPO,TURNO,MOTIVO "
cQry+="ORDER BY "
cQry+=" GRUPO,TURNO,PESO_APARA DESC   "
TCQUERY cQry NEW ALIAS "TMPZ"



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

TMPZ->(dbGoTop())
While TMPZ->(!EOF())

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

	   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	      nLin := 8
	   Endif


   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   cGrupo:=TMPZ->GRUPO
   lok:=.T.
   Do While TMPZ->(!EOF()) .AND. TMPZ->GRUPO==cGrupo
	   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	      nLin := 8
	   Endif
	
	    If !EMPTY(TMPZ->MOTIVO)
		   	
		   	if lok 
		       
		       lok2:=.T.
	           CPESO:=0
	           CPESOAPARA:=fPesoApa(TMPZ->GRUPO,"1")
	          
	          @nLin,00 PSAY IIF(TMPZ->GRUPO='C','Corte e Solda',IIF(TMPZ->GRUPO='P','Picotadeira',IIF(TMPZ->GRUPO='E','Extrusora',IIF(TMPZ->GRUPO='S','Sacoleira',IIF(TMPZ->GRUPO='I','Impressora',TMPZ->GRUPO)))))
    		  @nLin,30 PSAY " "
		      @nLin,82 PSAY "1"
		      @nLin,87 PSAY TRANSFORM(CPESO,"@E 999,999.99")
		      @nLin,97 PSAY TRANSFORM(CPESOAPARA,"@E 999,999.99")
    		  @nLin++,107 PSAY TRANSFORM((CPESOAPARA/(CPESO+CPESOAPARA))*100,"@E 999,999.99")    

		      lok:=.F.
		   endif
		   		   
		   
		   if alltrim(TMPZ->TURNO) $ '2' .and. CPESO=0
		      
                IF TYPE("lok2")='U'
                   lok2:=.T.
                ENDIF                  

               lok3 :=.T.
	           
	           IF lok2 

		           CPESOAPARA:=fPesoApa(TMPZ->GRUPO,TMPZ->TURNO)
		          
		           @nLin,82 PSAY TMPZ->TURNO
			       @nLin,87 PSAY TRANSFORM(0,"@E 999,999.99")
			       @nLin,97 PSAY TRANSFORM(CPESOAPARA,"@E 999,999.99")
	    		   @nLin++,107 PSAY TRANSFORM((CPESOAPARA/(0+CPESOAPARA))*100,"@E 999,999.99")    
	               lok2:=.F.
	
               ENDIF
               
		   endif
		   
		   if alltrim(TMPZ->TURNO) $ '3' .and. CPESO=0
		      
                IF TYPE("lok3")='U'
                   lok3:=.T.
                ENDIF                  
                
	           IF lok3 

		           CPESOAPARA:=fPesoApa(TMPZ->GRUPO,TMPZ->TURNO)
		          
		           @nLin,82 PSAY TMPZ->TURNO
			       @nLin,87 PSAY TRANSFORM(0,"@E 999,999.99")
			       @nLin,97 PSAY TRANSFORM(CPESOAPARA,"@E 999,999.99")
	    		   @nLin++,107 PSAY TRANSFORM((CPESOAPARA/(0+CPESOAPARA))*100,"@E 999,999.99")    
	               lok3:=.F.
	
               ENDIF
               
		   endif



		   @nLin,30 PSAY TMPZ->MOTIVO
		   @nLin,97 PSAY TRANSFORM(TMPZ->PESO_APARA,"@E 999,999.99")
		   @nLin++,107 PSAY TRANSFORM((TMPZ->PESO_APARA/(CPESO+TMPZ->PESO_APARA))*100,"@E 999,999.99")
	   
	    ELSE
	       
	       CPESO:=TMPZ-> PESO_KG
	       CPESOAPARA:=fPesoApa(TMPZ->GRUPO,TMPZ->TURNO)
	       
	       if lok 
	          @nLin,00 PSAY IIF(TMPZ->GRUPO='C','Corte e Solda',IIF(TMPZ->GRUPO='P','Picotadeira',IIF(TMPZ->GRUPO='E','Extrusora',IIF(TMPZ->GRUPO='S','Sacoleira',IIF(TMPZ->GRUPO='I','Impressora',TMPZ->GRUPO)))))
		      lok:=.F.
		   endif
		   
		   @nLin,30 PSAY TMPZ->MOTIVO
		   @nLin,82 PSAY TMPZ-> TURNO
		   @nLin,87 PSAY TRANSFORM(TMPZ->PESO_KG,"@E 999,999.99")
		   @nLin,97 PSAY TRANSFORM(CPESOAPARA,"@E 999,999.99")
		   @nLin++,107 PSAY TRANSFORM((CPESOAPARA/(TMPZ->PESO_KG+CPESOAPARA))*100,"@E 999,999.99")    
	   
	    ENDIF	   	       
	    TMPZ->(dbSkip()) // Avanca o ponteiro do registro no arquivo         
   Enddo

Enddo

TMPZ->(DbCloseArea())

Return 

***************

Static Function fmotcab(nLin,ctipo)

***************
CPESO:=TMPZ-> PESO_KG
CPESOAPARA:=fPesoApa(TMPZ->GRUPO,TMPZ->TURNO)
if cTipo='1'
   @nLin,00 PSAY IIF(TMPZ->GRUPO='C','Corte e Solda',IIF(TMPZ->GRUPO='P','Picotadeira',IIF(TMPZ->GRUPO='E','Extrusora',IIF(TMPZ->GRUPO='S','Sacoleira',IIF(TMPZ->GRUPO='I','Impressora',TMPZ->GRUPO)))))
   @nLin++
endif
@nLin,50 PSAY TMPZ-> TURNO
@nLin,55 PSAY TRANSFORM(CPESO,"@E 999,999.99")
@nLin,67 PSAY TRANSFORM(CPESOAPARA,"@E 999,999.99")
@nLin++,77 PSAY TRANSFORM((CPESOAPARA/(CPESO+CPESOAPARA))*100,"@E 999,999.99")

Return 

***************

Static Function fPesoApa(cGrupo,cTurno)

***************
local cQry:=''
local nRet:=0

cQry:="SELECT "
if !empty(cTurno)
   cQry+="GRUPO,TURNO,PESO_KG=SUM(PESO_KG),PESO_APARA=SUM(PESO_APARA) "
else
   cQry+="GRUPO,PESO_KG=SUM(PESO_KG),PESO_APARA=SUM(PESO_APARA) "
endif
cQry+="FROM ( "
cQry+="SELECT "
cQry+="GRUPO=SUBSTRING(Z00_MAQ,1,1), "
cQry+="TURNO,(PESO_KG),(PESO_APARA)  "
cQry+="FROM( "
cQry+="SELECT  "
cQry+="Z00_MAQ, "
cQry+="Z00_MAPAR=Z00_MAPAR, "
cQry+="TURNO=CASE WHEN Z00_HORA>= '"+Hora1+"' AND Z00_HORA<'"+Hora2+"'   THEN '1' "
cQry+="ELSE CASE WHEN Z00_HORA>='"+Hora2+"' AND Z00_HORA<'"+Hora3+"' THEN '2' "
cQry+="ELSE CASE WHEN (Z00_HORA>='"+Hora3+"' OR Z00_HORA<'24:00' )AND (Z00_HORA>='00:00' OR Z00_HORA < '"+Hora1+"'  )THEN '3' "
cQry+="ELSE 'XXXX' END END END "
cQry+=",PESO_KG=ISNULL(sum(case when Z00.Z00_APARA='' then Z00.Z00_PESO+Z00.Z00_PESCAP else 0 end),0) "
cQry+=",PESO_APARA=ISNULL(sum(case when Z00.Z00_APARA NOT IN('','W') then Z00.Z00_PESO+Z00.Z00_PESCAP else 0 end),0) "
cQry+="FROM Z00020 Z00  "
cQry+="WHERE Z00.Z00_DATHOR >= '"+DataI+Hora1+"' AND Z00.Z00_DATHOR  < '"+dataF+Hora1+"' AND  "
cQry+="Z00.Z00_FILIAL = ''  "
cQry+="AND Z00.D_E_L_E_T_ = ' '" 
cQry+="AND Z00.Z00_MAQ LIKE '[CPSEI][0123456789]%'  "
cQry+="GROUP BY Z00.Z00_MAQ  "
cQry+=",CASE WHEN Z00_HORA>= '"+Hora1+"' AND Z00_HORA<'"+Hora2+"'   THEN '1' "
cQry+="ELSE CASE WHEN Z00_HORA>='"+Hora2+"' AND Z00_HORA<'"+Hora3+"' THEN '2' "
cQry+="ELSE CASE WHEN (Z00_HORA>='"+Hora3+"' OR Z00_HORA<'24:00' )AND (Z00_HORA>='00:00' OR Z00_HORA < '"+Hora1+"'  )THEN '3' "
cQry+="ELSE 'XXXX' END END END "
cQry+=",Z00_MAPAR "
cQry+=") AS TABX  "
cQry+=") AS TABY "
cQry+="WHERE "
cQry+="GRUPO='"+cGrupo+"'  "
if !empty(cTurno)
   cQry+="AND TURNO='"+cTurno+"'  "
endif
cQry+="GROUP BY  "
if !empty(cTurno)
   cQry+="GRUPO,TURNO  "
else
   cQry+="GRUPO  "
endif   
TCQUERY cQry NEW ALIAS "TMPA"

If TMPA->(!EOF())
   nRet:=TMPA->PESO_APARA
EndIf

TMPA->(DBCLOSEAREA())

Return nRet
