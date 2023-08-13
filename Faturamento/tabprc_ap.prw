#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  TABPRC  ³ Autor ³   Mauricio Barros     ³ Data ³ 29/12/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Manutencao das tabelas de preco                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Rava Embalagens                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

*************
User Function TABPRC()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
*************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("AESTRUT,CARQTMP,CFILTRO,CCHAVE,CINDTMP,CCOD")
SetPrvt("CLOCAL,NVALCUST,NQTD,")

lMSErroAuto := .F.
lMsHelpAuto := .F.
aSvAtela    := {{},{}}
aSvAGets    := {{},{}}
aTela       :={}
aGets       :={}
cCABALIAS := "ZZ1"
cITEALIAS := "ZZ2"
aRotina := {{"Pesquisar", "AxPesqui", 0 , 1},;
            {"Visualizar", "U_TabprcVis", 0 , 2},;
            {"Incluir", "U_TabprcInc", 0 , 3},;
            {"Alterar", "U_TabprcAlt", 0 , 4},;
            {"Excluir", "DelModelo(cCABALIAS,cITEALIAS)", 0 , 5},;
            {"Imprimir", "U_TabprcImp", 0 , 6}}

cCADASTRO := OemToAnsi( "Tabela de precos" )
mBrowse( 06, 01, 22, 75, cCABALIAS )
Return NIL



*************
User Function TABPRCVIS()
*************

aAltEnChoice := {}//CAMPOS P/ ALTERAR NA ENCHOICE
nCnt    := 0
nOpca   := 2
aCols   := {}
aHeader := {}
aAltGetDados := {}// CAMPO P/ ALTERAR NO GETDADOS/ITEM
aCpoGetDados := {"ZZ2_COD","ZZ2_PRECO"}  //CAMPO P/ NAO MOSTRAR NO GETDADOS/ITEM
aCpoEnChoice := {{"ZZ1_REPRES","ZZ1_TABELA","ZZ1_DESCR","ZZ1_GRUPO","ZZ1_SGRUPO","ZZ1_OBS1","ZZ1_OBS2","ZZ1_OBS3","ZZ1_OBS4","ZZ1_OBS5"},;
                          {"ZZ2_COD","ZZ2_PRECO"}}  //CAMPOS P/ MOSTRAR NA ENCHOICE

nUsado := 0
For nI := 1 to Len(aCpoGetDados)
   aCpoGetDados[nI] := Padr(aCpoGetDados[nI],10)
Next
RegToMemory( cITEALIAS, .F. )
MontaHead()
MontaCols()
lRet := Modelo3( cCadastro, cCABALIAS, cITEALIAS, aCpoEnChoice, "U_TABPRCLI()", "U_TABPRCOK()", 2, 4,,,, aAltEnchoice, "", aAltGetDados )
Return



*************
User Function TABPRCALT()
*************

aAltEnChoice := {"ZZ1_REPRES","ZZ1_TABELA","ZZ1_DESCR","ZZ1_GRUPO","ZZ1_SGRUPO","ZZ1_OBS1","ZZ1_OBS2","ZZ1_OBS3","ZZ1_OBS4","ZZ1_OBS5"}//CAMPOS P/ ALTERAR NA ENCHOICE
nCnt    := 0
nOpca   := 4
aCols   := {}
aHeader := {}
aAltGetDados := {"ZZ2_COD","ZZ2_PRECO"}// CAMPO P/ ATERAR NO GETDADOS/ITEM
aCpoGetDados := {"ZZ2_FILIAL","ZZ2_REPRES","ZZ2_TABELA"}//CAMPO P/ NAO MOSTAR NO GETDADOS/ITEM
nUsado  := 0
aCpoEnChoice := {{"ZZ1_REPRES","ZZ1_TABELA","ZZ1_DESCR","ZZ1_GRUPO","ZZ1_SGRUPO","ZZ1_OBS1","ZZ1_OBS2","ZZ1_OBS3","ZZ1_OBS4","ZZ1_OBS5"},;
                 {"ZZ2_COD","ZZ2_PRECO"}}  //CAMPOS P/ MOSTRA NA ENCHOICE

For nI := 1 to Len(aCpoGetDados)
   aCpoGetDados[nI] := Padr(aCpoGetDados[nI],10)
Next
RegToMemory("SFJ",.F.)
MontaHead()
MontaCols()
lRet := Modelo3( cCadastro, "ZZ1", "ZZ2", aCpoEnChoice, "MTA297Li()", "MTA297OK()", 4, 4,,,, aAltEnchoice, "", aAltGetDados )
Return



*************
Static Function Montahead()
*************

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek( cITEALIAS )
While !Eof() .And. (X3_ARQUIVO == cITEALIAS)
   nPos := Ascan(aCpoGetDados,X3_CAMPO)
   IF X3USO(X3_USADO) .And. cNivel >= X3_NIVEL .And. Empty(nPos)
    nUsado:=nUsado+1
    AADD(aHeader,{ Trim(X3Titulo()), ;
                  X3_CAMPO,;
                  X3_PICTURE, ;
                  X3_TAMANHO, ;
                  X3_DECIMAL, ;
                  "AllwaysTrue()" , ;
                  X3_USADO,;
                   X3_TIPO, ;
                   X3_ARQUIVO,;
                   X3_CONTEXT } )
   EndIF
   dbSkip()
Enddo
Return



*************
Static Function MontaCols()
*************

aCols := {}
DbSelectArea( cITEALIAS )
DbSetOrder(1)
DbSeek( xFilial( cITEALIAS )+SFJ->FJ_CODIGO )
While !Eof() .And. DF_CODIGO==SFJ->FJ_CODIGO .and. xFilial( cITEALIAS )==SDF->DF_FILIAL
  AADD(aCols,Array(nUsado+1))
  For _ni:=1 to nUsado
    If ( aHeader[_ni][10] != "V")
      aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
      Else
      aCols[Len(aCols),_ni] := CriaVar(aHeader[_ni,2],.t.)
    EndIf
  Next
  aCols[Len(aCols),nUsado+1]:=.F.
  dbSkip()
EndDo
Return



*************
User Function TabprcLi()
*************
Local nx
Local lRet := .T.
Local lDeleted := .F.

IF ValType(aCols[n,Len(aCols[n])]) == "L"
  lDeleted := aCols[n,Len(aCols[n])]      // Verifica se esta Deletado
EndIF
IF !lDeleted
   For nx = 1 To Len(aCols)
      IF Mod(aCols[nx,ProcH('DF_QTDINF')],If(aCols[nx,ProcH('DF_QE')] > 0,aCols[nx,ProcH('DF_QE')],1)  ) > 0
         Help(" ",1,"MTA297LIN")
         lRet := .f.
      EndIF
    IF !lRet
       Exit
      EndIF
   Next nx
EndIF
Return lRet



*************
User Function TabprcOK()
*************
Local lRet := .T.
Local nX
Local lDeleted := .F.
Local lContinua := .f.
IF nOpca == 4 //Alterar
   IF M->FJ_TIPGER == "2"
      If Empty(M->FJ_FORNECE) .or. Empty(M->FJ_LOJA) .or. Empty(M->FJ_FILENT) .or. Empty(M->FJ_COND)
         lMshelpAuto := .f.
         Help(" ",1,"MTA297PED")
         Return .F.
      EndIf
   EndIF
   lMshelpAuto := .t.
  Begin Transaction
     For nX:=1 to Len(aCols)
       IF ValType(aCols[nX,Len(aCols[nX])]) == "L"
          lDeleted := aCols[nX,Len(aCols[nX])]      // Verfiica se esta Deletado
       EndIF
       IF ! lDeleted
          IF SDF->(DbSeek(xFilial("SDF")+SFJ->FJ_CODIGO+aCols[nX,ProcH('DF_PRODUTO')]))
             SDF->(RecLock("SDF",.F.))
             SDF->DF_QTDINF := aCols[nX,ProcH('DF_QTDINF')]
             SDF->DF_VLRTOT := aCols[nX,ProcH('DF_VLRTOT')]
             SDF->(MsUnlock())
          EndIF
       Else
          IF SDF->(DbSeek(xFilial("SDF")+SFJ->FJ_CODIGO+aCols[nX,ProcH('DF_PRODUTO')]))
             SDF->(RecLock("SDF",.F.))
             SDF->(DbDelete())
             SDF->(MsUnlock())
          EndIF
       EndIF
     Next
     IF M->FJ_TIPPRC # nTipPrc
        SFJ->(RecLock("SFJ",.F.))
        SFJ->FJ_TIPPRC := M->FJ_TIPPRC
        SFJ->(MsUnlock())
     EndIF
     If lContinua
      MT297Ger(MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR05)
     EndIF
  End Transaction
  IF lMsErroAuto
     MostraErro()
     lRet := .F.
  EndIF
   lMsErroAuto := .f.
   lMsHelpAuto := .f.
EndIF
Return lRet
