#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "topconn.ch"

*************

User Function BloqOP()

*************
Private aCores  := {{"!Empty(SC2->C2_BLOQUEA)", "BR_VERMELHO"},;
                    {"Empty(SC2->C2_BLOQUEA)", "BR_VERDE" } }
Private aRotina := {{"Pesquisar"  ,"AxPesqui"    , 0, 1},;
                    {"Bloquear"   ,"U_BlockOP(1)", 0, 2},;
                    {"Desbloquear","U_BlockOP(2)", 0, 3},;
                    {"Legenda"    ,"U_Legblock"  , 0, 6}}
Private cObs    := ""                    
DbSelectArea("SC2")
DbSetOrder(1)

mBrowse( 06, 01, 22, 75, "SC2",,,,,,aCores )

Return

*************

User Function LegBlock()

*************

Local aLegenda := {{"BR_VERMELHO","OP Bloqueada"    },;
	   			   {"BR_VERDE"   ,"OP Desbloqueada" }}
BrwLegenda("Ordens de Produção","Legenda",aLegenda)		   		

Return .T.

*************

User Function BlockOP(nOpt)

************
Local aUSUARIO := {}
Local cOBSBLQ  := ""


If xFilial("SC2") != '03'
	aUSUARIO := u_senha2("12") 
	if aUSUARIO[1]
		if nOpt == 1    //nOpt = 1 -> Bloqueia
			cOBSBLQ := obs()
			DbSelectArea("SC2")
			RecLock("SC2",.F.)
			SC2->C2_BLOQUEA := '*'
			SC2->C2_NMBLOQ  := aUSUARIO[2]
			cOBSBLQ := substr(cOBSBLQ,1,70)
			SC2->C2_BLOQCQ  := "BLQ MANUAL:" + cOBSBLQ + " - " + Dtoc(dDatabase) + " - " + SUBSTR(Time(),1,5)  //"BLOQOP"    //ORIGEM DO BLOQUEIO CQ
			SC2->( MSUnlock() )
		else			//nOpt = 2 -> DesBloqueia
			RecLock("SC2",.F.)
			SC2->C2_BLOQUEA := ''
		    SC2->C2_NMBLOQ  := aUSUARIO[2]
		    SC2->C2_BLOQCQ  := "DESBLQ MANUAL: " + Dtoc(dDatabase) + " - " + SUBSTR(Time(),1,5)
		    SC2->C2_OBSBLOQ := ""
			SC2->( MSUnlock() )				
		endIf
	endIf  //VOLTAR

Else   //se for a filial Caixas, somente JOrge poderá desbloquear
	
	if nOpt == 1
		aUSUARIO := u_senha2("12") 
		if aUSUARIO[1]
			obs()
			DbSelectArea("SC2")
			RecLock("SC2",.F.)
			SC2->C2_BLOQUEA := '*'
			SC2->C2_NMBLOQ  := aUSUARIO[2] 
			SC2->C2_BLOQCQ  := "BLQ MANUAL:" + cOBSBLQ + " - " + Dtoc(dDatabase) + " - " + SUBSTR(Time(),1,5)  //"BLOQOP"    //ORIGEM DO BLOQUEIO CQ //"BLOQOP"
			SC2->( MSUnlock() )
		Endif
	
	else
		MSGINFO("Aviso : SOMENTE JORGE PODERÁ DESBLOQUEAR OP NA FILIAL CAIXAS")
		aUSUARIO := u_senha2("22")  //SOMENTE JORGE ESTÁ NA TABELA ZY - CHAVE '22'		
		if aUSUARIO[1] 			
			RecLock("SC2",.F.)
			SC2->C2_BLOQUEA := ''
		    SC2->C2_NMBLOQ  := aUSUARIO[2] 
		    SC2->C2_BLOQCQ  := "DESBLQ MANUAL: " + Dtoc(dDatabase) + " - " + SUBSTR(Time(),1,5)
		    SC2->C2_OBSBLOQ := " "
			SC2->( MSUnlock() )	
		//else
			
		endif			
	endIf

Endif //xFilial




return

**************     

Static Function obs()

**************

DbSelectArea("SC2")

if !Empty(SC2->C2_BLOQUEA)
	cObs := MSMM( SC2->C2_OBSBLOQ )
endIf

SetPrvt("oDlg1","oGrp1","oMGet1","oGrp2","oBtn1","oBtn2")

oDlg1      := MSDialog():New( 180,331,500,860,"Observação :",,,.F.,,,,,,.T.,,,.T. )
oGrp1      := TGroup():New( 003,006,128,256,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oMGet1     := TMultiGet():New( 011,012,{|u| If(PCount()>0,cObs:=u,cObs)},oGrp1,239,108,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
oGrp2      := TGroup():New( 132,006,155,256,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oBtn1      := TButton():New( 137,075,"&Ok",oGrp2,     {||MSMM(,,,cObs,1,,,'SC2','C2_OBSBLOQ'),DbSelectArea("SC2"),oDlg1:End()},037,012,,,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 137,149,"&Cancela",oGrp2,{||oDlg1:End()},037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

Return(cObs)