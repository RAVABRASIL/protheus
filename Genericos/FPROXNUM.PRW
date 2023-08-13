#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FPROXNUM  º Autor ³                    º Data ³  21/02/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ AJUSTA O PARAMETRO MV_DOCSEQ PARA AS "EMPRESAS" 01 E 02    º±±
±±º          ³ E RETORNA O VALOR PARA O SISTEMA.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FPROXNUM()

//VARIAVEIS DO PROGRAMA
Local _C1,_C2,_cDocSeq

If File( "\SIGAADV2\SX6" + cEMPANT + "0.DBF" )

  //ABRE OS ARQUIVOS.

  //ABRE SX6 DA BASE SIGAADV COM ALIAS SX6A
  dbUseArea(.T.,"DBFCDXAX","\SIGAADV\SX6" + cEMPANT + "0","SX6A",.T.,.F.)
  DbSelectArea("SX6A")
  DbSetIndex("\SIGAADV\SX6" + cEMPANT + "0")
  DbSetOrder(1)

  //ABRE SX6 DA BASE SIGATST COM ALIAS SX6B
  dbUseArea(.T.,"DBFCDXAX","\SIGAADV2\SX6" + cEMPANT + "0","SX6B",.T.,.F.)
  DbSelectArea("SX6B")
  DbSetIndex("\SIGAADV2\SX6" + cEMPANT + "0")
  DbSetOrder(1)

  DBSELECTAREA("SX6A")
  DBSEEK (xFILIAL()+("MV_DOCSEQ"))
  _C1:=AllTrim( SX6A->X6_CONTEUD)

  DBSELECTAREA("SX6B")
  DBSEEK (xFILIAL()+("MV_DOCSEQ"))
  _C2:=AllTrim( SX6B->X6_CONTEUD)

  IF _C1>_C2
    _cDocSeq:=_C1
    DBSELECTAREA("SX6B")
    RecLock("SX6B",.F.)
    SX6B->X6_CONTEUD:=_cDocSeq
  //  MsUnLock()
  ELSE
    _cDocSeq:=_C2
    DBSELECTAREA("SX6A")
    RecLock("SX6A",.F.)
    SX6A->X6_CONTEUD:=_cDocSeq
  //  MsUnLock()
  ENDIF

  //FECHA OS ARQUIVOS CRIAR.

  Dbselectarea("SX6A")
  Dbclosearea()

  Dbselectarea("SX6B")
  Dbclosearea()
EndIf

Return(_cDocSeq)     //RETORNA O NUMERO DO DOCSEQ.
