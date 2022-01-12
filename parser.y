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
%token mulop_t
%token or_t
%token not_t


%type <std_type> standard_type
%type <str_v> identifier_list
%type <std_type> type
%type <memaddr> factor
%type <memaddr> term
%type <memaddr> simple_expression
%type <memaddr> expression
%type <str> variable

%%

program:
    program_t ident_t '(' identifier_list ')' ';'
    {
        string msg = string("nazwa programu: ") + string(*$2);
        print_if_debug(msg,"program",ENABLEDP);

        print_if_debug($4,"program",ENABLEDP);
        outfile<<"jump.i #"<<ENTRYPOINT_NAME<<endl;
    }
    declarations {
        // Global variables, do nothing here, vars are updated in `declarations`

    }
    subprogram_declarations//TODO: rozszeżony
    {
        // TODO: kod z funkcji :: close.

        outfile<<ENTRYPOINT_NAME<<":"<<endl;
    }
    compound_statement

    '.'
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
        print_if_debug(*$1,"statement[0]->variable",ENABLEDP);
        print_if_debug(to_string($3),"statement[0]->expression",ENABLEDP);
        auto src = memory.get($3);
        auto dest = memory.get(*$1);
        outfile<<asmfor_movassign(src,dest);
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
    | ident_t '[' expression ']' // TODO: later.
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
    | sign_t term
    | simple_expression sign_t term
    {
        if ($2 == SIGN::PLUS){
            Entry* result = memory.add_temp_var(STD_TYPES::INTEGER);
            Entry *e1 = memory.get($1);
            Entry *e2 = memory.get($3);
            print_if_debug("Addition!","simple_expresson[2]",ENABLEDP);
            outfile<<asmfor_add2memaddr(e1,e2,result);
            $$=result->address;
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
;
factor: // Send memory adress up, not the bloody value.
    variable
    | ident_t '(' expression_list ')' // Function call
    | num_t // a number
    {
        // Constant! Write the assembler to mov into memory! RETURN ADDRESS このバカの学生！.
        Entry* e = new Entry();
        e->name_or_value=*$1;
        e->type = ENTRY_TYPES::CONST;
        int i=memory.add_entry(e);
        memory.allocate(i);
        outfile<<asmfor_movconst(e);
        $$ = e->address;
    }
    | '(' expression ')' // 'do this first'
    | not_t factor
;
%%
