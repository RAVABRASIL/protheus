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

User Function PCPR009()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Controle de Parada de Maquina "
Local cPict          := ""
Local titulo         := "Controle de Maquina "
Local nLin           := 80
                      //          10        20        30        40        50        60        70        80        90        100       110       120       130
                      //012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Local Cabec1         := "  /-------- T U R N O 1 ---------\/-------- T U R N O 2 ---------\/-------- T U R N O 3 ---------\/--------  T O T A L  --------\"
Local Cabec2         := "   Duracao    Maq. Ligada     %    Duracao    Maq. Ligada     %    Duracao    Maq. Ligada     %    Duracao    Maq. Ligada     %  "
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "PCPR009" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PCPR009" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

Pergunte("TURPRD",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"TURPRD",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

titulo := "Controle de Maquina de "+DTOC(MV_PAR01) +" ate " +DTOC(MV_PAR02) 

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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  12/07/10   º±±
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
Local cQry:=''

nDias:= MV_PAR02 - MV_PAR01
nDias+=1


cTURNO1   := GetMv( "MV_TURMAQ1" )
cTURNO2   := GetMv( "MV_TURMAQ2" )
cTURNO3   := GetMv( "MV_TURMAQ3" )

nDURACAO1:= valor(nDias,SubStr( cTURNO1, 7, 5)+":00",.F.,.T.)
nDURACAO2:= valor(nDias,SubStr( cTURNO2, 7, 5)+":00",.F.,.F.) 
nDURACAO3:= valor(nDias,SubStr( cTURNO3, 7, 5)+":00",.T.,.F.) 
/*
nHORA1:=valor(1,Left( cTURNO1, 5 )+ ":00")
nHORA2:=valor(1,Left( cTURNO2, 5 )+ ":00")
nHORA3:=valor(1,Left( cTURNO3, 5 )+ ":00")
*/

nHORA1:=Left( cTURNO1, 5 )+ ":00"
nHORA2:=Left( cTURNO2, 5 )+ ":00"
nHORA3:=Left( cTURNO3, 5 )+ ":00"

cQry:="SELECT CAST(CAST(Z58_HORA AS DATETIME) AS FLOAT) Z58_DECIMAL,* "
cQry+="FROM Z58020 Z58 "
cQry+="WHERE  Z58.D_E_L_E_T_!='*' "
cQry+="AND Z58_DATA >= '" + Dtos( mv_par01 ) + "' AND Z58_DATA <= '" + Dtos( mv_par02 + 1 ) + "' "
//teste
//cQry+="AND Z58_MAQ='P03 ' "                	
//cQry+="AND Z58_CANAL='1'  "  
//cQry+="AND Z58_STATUS='0' "
//cQry+="AND Z58_DATA >= '20100705' AND Z58_DATA <= '20100706' "
//cQry+="AND Z58_HORA>='05:35:00'AND Z58_HORA<='14:00:00' " // 1
//cQry+="AND Z58_HORA>='14:00:00'AND Z58_HORA<='22:00:00' " // 2
//cQry+="AND ( (Z58_DATA ='20100705' AND Z58_HORA>='22:00:00')  OR  (Z58_DATA='20100706' AND Z58_HORA <= '05:35:00') )" // 3
//

cQry+="ORDER BY Z58_MAQ,Z58_CANAL,Z58_DATA,Z58_HORA "		
TCQUERY cQry NEW ALIAS "Z58X"

TCSetField( 'Z58X', "Z58_DATA", "D" )

                                	
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

Z58X->( dbGoTop() )

While Z58X->( !EOF() ) 

    cMaq:=Z58X->Z58_MAQ
    
    cStaAnt:='0'
    
    //cDtLig3A:=cDtLig3B:=''
    //cDtdes3A:=cDtdes3B:=''
    // VARIAVEIS PARA O LADO A 
    nTempLig1A:=nTempLig2A:=nTempLig3A:='00:00:00'//0 
    nTempDes1A:=nTempDes2A:=nTempDes3A:='00:00:00'//0
    // VARIAVEIS PARA O LADO B  
    nTempLig1B:=nTempLig2B:=nTempLig3B:='00:00:00'//0
    nTempDes1B:=nTempDes2B:=nTempDes3B:='00:00:00'//0
    // VARIAVEIS INICIAL DE CADA TURNO
     // Lado A                                               	
     cSI1A:=cSI2A:=cSI3A:=''
     nHI1A:=nHI2A:=nHI3A:='00:00:00'//0
    // Lado B
     cSI1B:=cSI2B:=cSI3B:=''
     nHI1B:=nHI2B:=nHI3B:='00:00:00' //0
     
    // VARIAVEIS FINAL DE CADA TURNO
     // Lado A
     cSF1A:=cSF2A:=cSF3A:=''
     nHF1A:=nHF2A:=nHF3A:='00:00:00' //0
     // Lado B
     cSF1B:=cSF2B:=cSF3B:=''
     nHF1B:=nHF2B:=nHF3B:='00:00:00' //0
     
     // TEMPO TOTAL LIGADO
     nTotTL1A:=nTotTL2A:=nTotTL3A:='00:00:00' //0 
     nTotTL1B:=nTotTL2B:=nTotTL3B:='00:00:00' //0 
     // % 
     nPer1A:=nPer2A:=nPer3A:=0
     nPer1B:=nPerB:=nPer3B:=0
     //variaveis logicas
     lOk1A:=lOk2A:=lOk3A:=.T.
     lOk1B:=lOk2B:=lOk3B:=.T.
     
    
    Do While Z58X->( !EOF() ) .AND. Z58X->Z58_MAQ=cMaq
		// 1ª Turno
		If Z58X->Z58_DATA <= mv_par02 .and. Z58X->Z58_HORA >= Left( cTURNO1, 5 )+ ":00" .and. Z58X->Z58_HORA <= U_Somahora( Left( cTURNO1, 5 ) + ":00", SubStr( cTURNO1, 7, 5 ) + ":00" )
		     
		    If Z58X->Z58_CANAL='0'  // LADO A 
		       If lOk1A
		          If Z58X->Z58_STATUS='0' 	             
		             nTotTL1A:=SomaHora(nTotTL1A,TempoLig(Z58X->Z58_HORA,nHORA1))
		             cStaAnt:=Z58X->Z58_STATUS
		             Z58X->(dbSkip()) 
   		             //incregua()
		          else
		             cStaAnt:='0'    
		          endif              
		          lOk1A:=.F.
		       endif   
		       
		       If Z58X->Z58_STATUS='1'  .and.  cStaAnt!=Z58X->Z58_STATUS   // MAQUINA LIGADA
		          nTempLig1A:=Z58X->Z58_HORA
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip()) 
		          //incregua()
		       endif                           		
		       
		       If  cStaAnt=Z58X->Z58_STATUS 
		           cStaAnt:=Z58X->Z58_STATUS
		           Z58X->(dbSkip())    
		           //incregua()
		           loop
		       endif
		       
		       If Z58X->Z58_STATUS='0' .and.  cStaAnt!=Z58X->Z58_STATUS // MAQUINA DESLIGADA
		          If Z58X->Z58_HORA>=nHORA2
		             nTempDes1A:=nHORA2
		             nTotTL2A:=SomaHora(nTotTL2A,TempoLig(Z58X->Z58_HORA,nHORA2))       
		          Else
		             nTempDes1A:=Z58X->Z58_HORA 
		          Endif
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip())
		          //incregua()
		       endif
		       
		       nTotTL1A:= SomaHora(nTotTL1A,TempoLig(nTempDes1A,nTempLig1A))                     

		    
		    elseif Z58X->Z58_CANAL='1' // LADO B
		       If lOk1B
		          If Z58X->Z58_STATUS='0' 
		             nTotTL1B:= SomaHora(nTotTL1B,TempoLig(Z58X->Z58_HORA,nHORA1))
		             cStaAnt:=Z58X->Z58_STATUS
		             Z58X->(dbSkip()) 
		             //incregua()
		          Else
		             cStaAnt:='0'
		          endif
		          lOk1B:=.F.
		       endif   
		       
		       If Z58X->Z58_STATUS='1' .AND. cStaAnt!=Z58X->Z58_STATUS // MAQUINA LIGADA
		          nTempLig1B:=Z58X->Z58_HORA
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip()) 
		          //incregua()
		       endif
		       
		       If  cStaAnt=Z58X->Z58_STATUS 
		           cStaAnt:=Z58X->Z58_STATUS
		           Z58X->(dbSkip())    
		           //incregua()
		           loop
		       endif
		       
		       If Z58X->Z58_STATUS='0' .AND. cStaAnt!=Z58X->Z58_STATUS // MAQUINA DESLIGADA
		          If Z58X->Z58_HORA>=nHORA2
		             nTempDes1B:=nHORA2
		             nTotTL2B:=SomaHora(nTotTL2B,TempoLig(Z58X->Z58_HORA,nHORA2))       
		          Else
		             nTempDes1B:=Z58X->Z58_HORA 
		          Endif
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip())
		          //incregua()
		       endif
		       
		       nTotTL1B:= SomaHora(nTotTL1B,TempoLig(nTempDes1B,nTempLig1B))                     
		       
		    Endif
		    		
		// 2ª truno
		
		elseIf Z58X->Z58_DATA <= mv_par02 .and. Z58X->Z58_HORA >= Left( cTURNO2, 5 )+ ":00"  .and. Z58X->Z58_HORA <= U_Somahora( Left( cTURNO2, 5 ) + ":00", SubStr( cTURNO2, 7, 5 ) + ":00" )
            

		    If Z58X->Z58_CANAL='0' // LADO A 
		    
		       If Z58X->Z58_STATUS='1' .AND. cStaAnt!=Z58X->Z58_STATUS // MAQUINA LIGADA
		          nTempLig2A:=Z58X->Z58_HORA
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip()) 
		          //incregua()
		       endif
		       
		       If  cStaAnt=Z58X->Z58_STATUS 
		           cStaAnt:=Z58X->Z58_STATUS
		           Z58X->(dbSkip())    
		           //incregua()
		           loop
		       endif
		       
		       If Z58X->Z58_STATUS='0' .AND. cStaAnt!=Z58X->Z58_STATUS // MAQUINA DESLIGADA
		          If Z58X->Z58_HORA>=nHORA3
		             nTempDes2A:=nHORA3
		             nTotTL3A:=SomaHora(nTotTL3A,TempoLig(Z58X->Z58_HORA,nHORA3))       
		          Else
		             nTempDes2A:=Z58X->Z58_HORA 
		          Endif
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip())
		          //incregua()
		       endif
		       
		       nTotTL2A:= SomaHora(nTotTL2A,TempoLig(nTempDes2A,nTempLig2A))                     
		       
		    elseif Z58X->Z58_CANAL='1' // LADO B
		       
		       
		       If Z58X->Z58_STATUS='1' .AND. cStaAnt!=Z58X->Z58_STATUS// MAQUINA LIGADA
		          nTempLig2B:=Z58X->Z58_HORA
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip()) 
		          //incregua()
		       endif
		       
		       If  cStaAnt=Z58X->Z58_STATUS 
		           cStaAnt:=Z58X->Z58_STATUS
		           Z58X->(dbSkip())    
		           //incregua()
		           loop
		       endif
		       
		       If Z58X->Z58_STATUS='0' .AND. cStaAnt!=Z58X->Z58_STATUS// MAQUINA DESLIGADA
		          If Z58X->Z58_HORA>=nHORA3
		             nTempDes2B:=nHORA3
		             nTotTL3B:=SomaHora(nTotTL3B,TempoLig(Z58X->Z58_HORA,nHORA3))       
		          Else
		             nTempDes2B:=Z58X->Z58_HORA 
		          Endif
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip())
		          //incregua()
		       endif
		       
		       nTotTL2B:= SomaHora(nTotTL2B,TempoLig(nTempDes2B,nTempLig2B))                     
    		    		    
		    Endif
		    		    
		// 3ª turno
		
		elseIf ( Z58X->Z58_DATA <= mv_par02 .and. Z58X->Z58_HORA >= Left( cTURNO3, 5 ) + ":00" ) .or. ;
		 			 ( Z58X->Z58_DATA >= mv_par01 + 1 .and. Z58X->Z58_HORA <=U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( cTURNO3, 7, 5 ) + ":00" ) )
            		    
		    If Z58X->Z58_CANAL='0' // LADO A 
		       	       
		       If Z58X->Z58_STATUS='1' .AND. cStaAnt!=Z58X->Z58_STATUS // MAQUINA LIGADA
		          cDtLig3A:=Z58X->Z58_DATA
		          nTempLig3A:=Z58X->Z58_HORA
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip()) 
		          //incregua()
		       endif
		       
		       If  cStaAnt=Z58X->Z58_STATUS 
		           cStaAnt:=Z58X->Z58_STATUS
		           Z58X->(dbSkip())    
		           //incregua()
		           loop
		       endif
		       
		       If Z58X->Z58_STATUS='0' .AND. cStaAnt!=Z58X->Z58_STATUS// MAQUINA DESLIGADA
		          cDtDesl3A:=Z58X->Z58_DATA
		          If Z58X->Z58_HORA>=nHORA1 .AND. cDtLig3A!=cDtDesl3A
		             nTempDes3A:=nHORA1      
		          Else
		             nTempDes3A:=Z58X->Z58_HORA 
		          Endif
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip())
		          //incregua()
		       endif
			   
			   If cDtLig3A!=cDtDesl3A
			      if cDtLig3A<cDtDesl3A
				     cRes24:=SomaHora(TempoLig('23:59:59',nTempLig3A),TempoLig(nTempDes3A,'00:00:00'))
			         nTotTL3A:=SomaHora(nTotTL3A,Somahora(cRes24,'00:00:01'))
	              Else	
	 			     cRes24:=SomaHora(TempoLig('23:59:59',nTempDes3A),TempoLig(nTempLig3A,'00:00:00'))
			         nTotTL3A:= SomaHora(nTotTL3A,Somahora(cRes24,'00:00:01'))
				  EndIf		       
				Else
			         nTotTL3A:= SomaHora(nTotTL3A,TempoLig(nTempDes3A,nTempLig3A))
	            Endif
                  		       		       
		    elseif Z58X->Z58_CANAL='1' // LADO B
		       
		       If Z58X->Z58_STATUS='1' .AND. cStaAnt!=Z58X->Z58_STATUS// MAQUINA LIGADA
		          cDtLig3B:=Z58_DATA
		          nTempLig3B:=Z58X->Z58_HORA
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip()) 
		          //incregua()
		       endif
		       
		       If  cStaAnt=Z58X->Z58_STATUS 
		           cStaAnt:=Z58X->Z58_STATUS
		           Z58X->(dbSkip())    
		           //incregua()
		           loop
		       endif
		       
		       If Z58X->Z58_STATUS='0' .AND. cStaAnt!=Z58X->Z58_STATUS// MAQUINA DESLIGADA
		          cDtDesl3B:=Z58_DATA
		          If Z58X->Z58_HORA>=nHORA1 .AND. cDtLig3B!=cDtDesl3B
		             nTempDes3B:=nHORA1     
		          Else
		             nTempDes3B:=Z58X->Z58_HORA 
		          Endif
		          cStaAnt:=Z58X->Z58_STATUS
		          Z58X->(dbSkip())
		          //incregua()
		       endif
		       
		       If cDtLig3B!=cDtDesl3B
			      if cDtLig3B<cDtDesl3B
				     cRes24:=SomaHora(TempoLig('23:59:59',nTempLig3B),TempoLig(nTempDes3B,'00:00:00'))
			         nTotTL3B:= SomaHora(nTotTL3B,Somahora(cRes24,'00:00:01'))                     
	               Else	
	 			     cRes24:=SomaHora(TempoLig('23:59:59',nTempDes3B),TempoLig(nTempLig3B,'00:00:00'))
			         nTotTL3B:= SomaHora(nTotTL3B,Somahora(cRes24,'00:00:01'))                     
				  EndIf		       
			   Else
			         nTotTL3B:= SomaHora(nTotTL3B,TempoLig(nTempDes3B,nTempLig3B))                     		       		             		    
		       Endif
		    endif   	    
		else
	        Z58X->(dbSkip()) // Avanca o ponteiro do registro no arquivo
            //incregua()
        endif    

    EndDo

   // imprimir aqui
 
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
      nLin :=9
   Endif
   
  // Maq
   @nLin++,00 PSAY iif(SUBSTR(cMaq,1,2)$'C0/C1/C2/C3/C4/C5/C6/C7/C8/C9','Corte e Solda '+SUBSTR(cMaq,2,LEN(cMaq)-1),iif(SUBSTR(cMaq,1,2)$'P0/P1/P2/P3/P4/P5/P6/P7/P8/P9','Picotadeira '+SUBSTR(cMaq,2,LEN(cMaq)-1),iif(SUBSTR(cMaq,1,2)$'S0/S1/S2/S3/S4/S5/S6/S7/S8/S9','Sacoleira '+SUBSTR(cMaq,2,LEN(cMaq)-1),'')))
   //Lado A                               
   @nLin,00 PSAY 'A'
   //1º turno
   nPer1A:= Percent(nTotTL1A,nDURACAO1)
   @nLin,03 PSAY nDURACAO1 
   @nLin,15 PSAY nTotTL1A 
   @nLin,27 PSAY TRANSFORM(Round(nPer1A,2),"@E 999.99")   
   
   //2º turno
   
   nPer2A:=Percent(nTotTL2A,nDURACAO2)
   @nLin,35 PSAY nDURACAO2  
   @nLin,47 PSAY  nTotTL2A  
   @nLin,59 PSAY TRANSFORM(Round(nPer2A,2),"@E 999.99")   
   
   //3º turno
  
   nPer3A:=Percent(nTotTL3A,nDURACAO3)
   @nLin,67 PSAY nDURACAO3  
   @nLin,79 PSAY nTotTL3A   
   @nLin,91 PSAY TRANSFORM(Round(nPer3A,2),"@E 999.99")   
   //total A
   cTotVDA:=somahora(nDURACAO1,nDURACAO2)  
   cTotVDA:=somahora(cTotVDA,nDURACAO3)  
   @nLin,99 PSAY cTotVDA
   cTotVLA:=somahora(nTotTL1A,nTotTL2A)  
   cTotVLA:=somahora(cTotVLA,nTotTL3A)  
   @nLin,111 PSAY cTotVLA
   cTotVPA:=Percent(cTotVLA,cTotVDA)
   @nLin++,123 PSAY TRANSFORM(Round(cTotVPA,2),"@E 999.99")   
   
   
   //Lado B                                                              
   @nLin,00 PSAY 'B' 
   //1º turno
   
   nPer1B:= Percent(nTotTL1B,nDURACAO1)
   @nLin,03 PSAY nDURACAO1 
   @nLin,15 PSAY nTotTL1B 
   @nLin,27 PSAY TRANSFORM(Round(nPer1B,2),"@E 999.99")   
   
   //2º turno
   
   nPer2B:=Percent(nTotTL2B,nDURACAO2)
   @nLin,35 PSAY nDURACAO2  
   @nLin,47 PSAY  nTotTL2B  
   @nLin,59 PSAY TRANSFORM(Round(nPer2B,2),"@E 999.99")   
   
   //3º turno
   
   nPer3B:=Percent(nTotTL3B,nDURACAO3)
   @nLin,67 PSAY nDURACAO3  
   @nLin,79 PSAY nTotTL3B   
   @nLin,91 PSAY TRANSFORM(Round(nPer3B,2),"@E 999.99")   
   
   //total B
   cTotVDB:=somahora(nDURACAO1,nDURACAO2)  
   cTotVDB:=somahora(cTotVDB,nDURACAO3)  
   @nLin,99 PSAY cTotVDB
   cTotVLB:=somahora(nTotTL1B,nTotTL2B)  
   cTotVLB:=somahora(cTotVLB,nTotTL3B)  
   @nLin,111 PSAY cTotVLB
   cTotVPB:=Percent(cTotVLB,cTotVDB)
   @nLin++,123 PSAY TRANSFORM(Round(cTotVPB,2),"@E 999.99")   
// --------------------------------------------------------  
   @nLin++,00 PSAY replicate("-",97) 
// total 1 TURNO
   cTotHD1:=somahora(nDURACAO1,iif(SUBSTR(cMaq,1,2)!='P0',nDURACAO1,"00:00:00"))  
   @nLin,03 PSAY cTotHD1
   cTotHL1:=somahora(nTotTL1A,nTotTL1B)  
   @nLin,15 PSAY cTotHL1
   cTotHP1:=Percent(cTotHL1,cTotHD1)
   @nLin,27 PSAY TRANSFORM(Round(cTotHP1,2),"@E 999.99")   
// total 2 TURNO
   cTotHD2:=somahora(nDURACAO2,iif(SUBSTR(cMaq,1,2)!='P0',nDURACAO2,"00:00:00"))  
   @nLin,35 PSAY cTotHD2
   cTotHL2:=somahora(nTotTL2A,nTotTL2B)  
   @nLin,47 PSAY cTotHL2
   cTotHP2:=Percent(cTotHL2,cTotHD2)
   @nLin,59 PSAY TRANSFORM(Round(cTotHP2,2),"@E 999.99")   
// total 3 TURNO
   cTotHD3:=somahora(nDURACAO3,iif(SUBSTR(cMaq,1,2)!='P0',nDURACAO3,"00:00:00"))  
   @nLin,67 PSAY cTotHD3
   cTotHL3:=somahora(nTotTL3A,nTotTL3B)  
   @nLin,79 PSAY cTotHL3
   cTotHP3:=Percent(cTotHL3,cTotHD3)
   @nLin++,91 PSAY TRANSFORM(Round(cTotHP3,2),"@E 999.99")   
   nLin++ 
 EndDo

Z58X->(DBCLOSEAREA())

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

/*
***************

Static Function TEMPO(nNum)

***************
Local cQry:=''
local nInt:=0

if nNum >=1
  nInt:= int(nNum)*24
endif

//cQry:="SELECT convert(char(10),cast(cast(STUFF('" + str(nNum) + "', PATINDEX( '%,%','" + str(nNum) + "') , 1, '.') as float ) as datetime),108)  AS CAMPO "
cQry:="SELECT convert(char(10),cast( "+alltrim(str(nNum))+" as datetime),108)  AS CAMPO  "
TCQUERY cQry NEW ALIAS "AUUX"

cCampo:=AUUX->CAMPO
AUUX->(DbCloseArea())

nHr:=Val(Subst(cCampo,1,2)  )+nInt


Return  strzero(nHr,2)+":"+Subst(cCampo,4,2)+":"+Subst(cCampo,7,2)
*/

 /*
***************

Static Function valor(nValor,cHora)

***************
Local cQry:=''
      
cQry:="SELECT " + ALLTRIM(STR(nValor)) + " * CAST( CAST('" +cHora+ "'AS DATETIME ) AS FLOAT ) AS CAMPO "
TCQUERY cQry NEW ALIAS "TMPZ"

nCampo:=TMPZ->CAMPO
TMPZ->(DbCloseArea())

Return nCampo
*/


**************

Static Function valor( nValor,_cHora,lTurno3,lTurno1 )

**************

Local _nHr1,_nMi1,nSg1,_nHr2,_nMi2,nSg2
local _nRs1:=_nRs2:=_nRs3:=0
local _cRes:=''
local Hr,ResHr,Mi,Seg
local cHr:=''
local cRs4:='' 

_nHr1 := Val(  Subst(_cHora,1,AT(":",_cHora)-1 )  )*3600  - 3600   
_nMi1 := Val(  Subst(_cHora,AT(":",_cHora)+1,2)  )*60 - IIF(lTurno3,10*60,0) -IIF(lTurno1,20*60,0)
cRs4:=Subst(_cHora,AT(":",_cHora)+1,len(_cHora))
_nSg1 := Val(  Subst(cRs4,AT(":",cRs4)+1,2 )  ) 


_nRs1:=_nHr1+_nMi1+_nSg1


_nRs3:=_nRs1*nValor 

Hr:=int(_nRs3/3600)
ResHr:=_nRs3%3600
Mi:=int(ResHr/60)
Seg:=ResHr%60

If Hr >99
cHr:=alltrim(str(Hr))
else
cHr:=StrZero(Hr,2)
EndIf


_cRes :=  cHr +":"+StrZero(Mi,2)+":"+StrZero(Seg,2)

/*
Local _nHr1,_nMi1,nSg1,_nRs1,_nRs2,_nRs3,_cRes

_nHr1 := Val(  Subst(_cHora,1,2)  )-1 
_nMi1 := Val(  Subst(_cHora,4,2)  )- IIF(lTurno3,10,0) -IIF(lTurno1,20,0)
_nSg1 := Val(  Subst(_cHora,7,2)  )

_nRs3 := _nSg1*nValor 
If _nRs3 >= 60
	_nRs3 := _nRs3 - 60
	_nMi1++
EndIf

_nRs2 := _nMi1*nValor 
If _nRs2 >= 60
	_nRs2 := _nRs2 - 60
	_nHr1++
EndIf

_nRs1 := _nHr1*nValor 

_cRes := StrZero(_nRs1,2)+":"+StrZero(_nRs2,2)+":"+StrZero(_nRs3,2)
*/

Return(  _cRes  )


**************

Static Function TempoLig( _cHora1, _cHora2 )

**************

Local _nHr1,_nMi1,nSg1,_nHr2,_nMi2,nSg2
local _nRs1:=_nRs2:=_nRs3:=0
local _cRes:=''
local Hr,ResHr,Mi,Seg
local cHr:=''
local cRs4:='' 

_nHr1 := Val(  Subst(_cHora1,1,AT(":",_cHora1)-1 )  )*3600     
_nMi1 := Val(  Subst(_cHora1,AT(":",_cHora1)+1,2)  )*60
cRs4:=Subst(_cHora1,AT(":",_cHora1)+1,len(_cHora1))
_nSg1 := Val(  Subst(cRs4,AT(":",cRs4)+1,2 )  ) 

_nHr2 := Val(  Subst(_cHora2,1,AT(":",_cHora2)-1)  )*3600
_nMi2 := Val(  Subst(_cHora2,AT(":",_cHora2)+1,2)  )*60
cRs4:=Subst(_cHora2,AT(":",_cHora2)+1,len(_cHora2))
_nSg2 := Val(   Subst(cRs4,AT(":",cRs4)+1,2 )  )

_nRs1:=_nHr1+_nMi1+_nSg1
_nRs2:=_nHr2+_nMi2+_nSg2

_nRs3:=_nRs1 - _nRs2

if _nRs3<0
  //alert("Hora Desligada > Hora Ligada" )
  Return "########" 
Endif


Hr:=int(_nRs3/3600)
ResHr:=_nRs3%3600
Mi:=int(ResHr/60)
Seg:=ResHr%60

If Hr >99
cHr:=alltrim(str(Hr)	)
else
cHr:=StrZero(Hr,2)
EndIf


_cRes :=  cHr +":"+StrZero(Mi,2)+":"+StrZero(Seg,2)


/*
_nRs3 := _nSg1 - _nSg2
_nRs2 := _nMi1 - _nMi2
_nRs1 := _nHr1 - _nHr2

if _nRs1<0
  alert("Hora Desligada > Hora Ligada" )
Endif
                          	
If _nRs3 < 0
	_nRs3 := _nRs3 + 60
	_nRs2--
EndIf


If _nRs2 < 0
	_nRs2 := _nRs2 + 60
	_nRs1--
EndIf

If _nRs1 >99
cHr:=alltrim(str(_nRs1)	)
else
cHr:=StrZero(_nRs1,2)
EndIf

_cRes := cHr +":"+StrZero(_nRs2,2)+":"+StrZero(_nRs3,2)
*/

Return(  _cRes  )    


**************

Static Function SomaHora( _cHora1, _cHora2 )

**************

Local _nHr1,_nMi1,nSg1,_nHr2,_nMi2,nSg2
local _nRs1:=_nRs2:=_nRs3:=0
local _cRes:=''
local Hr,ResHr,Mi,Seg
local cHr:=''
local cRs4:='' 

_nHr1 := Val(  Subst(_cHora1,1,AT(":",_cHora1)-1 )  )*3600     
_nMi1 := Val(  Subst(_cHora1,AT(":",_cHora1)+1,2)  )*60
cRs4:=Subst(_cHora1,AT(":",_cHora1)+1,len(_cHora1))
_nSg1 := Val(  Subst(cRs4,AT(":",cRs4)+1,2 )  ) 

_nHr2 := Val(  Subst(_cHora2,1,AT(":",_cHora2)-1)  )*3600
_nMi2 := Val(  Subst(_cHora2,AT(":",_cHora2)+1,2)  )*60
cRs4:=Subst(_cHora2,AT(":",_cHora2)+1,len(_cHora2))
_nSg2 := Val(   Subst(cRs4,AT(":",cRs4)+1,2 )  )

_nRs1:=_nHr1+_nMi1+_nSg1
_nRs2:=_nHr2+_nMi2+_nSg2

_nRs3:=_nRs1+_nRs2

Hr:=int(_nRs3/3600)
ResHr:=_nRs3%3600
Mi:=int(ResHr/60)
Seg:=ResHr%60

If Hr >99
cHr:=alltrim(str(Hr))
else
cHr:=StrZero(Hr,2)
EndIf


_cRes :=  cHr +":"+StrZero(Mi,2)+":"+StrZero(Seg,2)


/*
Local _nHr1,_nMi1,nSg1,_nHr2,_nMi2,nSg2,_nRs1,_nRs2,_nRs3,_cRes
local cHr:=''
_nHr1 := Val(  Subst(_cHora1,1,AT(":",_cHora1)-1 )  )     
_nMi1 := Val(  Subst(_cHora1,4,2)  )
_nSg1 := Val(  Subst(_cHora1,7,2)  )
_nHr2 := Val(  Subst(_cHora2,1,AT(":",_cHora2)-1)  )
_nMi2 := Val(  Subst(_cHora2,4,2)  )
_nSg2 := Val(  Subst(_cHora2,7,2)  )

_nRs3 := _nSg1 + _nSg2
If _nRs3 >= 60
	_nRs3 := _nRs3 - 60
	_nMi1++
EndIf

_nRs2 := _nMi1 + _nMi2
If _nRs2 >= 60
	_nRs2 := _nRs2 - 60
	_nHr1++
EndIf

_nRs1 := _nHr1 + _nHr2
If _nRs1 >99
cHr:=alltrim(str(_nRs1)	)
else
cHr:=StrZero(_nRs1,2)
EndIf


_cRes :=  cHr +":"+StrZero(_nRs2,2)+":"+StrZero(_nRs3,2)
*/


Return(  _cRes  )


**************

Static Function Percent( _cHora1, _cHora2 )

**************

Local _nHr1,_nMi1,nSg1,_nHr2,_nMi2,nSg2,_nRs1,_nRs2,_cRes

local cRs4:='' 

_nHr1 := Val(  Subst(_cHora1,1,AT(":",_cHora1)-1 )  )*3600     
_nMi1 := Val(  Subst(_cHora1,AT(":",_cHora1)+1,2)  )*60
cRs4:=Subst(_cHora1,AT(":",_cHora1)+1,len(_cHora1))
_nSg1 := Val(  Subst(cRs4,AT(":",cRs4)+1,2 )  ) 

_nHr2 := Val(  Subst(_cHora2,1,AT(":",_cHora2)-1)  )*3600
_nMi2 := Val(  Subst(_cHora2,AT(":",_cHora2)+1,2)  )*60
cRs4:=Subst(_cHora2,AT(":",_cHora2)+1,len(_cHora2))
_nSg2 := Val(   Subst(cRs4,AT(":",cRs4)+1,2 )  )


_nRs1:=_nHr1+_nMi1+_nSg1
_nRs2:=_nHr2+_nMi2+_nSg2

_cRes:=(_nRs1/_nRs2)*100


Return(  _cRes  )

