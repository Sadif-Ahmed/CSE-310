#include<iostream>
#include<fstream>
#include<string>
#include<vector>
#include<bits/stdc++.h>
using namespace std;
//mainly for function parameters when $$ holds a function.Details in  parameter_list in parser.y
struct func_param
{
    string name; //set to empty string "" for function declaration
    string type;
};
//when $$ is a declaration_list,vector<var>var holds the variables
struct var
{
    string name;
    string type;
    int size;
};
struct argument
{
    string name;
    string type;
    ///to check if its array.if size>0 its array
    int size; 
    bool error_state;
};

class SymbolInfo
{
    string name;
    string type;
    string ret_type;
    string var_type;
    string id;
    bool param_error_state;//only if $$ is parameter_list.It is set if parameter_list has some error .
    bool func_decl_state;// to keep track of declared function and verify if they are defined later
    bool func_state;//to check (at time of function calling) if $$ is really a function(see 2nd rule of factor)
    bool arr_state;//to check  if $$ is really an array
    //ICG Components
    string code;
    string assembly_value;
    int stack_offset;
    bool global_flag;
    
    SymbolInfo *next;
    public:
    //List of Parametres,Variable and Arguments
    vector<func_param> param_list;
    vector<var> var_list;
    vector<argument> argument_list;
    //Parse Tree Building Block
    vector<SymbolInfo*> children;
    int start_line;
    int end_line;
    bool leafstate=false;
    string println;

    

    voi set_assembly_value(string temp)
    {
        assembly_value=temp;
    }
    string get_assembly_value()
    {
        return assembly_value;
    }
    void set_code(string temp)
    {
        code=temp;
    }
    string get_code()
    {
        return code;
    }
    void add_code(string temp)
    {
        code += temp;
    }
    void set_stack_offset(int n)
    {
        stack_offset=n;
    }
    int get_stack_offset()
    {
        return stack_offset;
    }
    void set_global_flag(bool flag)
    {
        global_flag=flag;
    }
    bool get_global_flag()
    {
        return global_flag;
    }

    void add_child(SymbolInfo *temp)
    {
        children.push_back(temp);
    }
    void set_start(int n)
    {
        start_line=n;
    }
    int get_start()
    {
        return start_line;
    }
    void set_end(int n)
    {
        end_line=n;
    }
    int get_end()
    {
        return end_line;
    }
    void set_print(string temp)
    {
        println=temp;
    }
    string get_print()
    {
        return println;
    }
    void set_leaf_state(bool temp)
    {
        leafstate=temp;
    }
    bool get_leaf_state()
    {
        return leafstate;
    }
    vector<SymbolInfo*> get_children()
    {
        return children;
    }
    void clear_children()
    {
        children.clear();
    }
    void make_copy(SymbolInfo *temp)
    {
    this->name=temp->get_name();
    this->type=temp->get_type();
    this->ret_type=temp->get_ret_type();
    this->var_type=temp->get_var_type();
    this->id=temp->get_id();
    this->param_error_state=temp->get_param_error_state();
    this->func_decl_state=temp->get_func_decl_state();
    this->func_state=temp->get_func_state();
    this->arr_state=temp->get_arr_state();
    this->next=temp->get_next();
    this->param_list=temp->get_param_list();
    this->var_list=temp->get_var_list();
    this->argument_list=temp->get_argument_list();
    }
    void print_tree(SymbolInfo *head,int depth,FILE *fp)
    {
        for(int i=0;i<depth;i++)
        {
            fprintf(fp," ");
        }
        if(head->get_leaf_state())
        {
            fprintf(fp,"%s",head->get_print().c_str());
            fprintf(fp,"\t<Line: %d>\n",head->get_start());
        }
        else
        {
            fprintf(fp,"%s",head->get_print().c_str());
            fprintf(fp," \t<Line: %d-%d>\n",head->get_start(),head->get_end());
        }
        vector<SymbolInfo*> temp = head->get_children();
        for(int i=0;i<temp.size();i++)
        {
            print_tree(temp[i],depth+1,fp);
        }
    }
    void delete_tree(SymbolInfo *head)
    {
        vector<SymbolInfo*> temp = head->get_children();
        for(int i=0;i<temp.size();i++)
        {
            delete_tree(temp[i]);
        }
        delete head;
    }
    string to_up(string temp)
{
    string ret=temp;
    for(int i=0;i<temp.size();i++)
    {
        if(temp[i]>='a')
        {
            ret[i]=ret[i]-32;
        }
        else
        {
            ret[i]=ret[i];
        }
    }
    
    return ret;
}

    SymbolInfo(string name,string type)
    {
        this->name=name;
        this->type=type;
        set_ret_type("");
        set_var_type("");
        set_id("");
        code="";
        global_flag=false;
        set_func_decl_state(false);
        next=NULL;
    }
    SymbolInfo(string type)
    {
        this->name="";
        this->type=type;
        set_ret_type("");
        set_var_type("");
        set_id("");
        set_func_decl_state(false);
        code="";
        global_flag=false;
        next=NULL;

    }
    SymbolInfo()
    {
        this->name="";
        this->type="";
        set_ret_type("");
        set_var_type("");
        set_id("");
        set_func_decl_state(false);
        code="";
        global_flag=false;
        next=NULL;
    }
    string get_name()
    {
        return name;
    }
    string get_type()
    {
        return type;
    }
    SymbolInfo* get_next()
    {
        return next;
    }
    void set_name(string name)
    {
        this->name=name;
    }
    void set_type(string type)
    {
        this->type=type;
    }
    void set_next(SymbolInfo *temp)
    {
        this->next=temp;
    }
    void print()
    {
        cout<<'\t'<<" < "<<name<<" , "<<type<<" > "<<endl;
    }
    void set_ret_type(string temp)
    {
        ret_type=temp;
    }
    string get_ret_type()
    {
        return ret_type;
    }   
    void set_var_type(string temp)
    {
        var_type=temp;
    }
    string get_var_type()
    {
        return var_type;
    }
    void set_id(string temp)
    {
        id=temp;
    }
    string get_id()
    {
        return id;
    }
    void set_param_error_state(bool temp)
    {
        param_error_state=temp;
    }
    bool get_param_error_state()
    {
        return param_error_state;
    }
    void set_func_decl_state(bool temp)
    {
        func_decl_state=temp;
    }
    bool get_func_decl_state()
    {
        return func_decl_state;
    }
    void set_func_state(bool temp)
    {
        func_state=temp;
    }
    bool get_func_state()
    {
        return func_state;
    }
    void set_arr_state(bool temp)
    {
        arr_state=true;
    }
    bool get_arr_state()
    {
        return arr_state;
    }
    void push_param(string name,string type)
    {
        func_param temp;
        temp.name=name;
        temp.type=type;
        param_list.push_back(temp);
    }
    void pop_param()
    {
        param_list.pop_back();
    }
    void push_var(string name,string type,int size)
    {
        var temp;
        temp.name=name;
        temp.type=type;
        temp.size=size;
        var_list.push_back(temp);
    }
    void pop_var()
    {
        var_list.pop_back();
    }
    void push_argument(string name,string type,int size,bool state)
    {
        argument temp;
        temp.name=name;
        temp.type=type;
        temp.size=size;
        temp.error_state=state;
        argument_list.push_back(temp);
    }
    vector<func_param> get_param_list()
    {
        return param_list;
    };
    vector<var> get_var_list()
    {
        return var_list;
    };
    vector<argument> get_argument_list()
    {
        return argument_list;
    };
    ~SymbolInfo()
    {

    }

};
class ScopeTable{
    unsigned long long num_of_buckets;
    int unique_id;
    unsigned long long *bucketsizes;
    SymbolInfo **scope_table;
    ScopeTable *parent_scope;
    int pr;
    public:
    ScopeTable(unsigned long long num_of_buckets)
    {
        this->num_of_buckets=num_of_buckets;
        parent_scope=NULL;
        scope_table= new SymbolInfo*[num_of_buckets];
        bucketsizes=new unsigned long long[num_of_buckets];
        for(int i=0;i<num_of_buckets;i++)
        {
            scope_table[i]= NULL;
            bucketsizes[i]=0;
        }
        pr=true;

    }
    ScopeTable(unsigned long long num_of_buckets,unsigned long long id,ScopeTable* parent)
    {
        this->num_of_buckets=num_of_buckets;
        parent_scope=parent;
        unique_id=id;
        scope_table= new SymbolInfo*[num_of_buckets];
        bucketsizes=new unsigned long long[num_of_buckets];
        for(int i=0;i<num_of_buckets;i++)
        {
            scope_table[i]= NULL;
            bucketsizes[i]=0;
        }
        pr=true;

    }
    unsigned long long get_num_of_buckets()
    {
        return num_of_buckets;
    }
    unsigned long long get_unique_id()
    {
        return unique_id;
    }
    void set_num_of_buckets(unsigned long long num)
    {
        num_of_buckets=num;
    }
    void set_unique_id(unsigned long long id)
    {
        unique_id=id;
    }
    SymbolInfo ** get_scopetable()
    {
        return scope_table;
    }
    ScopeTable * get_parentscope()
    {
        return parent_scope;
    }
    void set_scopetable(SymbolInfo ** temp)
    {
        this->scope_table=temp;
    }
    void set_parentscope(ScopeTable *temp)
    {
        this->parent_scope=temp;
    }
    void toggle_print()
    {
        if(pr==true)
        {
            pr=false;
        }
        else
        {
            pr=true;
        }

    }
     unsigned long long hash_function(string str)
    {
        unsigned long long hash=0;
        for(unsigned long long i=0;i<str.length();i++)
        {
            hash = (str[i]) + (hash << 6) + (hash << 16) - hash;
           // hash=hash%num_of_buckets;r
        }
        return hash;
    }
    unsigned long long index_gen(string str)
    {
        unsigned long long hash_value=hash_function(str);
        return hash_value%num_of_buckets;
    }
    SymbolInfo* Lookup(string searchtext)
    {
        unsigned long long hash=index_gen(searchtext);
        unsigned long long position=0;
        SymbolInfo *temp= scope_table[hash];
        while(temp!=NULL)
        {
            if(temp->get_name()==searchtext)
            {   
                if(pr)
                {
                  //  cout<<'\t'<<"'"<<searchtext<<"'"<<" found in ScopeTable# "<<unique_id<<" at position "<<hash+1<<", "<<position+1<<endl;
                }
                 return temp;
            }
           temp=temp->get_next();
           position++;

        }
        return NULL;
    }
    bool Insert(string nm,string tp,FILE* logfile)
    {   toggle_print();
        SymbolInfo *temp= Lookup(nm);
        toggle_print();
        if(temp!=NULL)
        {
        //     cout<<'\t'<<"'"<<nm<<"' "<<"already exists in the current ScopeTable"<<endl;
       //fprintf(logfile,"\t%s already exisits in the current ScopeTable\n", nm.c_str());
            return false;
        }
        else
        {
            unsigned long long hash=index_gen(nm);
            SymbolInfo *newsymbol = new SymbolInfo(nm,tp);
            if(scope_table[hash]==NULL)
            {
                scope_table[hash]=newsymbol;
                bucketsizes[hash]=1;
             //   cout<<'\t'<<"Inserted in ScopeTable# "<<unique_id<<" at position "<<hash+1<<", "<<bucketsizes[hash]<<endl;
                return true;
            }
            else
            {
                SymbolInfo *temp= scope_table[hash];
                ++bucketsizes[hash];
                while(temp->get_next()!=NULL)
                {
                    temp=temp->get_next();
                }
                temp->set_next(newsymbol);
               // cout<<'\t'<<"Inserted in ScopeTable# "<<unique_id<<" at position "<<hash+1<<", "<<bucketsizes[hash]<<endl;
                return true;
            }
        }
    }
    void print(FILE* logfile)
    {   //cout<<'\t'<<"ScopeTable# "<<unique_id<<endl;
        fprintf(logfile,"\tScopeTable# %d\n",unique_id);
        for(int i=0;i<num_of_buckets;i++)
        {
          //  cout<<'\t'<<i+1<<"--> ";
          if(bucketsizes[i]!=0)
          {
            fprintf(logfile,"\t%d--> ",i+1);
            SymbolInfo *temp=scope_table[i];
            while(temp!=NULL)
            {
                //cout<<"<"<<temp->get_name()<<","<<temp->get_type()<<"> ";
                if(temp->get_func_state()||temp->get_func_decl_state())
                {
                    fprintf(logfile,"<%s, %s, %s> " , temp->get_name().c_str(),"FUNCTION",temp->to_up(temp->get_ret_type()).c_str());
                    temp=temp->get_next();
                }
                else if(temp->get_arr_state())
                {
                    fprintf(logfile,"<%s, %s, %s> " , temp->get_name().c_str(),"ARRAY",temp->to_up(temp->get_var_type()).c_str());
                    temp=temp->get_next();
                }
                else
                {
                fprintf(logfile,"<%s, %s> " , temp->get_name().c_str(),temp->to_up(temp->get_var_type()).c_str());
                
                temp=temp->get_next();
                }
            }
          //  cout<<endl;
           fprintf(logfile,"\n");
          }
        }
       
        
    }
    bool Delete(string nm)
    { toggle_print();
        if(!Lookup(nm))
        { 
         //   cout<<'\t'<<"Not found in the current ScopeTable"<<endl;
            return false;
        }
        toggle_print();

        int hash=index_gen(nm);
        SymbolInfo *target = scope_table[hash];
        if(target->get_name()==nm)
        {
            scope_table[hash]=target->get_next();
            --bucketsizes[hash];
           // cout<<'\t'<<"Deleted "<<"'"<<nm<<"' from ScopeTable# "<<unique_id<<" at position "<<hash+1<<", 1"<<endl;
            return true;
        }

        SymbolInfo *prev;
        unsigned long long position=0;
        while(target!=NULL)
        {
            if(target->get_name()==nm)
            {
                prev->set_next(target->get_next());
            //    cout<<'\t'<<"Deleted "<<"'"<<nm<<"' from ScopeTable# "<<unique_id<<" at position "<<hash+1<<", "<<position+1<<endl;
                break;
            }
            prev=target;
            target= target->get_next();
            position++;
        }
        --bucketsizes[hash];
        return true;
    }

    ~ScopeTable()
    {
        for(int i=0;i<num_of_buckets;i++)
        {
            delete (scope_table[i]);
        }
       // cout<<'\t'<<"ScopeTable# "<<unique_id<<" removed"<<endl;
    }
    };
    class SymbolTable
    {
        ScopeTable *current;
        ScopeTable *head;
        unsigned long long max_bucket_size;
        unsigned long long current_id_gen;
        public:
        SymbolTable(unsigned long long bucket_size)
        {
            max_bucket_size=bucket_size;
            current_id_gen=1;
            head=NULL;
            current=NULL;
            Enter_Scope(bucket_size);
        }
        ScopeTable* get_current()
        {
            return current;
        }
        ScopeTable* get_head()
        {
            return head;
        }
        void set_current(ScopeTable *temp)
        {
            current=temp;
        }
        void set_head(ScopeTable *temp)
        {
            head=temp;
        }
        unsigned long long get_max_bucket_size()
        {
            return max_bucket_size;
        }
        void set_max_bucket_size(unsigned long long n)
        {
            max_bucket_size=n;
        }
        unsigned long long get_current_id()
        {
            return current_id_gen;
        }
        void set_current_id_gen(unsigned long long n)
        {
            current_id_gen=n;
        }
        void Enter_Scope()
        { 
            ScopeTable *newtable;
            if(head!=NULL)
            {
                newtable = new ScopeTable(max_bucket_size,current_id_gen,current);
         //   cout<<'\t'<<"ScopeTable# "<<current_id_gen<<" created"<<endl;
            }
            else
            {
                newtable = new ScopeTable(max_bucket_size,current_id_gen,current);
           //     cout<<'\t'<<"ScopeTable# "<<current_id_gen<<" created"<<endl;
                head=newtable;
            }
            current_id_gen++;
            current=newtable;

        }
        void Enter_Scope(unsigned long long bucket_size)
        {
            ScopeTable *newtable;
            if(head!=NULL)
            {
                newtable = new ScopeTable(bucket_size,current_id_gen,current);
            //cout<<'\t'<<"ScopeTable# "<<current_id_gen<<" created"<<endl;
            }
            else
            {
                newtable = new ScopeTable(bucket_size,current_id_gen,NULL);
                head=newtable;
            //    cout<<'\t'<<"ScopeTable# "<<current_id_gen<<" created"<<endl;
            }
            current_id_gen++;
            current=newtable;
        }
        void Exit_Scope()
        {
            if(current!=head)
            {
            //    cout<<'\t'<<"ScopeTable# "<<current->get_unique_id()<<" removed"<<endl;
                current=current->get_parentscope();
            }
            else
            {
       //        cout<<'\t'<<"ScopeTable# "<<current->get_unique_id()<<" cannot be removed"<<endl;
            }
        }
        bool Insert(string name,string type,FILE* logfile)
        {
            return current->Insert(name,type,logfile);
        }
        bool Remove(string name)
        {
            return current->Delete(name);
        }
        SymbolInfo* Lookup(string name)
        {
            ScopeTable *temp=current;
            while (temp)
            {
                temp->toggle_print();
                if(temp->Lookup(name))
                {
                    temp->toggle_print();
                    return temp->Lookup(name);
                }
                else{
                    if(temp==head)
                    {
              //          cout<<'\t'<<"'"<<name<<"' "<<"not found in any of the ScopeTables"<<endl;
                    }
                    temp->toggle_print();
                    temp=temp->get_parentscope();
                }
            }
           return NULL;
            
        }
        SymbolInfo* Lookup_current_scope(string name)
        {
                ScopeTable *temp=current;
                temp->toggle_print();
                if(temp->Lookup(name))
                {
                    temp->toggle_print();
                    return temp->Lookup(name);
                }
                    return NULL;
        }
        void print_current_scope(FILE* logfile)
        {
            current->print(logfile);
        }
        void printall(FILE* logfile)
        {
            ScopeTable *temp=current;
            while(temp)
            {
                temp->print(logfile);
                temp=temp->get_parentscope();
            }
        }
        int get_current_scopeid()
        {
            return current->get_unique_id();
        }
        ~SymbolTable()
        {
           ScopeTable *temp=current;
            while (temp)
            {
               ScopeTable *x=temp->get_parentscope();
               delete temp;
               temp=x;
            }
            delete temp;
        }
         };
 