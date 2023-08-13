#include "rwmake.ch"
#include "topconn.ch"
#include "colors.ch"
#include "font.ch"
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบDesc.     ณ Media de atraso.                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rava Embalagens - Cobranca                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function COBC016()

//Verifica se o usuario tem permissao
Dbselectarea("SX5")
Dbseek(xFilial()+"ZY07")
If !UPPER(Trim(Subst(cUsuario,7,15))) $ SX5->X5_DESCRI
   Alert("Usuario sem permissao!!!")
   Return .t.
Endif        

******** VARIAVEIS UTILIZADAS **********
nDias  := 0    
dUltDia := GETMV("MV_ULMEDIA")

******** JANELA DE DIALOGO PRINCIPAL **********

@ 000,000 To 100,350 Dialog oDLG1 Title OemToAnsi( "Calcular Media de Atraso" )

@ 006,005 Say OemToAnsi("Quantos Dias :") COLOR CLR_HBLUE
@ 006,050 Get nDias Picture "@E 999" SIZE 35,30 Valid nDias > 0

@ 006,095 Say OemToAnsi("Ult Atualizacao :") COLOR CLR_HBLUE
@ 006,145 Say Dtoc(dUltDia) COLOR CLR_HBLUE

@ 025,050 Button OemToAnsi("_Confirma") Size 40,12 Action ProcMedia() Object oCONFIRMA //ProcPreAc()
@ 025,100 Button OemToAnsi("_Sair") Size 40,12 Action oDLG1:End() Object oSAIRMedia

Activate Dialog oDLG1 Centered //Valid SairMedia()

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC016   บAutor  ณMicrosiga           บ Data ณ  02/03/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ProcMedia()

Processa({|| CalcMedia() })

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  02/01/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SairMedia

If MsgBox( "Confirma saida do programa?", "Escolha", "YESNO" )
	Close( oDLG1 )
	Return .T.
EndIf

Return .F.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC011   บAutor  ณMicrosiga           บ Data ณ  01/31/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CalcMedia()

PutMv("MV_ULMEDIA",dDatabase)

dbselectarea("SE1")
For nJ := 1 To 2
	If nJ == 1
		cQUERY := "Select Count(DISTINCT A1_COD) as NUMTIT"
	Else
		cQUERY := "Select A1_COD,A1_LOJA,A1_NOME,MAX(SE1.E1_EMISSAO) as DATAMAX "
	EndIf
	cQUERY += " From " + RetSqlName( "SA1" ) + " SA1, "+ RetSqlName( "SE1" ) + " SE1 "
	cQUERY += " Where A1_COD+A1_LOJA = E1_CLIENTE+E1_LOJA AND SE1.E1_VENCREA < '"+Dtos(dDataBase)+"' "  
	cQUERY += " AND E1_TIPO IN ( 'NF ', 'CH ', 'DP ', 'R$ ', 'FI ' ) AND LEFT(E1_NATUREZ,3) <> '105' AND E1_ORIGEM <> 'FINA460' " //Mudar para naturezas usadas na Rava
	cQUERY += " AND E1_NUMLIQ = '' AND SA1.D_E_L_E_T_ = '' AND SE1.D_E_L_E_T_ = ''"
	If nJ == 2
		cQUERY += " GROUP BY SA1.A1_COD, SA1.A1_LOJA,A1_NOME "
		cQUERY += " ORDER BY SA1.A1_COD, SA1.A1_LOJA "
	Endif	
	cQUERY := ChangeQuery( cQUERY )
	If nJ == 1
		TCQUERY cQUERY Alias TITSE1 New   
		TCSetField("TITSE1", "NUMTIT","N",12,0)
		nREG := TITSE1->NUMTIT
		TITSE1->( DBCLOSEAREA() )
	Else
		TCQUERY cQUERY Alias TITSE1 New
	Endif
Next

//Cria arquivo temporario com o alias TMPSA1
TCSetField("TITSE1", "DATAMAX","D",08,2)

//Carrega arquivo de trabalho criado com os dados da consulta
Dbselectarea("TITSE1")
dbgotop()
ProcRegua( nReg )

While !Eof()

	IncProc( "Processando Cliente "+ TITSE1->A1_COD + "/" + TITSE1->A1_LOJA + " - " + TITSE1->A1_NOME )
	cQUERY := "Select E1_VENCREA,E1_BAIXA "
	cQUERY += " From " + RetSqlName( "SE1" ) + " SE1 "
	cQUERY += " Where E1_CLIENTE+E1_LOJA = '"+TITSE1->A1_COD+TITSE1->A1_LOJA+"' AND SE1.E1_VENCREA < '"+Dtos(dDataBase)+"' "   
	cQuery += " AND E1_EMISSAO BETWEEN "+dTos(TITSE1->DATAMAX-nDias)+" AND "+dTos(TITSE1->DATAMAX)+" "
	cQUERY += " AND E1_TIPO IN ( 'NF ', 'CH ', 'DP ', 'R$ ', 'FI ' ) AND LEFT(E1_NATUREZ,3) <> '105' AND E1_ORIGEM <> 'FINA460' " //Mudar para naturezas usadas na Rava
	cQUERY += " AND E1_NUMLIQ = '' AND SE1.D_E_L_E_T_ = ''"
	cQUERY := ChangeQuery( cQUERY )
	TCQUERY cQUERY Alias TITSA1 New
	TCSetField("TITSA1", "E1_VENCREA","D",08,2)
	TCSetField("TITSA1", "E1_BAIXA","D",08,2)
	Dbselectarea("TITSA1")
	dbgotop()
	nDiasAtr  := 0  //Dias de atraso
	nTitulos  := 0  //Titulos calculados
	nMaiorAtr := 0  //Maios Atraso
	nDiasAcum := 0  //Dias em atraso acumulado
	While !Eof() 
		nTitulos ++
		If Empty(E1_BAIXA)
			nDiasAtr := dDatabase-E1_VENCREA
		Else
			nDiasAtr := E1_BAIXA-E1_VENCREA
		Endif
		If nDiasAtr > nMaiorAtr
			nMaiorAtr := nDiasAtr
		Endif
		nDiasAcum += nDiasAtr
		dbskip()
	End      
	TITSA1->(DbCloseArea())
	nMedAtr := Round(nDiasAcum/nTitulos,0)
	Dbselectarea("SA1")
	Dbsetorder(1)
	If Dbseek(xFilial()+TITSE1->A1_COD+TITSE1->A1_LOJA)
		Reclock("SA1",.F.)
		Replace A1_METR With nMedAtr
		Replace A1_MATR With nMaiorAtr
		msunlock()
	Endif
	Dbselectarea("TITSE1")
	DBSKIP()
End

Dbselectarea("TITSE1")
Dbclosearea("TITSE1")


Dbselectarea("SA1")
dbgotop()


SairMedia()

Return .T.