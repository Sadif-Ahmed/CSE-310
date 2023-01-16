//#include<iostream>
#include<bits/stdc++.h>
//#include<fstream>
//#include<string>
using namespace std;
struct func_param
{
    string name;
    string type;
};
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
    bool param_error_state;
    bool func_decl_state;
    bool func_state;
    SymbolInfo *next;
    public:
    vector<func_param> param_list;
    vector<var> var_list;
    vector<argument> argument_list;
    SymbolInfo(string name,string type)
    {
        this->name=name;
        this->type=type;
        set_ret_type("");
        set_var_type("");
        set_id("");
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
    ~SymbolInfo()
    {

    }

};
class ScopeTable{
    long long num_of_buckets;
    int unique_id;
    long long *bucketsizes;
    SymbolInfo **scope_table;
    ScopeTable *parent_scope;
    int pr;
    public:
    ScopeTable(long long num_of_buckets)
    {
        this->num_of_buckets=num_of_buckets;
        parent_scope=NULL;
        scope_table= new SymbolInfo*[num_of_buckets];
        bucketsizes=new long long[num_of_buckets];
        for(int i=0;i<num_of_buckets;i++)
        {
            scope_table[i]= NULL;
            bucketsizes[i]=0;
        }
        pr=true;

    }
    ScopeTable(long long num_of_buckets,long long id,ScopeTable* parent)
    {
        this->num_of_buckets=num_of_buckets;
        parent_scope=parent;
        unique_id=id;
        scope_table= new SymbolInfo*[num_of_buckets];
        bucketsizes=new long long[num_of_buckets];
        for(int i=0;i<num_of_buckets;i++)
        {
            scope_table[i]= NULL;
            bucketsizes[i]=0;
        }
        pr=true;

    }
    long long get_num_of_buckets()
    {
        return num_of_buckets;
    }
    long long get_unique_id()
    {
        return unique_id;
    }
    void set_num_of_buckets(long long num)
    {
        num_of_buckets=num;
    }
    void set_unique_id(long long id)
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
    long long hash_function(string str)
    {
        long long hash=0;
        for(long long i=0;i<str.length();i++)
        {
            hash = (str[i]) + (hash << 6) + (hash << 16) - hash;
           // hash=hash%num_of_buckets;
        }
        return hash;
    }
    long long index_gen(string str)
    {
        long long hash_value=hash_function(str);
        return hash_value%num_of_buckets;
    }
    SymbolInfo* Lookup(string searchtext)
    {
        long long hash=index_gen(searchtext);
        long long position=0;
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
            long long hash=index_gen(nm);
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
                fprintf(logfile,"<%s, %s> " , temp->get_name().c_str(),temp->get_type().c_str());
                temp=temp->get_next();
            }
          //  cout<<endl;
           fprintf(logfile,"\n");
          }
        }
        fprintf(logfile,"\n");
        
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
        long long position=0;
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
        long long max_bucket_size;
        long long current_id_gen;
        public:
        SymbolTable(long long bucket_size)
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
        long long get_max_bucket_size()
        {
            return max_bucket_size;
        }
        void set_max_bucket_size(long long n)
        {
            max_bucket_size=n;
        }
        long long get_current_id()
        {
            return current_id_gen;
        }
        void set_current_id_gen(long long n)
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
        void Enter_Scope(long long bucket_size)
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
                //temp->toggle_print();
                if(temp->Lookup(name))
                {
                   // temp->toggle_print();
                    return temp->Lookup(name);
                }
                else
                {
                    return NULL;
                }
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
 