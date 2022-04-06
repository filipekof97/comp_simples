%{ /* -*- C++ -*- */

#include "parser.hh"
#include "scanner.hh"
#include "driver.hh"

/*  Defines some macros to update locations */
#define STEP() do {driver.location_->step();} while (0)
#define COL(col) driver.location_->columns(col)
#define LINE(line) do {driver.location_->lines(line);} while (0)
#define YY_USER_ACTION COL(yyleng);

/* import the parser's token type into a local typedef */
typedef Simples::Parser::token token;
typedef Simples::Parser::token_type token_type;

/* By default yylex returns int, we use token_type. Unfortunately yyterminate
 * by default returns 0, which is not of token_type. */
#define yyterminate() return token::TOK_EOF

%}

/*** Flex Declarations and Options ***/

/* enable scanner to generate debug output. disable this for release
 * versions. */
%option debug
/* enable c++ scanner class generation */
%option c++
/* we donâ€™t need yywrap */
%option noyywrap
/* you should not expect to be able to use the program interactively */
%option never-interactive
/* provide the global variable yylineno */
%option yylineno
/* do not fabricate input text to be scanned */
%option nounput
/* the manual says "somewhat more optimized" */
%option batch
/* change the name of the scanner class. results in "SimplesFlexLexer" */
%option prefix="Simples"

/*
%option stack
*/

/* Abbreviations.  */

blank   [ \t]+
eol     [\n\r]+

%%

 /* The following paragraph suffices to track locations accurately. Each time
 yylex is invoked, the begin position is moved onto the end position. */
%{
  STEP();
%}






","   {return VIRGULA;}
":"   {return DOISPONTOS;}
";"   {return PONTOEVIRGULA;}
"("   {return PARENTESESESQUERDA;}
")"   {return PARENTESESDIREITA;}
"["   {return COLCHETESESQUERDA;}
"]"   {return COLCHETESDIREITA;}
"{"   {return CHAVESESQUERDA;}
"}"   {return CHAVESDIREITA;}
"."   {return PONTO;}
"+"   {return MAIS;}
"-"   {return MENOS;}
"*"   {return ASTERISCO;}
"/"   {return BARRA;}
":="  {return ATRIBUICAO;}
"=="  {return COMPARACAO;}
"!="  {return DIFERENTE;}
"<"   {return MENOR;}
"<="  {return MENOROUIGUAL;}
">"   {return MAIOR;}
">="  {return MAIOROUIGUAL;}
"&"   {return ECOMERCIAL;}
"|"   {return PIPE;}
"="   {return DECLARACAO;}





"cadeia"     {return CADEIA;}
"valor"      {return VALOR;}
"ref"        {return REF;}
"retorne"    {return RETORNE;}
"nulo"       {return NULO;}
"ini­cio"     {return INICIO;}
"fim"        {return FIM;}
"pare"       {return PARE;}
"continue"   {return CONTINUE;}
"para"       {return PARA;}
"fpara"      {return FPARA;}
"enquanto"   {return ENQUANTO;}
"fenquanto"  {return FENQUANTO;}
"faca"       {return FACA;}
"se"         {return SE;}
"fse"        {return FSE;}
"verdadeiro" {return VERDADEIRO;}
"falso"      {return FALSO;}
"tipo"       {return TIPO;}
"de"         {return DE;}
"limite"     {return LIMITE;}
"global"     {return GLOBAL;}
"local"      {return LOCAL;}


 /*** BEGIN EXAMPLE - Change the example lexer rules below ***/

[0-9]+ {
     yylval->integerVal = atoi(yytext);
     return token::INTEGER;
 }

[0-9]+"."[0-9]* {
  yylval->doubleVal = atof(yytext);
  return token::REAL;
}

[A-Za-z][A-Za-z0-9_,.-]* {
  yylval->stringVal = new std::string(yytext, yyleng);
  return token::IDENTIFIER;
}

"/*" {comment_level+=1; BEGIN COMMENT;}
<COMMENT>"*/" {comment_level-=1; if(comment_level==0) BEGIN 0;}
<COMMENT><<EOF>> {EM_error(EM_tokPos,"unclosed comment");
  yyterminate();}
<COMMENT>.

\"   {adjust(); init_string_buffer(); BEGIN INSTRING;}
<INSTRING>\"  {adjust(); yylval.sval = String(string_buffer); BEGIN 0; return STRING;}
<INSTRING>\n  {adjust(); EM_error(EM_tokPos,"unclose string: newline appear in string"); yyterminate();}
<INSTRING><<EOF>> {adjust(); EM_error(EM_tokPos,"unclose string"); yyterminate();}
<INSTRING>\\[0-9]{3} {adjust(); int tmp; sscanf(yytext+1, "%d", &tmp);
                      if(tmp > 0xff) { EM_error(EM_tokPos,"ascii code out of range"); yyterminate(); }
                      append_to_buffer(tmp);
                      }



{blank} { STEP(); }

{eol}  { LINE(yyleng); }

.             {
                std::cerr << *driver.location_ << " Unexpected token : "
                                              << *yytext << std::endl;
                driver.error_ = (driver.error_ == 127 ? 127
                                : driver.error_ + 1);
                STEP ();
              }

%%

/* CUSTOM C++ CODE */

namespace Simples {

  Scanner::Scanner() : SimplesFlexLexer() {}

  Scanner::~Scanner() {}

  void Scanner::set_debug(bool b) {
    yy_flex_debug = b;
  }
}

#ifdef yylex
# undef yylex
#endif

int SimplesFlexLexer::yylex()
{
  std::cerr << "call parsepitFlexLexer::yylex()!" << std::endl;
  return 0;
}
