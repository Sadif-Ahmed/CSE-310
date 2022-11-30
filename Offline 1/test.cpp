#include<iostream>
#include<bits/stdc++.h>
using namespace std;

class SymbolInfo
{
    string name;
    string type;
    SymbolInfo *next;
    public:
    SymbolInfo(string name,string type)
    {
        this->name=name;
        this->type=type;
        next=NULL;
    }
    SymbolInfo()
    {
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
        cout<<" < "<<name<<" , "<<type<<" > "<<endl;
    }
    ~SymbolInfo()
    {

    }

};
class ScopeTable{
    long long num_of_buckets;
    long long unique_id;
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
                    cout<<"Found at Scopetable  "<<unique_id<<" at index "<<hash+1<<" at position "<<position+1<<endl;
                }
                 return temp;
            }
           temp=temp->get_next();
           position++;

        }
        if(pr)
        {
            cout<<searchtext<<" Not Found in ScopeTable "<<unique_id<<endl;
        }
        return NULL;
    }
    bool Insert(string nm,string tp)
    {   toggle_print();
        SymbolInfo *temp= Lookup(nm);
        toggle_print();
        if(temp!=NULL)
        {
             cout<<"<"<<nm<<","<<temp->get_type()<<">"<<" already exists in current ScopeTable"<<endl;
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
                cout<<"Inserted in ScopeTable# "<<unique_id<<" at position "<<hash+1<<", 1"<<endl;
                return true;
            }
            else
            {
                int position=0;
                SymbolInfo *temp= scope_table[hash];
                ++bucketsizes[hash];
                while(temp->get_next()!=NULL)
                {
                    temp=temp->get_next();
                    position++;
                }
                temp->set_next(newsymbol);
                cout<<"Inserted in ScopeTable# "<<unique_id<<" at position "<<hash+1<<", "<<position+1<<endl;
                return true;
            }
        }
    }
    void print()
    {   cout<<"ScopeTable # "<<unique_id<<endl;
        for(int i=0;i<num_of_buckets;i++)
        {
            cout<<i+1<<"--> ";
            SymbolInfo *temp=scope_table[i];
            while(temp!=NULL)
            {
                cout<<"< "<<temp->get_name()<<" : "<<temp->get_type()<<" > ";
                temp=temp->get_next();
            }
            cout<<endl;
        }
        cout<<endl;
    }
    bool Delete(string nm)
    { toggle_print();
        if(!Lookup(nm))
        {
            return false;
        }
        toggle_print();

        int hash=index_gen(nm);
        SymbolInfo *target = scope_table[hash];
        if(target->get_name()==nm)
        {
            scope_table[hash]=target->get_next();
            --bucketsizes[hash];
            cout<<"Deleted Entry "<<hash+1<<", 1 from current ScopeTable"<<endl;
            return true;
        }

        SymbolInfo *prev;
        long long position=0;
        while(target!=NULL)
        {
            if(target->get_name()==nm)
            {
                prev->set_next(target->get_next());
                cout<<"Deleted entry at "<<hash<<", "<<position+1<<" from current ScopeTable"<<endl;
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
        cout<<"Scopetable with id  "<<unique_id<<"  deleted  "<<endl;
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
            cout<<"New ScopeTable with id "<<current_id_gen<<" created"<<endl;
            }
            else
            {
                newtable = new ScopeTable(max_bucket_size,current_id_gen,current);
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
            }
            else
            {
                newtable = new ScopeTable(bucket_size,current_id_gen,NULL);
                head=newtable;
            }
            current_id_gen++;
            current=newtable;
        }
        void Exit_Scope()
        {
            if(current!=head)
            {
                cout<<"ScopeTable with id "<<current->get_unique_id()<<" removed"<<endl;
                current=current->get_parentscope();
            }
            else
            {
               cout<<"You can not delete the base scope"<<endl;
            }
        }
        bool Insert(string name,string type)
        {
            return current->Insert(name,type);
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
                    temp=temp->get_parentscope();
                }
            }
           return NULL;
            
        }
        void print_current_scope()
        {
            current->print();
        }
        void printall()
        {
            ScopeTable *temp=current;
            while(temp)
            {
                temp->print();
                temp=temp->get_parentscope();
            }
        }
        void clear_recursively(ScopeTable *temp)
        {
            if(temp==NULL)
            {
                return;
            }
            clear_recursively(temp->get_parentscope());
            delete temp;
        }
        ~SymbolTable()
        {
            clear_recursively(current);
        }
         }
    ;
int main()
{
    /*
    SymbolTable S(7);
    S.Insert("i","Variable");
    S.Insert("foo","function");
    S.Enter_Scope();
    S.Insert("damn","variable");
    S.Insert("fucck","function");
    S.printall();
    S.Lookup("damn");
    S.Lookup("i");
    S.Exit_Scope();
    S.Exit_Scope();
    return 0;
    */
}