%option noyywrap

%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string>
    #include<iostream>
    #include "1905058_SymbolTable.h"
    #include "y.tab.h"
    using namespace std;

    int line_count=1;
    int error_count=0;
  //  string comment="";

    FILE *log_ = fopen("1905058_log.txt","a");
   // FILE *token = fopen("1905058_token.txt","w");
    FILE *error = fopen("1905058_error.txt","a");


   // SymbolTable Table(10);

   string StringFormatter(const std::string str)
{
    string temp_s = string(str);
    string formatted_s = "";
    char prev_char = 0;

    for(size_t i = 1; i < temp_s.size() - 1; ++i)
    {
        if(prev_char == '\\')
        {
            prev_char = temp_s[i];
            switch(temp_s[i])
            {
                case 'n': 
            {
                formatted_s+='\n';
                break;
            }
            case 't':
            {
                formatted_s+='\t';
                break;
            }
            case 'a':
            {
                formatted_s+='\a';
                break;
            }
            case 'f':
            {
                formatted_s+='\f';
                break;
            }
            case 'r':
            {
                formatted_s+='\r';
                break;
            }
            case 'b':
            {
                formatted_s+='\b';
                break;
            }
            case 'v':
            {
                formatted_s+='\v';
                break;
            }
            case '0':
            {
                formatted_s+='\0';
                break;
            }
            case '\'':
            {
                formatted_s+='\'';
                break;
            }
            case '\"':
            {
                formatted_s+='\"';
                break;
            }
            case '\\':
            {
                formatted_s+='\\';
                break;
            }
            case '\n':
            {
                break;
            }
        }
        }
        else
        {
            prev_char = temp_s[i];

            if(temp_s[i] != '\\')
            {
                formatted_s += temp_s[i];
            }
        }
    }

    return formatted_s;
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
PRINTLN "printf"

/*OPERATORS*/
LPAREN ("(")
RPAREN (")")
LCURL ("{")
RCURL ("}")
LSQUARE ("[")
RSQUARE ("]")
ADDOP [+-]
MULOP [*/%]
INCOP ("++")
DECOP ("--")
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
WHITESPACE [ \t\f\r\v]
WHITESPACES {WHITESPACE}+
DELIM ({NEWLINE}|{WHITESPACE})
NORMAL_CHAR '([ -~]{-}['\\])'
SPECIAL_CHAR '(\\['nt\\afrbv0\"])'
EXPONENTIAL ([Ee][-+]?{DIGITS})
FLOAT_TYPE_ONE ({DIGITS}\.{DIGITS})({EXPONENTIAL})?
FLOAT_TYPE_TWO ({DIGITS})\.({EXPONENTIAL})?
FLOAT_TYPE_THREE (\.{DIGITS})({EXPONENTIAL})?
FLOAT_TYPE_FOUR ({DIGITS})({EXPONENTIAL})?
CHAR_ERROR_CHECKER ([^\\\'\"\r\n]|\\n|\\t|\\\"|\\\'|\\\\|\\a|\\f|\\r|\\b|\\v|\\0|\\[\r]?\n)

/*COMMENTS*/
SINGLE_LINE_COMMENT_TYPE_ONE \/\/[^\r\n]*
SINGLE_LINE_COMMENT_TYPE_TWO \/\/([^\r\n]*\\[\r]?\n)*[^\r\n]*
MULTIPLE_LINE_COMMENT \/\*([^\*]|\*[^\/])*\*\/

/*CONSTANTS*/
/*CHARACTER BUILDER*/
CHAR_TOKEN {NORMAL_CHAR}|{SPECIAL_CHAR}
/*ID BUILDER*/
IDENTIFIER [a-zA-Z_][a-zA-Z0-9_]*
/*STRING BUILDER*/
SINGLELINE_STRING \"([^\\\'\"\n\r]|\\n|\\t|\\\"|\\\'|\\\\|\\a|\\f|\\r|\\b|\\v|\\0)*\"
MULTILINE_STRING \"([^\\\'\"\n\r]|\\n|\\t|\\\"|\\\'|\\\\|\\a|\\f|\\r|\\b|\\v|\\0|\\[\r]?\n)*\"
/*INTEGER BUILDER*/
INT_TOKEN {DIGITS}
/*FLOAT BUILDER*/
FLOAT_TOKEN ({FLOAT_TYPE_ONE}|{FLOAT_TYPE_TWO}|{FLOAT_TYPE_THREE}|{FLOAT_TYPE_FOUR})

/*ERROR DETECTION*/
/*ERROR BASE*/
TOO_MANY_DECIMAL_POINT_ERROR_TYPE1 (\.{DIGITS})
TOO_MANY_DECIMAL_POINT_ERROR_TYPE2 ({DIGITS}\.{DIGITS})
ILL_TYPE_ONE ({DIGITS}\.{DIGITS})([Ee][-+]?)({FLOAT_TOKEN})
ILL_TYPE_TWO (\.{DIGITS})([Ee][-+]?)({FLOAT_TOKEN})
ILL_TYPE_THREE ({DIGITS})([Ee][-+]?)({FLOAT_TOKEN})
ILL_TYPE_FOUR ({TOO_MANY_DECIMAL_POINT_ERROR}(\.))([Ee][-+]?)(.*)([Ee][-+]?)?
ILL_TYPE_FIVE ([Ee][-+]?)?({FLOAT_TOKEN})
ILL_TYPE_SIX ({DIGITS}(\.))
STAR_FOLLOWED_BY_ANYTHING_EXCEPT_SLASH \*[^\/]
ANYTHING_EXCEPT_STAR [^*]
NORMAL_CHAR_FOR_ERR ([ -~]{-}['])
SPECIAL_CHAR_FOR_ERR (\\[nt\\afrbv0\"])
UNFINISHED_CHAR_ERROR_ONE '({NORMAL_CHAR_FOR_ERR}|{SPECIAL_CHAR_FOR_ERR})*
FORWARD_SLASH '[\\]'

/*TOO MANY DECIMAL POINT ERROR EXAMPLE:1.2.345*/
TOO_MANY_DECIMAL_POINT_ERROR ({TOO_MANY_DECIMAL_POINT_ERROR_TYPE2}|{TOO_MANY_DECIMAL_POINT_ERROR_TYPE1})({TOO_MANY_DECIMAL_POINT_ERROR_TYPE2}|{TOO_MANY_DECIMAL_POINT_ERROR_TYPE1})*

/*INVALID SUFFIX OR PREFIX EXAMPLE:12abcd*/
INVALID_SUFFIX_PREFIX [0-9]*[A-Za-z_]*

/* ILL FORMED NUMBER EXAMPLE:11E3.5*/
ILL_FORMED_NUMBER {ILL_TYPE_ONE}|{ILL_TYPE_TWO}|{ILL_TYPE_THREE}

/*UNFINISHED CHARACTERS EXAMPLE:‘a , ‘\n or ‘\’ */
UNFINISHED_CHAR_ERROR \'{CHAR_ERROR_CHECKER}?

/*UNFINISHED COMMENT*/
UNFINISHED_COMMENT \/\*([^\*]|\*[^\/])*

/*MULTI CHARACTER ERROR EXAMPLE:‘ab’ */
MULTI_CHAR_ERROR '(({NORMAL_CHAR_FOR_ERR}|{SPECIAL_CHAR_FOR_ERR})+)'

/*EMPTY*/
EMPTY_CHAR_ERROR ('')

/*UNFINISHED STRING*/
UNFINISHED_STRING_ERROR \"([^\\\'\"\n\r]|\\n|\\t|\\\"|\\\'|\\\\|\\a|\\f|\\r|\\b|\\v|\\0|\\[\r]?\n)*

/*UNRECOGNISED CHARACTER*/
UNRECOGNISED_CHAR_ERROR [^\n]

/*RULES SECTION*/
%%
{NEWLINE} {line_count++;}

{WHITESPACE} {}


{INT_TOKEN} {
    //fprint(token,"<CONST_INT, %s>\n",yytext);
    SymbolInfo *t =  new SymbolInfo(yytext,"CONST_INT");
    yylval.symbol=t;
    fprintf(log_,"Line# %d: Token <CONST_INT> Lexeme %s found\n",line_count,yytext);
    return CONST_INT;
}
{FLOAT_TOKEN} {
    //fprint(token,"<CONST_FLOAT, %s>\n",yytext);
    SymbolInfo *t =  new SymbolInfo(yytext,"CONST_FLOAT");
    yylval.symbol=t;
    fprintf(log_,"Line# %d: Token <CONST_FLOAT> Lexeme %s found\n",line_count,yytext);
    return CONST_FLOAT;
}
{CHAR_TOKEN} {
    string temp= yytext;
    if(temp.length()==3)
    {
        //fprint(token,"<CONST_CHAR, %c>\n",temp[1]);
        SymbolInfo *t =  new SymbolInfo(yytext,"CONST_CHAR");
        yylval.symbol=t;
        fprintf(log_,"Line# %d: Token <CONST_CHAR> Lexeme %c found\n",line_count,yytext[1]);
        return CONST_CHAR;
    }
    else
    {
        char temp_ch;
        switch(temp[2])
        {
            case 'n': 
            {
                temp_ch='\n';
                break;
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
                temp_ch='\f';
                break;
            }
            case 'r':
            {
                temp_ch='\r';
                break;
            }
            case 'b':
            {
                temp_ch='\b';
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
        //fprint(token,"<CONST_CHAR, %c>\n",temp_ch);
        SymbolInfo *t =  new SymbolInfo(yytext,"CONST_CHAR");
        yylval.symbol=t;
        fprintf(log_,"Line# %d: Token <CONST_CHAR> Lexeme %c found\n",line_count,temp_ch);
        return CONST_CHAR;
    }
       
}
{BREAK} {
    //fprint(token,"<BREAK, break>\n");
    fprintf(log_,"Line# %d: Token <BREAK> Lexeme %s found\n",line_count,yytext);
    return BREAK;
}
{PRINTLN} {
    fprintf(log_,"Line# %d: Token <PRINTLN> Lexeme %s found\n",line_count,yytext);
    return PRINTLN;
}
{CASE} {
   //fprint(token,"<CASE, case>\n");
    fprintf(log_,"Line# %d: Token <CASE> Lexeme %s found\n",line_count,yytext);
    return CASE;
}
{CHAR} {
     //fprint(token,"<CHAR, char>\n");
    fprintf(log_,"Line# %d: Token <CHAR> Lexeme %s found\n",line_count,yytext);
    return CHAR;
}
{CONTINUE} {
    //fprint(token,"<CONTINUE, continue>\n");
    fprintf(log_,"Line# %d: Token <CONTINUE> Lexeme %s found\n",line_count,yytext);
    return CONTINUE;
}
{DEFAULT} {
    //fprint(token,"<DEFAULT, default>\n");
    fprintf(log_,"Line# %d: Token <DEFAULT> Lexeme %s found\n",line_count,yytext);
    return DEFAULT;
}
{DO} {
    //fprint(token,"<DO, do>\n");
    fprintf(log_,"Line# %d: Token <DO> Lexeme %s found\n",line_count,yytext);
    return DO;
}
{DOUBLE} {
    //fprint(token,"<DOUBLE, double>\n");
    fprintf(log_,"Line# %d: Token <DOUBLE> Lexeme %s found\n",line_count,yytext);
    return DOUBLE;
}
{ELSE} {
    //fprint(token,"<ELSE, else>\n");
    fprintf(log_,"Line# %d: Token <ELSE> Lexeme %s found\n",line_count,yytext);
    return ELSE;
}
{FLOAT} {
    //fprint(token,"<FLOAT, float>\n");
    fprintf(log_,"Line# %d: Token <FLOAT> Lexeme %s found\n",line_count,yytext);
    return FLOAT;
}
{FOR} {
    //fprint(token,"<FOR, for>\n");
    fprintf(log_,"Line# %d: Token <FOR> Lexeme %s found\n",line_count,yytext);
    return FOR;
}
{IF} {
    //fprint(token,"<IF, if>\n");
    fprintf(log_,"Line# %d: Token <IF> Lexeme %s found\n",line_count,yytext);
    return IF;
}
{INT} {
    //fprint(token,"<INT, int>\n");
    fprintf(log_,"Line# %d: Token <INT> Lexeme %s found\n",line_count,yytext);
    return INT;
}
{RETURN} {
    //fprint(token,"<RETURN, return>\n");
    fprintf(log_,"Line# %d: Token <RETURN> Lexeme %s found\n",line_count,yytext);
    return RETURN;
}
{SWITCH} {
    //fprint(token,"<SWITCH, switch>\n");
    fprintf(log_,"Line# %d: Token <SWITCH> Lexeme %s found\n",line_count,yytext);
    return SWITCH;
}
{WHILE} {
    //fprint(token,"<WHILE, while>\n");
    fprintf(log_,"Line# %d: Token <WHILE> Lexeme %s found\n",line_count,yytext);
    return WHILE;
}
{VOID} {
    //fprint(token,"<VOID, void>\n");
    fprintf(log_,"Line# %d: Token <VOID> Lexeme %s found\n",line_count,yytext);
    return VOID;
}
{ADDOP} {
    //fprint(token,"<ADDOP, %s>\n",yytext);
    SymbolInfo *t =  new SymbolInfo(yytext,"ADDOP");
    yylval.symbol=t;
    fprintf(log_,"Line# %d: Token <ADDOP> Lexeme %s found\n",line_count,yytext);
    return ADDOP;
}
{MULOP} {
    //fprint(token,"<MULOP, %s>\n",yytext);
     SymbolInfo *t =  new SymbolInfo(yytext,"MULOP");
    yylval.symbol=t;
    fprintf(log_,"Line# %d: Token <MULOP> Lexeme %s found\n",line_count,yytext);
    return MULOP;
}
{RELOP} {
    //fprint(token,"<RELOP, %s>\n",yytext);
    SymbolInfo *t =  new SymbolInfo(yytext,"RELOP");
    yylval.symbol=t;
    fprintf(log_,"Line# %d: Token <RELOP> Lexeme %s found\n",line_count,yytext);
    return RELOP;
}
{INCOP} {
    //fprint(token,"<INCOP, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <INCOP> Lexeme %s found\n",line_count,yytext);
    return INCOP;
}
{DECOP} {
    //fprint(token,"<DECOP, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <DECOP> Lexeme %s found\n",line_count,yytext);
    return DECOP;
}
{LOGICOP} {
    //fprint(token,"<LOGICOP, %s>\n",yytext);
    SymbolInfo *t =  new SymbolInfo(yytext,"LOGICOP");
    yylval.symbol=t;
    fprintf(log_,"Line# %d: Token <LOGICOP> Lexeme %s found\n",line_count,yytext);
    return LOGICOP;
}
{ASSIGNOP} {
    //fprint(token,"<ASSIGNOP, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <ASSIGNOP> Lexeme %s found\n",line_count,yytext);
    return ASSIGNOP;
}
{BITOP} {
    //fprint(token,"<BITOP, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <BITOP> Lexeme %s found\n",line_count,yytext);
    return BITOP;
}
{NOT} {
    //fprint(token,"<NOT, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <NOT> Lexeme %s found\n",line_count,yytext);
    return NOT;
}
{LPAREN} {
    //fprint(token,"<LPAREN, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <LPAREN> Lexeme %s found\n",line_count,yytext);
    return LPAREN;
}
{RPAREN} {
    //fprint(token,"<RPAREN, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <RPAREN> Lexeme %s found\n",line_count,yytext);
    return RPAREN;
}
{LCURL} {
    //fprint(token,"<LCURL, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <LCURL> Lexeme %s found\n",line_count,yytext);
   // Table.Enter_Scope();
   return LCURL;
}
{RCURL} {
    //fprint(token,"<RCURL, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <RCURL> Lexeme %s found\n",line_count,yytext);
   // Table.Exit_Scope();
   return RCURL;
}
{LSQUARE} {
    //fprint(token,"<LSQUARE, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <LSQUARE> Lexeme %s found\n",line_count,yytext);
    return LSQUARE;
}
{RSQUARE} {
    //fprint(token,"<RSQUARE, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <RSQUARE> Lexeme %s found\n",line_count,yytext);
    return RSQUARE;
}
{COMMA} {
    //fprint(token,"<COMMA, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <COMMA> Lexeme %s found\n",line_count,yytext);
    return COMMA;
}
{SEMICOLON} {
    //fprint(token,"<SEMICOLON, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <SEMICOLON> Lexeme %s found\n",line_count,yytext);
    return SEMICOLON;
}
{IDENTIFIER} {
    //fprint(token,"<ID, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <ID> Lexeme %s found\n",line_count,yytext);
   SymbolInfo *t =  new SymbolInfo(yytext,"ID");
    yylval.symbol=t;
    return ID;
}
{SINGLELINE_STRING} {
                               
                                string formatted_s = StringFormatter(yytext);
                                //fprint(token, "<SINGLE LINE STRING, %s>\n", formatted_s.c_str());
                                fprintf(log_, "Line# %d: Token <SINGLE LINE STRING> Lexeme %s found\n", line_count, yytext);
                            }

{MULTILINE_STRING} { 
                                string formatted_s = StringFormatter(yytext);
                                string temp_s=string(yytext);
                                //fprint(token, "<MULTI LINE STRING, %s>\n", formatted_s.c_str());
                                fprintf(log_, "Line# %d: Token <MULTI LINE STRING> Lexeme %s found\n", line_count, yytext);

                                for(int i = 0; i < temp_s.size(); ++i)
                                {
                                    if(temp_s[i] == '\n')
                                    {
                                        line_count++;
                                    }
                                }
                            }


{SINGLE_LINE_COMMENT_TYPE_ONE} {
                            string temp_s = yytext;
                            if(temp_s.back() == '\n')
                            {
                                temp_s.pop_back();
                            }

                            if(temp_s.back() == '\r')
                            {
                                temp_s.pop_back();
                            }

                            fprintf(log_, "Line# %d: Token <SINGLE LINE COMMENT> Lexeme %s found\n", line_count, temp_s.c_str());

                          
                        }
{SINGLE_LINE_COMMENT_TYPE_TWO} {
                            string temp_com = string(yytext);
                            int additional_lines = 0;

                            if(temp_com.back() == '\n')
                            {
                                 temp_com.pop_back();
                                additional_lines++;
                              
                            }

                            if(temp_com.back() == '\r')
                            {
                                temp_com.pop_back();
                            }
                            //line_count++;

                            fprintf(log_, "Line# %d: Token <SINGLE LINE COMMENT> Lexeme %s found\n", line_count, temp_com.c_str());

                            line_count += additional_lines;

                            for(int i = 0; i < temp_com.size(); ++i)
                            {
                                if(temp_com[i] == '\n')
                                {
                                    line_count++;
                                }
                            }
                           
                        }

{MULTIPLE_LINE_COMMENT} {
                            std::string temp_com = string(yytext);

                            fprintf(log_, "Line# %d: Token <MULTI LINE COMMENT> Lexeme %s found\n", line_count, temp_com.c_str());

                            for(int i = 0; i < temp_com.size(); ++i)
                            {
                                if(temp_com[i] == '\n')
                                {
                                    line_count++;
                                }
                            }
                        }

                        
{TOO_MANY_DECIMAL_POINT_ERROR} {
    error_count++;
    fprintf(error,"Error at line# %d: TOO_MANY_DECIMAL_POINTS %s\n",line_count,yytext);

}
{ILL_FORMED_NUMBER} {
    error_count++;
    fprintf(error,"Error at line# %d: ILLFORMED_NUMBER %s\n",line_count,yytext);
}
{INVALID_SUFFIX_PREFIX} {
     error_count++;
    fprintf(error,"Error at line# %d: INVALID_ID_SUFFIX_NUM_PREFIX %s\n",line_count,yytext);
}
{EMPTY_CHAR_ERROR} {
     error_count++;
    fprintf(error,"Error at line# %d: EMPTY_CONST_CHAR %s\n",line_count,yytext);
}
{UNFINISHED_CHAR_ERROR} {
     error_count++;
    fprintf(error,"Error at line# %d: UNFINISHED_CONST_CHAR %s\n",line_count,yytext);
}
{MULTI_CHAR_ERROR} {
     error_count++;
    fprintf(error,"Error at line# %d: MULTICHAR_CONST_CHAR %s\n",line_count,yytext);
}

{UNFINISHED_STRING_ERROR} {
                        string temp_s = yytext;

                        for(int i = 0; i < temp_s.size(); ++i)
                        {
                            if(temp_s[i] == '\n')
                            {
                                line_count++;
                            }
                        }

                        fprintf(error, "Error at line# %d: UNFINISHED_STRING %s\n", line_count, yytext);

                        ++error_count;
                    }
                    
{UNFINISHED_COMMENT} {
                            string temp_s= yytext;

                            for(int i = 0; i < temp_s.size(); ++i)
                            {
                                if(temp_s[i] == '\n')
                                {
                                    line_count++;
                                }
                            }
                             while(temp_s.back() == '\r' || temp_s.back() == '\n')
                            {
                                temp_s.pop_back();
                            
                            }
                            error_count++;

                            fprintf(error, "Error at line# %d: UNFINISHED_COMMENT %s\n", line_count, yytext);

                            
                        } 
{UNRECOGNISED_CHAR_ERROR} {
     error_count++;
    fprintf(error,"Error at line# %d: UNRECOGNIZED_CHAR %s\n",line_count,yytext);
}                        
%%
