%option noyywrap

%x comment_state

%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string>
    #include<iostream>
    #include "SymbolTable.h"
    using namespace std;

    int line_count=1;
    int error_count=0;
    string comment="";

    FILE *log_ = fopen("1905058_log.txt","w");
    FILE *token = fopen("1905058_token.txt","w");


    SymbolTable Table(10);

   std::string StringFormatter(const std::string str)
{
    std::string temp_s = string(str);
    std::string formatted_s = "";
    char prev_char = 0;

    for(size_t i = 1; i < temp_s.size() - 1; ++i)
    {
        if(prev_char == '\\')
        {
            prev_char = temp_s[i];

            if(temp_s[i] == '\'')
            {
                formatted_s += '\'';
            }
            else if(temp_s[i] == '\"')
            {
                formatted_s += '\"';
            }
            else if(temp_s[i] == 'n')
            {
                formatted_s += '\n';
            }
            else if(temp_s[i] == 't')
            {
                formatted_s += '\t';
            }
            else if(temp_s[i] == '\\')
            {
                formatted_s += '\\';
                prev_char = 0;
            }
            else if(temp_s[i] == 'a')
            {
                formatted_s += '\a';
            }
            else if(temp_s[i] == 'f')
            {
                formatted_s += '\f';
            }
            else if(temp_s[i] == 'r')
            {
                formatted_s += '\r';
            }
            else if(temp_s[i] == 'b')
            {
                formatted_s += '\b';
            }
            else if(temp_s[i] == 'v')
            {
                formatted_s += '\v';
            }
            else if(temp_s[i] == '0')
            {
                formatted_s += '\0';
            }
            else if(temp_s[i] == '\r')
            {
                prev_char = '\\';
            }
            else if(temp_s[i] == '\n')
            {
                
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

/*COMMENTS*/
SINGLE_LINE_COMMENT \/\/[^\r\n]*([\r]?\n|$)
MULTILINE_COMMENT_1 \/\/([^\r\n\\]|\\[ \t]*[\r]?\n)*([\r]?\n|$)
MULTILINE_COMMENT_2 \/\*([^\*]|\*[^\/])*\*\/

/*CONSTANTS*/
/*CHARACTER BUILDER*/
CHAR_TOKEN {NORMAL_CHAR}|{SPECIAL_CHAR}
/*ID BUILDER*/
IDENTIFIER [a-zA-Z_][a-zA-Z0-9_]*
/*STRING BUILDER*/
SINGLELINE_STRING_LITERAL \"([^\\\'\"\n\r]|\\n|\\t|\\\"|\\\'|\\\\|\\a|\\f|\\r|\\b|\\v|\\0)*\"
MULTILINE_STRING_LITERAL \"([^\\\'\"\n\r]|\\n|\\t|\\\"|\\\'|\\\\|\\a|\\f|\\r|\\b|\\v|\\0|\\[\r]?\n)*\"
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
UNFINISHED_CHAR_ERROR {UNFINISHED_CHAR_ERROR_ONE}|{FORWARD_SLASH}

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
    fprintf(token,"<CONST_INT, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <CONST_INT> Lexeme %s found\n",line_count,yytext);
}
{FLOAT_TOKEN} {
     fprintf(token,"<CONST_FLOAT, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <CONST_FLOAT> Lexeme %s found\n",line_count,yytext);
}
{CHAR_TOKEN} {
    string temp= yytext;
    if(temp.length()==3)
    {
        fprintf(token,"<CONST_CHAR, %c>\n",temp[1]);
        fprintf(log_,"Line# %d: Token <CONST_CHAR> Lexeme %s found\n",line_count,yytext);
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
        fprintf(token,"<CONST_CHAR, %c>\n",temp_ch);
        fprintf(log_,"Line# %d: Token <CONST_CHAR> Lexeme %s found\n",line_count,yytext);
    }
       
}
{BREAK} {
    fprintf(token,"<BREAK, break>\n");
    fprintf(log_,"Line# %d: Token <BREAK> Lexeme %s found\n",line_count,yytext);
}
{CASE} {
    fprintf(token,"<CASE, case>\n");
    fprintf(log_,"Line# %d: Token <CASE> Lexeme %s found\n",line_count,yytext);
}
{CHAR} {
     fprintf(token,"<CHAR, char>\n");
    fprintf(log_,"Line# %d: Token <CHAR> Lexeme %s found\n",line_count,yytext);
}
{CONTINUE} {
    fprintf(token,"<CONTINUE, continue>\n");
    fprintf(log_,"Line# %d: Token <CONTINUE> Lexeme %s found\n",line_count,yytext);
}
{DEFAULT} {
    fprintf(token,"<DEFAULT, default>\n");
    fprintf(log_,"Line# %d: Token <DEFAULT> Lexeme %s found\n",line_count,yytext);
}
{DO} {
    fprintf(token,"<DO, do>\n");
    fprintf(log_,"Line# %d: Token <DO> Lexeme %s found\n",line_count,yytext);
}
{DOUBLE} {
    fprintf(token,"<DOUBLE, double>\n");
    fprintf(log_,"Line# %d: Token <DOUBLE> Lexeme %s found\n",line_count,yytext);
}
{ELSE} {
    fprintf(token,"<ELSE, else>\n");
    fprintf(log_,"Line# %d: Token <ELSE> Lexeme %s found\n",line_count,yytext);
}
{FLOAT} {
    fprintf(token,"<FLOAT, float>\n");
    fprintf(log_,"Line# %d: Token <FLOAT> Lexeme %s found\n",line_count,yytext);
}
{FOR} {
    fprintf(token,"<FOR, for>\n");
    fprintf(log_,"Line# %d: Token <FOR> Lexeme %s found\n",line_count,yytext);
}
{IF} {
    fprintf(token,"<IF, if>\n");
    fprintf(log_,"Line# %d: Token <IF> Lexeme %s found\n",line_count,yytext);
}
{INT} {
    fprintf(token,"<INT, int>\n");
    fprintf(log_,"Line# %d: Token <INT> Lexeme %s found\n",line_count,yytext);
}
{RETURN} {
    fprintf(token,"<RETURN, return>\n");
    fprintf(log_,"Line# %d: Token <RETURN> Lexeme %s found\n",line_count,yytext);
}
{SWITCH} {
    fprintf(token,"<SWITCH, switch>\n");
    fprintf(log_,"Line# %d: Token <SWITCH> Lexeme %s found\n",line_count,yytext);
}
{WHILE} {
    fprintf(token,"<WHILE, while>\n");
    fprintf(log_,"Line# %d: Token <WHILE> Lexeme %s found\n",line_count,yytext);
}
{VOID} {
    fprintf(token,"<VOID, void>\n");
    fprintf(log_,"Line# %d: Token <VOID> Lexeme %s found\n",line_count,yytext);
}
{ADDOP} {
    fprintf(token,"<ADDOP, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <ADDOP> Lexeme %s found\n",line_count,yytext);
}
{MULOP} {
    fprintf(token,"<MULOP, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <MULOP> Lexeme %s found\n",line_count,yytext);
}
{RELOP} {
    fprintf(token,"<RELOP, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <RELOP> Lexeme %s found\n",line_count,yytext);
}
{INCOP} {
    fprintf(token,"<INCOP, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <INCOP> Lexeme %s found\n",line_count,yytext);
}
{LOGICOP} {
    fprintf(token,"<LOGICOP, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <LOGICOP> Lexeme %s found\n",line_count,yytext);
}
{ASSIGNOP} {
    fprintf(token,"<ASSIGNOP, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <ASSIGNOP> Lexeme %s found\n",line_count,yytext);
}
{BITOP} {
    fprintf(token,"<BITOP, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <BITOP> Lexeme %s found\n",line_count,yytext);
}
{NOT} {
    fprintf(token,"<NOT, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <NOT> Lexeme %s found\n",line_count,yytext);
}
{LPAREN} {
    fprintf(token,"<LPAREN, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <LPAREN> Lexeme %s found\n",line_count,yytext);
}
{RPAREN} {
    fprintf(token,"<RPAREN, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <RPAREN> Lexeme %s found\n",line_count,yytext);
}
{LCURL} {
    fprintf(token,"<LCURL, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <LCURL> Lexeme %s found\n",line_count,yytext);
    Table.Enter_Scope();
}
{RCURL} {
    fprintf(token,"<RCURL, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <RCURL> Lexeme %s found\n",line_count,yytext);
    Table.Exit_Scope();
}
{LSQUARE} {
    fprintf(token,"<LSQUARE, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <LSQUARE> Lexeme %s found\n",line_count,yytext);
}
{RSQUARE} {
    fprintf(token,"<RSQUARE, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <RSQUARE> Lexeme %s found\n",line_count,yytext);
}
{COMMA} {
    fprintf(token,"<COMMA, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <COMMA> Lexeme %s found\n",line_count,yytext);
}
{SEMICOLON} {
    fprintf(token,"<SEMICOLON, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <SEMICOLON> Lexeme %s found\n",line_count,yytext);
}
{SINGLELINE_STRING_LITERAL} {
                               
                                string formatted_s = StringFormatter(yytext);
                                fprintf(token, "<SINGLE LINE STRING, %s>\n", formatted_s.c_str());
                                fprintf(log_, "Line# %d: Token <SINGLE LINE STRING> Lexeme %s found\n", line_count, yytext);
                            }

{MULTILINE_STRING_LITERAL} { 
                                string formatted_s = StringFormatter(yytext);
                                string temp_s=string(yytext);
                                fprintf(token, "<MULTI LINE STRING, %s>\n", formatted_s.c_str());
                                fprintf(log_, "Line# %d: Token <MULTI LINE STRING> Lexeme %s found\n", line_count, yytext);

                                for(int i = 0; i < temp_s.size(); ++i)
                                {
                                    if(temp_s[i] == '\n')
                                    {
                                        ++line_count;
                                    }
                                }
                            }

{IDENTIFIER} {
    fprintf(token,"<ID, %s>\n",yytext);
    fprintf(log_,"Line# %d: Token <ID> Lexeme %s found\n",line_count,yytext);
    if(Table.Insert(yytext,"ID",log_))
    {
        Table.printall(log_);
    }
}
{SINGLE_LINE_COMMENT} {
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

                            ++line_count;
                        }
{MULTILINE_COMMENT_1} {
                            string temp_com = yytext;
                            int additional_lines = 0;

                            if(temp_com.back() == '\n')
                            {
                                 temp_com.pop_back();
                                ++additional_lines;
                              
                            }

                            if(temp_com.back() == '\r')
                            {
                                temp_com.pop_back();
                            }

                            fprintf(log_, "Line# %d: Token <SINGLE LINE COMMENT> Lexeme %s found\n", line_count, temp_com.c_str());

                            line_count += additional_lines;

                            for(int i = 0; i < temp_com.size(); ++i)
                            {
                                if(temp_com[i] == '\n')
                                {
                                    ++line_count;
                                }
                            }
                        }

{MULTILINE_COMMENT_2} {
                            std::string temp_com = yytext;

                            fprintf(log_, "Line# %d: Token <MULTI LINE COMMENT> Lexeme %s found\n", line_count, temp_com.c_str());

                            for(int i = 0; i < comment.size(); ++i)
                            {
                                if(temp_com[i] == '\n')
                                {
                                    ++line_count;
                                }
                            }
                        }

                        
{TOO_MANY_DECIMAL_POINT_ERROR} {
    error_count++;
    fprintf(log_,"Error at line# %d: TOO_MANY_DECIMAL_POINTS %s\n",line_count,yytext);

}
{ILL_FORMED_NUMBER} {
    error_count++;
    fprintf(log_,"Error at line# %d: ILLFORMED_NUMBER %s\n",line_count,yytext);
}
{INVALID_SUFFIX_PREFIX} {
     error_count++;
    fprintf(log_,"Error at line# %d: INVALID_ID_SUFFIX_NUM_PREFIX %s\n",line_count,yytext);
}
{EMPTY_CHAR_ERROR} {
     error_count++;
    fprintf(log_,"Error at line# %d: EMPTY_CONST_CHAR %s\n",line_count,yytext);
}
{UNFINISHED_CHAR_ERROR} {
     error_count++;
    fprintf(log_,"Error at line# %d: UNFINISHED_CONST_CHAR %s\n",line_count,yytext);
}
{MULTI_CHAR_ERROR} {
     error_count++;
    fprintf(log_,"Error at line# %d: MULTICHAR_CONSTANT_CHAR %s\n",line_count,yytext);
}
{UNRECOGNISED_CHAR_ERROR} {
     error_count++;
    fprintf(log_,"Error at line# %d: UNRECOGNISED CHAR %s\n",line_count,yytext);
}
{UNFINISHED_STRING_ERROR} {
                        string temp_s = yytext;

                        for(int i = 0; i < temp_s.size(); ++i)
                        {
                            if(temp_s[i] == '\n')
                            {
                                ++line_count;
                            }
                        }

                        fprintf(log_, "Error at line# %d: UNFINISHED_STRING %s\n", line_count, yytext);

                        ++error_count;
                    }
                    
{UNFINISHED_COMMENT} {
                            string temp_s= yytext;

                            for(int i = 0; i < temp_s.size(); ++i)
                            {
                                if(temp_s[i] == '\n')
                                {
                                    ++line_count;
                                }
                            }

                            fprintf(log_, "Error at line# %d: UNFINISHED_COMMENT %s\n", line_count, yytext);

                            ++error_count;
                        } 
%%
int main(int argc,char *argv[]){
	
	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	
	
	yyin= fin;
	yylex();
    Table.printall(log_);
	fprintf(log_,"\nTotal Lines : %d\nTotal Errors : %d\n",line_count,error_count);
	fclose(yyin);
	fclose(token);
	fclose(log_);
	return 0;
}