#include "rwmake.ch"
#INCLUDE "Topconn.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO29    º Autor ³ AP6 IDE            º Data ³  09/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                                                                          							
User Function TMKR001()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "indentificação de problemas CallCenter"
Local cPict          := ""
Local titulo         := "Indentificação de Problemas CallCenter"
Local nLin           := 80
                      //         10        20        30        40        50        60        70        80        90        100       110       120       130        140       150       160
                      //012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Local Cabec1         :=""        
//:= "Nivel 1                        Nivel 2                         Nivel 3                         Nivel 4                         Nivel 5                         OBS "
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "TMKR001" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "TMKR001" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

/*
MV_PAR01 - Responsável de:
MV_PAR02 - Responsável até:
MV_PAR03 - Setor de:
MV_PAR04 - Setor até:
MV_PAR05 - Imprimir: Não resolvido / Resolvido / Todos
						  1				 2   	   3
MV_PAR06 - Tipo de relatório: Sintético / Analítico
								  1			  2
MV_PAR07 - Dt. ocorrência de:
MV_PAR08 - Dt. ocorrência até:
*/

Pergunte("TMKR001",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"TMKR001",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
            //         10        20        30        40        50        60        70        80        90        100       110       120       130        140       150       160       170       180       190       200       210
            //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
/*
IF MV_PAR06==02
	Cabec1:= "Nivel 1                        Nivel 2                         Nivel 3                         Nivel 4                         Nivel 5                         OBS                                                  Dt Ocorr."
ELSE
	Cabec1:= "Nivel 1                        Nivel 2                         Nivel 3                         Nivel 4                         Nivel 5                         Quantidade "
    titulo         := "Indentificação de Problemas CallCenter "+DTOc(MV_PAR07)+' ate '+DTOc(MV_PAR08)
ENDIF
*/   

IF MV_PAR06==02
	Cabec1:= "    Cliente            Nota/Serie   Nivel 1         Nivel 2          Nivel 3                    Nivel 4                                Nivel 5            Dt Ocorr   OBS"
ELSE
	Cabec1:= "    Cliente            Nota/Serie   Nivel 1         Nivel 2          Nivel 3                    Nivel 4                                Nivel 5            Quantidade "
    titulo         := "Indentificação de Problemas CallCenter "+DTOc(MV_PAR07)+' ate '+DTOc(MV_PAR08)
ENDIF

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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  09/04/10   º±±
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
local cQry:=''

if MV_PAR06=02

	cQry:="SELECT UD_OPERADO,UD_N1,UD_N2,UD_N3,UD_N4,UD_N5,CASE WHEN UD_RESOLVI='N' THEN '' ELSE UD_RESOLVI END UD_RESOLVI,UD_OBS,UC_DATA, UD_DTINCLU "
	
	cQry += " ,UC_CODIGO, UC_NFISCAL, UC_SERINF, UC_CHAVE, A1_NREDUZ "
	
	cQry+="FROM SUD020 SUD,SUC020 SUC  "
	
	cQry += " ," + RetSqlName("SA1") + " SA1 "
	cQry+="where UD_OPERADO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	cQry+="AND UD_N2 BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
   	//cQry+="AND UC_DATA BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
   	cQry+="AND UD_DTINCLU BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
	cQry+="AND UD_OPERADO!='' "
	cQry+="AND UC_CODIGO=UD_CODIGO "
	
	cQry += " AND RTRIM(UC_CHAVE) = RTRIM(A1_COD+A1_LOJA) "
	cQry+="AND SA1.D_E_L_E_T_!='*'   "
	
	cQry+="AND SUD.D_E_L_E_T_!='*'   "
	cQry+="AND SUC.D_E_L_E_T_!='*'   "
	//cQry+="ORDER BY UD_OPERADO,UD_RESOLVI,UC_DATA "
	cQry+="ORDER BY UD_OPERADO,UD_RESOLVI,UD_DTINCLU "	//ALTERADO POR FLÁVIA POIS NÃO HAVIA CAMPO NO ITEM QUE INDICASSE A DATA DE SUA INCLUSÃO
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////28/04/2010 - O CAMPO UC_DATA É A DATA QUE FOI ABERTO O ATENDIMENTO, MAS NEM SEMPRE SÃO INCLUÍDOS ITENS NO DIA EM QUE SE ABRE O ATENDIMENTO,
	////PODE OCORRER DO OPERADOR DO CALL CENTER INCLUIR ITENS DIA(S) APÓS A ABERTURA DO ATENDIMENTO, ENTÃO CRIEI O CAMPO UD_DTINCLU
	////QUE É A DATA DE INCLUSÃO DO ITEM, INICIALIZADO AUTOMATICAMENTE PELA dDATABASE DO SISTEMA.
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	TCQUERY cQry NEW ALIAS "AUUX"
	
Else

	cQry:="SELECT UD_OPERADO,CASE WHEN UD_RESOLVI='N' THEN '' ELSE UD_RESOLVI END UD_RESOLVI,UD_N1+UD_N2+UD_N3+UD_N4+UD_N5 NIVEL,COUNT(*) QTD "
	
	cQry += " ,UC_CODIGO,UC_NFISCAL, UC_SERINF, UC_CHAVE, A1_NREDUZ "	
	
	cQry+="FROM SUD020 SUD,SUC020 SUC  "
	
	cQry += " ," + RetSqlName("SA1") + " SA1 "
	
	
	cQry+="where UD_OPERADO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	cQry+="AND UD_N2 BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
    cQry+="AND UD_DTINCLU BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
	cQry+="AND UC_CODIGO=UD_CODIGO "
	cQry+="AND UD_OPERADO!='' "
	
	cQry += " AND RTRIM(UC_CHAVE) = RTRIM(A1_COD+A1_LOJA) "
	cQry+="AND SA1.D_E_L_E_T_!='*'   "
	
	cQry+="AND SUD.D_E_L_E_T_!='*'   "
	cQry+="AND SUC.D_E_L_E_T_!='*'   "
	cQry+="GROUP BY UD_OPERADO,CASE WHEN UD_RESOLVI='N' THEN '' ELSE UD_RESOLVI END,UD_N1+UD_N2+UD_N3+UD_N4+UD_N5 "
	
	cQry += " , UC_CODIGO,UC_NFISCAL,UC_SERINF,UC_CHAVE, A1_NREDUZ "
	
	cQry+="ORDER BY UD_OPERADO,UD_RESOLVI,NIVEL  "

    TCQUERY cQry NEW ALIAS "AUUX"

EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nConta := 1
AUUX->( dbGoTop() )

While AUUX->(!EOF())  

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
  cOperado:=AUUX->UD_OPERADO
  
  //If nConta = 1
	 // @nLin,000 PSAY "Cliente: " + Alltrim( Substr(AUUX->A1_NREDUZ,1,20) ) 
	 // @nLin,033 PSAY " - Nota Fiscal/Serie: " + Alltrim(AUUX->UC_NFISCAL) + "/" + Alltrim(AUUX->UC_SERINF)
	 // nLin++
  //Endif
  
  @nLin++,00 PSAY "Responsavel: "+ NomeOp( cOperado ) 
  @nLin++,00 PSAY replicate("-",30)
  While AUUX->(!EOF())  .AND. AUUX->UD_OPERADO == cOperado    
    
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	      nLin := 8
	    Endif

	    IF AUUX->UD_RESOLVI!='S'    .AND. (MV_PAR05=1 .OR. MV_PAR05=3)
	
		   	//If nConta > 1
			   	//@nLin,000 PSAY "Cliente: " + Alltrim( Substr(AUUX->A1_NREDUZ,1,20) ) 
		  		//@nLin,033 PSAY " - Nota Fiscal/Serie: " + Alltrim(AUUX->UC_NFISCAL) + "/" + Alltrim(AUUX->UC_SERINF)
		  		//nLin++
			//Endif
	  		
		   @nLin++,00 PSAY "Não Resolvido" 
		   @nLin++,00 PSAY replicate("-",220)
		   Do While AUUX->(!EOF())  .AND. AUUX->UD_OPERADO == cOperado .AND. AUUX->UD_RESOLVI!='S' 
		      
		      If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	             Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	             nLin := 8
	          Endif
	
		      TipoRel(Cabec1,Cabec2,Titulo,@nLin)
		      
	          IncRegua()
	          AUUX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	       Enddo
	       @nLin++,00 PSAY replicate("-",220)
    	ELSEIF AUUX->UD_RESOLVI=='S'  .AND. (MV_PAR05=2 .OR. MV_PAR05=3)
    
	    	//@nLin,000 PSAY "Cliente: " + Alltrim( Substr(AUUX->A1_NREDUZ,1,20) ) 
	  		//@nLin,033 PSAY " - Nota Fiscal/Serie: " + Alltrim(AUUX->UC_NFISCAL) + "/" + Alltrim(AUUX->UC_SERINF)
	  		//nLin++	   

		   @nLin++,00 PSAY "Resolvido" 
		   @nLin++,00 PSAY replicate("-",220)
		   Do While AUUX->(!EOF())   .AND. AUUX->UD_OPERADO==cOperado .AND. AUUX->UD_RESOLVI=='S'
	          
	          If nLin  > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	             Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	             nLin := 8
	          Endif
	
	          TipoRel(Cabec1,Cabec2,Titulo,@nLin)
	          
	          IncRegua()
	          AUUX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	       Enddo
	       @nLin++,00 PSAY replicate("-",220)
    	ELSE
      		AUUX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
    	ENDIF
  ENDDO    

EndDo

AUUX->(DbCloseArea())

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

Static Function wordWrap( cText, nRegua )

***************

Local aRet  := {}
Local cTemp := ''
Local i 	:= 1
cTemp := memoline( cText, nRegua, i, 4, .T. )
do while len( cTemp ) > 0
	aAdd(aRet, { alltrim(cTemp) } )
	i++
	cTemp := memoline( cText, nRegua, i, 4, .T. )
endDo

Return aRet   


***************

Static Function NomeOp( cOperado )

***************
PswOrder(1)
If PswSeek( cOperado, .T. )
   aUsuarios  := PSWRET() 					
   cNome := Alltrim(aUsuarios[1][2])     	// Nome do usuário
Endif 

return cNome

***************

Static Function TipoRel(Cabec1,Cabec2,Titulo,nLin)

***************

//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22       
//999999/99  XXXXXXXXXX 999999999/XXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXX  99/99/99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX     
// COD.CLI   NOME        NOTA/SERIE     NIVEL1        NIVEL 2         NIVEL 3                    NIVEL 4
If MV_PAR06==02
	
	@nLin,00 PSAY Substr(AUUX->UC_CHAVE,1,6) + "/" + Substr(AUUX->UC_CHAVE,7,2) + "-"
	@nLin,11 PSAY ALLTRIM(Substr(AUUX->A1_NREDUZ,1,10))
	@nLin,22 PSAY ALLTRIM( AUUX->UC_NFISCAL ) + "/" + ALLTRIM(AUUX->UC_SERINF)
	
	@nLin,36 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+AUUX->UD_N1,"Z46_DESCRI"),1,15) 	//nivel 1 - max 15
	@nLin,52 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+AUUX->UD_N2,"Z46_DESCRI"),1,15)  	//nivel 2 - max 15
	@nLin,68 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+AUUX->UD_N3,"Z46_DESCRI"),1,30) 	//nivel 3 - max 25
	@nLin,95 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+AUUX->UD_N4,"Z46_DESCRI"),1,30) 	//nivel 4 - max 40
	@nLin,137 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+AUUX->UD_N5,"Z46_DESCRI"),1,30) 	//nivel 5 - 
	//@nLin,212 PSAY DTOC(STOD(AUUX->UC_DATA))
	@nLin,154 PSAY DTOC(STOD(AUUX->UD_DTINCLU))
	iif(len( alltrim(AUUX->UD_OBS))>=50,aDesc := wordWrap( ALLTRIM(AUUX->UD_OBS),50 ),aDesc := wordWrap( ALLTRIM(AUUX->UD_OBS), LEN(ALLTRIM(AUUX->UD_OBS)) ) )
	For x:=1 to len(aDesc)
		
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		@nLin++,163 PSAY aDesc[x][1]
	Next
	if len(adesc)=0
		nLin++
	endif
	
ELSE

	@nLin,00 PSAY Substr(AUUX->UC_CHAVE,1,6) + "/" + Substr(AUUX->UC_CHAVE,7,2) + "-"
	@nLin,11 PSAY ALLTRIM(Substr(AUUX->A1_NREDUZ,1,10))
	@nLin,22 PSAY ALLTRIM( AUUX->UC_NFISCAL ) + "/" + ALLTRIM(AUUX->UC_SERINF)
	//@nLin,00 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+SUBSTR(AUUX->NIVEL,1,4),"Z46_DESCRI"),1,30)
	//@nLin,21 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+SUBSTR(AUUX->NIVEL,1,4),"Z46_DESCRI"),1,30)
	@nLin,36 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+SUBSTR(AUUX->NIVEL,1,4),"Z46_DESCRI"),1,15)	//nivel 1
	@nLin,52 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+SUBSTR(AUUX->NIVEL,5,4),"Z46_DESCRI"),1,15)  	//nivel 2
	@nLin,68 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+SUBSTR(AUUX->NIVEL,9,4),"Z46_DESCRI"),1,30)  	//nivel 3
	@nLin,95 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+SUBSTR(AUUX->NIVEL,13,4),"Z46_DESCRI"),1,30) 	//nivel 4
	@nLin,137 PSAY SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+SUBSTR(AUUX->NIVEL,17,4),"Z46_DESCRI"),1,30)	//nivel 5
	@nLin++,158 PSAY AUUX->QTD
	
EndIf


Return