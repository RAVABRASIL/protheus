#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch"

*************************
User Function FINC003()  
*************************

Local aCores := {{ "Z62->Z62_BLOQ == '1'", 'BR_VERDE'    },; //Viagem Liberada
				 { "Z62->Z62_BLOQ == '2'", 'BR_AMARELO'  },; //Viagem Pendente de Cotação
				 { "Z62->Z62_BLOQ == '3'", 'BR_LARANJA'  },; //Viagem Bloqueada
				 { "Z62->Z62_BLOQ == '5'", 'BR_PRETO'    }}  //Viagem Cancelada
       
Local aIndex    := {}
public cCOD     :=""
public cCODUTI  := Space(6)
public cBILHETe := Space(15)
public cCOMP    := Space(6)
public cFATURA  := Space(7)
public cMATRIC  := Space(6)
public cTRECHO  := Space(50)
public dDTVIAG  := CtoD(" ")
public nNewML   := 0
public nValor   := 0
public nMilhas  := 0

Public cMarca   := GetMark()
Public coTbl1
Public coTbl2
Public cEdi     := space(6)
Public cMatric  := space(6)
Public cEmpresa := space(6)
Public aFds     := {}
Public nRecno

//{"&Remarcar"         ,"U_Remarcar()"  ,0 , 5},;

aRotina :={;
{"&Pesquisar"        ,"AxPesqui"      ,0 , 1},;
{"&Visualizar"       ,"AxVisual"      ,0 , 2},;
{"&Solic Viagem"     ,"U_Incluir()"   ,0 , 3},;
{"&Cotação"          ,"U_fAltera()"   ,0 , 4},;
{"&Cancelar"         ,"U_Cancelar()"  ,0 , 5},;  //{"&Excluir"          ,"U_Deletar()"   ,0 , 5},;
{"&Despesas Viagem"  ,"U_Gerar(1,Z62->Z62_CODIGO)"     ,0 , 5},;
{"&Email Financ"     ,"U_Gerar(2,Z62->Z62_CODIGO)"     ,0 , 2},;
{"&Liberar"          ,"U_fLiberar()"  ,0 , 6},;
{"&Agenda"          ,"U_FAGEVIA()"  ,0 , 6},;
{"&Legenda"          ,"U_LegViag()"   ,0 , 6};
}

cAlias:="Z62"
cCadastro := OemToAnsi("Cadastro na TABELA "+cAlias)
DbSelectArea(cAlias )
DbSetOrder(1)
mBrowse( 06, 01, 22, 75,cAlias,,,,,,aCores)

Return

**********************
User Function Incluir()
********************** 

Local aAreaAtu	:= GetArea()
Local aAreaZ62	:= Z62->(GetArea())
Private cCodigo   := CriaVar("Z62_CODIGO",.F.,.F.)
Private DData     := CriaVar("Z62_DTVIAG",.F.,.F.)
Private dData1_   := CriaVar("Z62_DTVIAG",.F.,.F.)
Private dData12   := CriaVar("Z62_DTVIAG",.F.,.F.)
Private dData12_  := CriaVar("Z62_DTVIAG",.F.,.F.)
Private cCodH     := Space(6)
Private dViagem   := CriaVar("Z62_DTVIAG",.F.,.F.)
Private dViaVol   := CriaVar("Z62_DTVIAG",.F.,.F.)
Private cMatricu  := CriaVar("Z62_MATRIC",.F.,.F.)
Private cObser    := CriaVar("Z62_OBS",.F.,.F.)
Private cMotiv    := Space(6)
Private cMunO_    := Space(6) /*--*/
Private cMunOri   := Space(30)
Private cMunOrM4  := Space(30)
Private cMunOrM_  := Space(30)
Private cMunOrMD4 := Space(30)
Private cMunDes   := Space(30)
Private cTran   := Space(30)
Private cAlimen   := Space(30)
Private cTransp   := Space(30)
Private dData1  := CriaVar("Z62_DTTRID",.F.,.F.)
Private cUfOri4 := Space(2)
Private cUfOriD4:= Space(2)
Private cUfOri4_:= Space(2)
Private cUfOri  := Space(2)
Private cUfDes  := Space(2)
Private cUfOriD_:= Space(2)
Private cIDAG_:= Space(6)

Private nOpcA
eEmail := ""
DL := CHR(13) + CHR(10)
cMsg := ""
subj := ""  

DbSelectArea("Z62")
Z62->(DBGOBOTTOM())
cCodigo := Z62->Z62_CODIGO
while Z62->( DbSeek( xFilial( "Z62" ) + cCodigo ) )
   ConfirmSX8()
   cCodigo := Strzero(Val(cCodigo) + 1,6)
end
DbSelectArea("Z62")
Z62->(DBGOTOP())

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oSay3","oSay10","oSay11","oSay12","oSay13","oGet1","oGet2","oGet3")
SetPrvt("oGet11","oGet12","oGet13","oGrp2","oSay4","oSay5","oSay6","oSay7","oSay8","oSay9","oSay14","oSay15","oSay16")
SetPrvt("oSay17","oGet4","oGet5","oGet6","oGet7","oGet8","oGet9","oGet14","oGet15","oGet16","oGet17")
SetPrvt("oSayT2", "oSayD1", "oGetD1", "oSayUf4", "oGetUf4","oSayM4", "oGetM4","oGrp4")
SetPrvt("oSayD2", "oGetD2", "oSayUfd4", "oGetUf4", "oSayMD4","oGetMD4","oSayT3","oSayD1","oGetD1_")
SetPrvt("oSayUf4_ ", "oGetUf4_ ", "oSayM4_", "oGetM4_", "oSayD2_","oGetD2_","oSayUfd_","oGetUf_","oSayMD_","oGetMD_")
SetPrvt("oBtn2","oGrp3","oSay18","oSay19","oGet18","oGet19")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

oDlg1      := MSDialog():New( 118,248,605,708,"Viagens dos Colaboradores",,,.F.,,,,,,.T.,,,.F. )

/*REFERENTE AO PRIMEIRO QUADRO - CADASTRO DA VIAGEM*/

oGrp1      := TGroup():New( 004,007,050,220,"Cadastro de Viagens",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 017,012,{||"Codigo"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,025,008)
oSay3      := TSay():New( 033,012,{||"Matricula"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,024,008)
oSay12     := TSay():New( 015,140,{||"Data Ida"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
oSay13     := TSay():New( 031,140,{||"Data Volta"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)

oGet1      := TGet():New( 015,047,,oGrp1,043,008,'',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCodigo",,)
oGet1:bSetGet := {|u| If(PCount()>0,cCodigo:=u,cCodigo)}
oGet1:Disable()

oGet3         := TGet():New( 031,047,,oGrp1,043,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"US5","cMatricu",,)
oGet3:bSetGet := {|u| If(PCount()>0,cMatricu:=u,cMatricu)}

oGet12         := TGet():New( 015,173,,oGrp1,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dViagem",,)
oGet12:bSetGet := {|u| If(PCount()>0,dViagem:=u,dViagem)}

oGet13         := TGet():New( 031,173,,oGrp1,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dViaVol",,)
oGet13:bSetGet := {|u| If(PCount()>0,dViaVol:=u,dViaVol)}

/*Referente ao Segundo - QUADRO - Dados da Viagem*/

oGrp2      := TGroup():New( 050,007,102,220,"Dados da Viagem",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

oSay4      := TSay():New( 060,011,{||"UF Orig"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,021,008)
oGet4         := TGet():New( 060,047,,oGrp2,020,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"12","cUfOri",,)
oGet4:bSetGet := {|u| If(PCount()>0,cUfOri:=u,cUfOri)}

oSay6      := TSay():New( 060,075,{||"Mun Orig"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,026,008)
oGet4_1       := TGet():New( 060,105,,oGrp2,098,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"CC2Z62","cMunOri",,)
oGet4_1:bSetGet := {|u| If(PCount()>0,cMunOri:=u,cMunOri)}

oSay5      := TSay():New( 074,011,{||"UF Desti"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,021,008)
oGet5         := TGet():New( 074,047,,oGrp2,020,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"12","cUfDes",,)
oGet5:bSetGet := {|u| If(PCount()>0,cUfDes:=u,cUfDes)}

oSay7           := TSay():New(074,075,{||"Mun Des"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,026,008)
oGet5_1         := TGet():New( 074,105,,oGrp2,098,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"CC2Z6X","cMunDes",,)
oGet5_1:bSetGet := {|u| If(PCount()>0,cMunDes:=u,cMunDes)}

oSay16     := TSay():New( 090,011,{||"Obs.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,013,008)
oGet17         := TGet():New( 090,047,,oGrp2,167,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cObser",,)
oGet17:bSetGet := {|u| If(PCount()>0,cObser:=u,cObser)}

/*Referente ao Terceiro - QUADRO - TRechos*/

oGrp4      := TGroup():New( 105,007,179,220,"Trechos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

oSayT2      := TSay():New( 113,011,{||"Trecho-2"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,011)

oSayD1     := TSay():New( 123,011,{||"Data Ida"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetD1         := TGet():New( 121,032,,oGrp4,038,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dData1",,)
oGetD1:bSetGet := {|u| If(PCount()>0,dData1:=u,dData1)}

oSayUf4      := TSay():New( 123,079,{||"UF Orig"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,021,008)
oGetUf4         := TGet():New( 121,097,,oGrp4,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"12","cUfOri4",,)
oGetUf4:bSetGet := {|u| If(PCount()>0,cUfOri4:=u,cUfOri4)}

oSayM4      := TSay():New( 123,126,{||"Mun Orig"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,021,008)
oGetM4       := TGet():New( 121,150,,oGrp4,070,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"CC2Z6Y","cMunOrM4",,)
oGetM4:bSetGet := {|u| If(PCount()>0,cMunOrM4:=u,cMunOrM4)}

oSayD2     := TSay():New( 136,011,{||"Data Vol"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetD2         := TGet():New( 134,032,,oGrp4,038,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dData12",,)
oGetD2:bSetGet := {|u| If(PCount()>0,dData12:=u,dData12)}

oSayUfd4      := TSay():New( 136,079,{||"UF Dest"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,021,008)
oGetUf4         := TGet():New( 134,097,,oGrp4,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"12","cUfOriD4",,)
oGetUf4:bSetGet := {|u| If(PCount()>0,cUfOriD4:=u,cUfOriD4)}

oSayMD4      := TSay():New( 136,126,{||"Mun Dest"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,021,008)
oGetMD4       := TGet():New( 134,150,,oGrp4,070,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"CC2Z6W","cMunOrMD4",,)
oGetMD4:bSetGet := {|u| If(PCount()>0,cMunOrMD4:=u,cMunOrMD4)}

oSayT3      := TSay():New( 145,011,{||"Trecho-3"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,011)

oSayD1_     := TSay():New( 155,011,{||"Data Ida"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetD1_         := TGet():New( 153,032,,oGrp4,038,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dData1_",,)
oGetD1_:bSetGet := {|u| If(PCount()>0,dData1_:=u,dData1_)}

oSayUf4_      := TSay():New( 155,079,{||"UF Orig"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,021,008)
oGetUf4_         := TGet():New( 153,097,,oGrp4,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"12","cUfOri4_",,)
oGetUf4_:bSetGet := {|u| If(PCount()>0,cUfOri4_:=u,cUfOri4_)}

oSayM4_      := TSay():New( 155,126,{||"Mun Orig"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,021,008)
oGetM4_       := TGet():New( 153,150,,oGrp4,070,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"CC2Z6A","cMunOrM_",,)
oGetM4_:bSetGet := {|u| If(PCount()>0,cMunOrM_:=u,cMunOrM_)}

oSayD2_     := TSay():New( 168,011,{||"Data Vol"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGetD2_         := TGet():New( 166,032,,oGrp4,038,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dData12_",,)
oGetD2_:bSetGet := {|u| If(PCount()>0,dData12_:=u,dData12_)}

oSayUfd_      := TSay():New( 168,079,{||"UF Dest"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,021,008)
oGetUf_         := TGet():New( 166,097,,oGrp4,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"12","cUfOriD_",,)
oGetUf_:bSetGet := {|u| If(PCount()>0,cUfOriD_:=u,cUfOriD_)}

oSayMD_       := TSay():New( 168,126,{||"Mun Dest"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,021,008)
oGetMD_       := TGet():New( 166,150,,oGrp4,070,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"CC2Z6B","cMunO_",,)
oGetMD_:bSetGet := {|u| If(PCount()>0,cMunO_:=u,cMunO_)}

/*Referente ao Último - QUADRO - ADIANTAMENTO*/

oGrp3          := TGroup():New( 180,007,220,220,"Adiantamento",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay18         := TSay():New( 189,012,{||"Transporte"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
oSay19         := TSay():New( 209,012,{||"Alimentação"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)

oCBox1         := TComboBox():New( 189,045,,{"Sim", "Nao"},025,014,oGrp3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
oCBox1:nAt := 1
oCBox2         := TComboBox():New( 206,045,,{"Sim", "Nao"},025,014,oGrp3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
oCBox2:nAt := 1

oGet18         := TGet():New( 189,075,,oGrp3,140,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cTran",,)
oGet18:bSetGet := {|u| If(PCount()>0,cTran:=u,cTran)}     

oGet19         := TGet():New( 206,075,,oGrp3,140,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cAlimen",,)
oGet19:bSetGet := {|u| If(PCount()>0,cAlimen:=u,cAlimen)}

/*oCBox3         := TComboBox():New( 223,045,,{"Cartao 1", "Cartao 1", "Cartao 3"},025,014,oGrp3,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
oCBox3:nAt := 1*/


oSayIdAg := TSay():New( 225,012,{||"Agenda:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,024,008)
oGetIdAg         := TGet():New( 225,047,,oDlg1,043,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZZE","cIDAG_",,)
oGetIdAg:bSetGet := {|u| If(PCount()>0,cIDAG_:=u,cIDAG_)}
oGetIdAg:bValid := {|| FIDAGEN(cIDAG_) }

/*Botões de Confirma e Cancela*/

oBtn1      := TButton():New( 225,182,"Confirma",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
//oBtn1:bAction := {|| (nOpcA := 1, fOk(cCodigo, cMatricu, cMatricu, dViaVol, dViagem, dViagem, cUfOri, cMunOri, cUfDes, cMunDes, cObser, dData1, cUfOri4, cMunOrM4, dData12, cUfOriD4, cMunOrMD4, dData1_, dData12_, cUfOri4_, cUfOrid_, cMunOrM_, cMunO_, cTran, cAlimen) ) }       
oBtn1:bAction := {|| (nOpcA := 1, lOk := fValidaCpos(cMatricu, dViaVol, dViagem, cUfOri, cMunOri, cUfDes, cMunDes,cIDAG_) ) }       

oBtn2      := TButton():New( 225,136,"Cancelar",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
oBtn2:bAction := {|| (nOpcA := 0,oDlg1:End())}          



oDlg1:Activate(,,,.T.)

//If nOpcA = 1 .and. lOk
 	//grava dados
// 	MSGiNFO("CAMPOS OK, PODE GRAVAR!")
// 	oDlg1:End()
//Endif

RestArea(aAreaZ62)
RestArea(aAreaAtu)

Return

******************************************************************************************
Static Function fValidaCpos(cMatricu, dViaVol, dViagem, cUfOri, cMunOri, cUfDes, cMunDes)
******************************************************************************************

lRet:= .T.
nDiaViagem := 0
nDiaLancto := 0
nIntervalo := 0

nDiaViagem := Dow(dViagem) 
nDiaLancto := Dow(Date())


	If Empty(cMatricu)
		Alert("Favor Preencher a Matrícula do Colaborador !")
		lRet := .F.
		Return lRet		
    Endif
    
    If Empty(dViagem)
		Alert("Favor Preencher a Data da Viagem !")
		lRet := .F.
		Return lRet		 
    Endif
    
    If Empty(dViaVol)
		Alert("Favor Preencher a Data da Volta !")
		lRet := .F.
		Return lRet		
    Endif
    
    IF (dViaVol < dViagem)
			Alert("Dia da Volta é Menor que Dia Viagem, Favor Verificar as Datas !!!")
			lRet := .F.
			Return lRet		
	Endif

	IF (dViagem < DATE() ) //dDatabase)
		Alert("Dia da Viagem é Menor que Data de Hoje, Favor Verificar as Datas !!!")
		lRet := .F.
		Return lRet				
	Endif 
    
    If Empty(cUfOri)
		Alert("Favor Preencher o campo 'UF Orig' !")
		lRet := .F.
		Return lRet		 
    Endif
    
    If Empty(cMunOri)
		Alert("Favor Preencher o campo 'Mun Orig' !")
		lRet := .F.
		Return lRet	
    Endif
    
    If Empty(cUfDes)
		Alert("Favor Preencher o campo 'UF Desti' !")
		lRet := .F.
		Return lRet
    Endif
    
    If Empty(cMunDes)
		Alert("Favor Preencher o campo 'Mun Des' !")
		lRet := .F.
		Return lRet	
    Endif
   
    If Empty(cIDAG_)
		Alert("Favor Preencher o campo 'Agenda' !")
		lRet := .F.
		Return lRet	
    Endif




   /*
   1 - Domingo
   2 - Segunda
   3 - Terça
   4 - Quarta
   5 - Quinta
   6 - Sexta
   7 - Sábado
   */
   cDiaV := "" //DIA VIAGEM  
   cDiaL := ""   //DIA LANÇTO
   cDeveSer := ""
   nIntervalo := dViagem - DATE() //dDatabase  //intervalo de dias entre data viagem - data hoje que está lançando
   //ALERT("Dia da Viagem -> " + cDow(dViagem))
   cDiaV = DiaSemana(dViagem) // Quarta
   cDiaL = DiaSemana(dDatabase) //Date()
   
   //cDiaL = DiaSemana(Date()) //ativar este depois
   //ALERT("Dia da Viagem -> " + cDia)

   IF nIntervalo < 3 
        Alert("O Lançamento da Despesa, Deve Obrigatoriamente Ser 3 Dias Úteis Antes da Data da Viagem !")
        Return .F.
   ELSEif nIntervalo >= 3
   
   		//If nDiaViagem < 6 //qq dia, menos na 6a.feira :
   		If nDiaViagem < 5 //qq dia, menos na 5a. ou 6a.feira :
   			If nIntervalo < 5
   				Alert("O Lançamento da Despesa, Deve Obrigatoriamente Ser 3 Dias Úteis Antes da Data da Viagem !" + CHR(13) + CHR(10) + ;
   				      "Para Data Viagem: " + Dtoc(dViagem) + ", O Lançamento deveria ser Feito Dia: " + DTOC(dViagem - 5) + CHR(13) + CHR(10) + ;
   				      "Somente com a Senha Diretoria Poderá Prosseguir..." )
   				//lRet := .F.
   				lRet := U_Senha2("24",1)[1]  //SENHA DE REGINEIDE 
   				If !lRet	
   					
   					//envia email solicitando aprovação 
   					cMsg := ""
   					eEmail := ""
   					subj   := ""
   					cCopia := ""
   					cColab := ""
   					                               
   					cMsg   := "Prezado(a) Diretor(a)," + CHR(13) + CHR(10) + CHR(13) + CHR(10)
   					cMsg   += "A Solicitação de Viagem Abaixo, Requer Vossa Aprovação:" + CHR(13) + CHR(10)
   					
   					cColab := U_Func_Nome(cMatricu)
   					
   					cMsg   += "Colaborador: " + cColab + CHR(13) + CHR(10)
					cMsg   += "Origem     : " + cMunOri + '-' + cUfOri   + CHR(13) + CHR(10)
					cMsg   += "Destino    : " + cMunDes + '-' + cUfDes   + CHR(13) + CHR(10)
					cMsg   += "Data Viagem: " + Dtoc( dViagem) + CHR(13) + CHR(10)
					cMsg   += "Data Volta : " + Dtoc( dViaVol) + CHR(13) + CHR(10)
					
				
					aUsu := {}
					cNomeUsu := ""
					cDepto   := ""
					cMailUsu := ""
					//captura as informações do usuário logado, para compor a assinatura do email:
					PswOrder(1)
				    if PswSeek( __CUSERID, .T. )
				       aUsu := PSWRET() // Retorna vetor com informações do usuário
				       cNomeUsu := aUsu[1][4]  //nome completo
				       cDepto := aUsu[1][12]
				       cMailUsu  := aUsu[1][14]
				    Endif 
			    	cMsg   += "Atenciosamente," + CHR(13) + CHR(10) + CHR(13) + CHR(10)
			    	
					cMsg   += cNomeUsu  + CHR(13) + CHR(10)
					cMsg   += cDepto + CHR(13) + CHR(10)
					cMsg   += cMailUsu
					
					
					//eEmail := "flavia@ravaembalagens.com.br"
                    eEmail := "marcelo@ravaembalagens.com.br"					
					cCopia := "aline.farias@ravaembalagens.com.br"
					cCopia += ";regineide.neves@ravaembalagens.com.br"
					cCopia += ";flavia.rocha@ravaembalagens.com.br" //retirar
					
					subj   := "Solicitação Aprovação Viagem - " + cColab //assunto email
					U_SendFatr11(eEmail, cCopia, subj, cMsg, "" )
   				Endif
   				
   			//Else
   			//	lRet := .T.
   			//	ALERT("*** OK *** ")
   				
   			Endif   		
   		Endif
       
   ENDIF

	If lRet 
		//grava dados
			//MSGiNFO("CAMPOS OK, PODE GRAVAR!")
			
			  MsAguarde( { || fGrava(cCodigo, cMatricu, cMatricu, dViaVol, dViagem, dViagem,;
 								cUfOri, cMunOri, cUfDes, cMunDes, cObser, dData1, cUfOri4, cMunOrM4, dData12,;
 								cUfOriD4, cMunOrMD4, dData1_, dData12_, cUfOri4_, cUfOrid_, cMunOrM_, cMunO_, cTran, cAlimen ) }, "Aguarde. . .", "Gravando Dados da Viagem ..." )  
			
			oDlg1:End()
		
	Endif


Return lRet

*******************************************************************
Static Function fGrava(cCodigo, cMatricu, cMatricu, dViaVol, dViagem, dViagem,;
 cUfOri, cMunOri, cUfDes, cMunDes, cObser, dData1, cUfOri4, cMunOrM4, dData12,;
 cUfOriD4, cMunOrMD4, dData1_, dData12_, cUfOri4_, cUfOrid_, cMunOrM_, cMunO_, cTran, cAlimen )
*******************************************************************

	dbSelectArea("Z62")
	dbSetOrder(1)	
	If !Z62->(DbSeek(xFilial("Z62")+ cCodigo))
		RecLock("Z62",.T.)
			
			Z62->Z62_FILIAL := xFilial("Z62")
			Z62->Z62_CODIGO := cCodigo
			Z62->Z62_MATRIC	:= cMatricu
			Z62->Z62_DTVIAG := dViagem
			Z62->Z62_DTVOLT := dViaVol
			Z62->Z62_UFORIG := cUfOri
			Z62->Z62_UFDEST := cUfDes
			Z62->Z62_MUNORI := cMunOri
			Z62->Z62_MUNDES := cMunDes
			Z62->Z62_DTTRID := dData1
			Z62->Z62_UFT2ID := cUfOri4
			Z62->Z62_MUT2ID := cMunOrM4
 			Z62->Z62_DTT2VL := dData12
 			Z62->Z62_UFT2VL := cUfOriD4
 			Z62->Z62_MUT2VL	:= cMunOrMD4 //até aqui trecho 2
			Z62->Z62_DTT3ID := dData1_
			Z62->Z62_DTT3VL := dData12_
			Z62->Z62_UFT3ID := cUfOri4_
			Z62->Z62_UFT3VL := cUfOriD_
			Z62->Z62_MUT3ID := cMunOrM_
			Z62->Z62_MUT3VL := cMunO_
			Z62->Z62_TRANSP := iif(oCBox1:nat=1,"S","N")
			Z62->Z62_ALIMEN := iif(oCBox2:nat=1,"S","N")
			Z62->Z62_ADIAN1 := cTran
			Z62->Z62_ADIAN2 := cAlimen
			Z62->Z62_OBS    := cObser
            Z62->Z62_IDAGEN := cIDAG_
			Z62->Z62_BLOQ   := '3' //Sempre Bloqueada //'2' aguardando cotacao 
			
			/*
			IF (Z62->Z62_DTVIAG - dDatabase) < 15
				Z62->Z62_BLOQ := '3'
				ALERT("Solicitação Bloqueada")
				
			    cMsg := "Solicitação de Viagem Aguardando Aprovação: "
	    		cMsg += DL
	    		cMsg += "O Código da Solicitação de Viagem é: " + Z62->Z62_CODIGO + DL
	    		cMsg += DL
	    		cMsg += "O Colaborador é o Sr(a): " + fnome(alltrim(Z62->Z62_MATRIC))+ DL
	    	    cMsg += DL
	    	    cMsg += "A Data de Partida da Viagem é de: " + dtoc(Z62->Z62_DTVIAG) + DL
	    	    cMsg += DL
	    	    cMsg += "A Data de Retorno da Viagem é de: " + dtoc(Z62->Z62_DTVOLT) + DL
	    	    cMsg += DL
	    	    cMsg += " Local da Partida: " + cMunOri + DL
	    	    cMsg += DL
	    	    cMsg += " Local de Destino: " + cMunDes + DL
	    	    cMsg += DL
	    	    cMsg += "Observações: " + Z62->Z62_OBS + DL
	    	    	    	    
	    		SX5->(Dbsetorder(1))
					If SX5->(Dbseek(xFilial("SX5") + "MM" + Z62->Z62_MATRIC))      
						eEmail := Alltrim(SX5->X5_DESCRI)
					Endif
					 
	    		subj := "Solicitação de Viagens: "
	       		U_SendFatr11(eEmail, "", subj, cMsg, "" )
	    		Alert("Foi enviado um e-mail p/ o Gestor")
			
			else
				
				cMsg := "Solicitação de Viagem Aguardando Cotação: " 
	    		cMsg += "Data: " + Dtoc(Date()) 
	    		cMsg += " Hora: " + Time() + DL
	    		cMsg += "O Código da Solicitação de Viagem é: "
	    		cMsg += Z62->Z62_CODIGO
	    		eEmail := ""
	    		eEmail += ";regineide.neves@ravaembalagens.com.br" //voltar
	    		eEmail += ";aline.farias@ravaembalagens.com.br"		//voltar	 
	    		//eEmail += ";flavia.rocha@ravaembalagens.com.br"  //retirar
	    		subj := "Solicitação de Viagens: "
	       		
	       		U_SendFatr11(eEmail, "", subj, cMsg, "" )
	    		Alert("Email enviado p/ Cotação")
	    		
			Endif
			*/
			    cMsg := "Solicitação de Viagem Aguardando Aprovação: "
	    		cMsg += DL
	    		cMsg += "O Código da Solicitação de Viagem é: " + Z62->Z62_CODIGO + DL
	    		cMsg += DL
	    		cMsg += "O Colaborador é o Sr(a): " + fnome(alltrim(Z62->Z62_MATRIC))+ DL
	    	    cMsg += DL
	    	    cMsg += "A Data de Partida da Viagem é de: " + dtoc(Z62->Z62_DTVIAG) + DL
	    	    cMsg += DL
	    	    cMsg += "A Data de Retorno da Viagem é de: " + dtoc(Z62->Z62_DTVOLT) + DL
	    	    cMsg += DL
	    	    cMsg += " Local da Partida: " + cMunOri + DL
	    	    cMsg += DL
	    	    cMsg += " Local de Destino: " + cMunDes + DL
	    	    cMsg += DL
	    	    cMsg += "Observações: " + Z62->Z62_OBS + DL
	    	    cMsg += DL
	    	    cMsg += "Agenda: " + Z62->Z62_IDAGEN + DL

	    		eEmail := "marcelo@ravaembalagens.com.br"
	    		eEmail += ";antonio.feitosa@ravaembalagens.com.br"
					 
	    		subj := "Solicitação de Viagens: "
	       		U_SendFatr11(eEmail, "", subj, cMsg, "" )
			
			Z62->(MsUnlock())
			ALERT("Solicitação Incluída!")
	        oDlg1:End()	

	Endif

Return


**************************
User Function fLiberar()  
**************************

Local DLF := CHR(13) + CHR(10)
Local eEmailF := ""

eEmailF += ";regineide.neves@ravaembalagens.com.br"  //voltar
eEmailF += ";aline.farias@ravaembalagens.com.br" //voltar
eEmailF += ";marcelo@ravaembalagens.com.br" //ADD
//eEmailF += ";flavia.rocha@ravaembalagens.com.br" //retirar

cMsgF := "Solicitação de Viagem Aprovada Pelo Gestor: " + DLF
cMsgF += "Data: " + Dtoc(Date()) 
cMsgF += " Hora: " + Time() + DLF
cMsgF += "O Código da Solicitação de Viagem é: "
cMsgF += Z62->Z62_CODIGO + DLF
cMsgF += DLF
cMsgF += "Favor Realizar o processo de Cotação:"

subjF := "Viagem Liberada"  

If U_Senha2("23",1)[1]      //voltar
	RecLock("Z62",.F.)
	Z62->Z62_BLOQ:='2'
	Z62->( msUnlock() )
    
    U_SendFatr11(eEmailF, "", subjF, cMsgF, "" )
    Alert("Enviado para Cotação")
ENDIF


Return


      
**********************
User function Gerar(nOpGera, cCodigo)
**********************



LOCAL aArray := {}
Local dVencto:= Ctod("  /  /    ") 
Local aFeriados := { '0101' , '0421' , '0501' , '0907' , '1012' , '1115' , '1225' }
Local fr := 0
Local DLG := CHR(13) + CHR(10)

//alert("codigo: " + cCodigo)
eEmailG := ""
eEmailG += "financeiro@ravaembalagens.com.br;"
//eEmailG += ";regineide.neves@ravaembalagens.com.br"
eEmailG += ";aline.farias@ravaembalagens.com.br;"

//eEmailG += ";flavia.rocha@ravaembalagens.com.br"  //retirar

//exemplo:                    
//data viagem: 04/04/14
//o lançamento da viagem tem q ser 3 dias antes da viagem, ou seja, no exemplo da viagem 04/04,
//Aline tem q lançar dia 01/04
//vencto do título tem q ser: 03/04

If Dow(Z62->Z62_DTVIAG) = 2  //se a data da viagem cair numa segunda-feira, o título tem que ser pago na 6a.
	dVencto := (Z62->Z62_DTVIAG - 3) //pagar na 6a. feira, em viagens na 2a.feira
Else //se for qq outro dia, é um dia antes, padrão
	dVencto := (Z62->Z62_DTVIAG - 1) //vencto do título é 1 dia antes da viagem
Endif 

//aFeriados := { '0101' , '0421' , '0501' , '0907' , '1012' , '1115' , '1225' }
While (Ascan(aFeriados, Substr(DtoS(dVencto),5,4)) > 0)  .or. (Dow(dVencto) = 1 .or. Dow(dVencto) = 7)
//se a data Vencto gerada, for um feriado, retrocede para o dia útil anterior
//ou se a data Vencto gerada for um sábado ou domingo, vai voltando até ser dia útil (6a.feira por exemplo)
	dVencto := (dVencto - 1)	
Enddo  

cMsgG := "À" + DLG
cMsgG += "Diretoria Administrativo-Financeira." + DLG
cMsgG += DLG
cMsgG += "Assunto: Adiantamento de Despesas de Viagem." + DLG
cMsgG += DLG

If Time() <= "12:00"
	cMsgG := "Bom Dia. " + DLG
Elseif Time() < "18:00"
	cMsgG := "Boa Tarde, " + DLG
Else
	cMsgG := "Boa Noite, " + DLG
Endif

cMsgG += "Solicitamos adiantamento de verba para despesas de viagem a: " + Z62->Z62_MUNDES + " - " + Z62->Z62_UFDEST + "." + DLG
cMsgG += DLG
cMsgG += "Colaborador: " + U_Func_Nome(Z62->Z62_MATRIC) + DLG
cMsgG += "Data da Viagem: " + dtoc(Z62->Z62_DTVIAG) + DLG
cMsgG += "Data da Volta : " + dtoc(Z62->Z62_DTVOLT) + DLG
If !empty(Z62->Z62_OBS)
	cMsgG += "Motivo        : " + Alltrim(Z62->Z62_OBS) + DLG
	cMsgG += DLG
Endif

cMsgG += DLG
cMsgG += "O Valor Total do Adiantamento é: R$" + Transform(Z62->Z62_VALDES , "@E 999,999,999.99") 

cMsgG += DLG  
cMsgG += DLG
cMsgG += "*** Detalhamento das Despesas ***" + DLG
//LOCOMOÇÃO 
If !Empty(Z62->Z62_VALLOC)
	cMsgG += "Valor Locomoção: " + Transform(Z62->Z62_VALLOC , "@E 999,999,999.99") 	
Endif

If !Empty(Z62->Z62_ADIAN1)
	cMsgG += ", Referente a: " + Z62->Z62_ADIAN1
	cMsgG += DLG
Endif


//OUTROS VALORES
If !Empty(Z62->Z62_VALOUT)
	cMsgG += DLG
	cMsgG += "Outros Valores: " + Transform(Z62->Z62_VALOUT , "@E 999,999,999.99") 
	cMsgG += DLG
Endif

//ALIMENTAÇÃO
If !Empty(Z62->Z62_VALALI)
	cMsgG += DLG
	cMsgG += "Valor Alimentação: " + Transform(Z62->Z62_VALALI , "@E 999,999,999.99") 
Endif

If !Empty(Z62->Z62_ADIAN2)
	cMsgG += ", Referente a: " + Z62->Z62_ADIAN2
	cMsgG += DLG
Endif

cMsgG += DLG
cMsgG += "== Descriminado == " 
cMsgG += DLG 
cMsgG += DLG
              
nDias := Z62->Z62_DTVOLT - Z62->Z62_DTVIAG
ddata := Z62->Z62_DTVIAG 
aDias := {}
while ddata <= Z62->Z62_DTVOLT
	Aadd(aDias , ddata )
	ddata := ddata + 1
enddo
//variáveis móveis para as refeições
cCafe := "Z62->Z62_CAFE"
cAlm  := "Z62->Z62_ALM"
cJanta:= "Z62->Z62_JANTA" 
cVar  := ""
//loop para imprimir os campos referentes aos valores de café, almoço, janta de cada dia, que estiver preenchido
fr := 0
For fr := 1 to Len(aDias)
	
	cMsgG += "Dia: " + Dtoc(aDias[fr])  + DLG
	//café do dia se houver
	cVar := cCafe + Alltrim(Str(fr))
	If !Empty( &cVar )  //( &(cCafe)+Alltrim(Str(fr)) )   //If !Empty(Z62->Z62_CAFE1) 
		cMsgG += "- Café da Manhã: " + Transform( &cVar , "@E 999,999,999.99") + DLG
	Endif
		
	//almoço do dia se houver
	cVar := cAlm + Alltrim(Str(fr))
	If !Empty( &cVar )  //( &(cAlm)+Alltrim(Str(fr)) )   //If !Empty(Z62->Z62_CAFE1) 
		cMsgG += "- Almoço: " + Transform( &cVar , "@E 999,999,999.99") + DLG
	Endif
		
	//janta do dia se houver
	cVar := cJanta + Alltrim(Str(fr))
	If !Empty( &cVar )  //( &(cJanta)+Alltrim(Str(fr)) )   //If !Empty(Z62->Z62_CAFE1) 
		cMsgG += "- Jantar: " + Transform( &cVar , "@E 999,999,999.99") + DLG
	Endif
    cMsgG += DLG
Next

cMsgG += DLG
cMsgG += "Para tanto, Foi incluido um Título no contas a pagar, referente ao adiantamento de Despesas de Viagem, Conforme Abaixo: " + DLG
cMsgG += DLG

cMsgG += DLG

cMsgG += "ATENÇÃO     PARA    O       VENCIMENTO     DO    TÍTULO    ABAIXO:"
cMsgG += DLG
cMsgG += "Vencimento do Título: " + dtoc(dVencto)  //dtoc(Z62->Z62_DTVIAG - 3)
cMsgG += DLG
cMsgG += DLG
cMsgG += "O Número do Título gerado é: " + "000"+Z62->Z62_CODIGO + DLG
cMsgG += DLG
cMsgG += "O Valor do Reembolso é: R$" + Transform(Z62->Z62_VALDES , "@E 999,999,999.99") 

subjF := "Inclusão Título de Despesas de Viagens" 

//voltar
If nOpGera = 1 //gera financeiro
	//alert("GERA FINANCEIRO")

	IF (Z62->Z62_BLOQ <> '1')
			Alert("Viagem Não Liberada!")
		Return
	ENDIF
	
	dbSelectArea("Z62")
	dbSetOrder(1)	
	If Z62->(DbSeek(xFilial("Z62")+ Z62->Z62_CODIGO))
		IF (Z62->Z62_GERAFI = 'SIM')
			Alert("Título Já Gerado!")
			Return
		ENDIF
	Endif
	
	If ! U_Senha2("24",1)[1] // apenas a senha de regineide tabela ZY //voltar
	     Return 
	endif
	
	
	PRIVATE lMsErroAuto := .F.
	 
	DbSelectArea("SE2")
	DbSetOrder(2)
	


	aArray := { { "E2_PREFIXO"  , "UNI"             , NIL },;														
	            { "E2_NUM"      , "000"+Z62->Z62_CODIGO   , NIL },; //{ "E2_NUM"      , NextNumero( "SE2", 2, "E2_NUM", .T. )  , NIL },;
	            { "E2_TIPO"     , "REC"             , NIL },;
	            { "E2_NATUREZ"  , "20502"           , NIL },;
	            { "E2_FORNECE"  , "001357"          , NIL },;
	            { "E2_LOJA"     , "01"              , NIL },;
	            { "E2_EMISSAO"  , dDataBase         , NIL },;
	            { "E2_PARCELA"  , "1" ,             , NIL },;
	            { "E2_VENCTO"   , dVencto           , NIL },;
	            { "E2_VENCREA"  , dVencto           , NIL },;
	            { "E2_HIST"     , U_Func_Nome(Z62->Z62_MATRIC), NIL },;
	            { "E2_VALOR"    , Z62->Z62_VALDES   , NIL } }
	
	
	BEGIN TRANSACTION
	MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
	
		If lMsErroAuto
	    	MostraErro()
			DISARMTRANSACTION()
		Else
		
    	U_SendFatr11(eEmailG, "", subjF, cMsgG, "" )    	
	
	    	RecLock("Z62",.F.)
			Z62->Z62_GERAFI := 'SIM'
			Z62->(MsUnlock())
	    	MsgInfo("Título " + SE2->E2_NUM + " Incluído com Sucesso e Email Enviado, OK!! ")
		Endif
	
	END TRANSACTION
	
Elseif nOpGera = 2
    //se escolher a opção "só envia email", o título obrigatoriamente já tem que estar gerado
	
	dbSelectArea("Z62")
	dbSetOrder(1)	
	If Z62->(DbSeek(xFilial("Z62")+ Z62->Z62_CODIGO))
		IF EMPTY(Z62->Z62_GERAFI)
			Alert("Título Ainda Não Foi Gerado ! Favor Gerar Para que o Email possa Ser Enviado...")
			Return
		ELSE
			//alert("SÓ ENVIA EMAIL") 
			U_SendFatr11(eEmailG, "", subjF, cMsgG, "" )
			MsgInfo("E-mail Enviado, OK!! ")   
		ENDIF
	Endif
	 	
Endif
	
return

**********************
User function Milhas()
**********************
SetPrvt("oDlg1","oSay1","oGet1","oSBtn1","oSBtn2")
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 207,348,320,561,"Matricula",,,.F.,,,,,,.T.,,,.F. )
oSay1      := TSay():New( 06,004,{||"Matricula"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet1      := TGet():New( 06,036,{|u| If(PCount()>0,cMatric:=u,cMatric)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cMatric",,)
oGet1:cF3:="USR"

oSay2      := TSay():New( 018,004,{||"Empresa"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet2      := TGet():New( 018,036,{|u| If(PCount()>0,cEmpresa:=u,cEmpresa)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cEmpresa",,)
oGet2:cF3:="Z7"

oSBtn1     := SButton():New( 036,036,1,{|| oDlg1:end(),milhas()},oDlg1,,"Confirmar", )
oSBtn2     := SButton():New( 036,070,2,{|| oDlg1:end()         },oDlg1,,"Cancelar", )

oDlg1:Activate(,,,.T.)

return

*************************
static Function Milhas() 
*************************

SetPrvt("oDlg1","oGrp2","oSay3","oGrp1","oSay1","oEdita","oBtn1","oBrw1","oBrw2","oSay2")
oDlg1      := MSDialog():New( 132,209,600,1013,"Controle de Viagens",,,.F.,,,,,,.T.,,,.F. )

oGrp2      := TGroup():New( 012,005,230,396,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay3      := TSay():New( 020,011,{||"Viagens"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)

oBtn2 := SButton():New( 210.5 ,310,1,,oGrp2,,"&Confirmar", )
oBtn2:bAction := {||Baixa()}
oBtn3 := SButton():New( 210   ,338,2,,oGrp2,,"&Sair", )
oBtn3:bAction := {|| oDlg1:end()}

nRecno   := Z62->(RecNo())
oTbl2()
DbSelectArea("TMP2")
oBrw2 := MsSelect():New( "TMP2","MARCA","",;
{;
{"MARCA"  , "" , "MARCA"     ,"" },;
;// {"CODIGO" , "" , "CODIGO"    ,"" },;
{"NOME"   , "" , "NOME"      ,"" },;
;//{"MATRIC" , "" , "Matricula" ,"" },;
{"MILHAS" , "" , "MILHAS"    ,"" } ;
},.F.,cMarca,{40,10,200,390},, ,oDlg1)

oBrw2:bAval := {||TMP2Mark()}
oBrw2:oBrowse:bAllMark := {||TMP2MkAll()}
oBrw2:oBrowse:lHasMark := .T.
oBrw2:oBrowse:lCanAllmark := .T.
atualiza()
oBrw2:oBrowse:Refresh()

oDlg1:Activate(,,,.T.)

TMP2->(DBCloseArea())
Ferase(coTbl2)
Z62->(dbGoto(nRecno))
Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl2() - Cria temporario para o Alias: TMP2
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
************************
Static Function oTbl2() 
************************

aFds := {}
Aadd( aFds , {"MARCA"  ,"C",002,000} )
Aadd( aFds , {"CODIGO" ,"C",006,000} )
Aadd( aFds , {"NOME"   ,"C",015,000} )
Aadd( aFds , {"MATRIC" ,"C",006,000} )
Aadd( aFds , {"MILHAS" ,"N",010,002} )


coTbl2 := CriaTrab( aFds, .T. )
Use (coTbl2) Alias TMP2 New Exclusive
Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ EdiPre()
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

***************
Static Function atualiza()
***************
Local cQry:=''
dbSelectArea("Z62")
dbSetOrder(1)
TMP2->( __DbZap() ) // LIMPAR O CONTEUDO DA TABELA TEMPORARIA
Z62->( DBGoTop() )
While  ! Z62->( EOF() )
	if !Empty(Z62->Z62_CODUTI)        .or. ;// ja foi utilizado
		Z62->Z62_MATRIC != cMatric    .or. ;// filtro por usuario
		Z62->Z62_MILHAS == 0          .or. ;// nao ha milhas disponiveis
		Alltrim(Z62->Z62_CANCEL)!= "" .or. ;// viagem cancelada
		Alltrim(Z62->Z62_REMARC)!= "" .or. ;// viagem remarcada
		Z62->Z62_COMP   != cEmpresa      // filtro por companhia aerea
		// nao entram na lista de marcação
		Z62->(dbSkip())
		loop	
	endif
	RecLock("TMP2",.T.)                      
	TMP2->CODIGO:=Z62->Z62_CODIGO
	TMP2->MATRIC:=Z62->Z62_MATRIC 

	TMP2->NOME:=U_Usu_Cod2Nome(Z62->Z62_MATRIC) 
	
	TMP2->MILHAS:= Z62->Z62_MILHAS
	TMP2->(MsUnLock())
	Z62->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo

TMP2->( DbGotop() )
oBrw2:oBrowse:Refresh()

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ TMP2Mark() - Funcao para marcar o Item MsSelect
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
****************************
Static Function TMP2Mark()  
****************************

Local lDesMarca := TMP2->(IsMark("MARCA", cMarca))

RecLock("TMP2", .F.)
if lDesmarca
	TMP2->MARCA := "  "
else
	TMP2->MARCA := cMarca
endif

TMP2->(MsUnlock())

return

/*
ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ TMP2MkaLL() - Funcao para marcar todos os Itens MsSelect
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
****************************
Static Function TMP2MkAll() 
****************************

local nRecno := TMP2->(Recno())
TMP2->(DbGotop())
while ! TMP2->(EOF())
	RecLock("TMP2",.F.)
	if Empty(TMP2->MARCA)
			TMP2->MARCA := cMarca
		else
			TMP2->MARCA := "  "
	endif
	TMP2->(MsUnlock())
	TMP2->(DbSkip())
end
TMP2->(DbGoto(nRecno))

return .T.

***************
Static Function Baixa()
***************

local nRecno := TMP2->(Recno())

nMilhas:=0

cCod:= GetSx8Num( "Z62", "Z62_CODIGO" )
TMP2->(DbGotop())

while ! TMP2->(EOF())
	
	if !Empty(TMP2->MARCA)
		
		dbSelectArea("Z62")
		dbSetOrder(1)
		dbSeek(xFilial("Z62")+TMP2->CODIGO)

		nMilhas+=   TMP2->MILHAS  //- TMP2->MLUTI
		// Z62->(MsUnlock())
	endif
	TMP2->(DbSkip())
endDo
Cadastrar(cCod,nMilhas,.F.)

TMP2->(DbGoto(nRecno))

Return


**************************************************
static Function Cadastrar(cCod,nMilhas,lLibMilha) 
**************************************************

cCODUTI   := Space(6)
cBilhete  := Space(15)
cComp     := cEmpresa // Space(6)
cFatura   := Space(7)
cMatric   := Space(6) // cMatric
cTrecho   := Space(50)
dDtViag   := CtoD(" ")
dDtViag2  := CtoD(" ")
nNewML    := 0
nValor    := 0 
cObs      := Space(100)
dDtFat    := CtoD(" ")
/*
ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                           ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*/
SetPrvt("oDlg1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oSay8","oSay9","oSay10","oSay11")
SetPrvt("oGet2","oGet3","oGet4","oGet5","oGet6","oGet7","oGet8","oGet9","oGet10","oGet11")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

oFont1     := TFont():New( "MS Sans Serif",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )
oDlg2      := MSDialog():New( 186,275,727,909,"oDlg2",,,.F.,,,,,,.T.,,,.F. )
oDlg2:bInit := {||EnchoiceBar(oDlg2,{||OkEnch(lLibMilha)},{||Fecha()},.F.,{{'ALTERA',{|| U_FINC005(cCod,cMatric)},'Despezas'}})}

oSay1      := TSay():New( 029,003,{ || "Bilhete"      } , oDlg2,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
oSay2      := TSay():New( 041,003,{ || "Matricula"    } , oDlg2,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
oSay3      := TSay():New( 052,003,{ || "Trecho"       } , oDlg2,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
oSay4      := TSay():New( 062,003,{ || "Dt.Viagem"    } , oDlg2,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
oSay5      := TSay():New( 017,003,{ || "Codigo"       } , oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay6      := TSay():New( 073,003,{ || "Milhas"       } , oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay7      := TSay():New( 083,003,{ || "Cod.Utilizou" } , oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay8      := TSay():New( 017,141,{ || "Nº.Fatura"    } , oDlg2,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
oSay9      := TSay():New( 032,141,{ || "Companhia"    } , oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay10     := TSay():New( 063,141,{ || "Valor"        } , oDlg2,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
oSay11     := TSay():New( 074,141,{ || "ML.Utilizada" } , oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay12     := TSay():New( 094,003,{ || "Dt.Volta"     } , oDlg2,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
oSay13     := TSay():New( 105,003,{ || "Observação"   } , oDlg2,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
oSay13     := TSay():New( 116,003,{ || "Data Fatura"  } , oDlg2,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)

oGet1      := TGet():New( 016,035,,oDlg2,040,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCod",,)
oGet1:bSetGet := {|u| If(PCount()>0,cCod:=u,cCod)}
oGet1:Disable()

oGet2      := TGet():New( 017,178,,oDlg2,093,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cFatura",,)
oGet2:bSetGet := {|u| If(PCount()>0,cFatura:=u,cFatura)}
iif(lLibMilha,cFatura:=Z62->Z62_FATURA, )

oGet3      := TGet():New( 028,035,,oDlg2,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cBilhete",,)
oGet3:bSetGet := {|u| If(PCount()>0,cBilhete:=u,cBilhete)}
iif(lLibMilha,cBilhete:=Z62->Z62_BILHET, )

oGet4      := TGet():New( 035,178,,oDlg2,093,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cComp",,)
oGet4:bSetGet := {|u| If(PCount()>0,cComp:=u,cComp)}
iif(lLibMilha,cComp:=Z62->Z62_COMP, )
oGet4:Disable()

oGet5      := TGet():New( 040,035,,oDlg2,040,008,'',,CLR_BLACK,iif(lLibMilha,CLR_HGRAY,CLR_WHITE),,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cMatric",,)
oGet5:bSetGet := {|u| If(PCount()>0,cMatric:=u,cMatric)}
oGet5:bValid:={|| U_invalid(cMatric) }
iif(lLibMilha,cMatric:=Z62->Z62_MATRIC, )
iif(lLibMilha,oGet5:Disable(),)

oGet6      := TGet():New( 051,035,,oDlg2,236,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cTrecho",,)
oGet6:bSetGet := {|u| If(PCount()>0,cTrecho:=u,cTrecho)}
iif(lLibMilha,cTrecho:=Z62->Z62_TRECHO, )

oGet7      := TGet():New( 061,035,,oDlg2,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtViag",,)
oGet7:bSetGet := {|u| If(PCount()>0,dDtViag:=u,dDtViag)}
iif(lLibMilha,dDtViag:=Z62->Z62_DTVIAG, )

oGet8      := TGet():New( 062,178,{|u| If(PCount()>0,nValor:=u,nValor)},oDlg2,093,008,'999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nValor",,)
iif(lLibMilha,nValor:=Z62->Z62_VALOR, )

oGet9      := TGet():New( 072,035,{|u| If(PCount()>0,nNewML:=u,nNewML)},oDlg2,040,008,'999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nNewML",,)
iif(lLibMilha,nNewML:=Z62->Z62_MILHAS, )

oGet10     := TGet():New( 074,178,,oDlg2,093,008,'999,999.99',,CLR_BLACK, CLR_HGRAY ,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nMILHAS",,)
oGet10:bSetGet := {|u| If(PCount()>0,nMILHAS:=u,nMILHAS)}

oGet10:Disable()

oGet11:= TGet():New( 082,035,,oDlg2,040,008,'',,CLR_BLACK,CLR_HGRAY,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCODUTI" ,,)
oGet11:bSetGet := {|u| If(PCount()>0,cCODUTI:=u,cCODUTI)}
iif(lLibMilha,cCODUTI:=Z62->Z62_CODUTI, )
oGet11:Disable()

oGet12:= TGet():New( 092,035,,oDlg2,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtViag2",,)
oGet12:bSetGet := {|u| If(PCount()>0,dDtViag2:=u,dDtViag2)}
iif(lLibMilha,dDtViag2:=Z62->Z62_DTVOLT, )

oGet13:= TGet():New( 102,035,,oDlg2,236,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cObs"    ,,)
oGet13:bSetGet := {|u| If(PCount()>0,cObs:=u,cObs)}
iif(lLibMilha,cObs:=Z62->Z62_OBS, )  

oGet14:= TGet():New( 102,035,,oDlg2,236,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDtFat"    ,,)
oGet14:bSetGet := {|u| If(PCount()>0,dDtFat:=u,dDtFat)}
iif(lLibMilha,dDtFat:=Z62->Z62_DTFAT, )  

oDlg2:Activate(,,,.T.)

Return

***************************
Static Function Fecha()
***************************

RollBackSX8()
oDlg2:end()
return

Static Function OkEnch(lLibMilha)
if empty( cCOD     ) .or.;
	empty(cBilhete ) .or.;
	empty(cCOMP    ) .or.;
	empty(cFATURA  ) .or.;
	empty(cMATRIC  ) .or.;
	empty(cTRECHO  ) .or.;
	empty(dDTVIAG  ) .or.;
	empty(dDTVIAG2 )
	
	alert(" Preencha todos o Campos")
	return .F.
endif

if lLibMilha
	RecLock('Z62',.F.)
	Z62->Z62_REMARC := cCod
	Z62->(MsUnlock())
else
		
	TMP2->(DbGotop())
	
	while ! TMP2->(EOF())
		
		if !Empty(TMP2->MARCA)
			
			dbSelectArea("Z62")
			dbSetOrder(1)
			dbSeek(xFilial("Z62")+TMP2->CODIGO)
			RecLock("Z62",.F.)
			Z62->Z62_CODUTI:= cCod
			Z62->(MsUnlock())
		endif
		TMP2->(DbSkip())
	endDo
endif

RecLock("Z62",.T.)
Z62->Z62_FILIAL:= xFilial("Z62")
Z62->Z62_CODIGO:= cCod
Z62->Z62_FATURA:= cFatura
Z62->Z62_BILHET:= cBilhete
Z62->Z62_COMP  := cComp
Z62->Z62_MATRIC:= cMatric
Z62->Z62_TRECHO:= cTrecho
Z62->Z62_DTVIAG:= dDtViag
Z62->Z62_DTVOLT:= dDtViag2
Z62->Z62_VALOR := nValor
Z62->Z62_MILHAS:= nNewML
Z62->Z62_MLUTI := nMilhas
Z62->Z62_CODUTI:= ""
Z62->(MsUnlock())
ConfirmSX8()
oDlg2:end()
if !lLibMilha
	oDlg1:end()
endif
return

*************************
User function FILTROZ7() 
*************************

dbselectarea("SX5")
DBSETORDER(1)
DBSEEK(xFilial("SX5")+"Z7")

return .T.

*******************************
User function invalid(cMatric) 
*******************************

lValid:=iif(U_Func_Nome(cMatric) <> cMatric,.T.,.F.)

iif(lValid,,alert('Matricula Inválida'))

return lValid


*************************
User function Cancelar()  
*************************

DLFC := CHR(13) + CHR(10)
eEmailC := "financeiro@ravaembalagens.com.br;aline.farias@ravaembalagens.com.br"
subjC := "Cancelamento de Viagem"
cMsgC := "A viagem " + Z62->Z62_CODIGO + " Foi cancelada."  + DLFC
cMsgC += "Favor excluir o título " + "000"+Z62->Z62_CODIGO + " no contas a pagar"
cVarT := Z62->Z62_GERAFI


IF (Z62->Z62_DTVIAG < dDatabase .or. Z62->Z62_DTVIAG = dDatabase)
		Alert("Viagem Já Realizada")		
		Return
Endif

If ! U_Senha2("24",1)[1] // apenas a senha de regineide tabela ZY    //voltar
     Return 
endif

RecLock('Z62',.F.)

	Z62->Z62_BLOQ := '5'
	Z62->(MsUnlock())


IF ALLTRIM(cVarT) = "S"
	U_SendFatr11(eEmailC, "", subjC, cMsgC, "" )
	alert("Viagem Cancelada")
ENDIF
	
return

**************************
User function Remarcar()  
**************************

If ! U_Senha2("24",1)[1] // apenas a senha de regineide tabela ZY  //voltar
     Return 
endif

nRecno := Z62->(Recno())
if alltrim(Z62->Z62_CANCEL)!=''
	alert('Essa viagem esta cancelada ,nao é possivel remarcar')
	return
endif

if alltrim(Z62->Z62_REMARC)==''
	cCod:= GetSx8Num( "Z62", "Z62_CODIGO" )
	Cadastrar(cCod,Z62->Z62_MLUTI,.T.)
else
	alert('So é possivel remarcar essa Viagem pelo codigo ( '+alltrim(Z62->Z62_REMARC)+' )')
endif

Z62->(DbGoto(nRecno))

return

/*User function Deletar ()
nRecno  := Z62->(Recno())
cDelete := Z62->Z62_REMARC
cCodigoD:= Z62->Z62_CODIGO

if alltrim(cDelete)!=''
	alert('Não é possivel deletar essa Viagem pois esta associada ao codigo ( '+alltrim(Z62->Z62_REMARC)+' )')
	return
endif

RecLock('Z62',.F.)
Z62->(DbDelete())
Z62->(MsUnlock())

dbselectarea("Z62")
DBSETORDER(2)
DBSEEK(xFilial("Z62")+cCodigoD)
RecLock('Z62',.F.)
Z62->Z62_REMARC:=''
Z62->(MsUnlock())
dbselectarea("Z62")
DBSETORDER(1)
Z62->(DbGoto(nRecno))
return*/

*********************************                    
User function USU_cod2Nome(cCod) 
*********************************

PswOrder(1)
	If PswSeek( cCod, .T. )
		aUsuarios  := PSWRET()
		cCod := Alltrim(aUsuarios[1][2])
	Endif
return cCod

**********************************       
User function Func_Nome(cNomeCod) 
**********************************
 
		PswOrder(1)
		If PswSeek( cNomeCod, .T. )
			aUsuarios  := PSWRET()
			cNomeCod := Alltrim(aUsuarios[1][4])
		Endif
return cNomeCod  

******************************************************************************************************
User Function LegViag()
******************************************************************************************************

BrwLegenda(cCadastro,"Legenda",{	{"BR_VERDE" ,	"Viagem Liberada"},;
									{"BR_AMARELO",	"Pedente Cotação"},;
									{"BR_LARANJA",	"Viagem Bloqueada"},;
									{"BR_PRETO",	"Viagem Cancelada"} 	 } )

Return .T.





**************************
User function fAltera()
**************************

IF Z62->Z62_BLOQ='3'
	alert('Solicitacao de Viagem Bloqueada,Favor solicitar desbloqueio...')
	Return
ENDIF



If ! U_Senha2("24",1)[1]  //voltar
   Return 
endif

AxAltera('Z62',Z62->(RECNO()),4)

Return

***************************
Static Function fnome(mat) 
***************************

Local cNomeMat  := ''
Local cAuxiliar := ''

PswOrder(1)
If PswSeek(mat,.T.)
	aSolic := PswRet()
	cNomeMat := aSolic[1,4]
endif                         

cAuxiliar  := Rtrim(Substr(cNomeMat,1,17))

return cAuxiliar

****************************
User Function fAlimenta()   
****************************                                                                                                      

//acionada via gatilho Z62_CAFE1 , Z62_ALM1 , Z62_JANTA1 (OU SEJA, EM QUALQUER UMA DAS PRIMEIRAS REFEIÇÕES, O GATILHO SERÁ ATIVADO
//X7_REGRA = EXECBLOCK("FALIMENTA")                                                                              
Local nResult := 0

//If M->Z62_CALIME= "S" //SE CALCULA ALIMENTAÇÃO = SIM

	nResult += M->Z62_CAFE1
	nResult += M->Z62_ALM1
	nResult += M->Z62_JANTA1 
	
	nResult += M->Z62_CAFE2
	nResult += M->Z62_ALM2
	nResult += M->Z62_JANTA2
	
	nResult += M->Z62_CAFE3
	nResult += M->Z62_ALM3
	nResult += M->Z62_JANTA3
	
	nResult += M->Z62_CAFE4
	nResult += M->Z62_ALM4
	nResult += M->Z62_JANTA4
	
	nResult += M->Z62_CAFE5
	nResult += M->Z62_ALM5
	nResult += M->Z62_JANTA5
	
	nResult += M->Z62_CAFE6
	nResult += M->Z62_ALM6
	nResult += M->Z62_JANTA6
	
	nResult += M->Z62_CAFE7
	nResult += M->Z62_ALM7
	nResult += M->Z62_JANTA7
//Endif

Return(nResult)

  
**********************************
Static Function fRembDev(cTipo)   
**********************************
//função acionada via gatilho dos campos Z62_REEMB / Z62_DEVOLV
//caso digite um valor no campo Z62_REEMB, SOMA NO CAMPO Z62_VALDES
//caso digite um valor no campo Z62_DEVOLV, SUBTRAI do CAMPO Z62_VALDES

Local nResult := 0
Local nValOri := M->Z62_VALDES // valor original antes do cálculo

If cTipo = "D"   //funcionário devolve pra Rava
	nResult := nValOri - M->Z62_DEVOLV
	If M->Z62_DEVOLV > 0
		Return(nResult)
	Else
		Return(nValOri)
	Endif
Elseif cTipo = "R"  //Rava paga ao funcionário
	nResult := nValOri + M->Z62_REEMB
	If M->Z62_REEMB > 0
		Return(nResult)
	Else
		Return(nValOri)
	Endif
Endif


*************

sTATIC Function FIDAGEN(CID)

*************

Local aArea	    := GetArea()
local lRet:=.T.

if empty(CID)
   return .T.
ENDIF


cQuery :="SELECT  *  FROM "+RetSqlName("ZZE")+" ZZE WHERE ZZE_CODIGO='"+CID+"' AND ZZE.D_E_L_E_T_='' "

If Select("AUXZ") > 0
	DbSelectArea("AUXZ")
	AUXZ->(DbCloseArea())
EndIf
TCQUERY cQuery NEW ALIAS "AUXZ"

AUXZ->(DbGoTop()) 

IF AUXZ->(EOF())    
   
   alert('Esse codigo de Agenda  Nao e Valido: '+ CID  )
   lRet:=.F.

Else

   DbSelectArea("Z62")
   DbSetOrder(5)
   If Z62->(DbSeek(xFilial('Z62')+AUXZ->ZZE_CODIGO ) )
	  alert('Agenda Ja usada na viagem '+Z62->Z62_CODIGO)
	  lRet:=.F.
   Endif


EndIF

AUXZ->(DbCloseArea())

RestArea(aArea)

Return lRet
