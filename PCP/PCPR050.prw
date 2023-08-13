// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : PCPR050
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 20/02/18 | Gustavo Costa     | Producao por hora
// ---------+-------------------+-----------------------------------------------------------

#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch " 

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} novo
Montagem da tela de processamento

@author    TOTVS Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     7/08/2012
/*/
//------------------------------------------------------------------------------------------
User function PCPR050()
//--< variáveis >---------------------------------------------------------------------------

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Local cQuery	:=''
Local oFWMsExcel
Local oExcel
Local cArquivo	:= GetTempPath()+'PCPR050.xml'
Pergunte('PCPR50',.T.)
//////////seleciona os dados

cQuery := "SELECT ZZ2_DATA, ZZ2_MAQ, ZZ2_LADO, ZZ2_PROD, " 
cQuery += "SUM( CASE WHEN ZZ2_HORA BETWEEN '05:40' AND '06:39' THEN ZZ2_QUANT ELSE 0 END ) AS 'A', "   
cQuery += "SUM( CASE WHEN ZZ2_HORA BETWEEN '06:40' AND '07:39' THEN ZZ2_QUANT ELSE 0 END ) AS 'B', "   
cQuery += "SUM( CASE WHEN ZZ2_HORA BETWEEN '07:40' AND '08:39' THEN ZZ2_QUANT ELSE 0 END ) AS 'C', "   
cQuery += "SUM( CASE WHEN ZZ2_HORA BETWEEN '08:40' AND '09:39' THEN ZZ2_QUANT ELSE 0 END ) AS 'D', "   
cQuery += "SUM( CASE WHEN ZZ2_HORA BETWEEN '09:40' AND '10:39' THEN ZZ2_QUANT ELSE 0 END ) AS 'E', "   
cQuery += "SUM( CASE WHEN ZZ2_HORA BETWEEN '10:40' AND '11:39' THEN ZZ2_QUANT ELSE 0 END ) AS 'F', "   
cQuery += "SUM( CASE WHEN ZZ2_HORA BETWEEN '11:40' AND '12:39' THEN ZZ2_QUANT ELSE 0 END ) AS 'G', "   
cQuery += "SUM( CASE WHEN ZZ2_HORA BETWEEN '12:40' AND '13:39' THEN ZZ2_QUANT ELSE 0 END ) AS 'H', "   
cQuery += "SUM( CASE WHEN ZZ2_HORA BETWEEN '13:40' AND '14:39' THEN ZZ2_QUANT ELSE 0 END ) AS 'I', "   
cQuery += "SUM( CASE WHEN ZZ2_HORA BETWEEN '14:40' AND '15:39' THEN ZZ2_QUANT ELSE 0 END ) AS 'J', "   
cQuery += "SUM( CASE WHEN ZZ2_HORA BETWEEN '15:40' AND '16:39' THEN ZZ2_QUANT ELSE 0 END ) AS 'K', " 
cQuery += "SUM( CASE WHEN ZZ2_HORA BETWEEN '16:40' AND '17:39' THEN ZZ2_QUANT ELSE 0 END ) AS 'L', "   
cQuery += "SUM( CASE WHEN ZZ2_HORA BETWEEN '17:40' AND '18:39' THEN ZZ2_QUANT ELSE 0 END ) AS 'M', "   
cQuery += "SUM( CASE WHEN ZZ2_HORA BETWEEN '18:40' AND '19:39' THEN ZZ2_QUANT ELSE 0 END ) AS 'N', "   
cQuery += "SUM( CASE WHEN ZZ2_HORA BETWEEN '19:40' AND '20:39' THEN ZZ2_QUANT ELSE 0 END ) AS 'O', "   
cQuery += "SUM( CASE WHEN ZZ2_HORA BETWEEN '20:40' AND '21:39' THEN ZZ2_QUANT ELSE 0 END ) AS 'P', "   
cQuery += "SUM( CASE WHEN ZZ2_HORA BETWEEN '21:40' AND '22:39' THEN ZZ2_QUANT ELSE 0 END ) AS 'Q' "
cQuery += "FROM ZZ2020 ZZ2 WITH (NOLOCK) "
cQuery += "WHERE ZZ2.ZZ2_DATA BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' "  
cQuery += "AND ZZ2.D_E_L_E_T_ = '' " 
cQuery += "GROUP by ZZ2_DATA, ZZ2_MAQ, ZZ2_LADO, ZZ2_PROD "         
cQuery += "order by ZZ2_DATA, ZZ2_MAQ, ZZ2_LADO, ZZ2_PROD " 

//MemoWrite("C:\Temp\FINR008.sql", cQuery )

If Select("XE1") > 0
	DbSelectArea("XE1")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "XE1"
TCSetField( "XE1", "ZZ2_DATA", "D")

	//Criando o objeto que irá gerar o conteúdo do Excel
	oFWMsExcel := FWMSExcel():New()
	
	//Aba 01 - Teste
	oFWMsExcel:AddworkSheet("PCPR050") //Não utilizar número junto com sinal de menos. Ex.: 1-
		//Criando a Tabela
		oFWMsExcel:AddTable("PCPR050","Titulo Tabela")
		//Criando Colunas
		oFWMsExcel:AddColumn("PCPR050","Titulo Tabela","DATA",1,1) //1 = Modo Texto
		oFWMsExcel:AddColumn("PCPR050","Titulo Tabela","MAQ",1,1) //1 = Modo Texto
		oFWMsExcel:AddColumn("PCPR050","Titulo Tabela","LADO",2,1) //2 = Valor sem R$
		oFWMsExcel:AddColumn("PCPR050","Titulo Tabela","PRODUTO",3,1) //3 = Valor com R$
		oFWMsExcel:AddColumn("PCPR050","Titulo Tabela","05:40",2,2)
		oFWMsExcel:AddColumn("PCPR050","Titulo Tabela","06:40",2,2)
		oFWMsExcel:AddColumn("PCPR050","Titulo Tabela","07:40",2,2)
		oFWMsExcel:AddColumn("PCPR050","Titulo Tabela","08:40",2,2)
		oFWMsExcel:AddColumn("PCPR050","Titulo Tabela","09:40",2,2)
		oFWMsExcel:AddColumn("PCPR050","Titulo Tabela","10:40",2,2)
		oFWMsExcel:AddColumn("PCPR050","Titulo Tabela","11:40",2,2)
		oFWMsExcel:AddColumn("PCPR050","Titulo Tabela","12:40",2,2)
		oFWMsExcel:AddColumn("PCPR050","Titulo Tabela","13:40",2,2)
		oFWMsExcel:AddColumn("PCPR050","Titulo Tabela","14:40",2,2)
		oFWMsExcel:AddColumn("PCPR050","Titulo Tabela","15:40",2,2)
		oFWMsExcel:AddColumn("PCPR050","Titulo Tabela","16:40",2,2)
		oFWMsExcel:AddColumn("PCPR050","Titulo Tabela","17:40",2,2)
		oFWMsExcel:AddColumn("PCPR050","Titulo Tabela","18:40",2,2)
		oFWMsExcel:AddColumn("PCPR050","Titulo Tabela","19:40",2,2)
		oFWMsExcel:AddColumn("PCPR050","Titulo Tabela","20:40",2,2)
		oFWMsExcel:AddColumn("PCPR050","Titulo Tabela","21:40",2,2)
		//Criando as Linhas
		XE1->(dbGoTop())
		While !(XE1->(EoF()))
			oFWMsExcel:AddRow("PCPR050","Titulo Tabela",{;
															XE1->ZZ2_DATA ,;
															XE1->ZZ2_MAQ ,;
															XE1->ZZ2_LADO ,;
															XE1->ZZ2_PROD ,;
															XE1->A ,;
															XE1->B ,;
															XE1->C ,;
															XE1->D ,;
															XE1->E ,;
															XE1->F ,;
															XE1->G ,;
															XE1->H ,;
															XE1->I ,;
															XE1->J ,;
															XE1->K ,;
															XE1->L ,;
															XE1->M ,;
															XE1->N ,;
															XE1->O ,;
															XE1->P ,;
															XE1->Q })
		
			//Pulando Registro
			XE1->(DbSkip())
		EndDo
	
	//Ativando o arquivo e gerando o xml
	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cArquivo)
		
	//Abrindo o excel e abrindo o arquivo xml
	oExcel := MsExcel():New() 			//Abre uma nova conexão com Excel
	oExcel:WorkBooks:Open(cArquivo) 	//Abre uma planilha
	oExcel:SetVisible(.T.) 				//Visualiza a planilha
	oExcel:Destroy()						//Encerra o processo do gerenciador de tarefas
	
	XE1->(DbCloseArea())
	//RestArea(aArea)
Return
