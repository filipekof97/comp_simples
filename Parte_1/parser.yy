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
%token FUNCAO	   "fun��o"
%token ACAO       "a��o"
%token FACA       "fa�a"

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

%token IMPRIMIR           "imprimir"


%%


/* PROGRAMA */

programa: declaracoes /* Revisado */
   acao
   ;

declaracoes: /* Revisado */
   lista_declaracao_de_tipo
   lista_declaracao_de_variavel_global
   lista_declaracoes_de_funcao
   ;

lista_declaracao_de_tipo: /* Revisado */
   //empty
   |TIPO DOISPONTOS lista_declaracao_tipo
   ;

lista_declaracao_de_variavel_global: /* Revisado */
   //empty
   |GLOBAL DOISPONTOS lista_declaracao_variavel
   ;

lista_declaracoes_de_funcao: /* Revisado */
   //empty
   |FUNCAO DOISPONTOS lista_declaracao_funcao
   ;

acao: /* Revisado */
   ACAO DOISPONTOS lista_comandos_debug
   ;

lista_comandos_debug: /* Revisado */
   /* empty */
   |lista_comandos
   ;

/* TIPOS */

lista_declaracao_tipo: /* Revisado */
   declaracao_tipo
   | lista_declaracao_tipo declaracao_tipo
   ;

declaracao_tipo: /* Revisado */
   IDENTIFICADOR DECLARACAO descritor_tipo
   ;

descritor_tipo: /* Revisado */
   IDENTIFICADOR
   | CHAVESESQUERDA tipo_campos CHAVESDIREITA
   | COLCHETESESQUERDO tipo_constantes COLCHETESDIREITO DE IDENTIFICADOR
   ;

tipo_campos: /* Revisado */
   tipo_campo
   | tipo_campos VIRGULA tipo_campo
   ;

tipo_campo: /* Revisado */
   IDENTIFICADOR DOISPONTOS IDENTIFICADOR
   ;

tipo_constantes: /* Revisado */
   constante_inteiro
   | tipo_constantes VIRGULA constante_inteiro
   ;

constante_inteiro: /* Revisado */
   INTEIRO
   ;


/* VARIAVEIS*/

lista_declaracao_variavel: /* Revisado */
	declaracao_variavel
	| lista_declaracao_variavel declaracao_variavel
   ;

declaracao_variavel: /* Revisado */
   IDENTIFICADOR DOISPONTOS IDENTIFICADOR ATRIBUICAO expr
   ;



/* FUNCOES */

lista_declaracao_funcao: /* Revisado */
	declaracao_funcao
	| lista_declaracao_funcao declaracao_funcao
   ;

declaracao_funcao:  /* Revisado */
	IDENTIFICADOR PARENTESESESQUERDO lista_de_args  PARENTESESDIREITO DECLARACAO corpo
	| IDENTIFICADOR PARENTESESESQUERDO lista_de_args  PARENTESESDIREITO DOISPONTOS IDENTIFICADOR DECLARACAO corpo
   ;

lista_de_args:  /* Revisado */
   /* empty */
   | lista_args
   ;

lista_args:  /* Revisado */
  args
  | lista_args VIRGULA args
  ;

args:  /* Revisado */
   modificador IDENTIFICADOR DOISPONTOS IDENTIFICADOR
   ;

modificador:  /* Revisado */
	VALOR
   |REF
   ;

corpo: /* Revisado */
	lista_declaracao_de_variavel_local
	ACAO DOISPONTOS lista_comandos
   ;

lista_declaracao_de_variavel_local: /* Revisado */
	//empty
	| LOCAL DOISPONTOS lista_declaracao_variavel
   ;

lista_args_chamada: /* Revisado */
   /* empty */
   | expr
   | lista_args_chamada VIRGULA expr
   ;

fator: /* Revisado */
	PARENTESESESQUERDO expr PARENTESESDIREITO
	| literal
	| local
	| chamada_de_funcao
	| NULO
   ;

literal: /* Revisado */
	INTEIRO
	| REAL
   | CADEIA
   ;

chamada_de_procedimento: /* Revisado */
	IDENTIFICADOR PARENTESESESQUERDO lista_args_chamada PARENTESESDIREITO
   ;

chamada_de_funcao: /* Revisado */
  IDENTIFICADOR PARENTESESESQUERDO lista_args_chamada PARENTESESDIREITO
   ;

/* COMANDOS */

lista_comandos: /* Revisado */
   comando
   | lista_comandos PONTOEVIRGULA comando
   ;

comando: /* Revisado */
   local ATRIBUICAO expr
   | chamada_de_procedimento
   | SE expr VERDADEIRO lista_comandos FSE
   | SE expr VERDADEIRO lista_comandos FALSO lista_comandos FSE
   | PARA IDENTIFICADOR DE expr LIMITE expr FACA lista_comandos FPARA
   | ENQUANTO expr FACA lista_comandos FENQUANTO
   | PARE
   | CONTINUE
   | RETORNE expr
   ;


/* EXPRESSOES */

expr: /* Revisado */
   expressao_logica
	| CHAVESESQUERDA criacao_de_registro CHAVESDIREITA
   ;

criacao_de_registro: /* Revisado */
	atribuicao_de_registro
	| criacao_de_registro VIRGULA atribuicao_de_registro
   ;

atribuicao_de_registro: /* Revisado */
   IDENTIFICADOR DECLARACAO expr
   ;

expressao_logica: /* Revisado */
   expressao_logica E expressao_relacional
   | expressao_logica OU expressao_relacional
   | expressao_relacional
   ;

expressao_relacional: /* Revisado */
	expressao_relacional MENOROUIGUAL expressao_aritmetica
   | expressao_relacional MAIOROUIGUAL expressao_aritmetica
   | expressao_relacional MENOR expressao_aritmetica
   | expressao_relacional MAIOR expressao_aritmetica
   | expressao_relacional DIFERENTE expressao_aritmetica
   | expressao_relacional COMPARACAO expressao_aritmetica
   | expressao_aritmetica
   ;

expressao_aritmetica: /* Revisado */
	expressao_aritmetica MAIS termo
	| expressao_aritmetica MENOS termo
	| termo
   ;

local: /* Revisado */
   IDENTIFICADOR
	| local PONTO IDENTIFICADOR
	| local COLCHETESESQUERDO lista_args_chamada COLCHETESDIREITO
   ;

termo: /* Revisado */
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