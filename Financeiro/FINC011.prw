#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FINC011  � Autor � Fl�via Rocha       � Data �  06/11/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Solu��o para o Financeiro excluir os t�tulos tipo TX       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Depto. Financeiro                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

***********************
User Function FINC011
***********************

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cFiltraSE2    := ""
Local aIndexSE2		:= {}
Private bFiltraBrw	:= {|| Nil}	

Private cPerg   := "FINC011"
Private cCadastro := "T�tulos a Pagar Tipo: TX"

//���������������������������������������������������������������������Ŀ
//� Array (tambem deve ser aRotina sempre) com as definicoes das opcoes �
//� que apareceram disponiveis para o usuario. Segue o padrao:          �
//� aRotina := { {<DESCRICAO>,<ROTINA>,0,<TIPO>},;                      �
//�              {<DESCRICAO>,<ROTINA>,0,<TIPO>},;                      �
//�              . . .                                                  �
//�              {<DESCRICAO>,<ROTINA>,0,<TIPO>} }                      �
//� Onde: <DESCRICAO> - Descricao da opcao do menu                      �
//�       <ROTINA>    - Rotina a ser executada. Deve estar entre aspas  �
//�                     duplas e pode ser uma das funcoes pre-definidas �
//�                     do sistema (AXPESQUI,AXVISUAL,AXINCLUI,AXALTERA �
//�                     e AXDELETA) ou a chamada de um EXECBLOCK.       �
//�                     Obs.: Se utilizar a funcao AXDELETA, deve-se de-�
//�                     clarar uma variavel chamada CDELFUNC contendo   �
//�                     uma expressao logica que define se o usuario po-�
//�                     dera ou nao excluir o registro, por exemplo:    �
//�                     cDelFunc := 'ExecBlock("TESTE")'  ou            �
//�                     cDelFunc := ".T."                               �
//�                     Note que ao se utilizar chamada de EXECBLOCKs,  �
//�                     as aspas simples devem estar SEMPRE por fora da �
//�                     sintaxe.                                        �
//�       <TIPO>      - Identifica o tipo de rotina que sera executada. �
//�                     Por exemplo, 1 identifica que sera uma rotina de�
//�                     pesquisa, portando alteracoes nao podem ser efe-�
//�                     tuadas. 3 indica que a rotina e de inclusao, por�
//�                     tanto, a rotina sera chamada continuamente ao   �
//�                     final do processamento, ate o pressionamento de �
//�                     <ESC>. Geralmente ao se usar uma chamada de     �
//�                     EXECBLOCK, usa-se o tipo 4, de alteracao.       �
//�����������������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� aRotina padrao. Utilizando a declaracao a seguir, a execucao da     �
//� MBROWSE sera identica a da AXCADASTRO:                              �
//�                                                                     �
//� cDelFunc  := ".T."                                                  �
//� aRotina   := { { "Pesquisar"    ,"AxPesqui" , 0, 1},;               �
//�                { "Visualizar"   ,"AxVisual" , 0, 2},;               �
//�                { "Incluir"      ,"AxInclui" , 0, 3},;               �
//�                { "Alterar"      ,"AxAltera" , 0, 4},;               �
//�                { "Excluir"      ,"AxDeleta" , 0, 5} }               �
//�                                                                     �
//�����������������������������������������������������������������������


//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Excluir","AxDeleta",0,5},;
             {"LIMPA_TUDO","U_LIMPATX()",0,6} }

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SE2"

dbSelectArea("SE2")
dbSetOrder(1)

cPerg   := "FINC011"

Pergunte(cPerg,.T.)
//SetKey(123,{|| Pergunte(cPerg,.T.)}) // Seta a tecla F12 para acionamento dos parametros
cFiltraSE2:= " E2_TIPO = 'TX' .and. E2_FILIAL = '" + xFilial("SE2") + "' " 
//cFiltraSE2+= " .and. E2_VENCREA = '" + Dtos(MV_PAR01) + "' "
cFiltraSE2+= " .and. Dtos(E2_VENCREA) = '" + Dtos(MV_PAR01) + "' "
cFiltraSE2+= " .and. E2_FORNECE = '000054' .and. E2_LOJA = '00' "
cFiltraSE2+= " .and. E2_VALOR = E2_SALDO  .and. Empty(E2_BAIXA) "

//���������������������������������������������������������������������Ŀ
//� Executa a funcao MBROWSE. Sintaxe:                                  �
//�                                                                     �
//� mBrowse(<nLin1,nCol1,nLin2,nCol2,Alias,aCampos,cCampo)              �
//� Onde: nLin1,...nCol2 - Coordenadas dos cantos aonde o browse sera   �
//�                        exibido. Para seguir o padrao da AXCADASTRO  �
//�                        use sempre 6,1,22,75 (o que nao impede de    �
//�                        criar o browse no lugar desejado da tela).   �
//�                        Obs.: Na versao Windows, o browse sera exibi-�
//�                        do sempre na janela ativa. Caso nenhuma este-�
//�                        ja ativa no momento, o browse sera exibido na�
//�                        janela do proprio SIGAADV.                   �
//� Alias                - Alias do arquivo a ser "Browseado".          �
//� aCampos              - Array multidimensional com os campos a serem �
//�                        exibidos no browse. Se nao informado, os cam-�
//�                        pos serao obtidos do dicionario de dados.    �
//�                        E util para o uso com arquivos de trabalho.  �
//�                        Segue o padrao:                              �
//�                        aCampos := { {<CAMPO>,<DESCRICAO>},;         �
//�                                     {<CAMPO>,<DESCRICAO>},;         �
//�                                     . . .                           �
//�                                     {<CAMPO>,<DESCRICAO>} }         �
//�                        Como por exemplo:                            �
//�                        aCampos := { {"TRB_DATA","Data  "},;         �
//�                                     {"TRB_COD" ,"Codigo"} }         �
//� cCampo               - Nome de um campo (entre aspas) que sera usado�
//�                        como "flag". Se o campo estiver vazio, o re- �
//�                        gistro ficara de uma cor no browse, senao fi-�
//�                        cara de outra cor.                           �
//�����������������������������������������������������������������������

dbSelectArea(cString)
bFiltraBrw 	:= {|| FilBrowse( "SE2", @aIndexSE2, @cFiltraSE2 ) } 
Eval(bFiltraBrw)
mBrowse( 6,1,22,75,cString)

//Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros


Return

**************************
User Function LIMPATX()
**************************

Local cQuery := ""
Local LF     := CHR(13) + CHR(10)
Local qtos   := 0

If MsgYesNo("Deseja Realmente LIMPAR TODOS os T�TULOS TX desta Tela ?" )
	cQuery := "Select * from " + RetSqlName("SE2") + " SE2 " + LF
	cQuery += " Where E2_TIPO = 'TX' " + LF
	cQuery += " and E2_VENCREA = '" + Dtos(MV_PAR01) + "' " + LF
	cQuery += " and E2_FILIAL  = '" + Alltrim(xFilial("SE2")) + "' " + LF
	cQuery += " and SE2.D_E_L_E_T_ = '' " + LF
	cQuery += " and E2_FORNECE = '000054' and E2_LOJA = '00' "+ LF
	cQuery += " and E2_VALOR = E2_SALDO   and E2_BAIXA = ''  "	+ LF
	MemoWrite("C:\TEMP1\FINC011.SQL", cQuery )
	If Select("E2XX") > 0		
		DbSelectArea("E2XX")
		DbCloseArea()			
	EndIf
	TCQUERY cQuery NEW ALIAS "E2XX"
	TCSetField( "E2XX", "E2_VENCREA"   , "D")
	TCSetField( "E2XX", "E2_EMISSAO"   , "D")
	TCSetField( "E2XX", "E2_VENCTO"   , "D")
	E2XX->(DbGoTop())
	While !E2XX->(Eof())		
			
		SE2->(Dbsetorder(1))
		If SE2->(Dbseek(xFilial("SE2") + E2XX->E2_PREFIXO + E2XX->E2_NUM + E2XX->E2_PARCELA + E2XX->E2_TIPO + E2XX->E2_FORNECE + E2XX->E2_LOJA ))
			RecLock("SE2", .F.)
			SE2->(DbDelete())
			SE2->(MsUnlock())
			qtos++
		Endif
		
		E2XX->(Dbskip())
	Enddo
	MsgInfo("Limpeza Efetuada --> " + Alltrim(str(qtos)) + " Registros Apagados." )
Else
	MsgInfo("Nenhum T�tulo Apagado")
Endif	                            

Return
	
	