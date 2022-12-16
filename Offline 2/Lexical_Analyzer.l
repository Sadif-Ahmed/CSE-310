%option noyywrap

%x comment_state
 /*C Code Section*/
%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string>
    #include<iostream>
    #include "SymbolTable.h"
    using namespace std;

    long line_count=1;
    long error_count=0;
    string comment="";

    FILE *log = fopen("log.txt","w");
    FILE *token = fopen("token.txt","w")


    SymbolTable Table(10);

    pair<string,int> string_manipulation(string str)
    {
        long temp_l = line_count;
        string temp_s;
        for(int i=0,i<str.size();i++)
        {
            if(str[i]=='\n')
            {
                line_count++;
            }
            if(str[i]=='\\' && str[i+1]=='\n')
            {
                continue;
            }
            long flag=0;
            if(str[i]=='\\' && str[i+1]=='n')
            {
                temp_s.push_back('\n');
            }
            else if(str[i]=='\\' && str[i+1]=='t')
            {
                temp_s.push_back('\t');
            }
            else if(str[i]=='\\' && str[i+1]=='\\')
            {
                temp_s.push_back('\\');
            }
            else if(str[i]=='\\' && str[i+1]=='\'')
            {
                temp_s.push_back('\'')
            }
            else if(str[i]=='\\'  && str[i+1]=='\"')
            {
                temp_s.push_back('\"');
            }
            else if(str[i]=='\\' && str[i+1]=='a')
            {
                temp_s.push_back('\a');
            }
            else if(str[i]=='\\' && str[i+1]=='\0')
            {
                temp_s.push_back('\0');
            }
            else if(str[i]=='\\' && str[i+1]=='b')
            {
                temp_s.push_back('\b');
            }
            else if(str[i]=='\\' && str[i+1]=='v')
            {
                temp_s.push_back('\v');
            }
            else if(str[i]=='\\' && str[i+1]=='r')
            {
                temp_s.push_back('\r');
            }
            else if(str[i]=='\\' && str[i+1]=='f')
            {
                temp_s.push_back('\f');
            }
            else if(str[i]=='\n')
            {
                continue;
            }
            else
            {
                flag=1;
                temp_s.push_back(str[i]);
            }
            if(flag==0)
            {
                i++;
            }
            }
            return make_pair(temp_s,temp_l);

    }
    void comment_new_line_counter(string str)
    {
        for(int i=0;i<str.length();i++)
        {
            if(str[i]=='\n')
            {
                line_count++;
            }
        }
    }

%}
/*Definitions Section*/

/*KEYWORD TOKENS*/
CONTINUE "continue"
DEFAULT "default"
DO "do"
RETURN "return"
SWITCH "switch"
WHILE "while"
BREAK "break"
CASE "case"
CHAR "char"
VOID "void"
DOUBLE "double"
ELSE "else"
FLOAT "float"
FOR "for"
IF "if"
INT "int"
/*OPERATORS*/
LPAREN ("(")
RPAREN (")")
LCURL ("{")
RCURL ("}")
LSQUARE ("[")
RSQUARE ("]")
ADDOP [+-]
MULOP [*/%]
INCOP ("++"|"--")
RELOP (">"|">="|"<"|"<="|"=="|"!=")
ASSIGNOP ("=")
LOGICOP ("&&"|"||")
BITOP ("&"|"|"|"^"|"<<"|">>")
NOT ("!")
COMMA (",")
SEMICOLON (";")
/*TOKEN BASE*/
DIGIT [0-9]
DIGITS {DIGIT}+
LETTER [a-zA-Z]
NEWLINE [\n]
WHITESPACE [ \t\v]+
/*COMMENTS*/
SINGLE_LINE_COMMENT ("//"(([\\]+([\n]))|[^\n]*)*)

MULTI_LINE_COMMENT ([^*]|("*"[^\n]))*"*/"

/*CONSTANTS*/
/*CHARACTER BUILDER*/
NORMAL_CHAR '([ -~]{-}['\\])'
SPECIAL_CHAR '(\\['nt\\afrbv0\"])'
CHAR_TOKEN {NORMAL_CHAR}|{SPECIAL_CHAR}
/*ID BUILDER*/
IDENTIFIER [a-zA-Z_][a-zA-Z0-9_]*
/*STRING BUILDER*/
STRING \"([^\n]|(\\[\n])|(\"))*\" 
/*INTEGER BUILDER*/
INT_TOKEN {DIGITS}
/*FLOAT BUILDER*/
EXPONENTIAL ([Ee][-+]?{DIGITS})
FLOAT_TYPE_ONE ({DIGITS}\.{DIGITS})({EXPONENTIAL})?
FLOAT_TYPE_TWO ({DIGITS})\.({EXPONENTIAL})?
FLOAT_TYPE_THREE (\.{DIGITS})({EXPONENTIAL})?
FLOAT_TYPE_FOUR ({DIGITS})({EXPONENTIAL})?
FLOAT_TOKEN ({FLOAT_TYPE_ONE}|{FLOAT_TYPE_TWO}|{FLOAT_TYPE_THREE}|{FLOAT_TYPE_FOUR})

/*ERROR DETECTION*/

/*TOO MANY DECIMAL POINT ERROR EXAMPLE:1.2.345*/
TYPE1 (\.{DIGITS})
TYPE2 ({DIGITS}\.{DIGITS})
TOO_MANY_DECIMAL_POINT_ERROR ({TYPE2}|{TYPE1})({TYPE2}|{TYPE1})*

/*INVALID SUFFIX OR PREFIX EXAMPLE:12abcd*/
INVALID_SUFFIX_PREFIX [0-9]*[A-Za-z_]*

/* ILL FORMED NUMBER EXAMPLE:11E3.5*/
ILL_TYPE_ONE ({DIGITS}\.{DIGITS})([Ee][-+]?)({FLOAT_TOKEN})
ILL_TYPE_TWO (\.{DIGITS})([Ee][-+]?)({FLOAT_TOKEN})
ILL_TYPE_THREE ({DIGITS})([Ee][-+]?)({FLOAT_TOKEN})
ILL_TYPE_FOUR ({TOO_MANY_DECIMAL_POINT_ERROR}(\.))([Ee][-+]?)(.*)([Ee][-+]?)?
ILL_TYPE_FIVE ([Ee][-+]?)?({FLOAT_TOKEN})
ILL_TYPE_SIX ({DIGITS}(\.))
ILL_FORMED_NUMBER {ILL_TYPE_ONE}|{ILL_TYPE_TWO}|{ILL_TYPE_THREE}

/*UNFINISHED CHARACTERS EXAMPLE:‘a , ‘\n or ‘\’ */
NORMAL_CHAR_FOR_ERR ([ -~]{-}['])
SPECIAL_CHAR_FOR_ERR (\\[nt\\afrbv0\"])

UNFINISHED_CHAR_ERROR_ONE '({NORMAL_CHAR_FOR_ERR}|{SPECIAL_CHAR_FOR_ERR})*
FORWARD_SLASH '[\\]'

UNFINISHED_CHAR_ERROR {UNFINISHED_CHAR_ERROR_ONE}|{FORWARD_SLASH}

/*UNFINISHED COMMENT*/
STAR_FOLLOWED_BY_ANYTHING_EXCEPT_SLASH \*[^\/]
ANYTHING_EXCEPT_STAR [^*]
UNFINISHED_COMMENT "/*"({ANYTHING_EXCEPT_STAR}|{STAR_FOLLOWED_BY_ANYTHING_EXCEPT_SLASH})*

/*MULTI CHARACTER ERROR EXAMPLE:‘ab’ */
MULTI_CHAR_ERROR '(({NORMAL_CHAR_FOR_ERR}|{SPECIAL_CHAR_FOR_ERR})+)'

/*RULES SECTION*/

{WHITESPACE} {}

{NEWLINE} {line_count++}

"/*" 
{
BEGIN comment_state;
comment += yytext;
}
{SINGLE_LINE_COMMENT} {
    long temp = line_count;
    for(int i=0;i<yytext.length();i++)
        {
            if(yytext[i]=='\n')
            {
                line_count++;
            }
        }
        fprintf(log,"Line# %d: Token <COMMENT> Lexeme %s found\n\n",temp,yytext)
}
<comment_state>"*/"{
    long temp=line_count;
    comment += yytext;

    for(int i=0;i<yytext.length();i++)
        {
            if(yytext[i]=='\n')
            {
                line_count++;
            }
        }
      fprintf(log,"Line# %d: Token <COMMENT> Lexeme %s found\n\n",temp,comment.c_str());
      comment="";
      BEGIN INITIAL;   
}
<comment_state>.|\n{
    comment+=yytext;
}
<comment_state><<EOF>>{
    error_count++;
    long temp= line_count;
     for(int i=0;i<yytext.length();i++)
        {
            if(yytext[i]=='\n')
            {
                line_count++;
            }
        }
        fprintf(logfile,"Error at line# %d: Unfinished comment %s\n\n",temp,comment.c_str());
        return 0;
}
{INT_TOKEN}{
    fprintf(token,"<CONST_INT,%s>",yytext);
    fprintf(log,"Line# %d: Token <CONST_INT> Lexeme %s found\n\n",temp,yytext);
}
{FLOAT_TOKEN}{
     fprintf(token,"<CONST_FLOAT,%s>",yytext);
    fprintf(log,"Line# %d: Token <CONST_FLOAT> Lexeme %s found\n\n",temp,yytext);
}
{CHAR_TOKEN}{
    string temp= yytext;
    if(temp.length()==3)
    {
        fprintf(token,"<CONST_CHAR,%c> ",temp[1]);
        fprintf(log,"Line# %d: Token <CONST_CHAR> Lexeme %s found\n\n",line_count,yytext)
    }
    else
    {
        char temp_ch;
        switch(temp[2]):
        {
            case 'n': 
            {
                temp_ch='\n';
                break
            }
            case 't':
            {
                temp_ch='\t';
                break;
            }
            case 'a':
            {
                temp_ch='\a';
                break;
            }
            case 'f':
            {
                temp_ch='\f':
                break;
            }
            case 'r':
            {
                temp_ch='\r';
                break;
            }
            case 'b':
            {
                temp_ch='\b'
                break;
            }
            case 'v':
            {
                temp_ch='\v';
                break;
            }
            case '0':
            {
                temp_ch='\0';
                break;
            }
            case '\'':
            {
                temp_ch='\'';
                break;
            }
            case '\"':
            {
                temp_ch='\"';
                break;
            }
            case '\\':
            {
                temp_ch='\\';
                break;
            }
        }
        fprintf(token,"<CONST_CHAR,%c> ",temp_ch);
        fprintf(log,"Line# %d: Token <CONST_CHAR> Lexeme %s found\n\n",line_count,yytext);
}


