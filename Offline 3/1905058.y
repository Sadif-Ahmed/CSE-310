%{
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
FILE *log_ = fopen("1905058_log.txt","a");
// FILE *token = fopen("1905058_token.txt","w");
ILE *error = fopen("1905058_error.txt","a");

SymbolTable table(11);

extern int line_count;
extern int error_count=0;

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
  return NULL;
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
string int_to_str(int n)
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
  fprintf(error,"Line# %d: %s\n\n",line_count,s);
}
%}

%union {
    SymbolInfo *symbol;
}

%token IF ELSE FOR WHILE DO BREAK INT CHAR FLOAT DOUBLE
%token VOID RETURN SWITCH CASE DEFAULT CONTINUE
%token ASSIGNOP INCOP DECOP NOT LPAREN RPAREN LCURL RCURL LSQUARE RSQUARE COMMA SEMICOLON PRINTLN

%token<symbol>CONST_INT
%token<symbol>CONST_FLOAT
%token<symbol>CONST_CHAR
%token<symbol>ID
%token<symbol>ADDOP
%token<symbol>MULOP
%token<symbol>RELOP
%token<symbol>LOGICOP

%type<symbol>compound_statement type_specifier parameter_list declaration_list var_declaration unit func_declaration statement statements variable expression factor arguments argument_list expression_statement unary_expression simple_expression logic_expression rel_expression term func_definition program
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

start : program
	{
		//write your code in this block in all the similar blocks below
	}
	;

program : program unit
	{
		fprintf(log_,"Line# %d:  program : program unit\n\n",line_count);
		$$ = new SymbolInfo((string)$1->get_name()+(string)$2->get_name(), "NON_TERMINAL");
	}
	| unit
	{
		fprintf(log_,"Line# %d: program : unit\n\n",line_count);
		$$ = new SymbolInfo($1->get_name()+"\n", "NON_TERMINAL");
	}
	;
unit : var_declaration
	{
		fprintf(log_,"Line# %d: unit : var_declaration\n\n",line_count);
		$$ = new SymbolInfo($1->get_name(), "NON_TERMINAL");
	}
     | func_declaration
	{
		fprintf(log_,"Line# %d: unit : func_declaration\n\n",line_count);
		$$ = new SymbolInfo($1->get_name(), "NON_TERMINAL");
	}
     | func_definition
	{
        fprintf(logfile,"Line# %d: unit : func_definition\n\n",line_count);
		$$ = new SymbolInfo($1->get_name(), "NON_TERMINAL");
	}
     ;
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON
	{
    $$ = new SymbolInfo($1->get_name()+" "+$2->get_name()+"("+$4->get_name()+");", "NON_TERMINAL");
    fprintf(log_ , "Line# %d: func_declaration: type_specifier ID LPAREN parameter_list RPAREN SEMICOLON\n\n",line_count);

    /* checking whether already declared or not */
    SymbolInfo* temp = table.Lookup_current_scope($2->get_name());
    if(temp != NULL) {
			error_count++;
			fprintf(error , "Line# %d: Multiple declaration of %s\n\n" , line_count , $2->get_name().c_str());
		}
    else{
      table.Insert($2->get_name() , "ID" , log_);
      SymbolInfo *fd = table.Lookup_current_scope($2->get_name());
      fd->set_func_decl_state(true);

      //insert in func_list
      func_insert($2->get_name() , $4->param_list , $1->get_name());
    }

	}
    | type_specifier ID LPAREN RPAREN SEMICOLON
	{
		$$ = new SymbolInfo($1->get_name()+" "+$2->get_name()+"();", "NON_TERMINAL");
		fprintf(log_ , "Line# %d: func_declaration: type_specifier ID LPAREN RPAREN SEMICOLON\n\n",line_count);
		
        /* checking whether already declared or not */
		SymbolInfo* temp = table.Lookup_current_scope($2->get_name());
		if(temp != NULL) {
			error_count++;
			fprintf(error , "Line# %d: Multiple declaration of %s\n\n" , line_count , $2->get_name().c_str());
		}
    else{
      table.Insert($2->get_name() , "ID" , log_);
      SymbolInfo *fd = table.Lookup_current_scope($2->get_name());
      fd->set_func_decl_state(true);
      func_insert($2->get_name() , $1->get_name());
    }

	}
		;
func_definition : type_specifier ID LPAREN parameter_list RPAREN
  {
    //chking if invalid params given
    if($4->get_name()=="int" or $4->get_name()=="float"){
      error_count++;
      fprintf(error , "Line# %d: 1st parameter's name not given in function definition of %s\n\n" , line_count, $2->get_name().c_str());
    }
    //chking if declared previously and now being defined
    //param types,return type must be matched
    //assuming we don't need to handle function overloading
    if(check_func($2->get_name())){
      func_ f = get_func($2->get_name());
      if(f.return_type != $1->get_name()){
        error_count++;
        fprintf(error , "Line# %d: Return type mismatch with function declaration in function %s\n\n",line_count,$2->get_name().c_str());
      }
      else {
        bool matched = true;
        int n = $4->param_list.size();
        if(n == f.parametres.size()){
          for(int i=0;i<f.parametres.size();i++){
            if(f.parametres[i].first != $4->param_list[i].type){
              matched = false;
              break;
            }
          }
        }
        else{
          matched = false;
        }
        if(!matched){
          error_count++;
          fprintf(error , "Line# %d: Total number of arguments mismatch with declaration in function %s\n\n",line_count , $2->get_name().c_str());
          }
      }
    }


    /* checking whether already defined or not */
		SymbolInfo* temp = table.Lookup_current_scope($2->get_name());
		if(temp != NULL and (!temp->get_func_decl_state())) {
			error_count++;
			fprintf(error , "Line# %d: Multiple declaration of %s\n\n" , line_count , $2->get_name().c_str());
      	}
		else if(temp == NULL){
			table.Insert($2->get_name() , "ID" , log_);
      //insert in func_list
      func_insert($2->get_name() , $4->param_list , $1->get_name());
		}


    table.Enter_Scope(log_);
    for(int i=0;i<$4->param_list.size();i++){
        string name = $4->param_list[i].name;
        string type = "ID";
        SymbolInfo *tmp = table.Lookup_current_scope(name);
        if(tmp){
          fprintf(error,"Line# %d: Multiple declaration of %s in parameter\n\n",line_count,name.c_str());
          error_count++;
        }
        else{
          table.Insert(name , type , log_);
        }
    }

  } compound_statement { table.Exit_Scope(log_);var_list.clear();}

  {
      $$ = new SymbolInfo($1->get_name()+" "+$2->get_name()+"("+$4->get_name()+")"+$7->get_name()+"\n\n", "NON_TERMINAL");
      fprintf(logfile , "Line# %d: func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement\n\n" , line_count);

  }  
  | type_specifier ID LPAREN RPAREN
    {
      curr_ret_type = $1->get_name();
      /* checking whether already declared or not */
  		SymbolInfo* temp = table.Lookup_current_scope($2->get_name());
      if(temp != NULL and (!temp->get_func_decl_state())) {
  			error_count++;
  			fprintf(error , "Line# %d: Multiple declaration of %s\n\n" , line_count , $2->get_name().c_str());
        }
  		else if(temp == NULL){
  			table.Insert($2->get_name() , "ID" , log_);
        func_insert($2->get_name() , $1->get_name());
  		}

      table.Enter_Scope(log_);

    }
    compound_statement {table.Exit_Scope(log_);var_list.clear();}
 	{
      $$ = new SymbolInfo($1->get_name()+" "+$2->get_name()+"()"+$6->get_name()+"\n\n", "NON_TERMINAL");
      fprintf(log_ , "Line# %d: func_definition : type_specifier ID LPAREN RPAREN compound_statement\n\n" , line_count);
	}
	 	;
parameter_list  : parameter_list COMMA type_specifier ID
		{
			$$ = new SymbolInfo($1->get_name()+","+$3->get_name()+" "+$4->get_name(), "NON_TERMINAL");
			fprintf(log_,"Line# %d: parameter_list : parameter_list COMMA type_specifier ID\n\n",line_count);
			/* adding parameter to parameter list */
      $$->param_list = $1->param_list;
			$$->push_param($4->get_name() , $3->get_name());

      if($3->get_type()=="void"){
        error_count++;
        fprintf(log_,"Line# %d: Variable type cannot be void\n\n",line_count);
        }
		}
		| parameter_list COMMA type_specifier
		{
			$$ = new SymbolInfo($1->get_name()+","+$3->get_name(), "NON_TERMINAL");
			fprintf(log_,"Line# %d: parameter_list  : parameter_list COMMA type_specifier\n\n",line_count);
			/* adding parameter to parameter list */
      $$->param_list = $1->param_list;
			$$->push_param("", $3->get_name());
		}
 		| type_specifier ID
		{
			$$ = new SymbolInfo($1->get_name()+" "+$2->get_name(), "NON_TERMINAL");
			fprintf(log_,"Line# %d: parameter_list  : type_specifier ID\n\n",line_count);
			/* adding parameter to parameter list */
      if($1->get_name()=="void"){
        error_count++;
				fprintf(error,"Line# %d: Variable type cannot be void\n\n",line_count);
      }
			$$->push_param($2->get_name() ,$1->get_name());
		}
		| type_specifier
		{
			$$ = new SymbolInfo($1->get_name(), "NON_TERMINAL");
			fprintf(log_,"Line# %d: parameter_list  : type_specifier\n\n",line_count);
			/* adding parameter to parameter list */

			$$->push_param( "" , $1->get_name());
		}
    | type_specifier error
    {
      yyclearin;
      yyerrok;
    }
 		;
compound_statement : LCURL statements RCURL
  {
      $$ = new SymbolInfo("{\n"+$2->get_name()+"\n}"+"\n\n", "NON_TERMINAL");
      fprintf(log_,"Line# %d: compound_statement : LCURL statements RCURL\n\n",line_count);
      table.printall(log_);
  }
 		    | LCURL RCURL
  {
    $$ = new SymbolInfo("{\n}", "NON_TERMINAL");
    fprintf(log_,"Line %d: compound_statement : LCURL RCURL\n\n",line_count);
    table.printall(log_);
  }
 		    ;
var_declaration : type_specifier declaration_list SEMICOLON
		{
			fprintf(log_,"Line# %d: var_declaration : type_specifier declaration_list SEMICOLON\n\n",line_count);
			$$ = new SymbolInfo($1->get_name()+" "+$2->get_name()+";", "NON_TERMINAL");

      $$->set_var_type($1->get_name());

      //setting type of all elements of var in declaration_list
      for(int i=0;i<$2->var_list.size();i++){
          $2->var_list[i].type = $1->get_name();
      }
			/* inserting in symboltable */
			if($1->get_name()=="void"){
				error_count++;
				fprintf(error,"Line# %d: Variable type cannot be void\n\n",line_count);

			}
			else{
				/* checking whether already declared or not */
				for(int i=0;i<$2->var_list.size();i++){
					SymbolInfo* temp = table.Lookup_current_scope($2->var_list[i].name);
					if(temp != NULL) {
						error_count++;
						fprintf(error , "Line# %d: Multiple declaration of %s\n\n" , line_count , $2->var_list[i].name.c_str());
					}
					else{
						table.Insert($2->var_list[i].name , "ID" , log_);
            SymbolInfo *tmp = table.Lookup_current_scope($2->var_list[i].name);
            tmp->set_var_type($1->get_name());
            if($2->var_list[i].size>0){
              tmp->set_id("array");
            }else{
              tmp->set_id("var");
            }
					}
				}

			}

			//var_list.clear();
		}
    |
   error SEMICOLON
    {
      yyclearin;
      yyerrok;
    }
 		;
type_specifier	: INT
		{
			fprintf(log_,"Line# %d: type_specifier : INT \n\n",line_count);
			var_type = "int";

			SymbolInfo *x = new SymbolInfo("int" , "int");
			$$ = x;
			
		}
 		| FLOAT
		{
			fprintf(log_,"Line# %d: type_specifier : FLOAT \n",line_count);
			var_type = "float";

			SymbolInfo *x = new SymbolInfo("float" , "float");
			$$ = x;
			
		}
 		| VOID
 		{
			fprintf(log_,"Line# %d: type_specifier : VOID \n",line_count);
			var_type = "void";

			SymbolInfo *x = new SymbolInfo("void" , "void");
			$$ = x;
			
		}
		 ;        


      
