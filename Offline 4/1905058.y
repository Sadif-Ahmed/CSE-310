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
extern FILE *parse;
//ICG Components
FILE *tempasmCode,*asmCode,*optimized_asmCode;
SymbolTable table(11);
vector<pair<string,string>> variableList_to_be_Initialized;
string assembly_codes;

extern int line_count;
extern int error_count;

string var_type;
string curr_ret_type;
//Unit of list of variables
struct var_
{
    string name;
    int size; //set -1 for variables and corresponding size for arrays
} temp_var;
//Unit of list of functions
struct func_
{
    string name;
    vector<pair<string,string>> parametres;
    string ret_type;
    int return_reg_no;
} temp_func;

vector<var_> var_list; // For identifier(variable, array) insertion into symboltable and error checking
vector<func_> func_list; //For function related error checking 
//Function list insertion with parametres
void func_insert(string name , vector<func_param>& params , string ret_type, int return_reg_number){
    temp_func.name = name;
    temp_func.ret_type = ret_type;
    temp_func.return_reg_no = return_reg_number;
    for(int i=0;i<params.size();i++){
        temp_func.parametres.push_back(make_pair(params[i].type , params[i].name));
    }
    func_list.push_back(temp_func);
    temp_func.parametres.clear();
}
//Function list insertion without parametres
void func_insert(string name , string ret_type){
    temp_func.name = name;
    temp_func.ret_type = ret_type;
    func_list.push_back(temp_func);
}
//Checking if new function is already in list of functions
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
//Changing string to integer
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
//Extracting array name from a[]
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
//Extracting function name for foo()
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
int get_index(string str)
{
  //str is a[2]
  //we need to return 2
  string idx="";
  int i=0;
  while(str[i]!='[')i++;
  i++;
  while(str[i]!=']' and i<str.size())
  {
    idx+=str[i];i++;
  }
  stringstream geek(idx);
  int x = 0;
  geek >> x;
  return x;
}
//Checking if array index(integer) is valid or not.a[4] calling in size 5 array 'a'
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

int labelcnt=1,tempcnt=1,stack_offset=0;

string print_function(){
    string func=";------printing procedure----\n";
 		func+="PRINT_ID PROC\n\n";
 		func+="\t;SAVE IN STACK\n";
 		func+="\tPUSH AX\n";
 		func+="\tPUSH BX\n";
 		func+="\tPUSH CX\n";
 		func+="\tPUSH DX\n\n";

 		func+="\t;CHECK IF NEGATIVE\n";
 		func+="\tOR AX, AX\n";
 		func+="\tJGE PRINT_NUMBER\n\n";
 		func+="\t;PRINT MINUS SIGN\n";
 		func+="\tPUSH AX\n";
 		func+="\tMOV AH, 2\n";
 		func+="\tMOV DL, '-'\n";
 		func+="\tINT 21H\n";
 		func+="\tPOP AX\n\n";
 		func+="\tNEG AX\n\n";
 		func+="\tPRINT_NUMBER:\n";
 		func+="\tXOR CX, CX\n";
 		func+="\tMOV BX, 10D\n\n";
 		func+="\tREPEAT_CALC:\n\n";
 		func+="\t\t;AX:DX- QUOTIENT:REMAINDER\n";
 		func+="\t\tXOR DX, DX\n";
 		func+="\t\tDIV BX  ;DIVIDE BY 10\n";
 		func+="\t\tPUSH DX ;PUSH THE REMAINDER IN STACK\n\n";
 		func+="\t\tINC CX\n\n";
 		func+="\t\tOR AX, AX\n";
 		func+="\t\tJNZ REPEAT_CALC\n\n";

 		func+="\tMOV AH, 2\n\n";
 		func+="\tPRINT_LOOP:\n";
 		func+="\t\tPOP DX\n";
 		func+="\t\tADD DL, 30H\n";
 		func+="\t\tINT 21H\n";
 		func+="\t\tLOOP PRINT_LOOP\n";

 		func+="\n\t;NEWLINE\n";
 		func+="\tMOV AH, 2\n";
 		func+="\tMOV DL, 0AH\n";
 		func+="\tINT 21H\n";
 		func+="\tMOV DL, 0DH\n";
 		func+="\tINT 21H\n\n";

 		func+="\tPOP DX\n";
 		func+="\tPOP CX\n";
 		func+="\tPOP BX\n";
 		func+="\tPOP AX\n\n";
 		func+="\tRET\n";
 		func+="PRINT_ID ENDP\n\n";

    return func;
}
string pushCode(){
  return "\tPUSH AX\n\tPUSH BX\n\tPUSH CX\n\tPUSH DX\n";
}

string popCode(){
    return "\tPOP DX\n\tPOP CX\n\tPOP BX\n\tPOP AX\n";
}

string main_proc_start_code(){
  return "\t;INITIALIZE DATA SEGMENT\n\tMOV AX, @DATA\n\tMOV DS, AX\n\n";
}

string main_proc_ending_code(){
  return "\n\tMOV AX, 4CH\n\tINT 21H\nMAIN ENDP\n\nEND MAIN";
}
//following 2 methos are helper function.get_first_index returns the first position of the forbidden part
//of proc_code.get_last_Index returns the neding position of forbidden part.We then generate a valid new_proc_code
//inside the modify_proc method and return it.
int get_first_index(string str, string s)
{
    
    for (int i = 0; i < str.length(); i++) {
        if (str.substr(i, s.length()) == s) {
            return i+s.length();
        }
    }
}
int get_last_Index(string str, string s)
{

    
    for (int i = 0; i < str.length(); i++) {
        if (str.substr(i, s.length()) == s) {
            return i;
        }
    }
}
//removes anything from the procedure body if written after return statement
string modify_proc(string fnm , string proc_code)
{
  func_ f = get_func(fnm);
  string ret_reg = "T" + to_string(f.return_reg_no);
  int start_idx = get_first_index(proc_code , "MOV "+ret_reg+", AX");
  int end_idx = get_last_Index(proc_code , "POP DX");
  if(start_idx==0)return proc_code;//no return statement
  string new_proc_code="";
  for(int i=0;i<proc_code.length();i++){
    if(i<=start_idx || i>=end_idx-2){
      new_proc_code+=proc_code[i];
    }
  }
  return new_proc_code;
}
///return true for cases:
///s1 := MOV AX, a1
///s2 := MOV a1, AX
bool check_if_equivalent_command(string s1 , string s2)
{
  int len1 = s1.size();
  int len2 = s2.size();

  int i=0;
  //getting the first M from s1 cause s1 might contain \t at the beginning too.
  for(;i<len1;i++){
    if(s1[i]=='M')break;
  }
  if(i==len1)return false;
  if(s1.substr(i , 3)!="MOV")return false;
  int i1 = i;

  i=0;
  for(;i<len2;i++){
    if(s2[i]=='M')break;
  }
  if(i==len2)return false;
  if(s2.substr(i , 3)!="MOV")return false;
  int i2 = i;

  string src1="",dest1="",src2="",dest2="";

  dest1 = s1.substr(i1+4 , 2);
  src1 = s1.substr(i1+8 , 2);

  dest2 = s2.substr(i2+4 , 2);
  src2 = s2.substr(i2+8 , 2);

  //cout<<src1<<" "<<dest1<<" "<<src2<<" "<<dest2<<endl;

  if(src1==dest2 and src2==dest1)return true;
  else return false;
}

string assembly_procs="";

bool doesnt_affect(string s1 , string s2){
  if(s2.size()<=1)return true;
  else if(s2[0]==';' or s2[1]==';')return true;
  else if(s2[1]=='I' and s2[2]=='N' and s2[3]=='C')return false;
  else if(s2[1]=='D' and s2[2]=='E' and s2[3]=='C')return false;


  else return false;

}
void optimize_code(FILE *basecode){
   optimized_asmCode=fopen("optimized_code.asm","w");
   char *line = NULL;
   size_t n = 0;
   ssize_t if_read;
	 vector<string>v;
   while ((if_read = getline(&line, &n, basecode)) != -1) {
     v.push_back(string(line));
   }
   int sz = v.size();
   int to_be_removed[sz];
   for(int i=0;i<sz;i++){
     to_be_removed[i] = 0;
   }

   for(int i=0;i<sz-3;i++){
     if(check_if_equivalent_command(v[i] ,v[i+1])){
       to_be_removed[i+1] = 1;
     }
     else if (doesnt_affect(v[i] , v[i+1])){


       if(check_if_equivalent_command(v[i] ,v[i+2])){
         to_be_removed[i+2] = 1;
       }
       else if(check_if_equivalent_command(v[i] ,v[i+3])){
         to_be_removed[i+3] = 1;
       }
     }

   }

   for(int i=0;i<sz;i++){
     if(to_be_removed[i]==0){
       fprintf(optimized_asmCode , "%s" , v[i].c_str());
     }
   }
   fclose(optimized_asmCode);
}


%}

%union {
    SymbolInfo *symbol;
}

%token<symbol> IF ELSE FOR WHILE DO BREAK INT CHAR FLOAT DOUBLE
%token<symbol> VOID RETURN SWITCH CASE DEFAULT CONTINUE
%token<symbol> ASSIGNOP INCOP DECOP NOT LPAREN RPAREN LCURL RCURL LSQUARE RSQUARE COMMA SEMICOLON PRINTLN BITOP

%token<symbol>CONST_INT
%token<symbol>CONST_FLOAT
%token<symbol>CONST_CHAR
%token<symbol>ID
%token<symbol>ADDOP
%token<symbol>MULOP
%token<symbol>RELOP
%token<symbol>LOGICOP

%type<symbol>start compound_statement type_specifier parameter_list declaration_list var_declaration unit func_declaration statement statements variable expression factor arguments argument_list expression_statement unary_expression simple_expression logic_expression rel_expression term func_definition program
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%
//In Each Action initialize $$ then set parse tree attributes
//Then do action
start : program
	{
		//write your code in this block in all the similar blocks below
        fprintf(log_,"start : program\n");
        $$=new SymbolInfo("start","ROOT");
        $$->set_print("start : program");
        $$->add_child($1);
        $$->set_start($1->get_start());
        $$->set_end($1->get_end());
        $$->print_tree($$,0,parse);
        $$->delete_tree($$);
	}
	;

program : program unit
	{
		fprintf(log_,"program : program unit\n");
		$$ = new SymbolInfo((string)$1->get_name()+(string)$2->get_name(), "NON_TERMINAL");
    $$->set_print("program : program unit");
    $$->add_child($1);
    $$->add_child($2);
    $$->set_start($1->get_start());
    $$->set_end($2->get_end());
	}
	| unit
	{
		fprintf(log_,"program : unit\n");
		$$ = new SymbolInfo($1->get_name()+"\n", "NON_TERMINAL");
    $$->set_print("program : unit");
    $$->add_child($1);
    $$->set_start($1->get_start());
    $$->set_end($1->get_end());
	}
	;
unit : var_declaration
	{
		fprintf(log_,"unit : var_declaration\n");
		$$ = new SymbolInfo($1->get_name(), "NON_TERMINAL");
    $$->set_print("unit : var_declaration");
    $$->add_child($1);
    $$->set_start($1->get_start());
    $$->set_end($1->get_end());
	}
     | func_declaration
	{
		fprintf(log_,"unit : func_declaration\n");
		$$ = new SymbolInfo($1->get_name(), "NON_TERMINAL");
    $$->set_print("unit : func_declaration");
    $$->add_child($1);
    $$->set_start($1->get_start());
    $$->set_end($1->get_end());
	}
     | func_definition
	{
        fprintf(log_,"unit : func_definition\n");
		$$ = new SymbolInfo($1->get_name(), "NON_TERMINAL");
    $$->set_print("unit : func_definition");
    $$->add_child($1);
    $$->set_start($1->get_start());
    $$->set_end($1->get_end());
	}
     ;
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON
	{
    $$ = new SymbolInfo($1->get_name()+" "+$2->get_name()+"("+$4->get_name()+");", "NON_TERMINAL");
    fprintf(log_ , "func_declaration: type_specifier ID LPAREN parameter_list RPAREN SEMICOLON\n");
    $$->set_print("func_declaration: type_specifier ID LPAREN parameter_list RPAREN SEMICOLON");
    $$->add_child($1);
    $$->add_child($2);
    $$->add_child($3);
    $$->add_child($4);
    $$->add_child($5);
    $$->add_child($6);
    $$->set_start($1->get_start());
    $$->set_end($6->get_end());


    /* Checking whether function is already declared or not */
    SymbolInfo* temp = table.Lookup_current_scope($2->get_name());
    if(temp != NULL) {
			error_count++;
			fprintf(error , "Line# %d: Multiple declaration of '%s'\n" , line_count , $2->get_name().c_str());
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
    $$->set_print("func_declaration: type_specifier ID LPAREN RPAREN SEMICOLON");
    $$->add_child($1);
    $$->add_child($2);
    $$->add_child($3);
    $$->add_child($4);
    $$->add_child($5);
    $$->set_start($1->get_start());
    $$->set_end($5->get_end());
		
        /*Checking whether function is  already declared or not */
		SymbolInfo* temp = table.Lookup_current_scope($2->get_name());
		if(temp != NULL) {
			error_count++;
			fprintf(error , "Line# %d: Multiple declaration of '%s'\n" , line_count , $2->get_name().c_str());
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
    //Checking Valadity of Parametres
    if($4->get_name()=="int" or $4->get_name()=="float"){
      error_count++;
      fprintf(error , "Line# %d: 1st parameter's name not given in function definition of '%s'\n" , line_count, $2->get_name().c_str());
    }
    //Checking if function was declared previously and now being defined
    //parameter types,return type must be matched
    //assuming we don't need to handle function overloading
    if(check_func($2->get_name())){
      func_ f = get_func($2->get_name());
      if(f.ret_type != $1->get_name()){
        error_count++;
        fprintf(error , "Line# %d: Conflicting types for '%s'\n",line_count,$2->get_name().c_str());
      }
      else {
        bool matched = true;
        int n = $4->param_list.size();
        if(n == f.parametres.size()){
          for(int i=0;i<f.parametres.size();i++){
            if(f.parametres[i].first != $4->param_list[i].type){
          error_count++;
          fprintf(error , "Line# %d: Type mismatch for argument %d of '%s'\n",line_count ,i+1,$2->get_name().c_str());
            }
          }
        }
        else
        {
          error_count++;
          fprintf(error , "Line# %d: Conflicting types for '%s'\n",line_count , $2->get_name().c_str());
          
        }
        
      }
    }


    /* checking whether already defined or not */
		SymbolInfo* temp = table.Lookup_current_scope($2->get_name());
		if(temp != NULL and (!temp->get_func_decl_state())) {
			error_count++;
			fprintf(error , "Line# %d: '%s' redeclared as different kind of symbol\n" , line_count , $2->get_name().c_str());
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
          fprintf(error,"Line# %d: Redefinition of parameter '%s'\n",line_count,name.c_str());
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
    $$->set_print("func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement");
    $$->add_child($1);
    $$->add_child($2);
    $$->add_child($3);
    $$->add_child($4);
    $$->add_child($5);
    $$->add_child($7);
    $$->set_start($1->get_start());
    $$->set_end($7->get_end());

  }  
  | type_specifier ID LPAREN RPAREN
    {
      curr_ret_type = $1->get_name();
      /* checking whether already declared or not */
  		SymbolInfo* temp = table.Lookup_current_scope($2->get_name());
      if(temp != NULL and (!temp->get_func_decl_state())) {
  			error_count++;
  			fprintf(error , "Line# %d: Multiple declaration of '%s'\n" , line_count , $2->get_name().c_str());
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
    $$->set_print("func_definition : type_specifier ID LPAREN RPAREN compound_statement");
    $$->add_child($1);
    $$->add_child($2);
    $$->add_child($3);
    $$->add_child($4);
    $$->add_child($6);
    $$->set_start($1->get_start());
    $$->set_end($6->get_end());
	}
	 	;
parameter_list  : parameter_list COMMA type_specifier ID
		{
			$$ = new SymbolInfo($1->get_name()+","+$3->get_name()+" "+$4->get_name(), "NON_TERMINAL");
			fprintf(log_,"parameter_list : parameter_list COMMA type_specifier ID\n");
      $$->set_print("parameter_list : parameter_list COMMA type_specifier ID");
    $$->add_child($1);
    $$->add_child($2);
    $$->add_child($3);
    $$->add_child($4);
    $$->set_start($1->get_start());
    $$->set_end($4->get_end());
			/* adding parameter to parameter list */
      $$->param_list = $1->param_list;
			$$->push_param($4->get_name() , $3->get_name());

      if($3->get_type()=="void"){
        error_count++;
        fprintf(error,"Line# %d: Variable or field '%s'  declared void\n",line_count,$3->get_name().c_str());
        }
		}
		| parameter_list COMMA type_specifier
		{
			$$ = new SymbolInfo($1->get_name()+","+$3->get_name(), "NON_TERMINAL");
			fprintf(log_,"parameter_list  : parameter_list COMMA type_specifier\n");
      $$->set_print("parameter_list  : parameter_list COMMA type_specifier");
    $$->add_child($1);
    $$->add_child($2);
    $$->add_child($3);
    $$->set_start($1->get_start());
    $$->set_end($3->get_end());
			/* adding parameter to parameter list */
      $$->param_list = $1->param_list;
			$$->push_param("", $3->get_name());
		}
 		| type_specifier ID
		{
			$$ = new SymbolInfo($1->get_name()+" "+$2->get_name(), "NON_TERMINAL");
			fprintf(log_,"parameter_list  : type_specifier ID\n");
      $$->set_print("parameter_list  : type_specifier ID");
    $$->add_child($1);
    $$->add_child($2);
    $$->set_start($1->get_start());
    $$->set_end($2->get_end());
			/* adding parameter to parameter list */
      if($1->get_name()=="void"){
        error_count++;
				fprintf(error,"Line# %d: Variable or field '%s' declared void\n",line_count,$2->get_name().c_str());
      }
			$$->push_param($2->get_name() ,$1->get_name());

      
		}
		| type_specifier
		{
			$$ = new SymbolInfo($1->get_name(), "NON_TERMINAL");
			fprintf(log_,"parameter_list  : type_specifier\n");
      $$->set_print("parameter_list  : type_specifier");
    $$->add_child($1);
    $$->set_start($1->get_start());
    $$->set_end($1->get_end());
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
      $$->set_print("compound_statement : LCURL statements RCURL");
    $$->add_child($1);
    $$->add_child($2);
    $$->add_child($3);
    $$->set_start($1->get_start());
    $$->set_end($3->get_end());
      table.printall(log_);
  }
 		    | LCURL RCURL
  {
    $$ = new SymbolInfo("{\n}", "NON_TERMINAL");
    fprintf(log_,"compound_statement : LCURL RCURL\n");
    $$->set_print("compound_statement : LCURL statements RCURL");
    $$->add_child($1);
    $$->add_child($2);
    $$->set_start($1->get_start());
    $$->set_end($2->get_end());
    table.printall(log_);
  }
 		    ;
var_declaration : type_specifier declaration_list SEMICOLON
		{
			fprintf(log_,"var_declaration : type_specifier declaration_list SEMICOLON\n");
			$$ = new SymbolInfo($1->get_name()+" "+$2->get_name()+";", "NON_TERMINAL");
          $$->set_print("var_declaration : type_specifier declaration_list SEMICOLON");
    $$->add_child($1);
    $$->add_child($2);
    $$->add_child($3);
    $$->set_start($1->get_start());
    $$->set_end($3->get_end());

      $$->set_var_type($1->get_name());

      //setting type of all elements of var in declaration_list
      for(int i=0;i<$2->var_list.size();i++){
          $2->var_list[i].type = $1->get_name();
      }
			/* inserting in symboltable */
			if($1->get_name()=="void"){
				error_count++;
				fprintf(error,"Line# %d: Variable or field '%s' declared void\n",line_count,$2->get_name().c_str());

			}
			else{
				/* checking whether already declared or not */
				for(int i=0;i<$2->var_list.size();i++){
					SymbolInfo* temp = table.Lookup_current_scope($2->var_list[i].name);
					if(temp != NULL) {
            if(temp->get_var_type()==$2->var_list[i].type)
            {
              error_count++;
              fprintf(error , "Line# %d: Warning Multiple declaration of '%s'\n" , line_count , $2->var_list[i].name.c_str());
            }
            else
            {
						error_count++;
						fprintf(error , "Line# %d: Conflicting types for'%s'\n" , line_count , $2->var_list[i].name.c_str());
            }
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
      $$->set_print("type_specifier : INT");
    $$->add_child($1);
    $$->set_start($1->get_start());
    $$->set_end($1->get_end());
			
		}
 		| FLOAT
		{
			fprintf(log_,"type_specifier : FLOAT \n");
			var_type = "float";

			SymbolInfo *x = new SymbolInfo("float" , "float");
			$$ = x;
       $$->set_print("type_specifier : FLOAT");
    $$->add_child($1);
    $$->set_start($1->get_start());
    $$->set_end($1->get_end());
			
		}
 		| VOID
 		{
			fprintf(log_,"type_specifier : VOID \n");
			var_type = "void";

			SymbolInfo *x = new SymbolInfo("void" , "void");
			$$ = x;
      $$->set_print("type_specifier : VOID");
    $$->add_child($1);
    $$->set_start($1->get_start());
    $$->set_end($1->get_end());
			
		}
		 ;  
declaration_list : declaration_list COMMA ID
		{
			fprintf(log_,"declaration_list : declaration_list COMMA ID\n");
			$$ = new SymbolInfo((string)$1->get_name()+(string)","+(string)$3->get_name(), "NON_TERMINAL");
       $$->set_print("declaration_list : declaration_list COMMA ID");
    $$->add_child($1);
    $$->add_child($2);
    $$->add_child($3);
    $$->set_start($1->get_start());
    $$->set_end($3->get_end());
			
			/* keeping track of identifier(variable) */
      temp_var.name = $3->get_name();
      temp_var.size = -1;
      var_list.push_back(temp_var);

      /* 3 arguments are name , type, size of variable */
      $$->var_list = $1->var_list;
      $$->push_var($3->get_name() , "" , 0);

		}
 		  | declaration_list COMMA ID LSQUARE CONST_INT RSQUARE
		{
			fprintf(log_,"declaration_list : declaration_list COMMA ID LSQUARE CONST_INT RSQUARE\n");
			$$ = new SymbolInfo((string)$1->get_name()+(string)","+(string)$3->get_name()+(string)"["+(string)$5->get_name()+(string)"]", "NON_TERMINAL");
			 $$->set_print("declaration_list : declaration_list COMMA ID LSQUARE CONST_INT RSQUARE");
    $$->add_child($1);
    $$->add_child($2);
    $$->add_child($3);
    $$->add_child($4);
    $$->add_child($5);
    $$->add_child($6);
    $$->set_start($1->get_start());
    $$->set_end($6->get_end());
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
    $$->set_print("declaration_list : ID");
    $$->add_child($1);
    $$->set_start($1->get_start());
    $$->set_end($1->get_end());
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
      $$->set_print("declaration_list: ID LSQUARE CONST_INT RSQUARE");
    $$->add_child($1);
    $$->add_child($2);
    $$->add_child($3);
    $$->add_child($4);
    $$->set_start($1->get_start());
    $$->set_end($4->get_end());
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
       $$=new SymbolInfo($1->get_name(),"NON-TERMINAL");
      $$->make_copy($1);
       fprintf(log_ , "statements : statement\n");
       $$->clear_children();
    $$->set_print("statements : statement");
    $$->add_child($1);
    $$->set_start($1->get_start());
    $$->set_end($1->get_end());

    }
	   | statements statement
    {
      $$ = new SymbolInfo($1->get_name()+$2->get_name() , "NON_TERMINAL");
      fprintf(log_ , "statements : statements statement\n");
      $$->set_print("statements : statements statement");
    $$->add_child($1);
    $$->add_child($2);
    $$->set_start($1->get_start());
    $$->set_end($2->get_end());


    }
	   ;   
statement : var_declaration
    {
      fprintf(log_,"statement : var_declaration\n");
		$1->set_name($1->get_name()+"\n");
  		$$=new SymbolInfo($1->get_name(),"NON-TERMINAL");
      $$->make_copy($1);
      $$->clear_children();
      $$->set_print("statement : var_declaration");
    $$->add_child($1);
    $$->set_start($1->get_start());
    $$->set_end($1->get_end());
    }
	  | expression_statement
    {
      fprintf(log_,"statement : expression_statement\n");
		$1->set_name($1->get_name()+"\n");
		$$=new SymbolInfo($1->get_name(),"NON-TERMINAL");
      $$->make_copy($1);;
    $$->clear_children();
    $$->set_print("statement : expression_statement");
    $$->add_child($1);
    $$->set_start($1->get_start());
    $$->set_end($1->get_end());
    }
	  | compound_statement
    {
      fprintf(log_,"statement : compound_statement\n");
      $$=new SymbolInfo($1->get_name(),"NON-TERMINAL");
      $$->make_copy($1);;
      $$->clear_children();
      $$->set_print("statement : compound_statement");
    $$->add_child($1);
    $$->set_start($1->get_start());
    $$->set_end($1->get_end());
    }
	  | FOR LPAREN expression_statement expression_statement expression RPAREN statement
    {
      string str="for("+$3->get_name()+$4->get_name()+$5->get_name()+")"+$7->get_name();
      $$ = new SymbolInfo(str , "NON_TERMINAL");
      fprintf(log_,"statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement\n");
    $$->set_print("statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement");
    $$->add_child($1);
    $$->add_child($2);
    $$->add_child($3);
    $$->add_child($4);
    $$->add_child($5);
    $$->add_child($6);
    $$->add_child($7);
    $$->set_start($1->get_start());
    $$->set_end($7->get_end());
    }
	  | IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE
    {
      string str = "if("+$3->get_name()+")"+$5->get_name();
      $$ = new SymbolInfo(str , "statement");
      fprintf(log_,"statement : IF LPAREN expression RPAREN statement\n");
      $$->set_print("statement : IF LPAREN expression RPAREN statement");
    $$->add_child($1);
    $$->add_child($2);
    $$->add_child($3);
    $$->add_child($4);
    $$->add_child($5);
    $$->set_start($1->get_start());
    $$->set_end($5->get_end());
      

    }
	  | IF LPAREN expression RPAREN statement ELSE statement
    {
      string str = "if("+$3->get_name()+")"+$5->get_name()+"else"+$7->get_name();
      $$ = new SymbolInfo(str , "statement");
      fprintf(log_,"statement : IF LPAREN expression RPAREN statement ELSE statement\n");
      $$->set_print("statement : IF LPAREN expression RPAREN statement ELSE statement");
    $$->add_child($1);
    $$->add_child($2);
    $$->add_child($3);
    $$->add_child($4);
    $$->add_child($5);
    $$->add_child($6);
    $$->add_child($7);
    $$->set_start($1->get_start());
    $$->set_end($7->get_end());
    

    }
	  | WHILE LPAREN expression RPAREN statement
    {
      string str = "while("+$3->get_name()+")"+$5->get_name();
      $$ = new SymbolInfo(str , "statement");
      fprintf(log_,"statement : WHILE LPAREN expression RPAREN statement\n");
      $$->set_print("statement : WHILE LPAREN expression RPAREN statement");
    $$->add_child($1);
    $$->add_child($2);
    $$->add_child($3);
    $$->add_child($4);
    $$->add_child($5);
    $$->set_start($1->get_start());
    $$->set_end($5->get_end());
    
    }
	  | PRINTLN LPAREN ID RPAREN SEMICOLON
    {
      $$ = new SymbolInfo("printf("+$3->get_name()+");" , "statement");
      fprintf(log_,"statement : PRINTLN LPAREN ID RPAREN SEMICOLON\n");
      $$->set_print("statement : PRINTLN LPAREN ID RPAREN SEMICOLON");
    $$->add_child($1);
    $$->add_child($2);
    $$->add_child($3);
    $$->add_child($4);
    $$->add_child($5);
    $$->set_start($1->get_start());
    $$->set_end($5->get_end());
      if($3->get_func_state()){
        if(!table.Lookup_current_scope(func_name($3->get_name()))){
          error_count++;
          fprintf(error , "Line# %d:  Undeclared function '%s'\n" , line_count,func_name($3->get_name()).c_str());
            }
      }

      else if(!table.Lookup_current_scope($3->get_name())){
        error_count++;
        fprintf(error , "Line# %d: Undeclared variable '%s'\n" , line_count,$3->get_name().c_str());
      }
    }
	  | RETURN expression SEMICOLON
    {
      $$ = new SymbolInfo("return "+$2->get_name()+";" , "statement");
      fprintf(log_,"statement : RETURN expression SEMICOLON\n");
      $$->set_print("statement : RETURN expression SEMICOLON");
    $$->add_child($1);
    $$->add_child($2);
    $$->add_child($3);
    $$->set_start($1->get_start());
    $$->set_end($3->get_end());

      
    }
	  ;
expression_statement 	: SEMICOLON
    {
      $$ = new SymbolInfo(";" , "expression_statement");
      fprintf(log_,"expression_statement : SEMICOLON\n");
       $$->set_print("expression_statement : SEMICOLON");
    $$->add_child($1);
    $$->set_start($1->get_start());
    $$->set_end($1->get_end());
    }
			| expression SEMICOLON
    {
      $$ = new SymbolInfo($1->get_name()+";" , "expression_statement");
      fprintf(log_,"expression_statement : expression SEMICOLON\n");
       $$->set_print("expression_statement : expression SEMICOLON");
    $$->add_child($1);
    $$->add_child($2);
    $$->set_start($1->get_start());
    $$->set_end($2->get_end());
    

    }
    | expression error
    {
      yyclearin;
    }
			;
variable : ID
    {
      fprintf(log_,"variable : ID\n");
		$$=new SymbolInfo($1->get_name(),"TERMINAL");
      $$->make_copy($1);
    $$->clear_children();
    $$->set_print("variable : ID");
    $$->add_child($1);
    $$->set_start($1->get_start());
    $$->set_end($1->get_end());

      //Semantic : check if variable is declared before


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
     $$->set_print("variable : ID LSQUARE expression RSQUARE");
    $$->add_child($1);
    $$->add_child($2);
    $$->add_child($3);
    $$->add_child($4);
    $$->set_start($1->get_start());
    $$->set_end($4->get_end());
     $$->set_id("array");
     //array index must be integer

   }

	 ;       
expression : logic_expression
    {
      $$=new SymbolInfo($1->get_name(),"NON-TERMINAL");
      $$->make_copy($1);
      $$->clear_children();
      fprintf(log_,"expression : logic_expression\n");
      $$->set_print("expression : logic_expression");
    $$->add_child($1);
    $$->set_start($1->get_start());
    $$->set_end($1->get_end());
    }
	   | variable ASSIGNOP logic_expression
    {
      $$ = new SymbolInfo($1->get_name()+"="+$3->get_name() , "expression");
      fprintf(log_,"expression : variable ASSIGNOP logic_expression\n");
      $$->set_print("expression : variable ASSIGNOP logic_expression");
    $$->add_child($1);
    $$->add_child($2);
    $$->add_child($3);
    $$->set_start($1->get_start());
    $$->set_end($3->get_end());

      //semantics
      //todo
      //assign $3's variable_type to $1 after some error checkings
      //pass arrayname if array otherwise pass varname only
      //suppose $1->get_name() is a[2].Now array_name returns only a
      string varname;
      varname = array_name($1->get_name());
      SymbolInfo *x=table.Lookup(varname);
			if(x)
			{
				//setting type of var(int/float)
        $1->set_var_type(x->get_var_type());

        //check if variable and written with index
        bool isvar=true;
        for(int i=0;i<var_list.size();i++){
          if(var_list[i].name==x->get_name() && var_list[i].size>0){
            isvar = false;break;
         }
        }
        if(isvar){
          if(varname != $1->get_name()){
            error_count++;
            fprintf(error , "Line# %d: '%s' is not an array\n" , line_count,varname.c_str());
          }
        }
        //check if array
        for(int i=0;i<var_list.size();i++){
          if(var_list[i].name==x->get_name() && var_list[i].size>0){
            //now we're sure that it's an array
            //let's see if array is being used without any index
            if(varname==$1->get_name()){
              error_count++;
              fprintf(error,"Line# %d: Type mismatch, '%s' is an array\n",line_count , varname.c_str());
              break;

            }
            //now check if wrong index is given

            else if(!array_index_checker($1->get_name() , var_list[i].size)){
              error_count++;
              fprintf(error,"Line# %d: Array subscript is not an integer\n",line_count);
              break;
            }
          }
        }

        //check if float is assigned to int
        if(x->get_var_type()=="int" && $3->get_var_type()=="float"){
					error_count++;
          $$->set_var_type("int");
					fprintf(error,"Line# %d: Warning: possible loss of data in assignment of FLOAT to INT\n",line_count,$3->get_var_type().c_str(),x->get_var_type().c_str());	}
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
          ///check if func is returning to valid type

          if(f.ret_type=="void"){
            error_count++;
            fprintf(error , "Line# %d: Void cannot be used in expression \n",line_count);
          }
          else if(f.ret_type != $1->get_var_type()){
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
	   ;
logic_expression : rel_expression
    {
      $$=new SymbolInfo($1->get_name(),"NON-TERMINAL");
      $$->make_copy($1);
      $$->clear_children();
      fprintf(log_,"logic_expression : rel_expression\n");
      $$->set_print("logic_expression : rel_expression");
    $$->add_child($1);
    $$->set_start($1->get_start());
    $$->set_end($1->get_end());

    }
		 | rel_expression LOGICOP rel_expression
    {
      $$ = new SymbolInfo($1->get_name()+$2->get_name()+$3->get_name() , "logic_expression");
      fprintf(log_,"logic_expression : rel_expression LOGICOP rel_expression\n");
      $$->set_print("logic_expression : rel_expression LOGICOP rel_expression");
    $$->add_child($1);
    $$->add_child($2);
    $$->add_child($3);
    $$->set_start($1->get_start());
    $$->set_end($3->get_end());
      
      /*semantic
      both $1 and $3 must be of type non void
      $$ must be set to type int
      */
      if($1->get_var_type()=="void" || $3->get_var_type()=="void"){
 				error_count++;
 				fprintf(error,"Line# %d: Type mismatch(Operands of '%s' can't be void)\n",line_count,$2->get_name().c_str());
        	}

       $$->set_var_type("int");
    }
		 ;
rel_expression	: simple_expression
   {
     $$=new SymbolInfo($1->get_name(),"NON-TERMINAL");
      $$->make_copy($1);
     $$->clear_children();
     fprintf(log_,"rel_expression	: simple_expression\n");
     $$->set_print("rel_expression	: simple_expression");
    $$->add_child($1);
    $$->set_start($1->get_start());
    $$->set_end($1->get_end());
     
   }
		| simple_expression RELOP simple_expression
   {
     $$ = new SymbolInfo($1->get_name()+$2->get_name()+$3->get_name() , "rel_expression");
     fprintf(log_,"rel_expression : simple_expression RELOP simple_expression\n");
     $$->set_print("rel_expression : simple_expression RELOP simple_expression");
    $$->add_child($1);
    $$->add_child($2);
    $$->add_child($3);
    $$->set_start($1->get_start());
    $$->set_end($3->get_end());

     /*semantic
     both $1 and $3 must be of type non void
     $$ must be set to type int
     */
     if($1->get_var_type()=="void" || $3->get_var_type()=="void"){
				error_count++;
				fprintf(error,"Line# %d : Type mismatch(Operands of '%s' can't be void)\n",line_count,$2->get_name().c_str());
			}
      $$->set_var_type("int");
   }
		;
simple_expression : term
  {
    $$=new SymbolInfo($1->get_name(),"NON-TERMINAL");
      $$->make_copy($1);
    $$->clear_children();
    fprintf(log_,"simple_expression : term\n");
    $$->set_print("simple_expression : term");
    $$->add_child($1);
    $$->set_start($1->get_start());
    $$->set_end($1->get_end());

  }
		  | simple_expression ADDOP term
  {
    $$ = new SymbolInfo($1->get_name()+$2->get_name()+$3->get_name() , "simple_expression");
    fprintf(log_,"simple_expression : simple_expression ADDOP term\n");
    $$->set_print("simple_expression : simple_expression ADDOP term");
    $$->add_child($1);
    $$->add_child($2);
    $$->add_child($3);
    $$->set_start($1->get_start());
    $$->set_end($3->get_end());

    if($1->get_var_type()=="float" || $3->get_var_type()=="float")
				$$->set_var_type("float");
			else
				$$->set_var_type("int");

  }
		  ;     
term :	unary_expression
    {
      $$=new SymbolInfo($1->get_name(),"NON-TERMINAL");
      $$->make_copy($1);
      $$->clear_children();
      fprintf(log_,"term :	unary_expression\n");
      $$->set_print("term :	unary_expression");
    $$->add_child($1);
    $$->set_start($1->get_start());
    $$->set_end($1->get_end());
    }
     |  term MULOP unary_expression
    {
      $$ = new SymbolInfo($1->get_name()+$2->get_name()+$3->get_name() , "term");
      fprintf(log_,"term : term MULOP unary_expression\n");
       $$->set_print("term : term MULOP unary_expression");
    $$->add_child($1);
    $$->add_child($2);
    $$->add_child($3);
    $$->set_start($1->get_start());
    $$->set_end($3->get_end());
      //if $3 is void type function
      string fn = func_name($3->get_name());
      if(check_func(fn)){
        func_ f = get_func(fn);
        if(f.ret_type=="void"){
          error_count++;
          fprintf(error , "Line# %d: Void cannot be used in expression \n",line_count);        }
      }
      //features of mod operation
      if($2->get_name()=="%" && ($1->get_var_type()!="int" || $3->get_var_type()!="int")){
				error_count++;
				fprintf(error,"Line# %d: Operands of modulus must be integers \n",line_count);
        	}
      //mod by zero
      else if($2->get_name()=="%" && $3->get_name()=="0"){
				error_count++;
				fprintf(error,"Line# %d: Warning: division by zero \n",line_count);

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
          fprintf(error , "Line# %d: Void cannot be used in expression \n",line_count);        }
      }

      fprintf(log_,"unary_expression : ADDOP unary_expression\n");

			$$ = new SymbolInfo($1->get_name()+$2->get_name(),"unary_expression");
      $$->set_print("unary_expression : ADDOP unary_expression");
    $$->add_child($1);
    $$->add_child($2);
    $$->set_start($1->get_start());
    $$->set_end($2->get_end());

      $$->set_var_type($2->get_var_type());
      $$->set_id($2->get_id());

    }
		 | NOT unary_expression
    {
      fprintf(log_,"unary_expression : NOT unary_expression\n");


      $$ = new SymbolInfo("!"+$2->get_name(),"unary_expression");
      $$->set_print("unary_expression : NOT unary_expression");
    $$->add_child($1);
    $$->add_child($2);
    $$->set_start($1->get_start());
    $$->set_end($2->get_end());

      $$->set_var_type($2->get_var_type());
      $$->set_id($2->get_id());

    }
		 | factor
     {
       $$=new SymbolInfo($1->get_name(),"NON-TERMINAL");
      $$->make_copy($1);
       $$->clear_children();
       fprintf(log_,"unary_expression :	factor\n");  
       $$->set_print("unary_expression :	factor");
    $$->add_child($1);
    $$->set_start($1->get_start());
    $$->set_end($1->get_end());     
     }

		 ;
factor	: variable
    {
      fprintf(log_,"factor : variable\n");
     $$=new SymbolInfo($1->get_name(),"NON-TERMINAL");
      $$->make_copy($1);
      $$->clear_children();
       $$->set_print("factor : variable");
    $$->add_child($1);
    $$->set_start($1->get_start());
    $$->set_end($1->get_end());     
      ///pass arrayname if array otherwise pass varname only
      ///suppose $1->get_name() is a[2].Now array_name returns only a
      string varname;
      varname = array_name($1->get_name());
      SymbolInfo *x=table.Lookup(varname);
			if(!x){
        error_count++;
        fprintf(error,"Line# %d: Undeclared variable '%s'\n",line_count,varname.c_str());
              }
      else{

          //setting type of var(int/float) and identity(array/normal variable)
  				$$->set_var_type(x->get_var_type());
          $$->set_id(x->get_id());
          //check if array
          for(int i=0;i<var_list.size();i++){
            if(var_list[i].name==x->get_name() && var_list[i].size>0){
              //now we're sure that it's an array
              //let's see if array is being used without any index
              if(varname==$1->get_name()){
                /*
                error_count++;
                fprintf(error,"Line# %d:Type mismatch, '%s' is an array\n",line_count,varname.c_str());
                $$->set_param_error_state(true);
                break;
                */
                
              }
              //now check if wrong index is given
              else if(!array_index_checker($1->get_name() , var_list[i].size)){
                error_count++;
                fprintf(error,"Line# %d: Wrong array index\n",line_count);
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
      $$->set_print("factor : ID LPAREN argument_list RPAREN");
    $$->add_child($1);
    $$->add_child($2);
    $$->add_child($3);
    $$->add_child($4);
    $$->set_start($1->get_start());
    $$->set_end($4->get_end());     
      $$->set_func_state(true);

      //semantic
      //check if id is in func_list
      if(!check_func($1->get_name())){
        error_count++;
        fprintf(error , "Line# %d: Undeclared function '%s'\n",line_count,$1->get_name().c_str());
              }
      else{
        func_ f = get_func($1->get_name());
        //check arguments consistency
        if(f.parametres.size() != $3->argument_list.size())
        {
          if(f.parametres.size() > $3->argument_list.size())
          {
          error_count++;
          fprintf(error , "Line# %d: Too few arguments to function '%s'\n",line_count,$1->get_name().c_str());
           }
          else
          {
          error_count++;
          fprintf(error , "Line# %d: Too many arguments to function '%s'\n",line_count,$1->get_name().c_str());
          }
        }
        else{
          for(int i=0;i<f.parametres.size();i++){
            if($3->argument_list[i].error_state){
              error_count++;
              fprintf(error , "Line# %d: Type mismatch for argument %d of '%s'\n",line_count,i+1,$1->get_name().c_str());
              continue;
            }
            //cout<<f.f_name<<" "<<$3->arg_list[i].name<<" "<<$3->arg_list[i].sz<<endl;
            
            if($3->argument_list[i].size>0){
              if($3->get_name()==array_name($3->get_name())){
                 error_count++;
              fprintf(error , "Line# %d: Type mismatch for argument %d of '%s'\n",line_count,i+1,$1->get_name().c_str());
              continue;

              }
            }
          
            if(f.parametres[i].first != $3->argument_list[i].type){
               error_count++;
              fprintf(error , "Line# %d: Type mismatch for argument %d of '%s'\n",line_count,i+1,$1->get_name().c_str());
              continue;
            }
          }
        }
        //cout<<$1->get_name()<<" "<<already_error_in_arg<<endl;
        
      }

    }
	| LPAREN expression RPAREN
    {
      $$ = new SymbolInfo("("+$2->get_name()+")" , "factor");
      fprintf(log_,"factor : LPAREN expression RPAREN\n");
      $$->set_print("factor : LPAREN expression RPAREN");
    $$->add_child($1);
    $$->add_child($2);
    $$->add_child($3);
    $$->set_start($1->get_start());
    $$->set_end($3->get_end()); 

      $$->set_var_type($2->get_var_type());

    }
	| CONST_INT
    {
      fprintf(log_,"factor : CONST_INT\n");
			$$=new SymbolInfo($1->get_name(),"TERMINAL");
      $$->make_copy($1);;
      $$->clear_children();
      $$->set_print("factor : CONST_INT");
    $$->add_child($1);
    $$->set_start($1->get_start());
    $$->set_end($1->get_end()); 
			$$->set_var_type("int");
      

    }
	| CONST_FLOAT
    {
      fprintf(log_,"factor : CONST_FLOAT\n");
			$$=new SymbolInfo($1->get_name(),"TERMINAL");
      $$->make_copy($1);;
      $$->clear_children();
      $$->set_print("factor : CONST_FLOAT");
    $$->add_child($1);
    $$->set_start($1->get_start());
    $$->set_end($1->get_end()); 
			$$->set_var_type("float");

    }
	| variable INCOP
    {
      fprintf(log_,"factor	: variable INCOP\n");
      $$ = new SymbolInfo($1->get_name()+"++","factor");
      $$->set_print("factor	: variable INCOP");
    $$->add_child($1);
    $$->add_child($2);
    $$->set_start($1->get_start());
    $$->set_end($2->get_end()); 

      SymbolInfo *x=table.Lookup(array_name($1->get_name()));
			if(!x){
        error_count++;
        fprintf(error,"Line# %d: Undeclared variable '%s'\n",line_count,$1->get_name().c_str());
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
       $$->set_print("factor	: variable DECOP");
    $$->add_child($1);
    $$->add_child($2);
    $$->set_start($1->get_start());
    $$->set_end($2->get_end()); 

      SymbolInfo *x=table.Lookup(array_name($1->get_name()));
			if(!x){
        error_count++;
        fprintf(error,"Line# %d: Undeclared variable '%s'\n",line_count,$1->get_name().c_str());      }
      else{

         $$->set_var_type($1->get_var_type());
         $$->set_id($1->get_id());
      }
    }

	;   
argument_list : arguments
        {
          fprintf(log_,"argument_list : arguments\n");
    			$$=new SymbolInfo($1->get_name(),"NON-TERMINAL");
      $$->make_copy($1);;
          $$->clear_children();
           $$->set_print("argument_list : arguments");
    $$->add_child($1);
    $$->set_start($1->get_start());
    $$->set_end($1->get_end()); 
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
            $$->set_print("arguments : arguments COMMA logic_expression");
    $$->add_child($1);
    $$->add_child($2);
    $$->add_child($3);
    $$->set_start($1->get_start());
    $$->set_end($3->get_end()); 

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
    			$$=new SymbolInfo($1->get_name(),"TERMINAL");
      $$->make_copy($1);;
          $$->clear_children();
          $$->set_print("arguments : logic_expression");
    $$->add_child($1);
    $$->set_start($1->get_start());
    $$->set_end($1->get_end());
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

	fclose(fp);
	fclose(log_);
	fclose(error);

	return 0;
}          










      
