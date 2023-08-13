#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include 'Directry.ch'
************************
User Function MA110BAR()
************************

Local aButtons := {} // Botoes a adicionar
Public  cArqui  :=alltrim(SC1->C1_ANEXO)
aadd(aButtons,{'ALTERA',{|| iif(altera,U_ANEXAR(),alert(" Anexar somente na função  ALTERAR "))},"Anexar arquivo','Anexar."})


Return (aButtons )



User Function MT110CON()

Local lGrava  := .T.
codigo:=SC1->C1_NUM
nRecno:= SB1->(Recno())
dbSelectArea("SC1")
SC1->(dbSetOrder(1))
SC1->( DbSeek( xFilial( "SC1" ) + C1_NUM +"0001" , .T. ) )
while SC1->C1_NUM == codigo
	RecLock("SC1",.F.)
	SC1->C1_ANEXO := cArqui // arquivos
	SC1->(MsUnLock())
	SC1->( DbSkip() )
enddo

SC1->(dbGoto(nRecno))
Return ( lGrava )



************************
User Function ANEXAR()
************************


Local bAbreAnexo
Private cPriN

Private cTCod    := Space(6)
Private dTInc    := CtoD(" ")
Private dTIni    := CtoD(" ")
Private dTPrev   := CtoD(" ")
Private dTConc   := CtoD(" ")
Private cTMDesc
Private nTStatus
Private dTDULM   := CtoD(" ")
Private cTUULM   := Space(10)
Private cTEXEC   := Space(10)
Private cTPRIOR  := Space(4)
Private cTMOBS
Private nItem
Private aAnexo   := {}
Private cDirN    := "\ANEXOS\SC1\"
Private cDirL    := /*"K:\Protheus_Data"+*/GetSrvProfString("Startpath","")
Private cLocal    := "C:\SoliCompras\"
Private start:=GetSrvProfString("Startpath","")

Private cHora  := Space(5)
Private cTempo := Space(5)
Public  cDestino := strtran(cDirL+cDirN+SC1->C1_NUM+"\" ,"\\","\")


SetPrvt( "oSay4","oSay5","oSay3","oSay1","oSay2","oSay6","oSay10","oSay11","oSay12","oSay7","oSay8","oLBox1")
SetPrvt( "oTime","oSay9","oCod","oInc","oIni","oPrev","oConc","oMDesc","oStatus","oDULM","oUULM","oEXEC","oPRIOR")

oDlg2         := MSDialog():New( 0,0,260,335,"Anexar arquivos",,,,,,,,,.T.,,, )
oLBox1        := TListBox():New( 5,5,,aAnexo,160,090,,oDlg2,,CLR_BLACK,CLR_WHITE,.T.,,,,"",,,,,,, )

bAbreAnexo    := {||Processa({||fAbre()},"Aguarde","Abrindo anexo...")}
oLBox1:bLDBLClick := bAbreAnexo

oPanel1       := TPanel():New( 105,5,"",oDlg2,,.F.,.F.,,,160,001,.T.,.F. )

oPanel1       := TPanel():New( 120,5,"",oDlg2,,.F.,.F.,,,160,001,.T.,.F. )


oBANX         := TButton():New( 107,5,"&Anexar",  oDlg2,{||fAnexa()},037,012,,,,.T.,,"",,,,.F. )
oBANX:bWhen   := {|| len(aAnexo)<10 }

oBRMV         := TButton():New( 107,45,"&Remover",oDlg2,{||fRemov()},037,012,,,,.T.,,"",,,,.F. )
oBRMV:bWhen   := {||!Empty(aAnexo).and.oLBox1:nAt>0  }

oBABR         := TButton():New( 107,84,"A&brir",  oDlg2,bAbreAnexo,  037,012,,,,.T.,,"",,,,.F. )
oBABR:bWhen   := {||!Empty(aAnexo).and.oLBox1:nAt>0 }


oBCAN         := TButton():New( 107,124,"&Sair",        oDlg2,{|x| oDlg2:End() },040,012,,,,.T.,,"",,,,.F. )

PrepCampos()

oDlg2:Activate(,,,.T.)

Return




***********************
Static Function fAbre()
***********************

local cArq := Alltrim(aAnexo[oLBox1:nAt])

if ! lIsDir( cDestino)
	nMDir := MakeDir( cDestino )
	if nMDir <> 0
		alert("nao foi possivel criar Dir "+Alltrim(Str(nMDir)))
	endif
endif 


if ! lIsDir( cLocal)
	nMDir := MakeDir( cLocal )
	if nMDir <> 0
		alert("nao foi possivel criar Dir "+Alltrim(Str(nMDir)))
	endif
endif

CpyS2T(  strtran(start+cDirN+SC1->C1_NUM+"\"+cArq,"\\","\") ,cLocal )

//ShellExecute( 'open', strtran(cDirL+cDirN+SC1->C1_NUM+"\"+cArq,"\\","\"),'','', 1 )

ShellExecute( 'open', strtran(cLocal+cArq,"\\","\"),'','', 1 )

return


************************
static Function fAnexa()
************************
 

Local nP
Local cTipo := "Anexos Tarefas (DOC,XLS,BMP,JPG,GIF,PDF,ZIP,WRI,FDF,DWG,XMl,TXT) | *.* | "
Local cNewPathArq	:= cGetFile( cTipo , "Selecione o arquivo",,"C:\",,GETF_NETWORKDRIVE+GETF_LOCALHARD,.F. )
Local cDrive, cCaminho, cNome, cExt
Local aFile := {}

if Len(aAnexo)>=10
	Aviso("Aviso","Você só poderá anexar 10 arquivos.",{"OK"})
	Return
endif

if !Empty( cNewPathArq )
	SPLITPATH( cNewPathArq, @cDrive, @cCaminho, @cNome, @cExt )
	if Len(cNome)>60
		Aviso("Aviso","O nome do arquivo a ser anexado, deverá ter no máximo 60 caracteres."+CHR(13)+"Mude o nome do arquivo e anexe novamente.",{"OK"})
		Return
	endif
	
	aFile := DIRECTORY(cNewPathArq)
	if aFile[1,2] > 5242880
		Aviso("Aviso","O arquivo selecionado ultrapassa o limite de tamanho."+CHR(13)+"O limite máximo para o tamanho do arquivo a ser anexado é de 5Mb.",{"OK"})
		Return
	endif
	
	if !Upper(cExt) $ ".DOC/.XLS/.BMP/.JPG/.GIF/.PDF/.ZIP/.WRI/.FDF/.DWG/.XML/.TXT/"
		MsgAlert( "Tipo de Arquivo Invalido " )
		Return
	else
		nP := Ascan( aAnexo, UPPER(cNome+cExt) )
		if nP == 0
			Aadd( aAnexo, UPPER(cNome+cExt) )
			oLBox1:SetItems(aAnexo)
			oLBox1:nAt := Len(aAnexo)
			oLBox1:Refresh()
			
			cChar:=""
			for x:=1 to Len(aAnexo)
				cChar+=alltrim(aAnexo[x])+"/"
			next x
			
			cArqui:=cChar
			
			if ! lIsDir( strtran(cDirL+cDirN,"\\","\")            )
				nMDir := MakeDir( strtran(cDirL+cDirN,"\\","\")   )
				if nMDir <> 0
					alert("nao foi possivel criar Dir "+Alltrim(Str(nMDir)))
				endif
			endif
			
			if ! lIsDir( strtran(cDirL+cDirN+C1_NUM ,"\\","\")          )
				nMDir := MakeDir( strtran(cDirL+cDirN+C1_NUM,"\\","\")  )
				if nMDir <> 0
					alert("nao foi possivel criar Dir "+Alltrim(Str(nMDir)))
				endif
			endif
			
			
			
			CpyT2S( cNewPathArq, strtran(start+cDirN+C1_NUM ,"\\","\")  )
			
		else
			Aviso( "Aviso","O arquivo selecionado já está anexado.",{"OK"} )
		endif
	endif
else
	Return
endif

Return( cNewPathArq )



************************
Static Function fRemov()
************************

if Len(aAnexo) > 0
	if oLBox1:nAt > 0
		
		if MsgYesNo("Deseja excluir "+alltrim(aAnexo[oLBox1:nAt])+" ?")
			
			cArqui:=strtran(cArqui,alltrim(aAnexo[oLBox1:nAt])+"/","" )
			fErase(strtran(start+cDirN+C1_NUM+"\"+alltrim(aAnexo[oLBox1:nAt]),"\\","\"))
			
			ADel(aAnexo,oLBox1:nAt)
			ASize(aAnexo,Len(aAnexo)-1)
			oLBox1:SetItems(aAnexo)
			oLBox1:nAt := Len(aAnexo)
		endif
		
	else
		MsgAlert( "Selecione antes o arquivo a ser removido." )
	endif
else
	MsgAlert( "Não existem arquivos anexados." )
endif

Return


****************************
Static Function PrepCampos()
****************************

aAnexo   := U_Str2Arr( alltrim(cArqui),"/" )

oLBox1:SetItems(aAnexo)
if Len(aAnexo) > 0
	oLBox1:nAt := 1
endif

return




