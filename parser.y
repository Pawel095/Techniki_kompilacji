%{
    #define YYERROR_VERBOSE 1
    bool ENABLEDP=true;
    const char* ENTRYPOINT_NAME = "entrypoint";
%}

%code requires{
    #include "global.hpp"
    #include "debug/printer.hpp"
    #include "asmfor/asmfor.hpp"
}

%union{
    std::vector<int>* symtable_index_v;
    int symtable_index;
    RELOP cmp;
    STD_TYPES std_type;
    SIGN sign;
    MULOP mulop;
}

%token program_t
%token var_t
%token integer_t
%token real_t
%token array_t
%token begin_t
%token end_t
%token of_t
%token function_t
%token procedure_t
%token array_range_t

%token <symtable_index> ident_t
%token <symtable_index> num_t

%token while_t
%token do_t

%token if_t
%token else_t
%token then_t

%token write_t
%token read_t

%token assign_op_t
%token relop_t
%token <sign> sign_t
%token <mulop> mulop_t
%token or_t
%token not_t


%type <std_type> standard_type
%type <std_type> type
%type <symtable_index> factor
%type <symtable_index> term
%type <symtable_index> simple_expression
%type <symtable_index> expression
%type <symtable_index> variable
%type <symtable_index_v> identifier_list
%type <symtable_index_v> parameter_list
%type <symtable_index_v> arguments

%%

program:
    program_t ident_t '(' identifier_list ')' ';'
    {
        std::string msg = std::string("nazwa programu: ") + std::string(memory[$2].name_or_value);
        print_if_debug(msg,"program",ENABLEDP);
        outfile<<"jump.i #"<<ENTRYPOINT_NAME<<std::endl;
        delete $4;
    }
    declarations 
    {
        memory.set_scope(SCOPE::LOCAL);
        print_if_debug("Scope set to local","program->declarations",ENABLEDP);
    }
    subprogram_declarations
    {
        memory.set_scope(SCOPE::GLOBAL);
        print_if_debug("Scope set to global","program->subprogram_declarations",ENABLEDP);
        // TODO: kod z funkcji :: close.
        outfile<<ENTRYPOINT_NAME<<":"<<std::endl;
    }
    compound_statement '.'
    {
        outfile<<"exit"<<std::endl;
    }
;
identifier_list:
    ident_t
    {
        $$ = new std::vector<int>();
        $$->push_back($1);
        print_if_debug(memory[$1].name_or_value,"identifier_list[0]->ident_t",ENABLEDP);
    }
    | identifier_list ',' ident_t
    {
        $$->push_back($3);
        print_if_debug(memory[$3].name_or_value,"identifier_list[1]->ident_t",ENABLEDP);
    }
;
declarations:
    declarations var_t identifier_list ':' type ';'
    {
        for (auto index : *$3) 
        {
            auto entry = memory[index];
            int a=1;
            if (memory.get_scope()==SCOPE::GLOBAL)
                entry.type=ENTRY_TYPES::VAR;
            else
                entry.type = ENTRY_TYPES::LOCAL_VAR;
            entry.vartype=$5;
            memory.update_entry(index,entry);
            memory.allocate(index);
        }
        delete $3;
    }
    | %empty
;
type:
    standard_type
    {
        $$ = $1;
    }
    | array_t '[' num_t array_range_t num_t ']' of_t standard_type
    {
        // TODO: array type
    }
;
standard_type:
    integer_t {$$ = STD_TYPES::INTEGER;}
    | real_t {$$ = STD_TYPES::REAL;}
;
subprogram_declarations:
    subprogram_declarations subprogram_declaration ';'
    | %empty
;
subprogram_declaration:
    subprogram_head declarations compound_statement
    {
        std::cout<<memory.dump().c_str()<<std::endl;
        // TODO: drop temp variables
        // TODO: leave,return.
    }
;
subprogram_head:
    function_t ident_t arguments ':' standard_type ';'
    {
        std::cout<<"Func "<<memory[$2].name_or_value<<std::endl;
        delete $3;
    }
    | procedure_t ident_t arguments ';'
    {
        // TODO: add label here
        memory.reset_scope();
        print_if_debug("Scope reset","subprogram_head[1]",ENABLEDP);
        memory.initial_bp(false);
        auto func = memory[$2];
        func.type=ENTRY_TYPES::PROCEDURE;
        memory.update_entry($2,func);
        // add args to symtable
        for (auto id:*$3){
            auto arg = memory[id];
            arg.type = ENTRY_TYPES::ARGUMENT;
            memory.update_entry(id,arg);
            memory.allocate(id);
        }
        delete $3;
    }
;
arguments:
    '(' parameter_list ')'
    {
        $$ = $2;
    }
    | %empty
    {
        $$ = new std::vector<int>();
    }
;
parameter_list:
    identifier_list ':' type
    {
        print_if_debug(*$1,"parameter_list[0]->identifier_list",ENABLEDP);
        for (auto id:*$1) {
            auto entry = memory[id];
            entry.vartype = $3;
            memory.update_entry(id,entry);
        }
        $$ = $1;
    }
    | parameter_list ';' identifier_list ':' type
    {
        print_if_debug(*$3,"parameter_list[1]->identifier_list",ENABLEDP);
        for (auto index:*$3) {
            $$->push_back(index);
            auto entry = memory[index];
            entry.vartype = $5;
            memory.update_entry(index,entry);
        }
        delete $3;
    }
;
compound_statement: 
    begin_t
    optional_statements
    end_t
;
optional_statements: 
    statement_list
    | %empty
;
statement_list:
    statement
    | statement_list ';' statement
;
statement: 
    variable assign_op_t expression
    {
        print_if_debug(std::to_string($1),"statement[0]->variable",ENABLEDP);
        print_if_debug(std::to_string($3),"statement[0]->expression",ENABLEDP);
        auto var = memory[$1];
        auto expr = memory[$3];
        // TODO: Sprawdź czy funkcja i wykonaj. rezultat przypisz.
        if (var.vartype != expr.vartype) {
            auto converted = memory.add_temp_var(var.vartype);
            if(var.vartype == STD_TYPES::INTEGER){
                outfile<<asmfor_op2args(std::string("realtoint"), expr, converted);
            }
            if (var.vartype == STD_TYPES::REAL) {
                outfile<<asmfor_op2args(std::string("inttoreal"), expr, converted);
            }
            outfile<<asmfor_op2args(std::string("mov"), converted, memory[$1]);
        }else{
            outfile<<asmfor_op2args(std::string("mov"), memory[$3], memory[$1]);
        }
    }
    | procedure_statement
    | compound_statement
    | if_t expression then_t statement else_t statement
    | while_t expression do_t statement
    | write_t '(' identifier_list ')'
    {
        outfile<<asmfor_write(*$3);
        delete $3;
    }
;
variable:
    ident_t
    {
        print_if_debug(memory[$1].name_or_value,"variable[0]->ident_t",ENABLEDP);
        $$ = $1;
        print_if_debug(std::to_string($1),"variable[0]->ident_t->memindex",ENABLEDP);
    }
    | ident_t '[' expression ']' // TODO: array access
    {
    }
;
procedure_statement:
    ident_t
    | ident_t '(' expression_list ')'
;
expression_list:
    expression
    | expression_list ',' expression
;
expression:
    simple_expression
    | simple_expression relop_t simple_expression
;
simple_expression:
    term
    {
        $$ = $1;
    }
    | sign_t term
    {
        print_if_debug(std::string(enum2str($1)),"simple_expresson[1]->sign",ENABLEDP);
        $$ = $2;
        if ($1 == SIGN::MINUS){
            auto term = memory[$2];
            auto temp = memory.add_temp_var(term.vartype);
            auto zero = Entry();
            zero.type=ENTRY_TYPES::CONST;
            zero.name_or_value=std::string("0");
            zero.vartype=term.vartype;
            
            outfile<<asmfor_op3args(std::string("sub"), zero, term, temp);
            $$ = temp.mem_index;
        }
    }
    | simple_expression sign_t term
    {
        auto expr = memory[$1];
        auto term = memory[$3];
        // upgrade vars to real if needed
        if (expr.vartype != term.vartype) {
            auto upgraded = memory.add_temp_var(STD_TYPES::REAL);
            if (expr.vartype != STD_TYPES::REAL) {
                outfile<<asmfor_op2args(std::string("inttoreal"), expr, upgraded);
                expr = upgraded;
            }
            if (term.vartype != STD_TYPES::REAL) {
                outfile<<asmfor_op2args(std::string("inttoreal"), term, upgraded);
                term = upgraded;
            }
        }
        // all vars have the same type here.
        if ($2 == SIGN::PLUS) {
            auto tempvar = memory.add_temp_var(expr.vartype);
            outfile<<asmfor_op3args(std::string("add"), expr, term, tempvar);
            $$ = tempvar.mem_index;
        }

        if ($2 == SIGN::MINUS) {
            auto tempvar = memory.add_temp_var(expr.vartype);
            outfile<<asmfor_op3args(std::string("sub"), expr, term, tempvar);
            $$ = tempvar.mem_index;
        }
    }
    | simple_expression or_t term
;
term:
    factor
    {
        print_if_debug(std::to_string($1),"term->factor",ENABLEDP);
        $$=$1;
    }
    | term mulop_t factor
    {
        print_if_debug(std::to_string($1),"term[1]->term",ENABLEDP);
        print_if_debug(std::string("Mulop: ")+enum2str($2),"term[1]->mulop",ENABLEDP);
        print_if_debug(std::to_string($3),"term[1]->factor",ENABLEDP);
        
        auto term = memory[$1];
        auto factor = memory[$3];
        // upgrade vars to real if needed
        if (term.vartype != factor.vartype) {
            auto upgraded = memory.add_temp_var(STD_TYPES::REAL);
            if (term.vartype != STD_TYPES::REAL) {
                outfile<<asmfor_op2args(std::string("inttoreal"), term, upgraded);
                term = upgraded;
            }
            if (factor.vartype != STD_TYPES::REAL) {
                outfile<<asmfor_op2args(std::string("inttoreal"), factor, upgraded);
                factor = upgraded;
            }
        }
        // both real or both int.
        auto tempvar = memory.add_temp_var(term.vartype);
        if ($2 == MULOP::STAR) {
            outfile<<asmfor_op3args(std::string("mul"), term, factor, tempvar);
            $$ = tempvar.mem_index;
        }
        if ($2 == MULOP::SLASH or $2 == MULOP::DIV) {
            outfile<<asmfor_op3args(std::string("div"), term, factor, tempvar);
            $$ = tempvar.mem_index;
        }
        if ($2 == MULOP::MOD){
            outfile<<asmfor_op3args(std::string("mod"), term, factor, tempvar);
            $$ = tempvar.mem_index;
        }
    }
;
factor: // Send memory adress up, not the bloody value.
    variable
    {
        print_if_debug(std::to_string($1), "factor[0]->variable", ENABLEDP);
        $$ = $1;
    }
    | ident_t '(' expression_list ')' // Function call
    | num_t // a number
    {
        $$ = $1;
    }
    | '(' expression ')' // 'do this first'
    {
        $$ = $2;
    }
    | not_t factor
;
%%
