#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"      

/*/
�����������������������������������������������������������������������������
���Descricao � Relatorio de consulta de atendimento do cliente            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Rava Embalagens                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function COBR09()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cString
Private aOrd := {}
Private CbTxt        := ""
Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2         := "de acordo com os parametros informados pelo usuario."
Private cDesc3         := "Consulta de atendimentos do cliente"
Private cPict          := ""
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "COBR09"// Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private titulo       := "Atendimentos do Cliente"
Private nLin         := 80
//Private Cabec1       := "Produto     Descri��o                                Cubagem  Estoque  Endereco        Ref  Cap (m3)  Util(m3)   Sobra  Taxa   "
//Private Cabec2       := "                                                       1(CX)    Atual  Utilizado            Endereco  Endereco    (m3)  Util(%)"
//                       1234567890  1234567890123456789012345678901234567890 999.999  999,999  123456789012345 999    999.99    999.99  999.99   999.99
//                       0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//                                 1         2         3         4         5         6         7         8         9         0         1         2 
Private Cabec1       := "Cliente     Nome                                                                                                                       "
Private Cabec2       := "Data        H. Inicio   H. Fim     Nome Atendente        Tipo Pesq.   Sequencia   Desri��o                               Qual.     Tipo"
//                       1234567890  12345678    12345678   12345678901234567890     123          123      1234567890123456789012345678901234567    1         1
//                       01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//                                 1         2         3         4         5         6         7         8         9         0         1         2         3
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private imprime      := .T.
Private wnrel        := "COBR09"// Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg        := "COBR09"
Private oLeTxt
Private cBuffer
Private cString      := "ZA2"

ValidPerg()     //Valida grupo de perguntas cPerg no SX1 se n�o achar cria

Pergunte(cPerg,.f.)  //Carregua perguntas

dbSelectArea("ZA2")
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP5 IDE            � Data �  02/01/03   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

//���������������������������������������������������������������������Ŀ
//� Monta a query no SQL com base nos par�metros definidos.            �
//�����������������������������������������������������������������������

dbSelectArea("ZA2")

For j := 1 to 2
	If j == 1
		_cQuery := "SELECT Count(*) REG "
	Else
		_cQuery := "SELECT * "
	Endif
  	_cQuery += "from "+RetSqlName("ZA2")+" "
   _cQuery += "where ZA2_CODCLI = '"+mv_par01+"' "
   _cQuery += "and ZA2_DTATEN >= '"+DTOS(mv_par02)+"' "
   _cQuery += "and ZA2_DTATEN <= '"+DTOS(mv_par03)+"' "
	_cQuery += "and D_E_L_E_T_ <> '*' "
	If j == 2
		_cQuery += "order by ZA2_DTATEN, ZA2_HRINI "
	Endif
	
	//Executa a Query no banco SQL
	TCQUERY _cQuery NEW ALIAS "ZA2TMP"
	
	If j == 1
		Dbselectarea("ZA2TMP")
		nTotReg := ZA2TMP->REG
		Dbclosearea()
	Endif
Next

Dbselectarea("ZA2TMP")
dbGoTop()

If Eof()
	Alert("Nenhum Registro encontrado. Rever parametros.")
	Dbclosearea("ZA2TMP")
	Return
Endif   

//Inicializa regua
SetRegua(nTotReg)

//���������������������������������������������������������������������Ŀ
//� Imprime os dados do cliente na 1� p�gina...                         �
//�����������������������������������������������������������������������
@ nlin, 000 pSay ZA2TMP->ZA2_CODCLI
@ nlin, 012 pSay ZA2TMP->ZA2_NOMCLI
nlin ++
nlin ++

While !Eof()
 
   //���������������������������������������������������������������������Ŀ
   //� Verifica o cancelamento pelo usuario...                             �
   //�����������������������������������������������������������������������
	Incproc()
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif

   //���������������������������������������������������������������������Ŀ
   //� INCREMENTA A REGUA                                                  �
   //�����������������������������������������������������������������������
   INCREGUA()

   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������
	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
		@ nlin, 000 pSay ZA2TMP->ZA2_CODCLI
      @ nlin, 012 pSay ZA2TMP->ZA2_NOMCLI
      nlin ++
      nlin ++
	Endif

   cDescricao := ''

   If ZA2TMP->ZA2_PRIOR == 'CRD'
   	cDescricao := "CREDITO"
   ElseIf ZA2TMP->ZA2_PRIOR == 'CLI'
      cDescricao := "CLIENTE"   
   ElseiF ZA2TMP->ZA2_PRIOR == 'P1 '
      cDescricao := "Codigo Cliente"
   ElseiF ZA2TMP->ZA2_PRIOR == 'P2 '
      cDescricao := "Nome Cliente"
   ElseiF ZA2TMP->ZA2_PRIOR == 'P3 '
      cDescricao :="CGC / CPF"
   ElseiF ZA2TMP->ZA2_PRIOR == 'P4 '
      cDescricao := "Pedido"
   ElseiF ZA2TMP->ZA2_PRIOR == 'P5 '
      cDescricao := "T�tulo"
   ElseiF ZA2TMP->ZA2_PRIOR == 'P6 '
      cDescricao := "Valor"
   ElseiF ZA2TMP->ZA2_PRIOR == 'P7 ' 
      cDescricao := "Cidade"
   ElseiF ZA2TMP->ZA2_PRIOR == 'P8 '
      cDescricao := "Cod Identificador"
   ElseiF ZA2TMP->ZA2_PRIOR == 'P9 '
      cDescricao := "Nosso N�mero"
   ElseiF ZA2TMP->ZA2_PRIOR == 'P10'
      cDescricao := "Status Cob"
   ElseiF ZA2TMP->ZA2_PRIOR == 'P11'
      cDescricao := "Telefone"
   ElseiF ZA2TMP->ZA2_PRIOR == 'P12'
      cDescricao := "Grupo Empresarial"
   ElseiF ZA2TMP->ZA2_PRIOR == 'P13'
      cDescricao := "Representante"
   ElseiF ZA2TMP->ZA2_PRIOR == 'P14'
      cDescricao := "Retorno Agendado"
   ElseiF ZA2TMP->ZA2_PRIOR == 'P15'
      cDescricao := "D-(n Dias)"
   ElseiF ZA2TMP->ZA2_PRIOR == 'P16'
      cDescricao := "Acordo Agendado"
   ElseiF ZA2TMP->ZA2_PRIOR == 'P17'
      cDescricao := "Cheques"
   Else
      cQryZZ7 := "Select ZZ7_DESNAT, ZZ7_DESSTA "
      cQryZZ7 += "from "+RetSqlName("ZZ7")+" "
      cQryZZ7 += "where ZZ7_PRIORI = '"+ZA2TMP->ZA2_PRIOR+"' "
      cQryZZ7 += "and D_E_L_E_T_ <> '*'"
      
      TCQUERY cQryZZ7 NEW ALIAS "ZZ7TMP"
      
      Dbselectarea("ZZ7TMP")
      dbGoTop()
      cDescricao := trim(ZZ7TMP->ZZ7_DESNAT)
      cDescricao += ' - '
      cDescricao += trim(ZZ7TMP->ZZ7_DESSTA)
      DbCloseArea("ZZ7TMP")
      
      DbSelectArea("ZA2TMP")
      
   Endif
   
	@ nlin, 000 pSay STOD(ZA2TMP->ZA2_DTATEN)
	@ nlin, 012 pSay ZA2TMP->ZA2_HRINI
	@ nlin, 024 pSay ZA2TMP->ZA2_HRFIM
	@ nlin, 035 pSay ZA2TMP->ZA2_NOMATE
	@ nlin, 060 pSay ZA2TMP->ZA2_PRIOR
	@ nlin, 073 pSay ZA2TMP->ZA2_SEQUEN
	@ nlin, 082 pSay cDescricao
	@ nlin, 123 pSay ZA2TMP->ZA2_QUALI
	@ nlin, 133 pSay ZA2TMP->ZA2_TIPO
	nlin ++
   dbSkip()

/*
	cProd := BF_PRODUTO
	
	Dbselectarea("SB1")
	Dbsetorder(1)
	Dbseek(xFilial()+cProd)
	
	nCubProd  := B1_CUBAGEM
	nUnCxProd := B1_UNICX
	
	Dbselectarea("SB2")
	Dbsetorder(1)
	Dbseek(xFilial()+cProd+"01")
	
	nEstoque := B2_QATU

	//���������������������������������������������������������������������Ŀ
	//� Abate pedidos com Status > 202                                      �
	//�����������������������������������������������������������������������
	
	cQryPed := "Select Sum(C6_QTDEMP) PEDIDOS "
	cQryPed += " From "+RetSqlname("SC6")+" SC6, "+RetSqlname("SC5")+" SC5 "
	cQryPed += " Where C6_PRODUTO = '"+cProd+"'	"
	cQryPed += "   AND C6_FILIAL = '"+xFilial("SC6")+"' "
	cQryPed += "   AND C6_NUM = C5_NUM "
	cQryPed += "   AND C5_STATUS > '202' "
	cQryPed += "   AND C5_NOTA  = '' "
	cQryPed += "   AND C5_FILIAL = '"+xFilial("SC5")+"' "
	cQryPed += "   AND SC6.D_E_L_E_T_ = '' "		
	cQryPed += "   AND SC5.D_E_L_E_T_ = '' "		
	
	TCQUERY cQryPed NEW ALIAS "PED"
		
	dbselectarea("PED")
		
	nQtdPed := PED->PEDIDOS
		
	DbCloseArea()
	
	Dbselectarea("SB1")
	
	nEstoque -= nQtdPed
	
	//���������������������������������������������������������������������Ŀ
	//� Abate 2 cxs se o produto nao for caixa                              �
	//�����������������������������������������������������������������������
	
	nEstoque -= IIF( SB1->B1_UM == "CX" , 0 , 2*nUnCxProd )
	
	If nEstoque < 0
	   nEstoque := 0
	Endif   
	
	nCubEst := IIF(SB1->B1_UM == "CX", nEstoque*nCubProd, Round( nEstoque / SB1->B1_UNICX * nCubProd,0))
	
	nEstCx  := IIF(SB1->B1_UM == "CX", nEstoque, Round(nEstoque / SB1->B1_UNICX,0))
	
	dbselectarea("SBFTMP")
	nCubUtiTot := 0
	aLoc       := {}
	While !eof() .And. BF_PRODUTO == cProd
		
		//���������������������������������������������������������������������Ŀ
		//� Incrementa a regua                                                  �
		//�����������������������������������������������������������������������
		
      IncRegua()
		
		//���������������������������������������������������������������������Ŀ
		//� Conta numero de referencias no endereco em questao                  �
		//�����������������������������������������������������������������������
		Dbselectarea("SBF")
		cQryCont := "SELECT count( DISTINCT BF_PRODUTO ) CONTAR"
		cQryCont += "	FROM SBF010"
		cQryCont += "	WHERE SUBSTRING(BF_LOCALIZ,1,8) = '"+Substr(SBFTMP->BF_LOCALIZ,1,8)+"' "
		cQryCont += "	AND BF_LOCAL = '01'"
		cQryCont += "	AND BF_FILIAL = '"+xFilial("SBF")+"' "
		cQryCont += "	AND BF_PRIOR = 1"
		cQryCont += "	AND D_E_L_E_T_ = ''"
		
		TCQUERY cQryCont NEW ALIAS "CONTAR"
		
		dbselectarea("CONTAR")
		
		nRef := CONTAR->CONTAR
		
		DbCloseArea()
		
		//���������������������������������������������������������������������Ŀ
		//� Posiciona  no cadastro de capacidade cubica por rua/nivel           �
		//�����������������������������������������������������������������������
		
		Dbselectarea("ZAE") //Cubagem por rua/nivel/vao
		Dbsetorder(1)
		Dbseek(xFilial()+SUBSTR(SBFTMP->BF_LOCALIZ,1,2)+SUBSTR(SBFTMP->BF_LOCALIZ,7,2)+SUBSTR(SBFTMP->BF_LOCALIZ,4,2))
		
		nCubRua := ZAE->ZAE_CUBAGE
		
		nCubUti := Round(nCubRua/nRef,2)
		
		AADD( aLoc,{SBFTMP->BF_LOCALIZ, nRef, nCubUti})
		
		nCubUtiTot += nCubUti
		Dbselectarea("SBFTMP")
		dbSkip()
	End
	
	//���������������������������������������������������������������������Ŀ
	//� Verifica se a taxa de utiliza��o esta dentro do solicitado          �
	//�����������������������������������������������������������������������
	If (nCubEst/nCubUtiTot)*100 > mv_par01
		loop
	Endif
	
	//���������������������������������������������������������������������Ŀ
	//� Verifica se filtra produtos com mais de um endere�o.                �
	//�����������������������������������������������������������������������
	If mv_par02 == 1 .And. Len(aLoc) <= 1 //Se so houver um endereco
		loop
	Endif
	
	//���������������������������������������������������������������������Ŀ
	//� Verifica o cancelamento pelo usuario...                             �
	//�����������������������������������������������������������������������
	Incproc()
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//���������������������������������������������������������������������Ŀ
	//� Impressao do cabecalho do relatorio. . .                            �
	//�����������������������������������������������������������������������
	
	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	@ nlin, 000 pSay Subst(cProd,1,10)
	@ nlin, 012 pSay Subst(SB1->B1_DESC,1,40)
	For i := 1 To Len(aLoc)
		nlin ++
		@ nlin, 071 pSay aLoc[i,1] //Endereco
		@ nlin, 087 pSay aLoc[i,2] Picture "@E 999" //Referencias
		@ nlin, 094 pSay aLoc[i,3] Picture "@E 999.99" //Cubagem utilizada
	Next
	nlin ++
	@ nlin, 000 pSay "Totais do produto: "
	@ nlin, 053 pSay nCubProd  Picture "@E 999.999"
	@ nlin, 062 pSay nEstCX Picture "@E 999,999"
	@ nlin, 094 pSay nCubUtiTot Picture "@E 999.99"
	@ nlin, 104 pSay nCubEst  Picture "@E 999.99"
	@ nlin, 112 pSay nCubUtiTot-nCubEst Picture "@E 999.99"
	@ nlin, 121 pSay (nCubEst/nCubUtiTot)*100 Picture "@E 999.99"
	nlin ++
	@ nlin, 000 pSay Replicate("-",132)
	nlin ++
	Dbselectarea("SBFTMP")
*/
EndDo

Dbclosearea("ZA2TMP")
nTamanho := 0
_ymemo := ""
if ZZ6->(DbSeek(XFilial("ZZ6")+Mv_par01))
   _ymemo := ZZ6->ZZ6_memo   
   nTamanho:=mlcount(_ymemo,254)
endif      

_linha := prow()+2
@ _linha,01 PSAY "Negociacao:"
_linha++           

For _conta:=1 to nTamanho
    
    C_Linha := memotran(MEMOLINE(Alltrim(_ymemo),254,_conta),chr(13),chr(13)+chr(10)) 
                      
    mx := 1     
    N_tamanho := 120
    For i:=1 to 3
        T_linha := substr(C_linha,mx,N_tamanho)
        if !Empty(T_linha)
           @ _Linha,001 Psay T_linha
           _linha++ 
        endif
        mx += N_tamanho
    Next
    
    if _linha > 60
       @ 1,1 Psay "Negociacao:"
       _linha := 2
    endif                     
Next      


//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �VALIDPERG � Autor � AP5 IDE            � Data �  13/11/02   ���
�������������������������������������������������������������������������͹��
���Descri��o � Verifica a existencia das perguntas criando-as caso seja   ���
���          � necessario (caso nao existam).                             ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ValidPerg

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)

AADD(aRegs,{cPerg,"01","Cliente        :","","","mv_ch1","C",6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","CLI",""})
aAdd(aRegs,{cPerg,"02","Da Data        :","","","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","At� a Data     :","","","mv_ch3","D",8,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
//AADD(aRegs,{cPerg,"01","Taxa de Ocupa��o   :","De Emissao         :","De Emissao         :","mv_ch1","N",05,2,0,"G","","mv_par01",""          ,"","","","",""        ,"","","","",""     ,"","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"02","Mais de 1 Endere�o ?","","","mv_ch2","N",1,0,1,"C","NAOVAZIO()","mv_par02","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return