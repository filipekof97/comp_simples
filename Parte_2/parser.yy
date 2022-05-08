/*
 * PARSER
 */
https://blog.pantuza.com/artigos/tipos-abstratos-de-dados-tabela-hash

//#include "Tabelahash.hh"

/*
TabelaHash <string,int> tabelahash;
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


%type <integerVal> literal
%type <integerVal> fator
%type <integerVal> termo
%type <integerVal> expressao_aritmetica
%type <integerVal> expressao_relacional
%type <integerVal> expressao_logica
%type <integerVal> expr
%type <integerVal> chamada_funcao
%type <integerVal> local
%type <integerVal> comando

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

%token IMPRIMIR           "imprimir"


%%



programa: lista_comandos
   ;


lista_comandos:
   comando
   | lista_comandos PONTOEVIRGULA comando
   ;

comando:
   local ATRIBUICAO expr { $$ = $3; } // { tabelahash.inserir( *$1, int ($3) ) }
   | chamada_funcao
   ;

local:
   IDENTIFICADOR { $$ = $1;}
   ;

chamada_funcao:
	IMPRIMIR PARENTESESESQUERDO expr PARENTESESDIREITO { std::cout << $3 << std::endl;} // { tabelahash.imprimir($3, IDENTIFICADOR ) }
   ;

expr:
   expressao_logica
  ;

  expressao_logica:
   expressao_logica E expressao_relacional { $$ = $1 && $3 ;}
   | expressao_logica OU expressao_relacional { $$ = $1 || $3 ;}
   | expressao_relacional
   ;

expressao_relacional:
	expressao_relacional MENOROUIGUAL expressao_aritmetica { $$ = $1 <= $3 ;}
   | expressao_relacional MAIOROUIGUAL expressao_aritmetica  { $$ = $1 >= $3 ;}
   | expressao_relacional MENOR expressao_aritmetica  { $$ = $1 < $3 ;}
   | expressao_relacional MAIOR expressao_aritmetica  { $$ = $1 > $3 ;}
   | expressao_relacional DIFERENTE expressao_aritmetica  { $$ = $1 != $3 ;}
   | expressao_relacional COMPARACAO expressao_aritmetica { $$ = $1 == $3 ;}
   | expressao_aritmetica
   ;

expressao_aritmetica:
	expressao_aritmetica MAIS termo { $$ = $1 + $3;}
	| expressao_aritmetica MENOS termo { $$ = $1 - $3;}
	| termo
   ;


termo:
	termo ASTERISCO fator { $$ = $1 * $3;}
	| termo BARRA fator { $$ = $1 / $3;}
	| fator
   ;

fator:
	PARENTESESESQUERDO expr PARENTESESDIREITO { $$ = $2;}
	| literal
	| local
   ;


  literal:
	  INTEIRO { $$ = $1;}
   ;


%%

namespace Simples {
   void Parser::error(const location&, const std::string& m) {
        std::cerr << *driver.location_ << ": " << m << std::endl;
        driver.error_ = (driver.error_ == 127 ? 127 : driver.error_ + 1);
   }
}
