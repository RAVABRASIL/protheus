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

User Function FINC005 ( ) 
public dData1:=dData2:=stod("")
 public coTbl1:=coTbl2:=0,;
 cMarca := GetMark() 
oDlg1      := MSDialog():New( 041,066,616,636,"Despesas Extras",,,.F.,,,,,,.T.,,,.F. )
oGrp1      := TGroup():New( 004,004,025,277,"Data",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 012,012,{||"De:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,012,008)
oGDt1      := TGet():New( 012,024,,oGrp1,036,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dData1",,)  
oGDt1:bSetGet := {|u| If(PCount()>0,dData1:=u,dData1)}

oSay2      := TSay():New( 012,068,{||"Ate:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,013,008)
oGDt2      := TGet():New( 012,080,,oGrp1,048,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dData2",,)
oGDt2:bSetGet := {|u| If(PCount()>0,dData2:=u,dData2)}

oBtn1      := TButton():New( 010,134,"Filtrar",oGrp1,{||  atualiza() },052,012,,,,.T.,,"",,,,.F. )




oTbl1()
DbSelectArea("TMP1")
oBrw1      := MsSelect():New( "TMP1","","",{;
{"COD"     ,"","codigo"    ,""},;
{"MATRIC"  ,"","Passageiro",""},;
{"COMP"    ,"","Empresa"   ,""} ;
;//{"ID"      ,"","id"  ,""} ;
},.F.,,{030,004,124,277},,, oDlg1 )  
atualiza()
 oBrw1:OBrowse:bChange := {|| atualiza2() }
oBrw1:oBrowse:bLDBLClick := {|| visualizar(TMP1->ID) }



oTbl2()
DbSelectArea("TMP2")
oBrw2      := MsSelect():New( "TMP2","","",{;
{"COD" ,"","Codigo"    ,""},;
{"VALOR"  ,"","Valor"     ,""},;
{"DESCRI"   ,"","Descricao" ,""} ;
},.F.,,{142,004,275,234},,, oDlg1 ) 

   
oBtn3      := TButton():New( 142,240,"&Adicionar",oDlg1,{|| U_subtela(1)},037,012,,,,.T.,,"",,,,.F. )
oBtn4      := TButton():New( 154,240,"&Editar   ",oDlg1,{|| U_subtela(2)},037,012,,,,.T.,,"",,,,.F. )
oBtn5      := TButton():New( 166,240,"&Deletar  ",oDlg1,{|| U_subtela(3)},037,012,,,,.T.,,"",,,,.F. )
//oSBtn1     := SButton():New( 244,251,1,,oDlg1,,"", )     
     
 
oBrw1:oBrowse:lHasMark := .F.
oBrw1:oBrowse:lCanAllmark := .F. 

 
oBrw2:oBrowse:lHasMark := .F.
oBrw2:oBrowse:lCanAllmark := .F.

oDlg1:Activate(,,,.T.)
TMP1->(DBCloseArea())  
Ferase(coTbl1) // APAGA O ARQUIVO DO DISCO

TMP2->(DBCloseArea())  
Ferase(coTbl2) // APAGA O ARQUIVO DO DISCO

Return








/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl1() - Cria temporario para o Alias: TMP1
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl1()

Local aFds := {}

Aadd( aFds , {"COD"     ,"C",006,000} )
Aadd( aFds , {"MATRIC"  ,"C",030,000} )
Aadd( aFds , {"COMP"    ,"C",030,000} )
Aadd( aFds , {"ID"      ,"N",010,000} )

coTbl1 := CriaTrab( aFds, .T. )
Use (coTbl1) Alias TMP1 New Exclusive
Return 

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl2() - Cria temporario para o Alias: TMP
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl2()

Local aFds := {}
 
//Aadd( aFds , {"CODIGO"  ,"C",006,000} )
//Aadd( aFds , {"MATRIC"  ,"C",030,000} )
//Aadd( aFds , {"COMP"    ,"C",030,000} )

Aadd( aFds , {"COD" ,"C",006,000} )
Aadd( aFds , {"VALOR"   ,"N",010,002} )     
Aadd( aFds , {"DESCRi"    ,"C",200,000} )

coTbl2 := CriaTrab( aFds, .T. )
Use (coTbl2) Alias TMP2 New Exclusive
Return 






***************
Static Function atualiza()
***************
  
dbSelectArea("Z62")
dbSetOrder(1) 
 


cQry:=" SELECT Z62_CODIGO COD ,Z62_MATRIC MATRIC , Z62_COMP COMP,  R_E_C_N_O_ R_E_C_N_O_    "
cQry+=" FROM "+retSqlName("Z62")+" Z62 "
cQry+=" WHERE "
if !empty(dtos(dData1)) .and. !empty(dtos(dData2)) 
  if dData1 <= dData2
     cQry+=" Z62_DTFAT BETWEEN "+(dtos(dData1))+" AND "+(dtos(dData2))+" AND "
  endif
endif
cQry+=" D_E_L_E_T_='' "
cQry+=" and Z62_REMARC='' "
cQry+=" and Z62_CANCEL='' "
TCQUERY cQry NEW ALIAS "AUUX"

TMP1->( __DbZap() ) // LIMPAR O CONTEUDO DA TABELA TEMPORARIA 
AUUX->( DBGoTop() )

While  ! AUUX->( EOF() )

  RecLock("TMP1",.T.)

  TMP1->COD   := AUUX->COD
  TMP1->MATRIC:= U_USU_cod2Nome(AUUX->MATRIC)
  TMP1->COMP  := Posicione('SX5',1,xFilial("SX5")+'Z7'+ALLTRIM(AUUX->COMP),"X5_DESCRI") //AUUX->COMP
  TMP1->ID  := AUUX->R_E_C_N_O_
  TMP1->(MsUnLock())

  AUUX->(dbSkip()) // Avanca o ponteiro do registro no arquivo

EndDo

//TMP2->( DbGotop() )
 AUUX->(DBCloseArea())
oBrw1:oBrowse:Refresh()
TMP1->( DBGoTop() )

Return 











***************
Static Function atualiza2()
***************
  
dbSelectArea("Z72")
dbSetOrder(1) 
 


cQry:=" SELECT Z72_COD2 COD ,Z72_VALOR VALOR , Z72_DESCRI DESCRI    "
cQry+=" FROM "+retSqlName("Z72")+" Z72 "
cQry+=" WHERE "
cQry+=" Z72_COD = " + TMP1->COD
cQry+=" and D_E_L_E_T_='' "
TCQUERY cQry NEW ALIAS "AUUX"

TMP2->( __DbZap() ) // LIMPAR O CONTEUDO DA TABELA TEMPORARIA 
AUUX->( DBGoTop() )

While  ! AUUX->( EOF() )

  RecLock("TMP2",.T.)
 
  TMP2->COD     := AUUX->COD
  TMP2->VALOR   := AUUX->VALOR
  TMP2->DESCRI  := AUUX->DESCRI
  TMP2->(MsUnLock())

  AUUX->(dbSkip()) // Avanca o ponteiro do registro no arquivo

EndDo

//TMP2->( DbGotop() )
 AUUX->(DBCloseArea()) 
 TMP2->( DBGoTop() )
oBrw2:oBrowse:Refresh()


Return 

   


Static Function TMP2Mark()

Local lDesMarca := TMP1->(IsMark("MARCA", cMarca))

RecLock("TMP1", .F.)
if lDesmarca
   TMP1->MARCA := "  "
else
   TMP1->MARCA := cMarca
endif


TMP1->(MsUnlock())

return




/*
User Function FINC005 (cCodVi,cMatric)
public aItems:={},nList:=0                         
//cQry:="
//cQry+="
aItems:={;
{"1","hotel1"},;
{"2","hotel2"},;
{"3","hotel3"},;
{"4","hotel4"},;
{"5","hotel5"},;
{"6","hotel6"};
}
SetPrvt("oDlg2","oViagem","oSay2","oGViagem","oLista","oInclui","oAltera","oRemove","oOk","oCancela")
oDlg2      := MSDialog():New( 120,353,303,751,"oDlg2",,,.F.,,,,,,.T.,,,.F. )
oViagem    := TSay():New( 008,008,{||"Viagem"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,025,008) 
oSay2      := TSay():New( 027,008,{||"Despesas"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGViagem   := TGet():New( 006,035,,oDlg2,035,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCodVi",,)
oGViagem:bSetGet := {|u| If(PCount()>0,cCodVi:=u,cCodVi )}
oGViagem:disable()         
oList     := TListBox():New( 023,035,{|u|if(Pcount()>0,nList:=u,nList)},aItems,098,058,,oDlg2,,CLR_BLACK,CLR_WHITE,.T.,,,,"",,,,,,, )
oInclui    := TButton():New( 023,136,"&Incluir",oDlg2,{ || subtela(1,oList:nAt) },053,012,,,,.T.,,"",,,,.F. )
oAltera    := TButton():New( 038,136,"&Alterar",oDlg2,{ || subtela(2,oList:nAt) },053,012,,,,.T.,,"",,,,.F. )
oRemove    := TButton():New( 053,136,"&Remover",oDlg2,{ || deletar(oList:nAt) },053,012,,,,.T.,,"",,,,.F. )
oOk        := SButton():New( 070,136,1,,oDlg2,,"", )
oCancela   := SButton():New( 070,163,2,,oDlg2,,"", )
oNome      := TSay():New( 006,073,{|| U_USU_cod2Nome(cCMatric)},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,116,010)
oDlg2:Activate(,,,.T.)
Return        
*/







User Function subtela(nFunc)
local  nValor:=0
local  cDescri:=space(200)
SetPrvt("oDlg3","oValor","oGValor","oDesc","oMGdesc","oOK","oCancela")
   
if nFunc==2    
   nValor:=TMP2->VALOR
cDescri:=TMP2->DESCRI+space(200-len(TMP2->DESCRI)) 
endif
if nFunc==3  
 deletar() 
 return
endif

oDlg3      := MSDialog():New( 128,313,384,672,"oDlg3",,,.F.,,,,,,.T.,,,.F. )
oValor     := TSay():New( 012,004,{||"Valor"},oDlg3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,026,008)
oGValor    := TGet():New( 010,032,{|u| If(PCount()>0,nValor:=u,nValor)},oDlg3,060,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nValor",,)

oDesc      := TSay():New( 028,004,{||"Descrição"},oDlg3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,027,008)
oGDesc     := TMultiGet():New( 028,032,{|u| If(PCount()>0,cDescri:=u,cDescri)},oDlg3,139,074,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )

//oGDesc     := TGet():New(      028,032,{|u| If(PCount()>0,cDescri:=u,cDescri)},oDlg3,139,074,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDescri",,)

if     nFunc==1  
oOK        := SButton():New( 108,116,1,{|| adicionar(nValor,cDescri),oDlg3:end()},oDlg3,,"", )
elseif nFunc==2    
oOK        := SButton():New( 108,116,1,{|| editar(nValor,cDescri)   ,oDlg3:end()},oDlg3,,"", ) 
endif
oCancela   := SButton():New( 108,145,2,{|| oDlg3:end()            },oDlg3,,"", )

oDlg3:Activate(,,,.T.)

Return


 

Static Function Adicionar (nValor,cDescri)
cCod:= GetSx8Num( "Z72", "Z72_COD2" )
  	 RecLock('Z72',.T.)
     Z72->Z72_FILIAL := xFILIAL("Z72")
	 Z72->Z72_COD    := TMP1->COD
	 Z72->Z72_COD2    := cCod
	 Z72->Z72_VALOR  := nValor
	 Z72->Z72_DESCRI := cDescri
     Z72->(MsUnlock())
ConfirmSX8()  
     atualiza2()
  
Return Nil

       
Static Function Editar (nValor,cDescri)  
//Posicione("Z72",2,xFilial("Z72") + TMP1->COD +alltrim(str(nValor))+alltrim(cDescri), "Z72_COD") 

dbSelectArea("Z72")
dbSetOrder(2)  
//alert(xFilial("Z72") + TMP2->COD +alltrim(str(TMP2->VALOR))+alltrim(TMP2->DESCRI))
if ! dbSeek(xFilial("Z72") + TMP1->COD +TMP2->COD ,.F.) 
   return
endif
 
   	 RecLock('Z72',.F.)
     Z72->Z72_FILIAL := xFILIAL("Z72")
	 Z72->Z72_COD    := TMP1->COD 
	 Z72->Z72_VALOR  := nValor
	 Z72->Z72_DESCRI := cDescri
     Z72->(MsUnlock())  
     atualiza2()  
     
Return Nil 

       


Static Function Deletar ( )      
dbSelectArea("Z72")
dbSetOrder(2) 
if ! dbSeek(xFilial("Z72") + TMP1->COD +TMP2->COD ,.F.) 
   return
endif
 
   	 RecLock('Z72',.F.)
	 Z72->(dbDelete())
     Z72->(MsUnlock())  
     atualiza2()   
Return Nil 


      
Static Function visualizar (ID)
dbSelectArea("Z62")
dbSetOrder(1) 
if ! dbSeek(xFilial("Z62") + TMP1->COD  ,.F.) 
   return
endif
 
Private cCadastro  := OemToAnsi( "Viagem" )
Private aRotina := {;
{"Pesquisar" , "AxPesqui"   , 0, 1},;
{"Visualizar", "AxVisual", 0, 2};
}

Z62->(Msgoto( recno() ))
AxVisual("Z62", Z62->(recno()),2)  

               
return