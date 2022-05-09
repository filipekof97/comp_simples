/*
 * PARSER
 */

%{

/*** C++ Declarations ***/
#include "parser.hh"
#include "scanner.hh"
#include "cctype"

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
}

/* Tokens */
%token              TOK_EOF 0      "end of file"
%token              EOL            "end of line"
%token <integerVal> INTEIRO        "inteiro"
%token <doubleVal>  REAL           "real"
%token <stringVal>  IDENTIFICADOR  "identificador"
%token <stringVal>  CADEIA         "cadeia"

%token VALOR      "valor"
%token REF        "ref"
%token RETORNE    "retorne"
%token NULO       "nulo"
%token INICIO     "inicio"
%token FIM        "fim"
%token PARE       "pare"
%token CONTINUE   "continue"
%token PARA       "para"
%token FPARA      "fpara"
%token ENQUANTO   "enquanto"
%token FENQUANTO  "fenquanto"
%token SE         "se"
%token FSE        "fse"
%token VERDADEIRO "verdadeiro"
%token FALSO      "falso"
%token TIPO       "tipo"
%token DE         "de"
%token LIMITE     "limite"
%token GLOBAL     "global"
%token LOCAL      "local"
%token COMENTARIO "comentario"
%token FUNCAO	   "função"
%token ACAO       "ação"
%token FACA       "faça"

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
   ;

declaracoes:
   lista_declaracao_de_tipo
   lista_declaracao_de_variavel_global
   lista_declaracoes_de_funcao
   ;

lista_declaracao_de_tipo:
   //empty
   |TIPO DOISPONTOS lista_declaracao_tipo
   ;

lista_declaracao_de_variavel_global:
   //empty
   |GLOBAL DOISPONTOS lista_declaracao_variavel
   ;

lista_declaracoes_de_funcao:
   //empty
   |FUNCAO DOISPONTOS lista_declaracao_funcao
   ;

acao:
   ACAO DOISPONTOS lista_comandos
   ;

/* TIPOS */

lista_declaracao_tipo:
   declaracao_tipo
   | lista_declaracao_tipo declaracao_tipo
   ;

declaracao_tipo:
   IDENTIFICADOR DECLARACAO descritor_tipo
   ;

descritor_tipo:
   IDENTIFICADOR
   | CHAVESESQUERDA tipo_campos CHAVESDIREITA
   | COLCHETESESQUERDO tipo_constantes COLCHETESDIREITO DE IDENTIFICADOR
   ;

tipo_campos:
   tipo_campo
   | tipo_campos VIRGULA tipo_campo
   ;

tipo_campo:
   IDENTIFICADOR DOISPONTOS IDENTIFICADOR
   ;

tipo_constantes:
   constante_inteiro
   | tipo_constantes VIRGULA constante_inteiro
   ;

constante_inteiro:
   INTEIRO
   ;


/* VARIAVEIS*/

lista_declaracao_variavel:
	declaracao_variavel
	| lista_declaracao_variavel declaracao_variavel
   ;

declaracao_variavel:
   IDENTIFICADOR DOISPONTOS IDENTIFICADOR ATRIBUICAO expr
   ;



/* FUNCOES */

lista_declaracao_funcao:
	declaracao_funcao
	| lista_declaracao_funcao declaracao_funcao
   ;

declaracao_funcao:
	IDENTIFICADOR PARENTESESESQUERDO lista_de_args  PARENTESESDIREITO DECLARACAO corpo
	| IDENTIFICADOR PARENTESESESQUERDO lista_de_args  PARENTESESDIREITO DOISPONTOS IDENTIFICADOR DECLARACAO corpo
   ;

lista_de_args:
   /* empty */
   | lista_args
   ;

lista_args:
  args
  | lista_args VIRGULA args
  ;

args:
   modificador IDENTIFICADOR DOISPONTOS IDENTIFICADOR
   ;

modificador:
	VALOR
   |REF
   ;

corpo:
	lista_declaracao_de_variavel_local
	ACAO DOISPONTOS lista_comandos
   ;

lista_declaracao_de_variavel_local:
	//empty
	| LOCAL DOISPONTOS lista_declaracao_variavel
   ;

lista_args_chamada:
   /* empty */
   | expr
   | lista_args_chamada VIRGULA expr
   ;

fator:
	PARENTESESESQUERDO expr PARENTESESDIREITO
	| literal
	| local
	| chamada_de_funcao
	| NULO
   ;

literal:
	INTEIRO
	| REAL
   | CADEIA
   ;

chamada_de_funcao:
  IDENTIFICADOR PARENTESESESQUERDO lista_args_chamada PARENTESESDIREITO
   ;


/* COMANDOS */

lista_comandos:
   comando
   | lista_comandos PONTOEVIRGULA comando
   ;

comando:
   local ATRIBUICAO expr
   | chamada_de_funcao
   | SE expr VERDADEIRO lista_comandos FSE
   | SE expr VERDADEIRO lista_comandos FALSO lista_comandos FSE
   | PARA IDENTIFICADOR DE expr LIMITE expr FACA lista_comandos FPARA
   | ENQUANTO expr FACA lista_comandos FENQUANTO
   | PARE
   | CONTINUE
   | RETORNE expr
   ;


/* EXPRESSOES */

expr:
   expressao_logica
	| CHAVESESQUERDA criacao_de_registro CHAVESDIREITA
   | COLCHETESESQUERDO criacao_de_vetor COLCHETESDIREITO
   ;

criacao_de_registro:
	atribuicao_de_registro
	| criacao_de_registro VIRGULA atribuicao_de_registro
   ;

atribuicao_de_registro:
   IDENTIFICADOR DECLARACAO expr
   ;

criacao_de_vetor:
   atribuicao_de_vetor
   |criacao_de_vetor VIRGULA atribuicao_de_vetor
   ;

atribuicao_de_vetor:
   /*empty*/
   |expr
   ;

expressao_logica:
   expressao_logica E expressao_relacional
   | expressao_logica OU expressao_relacional
   | expressao_relacional
   ;

expressao_relacional:
	expressao_relacional MENOROUIGUAL expressao_aritmetica
   | expressao_relacional MAIOROUIGUAL expressao_aritmetica
   | expressao_relacional MENOR expressao_aritmetica
   | expressao_relacional MAIOR expressao_aritmetica
   | expressao_relacional DIFERENTE expressao_aritmetica
   | expressao_relacional COMPARACAO expressao_aritmetica
   | expressao_aritmetica
   ;

expressao_aritmetica:
	expressao_aritmetica MAIS termo
	| expressao_aritmetica MENOS termo
	| termo
   ;

local:
   IDENTIFICADOR
	| local PONTO IDENTIFICADOR
	| local COLCHETESESQUERDO lista_args_chamada COLCHETESDIREITO
   ;

termo:
	termo ASTERISCO fator
	| termo BARRA fator
	| fator
   ;

%%

namespace Simples {
   void Parser::error(const location&, const std::string& m) {
        std::cerr << *driver.location_ << ": " << m << std::endl;
        driver.error_ = (driver.error_ == 127 ? 127 : driver.error_ + 1);
   }
}
