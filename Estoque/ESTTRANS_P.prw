#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

USER FUNCTION ESTRANP()
                                                 
	/*Z10_STATUS == 1 (Solicitado)
	  Z10_STATUS == 2 (Transformado) */
	aCores := {{"Z10_STATUS == '1'", "BR_VERDE"},;
		  		  {"Z10_STATUS == '2'","BR_VERMELHO"}}
		  		  
	aRotina := {{"Pesquisar", "AxPesqui", 0, 1} ,;
					{"Solicitar", "U_ESTTRANS", 0, 3} ,;
					{"Transformar", "U_ESTTRANS", 0, 2} ,;
					{"Imprimir", "U_ESTTRAR", 0, 1} ,;
	 	 			{"Legenda", "U_LegTran", 0, 2}}
	 	 	
	DbSelectArea("Z10")
	
	mBrowse( 06, 01, 22, 75, "Z10",,,,,,aCores )

RETURN 	 			

/*컴컴컴쩡컴컴컴컴컫컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴쩡컴컴컴컴컴컴컴컴컴
Function  � LegTran()
컴컴컴컴컴탠컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴좔컴컴컴컴컴컴컴*/
User Function LegTran()

Local aLegenda	:= {{"BR_VERDE",	"Solicitado" },;		
                   {"BR_VERMELHO", "Transformado" }}

BrwLegenda("Solicitacao de Transformacoes","Legenda",aLegenda)

Return .T.	                                             
	