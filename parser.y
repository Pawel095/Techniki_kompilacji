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
    string* str;
    vector<string*>* str_v;
    int memaddr;
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

%token <str> ident_t
%token <str> num_t

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
%type <str_v> identifier_list
%type <std_type> type
%type <memaddr> factor
%type <memaddr> term
%type <memaddr> simple_expression
%type <memaddr> expression
%type <memaddr> variable

%%

program:
    program_t ident_t '(' identifier_list ')' ';'
    {
        string msg = string("nazwa programu: ") + string(*$2);
        print_if_debug(msg,"program",ENABLEDP);
        print_if_debug($4,"program",ENABLEDP);
        outfile<<"jump.i #"<<ENTRYPOINT_NAME<<endl;
    }
    declarations
    subprogram_declarations//TODO: rozszeżony
    {
        // TODO: kod z funkcji :: close.
        outfile<<ENTRYPOINT_NAME<<":"<<endl;
    }
    compound_statement '.'
    {
        outfile<<"exit"<<endl;
    }
;
identifier_list:
    ident_t
    {
        $$ = new vector<string* >();
        $$->push_back($1);
    }
    | identifier_list ',' ident_t
    {
        $$ = new vector<string* >();
        for (auto ident : *$1){
            $$->push_back(ident);
        }
        $$->push_back($3);
    }

;
declarations:
    declarations var_t identifier_list ':' type ';'
    {
        for (auto id : *$3){
            Entry* e = new Entry();
            e->name_or_value=*id;
            e->type = ENTRY_TYPES::VAR;
            e->vartype = $5;
            int i=memory.add_entry(e);
            memory.allocate(i);
        }
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
;
subprogram_head:
    function_t ident_t arguments ':' standard_type ';'
    | procedure_t ident_t arguments ';'
;
arguments:
    '(' parameter_list ')'
    | %empty
;
parameter_list:
    identifier_list ':' type
    | parameter_list ';' identifier_list ':' type
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
        print_if_debug(to_string($1),"statement[0]->variable",ENABLEDP);
        print_if_debug(to_string($3),"statement[0]->expression",ENABLEDP);
        auto var = memory[$1];
        auto expr = memory[$3];
        if (var->vartype != expr->vartype) {
            auto converted = memory.add_temp_var(var->vartype);
            if(var->vartype == STD_TYPES::INTEGER){
                outfile<<asmfor_op2args(string("realtoint"), expr, converted);
            }
            if (var->vartype == STD_TYPES::REAL) {
                outfile<<asmfor_op2args(string("inttoreal"), expr, converted);
            }
            outfile<<asmfor_op2args(string("mov"), converted, memory[$1]);
        }else{
            outfile<<asmfor_op2args(string("mov"), memory[$3], memory[$1]);
        }
    }
    | procedure_statement
    | compound_statement
    | if_t expression then_t statement else_t statement
    | while_t expression do_t statement
    | write_t '(' identifier_list ')'
    {
        outfile<<asmfor_write(*$3);
    }
;
variable:
    ident_t
    {
        print_if_debug(*$1,"variable[0]->ident_t",ENABLEDP);
        $$ = memory.get(*$1)->mem_index;
    }
    | ident_t '[' expression ']' // TODO: array access
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
        print_if_debug(string(enum2str($1)),"simple_expresson[1]->sign",ENABLEDP);
        $$ = $2;
        if ($1 == SIGN::MINUS){
            auto term = memory[$2];
            auto temp = memory.add_temp_var(term->vartype);
            auto zero = Entry();
            zero.type=ENTRY_TYPES::CONST;
            zero.name_or_value=string("0");
            zero.vartype=term->vartype;
            
            outfile<<asmfor_op3args(string("sub"), &zero, term, temp);
            $$ = temp->mem_index;
        }
    }
    | simple_expression sign_t term
    {
        auto expr = memory[$1];
        auto term = memory[$3];
        // upgrade vars to real if needed
        if (expr->vartype != term->vartype) {
            auto upgraded = memory.add_temp_var(STD_TYPES::REAL);
            if (expr->vartype != STD_TYPES::REAL) {
                outfile<<asmfor_op2args(string("inttoreal"), expr, upgraded);
                expr = upgraded;
            }
            if (term->vartype != STD_TYPES::REAL) {
                outfile<<asmfor_op2args(string("inttoreal"), term, upgraded);
                term = upgraded;
            }
        }
        // all vars have the same type here.
        if ($2 == SIGN::PLUS) {
            auto tempvar = memory.add_temp_var(expr->vartype);
            outfile<<asmfor_op3args(string("add"), expr, term, tempvar);
            $$ = tempvar->mem_index;
        }

        if ($2 == SIGN::MINUS) {
            auto tempvar = memory.add_temp_var(expr->vartype);
            outfile<<asmfor_op3args(string("sub"), expr, term, tempvar);
            $$ = tempvar->mem_index;
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
        print_if_debug(to_string($1),"term[1]->term",ENABLEDP);
        print_if_debug(string("Mulop: ")+enum2str($2),"term[1]->mulop",ENABLEDP);
        print_if_debug(to_string($3),"term[1]->factor",ENABLEDP);
        
        auto term = memory[$1];
        auto factor = memory[$3];
        // upgrade vars to real if needed
        if (term->vartype != factor->vartype) {
            auto upgraded = memory.add_temp_var(STD_TYPES::REAL);
            if (term->vartype != STD_TYPES::REAL) {
                outfile<<asmfor_op2args(string("inttoreal"), term, upgraded);
                term = upgraded;
            }
            if (factor->vartype != STD_TYPES::REAL) {
                outfile<<asmfor_op2args(string("inttoreal"), factor, upgraded);
                factor = upgraded;
            }
        }
        // both real or both int.
        auto tempvar = memory.add_temp_var(term->vartype);
        if ($2 == MULOP::STAR) {
            outfile<<asmfor_op3args(string("mul"), term, factor, tempvar);
            $$ = tempvar->mem_index;
        }
        if ($2 == MULOP::SLASH or $2 == MULOP::DIV) {
            outfile<<asmfor_op3args(string("div"), term, factor, tempvar);
            $$ = tempvar->mem_index;
        }
        if ($2 == MULOP::MOD){
            outfile<<asmfor_op3args(string("mod"), term, factor, tempvar);
            $$ = tempvar->mem_index;
        }
    }
;
factor: // Send memory adress up, not the bloody value.
    variable
    {
        print_if_debug(to_string($1), "factor[0]->variable", ENABLEDP);
        $$ = $1;
    }
    | ident_t '(' expression_list ')' // Function call
    | num_t // a number
    {
        // Constant! RETURN INDEX IN SYMTABLE このバカの学生！.
        Entry* e = new Entry();
        e->name_or_value=*$1;
        e->type = ENTRY_TYPES::CONST;
        e->vartype = isInteger($1) ? STD_TYPES::INTEGER : STD_TYPES::REAL;
        int i=memory.add_entry(e);
        $$ = i;
    }
    | '(' expression ')' // 'do this first'
    {
        $$ = $2;
    }
    | not_t factor
;
%%
