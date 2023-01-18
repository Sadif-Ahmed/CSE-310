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
  fprintf(error,"Line# %d: %s\n",line_count,s);
}
%}

%union {
    SymbolInfo *symbol;
}

%token IF ELSE FOR WHILE DO BREAK INT CHAR FLOAT DOUBLE
%token VOID RETURN SWITCH CASE DEFAULT CONTINUE
%token ASSIGNOP INCOP DECOP NOT LPAREN RPAREN LCURL RCURL LSQUARE RSQUARE COMMA SEMICOLON PRINTLN BITOP

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
        fprintf(log_,"start : program\n");
	}
	;

program : program unit
	{
		fprintf(log_,"program : program unit\n");
		$$ = new SymbolInfo((string)$1->get_name()+(string)$2->get_name(), "NON_TERMINAL");
	}
	| unit
	{
		fprintf(log_,"program : unit\n");
		$$ = new SymbolInfo($1->get_name()+"\n", "NON_TERMINAL");
	}
	;
unit : var_declaration
	{
		fprintf(log_,"unit : var_declaration\n");
		$$ = new SymbolInfo($1->get_name(), "NON_TERMINAL");
	}
     | func_declaration
	{
		fprintf(log_,"unit : func_declaration\n");
		$$ = new SymbolInfo($1->get_name(), "NON_TERMINAL");
	}
     | func_definition
	{
        fprintf(log_,"unit : func_definition\n");
		$$ = new SymbolInfo($1->get_name(), "NON_TERMINAL");
	}
     ;
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON
	{
    $$ = new SymbolInfo($1->get_name()+" "+$2->get_name()+"("+$4->get_name()+");", "NON_TERMINAL");
    fprintf(log_ , "func_declaration: type_specifier ID LPAREN parameter_list RPAREN SEMICOLON\n");

    /* checking whether already declared or not */
    SymbolInfo* temp = table.Lookup_current_scope($2->get_name());
    if(temp != NULL) {
			error_count++;
			fprintf(error , "Line# %d: Multiple declaration of %s\n" , line_count , $2->get_name().c_str());
		}
    else{
      table.Insert($2->get_name() , "ID" , log_);
      SymbolInfo *fd = table.Lookup_current_scope($2->get_name());
      fd->set_func_decl_state(true);
      fd->set_ret_type($1->get_name());

      //insert in func_list
      func_insert($2->get_name() , $4->param_list , $1->get_name());
    }

	}
    | type_specifier ID LPAREN RPAREN SEMICOLON
	{
		$$ = new SymbolInfo($1->get_name()+" "+$2->get_name()+"();", "NON_TERMINAL");
		fprintf(log_ , "func_declaration: type_specifier ID LPAREN RPAREN SEMICOLON\n");
		
        /* checking whether already declared or not */
		SymbolInfo* temp = table.Lookup_current_scope($2->get_name());
		if(temp != NULL) {
			error_count++;
			fprintf(error , "Line# %d: Multiple declaration of %s\n" , line_count , $2->get_name().c_str());
		}
    else{
      table.Insert($2->get_name() , "ID" , log_);
      SymbolInfo *fd = table.Lookup_current_scope($2->get_name());
      fd->set_func_decl_state(true);
      fd->set_ret_type($1->get_name());
      func_insert($2->get_name() , $1->get_name());
    }

	}
		;
func_definition : type_specifier ID LPAREN parameter_list RPAREN
  {
    //chking if invalid params given
    if($4->get_name()=="int" or $4->get_name()=="float"){
      error_count++;
      fprintf(error , "Line# %d: 1st parameter's name not given in function definition of %s\n" , line_count, $2->get_name().c_str());
    }
    //chking if declared previously and now being defined
    //param types,return type must be matched
    //assuming we don't need to handle function overloading
    if(check_func($2->get_name())){
      func_ f = get_func($2->get_name());
      if(f.ret_type != $1->get_name()){
        error_count++;
        fprintf(error , "Line# %d: Return type mismatch with function declaration in function %s\n",line_count,$2->get_name().c_str());
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
          fprintf(error , "Line# %d: Total number of arguments mismatch with declaration in function %s\n",line_count , $2->get_name().c_str());
          }
      }
    }


    /* checking whether already defined or not */
		SymbolInfo* temp = table.Lookup_current_scope($2->get_name());
		if(temp != NULL and (!temp->get_func_decl_state())) {
			error_count++;
			fprintf(error , "Line# %d: Multiple declaration of %s\n" , line_count , $2->get_name().c_str());
      	}
		else if(temp == NULL){
			table.Insert($2->get_name() , "ID" , log_);
      SymbolInfo *fd = table.Lookup_current_scope($2->get_name());
      fd->set_func_decl_state(true);
      fd->set_ret_type($1->get_name());
      //insert in func_list
      func_insert($2->get_name() , $4->param_list , $1->get_name());
		}


    table.Enter_Scope();
    for(int i=0;i<$4->param_list.size();i++){
        string name = $4->param_list[i].name;
        string type = "ID";
        SymbolInfo *tmp = table.Lookup_current_scope(name);
        if(tmp){
          fprintf(error,"Line# %d: Multiple declaration of %s in parameter\n",line_count,name.c_str());
          error_count++;
        }
        else{
          table.Insert(name , type , log_);
          SymbolInfo *par =  table.Lookup_current_scope(name);
          par->set_var_type($4->param_list[i].type);
        }
    }

  } compound_statement { table.Exit_Scope();var_list.clear();}

  {
      $$ = new SymbolInfo($1->get_name()+" "+$2->get_name()+"("+$4->get_name()+")"+$7->get_name()+"\n", "NON_TERMINAL");
      fprintf(log_ , "func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement\n");

  }  
  | type_specifier ID LPAREN RPAREN
    {
      curr_ret_type = $1->get_name();
      /* checking whether already declared or not */
  		SymbolInfo* temp = table.Lookup_current_scope($2->get_name());
      if(temp != NULL and (!temp->get_func_decl_state())) {
  			error_count++;
  			fprintf(error , "Line# %d: Multiple declaration of %s\n" , line_count , $2->get_name().c_str());
        }
  		else if(temp == NULL){
  			table.Insert($2->get_name() , "ID" , log_);
      SymbolInfo *fd = table.Lookup_current_scope($2->get_name());
      fd->set_func_decl_state(true);
      fd->set_ret_type($1->get_name());
        func_insert($2->get_name() , $1->get_name());
  		}

      table.Enter_Scope();

    }
    compound_statement {table.Exit_Scope();var_list.clear();}
 	{
      $$ = new SymbolInfo($1->get_name()+" "+$2->get_name()+"()"+$6->get_name()+"\n", "NON_TERMINAL");
      fprintf(log_ , "func_definition : type_specifier ID LPAREN RPAREN compound_statement\n");
	}
	 	;
parameter_list  : parameter_list COMMA type_specifier ID
		{
			$$ = new SymbolInfo($1->get_name()+","+$3->get_name()+" "+$4->get_name(), "NON_TERMINAL");
			fprintf(log_,"parameter_list : parameter_list COMMA type_specifier ID\n");
			/* adding parameter to parameter list */
      $$->param_list = $1->param_list;
			$$->push_param($4->get_name() , $3->get_name());

      if($3->get_type()=="void"){
        error_count++;
        fprintf(log_,"Variable type cannot be void\n");
        }
		}
		| parameter_list COMMA type_specifier
		{
			$$ = new SymbolInfo($1->get_name()+","+$3->get_name(), "NON_TERMINAL");
			fprintf(log_,"parameter_list  : parameter_list COMMA type_specifier\n");
			/* adding parameter to parameter list */
      $$->param_list = $1->param_list;
			$$->push_param("", $3->get_name());
		}
 		| type_specifier ID
		{
			$$ = new SymbolInfo($1->get_name()+" "+$2->get_name(), "NON_TERMINAL");
			fprintf(log_,"parameter_list  : type_specifier ID\n");
			/* adding parameter to parameter list */
      if($1->get_name()=="void"){
        error_count++;
				fprintf(error,"Line# %d: Variable type cannot be void\n",line_count);
      }
			$$->push_param($2->get_name() ,$1->get_name());

      
		}
		| type_specifier
		{
			$$ = new SymbolInfo($1->get_name(), "NON_TERMINAL");
			fprintf(log_,"parameter_list  : type_specifier\n");
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
      $$ = new SymbolInfo("{\n"+$2->get_name()+"\n}"+"\n", "NON_TERMINAL");
      fprintf(log_,"compound_statement : LCURL statements RCURL\n");
      table.printall(log_);
  }
 		    | LCURL RCURL
  {
    $$ = new SymbolInfo("{\n}", "NON_TERMINAL");
    fprintf(log_,"compound_statement : LCURL RCURL\n");
    table.printall(log_);
  }
 		    ;
var_declaration : type_specifier declaration_list SEMICOLON
		{
			fprintf(log_,"var_declaration : type_specifier declaration_list SEMICOLON\n");
			$$ = new SymbolInfo($1->get_name()+" "+$2->get_name()+";", "NON_TERMINAL");

      $$->set_var_type($1->get_name());

      //setting type of all elements of var in declaration_list
      for(int i=0;i<$2->var_list.size();i++){
          $2->var_list[i].type = $1->get_name();
      }
			/* inserting in symboltable */
			if($1->get_name()=="void"){
				error_count++;
				fprintf(error,"Line# %d: Variable type cannot be void\n",line_count);

			}
			else{
				/* checking whether already declared or not */
				for(int i=0;i<$2->var_list.size();i++){
					SymbolInfo* temp = table.Lookup_current_scope($2->var_list[i].name);
					if(temp != NULL) {
						error_count++;
						fprintf(error , "Line# %d: Multiple declaration of %s\n" , line_count , $2->var_list[i].name.c_str());
					}
					else{
						table.Insert($2->var_list[i].name , "ID" , log_);
            SymbolInfo *tmp = table.Lookup_current_scope($2->var_list[i].name);
            tmp->set_var_type($1->get_name());
            if($2->var_list[i].size>0){
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
    |
   error SEMICOLON
    {
      yyclearin;
      yyerrok;
    }
 		;
type_specifier	: INT
		{
			fprintf(log_,"type_specifier : INT \n");
			var_type = "int";

			SymbolInfo *x = new SymbolInfo("int" , "int");
			$$ = x;
			
		}
 		| FLOAT
		{
			fprintf(log_,"type_specifier : FLOAT \n");
			var_type = "float";

			SymbolInfo *x = new SymbolInfo("float" , "float");
			$$ = x;
			
		}
 		| VOID
 		{
			fprintf(log_,"type_specifier : VOID \n");
			var_type = "void";

			SymbolInfo *x = new SymbolInfo("void" , "void");
			$$ = x;
			
		}
		 ;  
declaration_list : declaration_list COMMA ID
		{
			fprintf(log_,"declaration_list : declaration_list COMMA ID\n");
			$$ = new SymbolInfo((string)$1->get_name()+(string)","+(string)$3->get_name(), "NON_TERMINAL");
			
			/* keeping track of identifier(variable) */
      temp_var.name = $3->get_name();
      temp_var.size = -1;
      var_list.push_back(temp_var);

      /* 3 args are name , type, size of variable */
      $$->var_list = $1->var_list;
      $$->push_var($3->get_name() , "" , 0);

		}
 		  | declaration_list COMMA ID LSQUARE CONST_INT RSQUARE
		{
			fprintf(log_,"declaration_list : declaration_list COMMA ID LSQUARE CONST_INT RSQUARE\n");
			$$ = new SymbolInfo((string)$1->get_name()+(string)","+(string)$3->get_name()+(string)"["+(string)$5->get_name()+(string)"]", "NON_TERMINAL");
			
			/* keeping track of identifier(array) */
      temp_var.name = (string)$3->get_name();
      stringstream temp_str((string) $5->get_name());
      temp_str >> temp_var.size;
      var_list.push_back(temp_var);

      stringstream geek($5->get_name());
      int size = 0;
      geek >> size;

      $$->var_list = $1->var_list;
      $$->push_var($3->get_name() , "" , size);
		}

 		  | ID
		{
			fprintf(log_,"declaration_list : ID\n");
 			$$ = new SymbolInfo($1->get_name() ,  "ID");
			 /* keeping track of identifier(variable) */
      temp_var.name = (string)$1->get_name();
      temp_var.size = -1;
      var_list.push_back(temp_var);

      $$->push_var($1->get_name() , "" , 0);

		}
 		| ID LSQUARE CONST_INT RSQUARE
		{
			fprintf(log_ , "declaration_list: ID LSQUARE CONST_INT RSQUARE\n");
			$$ = new SymbolInfo($1->get_name()+"["+$3->get_name()+"]", "NON_TERMINAL");
			temp_var.name = $1->get_name();
      stringstream temp_str($3->get_name());
      temp_str >> temp_var.size;
      var_list.push_back(temp_var);

      stringstream geek($3->get_name());
      int size = 0;
      geek >> size;

      $$->push_var($1->get_name() , "" , size);
    

		}
    | declaration_list error
    {
      yyclearin;
    }

 		  ;
statements : statement
    {
       $$ = $1;
       fprintf(log_ , "statements : statement\n");

    }
	   | statements statement
    {
      $$ = new SymbolInfo($1->get_name()+$2->get_name() , "NON_TERMINAL");
      fprintf(log_ , "statements : statements statement\n");

    }
	   ;   
statement : var_declaration
    {
      fprintf(log_,"statement : var_declaration\n");
		$1->set_name($1->get_name()+"\n");
  		$$=$1;
    }
	  | expression_statement
    {
      fprintf(log_,"statement : expression_statement\n");
		$1->set_name($1->get_name()+"\n");
		$$=$1;
    }
	  | compound_statement
    {
      fprintf(log_,"statement : compound_statement\n");
      $$=$1;
    }
	  | FOR LPAREN expression_statement expression_statement expression RPAREN statement
    {
      string str="for("+$3->get_name()+$4->get_name()+$5->get_name()+")"+$7->get_name();
      $$ = new SymbolInfo(str , "NON_TERMINAL");
      fprintf(log_,"statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement\n");
    }
	  | IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE
    {
      string str = "if("+$3->get_name()+")"+$5->get_name();
      $$ = new SymbolInfo(str , "statement");
      fprintf(log_,"statement : IF LPAREN expression RPAREN statement\n");
      

    }
	  | IF LPAREN expression RPAREN statement ELSE statement
    {
      string str = "if("+$3->get_name()+")"+$5->get_name()+"else"+$7->get_name();
      $$ = new SymbolInfo(str , "statement");
      fprintf(log_,"statement : IF LPAREN expression RPAREN statement ELSE statement\n");
    

    }
	  | WHILE LPAREN expression RPAREN statement
    {
      string str = "while("+$3->get_name()+")"+$5->get_name();
      $$ = new SymbolInfo(str , "statement");
      fprintf(log_,"statement : WHILE LPAREN expression RPAREN statement\n");
    
    }
	  | PRINTLN LPAREN ID RPAREN SEMICOLON
    {
      $$ = new SymbolInfo("printf("+$3->get_name()+");" , "statement");
      fprintf(log_,"statement : PRINTLN LPAREN ID RPAREN SEMICOLON\n");
      if($3->get_func_state()){
        if(!table.Lookup_current_scope(func_name($3->get_name()))){
          error_count++;
          fprintf(error , "Line# %d:  Undeclared function %s\n" , line_count,func_name($3->get_name()).c_str());
            }
      }

      else if(!table.Lookup_current_scope($3->get_name())){
        error_count++;
        fprintf(error , "Line %d: Undeclared Variable %s\n" , line_count,$3->get_name().c_str());
      }
    }
	  | RETURN expression SEMICOLON
    {
      $$ = new SymbolInfo("return "+$2->get_name()+";" , "statement");
      fprintf(log_,"statement : RETURN expression SEMICOLON\n");

      
    }
	  ;
expression_statement 	: SEMICOLON
    {
      $$ = new SymbolInfo(";" , "expression_statement");
      fprintf(log_,"expression_statement : SEMICOLON\n");
    }
			| expression SEMICOLON
    {
      $$ = new SymbolInfo($1->get_name()+";" , "expression_statement");
      fprintf(log_,"expression_statement : expression SEMICOLON\n");
    

    }
    | expression error
    {
      yyclearin;
    }
			;
variable : ID
    {
      fprintf(log_,"variable : ID\n");
		$$ = $1;
      //Semantic : chk if variable is declared before


      $$->set_id("var");
      $$->push_var($1->get_name(),"",0);
      SymbolInfo *x=table.Lookup($1->get_name());
      if(x)
      {$$->set_var_type(x->get_var_type());
      }



    }

	 | ID LSQUARE expression RSQUARE
   {
     fprintf(log_,"variable : ID LSQUARE expression RSQUARE\n");
     $$ = new SymbolInfo($1->get_name()+"["+$3->get_name()+"]" , "variable");
     $$->set_id("array");
     //array index must be integer

   }

	 ;       
expression : logic_expression
    {
      $$ = $1;
      fprintf(log_,"expression : logic_expression\n");
    }
	   | variable ASSIGNOP logic_expression
    {
      $$ = new SymbolInfo($1->get_name()+"="+$3->get_name() , "expression");
      fprintf(log_,"expression : variable ASSIGNOP logic_expression\n");

      //semantics
      //todo
      //assign $3's variable_type to $1 after some error chkings

      ///pass arrayname if array otherwise pass varname only
      ///suppose $1->get_name() is a[2].Now modified_name returns only a
      string varname;
      varname = array_name($1->get_name());
      SymbolInfo *x=table.Lookup(varname);
			if(x)
			{
				//setting type of var(int/float)
        $1->set_var_type(x->get_var_type());

        //chk if variable and written with index
        bool isvar=true;
        for(int i=0;i<var_list.size();i++){
          if(var_list[i].name==x->get_name() && var_list[i].size>0){
            isvar = false;break;
         }
        }
        if(isvar){
          if(varname != $1->get_name()){
            error_count++;
            fprintf(error , "Line %d: %s not an array\n" , line_count,varname.c_str());
          }
        }
        //chk if array
        for(int i=0;i<var_list.size();i++){
          if(var_list[i].name==x->get_name() && var_list[i].size>0){
            //now we're sure that it's an array
            //let's see if ara is being used without any index
            if(varname==$1->get_name()){
              error_count++;
              fprintf(error,"Line %d: Type Mismatch, %s is an array\n",line_count , varname.c_str());
              break;

            }
            //now chk if wrong index is given

            else if(!array_index_checker($1->get_name() , var_list[i].size)){
              error_count++;
              fprintf(error,"Line %d: Expression inside third brackets not an integer\n",line_count);
              break;
            }
          }
        }

        //check if float is assigned to int
        if(x->get_var_type()=="int" && $3->get_var_type()=="float"){
					error_count++;
          $$->set_var_type("int");
					fprintf(error,"Line %d: Type mismatch \n",line_count,$3->get_var_type().c_str(),x->get_var_type().c_str());	}
        else if(x->get_var_type()=="float" && $3->get_var_type()=="int"){
          $$->set_var_type("float");
        }
        else{
          $$->set_var_type(x->get_var_type());
        }


      if($3->get_func_state()){
        ///extract function name cause $3 has name like foo(6) but we need only foo
        string fnm = func_name($3->get_name());
        if(check_func(fnm)){
          func_ f = get_func(fnm);
          ///chk if func is returning to valid type

          if(f.ret_type=="void"){
            error_count++;
            fprintf(error , "Line %d: Void function used in expression\n",line_count);
          }
          else if(f.ret_type != $1->get_var_type()){
            error_count++;
            fprintf(error , "Line %d: Type Mismatch in function returning\n",line_count);
          }
        }
      }

			}

			else{
				error_count++;
				fprintf(error,"Line %d: Undeclared variable %s\n",line_count,varname.c_str());
        	}
    }
	   ;
logic_expression : rel_expression
    {
      $$ = $1;
      fprintf(log_,"logic_expression : rel_expression\n");
    }
		 | rel_expression LOGICOP rel_expression
    {
      $$ = new SymbolInfo($1->get_name()+$2->get_name()+$3->get_name() , "logic_expression");
      fprintf(log_,"logic_expression : rel_expression LOGICOP rel_expression\n");
      
      /*semantic
      both $1 and $3 must be of type non void
      $$ must be set to type int
      */
      if($1->get_var_type()=="void" || $3->get_var_type()=="void"){
 				error_count++;
 				fprintf(error,"Line %d: Type Mismatch(Operands of %s can't be void)\n",line_count,$2->get_name().c_str());
        	}

       $$->set_var_type("int");
    }
		 ;
rel_expression	: simple_expression
   {
     $$ = $1;
     fprintf(log_,"rel_expression	: simple_expression\n");
     
   }
		| simple_expression RELOP simple_expression
   {
     $$ = new SymbolInfo($1->get_name()+$2->get_name()+$3->get_name() , "rel_expression");
     fprintf(log_,"rel_expression : simple_expression RELOP simple_expression\n");

     /*semantic
     both $1 and $3 must be of type non void
     $$ must be set to type int
     */
     if($1->get_var_type()=="void" || $3->get_var_type()=="void"){
				error_count++;
				fprintf(error,"Line %d : Type Mismatch(Operands of %s can't be void)\n",line_count,$2->get_name().c_str());
			}
      $$->set_var_type("int");
   }
		;
simple_expression : term
  {
    $$ = $1;
    fprintf(log_,"simple_expression : term\n");

  }
		  | simple_expression ADDOP term
  {
    $$ = new SymbolInfo($1->get_name()+$2->get_name()+$3->get_name() , "simple_expression");
    fprintf(log_,"simple_expression : simple_expression ADDOP term\n");

    if($1->get_var_type()=="float" || $3->get_var_type()=="float")
				$$->set_var_type("float");
			else
				$$->set_var_type("int");

  }
		  ;     
term :	unary_expression
    {
      $$ = $1;
      fprintf(log_,"term :	unary_expression\n");
    }
     |  term MULOP unary_expression
    {
      $$ = new SymbolInfo($1->get_name()+$2->get_name()+$3->get_name() , "term");
      fprintf(log_,"term : term MULOP unary_expression\n");
      //if $3 is void type function
      string fn = func_name($3->get_name());
      if(check_func(fn)){
        func_ f = get_func(fn);
        if(f.ret_type=="void"){
          error_count++;
          fprintf(error , "Line %d: Void function used in expression\n",line_count);        }
      }
      //features of mod operation
      if($2->get_name()=="%" && ($1->get_var_type()!="int" || $3->get_var_type()!="int")){
				error_count++;
				fprintf(error,"Line %d: Non-Integer operand on modulus operator\n",line_count);
        	}
      //mod by zero
      else if($2->get_name()=="%" && $3->get_name()=="0"){
				error_count++;
				fprintf(error,"Line %d: Modulus by Zero\n",line_count);

			}
			//set variable_type
			if($2->get_name()=="%")
				$$->set_var_type("int");
			else
			{
				if($1->get_var_type()=="float" || $3->get_var_type()=="float")
					$$->set_var_type("float");
				else
					$$->set_var_type("int");
			}

    }
     ;             
unary_expression : ADDOP unary_expression
    {
      //if $3 is void type function
      string fn = func_name($2->get_name());
      if(check_func(fn)){
        func_ f = get_func(fn);
        if(f.ret_type=="void"){
          error_count++;
          fprintf(error , "Line %d: Void function used in expression\n",line_count);        }
      }

      fprintf(log_,"unary_expression : ADDOP unary_expression\n");

			$$ = new SymbolInfo($1->get_name()+$2->get_name(),"unary_expression");

      $$->set_var_type($2->get_var_type());
      $$->set_id($2->get_id());

    }
		 | NOT unary_expression
    {
      fprintf(log_,"unary_expression : NOT unary_expression\n");


      $$ = new SymbolInfo("!"+$2->get_name(),"unary_expression");

      $$->set_var_type($2->get_var_type());
      $$->set_id($2->get_id());

    }
		 | factor
     {
       $$ = $1;
       fprintf(log_,"unary_expression :	factor\n");       
     }

		 ;
factor	: variable
    {
      fprintf(log_,"factor : variable\n");
      $$ = $1;
      ///pass arrayname if array otherwise pass varname only
      ///suppose $1->get_name() is a[2].Now modified_name returns only a
      string varname;
      varname = array_name($1->get_name());
      SymbolInfo *x=table.Lookup(varname);
			if(!x){
        error_count++;
        fprintf(error,"Line %d: Undeclared variable %s\n",line_count,varname.c_str());
              }
      else{

          //setting type of var(int/float) and identity(array/normal variable)
  				$$->set_var_type(x->get_var_type());
          $$->set_id(x->get_id());
          //chk if array
          for(int i=0;i<var_list.size();i++){
            if(var_list[i].name==x->get_name() && var_list[i].size>0){
              //now we're sure that it's an array
              //let's see if ara is being used without any index
              if(varname==$1->get_name()){
                error_count++;
                fprintf(error,"Line %d:Type Mismatch, %s is an array\n",line_count,varname.c_str());
                $$->set_param_error_state(true);
                break;
              }
              //now chk if wrong index is given
              else if(!array_index_checker($1->get_name() , var_list[i].size)){
                error_count++;
                fprintf(error,"Line: %d Wrong array index\n",line_count);
                break;
              }
            }
          }
      }

    }
	  | ID LPAREN argument_list RPAREN
    {

      $$ = new SymbolInfo($1->get_name()+"("+$3->get_name()+")" , "factor");
      fprintf(log_,"factor : ID LPAREN argument_list RPAREN\n");
      $$->set_func_state(true);

      //semantic
      //chk if id is in func_list
      if(!check_func($1->get_name())){
        error_count++;
        fprintf(error , "Error at line: %d Undeclared Function %s\n",line_count,$1->get_name().c_str());
              }
      else{
        func_ f = get_func($1->get_name());
        //chk args consistency
        bool matched = true;
        bool already_error_in_arg = false;
        if(f.parametres.size() != $3->argument_list.size())matched = false;
        else{
          for(int i=0;i<f.parametres.size();i++){
            if($3->argument_list[i].error_state){
              already_error_in_arg = true;
              break;
            }
            //cout<<f.f_name<<" "<<$3->arg_list[i].name<<" "<<$3->arg_list[i].sz<<endl;
            if($3->argument_list[i].size>0){
              if($3->get_name()==array_name($3->get_name())){
                matched = false;
                break;
              }
            }
            if(f.parametres[i].first != $3->argument_list[i].type){
              matched = false;
              break;
            }
          }
        }
        //cout<<$1->get_name()<<" "<<already_error_in_arg<<endl;
        if(!matched && !already_error_in_arg){
          //
          error_count++;
          fprintf(error , "Line %d: Total number of arguments mismatch in function %s\n",line_count,$1->get_name().c_str());
        }
      }

    }
	| LPAREN expression RPAREN
    {
      $$ = new SymbolInfo("("+$2->get_name()+")" , "factor");
      fprintf(log_,"factor : LPAREN expression RPAREN\n");

      $$->set_var_type($2->get_var_type());

    }
	| CONST_INT
    {
      fprintf(log_,"factor : CONST_INT\n");
			$$=$1;
			$$->set_var_type("int");
      

    }
	| CONST_FLOAT
    {
      fprintf(log_,"factor : CONST_FLOAT\n");
			$$=$1;
			$$->set_var_type("float");

    }
	| variable INCOP
    {
      fprintf(log_,"factor	: variable INCOP\n");
      $$ = new SymbolInfo($1->get_name()+"++","factor");

      SymbolInfo *x=table.Lookup(array_name($1->get_name()));
			if(!x){
        error_count++;
        fprintf(error,"Line %d: Undeclared variable %s\n",line_count,$1->get_name().c_str());
              }
      else{

         $$->set_var_type($1->get_var_type());
         $$->set_id($1->get_id());
      }

    }
	| variable DECOP
    {
      fprintf(log_,"factor	: variable DECOP\n");
      $$ = new SymbolInfo($1->get_name()+"--","factor");

      SymbolInfo *x=table.Lookup(array_name($1->get_name()));
			if(!x){
        error_count++;
        fprintf(error,"Line %d: Undeclared variable %s\n",line_count,$1->get_name().c_str());      }
      else{

         $$->set_var_type($1->get_var_type());
         $$->set_id($1->get_id());
      }
    }

	;   
argument_list : arguments
        {
          fprintf(log_,"argument_list : arguments\n");
    			$$=$1;
        }
			  |
        {
          $$ = new SymbolInfo("" , "argument_list");
        }
			  ;          
arguments : arguments COMMA logic_expression
        {
          $$ = new SymbolInfo($1->get_name()+" , "+$3->get_name() , "arguments");
          fprintf(log_,"arguments : arguments COMMA logic_expression\n");

          $$->argument_list = $1->argument_list;
          bool isara=false;
          for(int i=0;i<var_list.size();i++){
            if($3->get_name()==var_list[i].name && var_list[i].size>0){
                isara = true;
                if($3->get_param_error_state()){
                  $$->push_argument($3->get_name() , $3->get_var_type() , var_list[i].size,true);break;
                }
                else $$->push_argument($3->get_name() , $3->get_var_type() , var_list[i].size,false);break;
            }
          }
          if(!isara){
            $$->push_argument($3->get_name() , $3->get_var_type() , 0,false);
          }

        }
	      | logic_expression
        {
          fprintf(log_,"arguments : logic_expression\n");
    			$$=$1;
          bool isara=false;
          for(int i=0;i<var_list.size();i++){
            if($1->get_name()==var_list[i].name && var_list[i].size>0){
              isara = true;
              if($1->get_param_error_state()){
                $$->push_argument($1->get_name() , $1->get_var_type() , var_list[i].size,true);break;
              }
              else $$->push_argument($1->get_name() , $1->get_var_type() , var_list[i].size,false);break;
            }
          }
          if(!isara){
            $$->push_argument($1->get_name() , $1->get_var_type() , 0,false);
          }
        }

	      ;
%%
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
	fprintf(error,"Total Errors: %d \n",error_count);

	fclose(fp);
	fclose(log_);
	fclose(error);

	return 0;
}          










      
