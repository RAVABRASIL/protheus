#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function FATEST()

	cAlias := Alias()
	aTmp := {}
  /*Voltando dois meses a partir da data base do SIGA*/
  dAux := dDatabase - day(dDataBase)
  dAux := dAux - day(dAux)

  cDataI := alltrim(substring(dtos(dAux),1,6)+"01")
  cDataF := dtos(dAux)

  nTot := 0
  nCount := 1

  while nCOunt <= 6

    cQuery := "select (sum(SI2.I2_VALOR) - "
    cQuery += "(select  sum(SI2.I2_VALOR) "
    cQuery += "from "+ RetSqlName("SI2") +" SI2 "
    cQuery += "where   (SI2.I2_CREDITO = '4715017010' "
    cQuery += "or SI2.I2_CREDITO between '4713047000' and '4713047020' "
    cQuery += "or SI2.I2_CREDITO between '4712017000' and '4712127020') "
    cQuery += "and SI2.I2_DATA >= '"+cDataI+"' and SI2.I2_DATA <= '"+cDataF+"' "
    cQuery += "and SI2.D_E_L_E_T_ = ' ' and SI2.I2_FILIAL = '"+xFilial("SI2")+"' ))"
    cQuery += "/(select sum(Z00.Z00_PESO)"
		cQuery += "+"
		cQuery += "(SELECT sum(Z00.Z00_PESO) "
		cQuery += "FROM "+RetSqlName("Z00")+" Z00 " //dataf + 1
		cQuery += "WHERE Z00.Z00_DATA >= '"+ dtos((stod(cDataF) + 1)) +"' AND Z00.Z00_DATA <= '"+ dtos((stod(cDataF) + 1)) +"' "
	  cQuery += "AND Z00.Z00_MAQ IN ('E01','E02','E03') and Z00.Z00_HORA >= '00:00' and Z00.Z00_HORA <= '05:29' "
	  cQuery += "AND Z00.Z00_FILIAL = '  ' AND Z00.D_E_L_E_T_ = ' ')"
		cQuery += "-"
		cQuery += "(SELECT sum(Z00.Z00_PESO) "
		cQuery += "FROM "+RetSqlName("Z00")+" Z00 " //datai
		cQuery += "WHERE Z00.Z00_DATA >= '"+cDataI+"' AND Z00.Z00_DATA <= '"+cDataI+"' "
		cQuery += "AND Z00.Z00_MAQ IN ('E01','E02','E03') and Z00.Z00_APARA != ' ' "
		cQuery += "AND Z00.Z00_FILIAL = '  ' AND Z00.D_E_L_E_T_ = ' ')"
    cQuery += "from "+ RetSqlName("Z00") +" Z00 "
    cQuery += "where Z00.Z00_MAQ IN ('E01','E02','E03')"
    cQuery += "and Z00.Z00_DATA >= '"+cDataI+"' AND Z00.Z00_DATA <= '"+cDataF+"' "
    cQuery += "and Z00.Z00_FILIAL = '  ' AND Z00.D_E_L_E_T_ = ' ' ) as result "
    cQuery += "from "+ RetSqlName("SI2") +" SI2 "
    cQuery += "where substring(SI2.I2_DEBITO, 1, 2) = '47' and  SI2.I2_DEBITO not in ('4711017010', '4711027010', '4711037010')"
    cQuery += "and SI2.I2_DATA >= '"+cDataI+"' and SI2.I2_DATA <= '"+cDataF+"' "
    cQuery += "and SI2.D_E_L_E_T_ = ' ' and SI2.I2_FILIAL = '"+xFilial("SI2")+"'"

    cQuery := ChangeQuery( cQuery )
    TCQUERY cQuery NEW ALIAS "TMP"

    TMP->( DbGoTop() )

		DO CASE
			CASE (year(stod(cDataF)) == 2006 ) .AND. (month(stod(cDataF)) ==  7 )
				nTot += 1.2332
			CASE (year(stod(cDataF)) == 2006 ) .AND. (month(stod(cDataF)) ==  6 )
				nTot += 0.9946
			CASE (year(stod(cDataF)) == 2006 ) .AND. (month(stod(cDataF)) ==  5 )
				nTot += 1.2800
			CASE (year(stod(cDataF)) == 2006 ) .AND. (month(stod(cDataF)) ==  4 )
				nTot += 1.4003
			CASE (year(stod(cDataF)) == 2006 ) .AND. (month(stod(cDataF)) ==  3 )
				nTot += 1.1911
			CASE (year(stod(cDataF)) == 2006 ) .AND. (month(stod(cDataF)) ==  2 )
				nTot += 1.4548
			OTHERWISE
				nTot += TMP->result
		ENDCASE

    TMP->( DbCloseArea() )

    /*Voltando um mês*/
    dAux := dAux - day(dAux)
    cDataI := alltrim(substring(dtos(dAux),1,6)+"01")
    cDataF := dtos(dAux)

    nCount++

  EndDo

	DBSelectArea( cAlias )

Return (nTot/6)
