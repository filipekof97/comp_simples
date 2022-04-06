%{

/*** C++ Declarations ***/
#include "parser.hh"
#include "scanner.hh"

#define yylex driver.scanner_->yylex

%}

%code requires {
  #include <iostream>
  #include "driver.hh"
  #include "location.hh"
  #include "position.hh"
}

%code provides {
  namespace Simples  {
    // Forward declaration of the Driver class
    class Driver;

    inline void yyerror (const char* msg) {
      std::cerr << msg << std::endl;
    }
  }
}

/* Require bison 2.3 or later */
%require "2.4"
/* enable c++ generation */
%language "C++"
%locations
/* write out a header file containing the token defines */
%defines
/* add debug output code to generated parser. disable this for release
 * versions. */
%debug
/* namespace to enclose parser in */
%define api.namespace {Simples}
/* set the parser's class identifier */
%define api.parser.class {Parser}
/* set the parser */
%parse-param {Driver &driver}
/* set the lexer */
%lex-param {Driver &driver}
/* verbose error messages */
%define parse.error verbose
/* use newer C++ skeleton file */
%skeleton "lalr1.cc"
/* Entry point of grammar */
%start programa


%union
{
 /* YYLTYPE */
  int             integerVal;
  double          doubleVal;
  std::string*    stringVal;
  FatorASTptr		fatorVal;
}

/* Tokens */
%token              TOK_EOF 0   "end of file"
%token              EOL         "end of line"
%token <integerVal> INTEIRO     "inteiro"
%token <doubleVal>  REAL        "real"
%token <stringVal>  IDENTIFIER  "identificador"

%token CADEIA     "cadeia"
%token VALOR      "valor"
%token REF        "ref"
%token RETORNE    "retorne"
%token NULO       "nulo"
%token INICIO     "ini­cio"
%token FIM        "fim"
%token PARE       "pare"
%token CONTINUE   "continue"
%token PARA       "para"
%token FPARA      "fpara"
%token ENQUANTO   "enquanto"
%token FENQUANTO  "fenquanto"
%token FACA       "faca"
%token SE         "se"
%token FSE        "fse"
%token VERDADEIRO "verdadeiro"
%token FALSO      "falso"
%token TIPO       "tipo"
%token DE         "de"
%token LIMITE     "limite"
%token GLOBAL     "global"
%token LOCAL      "local"
%token FUNCAO	   "funcao"
%token ACAO       "acao"

%token DOISPONTOS         ":"
%token PONTOEVIRGULA      ";"
%token VIRGULA            ","
%token PARENTESESESQUERDO "("
%token PARENTESESDIREITO  ")"
%token COLCHETESESQUERDO  "["
%token COLCHETESDIREITO   "]"
%token CHAVESESQUERDA     "{"
%token CHAVESDIREITA      "}"
%token PONTO              "."
%token MAIS               "+"
%token MENOS              "-"
%token ASTERISCO          "*"
%token BARRA              "/"
%token COMPARACAO         "=="
%token DIFERENTE          "!="
%token MENOR              "<"
%token MENOROUIGUAL       "<="
%token MAIOR              ">"
%token MAIOROUIGUAL       ">="
%token E                  "&"
%token OU                 "|"
%token ATRIBUICAO         ":="
%token DECLARACAO         "="


%%




/* PROGRAMA */

programa: declaracoes
   acao

declaracoes:
   lista_declaracao_de_tipo
   lista_declaracoes_de_globais
   lista_declaracoes_de_funcao

lista_declaracao_de_tipo:programa
   //empty
   |TIPO DOISPONTOS lista_declaracao_tipo

lista_declaracoes_de_globais:
   //empty
   |GLOBAL DOISPONTOS lista_declaracao_variavel

lista_declaracoes_de_funcao:
   //empty
   |FUNCAO DOISPONTOS lista_declaracao_funcao





/* TIPOS */

lista_declaracao_tipo:
   declaracao_tipo
   |lista_declaracao_tipo declaracao_tipo

declaracao_tipo:
   IDENTIFIER DECLARACAO descritor_tipo

descritor_tipo:
   IDENTIFIER
   | CHAVESESQUERDA tipo_campos CHAVESDIREITA
   | COLCHETESESQUERDO tipo_constantes COLCHETESDIREITO DE IDENTIFIER

tipo_campos:
   tipo_campo
   | tipo_campos VIRGULA tipo_campo


tipo_campo:
   IDENTIFIER DOISPONTOS IDENTIFIER




/* VARIAVEIS*/

lista_declaracao_variavel:
	declaracao_variavel
	| lista_declaracao_variavel declaracao_variavel

tipo_constantes:
   INTEIRO
   | tipo_constantes VIRGULA INTEIRO

declaracao_variavel:
   IDENTIFIER DOISPONTOS IDENTIFIER ATRIBUICAO inicializacao




/* FUNCOES */

lista_declaracao_funcao:
	declaracao_funcao
	| lista_declaracao_funcao declaracao_funcao

declaracao_funcao:
		IDENTIFIER PARENTESESESQUERDO args PARENTESESDIREITO DECLARACAO corpo
		| IDENTIFIER PARENTESESESQUERDO args PARENTESESDIREITO DOISPONTOS IDENTIFIER DECLARACAO corpo

args:
		modificador IDENTIFIER DOISPONTOS IDENTIFIER

modificador:
		VALOR | REF

corpo:
		declaracoes_de_locais
		ACAO DOISPONTOS lista_comandos

declaracoes_de_locais:
		//empty
		| LOCAL DOISPONTOS lista_declaracao_variavel

lista_args_chamada:
	//empty
	| fator
	| lista_args_chamada VIRGULA fator

fator:
	PARENTESESESQUERDO expr PARENTESESDIREITO
	| literal
	| loc_temp
	| chamada_funcao
	| NULO

literal:
	INTEIRO /*{FatorAST s;
	s.val = $1;
	cout << s.val << endl;
	s.print2();
	$$ = &s;}*/
	| REAL

chamada_funcao:
	IDENTIFIER PARENTESESESQUERDO lista_args_chamada PARENTESESDIREITO



/* COMANDOS */

acao:
   ACAO DOISPONTOS lista_comandos

lista_comandos:
   comando
   | lista_comandos PONTOEVIRGULA comando

comando:
   loc_temp ATRIBUICAO expr
   | chamada_funcao
   | PARA IDENTIFIER DE expr LIMITE expr FACA lista_comandos FACA
   | SE expr VERDADEIRO lista_comandos FSE
   | SE expr VERDADEIRO lista_comandos FALSO lista_comandos FSE
   | ENQUANTO expr FACA lista_comandos FENQUANTO
   | CONTINUE
   | PARE
   | RETORNE expr



/* EXPRESSOES */

inicializacao:
   expr
   |CHAVESESQUERDA criacao_de_registro CHAVESDIREITA

criacao_de_registro:
	atribuicao_de_registro
	| criacao_de_registro VIRGULA atribuicao_de_registro

expr:
   expressao_logica E expressao_relacional
	| expressao_logica OU expressao_relacional
	| expressao_relacional

expressao_logica: expr

expressao_relacional:
	expressao_relacional COMPARACAO expressao_aritmetica
	| expressao_relacional DIFERENTE expressao_aritmetica
	| expressao_relacional MENOR expressao_aritmetica
	| expressao_relacional MENOROUIGUAL expressao_aritmetica
	| expressao_relacional MAIOR expressao_aritmetica
	| expressao_relacional MAIOROUIGUAL expressao_aritmetica
	| expressao_aritmetica

expressao_aritmetica:
	expressao_aritmetica MAIS termo
	| expressao_aritmetica MENOS termo
	| termo

loc_temp:
   IDENTIFIER
	| loc_temp PONTO IDENTIFIER
	| loc_temp COLCHETESESQUERDO lista_args_chamada COLCHETESDIREITO

atribuicao_de_registro:
	IDENTIFIER  DECLARACAO expr

termo:
	termo ASTERISCO fator
	| termo BARRA fator
	| fator



%%

namespace Simples {
   void Parser::error(const location&, const std::string& m) {
        std::cerr << *driver.location_ << ": " << m << std::endl;
        driver.error_ = (driver.error_ == 127 ? 127 : driver.error_ + 1);
   }
}
