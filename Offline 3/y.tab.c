/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output, and Bison version.  */
#define YYBISON 30802

/* Bison version string.  */
#define YYBISON_VERSION "3.8.2"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* First part of user prologue.  */
#line 1 "1905058.y"

#include<iostream>
#include<cstdio>
#include<cstdlib>
#include<cstring>
#include<cmath>
#include<string>
#include<vector>
#include<bits/stdc++.h>
#include "1905058_SymbolTable.h"

using namespace std;

int yyparse(void);
int yylex(void);

extern FILE *yyin;
FILE *fp;
extern FILE *log_;
// FILE *token = fopen("1905058_token.txt","w");
extern FILE *error;

SymbolTable table(11);

extern int line_count;
extern int error_count;

string var_type;
string curr_ret_type;

struct var_
{
    string name;
    int size;
} temp_var;

struct func_
{
    string name;
    vector<pair<string,string>> parametres;
    string ret_type;
} temp_func;

vector<var_> var_list;
vector<func_> func_list;

void func_insert(string name , vector<func_param>& params , string ret_type){
    temp_func.name = name;
    temp_func.ret_type = ret_type;
    for(int i=0;i<params.size();i++){
        temp_func.parametres.push_back(make_pair(params[i].type , params[i].name));
    }
    func_list.push_back(temp_func);
    temp_func.parametres.clear();
}

void func_insert(string name , string ret_type){
    temp_func.name = name;
    temp_func.ret_type = ret_type;
    func_list.push_back(temp_func);
}
bool check_func(string name){
  for(int i=0;i<func_list.size();i++){
    if(func_list[i].name==name){
      return true;
    }
  }
  return false;
}
func_ get_func(string name){
  for(int i=0;i<func_list.size();i++){
    if(func_list[i].name==name){
      return func_list[i];
    }
  }
}
void print_funcs()
{
    for(int i=0;i<func_list.size();i++)
    {
        cout<<func_list[i].name;
        cout<<func_list[i].ret_type;
        for(int i=0;i<func_list[i].parametres.size();i++)
        {
            cout<<func_list[i].parametres[i].first<<"  "<<func_list[i].parametres[i].second<<endl;
        }
    }
}
string to_str(int n)
{
    string temp;
	while(n){
		int r=n%10;
		n/=10;
		temp.push_back(r+48);
  }

	reverse(temp.begin(),temp.end());
	return temp;
}
string array_name(string str){
  string done="";
  for(int i=0;i<str.size();i++){

    if(str[i]!='['){
      done+=str[i];
    }else{
      return done;
    }
  }
  return str;
}
string func_name(string str){
 
  string done="";
  for(int i=0;i<str.size();i++){

    if(str[i]!='('){
      done+=str[i];
    }else{
      return done;
    }
  }
  return str;
}
bool array_index_checker(string name,int size)
{
    string idx="";
  for(int i=0;i<name.size();i++){
    if(name[i]=='['){
      i++;
      while(name[i]!=']'){
        if(name[i]=='.')return false;
        idx += name[i];
        i++;
      }
    }
  }
  stringstream geek(idx);
  int x = 0;
  geek >> x;

  if(x<size && x>=0)return true;
  else return false;
}
void yyerror(char *s)
{
	//write your code
  error_count++;
  fprintf(error,"Line# %d: '%s'\n",line_count,s);
}

#line 224 "y.tab.c"

# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

/* Use api.header.include to #include this header
   instead of duplicating it here.  */
#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    IF = 258,                      /* IF  */
    ELSE = 259,                    /* ELSE  */
    FOR = 260,                     /* FOR  */
    WHILE = 261,                   /* WHILE  */
    DO = 262,                      /* DO  */
    BREAK = 263,                   /* BREAK  */
    INT = 264,                     /* INT  */
    CHAR = 265,                    /* CHAR  */
    FLOAT = 266,                   /* FLOAT  */
    DOUBLE = 267,                  /* DOUBLE  */
    VOID = 268,                    /* VOID  */
    RETURN = 269,                  /* RETURN  */
    SWITCH = 270,                  /* SWITCH  */
    CASE = 271,                    /* CASE  */
    DEFAULT = 272,                 /* DEFAULT  */
    CONTINUE = 273,                /* CONTINUE  */
    ASSIGNOP = 274,                /* ASSIGNOP  */
    INCOP = 275,                   /* INCOP  */
    DECOP = 276,                   /* DECOP  */
    NOT = 277,                     /* NOT  */
    LPAREN = 278,                  /* LPAREN  */
    RPAREN = 279,                  /* RPAREN  */
    LCURL = 280,                   /* LCURL  */
    RCURL = 281,                   /* RCURL  */
    LSQUARE = 282,                 /* LSQUARE  */
    RSQUARE = 283,                 /* RSQUARE  */
    COMMA = 284,                   /* COMMA  */
    SEMICOLON = 285,               /* SEMICOLON  */
    PRINTLN = 286,                 /* PRINTLN  */
    BITOP = 287,                   /* BITOP  */
    CONST_INT = 288,               /* CONST_INT  */
    CONST_FLOAT = 289,             /* CONST_FLOAT  */
    CONST_CHAR = 290,              /* CONST_CHAR  */
    ID = 291,                      /* ID  */
    ADDOP = 292,                   /* ADDOP  */
    MULOP = 293,                   /* MULOP  */
    RELOP = 294,                   /* RELOP  */
    LOGICOP = 295,                 /* LOGICOP  */
    LOWER_THAN_ELSE = 296          /* LOWER_THAN_ELSE  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif
/* Token kinds.  */
#define YYEMPTY -2
#define YYEOF 0
#define YYerror 256
#define YYUNDEF 257
#define IF 258
#define ELSE 259
#define FOR 260
#define WHILE 261
#define DO 262
#define BREAK 263
#define INT 264
#define CHAR 265
#define FLOAT 266
#define DOUBLE 267
#define VOID 268
#define RETURN 269
#define SWITCH 270
#define CASE 271
#define DEFAULT 272
#define CONTINUE 273
#define ASSIGNOP 274
#define INCOP 275
#define DECOP 276
#define NOT 277
#define LPAREN 278
#define RPAREN 279
#define LCURL 280
#define RCURL 281
#define LSQUARE 282
#define RSQUARE 283
#define COMMA 284
#define SEMICOLON 285
#define PRINTLN 286
#define BITOP 287
#define CONST_INT 288
#define CONST_FLOAT 289
#define CONST_CHAR 290
#define ID 291
#define ADDOP 292
#define MULOP 293
#define RELOP 294
#define LOGICOP 295
#define LOWER_THAN_ELSE 296

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 154 "1905058.y"

    SymbolInfo *symbol;

#line 363 "y.tab.c"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
/* Symbol kind.  */
enum yysymbol_kind_t
{
  YYSYMBOL_YYEMPTY = -2,
  YYSYMBOL_YYEOF = 0,                      /* "end of file"  */
  YYSYMBOL_YYerror = 1,                    /* error  */
  YYSYMBOL_YYUNDEF = 2,                    /* "invalid token"  */
  YYSYMBOL_IF = 3,                         /* IF  */
  YYSYMBOL_ELSE = 4,                       /* ELSE  */
  YYSYMBOL_FOR = 5,                        /* FOR  */
  YYSYMBOL_WHILE = 6,                      /* WHILE  */
  YYSYMBOL_DO = 7,                         /* DO  */
  YYSYMBOL_BREAK = 8,                      /* BREAK  */
  YYSYMBOL_INT = 9,                        /* INT  */
  YYSYMBOL_CHAR = 10,                      /* CHAR  */
  YYSYMBOL_FLOAT = 11,                     /* FLOAT  */
  YYSYMBOL_DOUBLE = 12,                    /* DOUBLE  */
  YYSYMBOL_VOID = 13,                      /* VOID  */
  YYSYMBOL_RETURN = 14,                    /* RETURN  */
  YYSYMBOL_SWITCH = 15,                    /* SWITCH  */
  YYSYMBOL_CASE = 16,                      /* CASE  */
  YYSYMBOL_DEFAULT = 17,                   /* DEFAULT  */
  YYSYMBOL_CONTINUE = 18,                  /* CONTINUE  */
  YYSYMBOL_ASSIGNOP = 19,                  /* ASSIGNOP  */
  YYSYMBOL_INCOP = 20,                     /* INCOP  */
  YYSYMBOL_DECOP = 21,                     /* DECOP  */
  YYSYMBOL_NOT = 22,                       /* NOT  */
  YYSYMBOL_LPAREN = 23,                    /* LPAREN  */
  YYSYMBOL_RPAREN = 24,                    /* RPAREN  */
  YYSYMBOL_LCURL = 25,                     /* LCURL  */
  YYSYMBOL_RCURL = 26,                     /* RCURL  */
  YYSYMBOL_LSQUARE = 27,                   /* LSQUARE  */
  YYSYMBOL_RSQUARE = 28,                   /* RSQUARE  */
  YYSYMBOL_COMMA = 29,                     /* COMMA  */
  YYSYMBOL_SEMICOLON = 30,                 /* SEMICOLON  */
  YYSYMBOL_PRINTLN = 31,                   /* PRINTLN  */
  YYSYMBOL_BITOP = 32,                     /* BITOP  */
  YYSYMBOL_CONST_INT = 33,                 /* CONST_INT  */
  YYSYMBOL_CONST_FLOAT = 34,               /* CONST_FLOAT  */
  YYSYMBOL_CONST_CHAR = 35,                /* CONST_CHAR  */
  YYSYMBOL_ID = 36,                        /* ID  */
  YYSYMBOL_ADDOP = 37,                     /* ADDOP  */
  YYSYMBOL_MULOP = 38,                     /* MULOP  */
  YYSYMBOL_RELOP = 39,                     /* RELOP  */
  YYSYMBOL_LOGICOP = 40,                   /* LOGICOP  */
  YYSYMBOL_LOWER_THAN_ELSE = 41,           /* LOWER_THAN_ELSE  */
  YYSYMBOL_YYACCEPT = 42,                  /* $accept  */
  YYSYMBOL_start = 43,                     /* start  */
  YYSYMBOL_program = 44,                   /* program  */
  YYSYMBOL_unit = 45,                      /* unit  */
  YYSYMBOL_func_declaration = 46,          /* func_declaration  */
  YYSYMBOL_func_definition = 47,           /* func_definition  */
  YYSYMBOL_48_1 = 48,                      /* $@1  */
  YYSYMBOL_49_2 = 49,                      /* $@2  */
  YYSYMBOL_50_3 = 50,                      /* $@3  */
  YYSYMBOL_51_4 = 51,                      /* $@4  */
  YYSYMBOL_parameter_list = 52,            /* parameter_list  */
  YYSYMBOL_compound_statement = 53,        /* compound_statement  */
  YYSYMBOL_var_declaration = 54,           /* var_declaration  */
  YYSYMBOL_type_specifier = 55,            /* type_specifier  */
  YYSYMBOL_declaration_list = 56,          /* declaration_list  */
  YYSYMBOL_statements = 57,                /* statements  */
  YYSYMBOL_statement = 58,                 /* statement  */
  YYSYMBOL_expression_statement = 59,      /* expression_statement  */
  YYSYMBOL_variable = 60,                  /* variable  */
  YYSYMBOL_expression = 61,                /* expression  */
  YYSYMBOL_logic_expression = 62,          /* logic_expression  */
  YYSYMBOL_rel_expression = 63,            /* rel_expression  */
  YYSYMBOL_simple_expression = 64,         /* simple_expression  */
  YYSYMBOL_term = 65,                      /* term  */
  YYSYMBOL_unary_expression = 66,          /* unary_expression  */
  YYSYMBOL_factor = 67,                    /* factor  */
  YYSYMBOL_argument_list = 68,             /* argument_list  */
  YYSYMBOL_arguments = 69                  /* arguments  */
};
typedef enum yysymbol_kind_t yysymbol_kind_t;




#ifdef short
# undef short
#endif

/* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
   <limits.h> and (if available) <stdint.h> are included
   so that the code can choose integer types of a good width.  */

#ifndef __PTRDIFF_MAX__
# include <limits.h> /* INFRINGES ON USER NAME SPACE */
# if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
#  define YY_STDINT_H
# endif
#endif

/* Narrow types that promote to a signed type and that can represent a
   signed or unsigned integer of at least N bits.  In tables they can
   save space and decrease cache pressure.  Promoting to a signed type
   helps avoid bugs in integer arithmetic.  */

#ifdef __INT_LEAST8_MAX__
typedef __INT_LEAST8_TYPE__ yytype_int8;
#elif defined YY_STDINT_H
typedef int_least8_t yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef __INT_LEAST16_MAX__
typedef __INT_LEAST16_TYPE__ yytype_int16;
#elif defined YY_STDINT_H
typedef int_least16_t yytype_int16;
#else
typedef short yytype_int16;
#endif

/* Work around bug in HP-UX 11.23, which defines these macros
   incorrectly for preprocessor constants.  This workaround can likely
   be removed in 2023, as HPE has promised support for HP-UX 11.23
   (aka HP-UX 11i v2) only through the end of 2022; see Table 2 of
   <https://h20195.www2.hpe.com/V2/getpdf.aspx/4AA4-7673ENW.pdf>.  */
#ifdef __hpux
# undef UINT_LEAST8_MAX
# undef UINT_LEAST16_MAX
# define UINT_LEAST8_MAX 255
# define UINT_LEAST16_MAX 65535
#endif

#if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
typedef __UINT_LEAST8_TYPE__ yytype_uint8;
#elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST8_MAX <= INT_MAX)
typedef uint_least8_t yytype_uint8;
#elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
typedef unsigned char yytype_uint8;
#else
typedef short yytype_uint8;
#endif

#if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
typedef __UINT_LEAST16_TYPE__ yytype_uint16;
#elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST16_MAX <= INT_MAX)
typedef uint_least16_t yytype_uint16;
#elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
typedef unsigned short yytype_uint16;
#else
typedef int yytype_uint16;
#endif

#ifndef YYPTRDIFF_T
# if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
#  define YYPTRDIFF_T __PTRDIFF_TYPE__
#  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
# elif defined PTRDIFF_MAX
#  ifndef ptrdiff_t
#   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  endif
#  define YYPTRDIFF_T ptrdiff_t
#  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
# else
#  define YYPTRDIFF_T long
#  define YYPTRDIFF_MAXIMUM LONG_MAX
# endif
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM                                  \
  YY_CAST (YYPTRDIFF_T,                                 \
           (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
            ? YYPTRDIFF_MAXIMUM                         \
            : YY_CAST (YYSIZE_T, -1)))

#define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))


/* Stored state numbers (used for stacks). */
typedef yytype_int8 yy_state_t;

/* State numbers in computations.  */
typedef int yy_state_fast_t;

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif


#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YY_USE(E) ((void) (E))
#else
# define YY_USE(E) /* empty */
#endif

/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
#if defined __GNUC__ && ! defined __ICC && 406 <= __GNUC__ * 100 + __GNUC_MINOR__
# if __GNUC__ * 100 + __GNUC_MINOR__ < 407
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")
# else
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# endif
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if !defined yyoverflow

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* !defined yyoverflow */

#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yy_state_t yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYPTRDIFF_T yynewbytes;                                         \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYPTRDIFF_T yyi;                      \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  13
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   189

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  42
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  28
/* YYNRULES -- Number of rules.  */
#define YYNRULES  72
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  127

/* YYMAXUTOK -- Last valid token kind.  */
#define YYMAXUTOK   296


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK                     \
   ? YY_CAST (yysymbol_kind_t, yytranslate[YYX])        \
   : YYSYMBOL_YYUNDEF)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_int8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41
};

#if YYDEBUG
/* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int16 yyrline[] =
{
       0,   177,   177,   184,   189,   195,   200,   205,   211,   233,
     255,   324,   254,   332,   351,   331,   357,   370,   378,   391,
     399,   405,   411,   418,   461,   467,   476,   485,   495,   510,
     529,   541,   558,   564,   570,   577,   583,   589,   594,   600,
     608,   616,   623,   639,   647,   652,   659,   664,   682,   692,
     697,   789,   794,   811,   817,   833,   839,   851,   856,   892,
     911,   922,   929,   969,  1028,  1036,  1044,  1051,  1068,  1085,
    1091,  1095,  1116
};
#endif

/** Accessing symbol of state STATE.  */
#define YY_ACCESSING_SYMBOL(State) YY_CAST (yysymbol_kind_t, yystos[State])

#if YYDEBUG || 0
/* The user-facing name of the symbol whose (internal) number is
   YYSYMBOL.  No bounds checking.  */
static const char *yysymbol_name (yysymbol_kind_t yysymbol) YY_ATTRIBUTE_UNUSED;

/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "\"end of file\"", "error", "\"invalid token\"", "IF", "ELSE", "FOR",
  "WHILE", "DO", "BREAK", "INT", "CHAR", "FLOAT", "DOUBLE", "VOID",
  "RETURN", "SWITCH", "CASE", "DEFAULT", "CONTINUE", "ASSIGNOP", "INCOP",
  "DECOP", "NOT", "LPAREN", "RPAREN", "LCURL", "RCURL", "LSQUARE",
  "RSQUARE", "COMMA", "SEMICOLON", "PRINTLN", "BITOP", "CONST_INT",
  "CONST_FLOAT", "CONST_CHAR", "ID", "ADDOP", "MULOP", "RELOP", "LOGICOP",
  "LOWER_THAN_ELSE", "$accept", "start", "program", "unit",
  "func_declaration", "func_definition", "$@1", "$@2", "$@3", "$@4",
  "parameter_list", "compound_statement", "var_declaration",
  "type_specifier", "declaration_list", "statements", "statement",
  "expression_statement", "variable", "expression", "logic_expression",
  "rel_expression", "simple_expression", "term", "unary_expression",
  "factor", "argument_list", "arguments", YY_NULLPTR
};

static const char *
yysymbol_name (yysymbol_kind_t yysymbol)
{
  return yytname[yysymbol];
}
#endif

#define YYPACT_NINF (-74)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-20)

#define yytable_value_is_error(Yyn) \
  0

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
static const yytype_int16 yypact[] =
{
     116,   -16,   -74,   -74,   -74,    24,    80,   -74,   -74,   -74,
     -74,    -9,   -74,   -74,   -74,    27,     4,     8,     3,   -74,
      15,   -74,    40,    -1,     1,    29,    56,   -74,    60,    58,
      52,   -74,   -74,   -74,    57,    73,   -74,   -74,    60,    61,
      64,    71,    82,    85,   152,   152,   152,   -74,   -74,    89,
     -74,   -74,    41,   152,   -74,   -74,    78,   110,   -74,   -74,
      81,    10,   -74,    86,    38,    84,   -74,   -74,   -74,   -74,
     -74,   -74,   152,    22,   152,    88,    46,   -74,    96,    92,
     152,   152,   -74,   103,   -74,   -74,   152,   -74,   -74,   -74,
     -74,   152,   152,   152,   152,   -74,   107,    22,   113,   -74,
     -74,   114,   -74,   115,   105,   117,   -74,   -74,    84,   112,
     -74,   147,   152,   147,   121,   -74,   152,   -74,   138,   130,
     -74,   -74,   -74,   147,   147,   -74,   -74
};

/* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE does not specify something else to do.  Zero
   means the default is an error.  */
static const yytype_int8 yydefact[] =
{
       0,     0,    25,    26,    27,     0,     0,     4,     6,     7,
       5,     0,    24,     1,     3,    30,     0,     0,     0,    32,
       0,    23,    13,     0,     0,     0,    28,     9,     0,    10,
       0,    20,    18,    31,     0,     0,    14,     8,     0,    17,
       0,     0,     0,     0,     0,     0,     0,    22,    44,     0,
      65,    66,    47,     0,    37,    35,     0,     0,    33,    36,
      62,     0,    49,    51,    53,    55,    57,    61,    15,    11,
      16,    29,     0,     0,     0,     0,    62,    60,     0,     0,
      70,     0,    59,    30,    21,    34,     0,    67,    68,    46,
      45,     0,     0,     0,     0,    12,     0,     0,     0,    43,
      64,     0,    72,     0,    69,     0,    50,    52,    56,    54,
      58,     0,     0,     0,     0,    63,     0,    48,    39,     0,
      41,    42,    71,     0,     0,    40,    38
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
     -74,   -74,   -74,   149,   -74,   -74,   -74,   -74,   -74,   -74,
     -74,   -18,    16,     9,   -74,   -74,   -51,   -55,   -45,   -43,
     -73,    66,    69,    67,   -41,   -74,   -74,   -74
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int8 yydefgoto[] =
{
       0,     5,     6,     7,     8,     9,    38,    95,    28,    68,
      23,    54,    55,    56,    16,    57,    58,    59,    60,    61,
      62,    63,    64,    65,    66,    67,   103,   104
};

/* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule whose
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int8 yytable[] =
{
      76,    75,    31,    78,    77,    19,    85,   102,    76,    11,
      36,    89,    82,   106,    12,    11,    10,     2,    97,     3,
      69,     4,    10,    29,    13,   -19,    24,    15,    30,    96,
     -19,    98,    22,    20,    21,    76,    25,    32,   105,    39,
      90,    76,   112,   122,    45,    46,    76,    76,    76,    76,
      17,    26,    48,   110,    18,    50,    51,    33,    52,    53,
     118,     2,   120,     3,    80,     4,    87,    88,    81,   119,
      27,    76,   125,   126,     1,    92,    41,    93,    42,    43,
      -2,     1,     2,    34,     3,    35,     4,    44,    37,     2,
      40,     3,    71,     4,    72,    45,    46,    70,    35,    47,
      86,    87,    88,    48,    49,    73,    50,    51,    74,    52,
      53,     1,    79,    41,    83,    42,    43,     1,    99,     2,
     100,     3,    94,     4,    44,     2,    91,     3,   101,     4,
      18,   111,    45,    46,   116,    35,    84,   113,   114,   115,
      48,    49,   123,    50,    51,   117,    52,    53,     1,    92,
      41,   121,    42,    43,   124,    14,     2,   107,     3,   108,
       4,    44,   109,     0,     0,     0,     0,     0,     0,    45,
      46,     0,    35,     0,    45,    46,     0,    48,    49,     0,
      50,    51,     0,    52,    53,    50,    51,     0,    52,    53
};

static const yytype_int8 yycheck[] =
{
      45,    44,     1,    46,    45,     1,    57,    80,    53,     0,
      28,     1,    53,    86,    30,     6,     0,     9,    73,    11,
      38,    13,     6,    24,     0,    24,    17,    36,    29,    72,
      29,    74,    24,    29,    30,    80,    33,    36,    81,    30,
      30,    86,    97,   116,    22,    23,    91,    92,    93,    94,
      23,    36,    30,    94,    27,    33,    34,    28,    36,    37,
     111,     9,   113,    11,    23,    13,    20,    21,    27,   112,
      30,   116,   123,   124,     1,    37,     3,    39,     5,     6,
       0,     1,     9,    27,    11,    25,    13,    14,    30,     9,
      33,    11,    28,    13,    23,    22,    23,    36,    25,    26,
      19,    20,    21,    30,    31,    23,    33,    34,    23,    36,
      37,     1,    23,     3,    36,     5,     6,     1,    30,     9,
      24,    11,    38,    13,    14,     9,    40,    11,    36,    13,
      27,    24,    22,    23,    29,    25,    26,    24,    24,    24,
      30,    31,     4,    33,    34,    28,    36,    37,     1,    37,
       3,    30,     5,     6,    24,     6,     9,    91,    11,    92,
      13,    14,    93,    -1,    -1,    -1,    -1,    -1,    -1,    22,
      23,    -1,    25,    -1,    22,    23,    -1,    30,    31,    -1,
      33,    34,    -1,    36,    37,    33,    34,    -1,    36,    37
};

/* YYSTOS[STATE-NUM] -- The symbol kind of the accessing symbol of
   state STATE-NUM.  */
static const yytype_int8 yystos[] =
{
       0,     1,     9,    11,    13,    43,    44,    45,    46,    47,
      54,    55,    30,     0,    45,    36,    56,    23,    27,     1,
      29,    30,    24,    52,    55,    33,    36,    30,    50,    24,
      29,     1,    36,    28,    27,    25,    53,    30,    48,    55,
      33,     3,     5,     6,    14,    22,    23,    26,    30,    31,
      33,    34,    36,    37,    53,    54,    55,    57,    58,    59,
      60,    61,    62,    63,    64,    65,    66,    67,    51,    53,
      36,    28,    23,    23,    23,    61,    60,    66,    61,    23,
      23,    27,    66,    36,    26,    58,    19,    20,    21,     1,
      30,    40,    37,    39,    38,    49,    61,    59,    61,    30,
      24,    36,    62,    68,    69,    61,    62,    63,    65,    64,
      66,    24,    59,    24,    24,    24,    29,    28,    58,    61,
      58,    30,    62,     4,    24,    58,    58
};

/* YYR1[RULE-NUM] -- Symbol kind of the left-hand side of rule RULE-NUM.  */
static const yytype_int8 yyr1[] =
{
       0,    42,    43,    44,    44,    45,    45,    45,    46,    46,
      48,    49,    47,    50,    51,    47,    52,    52,    52,    52,
      52,    53,    53,    54,    54,    55,    55,    55,    56,    56,
      56,    56,    56,    57,    57,    58,    58,    58,    58,    58,
      58,    58,    58,    58,    59,    59,    59,    60,    60,    61,
      61,    62,    62,    63,    63,    64,    64,    65,    65,    66,
      66,    66,    67,    67,    67,    67,    67,    67,    67,    68,
      68,    69,    69
};

/* YYR2[RULE-NUM] -- Number of symbols on the right-hand side of rule RULE-NUM.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     1,     2,     1,     1,     1,     1,     6,     5,
       0,     0,     8,     0,     0,     7,     4,     3,     2,     1,
       2,     3,     2,     3,     2,     1,     1,     1,     3,     6,
       1,     4,     2,     1,     2,     1,     1,     1,     7,     5,
       7,     5,     5,     3,     1,     2,     2,     1,     4,     1,
       3,     1,     3,     1,     3,     1,     3,     1,     3,     2,
       2,     1,     1,     4,     3,     1,     1,     2,     2,     1,
       0,     3,     1
};


enum { YYENOMEM = -2 };

#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab
#define YYNOMEM         goto yyexhaustedlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Backward compatibility with an undocumented macro.
   Use YYerror or YYUNDEF. */
#define YYERRCODE YYUNDEF


/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)




# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Kind, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo,
                       yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  FILE *yyoutput = yyo;
  YY_USE (yyoutput);
  if (!yyvaluep)
    return;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo,
                 yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyo, "%s %s (",
             yykind < YYNTOKENS ? "token" : "nterm", yysymbol_name (yykind));

  yy_symbol_value_print (yyo, yykind, yyvaluep);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp,
                 int yyrule)
{
  int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       YY_ACCESSING_SYMBOL (+yyssp[yyi + 1 - yynrhs]),
                       &yyvsp[(yyi + 1) - (yynrhs)]);
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args) ((void) 0)
# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif






/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg,
            yysymbol_kind_t yykind, YYSTYPE *yyvaluep)
{
  YY_USE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yykind, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/* Lookahead token kind.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;




/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    yy_state_fast_t yystate = 0;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus = 0;

    /* Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* Their size.  */
    YYPTRDIFF_T yystacksize = YYINITDEPTH;

    /* The state stack: array, bottom, top.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss = yyssa;
    yy_state_t *yyssp = yyss;

    /* The semantic value stack: array, bottom, top.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs = yyvsa;
    YYSTYPE *yyvsp = yyvs;

  int yyn;
  /* The return value of yyparse.  */
  int yyresult;
  /* Lookahead symbol kind.  */
  yysymbol_kind_t yytoken = YYSYMBOL_YYEMPTY;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;



#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yychar = YYEMPTY; /* Cause a token to be read.  */

  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yysetstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  YY_IGNORE_USELESS_CAST_BEGIN
  *yyssp = YY_CAST (yy_state_t, yystate);
  YY_IGNORE_USELESS_CAST_END
  YY_STACK_PRINT (yyss, yyssp);

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    YYNOMEM;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYPTRDIFF_T yysize = yyssp - yyss + 1;

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        yy_state_t *yyss1 = yyss;
        YYSTYPE *yyvs1 = yyvs;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        YYNOMEM;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          YYNOMEM;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "Stack size increased to %ld\n",
                  YY_CAST (long, yystacksize)));
      YY_IGNORE_USELESS_CAST_END

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */


  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either empty, or end-of-input, or a valid lookahead.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token\n"));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = YYEOF;
      yytoken = YYSYMBOL_YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else if (yychar == YYerror)
    {
      /* The scanner already issued an error message, process directly
         to error recovery.  But do not keep the error token as
         lookahead, it is too special and may lead us to an endless
         loop in error recovery. */
      yychar = YYUNDEF;
      yytoken = YYSYMBOL_YYerror;
      goto yyerrlab1;
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  /* Discard the shifted token.  */
  yychar = YYEMPTY;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
  case 2: /* start: program  */
#line 178 "1905058.y"
        {
		//write your code in this block in all the similar blocks below
        fprintf(log_,"start : program\n");
	}
#line 1512 "y.tab.c"
    break;

  case 3: /* program: program unit  */
#line 185 "1905058.y"
        {
		fprintf(log_,"program : program unit\n");
		(yyval.symbol) = new SymbolInfo((string)(yyvsp[-1].symbol)->get_name()+(string)(yyvsp[0].symbol)->get_name(), "NON_TERMINAL");
	}
#line 1521 "y.tab.c"
    break;

  case 4: /* program: unit  */
#line 190 "1905058.y"
        {
		fprintf(log_,"program : unit\n");
		(yyval.symbol) = new SymbolInfo((yyvsp[0].symbol)->get_name()+"\n", "NON_TERMINAL");
	}
#line 1530 "y.tab.c"
    break;

  case 5: /* unit: var_declaration  */
#line 196 "1905058.y"
        {
		fprintf(log_,"unit : var_declaration\n");
		(yyval.symbol) = new SymbolInfo((yyvsp[0].symbol)->get_name(), "NON_TERMINAL");
	}
#line 1539 "y.tab.c"
    break;

  case 6: /* unit: func_declaration  */
#line 201 "1905058.y"
        {
		fprintf(log_,"unit : func_declaration\n");
		(yyval.symbol) = new SymbolInfo((yyvsp[0].symbol)->get_name(), "NON_TERMINAL");
	}
#line 1548 "y.tab.c"
    break;

  case 7: /* unit: func_definition  */
#line 206 "1905058.y"
        {
        fprintf(log_,"unit : func_definition\n");
		(yyval.symbol) = new SymbolInfo((yyvsp[0].symbol)->get_name(), "NON_TERMINAL");
	}
#line 1557 "y.tab.c"
    break;

  case 8: /* func_declaration: type_specifier ID LPAREN parameter_list RPAREN SEMICOLON  */
#line 212 "1905058.y"
        {
    (yyval.symbol) = new SymbolInfo((yyvsp[-5].symbol)->get_name()+" "+(yyvsp[-4].symbol)->get_name()+"("+(yyvsp[-2].symbol)->get_name()+");", "NON_TERMINAL");
    fprintf(log_ , "func_declaration: type_specifier ID LPAREN parameter_list RPAREN SEMICOLON\n");

    /* checking whether already declared or not */
    SymbolInfo* temp = table.Lookup_current_scope((yyvsp[-4].symbol)->get_name());
    if(temp != NULL) {
			error_count++;
			fprintf(error , "Line# %d: Multiple declaration of '%s'\n" , line_count , (yyvsp[-4].symbol)->get_name().c_str());
		}
    else{
      table.Insert((yyvsp[-4].symbol)->get_name() , "ID" , log_);
      SymbolInfo *fd = table.Lookup_current_scope((yyvsp[-4].symbol)->get_name());
      fd->set_func_decl_state(true);
      fd->set_ret_type((yyvsp[-5].symbol)->get_name());

      //insert in func_list
      func_insert((yyvsp[-4].symbol)->get_name() , (yyvsp[-2].symbol)->param_list , (yyvsp[-5].symbol)->get_name());
    }

	}
#line 1583 "y.tab.c"
    break;

  case 9: /* func_declaration: type_specifier ID LPAREN RPAREN SEMICOLON  */
#line 234 "1905058.y"
        {
		(yyval.symbol) = new SymbolInfo((yyvsp[-4].symbol)->get_name()+" "+(yyvsp[-3].symbol)->get_name()+"();", "NON_TERMINAL");
		fprintf(log_ , "func_declaration: type_specifier ID LPAREN RPAREN SEMICOLON\n");
		
        /* checking whether already declared or not */
		SymbolInfo* temp = table.Lookup_current_scope((yyvsp[-3].symbol)->get_name());
		if(temp != NULL) {
			error_count++;
			fprintf(error , "Line# %d: Multiple declaration of '%s'\n" , line_count , (yyvsp[-3].symbol)->get_name().c_str());
		}
    else{
      table.Insert((yyvsp[-3].symbol)->get_name() , "ID" , log_);
      SymbolInfo *fd = table.Lookup_current_scope((yyvsp[-3].symbol)->get_name());
      fd->set_func_decl_state(true);
      fd->set_ret_type((yyvsp[-4].symbol)->get_name());
      func_insert((yyvsp[-3].symbol)->get_name() , (yyvsp[-4].symbol)->get_name());
    }

	}
#line 1607 "y.tab.c"
    break;

  case 10: /* $@1: %empty  */
#line 255 "1905058.y"
  {
    //chking if invalid params given
    if((yyvsp[-1].symbol)->get_name()=="int" or (yyvsp[-1].symbol)->get_name()=="float"){
      error_count++;
      fprintf(error , "Line# %d: 1st parameter's name not given in function definition of '%s'\n" , line_count, (yyvsp[-3].symbol)->get_name().c_str());
    }
    //chking if declared previously and now being defined
    //param types,return type must be matched
    //assuming we don't need to handle function overloading
    if(check_func((yyvsp[-3].symbol)->get_name())){
      func_ f = get_func((yyvsp[-3].symbol)->get_name());
      if(f.ret_type != (yyvsp[-4].symbol)->get_name()){
        error_count++;
        fprintf(error , "Line# %d: Conflicting types for '%s'\n",line_count,(yyvsp[-3].symbol)->get_name().c_str());
      }
      else {
        bool matched = true;
        int n = (yyvsp[-1].symbol)->param_list.size();
        if(n == f.parametres.size()){
          for(int i=0;i<f.parametres.size();i++){
            if(f.parametres[i].first != (yyvsp[-1].symbol)->param_list[i].type){
          error_count++;
          fprintf(error , "Line# %d: Type mismatch for argument %d of '%s'\n",line_count ,i+1,(yyvsp[-3].symbol)->get_name().c_str());
            }
          }
        }
        else
        {
          error_count++;
          fprintf(error , "Line# %d: Conflicting types for '%s'\n",line_count , (yyvsp[-3].symbol)->get_name().c_str());
          
        }
        
      }
    }


    /* checking whether already defined or not */
		SymbolInfo* temp = table.Lookup_current_scope((yyvsp[-3].symbol)->get_name());
		if(temp != NULL and (!temp->get_func_decl_state())) {
			error_count++;
			fprintf(error , "Line# %d: '%s' redeclared as different kind of symbol\n" , line_count , (yyvsp[-3].symbol)->get_name().c_str());
      	}
		else if(temp == NULL){
			table.Insert((yyvsp[-3].symbol)->get_name() , "ID" , log_);
      SymbolInfo *fd = table.Lookup_current_scope((yyvsp[-3].symbol)->get_name());
      fd->set_func_decl_state(true);
      fd->set_ret_type((yyvsp[-4].symbol)->get_name());
      //insert in func_list
      func_insert((yyvsp[-3].symbol)->get_name() , (yyvsp[-1].symbol)->param_list , (yyvsp[-4].symbol)->get_name());
		}


    table.Enter_Scope();
    for(int i=0;i<(yyvsp[-1].symbol)->param_list.size();i++){
        string name = (yyvsp[-1].symbol)->param_list[i].name;
        string type = "ID";
        SymbolInfo *tmp = table.Lookup_current_scope(name);
        if(tmp){
          fprintf(error,"Line# %d: Redefinition of parameter '%s'\n",line_count,name.c_str());
          error_count++;
        }
        else{
          table.Insert(name , type , log_);
          SymbolInfo *par =  table.Lookup_current_scope(name);
          par->set_var_type((yyvsp[-1].symbol)->param_list[i].type);
        }
    }

  }
#line 1682 "y.tab.c"
    break;

  case 11: /* $@2: %empty  */
#line 324 "1905058.y"
                       { table.Exit_Scope();var_list.clear();}
#line 1688 "y.tab.c"
    break;

  case 12: /* func_definition: type_specifier ID LPAREN parameter_list RPAREN $@1 compound_statement $@2  */
#line 326 "1905058.y"
  {
      (yyval.symbol) = new SymbolInfo((yyvsp[-7].symbol)->get_name()+" "+(yyvsp[-6].symbol)->get_name()+"("+(yyvsp[-4].symbol)->get_name()+")"+(yyvsp[-1].symbol)->get_name()+"\n", "NON_TERMINAL");
      fprintf(log_ , "func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement\n");

  }
#line 1698 "y.tab.c"
    break;

  case 13: /* $@3: %empty  */
#line 332 "1905058.y"
    {
      curr_ret_type = (yyvsp[-3].symbol)->get_name();
      /* checking whether already declared or not */
  		SymbolInfo* temp = table.Lookup_current_scope((yyvsp[-2].symbol)->get_name());
      if(temp != NULL and (!temp->get_func_decl_state())) {
  			error_count++;
  			fprintf(error , "Line# %d: Multiple declaration of '%s'\n" , line_count , (yyvsp[-2].symbol)->get_name().c_str());
        }
  		else if(temp == NULL){
  			table.Insert((yyvsp[-2].symbol)->get_name() , "ID" , log_);
      SymbolInfo *fd = table.Lookup_current_scope((yyvsp[-2].symbol)->get_name());
      fd->set_func_decl_state(true);
      fd->set_ret_type((yyvsp[-3].symbol)->get_name());
        func_insert((yyvsp[-2].symbol)->get_name() , (yyvsp[-3].symbol)->get_name());
  		}

      table.Enter_Scope();

    }
#line 1722 "y.tab.c"
    break;

  case 14: /* $@4: %empty  */
#line 351 "1905058.y"
                       {table.Exit_Scope();var_list.clear();}
#line 1728 "y.tab.c"
    break;

  case 15: /* func_definition: type_specifier ID LPAREN RPAREN $@3 compound_statement $@4  */
#line 352 "1905058.y"
        {
      (yyval.symbol) = new SymbolInfo((yyvsp[-6].symbol)->get_name()+" "+(yyvsp[-5].symbol)->get_name()+"()"+(yyvsp[-1].symbol)->get_name()+"\n", "NON_TERMINAL");
      fprintf(log_ , "func_definition : type_specifier ID LPAREN RPAREN compound_statement\n");
	}
#line 1737 "y.tab.c"
    break;

  case 16: /* parameter_list: parameter_list COMMA type_specifier ID  */
#line 358 "1905058.y"
                {
			(yyval.symbol) = new SymbolInfo((yyvsp[-3].symbol)->get_name()+","+(yyvsp[-1].symbol)->get_name()+" "+(yyvsp[0].symbol)->get_name(), "NON_TERMINAL");
			fprintf(log_,"parameter_list : parameter_list COMMA type_specifier ID\n");
			/* adding parameter to parameter list */
      (yyval.symbol)->param_list = (yyvsp[-3].symbol)->param_list;
			(yyval.symbol)->push_param((yyvsp[0].symbol)->get_name() , (yyvsp[-1].symbol)->get_name());

      if((yyvsp[-1].symbol)->get_type()=="void"){
        error_count++;
        fprintf(error,"Line# %d: Variable or field '%s'  declared void\n",line_count,(yyvsp[-1].symbol)->get_name().c_str());
        }
		}
#line 1754 "y.tab.c"
    break;

  case 17: /* parameter_list: parameter_list COMMA type_specifier  */
#line 371 "1905058.y"
                {
			(yyval.symbol) = new SymbolInfo((yyvsp[-2].symbol)->get_name()+","+(yyvsp[0].symbol)->get_name(), "NON_TERMINAL");
			fprintf(log_,"parameter_list  : parameter_list COMMA type_specifier\n");
			/* adding parameter to parameter list */
      (yyval.symbol)->param_list = (yyvsp[-2].symbol)->param_list;
			(yyval.symbol)->push_param("", (yyvsp[0].symbol)->get_name());
		}
#line 1766 "y.tab.c"
    break;

  case 18: /* parameter_list: type_specifier ID  */
#line 379 "1905058.y"
                {
			(yyval.symbol) = new SymbolInfo((yyvsp[-1].symbol)->get_name()+" "+(yyvsp[0].symbol)->get_name(), "NON_TERMINAL");
			fprintf(log_,"parameter_list  : type_specifier ID\n");
			/* adding parameter to parameter list */
      if((yyvsp[-1].symbol)->get_name()=="void"){
        error_count++;
				fprintf(error,"Line# %d: Variable or field '%s' declared void\n",line_count,(yyvsp[0].symbol)->get_name().c_str());
      }
			(yyval.symbol)->push_param((yyvsp[0].symbol)->get_name() ,(yyvsp[-1].symbol)->get_name());

      
		}
#line 1783 "y.tab.c"
    break;

  case 19: /* parameter_list: type_specifier  */
#line 392 "1905058.y"
                {
			(yyval.symbol) = new SymbolInfo((yyvsp[0].symbol)->get_name(), "NON_TERMINAL");
			fprintf(log_,"parameter_list  : type_specifier\n");
			/* adding parameter to parameter list */

			(yyval.symbol)->push_param( "" , (yyvsp[0].symbol)->get_name());
		}
#line 1795 "y.tab.c"
    break;

  case 20: /* parameter_list: type_specifier error  */
#line 400 "1905058.y"
    {
      yyclearin;
      yyerrok;
    }
#line 1804 "y.tab.c"
    break;

  case 21: /* compound_statement: LCURL statements RCURL  */
#line 406 "1905058.y"
  {
      (yyval.symbol) = new SymbolInfo("{\n"+(yyvsp[-1].symbol)->get_name()+"\n}"+"\n", "NON_TERMINAL");
      fprintf(log_,"compound_statement : LCURL statements RCURL\n");
      table.printall(log_);
  }
#line 1814 "y.tab.c"
    break;

  case 22: /* compound_statement: LCURL RCURL  */
#line 412 "1905058.y"
  {
    (yyval.symbol) = new SymbolInfo("{\n}", "NON_TERMINAL");
    fprintf(log_,"compound_statement : LCURL RCURL\n");
    table.printall(log_);
  }
#line 1824 "y.tab.c"
    break;

  case 23: /* var_declaration: type_specifier declaration_list SEMICOLON  */
#line 419 "1905058.y"
                {
			fprintf(log_,"var_declaration : type_specifier declaration_list SEMICOLON\n");
			(yyval.symbol) = new SymbolInfo((yyvsp[-2].symbol)->get_name()+" "+(yyvsp[-1].symbol)->get_name()+";", "NON_TERMINAL");

      (yyval.symbol)->set_var_type((yyvsp[-2].symbol)->get_name());

      //setting type of all elements of var in declaration_list
      for(int i=0;i<(yyvsp[-1].symbol)->var_list.size();i++){
          (yyvsp[-1].symbol)->var_list[i].type = (yyvsp[-2].symbol)->get_name();
      }
			/* inserting in symboltable */
			if((yyvsp[-2].symbol)->get_name()=="void"){
				error_count++;
				fprintf(error,"Line# %d: Variable or field '%s' declared void\n",line_count,(yyvsp[-1].symbol)->get_name().c_str());

			}
			else{
				/* checking whether already declared or not */
				for(int i=0;i<(yyvsp[-1].symbol)->var_list.size();i++){
					SymbolInfo* temp = table.Lookup_current_scope((yyvsp[-1].symbol)->var_list[i].name);
					if(temp != NULL) {
						error_count++;
						fprintf(error , "Line# %d: Multiple declaration of '%s'\n" , line_count , (yyvsp[-1].symbol)->var_list[i].name.c_str());
					}
					else{
						table.Insert((yyvsp[-1].symbol)->var_list[i].name , "ID" , log_);
            SymbolInfo *tmp = table.Lookup_current_scope((yyvsp[-1].symbol)->var_list[i].name);
            tmp->set_var_type((yyvsp[-2].symbol)->get_name());
            if((yyvsp[-1].symbol)->var_list[i].size>0){
              tmp->set_id("array");
              tmp->set_arr_state(true);
            }else{
              tmp->set_id("var");
            }
					}
				}

			}

			//var_list.clear();
		}
#line 1870 "y.tab.c"
    break;

  case 24: /* var_declaration: error SEMICOLON  */
#line 462 "1905058.y"
    {
      yyclearin;
      yyerrok;
    }
#line 1879 "y.tab.c"
    break;

  case 25: /* type_specifier: INT  */
#line 468 "1905058.y"
                {
			fprintf(log_,"type_specifier : INT \n");
			var_type = "int";

			SymbolInfo *x = new SymbolInfo("int" , "int");
			(yyval.symbol) = x;
			
		}
#line 1892 "y.tab.c"
    break;

  case 26: /* type_specifier: FLOAT  */
#line 477 "1905058.y"
                {
			fprintf(log_,"type_specifier : FLOAT \n");
			var_type = "float";

			SymbolInfo *x = new SymbolInfo("float" , "float");
			(yyval.symbol) = x;
			
		}
#line 1905 "y.tab.c"
    break;

  case 27: /* type_specifier: VOID  */
#line 486 "1905058.y"
                {
			fprintf(log_,"type_specifier : VOID \n");
			var_type = "void";

			SymbolInfo *x = new SymbolInfo("void" , "void");
			(yyval.symbol) = x;
			
		}
#line 1918 "y.tab.c"
    break;

  case 28: /* declaration_list: declaration_list COMMA ID  */
#line 496 "1905058.y"
                {
			fprintf(log_,"declaration_list : declaration_list COMMA ID\n");
			(yyval.symbol) = new SymbolInfo((string)(yyvsp[-2].symbol)->get_name()+(string)","+(string)(yyvsp[0].symbol)->get_name(), "NON_TERMINAL");
			
			/* keeping track of identifier(variable) */
      temp_var.name = (yyvsp[0].symbol)->get_name();
      temp_var.size = -1;
      var_list.push_back(temp_var);

      /* 3 args are name , type, size of variable */
      (yyval.symbol)->var_list = (yyvsp[-2].symbol)->var_list;
      (yyval.symbol)->push_var((yyvsp[0].symbol)->get_name() , "" , 0);

		}
#line 1937 "y.tab.c"
    break;

  case 29: /* declaration_list: declaration_list COMMA ID LSQUARE CONST_INT RSQUARE  */
#line 511 "1905058.y"
                {
			fprintf(log_,"declaration_list : declaration_list COMMA ID LSQUARE CONST_INT RSQUARE\n");
			(yyval.symbol) = new SymbolInfo((string)(yyvsp[-5].symbol)->get_name()+(string)","+(string)(yyvsp[-3].symbol)->get_name()+(string)"["+(string)(yyvsp[-1].symbol)->get_name()+(string)"]", "NON_TERMINAL");
			
			/* keeping track of identifier(array) */
      temp_var.name = (string)(yyvsp[-3].symbol)->get_name();
      stringstream temp_str((string) (yyvsp[-1].symbol)->get_name());
      temp_str >> temp_var.size;
      var_list.push_back(temp_var);

      stringstream geek((yyvsp[-1].symbol)->get_name());
      int size = 0;
      geek >> size;

      (yyval.symbol)->var_list = (yyvsp[-5].symbol)->var_list;
      (yyval.symbol)->push_var((yyvsp[-3].symbol)->get_name() , "" , size);
		}
#line 1959 "y.tab.c"
    break;

  case 30: /* declaration_list: ID  */
#line 530 "1905058.y"
                {
			fprintf(log_,"declaration_list : ID\n");
 			(yyval.symbol) = new SymbolInfo((yyvsp[0].symbol)->get_name() ,  "ID");
			 /* keeping track of identifier(variable) */
      temp_var.name = (string)(yyvsp[0].symbol)->get_name();
      temp_var.size = -1;
      var_list.push_back(temp_var);

      (yyval.symbol)->push_var((yyvsp[0].symbol)->get_name() , "" , 0);

		}
#line 1975 "y.tab.c"
    break;

  case 31: /* declaration_list: ID LSQUARE CONST_INT RSQUARE  */
#line 542 "1905058.y"
                {
			fprintf(log_ , "declaration_list: ID LSQUARE CONST_INT RSQUARE\n");
			(yyval.symbol) = new SymbolInfo((yyvsp[-3].symbol)->get_name()+"["+(yyvsp[-1].symbol)->get_name()+"]", "NON_TERMINAL");
			temp_var.name = (yyvsp[-3].symbol)->get_name();
      stringstream temp_str((yyvsp[-1].symbol)->get_name());
      temp_str >> temp_var.size;
      var_list.push_back(temp_var);

      stringstream geek((yyvsp[-1].symbol)->get_name());
      int size = 0;
      geek >> size;

      (yyval.symbol)->push_var((yyvsp[-3].symbol)->get_name() , "" , size);
    

		}
#line 1996 "y.tab.c"
    break;

  case 32: /* declaration_list: declaration_list error  */
#line 559 "1905058.y"
    {
      yyclearin;
    }
#line 2004 "y.tab.c"
    break;

  case 33: /* statements: statement  */
#line 565 "1905058.y"
    {
       (yyval.symbol) = (yyvsp[0].symbol);
       fprintf(log_ , "statements : statement\n");

    }
#line 2014 "y.tab.c"
    break;

  case 34: /* statements: statements statement  */
#line 571 "1905058.y"
    {
      (yyval.symbol) = new SymbolInfo((yyvsp[-1].symbol)->get_name()+(yyvsp[0].symbol)->get_name() , "NON_TERMINAL");
      fprintf(log_ , "statements : statements statement\n");

    }
#line 2024 "y.tab.c"
    break;

  case 35: /* statement: var_declaration  */
#line 578 "1905058.y"
    {
      fprintf(log_,"statement : var_declaration\n");
		(yyvsp[0].symbol)->set_name((yyvsp[0].symbol)->get_name()+"\n");
  		(yyval.symbol)=(yyvsp[0].symbol);
    }
#line 2034 "y.tab.c"
    break;

  case 36: /* statement: expression_statement  */
#line 584 "1905058.y"
    {
      fprintf(log_,"statement : expression_statement\n");
		(yyvsp[0].symbol)->set_name((yyvsp[0].symbol)->get_name()+"\n");
		(yyval.symbol)=(yyvsp[0].symbol);
    }
#line 2044 "y.tab.c"
    break;

  case 37: /* statement: compound_statement  */
#line 590 "1905058.y"
    {
      fprintf(log_,"statement : compound_statement\n");
      (yyval.symbol)=(yyvsp[0].symbol);
    }
#line 2053 "y.tab.c"
    break;

  case 38: /* statement: FOR LPAREN expression_statement expression_statement expression RPAREN statement  */
#line 595 "1905058.y"
    {
      string str="for("+(yyvsp[-4].symbol)->get_name()+(yyvsp[-3].symbol)->get_name()+(yyvsp[-2].symbol)->get_name()+")"+(yyvsp[0].symbol)->get_name();
      (yyval.symbol) = new SymbolInfo(str , "NON_TERMINAL");
      fprintf(log_,"statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement\n");
    }
#line 2063 "y.tab.c"
    break;

  case 39: /* statement: IF LPAREN expression RPAREN statement  */
#line 601 "1905058.y"
    {
      string str = "if("+(yyvsp[-2].symbol)->get_name()+")"+(yyvsp[0].symbol)->get_name();
      (yyval.symbol) = new SymbolInfo(str , "statement");
      fprintf(log_,"statement : IF LPAREN expression RPAREN statement\n");
      

    }
#line 2075 "y.tab.c"
    break;

  case 40: /* statement: IF LPAREN expression RPAREN statement ELSE statement  */
#line 609 "1905058.y"
    {
      string str = "if("+(yyvsp[-4].symbol)->get_name()+")"+(yyvsp[-2].symbol)->get_name()+"else"+(yyvsp[0].symbol)->get_name();
      (yyval.symbol) = new SymbolInfo(str , "statement");
      fprintf(log_,"statement : IF LPAREN expression RPAREN statement ELSE statement\n");
    

    }
#line 2087 "y.tab.c"
    break;

  case 41: /* statement: WHILE LPAREN expression RPAREN statement  */
#line 617 "1905058.y"
    {
      string str = "while("+(yyvsp[-2].symbol)->get_name()+")"+(yyvsp[0].symbol)->get_name();
      (yyval.symbol) = new SymbolInfo(str , "statement");
      fprintf(log_,"statement : WHILE LPAREN expression RPAREN statement\n");
    
    }
#line 2098 "y.tab.c"
    break;

  case 42: /* statement: PRINTLN LPAREN ID RPAREN SEMICOLON  */
#line 624 "1905058.y"
    {
      (yyval.symbol) = new SymbolInfo("printf("+(yyvsp[-2].symbol)->get_name()+");" , "statement");
      fprintf(log_,"statement : PRINTLN LPAREN ID RPAREN SEMICOLON\n");
      if((yyvsp[-2].symbol)->get_func_state()){
        if(!table.Lookup_current_scope(func_name((yyvsp[-2].symbol)->get_name()))){
          error_count++;
          fprintf(error , "Line# %d:  Undeclared function '%s'\n" , line_count,func_name((yyvsp[-2].symbol)->get_name()).c_str());
            }
      }

      else if(!table.Lookup_current_scope((yyvsp[-2].symbol)->get_name())){
        error_count++;
        fprintf(error , "Line# %d: Undeclared variable '%s'\n" , line_count,(yyvsp[-2].symbol)->get_name().c_str());
      }
    }
#line 2118 "y.tab.c"
    break;

  case 43: /* statement: RETURN expression SEMICOLON  */
#line 640 "1905058.y"
    {
      (yyval.symbol) = new SymbolInfo("return "+(yyvsp[-1].symbol)->get_name()+";" , "statement");
      fprintf(log_,"statement : RETURN expression SEMICOLON\n");

      
    }
#line 2129 "y.tab.c"
    break;

  case 44: /* expression_statement: SEMICOLON  */
#line 648 "1905058.y"
    {
      (yyval.symbol) = new SymbolInfo(";" , "expression_statement");
      fprintf(log_,"expression_statement : SEMICOLON\n");
    }
#line 2138 "y.tab.c"
    break;

  case 45: /* expression_statement: expression SEMICOLON  */
#line 653 "1905058.y"
    {
      (yyval.symbol) = new SymbolInfo((yyvsp[-1].symbol)->get_name()+";" , "expression_statement");
      fprintf(log_,"expression_statement : expression SEMICOLON\n");
    

    }
#line 2149 "y.tab.c"
    break;

  case 46: /* expression_statement: expression error  */
#line 660 "1905058.y"
    {
      yyclearin;
    }
#line 2157 "y.tab.c"
    break;

  case 47: /* variable: ID  */
#line 665 "1905058.y"
    {
      fprintf(log_,"variable : ID\n");
		(yyval.symbol) = (yyvsp[0].symbol);
      //Semantic : chk if variable is declared before


      (yyval.symbol)->set_id("var");
      (yyval.symbol)->push_var((yyvsp[0].symbol)->get_name(),"",0);
      SymbolInfo *x=table.Lookup((yyvsp[0].symbol)->get_name());
      if(x)
      {(yyval.symbol)->set_var_type(x->get_var_type());
      }



    }
#line 2178 "y.tab.c"
    break;

  case 48: /* variable: ID LSQUARE expression RSQUARE  */
#line 683 "1905058.y"
   {
     fprintf(log_,"variable : ID LSQUARE expression RSQUARE\n");
     (yyval.symbol) = new SymbolInfo((yyvsp[-3].symbol)->get_name()+"["+(yyvsp[-1].symbol)->get_name()+"]" , "variable");
     (yyval.symbol)->set_id("array");
     //array index must be integer

   }
#line 2190 "y.tab.c"
    break;

  case 49: /* expression: logic_expression  */
#line 693 "1905058.y"
    {
      (yyval.symbol) = (yyvsp[0].symbol);
      fprintf(log_,"expression : logic_expression\n");
    }
#line 2199 "y.tab.c"
    break;

  case 50: /* expression: variable ASSIGNOP logic_expression  */
#line 698 "1905058.y"
    {
      (yyval.symbol) = new SymbolInfo((yyvsp[-2].symbol)->get_name()+"="+(yyvsp[0].symbol)->get_name() , "expression");
      fprintf(log_,"expression : variable ASSIGNOP logic_expression\n");

      //semantics
      //todo
      //assign $3's variable_type to $1 after some error chkings

      ///pass arrayname if array otherwise pass varname only
      ///suppose $1->get_name() is a[2].Now modified_name returns only a
      string varname;
      varname = array_name((yyvsp[-2].symbol)->get_name());
      SymbolInfo *x=table.Lookup(varname);
			if(x)
			{
				//setting type of var(int/float)
        (yyvsp[-2].symbol)->set_var_type(x->get_var_type());

        //chk if variable and written with index
        bool isvar=true;
        for(int i=0;i<var_list.size();i++){
          if(var_list[i].name==x->get_name() && var_list[i].size>0){
            isvar = false;break;
         }
        }
        if(isvar){
          if(varname != (yyvsp[-2].symbol)->get_name()){
            error_count++;
            fprintf(error , "Line# %d: '%s' is not an array\n" , line_count,varname.c_str());
          }
        }
        //chk if array
        for(int i=0;i<var_list.size();i++){
          if(var_list[i].name==x->get_name() && var_list[i].size>0){
            //now we're sure that it's an array
            //let's see if ara is being used without any index
            if(varname==(yyvsp[-2].symbol)->get_name()){
              error_count++;
              fprintf(error,"Line# %d: Type mismatch, '%s' is an array\n",line_count , varname.c_str());
              break;

            }
            //now chk if wrong index is given

            else if(!array_index_checker((yyvsp[-2].symbol)->get_name() , var_list[i].size)){
              error_count++;
              fprintf(error,"Line# %d: Array subscript is not an integer\n",line_count);
              break;
            }
          }
        }

        //check if float is assigned to int
        if(x->get_var_type()=="int" && (yyvsp[0].symbol)->get_var_type()=="float"){
					error_count++;
          (yyval.symbol)->set_var_type("int");
					fprintf(error,"Line# %d: Warning: possible loss of data in assignment of FLOAT to INT \n",line_count,(yyvsp[0].symbol)->get_var_type().c_str(),x->get_var_type().c_str());	}
        else if(x->get_var_type()=="float" && (yyvsp[0].symbol)->get_var_type()=="int"){
          (yyval.symbol)->set_var_type("float");
        }
        else{
          (yyval.symbol)->set_var_type(x->get_var_type());
        }


      if((yyvsp[0].symbol)->get_func_state()){
        ///extract function name cause $3 has name like foo(6) but we need only foo
        string fnm = func_name((yyvsp[0].symbol)->get_name());
        if(check_func(fnm)){
          func_ f = get_func(fnm);
          ///chk if func is returning to valid type

          if(f.ret_type=="void"){
            error_count++;
            fprintf(error , "Line# %d: Void cannot be used in expression\n",line_count);
          }
          else if(f.ret_type != (yyvsp[-2].symbol)->get_var_type()){
            error_count++;
            fprintf(error , "Line# %d: Type mismatch in function returning\n",line_count);
          }
        }
      }

			}

			else{
				error_count++;
				fprintf(error,"Line# %d: Undeclared variable '%s'\n",line_count,varname.c_str());
        	}
    }
#line 2294 "y.tab.c"
    break;

  case 51: /* logic_expression: rel_expression  */
#line 790 "1905058.y"
    {
      (yyval.symbol) = (yyvsp[0].symbol);
      fprintf(log_,"logic_expression : rel_expression\n");
    }
#line 2303 "y.tab.c"
    break;

  case 52: /* logic_expression: rel_expression LOGICOP rel_expression  */
#line 795 "1905058.y"
    {
      (yyval.symbol) = new SymbolInfo((yyvsp[-2].symbol)->get_name()+(yyvsp[-1].symbol)->get_name()+(yyvsp[0].symbol)->get_name() , "logic_expression");
      fprintf(log_,"logic_expression : rel_expression LOGICOP rel_expression\n");
      
      /*semantic
      both $1 and $3 must be of type non void
      $$ must be set to type int
      */
      if((yyvsp[-2].symbol)->get_var_type()=="void" || (yyvsp[0].symbol)->get_var_type()=="void"){
 				error_count++;
 				fprintf(error,"Line# %d: Type mismatch(Operands of '%s' can't be void)\n",line_count,(yyvsp[-1].symbol)->get_name().c_str());
        	}

       (yyval.symbol)->set_var_type("int");
    }
#line 2323 "y.tab.c"
    break;

  case 53: /* rel_expression: simple_expression  */
#line 812 "1905058.y"
   {
     (yyval.symbol) = (yyvsp[0].symbol);
     fprintf(log_,"rel_expression	: simple_expression\n");
     
   }
#line 2333 "y.tab.c"
    break;

  case 54: /* rel_expression: simple_expression RELOP simple_expression  */
#line 818 "1905058.y"
   {
     (yyval.symbol) = new SymbolInfo((yyvsp[-2].symbol)->get_name()+(yyvsp[-1].symbol)->get_name()+(yyvsp[0].symbol)->get_name() , "rel_expression");
     fprintf(log_,"rel_expression : simple_expression RELOP simple_expression\n");

     /*semantic
     both $1 and $3 must be of type non void
     $$ must be set to type int
     */
     if((yyvsp[-2].symbol)->get_var_type()=="void" || (yyvsp[0].symbol)->get_var_type()=="void"){
				error_count++;
				fprintf(error,"Line# %d : Type mismatch(Operands of '%s' can't be void)\n",line_count,(yyvsp[-1].symbol)->get_name().c_str());
			}
      (yyval.symbol)->set_var_type("int");
   }
#line 2352 "y.tab.c"
    break;

  case 55: /* simple_expression: term  */
#line 834 "1905058.y"
  {
    (yyval.symbol) = (yyvsp[0].symbol);
    fprintf(log_,"simple_expression : term\n");

  }
#line 2362 "y.tab.c"
    break;

  case 56: /* simple_expression: simple_expression ADDOP term  */
#line 840 "1905058.y"
  {
    (yyval.symbol) = new SymbolInfo((yyvsp[-2].symbol)->get_name()+(yyvsp[-1].symbol)->get_name()+(yyvsp[0].symbol)->get_name() , "simple_expression");
    fprintf(log_,"simple_expression : simple_expression ADDOP term\n");

    if((yyvsp[-2].symbol)->get_var_type()=="float" || (yyvsp[0].symbol)->get_var_type()=="float")
				(yyval.symbol)->set_var_type("float");
			else
				(yyval.symbol)->set_var_type("int");

  }
#line 2377 "y.tab.c"
    break;

  case 57: /* term: unary_expression  */
#line 852 "1905058.y"
    {
      (yyval.symbol) = (yyvsp[0].symbol);
      fprintf(log_,"term :	unary_expression\n");
    }
#line 2386 "y.tab.c"
    break;

  case 58: /* term: term MULOP unary_expression  */
#line 857 "1905058.y"
    {
      (yyval.symbol) = new SymbolInfo((yyvsp[-2].symbol)->get_name()+(yyvsp[-1].symbol)->get_name()+(yyvsp[0].symbol)->get_name() , "term");
      fprintf(log_,"term : term MULOP unary_expression\n");
      //if $3 is void type function
      string fn = func_name((yyvsp[0].symbol)->get_name());
      if(check_func(fn)){
        func_ f = get_func(fn);
        if(f.ret_type=="void"){
          error_count++;
          fprintf(error , "Line# %d: Void cannot be used in expression\n",line_count);        }
      }
      //features of mod operation
      if((yyvsp[-1].symbol)->get_name()=="%" && ((yyvsp[-2].symbol)->get_var_type()!="int" || (yyvsp[0].symbol)->get_var_type()!="int")){
				error_count++;
				fprintf(error,"Line# %d: Operands of modulus must be integers\n",line_count);
        	}
      //mod by zero
      else if((yyvsp[-1].symbol)->get_name()=="%" && (yyvsp[0].symbol)->get_name()=="0"){
				error_count++;
				fprintf(error,"Line# %d: Warning: division by zero \n",line_count);

			}
			//set variable_type
			if((yyvsp[-1].symbol)->get_name()=="%")
				(yyval.symbol)->set_var_type("int");
			else
			{
				if((yyvsp[-2].symbol)->get_var_type()=="float" || (yyvsp[0].symbol)->get_var_type()=="float")
					(yyval.symbol)->set_var_type("float");
				else
					(yyval.symbol)->set_var_type("int");
			}

    }
#line 2425 "y.tab.c"
    break;

  case 59: /* unary_expression: ADDOP unary_expression  */
#line 893 "1905058.y"
    {
      //if $3 is void type function
      string fn = func_name((yyvsp[0].symbol)->get_name());
      if(check_func(fn)){
        func_ f = get_func(fn);
        if(f.ret_type=="void"){
          error_count++;
          fprintf(error , "Line# %d: Void cannot be used in expression\n",line_count);        }
      }

      fprintf(log_,"unary_expression : ADDOP unary_expression\n");

			(yyval.symbol) = new SymbolInfo((yyvsp[-1].symbol)->get_name()+(yyvsp[0].symbol)->get_name(),"unary_expression");

      (yyval.symbol)->set_var_type((yyvsp[0].symbol)->get_var_type());
      (yyval.symbol)->set_id((yyvsp[0].symbol)->get_id());

    }
#line 2448 "y.tab.c"
    break;

  case 60: /* unary_expression: NOT unary_expression  */
#line 912 "1905058.y"
    {
      fprintf(log_,"unary_expression : NOT unary_expression\n");


      (yyval.symbol) = new SymbolInfo("!"+(yyvsp[0].symbol)->get_name(),"unary_expression");

      (yyval.symbol)->set_var_type((yyvsp[0].symbol)->get_var_type());
      (yyval.symbol)->set_id((yyvsp[0].symbol)->get_id());

    }
#line 2463 "y.tab.c"
    break;

  case 61: /* unary_expression: factor  */
#line 923 "1905058.y"
     {
       (yyval.symbol) = (yyvsp[0].symbol);
       fprintf(log_,"unary_expression :	factor\n");       
     }
#line 2472 "y.tab.c"
    break;

  case 62: /* factor: variable  */
#line 930 "1905058.y"
    {
      fprintf(log_,"factor : variable\n");
      (yyval.symbol) = (yyvsp[0].symbol);
      ///pass arrayname if array otherwise pass varname only
      ///suppose $1->get_name() is a[2].Now modified_name returns only a
      string varname;
      varname = array_name((yyvsp[0].symbol)->get_name());
      SymbolInfo *x=table.Lookup(varname);
			if(!x){
        error_count++;
        fprintf(error,"Line# %d: Undeclared variable '%s'\n",line_count,varname.c_str());
              }
      else{

          //setting type of var(int/float) and identity(array/normal variable)
  				(yyval.symbol)->set_var_type(x->get_var_type());
          (yyval.symbol)->set_id(x->get_id());
          //chk if array
          for(int i=0;i<var_list.size();i++){
            if(var_list[i].name==x->get_name() && var_list[i].size>0){
              //now we're sure that it's an array
              //let's see if ara is being used without any index
              if(varname==(yyvsp[0].symbol)->get_name()){
                error_count++;
                fprintf(error,"Line# %d:Type mismatch, '%s' is an array\n",line_count,varname.c_str());
                (yyval.symbol)->set_param_error_state(true);
                break;
              }
              //now chk if wrong index is given
              else if(!array_index_checker((yyvsp[0].symbol)->get_name() , var_list[i].size)){
                error_count++;
                fprintf(error,"Line# %d: Wrong array index\n",line_count);
                break;
              }
            }
          }
      }

    }
#line 2516 "y.tab.c"
    break;

  case 63: /* factor: ID LPAREN argument_list RPAREN  */
#line 970 "1905058.y"
    {

      (yyval.symbol) = new SymbolInfo((yyvsp[-3].symbol)->get_name()+"("+(yyvsp[-1].symbol)->get_name()+")" , "factor");
      fprintf(log_,"factor : ID LPAREN argument_list RPAREN\n");
      (yyval.symbol)->set_func_state(true);

      //semantic
      //chk if id is in func_list
      if(!check_func((yyvsp[-3].symbol)->get_name())){
        error_count++;
        fprintf(error , "Line# %d: Undeclared function '%s'\n",line_count,(yyvsp[-3].symbol)->get_name().c_str());
              }
      else{
        func_ f = get_func((yyvsp[-3].symbol)->get_name());
        //chk args consistency
        if(f.parametres.size() != (yyvsp[-1].symbol)->argument_list.size())
        {
          if(f.parametres.size() > (yyvsp[-1].symbol)->argument_list.size())
          {
          error_count++;
          fprintf(error , "Line# %d: Too few arguments to function '%s'\n",line_count,(yyvsp[-3].symbol)->get_name().c_str());
           }
          else
          {
          error_count++;
          fprintf(error , "Line# %d: Too many arguments to function '%s'\n",line_count,(yyvsp[-3].symbol)->get_name().c_str());
          }
        }
        else{
          for(int i=0;i<f.parametres.size();i++){
            if((yyvsp[-1].symbol)->argument_list[i].error_state){
              error_count++;
              fprintf(error , "Line# %d: Type mismatch for argument %d of '%s'\n",line_count,i+1,(yyvsp[-3].symbol)->get_name().c_str());
              continue;
            }
            //cout<<f.f_name<<" "<<$3->arg_list[i].name<<" "<<$3->arg_list[i].sz<<endl;
            
            if((yyvsp[-1].symbol)->argument_list[i].size>0){
              if((yyvsp[-1].symbol)->get_name()==array_name((yyvsp[-1].symbol)->get_name())){
                 error_count++;
              fprintf(error , "Line# %d: Type mismatch for argument %d of '%s'\n",line_count,i+1,(yyvsp[-3].symbol)->get_name().c_str());
              continue;

              }
            }
          
            if(f.parametres[i].first != (yyvsp[-1].symbol)->argument_list[i].type){
               error_count++;
              fprintf(error , "Line# %d: Type mismatch for argument %d of '%s'\n",line_count,i+1,(yyvsp[-3].symbol)->get_name().c_str());
              continue;
            }
          }
        }
        //cout<<$1->get_name()<<" "<<already_error_in_arg<<endl;
        
      }

    }
#line 2579 "y.tab.c"
    break;

  case 64: /* factor: LPAREN expression RPAREN  */
#line 1029 "1905058.y"
    {
      (yyval.symbol) = new SymbolInfo("("+(yyvsp[-1].symbol)->get_name()+")" , "factor");
      fprintf(log_,"factor : LPAREN expression RPAREN\n");

      (yyval.symbol)->set_var_type((yyvsp[-1].symbol)->get_var_type());

    }
#line 2591 "y.tab.c"
    break;

  case 65: /* factor: CONST_INT  */
#line 1037 "1905058.y"
    {
      fprintf(log_,"factor : CONST_INT\n");
			(yyval.symbol)=(yyvsp[0].symbol);
			(yyval.symbol)->set_var_type("int");
      

    }
#line 2603 "y.tab.c"
    break;

  case 66: /* factor: CONST_FLOAT  */
#line 1045 "1905058.y"
    {
      fprintf(log_,"factor : CONST_FLOAT\n");
			(yyval.symbol)=(yyvsp[0].symbol);
			(yyval.symbol)->set_var_type("float");

    }
#line 2614 "y.tab.c"
    break;

  case 67: /* factor: variable INCOP  */
#line 1052 "1905058.y"
    {
      fprintf(log_,"factor	: variable INCOP\n");
      (yyval.symbol) = new SymbolInfo((yyvsp[-1].symbol)->get_name()+"++","factor");

      SymbolInfo *x=table.Lookup(array_name((yyvsp[-1].symbol)->get_name()));
			if(!x){
        error_count++;
        fprintf(error,"Line# %d: Undeclared variable '%s'\n",line_count,(yyvsp[-1].symbol)->get_name().c_str());
              }
      else{

         (yyval.symbol)->set_var_type((yyvsp[-1].symbol)->get_var_type());
         (yyval.symbol)->set_id((yyvsp[-1].symbol)->get_id());
      }

    }
#line 2635 "y.tab.c"
    break;

  case 68: /* factor: variable DECOP  */
#line 1069 "1905058.y"
    {
      fprintf(log_,"factor	: variable DECOP\n");
      (yyval.symbol) = new SymbolInfo((yyvsp[-1].symbol)->get_name()+"--","factor");

      SymbolInfo *x=table.Lookup(array_name((yyvsp[-1].symbol)->get_name()));
			if(!x){
        error_count++;
        fprintf(error,"Line# %d: Undeclared variable '%s'\n",line_count,(yyvsp[-1].symbol)->get_name().c_str());      }
      else{

         (yyval.symbol)->set_var_type((yyvsp[-1].symbol)->get_var_type());
         (yyval.symbol)->set_id((yyvsp[-1].symbol)->get_id());
      }
    }
#line 2654 "y.tab.c"
    break;

  case 69: /* argument_list: arguments  */
#line 1086 "1905058.y"
        {
          fprintf(log_,"argument_list : arguments\n");
    			(yyval.symbol)=(yyvsp[0].symbol);
        }
#line 2663 "y.tab.c"
    break;

  case 70: /* argument_list: %empty  */
#line 1091 "1905058.y"
        {
          (yyval.symbol) = new SymbolInfo("" , "argument_list");
        }
#line 2671 "y.tab.c"
    break;

  case 71: /* arguments: arguments COMMA logic_expression  */
#line 1096 "1905058.y"
        {
          (yyval.symbol) = new SymbolInfo((yyvsp[-2].symbol)->get_name()+" , "+(yyvsp[0].symbol)->get_name() , "arguments");
          fprintf(log_,"arguments : arguments COMMA logic_expression\n");

          (yyval.symbol)->argument_list = (yyvsp[-2].symbol)->argument_list;
          bool isara=false;
          for(int i=0;i<var_list.size();i++){
            if((yyvsp[0].symbol)->get_name()==var_list[i].name && var_list[i].size>0){
                isara = true;
                if((yyvsp[0].symbol)->get_param_error_state()){
                  (yyval.symbol)->push_argument((yyvsp[0].symbol)->get_name() , (yyvsp[0].symbol)->get_var_type() , var_list[i].size,true);break;
                }
                else (yyval.symbol)->push_argument((yyvsp[0].symbol)->get_name() , (yyvsp[0].symbol)->get_var_type() , var_list[i].size,false);break;
            }
          }
          if(!isara){
            (yyval.symbol)->push_argument((yyvsp[0].symbol)->get_name() , (yyvsp[0].symbol)->get_var_type() , 0,false);
          }

        }
#line 2696 "y.tab.c"
    break;

  case 72: /* arguments: logic_expression  */
#line 1117 "1905058.y"
        {
          fprintf(log_,"arguments : logic_expression\n");
    			(yyval.symbol)=(yyvsp[0].symbol);
          bool isara=false;
          for(int i=0;i<var_list.size();i++){
            if((yyvsp[0].symbol)->get_name()==var_list[i].name && var_list[i].size>0){
              isara = true;
              if((yyvsp[0].symbol)->get_param_error_state()){
                (yyval.symbol)->push_argument((yyvsp[0].symbol)->get_name() , (yyvsp[0].symbol)->get_var_type() , var_list[i].size,true);break;
              }
              else (yyval.symbol)->push_argument((yyvsp[0].symbol)->get_name() , (yyvsp[0].symbol)->get_var_type() , var_list[i].size,false);break;
            }
          }
          if(!isara){
            (yyval.symbol)->push_argument((yyvsp[0].symbol)->get_name() , (yyvsp[0].symbol)->get_var_type() , 0,false);
          }
        }
#line 2718 "y.tab.c"
    break;


#line 2722 "y.tab.c"

      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", YY_CAST (yysymbol_kind_t, yyr1[yyn]), &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYSYMBOL_YYEMPTY : YYTRANSLATE (yychar);
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
      yyerror (YY_("syntax error"));
    }

  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;
  ++yynerrs;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  /* Pop stack until we find a state that shifts the error token.  */
  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYSYMBOL_YYerror;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYSYMBOL_YYerror)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  YY_ACCESSING_SYMBOL (yystate), yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", YY_ACCESSING_SYMBOL (yyn), yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturnlab;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturnlab;


/*-----------------------------------------------------------.
| yyexhaustedlab -- YYNOMEM (memory exhaustion) comes here.  |
`-----------------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  goto yyreturnlab;


/*----------------------------------------------------------.
| yyreturnlab -- parsing is finished, clean up and return.  |
`----------------------------------------------------------*/
yyreturnlab:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  YY_ACCESSING_SYMBOL (+*yyssp), yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif

  return yyresult;
}

#line 1136 "1905058.y"

int main(int argc,char *argv[])
{

	if((fp=fopen(argv[1],"r"))==NULL)
	{
		printf("Cannot Open Input File.\n");
		exit(1);
	}

	yyin=fp;
	yyparse();

	fprintf(log_,"Total Lines: %d \n",line_count);
	fprintf(log_,"Total Errors: %d \n",error_count);

	fclose(fp);
	fclose(log_);
	fclose(error);

	return 0;
}          










      
