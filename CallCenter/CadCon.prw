User Function CadCon()

local cCLI
local cARQTMP := "CONTATOS.DBF"

DbSelectArea("SA1")
DbSetOrder(1)

DbUseArea( .T.,, cARQTMP, "CTOX", .F., .F. )
//Index On Str(CLIENTE) To &cARQTMP

//DbSelectArea("CTOX")
CTOX->(DbGotop())

while !CTOX->(EOF())

   cCLI := StrZero(CTOX->CLIENTE,6)

   if SA1->(DbSeek(xFilial("SA1")+cCli+CTOX->LOJA))
      RecLock("SU5", .T.)
      SU5->U5_FILIAL  := xFilial("SU5")
//      SU5->U5_CLIENTE := cCli
//      SU5->U5_LOJA    := CTOX->LOJA
      SU5->U5_CODCONT := GETSX8NUM("SU5","U5_CODCONT")
      SU5->U5_CONTAT  := CTOX->NOMTC1
      SU5->U5_CELULAR := AllTrim(CTOX->CELTC1)
      SU5->U5_DDD     := AllTrim(CTOX->DDDTC1)
      SU5->U5_EMAIL   := CTOX->MAILTC1
      SU5->U5_FCOM1   := AllTrim(CTOX->TELTC1)
      SU5->U5_NIVEL   := "07" //CONTATO TECNICO 01     
      SU5->(MsUnlock())
      CONFIRMSX8()
      CriaCont("SA1",cCli+CTOX->LOJA,SU5->U5_CODCONT)
     
      if !Empty(CTOX->NOMTC2) 
         RecLock("SU5", .T.)
         SU5->U5_FILIAL  := xFilial("SU5")
//         SU5->U5_CLIENTE := cCli
//         SU5->U5_LOJA    := CTOX->LOJA
         SU5->U5_CODCONT := GETSX8NUM("SU5","U5_CODCONT")
         SU5->U5_CONTAT  := CTOX->NOMTC2
         SU5->U5_CELULAR := AllTrim(CTOX->CELTC2)
         SU5->U5_DDD     := AllTrim(CTOX->DDDTC1)
         SU5->U5_EMAIL   := CTOX->MAILTC2
         SU5->U5_FCOM1   := AllTrim(CTOX->TELTC2)
         SU5->U5_NIVEL   := "07" //CONTATO TECNICO 02
         SU5->(MsUnlock())
         CONFIRMSX8()           
         CriaCont("SA1",cCli+CTOX->LOJA,SU5->U5_CODCONT)
      endif
      
      if !Empty(CTOX->NOMET1) 
         RecLock("SU5", .T.)
         SU5->U5_FILIAL  := xFilial("SU5")
//         SU5->U5_CLIENTE := cCli
//         SU5->U5_LOJA    := CTOX->LOJA
         SU5->U5_CODCONT := GETSX8NUM("SU5","U5_CODCONT")
         SU5->U5_CONTAT  := CTOX->NOMET1
         SU5->U5_CELULAR := AllTrim(CTOX->CELET1)
         SU5->U5_DDD     := AllTrim(CTOX->DDDTC1)
         SU5->U5_EMAIL   := CTOX->MAILET1
         SU5->U5_FCOM1   := AllTrim(CTOX->TELET1)
         SU5->U5_NIVEL   := "08" //CONTATO ESTRATEGICO 01
         SU5->(MsUnlock())
         CONFIRMSX8()           
         CriaCont("SA1",cCli+CTOX->LOJA,SU5->U5_CODCONT)   
      endif

      if !Empty(CTOX->NOMET2)
         RecLock("SU5", .T.)
         SU5->U5_FILIAL  := xFilial("SU5")
//         SU5->U5_CLIENTE := cCli
//         SU5->U5_LOJA    := CTOX->LOJA
         SU5->U5_CODCONT := GETSX8NUM("SU5","U5_CODCONT")
         SU5->U5_CONTAT  := CTOX->NOMET2
         SU5->U5_CELULAR := AllTrim(CTOX->CELET2)
         SU5->U5_DDD     := AllTrim(CTOX->DDDTC1)
         SU5->U5_EMAIL   := CTOX->MAILET2
         SU5->U5_FCOM1   := AllTrim(CTOX->TELET2)
         SU5->U5_NIVEL   := "08" //CONTATO ESTRATEGICO 02
         SU5->(MsUnlock())
         CONFIRMSX8()
         CriaCont("SA1",cCli+CTOX->LOJA,SU5->U5_CODCONT)
      endif
   endif
   CTOX->(DbSkip())
end

CTOX->(DbCloseArea())

Return

*******************************************************
static function CriaCont( cEntidade, cCodEnt, cCodCon )
*******************************************************

DbselectArea("AC8")
RecLock("AC8", .T.)
AC8->AC8_ENTIDA := cEntidade
AC8->AC8_CODENT := cCodEnt
AC8->AC8_CODCON := cCodCon
AC8->(MSUnLock())

return