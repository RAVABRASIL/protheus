#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "


*************

User Function WFPCP018()

*************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   conOut( " " )
   conOut( "***************************************************************************" )
   conOut( "Informações de Meta Painel     	           " )
   conOut( "***************************************************************************" )
   conOut( " " )

   If Select( 'SX2' ) == 0
     PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFPCP018" Tables "Z88"
   	 Sleep( 5000 )  //aguarda 5 seg para que os jobs IPC subam  
   	 grava()
   else
   	 grava()
   endif

Return 


*************

Static function grava()

*************

local nEfiReal:=0
local nEfiMeta:=0
local aInfoEfi :={}

         
ddataI:= FirstDay(ddatabase-1)
ddataF:=ddatabase-1

dbSelectArea("Z88")
dbSetOrder(1)

while ddataI <= ddataF
	IF !dbSeek( xFilial("Z88") + dtos(ddataI)  ) // NAO ENCONTROU A DATA COLOCO NA TABELA
		nEfiReal:=0  // REAL
		nEfiMeta:=0 // META
		aInfoEfi := U_PCPC018(Dtos(ddataI),'','','ZZZZZZZZZZ','',.F.)
		For x := 1 to LEN(aInfoEfi)
			// somatario produzido
			if aInfoEfi[x][9]>0    // so soma o realizado se tiver meta
				nEfiReal+=aInfoEfi[x][3]
			ENDIF
			
			if aInfoEfi[x][10]>0
				nEfiReal+=aInfoEfi[x][4]
			endIF
			
			if aInfoEfi[x][11]>0
				nEfiReal+=aInfoEfi[x][5]
			endIF
			
			// somatario Meta
			nEfiMeta:= nEfiMeta+aInfoEfi[x][9]+aInfoEfi[x][10]+aInfoEfi[x][11]
		Next
		// INCLUO NA TABELA
		fIncZ88(ddataI,nEfiReal,nEfiMeta)
	ENDIF
	ddataI:=ddataI+1
enddo


Return


***************

Static Function  fIncZ88(ddataI,nEfiReal,nEfiMeta)

***************

//IF !dbSeek( xFilial("Z88") + dtos(ddataI)  ) // NAO ENCONTROU A DATA COLOCO NA TABELA
   RecLock("Z88",.T.)
   Z88->Z88_DATA:=ddataI
   Z88->Z88_REAL:=ROUND(nEfiReal,2)
   Z88->Z88_META:=ROUND(nEfiMeta,2)
   Z88->( msUnlock() )
//Endif

Return 
