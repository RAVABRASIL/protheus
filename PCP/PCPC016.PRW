#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :          ³ Autor :TEC1 - Designer       ³ Data :2/3/2011   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao :                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros:                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   :                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       :                                                            ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function PCPC016 ( )
public cParam1:=cParam2:=space(6)
public cEmail:=""
public coTbl1:=coTbl2:=nEmail:=0
setPrvt( "cMARCA")
cMarca       := GetMark()
oDlg1         := MSDialog():New( 041,066,616,636,"Email de Boas Vindas",,,.F.,,,,,,.T.,,,.F. )
oGrp1         := TGroup():New( 004,004,025,277,"Cliente",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1         := TSay():New( 012,012,{||"De:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,012,008)
oGDt1         := TGet():New( 012,024,,oGrp1,036,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cParam1",,)
oGDt1:bSetGet := {|u| If(PCount()>0,cParam1:=u,cParam1)}
oGDt1:cF3     := "SA1"

oSay2         := TSay():New( 012,068,{||"Ate:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,013,008)
oGDt2         := TGet():New( 012,080,,oGrp1,048,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cParam2",,)
oGDt2:bSetGet := {|u| If(PCount()>0,cParam2:=u,cParam2)}
oGDt2:cF3     := "SA1"
oBtn1      := TButton():New( 010,134,"Filtrar",oGrp1,{||   	MsAguarde( {|| 	atualiza() }, OemToAnsi( "Aguarde" ), OemToAnsi( "Carregando Clientes ") )   },052,012,,,,.T.,,"",,,,.F. )




oTbl1()
DbSelectArea("TMP1")
oBrw1      := MsSelect():New( "TMP1","MARCA","",{;
{"MARCA"   ,  ,          ,"  "},;
{"COD"     ,"","codigo"  ,""  },;
{"NOME"    ,"","Cliente" ,""  },;
{"EMAIL"   ,"","E-Mail"  ,""  } ;
;//{"ID"      ,"","id"      ,""} ;
},.F.,cMARCA,{030,004,224,277},,, oDlg1 )
MsAguarde( {|| 	atualiza() }, OemToAnsi( "Aguarde" ), OemToAnsi( "Carregando Clientes ") )
//oBrw1:OBrowse:bChange := {|| atualiza2() }
oBrw1:oBrowse:bLDBLClick := {|| TMP2Mark() }


//oGeMAIL      := TGet():New( 142,04,,oGrp1,200,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cEMAiL",,)
//oGeMAIL:bSetGet := {|u| If(PCount()>0,cEMAiL:=u,cEMAiL)}
//oGeMAIL:disable()
oGeMAIL     := TMultiGet():New( 0,0,,oDlg1,0,0,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
oGeMAIL:bSetGet := {|u| If(PCount()>0,cEMAiL:=u,cEMAiL)}

oBtn3      := TButton():New( 250, 4,"&Enviar   ",oDlg1,{||  Enviar() },037,012,,,,.T.,,"",,,,.F. )
oBtn4      := TButton():New( 250,50,"&Cancelar ",oDlg1,{|| oDlg1:end()   },037,012,,,,.T.,,"",,,,.F. )

//oSBtn1     := SButton():New( 244,251,1,,oDlg1,,"", )


oBRW1:oBrowse:lhasMark    := .F.
oBRW1:oBrowse:lCanAllmark := .F.



oDlg1:Activate(,,,.T.)
TMP1->(DBCloseArea())
Ferase(coTbl1) // APAGA O ARQUIVO DO DISCO



Return








/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl1() - Cria temporario para o Alias: TMP1
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl1()

Local aFds :={}
Aadd( aFds , {"MARCA"   ,"C",002,000} )
Aadd( aFds , {"COD"     ,"C",006,000} )
Aadd( aFds , {"NOME"    ,"C",031,000} )
Aadd( aFds , {"EMAIL"   ,"C",030,000} )
Aadd( aFds , {"ID"      ,"N",010,000} )

coTbl1 := CriaTrab( aFds, .T. )
Use (coTbl1) Alias TMP1 New Exclusive
Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl2() - Cria temporario para o Alias: TMP
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/





***************
Static Function atualiza()
***************

dbSelectArea("SA1")
dbSetOrder(1)



cQry:=" SELECT  A1_COD COD ,A1_NOME NOME  ,A1_EMAIL EMAIL , R_E_C_N_O_ R_E_C_N_O_    "
cQry+=" FROM "+retSqlName("SA1")+" SA1 "
cQry+=" WHERE "
if !empty( cParam1 ) .and. !empty( cParam2 )
	cQry+=" A1_COD BETWEEN "+valtosql(cParam1)+" AND "+valtosql(cParam2)+" AND "
endif
cQry+=" D_E_L_E_T_='' "
cQry+=" order by COD"
TCQUERY cQry NEW ALIAS "AUUX"

TMP1->( __DbZap() ) // LIMPAR O CONTEUDO DA TABELA TEMPORARIA
AUUX->( DBGoTop() )

While  ! AUUX->( EOF() )
	
	RecLock("TMP1",.T.)
	if !empty(alltrim(AUUX->EMAIL))             // se tem email
		if at(alltrim(AUUX->EMAIL)+';',cEmail)!=0  // ele esta contido ,porem pode ser o primeiro
			TMP1->MARCA := cMarca
			nEmail++
		endif
	endif
	TMP1->COD   := AUUX->COD
	TMP1->NOME:= AUUX->NOME
	TMP1->EMAIL:= AUUX->EMAIL
	TMP1->ID  := AUUX->R_E_C_N_O_
	TMP1->(MsUnLock())
	
	AUUX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	
EndDo

//TMP2->( DbGotop() )
AUUX->(DBCloseArea())
oBrw1:oBrowse:Refresh()
TMP1->( DBGoTop() )

Return















Static Function TMP2Mark()



RecLock("TMP1", .F.)
if TMP1->MARCA!=" "
	TMP1->MARCA := " "
	
	cEmail:=strtran(cEmail,alltrim(TMP1->EMAIL)+';','')
	nEmail--
else
	if empty(alltrim(TMP1->EMAIL))
		alert('Nao é possivél selecionar esse cliente ,pois o mesmo<br> nao possui endereço de email cadastrado !')
		
	else
		TMP1->MARCA := cMarca
		cEmail+=alltrim(TMP1->EMAIL)+';'
		nEmail++
	endif
endif


TMP1->(MsUnlock())
oGeMAIL:Refresh()
return









Static Function editar (ID)
dbSelectArea("SA1")
dbSetOrder(1)
if ! dbSeek(xFilial("SA1") + TMP1->COD  ,.F.)
	return
endif

Private cCadastro  := OemToAnsi( "CLIENTE" )
Private aRotina := {;
{"Pesquisar" , "AxPesqui"   , 0, 1},;
{"Visualizar", "AxAltera", 0, 4};
}

TMP1->(Msgoto( recno() ))
AxAltera("SA1", TMP1->(recno()),2)


return




Static Function Enviar()
if empty(nEmail)
	alert("Nenhum cliente foi selecionado.")
	return
endif

nEnvio:=1
alert(  strzero(nEnvio,3)+" / "+strzero(nEmail,3)  )

TMP1->( DBGoTop() )
While  ! TMP1->( EOF() )
	if TMP1->MARCA!=" "
		MsAguarde( {|| 	email( ) }, OemToAnsi( "Aguarde" ), OemToAnsi( "Enviando email "+strzero(nEnvio,3)+" / "+strzero(nEmail,3)) )
		nEnvio++
	endif
	TMP1->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	
EndDo

oBrw1:oBrowse:Refresh()
TMP1->( DBGoTop() )
oDlg1:end()
return





Static Function email( )

cInicio:=CabecEmail()
cInicio +="<font size='4px;'>"
//cInicio +="<div style='position:absolute;top:-10;left:15%;border:dash;width:70%;height:110%;background-color:#99CC99;'></div>"
cInicio +="<div style='position:absolute;left:15%;width:70%;'>"
cInicio +="<p align='right'>Cabedelo "+dtoc(ddatabase)+"</p>"
cInicio +="<p align='left'>"+TMP1->NOME+"</p>"
//cInicio +="<p align='left'>"+TMP1->EMAIL+"</p>"
cInicio +="<br> "
cInicio +="<p align='left'>A Rava Embalagens tem como missão atender todos os nossos clientes com 100% de qualidade nos produtos e nos serviços prestados, por isso estamos enviando esse email como forma de desejar-lhe boas vindas."
cInicio +="<br>Qalidade, Agilidade e pontualidade. É assim que iremos atendê-los."
cInicio +="<br>Colocamo-nos à disposição, procurando estar sempre à altura de suas exigências."
cInicio +="<br>Agradecemos pela preferência "
cInicio +="<br><br>Cordiais saudações. "
cInicio +="<br><b>Comercial Rava Embalagens "
cInicio +="<br>SAC: 08007271915 "
cInicio +="<br>www.ravaembalagens.com.br "
cInicio +="<b></font>"
cInicio +="</div>"




cInicio +='</table>'
cInicio +='</center>'
cInicio +='</body>'
cInicio +='</html>'


//cEmail   :="rubem@ravaembalagens.com.br"

cEmail:="rubem@ravaembalagens.com.br;"

cAssunto := oemtoansi('Bem vindo a Rava Embalagens')
//ACSendMail(,,,,cEmail,cAssunto,cInicio,)
U_SendMailSC(cEmail ,"" , cAssunto, cInicio,"" )

return





STATIC function CabecEmail()
Local cInicio:=" "

cInicio+='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> '
cInicio+='<html xmlns="http://www.w3.org/1999/xhtml"> '
cInicio+='<head> '
cInicio+='<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /> '
cInicio+='<title></title> '
cInicio+='</head> '
cInicio+='<body> '
cInicio+='<center>'

cInicio+='<img src="http://www.ravaembalagens.com.br/figuras/topemail.gif" name="_x0000_i1025" border="0"> '
cInicio+='</center>'
cInicio+=' <br>'

return cInicio    
