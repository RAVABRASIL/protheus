#INCLUDE "protheus.CH"
#INCLUDE "TOPCONN.CH"
#include "TbiConn.ch"
#include "font.ch"
#include "colors.ch"       // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function PONAFS()
  
  oFont01 	:= TFont():New('Verdana'     ,20,20,.F.,.T.,5,.T.,5,.F.,.F.)
  oFont02 	:= TFont():New('Verdana'	 ,12,12,.F.,.T.,5,.T.,5,.F.,.F.)
  oFont03 	:= TFont():New('Verdana'	 ,12,12,.F.,.T.,5,.T.,5,.F.,.F.)
  oFont04 	:= TFont():New('Verdana'     ,15,15,.F.,.T.,5,.T.,5,.F.,.F.)
  oFont05 	:= TFont():New('Verdana'     ,10,10,.F.,.T.,5,.T.,5,.F.,.F.)
  oFont06 	:= TFont():New('Courier New' ,11,11,.F.,.T.,5,.T.,5,.F.,.F.)             
  
  aRotina := {{"Pesquisar"   , "AxPesqui"    , 0, 1},;
			  {"Ocorrências" , "U_DadosAdc()", 0, 2}}
  cCadastro := OemToAnsi("Cadastro de Advertências")              
  mBrowse(06,01,22,75,"SRA")
  /*DEFINE FONT oFont1 NAME "Arial" SIZE 0, 13 BOLD
  CriaArq()
  CriaGrid()
  RIEG->( DbCloseArea() )*/
  //DadosAdc()

Return Nil


***************
Static Function CriaGrid()
***************
                                                        
Local aBOTOES := {}

  aAdd( aBOTOES, { 'S4WB011N', {||  procura() }, "Procurar" } )
//aAdd( aBOTOES, { 'CONTAINR', {|| EncheArq() }, "Atualizar..." } )
//aAdd( aBOTOES, { 'CONTAINR', {|| U_MailPNF() }, "Enviar e-mails..." } )

DEFINE MSDIALOG _oDlg2 TITLE "Planilha de Faltas e Suspensões" FROM 000,000 TO 312,795 PIXEL
dbSelectArea('RIEG')
  oBRW1 := MsSelect():New( "RIEG",,, ;
                        {{ "RA_NOME"    ,,  OemToAnsi( "Nome"                 ) }, ;
                         { "R6_DESC"    ,,  OemToAnsi( "Turno"                ) }, ;
                         { "RA_MAT"     ,,  OemToAnsi( "Matrícula"            ) }, ;
                         { "Z5_ADVERT"  ,,  OemToAnsi( "Qtd. de Advertências" ) }, ;
                         { "Z5_ATRASO"  ,,  OemToAnsi( "Qtd. de Atrasos"      ) }, ;
                         { "Z5_FALTAS"  ,,  OemToAnsi( "Qtd. de Faltas"       ) }, ;
                         { "Z5_SUSPEN"  ,,  OemToAnsi( "Qtd. de Suspensões"   ) };
                        },.F.,, { 013, 000, 155, 397 } )
oBRW1:oBROWSE:SetFont( oFont1 )
oBrw1:oBROWSE:blDblClick    := { || DadosAdc() }
oBRW1:oBROWSE:nCLRFOREFOCUS := CLR_WHITE
RIEG->( DbGoTop() )                                               //Esse bloco é do botão fechar    //Esse bloco é do botão fechar
Activate Dialog _oDLG2 Centered On Init EnchoiceBar( _oDlg2, { || If( _oDlg2:End(), , NIL ), .F. }, { || _oDlg2:End() },, aBOTOES)


Return Nil


***************
Static Function CriaArq()
***************

aESTRUT   := { { "RA_NOME",    "C", 030, 0 }, ;
               { "RA_TELEFON", "C", 012, 0 }, ;
               { "RA_ENDEREC", "C", 080, 0 }, ;
               { "R6_DESC",    "C", 020, 0 }, ;
               { "RA_MAT",     "C", 005, 0 }, ; //trocado de 6 para 5
               { "Z5_ADVERT",  "C", 005, 0 }, ;
               { "Z5_ATRASO",  "C", 005, 0 }, ;
               { "Z5_FALTAS",  "C", 005, 0 }, ;
               { "Z5_SUSPEN",  "C", 005, 0 }}

cARQTMP := CriaTrab( aESTRUT, .T. )
DbUseArea( .T.,, cARQTMP, "RIEG", .F., .F. )
Index On RA_NOME + RA_MAT To &cARQTMP
EncheArq()


Return Nil


***************
Static Function EncheArq()
***************


cQuery := "select  SRA.RA_NOME, SRA.RA_MAT, SRA.RA_TELEFON, SR6.R6_DESC, "
cQuery += "SRA.RA_ENDEREC, SRA.RA_COMPLEM, SRA.RA_BAIRRO, SRA.RA_MUNICIP "
cQuery += "from " + RetSqlName("SRA") + " SRA, " + RetSqlName("SR6") + " SR6 "
//cQuery += "where SRA.RA_TNOTRAB = SR6.R6_TURNO and SRA.RA_INFRACO = '*' and SRA.RA_DEMISSA = ' ' "
cQuery += "where SRA.RA_TNOTRAB = SR6.R6_TURNO and SRA.RA_DEMISSA = ' ' "
cQuery += "and SRA.RA_FILIAL = '" + xFilial("SRA") + "' and SR6.R6_FILIAL = '" + xFilial("SR6") + "' "
cQuery += "and SRA.D_E_L_E_T_ = ' ' and SR6.D_E_L_E_T_ = ' ' "
cQuery += "order by RA_NOME"
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "TMP"
TMP->( DbGoTop() )

RIEG->(  __DbZap() )


while ! TMP->( EoF() )

  RIEG->( DbAppend() )

  RIEG->RA_NOME    :=          TMP->RA_NOME
  RIEG->RA_ENDEREC :=  alltrim(TMP->RA_ENDEREC)  + " " + alltrim(TMP->RA_COMPLEM) + " ";
                     + alltrim(TMP->RA_BAIRRO)   + " " + alltrim(TMP->RA_MUNICIP)
  RIEG->RA_TELEFON :=          TMP->RA_TELEFON
  RIEG->R6_DESC    :=          TMP->R6_DESC
  RIEG->RA_MAT     :=          TMP->RA_MAT

  aArr := ContInfr(TMP->RA_MAT)

  RIEG->Z5_ADVERT := alltrim(str(aArr[1]))
  RIEG->Z5_ATRASO := alltrim(str(aArr[2]))
  RIEG->Z5_FALTAS := alltrim(str(aArr[3]))
  RIEG->Z5_SUSPEN := alltrim(str(aArr[4]))

  aArr := { }
  TMP->( DbSkip() )

EndDo
RIEG->( DbGoTop() )
TMP->( DbCloseArea() )

aArr := { }

Return Nil


***************
Static Function CriaArq_2()
***************

aESTRUT2  := { { "MARCA"    ,  "C", 002, 0 }, ;
               { "Z5_MATRIC",  "C", 006, 0 }, ;
               { "Z5_TIPO"  ,  "C", 011, 0 }, ;
               { "Z5_DATA"  ,  "D", 008, 0 }, ;
               { "Z5_ITEM"  ,  "C", 003, 0 }, ;
               { "Z5_VISTO" ,  "C", 001, 0 }, ;
               { "Z5_OBS"   ,  "C", 100, 0 }  }

cARQTMP2 := CriaTrab( aESTRUT2, .T. )
DbUseArea( .T.,, cARQTMP2, "SZZZ", .F., .F. )
Index On Z5_MATRIC + dtos(Z5_DATA) + Z5_ITEM To &cARQTMP2
EncheArq_2()


Return Nil


**********

Static Function EncheArq_2()

**********

cQuery := "select  * "
cQuery += "from "                + RetSqlName("Z05") + "  "
cQuery += "where Z05_MATRIC = '" + SRA->RA_MAT + "' "
cQuery += "and Z05_FILIAL = '"   + xFilial("Z05") + "' "
cQuery += "and D_E_L_E_T_ = ' ' "
cQuery += "order by Z05_DATA, Z05_MATRIC"
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "TMP"
TMP->( DbGoTop() )

SZZZ->(  __DbZap() )

while ! TMP->( EoF() )

  SZZZ->( DbAppend() )

  SZZZ->Z5_MATRIC   :=      TMP->Z05_MATRIC
  SZZZ->Z5_TIPO     :=      TMP->Z05_TIPO
  SZZZ->Z5_DATA     := stod(TMP->Z05_DATA)
  SZZZ->Z5_ITEM     :=      TMP->Z05_ITEM

  SZZZ->Z5_VISTO    :=      TMP->Z05_VISTO
  IF TMP->Z05_VISTO =       '*'
    SZZZ->MARCA     :=      cMARCA
  ENDIF
  SZZZ->Z5_OBS      :=      TMP->Z05_OBS

  TMP->( DbSkip() )

EndDo

TMP->( DbCloseArea() )

Return Nil




*************
User Function DadosAdc()
*************

// Variaveis Locais da Funcao
Local aBOTOES  := {}
Local cEdit1   := Space( 8)
Local cEdit2   := Space(25)
Local cEdit3   := Space(25)
Local cEdit4   := Space(25)
Local cEdit5   := Space(25)
Local cEdit6   := Space(25)
Local cEdit7   := Space(25)
Local cEdit8   := Space(25)
Local cEdit9   := Space(25)
Local oEdit1
Local oEdit2
Local oEdit3
Local oEdit4
Local oEdit5
Local oEdit6
Local oEdit7
Local oEdit8
Local oEdit9

Private cMARCA
// Variaveis Private da Funcao
Private _oDlg       // Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.

                                                                //177           //547
DEFINE MSDIALOG _oDlg TITLE "Informações do funcionário" FROM C(150),C(184) TO C(570),C(694) PIXEL

  // Cria as Groups do Sistema
  @ C(018),C(006) TO C(095),C(250) LABEL "Informações Gerais :"     PIXEL OF _oDlg
  @ C(100),C(006) TO C(181),C(250) LABEL "Informações Adicionais :" PIXEL OF _oDlg

  // Cria Componentes Padroes do Sistema
  @ C(032),C(014) Say    "Matrícula :"     Size C(027),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
  @ C(032),C(065) Say    "Funcionário :"   Size C(032),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
  //@ C(007),C(023) Button "Button1" Size C(037),C(012) PIXEL OF _oDlg ACTION  _oDlg:End()
  @ C(040),C(012) MsGet  oEdit1 Var cEdit1 Size C(044),C(009) COLOR CLR_BLACK PIXEL OF _oDlg READONLY
  @ C(040),C(063) MsGet  oEdit2 Var cEdit2 Size C(182),C(009) COLOR CLR_BLACK PIXEL OF _oDlg READONLY
  @ C(050),C(014) Say    "Turno :"         Size C(019),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
  @ C(050),C(065) Say    "Endereço:"       Size C(026),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
  @ C(059),C(012) MsGet  oEdit3 Var cEdit3 Size C(043),C(009) COLOR CLR_BLACK PIXEL OF _oDlg READONLY
  @ C(059),C(063) MsGet  oEdit4 Var cEdit4 Size C(182),C(009) COLOR CLR_BLACK PIXEL OF _oDlg READONLY
  @ C(069),C(014) Say    "Telefone :"      Size C(026),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
  @ C(077),C(012) MsGet  oEdit5 Var cEdit5 Size C(044),C(009) COLOR CLR_BLACK PIXEL OF _oDlg READONLY
  @ C(190),C(053) Button "Incluir"         Size C(037),C(012)                 PIXEL OF _oDlg ACTION  IncluiOcor(1)
  @ C(190),C(105) Button "Sair"            Size C(037),C(012)                 PIXEL OF _oDlg ACTION  _oDlg:End()
  @ C(190),C(157) Button "Deletar"         Size C(037),C(012)                 PIXEL OF _oDlg ACTION  editar(" ", 4)

  CriaArq_2()
  dbSelectArea('SZZZ')
  cMARCA := GetMark()

  oBRW2 := MsSelect():New(   "SZZZ","MARCA",, ;
                          {{ "MARCA"   ,, " " }, ;
                           { "Z5_TIPO" ,,    OemToAnsi( "Tipo de Infração" ) }, ;
                           { "Z5_DATA" ,,    OemToAnsi( "Data da Infração" ) }, ;
                           { "Z5_OBS"  ,,    OemToAnsi( "Observações"      ) }},, ;
                           cMarca, { c(106), c(010), c(178), c(245) } )
													 		//cMarca, { 106, 010, 178, 245 } ) 29/05
															//cMarca, { C(120), C(010), C(205), C(280) } )
                              //cMarca, { 106, 010, 178, 245 } )// ** **, tamanho na vertical, tamanho horizontal

  //oBRW2:oBROWSE:SetFont( oFont1 )

  oBRW2:oBROWSE:lhasMark    := .F.
  oBRW2:oBROWSE:lCanAllmark := .F.

  oBrw2:oBROWSE:blDblClick := { || IncluiOcor(2) }
  oBRW2:oBROWSE:nCLRFOREFOCUS := CLR_WHITE
  SZZZ->( DbGoTop() )

  cEdit1 := SRA->RA_MAT
  cEdit2 := SRA->RA_NOME
  //cEdit3 := RIEG->R6_DESC
  cEdit4 := SRA->RA_ENDEREC
  cEdit5 := SRA->RA_TELEFON                    //editar(dEdit2, cComboBx1, cEdit1, 1)
  ObjectMethod( oEdit1, "Refresh()" )
  ObjectMethod( oEdit2, "Refresh()" )
  ObjectMethod( oEdit3, "Refresh()" )
  ObjectMethod( oEdit4, "Refresh()" )

aAdd( aBOTOES, { 'S4WB007N', {|| Relato(alltrim(SZZZ->Z5_TIPO)) }, "Relatório..." } )



//ACTIVATE MSDIALOG _oDlg CENTERED On Init EnchoiceBar( _oDlg, { || if(alltrim(PSWRet()[1][2]) == 'Waldir', editar(" ", 2), IW_MsgBox( "Você não pode confirmar advertências!" ) ), .F.}, { || if(alltrim(PSWRet()[1][2]) == 'Waldir', editar(" ", 3), IW_MsgBox( "Você não pode cancelar advertências!" ) ), .F.}, , aBOTOES )
//ACTIVATE MSDIALOG _oDlg CENTERED On Init EnchoiceBar( _oDlg, { || If( )editar(date()," "," ", 2), NIL), .F. }, { || _oDlg:End() },, aBOTOES )
ACTIVATE MSDIALOG _oDlg CENTERED On Init EnchoiceBar( _oDlg, { || _oDlg:End() },, aBOTOES )

SZZZ->( DbCloseArea() )


Return(.T.)



**********

Static Function ContInfr(cMatric)

**********

aCont := {0,0,0,0}
cQUery := "select Z05_TIPO, count(*) total from " + RetSqlName("Z05") + " "
cQuery += "where Z05_MATRIC = '" + cMatric + "' "
cQuery += "and Z05_FILIAL = '" + xFilial("Z05") + "' "
cQuery += "and D_E_L_E_T_ = ' ' "
cQuery += "group by Z05_TIPO"
cQuery := ChangeQuery(cQuery)
TcQuery cQuery NEW ALIAS "TMP2"
TMP2->( DbGoTop() )


IF TMP2->( EoF() )

  aCont := {0,0,0,0}

ELSE

  while ! TMP2->( EoF() )

    DO CASE

      CASE alltrim(TMP2->Z05_TIPO) == 'Advertência'

        aCont[1] := TMP2->total
        TMP2->( DbSKip() )

      CASE alltrim(TMP2->Z05_TIPO) == 'Atraso'

        aCont[2] := TMP2->total
        TMP2->( DbSKip() )

      CASE alltrim(TMP2->Z05_TIPO) == 'Falta'

        aCont[3] := TMP2->total
        TMP2->( DbSKip() )

      CASE alltrim(TMP2->Z05_TIPO) == 'Suspensão'

        aCont[4] := TMP2->total
        TMP2->( DbSKip() )

    EndCase

  EndDo

ENDIF

TMP2->( DbCloseArea() )

Return aCont


**********

Static Function IncluiOcor(nOpc)

**********

// Variaveis Locais da Funcao
Local cEdit1     := Space(200)
Local dEdit2     := ctod(Space(8)) := dDataBase
Local cEdit3     := Space(11)
Local aComboBx1  := {"Advertência","Atraso","Falta","Suspensão","Mud.horario","Apon.cartao"}
Local cComboBx1
Local oEdit1
Local oEdit2
Local oEdit3
Local oCox
// Variaveis Private da Funcao
Private _oDlg4       // Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.

DEFINE MSDIALOG _oDlg4 TITLE "Formulário de Ocorrências" FROM C(181),C(200) TO C(433),C(632) PIXEL

  // Cria as Groups do Sistema
  @ C(002),C(005) TO C(125),C(214) LABEL " Adicionar Ocorrência " PIXEL OF _oDlg4

  // Cria Componentes Padroes do Sistema
  @ C(019),C(108)   Say "Tipo de infração :"   Size C(043),C(008) COLOR CLR_BLACK PIXEL OF _oDlg4
  @ C(020),C(012)   Say "Data da ocorrência :" Size C(050),C(008) COLOR CLR_BLACK PIXEL OF _oDlg4
  //@ C(030),C(019) MsGet oEdit2 Var dEdit2 Size C(031),C(009) COLOR CLR_BLACK PIXEL OF _oDlg4
  //@ C(029),C(108) ComboBox oCox Var cComboBx1 Items aComboBx1 Size C(072),C(010)  PIXEL OF _oDlg4
  @ C(050),C(010)   Say "Observações :"        Size C(036),C(008) COLOR CLR_BLACK PIXEL OF _oDlg4
  //@ C(059),C(009) MsGet oEdit1 Var cEdit1 Size C(199),C(043) COLOR CLR_BLACK PIXEL OF _oDlg4
  @ C(059),C(009)   Get oEdit1 Var cEdit1 MEMO Size C(199),C(043) COLOR CLR_BLACK PIXEL OF _oDlg4

 //@ C(107),C(065) Button "Confirmar" Size C(037),C(012) PIXEL OF _oDlg4 ACTION  grava(dEdit2, cComboBx1, cEdit1)
  @ C(107),C(117)   Button "Cancelar"          Size C(037),C(012)                 PIXEL OF _oDlg4 ACTION  _oDlg4:End()

  IF nOpc == 2 .and. SZZZ->( !EoF() )
    @ C(029),C(108) MsGet oEdit3 Var cEdit3    Size C(035),C(010)                 PIXEL OF _oDlg4 READONLY
    @ C(107),C(065) Button "Confirmar"         Size C(037),C(012)                 PIXEL OF _oDlg4 ACTION editar(cEdit1, 1)
    @ C(030),C(019) MsGet oEdit2 Var dEdit2    Size C(031),C(009) COLOR CLR_BLACK PIXEL OF _oDlg4 READONLY

    cEdit1    := SZZZ->Z5_OBS
    ObjectMethod( oEdit1, "Refresh()" )
    dEdit2    := SZZZ->Z5_DATA
    ObjectMethod( oEdit2, "Refresh()" )
    cEdit3    := SZZZ->Z5_TIPO
    ObjectMethod( oEdit3, "Refresh()" )

  Else
    @ C(029),C(108) ComboBox oCox Var cComboBx1 Items aComboBx1 Size C(072),C(010)                 PIXEL OF _oDlg4
    @ C(107),C(065) Button "Confirmar"                          Size C(037),C(012)                 PIXEL OF _oDlg4 ACTION  grava(dEdit2, cComboBx1, cEdit1)
    @ C(030),C(019) MsGet oEdit2  Var dEdit2                    Size C(031),C(009) COLOR CLR_BLACK PIXEL OF _oDlg4

  EndIf

ACTIVATE MSDIALOG _oDlg4 CENTERED


Return(.T.)


**********

Static Function grava(dEdit, cComboBx, cEdit)

**********

  aCount :={0,0,0,0}
  nTotal := 0
  cQuery := "select count(*) as quant, Z05_TIPO from " + retsqlname("Z05") + " where Z05_DATA = '" + dtos(dEdit) + "' "
  cQuery += "and Z05_MATRIC = '" + SRA->RA_MAT + "' "
  cQuery += "and Z05_FILIAL = '" + xfilial("Z05") + "' "
  cQuery += "and D_E_L_E_T_ = ' ' "
  cQuery += "group by Z05_DATA, Z05_TIPO"
  cQuery := ChangeQuery( cQuery )
  TCQUERY cQuery NEW ALIAS "ZZZ"
  ZZZ->( DbGoTop() )
  DbSelectArea("Z05")

  while ! ZZZ->( EoF() )

    DO CASE
      CASE alltrim(ZZZ->Z05_TIPO) == 'Advertência'
        nTotal += aCount[1] := ZZZ->quant
      CASE alltrim(ZZZ->Z05_TIPO) == 'Atraso'
        nTotal += aCount[2] := ZZZ->quant
      CASE alltrim(ZZZ->Z05_TIPO) == 'Falta'
        nTotal += aCount[3] := ZZZ->quant
      CASE alltrim(ZZZ->Z05_TIPO) == 'Suspensão'
        nTotal += aCount[4] := ZZZ->quant
    ENDCASE

    ZZZ->( DbSkip() )

  EndDo

  ZZZ->( DbGoTop() )

  IF ZZZ->( EoF() ) .AND. ( dtos(dEdit) != '        ' )

    Z05->( DbAppend() )
    Z05->( RecLock("Z05", .F.) )//tentei a atribuiçao direta, mas deu pau
    Z05->Z05_MATRIC := alltrim(SRA->RA_MAT)
    Z05->Z05_DATA   := dEdit
    Z05->Z05_TIPO   := alltrim(cComboBx)
    Z05->Z05_ITEM   := str(1,1,0)
    Z05->Z05_OBS    := alltrim(cEdit)
    Z05->( MsUnlock() )

    SZZZ->( DbAppend() ) //tentei a atribuiçao direta, mas deu pau
    SZZZ->Z5_MATRIC := alltrim(SRA->RA_MAT)
    SZZZ->Z5_TIPO   := alltrim(cComboBx)
    SZZZ->Z5_DATA   := dEdit
    SZZZ->Z5_ITEM   := str(1,1,0)
    SZZZ->Z5_OBS    := alltrim(cEdit)
	EnviaMail( 1 )
  ELSEIF ((( aCount[2] < 2 ) .AND. ( aCount[3] < 2 ) .AND. ( aCount[4] < 1 ) .AND. ((aCount[2] + aCount[3]) < 2));
         .OR. (cComboBx == 'Advertência')) .AND. ( dtos(dEdit) != '        ' )

    Z05->( DbAppend() )
    Z05->( RecLock("Z05", .F.) )
    Z05->Z05_MATRIC :=  alltrim(SRA->RA_MAT)
    Z05->Z05_DATA   :=  dEdit
    Z05->Z05_TIPO   :=  alltrim(cComboBx)
    Z05->Z05_ITEM   :=  str(nTotal + 1,1,0)
    Z05->Z05_OBS    :=  alltrim(cEdit)
    Z05->( MsUnlock() )

    SZZZ->( DbAppend() )
    SZZZ->Z5_MATRIC := alltrim(SRA->RA_MAT)
    SZZZ->Z5_TIPO   := alltrim(cComboBx)
    SZZZ->Z5_DATA   := dEdit
    SZZZ->Z5_ITEM   := str(nTotal + 1,1,0)
    SZZZ->Z5_OBS    := alltrim(cEdit)
	EnviaMail( 1 )
  ELSEIF ( aCount[2] == 2 ) .OR. ( aCount[3] == 2 ) .OR. ( aCount[4] == 1 ) // falta + atraso?
         //mais de um atraso     //mais de uma falta     //uma suspensão
    IW_MsgBox( "Esse funcionário já execedeu o nº de infrações por um dia!" )

  ELSE

    IW_MsgBox( "Já existe uma ocorrência cadastrada para esse funcionário nesta data ou ele já execedeu o nº de infrações por um dia!" )

  ENDIF

  Z05->( DbCloseArea() )
  ZZZ->( DbCloseArea() )
  _oDlg4:End()

Return Nil


***************
Static Function editar(cObs, nCase)
***************

  DO CASE

  CASE nCase == 1

    DbSelectArea("Z05")
    Z05->( DbSetOrder(1) )
    Z05->( DbSeek( xFilial( "Z05" ) + SZZZ->Z5_MATRIC + dtos(SZZZ->Z5_DATA) + SZZZ->Z5_ITEM, .T. ) )

    Z05->( RecLock("Z05", .F.) )
    Z05->Z05_DATA   := SZZZ->Z5_DATA
    //Z05->Z05_TIPO   := allTrim(cInfrac)
    Z05->Z05_OBS    := allTrim(cObs)
    Z05->( MsUnlock() )
    Z05->( DbCloseArea() )

    SZZZ->Z5_OBS  := allTrim(cObs)
		dbSelectArea("SZZZ")
    _oDlg4:End()

  CASE nCase == 2

    cData := dtos(SZZZ->Z5_DATA)
    DbSelectArea("Z05")
    Z05->( DbSetOrder(1) )
    Z05->( DbSeek( xFilial( "Z05" ) + SZZZ->Z5_MATRIC + cData + SZZZ->Z5_ITEM, .T. ) )

    Z05->( RecLock("Z05", .F.) )
    Z05->Z05_VISTO = '*'
    Z05->( MsUnlock() )
    Z05->( DbCloseArea() )
    EnviaMail( 2 )
    SZZZ->MARCA := cMARCA
    IW_MsgBox("Visto realizado!" )
    
  CASE nCase == 3

    cData := dtos(SZZZ->Z5_DATA)
    DbSelectArea("Z05")
    Z05->( DbSetOrder(1) )
    Z05->( DbSeek(xFilial("Z05") + SZZZ->Z5_MATRIC + cData + SZZZ->Z5_ITEM, .T.) )

    Z05->( RecLock("Z05", .F.) )
    Z05->Z05_VISTO = ' '
    Z05->( MsUnlock() )
    Z05->( DbCloseArea() )

    SZZZ->MARCA := ' '
    IW_MsgBox("Visto removido!" )

  CASE nCase == 4

    cData := dtos(SZZZ->Z5_DATA)
    DbSelectArea("Z05")
    Z05->( DbSetOrder(1) )

    if Z05->( DbSeek(xFilial("Z05") + SZZZ->Z5_MATRIC + cData + SZZZ->Z5_ITEM, .T.) )

      if Z05->Z05_VISTO = ' '
        Z05->( RecLock("Z05", .F.) )
        Z05->( DbDelete() )
        Z05->( MsUnlock() )
        EncheArq_2()
        SZZZ->( DbGoTop() )
      else
        IW_MsgBox("Não é permitido excluir registros que já tenham sido checados pelo setor de RH!" )
      endif

    endif

    Z05->( DbCloseArea() )

  ENDCASE

Return  Nil


***************
Static Function AdcFunc()
***************

// Variaveis Locais da Funcao
Private cEdit1   := Space(5)
Private cEdit2   := Space(25)
Private cEdit3   := Space(50)
Private oEdit1
Private oEdit2
Private oEdit3

// Variaveis Private da Funcao
Private _oDlg5       // Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.
aRet := ARRAY(3)
DEFINE MSDIALOG _oDlg5 TITLE "Incluir Funcionário" FROM C(178),C(181) TO C(323),C(563) PIXEL

  // Cria as Groups do Sistema
  @ C(002),C(003) TO C(072),C(190) LABEL "" PIXEL OF _oDlg5

  // Cria Componentes Padroes do Sistema
  @ C(009),C(026) Say "Matrícula :"           Size C(052),C(008) COLOR CLR_BLACK PIXEL OF _oDlg5
  @ C(009),C(099) Say "Turno :"               Size C(019),C(008) COLOR CLR_BLACK PIXEL OF _oDlg5
  @ C(020),C(025) MsGet oEdit1 Var cEdit1     Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg5 READONLY //ON CHANGE aRet := Search(cEdit1)
  @ C(020),C(098) MsGet oEdit3 Var cEdit3     Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg5 READONLY
  @ C(030),C(026) Say "Nome do colaborador :" Size C(070),C(008) COLOR CLR_BLACK PIXEL OF _oDlg5
  @ C(041),C(024) MsGet oEdit2 Var cEdit2     Size C(136),C(009) COLOR CLR_BLACK PIXEL OF _oDlg5 READONLY
  @ C(056),C(052) Button "Inclui"             Size C(037),C(012)                 PIXEL OF _oDlg5 ACTION Ficha(cEdit1, cEdit2)//Ficha(aRet[2], aRet[1])
  @ C(056),C(099) Button "Cancela"            Size C(037),C(012)                 PIXEL OF _oDlg5 ACTION _oDlg5:END()
  @ C(019),C(083) Button "..."                Size C(010),C(012)                 PIXEL OF _oDlg5 ACTION BuscaFun()
ACTIVATE MSDIALOG _oDlg5 CENTERED
//BuscaFun()
  Return(.T.)


***************
Static Function Search(cPar)
***************

lFound := .F.
aDados := ARRAY(3)
cQuery := "select  SRA.RA_NOME, SRA.RA_MAT, SR6.R6_DESC "
cQuery += "from " + RetSqlName("SRA") + " SRA, " + RetSqlName("SR6") + " SR6 "
cQuery += "where SRA.RA_TNOTRAB = SR6.R6_TURNO and SRA.RA_MAT = '" + alltrim(cPar) + "'  and SRA.RA_DEMISSA = ' ' "
cQuery += "and SRA.RA_FILIAL = '" + xFilial("SRA") + "' and SR6.R6_FILIAL = '" + xFilial("SR6") + "' "
cQuery += "and SRA.D_E_L_E_T_ = ' ' and SR6.D_E_L_E_T_ = ' ' "
cQuery += "order by RA_NOME"
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "TMP"
TMP->( DbGoTop() )

while ! TMP->( EoF() )

  aDados[1] := alltrim(TMP->RA_NOME)
  aDados[2] := alltrim(TMP->RA_MAT )
  aDados[3] := alltrim(TMP->R6_DESC)
  lFound := .T.
  TMP->( DbSkip() )

EndDo

TMP->( DbCloseArea() )

if(lFound)

  if ( ( 30 - len(aDados[1] )) == 30 )
    cEdit3 := aDADOS[3]
    cEdit2 := aDADOS[1]
  else
    cEdit3 := aDADOS[3]
    cEdit2 := aDADOS[1]
    aDADOS[1] += Space( 30 - len(aDados[1]) )
  endif

else

  cEdit3 := Space(50)
  cEdit2 := Space(25)
  cEdit1 := Space(5)
  IW_MsgBox("Matrícula Inválida!" )

endif

Return aDados


**********

Static Function Ficha(cMat, cNome)

**********

if(cMat != " ")

  DbSelectArea("SRA")
  SRA->( DbSetOrder(1) )
  SRA->( DbSeek( xFilial( "SRA" ) + cMat, .T. ) )
  SRA->( RecLock("SRA", .F.) )
  SRA->RA_INFRACO := "*"
  SRA->( MsUnlock() )
  SRA->( DbCloseArea() )

  EncheArq()

  RIEG->( DbSeek(cNome + cMat), .T. )

  _oDlg5:END()
  DadosAdc()

else

  IW_MsgBox("Matrícula Inválida!" )

endif


Return Nil


**********

Static Function Relato(cOpc)

**********

Private cEdit1   := Space(99)
Private dEdit2   := ctod(Space(8)) := dDataBase
Private dEdit3   := ctod(Space(8))
Private cEdit4   := Space(30)
Private cEdit5   := Space(30)
Private oEdit1
Private oEdit2
Private oEdit3
Private oEdit4
Private oEdit5

// Variaveis Private da Funcao
Private _oDlg7       // Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.

//DEFINE MSDIALOG _oDlg7 TITLE "Relatório" FROM C(178),C(181) TO C(362),C(463) PIXEL 30/05/08 ORIGINAL
											// LEFT    TOP     BOTTOM      RIGHT
DEFINE MSDIALOG _oDlg7 TITLE "Relatório" FROM C(178),C(181) TO C(420),C(463) PIXEL

  // Cria as Groups do Sistema
  //@ C(000),C(002) TO C(093),C(141) LABEL "" PIXEL OF _oDlg7 30/05/08 ORIGINAL
  @ C(000),C(002) TO C(120),C(141) LABEL "" PIXEL OF _oDlg7
	
  // Cria Componentes Padroes do Sistema
  @ C(007),C(014) Say "Data de emissão :"      Size C(044),C(008) COLOR CLR_BLACK PIXEL OF _oDlg7
  @ C(007),C(075) MsGet oEdit2 Var dEdit2      Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg7

IF cOpc == 'Suspensão'
  @ C(021),C(014) Say "Data de volta :"        Size C(037),C(008) COLOR CLR_BLACK PIXEL OF _oDlg7
  @ C(021),C(075) MsGet oEdit3 Var dEdit3      Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg7
ENDIF

  @ C(035),C(005) Get oEdit1   Var cEdit1 MEMO Size C(130),C(047) COLOR CLR_BLACK PIXEL OF _oDlg7
  @ C(085),C(005) Say "Responsável"            Size C(037),C(008) COLOR CLR_BLACK PIXEL OF _oDlg7
  @ C(095),C(005) Get oEdit4   Var cEdit4      Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg7
  @ C(085),C(075) Say "Cargo"                  Size C(037),C(008) COLOR CLR_BLACK PIXEL OF _oDlg7  
  @ C(095),C(075) Get oEdit5   Var cEdit5      Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg7
  //076
  @ C(107),C(027) Button "Gerar"               Size C(037),C(012)                 PIXEL OF _oDlg7 ACTION Relato4(cEdit1, dEdit2, dEdit3, cOpc, cEdit4, cEdit5)
  @ C(107),C(079) Button "Cancelar"            Size C(037),C(012)                 PIXEL OF _oDlg7 ACTION _oDLg7:END()

ACTIVATE MSDIALOG _oDlg7 CENTERED

Return Nil

***************

Static Function Relato4(cMemo, dData1, dData2, cOpt, cNome, cCargo)

***************
Local aTemp := {}
Local nCol  := 170
Local nLin  := 190
oPrt := TMSPrinter():new(cOpt + "ao Funcionário")
oPrt:SetPortrait()
oPrt:StartPage()
if cOpt == "Suspensão"
	oPrt:Say( 190, nCol + 400, "SUSPENSÃO A FUNCIONÁRIO", oFont01, 300, , , 3 )
	oPrt:Say( 350, nCol, "Empresa:     RAVA EMBALAGENS INDÚSTRIA E COMÉRCIO LTDA.", oFont02, 300, , , 0 )
	oPrt:Say( 490, nCol, "Funcionário: "+SRA->RA_NOME, oFont02, 300, , , 0 )
	oPrt:Say( 590, nCol, "Pelo presente notificamos que a partir do dia "+alltrim(str(day(dEdit2))) + " de " + MesExtenso(month(dEdit2)) +;
	                   " de " + alltrim(str(year(dEdit2)))+" que Vossa Senhoria ", oFont02, 300, , , 0 )
	//oPrt:Say( 280, nCol, " que Vossa Senhoria está está suspenso de suas funções pelo prazo XXX dia(s), sem remuneração,", oFont02, 300, , , 0 )
	oPrt:Say( 630, nCol, "está suspenso de suas funções pelo prazo "+transform(dData2 - dData1,"@E 999")+" dia(s), sem remuneração, pelas faltas ", oFont02, 300, , , 0 )
	oPrt:Say( 670, nCol, "discriminadas a seguir:", oFont02, 300, , , 0 )
	iif( !empty(cMemo), aTemp := wordWrap( cMemo, 92 ), aAdd( aTemp, {"SEM INFORMAÇÕES"} ) )
	nLin := 870
	for z := 1 to len( aTemp )
		if nLin >= 2250
			nLin := 100
			oPrt:EndPage()
			oPrt:StartPage()
		endIf
		oPrt:Say( nLin,  nCol, aTemp[z][1], oFont06, 300, , , 0 )
		nLin += 40
	next
	oPrt:Say( nLin += 100 , nCol, "Apresente-se novamente ao serviço, no horário usual, somente no dia "+  alltrim(str(day(dEdit3))) + " de " +;
	 				           MesExtenso(month(dEdit3)), oFont02, 300, , , 0 )
	oPrt:Say( nLin += 40  , nCol, "de " + alltrim(str(year(dEdit3)))+". A reincidência no serviço do ato cometido poderá acarretar-lhe dispensa por", oFont02, 300, , , 0 )
	oPrt:Say( nLin += 40  , nCol, " JUSTA CAUSA, o que será considerado FALTA GRAVE.", oFont02, 300, , , 0 )
	oPrt:Line(nLin += 300 ,  850, nLin, 1500, )
	oPrt:Say( nLin +  40  , 1225, upper(cNome), oFont02,  300, , , 2 )
	oPrt:Say( nLin +  80  , 1225, upper(cCargo), oFont02, 300, , , 2 )
	oPrt:Say( nLin += 300 , nCol,"Cabedelo-PB, "+  alltrim(str(day(dDataBase))) + " de " +;
	 				           MesExtenso(month(dDataBase)) +" de " + alltrim(str(year(dDataBase))), oFont02, 300, , , 0 )
	oPrt:Say( nLin += 200 ,nCol , "Empregado  :________________________________________ Data: ____/____/____   ", oFont02, 300, , , 0 ) 				           
	oPrt:Say( nLin += 200 ,nCol , "Responsável:________________________________________ (caso de menor de idade)", oFont02, 300, , , 0 ) 				           
else
	oPrt:Say( 190, nCol + 400, "ADVERTÊNCIA DISCIPLINAR", oFont01, 300, , , 3 )
	oPrt:Say( 490, nCol, "A(o) Sr(a). "+SRA->RA_NOME, oFont02, 300, , , 0 )
	oPrt:Say( 590, nCol, "Pelo presente o ADVERTIMOS, em razão das faltas abaixo discriminadas:", oFont02, 300, , , 0 )
	iif( !empty(cMemo), aTemp := wordWrap( cMemo, 90 ), aAdd( aTemp, {"SEM INFORMAÇÕES"} ) )
	nLin := 790
	for z := 1 to len( aTemp )
		if nLin >= 2250
			nLin := 100
			oPrt:EndPage()
			oPrt:StartPage()
		endIf
		oPrt:Say( nLin,  nCol, aTemp[z][1], oFont06, 300, , , 0 )
		nLin += 40
	next
	oPrt:Say( nLin += 100, nCol, "Pedimos à Vossa Senhoria que não cometa mais faltas, para que não seja necessária "     , oFont02, 300, , , 0 )
	oPrt:Say( nLin += 40 , nCol, "a realização de medidas cabíveis no sentido de afastá-lo ou suspendê-lo em função "     , oFont02, 300, , , 0 )
	oPrt:Say( nLin += 40 , nCol, "de tais atitudes. Esperamos que Vossa Senhoria procure evitar a reincidência para "     , oFont02, 300, , , 0 )
    oPrt:Say( nLin += 40 , nCol, "que não tenhamos, no futuro, tomar as enérgicas medidas que nos são facultadas por lei.", oFont02, 300, , , 0 )
	
	oPrt:Line(nLin += 300,450, nLin, 1100, )
	oPrt:Say( nLin +  40 , 825, SRA->RA_NOME, oFont02,  300, , , 2 )
	oPrt:Say( nLin +  80 , 825, posicione('SRJ',1,xFilial("SRJ") + SRA->RA_CODFUNC,"RJ_DESC" ), oFont02, 300, , , 2 )
	
	oPrt:Line(nLin , 1250, nLin, 1900, )
	oPrt:Say( nLin +  40, 1625, upper(cNome) , oFont02,  300, , , 2 )
	oPrt:Say( nLin +  80, 1625, upper(cCargo), oFont02, 300 , , , 2 )
	
	oPrt:Say( nLin += 300 , nCol,"Cabedelo-PB, "+  alltrim(str(day(dDataBase))) + " de " +;
	 				           MesExtenso(month(dDataBase)) +" de " + alltrim(str(year(dDataBase))), oFont02, 300, , , 0 )
	oPrt:Say( nLin += 200,nCol, "Ciente em: ____/____/____   ", oFont02, 300, , , 0 ) 				           
endIf	
oPrt:EndPage()	
oPrt:Preview()

return


***************
Static Function Relato2(cEdit1, dEdit2, dEdit3, cOpc)
***************

//if(alltrim(PSWRet()[1][2]) == 'Waldir')

  aSTRUT := {{"CHAVE"  , "C", 01, 0},;
             {"NOME"   , "C", 30, 0},;
             {"DATAE"  , "C", 21, 0},;
             {"DATAENT", "C", 21, 0},;
             {"MEMO"   , "C", 99, 0}}

  cArq := criatrab(aSTRUT, .T.)
  DbUseArea( .T.,, cArq, "ARQ", .F., .F. )
  Index On CHAVE + NOME To &cArq

  ARQ->( DbAppend() )

  ARQ->CHAVE   := " "
  ARQ->NOME    := ";NOME"
  ARQ->DATAE   := ";DATAE"
  ARQ->DATAENT := ";DATAENT"
  ARQ->MEMO    := ";MEMO"

  ARQ->( DbCommit() )
  ARQ->( DbAppend() )

  ARQ->CHAVE   := "*"
  ARQ->NOME    := ";"    +RIEG->RA_NOME
  ARQ->DATAE   := ";"    +  alltrim(str(day(dEdit2))) + " de " + MesExtenso(month(dEdit2)) +;
                  " de " + alltrim(str(year(dEdit2)))

  ARQ->DATAENT := ";"    +  alltrim(str(day(dEdit3))) + " de " + MesExtenso(month(dEdit3)) +;
                  " de " + alltrim(str(year(dEdit3)))

  ARQ->MEMO    := ";"    + alltrim(cEdit1)

  ARQ->( DbCommit() )

  DbSelectArea("ARQ")
  cArq := "relato.txt"
  aFields := {"NOME", "DATA"}
  cPATH := "C:\" + cArq
  Copy Fields CHAVE, NOME, DATAE, DATAENT, MEMO To ( cPATH ) SDF
  ARQ->( DBCloseArea() )

  If Empty( Directory( "C:\" + cARQ, "D" ) )
    Alert("Caminho ou arquivo '" + cARQ + "' nao encontrado. Impossivel abrir o Word. Usuario sem acesso.")
  Else
    IF cOpc = 'Suspensão'
      ShellExecute( 'open', 'C:\RELSUSP.doc','','', 1 ) //shownormal
    ELSE
      ShellExecute( 'open', 'C:\RELADV.doc','','', 1 ) //shownormal
    ENDIF
  EndIf
  _oDLg7:END()
//Else
//  IW_MsgBox("Você não pode gerar relatórios de advertências!")
//Endif

Return Nil


***************
Static Function BuscaFun()
***************

// Variaveis Locais da Funcao
Local cEdit12   := Space(10)
Local oEdit12
Local oBRW1
Local cARQTMP
Local aESTRUT
// Variaveis Private da Funcao
Private _oDlg9       // Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.

DEFINE MSDIALOG _oDlg9 TITLE "Busca de Funcionários" FROM C(178),C(181) TO C(394),C(562) PIXEL

cQuery := "select  SRA.RA_NOME, SRA.RA_MAT, SR6.R6_DESC "
cQuery += "from " + RetSqlName("SRA") + " SRA, " + RetSqlName("SR6") + " SR6 "
cQuery += "where SRA.RA_TNOTRAB = SR6.R6_TURNO and SRA.RA_DEMISSA = ' ' "
cQuery += "and SRA.RA_FILIAL = '" + xFilial("SRA") + "' and SR6.R6_FILIAL = '" + xFilial("SR6") + "' "
cQuery += "and SRA.D_E_L_E_T_ = ' ' and SR6.D_E_L_E_T_ = ' ' "
cQuery += "order by RA_NOME"
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "XXX"
XXX->( DbGoTop() )

cARQTMP := CriaTrab( , .F. )
COPY TO ( cARQTMP )
XXX->( DbCloseArea() )
DbUseArea( .T., , cARQTMP, "XXX", .F., .F. )
Index On RA_NOME + RA_MAT to &cARQTMP

oBRW1 := MsSelect():New(   "XXX",,, ;
                        {{ "RA_MAT"     ,,  OemToAnsi( "Matrícula") }, ;
                         { "RA_NOME"    ,,  OemToAnsi( "Nome") }, ;
                         { "R6_DESC"    ,,  OemToAnsi( "Turno") }}, ;
                           .F.,, { 005, 006, 090, 152 } )
oBRW1:oBROWSE:SetFont( oFont1 )
oBrw1:oBROWSE:blDblClick := { || cEdit1 := alltrim(XXX->RA_MAT), cEdit2 := XXX->RA_NOME, cEdit3 := XXX->R6_DESC, _oDlg9:End() }
oBRW1:oBROWSE:nCLRFOREFOCUS := CLR_WHITE

  // Cria as Groups do Sistema
  @ C(001),C(004) TO C(108),C(190) LABEL "" PIXEL OF _oDlg9

  // Cria Componentes Padroes do Sistema
  //@ C(081),C(016) Say "Busca pelo nome :" Size C(046),C(008) COLOR CLR_BLACK PIXEL OF _oDlg9
  @ C(093),C(085) Say "<< Busca pelo nome"  Size C(065),C(008) COLOR CLR_BLACK PIXEL OF _oDlg9
  @ C(093),C(016) MsGet oEdit12 Var cEdit12 Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg9 ON CHANGE { ctest := upper(alltrim(cEdit12)) ,XXX->( DbSeek( ctest ,.T.) ), oBRW1:oBrowse:Refresh() }
  DEFINE SBUTTON FROM C(027),C(156) TYPE 1 ENABLE OF _oDlg9 ACTION { || cEdit1 := alltrim(XXX->RA_MAT), cEdit2 := XXX->RA_NOME, cEdit3 := XXX->R6_DESC, _oDlg9:End() }
  DEFINE SBUTTON FROM C(047),C(156) TYPE 2 ENABLE OF _oDlg9 ACTION _oDlg9:End()

ACTIVATE MSDIALOG _oDlg9 CENTERED

XXX->( DbCloseArea() )

Return(.T.)
                

***************
Static Function EnviaMail( nOpt )
***************
 /*
//Local cEmailTo  	:= iif(nOpt == 1,"rh@ravaembalagens.com.br","jorge@ravaembalagens.com.br;lindenberg@ravaembalagens.com.br;adalberto@ravaembalagens.com.br")//
Local cEmailTo  	:= "antonio@ravaembalagens.com.br"//"emmanuel@ravaembalagens.com.br"
Local cEmailCc  	:= ""
Local lResult   	:= .F.
Local cError    	:= "ERRO NO ENVIO DO EMAIL"
Local cUser
Local nAt
Local cMsg      	:= ""
Local cAccount		:= GetMV( "MV_RELACNT" )
Local cPassword	    := GetMV( "MV_RELPSW"  )
Local cServer		:= GetMV( "MV_RELSERV" )
Local cAttach 		:= ""
Local cAssunto		:= iif(nOpt == 1, "INCLUSÃO DE OCORRÊNCIA", "CONFIRMAÇÃO DE LEITURA DE OCORRÊNCIA")
Local cFrom			:= GetMV( "MV_RELACNT" )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia o e-mail para a lista selecionada. Envia como CC                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

 cEmailCc := ""                                  
                                                                      
CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

cMsg := "<b>PROGRAMA DE CONTROLE DE FALTAS, ATRASOS E PENALIDADES </b><br> <br> "

cMsg += "<p align='justify'>Cabedelo, "+ alltrim( str( day( dDataBase ) ) ) +" de "+mesextenso()+" de "+alltrim( str( year(dDataBase ) ) ) +", <br> <br> <br> "
cMsg += "De: WORKFLOW MICROSIGA <br> <br>"
cMsg += "Para: "+iif(nOpt == 1,"Recursos Humanos","Produção")+" <br> <br>"
cMsg += "INFORMATIVO <br> <br>"

if nOpt == 1
	cMsg += "Informamos que foi incluída uma nova ocorrência para o funcionário "+SRA->RA_NOME+" de matrícula: "+SRA->RA_MAT+".<br>"
	cMsg += "Favor confirmar a ocorrência.<br> <br>"
    //colocado em 19/09/2008
    
    cData := dtos(SZZZ->Z5_DATA)
    DbSelectArea("Z05")
    Z05->( DbSetOrder(1) )
    Z05->( DbSeek( xFilial( "Z05" ) + SZZZ->Z5_MATRIC + cData + SZZZ->Z5_ITEM, .T. ) )

    cMsg += +dtoc(Z05->Z05_DATA)+" - "+Z05->Z05_TIPO+" - "+Z05->Z05_OBS+"<BR><BR>"
    
    cMsg += "Usuário que incluiu a ocorrência: "+alltrim(PSWRet()[1][2])+"<br><br>"
    //
else
	cMsg += "A ocorrência do funcionário "+SRA->RA_NOME+" foi revisada.<br><br> "
    
    ///colocado em 19/09/2008
    cData := dtos(SZZZ->Z5_DATA)
    DbSelectArea("Z05")
    Z05->( DbSetOrder(1) )
    Z05->( DbSeek( xFilial( "Z05" ) + SZZZ->Z5_MATRIC + cData + SZZZ->Z5_ITEM, .T. ) )

    cMsg += +dtoc(Z05->Z05_DATA)+" - "+Z05->Z05_TIPO+" - "+Z05->Z05_OBS+"<BR>"
    ///
endIf

if lResult
	SEND MAIL FROM cFrom TO cEmailTo CC cEmailCc SUBJECT cAssunto BODY cMsg ATTACHMENT cAttach	RESULT lResult
	
	if !lResult
		//Erro no envio do email
		GET MAIL ERROR cError
		//Help(" ",1,"ATENCAO",,cError,4,5)
	endIf
	
	DISCONNECT SMTP SERVER
	
else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	//Help(" ",1,"ATENCAO",,cError,4,5)
endif  */ 


//Local cEmailTo  	:= iif(nOpt == 1,"rh@ravaembalagens.com.br","jorge@ravaembalagens.com.br")//
Local cEmailTo  	:= "rh@ravaembalagens.com.br"
Local cEmailCc  	:= "informatica@ravaembalagens.com.br"
Local lResult   	:= .F.
Local cError    	:= "ERRO NO ENVIO DO EMAIL"
Local cUser
Local nAt
Local cMsg      	:= ""
Local cAccount		:= GetMV( "MV_RELACNT" )
Local cPassword	    := GetMV( "MV_RELPSW"  )
Local cServer		:= GetMV( "MV_RELSERV" )
Local cAttach 		:= ""
Local cAssunto		:= iif(nOpt == 1, "INCLUSÃO DE OCORRÊNCIA", "CONFIRMAÇÃO DE LEITURA DE OCORRÊNCIA")
Local cFrom			:= GetMV( "MV_RELACNT" )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia o e-mail para a lista selecionada. Envia como CC                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

 cEmailCc := ""                                  
                                                                      
//CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

cMsg := "<b>PROGRAMA DE CONTROLE DE FALTAS, ATRASOS E PENALIDADES </b><br> <br> "

cMsg += "<p align='justify'>Cabedelo, "+ alltrim( str( day( dDataBase ) ) ) +" de "+mesextenso()+" de "+alltrim( str( year(dDataBase ) ) ) +", <br> <br> <br> "
cMsg += "De: WORKFLOW MICROSIGA <br> <br>"
cMsg += "Para: "+iif(nOpt == 1,"Recursos Humanos","Produção")+" <br> <br>"
cMsg += "INFORMATIVO <br> <br>"

if nOpt == 1
	cMsg += "Informamos que foi incluída uma nova ocorrência para o funcionário "+SRA->RA_NOME+" de matrícula: "+SRA->RA_MAT+".<br>"
	cMsg += "Favor confirmar a ocorrência.<br> <br>"
    //colocado em 19/09/2008
    
    cData := dtos(SZZZ->Z5_DATA)
    DbSelectArea("Z05")
    Z05->( DbSetOrder(1) )
    Z05->( DbSeek( xFilial( "Z05" ) + SZZZ->Z5_MATRIC + cData + SZZZ->Z5_ITEM, .T. ) )

    cMsg += +dtoc(Z05->Z05_DATA)+" - "+Z05->Z05_TIPO+" - "+Z05->Z05_OBS+"<BR><BR>"
    
    cMsg += "Usuário que incluiu a ocorrência: "+alltrim(PSWRet()[1][2])+"<br><br>"
    //
else
	cMsg += "A ocorrência do funcionário "+SRA->RA_NOME+" foi revisada.<br><br> "
    
    ///colocado em 19/09/2008
    cData := dtos(SZZZ->Z5_DATA)
    DbSelectArea("Z05")
    Z05->( DbSetOrder(1) )
    Z05->( DbSeek( xFilial( "Z05" ) + SZZZ->Z5_MATRIC + cData + SZZZ->Z5_ITEM, .T. ) )

    cMsg += +dtoc(Z05->Z05_DATA)+" - "+Z05->Z05_TIPO+" - "+Z05->Z05_OBS+"<BR>"
    ///
endIf
/*
if lResult
	SEND MAIL FROM cFrom TO cEmailTo CC cEmailCc SUBJECT cAssunto BODY cMsg ATTACHMENT cAttach	RESULT lResult
	
	if !lResult
		//Erro no envio do email
		GET MAIL ERROR cError
		//Help(" ",1,"ATENCAO",,cError,4,5)
	endIf
	
	DISCONNECT SMTP SERVER
	
else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	//Help(" ",1,"ATENCAO",,cError,4,5)
endif
*/     
  // cEmail   :="rubem@ravaembalagens.com.br"

    //ACSendMail(,,,,cEmailTo,cAssunto,cMsg,)
    U_SendMailSC(cEmailTo ,"" , cAssunto, cMsg,"" )
Return 

***************
Static Function C(nTam)
***************

Local nHRes :=  oMainWnd:nClientWidth // Resolucao horizontal do monitor
  If nHRes == 640 // Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
    nTam *= 0.8
  ElseIf (nHRes == 798).Or.(nHRes == 800) // Resolucao 800x600
    nTam *= 1
  Else  // Resolucao 1024x768 e acima
    nTam *= 1.28
  EndIf

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³Tratamento para tema "Flat"³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If "MP8" $ oApp:cVersion
    If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
      nTam *= 0.90
    EndIf
  EndIf

Return Int(nTam)

***************
Static Function wordWrap( cText, nRegua )
***************

Local aRet  := {}
Local cTemp := ''
Local i 	:= 1
cTemp :=     memoline( cText, nRegua, i, 4, .T. )
do while len( cTemp ) > 0
	aAdd(aRet, { alltrim(cTemp) } )
	i++
	cTemp := memoline( cText, nRegua, i, 4, .T. )
endDo

Return aRet