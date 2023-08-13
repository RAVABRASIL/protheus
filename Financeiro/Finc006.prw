#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch"
*************
User Function FINC006()
//          
 U_Modelo1(;
           "Cadastro de Metas para Gestores",; //nome para tela 
           "Z74",;                             //alias
           1;                                  //ordem
           )
 return
 
*************
User Function rubem1()
//          
 U_ModeloREL(;
           "finr0012",;     //nome do programa 
           "P",;            // tamanho do relatorio
           "FINR003",;             // pergunta
           .T.,;               // modo da pergunta
           "titulo  ",;     // titulo
           "cabec 1 ",;     // cabec1
           "cabec 2 ",;     // cabec2
           {},;             // ordem
           "U_execRel";              // chamada para a logica do relatorio
           )                //
            
 return  
 
 
 
 User function execRel(Cabec1,Cabec2,Titulo,nomeprog,nLin,TAMANHO,nTipo)
 
 Local nOrdem
Local cQuery:=" "
Local nCont:=nTotal:=0
cQuery:=""
cQuery+=" Select "                          +chr(10)
cQuery+="   Z62_CODIGO COD    , "           +chr(10)
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
cQuery+="   Z62_REMARC REMARC , "           +chr(10)
cQuery+="   Z62_DTFAT  DTFAT    "           +chr(10)
cQuery+=" From "+RetSqlName('Z62')+" Z62  " +chr(10)
cQuery+=" where                           " +chr(10)
cQuery+="   D_E_L_E_T_='' and   "           +chr(10)
cQuery+="   Z62_DTFAT between   "           +chr(10)
cQuery+=valtoSql(dtos(MV_PAR01))+"  and   " +chr(10)
cQuery+=valtoSql(dtos(MV_PAR02))            +chr(10)
IF MV_PAR03==1 
    cQuery+="  ORDER BY Z62_COMP  ,Z62_MATRIC"  +chr(10)
ELSE
	cQuery+="  ORDER BY Z62_MATRIC,Z62_COMP  "  +chr(10)	
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
	                     //         0         0         0         0         0         0         0         0         0         1         1         1         1         1         1         1         1         1         1         2         3         4
	                     //         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2
	                     //1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		Cabec1         := "Fatura   | Bilhete         |                Data                  | Companhia aerea                       |   Passageiro    |  Trecho                                  | Passagem  + Extras  | Ml acumuladas |     "
		Cabec2         := "         |                 |    Ida     |   Volta    | Fatura     |                                       |                 |                                          |                     |               |     "
		Cabec3         := "         |                 |            |            |            |                                       |                 |                                          |                     |               |     "
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,tamanho,nTipo)
		nLin := 9
		
	Endif

	IF MV_PAR03==1
	cGrupo:=AUUX->COMP	
	ELSE
	cGrupo:=AUUX->MATRIC
		
	ENDIF
	
	nValor:=0
	nMilhasAc:=0
	nBilhete:=0
	//@nLin++ ,000  PSAY replicate("_",220)
    nLin++
	While cGrupo == iif(MV_PAR03==1,AUUX->COMP,AUUX->MATRIC)

		//@nLin  ,000  PSAY Cabec3
		//@nLin  ,000  PSAY replicate("_",220)
		@nLin  ,000  PSAY AUUX->FATURA
		@nLin  ,012  PSAY AUUX->BILHET
		@nLin  ,030  PSAY dtoc(stod(AUUX->DTVIAG))
		@nLin  ,043  PSAY dtoc(stod(AUUX->DTVOLT))
		@nLin  ,056  PSAY dtoc(stod(AUUX->DTFAT))
		
		cComp:=Posicione('SX5',1,xFilial("SX5")+'Z7'+ALLTRIM(AUUX->COMP),"X5_DESCRI")
		@nLin  ,068  PSAY cComp
		
		
		cNome:=U_Usu_Cod2Nome(AUUX->MATRIC) //AUUX->MATRIC
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
		
		cSubQry:=" SELECT sum(Z72_VALOR) EXT      " +chr(10)
		cSubQry+=" FROM "+RetSqlName('Z72')+" Z72 " +chr(10)
		cSubQry+=" where                          " +chr(10)
		cSubQry+=" Z72_COD="+ValToSql(AUUX->COD)    +chr(10)
		cSubQry+=" and D_E_L_E_T_=' '             " +chr(10)
		TCQUERY cSubQry NEW ALIAS 'SUB'
		
		IF SUB->(!EOF())
		@nLin  ,(179 )  PSAY " + "+transform(SUB->EXT  , "@E 9,999.99")
		ENDIF
		@nLin  ,(194 )  PSAY transform(AUUX->MILHAS , "@E 999,999.99") + F_status()
		
	
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
	@nLin,000 PSAY 'Nª de bilhetes para '+alltrim(iif(MV_PAR03==1,cComp,cNome))+' = '+alltrim(str(nBilhete))
	
	@nLin  ,(160)  	PSAY "Total  |"+transform(nValor , "@E 999,999.99")+"           |"
	@nLin++  ,(193 )  PSAY transform(nMilhasAc, "@E 999,999.99")
   
	nML+=nMilhasAc
	nSaldo+=nValor
	nTotal+=nBilhete
	nLin++
	
EndDo
@nLin++,000  PSAY replicate("_",220)
//@nLin++ ,000  PSAY replicate("_",220)

@nLin++,000 PSAY 'Total de bilhetes  = '+alltrim(str(nTotal))

    @nLin    ,(160) PSAY "Total  |"+transform(nSaldo , "@E 999,999.99")+"           |"
    @nLin++  ,(193)  PSAY transform(nML, "@E 999,999.99")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 
AUUX-> (dbcloseArea()) 
nLin++
 //@nLin++  ,000 PSAY  __PrtThinLine()
 
 return                
 
 
 
 
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
 