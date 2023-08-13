#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF


user Function FATRNF()

  tamanho   := "M"
  titulo    := PADC("Relatorio de Notas Fiscais", 74)
  cDesc1    := PADC("Relatorio de Notas Fiscais", 74)
  cDesc2    := PADC("", 74)
  cDesc3    := PADC("", 74)
  cNatureza := ""
  aReturn   := { "Faturamento", 1,"Administracao", 1, 2, 1,"",1 }
  nomeprog  := "FATRNF"
  cPerg     := "FATRNF"
  nLastKey  := 0
  lContinua := .T.
  nLin      := 9
  wnrel     := "FATRNF"
  M_PAG     := 1

  Pergunte( cPerg, .F. )
  cString := "SB1"

  wnrel := SetPrint( cString, wnrel, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho )

  If nLastKey == 27
     Return
  Endif

  SetDefault( aReturn, cString )

  If nLastKey == 27
     Return
  Endif

  #IFDEF WINDOWS
     RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
     Return
    // Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Function RptDetail
    Static Function RptDetail()
  #ENDIF

  /*******QUERY********/

  cQuery := "select   distinct SA1.A1_NREDUZ, SA1.A1_TEL, SA1.A1_MUN, "
  cQuery += "SF2.F2_DOC, SF2.F2_EMISSAO, SA4.A4_NREDUZ, SA1.A1_CONTATO, SZZ.ZZ_PRZENT "
  cQuery += "from "+ RetSqlName("SA1") + " SA1, " + RetSqlName("SF2") +" SF2, " + RetSqlName("SA4") + " SA4, " + RetSqlName("SZZ") + " SZZ "
  cQuery += "where SF2.F2_CLIENTE = SA1.A1_COD and SF2.F2_EMISSAO >= '" + Dtos(mv_par01) + "' and SF2.F2_EMISSAO <= '" + Dtos(mv_par02) + "' "
  cQuery += "and SF2.F2_TRANSP = SA4.A4_COD and SF2.F2_TRANSP = SZZ.ZZ_TRANSP "
  cQuery += "and SA1.A1_MUN = substring(SZZ.ZZ_DESC, 1, len(SA1.A1_MUN))"
  cQuery += "and SA1.D_E_L_E_T_ = ' ' and SF2.D_E_L_E_T_ = ' '  and SA4.D_E_L_E_T_  = ' ' "
  cQuery += "and SA1.A1_FILIAL  = ' ' and SF2.F2_FILIAL  = '"+XFILIAL('SF2')+"' and SA4.A4_FILIAL = ' ' "
// 
  cQuery += " AND SZZ.ZZ_FILIAL='"+XFILIAL('SZZ')+"' "
//
  cQuery += "order by SF2.F2_DOC, SF2.F2_EMISSAO, SA1.A1_NREDUZ"
  cQuery := ChangeQuery( cQuery )
  TCQUERY cQuery NEW ALIAS "SFFA"
  TCSetField( 'SFFA', "A1_NREDUZ", "C" )
  TCSetField( 'SFFA', "F2_EMISSAO", "D")


  /******CABECARIO*******/

  cCabec_01 := "       CLIENTE     |   TELEFONE      |     CIDADE           | NOTA FISC. |  EMISSAO | TRANSPORTADORA  |   RESPONSAVEL   | PRAZO |"
  //             BAHIA BRILHO COML  (71) 3345-3460        SALVADOR            01253456     01/02/03   BONFIM CARGAS     FERNANDO MENDES    2
  //           01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
  //           0         1         2         3         4         5         6         7         8         9        10        11        12        13        14

  SFFA->(  DBGoTop() )

  Cabec( titulo, "", "", nomeprog, tamanho, 15 )
  @ Prow() + 1, 000 PSay cCabec_01
  @ Prow() + 1, 000 PSay Repl( '*', 132 )

  while !SFFA-> ( EOF() )
    @ PRow() + 1, 001 PSay substr(SFFA->A1_NREDUZ,1,17)
    @ PRow()    , 020 PSay substr(SFFA->A1_TEL,   1,15)
    @ PRow()    , 039 PSay substr(SFFA->A1_MUN,   1,20)
    @ PRow()    , 063 PSay SFFA->F2_DOC
    @ PRow()    , 076 PSay SFFA->F2_EMISSAO
    @ PRow()    , 087 PSay SFFA->A4_NREDUZ
    @ PRow()    , 105 PSay SFFA->A1_CONTATO
    @ PRow()    , 124 PSay SFFA->ZZ_PRZENT

    If Prow() > 58
      Cabec( titulo, "", "", nomeprog, tamanho, 15 )  //Impressao do cabecalho em nova pagina
      @ Prow() + 1,000 PSay cCabec_01
      @ Prow() + 1,000 PSay Repl( '*', 132 )
    EndIf

    SFFA->( DBSkip() )

  EndDo

  If aReturn[5] == 1
     Set Printer To
     Commit
     ourspool( wnrel ) //Chamada do Spool de Impressao
  Endif

   SFFA->( DBCloseArea() )
   MS_FLUSH()

Return Nil
