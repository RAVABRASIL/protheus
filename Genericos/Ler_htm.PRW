#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "Directry.ch"
#include "Fileio.ch"
user function Ler_Htm() 

Local cHtml:="" 
Local cCaminho:=cStartPath+cDiretorio
Local cDiretorio:=strtran(cCaminho,"\","/") 

Public cStartPath := GetSrvProfString("Startpath","")
Public cDiretorio :="Temporary Internet Files\"  
Public aFiles := DIRECTORY(cCaminho+"*.htm")

//cCaminho:=cStartPath+cDiretorio
//cDiretorio:=strtran(cCaminho,"\","/")

for arq:= 1 to len(aFiles)
	nomearq:=aFiles[arq][1] 
	alert(nomearq +" encontrado.")
	if  At("cabecalho_reduzido",nomearq)!=0
		
		cHtml:=arquivo(cDiretorio+nomearq )
		if empty(cHtml) 
		//nao abriu o arquivo 
		 loop
		endif 
		
		if  At("Estabelecimento não Cadastrado",nomearq)==0 
		//htm que contem informaçoes de cadastro
			alert(nomearq + " arquivo valido")
			gravar(cHtml)
		else 
		//htm que nao contem informaçoes de cadastro
			alert(nomearq + " nada encontrado")
			loop
		endif
	endif
	
next

return

*****************************
static Function Arquivo(cDir)
Local nTamArquivo:=0
Local cTxt    :=""

If fopen(cDir,0)==-1
	fClose(nFile) // nao abriu o arquivo
	return ""
endif

nFile:=fopen(cDir,0)         //abrir arquivo
nTamArquivo:=Fseek(nFile,0,2)//posiciona no fim e pega o tamanho

FREAD(nFile,cTxt ,nTamArquivo)//grava quantidade = tamanho  em cFim

fClose(nFile)//fecha arquivo

Return lower(Format_Htm(cTxt)) //retorna o conteudo do htm ja formatado

 

**********************************
static function Format_Htm(conteudo)//copia do conteudo original
conteudo:=strtran(conteudo,"<!","<! ")//gerar um padrão para comentario para evitar erros

//converte caracter especial elimina alguns erros fora de padrão html previamente testados
conteudo:=FORMATA(conteudo)

tagINI:={'<body','<!','<font','<table','<td','<div','<script','<html'} //lista de TAGs
tagFIM:={'>'    ,'->','>'    ,'>'     ,'>'  ,'>'   ,'>'      ,'>'    } //lista de fechamento de TAGs
//eliminar atributos
Limpa_tag(conteudo,tagINI,tagFIM)  

//elimina tags e mantem o seu conteudo
tagDEL:={'font>','b>','div>','table>','tr>'} //lista de TAGs
Del_tag(conteudo,tagDEL) 
               
//elimina tags e também o seu conteudo
tagINI:={ '<head>', '<script>'} //lista de TAGs
tagFIM:={'</head>','</script>'} //lista de fechamento de TAGs
Del_TgCont(conteudo,tagINI,tagFIM)

return conteudo // retorna o conteudo sem comentarios e sem as tags da Lista
                   
 
 
********************************  
static function FORMATA(cString)
aChar:={;
{'',chr(0)  },{'',chr(1) },{'',chr(2) },{'',chr(3) },{'',chr(4) },{'',chr(5) },{'',chr(6) },{'',chr(7) },{' ',chr(8) },{'',chr(9) },;
{' ',chr(10) },{'',chr(11)},{'',chr(12)},{' ',chr(13)},{'',chr(14)},{'',chr(15)},{'',chr(16)},{'',chr(17)},{'',chr(18)},{'',chr(19)},;
{'',chr(20) },{'',chr(21)},{'',chr(22)},{'',chr(23)},{'',chr(24)},{'',chr(25)},{'',chr(26)},{'',chr(27)},{'',chr(28)},{'',chr(29)},;
{'',chr(30) },{'',chr(31)},;
{'',chr(127)},{':','.:'},;
{'',' |'},{'','...'},{'','”'},{'','“'},{'',' < '},{'oe',"'C5e"},{'oe','"c5e'},{'','+-'},{'','-+'},{'','--'},{" ","&nbsp;"},{' ',''},{' ',''},{' ',''},{' ','  '},{' ' ,'<o:p></o:p>'},{' ' ,'<o:p>'},{' ' ,'</o:p>'},{"a","&Aacute;"},{"a","&aacute;"},{"a","&Acirc;"},{"a","&acirc;"},;
{'0','&deg;'},{"a","&Agrave;"},{"a","&agrave;"   },{"a","&Aring;"    },{"a","&aring;"                },{"a","&Atilde;" },{"a","&atilde;"},{"a","&Auml;"},{"a","&auml;"},;
{"","&AElig;"  },{"","&aelig;"     },{"e","&Eacute;"   },{"e","&eacute;"               },;
{"e","&Ecirc;" },{"e","&ecirc;"    },{"e","&Egrave;"   },{"e","&egrave;"               },{"e","&Euml;"              },{"e","&euml;"           },{" ","&lt;"                                     },{" ","&gt;"                   },{"&","&amp;"               },{'"',"&quot;"        },{' ',"&reg;"       },{' ',"&copy;"    },{' ',"&ETH;"   },{' ',"&eth;"   },{"c","&Ccedil;"},{"c","&ccedil;"},{"n","&Ntilde;"},{"n","&ntilde;"},{"i","&Iacute;"},;
{"i","&iacute;"},{"i","&Icirc;"    },{"i","&icirc;"    },{"i","&Igrave;"               },{"i","&igrave;"            },{"i","&Iuml;"           },{"i","&iuml;"                                   },{"y","&Yacute;"               },{"y","&yacute;"            },{'º','&ordm;'        },{' ',"&THORN;"     },{' ',"&thorn;"   },;
{"o","&Oacute;"},{"o","&oacute;"   },{"o","&Ocirc;"    },{"o","&ocirc;"                },{"o","&Ograve;"            },{"o","&ograve;"         },{' ',"&Oslash;"                                 },{' ',"&oslash;"               },{"o","&Otilde;"            },{"o","&otilde;"      },{"o","&Ouml;"      },{"o","&ouml;"    },;
{"u","&Uacute;"},{"u","&uacute;"   },{"u","&Ucirc;"    },{"u","&ucirc;"                },{"u","&Ugrave;"            },{"u","&ugrave;"         },{"u","&Uuml;"                                   },{"u","&uuml;"                 },{' ',"&szlig;"             },{' ','  '            },{'"',"'"           },{'>',' >'        },{'<','< '      },{' ',chr(10)   },;
{'<p>','<b>'   },{'</p>','</b>'    },{'','<b></b>'     },{'','<i></i>'                 },{'','<a></a>'              },{'', '<p></p>'          },{'','<tr></tr>'                                 },{'','<td></td>'               },{'','<strong></strong>'    },{'','<tbody></tbody>'},{'','<font></font>'},{'','<pre></pre>'},{'<b>','<b><b>'},{'<i>','<i><i>'},{'<a>','<a><a>'},;
{'<p>','<p><p>'},{'<tr>','<tr><tr>'},{'<td>','<td><td>'},{'<strong>','<strong><strong>'},{'<tbody>','<tbody><tbody>'},{'<font>','<font><font>'},{'<pre>','<pre><pre>'                           },{'</b>','</b></b>'            },;
{'</i>','</i></i>'                 },{'</a>','</a></a>'},{'</p>','</p></p>'            },{'</tr>','</tr></tr>'      },{'</td>','</td></td>'   },{'</strong>','</strong></strong>'               },{'</tbody>','</tbody></tbody>'},{'</font>','</font></font>'},;
{'</pre>','</pre></pre>'           },{' ','<i>'        },{' ','</i>'                   },{' ','<br>'                },{' ','</br>'            },{' ','<br/>'                                    },{' ','<hr>'                   },{'','<div>'                },{'','</div>'},{'','<tbody>'    },{'','</tbody>'},{' ','<strong>'},{' ','</strong>'},{' ', '  '},;
{'','<boletim@brlicita.com.br>'    },{'','>"'          },{'','borderColor=#eeeeee cellSpacing=0 cellPadding=2 width="100%"'                   },{'','align=center bgColor=#ffffff border=1 <TR>'},{'','clique aqui para fazer o download deste edital'       },{' ', '  '  },{'</td>','</t d>'}}
cString:=lower(cString)
cString:=ALLTRIM(cString)
for x:=1 to len(aChar)
	do while AT(aChar[x,2],cString)!=0
		cString := strtran( cString,aChar[x,2],aChar[x,1])
	enddo
next x
return lower(cString)         




**********************************
static function Limpa_tag(conteudo,tag,fim)//copia do conteudo original
//eliminar atributos
for X:=1 to len(tag)
	do while AT(tag[X]+" ",conteudo)!=0  //existe o item + espaco
		auxiliar:=substr(conteudo,AT(tag[X]+" ",conteudo), len(conteudo)) // item ate o fim do conteudo
		auxiliar:=substr(auxiliar,0,iif(AT(fim[X],auxiliar)!=0,AT(fim[X],auxiliar),len(auxiliar)))//inicio ate fechamento de tag
		conteudo:=strtran(conteudo,auxiliar,tag[X]+">")//troca a tag com atributos por <tag> sem atributos
	enddo
next X
return conteudo // retorna o conteudo sem comentarios e sem as tags da Lista
                     

******************************************
static function Del_TgCont(conteudo,inicio,fim)
for x:=1 to len(inicio)
if AT(inicio[x],conteudo)!=0 .and. AT(fim[x],conteudo)!=0  //existe abertura e fechamento da tag?
	do while AT(inicio[x],conteudo)!=0 .and. AT(fim[x],conteudo)!=0   //enquanto existir
		del:=substr(conteudo, AT(inicio[x],conteudo),  AT(fim[x],conteudo)-AT(inicio[x],conteudo)+len(fim[x]))
		//conteudo entre a <tag>...</tag>  incluindo a propria TAG e o fechamento
		conteudo:=strtran(conteudo,del,'')//elimina Tag e seu conteudo
	enddo
endif
next x
return conteudo 



********************************
static function Del_tag(conteudo,tag)//copia do conteudo original
//eliminar tags
for X:=1 to len(tag)
	conteudo:=strtran(conteudo,"<" +tag[X],"") //elimina <tag>  de abertura   sem atributos
	conteudo:=strtran(conteudo,"</"+tag[X],"") //elimina </tag> de fechamento nao existem atributos
next X
return conteudo //retorna conteudo sem as tags da Lista    


        

*****************************
static Function gravar(cParam)
Public  cDestino :="C:\Documents and Settings\rubem.RAVAEMBALAGENS.000\Desktop\teste.htm"
Public arquivo:=''
Public LOG_STATUS:=''

if FERASE(cDestino)==1    
Public arquivo:=fopen(cDestino,2)
else
Public arquivo:=Fcreate(cDestino,0)
fClose(arquivo) 
arquivo:=fopen(cDestino,2)
endif 
    
FWRITE(arquivo,cParam,len(cParam))      
fClose(arquivo) 
alert("Conferir Conteudo no Html")
return
