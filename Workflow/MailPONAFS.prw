#INCLUDE "protheus.CH"
#INCLUDE "topconn.CH"
#INCLUDE "tbiconn.CH"

User Function MailPNF()

  If Select( 'SX2' ) == 0
    // A rotina abaixo tem como finalidade preparar o ambiente caso não se execute o workflow
    // através de Menu
    RPCSetType( 3 ) // Não consome licensa de uso
    PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "MailPNF" Tables "SRA", "SR6", "Z05"
    sleep( 5000 ) // aguarda 5 segundos para que as jobs IPC subam.
    conOut( "Programa MailPNF na emp. 02 filial 01 " + Dtoc( Date() ) + ' - ' + Time() )
  Else
    conOut( "Programa MailPNF sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  EndIf

  conOut( "Programa relatório de " + DtoC( Date() ) + " - " + Time() )

  cQuery := "select  Z05.Z05_MATRIC, SRA.RA_NOME, Z05.Z05_TIPO, SR6.R6_DESC "
  cQuery += "from "+ RetSqlName("Z05") +" Z05, "+ RetSqlName("SRA") +" SRA, " + RetSqlName("SR6") + " SR6 "
  cQuery += " where " 
  cQuery += " Z05.Z05_DATA >= '"+ alltrim(dtos(date())) +"' and Z05.Z05_DATA <= '"+ alltrim(dtos(date())) +"'  and "
  //cQuery += " Z05.Z05_DATA >= '20120101' and "
  cQuery += " SRA.RA_TNOTRAB = SR6.R6_TURNO and Z05.Z05_MATRIC = SRA.RA_MAT "
  cQuery += " and Z05.Z05_FILIAL = '" + xFilial("Z05") + "' and SRA.RA_FILIAL = '" + xFilial("SRA") + "' and SR6.R6_FILIAL = '"+ xFilial("SR6") +"' "
  cQuery += " and Z05.D_E_L_E_T_ = ' ' and SRA.D_E_L_E_T_ = ' ' and SR6.D_E_L_E_T_ = ' ' "
  cQuery += " order by Z05.Z05_MATRIC, SRA.RA_NOME"  
  MemoWrite("\TEMP\MAILPONAFS.SQL", cQuery )
  cQuery := ChangeQuery( cQuery )
  TCQUERY cQuery NEW ALIAS "QRY"
  QRY->( DbGoTop() )

  IF ! QRY->( EOF() )

    oProcess := TWFProcess():New("MAILPNF", "Relat. de advertências.")
    oProcess:NewTask('Inicio', "\workflow\http\emp01\ponafs.htm")
    oHTML := oProcess:oHTML

    oHtml:ValByName( "cMes", MesExtenso( date() ) )
    oHtml:ValByName( "nDia", day( date() ) )
    oHtml:ValByName( "nAno", year( date() ) )

    while ! QRY->( EOF() )
      aadd( oHTML:ValByName( "it.cMatric" ), alltrim(QRY->Z05_MATRIC) )
      aadd( oHTML:ValByName( "it.cNome"   ), alltrim(QRY->RA_NOME)    )
      aadd( oHTML:ValByName( "it.cTipo"   ), alltrim(QRY->Z05_TIPO)   )
      aadd( oHTML:ValByName( "it.cDesc"   ), alltrim(QRY->R6_DESC)    )
      QRY->( DbSkip() )
    EndDo

    oProcess:cTo  := "rh@ravaembalagens.com.br"  //"rh@ravaembalagens.com.br"
    oProcess:cCC  := "flavia.rocha@ravaembalagens.com.br"
    oProcess:cSubject := "Relatório de advertências, faltas e suspensões."
    oProcess:Start()
    WFSendMail()
    Sleep( 1500 )
    oProcess:Finish()

  ENDIF

  QRY->( DbCloseArea() )

Return Nil
