#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO20    บ Autor ณ AP6 IDE            บ Data ณ  10/04/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function fMaxProd()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Maximizacao Producao"
Local cPict          := ""
Local titulo         := "Maximizacao Producao"
Local nLin           := 80

                       //          10        20        30        40        50        60        70        80        90        100       110       120       130       140       150
                       //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Local Cabec1         := "Maquina   Data - Hora     Lado  Produto  Litragem   Espessura Turno                      Regra"
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "fMaxProd" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "fMaxProd" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

Private cTURNO1   := GetMv("MV_TURNO1")
Private cTURNO2   := GetMv("MV_TURNO2")
Private cTURNO3   := GetMv("MV_TURNO3")


cntPar:=1
nTocD:=0
nTocDT:=0
nDias:=0
nDomi:=0
aPariAnt:={}

PERGUNTE('FMAXPROD',.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,'FMAXPROD',@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

titulo         := "Maximizacao Producao de: " +dtoc(MV_PAR01) +' Ate: '+dtoc(MV_PAR02)

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

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  10/04/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
local cQry:=''
Local nOrdem
local cMaq:=" "
local aAnt:={}
local cnt:=1
Local lImpBob	:= .F.


dDataI:=MV_PAR01
dDataF:=MV_PAR02  
// 
hora1:=Left(cTURNO1,5)
hora2:=Left(cTURNO2,5)
hora3:=Left(cTURNO3,5)
//

While dDataI<=dDataF
	cQry:="SELECT "
	cQry+="Z00_MAQ,Z00_DATA,Z00_HORA, Z00_DATHOR,Z00_LADO,C2_PRODUTO,B5_CAPACID, B5_LARGFIL, "
	//cQry+="DESC_CAP=(SELECT TOP 1 X5_DESCRI FROM SX5020 SX5 WHERE X5_TABELA='Z0' AND X5_CHAVE=B5_CAPACID AND SX5.D_E_L_E_T_=''), "
	cQry+="DESC_CAP=(SELECT TOP 1 X5_DESCRI FROM SX5020 SX5 WHERE X5_TABELA='Z0' AND X5_CHAVE=SUBSTRING(C2_PRODUTO,2,1) AND SX5.D_E_L_E_T_=''), "
	cQry+="B5_ESPESS,TURNO=CASE WHEN Z00_HORA>= '05:20' AND Z00_HORA<'13:40'   THEN '1' "
	cQry+="ELSE CASE WHEN Z00_HORA>='13:40' AND Z00_HORA<'22:00' THEN '2' "
	cQry+="ELSE CASE WHEN (Z00_HORA>='22:00' OR Z00_HORA<'24:00' )AND (Z00_HORA>='00:00' OR Z00_HORA < '05:20'  )THEN '3' "
	cQry+="ELSE 'XXXX' END END END "
	cQry+="FROM Z00020 Z00 WITH (NOLOCK), SC2020 SC2 WITH (NOLOCK),  SB1010 SB1 WITH (NOLOCK) "
	cQry+=",  SB5010 SB5 WITH (NOLOCK) "
	cQry+="WHERE Z00_FILIAL = '' " 
	cQry+="AND B1_COD=B5_COD "
	cQry+="AND C2_PRODUTO=B1_COD  AND B1_TIPO IN ('PA','PI') "
	cQry+="AND Z00_OP=C2_NUM+C2_ITEM+C2_SEQUEN "
	//cQry+="AND Z00.Z00_DATHOR >=  '"+DTOS(MV_PAR01)+"05:20' AND Z00.Z00_DATHOR <= '"+DTOS(MV_PAR01+1)+"05:19'  "
	//cQry+="AND Z00.Z00_DATHOR >=  '"+DTOS(dDataI)+"05:20' AND Z00.Z00_DATHOR <= '"+DTOS(dDataI+1)+"05:19'  "
	
    cQry+="AND Z00.Z00_DATHOR >=  '"+DTOS(dDataI)+hora1+"' AND Z00.Z00_DATHOR < '"+DTOS(dDataI+1)+hora1+"'  "
	
	cQry+="AND SUBSTRING(Z00.Z00_MAQ,1,2)  IN ('C0','C1','E0') "
	cQry+="AND Z00.Z00_APARA = '' AND Z00.D_E_L_E_T_ = '' "
	cQry+="AND SB1.D_E_L_E_T_=''  AND SB5.D_E_L_E_T_='' "
	cQry+="GROUP BY Z00_DATA,Z00_HORA,Z00_MAQ, Z00_DATHOR,Z00_LADO,C2_PRODUTO,B5_CAPACID, B5_LARGFIL,B5_ESPESS, "
	cQry+="CASE WHEN Z00_HORA>= '05:20' AND Z00_HORA<'13:40'   THEN '1' "
	cQry+="ELSE CASE WHEN Z00_HORA>='13:40' AND Z00_HORA<'22:00' THEN '2'  "
	cQry+="ELSE CASE WHEN (Z00_HORA>='22:00' OR Z00_HORA<'24:00' )AND (Z00_HORA>='00:00' OR Z00_HORA < '05:20'  )THEN '3' "
	cQry+="ELSE 'XXXX' END END END  "
	cQry+="ORDER BY Z00_MAQ, Z00_DATHOR  "
	TCQUERY cQry NEW ALIAS "TMPX"
	    
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	SetRegua(0)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Posicionamento do primeiro registro e loop principal. Pode-se criar ณ
	//ณ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ณ
	//ณ cessa enquanto a filial do registro for a filial corrente. Por exem ณ
	//ณ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ณ
	//ณ                                                                     ณ
	//ณ dbSeek(xFilial())                                                   ณ
	//ณ While !EOF() .And. xFilial() == A1_FILIAL                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	TMPX->(dbGoTop())
	If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   nLin := 8
	Endif
	@nLin++,00 PSAY "Dia: "+ dtoc(dDataI) 
	@nLin++
	if TMPX->(!EOF())
		While TMPX->(!EOF())
		
		   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		   //ณ Verifica o cancelamento pelo usuario...                             ณ
		   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		   If lAbortPrint
		      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		      Exit
		   Endif
		
		   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		   //ณ Impressao do cabecalho do relatorio. . .                            ณ
		   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		   If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		      nLin := 8
		   Endif
		
		   // Coloque aqui a logica da impressao do seu programa...
		   // Utilize PSAY para saida na impressora. Por exemplo:
		   cMaq:=TMPX->Z00_MAQ 
		   
		
		   Do While TMPX->(!EOF()) .AND. TMPX->Z00_MAQ==cMaq
		
		      If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		        Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		        nLin := 8
		      Endif
				
				If SubStr(TMPX->Z00_MAQ,1,1) <> "E" // Corte Solda
		      
			      If Cnt%2<>0 
			         aAnt:={}
			         Aadd( aAnt, TMPX->Z00_MAQ )
			         Aadd( aAnt, TMPX->Z00_DATA )
			         Aadd( aAnt, TMPX->Z00_HORA )
			         Aadd( aAnt, TMPX->Z00_LADO )
			         Aadd( aAnt, TMPX->C2_PRODUTO )
			         Aadd( aAnt, TMPX->DESC_CAP )
			         Aadd( aAnt, TMPX->B5_ESPESS )
			         Aadd( aAnt, TMPX->TURNO ) 
			         Aadd( aAnt, TMPX->B5_CAPACID )
			      endif        
			
			      If Cnt%2=0   
			         If ALLTRIM(TMPX->Z00_MAQ)== ALLTRIM(aAnt[1])  // maquinas iguais  
			            if ALLTRIM(TMPX->Z00_LADO)<>ALLTRIM(aAnt[4]) // lados diferentes 
			               if SUBSTR(TMPX->C2_PRODUTO,2,1)<>SUBSTR(aAnt[5],2,1) // Litragem diferente                
			                   If fDifData(STOD(aAnt[2]),STOD(TMPX->Z00_DATA),aAnt[3],TMPX->Z00_HORA) <= 2 // horas para conjugar (ate duas 2 )
			                      fConju(SUBSTR(aAnt[5],2,1),SUBSTR(TMPX->C2_PRODUTO,2,1),@nLin,TMPX->Z00_MAQ,ABS( aAnt[7] - TMPX->B5_ESPESS ),Cnt,aAnt )                    
			                   Endif
			               Endif   
			            Endif
			         Endif
			      Endif
			      Cnt+=1
				
				Else  //extrusora
				
					Do Case
					Case AllTrim(TMPX->Z00_MAQ) $ "E01"
						
						If TMPX->B5_LARGFIL > 173 .OR. TMPX->B5_LARGFIL < 145
						
							cTexto		:= "Produ็ใo gerada fora do padrใo. Entre 145cm e 173cm"
							lImpBob	:= .T.
						EndIf
					Case AllTrim(TMPX->Z00_MAQ) $ "E02"
						
						If TMPX->B5_LARGFIL > 153 .OR. TMPX->B5_LARGFIL < 129
						
							cTexto		:= "Produ็ใo gerada fora do padrใo. Entre 129cm e 153cm"
							lImpBob	:= .T.
						EndIf
					Case AllTrim(TMPX->Z00_MAQ) $ "E03"
						
						If TMPX->B5_LARGFIL > 134 .OR. TMPX->B5_LARGFIL < 113
						
							cTexto		:= "Produ็ใo gerada fora do padrใo. Entre 113cm e 134cm"
							lImpBob	:= .T.
						EndIf
					Case AllTrim(TMPX->Z00_MAQ) $ "E04"
						
						If TMPX->B5_LARGFIL > 115 .OR. TMPX->B5_LARGFIL < 97
						
							cTexto		:= "Produ็ใo gerada fora do padrใo. Entre 97cm e 115cm"
							lImpBob	:= .T.
						EndIf
					Case AllTrim(TMPX->Z00_MAQ) $ "E05"
						
						If TMPX->B5_LARGFIL > 96 .OR. TMPX->B5_LARGFIL < 81
						
							cTexto		:= "Produ็ใo gerada fora do padrใo. Entre 81cm e 96cm"
							lImpBob	:= .T.
						EndIf
						
					EndCase
					
					If lImpBob
					
						@nLin,00 PSAY TMPX->Z00_MAQ
						@nLin,10 PSAY DTOC(STOD(TMPX->Z00_DATA))+' '+TMPX->Z00_HORA
						@nLin,28 PSAY TMPX->Z00_LADO
						@nLin,32 PSAY TMPX->C2_PRODUTO
						//@nLin,42 PSAY TMPX->DESC_CAP
						@nLin,54 PSAY TMPX->B5_LARGFIL
						@nLin,64 PSAY TMPX->TURNO
						@nLin++,72 PSAY cTexto
						//@nLin++,00 PSAY replicate('_',220)       
						
						lImpBob 	:= .F.
					EndIf
					
				EndIf
		      IncRegua()
		      TMPX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
		
		   EndDo
		      if Cnt%2=0 // evita que um registro de uma maquina case com a de outra maquina (ex: C01 COM C02)
		         Cnt+=1 
		      Endif        
		      cntPar:=1 // contador da paridade volta para um a cada mudan็a da maquina 
		EndDo
	else
   //	    @nLin++,00 PSAY " Sem Ocorrencia " 
   //    @nLin++
	endif
	
	TMPX->(DbCloseArea())
	
	if nTocD > 0
	   @nLin++
	   @nLin++,00 PSAY "Numero de Ocorrencia do Dia( "+dtoc(dDataI)+" ) : "+alltrim(str(nTocD))
	   @nLin++
//	   nDias+=1
	else
	   @nLin++,00 PSAY " Sem Ocorrencia " 
	   @nLin++
	endif
	
	If dow(dDataI)=1 // Nao conta o domingo 
       nDomi+=1	
	EndIf
    nDias+=1		
	dDataI+=1
	nTocD:=0
Enddo

  
@nLin++,00 PSAY replicate('_',19)       
@nLin++,00 PSAY "Total de Ocorrencia: "+alltrim(str(nTocDT))
@nLin++,00 PSAY "Dias no Periodo    : "+alltrim(str(nDias))
@nLin++,00 PSAY "Domingos           : "+alltrim(str(nDomi))
@nLin++,00 PSAY "Media de Ocorrencia: "+alltrim(str(round(nTocDT/(nDias-nDomi),2)))
@nLin++,00 PSAY replicate('_',19)       


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

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
        
***************

Static Function fConju(cAntes,cDepois,nLin,cMaq,nDifEsp,cnt,aAnt)

***************
Local cTexto:=''
local lOk:=.F.

If cAntes='A' 
   if !cDepois $ 'D'
      lOk:=.T.
      cTexto:=" Produtos 200 Litros devem operar conjugado com 100 Litros"
   else 
      if alltrim(cMaq)='C01' .AND. nDifEsp>0.0003
         lOk:=.T.
         cTexto:=' Dif de Espessura: '+ alltrim(str(nDifEsp))
      Endif
   endif
endif

If cAntes='D' 
   if !cDepois $ 'A/E/F'
      lOk:=.T.
      cTexto:=" Produtos 100 Litros devem operar conjugado com 200 ou 90 ou 60 Litros"   
   else 
      if alltrim(cMaq)='C01' .AND. nDifEsp>0.0003
         lOk:=.T.
         cTexto:=' Dif de Espessura: '+ alltrim(str(nDifEsp))
      Endif
   endif
endif
 
If cAntes='E' 
   if !cDepois $ 'D/F'
      lOk:=.T.
      cTexto:=" Produtos 90 Litros devem operar conjugado com 100 ou 60 Litros"
   else 
      if alltrim(cMaq)='C01' .AND. nDifEsp>0.0003
         lOk:=.T.
         cTexto:=' Dif de Espessura: '+ alltrim(str(nDifEsp))
      Endif
   endif
endif

If cAntes='F' 
   if !cDepois $ 'D/E/G/H'
      lOk:=.T.
      cTexto:= " Produtos 60 Litros devem operar conjugado com 100 ou 90 ou 50 ou 40 Litros"
   else 
      if alltrim(cMaq)='C01' .AND. nDifEsp>0.0003
         lOk:=.T.
         cTexto:=' Dif de Espessura: '+ alltrim(str(nDifEsp))
      Endif
   endif
endif

If cAntes='G' 
   if !cDepois $ 'F/H/I'
      lOk:=.T.
      cTexto:= " Produtos 50 Litros devem operar conjugado com 60 ou 40 ou 30 Litros"
   else 
      if alltrim(cMaq)='C01' .AND. nDifEsp>0.0003
         lOk:=.T.
         cTexto:=' Dif de Espessura: '+ alltrim(str(nDifEsp))
      Endif
   endif
endif

If cAntes='H' 
   if !cDepois $ 'F/G/J/I'
      lOk:=.T.
      cTexto:=" Produtos 40 Litros devem operar conjugado com 60 ou 50 ou 20 ou 30 Litros"
   else 
      if alltrim(cMaq)='C01' .AND. nDifEsp>0.0003
         lOk:=.T.
         cTexto:=' Dif de Espessura: '+ alltrim(str(nDifEsp))
      Endif
   endif
endif

If cAntes='I' 
   if !cDepois $ 'H/G/J/K'
      lOk:=.T.
      cTexto:= " Produtos 30 Litros devem operar conjugado com 40 ou 50 ou 20 ou 15 Litros"
   else 
      if alltrim(cMaq)='C01' .AND. nDifEsp>0.0003
         lOk:=.T.
         cTexto:=' Dif de Espessura: '+ alltrim(str(nDifEsp))
      Endif
   endif
endif

If cAntes='J' 
   if !cDepois $ 'H/I/K'
      lOk:=.T.
      cTexto:= " Produtos 20 Litros devem operar conjugado com 40 ou 30 ou 15 Litros"
   else 
      if alltrim(cMaq)='C01' .AND. nDifEsp>0.0003
         lOk:=.T.
         cTexto:=' Dif de Espessura: '+ alltrim(str(nDifEsp))
      Endif
   endif
endif

If cAntes='K' 
   if !cDepois $ 'J/I'
      lOk:=.T.
      cTexto:= " Produtos 15 Litros devem operar conjugado com 20 ou 30 Litros"
   else 
      if alltrim(cMaq)='C01' .AND. nDifEsp>0.0003
         lOk:=.T.
         cTexto:=' Dif de Espessura: '+ alltrim(str(nDifEsp))
      Endif
   endif
endif

if lOk
   fImpr(@nLin,Cnt,aAnt,cTexto,Cmaq) 
   lOk:=.F.                      
Endif


Return 

***************

Static Function fImpr(nLin,Cnt,aAnt,cTexto,cMaq)

***************
local lOkAnt:=.F.
local lOkProx:=.F.

if cntPar=1
   lOkAnt:=.T.
   lOkProx:=.T.
ELSE
// registro anterior 
	If alltrim(aAnt[1])== alltrim(aPariAnt[1]) .AND. alltrim(aAnt[4])== alltrim(aPariAnt[2]) .AND. alltrim(aAnt[5])== alltrim(aPariAnt[3]) 
	   lOkAnt:=.F.
	ELSE
       lOkAnt:=.T.	
	Endif
	If alltrim(aAnt[1])== alltrim(aPariAnt[4]) .AND. alltrim(aAnt[4])== alltrim(aPariAnt[5]) .AND. alltrim(aAnt[5])== alltrim(aPariAnt[6])
	   lOkAnt:=.F.
	ELSE
       lOkAnt:=.T.	
	Endif
// registro atual 
	If alltrim(TMPX->Z00_MAQ)== alltrim(aPariAnt[1]) .AND. alltrim(TMPX->Z00_LADO)== alltrim(aPariAnt[2]) .AND. alltrim(TMPX->C2_PRODUTO)== alltrim(aPariAnt[3])
	   lOkProx:=.F.
    ELSE
	   lOkProx:=.T.	
	Endif
	If alltrim(TMPX->Z00_MAQ)== alltrim(aPariAnt[4]) .AND. alltrim(TMPX->Z00_LADO)== alltrim(aPariAnt[5]) .AND. alltrim(TMPX->C2_PRODUTO)== alltrim(aPariAnt[6])
       lOkProx:=.F.
    ELSE
	lOkProx:=.T.
	Endif
endif

If lOkAnt .AND. lOkProx
    aPariAnt:={}
    Aadd( aPariAnt,aAnt[1] )  // maq   registro anterior 
    Aadd( aPariAnt,aAnt[4] )   // lado
    Aadd( aPariAnt,aAnt[5] )  // produto
    Aadd( aPariAnt,TMPX->Z00_MAQ )    // maq registro atual 
    Aadd( aPariAnt,TMPX->Z00_LADO )   // lado
    Aadd( aPariAnt,TMPX->C2_PRODUTO ) // produto
    // REGISTRO ANTERIOR 
	@nLin,00 PSAY aAnt[1]
	@nLin,10 PSAY DTOC(STOD(aAnt[2]))+' '+aAnt[3]
	@nLin,28 PSAY aAnt[4]
	@nLin,32 PSAY aAnt[5]
	@nLin,42 PSAY aAnt[6]
	@nLin,54 PSAY alltrim(str(aAnt[7]))
	@nLin++,64 PSAY aAnt[8]
	// REGISTRO ATUAL 
	@nLin,00 PSAY TMPX->Z00_MAQ
	@nLin,10 PSAY DTOC(STOD(TMPX->Z00_DATA))+' '+TMPX->Z00_HORA
	@nLin,28 PSAY TMPX->Z00_LADO
	@nLin,32 PSAY TMPX->C2_PRODUTO
	@nLin,42 PSAY TMPX->DESC_CAP
	@nLin,54 PSAY TMPX->B5_ESPESS
	@nLin,64 PSAY TMPX->TURNO
	@nLin++,72 PSAY cTexto
	@nLin++,00 PSAY replicate('_',220)       
    lOkAnt:=.F.
    lOkProx:=.F.
    nTocD+=1
    nTocDT+=1
Endif

cntPar+=1

Return 


****************

Static Function fDifData(dDataIni,dDataFim,cHoraIni,cHorafim )

****************

Local nDifdia := 0
Local cMeiaNoite := "00:00:00"
Local cElap1
Local cHoraspassou := ""
Local nHoraspassou := 0
Local nHorastotal  := 0
Local lSemHrFIM    := .F.
Local lSemHrINI	   := .F.

set date brit

If !Empty(cHoraIni)
	If Len(cHoraIni) <= 5
		cHoraIni := cHoraIni + ":00"
	Endif
Else
	lSemHrINI := .T.
Endif	

If !Empty(cHoraFim)
	If Len(cHoraFim) <= 5
		cHoraFim := cHoraFim + ":00"
	Endif
Else
	lSemHrFIM := .T.
Endif	

nDifdia := (dDataFim - dDataIni)
If !lSemHrFIM .AND. !lSemHrINI
	If nDifdia = 0	
		cElap1 := ElapTime( cHoraIni, cHoraFim ) // Resultado: "01:00:00"
		cHoraspassou := cElap1
		nHoraspassou := Val(Substr(cHoraspassou,1,2))
		nHoraspassou += Val(Substr(cHoraspassou,4,2) ) / 60	
	Else		
		cElap1 := ElapTime(cHoraIni,cMeiaNoite)
		cHoraspassou := cElap1		
		nHoraspassou := Val(Substr(cHoraspassou,1,2) )
		nHoraspassou += Val(Substr(cHoraspassou,4,2) ) / 60
		cElap1 := ElapTime(cMeiaNoite,cHoraFim) 
		cHorasPassou := cElap1
		nHoraspassou += Val(Substr(cHoraspassou,1,2) )
		nHoraspassou += Val(Substr(cHoraspassou,4,2) )  / 60
	Endif
Endif

nHorastotal := nHoraspassou


Return(nHorastotal)
