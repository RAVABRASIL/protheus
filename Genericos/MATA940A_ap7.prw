#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function MATA940A()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CARQ01,CARQ02,CARQ03,CARQ04,CARQ05,ATOTREG88")
SetPrvt("CREGISTRO,AREGSALL,NREG88,CREG90,CCFO,NVALICM")
SetPrvt("LSOMA,CCFOPESQ,NREG0106,NREG0206,NDIA,NRET")
SetPrvt("ASAVE,NOPC,CPERG,CTITULO,CTEXT1,CTEXT2")
SetPrvt("CTEXT3,CSAY0107,CSAY0108,CSAY0109,CSAY0110,CSAY0111")
SetPrvt("CSAY0112,CSAY0113,NGET0107,NGET0108,NGET0109,NGET0110")
SetPrvt("NGET0111,NGET0112,NGET0113,CSAY0207,CSAY0208,CSAY0209")
SetPrvt("CSAY0210,CSAY0211,CSAY0212,CSAY0213,NGET0207,NGET0208")
SetPrvt("NGET0209,NGET0210,NGET0211,NGET0212,NGET0213,CSAY0306")
SetPrvt("CSAY0307,NGET0306,NGET0307,CSAY0406,CSAY0407,CSAY0408")
SetPrvt("CSAY0409,CSAY0410,NGET0406,NGET0407,NGET0408,NGET0409")
SetPrvt("NGET0410,CSAY0503,CSAY0504,CSAY0505,CSAY0506,CSAY0507")
SetPrvt("NGET0503,NGET0504,NGET0505,NGET0506,NGET0507,CSAY0606")
SetPrvt("CSAY0607,CSAY0608,CSAY0609,CSAY0610,CSAY0611,CSAY0612")
SetPrvt("CSAY0613,NGET0606,NGET0607,NGET0608,NGET0609,NGET0610")
SetPrvt("NGET0611,NGET0612,NGET0613,TG_ODLG,NLININI,TG_BOK")
SetPrvt("TG_NOPC,TG_BCANCEL,TG_BINIT,NREGX,NREGIST,NDISK")
SetPrvt("NREG90,CCLIFOR,CLOJA,CNOTA,CSERIE,CFILIAL")
SetPrvt("_N01,_N02,CCGC,CINSC,_NA02,I")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,TAMANHO,LIMITE")
SetPrvt("NTIPO,CABEC1,CABEC2,CABEC3,CBCONT,CBTXT")
SetPrvt("M_PAG,CSTRING,LEND,NLASTKEY,WNREL,NCNT01")
SetPrvt("NCNT02,CTIPO,CREG,NLIN,NTOTREG,")

DBCLOSEAREA(cARQTEMP)
cArq01 := Left(cArqTemp,7)+"A"
cArq02 := Left(cArqTemp,7)+"B"
cArq03 := Left(cArqTemp,7)+"C"
cArq04 := Left(cArqTemp,7)+"D"
cArq05 := Left(cArqTemp,7)+"E"
dbUseArea(.T.,__LocalDriver,cArqTEMP,"GIM",.T.,.F.)

DbSelectArea("GIM")
DbClearIndex()
DbSetIndex(cArq01+OrdBagExt())
DbSetIndex(cArq02+OrdBagExt())
DbSetIndex(cArq03+OrdBagExt())
DbSetIndex(cArq04+OrdBagExt())
DbSetIndex(cArq05+OrdBagExt())


aTotReg88 := {}
cRegistro := "88"
aRegsall := {}
nReg88   := 0
cREG90   := ""
cCFO     := ""
nValIcm  := 0
lSoma    := .f.
cCFOPESQ := "143,144,152,153,154,155,172,173,174,191,192,197,198,243,244,252,253,254,255,272,273,274,291,292,297,298,391,397"
nReg0106 := 0
nReg0206 := 0
nDia := 1
nRet := .f.
aSave    := {Alias(),IndexOrd(),Recno()}
nOpc     := 0
cPerg    := "GIM940"
cTitulo  := "Dados Adicionais da GIM"
cText1   := "Este programa gera arquivo pr‚-formatado dos lan‡amentos fiscais"
cText2   := "para entrega as Secretarias de Fazenda Estaduais, (opera‡”es   "
cText3   := "interestaduais). Convenio ICMS 31/99."
cSay0107 := "Credito do ativo imobilizado (R$):"
cSay0108 := "Creditos acumulados recebidos por transferencia (R$):"
cSay0109 := "ICMS antecipado ja recolhido (R$):"
cSay0110 := "ICMS antecipado a recolher (R$):"
cSay0111 := "Outros creditos (R$):"
cSay0112 := "Estorno de debito (R$):"
cSay0113 := "Saldo credor do mes anterior (R$):"
nGet0107 := 0.00
nGet0108 := 0.00
nGet0109 := 0.00
nGet0110 := 0.00
nGet0111 := 0.00
nGet0112 := 0.00
nGet0113 := 0.00
cSay0207 := "Transferencia de creditos acumulados (R$)  "
cSay0208 := "Outros debitos (R$)                        "                     
cSay0209 := "Estorno de credito (R$)                    "
cSay0210 := "Substituicao por entradas ja recolhida (R$)"
cSay0211 := "Substituicao por entradas a recolher (R$)  "
cSay0212 := "Substituicao por saidas ja recolhida (R$)  "
cSay0213 := "Substituicao por saidas a recolher (R$)    "
nGet0207 := 0.00
nGet0208 := 0.00
nGet0209 := 0.00
nGet0210 := 0.00
nGet0211 := 0.00
nGet0212 := 0.00
nGet0213 := 0.00
cSay0306 := "Natureza da transferencia (E/S)"
cSay0307 := "Valor da transferencia (R$)"
nGet0306 := Space(1)
nGet0307 := 0.00
cSay0406 := "Diferenca de aliquota de consumo e ativo fixo (R$)"
cSay0407 := "Imposto retido por outras Ufs (R$)"
cSay0408 := "e-mail do contribuinte"
cSay0409 := "Data de inicio das atividades"
cSay0410 := "Versao do programa"
nGet0406 := 0.00
nGet0407 := 0.00
nGet0408 := Space(40)
nGet0409 := Ctod("")
nGet0410 := Space(4)
cSay0503 := "CPF/CGC do Contador"
cSay0504 := "CRC do Contador"
cSay0505 := "Nome (Razao Social) do Contador"
cSay0506 := "Telefone do Contador"
cSay0507 := "E-mail do Contador"
nGet0503 := Space(14)
nGet0504 := Space(10)
nGet0505 := Space(40)
nGet0506 := Space(12)
nGet0507 := Space(40)
cSay0606 := "Estoque tributavel"
cSay0607 := "Estoque nao tributavel"
cSay0608 := "Estoque de substituicao tributaria"
cSay0609 := "Saldo em caixa"
cSay0610 := "Saldo em bancos"
cSay0611 := "Despesas com pessoal, terc., pro-labore"
cSay0612 := "Outros impostos e encargos"
cSay0613 := "Despesas gerais"
nGet0606 := 0.00
nGet0607 := 0.00
nGet0608 := 0.00
nGet0609 := 0.00
nGet0610 := 0.00
nGet0611 := 0.00
nGet0612 := 0.00
nGet0613 := 0.00

While .T.
	  tg_oDlg := oSend( MSDialog(), "New", 3, 3, 38,100,cTitulo,,,.F.,,,,,oMainWnd,.F.,,,.F.)
      nLinIni := 15
	  @ nLinIni,    005 SAY "01 - Creditos do ICMS (Anverso da GIM - Creditos)" 
      @ nLinIni+10, 015 SAY cSay0107 SIZE 120, 8 
      @ nLinIni+10, 145 GET nGet0107 Picture "@e 999,999.99" SIZE 45, 8 
      @ nLinIni+20, 015 SAY cSay0108 SIZE 140, 8 
      @ nLinIni+20, 145 GET nGet0108 Picture "@e 999,999.99" SIZE 45, 8 
      @ nLinIni+30, 015 SAY cSay0109 SIZE 120, 8 
      @ nLinIni+30, 145 GET nGet0109 Picture "@e 999,999.99" SIZE 45, 8 
      @ nLinIni+40, 015 SAY cSay0110 SIZE 120, 8 
      @ nLinIni+40, 145 GET nGet0110 Picture "@e 999,999.99" SIZE 45, 8 
      @ nLinIni+50, 015 SAY cSay0111 SIZE 120, 8 
      @ nLinIni+50, 145 GET nGet0111 Picture "@e 999,999.99" SIZE 45, 8 
      @ nLinIni+60, 015 SAY cSay0112 SIZE 120, 8 
      @ nLinIni+60, 145 GET nGet0112 Picture "@e 999,999.99" SIZE 45, 8 
      @ nLinIni+70, 015 SAY cSay0113 SIZE 120, 8 
      @ nLinIni+70, 145 GET nGet0113 Picture "@e 999,999.99" SIZE 45, 8 
      @ nLinIni   , 195 SAY "02 - Debitos do ICMS (Anverso da GIM - Debitos)" 
      @ nLinIni+10, 205 SAY cSay0207 SIZE 120, 8 
      @ nLinIni+10, 335 GET nGet0207 Picture "@e 999,999.99" SIZE 45, 8 
      @ nLinIni+20, 205 SAY cSay0207 SIZE 120, 8 
      @ nLinIni+20, 335 GET nGet0208 Picture "@e 999,999.99" SIZE 45, 8 
      @ nLinIni+30, 205 SAY cSay0209 SIZE 120, 8 
      @ nLinIni+30, 335 GET nGet0209 Picture "@e 999,999.99" SIZE 45, 8 
      @ nLinIni+40, 205 SAY cSay0210 SIZE 120, 8 
      @ nLinIni+40, 335 GET nGet0210 Picture "@e 999,999.99" SIZE 45, 8 
      @ nLinIni+50, 205 SAY cSay0211 SIZE 120, 8 
      @ nLinIni+50, 335 GET nGet0211 Picture "@e 999,999.99" SIZE 45, 8 
      @ nLinIni+60, 205 SAY cSay0212 SIZE 120, 8 
      @ nLinIni+60, 335 GET nGet0212 Picture "@e 999,999.99" SIZE 45, 8 
      @ nLinIni+70, 205 SAY cSay0213 SIZE 120, 8 
      @ nLinIni+70, 335 GET nGet0213 Picture "@e 999,999.99" SIZE 45, 8 
      nLinIni := nLinIni + 67 + 17
	  @ nLinIni   , 003 SAY "03 - Transferencia de Creditos" 
      @ nLinIni+10, 015 SAY cSay0306 SIZE 120, 8 
      @ nLinIni+10, 145 GET nGet0306 Picture "@!" SIZE 45,8 
      @ nLinIni+20, 015 SAY cSay0307 SIZE 120, 8 
      @ nLinIni+20, 145 GET nGet0307 Picture "@e 999,999.99" SIZE 45, 8 
      @ nLinIni   , 195 SAY "04 - Informacoes complementares" 
      @ nLinIni+10, 205 SAY cSay0406 SIZE 120, 8 
      @ nLinIni+10, 335 GET nGet0406 Picture "@e 999,999.99" SIZE 45, 8 
      @ nLinIni+20, 205 SAY cSay0407 SIZE 120, 8 
      @ nLinIni+20, 335 GET nGet0407 Picture "@e 999,999.99" SIZE 45, 8 
      @ nLinIni+30, 205 SAY cSay0408 SIZE 120, 8 
      @ nLinIni+30, 335 GET nGet0408 SIZE 45, 8 
      @ nLinIni+40, 205 SAY cSay0409 SIZE 120, 8 
      @ nLinIni+40, 335 GET nGet0409 SIZE 45, 8 
      @ nLinIni+50, 205 SAY cSay0410 SIZE 120, 8 
      @ nLinIni+50, 335 GET nGet0410 SIZE 45, 8 
      nLinIni := nLinIni + 47 + 17
	  @ nLinIni   , 003 SAY "05 - Informacoes complementares (Contador)" 
      @ nLinIni+10, 015 SAY cSay0503 SIZE 120, 8 
      @ nLinIni+10, 145 GET nGet0503 SIZE 45, 8 
      @ nLinIni+20, 015 SAY cSay0504 SIZE 120, 8 
      @ nLinIni+20, 145 GET nGet0504 SIZE 45, 8 
      @ nLinIni+30, 015 SAY cSay0505 SIZE 120, 8 
      @ nLinIni+30, 145 GET nGet0505 SIZE 45, 8 
      @ nLinIni+40, 015 SAY cSay0506 SIZE 120, 8 
      @ nLinIni+40, 145 GET nGet0506 SIZE 45, 8 
      @ nLinIni+50, 015 SAY cSay0507 SIZE 120, 8 
      @ nLinIni+50, 145 GET nGet0507 SIZE 45, 8 
      @ nLinIni   , 195 SAY "06 - Dados Anuais da GIM" 
      @ nLinIni+10, 205 SAY cSay0606 SIZE 120, 8 
      @ nLinIni+10, 335 GET nGet0606 Picture "@e 999,999.99" SIZE 45, 8 
      @ nLinIni+20, 205 SAY cSay0607 SIZE 120, 8 
      @ nLinIni+20, 335 GET nGet0607 Picture "@e 999,999.99" SIZE 45, 8 
      @ nLinIni+30, 205 SAY cSay0608 SIZE 120, 8 
      @ nLinIni+30, 335 GET nGet0608 Picture "@e 999,999.99" SIZE 45, 8 
      @ nLinIni+40, 205 SAY cSay0609 SIZE 120, 8 
      @ nLinIni+40, 335 GET nGet0609 Picture "@e 999,999.99" SIZE 45, 8 
      @ nLinIni+50, 205 SAY cSay0610 SIZE 120, 8 
      @ nLinIni+50, 335 GET nGet0610 Picture "@e 999,999.99" SIZE 45, 8 
      @ nLinIni+60, 205 SAY cSay0611 SIZE 120, 8 
      @ nLinIni+60, 335 GET nGet0611 Picture "@e 999,999.99" SIZE 45, 8 
      @ nLinIni+70, 205 SAY cSay0612 SIZE 120, 8 
      @ nLinIni+70, 335 GET nGet0612 Picture "@e 999,999.99" SIZE 45, 8 
      @ nLinIni+80, 205 SAY cSAY0613 SIZE 120, 8 
      @ nLinIni+80, 335 GET nGet0613 Picture "@e 999,999.99" SIZE 45, 8 
      tg_bOk     := {||tg_nOpc:=1,oSend(tg_oDlg,"End")}
      tg_bCancel := {||tg_nOpc:=0,oSend(tg_oDlg,"End")}
      tg_bInit := {|| EnchoiceBar(tg_oDlg,tg_bOk,tg_bCancel) }
      oSend( tg_oDlg, "Activate",,,,.T.,,, tg_bInit )
      oSend( tg_oDlg, "Destroy" )
   Do Case
   Case tg_nOpc==1
      nRet := .t.
   EndCase
   Exit
End
DBSELECTAREA("GIM")
DBGOTOP()
DO WHILE !eof()
   lsoma := .f.
   nRegx := ASCAN(aRegsAll, {|x| x[1] == TIPOREG})
   IF NREGX == 0
      IF !( TIPOREG $ "10.11.90" )
         AADD(aRegsAll, {TIPOREG, 1})
      ENDIF
   Else
      aRegsAll[nRegx,2] := aRegsAll[nRegx,2] + 1
   ENDIF
   IF TIPOREG == "50"
      cCFO    := Substr(G,16,3)
 	 nValIcm := Val(Substr(G,45,11)+"."+Substr(G,56,2))
      lSoma   := .t.
   ENDIF
   IF TIPOREG == "70"
      cCFO    := Substr(G,14,3)
 	 nValIcm := Val(Substr(G,45,11)+"."+Substr(G,56,2))
      lSoma   := .t.
   ENDIF
   IF TIPOREG == "90"
      //cReg90  := (cArqTemp)->TIPOREG+C+D+E+F+G
 	 nRegist := H
     NDISK   := NUMDISK 
	 nREG90  := GIM->(RECNO())
	 RecLock("GIM",.F.)
 	 dbdelete()
   ENDIF
   IF ( lSoma )
 	  
	     If !(Alltrim(cCFO)$cCFOPESQ) .and. Val(cCFO) < 500
	        nReg0106 := nReg0106 + nValIcm
      End
      
 	 If Val(cCFO) >= 500
	        nReg0206 := nReg0206 + nValIcm
      End
	  
   Endif   
   dbskip()
Enddo

DBSELECTAREA(cReg54)
DBGOTOP()
sf3->(dbsetorder(4))
DO WHILE !eof()
   cClifor := CLIEFOR
   cLoja   := LOJA
   cNota   := NOTA
   cSerie  := SERIE
   cFilial := SF3->(xFilial())
   IF SF3->(dbseek(cfilial+cCLIFOR+cLOJA+cNOTA+cSERIE))   
      _n01 := Ascan(aTotReg88, {|x| x[1] == "01"})
      If (_n01 == 0)
         IncProc("Processando registro 88...")
         If !(Alltrim(SF3->F3_CFO)$cCFOPESQ) .and. Val(SF3->F3_CFO) < 500
            Aadd(aTotReg88, {"01", SF3->F3_VALICM, 0, 0})
         Endif
      Else
         If !(Alltrim(SF3->F3_CFO)$cCFOPESQ) .and. Val(SF3->F3_CFO) < 500
            aTotReg88[_n01, 2] := aTotReg88[_n01, 2]+ SF3->F3_VALICM
         End
      End

      _n02 := Ascan(aTotReg88, {|x| x[1] == "02"})
      If (_n02 == 0)
         IncProc("Processando CFO's...")
         Aadd(aTotReg88, {"02", 0, 0, 0})
         If (Val(SF3->F3_CFO) >= 500)
            aTotReg88[1, 4] := aTotReg88[1, 4]+ SF3->F3_ICMSRET
            aTotReg88[1, 2] := aTotReg88[1, 2]+ SF3->F3_VALICM
         End
         If (Val(SF3->F3_CFO) < 500)
            aTotReg88[1, 3] := aTotReg88[1, 3] + SF3->F3_ICMSRET
         End
 	 Else
         If (Val(SF3->F3_CFO) >= 500)
            aTotReg88[_n02, 2] := aTotReg88[_n02, 2]+ SF3->F3_VALICM
            aTotReg88[_n02, 4] := aTotReg88[_n02, 4]+ SF3->F3_ICMSRET
         End
         If (Val(SF3->F3_CFO) < 500)
            aTotReg88[_n02, 3] := aTotReg88[_n02, 3] + SF3->F3_ICMSRET
         End
      Endif

   ENDIF
	  dbskip()
enddo

cCGC := SM0->M0_CGC
If Empty(cCGC)
   cCGC := Replic("0",14)
Endif
cInsc := SM0->M0_INSC
cRegistro := "88"                                                         //01.Tipo
cRegistro := cRegistro +  "01"                                            //02.Detalhe
cRegistro := cRegistro +  a940Fill(A940Num2Chr(Val(cInsc),9,0),9)         //03.Insc. Estadual
cRegistro := cRegistro +  a940Fill(StrZero(Year(mv_Par01),4);             //04.Periodo de Referencia
             +StrZero(Month(mv_Par01),2),06)
cRegistro := cRegistro +  a940Fill(if(mv_Par15==1,"N", "R"),1)            //05.Sub-serie
cRegistro := cRegistro +  a940Fill(A940Num2Chr(nReg0106,13,2),13)         //06.Cred. por Entradas
cRegistro := cRegistro +  a940Fill(A940Num2Chr(nGet0107,13,2),13)         //07.Cred. Ativo Imobilizado
cRegistro := cRegistro +  a940Fill(A940Num2Chr(nGet0108,13,2),13)         //08.Cred. Transferencia
cRegistro := cRegistro +  a940Fill(A940Num2Chr(nGet0109,13,2),13)         //09.ICMS antecipado Ja Recolhido
cRegistro := cRegistro +  a940Fill(A940Num2Chr(nGet0110,13,2),13)         //10.ICMS antecipado a Recolher
cRegistro := cRegistro +  a940Fill(A940Num2Chr(nGet0111,13,2),13)         //11.Outros creditos
cRegistro := cRegistro +  a940Fill(A940Num2Chr(nGet0112,13,2),13)         //12.Estorno de debito
cRegistro := cRegistro +  a940Fill(A940Num2Chr(nGet0113,13,2),13)         //13.Saldo credor
cRegistro := cRegistro +  Space(2)                                                                                                        //14.Brancos

RecLock("GIM",.T.)
nReg88  := nReg88 + 1
GIM->NUMDISK := nDISK
GIM->TIPOREG := SubStr(cRegistro,01,002)
GIM->C := SubStr(cRegistro,03,016)
GIM->D := SubStr(cRegistro,17,026)
GIM->E := SubStr(cRegistro,27,030)
GIM->F := SubStr(cRegistro,31,038)
GIM->G := SubStr(cRegistro,39,126)
GIM->H := nRegist
nRegist := nRegist + 1

nRegx := ASCAN(aRegsAll, {|x| x[1] == TIPOREG})
IF NREGX == 0
   IF !( TIPOREG $ "10.11.90" )
      AADD(aRegsAll, { TIPOREG, 1})
   ENDIF
Else
   aRegsAll[nRegx,2] := aRegsAll[nRegx,2] + 1
ENDIF
MsUnlock()

cRegistro := "88"                                                         //01.Tipo
cRegistro := cRegistro +  "02"                                            //02.Detalhe
cRegistro := cRegistro +  a940Fill(A940Num2Chr(Val(cInsc),9,0),9)         //03.Insc. Estadual
cRegistro := cRegistro +  a940Fill(StrZero(Year(mv_Par01),4);             //04.Periodo de Referencia
             +StrZero(Month(mv_Par01),2),06)
cRegistro := cRegistro +  a940Fill(if(mv_Par15==1,"N", "R"),1)            //05.Sub-serie
_na02 := Ascan(aTotReg88, {|x| x[1] == "02"})
cRegistro := cRegistro +  a940Fill(A940Num2Chr(nReg0206,13,2),13)         //06.Debito por Saidas
cRegistro := cRegistro +  a940Fill(A940Num2Chr(nGet0207,13,2),13)         //07.Cred. Ativo Imobilizado
cRegistro := cRegistro +  a940Fill(A940Num2Chr(nGet0208,13,2),13)         //08.Cred. Transferencia
cRegistro := cRegistro +  a940Fill(A940Num2Chr(nGet0209,13,2),13)         //09.ICMS antecipado Ja Recolhido
cRegistro := cRegistro + If(_na02>0,a940Fill(A940Num2Chr(aTotReg88[_na02; //10.
             , 3],13,2),13), Replicate("0",13))
cRegistro := cRegistro +  a940Fill(A940Num2Chr(nGet0211,13,2),13)         //11.Outros creditos
cRegistro := cRegistro +  a940Fill(A940Num2Chr(nGet0212,13,2),13)         //12.Estorno de debito
cRegistro := cRegistro +  If(_na02>0,a940Fill(A940Num2Chr(aTotReg88[_na02;//13.
             , 4],13,2),13), Replicate("0",13))
cRegistro := cRegistro +  Space(2)                                        //14.Brancos

RecLock("GIM",.T.)
nReg88 := nReg88 + 1
GIM->NUMDISK := nDISK
GIM->TIPOREG := SubStr(cRegistro,01,002)
GIM->C := SubStr(cRegistro,03,016)
GIM->D := SubStr(cRegistro,17,026)
GIM->E := SubStr(cRegistro,27,030)
GIM->F := SubStr(cRegistro,31,038)
GIM->G := SubStr(cRegistro,39,126)
GIM->H := nRegist
nRegist := nRegist + 1
nRegx := ASCAN(aRegsAll, {|x| x[1] == TIPOREG})
IF NREGX == 0
   IF !( TIPOREG $ "10.11.90" )
      AADD(aRegsAll, { TIPOREG, 1})
   ENDIF
Else
   aRegsAll[nRegx,2] := aRegsAll[nRegx,2] + 1
ENDIF
MsUnlock()

cRegistro := "88"                                                         //01.Tipo
cRegistro := cRegistro + "03"                                             //02.Detalhe
cRegistro := cRegistro +  a940Fill(A940Num2Chr(Val(cInsc),9,0),9)         //03.Insc. Estadual
cRegistro := cRegistro +  a940Fill(StrZero(Year(mv_Par01),4);             //04.Periodo de Referencia
             +StrZero(Month(mv_Par01),2),06)                        
cRegistro := cRegistro + a940Fill(A940Num2Chr(Val(cInsc),9,0),9)          //05.Insc. Estadual da empresa
cRegistro := cRegistro +  a940Fill(nGet0306,01)                           //06.Natureza da transferencia
cRegistro := cRegistro +  a940Fill(A940Num2Chr(nGet0307,13,2),13)         //07.Valor da transferencia
cRegistro := cRegistro +  Space(84)                                                                                                       //08.Brancos

RecLock("GIM",.T.)
nReg88 := nReg88 + 1
GIM->NUMDISK := nDISK
GIM->TIPOREG := SubStr(cRegistro,01,002)
GIM->C := SubStr(cRegistro,03,016)
GIM->D := SubStr(cRegistro,17,026)
GIM->E := SubStr(cRegistro,27,030)
GIM->F := SubStr(cRegistro,31,038)
GIM->G := SubStr(cRegistro,39,126)
GIM->H := nRegist
nRegist := nRegist + 1
nRegx := ASCAN(aRegsAll, {|x| x[1] == TIPOREG})
IF NREGX == 0
   IF !( TIPOREG $ "10.11.90" )
      AADD(aRegsAll, { TIPOREG, 1})
   ENDIF
Else
   aRegsAll[nRegx,2] := aRegsAll[nRegx,2] + 1
ENDIF
MsUnlock()

cRegistro := "88"                                                         //01.Tipo
cRegistro := cRegistro +  "04"                                            //02.Detalhe
cRegistro := cRegistro +  a940Fill(A940Num2Chr(Val(cInsc),9,0),9)         //03.Insc. Estadual
cRegistro := cRegistro +  a940Fill(StrZero(Year(mv_Par01),4);             //04.Periodo de Referencia
             +StrZero(Month(mv_Par01),2),06)
cRegistro := cRegistro +  a940Fill(if(mv_Par15==1,"N", "R"),1)            //05.Sub-serie
cRegistro := cRegistro +  a940Fill(A940Num2Chr(nGet0406,13,2),13)         //06.Diferenca de aliquota
cRegistro := cRegistro +  a940Fill(A940Num2Chr(nGet0407,13,2),13)         //07.Imposto retido por outra Ufs
cRegistro := cRegistro +  a940Fill(nGet0408,40)                           //08.e-mail do contribuinte
cRegistro := cRegistro +  a940Fill(StrZero(Year(nGet0409),4);             //09.Data de inicio das atividades
             +StrZero(Month(nGet0409),2)+StrZero(Day(nGet0409),2),08)
cRegistro := cRegistro +  a940Fill(nGet0410,04)                           //10.Versao do programa
cRegistro := cRegistro +  Space(28)                                                                                                       //11.Brancos

RecLock("GIM",.T.)
nReg88 := nReg88 + 1
GIM->NUMDISK := nDISK
GIM->TIPOREG := SubStr(cRegistro,01,002)
GIM->C := SubStr(cRegistro,03,016)
GIM->D := SubStr(cRegistro,17,026)
GIM->E := SubStr(cRegistro,27,030)
GIM->F := SubStr(cRegistro,31,038)
GIM->G := SubStr(cRegistro,39,126)
GIM->H := nRegist
nRegist := nRegist + 1
nRegx := ASCAN(aRegsAll, {|x| x[1] == TIPOREG})
IF NREGX == 0
   IF !( TIPOREG $ "10.11.90" )
      AADD(aRegsAll, { TIPOREG, 1})
   ENDIF
Else
   aRegsAll[nRegx,2] := aRegsAll[nRegx,2] + 1
ENDIF
MsUnlock()

cRegistro := "88"                                                         //01.Tipo
cRegistro := cRegistro +  "05"                                            //02.Detalhe
cRegistro := cRegistro +  a940Fill(nGet0503,14)                           //03.CPF/CGC do Contador
cRegistro := cRegistro +  a940Fill(nGet0504,10)                           //04.CRC do Contador
cRegistro := cRegistro +  a940Fill(nGet0505,40)                           //05.Nome (Razao) do Contador
cRegistro := cRegistro +  a940Fill(nGet0506,12)                           //06.Telefone do Contador
cRegistro := cRegistro +  a940Fill(nGet0507,40)                           //07.E-mail do Contador
cRegistro := cRegistro +  Space(06)                                       //08.Brancos

RecLock("GIM",.T.)
nReg88 := nReg88 + 1
GIM->NUMDISK := nDISK
GIM->TIPOREG := SubStr(cRegistro,01,002)
GIM->C := SubStr(cRegistro,03,016)
GIM->D := SubStr(cRegistro,17,026)
GIM->E := SubStr(cRegistro,27,030)
GIM->F := SubStr(cRegistro,31,038)
GIM->G := SubStr(cRegistro,39,126)
GIM->H := nRegist
nRegist := nRegist + 1
nRegx := ASCAN(aRegsAll, {|x| x[1] == TIPOREG})
IF NREGX == 0
   IF !( TIPOREG $ "10.11.90" )
      AADD(aRegsAll, { TIPOREG, 1})
   ENDIF
Else
   aRegsAll[nRegx,2] := aRegsAll[nRegx,2] + 1
ENDIF
MsUnlock()

cRegistro := "88"                                          	//01.Tipo
cRegistro := cRegistro +  "06"                                            //02.Detalhe
cRegistro := cRegistro +  a940Fill(A940Num2Chr(Val(cInsc),9,0),9)         //03.Insc. Estadual
cRegistro := cRegistro +  a940Fill(StrZero(Year(mv_Par01),4),4)           //04.Periodo de Referencia
cRegistro := cRegistro +  a940Fill(if(mv_Par15==1,"N", "R"),1)            //05.Tipo "N"ormal/"R"etificada
cRegistro := cRegistro +  a940Fill(A940Num2Chr(nGet0606,13,2),13)         //06.Estoque tributavel
cRegistro := cRegistro +  a940Fill(A940Num2Chr(nGet0607,13,2),13)         //07.Estoque nao tributavel
cRegistro := cRegistro +  a940Fill(A940Num2Chr(nGet0608,13,2),13)         //08.Estoque de substituicao tributaria
cRegistro := cRegistro +  a940Fill(A940Num2Chr(nGet0609,13,2),13)         //09.Saldo em caixa
cRegistro := cRegistro +  a940Fill(A940Num2Chr(nGet0610,13,2),13)         //10.Saldo em bancos
cRegistro := cRegistro +  a940Fill(A940Num2Chr(nGet0611,13,2),13)         //11.Despesas com pessoal, terc., pro-labore
cRegistro := cRegistro +  a940Fill(A940Num2Chr(nGet0612,13,2),13)         //12.Outros impostos e encargos
cRegistro := cRegistro +  a940Fill(A940Num2Chr(nGet0613,13,2),13)         //13.Despesas gerais
cRegistro := cRegistro +  Space(04)                                       //14.Brancos

RecLock("GIM",.T.)
nReg88 := nReg88 + 1
GIM->NUMDISK := nDISK
GIM->TIPOREG := SubStr(cRegistro,01,002)
GIM->C := SubStr(cRegistro,03,016)
GIM->D := SubStr(cRegistro,17,026)
GIM->E := SubStr(cRegistro,27,030)
GIM->F := SubStr(cRegistro,31,038)
GIM->G := SubStr(cRegistro,39,126)
GIM->H := nRegist
nRegist := nRegist + 1
nRegx := ASCAN(aRegsAll, {|x| x[1] == TIPOREG})
IF NREGX == 0
   IF !( TIPOREG $ "10.11.90" )
      AADD(aRegsAll, { TIPOREG, 1})
   ENDIF
Else
   aRegsAll[nRegx,2] := aRegsAll[nRegx,2] + 1
ENDIF
MsUnlock()

cRegistro := "90"                                                                 //01.Tipo
cRegistro := cRegistro + a940Fill(A940Num2Chr(Val(SM0->M0_CGC),14,0),14)          //02.CGC
cRegistro := cRegistro + a940Fill(A940RETDIG(SM0->M0_INSC,.t.,SM0->M0_ESTENT),14) //03.Inscr. Estadual
FOR I:= 1 TO LEN(aRegsAll)
    cRegistro := cRegistro + Alltrim(aRegsAll[I,1]) + strzero(aRegsAll[I,2],8)
NEXT
cRegistro := cRegistro + "99"
cRegistro := cRegistro + A940Fill(StrZero(nRegist,8),8)
cRegistro := cRegistro + a940Fill(,(125-Len(cRegistro))) // Brancos ate registro final
cRegistro := cRegistro + Alltrim(Str(1))                 // Nro registro tipo 90

RecLock("GIM",.T.)
GIM->NUMDISK := nDISK
GIM->TIPOREG := "90"
GIM->C := SubStr(cRegistro,03,016)
GIM->D := SubStr(cRegistro,17,026)
GIM->E := SubStr(cRegistro,27,030)
GIM->F := SubStr(cRegistro,31,038)
GIM->G := SubStr(cRegistro,39,087)
GIM->G := Left(GIM->G,87)+"1"

GIM->H := nRegist
MsUnlock()


DBCLOSEAREA("GIM")
dbUseArea(.T.,__LocalDriver,cARQTEMP,cARQTEMP,.T.,.F.)
DbSelectArea(cARQTEMP)
DbClearIndex()
DbSetIndex(cArq01+OrdBagExt())
DbSetIndex(cArq02+OrdBagExt())
DbSetIndex(cArq03+OrdBagExt())
DbSetIndex(cArq04+OrdBagExt())
DbSetIndex(cArq05+OrdBagExt())

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³a940Relat   ³ Autor ³ Andreia dos Santos  ³ Data ³ 07/01/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprime relatorio de conferencia                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Titulo := "Listagem de acompanhamento"
cDesc1 := "Listagem de acompanhamento do arquivo pr‚-formatado."
cDesc2 := ""
cDesc3 := ""
Tamanho := "P"
Limite := 80
nTipo := 18
cabec1 := ''
cabec2 := ''
cabec3 := ''
cbCont := 0
cbtxt := Space(10)
m_pag := 1
cPerg := "MTA940"
cString := "SF3"
lEnd := .f.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cperg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLastKey := 0
	
wnrel := SetPrint(cString,"GIM2001",cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.)
If nLastKey==27
   Return
Endif
SetDefault(aReturn,cString)
If nLastKey==27
   Return
Endif
	
nCnt01 :=	1
nCnt02 := 1
cTipo := ""
nReg90 := 1
	
dbSelectArea(cArqTemp)
dbSetOrder(1)
	
cREG := ""
If dbSeek("90",.F.)
   cReg := F+G
EndIf
	
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
nLin:=Prow()+1
@ nLin,00 PSAY Replic("*",80)
nLin	:= nLin + 2
@ nLin,15 PSAY "C.G.C.(MF)........: "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")
nLin	:= nLin + 1
@ nLin,15 PSAY "Inscricao Estadual: "+SM0->M0_INSC
nLin	:= nLin + 1
@ nLin,15 PSAY "Razao Social......: "+SM0->M0_NOMECOM
nLin	:= nLin + 1
@ nLin,15 PSAY "Endereco..........: "+SM0->M0_ENDENT
nLin	:= nLin + 1
@ nLin,15 PSAY "                    "+SM0->M0_CIDENT+" - "+SM0->M0_ESTENT+" - CEP: "+Transform(SM0->M0_CEPENT,"@R 99999-999")
nLin	:= nLin + 2
@ nLin,15 PSAY "Equipamento.......: "+cEquip
nLin	:= nLin + 1
@ nLin,15 PSAY "Meio Magnetico....: "+If(nMeioMag<=4,"Disquete","Fita")
nLin	:= nLin + 1
@ nLin,15 PSAY "Fator de Bloco....: "+cFatBloc
nLin	:= nLin + 2
@ nLin,15 PSAY "Periodo abrangido.: "+DTOC(dDtIni)+" a "+DTOC(dDtFim)
nLin	:= nLin + 1
@ nLin,15 PSAY "Tipo 10...........: "+Str(1,8)	   +" Registro"
nLin	:= nLin + 1
@ nLin,15 PSAY "Tipo 11...........: "+Str(1,8)	   +" Registro"
nLin	:= nLin + 1
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime somente itens existentes no arq. magnetico           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ntotreg := 2
For I := 1 to len(aRegsAll)
   @ nLin,15 PSAY "Tipo "+ aRegsAll[I,1] +"...........: "+Str(aRegsAll[i,2],8)   +" Registro(s)"
   ntotReg := ntotreg + aRegsAll[i,2]
   nlin := nlin + 1
Next

@ nLin,15 PSAY "Tipo 90...........: "+Str(1,8)	  +" Registros"
nLin := nlin + 1
@ nLin,15 PSAY "Total de registros: "+Str(nTotReg)+" Registros"
nLin := nlin + 1
	
If nTotReg>0
   roda(cbcont,cbtxt,tamanho)
Endif
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Spool de Impressao                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFNDEF WINDOWS
   Set Device to Screen
#ENDIF
Set Printer to
If aReturn[5] == 1
   dbcommitAll()
   ourspool(wnrel)
Endif
	
wnrel := "MATA940"
Return .t.

