#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCD00001   บ Autor ณ Eurivan Marques    บ Data ณ  16/03/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gera arquivo par EDI com CD - Sใo Paulo                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Faturamento                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function CD00001()

Private cPerg   := "CD00001"
Private oGeraTxt

Private cString := "SA1"

dbSelectArea("SA1")
dbSetOrder(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Gerao de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira gerar um arquivo texto, conforme os parame- "
@ 18,018 Say " tros definidos  pelo usuario,  com os registros do arquivo de "
@ 26,018 Say "                                                               "

@ 65,095 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 65,125 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 65,155 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ OKGERATXTบ Autor ณ AP5 IDE            บ Data ณ  16/03/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamenบฑฑ
ฑฑบ          ณ to. Executa a geracao do arquivo texto.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function OkGeraTxt

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria o arquivo texto                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private nSequen := getMV("MV_SEQADE")
Private cArqTxt := "C:\E"+substr(dtos(dDataBase),3,2) + substr(dtos(dDataBase),5,2) + substr(dtos(dDataBase),7,2)+alltrim(str(nSequen))+".TXT"
Private nHdl    := fCreate(cArqTxt)

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
    Return
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa a regua de processamento                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Processa({|| RunCont() },"Processando...")
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RUNCONT  บ Autor ณ AP5 IDE            บ Data ณ  16/03/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunCont

Local nTamLin, cLin, cCpo, cQuery

cQuery := "SELECT '0' AS CPO1, 'I' AS CPO2, F2_DOC, A1_CGC, '' AS CGC_RAVA, F2_EMISSAO, F2_HORA, "
cQuery += "F2_SERIE, '   ' AS SUBSERIE, '          ' AS DOCENT, '        ' AS DTENT, '      ' AS HRENT, "
cQuery += "'   ' AS SERENT, '   ' AS SSERENT, 'NF' AS DIVDOC, '0' AS TPDOC "
cQuery += "FROM "+RetSqlName("SF2")+" SF2, "+RetSqlName("SA1")+" SA1 "
cQuery += "WHERE F2_EMISSAO between '"+dtos(mv_par09)+"' and '"+dtos(mv_par10)+"' AND F2_SERIE between '"+MV_PAR01+"' and '"+MV_PAR02+"' AND " 
cQuery += "F2_DOC between '"+MV_PAR03+"' and '"+MV_PAR04+"' AND F2_LOJA between '"+MV_PAR05+"' and '"+MV_PAR06+"' AND "
cQuery += "F2_CLIENTE between '"+MV_PAR07+"' and '"+MV_PAR08+"' AND "
cQuery += "A1_COD+A1_LOJA = F2_CLIENTE+F2_LOJA "
cQuery += "AND F2_SERIE <> '' AND SA1.D_E_L_E_T_ = '' AND SF2.D_E_L_E_T_ = '' "
TCQUERY cQuery NEW ALIAS "XF2"

DbSelectArea("XF2")
ProcRegua(0) 

while !XF2->(EOF())
    IncProc()

    nTamLin := 93
    cLin    := Space(nTamLin)+cEOL

    cCpo := PADR(XF2->CPO1,01)//Indicador
    cLin := Stuff(cLin,01,01,cCpo)

    cCpo := PADR(XF2->CPO2,01)//Indicador
    cLin := Stuff(cLin,02,01,cCpo)

    cCpo := StrZero(Val(XF2->F2_DOC),10)//Nบ da nota fiscal
    cLin := Stuff(cLin,03,10,cCpo)

    cCpo := PADR(XF2->A1_CGC,14)//CNPJ do cliente
    cLin := Stuff(cLin,13,14,cCpo)

    cCpo := PADR(SM0->M0_CGC,14)//CNPJ do fornecedor
    cLin := Stuff(cLin,27,14,cCpo)

    cCpo := substr(XF2->F2_EMISSAO,7,2) + substr(XF2->F2_EMISSAO,5,2) + substr(XF2->F2_EMISSAO,1,4)//Data de emissใo
    cLin := Stuff(cLin,41,8,cCpo)
                                        //Segundos
    cCpo := STRTRAN(XF2->F2_HORA,":","")+"00"//Data de emissใo
    cLin := Stuff(cLin,49,6,cCpo)
  
    cCpo := PADR(XF2->F2_SERIE,03)//S้rie
    cLin := Stuff(cLin,55,3,cCpo)
    
    /*cCpo := Space(3)//Sub-S้rie
    cLin := Stuff(cLin,58,3,cCpo)
    
    cCpo := Space(10)//Nบ documento de entrada do fornecedor
    cLin := Stuff(cLin,61,10,cCpo)
    
    cCpo := space(8)//Dt. Emissใo
    cLin := Stuff(cLin,71,8,cCpo)
       
    cCpo := space(6)//Hora Emissใo
    cLin := Stuff(cLin,79,6,cCpo)
    
    cCpo := space(3)//S้rie doc. fornecedor
    cLin := Stuff(cLin,85,3,cCpo)
    
    cCpo := space(3)//Sub-s้rie doc. fornecedor
    cLin := Stuff(cLin,88,3,cCpo)*/

    if fWrite(nHdl,cLin,len(cLin)) != len(cLin)
        if !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
            exit
        endif
    endif

    cQuery := "SELECT '1' AS CPO1, D2_COD, D2_QUANT, D2_PRCVEN, '          ' AS LOTE "
    cQuery += "FROM "+RetSqlName("SD2")+" SD2 "
    cQuery += "WHERE D2_DOC = '"+XF2->F2_DOC+"' AND D2_SERIE = '"+XF2->F2_SERIE+"' AND "
    cQuery += "D2_EMISSAO = '"+XF2->F2_EMISSAO+"' AND "
    cQuery += "SD2.D_E_L_E_T_ = '' "
    TCQUERY cQuery NEW ALIAS "XD2"
    while !XD2->(EOF())
       cLin := Space(nTamLin)+cEOL

	   cCpo := PADR(XD2->CPO1,01)//Indicador
       cLin := Stuff(cLin,01,01,cCpo)

	   cCpo := PADR(XD2->D2_COD,15)//C๓digo do produto
       cLin := Stuff(cLin,02,15,cCpo)
       
   	   cCpo := strZero( Round(qtdPaco(XD2->D2_COD, XD2->D2_QUANT),3) * 1000, 13 )//Quantidade
	   cLin := Stuff(cLin,17,13,cCpo)
	   
   	   cCpo := strZero( Round(XD2->D2_PRCVEN,2) * 100, 11 )//Valor unitแrio
	   cLin := Stuff(cLin,30,11,cCpo)
	   
   	   /*cCpo := space(10)//Lote
       cLin := Stuff(cLin,41,10,cCpo)
       
   	   cCpo := space(8)//Validade
       cLin := Stuff(cLin,51,8,cCpo)
       
   	   cCpo := space(8)//Fabrica็ใo
       cLin := Stuff(cLin,59,8,cCpo)*/

       if fWrite(nHdl,cLin,len(cLin)) != len(cLin)
          if !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
             exit
          endif
       endif

       XD2->(DbSkip())
    end
    XD2->(DbCloseArea())


    XF2->(DbSkip())
end

XF2->(DbCloseArea())

fClose(nHdl)
Close(oGeraTxt)
putMV( "MV_SEQADE", ++nSequen )

return

***************

Static Function qtdPaco(cProd, nQuant)

***************
Local nQtdPaco := 0
SB5->( dbSetOrder(1) )
if SB5->( dbSeek( xFilial("SB5") + cProd, .F. ) )
	msgAlert("Nใo ้ possํvel achar o produto " + cProd)
	Break
endIf

if SB5->B5_QTDEMB <= 0
	msgAlert("Aten็ใo: B5_QTDEMB <= 0 ! ! ! " + cProd )
else
	nQtdPaco := (nQuant * SB5->B5_QE2)/SB5->B5_QTDEMB
endIf

Return nQtdPaco